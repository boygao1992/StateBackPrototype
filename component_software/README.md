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
Users are presumably programmers and programs at the runtime.

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
