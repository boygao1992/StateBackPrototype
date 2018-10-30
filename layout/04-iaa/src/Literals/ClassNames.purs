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

headerButton :: String
headerButton = header_ "button"

headerNavigationDesktop :: String
headerNavigationDesktop = header_ "nav-desktop"

headerNavigationMobile :: String
headerNavigationMobile = header_ "nav-mobile"

-- | Hero
hero :: String
hero = "hero"

heroTitle :: String
heroTitle = hero_ "title"

heroHint :: String
heroHint = hero_ "hint"

heroSpring :: String
heroSpring = hero_ "spring"

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
