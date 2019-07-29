# Pure
import Data.MemoTrie (memo)
memo :: HasTrie t => (t -> a) -> t -> a

newtype Behavior (Pure t) a = Behavior (t -> a)
newtype Event (Pure t) a = Event (t -> Maybe a)
newtype Dynamic (Pure t) a = Dynamic (t -> (a, Maybe a))
newtype Incremental (Pure t) p = Incremental (t -> PatchTarget p, Maybe p)

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
  = EventSelector \k -> Event \t ->
      fmap runIdentity . DMap.lookup k
      =<< event t

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
  = Behavior \t ->
      fst $ dynamic t

updated
  :: forall t a
  . Dynamic (Pure t) a -- t -> (a, Maybe a)
  -> Event (Pure t) a -- t -> Maybe a
updated (Dynamic dynamic)
  = Event \t ->
      snd $ dynamic t
