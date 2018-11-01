module CSSRoot where

import Prelude

import Animations as Animations
import CSS (CSS)
import CSS (absolute, alignItems, b, background, backgroundColor, block, body, borderBox, bottom, boxSizing, color, column, deg, display, displayNone, em, figure, fixed, flex, flexDirection, flexWrap, fontSize, grid, height, hover, img, importUrl, inlineBlock, justifyContent, left, letterSpacing, li, marginTop, nil, nowrap, pct, position, relative, rem, rotate, row, spaceBetween, span, star, textWhitespace, transform, ul, vh, vw, whitespaceNoWrap, width, zIndex) as CSS
import CSS.Common (center) as CSS
import CSS.Overflow (hidden, overflow) as CSS
import CSS.TextAlign (center, textAlign) as CSSText
import CSSConfig (ballRadius, springWidth, springHeight, desktop, half)
import CSSUtils ((&), (?))
import CSSUtils (borderRadius1, margin1, padding1, padding2, pair, byClass) as CSS
import Colors as Colors
import Selectors as S
import Urls as Urls
import ClassNames as CN

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
    CSS.zIndex 3

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

  S.headerButton & (CSS.byClass CN.headerButtonOpen) ? do
    S.headerButtonPart1 ? do
      CSS.width (CSS.pct 100.0)
      CSS.transform $ CSS.rotate $ CSS.deg 45.0
    S.headerButtonPart2 ? do
      CSS.marginTop (CSS.rem (-0.10))
      CSS.width (CSS.pct 100.0)
      CSS.transform $ CSS.rotate $ CSS.deg (-45.0)

  S.headerNavigationMobile ? do
    CSS.display CSS.displayNone
    CSS.width (CSS.vw 100.0)
    CSS.height (CSS.vh 100.0)
    CSS.color Colors.white
    CSS.backgroundColor Colors.robinsEggBlue
    CSS.fontSize (CSS.rem 2.0)
    CSS.pair "font-weight" "100"

    CSS.ul ? do
      CSS.padding1 CSS.nil
      CSS.pair "list-style" "none"
      CSS.display CSS.flex
      CSS.flexDirection CSS.column
      CSS.alignItems CSS.center
    CSS.li ? do
      CSS.margin1 (CSS.em 0.5)

  S.headerNavigationMobile & (CSS.byClass CN.headerButtonOpen)? do
    CSS.display CSS.flex
    CSS.alignItems CSS.center
    CSS.justifyContent CSS.center
    CSS.position CSS.fixed
    CSS.zIndex 2

  -- half do
  --   S.headerNavigationMobile & (CSS.byClass CN.headerButtonOpen)? do
  --     CSS.display CSS.displayNone
  --   S.headerButton ? do
  --     CSS.display CSS.displayNone

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
    CSS.alignItems CSS.center
    CSS.figure ? do
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
