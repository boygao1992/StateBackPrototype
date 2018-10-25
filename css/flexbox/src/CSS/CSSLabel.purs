module CSSLabel where

import Prelude

import CSS (CSS, Selector, (?), (|>))
import CSS as CSS
import CSSUtils ((++))
import Colors as Colors
import Selectors as S

-- | Styles

labelStyle :: CSS
labelStyle = do
  CSS.position CSS.absolute
  CSS.backgroundColor Colors.green
  CSS.color CSS.gray
  CSS.lineHeight (CSS.em 1.0)

-- | Positioning

labelPosition :: CSS
labelPosition = do
  CSS.top CSS.nil
  CSS.left CSS.nil
  CSS.padding CSS.nil (CSS.px 3.0) (CSS.px 3.0) CSS.nil

endLabelPosition :: CSS
endLabelPosition = do
  CSS.right CSS.nil
  CSS.bottom CSS.nil
  CSS.padding (CSS.px 3.0) CSS.nil CSS.nil (CSS.px 3.0)

-- | Functions

redLabelStyle :: Selector -> CSS
redLabelStyle selector = do
  (selector |> S.label) ++ (selector |> S.endLabel) ? do
    CSS.color Colors.white
    CSS.backgroundColor Colors.red

yellowLabelStyle :: Selector -> CSS
yellowLabelStyle selector = do
  (selector |> S.label) ++ (selector |> S.endLabel) ? do
    CSS.color Colors.gray
    CSS.backgroundColor Colors.yellow

-- | CSS

label :: CSS
label =
  S.label ? do
    labelStyle
    labelPosition

endLabel :: CSS
endLabel =
  S.endLabel ? do
    labelStyle
    endLabelPosition

root :: CSS
root = do
  label
  endLabel
  redLabelStyle S.elemRed
  yellowLabelStyle S.elemYellow
