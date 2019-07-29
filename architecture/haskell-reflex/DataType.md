# MemoTrie

class HasTrie t where
  data (:->:) t :: * -> *

  tire :: (t -> a) -> t :->: a
  untrie :: (t :->: a) -> t -> a
  enumerate :: (t :->: a) -> [(t, a)]

memo :: HasTrie t => (t -> a) -> t -> a
memo = untrie <<< trie

class Patch p where
  type PatchTarget p :: *
  apply :: p -> PatchTarget p -> Maybe (PatchTarget p)

# DSum

data DSum (tag :: k -> *) (f :: k -> *)
  = forall v. -- NOTE existential
    tag v :=> f v

(==>) :: forall tag f v. Applicative f => tag v -> v -> DSum tag f
k ==> v =
  k :=> pure v

# DMap

data DMap (tag :: k -> *) (f :: k -> *) where -- Binary Search Tree
  Tip :: DMap tag f
  Bin :: forall v
      . Int -- size
      -> tag v -- key
      -> f v -- value
      -> DMap tag f -- left
      -> DMap tag f -- right
      -> DMap tag f

{-
data Tag a where
  AString :: Tag String
  AnInt :: Tag Int

e.g.

AString ==> "hello" :: forall f. DSum Tag f
AnInt ==> 42 :: forall f. DSum Tag f

toString :: DSum Tag Identity -> String
toString (AString :=> Identity str) = str
toString (AnInt :=> Identity int) = show int

-}


-- type (:=) = (:~:)
-- NOTE witnessing equality of two types
data a := b where
  Refl :: a := a

class GEq f where
  geq :: forall a b. f a -> f b -> Maybe (a := b)

data GOrdering a b where
  GLT :: GOrdering a b
  GEQ :: forall t. GOrdering t t
  GGT :: GOrdering a b

class GEq f => GCompare (f :: k -> *) where
  gcompare :: forall a b. f a -> f b -> GOrdering a b

# Reflex

newtype EventSelector t k = EventSelector
  { -- | Retrieve the 'Event' for the given key.  The type of the 'Event' is
    -- determined by the type of the key, so this can be used to fan-out
    -- 'Event's whose sub-'Event's have different types.
    --
    -- Using 'EventSelector's and the 'fan' primitive is far more efficient than
    -- (but equivalent to) using 'mapMaybe' to select only the relevant
    -- occurrences of an 'Event'.
    select :: forall v. k v -> Event t v
  }

