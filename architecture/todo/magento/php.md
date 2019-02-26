- [PHP DI](http://php-di.org/)
- [phpmd - PHP Mess Detector](https://phpmd.org/rules/index.html)
- [php-annotations](https://php-annotations.readthedocs.io/en/latest/index.html)
- [php reflection](http://php.net/manual/en/book.reflection.php)

# IO

```purescript
is_readable :: String -> Effect Boolean

file_get_contents :: 
  { filename :: String
  , use_include_path :: Maybe Boolean
  , context :: Maybe Resource
  , offset :: Maybe Int
  , maxlen :: Maybe Int
  } -> Effect String
```
