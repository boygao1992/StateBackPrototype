module Styles where

import Prelude

import Colors as Colors

import CSS.Background (backgroundColor)
import CSS.Border (solid, border) as CSS
import CSS.Common (auto) as CSS
import CSS.Display (position, absolute, relative) as CSS
import CSS.Font (color) as CSS
import CSS.Geometry (width, maxWidth, margin, top, left, padding, lineHeight) as CSS
import CSS.Selector (element) as CSS
import CSS.Size (nil, px, em) as CSS
import CSS.Stylesheet (CSS)
import CSS.Stylesheet (select) as CSS
import Color (Color)
import Color as Color
import Data.Array (filter)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..), fst, snd)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as HC
import Halogen.HTML.Properties as HP



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
