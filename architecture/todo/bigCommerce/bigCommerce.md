# Data Model

## Product

```purescript
newtype Product = Product
  { visibility :: Boolean -- Visible on Storefront
  -- Basic Information
  , name :: String -- Product Name
  , "SKU" :: String
  , "type" :: ProductType
  , price :: Number -- $
  , brand :: Brand? -- edible?
  , weight :: Number -- Ounces
  , categories :: Category
  -- Description
  , description :: String
  -- Images and Videos
  , images :: Array String
  , videos :: ?
  -- Product Identifiers
  , "MPN" :: String -- Manufacturer Part Number
  , "UPC" :: String -- Product UPC/EAN
  , "GTN" :: String -- Global Trade Number
  , "BPN" :: String -- Bin Picking Number
  -- Pricing
  , tax_class :: TaxClass
  , cost :: Number
  , "MSRP" :: Number
  , sale_price :: Number
  -- Bulk Pricing
  , bulk_pricing :: Array Tier
  -- Inventory
  , track_inventory :: TrackInventory
  -- Variations (Configurable Product, Attribute Option)
  , variants :: VariantOption option => Map (Array option) Product
  -- Customizations
  , modifier_options :: Array ModifierOption
  , rules :: Array Rule
  -- Storefront Details
  , as_feature_product :: Boolean
  , search_keywords :: Array String
  , sort_order :: Maybe Int
  , template_layout_file :: LayoutFileOption
  , warranty_information :: String
  , availability_text :: String
  , condition :: ProductCondition
  , show_condition_on_storefront :: Boolean
  -- Custom Fields
  , custom_fields :: Array { name :: String, value :: String }
  -- Related Products
  , show_related_product :: Boolean
  -- Dimensions & Weight
  , weight :: Number
  , width :: Maybe Number
  , height :: Maybe Number
  , depth :: Maybe Number
  -- Shipping Details
  , fixed_shipping_price :: Maybe Number
  , free_shipping :: Boolean
  -- Purchasability
  , purchasability :: Purchasability
  , min_purchase_quantity :: Maybe Int
  , max_purchase_quantity :: Maybe Int
  -- Gift Wrapping
  , gift_wrapping_options :: GiftWrappingOption
  -- SEO & Sharing
  , page_title :: Maybe String
  , product_url :: String
  , meta_description :: Maybe String
  -- Open Graph Sharing
  }

data ProductType
  = Physical
  | Digital

data Category
  = Root Category
  | Branch String (Array Category)
  | Node String

data TaxClass
  = DefaultTaxClass
  | NonTaxableProducts
  | Shipping
  | GiftWrapping

type Tier =
  { min_quantity :: Int
  , discount :: Number
  , unit_price :: Number
  }

data TrackInventory
  = NonTracking
  | TrackingOnProductLevel { stock :: Int, low_stock :: Int }
  | TrackingOnVariantLevel

type ModifierOption =
  { name :: String
  , isRequired :: Boolean
  , "type" :: ModifierOptionType
  }

data ModifierOptionType
  = Swatch
    ( Array
      { label :: String
      , option :: NonEmpty Array SwatchOption
      }
    )
  | RadioButtons (Array { label :: String })
  | RectangleList (Array { label :: String })
  | Dropdown (Array { label :: String })
  | PickList
    { products :: Array { label :: String, product :: Product }
    , show_product_image_on_storefront :: Boolean
    , adjust_inventory_for_these_products_when_purchased :: Boolean
    , adjust_the_price_based_on_the_chosen_option :: Boolean
    , factor_chosen_product_into_shipping_calculations :: ShippingCostOption
    }
  -- Other
  | TextField
    { default_value :: Maybe String
    , char_num_limit :: Maybe { min :: Int, max :: Int }
    }
  | NumbersOnlyTextField
    { default_value :: Maybe Number
    , limit_numbers_by :: LimitOption Number
    }
  | DateField
    { default_value :: Maybe DateTime
    , limit_date_by :: LimitOption DateTime
    }
  | MultilineTextField
    { default_value :: String
    , char_num_limit :: Maybe { min :: Int, max :: Int }
    , line_num_limit :: Maybe { max :: Int }
    }
  | Checkbox
    { field_value :: String
    , checked_by_default :: Boolean
    }
  | FileUpload
    { max_file_size :: Int -- Kb
    , file_types :: FileTypesOption
    }

data SwatchOption
  = OneColor { color1 :: Color }
  | TwoColor { color1 :: Color, color2 :: Color }
  | ThreeColor {color1 :: Color, color2 :: Color, color3 :: Color }
  | Pattern { file :: File }

data ShippingCostOption
  = None
  | Package
  | Weight

data LimitOption a
  = NoLimit
  | Bottom { min :: a }
  | Top { max :: a }
  | Range { min :: a, max :: a }

data FileTypesOption
  = AllowAllFileTypes
  | AllowCertainFileTypes
    { images_and_photos :: Boolean
    , documents_and_text_files :: Boolean
    , other_file_types :: Maybe String -- Array String, sepBy ","
    }

newtype Rule = Rule
  { targetOption :: ModifierOptionValueId
  , adjust_price
    :: Maybe { action :: AdjustAction
            , value :: Number
            , unit :: AdjustPriceUnit
            }
  , adjust_weight
    :: Maybe { action :: AdjustAction
            , value :: Number
            }
  }

data AdjustAction
  = Add
  | Remove

data AdjustPriceUnit
  = Price
  | Percentage

data ProductCondition
  = New
  | Used
  | Refurbished

data Purchasability
  = Available -- This product can be purchased in my online store
  | TakePreOrders -- This product is coming soon but I want to take pre-orders
  | Unavailable -- This product cannot be purchased in my online store

data GiftWrappingOption
  = AllAvailableOptions -- Use all visible gift wrapping options I've created
  | NoWrapping -- Don't allow this item to be gift wrapped
  | SpecifyOptions -- Specify gift wrapping options for this product

Root
[ Branch "Shop All"
  [ Branch "level 1"
    [ ...
    ]
  , Branch "level 1a" []
  ]
, ...
]

-- image url
https://cdn11.bigcommerce.com/s-3nf5lovwc9/products/111/images/371/smithjournal1.1435956911.220.290.jpg?c=2
https://cdn11.bigcommerce.com/s-3nf5lovwc9/products/111/images/376/PI1zzXk__92022.1556029531.220.290.png?c=2

data VariantOption_Size
  = Size_Small
  | Size_Medium
  | Size_Large

data VariantOption_Color
  = Color_Red
  | Color_Green
  | Color_Blue

```

