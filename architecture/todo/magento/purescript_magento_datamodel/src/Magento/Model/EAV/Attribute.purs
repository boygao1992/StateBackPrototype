module Magento.Model.EAV.Attribute where

data EntityType
  = Customer
  | CustomerAddress
  | CatalogCategory

data FrontendInput
  -- parent-child
  = Select
  | Multiselect
  -- view
  | Hidden
  -- atom
  | FrontentInput_Text
  | FrontentInput_Boolean
  | FrontentInput_Date
  | FrontentInput_Price
  | FrontentInput_Etc

data BackendType
  = Static
  | BackendType_Text
  | BackendType_DateTime
  | BackendType_Etc

newtype Attribute = Attribute
  { entity_type :: EntityType
  , frontend_input :: FrontendInput
  , backend_type :: BackendType
  , attribute_code :: String
  }
