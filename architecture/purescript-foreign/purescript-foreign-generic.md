[purescript-foreign-generic](https://github.com/paf31/purescript-foreign-generic)

# Foreign.Class

## class Decode
```purescript
class Decode a where
  decode :: Foreign -> F a
```

## class Encode
```purescript
class Encode a where
  encode :: a -> Foreign
```

# Test.Types
