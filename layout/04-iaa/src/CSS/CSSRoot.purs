module CSSRoot where

import Prelude

import CSS (CSS)
import CSS as CSS
import CSS.Common (auto, none) as CSS
import CSS.Text.Transform (textTransform, uppercase) as CSS
import CSS.TextAlign (center, textAlign) as CSSText
import CSS.ListStyle.Type (listStyleType) as CSS
import CSSUtils ((&), (++), (?))
import CSSUtils (borderWidth, focus, margin1, margin2, padding1, padding2, pair) as CSS
import Colors as Colors
import Selectors as S
import Urls as Urls

root :: CSS
root = do

  CSS.importUrl Urls.googleRoboto

  CSS.star ? do
    CSS.boxSizing CSS.borderBox

  CSS.body ? do
    CSS.pair "font-family" "'Roboto', sans-serif"

  S.hero ? do
    CSS.background Colors.robinsEggBlue

  S.heroTitle ? do
    CSSText.textAlign CSSText.center
    CSS.fontSize (CSS.vw 8.75)
    CSS.color Colors.white
    CSS.span ? do
      CSS.display CSS.block
      CSS.pair "font-weight" "100"

      CSS.b ? do
        CSS.pair "font-weight" "400"

      CSS.span ? do
        CSS.display CSS.inlineBlock
