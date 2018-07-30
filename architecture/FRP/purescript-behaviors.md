`Event` is modeled as a function which takes a event handler (`a -> Effect Unit`) and returns a JS primitive effect (`Effect (Effect Unit)`)

`Instant` (from `purescript-datetime`)
- An instant is a duration in milliseconds relative to the Unix epoch (1970-01-01 00:00:00 UTC).

```purescript
instance functorEvent :: Functor Event where
  -- map :: forall a b f. Functor f => (a -> b) -> f a -> f b
  -- e :: (a -> Effect Unit) -> Effect (Effect Unit)
  -- f :: a -> b
  -- k :: b -> Effect Unit
  -- (k <<< f) :: a -> Effect Unit
  -- RHS :: (b -> Effect Unit) -> Effect (Effect Unit) = Event b
  map f (Event e) = Event \k -> e (k <<< f)
```

``` purescript
instance applicativeEvent :: Applicative Event where
               -- k :: a -> Effect Unit
  pure a = Event \k -> do
    k a -- Effect Unit
    pure (pure unit) -- Effect (Effect Unit)
```

