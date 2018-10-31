module CSSRoot where

import Prelude

import Animations as Animations
import CSS (CSS)
import CSS (absolute, alignItems, b, background, backgroundColor, block, body, borderBox, bottom, boxSizing, color, column, display, em, figure, flex, flexDirection, flexWrap, fontSize, grid, height, hover, img, importUrl, inlineBlock, justifyContent, left, letterSpacing, marginTop, nil, nowrap, pct, position, relative, rem, row, spaceBetween, span, star, textWhitespace, vw, whitespaceNoWrap, width) as CSS
import CSS.Common (center) as CSS
import CSS.Overflow (hidden, overflow) as CSS
import CSS.TextAlign (center, textAlign) as CSSText
import CSSConfig (ballRadius, springWidth, springHeight, desktop, half)
import CSSUtils ((?), (&))
import CSSUtils (borderRadius1, margin1, padding1, padding2, pair) as CSS
import Colors as Colors
import Selectors as S
import Urls as Urls

buttonPart :: CSS
buttonPart = do
  CSS.position CSS.relative
  CSS.display CSS.block
  CSS.height (CSS.rem 0.1)
  CSS.backgroundColor Colors.black

root :: CSS
root = do
  Animations.root

  CSS.importUrl Urls.googleRoboto

  CSS.star ? do
    CSS.boxSizing CSS.borderBox

  CSS.body ? do
    CSS.pair "font-family" "'Roboto', 'Helvetica Neue', 'Yu Gothic', YuGothic, 'ヒラギノ角ゴ Pro', 'Hiragino Kaku Gothic Pro', 'メイリオ', 'Meiryo', sans-serif"
    CSS.margin1 CSS.nil


  S.header ? do
    CSS.display CSS.flex
    CSS.padding2 CSS.nil (CSS.rem 0.4)
    CSS.flexDirection CSS.row
    CSS.flexWrap CSS.nowrap
    CSS.justifyContent CSS.spaceBetween

  S.headerLogo ? do
    CSS.margin1 CSS.nil
    CSS.height (CSS.pct 100.0)

  S.logo ? do
    CSS.height (CSS.pct 100.0)

  S.headerButtonContainer ? do
    CSS.width (CSS.rem 1.5)
    CSS.display CSS.flex
    CSS.alignItems CSS.center
    CSS.justifyContent CSS.center

  S.headerButton ? do
    CSS.pair "border" "none"
    CSS.pair "background" "none"
    CSS.width (CSS.pct 100.0)
    CSS.height (CSS.rem 2.0)
    CSS.padding1 CSS.nil

  S.headerButtonPart1 ? do
    CSS.width (CSS.pct 100.0)
    buttonPart

  S.headerButtonPart2 ? do
    CSS.width (CSS.pct 75.0)
    CSS.marginTop (CSS.rem 0.5)
    buttonPart

  S.headerButton & CSS.hover ? do
    S.headerButtonPart1 ? do
      CSS.width (CSS.pct 75.0)
    S.headerButtonPart2 ? do
      CSS.width (CSS.pct 100.0)


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
    Animations.hintTwinkle

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

  S.gallery ? do
    CSS.display CSS.grid
    CSS.pair "grid-template-columns" "1fr"
    CSS.figure ? do
      CSS.margin1 CSS.nil
      CSS.padding1 CSS.nil

  half do
    S.gallery ? do
      CSS.pair "grid-template-columns" "1fr 1fr"

  desktop do
    S.gallery ? do
      CSS.pair "grid-template-columns" "1fr 1fr 1fr"

  S.galleryItem ? do
    CSS.img ? do
      CSS.display CSS.block
      CSS.width (CSS.pct 100.0)
