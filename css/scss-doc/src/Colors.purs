module Colors where

import CSSUtils as CSS
import Color (Color, rgba)
import Color.Scheme.MaterialDesign (blue, lime, red) as Color
import Color (black) as Color

lime :: Color
lime = Color.lime

red :: Color
red = Color.red

pink :: Color
pink = CSS.safeFromHexString "#ffdddd"

black :: Color
black = Color.black

blue :: Color
blue = Color.blue

transparent :: Color
transparent = rgba 255 255 255 0.0
