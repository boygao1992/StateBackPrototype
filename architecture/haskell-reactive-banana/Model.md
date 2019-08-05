# Model (Semantic)

## Types

type Time = Int -- >= 0
newtype Moment a = M (Time -> a)

newtype Behavior a = B (Moment a)
  deriving newtype (Functor, Apply, Applicative, Bind, Monad, MonadFix)
newtype BehaviorSample a = BS [a] -- sampling of a Behavior function from Time = 0

newtype Event a = E (Moment (Maybe a)) -- NOTE Event is a special type of Behavior
  deriving newtype (Functor, Apply, Applicative, Bind, Monad, MonadFix)
newtype EventSample a = ES [Maybe a] -- sampling of an Event function from Time = 0

sampleEventHead :: forall a. Time -> Event a -> EventSample a
sampleEventHead t = ES . take t . toEventSample

toEventSample :: forall a. Event a -> EventSample a
toEventSample (E (M tma)) = tma <$> [0..]

fromEventSample :: forall a. EventSample a -> Event a
fromEventSample (ES mas) = E $ M $ \t -> (mas ++ repeat Nothing) !! t

eventSampleToBehaviorSample :: forall a. a -> EventSample a -> BehaviorSample a
eventSampleToBehaviorSample init (ES mas) = BS $ go init mas
  where
    go :: a -> [Maybe a] -> [a]
    go past (ma:rest) =
      let current = case ma of
            Just a -> a
            Nothing -> past
      in current : eventSampleToBehaviorSample current rest
    go _ [] = []

interpret
  :: forall a b
  . (Event a -> Event b)
  -> EventSample a
  -> EventSample b
interpret f (ES sampleA)
  = ES
  . sampleEventHead (length sampleA)
  . f
  . fromEventSample

## Instances

instance Functor Moment where
  fmap :: forall a b. a -> b -> Moment a -> Moment b
  fmap f (M ta) = M \t -> f $ ta t

instance Apply Moment where
  apply :: forall a b. Moment (a -> b) -> Moment a -> Moment b
  apply (M tf) (M ta) = M \t -> (tf t) (ta t)

instance Applicative Moment where
  pure :: forall a. a -> Moment a
  pure = M $ const a

instance Bind Moment where
  bind :: forall a b. (a -> Moment b) -> Moment a -> Moment b
  bind k (M ta) = M \t ->
    let a = ta t
        (M tb) = k a
    in tb t

instance Monad Moment

instance MonadFix Moment where
  mfix :: forall a. (a -> Moment a) -> Moment a
  mfix k = M $ mfix (unM . k :: a -> (Time -> a)) :: Time -> a

## Operators

never :: forall a. Event a
never = E $ M $ const Nothing

unionWith :: forall a. (a -> a -> a) -> Event a -> Event a -> Event a
unionWith f e1 e2 = E $ M \t -> combine <$> e1 <*> e2
  where
    combine :: Maybe a -> Maybe a -> Maybe a
    combine (Just x) (Just y) = Just $ f x y
    combine (Just x) _ = Just x
    combine _ (Just y) = Just y
    combine _ _ = Nothing

filterJust :: forall a. Event (Maybe a) -> Event a
filterJust (E (M tmma)) = E $ M $ join <$> tmma

apply :: forall a b. Behavior (a -> b) -> Event a -> Event b
apply (B mf) (E ma) = E $ (fmap <$> mf) <*> ma

-- Forget all event occurences before a particular time
forgetE :: forall a. Time -> EventSample a -> EventSample a
forgetE t (ES as) = drop t as

-- TODO convolution using Comonad extend
stepper :: forall a. a -> Event a -> Behavior (Behavior a)
stepper init e0 = B $ M $ \t ->
  let
    es0 = toEventSample e0
    es1 = replicate t (Just init) ++ forgetE t es0
    (BS bs1) = eventSampleToBehaviorSample init es1
  in
    B $ M $ \t -> bs1 !! t

-- accumE :: forall a. a -> Event (a -> a) -> Behavior (Event a)
-- accumE init (E (M tmf)) =
