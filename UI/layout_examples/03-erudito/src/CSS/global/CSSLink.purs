module CSSLink where

import CSS as CSS
import CSS (CSS)
import CSSUtils ((?))

linkStyle :: CSS
linkStyle =
  CSS.a ? CSS.textDecoration CSS.noneTextDecoration

root :: CSS
root = linkStyle
