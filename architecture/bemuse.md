[bemuse - Web-based online rhythm action game. Based on HTML5 technologies, React, Redux and Pixi.js.](https://github.com/bemusic/bemuse)

# External Libraries

## 1. [taskworld/impure](https://github.com/taskworld/impure)

- `createIO`, create a "runable" which is waiting for drivers to be injected
- `createRun`, inject drivers (so called "context") to handle different types of side effects
- `wrapGenerator`, use `generator`/`async` function (`do` notation in Haskell) to "chain" IO

deprecated. better alternative: [funkia/io](https://github.com/funkia/io)

## 2. [Gozala/events -  Node's event emitter for all engines.](https://github.com/Gozala/events)

## 3. [Bacon.js](https://github.com/baconjs/bacon.js/#bus)

> `Bus` is an EventStream that allows you to push values into the stream. It also allows plugging other streams into the Bus. The Bus practically merges all plugged-in streams and the values pushed using the push method.

a simpler version of RxJS's `Subject`
allows dynamically switching upstream producers

# Architecture

`bemuse/src/` source code
- `ui/` react view functions, `jsx`+`scss` solution
- `app/` redux state store
  - `io/` IO effects
- `boot/` game modules loading screen
- `flux/` a primitive state store based on Bacon (async dataflow) and explicit locking, possibly deprecated after adoption of Redux, but still used in music module
  - `connect` parametrizes React Component by view function
- `omni-input` keyboard input handling logic
- `online` in-browser storage for game content and user info handling

## State / Model
`/bemuse/src/app/entities/`

Classes of subdimensions
- Collections
- LoadState
- MusicSearchText
- MusicSelection
- Options

### Music Collections
`/bemuse/src/app/entities/Collections.js`

```elm
type alias ErrMsg =
    String

type alias Url =
    String

type alias Collection a =
    { url : Url
    , loadingStatus : LoadingStatus a}

type LoadingStatus a =
      beginLoading
    | completeLoading a
    | errorLoding ErrMsg
    
getCollectionByUrl : Url -> Model -> Maybe (Collection a)
getCollectionByUrl url model =
    model.collections |> get url
```

No data model defined by `Proptypes`.
Recovered by reverse engineering.

Suppose there is a `collections : Dict Url (Collection a)` in `Model`.

Not sure what to be filled in `a`. Possibly `Song`.

May need `Validator` for `Url` validation.

### Songs
`/bemuse/src/music-collection-viewer/MusicTable.js`

```elm
type alias ChartInfo =
    { difficulty : Int
    , level : ? 
    , subtitles : String }

type alias MusicChart =
    { keys : String
    , info : ChartInfo }

type alias Song =
    { id : String
    , title : String
    , genre : String
    , unreleased : Bool
    , exclusive : Bool
    , charts : List MusicChart
    , readme : Maybe String
    , replaygain : ?
    , artist_url : Maybe Url
    , added : Maybe Date
    , initial : Maybe Date
    , song_url : Maybe Url
    , youtube_url : Maybe Url
    , long_url : Maybe Url
    , bms_url : Maybe Url
    , bmssearch_id : Maybe String
    , }
```


## Event / Msg
`/bemuse/src/app/redux/ReduxState.js > Actions`

## State Transformation / Update
`/bemuse/src/app/redux/ReduxState.js > Reducer`

## IO / Cmd
`bemuse/src/io/`
