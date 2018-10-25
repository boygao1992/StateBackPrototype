module ViewComponent where

import Prelude

import ClassNames as CN
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP
import HalogenUtils (classList)
import CSS as CSS
import CSSUtils (spaceEvenly) as CSS
import CSS.TextAlign (center, textAlign) as CSSText
import CSS.Common (center) as CSS
import Color (white) as Color
import Color.Scheme.X11 (gray, orangered, steelblue, yellowgreen) as Color

-- | Types

type State = Unit

initialState :: State
initialState = unit

data Query next
  = NoOp next

type Input = Unit

type Output = Void

-- type IO = Aff

-- | View

flexboxExample :: forall q. H.ComponentHTML q
flexboxExample =
  HH.div [ classList
           [ CN.container
           , CN.elem
           ]
         ]
  [ HH.span [ classList [ CN.label]
            ]
    [ HH.text "<div class=\"container\">"]
  , flexboxExampleNav
  , HH.div [ classList
             [ CN.flexColumn ]
           ]
      [ flexboxExampleSection1
      , flexboxExampleSection2
      ]
  ]
  where
    flexboxExampleNav :: H.ComponentHTML q
    flexboxExampleNav =
      HH.nav [ classList
               [ "nav"
               , CN.elemRed
               ]
             ]
      [ HH.span [ classList [ CN.label]]
        [ HH.text "<nav>"]
      , HH.ul_
        [ HH.li_
          [ HH.a [ HP.href "."]
            [ HH.text "Home"]
          ]
        , HH.li_
          [ HH.a [ HP.href "."]
            [ HH.text "Taco Menu"]
          ]
        , HH.li_
          [ HH.a [ HP.href "."]
            [ HH.text "Draft List"]
          ]
        , HH.li_
          [ HH.a [ HP.href "."]
            [ HH.text "Hours"]
          ]
        , HH.li_
          [ HH.a [ HP.href "."]
            [ HH.text "Directions"]
          ]
        , HH.li_
          [ HH.a [ HP.href "."]
            [ HH.text "Contact"]
          ]
        ]
      , HH.span [ classList [ CN.endLabel]]
        [ HH.text "</nav>"]
      ]

    flexboxExampleSection1 :: H.ComponentHTML q
    flexboxExampleSection1 =
      HH.section [ classList [ CN.elemYellow]]
      [ HH.span [ classList [ CN.label]]
        [ HH.text "<section>"]
      , HH.p_
        [ HH.text "Flexbox layout"
        ]
      , HH.span [ classList [ CN.endLabel]]
        [ HH.text "</section>"]
      ]

    flexboxExampleSection2 :: H.ComponentHTML q
    flexboxExampleSection2 =
      HH.section [ classList [ CN.elemYellow ]
                   -- [ ClassNames.elem
                   -- , ClassNames.elemYellow
                   -- , ClassNames.section
                   -- , "ipsum"
                   -- ]
                 ]
      [ HH.span [ classList [ CN.label]]
        [ HH.text "<section>"]
      , HH.p_
        [ HH.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Fusce luctus vestibulum augue ut aliquet. Mauris ante ligula, facilisis sed ornare eu, lobortis in odio. Praesent convallis urna a lacus interdum ut hendrerit risus congue. Nunc sagittis dictum nisi, sed ullamcorper ipsum dignissim ac. In at libero sed nunc venenatis imperdiet sed ornare turpis. Donec vitae dui eget tellus gravida venenatis. Integer fringilla congue eros non fermentum. Sed dapibus pulvinar nibh tempor porta. Cras ac leo purus. Mauris quis diam velit."
        ]
      , HH.span [ classList [ CN.endLabel]]
        [ HH.text "</section>"]
      ]

flexWrapExample :: forall q. H.ComponentHTML q
flexWrapExample =
  HH.div_
  [ HH.h4_
    [ HH.text "flex-wrap: wrap;"]
  , flexWrap CSS.wrap
  , HH.h4_
    [ HH.text "flex-wrap: no-wrap;"]
  , flexWrap CSS.nowrap
  ,  HH.h4_
    [ HH.text "flex-wrap: wrap-reverse;"]
  , flexWrap CSS.wrapReverse
  ]

  where
    flexWrap :: CSS.FlexWrap -> H.ComponentHTML q
    flexWrap fw =
      HH.div [ HC.style do
                CSS.display CSS.flex
                CSS.flexWrap fw

                CSS.color Color.white
                CSS.height (CSS.px 150.0)
                CSSText.textAlign CSSText.center
                CSS.border CSS.solid (CSS.px 3.0) Color.gray
             ]
      [ HH.div [ HC.style do
                  CSS.backgroundColor Color.orangered
                  CSS.height (CSS.pct 50.0)
                  CSS.width (CSS.pct 50.0)
               ]
        [ HH.text "1"]
      , HH.div [ HC.style do
                  CSS.backgroundColor Color.yellowgreen
                  CSS.height (CSS.pct 50.0)
                  CSS.width (CSS.pct 50.0)
               ]
        [ HH.text "2"]
      , HH.div [ HC.style do
                  CSS.backgroundColor Color.steelblue
                  CSS.height (CSS.pct 50.0)
                  CSS.width (CSS.pct 50.0)
               ]
        [ HH.text "3"]
      ]

justifyContentExample :: forall q. H.ComponentHTML q
justifyContentExample =
  HH.div_
  [ justifyContentTemplate "flex-start" CSS.flexStart
  , justifyContentTemplate "flex-end" CSS.flexEnd
  , justifyContentTemplate "center" CSS.center
  , justifyContentTemplate "space-around" CSS.spaceAround
  , justifyContentTemplate "space-between" CSS.spaceBetween
  , justifyContentTemplate "space-evenly" CSS.spaceEvenly
  ]
  where
    justifyContentTemplate :: String -> CSS.JustifyContentValue -> H.ComponentHTML q
    justifyContentTemplate str jc =
      HH.div_
      [ HH.h4_
        [ HH.text $ "justify-content: " <> str <> ";"]
      , HH.div [ HC.style do
                   CSS.display CSS.flex
                   CSS.justifyContent jc
               ]
        [ HH.div [ HC.style do
                     CSS.backgroundColor Color.orangered
                     CSS.width (CSS.px 100.0)
                     CSS.height (CSS.px 100.0)
                 ]
          [ HH.text "1"]
        , HH.div [ HC.style do
                     CSS.backgroundColor Color.yellowgreen
                     CSS.width (CSS.px 100.0)
                     CSS.height (CSS.px 100.0)
                 ]
          [ HH.text "2"]
        , HH.div [ HC.style do
                     CSS.backgroundColor Color.steelblue
                     CSS.width (CSS.px 100.0)
                     CSS.height (CSS.px 100.0)
                 ]
          [ HH.text "3"]
        ]
      ]

-- | Component

render :: forall q. State -> H.ComponentHTML q
render _ =
  HH.div_
  [ flexboxExample
  , flexWrapExample
  , justifyContentExample
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
