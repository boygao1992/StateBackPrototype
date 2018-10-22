module ViewComponent where

import Prelude

import CSSModule (root) as CSSModule
import ClassNames as ClassNames
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP

-- | Types
type State = Unit
initialState :: State
initialState = unit

data Query next = NoOp next

type Input = Unit
type Output = Void

-- type IO = Aff

-- | Utils
classList
  :: forall r i
   . Array String
  -> H.IProp ("class" :: String | r) i
classList = HP.classes <<< map H.ClassName

-- | HTML
marginAuto :: forall q. H.ComponentHTML q
marginAuto =
  HH.div [ classList [ ClassNames.elem ]
         , HP.id_ "main"
         ]
  [ HH.span [ classList [ ClassNames.label ] ]
    [ HH.text "<div id=\"main\">"]
  , HH.p_
    [ HH.text "Setting the "
    , HH.code_
        [ HH.text "width" ]
    , HH.text " of a block-level element will prevent it from stretching out to the edges of its container to the left and right. Then, you can set the left and right margins to "
    , HH.code_
        [ HH.text "auto"]
    , HH.text " to horizontally center that element within its container. The element will take up the width you specify, then the remaining space will be split evenly between the two margins."
    ]
  , HH.p_
    [ HH.text "The only problem occurs when the browser window is narrower than the width of your element. The browser resolves this by creating a horizontal scrollbar on the page. Let's improve the situation..."]
  , HH.span [ classList [ ClassNames.endLabel ] ]
    [ HH.text "</div>"]
  ]

maxWidth :: forall q. H.ComponentHTML q
maxWidth =
  HH.div [ classList [ ClassNames.elem ]
         , HP.id_ "main2"
         ]
  [ HH.span [ classList [ ClassNames.label ] ]
    [ HH.text "<div id=\"main2\">"]
  , HH.p_
    [ HH.text "Using "
    , HH.code_
        [ HH.text "max-width" ]
    , HH.text " instead of "
    , HH.code_
        [ HH.text "width"]
    , HH.text " in this situation will improve the browser's handling of small windows. This is important when making a site usable on mobile. Resize this page to check it out!"
    ]
  , HH.p_
    [ HH.text "By the way, "
    , HH.code_
        [ HH.text "max-width" ]
    , HH.text " is "
    , HH.a [ HP.href "http://caniuse.com/#search=max-width"]
      [ HH.text "supported by all major browsers"]
    , HH.text " including IE7+ so you shouldn't be afraid of using it."
    ]
  , HH.span [ classList [ ClassNames.endLabel ] ]
    [ HH.text "</div>"]
  ]

theBoxModel :: forall q. H.ComponentHTML q
theBoxModel =
  HH.div_
  [ HH.div [ classList [ ClassNames.elem ]
           , HP.id_ "simple"
           ]
    [ HH.span [ classList [ ClassNames.label ] ]
      [ HH.text "<div id=\"simple\">"]
    , HH.p_
      [ HH.text " I'm smaller..."]
    , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
      [ HH.text "</div>"]
    ]

  , HH.div [ classList [ ClassNames.elem ]
           , HP.id_ "fancy"
           ]
    [ HH.span [ classList [ ClassNames.label ] ]
      [ HH.text "<div id=\"fancy\">"]
    , HH.p_
      [ HH.text "And I'm bigger!"]
    , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
      [ HH.text "</div>"]
    ]
  ]

boxSizing :: forall q. H.ComponentHTML q
boxSizing =
  HH.div_
  [ HH.div [ classList [ ClassNames.elem ]
           , HP.id_ "simple2"
           ]
    [ HH.span [ classList [ ClassNames.label ] ]
      [ HH.text "<div id=\"simple2\">"]
    , HH.p_
      [ HH.text "We're the same size now!"]
    , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
      [ HH.text "</div>"]
    ]

  , HH.div [ classList [ ClassNames.elem ]
           , HP.id_ "fancy2"
           ]
    [ HH.span [ classList [ ClassNames.label ] ]
      [ HH.text "<div id=\"fancy2\">"]
    , HH.p_
      [ HH.text "Hooray!"]
    , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
      [ HH.text "</div>"]
    ]
  ]

