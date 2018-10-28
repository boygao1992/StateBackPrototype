module Colors where

import CSSUtils (safeFromHexString)
import Color (Color)
import Color as Color
import Color.Scheme.X11 as Color

accent :: Color
accent = safeFromHexString "#F6AE2D"

dark :: Color
dark = safeFromHexString "#2F4858"

light :: Color
light = safeFromHexString "#EBF5EE"
