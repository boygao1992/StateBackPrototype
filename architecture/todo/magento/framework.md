# Magento\Framework\Validation

- Magento\Framework\Validation\ValidationResult
- Magento\Framework\Validation\ValidationException
  - implements
    - Magento\Framework\Exception\AggregateExceptionInterface
  - extends 
    - Magento\Framework\Exception\LocalizedException
  - dependencies
    - \Exception
    - Magento\Framework\Phrase
    - Magento\Framework\Validation\ValidationResult

## Magento\Framework\Validation\ValidationResult

```php
class ValidationResult {
    private $errors = []

    public function __construct(array $errors)
    public function isValid(): bool
    public function getErrors(): array
}
```

[`Data.Validation.Semigroup`](https://pursuit.purescript.org/packages/purescript-validation/4.2.0/docs/Data.Validation.Semigroup)
> collecting multiple errors using a `Semigroup`

Here we use array which is a Semigroup instance.

## Magento\Framework\Validation\ValidationException

```php
use Magento\Framework\Exception\AggregateExceptionInterface;
use Magento\Framework\Exception\LocalizedException;
use Magento\Framework\Phrase;

class ValidationException 
  extends LocalizedException 
  implements AggregateExceptionInterface

    private $validationResult;

    public function __construct(
        Phrase $phrase,
        \Exception $cause = null,
        $code = 0,
        ValidationResult $validationResult = null
    )

    public function getErrors(): array
```

# Magento\Framework\Exception

- LocalizedException
  - extends 
    - \Exception (php built-in exception class, empty namespace ('\'))
  - dependencies
    - Magento\Framework\Phrase
  - implicit dependencies
    - Magento\Framework\Phrase\Renderer\Placeholder

## Magento\Framework\Exception\LocalizedException

```php
class LocalizedException 
  extends \Exception

    protected $phrase;  # :: Magento\Framework\Phrase
    protected $logMessage; # :: String

    public function __construct(
      Phrase $phrase,
      \Exception $cause = null,
      $code = 0
    )

    public function getRawMessage() # Phrase->getText :: Unit -> 
    public function getParameters() # Phrase->getParameters :: Unit -> 

    public function getLogMessage()
```

# Magento\Framework\Phrase

Text formatters

- Magento\Framework\Phrase\RendererInterface

1. Magento\Framework\Phrase\Placeholder
  - implements
    - Magento\Framework\Phrase\RendererInterface
2. Magento\Framework\Phrase\Inline
  - implements
    - Magento\Framework\Phrase\RendererInterface
  - dependencies
    - Magento\Framework\TranslateInterface
    - Magento\Framework\Translate\Inline\ProviderInterface
    - Psr\Log\LoggerInterface
  - implicit dependencies
    - \Exception
3. Magento\Framework\Phrase\Translate
  - implements
    - Magento\Framework\Phrase\RendererInterface
  - dependencies
    - Magento\Framework\TranslateInterface
    - Psr\Log\LoggerInterface
  - implicit dependencies
    - \Exception
4. Magento\Framework\Phrase\Composite
  - implements
    - Magento\Framework\Phrase\RendererInterface
  - dependencies
    - Magento\Framework\Phrase\RendererInterface
  - implicit dependencies
    - \InvalidArgumentException

## Magento\Framework\Phrase\RendererInterface

```php
interface RendererInterface
    public function render(array $source, array $arguments);
```

## 1. Magento\Framework\Phrase\Placeholder

```php
use Magento\Framework\Phrase\RendererInterface;

class Placeholder 
  implements RendererInterface

    public function render(array $source, array $arguments)
    private function keyToPlaceholder($key) # :: (String | Int) -> String
```

### example
```php
$placeholder->render(
  'text %1 %two %2 %3 %five %4 %5',
  ['one', 'two' => 'two', 'three', 'four', 'five' => 'five', 'six', 'seven']
)
== 'text one two three four five six seven'
```

## 2. Magento\Framework\Phrase\Inline
```php
use Magento\Framework\Phrase\RendererInterface;
use Magento\Framework\TranslateInterface;
use Magento\Framework\Translate\Inline\ProviderInterface;
use Psr\Log\LoggerInterface;

class Inline 
  implements RendererInterface

    protected $translator; :: TranslateInterface
    protected $inlineProvider; :: ProviderInterface
    protected $logger; :: LoggerInterface

    public function __construct(
        TranslateInterface $translator,
        ProviderInterface $inlineProvider,
        LoggerInterface $logger
    )

    public function render(array $source, array $arguments)
```

## 3. Magento\Framework\Phrase\Translate

```php
use Magento\Framework\Phrase\RendererInterface;
use Magento\Framework\TranslateInterface;
use Psr\Log\LoggerInterface;

class Translate 
  implements RendererInterface

    protected $translator; :: TranslateInterface
    protected $logger; :: LoggerInterface

    public function __construct(
        TranslateInterface $translator,
        LoggerInterface $logger
    )

    public function render(array $source, array $arguments)

```

## 4. Magento\Framework\Phrase\Composite

```php
use Magento\Framework\Phrase\RendererInterface;

class Composite 
  implements RendererInterface
  
    protected $_renderers; # :: Array RenderInterface

    public function __construct(array $renderers)

    public function render(array $source, array $arguments = [])
```
# Magento\Framework\Parse

- Zip
  - zip code parser
  - no dependencies (utility function package)

```php
class Zip

    public static function parseRegions($state, $zip) :: String -> String -> Array String
    public static function parseZip($zip) :: String -> Array String
    public static function zipRangeToZipPattern($zipRange)
```

