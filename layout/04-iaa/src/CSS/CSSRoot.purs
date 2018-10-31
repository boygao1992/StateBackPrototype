module CSSRoot where

import Prelude

import Animations as Animations
import CSS (CSS)
import CSS as CSS
import CSS.Common (auto, none, center) as CSS
import CSS.ListStyle.Type (listStyleType) as CSS
import CSS.Overflow (overflow, hidden) as CSS
import CSS.Text.Transform (textTransform, uppercase) as CSS
import CSS.TextAlign (center, textAlign) as CSSText
import CSSConfig (ballRadius, springWidth, springHeight)
import CSSUtils ((&), (++), (?))
import CSSUtils (borderRadius1, borderWidth, focus, margin1, margin2, padding1, padding2, pair) as CSS
import Colors as Colors
import Selectors as S
import Urls as Urls

root :: CSS
root = do
  Animations.vertical

  CSS.importUrl Urls.googleRoboto

  CSS.star ? do
    CSS.boxSizing CSS.borderBox

  CSS.body ? do
    CSS.pair "font-family" "'Roboto', 'Helvetica Neue', 'Yu Gothic', YuGothic, 'ヒラギノ角ゴ Pro', 'Hiragino Kaku Gothic Pro', 'メイリオ', 'Meiryo', sans-serif"

  S.hero ? do
    CSS.position CSS.relative
    CSS.background Colors.robinsEggBlue
    CSSText.textAlign CSSText.center
    CSS.color Colors.white
    CSS.padding2 (CSS.em 3.0) CSS.nil
    CSS.textWhitespace CSS.whitespaceNoWrap
    CSS.overflow CSS.hidden

  S.heroTitle ? do
    CSS.fontSize (CSS.vw 8.75)
    CSS.letterSpacing (CSS.em 0.15)
    CSS.span ? do
      CSS.display CSS.block
      CSS.pair "font-weight" "100"

      CSS.b ? do
        CSS.pair "font-weight" "400"

      CSS.span ? do
        CSS.display CSS.inlineBlock

  S.heroHint ? do
    CSS.pair "font-weight" "400"
    CSS.fontSize (CSS.vw 4.0)
    CSS.letterSpacing (CSS.em 0.33)

  S.heroSpringContainer ? do
    CSS.position CSS.absolute
    CSS.left (CSS.pct 50.0)
    CSS.bottom CSS.nil

  S.heroSpring ? do
    CSS.position CSS.relative
    CSS.display CSS.flex
    CSS.flexDirection CSS.column
    CSS.justifyContent CSS.center
    CSS.alignItems CSS.center
    Animations.springOscillation

  S.heroSpringTop ? do
    CSS.width (CSS.em (ballRadius * 2.0))
    CSS.height (CSS.em (ballRadius * 2.0))
    CSS.borderRadius1 (CSS.em ballRadius)
    CSS.backgroundColor Colors.white

  S.heroSpringBottom ? do
    CSS.backgroundColor Colors.white
    CSS.width (CSS.em springWidth)
    CSS.height (CSS.em springHeight)
