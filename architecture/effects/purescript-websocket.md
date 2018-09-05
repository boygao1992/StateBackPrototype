[purscript-web-socket](https://pursuit.purescript.org/packages/purescript-web-socket)

[Stackless Coroutines in Purescript](https://blog.functorial.com/posts/2015-07-31-Stackless-PureScript.html)

> stack-free implementation of the free monad transformer for a functor
>
> Free Monads and Coroutines
>
> Tail Recursive Monads
>
> Stack-Safe Free Monad Transformers
>
> Stackless Coroutines

```haskell
import Data.Foldable (for_)

import Control.Coroutine as CR
import Control.Coroutine.Aff as CRA

import Web.Socket.WebSocket as WS
import Web.Event.EventTarget as EET
import Web.Socket.Event.EventTypes as WSET
import Web.Socket.Event.MessageEvent as ME

import Control.Monad.Except (runExcept)

import Foreign
                                         data ForeignError
                                           = ForeignError String
                                           | TypeMismatch String String
                                           | ErrorAtIndex Int ForeignError
                                           | ErrorAtProperty String ForeignError
      import Data.List.NonEmpty (NonEmptyList)
           type MultipleErrors = NonEmptyList ForeignError
         import Control.Monad.Except (Except, throwError, mapExcept)
    type F = Expect MultipleErrors -- an error monad, used to encode possible failures
  ( F

    foreign import data Foreign :: Type
    -- A type for foreign data from any external unknown or unreliable source, for which it cannot be guaranteed that the runtime representation conforms to that of any particular type.
    -- thus need explicit error handling when interpreting it as a known data-type
  , Foreign
  , unsafeToForeign
  , readString)

-- A producer coroutine that emits messages that arrive from the websocket.
wsProducer :: WS.WebSocket -> CR.Producer String Aff Unit
                    CRA.produce :: forall a r. (Emitter Effect a r -> Effect Unit) -> Producer a Aff r -- a = String, r = Unit
wsProducer socket = CRA.produce \emitter -> do -- emitter :: Emitter Effect String Unit
              EET.eventListener :: forall a. (Event -> Effect a) -> Effect EventListener -- a = Unit
  listener <- EET.eventListener \ev -> do -- ev :: Event
 -- for :: forall a b m t. Applicative m => Traversable t => t a -> (a -> m b) -> m (t b)
    for_ :: forall a b f m. Applicative m => Foldable f => f a -> (a -> m b) -> m Unit -- m = Effect, f = Maybe, a = MessageEvent, b = Unit
          ME.fromEvent :: Event -> Maybe MessageEvent
    for_ (ME.fromEvent ev) \msgEvent -> -- msgEvent :: MessageEvent
      for_ :: forall a b f m. Applicative m => Foldable f => f a -> (a -> m b) -> m Unit -- f = Maybe, a = Foreign, b = Unit
                       readString :: Foreign -> F String
                                   ME.data_:: MessageEvent -> Foreign
      for_ (readHelper readString (ME.data_ msgEvent)) \msg -> -- msg :: String
        CRA.emit :: forall m a r. Emitter m a r -> a -> m Unit -- m = Effect, a = String, r = Unit
                 emitter :: Emitter Effect String Unit
                         msg :: String
        CRA.emit emitter msg
  EET.addEventListener :: EventType -> EventListener -> Boolean -> EventTarget -> Effect Unit
  EET.addEventListener
    WSET.onMessage :: EventType
    WSET.onMessage
    listener :: Event -> Effect a -- a = Unit
    listener
    false
     WS.toEventTarget :: WebSocket -> EventTarget
                      socket :: WebSocket
    (WS.toEventTarget socket)
  where
    readHelper :: forall a b. (Foreign -> F a) -> b -> Maybe a -- a = String, b = Foreign
    readHelper read =
      either (const Nothing) Just
            runExcept :: forall e a. Except e a -> Either e a -- a = String
        <<< runExcept
            read :: Foreign -> F a -- a = String
        <<< read
foreign import unsafeToForeign :: forall b. b -> Foreign
            -- Coerce any value to the a `Foreign` value.
            -- This is considered unsafe as it's only intended to be used on primitive Javascript types
        <<< unsafeToForeign
```

