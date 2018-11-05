module CSSRoot where

import Prelude

import CSS (CSS)
import CSSStar as Star
import CSSLink as Link
import CSSHeader as Header
import CSSContent as Content

root :: CSS
root = do
  Star.root
  Link.root
  Header.root
  Content.root
