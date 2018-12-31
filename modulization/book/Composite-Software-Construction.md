[Composite Software Construction - Jean-Jacques Dubray](https://www.infoq.com/minibooks/composite-software-construction)

[WSPER - the specification of an abstract SOA framework](https://www.ebpml.org/wsper/wsper/index.html)

# Chapter 6 - A Composite Programming Model

## Service Metamodel

### Interfaces

> Unlike a class, a service can only expose operations via an interface definition.
> We will see later that a private interface cannot expose any of its operation as part of a component within an assembly.
> An interface may interact with as many roles as necessary as part of an assembly.

### Operations

> one important distinction between an Object Oriented interface and a Service Oriented Interface is that outbound operations are explicit.

> In the OO metamodel, 
> - properties of type class provide a hint of the possible outbound operations that will be invoked, but they are not explicitly called out.
> - OO couples the arguments and signature of a method when classes cooperate as part of a unit of work, which creates a tight coupling between the two classes and leads to the utilization of the adapter pattern

> In a Service Oriented Architecture, services are by definition designed in isolation,
> wsper's assembly mechanism implements a loosely coupled relationship between services using a concept of connectors (which implements data mapping for instance).
