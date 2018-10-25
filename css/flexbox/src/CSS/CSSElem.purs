module CSSElem where

import Prelude

import CSS (CSS, (?))
import CSS as CSS
import Color (Color)
import Colors as Colors
import Selectors as S

-- | Positioning
elemPosition :: CSS
elemPosition =
  CSS.position CSS.relative

-- | Functions
elemBorder :: Color -> CSS
elemBorder color =
  CSS.border CSS.solid (CSS.px 3.0) color

elem :: CSS
elem =
  S.elem ? do
    elemBorder Colors.green
    elemPosition

elemRed :: CSS
elemRed =
  S.elemRed ? do
    elemBorder Colors.red
    elemPosition

elemYellow :: CSS
elemYellow =
  S.elemYellow ? do
    elemBorder Colors.yellow
    elemPosition

root :: CSS
root = do
  elem
  elemRed
  elemYellow
