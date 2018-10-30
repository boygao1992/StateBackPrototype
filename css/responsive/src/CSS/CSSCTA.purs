module CSSCTA where


import Prelude

import CSS (CSS)
import CSS (backgroundColor, em, h1, marginTop, nil) as CSS
import CSSUtils ((?))
import CSSUtils (padding2) as CSS
import Colors as Colors
import Selectors as S

root :: CSS
root =
  S.callToAction ? do
    CSS.backgroundColor Colors.springgreen
    CSS.padding2 (CSS.em 3.0) CSS.nil

    CSS.h1 ? do
      CSS.marginTop CSS.nil
