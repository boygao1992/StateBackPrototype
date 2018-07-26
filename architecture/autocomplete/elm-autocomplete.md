[elm-autocomplete](https://github.com/thebritican/elm-autocomplete)
- API, `/elm-autocomplete/src/Autocomplete.elm`
- Autocomplete (candidate selection box), `/elm-autocomplete/src/Autocomplete/Autocomplete.elm`

Example App
- App, `/elm-autocomplete/examples/Demo.elm`
- AccessibleExample, `/elm-autocomplete/examples/src/AccessibleExample.elm`
- SectionExample, `/elm-autocomplete/examples/src/SectionExample.elm`


recursive updates are intensively used.
good material to investigate

limitations
- direct parent and children communication
- internal message propagation is sequential
- need to figure out a way to visualize the internal message cascading paths,
state space being shaped this way is messy
- only one instance of Autocomplete Component under each customized Component,
need to be able to deal with a list of dynamically instantiated Components
- when both input fields are off focus, `State {currentFocus}` is not set to `None`
  - not able to close the candidate selection box correctly which is still actively responding to keyboard events
  - need `onBlur` event handling
- no scrolling by keyboard in `SectionExample`
  - `Dom.Scroll`, hacky
