module Animations where

import Prelude

import AnimationNames as AN
import CSS (alternate, animation, fromString, infinite, keyframes, nil, sec, transform, translate) as CSS
import CSS (CSS)
import CSSUtils (translate_, pair) as CSS
import Data.Tuple (Tuple(Tuple))
import Data.NonEmpty ((:|))
import CSSAnimation (easeInOut, none) as CSSAM
import CSSConfig (springMotion)

-- | Keyframes

vertical :: CSS
vertical = CSS.keyframes AN.vertical $
  ( Tuple 0.0 ( CSS.transform ( CSS.translate CSS.nil CSS.nil))) :|
  [ ( Tuple 100.0 $ CSS.transform $ CSS.translate_ CSS.nil springMotion )]

twinkle :: CSS
twinkle = CSS.keyframes AN.twinkle $
  ( Tuple 0.0 ( CSS.pair "opacity" "1.0")) :|
  [ ( Tuple 100.0 ( CSS.pair "opacity" "0.1")) ]

root :: CSS
root = do
  vertical
  twinkle


-- twinkle

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

hintTwinkle :: CSS
hintTwinkle =
  CSS.animation
    (CSS.fromString AN.twinkle)
    (CSS.sec 1.0)
    CSSAM.easeInOut
    (CSS.sec 0.0)
    CSS.infinite
    CSS.alternate
    CSSAM.none

-- TODO: modify hero content layout and add text unfolding animation
