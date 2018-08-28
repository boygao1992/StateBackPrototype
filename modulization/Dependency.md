As long as the structure of the object graph is available at compile time (Static Signal Graph), the dependencies (edges in the object graph) can be encoded as Type thus can be guarded by the Type system (through logical proof under the hood).

[javax-intent - JSR-330 Dependency Injection standard for Java](https://github.com/javax-inject/javax-inject)

utilize type annotation system for static analysis and code generation (meta-programming / template programming)

but type annotation system doesn't have a type checking system which is left to be implemented by framework vendors (based on coarse understanding, not as good)

[Dagger 2 slides](https://docs.google.com/presentation/d/1fby5VeGU9CN8zjw4lAb2QPPsKRxx6mSwCe9q7ECNSJQ/edit#slide=id.p)

> Spring: runtime validation of the graph
> Guice: runtime validation of the graph
> Dagger 1:  compile-time validation of portions of the graph
> Dagger 2: compile-time validation of the entire graph



with type classes, by switching one type at the entry of the application, able to switch to a different configuration of dependencies
```haskell
realCode :: forall m. MonadCache m => MonadRequest String m => m String
realCode = requestWithCache "/cache" "https://purescript.org"

class Monad m => MonadCache m where
  read :: String -> m (Maybe String)
  write :: String -> m Unit

class Monad m => MonadRequest req m | m -> req where
  request :: req -> m String

instance appMonadMonadCache :: MonadCache AppMonad where ...
instance appMonadMonadRequest :: MonadRequest AppMonad where ...

realCodeApp :: AppMonad String -- "dependency injection" by Type signature
realCodeApp = realCode -- the same

instance testMonadMonadCache :: MonadCache TestMonad where ...
instance testMonadMonadRequest :: MonadRequest TestMonad where ...

realCodeTest :: TestMonad String -- "dependecy injection" by Type signature
realCodeTest = realCode -- the same
```
by narrowing Types in the Type signature, compiler has enough knowledge to infer the correct implementation to use.


ultimate form:

- DSL by Free Monad ~ type-level Command
- interpreter functions ~ Command Handlers with Type guarantee

comparing to runtime-construct Command
- coordination by identity, usually `String`


Statement: Dependency Injection in OOP is to retrieve some of the Referential Transparency back so that programmers can follow equational reasoning locally.

~~Proof~~

Assumption: IO effects are properly handled (pushed to the boundary of the app, IO layer)

```Java
class ClassName {
  private TypeA a;
  constructor(TypeA a) {...}
  TypeB method() {} // () -> TypeB
}
```
is equivalent to a unary function `f :: TypeA -> TypeB`

```Java
...
  constructor(TypeA a, TypeB b, TypeC c) {...}
  TypeD method() {} // () -> TypeD
...
```
is equivalent to a unary function `f :: (TypeA, TypeB, TypeC) -> TypeD`
where all the arguments in the constructor form a product.

By currying, we know `(a, b, c) -> d` is isomorphic to the following higher-order functions
- `(a, b) -> (c -> d)`
- `a -> ((b,c) -> d)`
- `a -> (b -> (c -> d))`

In FP, currying is done by the compiler automatically so no effort is needed to manually transform between these.

In OOP, thing's a bit hairy because currying has to be done by hand. Either need to 
- have more than one class/object implemented
- or have one class but with multiple constructors for different variants, and use null checks to dispatch to a specific variant (fundamentally, currying)

the latter approach is more common because it takes less code to realize,
but it entangles the currying logic (noise) with domain logic (real meat) so that it's harder to read and error-prone if the number of arguments are huge (the number of variants grows fast).

Builder Pattern is the generalization of this solution which further allows setters to late bind arguments/dependencies, but it forces the variables holding dependencies to be mutable and need runtime logic to guarantee each dependency is supplied only once to regain some determinism.

in summary
1. direct referencing classes in scope as dependencies (terrible, similar to functions referencing variables in the global scope)
2. configure dependencies through constructors (better, referential transparency at class level)
3. late configuration through setters (more flexible and less code to suit all currying variants but less maintainable and more noise around domain logic)


construction of object graph
1. manually `new` correct concrete object and supply to a polymorphic interface
2. concrete factories to pack common configurations
3. configure DI framework to generate factories through annotation post-processing engine.



the only upside (not sure if it is of any practical usage in FP) of class/object model over sole function composition so far is being able to supply the same set of arguments to multiple functions at once, and later able to dispatch any of these argument fulfilled functions by name

inject "environment" => Reader Monad

```haskell
newtype Reader e a = Reader { runReader :: e -> a }

instance Monad (Reader e) where
  return :: a -> Reader e a
  return a = Reader ( \_ -> a )

  (>>=) :: Reader e a -> (a -> Reader e b) -> Reader e b
                   -- postpone supplying the environment e ("lazyness"), like a placeholder
                                        -- assume you have the environment e in hand
                                                  -- m :: Reader e a
                                        -- runReader m :: e -> a
                                        -- runReader m e :: a
                                    -- k :: a -> Reader e b
                                    -- k ( runReader m e) :: Reader e b
                        -- runReader ( k ( runReader m e ) ) :: e -> b
                        -- runReader ( k ( runReader m e ) ) e :: b
                  -- \e -> runReader ( k ( runReader m e ) ) e :: e -> b
         -- Reader e b
  m >>= k = Reader ( \e -> runReader ( k ( runReader m e ) ) e

ask :: Reader e e
ask = Reader id
```

if `a` is a `Record` of functions
```haskell
data Methods = Methods
  { method1 :: b -> c
  , method2 :: d -> e
  , ...
  }
type Object e = Reader e Methods
```
