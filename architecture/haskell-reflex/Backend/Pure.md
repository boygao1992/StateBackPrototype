# Pure (Semantic)

import Data.MemoTrie (memo)
memo :: HasTrie t => (t -> a) -> t -> a

class Patch p where
  type PatchTarget p :: *
  apply :: p -> PatchTarget p -> Maybe (PatchTarget p)

newtype Behavior (Pure t) a = Behavior (t -> a)
newtype Event (Pure t) a = Event (t -> Maybe a)
newtype Dynamic (Pure t) a = Dynamic (t -> (a, Maybe a))
newtype Incremental (Pure t) p = Incremental t -> (PatchTarget p, Maybe p)

type PushM (Pure t) = (->) t
type PullM (Pure t) = (->) t

never :: Event (Pure t) a
never = Event $ const Nothing

constant :: a -> Behavior (Pure t) a
constant = Behavior <<< const

-- (a -> (t -> Maybe b)) -> (t -> Maybe a) -> (t -> Maybe b)
push
  :: (a -> PushM (Pure t) (Maybe b))
  -> Event (Pure t) a
  -> Event (Pure t) b
push f (Event e) = Event $ memo $ \t -> e t >>= \o -> f o t

pushCheap
  :: (a -> PushM (Pure t) (Maybe b))
  -> Event (Pure t) a
  -> Event (Pure t) b
pushCheap = push

-- (t -> a) -> (t -> a)
pull :: PullM (Pure t) a -> Behavior (Pure t) a
pull = Behavior <<< memo

merge
  :: forall (k :: k1 -> *) t
  . GCompare k
  => DMap k (Event (Pure t)) -- [ exists v. k v :=> (t -> Maybe v) ]
  -> Event (Pure t) (DMap k Identity) -- t -> Maybe [ exists v. k v :=> v ]
merge events
  = Events
  $ memo \t ->
    let
      currentOccurrences
        {-  mapMaybeWithKey
              :: GCompare k
              => (forall v. k v -> f v -> Maybe (g v))
              -> DMap k f -> DMap k g
          NOTE f = Event (Pure t), g = Identity
            mapMaybeWithKey
              :: GCompare k
              => (forall v. k v -> Event (Pure t) v -> Maybe (Identity v))
              -> DMap k (Event (Pure t)) -> DMap k Identity
        -}
        = (DMap.mapMaybeWithKey <@> events)
        $ \_ (Event (event :: t -> Maybe v)) ->
            (Identity <$> event t :: Maybe (Identity v))
          :: forall v. k v -> Event (Pure t) v -> Maybe (Identity v)
    in if DMap.null currentOccurrences
       then Nothing
       else Just currentOccurrences

fan
  :: forall k t
  . GCompare k
  => Event (Pure t) (DMap k Identity) -- t -> Maybe [ exists v. k v :=> v ]
  -> EventSelector (Pure t) k -- forall v. k v -> (t -> Maybe v)
fan (Event (event :: t -> Maybe (DMap k Identity)))
  = EventSelector \k ->
      Event
      $ fmap runIdentity <<< DMap.lookup k
        <=< event

fanInt
  :: forall t a
  . Event t (IntMap a) -- t -> Maybe (Map Int a) ~ t -> Maybe (Int -> Maybe a)
  -> EventSelectorInt t a -- Int -> (t -> Maybe a)
fanInt (Event event)
  = EventSelectorInt \k ->
      Event $ IntMap.lookup k <=< event

switch
  :: forall t a
  . Behavior (Pure t) (Event (Pure t) a) -- t -> (t -> Maybe a)
  -> Event (Pure t) a -- t -> Maybe a
switch (Behavior behavior)
  = Event
  $ memo \t ->
      unEvent (behavior t) t

coincidence
  :: forall t a
  . Event (Pure t) (Event (Pure t) a) -- t -> Maybe (t -> Maybe a)
  -> Event (Pure t) a -- t -> Maybe a
coincidence (Event outer)
  = Event
  $ memo \t ->
      outer t >>= \(Event inner) ->
        inner t

current
  :: forall t a
  . Dynamic (Pure t) a -- t -> (a, Maybe a)
  -> Behavior (Pure t) a -- t -> a
current (Dynamic dynamic)
  = Behavior $ fst <<< dynamic

updated
  :: forall t a
  . Dynamic (Pure t) a -- t -> (a, Maybe a)
  -> Event (Pure t) a -- t -> Maybe a
updated (Dynamic dynamic)
  = Event $ snd <<< dynamic

unsafeBuildDynamic
  :: forall t a
  . PullM (Pure t) a -- t -> a
  -> Event (Pure t) a -- t -> Maybe a
  -> Dynamic (Pure t) a -- t -> (a, Maybe a)
