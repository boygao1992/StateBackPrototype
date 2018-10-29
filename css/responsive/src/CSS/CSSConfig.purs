module CSSConfig where

import CSS (CSS, Size, Rel, rem, query)
import CSSMedia (screen, minWidth) as CSSMedia
import CSSConfig (screenSizeMobile)
import Data.NonEmpty (singleton) as NE

screenSizeMobile :: Size Rel
screenSizeMobile = rem 60.0

desktop :: CSS -> CSS
desktop = query CSSMedia.screen (NE.singleton (CSSMedia.minWidth screenSizeMobile))