position :: forall q. H.ComponentHTML q
position =
  HH.div_
  [ positionStatic
  , positionRelative
  , positionFixed
  , positionAbsolute
  ]
  where
    positionStatic :: H.ComponentHTML q
    positionStatic =
      HH.div [ HP.class_ $ H.ClassName ClassNames.elem]
      [ HH.span [ classList [ ClassNames.label ] ]
        [ HH.text "<div id=\"static\">"]
      , HH.p [ HP.class_ $ H.ClassName "static"]
        [ HH.code_
          [ HH.text "static"]
        , HH.text " is the default value. An element with "
        , HH.code_
          [ HH.text "position: static"]
        , HH.text "; is not positioned in any special way. A static element is said to be not positioned and an element with its position set to anything else is said to be "
        , HH.i_
          [ HH.text "positioned"]
        , HH.text "."
        ]
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</div>"]
      ]

    positionRelative :: H.ComponentHTML q
    positionRelative =
      HH.div_
      [ HH.div [ classList [ ClassNames.elem , "relative1" ] ]
        [ HH.span [ classList [ ClassNames.label ] ]
          [ HH.text "<div id=\"relative1\">"]
        , HH.p_
          [ HH.code_
            [ HH.text "relative"]
          , HH.text " behaves the same as "
          , HH.code_
            [ HH.text "static"]
          , HH.text " unless you add some extra properties."
          ]
        , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
          [ HH.text "</div>"]
        ]

      , HH.div [ classList [ ClassNames.elemRed, "relative2" ] ]
        [ HH.span [ classList [ ClassNames.label ] ]
          [ HH.text "<div id=\"relative2\">"]
        , HH.p_
          [ HH.text "Setting the "
          , HH.code_
            [ HH.text "top"]
          , HH.text ", "
          , HH.code_
            [ HH.text "right"]
          , HH.text ", "
          , HH.code_
            [ HH.text "bottom"]
          , HH.text ", and "
          , HH.code_
            [ HH.text "left"]
          , HH.text " properties of a relatively-positioned element will cause it to be adjusted away from its normal position. Other content will not be adjusted to fit into any gap left by the element."
          ]
        , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
          [ HH.text "</div>"]
        ]
      ]

    positionFixed :: H.ComponentHTML q
    positionFixed =
      HH.div [ classList [ ClassNames.elemYellow, "fixed" ] ]
      [ HH.span [ classList [ ClassNames.label ] ]
        [ HH.text "<div id=\"fixed\">"]
      , HH.p_
        [ HH.text "Hello! Don't pay attention to me yet."]
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</div>"]
      ]

    positionAbsolute :: H.ComponentHTML q
    positionAbsolute =
      HH.div_
      [ HH.div [ classList [ ClassNames.elem, "relative" ] ]
        [ HH.span [ classList [ ClassNames.label ] ]
          [ HH.text "<div id=\"relative\">"]
        , HH.p_
          [ HH.text "This element is relatively-positioned. If this element was "
          , HH.code_
            [ HH.text "position: static"]
          , HH.text"; its absolutely-positioned child would escape and would be positioned relative to the document body. "
          ]
        , HH.div [ classList [ ClassNames.elemRed, "absolute" ] ]
          [ HH.span [ classList [ ClassNames.label ] ]
            [ HH.text "<div id=\"absolute\">"]
          , HH.p_
            [ HH.text "This element is absolutely-positioned. It's positioned relative to its parent."]
          , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
            [ HH.text "</div>"]
          ]
        , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
          [ HH.text "</div>"]
        ]
      ]

