# Problems in Current Frameworks
## CycleJS
1. CycleJS claims that the Main Function is *Pure*, but not really.
Still need mocking for testing.
  - event listener attach/removal is side effect which is not abstracted away from Main.
  - RxJS Observable has many stateful operators which are declarative but encapsulate/hide state.
    - MemoryStream / operators with buffers
    - time-related operators
3. Cyclic dependency is painful to handle which destroys scalability.

Why cyclic?

Parent component cannot interpret External Events from Event Listeners attached by its child components which is a reasonable design choice.
To pass interpreted events as messages back to parent component, part of child's sink has to be part of parent's source while part of parent's source is already part of child's source. Thus, parent and child depend on each other.
e.g. TodoMVC, delete button is attached to child components (TodoItem) while the lifecycles of child components are managed by parent component (TodoList). Parent need DELETE event from child to perform the state transition.

## ELM
1. state transition function without validation of state
2. state transition functions are directly attached to event handlers, which strongly couples model and view 
3. child-parent message passing need child to expose state getter/lense function to its parent to grant parent access to its state (give it ability to interpret)
(in OOP, Translator Pattern**
4.  node-to-node communication is even worse.
Need to find a common ancestor and all the ancestor/parent along the way to be aware of the communication.

**[ pic ]**

## SAM
V = State( vm( Model.present( Action( data))), nap(Model))

Moore Machine(?)

1. If nap(next-action predicate, push machine out of intermediate state) is rejected by Model.present, then the entire system gets stuck in an invalid state.
This means nap() function has to coherent with Model.present but this type of coordination is managed manually. 
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

[cyclic dependency]: can be unfolded into an infinite/varying length acyclic dependency sequence. The infinite length case can be handled by Banach fixed-point theorem which is out of the scope of this project.
3. Unified cyclic/acyclic dependencies
child state machines are in a map

## Guard

Higher-order combinational logic with variables

### AND/OR Table

**[ pic ]**

### Regulator, (post) Censor, (pre) Interrupter

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

## Extended Finite State Machine

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

# Overall Architecture
