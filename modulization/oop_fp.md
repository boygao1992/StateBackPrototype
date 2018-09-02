Object-oriented: Vertex graph, directional edges (functions connecting two data-types) are second-class citizen that live inside vertices (data-types)

Function-oriented / Functional: Edge graph, but usually both data-types and functions are first-class citizen in FP languages, anonymous functions and data-types are allowed as well.

purpose anonymous functions and data / objects:
ontology / taxonomy that group similar constructs together into a class / named data-type (with data constructor function) is for reuse purpose.
Roughly, if an object is never used more than 3 times in a code base, then it doesn't worth to be generalized into a class.

# Interface, Type class vs. Discriminated/Tagged Union

interface

- open world assumption on instances (single type)
- close world assumption on structure (data-types and functions)

```typescript
interface IType {
    x : Type1
    y : Type2
    z : Type3
    
    method1(_this : IType, args: Type4): Type5 {}
    method2(_this : IType): Type6 {}
}
```

```haskell
newtype IType = IType
  { x :: Type1
  , y :: Type2
  , z :: Type3
  }

class ITypeClass a where
  method1 :: a -> Type4 -> Type5 -- polymorphism only at the first argument
  method2 :: a -> Type6

instance ITypeClass IType where
  method1 :: IType -> Type4 -> Type5
  method1 i args = ...
  method2 :: IType -> Type6
  method2 i = ...
```

interface only allows subtype polymorphism on the initial vertex of a set of edges
(by default, the encapsulated variables are accessible through `this`, which can be treated as the first argument to all methods in that interface)

FP focus on edges, where type class allows subtype polymorphism on all vertices along the edge (a high-order function is an edge in hypergraph that connects multiple vertices)

```haskell
class ITypeClass a b where -- a :: *, b :: *
  method1 :: a -> Type
  method2 :: Type -> a
  method3 :: Type -> a -> Type
  method4 :: b -> a -> b
```

type class further supports polymorphism on (higher-order) Type Functions

```haskell
class Transform f t a b where -- f :: * -> *, t :: * -> * -> *
  transform :: t a (f a) -> f b
```

functional dependency: assert a functional relationship between type arguments of a multi-parameter type class

```haskell
class Stream stream element
  | stream -> element -- there is a function from a `stream` type to a unique `element` type (uncons, in this case), thus `element` type can be inferred by the compiler
  where
    uncons :: stream -> Maybe { head :: element, tail :: stream }

genericTail :: forall stream element. Stream stream element => stream -> Maybe stream
genericTail xs = map _.tail (uncons xs) -- a generic function that only transforms the structure of the Stream
```

instance dependencies

```haskell
-- an example of polymorphic recursion
instance Show a => Show ([a]) where
  show [] = "nil"
  show (x: xs) = show x ++ " : " ++ show xs
-- substitute a by [a], we have Show [a] => Show ([[a]])
-- then possibly, Show ([[[...[a]...]]])
-- thus, this type class works for an infinite number of types
-- {[a], [[a]], [[[a]]], ...}

show [[[[[1]]]]] :: String -- 1 : nil : nil : nil : nil : nil
```





type class

- open world assumption on instances (multiple types or type functions)
- closed world assumption on structure (functions)

union: closed world assumption on instances, compile-time exhaustive matching

marker interface: empty interface for grouping, need runtime reflection to match each instance

```typescript
interface Shape {}

interface Point {
    x : number
    y : number
}

class Circle implements Shape {
    center : Point
    radius : number
}

class Rectangle implements Shape {
    center : Point
    width: number
    height: number
}

class Line implements Shape {
    start : Point
    end : Point
}
```

```haskell
data Point = Point
  { x :: Double
  , y :: Double
  }
type Shape
  = Circle { center :: Point, radius :: Double }
  | Rectangle { width :: Double, height :: Double }
  | Line { start :: Point, end :: Point }
```

```haskell
class Shape s where
  -- 
```

Union type in OOP

