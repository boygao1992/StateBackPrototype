# Type classes

`Ordering` data type
``` purescript
data Ordering = LT | GT | EQ
```

`Ord` type class
``` purescript
class Eq a <= Ord a where
compare :: a -> a -> Ordering
```
laws
- Reflexivity: `a <= a`
- Antisymmetry: `if a <= b and b <= a then a = b`
- Transitivity: `if a <= b and b <= c then a <= c`

`Enum` type class
``` purescript
class Ord a <= Enum a where
  succ :: a -> Maybe a
pred :: a -> Maybe a
```

`Bounded` type class

``` purescript
class Ord a <= Bounded a where
  top :: a
bottom :: a
```

`BoundedEnum` type class
``` purescript
class (Bounded a, Enum a) <= BoundedEnum a where
  cardinality :: Cardinality a
  toEnum :: Int -> Maybe a
fromEnum :: a -> Int
```


# Dependencies

## purescript-datetime

### Time
``` purescript
{- /src/Data/Time.purs -}
data Time = Time Hour Minute Second Millisecond
-- Eq, Ord, Bounded, Enum, BoundedEnum, Show
instance boundedTime :: Bounded Time where
  bottom = Time bottom bottom bottom bottom
  top = Time top top top top

{- /src/Data/Time/Component.purs -}
newtype Hour = Hour Int
-- Eq, Ord, Bounded(0 .. 23), Enum, BoundedEnum, Show
derive newtype instance eqHour :: Eq Hour
derive newtype instance ordHour :: Ord Hour

instance boundedHour :: Bounded Hour where
  bottom = Hour 0
  top = Hour 23

instance enumHour :: Enum Hour where
  -- fromEnum :: forall a. BoundedEnum a => a -> Int
  -- toEnum :: forall a. BoundedEnum a => Int -> Maybe a
  succ = toEnum <<< (_ + 1) <<< fromEnum
  pred = toEnum <<< (_ - 1) <<< fromEnum

instance boundedEnumHour :: BoundedEnum Hour where
  cardinality = Cardinality 24
  toEnum n
    | n >= 0 && n <= 23 = Just (Hour n)
    | otherwise = Nothing
  fromEnum (Hour n) = n
  
newtype Minute = Minute Int
-- Eq, Ord, Bounded(0 .. 59), Enum, BoundedEnum, Show
newtype Second = Second Int
-- Eq, Ord, Bounded(0 .. 59), Enum, BoundedEnum, Show
newtype Millisecond = Millisecond Int
-- Eq, Ord, Bounded(0 .. 999), Enum, BoundedEnum, Show
```

### Date
```purescript
{- /src/Data/Date.purs -}
data Date = Date Year Month Day
-- Eq, Ord, Bounded, Enum, BoundedEnum, Show
instance boundedDate :: Bounded Date where
  bottom = Date bottom bottom bottom
  top = Date top top top

{- /src/Data/Date/Component.purs -}
newtype Year = Year Int
-- Eq, Ord, Bounded(-271820 .. 275759), Enum, BoundedEnum, Show
  
data Month
  = January
  | February
  | March
  | April
  | May
  | June
  | July
  | August
  | September
  | October
  | November
  | December
-- Eq, Ord, Bounded(January .. December), Enum, BoundedEnum, Show
instance boundedMonth :: Bounded Month where
  bottom = January
  top = December
  
instance enumMonth :: Enum Month where
  succ = toEnum <<< (_ + 1) <<< fromEnum
  pred = toEnum <<< (_ - 1) <<< fromEnum

instance boundedEnumMonth :: BoundedEnum Month where
  cardinality = Cardinality 12
  toEnum = case _ of
    1 -> Just January
    -- ...
    12 -> Just December
    _ -> Nothing
  fromEnum = case _ of
    January -> 1
    -- ...
    December -> 12
 
newtype Day = Day Int
-- Eq, Ord, Bounded(1 .. 31), Enum, BoundedEnum, Show

data Weekday
  = Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday
  | Sunday
-- Eq, Ord, Bounded(Monday .. Sunday), Enum, BoundedEnum, Show
```

### DateTime
```purescript
{- /src/Data/DateTime.purs -}
data DateTime = DateTime Date Time
-- Eq, Ord, Bounded, Enum, BoundedEnum, Show
instance boundedDateTime :: Bounded DateTime where
  bottom = DateTime bottom bottom
  top = DateTime top top
  
{- /src/Data/DateTime/Instant.purs -}  
-- An instant is a duration in milliseconds relative to the Unix epoch (1970-01-01 00:00:00 UTC).
newtype Instant = Instant Milliseconds
-- Eq, Ord, Bounded(-8639977881600000.0 .. 8639977881599999.0), Enum, BoundedEnum, Show
```

### Interval

``` purescript
{- /src/Data/Interval.purs -}
data RecurringInterval d a = RecurringInterval (Maybe Int) (Interval d a)

data Interval d a
  = StartEnd      a a
  | DurationEnd   d a
  | StartDuration a d
  | DurationOnly  d

{- /src/Data/Interval/Duration.purs -}
newtype Milliseconds = Milliseconds Number
newtype Seconds = Seconds Number
newtype Minutes = Minutes Number
newtype Hours = Hours Number
newtype Days = Days Number

class Duration a where
  fromDuration :: a -> Milliseconds
  toDuration :: Milliseconds -> a

```

## purescript-js-timers

``` purescript
newtype TimeoutId = TimeoutId Int

foreign import setTimeout :: 
  Int -> -- Time in millisecond
  Effect Unit -> -- callback
  Effect TimeoutId -- canceller id

foreign import setInterval :: Int -> Effect Unit -> Effect IntervalId

foreign import clearInterval :: IntervalId -> Effect Unit
```

# purescript-event

## Event

``` purescript
newtype Event a = Event ((a -> Effect Unit) -> Effect (Effect Unit))
```
`Event` is modeled as a function which takes a callback (`a -> Effect Unit`) and returns a `Effect` warping a canceller (`Effect Unit`)

### Functor
```purescript
instance functorEvent :: Functor Event where
  -- map :: forall a b f. Functor f => (a -> b) -> f a -> f b
  -- e :: (a -> Effect Unit) -> Effect (Effect Unit)
  -- f :: a -> b
  -- k :: b -> Effect Unit
  -- (k <<< f) :: a -> Effect Unit
  -- RHS :: (b -> Effect Unit) -> Effect (Effect Unit) = Event b
  map f (Event e) = Event \k -> e (k <<< f)
```

### Applicative
``` purescript
instance applicativeEvent :: Applicative Event where
               -- k :: a -> Effect Unit
  pure a = Event \k -> do
    k a -- Effect Unit
    pure (pure unit) -- Effect (Effect Unit)
```

