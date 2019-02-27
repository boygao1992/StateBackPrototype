product
- `catalog_product_entity`
  - if `type_id` == "configurable" | "grouped" | "bundle", 2 paths from parent to children
    - -`entity_id == parent_id`-> `catalog_product_super_link`
      - -`product_id == entity_id`-> `catalog_product_entity`
    - -`entity_id == parent_id` -> `catalog_product_relation`
      - -`child_id == entity_id`-> `catalog_product_entity`
  - -`entity_id == product_id`-> `catalog_category_product`
    - `category_id == entity_id` -> `catalog_category_entity`
  - -`entity_id == product_id`-> `catalog_product_super_attribute`
    - -`attribute_id`-> `eav_attribute`
    - -`attribute_id`-> `eav_entity_attribute`

attribute 
- `entity_type > attribute_set > attribute_group > attribute > attribute_option > attribute_option_value`, depth-6 taxonomy
  - `eav_attribute_option_value`
    - -`option_id`-> `eav_attribute_option`
  - `eav_attribute_option`
    - -`attribute_id`-> `eav_attribute`
  - `eav_attribute`
    - -`entity_type_id`-> `eav_entity_type` (shortcut)
    - NOTE no direct path to `attribute_group` from here, use `eav_entity_attribute`
  - `eav_entity_attribute` (first 4 layers of the phylogenetic tree)
    - -`attribute_id`-> `eav_attribute`
    - -`attribute_group_id`-> `eav_attribute_group`
    - -`attribute_set_id`-> `eav_attribute_set`
    - -`entity_type_id`-> `eav_entity_type`
  - `eav_attribute_group`
    - -`attribute_set_id`-> `eav_attribute_set`
  - `eav_attribute_set`
    - -`entity_type_id`-> `eav_entity_type`
- `eav_attribute_label`
 - -`attribute_id`-> `eav_attribute`
- `eav_attribute_option_value`
  - -`option_id`-> `eav_attribute_option`
    - -`attribute_id` -> `eav_attribute`

```purescript
type EntityType =
  { entity_type_id :: Int
  , attribute_set :: Array
    { attribute_set_id :: Int
    , attribute_group :: Array
      { attribute_group_id :: Int
      , attribute :: Array
        { attribute_id :: Int
        , attribute_label :: String
        , attribute_option :: Array
          { option_id :: Int
          , attribute_option_value :: Array
            { value_id :: Int
            , store_id :: Int
            , value :: String
            }
          }
        }
      }
    }
  }
```

store
- `store`
- `eav_attribute_option_value`
  - -`store_id`-> `store` (for different stores, value of an option may vary)

