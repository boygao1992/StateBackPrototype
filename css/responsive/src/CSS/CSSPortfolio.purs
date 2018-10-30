module CSSPortfolio where


import Prelude

import CSS (CSS)
import CSS (absolute, backgroundColor, block, bottom, color, display, em, flex, grid, hover, img, justifyContent, left, nil, padding, pct, position, relative, right, transform, width, zIndex) as CSS
import CSS.Overflow (overflow, hidden) as CSS
import CSS.Common (center) as CSS
import CSSUtils ((&), (?), (|*))
import CSSUtils (margin1, margin2, pair, translate_) as CSS
import Colors as Colors
import Selectors as S
import CSSConfig (desktop, half)
import Color (rgba) as Color

root :: CSS
root = do
  S.portfolio ? do
    CSS.margin2 (CSS.em 3.0) CSS.nil

  S.portfolioItem ? do
    CSS.position CSS.relative
    CSS.margin1 CSS.nil
    CSS.overflow CSS.hidden

    CSS.img ? do
      CSS.display CSS.block
      CSS.width (CSS.pct 100.0)

  S.portfolioDescriptionBox ? do
    CSS.position CSS.absolute
    CSS.left CSS.nil
    CSS.right CSS.nil
    CSS.bottom $ CSS.em 2.0
    CSS.zIndex 1
    CSS.display CSS.flex
    CSS.justifyContent CSS.center

  S.portfolioDescription ? do
    CSS.width (CSS.pct 75.0)
    CSS.padding (CSS.em 0.5) CSS.nil (CSS.em 1.0) CSS.nil
    CSS.backgroundColor $ Color.rgba 0 0 0 0.60
    CSS.color Colors.white

  half do
    S.portfolioList ? do
      CSS.display CSS.grid
      CSS.pair "grid-template-columns" "1fr 1fr"

    S.portfolioDescriptionBox ? do
      CSS.bottom CSS.nil
      CSS.transform $ CSS.translate_ CSS.nil (CSS.pct 150.0)

    S.portfolioItem & CSS.hover |* S.portfolioDescriptionBox ? do
      CSS.transform $ CSS.translate_ CSS.nil CSS.nil

    S.portfolioDescription ? do
      CSS.width (CSS.pct 100.0)

  desktop do
    S.portfolioList ? do
      CSS.display CSS.grid
      CSS.pair "grid-template-columns" "1fr 1fr 1fr"

    S.portfolioDescriptionBox ? do
      CSS.bottom CSS.nil
      CSS.transform $ CSS.translate_ CSS.nil (CSS.pct 150.0)

    S.portfolioItem & CSS.hover |* S.portfolioDescriptionBox ? do
      CSS.transform $ CSS.translate_ CSS.nil CSS.nil

    S.portfolioDescription ? do
      CSS.width (CSS.pct 100.0)
