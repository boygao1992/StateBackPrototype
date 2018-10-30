module Selectors where

import CSS (Selector)
import CSSUtils (class_)
import ClassNames as CN

-- | id selectors

-- | class selectors

logo :: Selector
logo = class_ CN.logo

largeLogo :: Selector
largeLogo = class_ CN.largeLogo

-- | Header

header :: Selector
header = class_ CN.header

headerButton :: Selector
headerButton = class_ CN.headerButton

headerNavigationDesktop :: Selector
headerNavigationDesktop =  class_ CN.headerNavigationDesktop

headerNavigationMobile :: Selector
headerNavigationMobile =  class_ CN.headerNavigationMobile

-- | Hero
hero :: Selector
hero = class_ CN.hero

heroTitle :: Selector
heroTitle = class_ CN.heroTitle

heroHint :: Selector
heroHint = class_ CN.heroHint

heroSpring :: Selector
heroSpring = class_ CN.heroSpring

heroSpringTop :: Selector
heroSpringTop = class_ CN.heroSpringTop

heroSpringBottom :: Selector
heroSpringBottom = class_ CN.heroSpringBottom

-- | Gallery

gallery :: Selector
gallery = class_ CN.gallery

galleryItem :: Selector
galleryItem = class_ CN.galleryItem


-- | Navigator
navigator :: Selector
navigator = class_ CN.navigator

-- | Footer
footer :: Selector
footer = class_ CN.footer
