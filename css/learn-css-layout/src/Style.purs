module Styles where

import Prelude

import CSS.Background (backgroundColor) as CSS
import CSS.Border (solid, border) as CSS
import CSS.Box (borderBox, boxSizing) as CSS
import CSS.Common (auto) as CSS
import CSS.Display (position, absolute, relative, static, fixed, zIndex, float, floatLeft, floatRight, clear, clearLeft) as CSS
import CSS.Font (color) as CSS
import CSS.Geometry (width, maxWidth, height, margin, marginLeft, top, right, bottom, left, padding, lineHeight) as CSS
import CSS.Overflow (overflow, overflowAuto) as CSS
import CSS.Size (Size)
import CSS.Size (nil, px, em, pct) as CSS
import CSS.String (fromString)
import CSS.Stylesheet (CSS, key)
import CSS.Text (textDecoration, noneTextDecoration, underline) as CSS
import CSS.TextAlign (textAlign, center) as CSS
import Colors as Colors

-- | Util
margin1 :: forall a. Size a -> CSS
margin1 s = CSS.margin s s s s

margin2 :: forall a. Size a -> Size a -> CSS
margin2 s1 s2 = CSS.margin s1 s2 s1 s2

padding1 :: forall a. Size a -> CSS
padding1 s = CSS.padding s s s s

padding2 :: forall a. Size a -> Size a -> CSS
padding2 s1 s2 = CSS.padding s1 s2 s1 s2

borderWidth :: forall a. Size a -> CSS
borderWidth = key $ fromString "border-width"

-- | CSS
star_ :: CSS
star_ = do
  CSS.boxSizing CSS.borderBox

p_ :: CSS
p_ = do
  margin2 (CSS.em 1.0) CSS.nil

elem_p :: CSS
elem_p = do
  padding2 CSS.nil (CSS.em 1.0)

main :: CSS
main = do
  CSS.width $ CSS.px 600.0
  CSS.margin CSS.nil CSS.auto CSS.nil CSS.auto

main2 :: CSS
main2 = do
  CSS.maxWidth $ CSS.px 600.0
  CSS.margin CSS.nil CSS.auto CSS.nil CSS.auto

elem :: CSS
elem = do
  CSS.border CSS.solid (CSS.px 3.0) Colors.green
  CSS.position CSS.relative

elem_red :: CSS
elem_red = do
  CSS.border CSS.solid (CSS.px 3.0) Colors.red

elem_yellow :: CSS
elem_yellow = do
  CSS.border CSS.solid (CSS.px 3.0) Colors.yellow

elem_green :: CSS
elem_green = do
  CSS.border CSS.solid (CSS.px 3.0) Colors.lightGreen

code :: CSS
code = CSS.backgroundColor Colors.gray

link_normal :: CSS
link_normal = do
  CSS.color Colors.red
  CSS.textDecoration CSS.noneTextDecoration

link_hover :: CSS
link_hover = do
  CSS.textDecoration CSS.underline

label :: CSS
label = do
  CSS.top CSS.nil
  CSS.left CSS.nil
  CSS.padding CSS.nil (CSS.px 3.0) (CSS.px 3.0) CSS.nil

endLabel :: CSS
endLabel = do
  CSS.right CSS.nil
  CSS.bottom CSS.nil
  CSS.padding (CSS.px 3.0) CSS.nil CSS.nil (CSS.px 3.0)

allLabel :: CSS
allLabel = do
  CSS.position CSS.absolute
  CSS.backgroundColor Colors.green
  CSS.color Colors.dark
  CSS.lineHeight $ CSS.em 1.0

allLabel_red :: CSS
allLabel_red = do
  CSS.color Colors.white
  CSS.backgroundColor Colors.red

allLabel_yellow :: CSS
allLabel_yellow = do
  CSS.backgroundColor Colors.yellow

allLabel_green :: CSS
allLabel_green = do
  CSS.backgroundColor Colors.lightGreen

simple :: CSS
simple = do
  CSS.width (CSS.px 500.0)
  margin2 (CSS.px 20.0) CSS.auto

fancy :: CSS
fancy = do
  simple
  padding1 (CSS.px 50.0)
  borderWidth (CSS.px 10.0)

simple2 :: CSS
simple2 = do
  simple
  CSS.boxSizing CSS.borderBox

fancy2 :: CSS
fancy2 = do
  fancy
  CSS.boxSizing CSS.borderBox

static_ :: CSS
static_ = do
  CSS.position CSS.static

relative1 :: CSS
relative1 = do
  CSS.position CSS.relative

relative2 :: CSS
relative2 = do
  relative1
  CSS.top (CSS.px (-20.0))
  CSS.left (CSS.px 20.0)
  CSS.backgroundColor Colors.white
  CSS.width (CSS.px 500.0)

fixed_ :: CSS
fixed_ = do
  CSS.position CSS.fixed
  CSS.top CSS.nil
  CSS.right CSS.nil
  CSS.width (CSS.px 200.0)
  CSS.backgroundColor Colors.white
  CSS.zIndex 1

relative_ :: CSS
relative_ = do
  CSS.position CSS.relative
  CSS.width (CSS.px 600.0)
  CSS.height (CSS.px 400.0)

absolute_ :: CSS
absolute_ = do
  CSS.position CSS.absolute
  CSS.top (CSS.px 120.0)
  CSS.right CSS.nil
  CSS.width (CSS.px 300.0)
  CSS.height (CSS.px 200.0)

section_ :: CSS
section_ = do
  CSS.marginLeft (CSS.px 200.0)

nav_elem :: CSS
nav_elem = do
  CSS.position CSS.absolute
  CSS.left CSS.nil
  CSS.width (CSS.px 200.0)

ipsum :: CSS
ipsum = do
  CSS.color Colors.darkRed
  CSS.backgroundColor Colors.whitesmoke

footer_ :: CSS
footer_ = do
  CSS.textAlign CSS.center

footer_elem :: CSS
footer_elem = do
  CSS.position CSS.fixed
  CSS.bottom CSS.nil
  CSS.left CSS.nil
  CSS.height (CSS.px 75.0)
  CSS.backgroundColor Colors.white
  CSS.width (CSS.pct 100.0)
  margin1 CSS.nil
  CSS.zIndex 1

img_ :: CSS
img_ = do
  CSS.float CSS.floatRight
  CSS.margin CSS.nil CSS.nil (CSS.em 1.0) (CSS.em 1.0)

box :: CSS
box = do
  CSS.float CSS.floatLeft
  CSS.width (CSS.px 200.0)
  CSS.height (CSS.px 100.0)
  margin1 (CSS.em 1.0)

after_box :: CSS
after_box = do
  CSS.clear CSS.clearLeft

nav_ :: CSS
nav_ = do
  CSS.float CSS.floatLeft
  CSS.width (CSS.px 200.0)

clearfix :: CSS
clearfix = do
  CSS.overflow CSS.overflowAuto

article_img :: CSS
article_img = do
  CSS.float CSS.floatRight
  CSS.width (CSS.pct 50.0)
