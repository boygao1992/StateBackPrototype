table: `eav_attribute`

# Schema

CREATE TABLE `eav_attribute` (
  `attribute_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Attribute Id',
  `entity_type_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Entity Type Id',
  `attribute_code` varchar(255) NOT NULL COMMENT 'Attribute Code',
  `attribute_model` varchar(255) DEFAULT NULL COMMENT 'Attribute Model',
  `backend_model` varchar(255) DEFAULT NULL COMMENT 'Backend Model',
  `backend_type` varchar(8) NOT NULL DEFAULT 'static' COMMENT 'Backend Type',
  `backend_table` varchar(255) DEFAULT NULL COMMENT 'Backend Table',
  `frontend_model` varchar(255) DEFAULT NULL COMMENT 'Frontend Model',
  `frontend_input` varchar(50) DEFAULT NULL COMMENT 'Frontend Input',
  `frontend_label` varchar(255) DEFAULT NULL COMMENT 'Frontend Label',
  `frontend_class` varchar(255) DEFAULT NULL COMMENT 'Frontend Class',
  `source_model` varchar(255) DEFAULT NULL COMMENT 'Source Model',
  `is_required` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Defines Is Required',
  `is_user_defined` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Defines Is User Defined',
  `default_value` text COMMENT 'Default Value',
  `is_unique` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Defines Is Unique',
  `note` varchar(255) DEFAULT NULL COMMENT 'Note',
  PRIMARY KEY (`attribute_id`),
  UNIQUE KEY `EAV_ATTRIBUTE_ENTITY_TYPE_ID_ATTRIBUTE_CODE` (`entity_type_id`,`attribute_code`),
  CONSTRAINT `EAV_ATTRIBUTE_ENTITY_TYPE_ID_EAV_ENTITY_TYPE_ENTITY_TYPE_ID` FOREIGN KEY (`entity_type_id`) REFERENCES `eav_entity_type` (`entity_type_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=158 DEFAULT CHARSET=utf8 COMMENT='Eav Attribute'

# Columns

- `entity_type_id`
  - source key
    - `entity_type_id` from `eav_entity_type`
- `frontend_input`
  - values
    - parent-child
      - `select`
      - `multiselect`
    - view
      - `hidden`
    - atom
      - `text`
      - `textarea`
      - `multiline`
      - `gallery`
      - `image`
      - `boolean`
      - `date`
      - `price`
      - `weight`
- `backend_type`
  - values
    - built-in (not instantiated as a dedicated table, but directly lives in entity tables)
      - `static`
    - customized (corresponds to MySQL built-in value types)
      - `text`
      - `varchar`
      - `int`
      - `decimal`
      - `datetime`
- `attribute_code`
  - attribute name

# Value Tables (Entity-Attribute-"Value")

- table naming convention
  - `{entity_type_code}_entity_{backend_type}`
- columns
  - `entity_id` (community version) / `row_id` (enterprise version)
    - source key
      - `entity_id` from `catalog_product_entity`
      - a unique identifier for products
  - `attribute_id`
    - source key
      - `attribute_id` from `eav_attribute`
  - `value`
    - "V" in "EAV" model
  - `store_id`
    - optional, default to `0`
    - able to further differentiate attribute values for different stores
