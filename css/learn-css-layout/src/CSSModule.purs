module CSSModule where

import Prelude

import CSS.Selector
  ( Predicate(Class, Id, Pseudo)
  , Refinement(Refinement)
  , Selector
  , (|>)
  )
import CSS.Pseudo (hover) as CSS
import CSS.Selector (star, with) as CSS
import CSS.Elements (a, code) as CSS
import CSS.Stylesheet (CSS)
import CSS.Stylesheet (select) as CSS
import Styles as Styles


-- | Util
infix 0 CSS.with as ## -- bug fix for 3.4.0

byId :: String -> Refinement
byId = Refinement <<< pure <<< Id

byClass :: String -> Refinement
byClass = Refinement <<< pure <<< Class

pseudo :: String -> Refinement
pseudo = Refinement <<< pure <<< Pseudo

id_ :: String -> Selector
id_ s = CSS.star ## byId s

class_ :: String -> Selector
class_ s = CSS.star ## byClass s

-- | Root
root :: CSS
root = do
  CSS.select CSS.code Styles.code
  CSS.select (id_ "main") Styles.main
  CSS.select (id_ "main2") Styles.main2
  CSS.select (id_ "simple") Styles.simple
  CSS.select (id_ "simple2") Styles.simple2
  CSS.select (id_ "fancy") Styles.fancy
  CSS.select (id_ "fancy2") Styles.fancy2
  CSS.select (class_ "elem") Styles.elem
  CSS.select (class_ "elem-red") Styles.elem_red
  CSS.select (class_ "label") Styles.label
  CSS.select (class_ "endLabel") Styles.endLabel
  do
    CSS.select (class_ "label") Styles.allLabel
    CSS.select (class_ "endLabel") Styles.allLabel
  do
    CSS.select (class_ "elem-red" |> class_ "label") Styles.allLabel_red
    CSS.select (class_ "elem-red" |> class_ "endLabel") Styles.allLabel_red
  do
    CSS.select (CSS.a ## pseudo "link") Styles.link_normal
    CSS.select (CSS.a ## CSS.hover) Styles.link_hover
  CSS.select (class_ "static") Styles.static_
  CSS.select (class_ "relative1") Styles.relative1
  CSS.select (class_ "relative2") Styles.relative2
