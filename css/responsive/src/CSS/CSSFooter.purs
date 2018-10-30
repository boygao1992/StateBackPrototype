module CSSFooter where

import Prelude

import CSS (CSS)
import CSS (backgroundColor, block, color, display, em, grid) as CSS
import CSSUtils ((?), (|*))
import CSSUtils (margin1, padding1, pair) as CSS
import Colors as Colors
import Selectors as S
import CSSConfig (desktop, half)

root :: CSS
root = do
  S.footer ? do
    CSS.backgroundColor Colors.mineshaft
    CSS.color Colors.white
    CSS.padding1 (CSS.em 5.0)

    S.container ? do
      CSS.display CSS.block

    S.column1 ? do
      CSS.margin1 (CSS.em 1.0)

  half do
    S.footer |* S.container ? do
      CSS.display CSS.grid
      CSS.pair "grid-template-columns" "1fr 1fr 1fr"

      S.column3 ? do
        CSS.pair "grid-column" "1 / 4"

  desktop do
    S.footer |* S.container ? do
      CSS.display CSS.grid
      CSS.pair "grid-template-columns" "3fr 1fr 1fr 1fr"
      CSS.pair "grid-column-gap" "3em"

      S.column3 ? do
        CSS.pair "grid-column" "1"
