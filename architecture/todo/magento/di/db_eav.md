`magento/module-eav/Setup/EavSetup.php`
- `use Magento\Framework\Setup\ModuleDataSetupInterface` (`magento/framework/Setup/ModuleDataSetupInterface.php`)
  - `magento/magento2-base/app/etc/di.xml`
  ```xml
  <preference for="Magento\Framework\Setup\ModuleDataSetupInterface" type="Magento\Setup\Module\DataSetup" />
  ```
    - `magento/magento2-base/setup/src/Magento/Setup/Module/DataSetup.php`
      - `extends \Magento\Framework\Module\Setup` (`magento/framework/Module/Setup.php`)
        - `use Magento\Framework\App\ResourceConnection` (`magento/framework/App/ResourceConnection.php`)
          - `use Magento\Framework\Model\ResourceModel\Type\Db\ConnectionFactoryInterface`
            - `magento/magento2-base/app/etc/di.xml`
            ```xml
            <type name="Magento\Framework\App\ResourceConnection">
                <arguments>
                    <argument name="connectionFactory" xsi:type="object">Magento\Framework\App\ResourceConnection\ConnectionFactory</argument>
                </arguments>
            </type>
            ```
              - `magento/framework/Model/ResourceModel/Type/Db/ConnectionFactory.php`, connection adapter factory
                - instantiate `\Magento\Framework\App\ResourceConnection\ConnectionAdapterInterface` through `Magento\Framework\ObjectManager` (`magento/framework/ObjectManager/ObjectManager.php`)
                ```php
                $adapterInstance = $this->objectManager->create(
                    \Magento\Framework\App\ResourceConnection\ConnectionAdapterInterface::class,
                    ['config' => $connectionConfig]
                );
                ```
                  - `magento/magento2-base/app/etc/di.xml`
                  ```xml
                  <preference for="Magento\Framework\App\ResourceConnection\ConnectionAdapterInterface" type="Magento\Framework\Model\ResourceModel\Type\Db\Pdo\Mysql"/>
                  ```
                    - `magento/framework/Model/ResourceModel/Type/Db/Pdo/Mysql.php`
                      - `extends \Magento\Framework\Model\ResourceModel\Type\Db` (`magento/framework/Model/ResourceModel/Type/Db.php`)
                        - `extends \Magento\Framework\Model\ResourceModel\Type\AbstractType` (`magento/framework/Model/ResourceModel/Type/AbstractType.php`)
                      - `implements Magento\Framework\App\ResourceConnection\ConnectionAdapterInterface` (`magento/framework/App/ResourceConnection/ConnectionAdapterInterface.php`)
                        - `use Magento\Framework\DB\Adapter\AdapterInterface` (`magento/framework/DB/Adapter/AdapterInterface.php`)
                      - `protected function getDbConnectionClassName() { return DB\Adapter\Pdo\Mysql::class; }`
                        - `magento/framework/DB/Adapter/Pdo/Mysql.php`, implementation details of mysql client, majority being query builder related
                          - `implements Magento\Framework\DB\Adapter\AdapterInterface` (`magento/framework/DB/Adapter/AdapterInterface.php`)
                          - `extends \Zend_Db_Adapter_Pdo_Mysql`
                            - `magento/zendframework1/library/Zend/Db/Adapter/Pdo/Mysql.php`
                      - `use Magento\Framework\DB\Adapter\Pdo\MysqlFactory` (`magento/framework/DB/Adapter/Pdo/MysqlFactory.php`)
                        - `public function create($className, ... ) { ... }`

            - `use Magento\Framework\App\ResourceConnection\ConfigInterface`
              - `magento/magento2-base/app/etc/di.xml`
              ```xml
              <preference for="Magento\Framework\App\ResourceConnection\ConfigInterface" type="Magento\Framework\App\ResourceConnection\Config\Proxy" />
              ```
            - `use Magento\Framework\Config\ConfigOptionsListConstants`
              - `magento/framework/Config/ConfigOptionsListConstants.php`
                - `CONFIG_PATH_*`, Path to the values in the deployment config
            - `use Magento\Framework\App\DeploymentConfig`
              - `magento/framework/App/DeploymentConfig.php`
                - `DeploymentConfig\Reader` (`magento/framework/App/DeploymentConfig/Reader.php`)
                  - `use Magento\Framework\Config\File\ConfigFilePool` (`magento/framework/Config/File/ConfigFilePool.php`)
                    - `private $applicationConfigFiles`, default configuration file names
                  - `use Magento\Framework\App\Filesystem\DirectoryList` (`magento/framework/App/Filesystem/DirectoryList.php`)
                    - `const CONFIG = "etc";`
                    - `self::CONFIG => [parent::PATH => 'app/etc']`
                    - `extends \Magento\Framework\Filesystem\DirectoryList`
                      - The `\Magento\Framework\App\Filesystem` module extends `\Magento\Framework\Filesystem` by defining list of directories available in the application.
                      - `magento/framework/Filesystem/DirectoryList.php`
                        - `const PATH = 'path';`
- `use Magento\Eav\Model\Entity\Setup\PropertyMapperInterface`
  - `magento/module-eav/etc/di.xml`
  ```xml
  <preference for="Magento\Eav\Model\Entity\Setup\PropertyMapperInterface" type="Magento\Eav\Model\Entity\Setup\PropertyMapper\Composite" />
  <type name="Magento\Eav\Model\Entity\Setup\PropertyMapper\Composite">
      <arguments>
          <argument name="propertyMappers" xsi:type="array">
              <item name="default" xsi:type="string">Magento\Eav\Model\Entity\Setup\PropertyMapper</item>
          </argument>
      </arguments>
  </type>
  ```
    - `magento/module-eav/Model/Entity/Setup/PropertyMapper.php`

- `Magento\Framework\DB\Ddl\Table`
  - `addForeignKey`
  - `addColumn`
