module CSSRoot where

import Prelude

import Animations as Animations
import CSS (CSS)
import CSS as CSS
import CSS.Common (center) as CSS
import CSS.Overflow (hidden, overflow) as CSS
import CSS.TextAlign (center, textAlign, leftTextAlign, rightTextAlign) as CSSText
import CSSAnimation (easeInOut)
import CSSConfig (ballRadius, springWidth, springHeight, desktop, half)
import CSSUtils ((&), (?), (++))
import CSSUtils (borderRadius1, byClass, margin1, margin2, padding1, padding2, pair, transition, after) as CSS
import ClassNames as CN
import Color (rgba) as Color
import Colors as Colors
import Selectors as S
import Urls as Urls

buttonPart :: CSS
buttonPart = do
  CSS.position CSS.relative
  CSS.display CSS.block
  CSS.height (CSS.rem 0.07)
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
    CSS.height (CSS.rem 4.0)
    CSS.margin CSS.nil CSS.nil (CSS.rem 0.1) CSS.nil

    CSS.a ? do
      CSS.textDecoration CSS.noneTextDecoration
      CSS.letterSpacing (CSS.em 0.06)
      CSS.color Colors.black

    CSS.a & CSS.after ? do
      CSS.position CSS.absolute
      CSS.left CSS.nil
      CSS.bottom (CSS.em (-0.5))
      CSS.pair "content" "''"
      CSS.height (CSS.em 0.12)
      CSS.width CSS.nil
      CSS.backgroundColor Colors.robinsEggBlue
      CSS.transition "all" (CSS.ms 250.0) easeInOut (CSS.ms 0.0)

    CSS.a & (CSS.fromString ":hover::after") ? do
      CSS.width (CSS.pct 100.0)

  S.headerBar ? do
    CSS.position CSS.fixed
    CSS.width (CSS.pct 100.0)
    CSS.height (CSS.rem 4.0)
    CSS.display CSS.flex
    CSS.padding2 (CSS.rem 0.2) (CSS.rem 0.4)
    CSS.flexDirection CSS.row
    CSS.flexWrap CSS.nowrap
    CSS.alignItems CSS.center
    CSS.justifyContent CSS.spaceBetween
    CSS.backgroundColor (Color.rgba 255 255 255 0.4)
    CSS.zIndex 1

  S.headerLogo ? do
    CSS.display CSS.flex
    CSS.justifyContent CSS.center
    CSS.margin1 CSS.nil

  S.logo ? do
    CSS.height (CSS.rem 1.6)

  S.headerButtonContainer ? do
    CSS.display CSS.flex
    CSS.alignItems CSS.center
    CSS.justifyContent CSS.center

  S.headerButton ? do
    CSS.pair "border" "none"
    CSS.pair "background" "none"
    CSS.width (CSS.rem 2.0)
    CSS.height (CSS.rem 1.5)
    CSS.padding1 CSS.nil
    CSS.zIndex 3

  S.headerButtonPart1 ? do
    CSS.width (CSS.pct 100.0)
    buttonPart
    CSS.transition "all" (CSS.ms 250.0) easeInOut (CSS.ms 0.0)

  S.headerButtonPart2 ? do
    CSS.width (CSS.pct 75.0)
    CSS.marginTop (CSS.rem 0.5)
    buttonPart
    CSS.transition "all" (CSS.ms 250.0) easeInOut (CSS.ms 0.0)

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

  S.headerNavigationDesktop ? do
    CSS.display CSS.displayNone
    CSS.ul ? do
      CSS.margin1 CSS.nil
      CSS.padding1 CSS.nil
      CSS.pair "list-style" "none"
      CSS.display CSS.flex
      CSS.flexDirection CSS.row
      CSS.alignItems CSS.center
      CSS.justifyContent CSS.spaceBetween
    CSS.li ? do
      CSS.margin2 CSS.nil (CSS.em 1.0)
      CSS.position CSS.relative

  S.headerNavigationDesktopContact ? do
    CSS.display CSS.displayNone
    CSS.position CSS.relative

  half do
    S.headerNavigationDesktop ? do
      CSS.display CSS.block
    S.headerNavigationDesktopContact ? do
      CSS.display CSS.block

  S.headerNavigationMobile ? do
    CSS.position CSS.fixed
    CSS.display CSS.flex
    CSS.top CSS.nil
    CSS.left CSS.nil
    CSS.width (CSS.vw 100.0)
    CSS.height CSS.nil
    CSS.pair "opacity" "0.0"
    -- CSS.height (CSS.vh 100.0)
    CSS.color Colors.white
    CSS.backgroundColor Colors.robinsEggBlue
    CSS.fontSize (CSS.rem 2.0)
    CSS.pair "font-weight" "100"
    CSS.transition "all" (CSS.ms 250.0) easeInOut (CSS.ms 0.0)

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
    CSS.height (CSS.vh 100.0)
    CSS.pair "opacity" "1.0"

  half do
    S.headerNavigationMobile & (CSS.byClass CN.headerButtonOpen)? do
      CSS.display CSS.displayNone
    S.headerButtonContainer ? do
      CSS.display CSS.displayNone

  S.hero ? do
    CSS.display CSS.block
    CSS.position CSS.relative
    CSS.background Colors.robinsEggBlue
    CSSText.textAlign CSSText.center
    CSS.color Colors.white
    CSS.padding2 (CSS.em 3.0) CSS.nil
    CSS.textWhitespace CSS.whitespaceNoWrap
    CSS.overflow CSS.hidden

  S.heroTitle ? do
    CSS.fontSize (CSS.vmin 8.75)
    CSS.letterSpacing (CSS.em 0.15)
    CSS.span ? do
      CSS.display CSS.block
      CSS.pair "font-weight" "100"

      CSS.b ? do
        CSS.pair "font-weight" "400"

      CSS.span ? do
        CSS.display CSS.inlineBlock

    desktop do
      CSS.display CSS.flex
      CSS.flexDirection CSS.row
      CSS.flexGrow 1
      CSS.flexShrink 1
      CSS.flexWrap CSS.wrap
      CSS.justifyContent CSS.center

      CSS.span ? do
        CSS.flexBasis $ CSS.pct 30.0

      S.heroInstitute ? do
        CSS.flexBasis $ CSS.pct 50.0

      S.heroInstitute ++ S.heroArchitectural ? do
        CSSText.textAlign CSSText.rightTextAlign
        CSS.padding CSS.nil (CSS.em 0.5) CSS.nil CSS.nil

      S.heroFor ++ S.heroAnthropology ? do
        CSSText.textAlign CSSText.leftTextAlign

  S.heroHint ? do
    CSS.pair "font-weight" "400"
    CSS.fontSize (CSS.vw 4.0)
    CSS.letterSpacing (CSS.em 0.33)
    Animations.hintTwinkle

    desktop do
      CSS.fontSize $ CSS.rem 1.0

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
    springWidth
    springHeight

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
