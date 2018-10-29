module CSSHeader where

import Prelude

import CSS (CSS)
import CSS as CSS
import CSS.Common (none) as CSS
import CSSUtils ((?), (&), (++))
import CSSUtils (margin1, padding1, focus, pair) as CSS
import CSS.ListStyle.Type (listStyleType) as CSS
import CSS.Text.Transform (textTransform, uppercase) as CSS
import Colors (white, lightgray) as Colors
import CSSConfig (desktop)
import Selectors as S

root :: CSS
root = do
  CSS.header ? do
    -- CSS.marginTop (CSS.em 1.0)
    CSS.position CSS.absolute
    CSS.left CSS.nil
    CSS.right CSS.nil
    CSS.margin1 (CSS.em 1.0)

  CSS.nav ? do
    CSS.ul ? do
      CSS.margin1 CSS.nil
      CSS.padding1 CSS.nil
      CSS.listStyleType CSS.none

      CSS.li ? do
        CSS.display CSS.inlineBlock
        CSS.margin1 (CSS.em 1.0)

    CSS.a ? do
      -- CSS.fontWeight (CSS.weight 900.0)
      CSS.pair "font-weight" "900"
      CSS.textDecoration CSS.noneTextDecoration
      CSS.textTransform CSS.uppercase
      CSS.fontSize (CSS.em 0.8)
      CSS.padding1 (CSS.em 0.5)
      CSS.color Colors.white

    (CSS.a & CSS.hover) ++ (CSS.a & CSS.focus) ? do
      CSS.color Colors.lightgray


  desktop do
    S.logo ? do
      CSS.float CSS.floatLeft

    CSS.nav ? do
      CSS.float CSS.floatRight
