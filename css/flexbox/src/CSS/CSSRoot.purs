module CSSRoot where

import Prelude

import CSS (CSS, Selector, (?), (|>))
import CSS as CSS
import CSS.Common (auto) as CSS
import CSSUtils ((++))
import CSSUtils as CSS
import Colors as Colors
import Selectors as S
import CSSElem as CSSElem
import CSSLabel as CSSLabel

container :: CSS
container =
  S.container ? do
    CSS.display CSS.flex

nav :: CSS
nav =
  CSS.nav ? do
    CSS.width (CSS.px 200.0)

flexColumn :: CSS
flexColumn =
  S.flexColumn ? do
    CSS.flexBasis CSS.auto
    CSS.flexDirection CSS.row
    CSS.flexGrow 1
    CSS.flexShrink 1

root :: CSS
root = do
  container
  nav
  flexColumn

  CSSElem.root
  CSSLabel.root
