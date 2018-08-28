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