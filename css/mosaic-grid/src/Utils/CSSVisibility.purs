module CSSVisibility where

import Prelude

import CSS.Common
  ( class Visible, visible
  , class Hidden, hidden
  , class Initial, initial
  , class Inherit, inherit
  )
import CSS.Property (class Val, Value)
import CSS.String (fromString)
import CSS.Stylesheet (CSS, key)

-- | Util
newtype Visibility = Visibility Value
derive instance eqVisibility :: Eq Visibility
derive instance ordVisiblity :: Ord Visibility
derive newtype instance visibleVisibility :: Visible Visibility
derive newtype instance hiddenVisibility :: Hidden Visibility
derive newtype instance initialVisibility :: Initial Visibility
derive newtype instance inheritVisibility :: Inherit Visibility

instance valVisibility :: Val Visibility where
  value (Visibility v) = v

visibilityVisible :: Visibility
visibilityVisible = visible

visibilityHidden :: Visibility
visibilityHidden = hidden

visibilityInitial :: Visibility
visibilityInitial = initial

visibilityInherit :: Visibility
visibilityInherit = inherit

visibilityCollapse :: Visibility
visibilityCollapse = Visibility $ fromString "collapse"

-- visibilitySeparate :: Visibility
-- visibilitySeparate = Visibility $ fromString "separate"

visibility :: Visibility -> CSS
visibility = key $ fromString "visibility"
