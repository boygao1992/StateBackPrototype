const C = require('crocks')
const {
  Maybe,
  Maybe: { Just, Nothing }
} = C
const R = require('ramda')
const { last } = R
const I = require('./immutableCustom')
const { List, Map } = I
const {
  initialState: buttonInitialState,
  ST: buttonST
} = require('./button')


const initialState = Map({
  a: { State: buttonInitialState(true), ST: buttonST },
  b: { State: buttonInitialState(false), ST: buttonST },
  c: { State: buttonInitialState(false), ST: buttonST },
})
let history = []
history.push(initialState)

function nextState(input) {
  const state = last(history)
  // state.map((v,k) => )
}
