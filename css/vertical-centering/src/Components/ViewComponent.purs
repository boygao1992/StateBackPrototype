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
import CSS as CSS

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
  HH.div [ classList [ CN.content]]
  [ HH.h1_
    [ HH.text "Vertically centering with CSS"]
  , HH.div [classList [ CN.section]]
    [ HH.h2 [ classList [ CN.title]]
      [ HH.text "table"]
    , HH.div [ classList [ CN.table]]
      [ HH.p_
        [ HH.text
          """
.table {
  display: table
}
.table p {
  display: tabel-cell
  vertical-align: center;
}
          """
        ]
      ]
    ]
  , HH.div [classList [ CN.section]]
    [ HH.h2 [ classList [ CN.title]]
      [ HH.text "absolute"]
    , HH.div [ classList [ CN.absolute]]
      [ HH.p_
        [ HH.text
          """
.absolute {
  position: relative;
}
.absolute p {
  position: absolute;
  top: 50%;
  width: 100%;
  transform: translateY(-50%);
}
          """
        ]
      ]
    ]
  , HH.div [classList [ CN.section]]
    [ HH.h2 [ classList [ CN.title]]
      [ HH.text "flexbox"]
    , HH.div [ classList [ CN.flexbox]]
      [ HH.p_
        [ HH.text
          """
.flexbox {
  display: flex;
  align-items: center;
  justify-content: center;
}
          """
        ]
      ]
    ]
  , HH.div [classList [ CN.section]]
    [ HH.h2 [ classList [ CN.title]]
      [ HH.text "grid"]
    , HH.div [ classList [ CN.grid]]
      [ HH.p_
        [ HH.text
          """
.grid {
  display: gird;
  align-items: center;
  justify-content: center;
}
          """
        ]
      ]
    ]
  , HH.div [classList [ CN.section]]
    [ HH.h2 [ classList [ CN.title]]
      [ HH.text "margins"]
    , HH.div [ classList [ CN.margins]]
      [ HH.p_
        [ HH.text
          """
.margin {
  display: flex;
}
.margin p {
  margin: auto;
}
          """
        ]
      ]
    ]
  , HH.div [classList [ CN.section]]
    [ HH.h2 [ classList [ CN.title]]
      [ HH.text "align-self"]
    , HH.div [ classList [ CN.alignSelf]]
      [ HH.p_
        [ HH.text
          """
.align-self {
  display: flex;
  justify-content: center;
}
.align-self p {
  align-self: center;
}
          """
        ]
      ]
    ]
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
