module CSSRoot where

import Prelude

import CSS (CSS)
import CSSStar as Star
import CSSLink as Link
import CSSHeader as Header

root :: CSS
root = do
  Star.root
  Link.root
  Header.root
