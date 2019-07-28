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

-- merge :: GCompare k => DMap k (Event t) -> Event t (DMap k Identity)
-- merge
