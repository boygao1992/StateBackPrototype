module ClassNames where

import Prelude

-- | Utils
namespace :: String -> String -> String
namespace s1 s2 = s1 <> "-" <> s2

-- | Namespaces
header_ :: String -> String
header_ = namespace header

hero_ :: String -> String
hero_ = namespace hero

gallery_ :: String -> String
gallery_ = namespace gallery

-- | Global

logo :: String
logo = "logo"

largeLogo :: String
largeLogo = "large-logo"

-- | Header

header :: String
header = "header"

headerBar :: String
headerBar = header_ "bar"

headerLogo :: String
headerLogo = header_ "logo"

headerButton :: String
headerButton = header_ "button"

headerButtonOpen :: String
headerButtonOpen = headerButton <> "Open"

headerButtonContainer :: String
headerButtonContainer = headerButton <> "Container"
headerButtonPart1 :: String
headerButtonPart1 = headerButton <> "Part1"
headerButtonPart2 :: String
headerButtonPart2 = headerButton <> "Part2"

headerNavigationDesktop :: String
headerNavigationDesktop = header_ "nav-desktop"

headerNavigationDesktopContact :: String
headerNavigationDesktopContact = headerNavigationDesktop <> "Contact"

headerNavigationMobile :: String
headerNavigationMobile = header_ "nav-mobile"

-- | Hero
hero :: String
hero = "hero"

heroTitle :: String
heroTitle = hero_ "title"

heroInstitute :: String
heroInstitute = hero_ "institute"

heroFor :: String
heroFor = hero_ "for"

heroArchitectural :: String
heroArchitectural = hero_ "architectural"

heroAnthropology :: String
heroAnthropology = hero_ "anthropology"

heroHint :: String
heroHint = hero_ "hint"

heroSpring :: String
heroSpring = hero_ "spring"

heroSpringContainer :: String
heroSpringContainer = heroSpring <> "Container"

heroSpringTop :: String
heroSpringTop = heroSpring <> "Top"

heroSpringBottom :: String
heroSpringBottom = heroSpring <> "Bottom"

-- | Gallery

gallery :: String
gallery = "gallery"

galleryItem :: String
galleryItem = gallery_ "item"


-- | Navigator
navigator :: String
navigator = "navigator"

-- | Footer
footer :: String
footer = "footer"
