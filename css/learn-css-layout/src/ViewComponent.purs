module ViewComponent where

import Prelude

import CSSModule (root) as CSSModule
import Data.Array (filter)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..), fst, snd)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP

-- | Types
type State = Unit
initialState :: State
initialState = unit

data Query next = NoOp next

type Input = Unit
type Output = Void

-- type IO = Aff

-- | Utils
classList
  :: forall r i
   . Array (Tuple String Boolean)
  -> H.IProp ("class" :: String | r) i
classList = HP.classes <<< map (H.ClassName <<< fst) <<< filter snd

-- | HTML
marginAuto :: forall q. H.ComponentHTML q
marginAuto =
  HH.div [ classList [ Tuple "elem" true ]
         , HP.id_ "main"
         ]
  [ HH.span [ HP.class_ $ H.ClassName "label"]
    [ HH.text "<div id=\"main\">"]
  , HH.p_
    [ HH.text "Setting the "
    , HH.code_
        [ HH.text "width" ]
    , HH.text " of a block-level element will prevent it from stretching out to the edges of its container to the left and right. Then, you can set the left and right margins to "
    , HH.code_
        [ HH.text "auto"]
    , HH.text " to horizontally center that element within its container. The element will take up the width you specify, then the remaining space will be split evenly between the two margins."
    ]
  , HH.p_
    [ HH.text "The only problem occurs when the browser window is narrower than the width of your element. The browser resolves this by creating a horizontal scrollbar on the page. Let's improve the situation..."]
  , HH.span [ HP.class_ $ H.ClassName "endLabel"]
    [ HH.text "</div>"]
  ]

maxWidth :: forall q. H.ComponentHTML q
maxWidth =
  HH.div [ classList [ Tuple "elem" true ]
         , HP.id_ "main2"
         ]
  [ HH.span [ HP.class_ $ H.ClassName "label"]
    [ HH.text "<div id=\"main2\">"]
  , HH.p_
    [ HH.text "Using "
    , HH.code_
        [ HH.text "max-width" ]
    , HH.text " instead of "
    , HH.code_
        [ HH.text "width"]
    , HH.text " in this situation will improve the browser's handling of small windows. This is important when making a site usable on mobile. Resize this page to check it out!"
    ]
  , HH.p_
    [ HH.text "By the way, "
    , HH.code_
        [ HH.text "max-width" ]
    , HH.text " is "
    , HH.a [ HP.href "http://caniuse.com/#search=max-width"]
      [ HH.text "supported by all major browsers"]
    , HH.text " including IE7+ so you shouldn't be afraid of using it."
    ]
  , HH.span [ HP.class_ $ H.ClassName "endLabel"]
    [ HH.text "</div>"]
  ]

theBoxModel :: forall q. H.ComponentHTML q
theBoxModel =
  HH.div_
  [ HH.div [ classList [ Tuple "elem" true ]
           , HP.id_ "simple"
           ]
    [ HH.span [ HP.class_ $ H.ClassName "label"]
      [ HH.text "<div id=\"simple\">"]
    , HH.p_
      [ HH.text " I'm smaller..."]
    , HH.span [ HP.class_ $ H.ClassName "endLabel"]
      [ HH.text "</div>"]
    ]
  , HH.div [ classList [ Tuple "elem" true ]
           , HP.id_ "fancy"
           ]
    [ HH.span [ HP.class_ $ H.ClassName "label"]
      [ HH.text "<div id=\"fancy\">"]
    , HH.p_
      [ HH.text "And I'm bigger!"]
    , HH.span [ HP.class_ $ H.ClassName "endLabel"]
      [ HH.text "</div>"]
    ]
  ]

boxSizing :: forall q. H.ComponentHTML q
boxSizing =
  HH.div_
  [ HH.div [ classList [ Tuple "elem" true ]
           , HP.id_ "simple2"
           ]
    [ HH.span [ HP.class_ $ H.ClassName "label"]
      [ HH.text "<div id=\"simple2\">"]
    , HH.p_
      [ HH.text "We're the same size now!"]
    , HH.span [ HP.class_ $ H.ClassName "endLabel"]
      [ HH.text "</div>"]
    ]
  , HH.div [ classList [ Tuple "elem" true ]
           , HP.id_ "fancy2"
           ]
    [ HH.span [ HP.class_ $ H.ClassName "label"]
      [ HH.text "<div id=\"fancy2\">"]
    , HH.p_
      [ HH.text "Hooray!"]
    , HH.span [ HP.class_ $ H.ClassName "endLabel"]
      [ HH.text "</div>"]
    ]
  ]

position :: forall q. H.ComponentHTML q
position =
  HH.div_
  [ HH.div [ HP.class_ $ H.ClassName "elem"]
    [ HH.span [ HP.class_ $ H.ClassName "label"]
      [ HH.text "<div id=\"static\">"]
    , HH.p [ HP.class_ $ H.ClassName "static"]
      [ HH.code_
        [ HH.text "static"]
      , HH.text " is the default value. An element with "
      , HH.code_
        [ HH.text "position: static"]
      , HH.text "; is not positioned in any special way. A static element is said to be not positioned and an element with its position set to anything else is said to be "
      , HH.i_
        [ HH.text "positioned"]
      , HH.text "."
      ]
    , HH.span [ HP.class_ $ H.ClassName "endLabel"]
      [ HH.text "</div>"]
    ]
  , HH.div [ classList [ Tuple "elem" true
                       , Tuple "relative1" true
                       ]
           ]
    [ HH.span [ HP.class_ $ H.ClassName "label"]
      [ HH.text "<div id=\"relative1\">"]
    , HH.p_
      [ HH.code_
        [ HH.text "relative"]
      , HH.text " behaves the same as "
      , HH.code_
        [ HH.text "static"]
      , HH.text " unless you add some extra properties."
      ]
    , HH.span [ HP.class_ $ H.ClassName "endLabel"]
      [ HH.text "</div>"]
    ]
  , HH.div [ classList [ Tuple "elem-red" true
                       , Tuple "relative2" true
                       ]
           ]
    [ HH.span [ HP.class_ $ H.ClassName "label"]
      [ HH.text "<div id=\"relative1\">"]
    , HH.p_
      [ HH.text "Setting the "
      , HH.code_
        [ HH.text "top"]
      , HH.text ", "
      , HH.code_
        [ HH.text "right"]
      , HH.text ", "
      , HH.code_
        [ HH.text "bottom"]
      , HH.text ", and "
      , HH.code_
        [ HH.text "left"]
      , HH.text " properties of a relatively-positioned element will cause it to be adjusted away from its normal position. Other content will not be adjusted to fit into any gap left by the element."
      ]
    , HH.span [ HP.class_ $ H.ClassName "endLabel"]
      [ HH.text "</div>"]
    ]
  ]

-- | Component
render :: State -> H.ComponentHTML Query
render _ =
  HH.div_
  [ HC.stylesheet CSSModule.root
  , marginAuto
  , maxWidth
  , theBoxModel
  , boxSizing
  , position
  ]

eval :: forall m. Query ~> H.ComponentDSL State Query Output m
eval (NoOp next) = pure next


component :: forall m. H.Component HH.HTML Query Input Output m
component = H.component spec
  where
    spec :: H.ComponentSpec HH.HTML State Query Input Output m
    spec =
      { initialState : const initialState
      , render
      , eval
      , receiver : const Nothing
      }
