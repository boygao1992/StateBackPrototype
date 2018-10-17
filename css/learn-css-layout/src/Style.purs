module Styles where

import Prelude

import CSS.Background (backgroundColor) as CSS
import CSS.Border (solid, border) as CSS
import CSS.Box (borderBox, boxSizing) as CSS
import CSS.Common (auto) as CSS
import CSS.Display (position, absolute, relative, static) as CSS
import CSS.Font (color) as CSS
import CSS.Geometry (width, maxWidth, margin, top, right, bottom, left, padding, lineHeight) as CSS
import CSS.Size (Size)
import CSS.Size (nil, px, em) as CSS
import CSS.String (fromString)
import CSS.Stylesheet (CSS, key)
import CSS.Text (textDecoration, noneTextDecoration, underline) as CSS
import Colors as Colors

-- | Util
margin2 :: forall a. Size a -> Size a -> CSS
margin2 s1 s2 = CSS.margin s1 s2 s1 s2

padding1 :: forall a. Size a -> CSS
padding1 s = CSS.padding s s s s

borderWidth :: forall a. Size a -> CSS
borderWidth = key $ fromString "border-width"

-- | CSS
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

