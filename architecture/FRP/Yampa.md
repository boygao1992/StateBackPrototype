[Yampa](https://github.com/ivanperez-keera/Yampa)

`loop`
- not a fixed-point combinator
- allows construction of stateful Signal Function
- state is hidden like `State` Monad (but you can copy the state and expose it; sort of pointless)

`Elm` `Program` actually utilizes such a discrete `loop` construct in its runtime
(hidden from programmer, of course)

`purescript-event` (a submodule of `purescript-behaviors`) has a fixed-point combinator for its Signal Function
```purescript
fix :: forall i o. (Event i -> { input :: Event i, output :: Event o }) -> Event o
```

2.6 Switching and Signal Collections
- `switch :: SF a (b, Event c) -> (c -> SF a b) -> SF a b`
- `rswitch :: SF a b -> SF (a, Event (SF a b)) b` (second-order `SF`)
- `parB :: Functor col => col (SF a b) -> SF a (col b)`
