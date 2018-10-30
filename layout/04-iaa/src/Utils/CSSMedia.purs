module CSSMedia
  (maxWidth, minWidth, module CSS.Media)
  where

import Prelude

import Data.Maybe (Maybe(..))
import CSS.Property (value)
import CSS.Size (Size)
import CSS.Stylesheet (Feature(Feature))
import CSS.Media (screen)

maxWidth :: forall a. Size a -> Feature
maxWidth = Feature "max-width" <<< Just <<< value

minWidth :: forall a. Size a -> Feature
minWidth = Feature "min-width" <<< Just <<< value
