module ViewComponent where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP
import HalogenUtils (classList)
import ClassNames as CN
import Data.Array ((:))
import CSS.Root (root) as CSSRoot

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
render state =
  HH.div_
  [ sidebar
  , content
  , HC.stylesheet CSSRoot.root
  ]

  where
    sidebar :: H.ComponentHTML q
    sidebar =
      HH.div [ classList [ CN.sidebar]]
      [ HH.div [ classList [ CN.logo]]
        [ HH.text "Mosaic"
        , HH.span_
          [ HH.text "Grid"]
        ]
      , HH.nav_
        [ HH.a [ classList [ CN.navItem]
               , HP.href ""]
          [ HH.text "Home"]
        , HH.a [ classList [ CN.navItem]
               , HP.href ""]
          [ HH.text "About"]
        , HH.a [ classList [ CN.navItem
                           , CN.active]
               , HP.href ""]
          [ HH.text "Portfolio"]
        , HH.a [ classList [ CN.navItem]
               , HP.href ""]
          [ HH.text "Contact"]
        ]
      ]

    content :: H.ComponentHTML q
    content =
      HH.div [ classList [ CN.content]]
      [ HH.div [ classList [ CN.portfolio]]
        [ portfolioItem "one" [ CN.medium ]
        , portfolioItem "two" [ CN.large, CN.two]
        , portfolioItem "three" [ CN.medium ]
        , portfolioItem "four" [ CN.small ]
        , portfolioItem "five" [ CN.tall ]
        , portfolioItem "six" [ CN.wide ]
        ]
      ]
      where
        portfolioItem :: String -> Array String -> H.ComponentHTML q
        portfolioItem title classNames =
          HH.div [ classList $ CN.portfolioItem : classNames
                 ]
          [ HH.text title]


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
