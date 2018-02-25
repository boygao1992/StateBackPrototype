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

## ELM

1. state transition function without validation of state

2. state transition functions are directly attached to event handlers, which strongly couples model and view 

3. child-parent message passing need child to expose state getter/lense function to its parent to grant parent access to its state (give it ability to interpret)
  (in OOP, Translator Pattern)

4. node-to-node communication is even worse.
  Need to find a common ancestor and all the ancestor/parent along the way to be aware of the communication.

5. first-order FRP and static signal graph. Separation between Container and Child Component in state management (which is essential for creating General Container Widget) while maintaining the ability to add/remove child components dynamically in runtime is not possible.

![Node-to-Node Message Passing](./doc/node-to-node_message_passing.png "Node-to-Node Message Passing")

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
1. Cascade Composition ( 2 sequential dependent tasks)

signal passing

**[ pic ]**

2. Synchronous Parallel/Side-by-side Composition ( n independent tasks, n >= 2)

signal broadcasting

**[ pic ]**

3. Feedback Loop

These composition logic will be implemented by Writer monad, Monoid, and ChainRec monad.

### Reader
### Writer
### Monoid
### ChainRec

### F-Algebra, Fixed-point data type (Fix), recursive function

[Understanding F-Algebras](https://www.schoolofhaskell.com/user/bartosz/understanding-algebras)

[Haskell/Fix and recursion](https://en.wikibooks.org/wiki/Haskell/Fix_and_recursion)
The Fix data type cannot model all forms of recursion.

[purescript-fixed-points](https://pursuit.purescript.org/packages/purescript-fixed-points/4.0.0)

### Free / CoFree
[Free from Tree & Halogen VDOM](https://www.youtube.com/watch?v=eKkxmVFcd74)

Core primitives to model any recursive types, which means you can build Mu/Nu (fixed-point data type) out of Free/CoFree. 
Mathematically equivalent but may not be optimal for performance because of the structural overhead (e.g. extra wrapping which takes more memory and of course extra unwrapping).
It's like trading performance for generality so that you can get all the operators for free.

Two different types of Trees.

Substitute a Functor into Free/CoFree, you can derive a Monad/CoMonad.

Used to build AST and Interpreter.

**One usage is to turn Effects into data.**
Which is exactly what I need.
- time travel: state + effects
- hot reload (S-[B]) with security

[Free for DSLs, cofree for interpreters](http://dlaing.org/cofun/posts/free_and_cofree.html)

[DrBoolean/freeky](https://github.com/DrBoolean/freeky)

[Free play - part 1](http://therning.org/magnus/posts/2016-01-13-000-free-play--part-one.html)
[Free, take 2](http://therning.org/magnus/posts/2016-06-18-free--take-2.html)

[A Modern Architecture for FP](http://degoes.net/articles/modern-fp)

# Overall Architecture

Mealy Machine + Synchronous Composition + Feedback

## Driver

1. DOM Driver
2. HTTP Driver (WebSocket Driver)
3. Time Driver
4. Database Driver
  ![Abstract out IO Effects by Drivers](./doc/io-eff-by-drivers.png "Abstract out IO Effects by Drivers")

### Time Driver
1 Global Clock / n Local Clocks

I guess Global Clock is better for animation.

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

## Stateful HTML Elements handling for performance

1. Text Input Box
2. Slider
3. Selector

may represented by continuous-time model?
(e.g. [@funkia/turbine](https://github.com/funkia/turbine)
[@funkia/hareactive](https://github.com/funkia/hareactive))

## State Store as Database

1.[Using the Redux Store Like a Database](https://hackernoon.com/shape-your-redux-store-like-your-database-98faa4754fd5)

## Event Handler as Data

1. [Emerging Patterns in JavaScript Event Handling](https://www.sitepoint.com/emerging-patterns-javascript-event-handling/)

## Serialization of Functions

1. [JavaScript's eval() and Function() constructor](http://dfkaye.github.io/2014/03/14/javascript-eval-and-function-constructor/)

## State Transitions as Events

## API Complexity
### 1.[The MNP Problem of Distributed Computing](https://www.ebpml.org/blog2/index.php/2014/12/27/the-mnp-problem-of-distributed)

MNPT Problem:
An architecture with M **clients**, invoking N remote operations/**actions** which can each have P **versions** and involves data fetching from T **systems of records** / micro-services, ends up with MNPT **communication paths**.



# Reference

## Automata
- [Turing Machine](https://en.wikipedia.org/wiki/Turing_machine)
- [Pushdown Automata (PDA)](https://en.wikipedia.org/wiki/Pushdown_automaton)
- [Sequential Logic](https://en.wikipedia.org/wiki/Sequential_logic)
/ [Finite State Machine](https://en.wikipedia.org/wiki/Finite-state_machine)
- [Combinational Logic](https://en.wikipedia.org/wiki/Combinational_logic)

### 1.[State Machines for Event-Driven Systems](https://barrgroup.com/Embedded-Systems/How-To/State-Machines-Event-Driven-Systems)

### 2.[Introduction to Hierarchical State Machines (HSMs)](https://barrgroup.com/Embedded-Systems/How-To/Introduction-Hierarchical-State-Machines)


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

[Introduction to Embedded Systems: a Cyber-Physical Systems Approach](http://leeseshia.org/releases/LeeSeshia_DigitalV1_08.pdf)

### Event Sequence

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

### Timed Model of Computation

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

#### Classification
Evan's presentation classifies FRP libraries into four categories according to the choices they make regarding dynamic graphs. In our list of implementations at the top of this page, we tag each library with the category it belongs to, as well as the scenarios it can implement via dynamic graph changes. There are also other important distinctions between libraries which have nothing to do with dynamic graphs, whose corresponding tags are described in this section.
- First-order FRP: from Evan's classification, an FRP library which only supports static graphs.
- High-order FRP: from Evan's classification, an FRP library in which event streams are infinite and the graphs can be changed by collapsing a signal of signals of values into a signal of values.
- Asynchronous data flow: from Evan's classification, an FRP library in which fast event-processing nodes may receive more recent events than their slower neighbours. Some versions of this model support "cold" signals, in which the event processing is skipped if nobody is listening for the results.
- Arrowized FRP: from Evan's classification, an FRP library in which graph nodes are automatons which may or may not tick each frame, depending on whether or not they are currently part of the graph. Best for scenario 5. Another way to view this category is that the primary abstraction isn't signals, but functions between signals.
- Events and behaviours: an FRP library in which there are two kinds of reactive objects: behaviours hold a value at every point in time, while events only hold values when the event they represent occurs.
- Signals: an FRP library in which all reactive values hold a value at every point in time. Typically, events are represented via Maybe.
- Step signals: a separate representation for signals whose value only changes at specific points in time, typically when an event occurs.
- Continuous: an FRP library in the style of Conal Elliott, meaning that signals are functions from time to values. This built-in notion of time allows interpolation between values, and other time-based transformations.

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

## Petri Nets

[Communicating finite-state machine](https://en.wikipedia.org/wiki/Communicating_finite-state_machine)

### 1.[Petri Net](https://en.wikipedia.org/wiki/Petri_net)

### 2.[A Unified Frame Work for Discrete Event Systems](https://link.springer.com/article/10.1007/s12555-012-9408-6)

Petri net models are normally more compact than similar automata based models and are better suited for the representation of discrete event systems.

### 3.[Petri nets: properties, analysis, and applications](https://inst.eecs.berkeley.edu/~ee249/fa07/discussions/PetriNets-Murata.pdf)

### 4.[An Introduction to the Practical Use of Colored Petri Nets](https://pdfs.semanticscholar.org/c46a/a30cea94b734e4e653d410a3f9c2f5508434.pdf)

### 5.[Petri Nets: Fundamental Models, Verification and Applications](https://books.google.com/books/about/Petri_Nets.html?id=6YRmLxXp5uQC)

## Functional JS
### 1. [Jabz - powerful and practical abstractions for JavaScript](https://funkia.github.io/jabz/)

### 2. [fp-ts](https://github.com/gcanti/fp-ts)

Lightweight higher-kinded polymorphism

[StateIO](https://github.com/gcanti/fp-ts/blob/master/examples/StateIO.ts)
[Free](https://github.com/gcanti/fp-ts/blob/master/examples/Free.ts)
[Moore](https://github.com/gcanti/fp-ts/blob/master/examples/Moore.ts)

### 3. [Sanctuary](https://github.com/sanctuary-js/sanctuary)
[Sanctuary-Type-Classes](https://github.com/sanctuary-js/sanctuary-type-classes)

### 4. [union-type](https://github.com/paldepind/union-type)

### 5. [Common combinators in JavaScript](https://gist.github.com/Avaq/1f0636ec5c8d6aed2e45)


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


## Algebraic Data Type
### 1. [Monads for drummers](https://github.com/anton-k/monads-for-drummers)
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


## Others

### 1. [To Dissect a Mockingbird: A Graphical Notation for the Lambda Calculus with Animated Reduction](http://dkeenan.com/Lambda/)

### 2. [Cyclomatic Complexity - Wikipedia](https://en.wikipedia.org/wiki/Cyclomatic_complexity)
