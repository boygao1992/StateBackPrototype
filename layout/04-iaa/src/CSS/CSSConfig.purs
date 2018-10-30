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
