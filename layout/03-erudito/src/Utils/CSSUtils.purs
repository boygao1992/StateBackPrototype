module CSSUtils where

import Prelude

import CSS (margin, padding, borderRadius) as CSS
import CSS.Property (value)
import CSS.Flexbox (JustifyContentValue)
import CSS.Selector (Predicate(Pseudo, Class, Id), Refinement(Refinement), Selector(Selector), Path(Combined))
import CSS.Selector (deep, star, with) as CSS
import CSS.Size (Size, Rel)
import CSS.String (fromString)
import CSS.Stylesheet (CSS, key)
import CSS.Transform (Transformation(..))
import Color (Color)
import Color as Color
import Data.Maybe (fromMaybe)

-- | Color
safeFromHexString :: String -> Color
safeFromHexString = fromMaybe Color.white <<< Color.fromHexString

-- | Selector
byId :: String -> Refinement
byId = Refinement <<< pure <<< Id

byClass :: String -> Refinement
byClass = Refinement <<< pure <<< Class

pseudo :: String -> Refinement
pseudo = Refinement <<< pure <<< Pseudo

id_ :: String -> Selector
id_ s = CSS.star & byId s

class_ :: String -> Selector
class_ s = CSS.star & byClass s

combine :: Selector -> Selector -> Selector
combine s1 s2 = Selector (Refinement []) (Combined s1 s2)

infixl 6 CSS.with as & -- AB, bug fix for 3.4.0
infixl 6 CSS.deep as |* -- A B
infixl 6 combine as ++


-- | Style
margin1 :: forall a. Size a -> CSS
margin1 s = CSS.margin s s s s

margin2 :: forall a. Size a -> Size a -> CSS
margin2 s1 s2 = CSS.margin s1 s2 s1 s2

padding1 :: forall a. Size a -> CSS
padding1 s = CSS.padding s s s s

padding2 :: forall a. Size a -> Size a -> CSS
padding2 s1 s2 = CSS.padding s1 s2 s1 s2

borderWidth :: forall a. Size a -> CSS
borderWidth = key $ fromString "border-width"

borderRadius1 :: forall a. Size a -> CSS
borderRadius1 s = CSS.borderRadius s s s s

-- | Flex
class SpaceEvenly a where
  spaceEvenly :: a

instance spaceEvenlyJustifyContentValue :: SpaceEvenly JustifyContentValue where
  spaceEvenly = fromString "space-evenly"

-- | Transform
translate_ :: Size Rel -> Size Rel -> Transformation
translate_ x y = Transformation $ fromString "translate(" <> value [x, y] <> fromString ")"
