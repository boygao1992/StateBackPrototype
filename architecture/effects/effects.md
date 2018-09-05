- Network: HTTP / WebSocket (asynchronous, `Aff`, `Fiber`/`Coroutine`)
- Time
  - `now`: get current time (synchronous, `Effect`)
  - `every`: trigger an event with a given frequency (asynchronous, `Aff`, `Fiber` / `Coroutine`, `Canceller`)
- Random number generation
  - `liftM distInv State ( randomR (0, 1) )`: pseudo random number generator with an explicit state (current seed)
  - `liftM distInv ( randomRIO (0,1) )`: "true" random number generator through IO
  
purescript used to enforce `Eff` attached with `# Type` (Row Kind) for optimization purpose
now `Effect` is preferred for simplicity since performance issue is solved
