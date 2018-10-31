module Animations where

import Prelude

import AnimationNames as AN
import CSS as CSS
import CSS (CSS)
import CSSUtils (translate_) as CSS
import Data.Tuple (Tuple(Tuple))
import Data.NonEmpty ((:|))
import CSSAnimation (easeInOut, none) as CSSAM
import CSSConfig (springMotion)

-- | Keyframes

vertical :: CSS
vertical = CSS.keyframes AN.vertical $
  ( Tuple 0.0 ( CSS.transform ( CSS.translate CSS.nil CSS.nil))) :|
  [ ( Tuple 100.0 $ CSS.transform $ CSS.translate_ CSS.nil (CSS.pct springMotion) )]

-- | Animations

springOscillation :: CSS
springOscillation =
  CSS.animation
    (CSS.fromString AN.vertical)
    (CSS.sec 1.0)
    CSSAM.easeInOut
    (CSS.sec 0.0)
    CSS.infinite
    CSS.alternate
    CSSAM.none
