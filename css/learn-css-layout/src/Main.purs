module Main where

import Prelude

import Data.Maybe (fromMaybe)
import Effect (Effect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Web.DOM.ParentNode (QuerySelector(..))
import LearnCSSLayout as LCL


main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  app <- HA.selectElement (QuerySelector "#app")
  runUI
    ( LCL.component
    )
    unit -- Input
    (fromMaybe body app) -- HTMLElement
