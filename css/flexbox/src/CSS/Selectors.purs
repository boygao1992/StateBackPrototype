module Selectors where

import ClassNames as CN
import CSS (Selector)
import CSSUtils (class_)

container :: Selector
container = class_ CN.container

flexColumn :: Selector
flexColumn = class_ CN.flexColumn

elem :: Selector
elem = class_ CN.elem

elemRed :: Selector
elemRed = class_ CN.elemRed

elemYellow :: Selector
elemYellow = class_ CN.elemYellow

label :: Selector
label = class_ CN.label

endLabel :: Selector
endLabel = class_ CN.endLabel

