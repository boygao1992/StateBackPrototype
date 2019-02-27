table: `catalog_product_entity`

# Schema

```sql
CREATE TABLE `catalog_product_entity` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Entity Id',
  `attribute_set_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Attribute Set ID',
  `type_id` varchar(32) NOT NULL DEFAULT 'simple' COMMENT 'Type ID',
  `sku` varchar(64) DEFAULT NULL COMMENT 'SKU',
  `has_options` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Has Options',
  `required_options` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Required Options',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation Time',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update Time',
  PRIMARY KEY (`entity_id`),
  KEY `CATALOG_PRODUCT_ENTITY_ATTRIBUTE_SET_ID` (`attribute_set_id`),
  KEY `CATALOG_PRODUCT_ENTITY_SKU` (`sku`)
) ENGINE=InnoDB AUTO_INCREMENT=2047 DEFAULT CHARSET=utf8 COMMENT='Catalog Product Table'
```

# Columns

- `type_id`
  - values
    - atom
      - `simple`
      - `downloadable`
    - set
      - `configurable`
        - a Union/Enum of `simple` products differentiated by a set of attributes
        - a combination of attribute values uniquely identifies a `simple` product
        - e.g. Chaz Kangeroo Hoodie 
      - `grouped`
        - a Product of `simple` products that can be purchased simultaneously, each with a differently specified quantity
      - `bundle`
        - a Product of `simple` and `configurable` that can be purchased simultaneously, each with a differently specified quantity
- `entity_id`
  - a unique identifier for each product (for database developers)
- `sku` ("stockkeeping unit")
  - a unique identifier for each product (for domain operators)
- `attribute_set_id`

