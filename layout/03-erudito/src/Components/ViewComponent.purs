module ViewComponent where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP
import CSS (alignItems, backgroundColor, border, color, display, em, flex, flexDirection, flexEnd, flexStart, flexWrap, fontSize, height, justifyContent, lineHeight, marginRight, marginTop, maxWidth, nil, nowrap, pct, px, rem, row, solid, spaceBetween, textWhitespace, whitespaceNoWrap, width, wrap) as CSS
import CSS.Common (center) as CSS
import Colors as Colors
import CSSUtils (borderRadius1, margin2, padding2) as CSS
import Images as Images
import Urls as Urls
import IDs as IDs
import CSSRoot (root) as CSSRoot

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
  HH.div [ HP.id_ IDs.header]
  [ HH.div [ HP.id_ IDs.navbar]
    [ logo
    , nav
    , contact
    , HH.img [ HP.src Images.bubbleGreen]
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

    nav :: H.ComponentHTML q
    nav =
      HH.nav [ HP.id_ IDs.desktopMenu
             ]
      [ HH.a [ HP.href "/work"]
        [ HH.text "Work"]
      , HH.a [ HP.href "/services"]
        [ HH.text "Services"]
      , HH.a [ HP.href "/about"]
        [ HH.text "About"]
      , HH.a [ HP.href "/careers"]
        [ HH.text "Carrers"]
      , HH.a [ HP.href "/blog"]
        [ HH.text "Blog"]
      ]

    contact :: H.ComponentHTML q
    contact =
      HH.a [ HP.id_ IDs.contact]
      [ HH.text "contact"]

body :: forall q. H.ComponentHTML q
body =
  HH.div [ HC.style do
             CSS.marginTop (CSS.rem 3.8)
         ]
  [ content
  ]

content :: forall q. H.ComponentHTML q
content =
  HH.div [ HP.id_ IDs.content]
  [ HH.div_
    [ textBlock
    , imageBlock
    ]
  ]
  where
    textBlock :: H.ComponentHTML q
    textBlock =
      HH.div [ HP.id_ IDs.splashText]
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
      HH.div [ HP.id_ IDs.splashImage]
      [ HH.img [ HP.src Urls.main]
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
  , HC.stylesheet CSSRoot.root
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