positionExample :: forall q. H.ComponentHTML q
positionExample =
  HH.div [ classList
           [ ClassNames.elem
           , "container"
           ]
         ]
  [ HH.span [ classList [ ClassNames.label ] ]
    [ HH.text "<div class=\"container\">"]
  , positionExampleNav
  , positionExampleSection1
  , positionExampleSection2
  , positionExampleSection3
  -- , positionExampleFooter
  ]
  where
    positionExampleNav :: H.ComponentHTML q
    positionExampleNav =
      HH.nav [ classList
               [ ClassNames.elem
               , ClassNames.elemRed
               ]
             ]
      [ HH.span [ classList [ ClassNames.label ] ]
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
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</nav>"]
      ]

    positionExampleSection1 :: H.ComponentHTML q
    positionExampleSection1 =
      HH.section [ classList
                   [ ClassNames.elem
                   , ClassNames.elemYellow
                   , ClassNames.section
                   ]
                 ]
      [ HH.span [ classList [ ClassNames.label ] ]
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
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</section>"]
      ]

    positionExampleSection2 :: H.ComponentHTML q
    positionExampleSection2 =
      HH.section [ classList
                   [ ClassNames.elem
                   , ClassNames.elemYellow
                   , ClassNames.section
                   , "ipsum"
                   ]
                 ]
      [ HH.span [ classList [ ClassNames.label ] ]
        [ HH.text "<section>"]
      , HH.p_
        [ HH.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Fusce luctus vestibulum augue ut aliquet. Mauris ante ligula, facilisis sed ornare eu, lobortis in odio. Praesent convallis urna a lacus interdum ut hendrerit risus congue. Nunc sagittis dictum nisi, sed ullamcorper ipsum dignissim ac. In at libero sed nunc venenatis imperdiet sed ornare turpis. Donec vitae dui eget tellus gravida venenatis. Integer fringilla congue eros non fermentum. Sed dapibus pulvinar nibh tempor porta. Cras ac leo purus. Mauris quis diam velit."
        ]
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</section>"]
      ]

    positionExampleSection3 :: H.ComponentHTML q
    positionExampleSection3 =
      HH.section [ classList
                   [ ClassNames.elem
                   , ClassNames.elemYellow
                   , ClassNames.section
                   ]
                 ]
      [ HH.span [ classList [ ClassNames.label ] ]
        [ HH.text "<section>"]
      , HH.p_
        [ HH.text "Notice what happens when you resize your browser. It works nicely!"
        ]
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</section>"]
      ]

    positionExampleFooter :: H.ComponentHTML q
    positionExampleFooter =
      HH.footer [ classList
                  [ ClassNames.elem
                  , ClassNames.elemGreen
                  ]
                ]
      [ HH.span [ classList [ ClassNames.label ] ]
        [ HH.text "<footer>"]
      , HH.p_
        [ HH.text "If you use a fixed header or footer, make sure there is room for it! I put a "
        , HH.code_
          [ HH.text "margin-bottom"]
        , HH.text " on the "
        , HH.code_
          [ HH.text "body"]
        , HH.text "."
        ]
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</footer>"]
      ]

float_ :: forall q. H.ComponentHTML q
float_ =
  HH.p [ classList [ "content" , "ipsum" ] ]
  [ HH.img [ HP.src "./images/ilta.png" ]
  , HH.p_
    [ HH.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Fusce luctus vestibulum augue ut aliquet. Mauris ante ligula, facilisis sed ornare eu, lobortis in odio. Praesent convallis urna a lacus interdum ut hendrerit risus congue. Nunc sagittis dictum nisi, sed ullamcorper ipsum dignissim ac. In at libero sed nunc venenatis imperdiet sed ornare turpis. Donec vitae dui eget tellus gravida venenatis. Integer fringilla congue eros non fermentum. Sed dapibus pulvinar nibh tempor porta. Cras ac leo purus. Mauris quis diam velit."
    ]
  ]

