module Export where

import Prelude

import CSS.Render (render, renderedSheet)
import CSSModule (root)
import Data.Maybe (fromMaybe)
import Effect (Effect)
import Node.Encoding (Encoding(UTF8))
import Node.FS.Sync (writeTextFile)

export :: Effect Unit
export = do
  let css = fromMaybe "" <<< renderedSheet <<< render $ root
  writeTextFile UTF8 "compiled/purescript-css.css" css
