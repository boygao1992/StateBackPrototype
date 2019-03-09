`magento/module-catalog/Api/Data/ProductInterface.php`
- `magento/module-catalog/etc/di.xml`
```xml
<preference for="Magento\Catalog\Api\Data\ProductInterface" type="Magento\Catalog\Model\Product" />
```
  - `magento/module-catalog/Model/Product.php`
    - `extends \Magento\Catalog\Model\AbstractModel` (`magento/module-catalog/Model/AbstractModel.php`)
      - `extends \Magento\Framework\Model\AbstractExtensibleModel` (`magento/framework/Model/AbstractExtensibleModel.php`)
        - `extends AbstractModel` (`magento/framework/Model/AbstractModel.php`)
          - `extends \Magento\Framework\DataObject` (`magento/framework/DataObject.php`)

Resource Model
- `magento/module-catalog/Model/ResourceModel/Product/Relation.php`
- `magento/module-catalog/Model/ResourceModel/Product/Indexer/Eav/Source.php`
- `magento/module-configurable-product/Model/ResourceModel/Attribute/OptionSelectBuilder.php`

Tables
- `dev/tests/static/testsuite/Magento/Test/Integrity/_files/dependency_test/tables_ce.php`

