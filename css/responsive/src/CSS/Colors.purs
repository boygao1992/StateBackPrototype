module Colors where

import CSSUtils (safeFromHexString)
import Color (Color)
import Color (white) as Color
import Color.Scheme.X11 (lightgray) as Color

white :: Color
white = Color.white

lightgray :: Color
lightgray = Color.lightgray

lightgreen :: Color
lightgreen = safeFromHexString "#00ff6c"

dark :: Color
dark = safeFromHexString "#232323"
