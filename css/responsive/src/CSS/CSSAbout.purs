module CSSAbout where

import Prelude

import CSS (CSS)
import CSS (absolute, backgroundColor, backgroundImage, backgroundPosition, backgroundRepeat, border, boxShadow, color, display, em, fontSize, h1, inlineBlock, left, marginTop, minWidth, nil, noRepeat, p, padding, paddingBottom, paddingLeft, pct, placed, position, px, relative, rem, right, sideCenter, solid, top, url, width) as CSS
import CSS.TextAlign (startTextAlign, textAlign) as CSSText
import CSSUtils ((?))
import CSSUtils (padding1, padding2, pair) as CSS
import Colors as Colors
import Color (rgba) as Color
import Selectors as S
import Urls (aboutBackground) as Urls
import CSSConfig (desktop)


root :: CSS
root = do
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
