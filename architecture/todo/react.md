# Lifecycles

1. Mounting
`constructor` -> `render` -> (VDOM diff patch) -> `componentDidMount`
(`componentDidMount` ~ `initialState :: Input -> State`)

2. Updating
new `props`/`setState`/`forceUpdate` -> `render` -> (V~) -> `componentDidUpdate`
(`componentDidUpdate` ~ `receiver :: Input -> Maybe (Query Unit)`)
  - `static getDerivedStateFromProps()`
  - `shouldComponentUpdate()`
  - `render()`
  - `getSnapshotBeforeUpdate()`
  - `componentDidUpdate()`

3. Unmounting
`componentWillUnmount`


[Lifting State Up](https://reactjs.org/docs/lifting-state-up.html)
- This works mostly for static pages.
- the event cascading paths are tightly coupled with current DOM tree structure
- not resilient to reorganization of UI components
