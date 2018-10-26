module Selectors where

import CSS (Selector)
import CSSUtils as CSS
import IDs as IDs
import ClassNames as CN

-- | id selectors

header :: Selector
header = CSS.id_ IDs.header

navbar :: Selector
navbar = CSS.id_ IDs.navbar

desktopMenu :: Selector
desktopMenu = CSS.id_ IDs.desktopMenu

mobileMenu :: Selector
mobileMenu = CSS.id_ IDs.mobileMenu

contact :: Selector
contact = CSS.id_ IDs.contact

bubbleYellow :: Selector
bubbleYellow = CSS.id_ IDs.bubbleYellow

bubbleRed :: Selector
bubbleRed = CSS.id_ IDs.bubbleRed

bubblePurple :: Selector
bubblePurple = CSS.id_ IDs.bubblePurple

bubbleGreen :: Selector
bubbleGreen = CSS.id_ IDs.bubbleGreen

-- | class selectors

