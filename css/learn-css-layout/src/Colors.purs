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

dark :: Color
dark = safeFromHexString "#414142"

red :: Color
red = safeFromHexString "#D64078"
