[github - slamdata/purescript-halogen](https://github.com/slamdata/purescript-halogen)
[pursuit - purescript-halogen](https://pursuit.purescript.org/packages/purescript-halogen/3.1.3)

attention
- current package version: `4.0.0`
- current documentation version on Pursuit: `3.1.3`

# Web technology

[The Web platform: Browser technologies](https://platform.html5.org/)

## Browsing contexts

[7.1 Browsing contexts](https://html.spec.whatwg.org/multipage/browsers.html#windows)
> Definition: A **browsing context** is an environment in which `Document` objects are presented to the user.

> A *tab* or *window* in a Web browser typically contains a **browsing context**, as does an `iframe` or `frame`s in a `frameset`.

> A browsing context has a **session history**, which lists the `Document` objects that the browsing context has presented, is presenting, or will present.

> A browsing context's **active document** is its `WindowProxy` object's `[[Window]]` internal slot value's associated `Document`.

> A `Document`'s browsing context is the browsing context whose **session history** contains the `Document`, if any such browsing context exists and has not been discarded.

> A browsing context can have a **creator browsing context**, the browsing context that was responsible for its creation.
> - If a browsing context has a **parent browsing context**, then that is its creator browsing context.
> - Otherwise, if the browsing context has an **opener browsing context**, then that is its creator browsing context.
> - Otherwise, the browsing context has **no** creator browsing context.

> If a browsing context has a creator browsing context creator, it also has the following properties.
> - creator origin: creator document's origin
> - creator URL: creator document's URL
> - creator base URL: creator document's base URL
> - creator referrer policy: creator document's referrer policy

[7.1.1 Nested browsing contexts](https://html.spec.whatwg.org/multipage/browsers.html#nested-browsing-contexts)
> Certain elements (for example, `iframe` elements) can instantiate further browsing contexts.
> These elements are called **browsing context containers**.


## Window

[7.3 The Window object](https://html.spec.whatwg.org/multipage/window-object.html#the-window-object)

[7.4 The WindowProxy exotic object](https://html.spec.whatwg.org/multipage/window-object.html#the-windowproxy-exotic-object)
> A `WindowProxy` is an exotic object that wraps a Window ordinary object, indirecting most operations through to the wrapped object.
> Each browsing context has an associated `WindowProxy` object.
> When the browsing context is navigated, the `Window` object wrapped by the browsing context's associated `WindowProxy` object is changed.
> There is **no `WindowProxy` interface object**.
> Every `WindowProxy` object has a `[[Window]]` internal slot representing the wrapped `Window` object.

## History & Location
[7.7 Session history and navigation](https://html.spec.whatwg.org/multipage/history.html)
> A browsing context's **session history** consists of a flat list of **session history entries**.
> Each **session history entry** consists, at a minimum,
> - of a `URL`, 
> - and each entry may in addition have **serialized state**,
> - a **title**,
> - a `Document` object,
> - **form data**,
> - a **scroll restoration mode**, 
> - a **scroll position**, 
> - a **browsing context name**, and other information associated with it.

> Each `Document` object in a browsing context's **session history** is associated with a unique `History` object which must all model the same underlying session history.

> **Serialized state** is a serialization (via StructuredSerializeForStorage) of an object representing a user interface state.

[7.7.2 The History interface](https://html.spec.whatwg.org/multipage/history.html#the-history-interface)

[7.7.4 The Location interface](https://html.spec.whatwg.org/multipage/history.html#the-location-interface)

## Document
[3 Semantics, structure, and APIs of HTML documents](https://html.spec.whatwg.org/multipage/dom.html)

## Events
[8.1.5 Events](https://html.spec.whatwg.org/multipage/webappapis.html#events)

##### EventSource

[9.2.2 The EventSource interface](https://html.spec.whatwg.org/multipage/server-sent-events.html#event-stream-interpretation)

##### EventTarget

[EventTarget](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget)
> `EventTarget` is an interface implemented by objects that can receive events
> and have listeners (event handlers) for them.
> e.g. `Element`, `Document`, `Window`
> less common ones: `XMLHttpRequest`, `AudioNode`, `AUdioContext`, etc.
> Many event targets (including `Element`s, `Document`s, and `Window`s) also support setting event handlers via `on...` properties and attributes.

```typescript
interface EventTarget {
  addEventListener() : void;
  removeEventListener() : void;
  dispatchEvent() : void;
}

interface EventTargetConstuctor {
  new () : EventTarget;
}
```

## WebSocket

[9.3.2 The WebSocket interface](https://html.spec.whatwg.org/multipage/web-sockets.html#the-websocket-interface)

## Navigator
[8.8 System state and capabilities](https://html.spec.whatwg.org/multipage/system-state.html#system-state-and-capabilities)

## Storage

[11 Web storage](https://html.spec.whatwg.org/multipage/webstorage.html#webstorage)


# Dependencies

## purescript-halogen-vdom

- "purescript-prelude": "^4.0.0"
- "purescript-effect": "^2.0.0"
- "purescript-tuples": "^5.0.0"
- "purescript-maybe": "^4.0.0"
- "purescript-bifunctors": "^4.0.0"

- "purescript-unsafe-coerce": "^4.0.0"
- "purescript-refs": "^4.1.0"
- "purescript-foreign": "^5.0.0"
- "purescript-foreign-object": "^1.0.0"

- "purescript-web-html": "^1.0.0"


## purescript-web-html

- purescript-web-dom ^1.0.0
- purescript-web-file ^1.0.0
- purescript-web-storage ^2.0.0

- purescript-js-date ^6.0.0


### Moduels

- Web.HTML 
- Web.HTML.Window 
  - Web.HTML.HTMLDocument 
  - Web.HTML.History 
  - Web.HTML.Location 
  - Web.HTML.Navigator 
  - Web.Storage.Storage (purescript-web-storage)

- Web.HTML.HTMLDocument.ReadyState 
- Web.HTML.Event.BeforeUnloadEvent 
- Web.HTML.Event.BeforeUnloadEvent.EventTypes 
- Web.HTML.Event.DataTransfer 
- Web.HTML.Event.DragEvent 
- Web.HTML.Event.DragEvent.EventTypes 
- Web.HTML.Event.ErrorEvent 
- Web.HTML.Event.EventTypes 
- Web.HTML.Event.HashChangeEvent 
- Web.HTML.Event.HashChangeEvent.EventTypes 
- Web.HTML.Event.PageTransitionEvent 
- Web.HTML.Event.PageTransitionEvent.EventTypes 
- Web.HTML.Event.PopStateEvent 
- Web.HTML.Event.PopStateEvent.EventTypes 
- Web.HTML.Event.TrackEvent 
- Web.HTML.Event.TrackEvent.EventTypes 
- Web.HTML.HTMLAnchorElement 
- Web.HTML.HTMLAreaElement 
- Web.HTML.HTMLAudioElement 
- Web.HTML.HTMLBRElement 
- Web.HTML.HTMLBaseElement 
- Web.HTML.HTMLBodyElement 
- Web.HTML.HTMLButtonElement 
- Web.HTML.HTMLCanvasElement 
- Web.HTML.HTMLDListElement 
- Web.HTML.HTMLDataElement 
- Web.HTML.HTMLDataListElement 
- Web.HTML.HTMLDivElement 
- Web.HTML.HTMLElement 
- Web.HTML.HTMLEmbedElement 
- Web.HTML.HTMLFieldSetElement 
- Web.HTML.HTMLFormElement 
- Web.HTML.HTMLHRElement 
- Web.HTML.HTMLHeadElement 
- Web.HTML.HTMLHeadingElement 
- Web.HTML.HTMLIFrameElement 
- Web.HTML.HTMLImageElement 
- Web.HTML.HTMLInputElement 
- Web.HTML.HTMLKeygenElement 
- Web.HTML.HTMLLIElement 
- Web.HTML.HTMLLabelElement 
- Web.HTML.HTMLLegendElement 
- Web.HTML.HTMLLinkElement 
- Web.HTML.HTMLMapElement 
- Web.HTML.HTMLMediaElement 
- Web.HTML.HTMLMediaElement.CanPlayType 
- Web.HTML.HTMLMediaElement.NetworkState 
- Web.HTML.HTMLMediaElement.ReadyState 
- Web.HTML.HTMLMetaElement 
- Web.HTML.HTMLMeterElement 
- Web.HTML.HTMLModElement 
- Web.HTML.HTMLOListElement 
- Web.HTML.HTMLObjectElement 
- Web.HTML.HTMLOptGroupElement 
- Web.HTML.HTMLOptionElement 
- Web.HTML.HTMLOutputElement 
- Web.HTML.HTMLParagraphElement 
- Web.HTML.HTMLParamElement 
- Web.HTML.HTMLPreElement 
- Web.HTML.HTMLProgressElement 
- Web.HTML.HTMLQuoteElement 
- Web.HTML.HTMLScriptElement 
- Web.HTML.HTMLSelectElement 
- Web.HTML.HTMLSourceElement 
- Web.HTML.HTMLSpanElement 
- Web.HTML.HTMLStyleElement 
- Web.HTML.HTMLTableCaptionElement 
- Web.HTML.HTMLTableCellElement 
- Web.HTML.HTMLTableColElement 
- Web.HTML.HTMLTableDataCellElement 
- Web.HTML.HTMLTableElement 
- Web.HTML.HTMLTableHeaderCellElement 
- Web.HTML.HTMLTableRowElement 
- Web.HTML.HTMLTableSectionElement 
- Web.HTML.HTMLTemplateElement 
- Web.HTML.HTMLTextAreaElement 
- Web.HTML.HTMLTimeElement 
- Web.HTML.HTMLTitleElement 
- Web.HTML.HTMLTrackElement 
- Web.HTML.HTMLTrackElement.ReadyState 
- Web.HTML.HTMLUListElement 
- Web.HTML.HTMLVideoElement 

- Web.HTML.SelectionMode 
- Web.HTML.ValidityState 

```haskell
-- | Web.HTML
window :: Effect Window

-- | Web.HTML.Window
data Window :: Type

toEventTarget :: Window -> EventTarget

document :: Window -> Effect HTMLDocument
navigator :: Window -> Effect Navigator
location :: Window -> Effect Location
history :: Window -> Effect History
localStorage :: Window -> Effect Storage
sessionStorage :: Window -> Effect Storage

innerWidth :: Window -> Effect Int
innerHeight :: Window -> Effect Int
alert :: String -> Window -> Effect Unit
confirm :: String -> Window -> Effect Boolean
moveBy :: Int -> Int -> Window -> Effect Unit
moveTo :: Int -> Int -> Window -> Effect Unit
open :: String -> String -> String -> Window -> Effect (Maybe Window)
outerHeight :: Window -> Effect Int
outerWidth :: Window -> Effect Int
print :: Window -> Effect Unit
prompt :: String -> Window -> Effect (Maybe String)
promptDefault :: String -> String -> Window -> Effect (Maybe String)
_prompt :: String -> String -> Window -> Effect (Nullable String)
resizeBy :: Int -> Int -> Window -> Effect Unit
resizeTo :: Int -> Int -> Window -> Effect Unit
screenX :: Window -> Effect Int
screenY :: Window -> Effect Int

scroll :: Int -> Int -> Window -> Effect Unit
scrollBy :: Int -> Int -> Window -> Effect Unit
scrollX :: Window -> Effect Int
scrollY :: Window -> Effect Int

requestAnimationFrame :: Effect Unit -> Window -> Effect RequestAnimationFrameId
cancelAnimationFrame :: RequestAnimationFrameId -> Window -> Effect Unit
newtype RequestAnimationFrameId
requestIdleCallback :: { timeout :: Int } -> Effect Unit -> Window -> Effect RequestIdleCallbackId
cancelIdleCallback :: RequestIdleCallbackId -> Window -> Effect Unit
newtype RequestIdleCallbackId
```
