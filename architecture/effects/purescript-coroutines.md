[purscript-coroutines](https://pursuit.purescript.org/packages/purescript-coroutines)

[purescript-aff-coroutines - Helper functions for creating coroutines with the Aff monad](https://pursuit.purescript.org/packages/purescript-aff-coroutines)

[Stackless Coroutines in Purescript](https://blog.functorial.com/posts/2015-07-31-Stackless-PureScript.html)

> stack-free implementation of the free monad transformer for a functor
>
> Free Monads and Coroutines

> ```haskell
> data Emit o a = Emit o a
>
> type Producer = Free Emit
>
> emit :: o -> Producer o Unit
> emit o = liftF $ Emit o unit
>
> emit3 :: Producer Int Unit
> emit3 = do
>   emit 1
>   emit 2
>   emit 3
> ```

> ```haskell
> data GosubF f a b = GosubF (Unit -> Free f b) (b -> Free f a)
> data Free f a
>   = Pure a
>   | Free (f (Free f a))
>   | Gosub (Exists (GosubF f a))
> ```

> the `Gosub` constructor which directly captures the arguments to a monadic bind
> , **existentially** hiding the return type `b` of the inner action.

>
> Tail Recursive Monads
```haskell
pow :: Int -> Int -> Int
pow n p = go 1 p
  where
    go acc 0 = acc
    go acc p = go (acc * n) (p - 1) -- tail recursion, will be compiled into while loop in JS
```

```haskell
powWriter :: Int -> Int -> Writer Product Unit
powWriter n = go
  where
    go 0 = return unit
    go m = do
      tell :: forall w. w -> Run (writer :: Writer w | r) Unit
      tell n
      go (m - 1)
```

>
> Stack-Safe Free Monad Transformers
>
> Stackless Coroutines
