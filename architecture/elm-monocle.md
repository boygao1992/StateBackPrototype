[arturopala/elm-monocle](https://github.com/arturopala/elm-monocle)

`elm-monocle/src/Monocle/Lens.elm`

> ```elm
> type alias Lens a b = -- Lens s t a b :: Functor f => (a -> f b) -> s -> f t
>   { get : a -> b -- getter :: s -> a
>   , set : b -> a -> a -- setter :: s -> b -> t, in this case, a -> s -> s
>   }
> -- this is a simple Lens with f being the Identity functor
> -- Lens' a s = (a -> Identity a) -> s -> Identity s
> ```

```elm
type alias Lens a s = (a -> a) -> s -> s
-- | create a Lens from a getter and setter
lens : (s -> a) -> (s -> a -> s) -> Lens a s
lens getter setter f s = (setter s) << (f << getter) <| s
```

