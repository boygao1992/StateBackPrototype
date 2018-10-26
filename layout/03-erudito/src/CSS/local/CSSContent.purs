module CSSContent where

import Prelude

import CSS (CSS)
import CSS as CSS
import CSS.Common (center, auto) as CSS
import CSS.Media (screen, maxWidth) as CSSMedia
import CSS.Stylesheet (query) as CSS
import CSSConfig (screenSizeMobile)
import CSSUtils ((?), (&), (|>))
import CSSUtils as CSS
import Colors as Colors
import Data.NonEmpty (singleton) as NE
import Selectors as S

-- | Layout
contentLayout :: CSS
contentLayout = do
  S.content ? do
    CSS.display CSS.flex
    CSS.flexDirection CSS.row
    CSS.alignItems CSS.flexStart
    CSS.justifyContent CSS.center
    CSS.flexWrap CSS.nowrap

  S.content |> CSS.div ? do
    CSS.display CSS.flex
    CSS.flexDirection CSS.row
    CSS.alignItems CSS.center
    CSS.justifyContent CSS.spaceBetween
    CSS.flexWrap CSS.nowrap
    CSS.width (CSS.pct 75.0)
    CSS.height (CSS.rem 50.0)

    CSS.query CSSMedia.screen (NE.singleton (CSSMedia.maxWidth screenSizeMobile)) do
      CSS.flexWrap CSS.wrap

splashTextLayout :: CSS
splashTextLayout = do
  S.splashText ? do
    CSS.maxWidth (CSS.pct 40.0)
    CSS.padding1 (CSS.em 1.0)

  CSS.query CSSMedia.screen (NE.singleton (CSSMedia.maxWidth screenSizeMobile)) do
    S.splashText ? do
      CSS.maxWidth (CSS.pct 100.0)

splashImageLayout :: CSS
splashImageLayout = do
  S.splashImage ? do
    CSS.width (CSS.pct 50.0)
    CSS.img ? do
      CSS.maxWidth (CSS.pct 100.0)

  CSS.query CSSMedia.screen (NE.singleton (CSSMedia.maxWidth screenSizeMobile)) do
    S.splashImage ? do
      CSS.width CSS.auto
      CSS.height (CSS.pct 100.0)

      CSS.img ? do
        CSS.height (CSS.pct 100.0)
-- | Style

-- | Root
root :: CSS
root = do
  contentLayout
  splashTextLayout
  splashImageLayout
