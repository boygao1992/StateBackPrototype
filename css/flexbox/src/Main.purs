module Main where

import Prelude

import Data.Maybe (fromMaybe)
import Effect (Effect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Web.DOM.ParentNode (QuerySelector(..))
import ViewComponent as VC

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    app <- HA.selectElement (QuerySelector "#app")
    runUI
      ( VC.component
      )
      unit -- Input
      (fromMaybe body app) -- HTMLElement

