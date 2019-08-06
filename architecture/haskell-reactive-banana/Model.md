# 1.2.x.x (modified for comprehension)

## Semantic model

discrete-time signal function

### Types

```haskell
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
```

### Instances

```haskell
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
```

### First-order Operators

```haskell
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
```

### Second-order Operators

```haskell
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

```

# 0.2.0.0

[source code](https://hackage.haskell.org/package/reactive-banana-0.2.0.0/reactive-banana-0.2.0.0.tar.gz)

related blog posts
- [(31 Mar 2011) Trouble with simultaneity](https://apfelmus.nfshost.com/blog/2011/03/31-frp-trouble-with-simultaneity.html)
- [(24 Apr 2011) Push-driven Implementations and Sharing](https://apfelmus.nfshost.com/blog/2011/04/24-frp-push-driven-sharing.html)
- [(28 Apr 2011) Release of reactive-banana version 0.2](https://apfelmus.nfshost.com/blog/2011/04/28-frp-banana-0-2.html)
- [(06 May 2011) Introduction to FRP - Why Applicative Functors?](https://apfelmus.nfshost.com/blog/2011/05/06-frp-why-functors.html)

## Semantic model

```haskell

-- | The type index 'Model' represents the model implementation.
data Model

-- Stream of events. Simultaneous events are grouped into lists.
newtype instance Event Model a = E { unE :: [[a]] }
--   [(Time, a)] -- original model from FRAnimation
-- ~ [(Time, [a])] -- NOTE introduce simultaneity
-- ~ Time -> [a] -- Time = Int
-- ~ [[a]]

-- Stream of values that the behavior takes.
newtype instance Behavior Model a = B { unB :: [a] } -- Time -> a, function
--   Time -> a -- Time = Int
-- ~ [a]

------------------
-- Class interface

data family Event f    :: * -> *
data family Behavior f :: * -> *

class
  ( Functor (Event f)
  , Functor (Behavior f)
  , Applicative (Behavior f)
  ) => FRP f where

    -- | Event that never occurs.
    -- Think of it as @never = []@.
    never    :: Event f a

    -- | Merge two event streams of the same type.
    -- In case of simultaneous occurrences, the left argument comes first.
    -- Think of it as
    --
    -- > union ((timex,x):xs) ((timey,y):ys)
    -- >    | timex <= timey = (timex,x) : union xs ((timey,y):ys)
    -- >    | timex >  timey = (timey,y) : union ((timex,x):xs) ys
    union    :: Event f a -> Event f a -> Event f a

    -- | Apply a time-varying function to a stream of events.
    -- Think of it as
    --
    -- > apply bf ex = [(time, bf time x) | (time, x) <- ex]
    apply    :: Behavior f (a -> b) -> Event f a -> Event f b


    -- | Allow all events that fulfill the predicate, discard the rest.
    -- Think of it as
    --
    -- > filter p es = [(time,a) | (time,a) <- es, p a]
    filter   :: (a -> Bool) -> Event f a -> Event f a

    -- | Allow all events that fulfill the time-varying predicate, discard the rest.
    -- It's a slight generalization of 'filter'.
    filterApply :: Behavior f (a -> Bool) -> Event f a -> Event f a

    -- Accumulation.
    -- Note: all accumulation functions are strict in the accumulated value!
    -- acc -> (x,acc) is the order used by  unfoldr  and  State

    -- | Construct a time-varying function from an initial value and
    -- a stream of new values. Think of it as
    --
    -- > stepper x0 ex = \time -> last (x0 : [x | (timex,x) <- ex, timex < time])
    --
    -- Note that the smaller-than-sign in the comparision @timex < time@ means
    -- that the value of the behavior changes \"slightly after\"
    -- the event occurrences. This allows for recursive definitions.
    --
    -- Also note that in the case of simultaneous occurrences,
    -- only the last one is kept.
    stepper :: a -> Event f a -> Behavior f a

    -- | The 'accumB' function is similar to a /strict/ left fold, 'foldl''.
    -- It starts with an initial value and combines it with incoming events.
    -- For example, think
    --
    -- > accumB "x" [(time1,(++"y")),(time2,(++"z"))]
    -- >    = behavior "x" [(time1,"xy"),(time2,"xyz")]
    --
    -- Note that the value of the behavior changes \"slightly after\"
    -- the events occur. This allows for recursive definitions.
    accumB   :: a -> Event f (a -> a) -> Behavior f a

    -- NOTE [Haskell/Foldable](https://en.wikibooks.org/wiki/Haskell/Foldable)
    -- foldr :: (a -> (b -> b)) -> b -> [a] -> b
    --       ~> (a -> (a -> a)) -> a -> [a] -> a -- degenerated
    --        ~ a -> [a -> a] -> a -- map over the list [a]
    --       ~? a -> f [a -> a] -> f a -- NOTE lift both into an effect f
    --        ~ a -> (Time -> [a -> a]) -> (Time -> a) -- f = (->) Time
    --        ~ a -> Event (a -> a) -> Behavior a

    -- | The 'accumE' function accumulates a stream of events.
    -- Note that the output events are simultaneous with the input events,
    -- there is no \"delay\" like in the case of 'accumB'.
    accumE   :: a -> Event f (a -> a) -> Event f a
    --       ~ a -> [a -> a] -> a
    --       ~ [a -> a] -> (a -> a)
    -- (a -> a) ~ Endo a
    -- instance Semigroup (Endo a) where (<>) = under Endo (<<<)
    -- instance Monoid (Endo a) where mempty = Endo identity
    --       = ala Endo foldMap

instance FRP f => Monoid (Event f a) where
  mempty  = never
  mappend = union

----------------------
-- Derived Combinators

-- | Variant of 'filterApply'.
whenE :: FRP f => Behavior f Bool -> Event f a -> Event f a

-- | Efficient combination of 'accumE' and 'accumB'.
mapAccum :: FRP f => acc -> Event f (acc -> (x,acc)) -> (Event f x, Behavior f acc)

```

## Compile Network AST

compile
  :: Event Accum () -- Program, discrete machine with Accum backend
  -> IO ([Path], Cache)
compile e
  = runStore
  $ runCompile
  $ return . map compilePath
    =<< compileUnion
    =<< compileAccumB e
