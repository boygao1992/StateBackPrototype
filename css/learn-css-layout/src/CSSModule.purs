module CSSModule where

import Prelude

import CSS.Selector (Predicate(Id, Class), Selector(Selector), Refinement(Refinement), Path(Star)) as CSS
import CSS.Elements (code) as CSS
import CSS.Stylesheet (CSS)
import CSS.Stylesheet (select) as CSS
import CSS.Background (backgroundColor)
import CSS.Border (solid, border) as CSS
import CSS.Common (auto) as CSS
import CSS.Display (position, absolute, relative) as CSS
import CSS.Font (color) as CSS
import CSS.Geometry (width, maxWidth, margin, top, left, padding, lineHeight) as CSS
import CSS.Size (nil, px, em) as CSS
import Color (Color)
import Color as Color
import Data.Maybe (fromMaybe)


-- | Util
id_ :: String -> CSS.Selector
id_ s = CSS.Selector (CSS.Refinement [ CSS.Id s ]) CSS.Star
class_ :: String -> CSS.Selector
class_ s = CSS.Selector (CSS.Refinement [ CSS.Class s ]) CSS.Star

-- | Color
bgColor :: Color
bgColor = (fromMaybe Color.white) <<< Color.fromHexString $ "#ECECEC"

color_green :: Color
color_green = (fromMaybe Color.white) <<< Color.fromHexString $ "#6AC5AC"

color_dark :: Color
color_dark = (fromMaybe Color.white) <<< Color.fromHexString $ "#414142"

-- | CSS
style_main :: CSS
style_main = do
  CSS.width $ CSS.px 600.0
  CSS.margin CSS.nil CSS.auto CSS.nil CSS.auto

style_main2 :: CSS
style_main2 = do
  CSS.maxWidth $ CSS.px 600.0
  CSS.margin CSS.nil CSS.auto CSS.nil CSS.auto

style_elem :: CSS
style_elem = do
  CSS.border CSS.solid (CSS.px 3.0) color_green
  CSS.position CSS.relative

style_code :: CSS
style_code = backgroundColor bgColor

style_label :: CSS
style_label = do
  CSS.top CSS.nil
  CSS.left CSS.nil
  CSS.padding CSS.nil (CSS.px 3.0) (CSS.px 3.0) CSS.nil

style_endlabel :: CSS
style_endlabel = do
  style_label
  CSS.position CSS.absolute
  backgroundColor color_green
  CSS.color color_dark
  CSS.lineHeight $ CSS.em 1.0

root :: CSS
root = do
  CSS.select CSS.code style_code
  CSS.select (id_ "main") style_main
  CSS.select (class_ "elem") style_elem
  CSS.select (class_ "label") style_endlabel
  CSS.select (class_ "main2") style_main2
