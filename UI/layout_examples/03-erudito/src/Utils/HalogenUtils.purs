module HalogenUtils where

import Prelude
import Halogen (IProp, ClassName(ClassName), HTML)
import Halogen.HTML.Properties (classes)
import Halogen.HTML (attr, AttrName(AttrName)) as HH
import Svg.Renderer.Halogen as Svg
import Data.Array ((:))

-- | Utils
classList
  :: forall r i
   . Array String
  -> IProp ("class" :: String | r) i
classList = classes <<< map ClassName

-- | Svg
svg_ :: forall p r i. String -> Array (IProp r i) -> HTML p i
svg_ code props = Svg.icon code ((HH.attr (HH.AttrName "class") "icon") : props)
