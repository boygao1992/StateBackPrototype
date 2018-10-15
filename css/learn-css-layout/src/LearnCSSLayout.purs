module LearnCSSLayout where

import Prelude

import Data.Array (filter)
import Data.Tuple (Tuple(..), fst, snd)
import CSS.Selector (element) as CSS
import CSS.Stylesheet (CSS)
import CSS.Stylesheet (select) as CSS
import CSS.Background (backgroundColor)
import CSS.Border (solid, border) as CSS
import CSS.Common (auto) as CSS
import CSS.Display (position, absolute, relative) as CSS
import CSS.Font (color) as CSS
import CSS.Geometry (width, maxWidth, margin, top, left, padding, lineHeight) as CSS
import CSS.Size (nil, px, em) as CSS
import Color (Color)
import Color as Color
import Data.Maybe (Maybe(..), fromMaybe)
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

-- | Color
bgColor :: Color
bgColor = (fromMaybe Color.white) <<< Color.fromHexString $ "#ECECEC"

color_green :: Color
color_green = (fromMaybe Color.white) <<< Color.fromHexString $ "#6AC5AC"

color_dark :: Color
color_dark = (fromMaybe Color.white) <<< Color.fromHexString $ "#414142"

-- | CSS
style_main :: CSS
style_main = do
  CSS.width $ CSS.px 600.0
  CSS.margin CSS.nil CSS.auto CSS.nil CSS.auto

style_main2 :: CSS
style_main2 = do
  CSS.maxWidth $ CSS.px 600.0
  CSS.margin CSS.nil CSS.auto CSS.nil CSS.auto

style_elem :: CSS
style_elem = do
  CSS.border CSS.solid (CSS.px 3.0) color_green
  CSS.position CSS.relative

style_code :: CSS
style_code = backgroundColor bgColor

style_label :: CSS
style_label = do
  CSS.top CSS.nil
  CSS.left CSS.nil
  CSS.padding CSS.nil (CSS.px 3.0) (CSS.px 3.0) CSS.nil

style_endlabel :: CSS
style_endlabel = do
  style_label
  CSS.position CSS.absolute
  backgroundColor color_green
  CSS.color color_dark
  CSS.lineHeight $ CSS.em 1.0

style_select :: CSS
style_select = do
  CSS.select (CSS.element "code") style_code
  CSS.select (CSS.element ".main") style_main
  CSS.select (CSS.element ".elem") style_elem
  CSS.select (CSS.element ".label") style_endlabel
  CSS.select (CSS.element ".main2") style_main2

-- | Utils
classList
  :: forall r i
   . Array (Tuple String Boolean)
  -> H.IProp ("class" :: String | r) i
classList = HP.classes <<< map (H.ClassName <<< fst) <<< filter snd

-- | HTML
marginAuto :: forall q. H.ComponentHTML q
marginAuto =
  HH.div [ classList [ Tuple "main" true
                     , Tuple "elem" true
                     ]
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
  ]

maxWidth :: forall q. H.ComponentHTML q
maxWidth =
  HH.div [ classList [ Tuple "main2" true
                     , Tuple "elem" true
                     ]
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
  ]

-- | Component
render :: State -> H.ComponentHTML Query
render _ =
  HH.div_
  [ marginAuto
  , maxWidth
  , HC.stylesheet style_select
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
