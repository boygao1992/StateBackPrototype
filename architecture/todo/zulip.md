# Code Organization


- `account` - login, logout, and user account
- `api` - clients for the Zulip server API
- `common` - common components for multiple reuse (buttons, inputs, etc.)
- `compose` - composing messages
- `message` - messages and groups of related messages
- `nav` - navigation
- `streams` - stream of messages
- `users` - user display, search and selection

- `ZulipMobile.js` - the top-level React component for the app
- `boot/reducers.js` - the top-level reducer

- `types.js` - data models in `flow`

## Redux Selectors
Redux (memorized) selectors are basically secondary indexes on the Store (as a database).

- `baseSelectors.js`
- `directSelectors.js`
- `selectors.js`
