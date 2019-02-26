module Magento.Model.Orders where

import Magento.Model.Address (Address)

import Prelude
import Data.DateTime (DateTime)
import Data.Maybe (Maybe)
import Data.Fixed (Fixed, P100)

newtype ID = ID Int

type PurchasePoint = Array String

data OrderStatus
  = Closed
  | Processing

newtype Order = Order
  { id :: ID
  , date :: DateTime -- sales/order/Purchase Date, sales/order/view/Order Date
  , status :: OrderStatus -- sales/order/Status, sales/order/view/Order Status
  , purchased_from :: PurchasePoint -- sales/order/Purchase Point, sales/order/view/Purchased From
  , billTo_name :: String
  , grand_total ::
    { base :: Fixed P100
    , purchased :: Fixed P100
    }
  , signifyd_guarantee_decision :: Maybe Unit
  }
