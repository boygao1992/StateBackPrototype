module CSSStar where

import Prelude
import CSS (CSS, (?))
import CSS as CSS
import CSS.Common (inherit) as CSS

root :: CSS
root =
  CSS.star ? do
    CSS.boxSizing CSS.inherit