## Customer

```purescript

newtype Customer = Customer
  { first_name :: String
  , last_name :: String
  , company_name :: String
  , email_address :: String
  , customer_group :: CustomerGroup?
  , phone_number :: String
  , store_credit :: Number
  , receive_asc_or_review_emails :: Boolean
  , force_password_rest_on_next_login :: Boolean
  , tax_exempt_category :: String
  , password :: String
  }

newtype Address = Address
  { first_name :: String
  , last_name :: String
  , company_name :: String
  , phone_number :: String
  , address_line_1 :: String
  , address_line_2 :: String
  , city :: String
  , country :: String
  , state :: String
  , zip :: String
  , address_type :: AddressType
  }

data AddressType
  = Residential
  | Commercial

```

# Theme Templates

## Product

- `/templates/components/products/grid.html`
  - productGrid 
    - product
      - `/templates/components/products/card.html`
        - card 
          - card-figure
            - a (link on image)
            - card-figcaption
              - card-figcaption-body (mouse hover menu)
          - card-body (product brief)

## Category

- `/templates/components/category/sidebar.html`
  - sidebarBlock
    - sidbarBlock-heading
    - navList
      - `#each category.subcategories`

- `/templates/components/category/sortbox.html`
  - actionBar-section
    - form-label
    - select, sort

## Navigation Bar

- `/templates/components/common/navigation.html`
  - navUser
    - navUser-section
      - navUser-item--account
      - navUser-item--cart
        - cart-preview-dropdown
    - quickSearch

## Breadcrumbs

- `/templates/components/common/breadcrumbs.html`