unsafeBuildDynamic readV0 (Event event)
  = Dynamic \t -> (readV0 t, event t)

-- TODO unsafeBuildIncremental :: Patch p => PullM t (PatchTarget p) -> Event t p -> Incremental t p
-- TODO mergeIncremental :: GCompare k => Incremental t (PatchDMap k (Event t)) -> Event t (DMap k Identity)
-- TODO mergeIncrementalWithMove :: GCompare k => Incremental t (PatchDMapWithMove k (Event t)) -> Event t (DMap k Identity)

currentIncremental
  :: forall p t
  . Patch p
  => Incremental (Pure t) p -- t -> (PatchTarget p, Maybe p)
  -> Behavior (Pure t) (PatchTarget p) -- t -> PatchTarget p
currentIncremental (Incremental incremental)
  = Behavior $ fst <<< incremental

updatedIncremental
  :: forall p t
  . Patch p
  => Incremental (Pure t) p -- t -> (PatchTarget p, Maybe p)
  -> Event (Pure t) p -- t -> Maybe p
updatedIncremental (Incremental incremental)
  = Event $ snd <<< incremental

incrementalToDynamic
  :: forall p t
  . Patch p
  => Incremental t p -- t -> (PatchTarget p, Maybe p)
  -> Dynamic t (PatchTarget p) -- t -> (PatchTarget p, Maybe p)
incrementalToDynamic (Incremental incremental)
  = Dynamic \t ->
      let
        (old, mPatch) = incremental t
        mNew
          = ((apply :: p -> PatchTarget p -> Maybe (PatchTarget p)) <@> old)
          =<< mPatch
      in (old, mNew)

-- TODO behaviorCoercion :: Coercion a b -> Coercion (Behavior t a) (Behavior t b)
-- TODO eventCoercion :: Coercion a b -> Coercion (Event t a) (Event t b)
-- TODO dynamicCoercion :: Coercion a b -> Coercion (Dynamic t a) (Dynamic t b)
-- TODO mergeIntIncremental :: Incremental t (PatchIntMap (Event t a)) -> Event t (IntMap a)

instance Functor (Dynamic (Pure t)) where
  fmap
    :: forall a b
    . (a -> b)
    -> Dynamic (Pure t) a -- t -> (a, Maybe a)
    -> Dynamic (Pure t) b -- t -> (b, Maybe b)
  fmap f (Dynamic dynamic)
    = Dynamic $ dimap f (fmap f) <<< dynamic

instance Apply (Dynamic (Pure t)) where
  apply
    :: forall a b
    . Dynamic (Pure t) (a -> b) -- t -> (a -> b, Maybe (a -> b))
    -> Dynamic (Pure t) a -- t -> (a, Maybe a)
    -> Dynamic (Pure t) b -- t -> (b, Maybe b)
  apply (Dynamic dynamicF) (Dynamic dynamicA)
    = Dynamic \t ->
        let
          (f, mF) = dynamicF t
          (a, mA) = dynamicA t
        in
          (f a, mF <*> mA)

instance Applicative (Dynamic (Pure t)) where
  pure
    :: forall a
    . a
    -> Dynamic (Pure t) a
  pure a = Dynamic \t -> (a, Nothing)

instance Bind (Dynamic (Pure t)) where
  bind
    :: forall a b
    . Dynamic (Pure t) a
    -> (a -> Dynamic (Pure t) b)
    -> Dynamic (Pure t) b
  bind (Dynamic dynamicA) k
    = Dynamic \t ->
        let
          (currentA, updateA) = dynamicA t
          Dynamic dynamicB = k currentA
          (currentB, updateBOuter) = dynamicB t
          (updateBInner, nextUpdateB) = case updateA of
            Nothing -> (Nothing, Nothing)
            Just nextA ->
              let
                Dynamic nextDynamicB = k nextA
                (nextB, nextUpdateB) = nextDynamicB t
              in
                (Just nextB, nextUpdateB)
        in
          -- NOTE Data.Maybe.First (First(..))
          -- NOTE nextUpdateB > updateBOuter > updateBInner
          (currentB, ala First foldMap [nextUpdateB, updateBOuter, updateBInner])

instance Monad (Dynamic (Pure t))

-- | 'MonadSample' designates monads that can read the current value of a
-- 'Behavior'.  This includes both 'PullM' and 'PushM'.
class (Applicative m, Monad m) => MonadSample t m | m -> t where
  -- | Get the current value in the 'Behavior'
  sample :: Behavior t a -> m a

