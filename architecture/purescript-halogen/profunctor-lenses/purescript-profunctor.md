[purescript-profunctor](https://pursuit.purescript.org/packages/purescript-profunctor/)


Data
- Data.Profunctor.Wrap, Data.Profunctor.Cowrap
- Data.Profunctor.Joker, Data.Profunctor.Clown
- Data.Profunctor.Star, Data.Profunctor.Costar
- TODO Data.Profunctor.Join
- TODO Data.Profunctor.Split

Class
- Data.Profunctor 
- Data.Profunctor.Strong, Data.Profunctor.Costrong 
- Data.Profunctor.Choice, Data.Profunctor.Cochoice
- TODO Data.Profunctor.Closed 

## Control.Semigroupoid, Control.Category
```purescript
class Semigroupoid p where
  (<<<) :: forall a b c. p b c -> p a b -> p a c
  (>>>) :: forall a b c. p a b -> p b c -> p a c

class (Semigroupoid p) <= Category p where
  identity :: forall i. p i i
```

## Data.Profunctor

```purescript
class Profunctor p where
  dimap :: forall s t a b. (s -> a) -> (b -> t) -> p a b -> p s t

lcmap :: forall a b c p. Profunctor p => (a -> b) -> p b c -> p a c
lcmap l = dimap l identity

rmap :: forall a b c p. Profunctor p => (b -> c) -> p a b -> p a c
rmap r = dimap identity r
```

## Data.Profunctor.Wrap, Data.Profunctor.Cowrap

```purscript
newtype Wrap p a b = Wrap (p a b)

instance functorWrap :: Functor (Wrap p a) where
  map r = wrap <<< rmap r <<< unwrap
```

```purescript
newtype Cowrap p b a = Cowrap (p a b)

instance contravariantCowrap :: Contravariant (Cowrap p b) where
  cmap l = wrap <<< lcmap l <<< unwrap
```

## Data.Profunctor.Joker, Data.Profunctor.Clown

```purescript
newtype Joker f a b = Joker (f b)

instance profunctorJoker :: Functor f => Profunctor (Joker f) where
  dimap _ g = wrap <<< map g <<< unwrap
```

```purescript
newtype Clown f a b = Clown (f a)

instance profunctorClown :: Contravariant f => Profunctor (Clown f) where
  dimap f _ = wrap <<< cmap f <<< unwrap
```

## Data.Profunctor.Star, Data.Profunctor.Costar

```purescript
newtype Star f a b = Star (a -> f b) -- Function a (f b)

instance profunctorStar :: (Functor f) => Profunctor (Star f) where
                                                -- Function s (f t)
  dimap :: (s -> a) -> (b -> t) -> (Star f) a b -> (Star f) s t
  dimap l r = wrap <<< map (map r) <<< cmap l <<< unwrap

```

```purescript
newtype Costar f a b = Costar (f a -> b) -- Function (f a) b

instance profunctorCostar :: (Functor f) => Profunctor (Costar f) where
                                                  -- Function (f s) t
  dimap :: (s -> a) -> (b -> t) -> (Costar f) a b -> (Costar f) s t
  dimap l r = wrap <<< map r <<< cmap (cmap l) <<< unwrap
```

## Data.Profunctor.Strong, Data.Profunctor.Costrong

```purescript
class (Profunctor p) <= Strong p where
    first :: forall a b i. p a b -> p (Tuple a i) (Tuple b i)
    second :: forall a b i. p a b -> p (Tuple i a) (Tuple i b)

splitStrong :: forall p a b c d. Category p => Strong p => 
    p a b -> p c d -> p (Tuple a c) (Tuple b d)
              --  first l :: p (Tuple a c)  (Tuple b c)
                           -- second r :: p (Tuple b c) (Tuple b d)
splitStrong l r = first l >>> second r

fanout :: forall p a b d. Category p => Strong p => 
 -- p a b -> p a d -> p (Tuple a a) (Tuple b d), a special case of `splitStrong`
    p a b -> p a d -> p        a    (Tuple b d)
fanout l r = lcmap (\a -> Tuple a a) (splitStrong l r)
```

```purescript
class (Profunctor p) <= Costrong p where
    unfirst :: forall a b i. p (Tuple a i) (Tuple b i) -> p a b
    unsecond :: forall a b i. p (Tuple i a) (Tuple i b) -> p b c
```

## Data.Profunctor.Choice, Data.Profunctor.Cochoice

```purescript
class (Profunctor p) <= Choice p where
  left :: forall a b c. p a b -> p (Either a c) (Either b c)
  right :: forall a b c. p b c -> p (Either a b) (Either a c)

splitChoice :: forall p a b c d. Category p => Choice p => 
    p a b -> p c d -> p (Either a c) (Either b d)
splitChoice l r = left l >>> right r

fanin :: forall p a b c. Category p => Choice p =>
    p a c -> p b c -> p (Either a b) c
fanin l r = rmap (either identity identity) (splitChoice l r)
```

```purescript
class (Profunctor p) <= Cochoice p where
  unleft :: forall a b c. p (Either a c) (Either b c) -> p a b
  unright :: forall a b c. p (Either a b) (Either a c) -> p b c
```