clear_ :: forall q. H.ComponentHTML q
clear_ =
  HH.div_
  [ withoutClear
  , withClear
  ]

  where
    withoutClear :: H.ComponentHTML q
    withoutClear =
      HH.div_
      [ HH.div [ classList [ "box", ClassNames.elem]]
        [ HH.span [ classList [ ClassNames.label]]
          [ HH.text "<div class=\"box\">"]
        , HH.p_
          [ HH.text "I feel like I'm floating!"]
        , HH.span [ classList [ ClassNames.endLabel]]
          [ HH.text "</div>"]
        ]
      , HH.section [ classList [ ClassNames.elem, ClassNames.elemYellow]]
        [ HH.span [ classList [ ClassNames.label]]
          [ HH.text "<section>"]
        , HH.p_
          [ HH.text "In this case, the "
          , HH.code_
            [ HH.text "section"]
          , HH.text " element is actually after the "
          , HH.code_
            [ HH.text "div"]
          , HH.text ". However, since the "
          , HH.code_
            [ HH.text "div"]
          , HH.text " is floated to the left, this is what happens: the text in the section is floated around the "
          , HH.code_
            [ HH.text "div"]
          , HH.text " and the "
          , HH.code_
            [ HH.text "section"]
          , HH.text " surrounds the whole thing. What if we wanted the section to actually appear after the floated element?"
          ]
        , HH.span [ classList [ ClassNames.endLabel]]
          [ HH.text "</section>"]
        ]
      ]

    withClear :: H.ComponentHTML q
    withClear =
      HH.div_
      [ HH.div [ classList [ "box", ClassNames.elem]]
        [ HH.span [ classList [ ClassNames.label]]
          [ HH.text "<div class=\"box\">"]
        , HH.p_
          [ HH.text "I feel like I'm floating!"]
        , HH.span [ classList [ ClassNames.endLabel]]
          [ HH.text "</div>"]
        ]
      , HH.section [ classList [ ClassNames.elem
                               , ClassNames.elemYellow
                               , "after-box"
                               ]
                   ]
        [ HH.span [ classList [ ClassNames.label]]
          [ HH.text "<section class=\"after-box\">"]
        , HH.p_
          [ HH.text "Using "
          , HH.code_
            [ HH.text "clear"]
          , HH.text " we have now moved this section down below the floated "
          , HH.code_
            [ HH.text "div"]
          , HH.text ". You use the value "
          , HH.code_
            [ HH.text "left"]
          , HH.text " to clear elements floated to the left. You can also clear "
          , HH.code_
            [ HH.text "right"]
          , HH.text " and "
          , HH.code_
            [ HH.text "both"]
          , HH.text "."
          ]
        , HH.span [ classList [ ClassNames.endLabel]]
          [ HH.text "</section>"]
        ]
      ]

clearfix :: forall q. H.ComponentHTML q
clearfix =
  HH.div_
  [ withoutClearfix
  , withClearfix
  ]
  where
    withoutClearfix :: H.ComponentHTML q
    withoutClearfix =
      HH.div [classList [ ClassNames.elem]]
      [ HH.span [ classList [ ClassNames.label]]
        [ HH.text "<div>"]
      , HH.img [ HP.src "./images/ilta.png" ]
      , HH.p_
        [ HH.text "Uh oh... this image is taller than the element containing it, and it's floated, so it's overflowing outside of its container!"]
      ]

    withClearfix :: H.ComponentHTML q
    withClearfix =
      HH.div [classList [ ClassNames.elem, "clearfix"]]
      [ HH.span [ classList [ ClassNames.label]]
        [ HH.text "<div class=\"clearfix\">"]
      , HH.img [ HP.src "./images/ilta.png" ]
      , HH.p_
        [ HH.text "Much better!"]
      , HH.span [ classList [ ClassNames.endLabel]]
        [ HH.text "</div>"]
      ]

