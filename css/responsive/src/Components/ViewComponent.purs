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
  , aboutUs
  , portfolio
  , footer
  , HC.stylesheet CSSRoot.root
  ]

  where
    header :: H.ComponentHTML q
    header =
      HH.header_
      [ HH.img [ HP.src Urls.logo
              , HP.alt ""
              , classList [ CN.logo]]
      , HH.nav_
        [ HH.ul_
          [ HH.li_
            [ HH.a [ HP.href "/home"]
              [ HH.text "Home"]
            ]
          , HH.li_
            [ HH.a [ HP.href "/about"]
              [ HH.text "About"]
            ]
          , HH.li_
            [ HH.a [ HP.href "/contact"]
              [ HH.text "Contact"]
            ]
          ]
        ]
      ]

    hero :: H.ComponentHTML q
    hero =
      HH.section [ classList [ CN.homeHero]]
      [ HH.div [ classList [ CN.container]]
        [ HH.h1 [ classList [ CN.title]]
          [ HH.text "Making things looks great"
          , HH.span_
            [ HH.text "for companies who make great stuff"]
          ]
        , HH.a [ HP.href "/projects"
               , classList [ CN.button, CN.buttonAccent]]
          [ HH.text "See Our Work"]
        ]
      ]

    aboutUs :: H.ComponentHTML q
    aboutUs =
      HH.section [ classList [ CN.homeAbout]]
      [ HH.div [ classList [ CN.homeAboutText]]
        [ HH.h1_
          [ HH.text "Who we are"]
        , HH.p_
          [ HH.text "Sit by the fire drink water out of faucet hide head under blanket so no one can see cat is love, cat is life. Knock dish off table eating always hungry so favor packing over toy"]
        , HH.p_
          [ HH.strong_
            [ HH.text "Rub face on owners."]
          , HH.text " Peer out window, chatter at birds, lure them to mouth. Chase ball of string eat a plant, kill a hand, i am the best have secret plans."
          ]
        ]
      ]

    portfolio :: H.ComponentHTML q
    portfolio =
      HH.section [ classList [ CN.portfolio]]
      [ HH.h1_
        [ HH.text "Some of our work"
        ]
      , portfolioItem Urls.portfolio1
      , portfolioItem Urls.portfolio2
      , portfolioItem Urls.portfolio3
      , portfolioItem Urls.portfolio4
      , portfolioItem Urls.portfolio5
      , portfolioItem Urls.portfolio6
      ]
      where
        portfolioItem :: String -> H.ComponentHTML q
        portfolioItem url =
          HH.figure [ classList [ CN.portfolioItem]]
          [ HH.img [ HP.src url
                   , HP.alt "portfolio item"
                   ]
          , HH.figcaption [ classList [ CN.portfolioDescription]]
            [ HH.p_
              [ HH.text "Project title"]
            , HH.a [ HP.href ""
                   , classList [ CN.button, CN.buttonAccent, CN.buttonSmall]]
              [ HH.text "Project details"]
            ]
          ]

    footer :: H.ComponentHTML q
    footer =
      HH.footer_
      [ description
      , links
      , links
      , links
      ]
      where
        description :: H.ComponentHTML q
        description =
          HH.div [ classList [ CN.column3]]
          [ HH.p_
            [ HH.text "Shoreditch bespoke leggings, tote bag williamsburg woke retro readymade scenester brunch art party farm-to-table pug. Wayfarers lyft prism, edison bulb distillery pok pok narwhal pinterest poke."]
          ]

        links :: H.ComponentHTML q
        links =
          HH.div [ classList [ CN.column1]]
          [ HH.ul [ classList [ CN.unstyledList]]
            [ HH.li_
              [ HH.strong_
                [ HH.text "Shoreditch"]
              ]
            , HH.li_
              [ HH.text "Bag williamsburg"]
            , HH.li_
              [ HH.text "Woke retro"]
            , HH.li_
              [ HH.text "Readymade"]
            , HH.li_
              [ HH.text "Scenester"]
            ]
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
