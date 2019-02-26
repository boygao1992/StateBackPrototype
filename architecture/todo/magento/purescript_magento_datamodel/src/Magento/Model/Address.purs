module Magento.Model.Address where

import Prelude
import Data.Maybe (Maybe)

newtype Country = Country Unit
newtype StateOrProvince = StateOrProvince Unit
newtype PhoneNumber = PhoneNumber Int

newtype Address = Address
  { name_prefix :: Maybe String
  , first_name :: String
  , middle_name :: Maybe String
  , last_name :: Maybe String
  , name_suffix :: Maybe String
  , company :: Maybe String
  , street_address :: String
  , city :: String
  , country :: Country
  , stateOrProvince :: StateOrProvince
  , zipOrPostal_code :: Maybe String
  , phone_number :: PhoneNumber
  , fax :: Maybe String
  , vat_number :: Maybe Int
  }
