const ST = state => input => {
  switch (true) {
    case (state.active === true &&
          input.action === 'Disable'):
      {
        const newState = { ...state, active: false }
        return [
          newState,
          { type: 'InternalMsg', channel: 'StateChange', state: newState },
          null
        ]
      }
    case (state.active === false &&
          input.action === 'Activate'):
      {
        const newState = { ...state, active: false }
        return [
          newState,
          { type: 'InternalMsg', channel: 'StateChange', state: newState },
          null
        ]
      }
  }
}

module.exports = {
  ST
}
