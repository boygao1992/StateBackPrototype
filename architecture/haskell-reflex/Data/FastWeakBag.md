# GHC

{- NOTE System.Mem.Weak

data Weak v = Weak (Weak# v)

-- | Establishes a weak pointer to @k@, with value @v@ and a finalizer.
mkWeak  :: k                            -- ^ key
        -> v                            -- ^ value
        -> Maybe (IO ())                -- ^ finalizer
        -> IO (Weak v)                  -- ^ returns: a weak pointer object

A weak pointer expresses a relationship between two objects, the key and the value:
- if the key is considered to be alive by the garbage collector, then the value is also alive.
- NOTE a reference from the value to the key does not keep the key alive.

[The cost of weak pointers and finalizers in GHC](http://blog.ezyang.com/2014/05/the-cost-of-weak-pointers-and-finalizers-in-ghc/)

[Stretching the storage manager: weak pointers and stable names in Haskell](http://simonmar.github.io/bib/papers/weak.pdf)

-}

data FastWeakBag a = FastWeakBag
  { nextId :: !(IORef Int) --TODO: what if this wraps around?
  , children :: !(IORef (IntMap (Weak a))) -- Int -> Weak a
  }
data FastWeakBagTicket a = FastWeakBagTicket
  { weakItem :: !(Weak a)
  , item :: !a
  }

empty :: IO (FastWeakBag a)
empty = do
  nextId <- newIORef 1
  children <- newIORef IntMap.empty
  return $ FastWeakBag { nextId , children }

isEmpty :: FastWeakBag a -> IO Bool
isEmpty (FastWeakBag { children }) = IntMap.null <$> readIORef children

insert
  :: forall a
  . a -- ^ The item
  -> FastWeakBag a -- ^ The 'FastWeakBag' to insert into
  -> IO (FastWeakBagTicket a) -- ^ Returns a 'FastWeakBagTicket' that ensures the item is retained and allows the item to be removed.
insert a (FastWeakBag nextId children) = do
  -- NOTE import Control.Exception (evaluate)
  -- Evaluate the argument to weak head normal form (WHNF).
  -- NOTE WHNF: the top level (constructor, partially applied function, lambda expression) of an expression is evaluated with the rest (its arguments) untouched
  -- "Parallel and Concurrent Programming in Haskell" p.12
  a' :: a
    <- (evaluate :: a -> IO a) a
  myId :: Int
    -- NOTE import Data.IORef (atomicModifyIORef' :: IORef a -> (a -> (a, b)) -> IO b)
    -- Strict version of atomicModifyIORef. This forces both the value stored in the IORef as well as the value returned.
    <- atomicModifyIORef' nextId $ \n -> (succ n, n)
      where
        -- NOTE import GHC.Prim (seq :: a -> b -> b)
        -- The value of `seq a b` is bottom if `a` is bottom, and otherwise equal to `b`. In other words, it evaluates the first argument a to weak head normal form (WHNF). `seq` is usually introduced to improve performance by avoiding unneeded laziness.
        -- A note on evaluation order: the expression seq a b does not guarantee that a will be evaluated before b. The only guarantee given by seq is that the both a and b will be evaluated before seq returns a value. In particular, this means that b may be evaluated before a. If you need to guarantee a specific order of evaluation, you must use the function pseq from the "parallel" package.
        atomicModifyIORef' :: IORef a -> (a -> (a,b)) -> IO b
        atomicModifyIORef' ref f = do
            b <- atomicModifyIORef ref $ \a ->
                    case f a of
                        v@(a',_) -> a' `seq` v
            b `seq` return b
  let
    -- NOTE clearup is in WHNF
    -- ~ IntMap.delete myId cs `seq` (IntMap.delete myId cs, ()) `seq` return ()
    -- NOTE the evaluation of () will trigger evaluation of (IntMap.delete myId cs)
    cleanup :: IO ()
      -- NOTE import Data.IntMap.Strict (delete)
      -- Each function in this module is careful to force values before installing them in an IntMap.
      -- NOTE myId is forced
      = atomicModifyIORef' children \cs -> (IntMap.delete myId cs, ())
  wa :: Weak a
    -- NOTE import System.Mem.Weak (mkWeakPtr :: k -> Maybe (IO ()) -> IO (Weak k))
    -- A specialised version of mkWeak, where the key and the value are the same object:
    -- TODO I guess the only purpose of Weak here is to hold a "finalizer", which will be used in `remove :: FastWeakBagTicket a -> IO ()`
    <- mkWeakPtr a' $ Just cleanup
  atomicModifyIORef' children $ \cs -> (IntMap.insert myId wa cs, ())
  return $ FastWeakBagTicket
    { weakItem = wa
    , item = a'
    }


traverse :: forall a m. MonadIO m => FastWeakBag a -> (a -> m ()) -> m ()
traverse (FastWeakBag { children }) f = do
  cs :: IntMap (Weak a)
    <- liftIO $ readIORef children
  for_ cs \(c :: Weak a) -> do
    -- NOTE import System.Mem.Weak (deRefWeak)
    -- Dereferences a weak pointer. If the key is still alive, then Just v is returned (where v is the value in the weak pointer), otherwise Nothing is returned.
    -- The return value of deRefWeak depends on when the garbage collector runs, hence it is in the IO monad.
    ma :: Maybe a
      <- liftIO $ (deRefWeak :: Weak a -> IO (Maybe a)) c
    traverse_ f ma

remove :: FastWeakBagTicket a -> IO ()
remove (FastWeakBagTicket { weakItem })
  -- NOTE import System.Mem.Weak (finalize)
  -- Causes a the finalizer associated with a weak pointer to be run immediately.
  = (finalize :: Weak a -> IO ()) weakItem

# GHCJS

newtype FastWeakBag a = FastWeakBag JSVal
newtype FastWeakBagTicket a = FastWeakBagTicket JSVal

empty :: IO (FastWeakBag a)
empty = js_empty
foreign import javascript unsafe "$r = new h$FastWeakBag();" js_empty :: IO (FastWeakBag a)


