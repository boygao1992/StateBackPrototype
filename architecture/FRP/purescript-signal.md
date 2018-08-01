[purescript-signal - Elm style FRP library for PureScript](https://github.com/bodil/purescript-signal/)

```purescript
-- | Creates a past dependent signal. The function argument takes the value of the input signal, and the previous value of the output signal, to produce the new value of the output signal.
foldp :: forall a b. (a -> b -> b) -> b -> (Signal a) -> (Signal b)
```

- the body of the program:
`(a -> b -> b)` is usually `event -> state -> state`, a state transition function.
therefore, `foldp` takes a state transition function and an initial state, and then transform a `Signal event` into `Signal state`

- at the (lower) boundary of the program:
the sinks of the signal network are functions that transform program state/internal events into IO effects that are then handled by the runtime:
`Signal event/state -> Signal (Effect Unit)`

merge these two type of transformation functions together, we have a legitimate Mealy machine:
`event -> state -> (state, Effect Unit)` (or `(state, input) -> (state, output)`)

In Elm, all the source `Signal event`s, e.g. events from DOM or network, are merged into one gigantic `Singal event`, and then the programmers are required to provide a gigantic state transition function of a Mealy machine `event -> state -> (state, Effect Unit)` and an initial state, then the runtime will use `foldp` to connect these two.

This is how Elm "deprecated" `Signal` or, more precisely, hided `Signal` from users ever since 0.17.

The reason why (based on my understanding)
- this choice of architecture was widely adopted by the community
- `Signal` is hard to understand for non-FP programmers

Cons
- loss of all the combinators for `Signal`, 
now the only two ways to compose state transition functions are 
  - function composition (including recursive/fixed-point combinator, but not recommended)
    - without recursive calls of state transition function, the state transition for all state variables should be handled in one step/pass.
    duplication is unavoidable but could be mitigated by function reuses
  - conditional nesting (because for state transition `event -> state -> state`, you can pattern match on `event` and passing a subset of `event`s to a "child" state transition `event -> state -> state`)
- harder to define `integral` and `derivative` operators for animation

# examples

- [The canonical Elm Mario](https://github.com/michaelficarra/purescript-demo-mario)
- [Ponies](https://github.com/bodil/purescript-is-magic)
