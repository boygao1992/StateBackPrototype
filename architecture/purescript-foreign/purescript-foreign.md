[purescript-foreign](https://github.com/purescript/purescript-foreign)

# Foreign

## Foreign

```purescript
foreign import data Foreign :: Type
```
- a foreign type to represent a data-type from a foreign source which we have no idea about its internal structure yet thus there's no way to construct its type-level representation

## ForeignError
```purescript
data ForeignError
  = ForeignError String
  | TypeMismatch String String
  | ErrorAtIndex Int ForeignError
  | ErrorAtProperty String ForeignError

type MultipleErrors = NonEmptyList ForeignError
```
- data constructors
  - `ForeignError :: String -> ForeignError`
    - params
      - `String`, an error message
    - usage
      - `Foreign.Class (instance voidDecode)`
      - `Foreign.JSON (parseJSON)`
      - `Foreign.Generic.Class (instance genericDecodeNoConstructors, instance genericDecodeArgsNoArguments)`
      - `Foreign.Generic.Enum (instance ctorNoArgsGenericDecodeEnum)`
  - `TypeMisMatch :: String -> String -> ForeignError`
    - params
      - first `String`, target type
      - second `String`, foreign data type
    - usage
      - `Foreign (unsafeReadTagged, readChar, readInt, readArray)`
      - `Foreign.Internal (readObject)`
  - `ErrorAtIndex :: Int -> ForeignError`
    - params
      - `Int`, index of Array
    - usage
      - `Foreign.Class (instance arrayDecode)`
  - `ErrorAtProperty`
    - params
      - `String`, property/key of Object
    - usage
      - `Foreign.Generic.Class (instance decodeRecordCons)`

## F
```purscript
type F = Except MultipleErrors
```
- use `Alt` instance for `Except` to accumulate errors

### ExceptT
```purescript
-- [Control.Monad.Except.Trans](https://github.com/purescript/purescript-transformers)
newtype ExceptT e m a = ExceptT (m (Either e a))

type Except e a = ExceptT e Identity a

instance applicativeExceptT :: Monad m => Applicative (ExceptT e m) where
  pure = ExceptT <<< pure <<< Right -- resolve

instance monadThrowExceptT :: Monad m => MonadThrow e (ExceptT e m) where
  throwError = ExceptT <<< pure <<< Left -- reject

-- [Control.Alt](https://github.com/purescript/purescript-control)
-- laws for Alt
-- 1. Associativity: 
--   - (x <|> y) <|> z = x <|> (y <|> z)
-- 2. Distributivity (map distributes over alt): 
--   - f <$> (x <|> y) = (f <$> x) <|> (f <$> y)
class (Functor f) <= Alt f where
  alt :: forall a. f a -> f a -> f a
-- laws for Plus
-- 1. Left identity: empty <|> x = x
-- 2. Right identity: x <|> empty = x
-- 3. Annihilation (empty annihilates left map): f <$> empty = empty
class (Alt f) <= Plus f where
  empty :: forall a. f a
-- laws for Alternative
-- 1. Distributivity (right apply distributes over alt):
--   - (f <|> g) <*> x = (f <*> x) <|> (g <*> x)
-- 2. Annihilation (empty annihilates right apply):
--   - empty <*> f = empty
class (Applicative f, Plus f) <= Alternative f where
-- laws for Zero
-- 1. Annihilation (empty annihilates right bind): empty >>= f = empty
class (Monad m, Alternative m) <= MonadZero m


-- NOTE core functionality, accumulate error messages if all branches reject
instance altExceptT :: (Semigroup e, Monad m) => Alt (ExceptT e m)
  alt :: forall a. ExceptT e m a -> ExceptT e m a -> ExceptT e m a
  alt (ExceptT m1) (ExceptT m2) = ExceptT do
    e1 <- m1
    case e1 of
      Right x -> pure (Right x) -- first ExceptT resolves
      Left err1 -> do
        e2 <- m2
        case e2 of
          Right x -> pure (Right x) -- second ExceptT resolves
          Left err2 -> pure (Left (err1 <> err2)) -- both ExceptT rejects, concatenate error messages from both through `append` (<>) from Semigroup, e.g. `String`, `Array a`
          -- for Foreign, it's `NonEmptyList a` (type MultipleErrors = NonEmptyList ForeignError)

instance plusExceptT :: (Monoid e, Monad m) => Plus (ExceptT e m) where
  empty = throwError (mempty :: e)

instance alternativeExceptT :: (Monoid e, Monad m) => Alternative (ExceptT e m)

instance monadZeroExceptT :: (Monoid e, Monad m) => MonadZero (ExceptT e m)
```

## FFI

```purescript
-- unsafely coerce a purescript value of any type to Foreign
foreign import unsafeToForeign :: forall a. a -> Foreign

-- unsafely coerce a Foreign value to a purescript value of any type
foreign import unsafeFromForeign :: forall a. Foreign -> a

-- use native `typeof` operator to inspect type name of a runtime value
foreign import typeOf :: Foreign -> String

-- use native `Object.prototype.toString` to inspect type name of a runtime value
foreign import tagOf :: Foreign -> String

foreign import isNull :: Foreign -> Boolean
foreign import isUndefined :: Foreign -> Boolean
-- use `Array.isArray` if exists, otherwise fall back on `Object.prototype.toString`
foreign import isArray :: Foreign -> Boolean
```

```javascript
typeOf = function (value) {
  return typeof value
}

typeOf(true) // "boolean"
typeOf(1) // "number"
typeOf(1.1) // "number"
typeOf("") // "string"
typeOf([]) // "object"
typeOf({}) // "object"
```
- `typeOf` cannot tell the difference between
  - `Int` and `Number`
  - `Char` and `String`
  - `Array` and `Object`

```javascript
tagOf = function (value) {
  return Object.prototype.toString.call(value).slice(8, -1)
}

tagOf(true) // "Boolean"
tagOf(1) // "Number"
tagOf(1.1) // "Number"
tagOf("") // "String"
tagOf([]) // "Array"
tagOf({}) // "Object"
```
- `tagOf` is able to differentiate `Array` and `Object`
  - it is recommended to use native `Array.isArray` predicate

## Operators

- `unsafeReadTagged :: forall a. String -> Foreign -> F a`
  - use `tagOf` to reflect type of JS runtime value
  - params
    - `String`, type name
- `readBoolean`, `readNumber`, `readString`
  - for native JS types, `Boolean`, `Number` and `String`, use `unsafeReadTagged`
- `readChar`, `readInt`
  - for non-native JS types, `Char` and `Int`, need special treatments
- `readArray`
  - use `isArray`
- `readNull`, `readUndefined`, `readNullOrUndefined`
  - use `isNull` and/or `isUndefined`