instance MonadSample (Pure t) ((->) t) where

  sample :: Behavior (Pure t) a -> (t -> a)
  sample = unBehavior

-- | 'MonadHold' designates monads that can create new 'Behavior's based on
-- 'Event's; usually this will be 'PushM' or a monad based on it.  'MonadHold'
-- is required to create any stateful computations with Reflex.
class MonadSample t m => MonadHold t m where

  -- | Create a new 'Behavior' whose value will initially be equal to the given
  -- value and will be updated whenever the given 'Event' occurs.  The update
  -- takes effect immediately after the 'Event' occurs; if the occurrence that
  -- sets the 'Behavior' (or one that is simultaneous with it) is used to sample
  -- the 'Behavior', it will see the __old__ value of the 'Behavior', not the new
  -- one.
  hold :: a -> Event t a -> m (Behavior t a)

  default hold
    :: (m ~ f m', MonadTrans f, MonadHold t m')
    => a -> Event t a -> m (Behavior t a)
  hold v0 = lift <<< hold v0

  -- | Create a 'Dynamic' value using the given initial value that changes every
  -- time the 'Event' occurs.
  holdDyn :: a -> Event t a -> m (Dynamic t a)

  default holdDyn :: (m ~ f m', MonadTrans f, MonadHold t m') => a -> Event t a -> m (Dynamic t a)
  holdDyn v0 = lift <<< holdDyn v0

  -- | Create an 'Incremental' value using the given initial value that changes
  -- every time the 'Event' occurs.
  holdIncremental :: Patch p => PatchTarget p -> Event t p -> m (Incremental t p)

  default holdIncremental :: (Patch p, m ~ f m', MonadTrans f, MonadHold t m') => PatchTarget p -> Event t p -> m (Incremental t p)
  holdIncremental v0 = lift <<< holdIncremental v0

  buildDynamic :: PushM t a -> Event t a -> m (Dynamic t a)
  {-
  default buildDynamic :: (m ~ f m', MonadTrans f, MonadHold t m') => PullM t a -> Event t a -> m (Dynamic t a)
  buildDynamic getV0 = lift <<< buildDynamic getV0
  -}
  -- | Create a new 'Event' that only occurs only once, on the first occurrence of
  -- the supplied 'Event'.

  headE :: Event t a -> m (Event t a)

-- | The 'Enum' instance of @/t/@ must be dense: for all @/x :: t/@, there must not exist
-- any @/y :: t/@ such that @/'pred' x < y < x/@. The 'HasTrie' instance will be used
-- exclusively to memoize functions of @/t/@, not for any of its other capabilities.
instance (Enum t, HasTrie t, Ord t) => MonadHold (Pure t) ((->) t) where

  -- NOTE memorize the entire history
  hold
    :: a
    -> Event (Pure t) a -- t -> Maybe a
    -> t
    -> Behavior (Pure t) a -- t -> a
  hold initialValue (Event event) initialTime = Behavior behavior
    where
      behavior :: t -> a
      behavior
        = memo \sampleTime ->
          -- Really, the sampleTime should never be prior to the initialTime,
          -- because that would mean the Behavior is being sampled before
          -- being created.
          if sampleTime <= initialTime
          then initialValue
          else
            let lastTime = pred sampleTime
            in
              fromMaybe (behavior lastTime) -- NOTE loop back to history
              $ event lastTime

  holdDyn v0 = buildDynamic (return v0)

  buildDynamic
    :: (t -> a)
    -> Event (Pure t) a -- t -> Maybe a
    -> t
    -> Dynamic (Pure t) a -- t -> (a, Maybe a)
  buildDynamic initialValue (Event event) initialTime =
    let Behavior behavior = hold (initialValue initialTime) e initialTime
    in Dynamic \t -> (behavior t, event t)

  holdIncremental
    :: Patch p
    => PatchTarget p
    -> Event (Pure t) p -- t -> Maybe p
    -> t
    -> Incremental (Pure t) p -- t -> (PatchTarget p, Maybe p)
  holdIncremental initialValue (Event event) initialTime
    = Incremental $ \t -> (behavior t, event t)
    where
      behavior :: t -> PatchTarget p
      behavior
        = memo \sampleTime ->
          -- Really, the sampleTime should never be prior to the initialTime,
          -- because that would mean the Behavior is being sampled before
          -- being created.
          if sampleTime <= initialTime
          then initialValue
          else
            let lastTime = pred sampleTime
                lastValue = behavior lastTime -- NOTE loop back to history
            in
              fromMaybe lastValue
              $ (apply <@> lastValue) -- apply patch if an event fired in last step
                <$> event lastTime

  headE = slowHeadE
