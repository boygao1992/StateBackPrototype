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

# Internal

## State

As a view component/widget, the state is limited to view-logic-related only.

```elm
{-| external state
  List data
 -}

-- Maybe.Nothing denotes "no selection yet"
-- String holds a unique Id for each item in the source data (List)
type alias State =
  { key : Maybe String 
  , mouse : Maybe String 
  }

type alias KeySelected = Bool
type alias MouseSelected = Bool

{-| helpers for state initialization/reset -}
--| internal
-- no selection for both key and mouse
empty : State
-- set current selection to the head of the Window
resetToFirst : UpdateConfig msg data -> List data -> State -> State
-- set current mouse selection to a specified Id
resetMouseStateWithId : Bool -> String -> State -> State
--| exposed in API
reset : UpdateConfig msg data -> State -> State
resetToFirstItem : UpdateConfig msg data -> List data -> Int -> State -> State
resetToLastItem : UpdateConfig msg data -> List data -> Int -> State -> State
```

### Sliding Window
`howManyToShow : Int` denotes the size of the Sliding Window on the source List.
So there is an awareness of this "Sliding Window" as an important concept, which is directly manifested as the Candidate Selection Box in the view, but it is implicitly defined.
At least, not in `Model` nor `Config` but scattered around all different places.
Probably, the author wants it to be dynamically assigned thus the `candidtate selection box` is able to have varying length based on domain logic.
Or his abstraction process halted at this point because of some personal reasons.
It may be cumbersome to define a `RuntimeConfig` just for one variable but I insist it is necessary for maintenance.

## Event

```elm
{-| input events -}
subscription : Sub Msg
subscription =
    -- global input event
    Keyboard.downs KeyDown

type Msg
    -- local input events
    = KeyDown KeyCode
    | MouseEnter String
    | MouseLeave String
    | MouseClick String
    | NoOp
    -- internal events
    | WentTooLow
    | WentTooHigh

{-| ouput events -}
type alias UpdateConfig msg data =
    { ...
      --| route the input events back to parent with configured transformations.
      -- inform parent when hitting a specific Id with a customized key
      -- potential use case: display a brief explanation of the selected item
    , onKeyDown : KeyCode -> Maybe String -> Maybe msg
    , onMouseEnter : String -> Maybe msg
    , onMouseLeave : String -> Maybe msg
    , onMouseClick : String -> Maybe msg
      --| view logic related output events
      -- key selection hits lower boundary
    , onTooLow : Maybe msg
      -- key selection hits upper boundary
    , onTooHigh : Maybe msg
    }

-- translate primitive KeyCode from DOM to key selection based on current key selection
-- 38 (Up) and 40 (Down) is reserved for view logic
navigateWithKey : Int -> List String -> Maybe String -> Maybe String

{-| helper -}
mapNeverToMsg : Attribute Never -> Attribute Msg
mapNeverToMsg msg =
    Html.Attributes.map (\_ -> NoOp) msg

```

## State Transition

```elm
update : UpdateConfig msg data -> Msg -> Int -> State -> List data -> ( State, Maybe msg )
update config msg howManyToShow state data =
    case msg of
        --| input events handling
        KeyDown keyCode ->
        MouseEnter id ->
        MouseLeave id ->
        MouseClick id ->
        NoOp ->
        --| internal event handling
        --| 1. translate the internal event with a given translation function in Config
        --| 2. pass the translated event back to the parent
        WentTooLow ->
        WentTooHigh ->

{-| helpers -}

--| get neighor's id in the source List
--| Problem: the implementation is hacky, not really denotational
--| TODO: provide a better implementation
getPrevious : String -> String -> Maybe String -> Maybe String
-- foldr
getPreviousItemId : List String -> String -> String
-- foldl
getNextItemId : List String -> String -> String
```

a better implementation
```elm
type FoldState comparable
  = NotTarget
  | HitTarget
  | Get comparable
  
getNext : comparable -> comparable -> FoldState comparable -> FoldState comparable
getNext target current state =
  case state of
    NotTarget ->
      if current == target
      then HitTarget
      else NotTarget
      
    HitTarget ->
      Get current
      
    Get _ ->
      state

processResult : FoldState comparable -> Maybe comparable
processResult result = 
  case result of
    Get next ->
      Maybe.Just next

    _ ->
      Maybe.Nothing

getNextItem : List comparable -> comparable -> comparable
getNextItem items target =
  List.foldr (getNext target) NotTarget items
    |> processResult
    |> Maybe.withDefault target

getPrevItem : List comparable -> comparable -> comparable
getPrevItem items target =
  List.foldl (getNext target) NotTarget items
    |> processResult
    |> Maybe.withDefault target
```

## View

```elm
view : ViewConfig data -> Int -> State -> List data -> Html Msg

viewWithSections : ViewWithSectionsConfig data sectionData -> Int -> State -> List sectionData -> Html Msg

viewSection : ViewWithSectionsConfig data sectionData -> State -> sectionData -> Html Msg

viewData : ViewWithSectionsConfig data sectionData -> State -> data -> Html Msg

viewList : ViewConfig data -> Int -> State -> List data -> Html Msg

viewItem : ViewConfig data -> State -> data -> Html Msg
```

## Config

```elm
type alias UpdateConfig msg data =
    { onKeyDown : KeyCode -> Maybe String -> Maybe msg
    , onTooLow : Maybe msg
    , onTooHigh : Maybe msg
    , onMouseEnter : String -> Maybe msg
    , onMouseLeave : String -> Maybe msg
    , onMouseClick : String -> Maybe msg
    , toId : data -> String
    , separateSelections : Bool
    }

type alias ViewConfig data =
    { toId : data -> String
    , ul : List (Attribute Never)
    , li : KeySelected -> MouseSelected -> data -> HtmlDetails Never
    }

type alias ViewWithSectionsConfig data sectionData =
    { toId : data -> String
    , ul : List (Attribute Never)
    , li : KeySelected -> MouseSelected -> data -> HtmlDetails Never
    , section : SectionConfig data sectionData
    }

type alias SectionConfig data sectionData =
    { toId : sectionData -> String
    , getData : sectionData -> List data
    , ul : List (Attribute Never)
    , li : sectionData -> SectionNode Never
    }
```
