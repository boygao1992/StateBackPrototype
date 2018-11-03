module CSSConfig where

import Prelude

import CSS (CSS, Size, Rel, rem, query)
import CSSMedia (screen, minWidth) as CSSMedia
import Data.NonEmpty (singleton) as NE
import CSS as CSS

screenSizeDesktop :: Size Rel
screenSizeDesktop = rem 60.0

screenSizeHalf :: Size Rel
screenSizeHalf = rem 37.0

desktop :: CSS -> CSS
desktop = query CSSMedia.screen (NE.singleton (CSSMedia.minWidth screenSizeDesktop))

half :: CSS -> CSS
half = query CSSMedia.screen (NE.singleton (CSSMedia.minWidth screenSizeHalf))

ballRadius :: Number -- em
ballRadius = 0.25

springWidth :: CSS
springWidth = CSS.width $ CSS.em 0.1


springHeight :: CSS
springHeight = CSS.height $ CSS.em 2.5


springMotion :: Size Rel
springMotion = CSS.pct 30.0

headerHeight :: CSS
headerHeight = CSS.height (CSS.rem 2.0)
