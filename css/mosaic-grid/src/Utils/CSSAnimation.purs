module CSSAnimation
  ( easeIn
  , easeInOut
  , none
  , module CSS.Transition
  )
  where

import Prelude

import CSS.String (fromString)
import CSS.Transition (TimingFunction(..), easeOut, linear)
import CSS.Animation (FillMode(..))

-- | TimingFunctions

easeInOut :: TimingFunction
easeInOut = TimingFunction $ fromString "ease-in-out"

easeIn :: TimingFunction
easeIn = TimingFunction $ fromString "ease-in"

-- | FillModes

none :: FillMode
none = FillMode $ fromString "none"
