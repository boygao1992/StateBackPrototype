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



ultimate form:

- DSL by Free Monad ~ type-level Command
- interpreter functions ~ Command Handlers



Statement: Dependency Injection in OOP is to retrieve some of the Referential Transparency back so that programmers can follow equational reasoning locally.

Proof

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

