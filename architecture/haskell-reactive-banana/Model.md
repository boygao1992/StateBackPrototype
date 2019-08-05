# Model (Semantic)

discrete-time signal function

## Types

type Time = Int -- >= 0
newtype Moment a = M (Time -> a)

newtype Behavior a = B (Moment a)
  deriving newtype (Functor, Apply, Applicative, Bind, Monad, MonadFix)
newtype BehaviorSample a = BS [a] -- sampling of a Behavior function from Time = 0

newtype Event a = E (Moment (Maybe a)) -- NOTE Event is a special type of Behavior
  deriving newtype (Functor, Apply, Applicative, Bind, Monad, MonadFix)
newtype EventSample a = ES [Maybe a] -- sampling of an Event function from Time = 0

sampleEvent :: forall a. Event a -> EventSample a
sampleEvent (E (M tma)) = tma <$> [0..]

sampleEventHead :: forall a. Time -> Event a -> EventSample a
sampleEventHead t = ES . take t . unES . sampleEvent

valueE :: forall a. EventSample a -> Event a
valueE (ES mas) = E $ M \t -> (mas ++ repeat Nothing) !! t

sampleBehavior :: forall a. Behavior a -> BehaviorSample a
sampleBehavior (B (M ta)) = BS $ ta <$> [0..]

-- NOTE must be an infinite sample
unsafeValueB :: forall a. BehaviorSample a -> Behavior a
unsafeValueB (BS as) = B $ M \t -> as !! t

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

eventToBehavior :: forall a. a -> Event a -> Behavior a
eventToBehavior init
  = unsafeValueB
  . eventSampleToBehaviorSample init
  . sampleEvent

behaviorToEvent :: forall a. Behavior a -> Event a
behaviorToEvent (B (M ta)) = E $ M \t -> Just $ ta t

interpret
  :: forall a b
  . (Event a -> Event b)
  -> EventSample a
  -> EventSample b
interpret f (ES sampleA)
  = ES
  . sampleEventHead (length sampleA)
  . f
  . valueE

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

## First-order Operators

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

applyE :: forall a b. Behavior (a -> b) -> Event a -> Event b
applyE (B mf) (E ma) = E $ (fmap <$> mf) <*> ma

-- Forget all event occurences before a particular time
forgetES :: forall a. Time -> EventSample a -> EventSample a
forgetES t (ES as) = drop t as

valueB :: forall a. BehaviorSample a -> Behavior a
valueB = unsafeValueB

# Second-order Operators

-- TODO convolution using Comonad extend
stepper :: forall a. a -> Event a -> Behavior (Behavior a)
stepper init e0 = B $ M $ \t ->
  let
    es0 = sampleEvent e0
    (ES mas) = forgetES t es0
    es1 = ES $ replicate t (Just init) ++ mas
    bs = eventSampleToBehaviorSample init es1
  in
    unsafeValueB bs

accumE :: forall a. a -> Event (a -> a) -> Behavior (Behavior a)
accumE init e1 = mdo
  let (e2 :: Event a) = ( (\a f -> f a) <$> b :: Behavior ((a -> a) -> a) ) `applyE` e1
  b :: Behavior a
    <- stepper init e2
  pure e2

observeE :: Event (Behavior a) -> Event a
observeE = (E (M tmB)) = E $ M \t ->
  let
    mB = tmB t
  in
    (\ta -> ta t) . unB <$> mB

diagonalB :: Behavior (Behavior a) -> Behavior a
diagonalB (B (M tB)) = B $ M \t ->
  let
    (B (M ta)) = tB t
  in
    ta t

forgetDiagonalE :: Event (Event a) -> Event (EventSample a)
forgetDiagonalE (E (M tmE)) = E $ M \t ->
  let
    mE = tmE t
    mES = forgetES t . sampleEvent <$> mE
  in
    mES

switchE :: Event (Event a) -> Behavior (Event a)
switchE eE =
  let (E (M tES)) = forgetDiagonalE eE
  in B $ M \t -> valueE $ tES t

switchB :: Behavior a -> Event (Behavior a) -> Behavior (Behavior a)
switchB initB eB
  = diagonalB
  <$> stepper initB eB :: Behavior (Behavior (Behavior a))

