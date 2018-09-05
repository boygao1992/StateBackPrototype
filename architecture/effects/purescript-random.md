[purescript-random](https://github.com/purescript/purescript-random)

```javascript
exports.random = Math.random;
```

```haskell
foreign import random :: Effect Number
-- | uniformly distributed over an interval
randomInt :: Int -> Int -> Effect Int
randomRange :: Number -> Number -> Effect Number
randomBool :: Effect Boolean
```

synchronous `Effect`, need to wrap it in a `Aff` to perform asynchronously