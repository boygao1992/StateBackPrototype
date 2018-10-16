module Styles where

import Prelude

import CSS.Background (backgroundColor)
import CSS.Border (solid, border) as CSS
import CSS.Common (auto) as CSS
import CSS.Display (position, absolute, relative) as CSS
import CSS.Font (color) as CSS
import CSS.Geometry (width, maxWidth, margin, top, left, padding, lineHeight) as CSS
import CSS.Size (Size)
import CSS.Size (nil, px, em) as CSS
import CSS.String (fromString)
import CSS.Stylesheet (CSS, key)
import CSS.Box (borderBox, boxSizing) as CSS
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

code :: CSS
code = backgroundColor Colors.gray

label :: CSS
label = do
  CSS.top CSS.nil
  CSS.left CSS.nil
  CSS.padding CSS.nil (CSS.px 3.0) (CSS.px 3.0) CSS.nil

endlabel :: CSS
endlabel = do
  label
  CSS.position CSS.absolute
  backgroundColor Colors.green
  CSS.color Colors.dark
  CSS.lineHeight $ CSS.em 1.0

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
