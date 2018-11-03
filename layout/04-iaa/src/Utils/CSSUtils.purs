module CSSUtils where

import Prelude

import CSS.Common (browsers)
import CSS (Time)
import CSS.Transition (TimingFunction)
import CSS (borderRadius, child, margin, padding, select) as CSS
import CSS.Flexbox (JustifyContentValue)
import CSS.Property (class Val, value, (!))
import CSS.Selector (Predicate(Pseudo, Class, Id), Refinement(Refinement), Selector(Selector), Path(Combined))
import CSS.Selector (deep, star, with) as CSS
import CSS.Size (Size(Size), Rel)
import CSS.String (fromString)
import CSS.Stylesheet (CSS, key, prefixed)
import CSS.Transform (Transformation(..))
import Color (Color)
import Color as Color
import Data.Maybe (fromMaybe)
import Data.Array (intercalate, replicate)

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

infixl 6 CSS.select as ?
infixl 6 CSS.child as |> -- A > B
infixl 6 CSS.with as & -- AB, bug fix for 3.4.0
infixl 6 CSS.deep as |* -- A B
infixl 6 combine as ++

-- -- | Element
-- root :: Selector
-- root = CSS.element ":root"

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

-- | Pseudo
link :: Refinement
link = fromString ":link"

focus :: Refinement
focus = fromString ":focus"

before :: Refinement
before = fromString "::before"

after :: Refinement
after = fromString "::after"

-- | Flex
class SpaceEvenly a where
  spaceEvenly :: a

instance spaceEvenlyJustifyContentValue :: SpaceEvenly JustifyContentValue where
  spaceEvenly = fromString "space-evenly"

-- | Size
fr :: Number -> Size Rel
fr i = Size (value i <> fromString "fr")

-- | Transform
translate_ :: Size Rel -> Size Rel -> Transformation
translate_ x y = Transformation $ fromString "translate(" <> value [x, y] <> fromString ")"

-- | Grid
newtype GridArray a = GridArray (Array a)
derive instance eqGridArray :: (Eq a) => Eq (GridArray a)
derive instance ordGridArray :: (Ord a) => Ord (GridArray a)

instance valGridArray :: (Val a) => Val (GridArray a) where
  value (GridArray xs) = intercalate (fromString " ") (value <$> xs)

gridTemplateColumns :: forall a. GridArray (Size a) -> CSS
gridTemplateColumns = key (fromString "grid-template-columns") <<< value

gridTemplateRows :: forall a. GridArray (Size a) -> CSS
gridTemplateRows = key (fromString "grid-template-rows") <<< value

gridArray :: forall a. Array (Size a) -> GridArray (Size a)
gridArray = GridArray

gridRepeat :: forall a. Int -> Size a -> GridArray (Size a)
gridRepeat n s = GridArray (replicate n s)

-- | Transition
-- from purescript-css/master
transition :: String -> Time -> TimingFunction -> Time -> CSS
transition p d f e = prefixed (browsers <> fromString "transition") (p ! d ! f ! e)

-- | HACK

pair :: String -> String -> CSS
pair k v = key (fromString k) (value v)
