module CSS.Config where

import CSS (CSS)
import Color (Color)
import Colors as Colors
import CSSUtils (pair) as CSS

accent :: Color
accent = Colors.orange

bodyBackgroundColor :: Color
bodyBackgroundColor = Colors.black

menuBackgroundColor :: Color
menuBackgroundColor = Colors.gray

mainFontColor :: Color
mainFontColor = Colors.lightGray

menuActiveColor :: Color
menuActiveColor = Colors.lightGray

menuFontColor :: Color
menuFontColor = Colors.mediumGray

linkColor :: Color
linkColor = accent

fontLight :: CSS
fontLight = CSS.pair "font-weight" "300"

fontBold :: CSS
fontBold = CSS.pair "font-weight" "700"