```Java
abstract class List<A> {
    public abstract <B> B accept(ListVisitor<A,B> that);
}
interface ListVisitor<A, B> {
    public B _case(Empty<A> that);
    public B _case(Cons<A> that);
}
class Empty<A> extends List<A> {
    public <B> B accept(ListVisitor<A,B> that) {
      return that._case(this);
    }
}
class Cons<A> extends List<A> {
    private A head;
    private List<A> tail;
    
    Cons(A _head, List<A> _tail) {
      first = _head;
      tail = _tail;
    }
    public A head() {return head;}
    public List<A> tail() {return tail;}
    
    public <B> B accept(ListVisitor<A,B> that) {
      return that._case(this);
    }
}
```

[JavaSealedUnions](https://github.com/pakoito/JavaSealedUnions)

```Java
interface Union2<T1, T2> {
    <A> A case(Function<T1, A> f, Function<T2, A> g);
}
interface Constructor2<T1, T2> {
    Union2<T1, T2> first(T1 x);
    Union2<T1, T2> second(T2 x);
}
```



```scala
sealed trait List[A]
final case class Cons[A](x: A, xs: List[A]) extends List[A]
final case class Nil[A]() extends List[A]

val sum: List[Double] => Double = {
    case Cons(x , xs) => x + sum(xs)
    case Nil() => 0
}
```

[learning Scalaz — Coproducts](http://eed3si9n.com/learning-scalaz/Coproducts.html)


# Higher-Kinded Polymorphism

[Higher-rank and higher-kinded types](https://www.stephanboyer.com/post/115/higher-rank-and-higher-kinded-types)

> There is one possibility we haven’t explored: functions from values to types. These are called “[dependent types](https://en.wikipedia.org/wiki/Dependent_type)” and open up a mind-blowing world of [programming with proofs](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence).

higher-kinded type (type-level functions)
higher-rank type (type-level functions that have type-level functions as its arguments)


[Multi-parameter type class](https://wiki.haskell.org/Multi-parameter_type_class)

> If you think of a single-parameter type class as a set of types,
> then a multi-parameter type class is a relation between types. 



# Multiple Dispatch

[Reflection-based implementation of Java extensions: the double-dispatch use-case](http://www.jot.fm/issues/issue_2005_12/article3/)

# Ad-hoc Polymorphism vs. Universal Polymorphism

[subtype polymorphism](https://www.javaworld.com/article/2075223/core-java/reveal-the-magic-behind-subtype-polymorphism.html)
> *Universal polymorphism* refers to a uniformity of type  structure, in which the polymorphism acts over an infinite number of  types that have a common feature. The less structured *ad hoc polymorphism* acts over a finite number of possibly unrelated types.

> - ad hoc
>   - **Coercion:** a single abstraction serves several types through implicit type conversion

implicit laws, require memorization

> example
> ```java
> 2.0 + 2.0 // double + double
> 2.0 + 2 // double + int => double + double
> 2.0 + "2" // double + string => string + string
> // int < double < string, "widening"
> ```

> "A widening conversion of an int or a long value to float, or of a long value to double, may result in loss of precision"
> ```java
> int d = Integer.MAX_VALUE;
> float f = d;
> System.out.println(String.format("%d != %12.0f", d, f));
> // 2147483647 != 2147483648
> ```



Haskell never implicitly converts between types, but it has the conversion functions.
e.g. `fromIntegral`

![haskell-prelude-types](/home/wenbo/work/testProject/StateBackPrototype/doc/haskell-prelude-types.gif)

```haskell
-- | Numeric types declared in GHC.Prim
-- Integral: Int, Integer
data Int -- Bounded, [-2^29 .. 2^29-1], machine integers
data Integer -- unbounded, arbitrary-precision, mathematical integers
-- Fractional : Double, Float
data Double -- double-precision floating-point numbers
data Float -- don't use
type Rational = Ratio Integer -- arbitrary-precision fractions

-- | Type classes
class Num a where
  (+) :: a -> a -> a
  (-) :: a -> a -> a
  (*) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a -- Sign of a number, -1 (negative), 0 (zero), 1 (positive)
  fromInteger :: Integer -> a

class (Num a, Ord a) => Real a where
  -- Real types include both Integral and RealFrac types (excludes Complex numbers)
  toRational :: a -> Rational

class Num a => Fractional a where
    (/) :: a -> a -> a -- fractional division
    recip :: a -> a -- reciprocal fraction
    fromRational :: Rational -> a 

class (Real a, Enum a) => Integral a where
    quot :: a -> a -> a -- integer division truncated toward zero
    rem :: a -> a -> a -- integer remainder
    div :: a -> a -> a -- integer division truncated toward negative infinity
    mod :: a -> a -> a
    quotRem :: a -> a -> (a, a) -- simultaneous quot and rem
    divMod :: a -> a -> (a, a) -- simultaneous div and mod
    toInteger :: a -> Integer

class Fractional a => Floating a where
    pi :: a
    exp :: a -> a
    log :: a -> a
    sqrt :: a -> a
    (**) :: a -> a -> a
    logBase :: a -> a -> a
    sin :: a -> a
    cos :: a -> a
    tan :: a -> a
    asin :: a -> a
    acos :: a -> a
    atan :: a -> a
    sinh :: a -> a
    cosh :: a -> a
    tanh :: a -> a
    asinh :: a -> a
    acosh :: a -> a
    atanh :: a -> a

class (Real a, Fractional a) => RealFrac a where
  -- RealFrac types can contain either whole numbers or fractions.
  -- instances: Ratio a (forall a. including Rational), Double
  properFraction :: Integral b => a -> (b, a)
  -- takes a real fractional number x and returns a pair (n,f) where
  --   n is an integral number with the same sign as x;
  --   f is a fraction with the same type and sign as x, and with absolute value less than 1.
  truncate :: Integral b => a -> b
  round :: Integral b => a -> b
  ceiling :: Integral b => a -> b
  floor :: Integral b => a -> b

class (RealFrac a, Floating a) => RealFloat a where
  floatRadix :: a -> Integer
  floatDigits :: a -> Int
  floatRange :: a -> (Int, Int)
  decodeFloat :: a -> (Integer, Int)
  encodeFloat :: Integer -> Int -> a
  exponent :: a -> Int
  significand :: a -> a
  scaleFloat :: Int -> a -> a
  isNaN :: a -> Bool -- "not-a-number" (NaN)
  isInfinite :: a -> Bool
  isDenormalized :: a -> Bool
  isNegativeZero :: a -> Bool
  isIEEE :: a -> Bool -- IEEE floating point number
  atan2 :: a -> a -> a

-- | Numeric functions
fromIntegral :: (Integral a, Num b) => a -> b -- general coercion from integral types
realToFrac :: (Real a, Fractional b) => a -> b -- general coercion to fractional types
```

[don't use `Float`](https://wiki.haskell.org/Performance/Floating_point)

```haskell
type String = [Char]

-- | ToString
type ShowS = String -> String -- a function that prepends the output String to an existing String.
class Show a where
  showsPrec :: Int -> a -> ShowS
  show :: a -> String
  showList :: [a] -> ShowS

-- | FromString
type ReadS a = String -> [(a, String)] -- A parser for a type a, represented as a function that takes a String and returns a list of possible parses as (a,String) pairs.
class Read a where
  readsPrec :: Int -> ReadS a
  readList :: ReadS [a]

read :: Read a => String -> a 
```



```haskell
2.0 + 2.0 :: Fractional a => a -- remains at type class level, could be Double, Float or other instances of type class Fractional
2.0 + 2 :: Fractional a => a
2 + 2 :: Num a => a -- could be Int, Integer, Double, Float, or other instances of type class Num

2.0 + "2" -- illegal
        (++) :: [a] -> [a] -> [a] -- List concatenation
show 2.0 ++ "2" :: String -- "2.02", or ['2', '.', '0', '2']
-- 2.0 is inferred as Fractional a, which is not an instance of Show a, how?
-- Monomorphism restriction (default type narrowing rules), Fractional a is filled by Double, which is an instance of Show a
show (2.0::Double) ++ "2"
```

> [Monomorphism restriction](https://wiki.haskell.org/Monomorphism_restriction)
>
> a counter-intuitive rule in Haskell type inference
> If you forget to provide a type signature, sometimes this rule will fill the free type variables with specific types using "type defaulting"  rules.

>   - ad hoc
>     - **Overloading:** a single identifier denotes several abstractions

type class

>   - universal
>     - **Parametric:** an abstraction operates uniformly across different types

[Polymorphism](https://wiki.haskell.org/Polymorphism)
> Parametric polymorphism refers to when the type of a value contains one or more (unconstrained) type variables, so that the value may adopt any type that results from substituting those variables with concrete types. 
> Since a parametrically polymorphic value does not "know" anything about the unconstrained type variables, it must behave the same regardless of its type.

examples: `id`, `const`, `flip`, `apply`
```haskell
id :: forall a. a -> a
id x = x

const :: forall a b. a -> b -> a
const x _ = x

flip :: forall a b c. (a -> b -> c) -> b -> a -> c
flip f y x = f x y
```

>   - universal
>     - **Inclusion:** an abstraction operates through an inclusion relation

ad-hoc actually, a limited type class mechanism
a finite number of subtypes are settled at the compile time

```typescript
// type predicates
function isNumber(x : any) x is number {
    return typeof x == "number"
}
function isString(x : any) x is string {
    return typeof x == "string"
}

function add(x : any, y : any): number | string {
    if (isNumber(x) && isNumber(y)) {
        return x + y
    }
    if (isString(x) && isString(y)) {
        return x + y
    }
    throw new Error(`Expected both number or string.`);
}
```

```haskell
data Addable
  = AddableNumber Float
  | AddableString String

add :: Addable -> Addable -> Result String Addable
add (AddableNumber x) (AddableNumber y) = Ok $ x + y
add (AddableString x) (AddableString y) = Ok $ x <> y
add _ _ = Err $ "Expected both number or string."
```

```haskell
class Addable a where
  add :: a -> a -> a

instance Addable Float where
  add x y = x + y

instance Addable String where
  add x y = x <> y
  
doubleAddition :: Addable a => a -> a -> a -> a
doubleAddition x y z = add x (add y z)

-- doubleAddition :: String -> String -> String -> String
-- doubleAddition "1" "2" "3" = "123"
-- doubleAddition :: Float -> Float -> Float -> Float
-- doubleAddition 1 2 3 = 6
```

```haskell
id :: forall a. a -> a
id x = x

-- id :: Int -> Int
-- id 1 = 1
-- id :: List String -> List String
-- id ["hello", "world"] = ["hello", "world"]

class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b
```

# Row Polymorphism

extensible records in Purescript
- rows are association list from labels to types
- rows can have duplicate labels
- unification of rows ignores order of different labels,
but preserves order of duplicates
- `row` of `k` is a new kind for every kind `k`
```haskell
add :: forall r. Int -> { count :: Int | r } -> { count :: Int | r }
add x r@{ count } = r { count = count + x }
```

extensible effects in Purescript
```haskell
main
  :: forall e
   . Eff
      ( console :: CONSOLE
      , http :: HTTP
      , fs :: FS
      , buffer :: BUFFER
      , avar :: AVAR
      , redex :: ReduxStore
        ( read :: ReadRedux
        , write :: WriteRedux
        , subscribe :: SubscribeRedux
        , create :: CreateRedux )
      | e )
   Unit
main = do
  log "starting ..."
  store <- mkStore initialState
  runServer defaultOptionsWithLogging {} (app store)
```

functional dependency

[purescript-conveyor](https://github.com/oreshinya/purescript-conveyor)
```haskell
class RowToList
        (row :: # Type)
        (list :: RowList)
        | row -> list

rowToList :: forall proxy r l. RowToList r l => proxy r -> LProxy l
```
type level prolog
```haskell
-- Peano numbers
data Z
data S n

class Succ n m | m -> n
instance succInst :: Succ x (S x)

class Pred n m | m -> n
instance predInst :: (Succ x y) => Pred y x

class Gt x y
instance gt1 :: (Pred x xp, Pred y yp, Gt xp yp) => Gt x y
instance gt2 :: Gt (S x) Z -- base case
```
