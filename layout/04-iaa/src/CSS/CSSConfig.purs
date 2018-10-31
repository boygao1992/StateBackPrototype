module CSSConfig where

import CSS (CSS, Size, Rel, rem, query)
import CSSMedia (screen, minWidth) as CSSMedia
import Data.NonEmpty (singleton) as NE

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

springWidth :: Number -- em
springWidth = 0.1

springHeight :: Number -- em
springHeight = 2.5

springMotion :: Number -- pct
springMotion = 30.0
