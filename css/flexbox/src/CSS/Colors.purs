module Colors where

import Prelude

import Color (Color)
import Color as Color
import Data.Maybe (fromMaybe)

-- | Util
safeFromHexString :: String -> Color
safeFromHexString = (fromMaybe Color.white) <<< Color.fromHexString

-- | Color
gray :: Color
gray = safeFromHexString "#ECECEC"

green :: Color
green = safeFromHexString "#6AC5AC"

lightGreen :: Color
lightGreen = safeFromHexString "#96C02E"

dark :: Color
dark = safeFromHexString "#414142"

red :: Color
red = safeFromHexString "#D64078"

darkRed :: Color
darkRed = safeFromHexString "#734161"

blue :: Color
blue = safeFromHexString "#0000FF"

white :: Color
white = Color.white

whitesmoke :: Color
whitesmoke = safeFromHexString "#eee"

yellow :: Color
yellow = safeFromHexString "#FDC72F"
