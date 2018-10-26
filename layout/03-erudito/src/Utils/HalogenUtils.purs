module HalogenUtils where

import Prelude
import Halogen (IProp, ClassName(ClassName))
import Halogen.HTML.Properties (classes)

-- | Utils
classList
  :: forall r i
   . Array String
  -> IProp ("class" :: String | r) i
classList = classes <<< map ClassName
