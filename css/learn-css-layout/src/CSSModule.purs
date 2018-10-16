module CSSModule where

import Prelude

import CSS.Selector (Predicate(Id, Class), Selector(Selector), Refinement(Refinement), Path(Star)) as CSS
import CSS.Elements (code) as CSS
import CSS.Stylesheet (CSS)
import CSS.Stylesheet (select) as CSS
import Styles as Styles


-- | Util
id_ :: String -> CSS.Selector
id_ s = CSS.Selector (CSS.Refinement [ CSS.Id s ]) CSS.Star

class_ :: String -> CSS.Selector
class_ s = CSS.Selector (CSS.Refinement [ CSS.Class s ]) CSS.Star


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
  CSS.select (class_ "label") Styles.endlabel
