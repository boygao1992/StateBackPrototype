module CSSModule where

import Prelude

import CSS.Elements (a, code, section, nav, p, footer, img) as CSS
import CSS.Pseudo (hover) as CSS
import CSS.Selector (Predicate(Class, Id, Pseudo), Refinement(Refinement), Selector, (|>))
import CSS.Selector (star, with, deep) as CSS
import CSS.Stylesheet (CSS)
import CSS.Stylesheet (select) as CSS
import Styles as Styles
import ClassNames as ClassNames

-- | Util
infix 6 CSS.with as & -- AB, bug fix for 3.4.0
infix 6 CSS.deep as |* -- A B

byId :: String -> Refinement
byId = Refinement <<< pure <<< Id

byClass :: String -> Refinement
byClass = Refinement <<< pure <<< Class

pseudo :: String -> Refinement
pseudo = Refinement <<< pure <<< Pseudo

id_ :: String -> Selector
id_ s = CSS.star & byId s

class_ :: String -> Selector
class_ s = CSS.star & byClass s

-- | Root
root :: CSS
root = do
  CSS.select CSS.star Styles.star_
  CSS.select CSS.code Styles.code
  CSS.select (id_ "main") Styles.main
  CSS.select (id_ "main2") Styles.main2
  CSS.select (id_ "simple") Styles.simple
  CSS.select (id_ "simple2") Styles.simple2
  CSS.select (id_ "fancy") Styles.fancy
  CSS.select (id_ "fancy2") Styles.fancy2
  CSS.select (class_ ClassNames.elem) Styles.elem
  CSS.select (class_ ClassNames.elemRed) Styles.elem_red
  do
    CSS.select
      (class_ ClassNames.elemRed |> class_ ClassNames.label)
      Styles.allLabel_red
    CSS.select
      (class_ ClassNames.elemRed |> class_ ClassNames.endLabel)
      Styles.allLabel_red
  CSS.select (class_ ClassNames.elemYellow) Styles.elem_yellow
  do
    CSS.select
      (class_ ClassNames.elemYellow |> class_ ClassNames.label)
      Styles.allLabel_yellow
    CSS.select
      (class_ ClassNames.elemYellow |> class_ ClassNames.endLabel)
      Styles.allLabel_yellow
  CSS.select (class_ ClassNames.elemGreen) Styles.elem_green
  do
    CSS.select
      (class_ ClassNames.elemGreen |> class_ ClassNames.label)
      Styles.allLabel_green
    CSS.select
      (class_ ClassNames.elemGreen |> class_ ClassNames.endLabel)
      Styles.allLabel_green
  CSS.select (class_ ClassNames.label) Styles.label
  CSS.select (class_ ClassNames.endLabel) Styles.endLabel
  do
    CSS.select (class_ ClassNames.label) Styles.allLabel
    CSS.select (class_ ClassNames.endLabel) Styles.allLabel
  do
    CSS.select (CSS.a & pseudo "link") Styles.link_normal
    CSS.select (CSS.a & CSS.hover) Styles.link_hover
  CSS.select (class_ "static") Styles.static_
  CSS.select (class_ "relative1") Styles.relative1
  CSS.select (class_ "relative2") Styles.relative2
  CSS.select (class_ "fixed") Styles.fixed_
  CSS.select (class_ "relative") Styles.relative_
  CSS.select (class_ "absolute") Styles.absolute_
  CSS.select CSS.section Styles.section_
  CSS.select (CSS.nav & byClass ClassNames.elem) Styles.nav_elem
  CSS.select (class_ ClassNames.elem |* CSS.p) Styles.elem_p
  CSS.select (class_ "ipsum") Styles.ipsum
  CSS.select CSS.footer Styles.footer_
  CSS.select (CSS.footer & byClass ClassNames.elem) Styles.footer_elem
  CSS.select CSS.img Styles.img_
