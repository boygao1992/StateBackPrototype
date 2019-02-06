[purescript-profunctor](https://pursuit.purescript.org/packages/purescript-profunctor/)

- Data.Profunctor 
- Data.Profunctor.Choice 
- Data.Profunctor.Closed 
- Data.Profunctor.Clown 
- Data.Profunctor.Cochoice 
- Data.Profunctor.Costar 
- Data.Profunctor.Costrong 
- Data.Profunctor.Cowrap 
- Data.Profunctor.Join 
- Data.Profunctor.Joker 
- Data.Profunctor.Split 
- Data.Profunctor.Star 
- Data.Profunctor.Strong 
- Data.Profunctor.Wrap 

## Data.Profunctor.Star

```purescript
newtype Star f a b = Star (a -> f b) -- Function a (f b)

instance profunctorStar :: (Functor f) => Profunctor (Star f) where
                                                -- Function s (f t)
  dimap :: (s -> a) -> (b -> t) -> (Star f) a b -> (Star f) s t
  dimap l r = wrap <<< map (map r) <<< cmap l <<< unwrap
```

## Data.Profunctor.Costar

```purescript
newtype Costar f a b = Costar (f a -> b) -- Function (f a) b

instance profunctorCostar :: (Functor f) => Profunctor (Costar f) where
                                                  -- Function (f s) t
  dimap :: (s -> a) -> (b -> t) -> (Costar f) a b -> (Costar f) s t
  dimap l r = wrap <<< map r <<< cmap (cmap l) <<< unwrap
```
