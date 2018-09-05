[purescript-aff](https://github.com/slamdata/purescript-aff)

mainly implemented in JS for performance
then bundled with purescript runtime by  `foreign import data`

```haskell
foreign import data Aff :: Type -> Type
-- | approximated declaration in purescript
data Aff eff a
  = Pure a
  | Throw Error
  | Catch (Aff eff a) (Error -> Aff eff a)
  | Sync (Eff eff a)
  | Async ( (Either Error a -> Eff eff Unit) -> Eff eff (Canceller eff) )
  | forall b. Bind (Aff eff b) (b -> Aff eff a) -- existential
  | forall b. Bracket (Aff eff b) (BracketConditions eff b) (b -> Aff eff a)
  | forall b. Fork Boolean (Aff eff b) ?(Fiber eff b -> a)
  | Sequential (ParAff aff a)

-- | Applicative to coordinate effects in parallel
data ParAff eff a
  = forall b. Map (b -> a) (ParAff eff b)
  | forall b. Apply (ParAff eff (b -> a)) (ParAff eff b)
  | Alt (ParAff eff a) (ParAff eff a)
  | ?Par (Aff eff a)

data FiberState
  = Suspended
  | Continue
  | StepBind
  | StepResult
  | Pending
  | Return
  | Completed

initialState :: FiberState
initialState = Suspended
```
