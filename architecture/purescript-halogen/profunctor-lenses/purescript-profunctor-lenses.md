[purescript-profunctor-lenses](https://pursuit.purescript.org/packages/purescript-profunctor-lenses)

- Data.Lens.Types 
  - Data.Lens.Internal.Forget 
  - Data.Lens.Internal.Shop 
  - Data.Lens.Internal.Wander 
  - Data.Lens.Internal.Exchange 
  - Data.Lens.Internal.Focusing 
  - Data.Lens.Internal.Grating 
  - Data.Lens.Internal.Indexed 
  - Data.Lens.Internal.Market 
  - Data.Lens.Internal.Re 
  - Data.Lens.Internal.Tagged 
  - Data.Lens.Internal.Zipping 


- Data.Lens.Fold 
  - Data.Lens.Fold.Partial 
- Data.Lens.Setter 
- Data.Lens.Getter 
- Data.Lens.Traversal 
- Data.Lens.Lens 
- Data.Lens.Prism 
- Data.Lens.Iso 
- Data.Lens.Index 
  - Data.Lens.At 
  - Data.Lens.Indexed 
- Data.Lens.Grate 
- Data.Lens.Zoom

- Data.Lens.Lens.Void 
- Data.Lens.Lens.Unit 
- Data.Lens.Lens.Tuple 
- Data.Lens.Lens.Product 
- Data.Lens.Prism.Maybe 
- Data.Lens.Prism.Either 
- Data.Lens.Prism.Coproduct 
- Data.Lens.Iso.Newtype 
- Data.Lens.Record 

## Data.Lens.Wander

```purescript
class (Strong p, Choice p) <= Wander p where
  wander
    :: forall s t a b
     . (forall f. Applicative f => (a -> f b) -> s -> f t)
    -> p a b
    -> p s t

alaF 
  :: forall f g t a s b
   . Functor f 
  => Functor g 
  => Newtype t a -- wrap :: a -> t
  => Newtype s b  -- unwrap :: s -> b
  => (a -> t) -> (f t -> g s) 
  -> f a -> g b
alaF _ f = map unwrap <<< f <<< map wrap

foldMap :: forall a m. Monoid m => (a -> m) -> f a -> m

instance wanderFunction :: Wander Function where
  wander t = alaF Identity t
```
