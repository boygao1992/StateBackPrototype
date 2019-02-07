[purescript-distributive](https://pursuit.purescript.org/packages/purescript-distributive)

## Example

```purescript
-- distribute :: Functor f => f (g a) -> g (f a)
-- distribute :: Array (Int -> Int) -> (Int -> (Array Int))
distribute [(_ + 1), (_ + 2)] 1 = [2,3]
```