floatLayoutExample :: forall q. H.ComponentHTML q
floatLayoutExample =
  HH.div [ classList
           [ ClassNames.elem
           , "container"
           ]
         ]
  [ HH.span [ classList [ ClassNames.label ] ]
    [ HH.text "<div class=\"container\">"]
  , floatLayoutExampleNav
  , floatLayoutExampleSection1
  , floatLayoutExampleSection2
  ]
  where
    floatLayoutExampleNav :: H.ComponentHTML q
    floatLayoutExampleNav =
      HH.nav [ classList
               [ ClassNames.elem
               , ClassNames.elemRed
               , "nav"
               ]
             ]
      [ HH.span [ classList [ ClassNames.label ] ]
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
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</nav>"]
      ]

    floatLayoutExampleSection1 :: H.ComponentHTML q
    floatLayoutExampleSection1 =
      HH.section [ classList
                   [ ClassNames.elem
                   , ClassNames.elemYellow
                   , ClassNames.section
                   ]
                 ]
      [ HH.span [ classList [ ClassNames.label ] ]
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
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</section>"]
      ]

    floatLayoutExampleSection2 :: H.ComponentHTML q
    floatLayoutExampleSection2 =
      HH.section [ classList
                   [ ClassNames.elem
                   , ClassNames.elemYellow
                   , ClassNames.section
                   , "ipsum"
                   ]
                 ]
      [ HH.span [ classList [ ClassNames.label ] ]
        [ HH.text "<section>"]
      , HH.p_
        [ HH.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Fusce luctus vestibulum augue ut aliquet. Mauris ante ligula, facilisis sed ornare eu, lobortis in odio. Praesent convallis urna a lacus interdum ut hendrerit risus congue. Nunc sagittis dictum nisi, sed ullamcorper ipsum dignissim ac. In at libero sed nunc venenatis imperdiet sed ornare turpis. Donec vitae dui eget tellus gravida venenatis. Integer fringilla congue eros non fermentum. Sed dapibus pulvinar nibh tempor porta. Cras ac leo purus. Mauris quis diam velit."
        ]
      , HH.span [ HP.class_ $ H.ClassName ClassNames.endLabel]
        [ HH.text "</section>"]
      ]

percentWidth :: forall q. H.ComponentHTML q
percentWidth =
  HH.article [ classList
               [ ClassNames.elem
               , ClassNames.elemYellow
               , "clearfix"]
             ]
  [ HH.span [ classList [ ClassNames.label]]
    [ HH.text "<article class=\"clearfix\">"]
  , HH.img [ HP.src "./images/ilta.png" ]
  , HH.p_
    [ HH.text "You could even use "
    , HH.code_
      [ HH.text "min-width"]
    , HH.text " and "
    , HH.code_
      [ HH.text "max-width"]
    , HH.text " to limit how big or small the image can get!"
    ]
  , HH.span [ classList [ ClassNames.endLabel]]
    [ HH.text "</article>"]
  ]

-- | new spec, not popular enough
column :: forall q. H.ComponentHTML q
column =
  HH.div [ classList [ ClassNames.elem, "three-column" ]]
  [ HH.span [ classList [ ClassNames.label]]
    [ HH.text "<div class=\"three-column\">"]
  , HH.p_
    [ HH.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus imperdiet, nulla et dictum interdum, nisi lorem egestas odio, vitae scelerisque enim ligula venenatis dolor. Maecenas nisl est, ultrices nec congue eget, auctor vitae massa. Fusce luctus vestibulum augue ut aliquet. Mauris ante ligula, facilisis sed ornare eu, lobortis in odio. Praesent convallis urna a lacus interdum ut hendrerit risus congue. Nunc sagittis dictum nisi, sed ullamcorper ipsum dignissim ac. In at libero sed nunc venenatis imperdiet sed ornare turpis. Donec vitae dui eget tellus gravida venenatis. Integer fringilla congue eros non fermentum. Sed dapibus pulvinar nibh tempor porta. Cras ac leo purus. Mauris quis diam velit."]
  , HH.span [ classList [ ClassNames.endLabel]]
    [ HH.text "</div>"]
  ]

-- | Component
render :: State -> H.ComponentHTML Query
render _ =
  HH.div_
  [ HC.stylesheet CSSModule.root
  , marginAuto
  , maxWidth
  , theBoxModel
  , boxSizing
  , position
  , positionExample
  , float_
  , clear_
  , clearfix
  , floatLayoutExample
  , percentWidth
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
