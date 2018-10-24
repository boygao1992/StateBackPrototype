module CSSModule where

import Prelude

import CSS.Elements (a, code, footer, img, nav, p, article) as CSS
import CSS.Pseudo (hover) as CSS
import CSS.Selector ((|>))
import CSS.Selector (star) as CSS
import CSS.Stylesheet (CSS)
import CSS.Stylesheet (select) as CSS
import Styles as Styles
import ClassNames as ClassNames
import CSSUtils (byClass, class_, id_, pseudo) as CSS
import CSSUtils ((&), (|*))

-- | Root
root :: CSS
root = do
  CSS.select CSS.star Styles.star_
  CSS.select CSS.code Styles.code
  CSS.select (CSS.id_ "main") Styles.main
  CSS.select (CSS.id_ "main2") Styles.main2
  CSS.select (CSS.id_ "simple") Styles.simple
  CSS.select (CSS.id_ "simple2") Styles.simple2
  CSS.select (CSS.id_ "fancy") Styles.fancy
  CSS.select (CSS.id_ "fancy2") Styles.fancy2
  CSS.select (CSS.class_ ClassNames.elem) Styles.elem
  CSS.select (CSS.class_ ClassNames.elemRed) Styles.elem_red
  do
    CSS.select
      (CSS.class_ ClassNames.elemRed |> CSS.class_ ClassNames.label)
      Styles.allLabel_red
    CSS.select
      (CSS.class_ ClassNames.elemRed |> CSS.class_ ClassNames.endLabel)
      Styles.allLabel_red
  CSS.select (CSS.class_ ClassNames.elemYellow) Styles.elem_yellow
  do
    CSS.select
      (CSS.class_ ClassNames.elemYellow |> CSS.class_ ClassNames.label)
      Styles.allLabel_yellow
    CSS.select
      (CSS.class_ ClassNames.elemYellow |> CSS.class_ ClassNames.endLabel)
      Styles.allLabel_yellow
  CSS.select (CSS.class_ ClassNames.elemGreen) Styles.elem_green
  do
    CSS.select
      (CSS.class_ ClassNames.elemGreen |> CSS.class_ ClassNames.label)
      Styles.allLabel_green
    CSS.select
      (CSS.class_ ClassNames.elemGreen |> CSS.class_ ClassNames.endLabel)
      Styles.allLabel_green
  CSS.select (CSS.class_ ClassNames.label) Styles.label
  CSS.select (CSS.class_ ClassNames.endLabel) Styles.endLabel
  do
    CSS.select (CSS.class_ ClassNames.label) Styles.allLabel
    CSS.select (CSS.class_ ClassNames.endLabel) Styles.allLabel
  do
    CSS.select (CSS.a & CSS.pseudo "link") Styles.link_normal
    CSS.select (CSS.a & CSS.hover) Styles.link_hover
  CSS.select (CSS.class_ "static") Styles.static_
  CSS.select (CSS.class_ "relative1") Styles.relative1
  CSS.select (CSS.class_ "relative2") Styles.relative2
  CSS.select (CSS.class_ "fixed") Styles.fixed_
  CSS.select (CSS.class_ "relative") Styles.relative_
  CSS.select (CSS.class_ "absolute") Styles.absolute_
  CSS.select (CSS.class_ ClassNames.section) Styles.section_
  CSS.select (CSS.nav & CSS.byClass ClassNames.elem) Styles.nav_elem
  CSS.select (CSS.class_ ClassNames.elem |* CSS.p) Styles.elem_p
  CSS.select (CSS.class_ "ipsum") Styles.ipsum
  CSS.select CSS.footer Styles.footer_
  CSS.select (CSS.footer & CSS.byClass ClassNames.elem) Styles.footer_elem
  CSS.select CSS.img Styles.img_
  CSS.select (CSS.class_ "box") Styles.box
  CSS.select (CSS.class_ "after-box") Styles.after_box
  CSS.select (CSS.class_ "nav") Styles.nav_
  CSS.select (CSS.class_ "clearfix") Styles.clearfix
  CSS.select (CSS.article |* CSS.img) Styles.article_img
