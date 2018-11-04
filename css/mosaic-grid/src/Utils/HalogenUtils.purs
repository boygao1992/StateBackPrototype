module HalogenUtils where

import Prelude
import Halogen (IProp, ClassName(ClassName), HTML)
import Halogen.HTML.Properties (classes)
import Halogen.HTML (attr, AttrName(AttrName)) as HH
import Svg.Renderer.Halogen as Svg
import Data.Array ((:), filter)
import Data.Tuple (Tuple, fst, snd)

-- | Utils
classList
  :: forall r i
   . Array String
  -> IProp ("class" :: String | r) i
classList = classes <<< map ClassName

classList_
  :: forall r i
   . Array (Tuple Boolean String)
  -> IProp ("class" :: String | r) i
classList_ = classes <<< map (ClassName <<< snd) <<< filter fst

-- | Svg
svg_ :: forall p r i. String -> Array (IProp r i) -> HTML p i
svg_ code props = Svg.icon code ((HH.attr (HH.AttrName "class") "icon") : props)

svg :: forall p r i. String -> String -> Array (IProp r i) -> HTML p i
svg className code props = Svg.icon code ((HH.attr (HH.AttrName "class") className) : props)
