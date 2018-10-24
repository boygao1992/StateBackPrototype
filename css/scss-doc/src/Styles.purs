module Styles where

import Prelude

import CSS (CSS, Selector, (?))
import CSS as CSS
import CSS.Common (normal) as CSS
import CSSUtils ((++), (|*), (&))
import CSSUtils as CSS
import ClassNames as CN
import Colors as Colors
import Data.NonEmpty (singleton) as NE
import Fonts (fantasy) as CSS
import IDs as IDs
import Urls as Urls

-- | Nested Rules
nestedRules1 :: CSS
nestedRules1 =
  (CSS.id_ IDs.main |* CSS.p) ? do
    CSS.color Colors.lime
    CSS.width (CSS.pct 97.0)

    (CSS.class_ CN.redbox) ? do
      CSS.backgroundColor Colors.red
      CSS.color Colors.black

nestedRules2 :: CSS
nestedRules2 =
  (CSS.id_ IDs.main) ? do
    CSS.width (CSS.pct 97.0)

    (CSS.p ++ CSS.div) ? do
      CSS.fontSize (CSS.em 2.0)
      CSS.a ? do
        CSS.fontWeight CSS.bold

    CSS.pre ? do
      CSS.fontSize (CSS.em 3.0)

-- | Referencing Parent Selectors
linkStyle_ :: Selector -> CSS
linkStyle_ selector = do
  selector ? do
    CSS.fontWeight CSS.bold
    CSS.textDecoration CSS.noneTextDecoration

  (selector & CSS.hover) ? do
    CSS.textDecoration CSS.underline

  (CSS.body & CSS.byClass CN.firefox |* selector) ? do
    CSS.fontWeight CSS.normal

refParentSelectors1 :: CSS
refParentSelectors1 = linkStyle_ CSS.a

linkStyle__ :: Selector -> CSS
linkStyle__ selector = do
  selector ? do
    CSS.fontWeight CSS.bold

  (selector & CSS.hover) ? do
    CSS.color Colors.red

refParentSelectors2 :: CSS
refParentSelectors2 = do
  (CSS.id_ IDs.main) ? do
    CSS.color Colors.black

    linkStyle__ CSS.a

suffixStyle :: String -> CSS
suffixStyle id = do
  (CSS.id_ id) ? do
    CSS.color Colors.black

  (CSS.id_ (id <> "-sidebar")) ? do
    CSS.border CSS.solid (CSS.px 1.0) Colors.transparent

refParentSelectors3 :: CSS
refParentSelectors3 = suffixStyle IDs.main

-- | Nested Properties

nestedProperties :: CSS
nestedProperties =
  (CSS.id_ "funky") ? do
    CSS.fontFamily [] (NE.singleton CSS.fantasy)
    CSS.fontSize (CSS.em 30.0)
    CSS.fontWeight CSS.bold

-- | @extend
errorStyle :: CSS
errorStyle = do
  CSS.border CSS.solid (CSS.px 1.0) Colors.red
  CSS.backgroundColor Colors.pink

  (CSS.class_ CN.intrusion) ? do
    CSS.backgroundImage (CSS.url Urls.hacked)

error :: CSS
error =
  (CSS.class_ CN.error) ? errorStyle

seriousError :: CSS
seriousError =
  (CSS.class_ CN.seriousError) ? do
    errorStyle
    CSS.borderWidth (CSS.px 3.0)

-- | Multiple Extends
errorStyle_ :: CSS
errorStyle_ = do
  CSS.border CSS.solid (CSS.px 1.0) Colors.red
  CSS.backgroundColor Colors.pink

attentionStyle :: CSS
attentionStyle = do
  CSS.fontSize (CSS.em 3.0)
  CSS.backgroundColor Colors.red

error_ :: CSS
error_ =
  (CSS.class_ CN.error) ? errorStyle_

attention :: CSS
attention =
  (CSS.class_ CN.attention) ? attentionStyle

seriousError_ :: CSS
seriousError_ =
  (CSS.class_ CN.seriousError) ? do
    errorStyle_
    attentionStyle
    CSS.borderWidth (CSS.px 3.0)

-- | Chaining Extends
seriousErrorStyle :: CSS
seriousErrorStyle = do
  errorStyle_
  CSS.borderWidth (CSS.px 3.0)

seriousError__ :: CSS
seriousError__ =
  (CSS.class_ CN.seriousError) ? seriousErrorStyle

criticalError :: CSS
criticalError =
  (CSS.class_ CN.criticalError) ? do
    seriousErrorStyle
    CSS.position CSS.fixed
    CSS.top (CSS.pct 10.0)
    CSS.bottom (CSS.pct 10.0)
    CSS.left (CSS.pct 10.0)
    CSS.right (CSS.pct 10.0)

-- | Selector Sequences
linkStyle :: Selector -> CSS
linkStyle selector = do
  selector ? do
    CSS.color Colors.blue
  (selector & CSS.hover) ? do
    CSS.textDecoration CSS.underline

hyperLink :: CSS
hyperLink = linkStyle CSS.a

fakeLinks :: CSS
fakeLinks = linkStyle (CSS.id_ IDs.fakeLinks |* CSS.class_ CN.link)
