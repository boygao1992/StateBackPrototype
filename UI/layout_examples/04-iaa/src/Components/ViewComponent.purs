module ViewComponent where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import HalogenUtils (classList, classList_)
import ClassNames as CN
import CSSRoot (root) as CSSRoot
import Urls as Urls
import Svgs as Svgs
import Data.Tuple (Tuple(Tuple))

-- | Types

type State =
  { buttonOpen :: Boolean
  }

initialState :: State
initialState =
  { buttonOpen : false
  }

data Query next
  = ButtonOnClick next

type Input = Unit

type Output = Void

-- type IO = Aff

-- | View

-- | Component

render :: State -> H.ComponentHTML Query
render { buttonOpen } =
  HH.div_
  [ header
  , hero
  , gallery
  , navigator
  , footer
  , HC.stylesheet CSSRoot.root
  ]

  where
    header :: H.ComponentHTML Query
    header =
      HH.header [ classList [ CN.header]]
      [
        HH.div [ classList [ CN.headerBar]]
        [ HH.h1 [ classList [ CN.headerLogo]]
          [ Svgs.logo []
          ]
        , HH.div [ classList [ CN.headerButtonContainer]]
          [ HH.button [ classList_ [ Tuple true CN.headerButton
                                   , Tuple buttonOpen CN.headerButtonOpen
                                   ]
                      , HE.onClick $ HE.input_ ButtonOnClick
                      ]
            [ HH.span [ classList [ CN.headerButtonPart1]]
              []
            , HH.span [ classList [ CN.headerButtonPart2]]
              []
            ]
          ]
        , HH.nav [ classList [ CN.headerNavigationDesktop]]
          [ HH.ul []
            [ HH.li_
              [ HH.a [ HP.href ""]
                [ HH.text "Home" ]
              ]
            , HH.li_
              [ HH.a [ HP.href ""]
                [ HH.text "Works" ]
              ]
            , HH.li_
              [ HH.a [ HP.href ""]
                [
                  HH.text "About"
                ]
              ]
            ]
          ]
        , HH.span [ classList [ CN.headerNavigationDesktopContact]]
          [ HH.a [ HP.href ""]
            [
              HH.text "Contact"
            ]
          ]
        , mobileNav
        ]
      ]

      where
        mobileNav :: H.ComponentHTML Query
        mobileNav =
          HH.nav [ classList_ [ Tuple true CN.headerNavigationMobile
                              , Tuple buttonOpen CN.headerButtonOpen]]
          [ HH.ul []
            [ HH.li_
              [ HH.text "Home"]
            , HH.li_
              [ HH.text "Works"]
            , HH.li_
              [ HH.text "About"]
            , HH.li_
              [ HH.text "Contact"]
            ]
          ]


    hero :: forall q. H.ComponentHTML q
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
      , HH.div [ classList [ CN.heroSpringContainer]]
        [
          HH.div [ classList [ CN.heroSpring]]
          [ HH.div [ classList [ CN.heroSpringTop]]
            []
          , HH.div [ classList [ CN.heroSpringBottom]]
            []
          ]
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

    gallery :: forall q. H.ComponentHTML q
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

    navigator :: forall q. H.ComponentHTML q
    navigator =
      HH.div [ classList [ CN.navigator]]
      []

    footer :: forall q. H.ComponentHTML q
    footer =
      HH.div [ classList [ CN.footer]]
      [ HH.small_
        [ HH.text "© Institute of Architectural Anthropology"]
      ]

eval :: forall m. Query ~> H.ComponentDSL State Query Output m
eval (ButtonOnClick next) = next <$ do
  { buttonOpen } <- H.get
  H.modify_ $ _ { buttonOpen = not buttonOpen }

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
