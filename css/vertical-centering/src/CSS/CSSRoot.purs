module CSSRoot where

import Prelude

import CSS (CSS)
import CSS as CSS
import CSS.Common (auto, center) as CSS
import CSS.TextAlign (textAlign, center) as CSSText
import CSS.VerticalAlign (verticalAlign, VerticalAlign(Middle)) as CSS
import CSSUtils ((?), (++), (|>))
import CSSUtils as CSS
import Colors as Colors
import Selectors as S

root :: CSS
root = do
  CSS.body ? do
    CSS.fontSize (CSS.rem 2.0)
    CSS.backgroundColor Colors.dark
    CSS.color Colors.light
    CSS.letterSpacing (CSS.px 2.0)
    CSSText.textAlign CSSText.center

  CSS.p ? do
    CSS.margin1 CSS.nil

  S.content ? do
    CSS.display CSS.grid
    -- CSS.gridTemplateColumns (CSS.gridRepeat 3 (CSS.fr 1.0))
    CSS.pair "grid-template-columns" "1fr minmax(250px, 500px) 1fr"
    CSS.pair "grid-auto-rows" "auto"

    CSS.div |> CSS.div ? do
      CSS.height (CSS.vh 80.0)
      CSS.margin2 (CSS.vh 10.0) CSS.nil
      CSS.border CSS.solid (CSS.px 5.0) Colors.accent


  S.content |> CSS.star ? do
    CSS.pair "grid-column" "2"

  S.section ? do
    CSS.display CSS.grid
    CSS.pair "grid-template-columns" "1fr minmax(250px, 500px)"
    CSS.pair "grid-auto-rows" "auto"

    CSS.div ? do
      CSS.pair "grid-column" "2"

  S.title ? do
    CSS.pair "grid-column" "1"
    CSS.pair "writing-mode" "vertical-lr"
    CSS.margin CSS.nil (CSS.em 0.5) CSS.nil CSS.auto
    CSS.paddingLeft (CSS.em 1.0)
    CSS.color Colors.accent
    CSS.pair "opacity" "0.35"

  S.table ? do
    CSS.display CSS.table

    CSS.p ? do
      CSS.display CSS.tableCell
      CSS.verticalAlign CSS.Middle

  S.absolute ? do
    CSS.position CSS.relative

    CSS.p ? do
      CSS.position CSS.absolute
      CSS.top (CSS.pct 50.0)
      CSS.width (CSS.pct 100.0)
      CSS.transform $ CSS.translate_ CSS.nil (CSS.pct (-50.0))

  S.flexbox ++ S.grid ? do
    CSS.display CSS.flex
    CSS.alignItems CSS.center
    CSS.justifyContent CSS.center

  S.margins ? do
    CSS.display CSS.flex

    CSS.p ? do
      CSS.margin1 CSS.auto

  S.alignSelf ? do
    CSS.display CSS.flex
    CSS.justifyContent CSS.center

    CSS.p ? do
      CSS.alignSelf CSS.center
