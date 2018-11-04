module CSS.Root where

import Prelude

import CSS (CSS)
import CSS (alignItems, backgroundColor, backgroundSize, body, borderBox, boxSizing, color, cover, display, em, flex, flexBasis, flexGrow, flexShrink, flexWrap, fontSize, grid, height, importUrl, inlineBlock, justifyContent, lineHeight, marginBottom, marginRight, minHeight, minWidth, nil, noneTextDecoration, pct, px, rem, span, star, textDecoration, vh, wrap) as CSS
import CSS.Common (center) as CSS
import CSS.Config as Config
import CSS.Text.Transform (textTransform, uppercase) as CSS
import CSSUtils ((&), (?))
import CSSUtils (byClass, padding1, padding2, pair, unitless) as CSS
import ClassNames as CN
import Colors as Colors
import Selectors as S
import Urls as Urls

root :: CSS
root = do
  CSS.importUrl Urls.googleRaleway

  CSS.star ? do
    CSS.boxSizing CSS.borderBox

  CSS.body ? do
    CSS.backgroundColor Config.bodyBackgroundColor
    CSS.color Config.mainFontColor
    CSS.pair "font-family" "'Raleway', sans-serif"
    CSS.fontSize $ CSS.rem 1.2
    CSS.lineHeight $ CSS.unitless 1.45
    CSS.display CSS.flex
    CSS.flexWrap CSS.wrap

  -- | Navigation

  S.sidebar ? do
    CSS.backgroundColor Config.menuBackgroundColor
    CSS.flexGrow 1
    CSS.flexShrink 1
    CSS.flexBasis $ CSS.pct 20.0
    CSS.minWidth $ CSS.px 300.0
    CSS.padding1 $ CSS.em 3.0

  S.logo ? do
    CSS.textTransform CSS.uppercase
    CSS.marginBottom $ CSS.em 2.0

    -- TODO: media query
    CSS.span ? do
      CSS.padding2 CSS.nil (CSS.em 0.2)
      Config.fontBold

  S.navItem ? do
    CSS.color Config.menuFontColor
    CSS.textDecoration CSS.noneTextDecoration
    CSS.fontSize $ CSS.rem 1.7
    CSS.display CSS.inlineBlock
    CSS.marginRight $ CSS.em 2.0

  S.navItem & (CSS.byClass CN.active) ? do
    CSS.color Config.menuActiveColor

  -- | Content
  S.content ? do
    CSS.padding1 $ CSS.pct 10.0
    CSS.flexGrow 1
    CSS.flexShrink 1
    CSS.flexBasis $ CSS.pct 80.0
    CSS.minHeight $ CSS.vh 100.0

  -- | Portfolio
  S.portfolio ? do
    CSS.display CSS.grid
    CSS.height $ CSS.pct 100.0
    CSS.pair "grid-template-rows" "repeat(8, 1fr)"
    CSS.pair "grid-template-columns" "repeat(5, 1fr)"
    CSS.pair "grid-gap" "20px"

  S.portfolioItem ? do
    CSS.backgroundColor Config.accent
    CSS.color Colors.lightGray
    Config.fontBold
    CSS.display CSS.flex
    CSS.justifyContent CSS.center
    CSS.alignItems CSS.center

    CSS.fontSize $ CSS.em 1.5
    CSS.backgroundSize CSS.cover

  S.portfolioItem & (CSS.byClass CN.small) ? do
    CSS.pair "grid-row" "span 1"
    CSS.pair "grid-column" "span 1"

  S.portfolioItem & (CSS.byClass CN.medium) ? do
    CSS.pair "grid-row" "span 2"
    CSS.pair "grid-column" "span 2"

  S.portfolioItem & (CSS.byClass CN.large) ? do
    CSS.pair "grid-row" "span 3"
    CSS.pair "grid-column" "span 3"

  S.portfolioItem & (CSS.byClass CN.tall) ? do
    CSS.pair "grid-row" "span 3"
    CSS.pair "grid-column" "span 2"

  S.portfolioItem & (CSS.byClass CN.wide) ? do
    CSS.pair "grid-row" "span 2"
    CSS.pair "grid-column" "span 3"
