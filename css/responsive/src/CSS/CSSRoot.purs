module CSSRoot where

import Prelude

import CSS (CSS)
import CSS as CSS
import CSS.Common (auto) as CSS
import CSS.Text.Transform (textTransform, uppercase) as CSS
import CSS.TextAlign (center, textAlign) as CSSText
import CSSUtils ((&), (++), (?))
import CSSUtils (borderWidth, focus, margin1, margin2, padding2, pair) as CSS
import Colors as Colors
import Selectors as S
import Urls (googleRaleway) as Urls
import CSSConfig (desktop)
import CSSHeader (root) as CSSHeader
import CSSHero (root) as CSSHero
import CSSAbout (root) as CSSAbout
import CSSPortfolio (root) as CSSPortfolio



root :: CSS
root = do
  CSS.importUrl Urls.googleRaleway

  CSS.star ? do
    CSS.boxSizing CSS.borderBox
    CSS.pair "transition" "all ease-in-out 250ms"

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

  S.buttonSmall ? do
    CSS.fontSize (CSS.rem 0.7)
    CSS.pair "font-weight" "700"

  desktop do
    S.buttonSmall ? do
      CSS.fontSize (CSS.rem 0.8)

  CSSHeader.root

  CSSHero.root

  CSSAbout.root

  CSSPortfolio.root

