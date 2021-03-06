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

headerBar :: Selector
headerBar = class_ CN.headerBar


headerLogo :: Selector
headerLogo = class_ CN.headerLogo

headerButton :: Selector
headerButton = class_ CN.headerButton

headerButtonOpen :: Selector
headerButtonOpen = class_ CN.headerButtonOpen

headerButtonContainer :: Selector
headerButtonContainer = class_ CN.headerButtonContainer
headerButtonPart1 :: Selector
headerButtonPart1 = class_ CN.headerButtonPart1
headerButtonPart2 :: Selector
headerButtonPart2 = class_ CN.headerButtonPart2

headerNavigationDesktop :: Selector
headerNavigationDesktop =  class_ CN.headerNavigationDesktop

headerNavigationDesktopContact :: Selector
headerNavigationDesktopContact = class_ CN.headerNavigationDesktopContact

headerNavigationMobile :: Selector
headerNavigationMobile =  class_ CN.headerNavigationMobile

-- | Hero
hero :: Selector
hero = class_ CN.hero

heroTitle :: Selector
heroTitle = class_ CN.heroTitle

heroInstitute :: Selector
heroInstitute = class_ CN.heroInstitute

heroFor :: Selector
heroFor = class_ CN.heroFor

heroArchitectural :: Selector
heroArchitectural = class_ CN.heroArchitectural

heroAnthropology :: Selector
heroAnthropology = class_ CN.heroAnthropology

heroHint :: Selector
heroHint = class_ CN.heroHint

heroSpring :: Selector
heroSpring = class_ CN.heroSpring

heroSpringContainer :: Selector
heroSpringContainer = class_ CN.heroSpringContainer

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
