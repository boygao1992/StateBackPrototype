module Selectors where

import CSS (Selector)
import CSSUtils (class_)
import ClassNames as CN

-- | id selectors

-- | class selectors

content :: Selector
content = class_ CN.content

section :: Selector
section = class_ CN.section

title :: Selector
title = class_ CN.title

table :: Selector
table = class_ CN.table

absolute :: Selector
absolute = class_ CN.absolute

flexbox :: Selector
flexbox = class_ CN.flexbox

grid :: Selector
grid = class_ CN.grid

margins :: Selector
margins = class_ CN.margins

alignSelf :: Selector
alignSelf = class_ CN.alignSelf
