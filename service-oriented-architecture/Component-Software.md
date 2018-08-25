[Component Software: Beyond Object-Oriented Programming -  Clemens Szyperski](https://www.amazon.com/gp/product/0201745720/)

# Chapter One - Introduction

## 1.1 Component are for composition

> To become a reusable asset, it is not enough to start with a monolithic design of a complete solution and then partition it into fragments.
under-generalization
> Instead, descriptions have to be carefully generalized to allow for reuse in a sufficient number of different contexts.
> Overgeneralization has to be avoid to keep the descriptions nimble and lightweight enough for actual reuse to remain practical.
over-generalization
> Descriptions in this sense are sometimes called components.
definition of components

## 1.2 Components - custom-made versus standard software

### Custom-made software

Pros
- optimally adapted to the user's business model and can take advantage of any in-house proprietary knowledge or practices

Cons
- production from scratch is a very expensive undertaking
- suboptimal solutions in all but the local areas of expertise are likely
- maintenance and "chasing" of the state-of-the-art
- interoperability with other in-house systems and with business partners and customers
- too late to be productive before becoming obsolete

### Standard software

Pros
- the burden of maintenance, product evolution, and interoperability is left to the vendor

Cons
- parametrization and configuration details
- no competitive edge over other competitors using the same software
- not under local control, not able to adapt quickly to changing needs

## 1.3 Inevitability of components

## 1.4 The nature of software and deployable entities

> Software components were initially considered to be analogous to hardware components in general and to integrated circuits (IC) in particular.
> The term software IC and the associated analogy thus fail to capture one of the most distinctive aspects of software as a **metaproduct**.

> Rather than delivering a final product, delivery of software means delivering the blueprints for products.
> Computers can be seen as fully automatic factories that accpet such blueprints and instantiate them.

> Plans can be parametrized, applied recursively, scaled, and instantiated any number of times.
> None of this is possilbe with actual instances.

At runtime, new objects are instantiated to represent incoming information in a predefined encoding.

The undeployed software as a blueprint could be treated as DNA of an organic entity which encodes all the desired behaviors / living strategies to survive in the target environment.
The deployed software as a product then is the instantiated organic entity that is malleable enough to adapt itself to fit the environment but following the blueprint.
A software with dynamic signal graph can extend the programming process (of the DNA) to runtime, where the users are the programmers.
Some meta-models should be laid out in the DNA to establish a minimal contract between the program and the user for initialization of the communication.

A most straight forward example is REPL, for example CodePen.
Users are presumably programmers who write and execute code at the runtime of this software.
The shared knowledge between the user and the software is the syntax and other specifics of the programming language.

Another typical example is editor, such as 3D modeling software, text editors, IDEs, etc.

> Mathematics and logic draw their strength from the isolation of aspects, their orthogonal treatment, and their static capturing.
> These are excellent tools to understand the software concepts of uniformity of resources, arbitrary copying, recursive nesting, parametrization, or configuration.
> However, mathematical modeling fails to capture the engineering and market aspects of component technology ---
> the need to combine all facets, functional and extra-functional, into one interacting whole, forming a viable product.

Not sure what this emphasizes, will see.

> "object" is one of the most indefinite and imprecise terms that people could possibly use to name a concept.

## 1.5 Components are units of depolyment

> "Object orientation has failed but component software is succeeding."

> 1. the definition of objects is purely technical
> briefly, encapsulation of state and behavior, polymorphism, and inheritance.
> The definition does not include notions of independence or late composition.
> their lack has led to the current situation in which object technology is mostly used to construct monolithic applications.

> Most objects have no meaning to clients who are not programmers.
> Objects are rarely shaped to allow for mix-and-match composition by a third party, also known as "plug and play".

> 2. object technology tends largely to ignore the aspects of economics and markets and their technical consequences.

> customers are more interested in products that are obviously useful, easy to use, and can be safely mixed and matched.
> they are not in the least interest in whether or not the products are internally object-oriented.

## 1.6 Lessons learned

> the vision of object markets did not happen.
> most of the few early component success stories were not even object-oriented, although some are object-based.

> component success stories
> - Microsoft's Visual Basic
> - Enterprise JavaBeans (EJB) and COM+

> - all modern operating systems
> Applications are coarse-grained components executing in the environment provided by an operating system.
> Interoperability between such components is as old as the sharing of file systems and common file formats, or the use of pipe-and-filter composition.

> - relational database engines and transition-processing monitors

> - plugin architectures, using finer-grained components
>   with plugins, the client gains some explicable, high-level feature and the plugin itself is a user-installed and configured component
>   - Netscape's Navigator web browsers
>   - Apple's QuickTime
>   - DOS terminate-and-stay-resident applications (TSRs)
>   - Active Server Pages (ASP) and Java Server Pages (JSP) architectures for web servers
>     accepting application-specific plugins into the server to provide
>     server-side computations
>     and web page synthesis to service incoming web requests

> - modern application and integration servers around J2EE and COM+ / .NET

> component exist on a level of abstraction where they directly mean something to the deploying client.
> example: Visual Basic
> a control has a direct visual representation, displayable and editable properties, and has meaning that is closely attached to its appearance

> Dependencies in such a large system need to be managed carefully.
> However, the CommonPoint frameworks exposed far too many details and were only weakly layered (the overall architecture was underdeveloped).

> C++ object model is too fragile as an component model.
> Blackbox reuse was neglected in preference for deep and entangled multiple inheritance hierarchies.
> Finally, overdesign and the C++ template facilities led to massive code bloat.

> For components to be independently deployable, their granularity and mutual dependencies have to be carefully controlled from the outset.

# Chapter Four - What a component is and is not

## 4.1 Terms and concepts

### 4.1.1 Components

> - unit of independent deployment
>   - well separated from its environment and other components
>   - will never be deployed partially (otherwise, not a unit)
> - unit of third-party composition
>   - encapsulate its implementation and interact with its environment by means of well-defined interfaces
>   - third party cannot be expected to have access to the construction details of all the components involved
> - has no (externally) observable state
>   - the component cannot be functionally distinguished from copies of its own
>     - otherwise, no two installations of the "same" component would have the same properties
>   - due to the stateless nature of components, in any given process, there will be at most one copy of a particular component
>   
> This separation of the immutable "plan" from the mutable "instances" is essential to avoid massive maintenance problems.

### 4.1.2 Objects

> - unit of instantiation, it has a unique identity over its lifetime
>   - a construction plan that describes the state space, initial state, and behavior of a new object
>   - or a pre-existing prototype object that can be cloned
> - may have state and this can be externally observable
> - encapsulates its state and behavior

### 4.1.3 Components and objects

> a component is likely to act through objects and therefore would normally 
> - consist of one or more classes or immutable prototype objects
> - might contain a set of immutable objects that capture default initial state and other component resources
> - objects created in a component can leave the component and become visible to the component's clients, usually other components

> Whether or not inheritance of implementations across components is a good thing is the focus of a heated debate between two schools of thought.

> However, there is no need for a component to contain classes only, or even to contain classes at all
> - could contain traditional procedures and even have global (static) variables (as long as the resulting state remains unobservable)
> - may be realized in its entirety using a functional programming approach or using assembly languages, or any other approach

### 4.1.4 Modules

> - can be used to package multiple entities such as ADTs or classes
> - do not have a concept of instantiation
> - unlike classes, modules can be used to form minimal components
>   - example: traditional math libraries, a package of functions
> - no persistent immutable resources that come with a module, beyond what has been hardwired as constants in the code
>   - replacing these resources allows the component to be configured without the need to rebuild the code

> The configuration of resources seems to assign mutable state to a component.
> However, as components are not supposed to modify their own resources, resources fall into the same category as the compiled code that also forms part of a component.

> Adopting component technology requires adoption of principles of independence and controlled explicit dependencies.
> Component technology unavoidably leads to modular solutions.

### 4.1.5 Whitebox versus blackbox abstractions and reuse

> In an ideal blackbox abstraction, clients know no details beyond the interface and its specification.
>
> In a whitebox abstraction, the interface may still enforce encapsuation and limit what clients can do, although implementation inheritance allows for substantial inference.
> However, the implementation of a whitebox is fully available and can thus be studied to enhance the understanding of what the abstraction does.
>
> Grayboxes are those that reveal a controlled part of their implementation.
>
> Blackbox reuse refers to the concept of reusing implementations without relying on anything but their interfaces and specifications.
>
> Whitebox reuse refers to using a software fragment, through its interfaces, while relying on the understanding gained from studying the actual implementation.
>
> Whitebox reuse renders it unlikely that the reuse software can be replaced by a new release since a replacement will probably break some of the reusing clients which directly depend on implementation details that may have changed in the new release.

> A software component is a unit of computation with contractually specified interfaces and explicit context dependencies only.
> A software component can be deployed independently and is subject to composition by third parties.

### 4.1.6 Interfaces

> non-technical aspects
> - the economy of scale has to be kept in mind
> - undue fragmentation of the market has to be avoided as it threatens the viability of components.
> - maximize the reach of an interface specification and components implements this interface

### 4.1.7 Explicit context dependencies

### 4.1.8 Component "weight"

> Instead of constructing a self-sufficient component with everything built in, a component designer may have opted for "maximum reuse".

> Maximizing reuse minimizes use.

## 4.2 Standardization and normalization

### 4.2.1 Horizontal versus vertical markets

### 4.2.2 Standard component world and normalization
