module ViewComponent where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP
import HalogenUtils (classList)
import ClassNames as CN
import CSSRoot (root) as CSSRoot
import Urls as Urls
import Svgs as Svgs

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

-- | Component

render :: forall q. State -> H.ComponentHTML q
render _ =
  HH.div_
  [ header
  , hero
  , gallery
  , navigator
  , footer
  , HC.stylesheet CSSRoot.root
  ]

  where
    header :: H.ComponentHTML q
    header =
      HH.div [ classList [ CN.header]]
      [ HH.h1 [ classList [ CN.logo]]
        [ Svgs.logo []
        ]
      , HH.button [ classList [ CN.headerButton]]
        [ HH.span_
          []
        , HH.span_
          []
        ]
      , HH.nav [ classList [CN.headerNavigationDesktop]]
        []
      , HH.nav [ classList [CN.headerNavigationMobile]]
        []
      ]

    hero :: H.ComponentHTML q
    hero =
      HH.section [ classList [ CN.hero]]
      [
        HH.h1 [ classList [ CN.heroTitle]]
        [ titleInstitute
        , titleFor
        , titleArchitectural
        , titleAnthropology
        ]
      , HH.p [ classList [ CN.heroHint]]
        [ HH.text "Scroll Down"]
      , HH.div [ classList [ CN.heroSpring]]
        [ HH.div [ classList [ CN.heroSpringTop]]
          []
        , HH.div [ classList [ CN.heroSpringBottom]]
          []
        ]
      ]
      where
        titleInstitute :: H.ComponentHTML q
        titleInstitute =
          HH.span_
          [ HH.b_
            [ HH.text "I"]
          , HH.span_
            [ HH.text "nstitute" ]
          ]

        titleFor :: H.ComponentHTML q
        titleFor =
          HH.span_
          [ HH.text "for"]

        titleArchitectural :: H.ComponentHTML q
        titleArchitectural =
          HH.span_
          [ HH.b_
            [ HH.text "A"]
          , HH.span_
            [ HH.text "rchitactural" ]
          ]

        titleAnthropology :: H.ComponentHTML q
        titleAnthropology =
          HH.span_
          [ HH.b_
            [ HH.text "A"]
          , HH.span_
            [ HH.text "nthropology" ]
          ]

    gallery :: H.ComponentHTML q
    gallery =
      HH.div [ classList [ CN.gallery]]
      [ galleryItem Urls.image01
      , galleryItem Urls.image02
      , galleryItem Urls.image03
      , galleryItem Urls.image04
      , galleryItem Urls.image05
      , galleryItem Urls.image06
      , galleryItem Urls.image07
      , galleryItem Urls.image08
      , galleryItem Urls.image09
      , galleryItem Urls.image10
      , galleryItem Urls.image11
      , galleryItem Urls.image12
      , galleryItem Urls.image13
      ]

      where
        galleryItem :: String -> H.ComponentHTML q
        galleryItem source=
          HH.figure [ classList [ CN.galleryItem]]
          [ HH.img [ HP.src source]
          ]

    navigator :: H.ComponentHTML q
    navigator =
      HH.div [ classList [ CN.navigator]]
      []

    footer :: H.ComponentHTML q
    footer =
      HH.div [ classList [ CN.footer]]
      [ HH.small_
        [ HH.text "© Institute of Architectural Anthropology"]
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
