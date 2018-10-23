Ajax
- XMLHttpRequest
- jQuery, `$.ajax`
- `fetch(url, options) :: Promise Response`
  - `options :: ( method :: String, headers :: Object, body :: String )`
    - e.g. `{ method: "post", headers: { Content-Type: "application/json"}, body }`
  - ```haskell
      Response ::
        ( body :: ReadableStream
        , bodyUsed :: Boolean
        -- body :: Maybe ReadableStream
        , headers :: Headers
        , ok :: Boolean
        , redirected :: Boolean
        , status :: Int
        , statusText :: String
        , type :: String
        , url :: String
        )
    ```
- axios, `axios({ method :: String, url :: String, data :: Object })`
