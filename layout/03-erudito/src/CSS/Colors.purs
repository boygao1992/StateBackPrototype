module Colors where

import CSSUtils (safeFromHexString)
import Color (Color)
import Color (white) as Color
import Color.Scheme.X11 (yellowgreen, gray) as Color

purple :: Color
purple = safeFromHexString "#8234ee"

darkPurple :: Color
darkPurple = safeFromHexString "#6416d0"

shadowPurple :: Color
shadowPurple = safeFromHexString "#7325df"

white :: Color
white = Color.white

darkerWhite :: Color
darkerWhite = safeFromHexString "#fcfdff"

gray :: Color
gray = Color.gray

warning :: Color
warning = Color.yellowgreen
