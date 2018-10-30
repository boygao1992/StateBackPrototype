module Colors where

import CSSUtils (safeFromHexString)
import Color (Color)
import Color (white, black) as Color
import Color.Scheme.X11 as Color

black :: Color
black = Color.black

white :: Color
white = Color.white

robinsEggBlue :: Color
robinsEggBlue = safeFromHexString "#00C9B6"

codGray :: Color
codGray = safeFromHexString "#1a1a1a"
