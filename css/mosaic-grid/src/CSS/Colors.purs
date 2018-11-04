module Colors where

import CSSUtils (safeFromHexString)
import Color (Color)

black :: Color
black = safeFromHexString "#353535"

gray :: Color
gray = safeFromHexString "#4f4f4f"

mediumGray :: Color
mediumGray = safeFromHexString "#737373"

lightGray :: Color
lightGray = safeFromHexString "#c4c4c4"

orange :: Color
orange = safeFromHexString "#f96855"
