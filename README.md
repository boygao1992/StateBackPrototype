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
  (in OOP, Translator Pattern**

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

## Guard

Higher-order combinational logic with variables

### AND/OR Table

**[ pic ]**

## State Refinement

**Guard can be factored out of state transition**

Used to incrementally refine the state following some global constraints.

1. Pre Censor / Interrupter

Listening to (External) Messages

Filtered out Messages/Inputs for components based on Global Constraints

2. Regulator

Listening to (Internal) Messages which indicate State Update in any component.

Push forward / Roll back the component's state to next/last intermediate state based on Global Constraints

3. Post Censor

After the state transition in this tick/step is done ( no more Internal Messages received), Post Censor checks if the system is in a valid state.
If not, roll back to previous valid state.

*All intermediate states are invalid states and should not be observed by external observers.

### Case Study
#### 1. push forward
#### 2. pull back

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

2. Synchronous Parallel Composition ( n independent tasks, n >= 2)

signal broadcasting

**[ pic ]**

3. Feedback Loop

These composition logic will be implemented by Writer monad, Monoid, and ChainRec monad.

### Reader
### Writer
### Monoid
### ChainRec

# Overall Architecture

Mealy Machine + Synchronous Composition + Feedback

## Driver

1. DOM Driver
2. HTTP Driver (WebSocket Driver)
3. Time Driver
4. Database Driver
  ![Abstract out IO Effects by Drivers](./doc/io-eff-by-drivers.png "Abstract out IO Effects by Drivers")

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

# Design Choices TODO

## Stateful HTML Elements handling for performance

1. Text Input Box
2. Slider
3. Selector


# Reference

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

7 :: B Real

![cfrp-behavior-exapmle01](./doc/cfrp-behavior-example01.png "CFRP Example 01")

time :: B Time

![cfrp-behavior-exapmle02](./doc/cfrp-behavior-example02.png "CFRP Example 02")

(+) :: B Real -> B Real -> B Real

![cfrp-behavior-exapmle03](./doc/cfrp-behavior-example03.png "CFRP Example 03")

lift1 :: (a -> b) -> (B a -> B b)

(Real -> Real) -> (B Real -> B Real)

![cfrp-behavior-exapmle04](./doc/cfrp-behavior-example04.png "CFRP Example 04")

integral :: B Real -> B Real

![cfrp-behavior-exapmle05](./doc/cfrp-behavior-example05.png "CFRP Example 05")

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
