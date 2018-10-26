module ViewComponent where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP
import CSS (absolute, alignItems, backgroundColor, block, border, boxSizing, color, display, em, flex, flexDirection, flexEnd, flexStart, flexWrap, fontSize, fontWeight, height, justifyContent, left, lineHeight, marginRight, marginTop, maxWidth, nil, nowrap, padding, pct, position, px, relative, rem, right, row, solid, spaceBetween, star, top, transform, vw, weight, width, zIndex, textWhitespace, whitespaceNoWrap, wrap) as CSS
import CSS (CSS, (?))
import CSS.Common (center, inherit) as CSS
import Colors as Colors
import CSSUtils (margin1, margin2, translate_, padding2, borderRadius1) as CSS
import Images as Images
import Urls as Urls

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
header :: forall q. H.ComponentHTML q
header =
  HH.div [ HC.style do
             CSS.height (CSS.px 35.0)
             CSS.display CSS.flex
             CSS.alignItems CSS.center
             CSS.justifyContent CSS.center
             CSS.padding (CSS.rem 1.9) CSS.nil (CSS.rem 3.9) CSS.nil
         ]
  [ HH.div [ HC.style do
               CSS.position CSS.relative
               CSS.top CSS.nil
               CSS.left CSS.nil
               CSS.right CSS.nil
               CSS.zIndex 1

               CSS.width (CSS.pct 75.0)
           ]
    [ HH.div [ HC.style do
                 CSS.display CSS.flex
                 CSS.alignItems CSS.center
                 CSS.justifyContent CSS.spaceBetween
             ]
      [ logo
      , nav
      , contact
      ]
    ]
  ]
  where
    logo :: H.ComponentHTML q
    logo =
      HH.div [ HC.style do
                 CSS.color Colors.white
                 CSS.backgroundColor Colors.warning
             ]
      [ HH.text "Erudito-logo" ]

    linkStyle :: CSS
    linkStyle = do
      CSS.color Colors.gray
      CSS.margin1 (CSS.rem 0.95)
      CSS.position CSS.relative

    nav :: H.ComponentHTML q
    nav =
      HH.nav [ HC.style do
                 CSS.display CSS.flex
             ]
      [ HH.a [ HC.style linkStyle
             , HP.href "/work"
             ]
        [ HH.text "Work"]
      , HH.a [ HC.style linkStyle
             , HP.href "/services"
             ]
        [ HH.text "Services"]
      , HH.a [ HC.style linkStyle
             , HP.href "/about"
             ]
        [ HH.text "About"]
      , HH.a [ HC.style linkStyle
             , HP.href "/careers"
             ]
        [ HH.text "Carrers"]
      , HH.a [ HC.style linkStyle
             , HP.href "/blog"
             ]
        [ HH.text "Blog"]
      ]

    contact :: H.ComponentHTML q
    contact =
      HH.a [ HC.style do
               CSS.color Colors.white
               CSS.display CSS.block
               CSS.fontWeight (CSS.weight 600.0)
           ]
      [ HH.text "contact"
      , HH.img [ HP.src Images.bubbleGreen
               , HC.style do
                   CSS.maxWidth (CSS.vw 50.0)
                   CSS.position CSS.absolute
                   CSS.transform $ CSS.translate_ (CSS.rem (-12.0)) (CSS.rem (-12.0))
                   CSS.zIndex (-1)
               ]
      ]

body :: forall q. H.ComponentHTML q
body =
  HH.div [ HC.style do
             CSS.marginTop (CSS.rem 3.8)
         ]
  [ content1
  ]

content1 :: forall q. H.ComponentHTML q
content1 =
  HH.div [ HC.style do
             CSS.display CSS.flex
             CSS.flexDirection CSS.row
             CSS.alignItems CSS.flexStart
             CSS.justifyContent CSS.center
             CSS.flexWrap CSS.nowrap
             CSS.height (CSS.rem 15.0)
         ]
  [ HH.div [ HC.style do
               CSS.display CSS.flex
               CSS.flexDirection CSS.row
               CSS.alignItems CSS.center
               CSS.justifyContent CSS.spaceBetween
               CSS.flexWrap CSS.nowrap
               CSS.width (CSS.pct 75.0)
           ]
    [ textBlock
    , imageBlock
    ]
  ]
  where
    textBlock :: H.ComponentHTML q
    textBlock =
      HH.div [ HC.style do
                 CSS.maxWidth (CSS.pct 35.0)
             ]
      [ HH.h1 [ HC.style do
                  CSS.fontSize (CSS.rem 3.0)
                  CSS.lineHeight (CSS.pct 110.0)
              ]
        [ HH.text "Award-winning design studio in Sydney, Australia"]
      , HH.p [ HC.style do
                 CSS.margin2 (CSS.em 1.2) CSS.nil
                 CSS.lineHeight (CSS.pct 200.0)
             ]
        [ HH.text "Erudito is a design studio that creates beautiful digital products, brands and experiences for amazing companies and disruptive startups. Got something cool for us to work on?"
        ]
      , buttonBlock
      ]

    imageBlock :: H.ComponentHTML q
    imageBlock =
      HH.div [ HC.style do
                 CSS.maxWidth (CSS.pct 50.0)
             ]
      [ HH.img [ HP.src Urls.main
               , HC.style do
                   CSS.width (CSS.pct 100.0)
               ]
      ]

    buttonBlock :: H.ComponentHTML q
    buttonBlock =
      HH.div [ HC.style do
                 CSS.display CSS.flex
                 CSS.flexDirection CSS.row
                 CSS.justifyContent CSS.flexStart
                 CSS.alignItems CSS.flexEnd
                 CSS.flexWrap CSS.wrap
             ]
      [ HH.a [ HP.href "/contact"
             , HC.style do
                 CSS.marginRight (CSS.rem 1.0)
                 CSS.padding2 (CSS.rem 1.05) (CSS.rem 1.85)
                 CSS.backgroundColor Colors.purple
                 CSS.color Colors.white
                 CSS.borderRadius1 (CSS.px 5.0)
                 CSS.textWhitespace CSS.whitespaceNoWrap
             ]
        [ HH.text "Get in touch"]
      , HH.a [ HP.href "/contact"
             , HC.style do
                 CSS.marginTop (CSS.rem 1.0)
                 CSS.padding2 (CSS.rem 1.05) (CSS.rem 1.85)
                 CSS.backgroundColor Colors.white
                 CSS.color Colors.gray
                 CSS.border CSS.solid (CSS.px 1.0) Colors.gray
                 CSS.borderRadius1 (CSS.px 5.0)
                 CSS.textWhitespace CSS.whitespaceNoWrap
             ]
        [ HH.text "Watch our reel"]
      ]

-- | Component

render :: forall q. State -> H.ComponentHTML q
render _ =
  HH.div_
  [ header
  , body
  , HC.stylesheet do
      CSS.star ? do
        CSS.boxSizing CSS.inherit
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
