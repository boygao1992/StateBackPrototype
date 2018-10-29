module Colors where

import CSSUtils (safeFromHexString)
import Color (Color)
import Color (white, black) as Color
import Color.Scheme.X11 (lightgray, springgreen) as Color

black :: Color
black = Color.black

white :: Color
white = Color.white

lightgray :: Color
lightgray = Color.lightgray

springgreen :: Color
springgreen = Color.springgreen

william :: Color
william = safeFromHexString "#37566a"

mineshaft :: Color
mineshaft = safeFromHexString "#232323"
