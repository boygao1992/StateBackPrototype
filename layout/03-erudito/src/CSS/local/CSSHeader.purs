module CSSHeader where

import Prelude

import CSS (CSS)
import CSS as CSS
import CSS.Common (center) as CSS
import CSSUtils ((?), (&))
import CSSUtils as CSS
import Colors as Colors
import Selectors as S

-- | Layout

headerLayout :: CSS
headerLayout = do
  S.header ? do
    CSS.display CSS.flex
    CSS.flexDirection CSS.row
    CSS.justifyContent CSS.center
    CSS.alignItems CSS.center

    CSS.height (CSS.px 35.0)
    CSS.padding (CSS.rem 1.9) CSS.nil (CSS.rem 3.9) CSS.nil

    CSS.img ? do
      CSS.maxWidth (CSS.vw 50.0)
      CSS.position CSS.absolute
      CSS.right CSS.nil
      CSS.transform $ CSS.translate_ (CSS.rem 2.0) (CSS.rem (-3.0))
      CSS.zIndex (-1)

navbarLayout :: CSS
navbarLayout =
  S.navbar ? do
    CSS.display CSS.flex
    CSS.alignItems CSS.center
    CSS.justifyContent CSS.spaceBetween

    CSS.zIndex 1
    CSS.width (CSS.pct 75.0)
    CSS.top CSS.nil
    CSS.left CSS.nil
    CSS.right CSS.nil

desktopMenuLayout :: CSS
desktopMenuLayout =
  S.desktopMenu ? do
    CSS.display CSS.flex

    CSS.a ? do
      CSS.margin1 (CSS.rem 0.95)
      CSS.position CSS.relative

contactLayout :: CSS
contactLayout =
  S.contact ? do
    CSS.display CSS.block

-- | Style

desktopMenuStyle :: CSS
desktopMenuStyle =
  S.desktopMenu ? do
    CSS.a ? do
      CSS.color Colors.gray
    CSS.a & CSS.hover ? do
      CSS.color Colors.black


contactStyle :: CSS
contactStyle =
  S.contact ? do
    CSS.color Colors.white
    CSS.fontWeight (CSS.weight 600.0)


root :: CSS
root = do
  headerLayout
  navbarLayout
  desktopMenuLayout
  contactLayout

  desktopMenuStyle
  contactStyle
