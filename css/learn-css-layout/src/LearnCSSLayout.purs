module LearnCSSLayout where

import Prelude

import CSS.Background (backgroundColor)
import CSS.Border (solid, border) as CB
import CSS.Common (auto) as CC
import CSS.Display (position, absolute, relative) as CD
import CSS.Font (color) as CF
import CSS.Geometry (width, maxWidth, margin, top, left, padding, lineHeight) as CG
import CSS.Size as CS
import CSS.Stylesheet (StyleM)
import Color (Color)
import Color as Color
import Data.Maybe (Maybe(..), fromMaybe)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
-- import Halogen.HTML.Properties as HP

type State = Unit
initialState :: State
initialState = unit

data Query next = NoOp next

type Input = Unit
type Output = Void

-- type IO = Aff

bgColor :: Color
bgColor = (fromMaybe Color.white) <<< Color.fromHexString $ "#ECECEC"

color_green :: Color
color_green = (fromMaybe Color.white) <<< Color.fromHexString $ "#6AC5AC"

color_dark :: Color
color_dark = (fromMaybe Color.white) <<< Color.fromHexString $ "#414142"

style_main :: StyleM Unit
style_main = do
  CG.width $ CS.px 600.0
  CG.margin CS.nil CC.auto CS.nil CC.auto

style_main2 :: StyleM Unit
style_main2 = do
  CG.maxWidth $ CS.px 600.0
  CG.margin CS.nil CC.auto CS.nil CC.auto

style_elem :: StyleM Unit
style_elem = do
  CB.border CB.solid (CS.px 3.0) color_green
  CD.position CD.relative

style_code :: StyleM Unit
style_code = backgroundColor bgColor

style_label :: StyleM Unit
style_label = do
  CG.top CS.nil
  CG.left CS.nil
  CG.padding CS.nil (CS.px 3.0) (CS.px 3.0) CS.nil

style_endlabel :: StyleM Unit
style_endlabel = do
  style_label
  CD.position CD.absolute
  backgroundColor color_green
  CF.color color_dark
  CG.lineHeight $ CS.em 1.0

marginAuto :: forall q. H.ComponentHTML q
marginAuto =
  HH.div [ HC.style do
             style_main
             style_elem
         ]
  [ HH.span [ HC.style style_endlabel]
    [ HH.text "<div id=\"main\">"]
  , HH.p_
    [ HH.text "Setting the "
    , HH.code
        [ HC.style style_code ]
        [ HH.text "width" ]
    , HH.text " of a block-level element will prevent it from stretching out to the edges of its container to the left and right. Then, you can set the left and right margins to "
    , HH.code
        [ HC.style style_code ]
        [ HH.text "auto"]
    , HH.text " to horizontally center that element within its container. The element will take up the width you specify, then the remaining space will be split evenly between the two margins."
    ]
  , HH.p_
    [ HH.text "The only problem occurs when the browser window is narrower than the width of your element. The browser resolves this by creating a horizontal scrollbar on the page. Let's improve the situation..."]
  ]


render :: State -> H.ComponentHTML Query
render _ =
  HH.div_
  [ marginAuto
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
