[MemoTrie: Trie-based memo functions](https://hackage.haskell.org/package/MemoTrie)
- [Conal Elloitt's Trie Series](http://conal.net/blog/tag/trie)
- [Ralf Hinze - Generalizing Generalized Tries](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.8.4069)

[purescript-memoize](https://github.com/paf31/purescript-memoize)
- [Conal Elloitt - talk-2014-elegant-memoization](https://github.com/conal/talk-2014-elegant-memoization/blob/master/README.md)
- [Ralf Hinze - Memo functions, polytyically!](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.43.3272)

# MemoTrie

```haskell
class HasTrie a where
  data (:->:) a :: * -> *

  trie :: (a -> b) -> (a :->: b)
  untrie :: (a :->: b) -> (a -> b)
```

> identity law
> - tire . untrie = id
> - untrie . trie = id

```haskell
meme :: HasTrie a => (a -> b) -> (a -> b)
meme = untire . trie
```

> laws of exponential
> - `() -> a ~= a` -- a^1 = a
> - `(a \/ b) -> c ~= (a -> c) /\ (b -> c)` -- c^(a + b) = c^a * c^b
> - `(a /\ b) -> c ~= a -> (b -> c)` -- c^(a * b) = (c^b)^a

```haskell
instance HasTrie () where
  -- () -> a ~= a
  newtype () :->: a = UnitTrie a

  -- () -> a => a
  trie :: forall b. (() -> b) -> (() :->: b)
  trie f = UniTrie (f ())

  -- a => () -> a
  untrie :: forall b. (() :->: b) -> (() -> b)
  untrie (UnitTrie a) = const a

instance (HasTrie a, HasTrie b) => HasTrie (Either a b) where
  -- (a \/ b) -> x ~= (a -> x) /\ (b -> x)
  data (Either a b) :->: x = EitherTrie (a :->: x) (b :->: x)

  -- (a \/ b) -> x => (a -> x) /\ (b -> x)
  trie :: forall x. (Either a b -> x) -> (Either a b :->: x)
  trie f = EitherTrie (trie (f . Left :: a -> x)) (trie (f . Right :: b -> x))

  -- (a -> x) /\ (b -> x) => (a \/ b) -> x
  untrie :: forall x. (Either a b :->: x) -> (Either a b -> x)
  untrie (EitherTrie s t) = either (untrie s) (untrie t)

instance (HasTrie a, HasTrie b) => HasTrie (a, b) where
  -- NOTE currying, uncurrying
  -- (a, b) -> x ~= a -> (b -> x)
  newtype (a, b) :->: x = PairTrie (a :->: (b :->: x))

  -- (a, b) -> x => a -> b -> x
  trie :: ((a, b) -> x) -> ((a, b) :->: x)
  trie f
    = PairTrie
    $ (trie :: (a -> (b :->: x)) -> (a :->: (b :->: x))) -- :: a :->: (b :->: x)
    $ (trie :: (a -> (b -> x)) -> (a -> (b :->: x))) -- :: a -> (b :->: x)
    . (curry :: ((a,b) -> x) -> a -> b -> x) f -- :: a -> b -> x

  -- a -> b -> x => (a,b) -> x
  untrie :: forall x. ((a, b) :->: x) -> (a, b) -> x
  untrie (PairTrie (t :: a :->: (b :->: x)))
    = uncurry :: (a -> b -> x) -> (a, b) -> x -- (a, b) -> x
        ( (untire :: (b :->: x) -> (b -> x)) -- a -> ( b -> x)
        . (untrie :: (a :->: (b :-> x)) -> (a -> (b :->: x))) t -- a -> (b :-> x)
        )
```

## Containers

```haskell
instance HasTrie a => HasTrie [a] where
  -- empty list: ()
  -- non-empty list: (a, [a])
  -- [a] -> x ~= () \/ (a, [a]) -> x
  newtype [a] :->: x = ListTrie (Either () (a, [a]) :->: x)

  -- NOTE
  -- [a] -> x
  -- () \/ (a, [a]) -> x
  -- (() -> x) /\ ((a, [a]) -> x)
  -- (() -> x) /\ (a -> ([a] -> x))

  -- [a] -> x => () \/ (a, [a]) -> x
  trie :: forall x. ([a] -> x) -> ([a] :->: x)
  trie f
    = ListTrie
    $ (trie :: (Either () (a, [a]) -> x) -> (Either () (a, [a]) :->: x))
    $ (f :: [a] -> x)
    . (either (const [] :: () -> [a]) (uncurry (:) :: (a, [a]) -> [a])
        :: Either () (a, [a]) -> [a]
      )

  -- () \/ (a, [a]) -> x => [a] -> x
  untrie :: forall x. ([a] :->: x) -> ([a] -> x)
  untrie (ListTrie (eitherTrie :: Either () (a, [a]) :->: x))
    = (untrie eitherTrie :: Either () (a, [a]) -> x)
    . \case
        [] -> Left ()
        (x:xs) -> Right (x, xs)
```

## Primitive Types

```haskell
instance HasTrie Bool where
  -- Bool -> x ~= (x, x)
  data Bool :->: x = BoolTrie x x

  -- Bool -> x => (x, x)
  trie :: forall x. (Bool -> x) -> (Bool :->: x)
  trie f = BoolTrie (f False) (f True)

  -- (x, x) => Bool -> x
  untrie :: forall x. (Bool :->: x) -> (Bool -> x)
  untrie (BoolTrie false _) False = false
  untire (BoolTrie _ true) True = true

instance HasTrie Word where
  -- Word -> x ~> [Bool] -> x
  newtype Word :->: x = WordTrie ([Bool] :->: x)

  -- Word -> x => [Bool] -> x
  trie :: forall x. (Word -> x) -> (Word :->: x)
  trie f
    = WordTrie
    $ (trie :: ([Bool] -> x) -> ([Bool] :->: x))
    $ (f :: Word -> x) . (unBits :: [Bool] -> Word) :: [Bool] -> x

  -- [Bool] -> x => Word -> x
  untrie :: forall x. (Word :->: x) -> (Word -> x)
  untrie (WordTrie (listTrie :: [Bool] :->: x))
    = (untrie listTrie :: [Bool] -> x)
    . (bits :: Word -> [Bool])

instance HasTrie Int where
  -- Int -> x ~= Word -> x
  newtype Int :->: x = IntTrie (Word :->: x)

  -- Int -> x => Word -> x
  trie :: forall x. (Int -> x) -> (Int :->: x)
  trie f
    = IntTrie
    $ (trie :: (Word -> x) -> (Word :->: x))
    $ f . (fromIntegral :: Word -> Int) :: Word -> x

  -- Word -> x => Int -> x
  untrie :: forall x. (Int :->: x) -> (Int -> x)
  untrie (IntTrie wordTrie)
    = (untrie wordTrie :: Word -> x)
    . (fromIntegral :: Int -> Word)


instance HasTrie Char where
  -- Char -> x ~= Int -> x
  newtype Char :->: x = CharTrie (Int :->: x)

  -- Char -> x => Int -> x
  tire :: forall x. (Char -> x) -> (Char :->: x)
  trie f
    = CharTrie
    $ (trie :: (Int -> x) -> (Int :->: x))
    $ (f :: Char -> x) . (toEnum :: Int -> Char) :: Int -> x

  -- Int -> x => Char -> x
  untrie :: forall x. (Char :->: x) -> Char -> x
  untrie (CharTrie (intTrie :: Int :->: x))
    = (untrie intTrie :: Int -> x)
    . (fromEnum :: Char -> Int)
```


