module ViewComponent where

import Prelude

import ClassNames as CN
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP
import HalogenUtils (classList)
import CSSRoot as CSSRoot

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
        [ HH.text "The "
        , HH.code_
          [ HH.text "margin-left"]
        , HH.text " style for "
        , HH.code_
          [ HH.text "section"]
        , HH.text "s makes sure there is room for the "
        , HH.code_
          [ HH.text "nav"]
        , HH.text ". Otherwise, the absolute and static elements would overlap"
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

-- | Component

render :: forall q. State -> H.ComponentHTML q
render _ =
  HH.div_
  [ flexboxExample
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
