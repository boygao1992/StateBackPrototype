# Lifecycles

1. Mounting
`constructor` -> `render` -> (VDOM diff patch) -> `componentDidMount`
(`componentDidMount` ~ `initialState :: Input -> State`)
2. Updating
new `props`/`setState`/`forceUpdate` -> `render` -> (V~) -> `componentDidUpdate`
(`componentDidUpdate` ~ `receiver :: Input -> Maybe (Query Unit)`)
3. Unmounting
`componentWillUnmount`


