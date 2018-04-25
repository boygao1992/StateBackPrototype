# Problems in Current Frameworks
## CycleJS

1. CycleJS claims that the Main Function is *Pure*, but not really.
  Still need mocking for testing.
  - event listener attach/removal is side effect which is not abstracted away from Main.
  - RxJS Observable has many stateful operators which are declarative (named)  but encapsulate/hide state.
    - MemoryStream / operators with buffers
    - time-related operators

2. Cyclic dependency is painful to handle which destroys scalability.

Why cyclic?

Parent component cannot interpret External Events from Event Listeners attached by its child components which is a reasonable design choice.
To pass interpreted events as messages back to parent component, part of child's sink has to be part of parent's source while part of parent's source is already part of child's source. Thus, parent and child depend on each other.
e.g. TodoMVC, delete button is attached to child components (TodoItem) while the lifecycles of child components are managed by parent component (TodoList). Parent need DELETE event from child to perform the state transition.

[Handling lists in Cycle.js](https://github.com/cyclejs/cyclejs/issues/312)
[Solve memory leak with circular dependencies of streams](https://github.com/cyclejs/cyclejs/issues/257)
[Exploring composition in CycleJS - circular dependencies](http://blog.krawaller.se/posts/exploring-composition-in-cyclejs/)

## ELM

1. state transition function without validation of state

2. state transition functions are directly attached to event handlers, which strongly couples model and view 

3. child-parent message passing need child to expose state getter/lense function to its parent to grant parent access to its state (give it ability to interpret)
  (in OOP, Translator Pattern)

4. node-to-node communication is even worse.
  Need to find a common ancestor and all the ancestor/parent along the way to be aware of the communication.

5. first-order FRP and static signal graph. Separation between Container and Child Component in state management (which is essential for creating General Container Widget) while maintaining the ability to add/remove child components dynamically in runtime is not possible.

![Node-to-Node Message Passing](./doc/node-to-node_message_passing.png "Node-to-Node Message Passing")

### 1. [Scaling The Elm Architecture](https://github.com/evancz/guide.elm-lang.org/tree/master/reuse)

> **We do not think in terms of reusable components.** Instead, we focus on reusable functions.
> we create **reusable views** by breaking out helper functions to display our data.

## SAM

V = State( vm( Model.present( Action( data))), nap(Model))

Moore Machine(?)

1. If nap(next-action predicate, push machine out of intermediate state) is rejected by Model.present, then the entire system gets stuck in an invalid state.
  This means nap() function has to be consistent with Model.present but this type of coordination is error-prone if managed manually.

2. nap() function has to guarantee global validness which is not planned to be componentized. Scalability issue.

3. Modulization pattern in this framework is not clearly stated or ever designed.

## React + Redux

State transition function and Output function are separated into Reducer and Middleware.

1. Middlewares don't compose. Functional specification needed.

2. Reducer can be modulized based on DOM tree's hierarchical structure but then suffer from the same communication problem as ELM. If reducer tree is flattened into a single layer hash map, then global constraints are easy to implement but cyclic dependency are still not properly handled (some parent components know too much).

## Angular2 / Vue

TODO

## Some Progress in the Community
### 1. [scalable-frontend-with-elm-or-redux](https://github.com/slorber/scalable-frontend-with-elm-or-redux)
### 2. [The Rise Of The State Machines](https://www.smashingmagazine.com/2018/01/rise-state-machines/) - [Stent | FSM in JS](https://github.com/krasimir/stent)
Still, Scalability Issues:
- How to divide the state space to reduce the complexity to a certain level in which an average programmer is able to reason about?
- How to compose individual state machines? Communication with network/graph?


# Comparison between Finite State Machine, Actor, FRP, Arrowized FRP, and OOP with Mutation

## Actor

Each actor/coroutine is actually an individual finite state machine (with/without feedback loop).
(Fact: the implementation of goroutine in Clojure is just syntax sugar of a state machine written in Clojure Macro.)

Actors communicating with each other through channels is basically saying that interconnections in the network are explicit by function calls (OOP, yet can be implemented in FP, push/pull functions (setter) have side effects and its state is not explicit nor accessible at any moment but managed by a scheduler) which is more optimal than a total graph in performance.

But the network itself is not part of the program as a monolithic state machine, which means either the network is static, or the evolution of the network can not be traced by the state history.

Post-censor is expressible but too hard to implement in this model because of the implicit state in all the channels with a buffer. 

The benefit of channels is that the wiring between senders and receivers has less manual coordination and thus less error-prone.

Maybe refrained from stateful channels thus only using stateless channels to build up a communication network between state machines is a way to go.
Basically, abstract out the state machine out of each buffer so that the state transformation is explicit and can be traced by the global state history.

[What is the purpose of the state monad?](https://stackoverflow.com/questions/28224270/what-is-the-purpose-of-the-state-monad)

> From what you're describing it seems to me like you're looking for something more along the lines of the **actor model of concurrency**, where state is managed in an actor and the rest of the code interfaces with it through that, retrieving (a non-mutable version of) it or telling it to be modified via messages. In immutable languages (like Erlang), actors block waiting for a message, then process one when it comes in, then loop via (tail) recursion; they pass any modified state to the recursive call, and this is how the state gets "modified".

# Tech & Design Choices

## Message-Passing / Component-Wiring Style

### Actor

- Interactive

Sender-> Receiver (**[ pic ]**)

- Reactive

Sender ->Receiver (**[ pic ]**)

### CSP

Sender ->Mediator(Channel)-> Receiver (**[ pic ]**)

**Benefit**: abstract out dependency/wiring/edge and leave components autonomic and independent from others

## Combinational Logic (acyclic composition)

data flow/dependency/causality

composition by logic gate/operator

**[ pic ]**

## Feedback Loop (cyclic composition)
1. Feedback loop merges the internal dependency/wiring/network into one stream.

2. Able to express cyclic dependency

(unachievable by combinational logic / acyclic composition)
**[ pic ]**

*[cyclic dependency]: can be unfolded into an infinite/varying length acyclic dependency sequence. The infinite length case can be handled by Banach fixed-point theorem which is out of the scope of this project.

3. Unified cyclic/acyclic dependencies

child state machines are in a map

## Top-down thinking of a event-driven system
### General Model of event-driven programming

Approach 1 and approach 2 actually commute.
**[ pic ]**

#### Approach 1
1 Define State Space & State Graph

Define the unified state vector to represent the entire state space of the system.
We start with a total graph in which each node is connected to the other nodes.

1 -> 2 Reshape the State Graph

2 A single connected graph, or multiple isolated/unconnected subgraphs

2 -> 3 Index all the edges with names of the events

All the outgoing edges from a single node in the graph should be indexed/named
differently, otherwise the state machine is non-deterministic.

(optional) add terminal state to the system and all the state may have an edge to the terminal state. These edges to terminal state may have different indices.

3 Event graph

#### Approach 2
1 State Space Definition

1 -> 2 Classify/index all the edges in the graph by names of the events.
Map each index/name to a state transformation function.

2 Annotated Graph

2 -> 3 Reshape the annotated graph by adding guards to state transformation functions to limit the state space each state transformation function dealing with (equivalent to remove edges from the state graph).

3 Event Graph

### Practical Workflow
1. Given a collection of information to be presented in GUI.
2. Build / Have a collection of widgets.
3. Classify / Pack information as payloads to be injected into suitable widgets.
Each widgets are disjoint state machine functioning independently.
Refined the behavior of each widget by adding guards to fulfill local constraints
4. Refine the behavior of groups of widgets by adding guards to fulfill global constraints
5. project manager / UI designer modifies the design
  - some information is packed differently (into different widgets than before)
  - extra information (dispatch to widgets already existed or add new widgets)
  - modify the appearance of some widgets (not a big deal)
  - modify the behavior of some widgets
  - replace some widgets entirely by other implementations
  - extra behaviors on a group of widgets (may get packed into a new container)
  
### Indexing / Classification Strategy

#### Staged Computation / action decomposition (Hierarchical State Machines)
Categorized by one variable/dimension

#### Parametrization
Index a set of edges (from a set of states to a set of states) by the same event name.


## State Refinement

**Guard can be factored out of state transition**

Used to incrementally refine the state following some global constraints.

1. Pre Censor

**Remove indexed edges from the state graph**

Listening to (External) Messages

Filtered out Messages/Inputs for components based on Global Constraints

2. Regulator

i) pull back <=> pre-censor (so don't use it this way)

ii) push forward <=> **move the index on a outgoing edge of a given node to a different outgoing edge**

Listening to (Internal) Messages which indicate State Update in any component.

Push forward / Roll back the component's state to next/last intermediate state based on Global Constraints

3. Post Censor

**Remove nodes and associated edges from the state graph**

After the state transition in this tick/step is done ( no more Internal Messages received), Post Censor checks if the system is in a valid state.
If not, roll back to previous valid state.

*All intermediate states are invalid states and should not be observed by external observers.

4. Guard
Guard are constraints on local states.

### Case Study
#### 1. push forward
#### 2. pull back

## Guard

Higher-order combinational logic with variables

### AND/OR Table

**[ pic ]**


## Separation of Internal Representation and External Representation
This framework is ought to be general for both Frontend and Backend application.

1. Model

Minimal amount of information that will be presented in different formats and sent to External World through corresponding Drivers.

Compensate Models
  - View Model ( DOM )

  Strictly view-related only. Parametrize the View(template) Function.

  e.g. Color, Opacity, Font, Coordinates, Layer etc.

  Targeting different platforms.

  e.g. Console (Terminal App), Mobile (IOS, Android), Hybrid(React Native, Cordova)

  Will be shipped with (pure) View Function in View Container/Component library.
  - Network Model ( HTTP(S)/WebSocket )

  Client-related states are stored in Model but protocol-related information like Server-Client Message Schema, Communication Encryption Method, etc. should be presented in HTTP Model.

2. View

A function that transforms internal representation (Model) to external representation (DOM, HTTP, Mobile, etc.).

For example, DOM View maps the hash map of Model into a tree.

general view container/component library
general model testing/prototyping purpose view function

### Case

## Extended Finite State Machine

### time constraints

## Self-adaptive

[Multiple Levels in Self-adaptive Complex Systems: A State-Based Approach](https://arxiv.org/abs/1209.1628)

[An Approach to Self-Adaptive Software based on Supervisory Control](http://www.isis.vanderbilt.edu/sites/default/files/Karsai_G_5_0_2001_An_Approac.pdf)

In order to sustain the clear separation between Parent and Child components (state machines) where Parent manages the lifecycles of its children including their behaviors (State Transition Function is swappable dynamically during the runtime), the dependency network is no longer static which needs a second-order state machine.

## State Machine Composition
1. Cascade Composition / Sequencing ( 2 sequential dependent tasks)

signal passing

**[ pic ]**

2. Synchronous Parallel/Side-by-side Composition / Intersection ( n independent tasks, n >= 2)

signal broadcasting

**[ pic ]**

3. Feedback Loop / Repetition

4. Switch / Choice ( Hierarchical State Machine, add guards before each State Machine)

These composition logic will be implemented by Writer Monad, Monoid, ChainRec Monad, Fixed-point Monad.

### Reader Monad
### Writer Monad
### Monoid
### ChainRec

### F-Algebra, Fixed-point data type (Fix), recursive function

[Understanding F-Algebras](https://www.schoolofhaskell.com/user/bartosz/understanding-algebras)

[Haskell/Fix and recursion](https://en.wikibooks.org/wiki/Haskell/Fix_and_recursion)
The Fix data type cannot model all forms of recursion.

[purescript-fixed-points](https://pursuit.purescript.org/packages/purescript-fixed-points/4.0.0)

# State Graph Model

### i. Extended Finite State Machines
Like any other user interface, 3D modeling systems are typical event-driven systems which can be precisely described by Finite State Machines (FSM).
States and State Transitions are denoted by unique symbols in an algebraic/formal system.
Then we end up with a directed total graph of state space where vertices are states and directed edges between each pair of distinct vertices are state transitions.

As the complexity of the system increases the number of discrete states grows exponentially so we need Extended Finite State Machines (EFSM) which allow parametrization as an effective state space compression technique.
By parametrization, a set of states can be described by one or many variables.
An unique combination of specific values in all variables is a unique symbol itself and can be mapped back to each unique state in the original finite state machine.
This way we no longer need to deal with a large number of plain discrete states but a number of discrete or continuous variables which can be further abstracted by types.

> Two primitive types are Integer and String, both of which can be mapped to natural number set.
> Two famous constructs of natural number set are Von Neumann Ordinals and Church Numerals.
> Then with Boolean Algebra, we can represent a finite subset of the natural number set using combinational logic circuits.

> With higher-order abstraction, Dependent Type, from type theory, each type can be precisely crafted by ruling out a set of values using logical constraints so that a set of invalid states are irrepresentable by the combinations of these types.

At this point, we can update our state space representation using a vector to denote each state with a set of variables.

### ii. Event-driven System Design
With the formal system / EFSM defined, programmers or domain experts add semantics to the system by mapping each state or state Transition to a scenario or a signal/action respectively in the real system which usually described also by a formal system.
Because of the limitation in human's working memory, programmers and users can only deal with a small set of objects at a time.
Therefore, before or during the process of indexing states and state transitions by comprehensible names, usually large state space needs to be preprocessed by state space partition/classification, basically indexing/naming states or state transitions with human-readable Strings.

### iii. State Space Partition Techniques

#### 1. Horizontal Split
Horizontal Split of state space means grouping all the variables in the state vector into disjoint sets.
Each subspace after the horizontal split is still a total graph with the same number of vertices as the original but with lower dimensionality.
Then the state transition functions in each subspace can deal with lower number of variables.

For a UI system, the horizontal split usually means dividing the monolith system into independent widgets/subsystems (for analytic purpose, which is likely the opposite way to construct a UI system in practice).
Each widget embeds an extended finite state machine whose state vector only has a small number of variables.

#### 2. Vertical Split
Vertical Split of state space means grouping all the state vectors into disjoint sets based on rules each of which involves an arbitrary number of dimensions.
The subspace left untouched by the rule set can be automatically named "Otherwise"/"Rest".
Each subspace after the vertical split is still a total graph with the same dimensionality as the original but with lower number of vertices.

In each subspace, some information may no longer be needed and can be thrown away based on some sequential ordering.
In our formal representation, this means that the edges between two subspaces after a vertical split is directed only from one to the other, not the other way around.
Thus, after a vertical split, each subspace can have its own state vector representation instead of using the global state vector.

For example, in a transition system, after confirmation of credit card info and generation of an order number, the card info related variables (e.g. card number, address, etc.) are no longer useful.
However, if the system requires certain degree of fault tolerance, the card info then should not be thrown right after the confirmation because the transition may fail and the card info need to be presented and modified by the user for another try.

#### 3. Hierarchical Composition

##### Hierarchical Finite State Machine (HFSM)
HFSM requires a horizontal split on the state space and construct state transition functions in each subspace.
When constructing the HFSM, a vertical split is conducted first and some of the state transition functions from the horizontal split can be reused directly or with slight modification (usually parametrized) across these vertically partitioned subspaces, which will reduce a fair amount of boilerplate in code base. 

##### Behavior Tree (BT)
State space is hierarchically classified into subspaces using vertical splits.

# Overall Architecture

Mealy Machine + Synchronous Composition + Feedback + Explicit Side Effects

## Driver
Represent side effects by data, push them out of the main logic, and let the drivers to interpret the Effs.
Like a Domain Specific Language (DSL).
Can be naturally implemented by Free Monad.

1. DOM Driver
2. HTTP Driver (WebSocket Driver)
3. Time Driver
4. Database Driver
  ![Abstract out IO Effects by Drivers](./doc/io-eff-by-drivers.png "Abstract out IO Effects by Drivers")

### Time Driver
1 Global Clock / n Local Clocks

I guess Global Clock is better for animation.

### Free / CoFree
#### 1.[Free from Tree & Halogen VDOM](https://www.youtube.com/watch?v=eKkxmVFcd74)

Core primitives to model any recursive types, which means you can build Mu/Nu (fixed-point data type) out of Free/CoFree. 
Mathematically equivalent but may not be optimal for performance because of the structural overhead (e.g. extra wrapping which takes more memory and of course extra unwrapping).
It's like trading performance for generality so that you can get all the operators for free.

Two different types of Trees.

Substitute a Functor into Free/CoFree, you can derive a Monad/CoMonad.

Used to build AST and Interpreter.

**One usage is to turn Effects into data/AST.**
Which is exactly what I need.
- time travel: state + effects
- hot reload (S-[B]) with security

#### 2.[Free for DSLs, cofree for interpreters](http://dlaing.org/cofun/posts/free_and_cofree.html)

#### 3.[DrBoolean/freeky](https://github.com/DrBoolean/freeky)

#### 4. Free play
[Free play - part 1](http://therning.org/magnus/posts/2016-01-13-000-free-play--part-one.html)

[Free, take 2](http://therning.org/magnus/posts/2016-06-18-free--take-2.html)

#### 5.[A Modern Architecture for FP](http://degoes.net/articles/modern-fp)

#### 6.[The Free Monad Interpreter Pattern](https://blog.otastech.com/2016/01/the-free-monad-interpreter-pattern/)

#### 7.[Why free monads matter](http://www.haskellforall.com/2012/06/you-could-have-invented-free-monads.html?m=1)

### Existing Examples in JS
#### 1.[Elm-Effects](https://guide.elm-lang.org/architecture/effects/) / [Type Reference](http://package.elm-lang.org/packages/evancz/elm-effects/2.0.1/Effects)

#### 2.[Cyclejs Drivers](https://cycle.js.org/drivers.html)

#### 3.[Redux-Saga](https://github.com/redux-saga/redux-saga)

[Closed Issue: redux-saga is a lot like an IO monad](https://github.com/redux-saga/redux-saga/issues/505)

#### 4.[Redux-Loop](https://github.com/redux-loop/redux-loop)

#### 5.[Redux-Cycles](https://github.com/cyclejs-community/redux-cycles)

### Potential Issues of Drivers/FreeMonads

1. no helpful information from stack traces

#### 1.[Practical Principled FRP](https://github.com/beerendlauwers/haskell-papers-ereader/blob/master/papers/Practical%20Principled%20FRP%20-%20Forget%20the%20past,%20change%20the%20future,%20FRPNow!.pdf)

I/O in FRP The second problem with Fran is that interaction with the outside world is limited to a few built-in primitives: there is no general way to interact with the outside world. Arrowized FRP does allow general interaction with the outside world, by organizing the FRP program as a function of type `Behavior Input → Behavior Output`, where Input is a type containing all input values the program is interested in and Output is a type containing all I/O requests the program can do. This function is then passed to a wrapper program, which actually does the I/O , processing requests and feeding input to this function. This way of doing I/O is reminiscent of the stream based I/O that was used in early versions and precursors to Haskell, before monadic I/O was introduced. It has a number of problems (the first two are taken from Peyton Jones [10] discussing stream based I/O ):

- It is hard to extend: new input and output facilities can only be added by changing the Input and Output types, and then changing the wrapper program.

- There is no close connection between a request and its corresponding response. For example, an FRP program may open multiple files simultaneously. To associate the result of opening a file to its the request, we have to resort to using unique identifiers.

- All I/O must flow through the top-level function, meaning the programmer must manually route each input to the place in the program where it is needed, and route each output from the place where the request is done.

Other FRP formulations partially remedy this situation[1, 21], but none overcome all of the above issues. We present a solution that is effectively the FRP counterpart of monadic I/O . We employ a monad, called the Now monad, that allows us to (1) sample behaviors at the current time, and (2) plan to execute Now computations in the future and (3) start I/O actions with the function:

```haskell
async :: IO a → Now (Event a)
```

which starts the IO action and immediately returns the event associated with the completion of the I/O action. The key idea is that all actions inside the Now monad are synchronous 2 , i.e. they return immediately, conceptually taking zero time, making it easier to reason about the sampling of behaviors in this monad. Since starting an I/O action takes zero time, its effects do not occur now, and hence async does not change the present, but “changes the future”. Like the I/O monad, the Now monad is used to deal with input as well as output, both via async. This approach does not have the problems associated with stream-based IO, and is as flexible and modular as regular monadic I/O.

#### 2.[Free monad considered harmful](https://markkarpov.com/post/free-monad-considered-harmful.html)

1. Inspection
2. Efficiency
3. Composability

A better solution - type classes in Haskell

So we want to be able to interpret a monadic action in different ways, inspect/transform it, etc. Well, Haskell already has a mechanism for giving different concrete meanings to the same abstract (read polymorphic) thing. It’s called type classes. It’s simple, efficient, familiar, composable, and if you really want to build data structures representing your actions to do whatever you want with them, guess what… you can do that too.

[The ReaderT Design Pattern - Avoid WriterT, StateT, ExceptT](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern)

#### 3.[Typed final (tagless-final) style](http://okmij.org/ftp/tagless-final/index.html)
[Typed Tagless Final Interpreters](http://okmij.org/ftp/tagless-final/course/lecture.pdf)

#### 4.[Monad transformers, free monads, mtl, laws and a new approach](https://ocharles.org.uk/blog/posts/2016-01-26-transformers-free-monads-mtl-laws.html)

#### 5.[3 approaches to monadic api design in haskell](https://making.pusher.com/3-approaches-to-monadic-api-design-in-haskell/)

- Concrete monads
- Monad typeclasses

Issues with typeclasses

The types become more complicated.
compiler errors can be much harder to understand.
Potentially performance issue (may already be solved by inlining).

- Free/operational monads

This is nice because it **decouples** the **logic** from the means of performing the **effects**. Another advantage is that it allows different interpreters to be written for different purposes; this would be particular useful when writing **tests**.

However this approach comes with similar problems as mtl. It also has the disadvantage of being less widely used/understood at the moment.

Furthermore it means that the caller of the library will likely need to write more code because they have to implement the interpreter. For more complex libraries, this may be worth it, but for simple things like writing a client library for a web API, it is most likely overkill.

#### 6.[mtl is Not a Monad Transformer Library](https://blog.jle.im/entry/mtl-is-not-a-monad-transformer-library.html)

# DOM Component Library

Framework-independent & composable

## Container

1. spring grid system (draggable)
2. waterfall
3. notification/modal
4. scroll lazy load
5. Router / Page with Navigator

## Component

1. table
2. tree (collapse)
3. graph
4. (video/soundtrack) media player
5. (geo) map
6. time
7. image viewer
8. text editor (container? DOM tree inside)
9. text area with annotation (hidden, collapse)

# Examples

## Cyclic-dependent Buttons
## Autocomplete Input Box
## TodoList
## Container with different types of Draggable Components
## Drag-and-drop among multiple Containers

# TODO (unsettled design choices)

## State Vector Type Construct

### 1.[Structured TodoMVC example with Elm](https://github.com/rogeriochaves/structured-elm-todomvc/)

> - [NoMap approach with Domain focus](https://github.com/rogeriochaves/structured-elm-todomvc/tree/nomap-domain)
> - [NoMap approach with Technical focus](https://github.com/rogeriochaves/structured-elm-todomvc/tree/nomap-technical)
> - [OutMsg approach](http://folkertdev.nl/blog/elm-child-parent-communication/)
> - [Translator approach](https://medium.com/@alex.lew/the-translator-pattern-a-model-for-child-to-parent-communication-in-elm-f4bfaa1d3f98)


## Input/Event Space Partition
1. Event Type definition
2. Organization of Event Indices/Names

### 1.[An  Industrial  Study  of  Applying  Input  Space Partitioning to Test Financial Calculation Engines](https://cs.gmu.edu/~offutt/rsrch/papers/calcengine.pdf)

> This paper presents result from an industrial study that applied input space partitioning and semi-automated requirements modeling to large-scale industrial software, specifically financial calculation engines.

## Model Checking (Rule-based System / Logic Programming)

### 1.[Architecture for logic programing with arrangements of finite-state machines](http://ieeexplore.ieee.org/document/7588297/)

### 2.[Verification of Conflicition and Unreachability in Rule-based Expert System with Model Checking](https://arxiv.org/pdf/1404.2768.pdf)

> 3.2 UPPAAL
> UPPAAL can verify systems that can be modeled as networks of timed automata (TA) expanded with structured data types, integer variables, and channel synchronization.
> A finite state machine expended by clock variables is a TA.

> UPPAAL expands the definition of TA with extra characteristics:
> - Templates
> - Global Variables
> - Expressions
> - Edges
>   - Select
>   - Guard
>   - Synchronization
>   - Update

### 3.[Rule-based Machine Learning - Wikipedia](https://en.wikipedia.org/wiki/Rule-based_machine_learning)

[Where machine learning meets rule-based systems - Hacker News](https://news.ycombinator.com/item?id=14717692)

## Stateful HTML Elements handling for performance

1. Text Entry Box
2. Slider
3. Selector

may represented by continuous-time model?
(e.g. [@funkia/turbine](https://github.com/funkia/turbine)
[@funkia/hareactive](https://github.com/funkia/hareactive))

## State Store as Database

1.[Using the Redux Store Like a Database](https://hackernoon.com/shape-your-redux-store-like-your-database-98faa4754fd5)

2.[gist - Most efficient way to store domain state in Redux (Indexed Key-Value Store)](https://gist.github.com/sikanhe/9b940ce866d78354bba3)

## Event Handler as Data

1. [Emerging Patterns in JavaScript Event Handling](https://www.sitepoint.com/emerging-patterns-javascript-event-handling/)

## Serialization of Functions

1. [JavaScript's eval() and Function() constructor](http://dfkaye.github.io/2014/03/14/javascript-eval-and-function-constructor/)

## State Transitions as Events

## API Complexity
### 1.[The MNP Problem of Distributed Computing](https://www.ebpml.org/blog2/index.php/2014/12/27/the-mnp-problem-of-distributed)

MNPT Problem:
An architecture with M **clients**, invoking N **remote operations**/actions which can each have P **versions** and involves data fetching from T **systems of records** / micro-services, ends up with MNPT **communication paths**.

I would personally support any approach where:
- operations are explicit (machine readable contracts, generated clients)
- an interface can change while remaining compatible (when possible) with existing consumers which are not immediately interested in consuming that change (that should limit the number of versions in production to 3 or less)
- an architecture where operations are not hard wired to the systems of record since you want to be in the position to 
  - control how changes from the systems of record propagate to the operation's contract
  - add new systems of record in the future without asking your clients to change anything

There are 3 approaches to distributed computing which are not interchangeable and solve different kinds of problems:
- Consumer-System of Record (a.k.a Point-to-Point)
- Event-Driven (this pattern is more often used in system-to-system communication than consumer-to-system of record)
- Service Oriented

All I know is that the worst way to deal with that problem is to use a point-to-point approach.
Each time a consumer communicates directly with a system of record, you are using a "point-to-point" integration pattern, wiring consumers to the integration points of the system of record.
That is the root of all problems in distributed computing where the number of components is greater than two.
That is why RPC fails, that is why CORBA or EJB were too "brittle" because any change in the system impacted too many communication paths.
And to minimize impact, you respond to change by creating more integration points (or microservices if you like that term better), hence more communication paths.
That is the definition of a runaway system.

Personally, I prefer a "Service-Oriented" approach where the consistency responsibility is given to a 3rd party component exposing an intentional and versionable interface because that logic does not belong to the consumer or the system of record.


## Debugging Complexity

### 1.[Debugging Go Routine leaks](https://blog.minio.io/debugging-go-routine-leaks-a1220142d32c)

Daily code optimization using benchmarks and profiling in Golang - Gophercon India 2016 talk - 
[article](https://medium.com/@hackintoshrao/daily-code-optimization-using-benchmarks-and-profiling-in-golang-gophercon-india-2016-talk-874c8b4dc3c5)
/ [youtube](https://www.youtube.com/watch?v=-KDRdz4S81U)

## Continuous-time Model Representation

### 1.[State-space representation - Wikipedia](https://en.wikipedia.org/wiki/State-space_representation)

control engineering

a mathematical model of a physical system as a set of input, output and state variables related by **first-order differential equations** or difference equations.

State variables are variables whose values **evolve through time** in a way that depends on the values they have at any given time and also depends on the externally imposed values of input variables.

Output variables’ values depend on the values of the state variables.
(Moore Machine?)

### 2.[Youtube - The simple essence of automatic differentiation - Conal Elliott](https://www.youtube.com/watch?v=Shl3MtWGu18&t=1083s)

### 3.[Youtube - You Should Be Using Automatic Differentiation - Ryan Adams (Twitter & Harvard)](https://www.youtube.com/watch?v=sq2gPzlrM0g&t=1314s)

## OOP missing features

1. Multiple Dispatch

Overloaded functions dispatch based on runtime subtypes.

OOP: class-based Single Dispatch (Function Dispatch doesn't enforce subtyping)

Visitor Pattern: reverse caller-callee once called for a extra Single Dispatch, called Double Dispatch
 (two calls: A call B to get subtype of A, then B call A to get subtype of B, then the end function have subtypes from both A and B)
 
Strong coupling between concrete Visitor classes and subtypes of B.
(Adding/Removing subtypes from B will cause a reimplementation of Visitor.)

2. Unit ()

OOP: Void, lead to functions not pure nor composable.

3. Type Alias

> data - creates new algebraic type with value constructors
> - Can have several value constructors
> - Value constructors are lazy
> - Values can have several fields
> - Affects both compilation and runtime, have runtime overhead
> - Created type is a distinct new type
> - Can have its own type class instances
> - When pattern matching against value constructors, WILL be evaluated at least to weak head normal form (WHNF) *
> - Used to create new data type (example: Address { zip :: String, street :: String } )
>
> newtype - creates new “decorating” type with value constructor
> - Can have only one value constructor
> - Value constructor is strict
> - Value can have only one field
> - Affects only compilation, no runtime overhead
> - Created type is a distinct new type
> - Can have its own type class instances
> - When pattern matching against value constructor, CAN be not evaluated at all *
> - Used to create higher level concept based on existing type with distinct set of supported operations or that is not interchangeable with original type (example: Meter, Cm, Feet is Double)
>
> type - creates an alternative name (synonym) for a type (like typedef in C)
> - No value constructors
> - No fields
> - Affects only compilation, no runtime overhead
> - No new type is created (only a new name for existing type)
> - Can NOT have its own type class instances
> - When pattern matching against data constructor, behaves the same as original type
> - Used to create higher level concept based on existing type with the same set of supported operations (example: String is [Char])
    
C# only supports `type` with `using`

4. Advanced Pattern Matching

[Match Me if you can: Swift Pattern Matching in Detail.](https://appventure.me/2015/08/20/swift-pattern-matching-in-detail/)

> - Wildcard Pattern (`_`)
> - Identifier Pattern (Concrete Value)
> - Value-Binding Pattern (Destructuring into Variables)
> - Tuple Pattern (Product Type)
> - Enumeration Case Pattern (Sum Type, not strict about Totality, support recursion i.e. Recursive Enumerations)
> - Type-Casting Patterns (Runtime/Dynamic Subtypes, Foreign data)
> - Expression Pattern (`~=` operator, e.g. Int ranges `0..9`)
> - Fallthrough (default break in swtich), Break, and Labels

# Reference

## Automata
- [Turing Machine](https://en.wikipedia.org/wiki/Turing_machine)
- [Pushdown Automata (PDA)](https://en.wikipedia.org/wiki/Pushdown_automaton)

FSM with Buffer/History

- [Sequential Logic](https://en.wikipedia.org/wiki/Sequential_logic)
/ [Finite State Machine](https://en.wikipedia.org/wiki/Finite-state_machine)
- [Combinational Logic](https://en.wikipedia.org/wiki/Combinational_logic)

### 1.[EECS149 - Chapter 5: Composition of State Machines](https://chess.eecs.berkeley.edu/eecs149/lectures/CompositionOfStateMachines.pdf)

### 2.[Building Finite State Machines](http://www.dcs.ed.ac.uk/home/mic/FiniteStateMachines2-slides.pdf)

### 3.[State Machines for Event-Driven Systems](https://barrgroup.com/Embedded-Systems/How-To/State-Machines-Event-Driven-Systems)

### 4.[Introduction to Hierarchical State Machines (HSMs)](https://barrgroup.com/Embedded-Systems/How-To/Introduction-Hierarchical-State-Machines)

### 5.[Transition system](https://en.m.wikipedia.org/wiki/Transition_system)
A labelled transition system is a tuple `(S, Λ, →)` where `S` is a set of states, `Λ` is a set of labels and `→` is a set of labelled transitions (i.e., a subset of `S × Λ × S`).

a labeled transition system is equivalent to an abstract rewriting system with the indices being the labels

[Uniform Labeled Transition Systems for Nondeterministic, Probabilistic, and Stochastic Process Calculi](https://arxiv.org/abs/1108.1865)

### 6.[Abstract rewriting system](https://en.m.wikipedia.org/wiki/Abstract_rewriting_system)

### 7.[Microsoft: The Abstract State Machines Method for High-Level System Design and Analysis](http://pages.di.unipi.it/boerger/Papers/Methodology/BcsFacs07.pdf)

Design
- Ground model constuction
- Model refinement
- Model change

Analysis
- Mathemetical verification
- Experimental validation

### 8.[State Space Representations of Linear Physical Systems](http://lpsa.swarthmore.edu/Representations/SysRepSS.html)

## Behavior Tree

### 1.[Behavior Trees in Robotics and AI: An Introduction](https://arxiv.org/abs/1709.00084)

### 2.[How Behavior Trees Modularize Hybrid Control Systems and Generalize Sequential Behavior Compositions, the Subsumption Architecture and Decision Trees](http://michelecolledanchise.com/tro16colledanchise.pdf)

### 3.[Algorithmic State Machine (ASM) - Wikipedia](https://en.wikipedia.org/wiki/Algorithmic_state_machine)

### 4.[DRAKON charts - Wikipedia](https://en.wikipedia.org/wiki/DRAKON)

## General Web Component/Container

### 1.[How to Build the Ultimate Reusable Web Chat Component](https://medium.com/outsystems-engineering/how-to-build-the-ultimate-reusable-web-chat-component-c9acf3dc5f2b)

### 2.[This SVG always shows today's date](https://shkspr.mobi/blog/2018/02/this-svg-always-shows-todays-date/)

## CSS
### 1.[Modern CSS Explained For Dinosaurs](https://medium.com/actualize-network/modern-css-explained-for-dinosaurs-5226febe3525)

## Dependent Type

May use dependent type to further restrict the state space so that invalid states are not representable.

Able to modify the type rules in runtime which aligns well with hot reloading / behavior adapting.

- Idris
- Agda
- ATS (with Linear Type)
- F*(fstar)

[Implementing State-aware Systems in Idris](http://docs.idris-lang.org/en/latest/st/introduction.html)

[State Machines All The Way Down: An Architecture for Dependent Typed Applications](https://www.idris-lang.org/drafts/sms.pdf)

## Concurrent Models of Computation

### 1.[Introduction to Embedded Systems: a Cyber-Physical Systems Approach](http://leeseshia.org/releases/LeeSeshia_DigitalV1_08.pdf)

#### Event Sequence

Only care about the sequence of ticks while the physical time at which the ticks occur is irrelevant.

1. Synchronously Reactive Model

The reaction of all actors are simultaneous and instantaneous at each of a sequence of ticks of a global clock.

2. Synchronous Dataflow Model (SDF)

SDF actors are constrained to produce the same number of output tokens on each firing.
  - need scheduling polices that deliver bounded buffers
  - need Delay actor (produce an initial output token without having any input token available) to prevent deadlock (insufficient tokens to satisfy any of the firing rules of the actors in a directed loop)

![synchronous-dataflow](./doc/synchronous-dataflow.png "SDF actor")
All tokens that A produces are consumed by B if and only if the following balance equation is satisfied:
![q_AM=q_BN](./doc/math/SDF01.png "q_A M = q_B N")

3. Dynamic Dataflow Model (DDF)

DDF actors support conditional firing.
  - Select Actor
  - Switch Actor

Select and Switch Actor are dataflow analogs of **goto** statement in imperative programming.

Bounded buffers and deadlock are undecidable for DDF models.(Buck 1993)

4. Structured Dataflow (constrained DDF)

A higher-order actor called Conditional is introduced, which has one or more models as parameters.

When Conditional fires, it consumes one token from each input port and produces one token on its output port, so it is an SDF actor.

![structured-dataflow](./doc/structured-dataflow.png "Structured dataflow approach to conditional firing")
The action of Conditional depends on the value of the token that arrives from B: if that value is true, then actor C fires, otherwise actor D fires.

5. Process Network (PN)

Processes in a PN are called **Coroutines**.

Blocking reads and nonblocking writes. Such interaction between processes is called **Rendezvous**. 

Boundness of buffers and deadlock are also undecidable.

6. Communication Sequential Process (CSP)

A variant of PN.

Reads and writes are both blocking.

e.g. Go Lang, Clojure (core.async), Javascript (JS-CSP)

goroutine <= Coroutine

Go Channel: All operations on unbuffered channels block the execution until both sender and receiver are ready to communicate.

#### Timed Model of Computation

1. Time-triggered Model

Computations are coordinated by a global clock as in SR MoC but computations take time instead of simultaneous and instantaneous.

Each computation in time-triggered MoCs is associated with a logical execution time.

The inputs to the computation are provided at each tick of the global clock, but the outputs are not visible to other computations until the next tick of the global clock.
  - no race condition

  Between ticks, no interaction between computations.

  - no difficulties with feedback loop

  Computations are not instantanous in each tick but can take multiple ticks.

The computations are tied closely to a periodic clock (whose frequency is decided by global execution time) which makes the model awkward when actions are not periodic.

2. Discrete-Event (DE) System

Events are endowed with a **time stamp**. Distinct time stamps must be comparable.

DE system is a network of actors where each actor reacts to input events in time-stamp order and produces output events in time-stamp order.

To execute a DE model, we can use an **event queue**, which is a list of events sorted by time stamp.

e.g. Event Loop in Javascript

[Basics of parallel programming with Swift](https://medium.com/flawless-app-stories/basics-of-parallel-programming-with-swift-93fee8425287)

[The Android Event Loop](http://mattias.niklewski.com/2012/09/android_event_loop.html)

3. Continuous-Time System

Time continuum can only be approximated on digital computers but the continuous-time model preserves the exact dynamics which is similar to the purpose of Scalable Vector Graphics so that you can adjust the precision to match your need.

The approximate execution of a continuous-time model is accomplished by a solver with static/variable step size (may take into account the slope of the curve). e.g. Forward Euler, ODE45

A continuous-time model can be viewed as an **SR model** with a time step between global reaction determined by a solver.
Specifically, a continuous-time model is a network of actors, each of which is **a cascade composition of a simple memoryless computation actor and a state machine**, and actor reactions are **simultaneous and instantaneous**.
Thus, the mechanisms required to achieve a continuous-time model of computation are not much different from those required to achieve SR and DE.

### 2.[LuaCSP Reference Manual](http://htmlpreview.github.io/?https://github.com/loyso/LuaCSP/blob/master/doc/html/LuaCSP.html)


## Arrowized FRP

### 1. Euterpea: From signals to symphonies
  [Youtube](https://www.youtube.com/watch?v=xtmo6Bmfahc)

![causal commutative arrows](./doc/from-Euterpea-video.png "Causal Commutative Arrows")

### 2. Causal Commutative Arrows and Their Optimization
[Paper](http://haskell.cs.yale.edu/wp-content/uploads/2012/06/FromJFP.pdf) 
[Youtube](https://vimeo.com/6652662)

Causal Commutative Normal Form(CCNF):
- A pure arrow, or a single loop containing one pure arrow and one initial state
- Transition only based on abstract laws without committing to any particular implementation.

### 3. Causal Commutative Arrows Revisited
[Paper](https://www.cl.cam.ac.uk/~jdy22/papers/causal-commutative-arrows-revisited.pdf) 
[Youtube](https://www.youtube.com/watch?v=bnFHYsL4QNc) 
[Github](https://github.com/yallop/causal-commutative-arrows-revisited)

### 4. [Yampa](https://wiki.haskell.org/Yampa#Primitive_signal_functions)

### 5. [Henrik Nilsson - ITU FRP2010 Lecture](http://www.cs.nott.ac.uk/~psznhn/ITU-FRP2010/)

#### Lecture 01
FRP Variants
- Classic FRP
  First class signal generators.
- Extended Classic FRP
  First class signal generators and signals
- Yampa
  First class signal functions, signals and secondary notion
- Elerea
  First class signals and signal generators

![frp-central-notions](./doc/frp-central-notions.png "Central Notions")

Causality Requirement
  output at time *t* must be determined by input on interval [0,t].

Signal Function Purity
- Pure/Stateless
  if output at time *t* only depends on input at time *t*.
  or if *y(t)* depends only on *x(t)*
- Impure/Stateful
  if output at time *t* depends on input over the interval [0,t].
  of if *y(t)* depends on *x(t)* and *state(t)*
  where *state(t)* summarizes input history *x(t')*, *t' \in [0,t]*

##### Classic FRP
![Signal, Time-varying value: Signal a ~~ Time -> a. Signal Generator, maps a start time to a Signal: SG a ~~ Time -> Signal a. Signal Function, maps a signal to a signal: SF a b ~~ Signal a -> Signal b](./doc/classic-frp-central-abstractions.png "Classic FRP Central Abstractions")
Classic FRP Behavior Examples:
![classic-frp-behavior-examples](./doc/classic-frp-behavior-examples.png "Classic FRP Behavior Examples")

|                    7                     |                   time                   |                   (+)                    | lift1 :: (Real -> Real) -> (B Real -> B Real) |                 integral                 |
| :--------------------------------------: | :--------------------------------------: | :--------------------------------------: | :--------------------------------------: | :--------------------------------------: |
| ![cfrp-behavior-exapmle01](./doc/cfrp-behavior-example01.png "CFRP Example 01") | ![cfrp-behavior-exapmle02](./doc/cfrp-behavior-example02.png "CFRP Example 02") | ![cfrp-behavior-exapmle03](./doc/cfrp-behavior-example03.png "CFRP Example 03") | ![cfrp-behavior-exapmle04](./doc/cfrp-behavior-example04.png "CFRP Example 04") | ![cfrp-behavior-exapmle05](./doc/cfrp-behavior-example05.png "CFRP Example 05") |

Classic FRP Event Examples:
![classic-frp-event-examples](./doc/classic-frp-event-examples.png "Classic FRP Event Examples")

### 6. [Functional reactive programming - Johannes Kepler University 2012](http://lambdor.net/wp-content/uploads/2012/06/2012%20-%20Functional%20Reactive%20Programming%20-%20Gerold%20Meisinger.pdf)
- Programming Paradigms
  ![programming-paradigm](./doc/programming-paradigms.png "Programming Paradigms")

FRP Variants
- Classic FRP
  e.g. Fran, FrTime 
- Push-pull FRP
  e.g. reactive 
- Arrowized FRP
  e.g. Yampa, Elera

Haskell Type Classes
![haskell-type-classes](./doc/haskell-type-classes.png "Haskell Type Classes")

Yampa Switches
=> Dynamic Dataflow (DDF)
![yampa-switches](./doc/yampa-switches.png "Yampa Switches")

### 7. [FRP Zoo - Comparing many FRP implementations by reimplementing the same toy app in each](https://github.com/gelisam/frp-zoo)

> Evan's presentation classifies FRP libraries into four categories according to the choices they make regarding dynamic graphs. In our list of implementations at the top of this page, we tag each library with the category it belongs to, as well as the scenarios it can implement via dynamic graph changes. There are also other important distinctions between libraries which have nothing to do with dynamic graphs, whose corresponding tags are described in this section.
**Static signal graph v.s. Dynamic signal graph
**Higer-order FRP (any implementation allowing `Signal<Signal>` type) and Asynchronous data flow (e.g. ReactiveX implemented in Observer Pattern)
> - First-order FRP: from Evan's classification, an FRP library which only supports static graphs.
> - High-order FRP: from Evan's classification, an FRP library in which event streams are infinite and the graphs can be changed by collapsing a signal of signals of values into a signal of values.
> - Asynchronous data flow: from Evan's classification, an FRP library in which fast event-processing nodes may receive more recent events than their slower neighbours. Some versions of this model support "cold" signals, in which the event processing is skipped if nobody is listening for the results.
> - Arrowized FRP: from Evan's classification, an FRP library in which graph nodes are automatons which may or may not tick each frame, depending on whether or not they are currently part of the graph. Best for scenario 5. Another way to view this category is that the primary abstraction isn't signals, but functions between signals.
**Separation of Discrete Signal and Continuous Signal**
> - Events and behaviours: an FRP library in which there are two kinds of reactive objects: behaviours hold a value at every point in time, while events only hold values when the event they represent occurs.
> - Signals: an FRP library in which all reactive values hold a value at every point in time. Typically, events are represented via Maybe.
> - Step signals: a separate representation for signals whose value only changes at specific points in time, typically when an event occurs.
> - Continuous: an FRP library in the style of Conal Elliott, meaning that signals are functions from time to values. This built-in notion of time allows interpolation between values, and other time-based transformations.

### 8. [flapjax - Classic FRP](http://www.flapjax-lang.org/)
### 9. [Breaking down FRP](https://blog.janestreet.com/breaking-down-frp/)
Here are some properties that you might want from your FRP system:
- History-sensitivity, or the ability to construct calculations that react not just to the current state of the world, but also to what has happened in the past.
- Efficiency. This comes in two forms: space efficiency, mostly meaning that you want to minimize the amount of your past that you need to remember; and computational efficiency, meaning that you want to minimize the amount of the computation that must be rerun when inputs change.
- Dynamism, or the ability to reconfigure the computation over time, as the inputs to your system change.
- Ease of reasoning. You’d like the resulting system to have a clean semantics that’s easy to reason about.

#### Pure Monadic FRP
In pure monadic FRP, we make the choice to always give such an expression the same meaning, and thus preserve equational reasoning. We also end up with something that’s impossible to implement efficiently. In particular, this choice forces us to remember every value generated by every input forever.

#### Pure Applicative FRP
just drop the join operator, thus giving up dynamism.
static dependency graphs, without the ability to reconfigure

e.g. Elm

e.g. Arrowized FRP
Lets you create a finite collection of static graphs which you can switch between. If those static graphs contain history-dependent computations, then all the graphs will have to be kept running at all times, which means that, while it can be more efficient then applicative FRP, it’s not materially more expressive.

#### Impure Monadic FRP
gives up on equational reasoning.
In other words, the meaning of (max_dist_to_origin mouse_pos) depends on when you call it. Essentially, evaluating an expression that computes a history-sensitive signal should be thought of as an effect in that it returns different results depending on when you evaluate it.

reasoning about when a computation was called in a dynamic dependency graph is really quite tricky and non-local, which can lead to programs whose semantics is difficult to predict.

#### Self-Adjusting Computations (SAC)
give up on history-sensitivity.
no foldp operator

dynamism
The full set of monadic operators, including join
able to build highly configurable computations that can respond to reconfiguration efficiently.

lack of history-sensitivity, thus less suitable UI
suitable for efficient on-line algorithms that could be updated efficiently when the problem changes in a small way.

easy to reason about, all an SAC computation is doing is incrementalizing an otherwise ordinary functional program. 
full equational reasoning if avoid effects within SAC computation.

#### History sensitivity for SAC
The simplest and easiest approach to dealing with history within SAC is to create inputs that keep track of whatever history is important to your application.
you simply set up calculations outside of the system that create new inputs that inject that historical information into your computation.

### 10. [FRP - Dynamic Event Switching](https://apfelmus.nfshost.com/blog/2011/05/15-frp-dynamic-event-switching.html)

> My first design decision for the reactive-banana library was to **remove** this function from the set of combinators. In this post
> - I’m going to explain that the original switcher leads to **time leaks**.
> - I will argue that removing switcher is an **acceptable loss of expressivity**,
> - but nonetheless also **summarize two leak-free solutions** for dynamic event switching. These are relevant for future versions of reactive-banana, even though I have no immediate plans to incorporate them.


### 11. [Higher-order functional reactive programming without spacetime leaks](https://www.cl.cam.ac.uk/~nk480/simple-frp.pdf)

### 12. [purescript-behaviors](https://github.com/paf31/purescript-behaviors/tree/v6.0.0)
[youtube](https://www.youtube.com/watch?v=N4tSQsKZDQ8)

### 13. [TimeFiles: Push-Pull Signal-Function Functional Reactive Programming](https://github.com/eamsden/pushbasedFRP/raw/master/Docs/Thesis/thesis.pdf)

[briancavalier/arrow in JS](https://github.com/briancavalier/arrow)

### 14. [Signals, Not Generators!](http://ai2-s2-pdfs.s3.amazonaws.com/519f/3860d7f719d3cf89ecf507dd01aa0e149cdf.pdf)

### 15. [The Azimuth Project - Functional reactive programming summary](http://www.azimuthproject.org/azimuth/show/Functional+reactive+programming)

### 16. [FrTime: Functional Reactive Programming in PLT Scheme](https://github.com/papers-we-love/papers-we-love/blob/master/paradigms/functional_reactive_programming/frp-in-plt-scheme.pdf?raw=true)

[FrTime Type Specification - Racket Lang](http://docs.racket-lang.org/frtime/)

### 17. [Conal Elliott - Circuits as a bicartesian closed category](http://conal.net/blog/posts/circuits-as-a-bicartesian-closed-category)

### 18. [The operad of wiring diagrams: formalizing a graphical language for databases, recursion, and plug-and-play circuits](https://arxiv.org/abs/1305.0297)

### 19. [Introduction to Functional Game Programming with Scala - LambdaConf 2014](https://github.com/jdegoes/lambdaconf-2014-introgame)

### 20. [HaReactive - Purely functional reactive programming library for JavaScript and TypeScript](https://github.com/funkia/hareactive)

stateful behaviors

Behavior<Behavior<A>> : a behavior of a behavior is like a value that depends on two moments in time. This makes sense for scan because the result of accumulating depends both on when we start accumulating and where we are now.

To get rid of the extra layer of nesting we often use sample. 
It has the type (b: Behavior<A>) => Now<A>.
``` javascript
const count = sample(scan((acc, inc) => acc + inc, 0, incrementStream));
```
Here count has type Now<Behavior<A>> and it represents a Now-computation that will start accumulating from the present moment.

### 21.[FRP.Elerea.Simple](https://hackage.haskell.org/package/elerea-2.9.0/docs/FRP-Elerea-Simple.html)

### 22.[Practical Principled FRP](https://github.com/beerendlauwers/haskell-papers-ereader/blob/master/papers/Practical%20Principled%20FRP%20-%20Forget%20the%20past,%20change%20the%20future,%20FRPNow!.pdf)

### 23.[signal.js](https://github.com/yelouafi/signal)

[What is Functional reactive programming (FRP)](https://github.com/yelouafi/signal/wiki/What-is-Functional-reactive-programming-(FRP))
- Disambiguation: What vs How (Or Denotational vs Operational)
- Classic FRP

good interpretation of Conal Elliott's original paper

### 24.[Fran - Functional Reactive Animation library in Haskell - Conal Elliott (Microsoft)](http://conal.net/fran/)

[Composing Reactive Animations](http://conal.net/fran/tutorial.htm)

### 25.[Functional Reactive Programming for Real-Time Reactive Systems - Zhanyong Wan(PhD Thesis 2002)](http://haskell.cs.yale.edu/wp-content/uploads/2011/02/wan-thesis.pdf)

> **3.3 Two kinds of recursion**
> - Feedback
> - Cycles in state transition diagram

2nd case using a `switch` as a mechanism to dynamically switch among a set of behaviors may not be a form of recusion but can be interpreted as second-order state machine whose state is composed of smaller state machines.

> 3.3.3 Recursion in FRP
> there is no syntactic distinction between two forms of recursion in FRP.
> in practice can create confusion about the program.

> 4 Hybrid FRP
`Behaviors`, `Switchers`, `Events`

> 5 Event-driven FRP

There are two kinds of behaviors: *stateless* and *stateful*.

A stateless behavior `e` can be viewed as a pure function whose inputs are other behaviors, or it can be a constant when there is no input.
The value of `e` depends sorely on its current input, and is not affected by the history of the input at all.
In this sense, `e` is like a combinatorial/combinational circuit.

A stateful behavior `sf` has a state that can be updated by event occurrences.
The value of `sf` depends on both the current input and its state.
Therefore `sf` is analogous to a sequential circuit.

### 26.[Deprecating the Observer Pattern](https://infoscience.epfl.ch/record/148043/files/DeprecatingObserversTR2010.pdf)

> 7. Related Work
> 7.1 Functional Reactive Programming
> 7.2 Adaptive Functional Programming
> 7.3 Dataflow Programming
> 7.4 Complex Event Processing
> 7.5 Actors

### 27.[Testing and Debugging Functional Reactive Programming](https://dl.acm.org/citation.cfm?id=3136534.3110246)

## Self-adjusting Computation (SAC)

### 1.[Self-Adjusting Computation - Umut Acar - Carnegie Mellon University](http://www.umut-acar.org/self-adjusting-computation)

[Self-Adjusting Computation. PhD. Thesis. 2005. Umut A. Acar.](http://www.umut-acar.org/publications/umut-thesis.pdf?attredirects=0)

[Self-Adjusting Machines, Ph.D. Thesis, 2012, Matthew Hammer.](http://www.umut-acar.org/publications/matt-thesis.pdf?attredirects=0)

[Functional Programming for Dynamic and Large Data with Self-Adjusting Computation.](http://www.umut-acar.org/publications/icfp2014.pdf?attredirects=0)

### 2.[Introducing Incremental - a SAC library](https://blog.janestreet.com/introducing-incremental/)

### 3.[Breaking down FRP](https://blog.janestreet.com/breaking-down-frp/)


## Process Algebra/Calculus

### 1.[A gentle introduction to Process Algebras](https://pdfs.semanticscholar.org/12d9/eae1638729aeb237b5be445ee91ecdd3c5d7.pdf)

### 2.[Process Calculus - Wikipedia](https://en.wikipedia.org/wiki/Process_calculus)
History

In the first half of the 20th century, various formalisms were proposed to capture the informal concept of a computable function, with μ-recursive functions, Turing machines and the lambda calculus possibly being the best-known examples today. The surprising fact that they are essentially equivalent, in the sense that they are all encodable into each other, supports the Church-Turing thesis. Another shared feature is more rarely commented on: they all are most readily understood as **models of sequential computation**. The subsequent consolidation of computer science required a more subtle formulation of the notion of computation, in particular explicit representations of concurrency and communication.

**Models of concurrency** such as the process calculi, Petri nets in 1962, and the actor model in 1973 emerged from this line of inquiry.

## Petri Nets

[Communicating finite-state machine](https://en.wikipedia.org/wiki/Communicating_finite-state_machine)

### 1.[Petri Net](https://en.wikipedia.org/wiki/Petri_net)

### 2.[A Unified Frame Work for Discrete Event Systems](https://link.springer.com/article/10.1007/s12555-012-9408-6)

Petri net models are normally more compact than similar automata based models and are better suited for the representation of discrete event systems.

### 3.[Petri nets: properties, analysis, and applications](https://inst.eecs.berkeley.edu/~ee249/fa07/discussions/PetriNets-Murata.pdf)

### 4.[An Introduction to the Practical Use of Colored Petri Nets](https://pdfs.semanticscholar.org/c46a/a30cea94b734e4e653d410a3f9c2f5508434.pdf)

### 5.[Petri Nets: Fundamental Models, Verification and Applications](https://books.google.com/books/about/Petri_Nets.html?id=6YRmLxXp5uQC)

### 6.[CPN Tools - A tool for editing, simulating, and analyzing Colored Petri nets](http://cpntools.org/)

[Coloured Petri net](https://en.wikipedia.org/wiki/Coloured_Petri_net)

## TLA+

### 1.[Hillel Wayne Blog](https://www.hillelwayne.com/tags/tla+/)

[List of TLA+ Examples](https://www.hillelwayne.com/post/list-of-tla-examples/)

[Modeling Redux with TLA+](https://www.hillelwayne.com/post/tla-redux/)

### 2.[Learn TLA+](https://learntla.com/introduction/)

## Reactive JS
### 1.[Popmotion- A functional, reactive animation library](https://github.com/Popmotion/popmotion)

### 2.[RxJS 6](https://github.com/ReactiveX/rxjs)

### 3.[most - Monadic streams for reactive programming](https://github.com/cujojs/most)

### 4.[xstream - An extremely intuitive, small, and fast functional reactive stream library for JavaScript](http://staltz.github.io/xstream/)

### 5. [HaReactive - Purely functional reactive programming library for JavaScript and TypeScript](https://github.com/funkia/hareactive)

## Functional JS
### 1.[Jabz - powerful and practical abstractions for JavaScript](https://funkia.github.io/jabz/)

### 2.[fp-ts](https://github.com/gcanti/fp-ts)

Lightweight higher-kinded polymorphism

[StateIO](https://github.com/gcanti/fp-ts/blob/master/examples/StateIO.ts)
[Free](https://github.com/gcanti/fp-ts/blob/master/examples/Free.ts)
[Moore](https://github.com/gcanti/fp-ts/blob/master/examples/Moore.ts)

### 3. [Sanctuary](https://github.com/sanctuary-js/sanctuary)
[Sanctuary-Type-Classes](https://github.com/sanctuary-js/sanctuary-type-classes)

### 4. [union-type](https://github.com/paldepind/union-type)

### 5. [Common combinators in JavaScript](https://gist.github.com/Avaq/1f0636ec5c8d6aed2e45)

### 6.[Akh - Javascript Monad and Monad Transformer Collection](https://github.com/mattbierner/akh)

### 7.[Mostly Adequate Guide to FP - Chapter 11: Transform Again, Naturally](https://mostly-adequate.gitbooks.io/mostly-adequate-guide/ch11.html)

### 8.[(experimental) monad-t - Transformers for monadic algebraic structures bridging types from various monadic libraries (Fluture, monet)](https://github.com/char0n/monad-t)

## Algebraic Automata

### 1. [Cellular Automata - Part2: PNGs and Moore](https://www.schoolofhaskell.com/school/to-infinity-and-beyond/pick-of-the-week/part-2)

### 2. [Moore for Less](https://www.schoolofhaskell.com/user/edwardk/moore/for-less)

Moore Machine can be seen as a CoFree CoMonad


### 4. [Bartosz Milewski - Comonads](https://bartoszmilewski.com/2017/01/02/comonads/)

### 5. [Sequences, streams, and segments](http://conal.net/blog/posts/sequences-streams-and-segments)

### 6. [The Reader and Writer Monads and Comonads ](https://www.olivierverdier.com/posts/2014/12/31/reader-writer-monad-comonad/)

### 7. [Comonads as Spaces](http://blog.functorial.com/posts/2016-08-07-Comonads-As-Spaces.html)

### 9. Intro to Machines & Arrows
[Intro to Machines & Arrows - Part 1: Stream and Auto](https://blog.jle.im/entry/intro-to-machines-arrows-part-1-stream-and.html)

[Intro to Machines & Arrows - Part 2: Auto as Category, Applicative & Arrow](https://blog.jle.im/entry/auto-as-category-applicative-arrow-intro-to-machines.html)

[Intro to Machines & Arrows - Part 3: Effectful, Recursive, Real-World Autos](https://blog.jle.im/entry/effectful-recursive-real-world-autos-intro-to-machine.html)

### 10. [CLaSH.Prelude.Mealy](https://hackage.haskell.org/package/clash-prelude-0.11.2/docs/CLaSH-Prelude-Mealy.html)

Mealy machine synchronised to the system clock

### 11. [Finite State Transducers in Haskell? - Stack Overflow](https://stackoverflow.com/questions/27997155/finite-state-transducers-in-haskell)

[Finite-State Transducer - Wikipedia](https://en.wikipedia.org/wiki/Finite-state_transducer)

A Mealy machine alternately reads an `a` from a stream of inputs `a` and outputs `a` b to a stream of outputs. It reads first and then outputs once after each read.

``` haskell
newtype Mealy a b = Mealy { runMealy :: a -> (b, Mealy a b) }
```

A Moore machine alternately outputs a `b` to a stream of outputs and reads an input `a` from a stream of inputs. It starts with an output of `b` and then reads once after each output.

``` haskell
data Moore a b = Moore b (a -> Moore a b)
```

An FST either reads from it's input, writes to its output, or stops. It can read as many times in a row as it wants or write as many times in a row as it wants.

``` haskell
data FST a b
    = Read  (a -> FST a b)
    | Write (b,   FST a b)
    | Stop
```

The equivalent of an FST from machines is Process. It's definition is a little spread out. To simplify the discussion we are going to forget about Process for now and explore it from the inside-out.

### 12. [Haskell - Data.Machine.Mealy](https://hackage.haskell.org/package/machines-0.6.3/docs/Data-Machine-Mealy.html)

### 13. [Purescript - Data.Machine.Mealy](https://pursuit.purescript.org/packages/purescript-machines/4.0.0/docs/Data.Machine.Mealy)

### 14. [Elm-Automaton - experimental Arrowized FRP in Elm](https://github.com/evancz/automaton)

### 15. [AFSM: Arrowized functional state machines - Haskell Library](https://hackage.haskell.org/package/AFSM)

> In functional reactive programming(FRP), the key concepts are the signal, Signal a :: Time -> a, and the signal function from signal to signal, SF a b :: Signal a -> Signal b.
>
> The model of FRP is beautiful, but one difficult thing is that the signal is continuous function, and our computers are discrete systems.
>
> However, what if we do not care about time, and only focus on the sequence of input. There is reason to believe that computational tasks usually are time-insensitive. For example, the parsing process. So [a] and [Event a] are the only things we expected in our system.
>
> For discrete system, simplifying the input type is kind of generalizing [(Time,a)] to [a]. This simplified model is still able to process the time sequences by using [(Time, a)] as the input. In conclusion, we doesn't consider time as an essential part of the input, but if the input involves time, users can add time back as a part of the input.

## State Machine Implementations

### Unity

#### 1.[Unity: PlayMaker](https://assetstore.unity.com/packages/tools/visual-scripting/playmaker-368)

### JS

#### 1.[How I Learned to Stop Worrying and ❤️ the State Machine](http://raganwald.com/2018/02/23/forde.html)
#### 2.[JS: xstate - Functional, Stateless JS Finite State Machines and Statecharts](https://github.com/davidkpiano/xstate)
#### 3.[JS: statechart - A javascript implementation of a Harel Statechart](https://github.com/burrows/statechart.js)
#### 4.[JS: royal](https://github.com/jdque/royal)

[Hacker News Discussion](https://news.ycombinator.com/item?id=16468280)


## Algebraic Data Type
### 1.[Typeclassopedia](https://wiki.haskell.org/Typeclassopedia)

> There are two keys to an expert Haskell hacker’s wisdom:
> - Understand the types.
> - Gain a deep intuition for each type class and its relationship to other type classes, backed up by familiarity with many examples.

### 2. [Functors, Applicatives, And Monads In Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)
### 3. [Three Useful Monads](http://adit.io/posts/2013-06-10-three-useful-monads.html)
### 4. [ADT & Dependent Type](http://www.tomharding.me/)
### 5. A functional approach to building React applications. 
[Part 1 - Deconstructing the React Component](https://jaysoo.ca/2017/04/30/learn-fp-with-react-part-1/)

[Part 2 - The Reader monad and read-only context](https://jaysoo.ca/2017/05/10/learn-fp-with-react-part-2/)

[Part 3 - Functional state management with Reducer (W.I.P.)](https://jaysoo.ca/)

### 6. [Revisiting 'Monadic Parsing in Haskell'](http://vaibhavsagar.com/blog/2018/02/04/revisiting-monadic-parsing-haskell/)

### 7. [HLearn](https://github.com/mikeizbicki/HLearn)

| Structure     | What we get                           |
|:--------------|:--------------------------------------|
| Monoid        | parallel batch training               |
| Monoid        | online training                       |
| Monoid        | fast cross-validation                 |
| Abelian group | "untraining" of data points           |
| Abelian group | more fast cross-validation            |
| R-Module      | weighted data points                  |
| Vector space  | fractionally weighted data points     |
| Functor       | fast simple preprocessing of data     |
| Monad         | fast complex preprocessing of data    |

### 8.[The ReaderT Design Pattern - Avoid WriterT, StateT, ExceptT](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern)
### 9. [Monads for drummers](https://github.com/anton-k/monads-for-drummers)
### 10.[What a Monad is not](https://wiki.haskell.org/What_a_Monad_is_not)
### 11.[Combinator Parsing: A Short Tutorial](http://www.cs.uu.nl/research/techreps/repo/CS-2008/2008-044.pdf)

from ["Free monad considered harmful"](https://markkarpov.com/post/free-monad-considered-harmful.html)

Levi Pearson comments:
Regarding "inspection", building a structure out of a free Applicative rather than Monad removes the excess "dynamism" that prevents deep inspection. I guess you were probably already aware of this too, but I figured it was worth a mention in case you weren't. You can see this in Haxl ( https://code.facebook.com/p... ), and UU-Parsinglib ( https://hackage.haskell.org... ) takes advantage of the inspectability of Applicative structure to do interesting things to parsers built with an Applicative-based DSL.

### 12.[Chart: hierarchy of the numeric type classes in Haskell](https://rufflewind.com/2014-08-03/haskell-numeric-type-classes-hierarchy)

![haskell numeric type classes](./doc/haskell-numeric-type-classes.svg)

### 13.[OOP vs type classes](https://wiki.haskell.org/OOP_vs_type_classes)

### 14.[Type classes v.s. Java interfaces](https://www.schoolofhaskell.com/school/starting-with-haskell/introduction-to-haskell/5-type-classes)

**multiple dispatch**

### 15.[Monoids, Functors, Applicatives, and Monads: 10 Main Ideas](https://monadmadness.wordpress.com/2015/01/02/monoids-functors-applicatives-and-monads-10-main-ideas/)

> Main Idea #1: Monoids, functors, applicatives, and monads are all different algebras
>
> Main Idea #2: Monoids, functors, applicatives, and monads are ideas about computation, and are not just specific to Haskell
>
> Main Idea #3: Functors transform values inside containers, while applicatives and monads combine values inside containers
>
> Main Idea #4: Things that are monads can be combined using a special type of function composition
>
> Main Idea #5: You can put values inside a container but you can’t always take them out
>
> Main Idea #6: Applicatives and monads offer an elegant way to manage side effects and state
>
> Main Idea #7: Applicatives and monads both model running computations in sequence, but monads are more powerful
>
> Main Idea #8: Applicatives and monads come with nice syntax
>
> Main Idea #9: Monoids are a general algebra for combining things in a certain way
>
> Main Idea #10: Monads are monoids in the category of endofunctors

### 16.[What a Monad is not](https://wiki.haskell.org/What_a_Monad_is_not#Haskell_doesn.27t_need_Monads)

### 17.[Abstract Data Types and Objects - Two fundamental approaches to data abstraction](https://medium.com/@JosephJnk/abstract-data-types-and-objects-17828bd4abdc)

## Model Theory
### 1.[Model Theory - Wikipedia](https://en.wikipedia.org/wiki/Model_theory)
universal algebra + logic = model theory
model theory = algebraic geometry − fields

### 2.[Combinatorics - Wikipedia](https://en.wikipedia.org/wiki/Combinatorics)
an area of mathematics primarily concerned with counting, both as a means and an end in obtaining results, and certain properties of finite structures
> - the enumeration (counting) of specified structures, sometimes referred to as arrangements or configurations in a very general sense, associated with finite systems,
> - the existence of such structures that satisfy certain given criteria,
> - the construction of these structures, perhaps in many ways, and
> - optimization, finding the "best" structure or solution among several possibilities, be it the "largest", "smallest" or satisfying some other optimality criterion.

- Partition Theory
- Graph Theory
- Design Theory
- Order Theory
- Probabilistic Combinatorics
- Algebraic Combinatorics (abstract algebra)
- Combinatorics on words (formal languages)
- Coding Theory (error-correcting codes, information theory)

### 3.[Abstract Algebra - Wikipedia](https://en.wikipedia.org/wiki/Abstract_algebra)

> **Category theory** is a formalism that allows a unified way for expressing properties and constructions that are similar for various structures.
> **Universal algebra** is a related subject that studies types of algebraic structures as single objects. For example, the structure of groups is a single object in universal algebra, which is called variety of groups.


## Category Theory
### Theory
#### 1.[A Concise Course in Algebraic Topology](https://www.math.uchicago.edu/~may/CONCISE/ConciseRevised.pdf)
#### 2.[Abstract and Concrete Categories](http://katmat.math.uni-bremen.de/acc/acc.pdf)
#### 3.[Toposes, Triples and Theories](http://www.tac.mta.ca/tac/reprints/articles/12/tr12.pdf)

### Application
#### 1.[Memory Evolutive System (MES)](http://vbm-ehr.pagesperso-orange.fr/AnintroT.htm)
#### 2.[Understanding Visualization: A Formal Approach using Category Theory and Semiotics](https://arxiv.org/abs/1311.4376)

## Guarded Recursion
### 1.[A Modality for Recursion](https://pdfs.semanticscholar.org/a177/47f98e5b821f03ec8be858794f2f83a683b7.pdf)
### 2.[A Model of Guarded Recursion with Clock Synchronisation](http://www.itu.dk/people/mogel/papers/clocks-mfps2015.pdf)

## Post-OOP

### 1.[Entity–component–system - Wikipedia](https://en.m.wikipedia.org/wiki/Entity–component–system)

*Used in Unity

Composition over Inheritance

behavior of an entity can be changed at runtime by adding or removing components

Common ECS approaches are highly compatible and often combined with **data oriented design** techniques.

### 2.[Data-oriented design - Wikipedia](https://en.m.wikipedia.org/wiki/Data-oriented_design)

The claim is that traditional object-oriented programming (OOP) design principles result in **poor data locality**, more so if runtime polymorphism (dynamic dispatch) is used (which is especially problematic on some processors[3]).[4]
Although OOP does superficially seem to organise code around data, the practice is quite different. OOP is actually about organising source code around **data types**, rather than physically grouping individual fields and arrays in a format efficient for access by specific functions.
It also often **hides layout details** under abstraction layers, while a data-oriented programmer wants to consider this first and foremost.

### 3.[One Weird Trick to Write Better Code](http://etodd.io/2015/09/28/one-weird-trick-better-code/)

Rather than inheriting functionality, Unity entities are just bags of components. 

[Data first, not code first - Hacker News](https://news.ycombinator.com/item?id=10291688)

### 4.Wizards and warriors
(?) from OOP encoding rules in Type System to Rule Engine / Function on Data

*Interesting Debates in Comments

[Wizards and warriors, part one](https://ericlippert.com/2015/04/27/wizards-and-warriors-part-one/)

[Wizards and warriors, part two](https://ericlippert.com/2015/04/30/wizards-and-warriors-part-two/)

[Wizards and warriors, part three](https://ericlippert.com/2015/05/04/wizards-and-warriors-part-three/)

[Wizards and warriors, part four](https://ericlippert.com/2015/05/07/wizards-and-warriors-part-four/)

[Wizards and warriors, part five](https://ericlippert.com/2015/05/11/wizards-and-warriors-part-five/)

[Hacker News Comments: How I Learned to Stop Worrying and Love the State Machine](https://news.ycombinator.com/item?id=16468280)

##### pinkythepig

> ``` haskell
> data Player =
>     Player (Maybe Weapon) Class
>
> data Weapon =
>       Sword
>     | Staff
>     | Dagger
>
> data Class =
>       Warrior
>     | Wizard
>
> type Error = String
>
> mkPlayer :: Maybe Weapon -> Class -> Either Error Player
>
> mkPlayer (Just Sword) Warrior = Right (Player (Just Sword) Warrior)
> mkPlayer (Just Dagger) Warrior = Right (Player (Just Dagger) Warrior)
> mkPlayer Nothing Warrior = Right (Player Nothing Warrior)
> mkPlayer (Just Staff) Warrior = Left "A Warrior cannot equip a Staff"
>
> mkPlayer (Just Staff) Wizard = Right (Player (Just Staff) Wizard)
> mkPlayer (Just Dagger) Wizard = Right (Player (Just Dagger) Wizard)
> mkPlayer Nothing Wizard = Right (Player Nothing Wizard)
> mkPlayer (Just Sword) Wizard = Left "A Wizard cannot equip a Sword"
> ```
>
> A player is always a defined class(wizard or warrior), but they may not have a weapon equipped. This solution is a bit wordy, but comes with the benefit that if you ever add a new weapon/class, the compiler will scream at you if you haven't handled the case for it properly.
>
> You would only export the mkPlayer function in the library and you could potentially have much fancier error handling, such as building a data structure that contains an 'invalid' player anyways (e.g. `Left (Player (Just Sword) Wizard)`) so you can custom build an error message at the call site ("A $class cannot equip a $weapon") or even completely ignore the error if that is a potential usecase (such as building an armor/weapon preview tool, where you don't care whether they can use the weapon/armor).
>
> Modifying it is pretty easy too. Say I wanted to allow for 2handed weapons, plus offhand weapons (shields, orbs, charms, etc.) I could encode that in a data type like:
>
> ``` haskell
> data EquippedWeapon =
>       TwoHanded TwoHandWeapon
>     | OneHanded (Maybe OneHandWeapon) (Maybe Offhand)
>     | Unequipped
> ```
>
> and swap it into the Player definition:
>
> ``` haskell
> data Player =
>     Player EquippedWeapon Class
> ```
>
> And now I wouldn't be able to compile until I fixed the mkPlayer function and any other place that uses a Player and is dependent upon the weapon portion of the data structure.
>
> e.g. This function wouldn't need to change
>
> ``` haskell
> areYouAWizardHarry :: Player -> Bool
> areYouAWizardHarry (Player _ Wizard) = True
> areYouAWizardHarry (Player _ _) = False
> ```

##### FBT

> The answer is very much "practicality issue". Haskell's more advanced type level features (including GADTs and type families) are very much suited for this, but they're also the sort of thing that gives Haskell a reputation for being complicated. If your just using Haskell's core features the way the parent post does, Haskell is a very simple, very elegant language.
>
> But better yet, it certainly does have the big guns which you can pull out.
>
> ``` haskell
> -- Just like before, we define `Class` and `Weapon`:
> data Class = Warrior | Wizard
> data Weapon = Sword | Staff | Dagger
>
> -- The one really annoying thing is that
> -- at the moment you have to use a little bit
> -- of annoying boilerplate to define singletons
> -- (not related to the OOP concept of singletons, by
> -- the way), or use the `singletons` library. In the
> -- future, with DependentHaskell, this won't be necessary:
> data SWeapon (w :: Weapon) where
>   SSword :: SWeapon 'Sword
>   SStaff :: SWeapon 'Staff
>   SDagger :: SWeapon 'Dagger
>
> -- Now we can define `Player`:
> data Player (c :: Class) where
>   WizardPlayer :: AllowedToWield 'Wizard w ~ 'True => SWeapon w -> Player 'Wizard
>   WarriorPlayer :: AllowedToWield 'Warrior w ~ 'True => SWeapon w -> Player 'Warrior
> ```
>
> This last part shouldn't be to difficult to understand, if you ignore the SWeapon boilerplate: Player is parameterized over the player's class, with different constructors for warriors and wizards. Each constructor has a parameter for the weapon the player is wielding, which is constrained by the type family (read: type-level function) named AllowedToWield.
>
> AllowedToWield isn't that complicated either, it's just a (type-level) function that takes a Class and a Weapon and returns a `Bool` using pattern matching:
>
> ``` haskell
> type family AllowedToWield (c :: Class) (w :: Weapon) :: Bool where
>   AllowedToWield 'Wizard 'Sword = 'False
>   AllowedToWield 'Wizard 'Dagger = 'True
>   AllowedToWield 'Wizard 'Staff = 'True
>   AllowedToWield 'Warrior 'Sword = 'True
>   AllowedToWield 'Wizard 'Dagger = 'True
>   AllowedToWield 'Wizard 'Staff = 'False
> ```
>
> And there it is. What do you gain from all this? Something which it is very had to get in certain other languages: compile-time type checking that there is no code that will allow a wizard to equip a sword, or a warrior to equip a staff.
>
> Once again, I want to make it clear that you absolutely don't need to do this, even in Haskell. You're absolutely allowed to write the simple code like in the parent post. But in my opinion, this is an extremely powerful and useful tool that Haskell lets you take much further than many other languages.
>
> So long story short, the answer to your question is that it is indeed a "practicality issue", although I don't think that my code is that impracticable. It certainly is absolutely not a Haskell limitation: in fact if anything, Haskell makes it a bit too tempting to go in the other direction, and go way overboard with embedding this kind of thing in the type system.

### 5.[Design Patterns in Dynamic Languages](http://www.norvig.com/design-patterns/)

### 6.[Are Design Patterns Missing Language Features](http://wiki.c2.com/?AreDesignPatternsMissingLanguageFeatures)

### 7.[OOP vs type classes](https://wiki.haskell.org/OOP_vs_type_classes)

### 8.[Data-Oriented Design (Or Why You Might Be Shooting Yourself in The Foot With OOP)](http://gamesfromwithin.com/data-oriented-design)

> When we think about objects, we immediately think of trees— inheritance trees, containment trees, or message-passing trees, and our data is naturally arranged that way. As a result, when we perform an operation on an object, it will usually result in that object in turn accessing other objects further down in the tree. Iterating over a set of objects performing the same operation generates cascading, totally different operations at each object (see Figure 1a).

> To achieve the best possible data layout, it’s helpful to break down each object into the different components, and group components of the same type together in memory, regardless of what object they came from. This organization results in large blocks of homogeneous data, which allow us to process the data sequentially (see Figure 1b).
> A key reason why data-oriented design is so powerful is because it works very well on large groups of objects. 
>
> OOP, by definition, works on a single object.
>
> OOP ignores that and deals with each object in isolation.
>
> Advantages of Data-Oriented Design
> - Parallelization
> - Cache utilization
> - Modularity
> - Testing

## Control Theory
### 1.[Mathematical Control Theory: Deterministic Finite Dimensional Systems](http://www.math.rutgers.edu/~sontag/FTPDIR/sontag_mathematical_control_theory_springer98.pdf)

> 1.4 Feedback Versus Precomputed Control
> 1.5 State-Space and Spectrum Assignment
> 2.1 Basic Definitions
> 2.1.2 A **system** or **machine**
> time, state space, input-value space, transition map
> 2.6 Continuous-Time
> 7 Observers and Dynamic Feedback

## Computer Model
**Correct this section after reading "Microprogrammed State Machine Design"**

- discrete/continuous-time
- discrete/continuous-value

### 1.[Analog computer - Wikipedia](https://en.wikipedia.org/wiki/Analog_computer)
### 2.[Digital electronic computer - Wikipedia](https://en.wikipedia.org/wiki/Digital_electronic_computer)
### 3.[Hybrid computer - Wikipedia](https://en.wikipedia.org/wiki/Hybrid_computer)

## Scalable Architecture

### 1.[Functional Design and Architecture](https://github.com/graninas/Functional-Design-and-Architecture)

### 2.[Message Oriented Programming](https://www.joeforshaw.com/blog/message-oriented-programming)

### 3.[Event Notifier, a Pattern for Event Notification](http://www.marco.panizza.name/dispenseTM/slides/exerc/eventNotifier/eventNotifier.html)

### 4.[Unidirectional User Interface Architectures](https://staltz.com/unidirectional-user-interface-architectures.html)

### 5.[Elm Static Types to Effectively Model Application Domain](https://egghead.io/courses/elm-static-types-to-effectively-model-application-domain)

## React

### 1.[Simple React Patterns - Dealing With Side-Effects In React](http://lucasmreis.github.io/blog/simple-react-patterns/)

## Others

### 1.[To Dissect a Mockingbird: A Graphical Notation for the Lambda Calculus with Animated Reduction](http://dkeenan.com/Lambda/)

### 2.[Cyclomatic Complexity - Wikipedia](https://en.wikipedia.org/wiki/Cyclomatic_complexity)
