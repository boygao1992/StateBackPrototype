module CSSRoot where

import Prelude

import CSS (CSS)
import CSS as CSS
import CSS.Common (auto) as CSS
import CSS.Text.Transform (textTransform, uppercase) as CSS
import CSS.TextAlign (textAlign, center, startTextAlign) as CSSText
import CSSHeader (root) as CSSHeader
import CSSUtils ((?), (++), (&), (|*))
import CSSUtils (borderWidth, margin1, margin2, padding1, padding2, pair, focus) as CSS
import Colors as Colors
import Color (rgba) as Color
import Selectors as S
import Urls (googleRaleway, heroBackground, aboutBackground) as Urls
import CSSConfig (desktop)


root :: CSS
root = do
  CSS.importUrl Urls.googleRaleway

  CSS.star ? do
    CSS.boxSizing CSS.borderBox

  CSS.body ? do
    CSS.margin1 CSS.nil
    CSS.pair "font-family" "'Raleway', sans-serif"
    CSSText.textAlign CSSText.center

  CSS.p ? do
    CSS.marginTop CSS.nil
    CSS.lineHeight (CSS.em 1.5)

  CSS.img ? do
    CSS.maxWidth (CSS.pct 100.0)
    CSS.height CSS.auto

  S.container ? do -- | for mobile
    CSS.width (CSS.pct 95.0)
    CSS.margin2 CSS.nil CSS.auto

  S.title ? do
    CSS.fontSize (CSS.rem 2.5)
    CSS.marginBottom (CSS.em 1.5)

    CSS.span ? do
      -- CSS.fontWeight (CSS.weight 300.0)
      CSS.pair "font-weight" "300"
      CSS.display CSS.block
      CSS.fontSize (CSS.em 0.9)

  desktop do
    S.title ? do
      CSS.fontSize (CSS.rem 3.7)

  S.button ? do
    CSS.display CSS.inlineBlock
    CSS.fontSize (CSS.rem 1.2)
    CSS.textDecoration CSS.noneTextDecoration
    CSS.textTransform CSS.uppercase
    CSS.pair "border-style" "solid"
    CSS.borderWidth (CSS.px 2.0)
    CSS.padding2 (CSS.em 0.5) (CSS.em 1.75)

  desktop do
    S.button ? do
      CSS.fontSize (CSS.rem 1.5)

  S.buttonAccent ? do
    CSS.color Colors.springgreen
    CSS.borderColor Colors.springgreen

  (S.buttonAccent & CSS.hover) ++ (S.buttonAccent & CSS.focus) ? do
    CSS.backgroundColor Colors.springgreen
    CSS.color Colors.mineshaft

  CSSHeader.root

  S.homeHero ? do
    CSS.backgroundImage (CSS.url Urls.heroBackground)
    CSS.backgroundSize CSS.cover
    CSS.backgroundPosition $ CSS.placed CSS.sideCenter CSS.sideCenter
    CSS.padding2 (CSS.em 10.0) CSS.nil
    CSS.color Colors.white

  desktop do
    S.homeHero ? do
      CSS.height (CSS.vh 100.0)
      CSS.paddingTop (CSS.vh 35.0)

  S.homeAboutText ? do
    CSS.backgroundColor Colors.mineshaft
    CSS.padding1 (CSS.em 3.0)

  S.homeAboutTextBox ? do
    CSS.position CSS.relative
    CSS.border CSS.solid (CSS.px 2.0) Colors.springgreen
    CSS.padding (CSS.em 2.0) (CSS.em 2.0) CSS.nil (CSS.em 2.0)

    S.boxTitle ? do
      CSS.position CSS.absolute
      CSS.left CSS.nil
      CSS.right CSS.nil
      CSS.top (CSS.em (-1.0))

      CSS.h1 ? do
        CSS.marginTop CSS.nil
        CSS.display CSS.inlineBlock
        CSS.padding2 CSS.nil (CSS.em 0.3)
        CSS.backgroundColor Colors.mineshaft
        CSS.color Colors.springgreen
        CSS.pair "font-weight" "300"
        CSS.fontSize (CSS.rem 1.7)

    CSS.p ? do
      CSS.color Colors.white

  desktop do
    S.homeAbout ? do
      CSS.backgroundImage $ CSS.url Urls.aboutBackground
      CSS.backgroundPosition $ CSS.placed CSS.sideCenter CSS.sideCenter
      CSS.backgroundRepeat CSS.noRepeat
      CSS.paddingBottom (CSS.em 10.0)
      CSS.position CSS.relative
      CSS.padding1 (CSS.em 20.0)

    S.homeAboutText ? do
      CSS.position CSS.absolute
      CSS.top (CSS.em (-10.0))
      CSS.left (CSS.em 3.0)
      CSS.width (CSS.pct 50.0)
      CSS.minWidth (CSS.rem 35.0)
      CSSText.textAlign CSSText.startTextAlign
      CSS.boxShadow CSS.nil CSS.nil (CSS.em 4.0) (Color.rgba 0 0 0 0.5)

    S.homeAboutTextBox ? do
      CSS.padding (CSS.em 5.0) (CSS.em 3.0) (CSS.em 2.0) (CSS.em 5.0)

      S.boxTitle ? do
        CSS.paddingLeft (CSS.em 5.0)
        CSS.top (CSS.em (-1.5))

        CSS.h1 ? do
          CSS.fontSize (CSS.rem 3.0)
          CSS.padding2 CSS.nil (CSS.em 0.6)

      CSS.p ? do
        CSS.fontSize (CSS.rem 1.5)
