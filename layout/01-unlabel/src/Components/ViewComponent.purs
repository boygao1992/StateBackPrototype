module ViewComponent where

import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP
import CSS as CSS
import CSS.Common (center) as CSS
import Colors as Colors
import CSSUtils  as CSS
import HalogenUtils (svg_) as HH
import Urls as Urls
import IDs as IDs
-- import CSSRoot (root) as CSSRoot
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
  [ HH.svg_ "icon" Svgs.logo []
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
