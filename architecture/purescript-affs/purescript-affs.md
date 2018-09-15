`Aff` and `AVar` are Actor and (unbounded) Channel from CSP.

- Actor can spawn child Actors, and have their Addresses
  - `Aff` can `forkAff` to create new `Aff`
- in the original definition of Actor, when a child Actor is spawned, a bidirectional connection between parent Actor and child Actor is established by default so they can talk to each other through Messages, and there is a Mailbox built-in in each Actor to queue up unhandled Messages
  - by default, parent `Aff` and child `Aff` have no way to communicate with each other
- Actor can create Channel (which is an Actor itself dedicated to Message passing logic without other computation) and sent the Address of the Channel to other Actors, and later talk to them through it
  - `Aff` can create `AVar` (unbounded Channel)
  - since there is no default way for `Aff`s to communicate, when parent `Aff` create a new child `Aff`, it has to have the reference of that `AVar` embedded in the child `Aff` (an implicit message passing during initialization of child `Aff` by referencing in scope; downside of this, we may have similar situation like "Callback Hell" when dealing with nesting)
  - can mimic Actors' behavior by having `AVar` of `AVar` (a Channel passing Addresses of Channels)
- `AVar` is bidirectional which means any `Aff` have reference to an `AVar` can both `take` (read) and `put` (write) to it
  - if an `Aff` both `take` and `put` to the same `AVar`, it's like talking to itself asynchronously; but if some other `Aff`s also have the reference to that `AVar`, then the message passing pathways can be unpredictable, unless have its sender and receiver encoded in every message and all `Aff`s need to have their unique identities
  - better restrict usage to directional communication
    - an `AVar` that an `Aff` only takes from, can be treated as its Mailbox in Actor model
    - then parent `Aff` send message to child `Aff`s by `put` to their `AVar` Mailboxes

