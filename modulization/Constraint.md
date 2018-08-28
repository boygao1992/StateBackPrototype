# Runtime Validation

have to manually call compile-time/runtime configured validators

## OOP

[Hibernate Validator](http://hibernate.org/validator/)

- compile-time configuration through annotations
  - [2.3. Built-in constraints](https://docs.jboss.org/hibernate/stable/validator/reference/en-US/html_single/#section-builtin-constraints)
  - [Declaring and validating method constraints](https://docs.jboss.org/hibernate/stable/validator/reference/en-US/html_single/#section-declaring-method-constraints)
  - [Creating custom constraints](https://docs.jboss.org/hibernate/stable/validator/reference/en-US/html_single/#validator-customconstraints)
- runtime configuration: [12.4. Programmatic constraint definition and declaration](https://docs.jboss.org/hibernate/stable/validator/reference/en-US/html_single/#section-programmatic-api)


[JSR 380 - Bean Validation 2.0](https://beanvalidation.org/2.0/spec/)

- `Object`
  - `@NotNull`
  - `@Null`

- `boolean`, `Boolean`

  - `@AssertFalse`
  - `@AssertTrue`

- `BigDecimal`, `BigInteger`, `byte`, `short`, `int`, `long`
  - `@DecimalMax(value = string, inclusive = boolean) // string representation of a decimal`
  - `@DecimalMin(value = string, inclusive = boolean)`
  - `@Digits(integer = int, fraction = int)`
  - `@Max(value = int)`
  - `@Min(value = int)`
  - `@Negative`
  - `@NegativeOrZero`
  - `@Positive`
  - `@PositiveOrZero`

- `double`, `float`
  - `@Negative`
  - `@NegativeOrZero`
  - `@Positive`
  - `@PositiveOrZero`

- `Date`, `Calender`, `Instant`, `LocalDate`, `LocalDateTime`, `LocalTime`, `MonthDay`, `OffsetDateTime`, `OffsetTime`, `Year`, `YearMonth`, `ZonedDateTime`

  - `@Future`
  - `@FutureOrPresent`
  - `@PastOrPresent`
  - `@Past`

- `CharSequence`
  - `@Size(min = int, max = int)`
  - `@Digits(integer = int, fraction = int) //The annotated element must be a number within accepted range`
  - `@Pattern(regexp = string) // string representation of a regular expression`
  - `@NotEmpty`
  - `@NotBlank`
  - `@CharSequence`

- `Collection`, `Map`, `Array`
  - `@Size(min = int, max = int)`
  - `@NotEmpty`

- user-defined constraints
  - `@constraint_name`





## FP

### compile-time configured validation

type classes

- `Eq`
  - `eq :: a -> a -> Boolean`
- `Ord`
  - `compare :: a -> a -> Ordering` where `data Ordering = LT | GT | EQ`
- `Enum`
  - `succ :: a -> Maybe a`
  - `prev :: a -> Maybe a`
- `Bounded`
  - `top :: a`
  - `bottom :: a`
- `BoundedEnum`
  - `cardinality :: Cardinality a`
  - `toEnum :: Int -> Maybe a`
  - `fromEnum :: a -> Int`

### runtime configurable validation

[pruescript-validation](https://pursuit.purescript.org/packages/purescript-validation)

> - Applicative validation: allow multiple errors to be collected using a `Semigroup`

each validator function are treated independently and functions in parallel
applicative functor then collects all the results from these computations

> - Monadic validation: terminates on the first error

monad preserves sequential ordering/dependency among computations where the evaluation of the next computation relies on the result from the current computation



[elm-validate](https://package.elm-lang.org/packages/iodevs/elm-validate/)

```elm
type Field raw a = Field raw a -- `a` could be Validity or other customized validation state model

type Validity a -- with `apply` defined, conceptually it's an Applicative Functor
  = NotValidated
  | Valid a
  | Invalid String

type alias Validator a b = -- `Result` is a Monad
    a -> Result String b
(|:) : Validity (a -> b) -> Validity a -> Validity b -- `apply`
(>&&) : Validator a b -> Validator b c -> Validator a c -- Left-to-right Kleisli composition of Monads
```



# Compile-time Validation

> "make illegal states unrepresentable"

[Smart Constructors](https://wiki.haskell.org/Smart_constructors)

[Peano numbers](https://wiki.haskell.org/Peano_numbers)

> **Peano numbers** are a simple way of representing the natural  numbers using only a zero value and a successor function. 
> In Haskell it  is easy to create a type of Peano number values, but since unary  representation is inefficient, they are more often used to do [type arithmetic](https://wiki.haskell.org/Type_arithmetic) due to their simplicity. 

[Type arithmetic](https://wiki.haskell.org/Type_arithmetic)

[Data.FixedList](http://hackage.haskell.org/package/fixed-list-0.1.6/docs/Data-FixedList.html)

> The length of a list is encoded into its type in a natural way.
>
> ```haskell
> data FixedList f =>
>   Cons f a = (:.) {
>     head :: a,
>     tail :: (f a)
>   }  deriving (Eq, Ord)
> 
> data Nil a = Nil
>   deriving (Eq, Ord)
> 
> type FixedList0 = Nil
> type FixedList1 = Cons FixedList0
> -- ...
> type FixedList32 = Cons FixedList31
> ```
>
> `FixedList0` ~ `FixedList32`

Union Type
