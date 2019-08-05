# Spider

data EventSubscribed x = EventSubscribed
  { heightRef :: !(IORef Height)
  , retained :: !Any
  {- NOTE debug
  , getParents :: !(IO [Some (EventSubscribed x)]) -- For debugging loops
  , hasOwnHeightRef :: !Bool
  , whoCreated :: !(IO [String])
  -}
  }

--type role PullSubscribed representational
data PullSubscribed t a = PullSubscribed
  { value :: !a
  , invalidators :: !(IORef [Weak (Invalidator t)])
  , ownInvalidator :: !(Invalidator t)
  , parents :: ![SomeBehaviorSubscribed t] -- Need to keep parent behaviors alive, or they won't let us know when they're invalidated
  }
newtype Height = Height Int
data Subscriber t a = Subscriber
  { propagate :: !(a -> EventM t ())
  , invalidateHeight :: !(Height -> IO ())
  , recalculateHeight :: !(Height -> IO ())
  }
data EventSubscription t = EventSubscription
  { unsubscribe :: !(IO ())
  , subscribed :: !(EventSubscribed t)
  }

--type role Pull representational
data Pull t a = Pull
  { value :: !(IORef (Maybe (PullSubscribed t a)))
  , compute :: !(BehaviorM t a)
  , nodeId :: Int -- NOTE debug
  }
data SwitchSubscribed t a = SwitchSubscribed
  { cachedSubscribed :: !(IORef (Maybe (SwitchSubscribed t a)))
  , occurrence :: !(IORef (Maybe a))
  , height :: !(IORef Height)
  , subscribers :: !(WeakBag (Subscriber t a))
  , ownInvalidator ::  !(Invalidator t)
  , ownWeakInvalidator :: !(IORef (Weak (Invalidator t)))
  , behaviorParents :: !(IORef [SomeBehaviorSubscribed t])
  , parent :: !(Behavior t (Event t a))
  , currentParent :: !(IORef (EventSubscription t))
  , weakSelf :: !(IORef (Weak (SwitchSubscribed t a)))
  , nodeId :: Int -- NOTE debug
  }
data BehaviorSubscribed t a
   = forall p. BehaviorSubscribedHold (Hold t p)
   | BehaviorSubscribedPull (PullSubscribed t a)
data Hold t p = Hold
  { value :: !(IORef (PatchTarget p))
  , invalidators :: !(IORef [Weak (Invalidator t)])
  , event :: Event t p -- This must be lazy, or holds cannot be defined before their input Events
  , parent :: !(IORef (Maybe (EventSubscription t))) -- Keeps its parent alive (will be undefined until the hold is initialized) --TODO: Probably shouldn't be an IORef
  , nodeId :: Int -- NOTE debug
  }

data Invalidator t
   = forall a. InvalidatorPull (Pull t a)
   | forall a. InvalidatorSwitch (SwitchSubscribed t a)
data SomeBehaviorSubscribed t
  = forall a. SomeBehaviorSubscribed (BehaviorSubscribed t a)
data SomeHoldInit t = forall p. Patch p => SomeHoldInit !(Hold t p)

## Event

-- EventM can do everything BehaviorM can, plus create holds
newtype EventM t a = EventM (IO a) -- The environment should be Nothing if we are not in a frame, and Just if we are - in which case it is a list of assignments to be done after the frame is over

newtype Event t a = Event
  (Subscriber t a -> EventM t (EventSubscription t, Maybe a))
-- NOTE (Pure)   t -> Maybe a
-- NOTE (Spider) Subscriber -> IO (Maybe a, {unsubscribe :: IO ()})

~ -- NOTE Subscriber t a
  { propagate :: a -> IO ()
  , invalidateHeight :: Height -> IO ()
  , recalculateHeight :: Height -> IO ()
  }
  -> IO
    ( -- NOTE EventSubscription t
      { unsubscribe :: IO ()
      , subscribed :: -- NOTE EventSubscribed t
          { heightRef :: IORef Height
          , retained :: Any
          }
      }
    , Maybe a
    )

## Bahavior

type BehaviorEnv t =
  ( Maybe ( Weak (Invalidator t)
          , IORef [SomeBehaviorSubscribed t]
          )
  , IORef [SomeHoldInit t]
  )
newtype BehaviorM t a = BehaviorM (ReaderT (BehaviorEnv t) IO a)
newtype Behavior t a = Behavior (BehaviorM t a)
-- NOTE (Pure)   t -> a
-- NOTE (Spider) (Maybe (Invalidator, [Subscribed]), [Hold]) -> IO a

~ ( Maybe
    ( Weak -- NOTE (Invalidator t)
      ( forall a. InvalidatorPull -- NOTE (Pull t a)
          { value ::
              IORef
              ( Maybe -- NOTE (PullSubscribed t a)
                { value :: a
                , invalidators :: IORef [Weak (Invalidator t)] -- NOTE rec
                , ownInvalidator :: Invalidator t -- NOTE rec
                , parents ::
                    [ -- NOTE SomeBehaviorSubscribed t
                      exists a.
                      ( forall p. BehaviorSubscribedHold (Hold t p) -- NOTE expanded below
                      | BehaviorSubscribedPull (PullSubscribed t a) -- NOTE rec
                      )
                    ] -- Need to keep parent behaviors alive, or they won't let us know when they're invalidated
                }
              )
          , compute :: BehaviorM t a -- NOTE rec
          , nodeId :: Int -- NOTE debug
          }

      | forall a. InvalidatorSwitch -- NOTE (SwitchSubscribed t a)
          { cachedSubscribed :: !(IORef (Maybe (SwitchSubscribed t a))) -- NOTE rec
          , occurrence :: !(IORef (Maybe a))
          , height :: !(IORef Height)
          , subscribers :: !(WeakBag (Subscriber t a))
          , ownInvalidator ::  !(Invalidator t)
          , ownWeakInvalidator :: !(IORef (Weak (Invalidator t))) -- NOTE rec
          , behaviorParents :: !(IORef [SomeBehaviorSubscribed t]) -- NOTE expanded below
          , parent :: !(Behavior t (Event t a)) -- NOTE rec
          , currentParent :: !(IORef (EventSubscription t)) -- NOTE expanded above
          , weakSelf :: !(IORef (Weak (SwitchSubscribed t a))) -- NOTE rec
          , nodeId :: Int -- NOTE debug
          }
      )
    , IORef
        [ -- NOTE SomeBehaviorSubscribed t
          exists a.
            ( forall p. BehaviorSubscribedHold (Hold t p) -- NOTE expanded below
            | BehaviorSubscribedPull -- NOTE (PullSubscribed t a)
                { value :: a
                , invalidators :: IORef [Weak (Invalidator t)] -- NOTE rec
                , ownInvalidator :: Invalidator t -- NOTE rec
                , parents :: [SomeBehaviorSubscribed t] -- NOTE rec -- Need to keep parent behaviors alive, or they won't let us know when they're invalidated
                }
            )
        ]
    )
  , IORef
      [ -- NOTE SomeHoldInit t
        exists p. Patch p => -- NOTE Hold t p
          { value :: IORef (PatchTarget p)
          , invalidators :: IORef [Weak (Invalidator t)] -- NOTE rec
          , event :: Event t p -- NOTE This must be lazy, or holds cannot be defined before their input Events
          , parent ::
              IORef
              ( Maybe -- NOTE (EventSubscription t)
                { unsubscribe :: IO ()
                , subscribed :: -- NOTE EventSubscribed t
                    { heightRef :: IORef Height
                    , retained :: Any
                    }
                }
              ) -- Keeps its parent alive (will be undefined until the hold is initialized) --TODO: Probably shouldn't be an IORef
          , nodeId :: Int -- NOTE debug
          }
      ]
  )
  -> IO a

## Dynamic

data Dynamic t p = Dynamic
  { dynamicCurrent :: !(Behavior t (PatchTarget p))
  , dynamicUpdated :: !(Event t p)
  }

## instance Reflex (SpiderTimeline t)

instance HasSpiderTimeline t => R.Reflex (SpiderTimeline t) where
  newtype Event (SpiderTimeline t) a = SpiderEvent (Event t a)
  newtype Behavior (SpiderTimeline t) a = SpiderBehavior (Behavior t a)
  newtype Dynamic (SpiderTimeline t) a = SpiderDynamic (Dynamic t (Identity a))
  newtype Incremental (SpiderTimeline t) p = SpiderIncremental (Dynamic t p)

  newtype SpiderPullM t a = SpiderPullM (BehaviorM t a)
  type PullM (SpiderTimeline t) = SpiderPullM t

  newtype SpiderPushM t a = SpiderPushM (EventM t a)
  type PushM (SpiderTimeline t) = SpiderPushM t

## Cache (Event)

data CacheSubscribed t a = CacheSubscribed
  { subscribers :: !(FastWeakBag (Subscriber t a)) -- forward propagation of event
  , parent :: !(EventSubscription t) -- backward propagation for cleanup
  , occurrence :: !(IORef (Maybe a)) -- cache the latest value
  }

~ { subscribers :: FastWeakBag -- NOTE (Subscriber t a)
      { propagate :: a -> EventM t ()
      , invalidateHeight :: Height -> IO ()
      , recalculateHeight :: Height -> IO ()
      }
  , parent :: -- NOTE EventSubscription t
      { unsubscribe :: IO ()
      , subscribed :: -- NOTE EventSubscribed t
           { heightRef :: IORef Height
           , retained :: Any
           }
      }
  , occurrence :: IORef (Maybe a)
  }

data SomeClear = forall a. SomeClear !(IORef (Maybe a))

cacheEvent :: forall t a. HasSpiderTimeline t => Event t a -> Event t a
cacheEvent e =
  -- withStackOneLine $ \callSite -> Event $ -- NOTE debug
  Event \(sub :: Subscriber t a) -> do
    let
      mSubscribedRef :: IORef (FastWeak (CacheSubscribed t a))
      !mSubscribedRef
        = unsafeNewIORef e (emptyFastWeak :: FastWeak a)
        where
          -- NOTE Control.Monad.Primitive
          -- in short: [IO/ST](http://dev.stephendiehl.com/hask/#iost)
          -- in depth: [Primitive Haskell - FP Complete](https://haskell.fpcomplete.com/tutorial/primitive-haskell)
          unsafeNewIORef :: a -> b -> IORef b
          unsafeNewIORef a b = unsafePerformIO $ do
            -- TODO GHC.Prim (touch# :: o -> State# RealWorld -> State# RealWorld)
            -- NOTE the point of touch is to prevent premature GC
            -- from [Behavior of touch#](https://mail.haskell.org/pipermail/glasgow-haskell-users/2014-December/025502.html)
            -- NOTE [Deprecate touch and introduce with](https://github.com/haskell/primitive/issues/216)
            (touch :: Control.Monad.Primitive.PrimMonad m => a -> m ()) a
            newIORef b

    -- unless (BS8.null callSite) $ liftIO $ BS8.hPutStrLn stderr callSite -- NOTE debug
    subscribedTicket :: FastWeakTicket (CacheSubscribed t a)
      <- liftIO
          ( readIORef mSubscribedRef
          >>= (getFastWeakTicket
                :: FastWeak (CacheSubscribed t a)
                -> IO (Maybe (FastWeakTicket (CacheSubscribed t a))))
          )
            where
              getFastWeakTicket :: forall a. FastWeak a -> IO (Maybe (FastWeakTicket a))
              getFastWeakTicket w = do
                -- NOTE import System.Mem.Weak (deRefWeak)
                -- Dereferences a weak pointer. If the key is still alive, then Just v is returned (where v is the value in the weak pointer), otherwise Nothing is returned.
                -- The return value of deRefWeak depends on when the garbage collector runs, hence it is in the IO monad.
                deRefWeak w >>= \case
                  Nothing -> return Nothing
                  Just v -> return $ Just $ FastWeakTicket { val = v , weak = w }

      >>= \case
        Just (subscribedTicket :: FastWeakTicket (CacheSubscribed t a)) ->
          return subscribedTicket
        Nothing -> do
          subscribers :: FastWeakBag (Subscriber t a)
            <- liftIO FastWeakBag.empty
          occRef :: IORef (Maybe a)
            <- liftIO $ newIORef Nothing -- This should never be read prior to being set below
          (parentSub :: EventSubscription t, occ :: Maybe a)
            <- subscribeAndRead e $ Subscriber
              { propagate = \a -> do
                  liftIO $ writeIORef occRef $ Just a
                  scheduleClear occRef
                  -- NOTE propagateFast a subscribers
                  FastWeakBag.traverse subscribers \s ->
                    s.propagate a -- NOTE forward propagation (push) of a new value
              , invalidateHeight = \oldHeight ->
                  FastWeakBag.traverse subscribers \s ->
                    s.invalidateHeight oldHeight
              , recalculateHeight = \newHeight ->
                  FastWeakBag.traverse subscribers \s ->
                    s.recalculateHeight newHeight
              }
            where
              subscribeAndRead
                :: Event t a
                -> Subscriber t a -> EventM t (EventSubscription t, Maybe a)
              subscribeAndRead (Event e) = e

              -- TODO only (instance Defer (SomeHoldInit x) (BehaviorM x)) is currently in use?
              scheduleClear :: Defer SomeClear m => IORef (Maybe a) -> m ()
              scheduleClear r = defer $ SomeClear r
                where
                  defer :: Defer a m => a -> m ()
                  defer a = do
                    q :: IORef [a]
                      <- getDeferralQueue
                    liftIO $ modifyIORef' q ((a : _) :: [a] -> [a])

                  instance HasSpiderTimeline x => Defer SomeClear (EventM x)
                    where
                      getDeferralQueue = asksEventEnv eventEnvClears

              -- | Propagate everything at the current height
              propagateFast :: a -> FastWeakBag (Subscriber x a) -> EventM x ()
              propagateFast a subscribers =
                -- NOTE: in the following traversal, we do not visit nodes that are added to the list during our traversal; they are new events, which will necessarily have full information already, so there is no need to traverse them
                --TODO: Should we check if nodes already have their values before propagating?  Maybe we're re-doing work
                FastWeakBag.traverse subscribers \s ->
                  s.propagate a

          when (isJust occ) $ do
            liftIO $ writeIORef occRef occ -- Set the initial value of occRef; we don't need to do this if occ is Nothing
            scheduleClear occRef
          let !subscribed = CacheSubscribed
                { subscribers = subscribers
                , parent = parentSub
                , occurrence = occRef
                }
          subscribedTicket :: FastWeakTicket (CacheSubscribed t a)
            <- liftIO $ mkFastWeakTicket subscribed
          liftIO
            $ writeIORef mSubscribedRef
            =<< getFastWeakTicketWeak subscribedTicket
          return subscribedTicket

    liftIO do
      subscribed :: CacheSubscribed t a
        <- getFastWeakTicketValue subscribedTicket
      ticket :: FastWeakBagTicket (Subscriber t a)
        <- FastWeakBag.insert sub subscribed.subscribers
      occ :: Maybe a
        <- readIORef subscribed.occurrence
      let es = EventSubscription
            { unsubscribe = do
                FastWeakBag.remove ticket
                isEmpty <- FastWeakBag.isEmpty subscribed.subscribers
                when isEmpty do
                  writeIORef mSubscribedRef emptyFastWeak
                  subscribed.parent.unsubscribe -- NOTE backward propagation of unsubscribe
                touch ticket
                touch subscribedTicket
            , subscribed = EventSubscribed
                { heightRef = subscribed.parent.subscribed.heightRef
                , retained = toAny subscribedTicket
                }
            }
            where
              toAny :: a -> Any
              toAny = unsafeCoerce

      return (es, occ)

## Push (Event)

pushCheap
  :: forall t a b
  . (a -> EventM t (Maybe b)) -- a -> IO (Maybe b)
  -> Event t a -- Subscriber t a -> IO (Maybe a, {unsubscribe :: IO ()})
  -> Event t b -- Subscriber t b -> IO (Maybe b, {unsubscribe :: IO ()})
pushCheap !f (Event eventA) = Event \(subscriberB :: Subscriber t b) -> do
  let
    subscriberA :: Subscriber t a
      = subscriberB
        { propagate = \a -> do
            (mb :: Maybe b) <- f a
            traverse_ subscriberB.propagate mb
        }
  (subscription :: EventSubscription t, occA :: Maybe a)
    <- eventA subscriberA
  occB :: Maybe b
    <- join <$> traverse f occA
  return (subscription, occB)

push
  :: forall t a b
  . HasSpiderTimeline t
  => (a -> EventM t (Maybe b))
  -> Event t a -> Event t b
push f e = cacheEvent (pushCheap f e)

## Pull (Behavior)

type BehaviorEnv t =
  ( Maybe ( Weak (Invalidator t)
          , IORef [SomeBehaviorSubscribed t] -- NOTE parentsRef
          )
  , IORef [SomeHoldInit t] -- NOTE behaviorHoldInit
  )
newtype BehaviorM t a = BehaviorM (ReaderT (BehaviorEnv t) IO a)
  deriving newtype (MonadReader)
newtype Behavior t a = Behavior (BehaviorM t a)

data Pull t a = Pull
  { value :: !(IORef (Maybe (PullSubscribed t a)))
  , compute :: !(BehaviorM t a)
  -- , nodeId :: Int -- NOTE debug
  }
data PullSubscribed t a = PullSubscribed
  { value :: !a
  , invalidators :: !(IORef [Weak (Invalidator t)])
  , ownInvalidator :: !(Invalidator t)
  , parents :: ![SomeBehaviorSubscribed t] -- Need to keep parent behaviors alive, or they won't let us know when they're invalidated
  }

behaviorPull :: Pull x a -> Behavior x a
behaviorPull !p = Behavior $
  (liftIO $ readIORef $ p.value :: IORef (Maybe (PullSubscribed t a)))
  >>= \case
    Just (subscribed :: PullSubscribed t a) ->
    do
      askParentsRef >>= traverse_ \(r :: IORef [SomeBehaviorSubscribed t]) ->
        liftIO $ modifyIORef' r
          (SomeBehaviorSubscribed (BehaviorSubscribedPull subscribed) : _)
        where
          askParentsRef :: BehaviorM t (Maybe (IORef [SomeBehaviorSubscribed t]))
  -- NOTE askParentsRef = preview (_1._Just._2)
          askParentsRef = do
            (!m, _) :: BehaviorEnv t
              <- BehaviorM ask
            case m of
              Nothing -> return Nothing
              Just (_, !p :: IORef [SomeBehaviorSubscribed t]) ->
                return $ Just p

      askInvalidator >>= traverse_ \(wi :: Weak (Invalidator t)) ->
        liftIO
        $ modifyIORef'
            (subscribed.invalidators :: IORef [Weak (Invalidator t)])
            (wi : _)
        where
          askInvalidator :: BehaviorM t (Maybe (Weak (Invalidator t)))
  -- NOTE askInvalidator = preview (_1._Just._1)
          askInvalidator = do
            (!m, _) :: BehaviorEnv t
              <- BehaviorM ask
            case m of
              Nothing -> return Nothing
              Just (!wi :: Weak (Invalidator t), _) ->
                return $ Just wi

      liftIO $ touch $ subscribed.ownInvalidator :: Invalidator t
      return $ subscribed.value :: a
    Nothing -> do
      i :: Invalidator t
        <- liftIO $ newInvalidatorPull p
        where
          newInvalidatorPull :: Pull t a -> IO (Invalidator t)
          newInvalidatorPull p = return $! InvalidatorPull p

      wi :: Weak (Invalidator t)
        <- liftIO $ mkWeakPtrWithDebug i "InvalidatorPull"
        where
          debugFinalize :: Bool
          debugFinalize = False

          mkWeakPtrWithDebug :: a -> String -> IO (Weak a)
          mkWeakPtrWithDebug x debugNote = do
            x' <- evaluate x
            mkWeakPtr x' $
              if debugFinalize
              then Just $ putStrLn $ "finalizing: " ++ debugNote
              else Nothing

      parentsRef :: IORef [SomeBehaviorSubscribed t]
        <- liftIO $ newIORef []

      a <- do
          holdInits :: IORef [SomeHoldInit t]
            <- askBehaviorHoldInits
            where
              askBehaviorHoldInits :: BehaviorM t (IORef [SomeHoldInit t])
      -- NOTE askBehaviorHoldInits = preview _2
              askBehaviorHoldInits = do
                (_, !his) <- BehaviorM ask
                return his
          liftIO
            $ runReaderT (unBehaviorM p.compute) :: BehaviorEnv t -> IO a
            $ (Just (wi, parentsRef), holdInits)

      invsRef :: IORef [Weak (Invalidator t)]
        <- liftIO . newIORef . maybeToList
        =<< (askInvalidator :: BehaviorM t (Maybe (Weak (Invalidator t))))

      parents :: [SomeBehaviorSubscribed t]
        <- liftIO $ readIORef parentsRef

      let subscribed = PullSubscribed
            { value = a
            , invalidators = invsRef
            , ownInvalidator = i
            , parents = parents
            }
      liftIO $ writeIORef p.value $ Just subscribed
      askParentsRef >>= traverse_ \(r :: IORef [SomeBehaviorSubscribed t]) ->
        liftIO $ modifyIORef' r
          (SomeBehaviorSubscribed (BehaviorSubscribedPull subscribed) : _)

      return a

pull :: BehaviorM x a -> Behavior x a
pull a = behaviorPull $ Pull
  { value = unsafeNewIORef a Nothing
  , compute = a
  , nodeId = unsafeNodeId a -- NOTE debug
  }

## Merge (Event)

data Merge x k s = Merge
  { parentsRef ::  !(IORef (DMap k s))
  , heightBagRef ::  !(IORef HeightBag)
  , heightRef ::  !(IORef Height)
  , sub ::  !(Subscriber x (DMap k Identity))
  , accumRef ::  !(IORef (DMap k Identity))
  }
data HeightBag = HeightBag
  { size :: !Int
  , contents :: !(IntMap Word) -- Number of excess in each bucket
  }

~ -- NOTE Merge t k s
  { parentsRef
      :: IORef -- NOTE (DMap k s)
          [ exists v. k v :=> s v ]
  , heightBagRef
      :: IORef -- NOTE HeightBag
          { size :: Int
          , contents :: IntMap Word
          }
  , heightRef ::  IORef Height
  , sub -- NOTE Subscriber t (DMap k Identity)
      :: { propagate
            :: [ exists v. k v :=> v ] -- NOTE (DMap k Identity)
            -> IO ()
        , invalidateHeight :: Height -> IO ()
        , recalculateHeight :: Height -> IO ()
        }
      -> IO
      ( -- NOTE EventSubscription t
        { unsubscribe :: IO ()
        , subscribed :: -- NOTE EventSubscribed t
            { heightRef :: IORef Height
            , retained :: Any
            }
        }
      , Maybe [ exists v. k v :=> v ]
      )
  , accumRef
      :: IORef -- NOTE (DMap k Identity)
          [ exists v. k v :=> v ]
  }

type MergeInitFunc k x s
  = DMap k (Event x)
  -> (forall a. EventM x (k a) -> Subscriber x a)
  -> EventM x (DMap k Identity, [Height], DMap k s)

type MergeUpdateFunc k x p s
  = (forall a. EventM x (k a) -> Subscriber x a)
  -> IORef HeightBag
  -> DMap k s
  -> p
  -> EventM x ([EventSubscription x], DMap k s)

type MergeDestroyFunc k s
  = DMap k s
  -> IO ()

mergeCheap'
  :: forall k t p s
  . ( HasSpiderTimeline t
    , GCompare k
    , PatchTarget p ~ DMap k (Event t)
    )
  => MergeInitFunc k t s
  -> MergeUpdateFunc k t p s
  -> MergeDestroyFunc k s
  -> Dynamic t p
  -> Event t (DMap k Identity)
mergeCheap' getInitialSubscribers updateFunc destroy dynamic = Event \(sub :: Subscriber t (DMap k Identity)) -> do
  parentsRef :: IORef (DMap k s)
    <- liftIO $ newIORef $ error "merge: parentsRef not yet initialized"
  heightBagRef :: IORef HeightBag
    <- liftIO $ newIORef $ error "merge: heightBagRef not yet initialized"
  heightRef :: IORef Height
    <- liftIO $ newIORef $ error "merge: heightRef not yet initialized"
  accumRef :: IORef (DMap k Identity)
    <- liftIO $ newIORef $ error "merge: accumRef not yet initialized"
  let
    m = Merge
          { parentsRef = parentsRef
          , heightBagRef = heightBagRef
          , heightRef = heightRef
          , sub = sub
          , accumRef = accumRef
          }

  initialParents :: DMap k (Event t)
    <- readBehaviorUntracked dynamic.current
    where
      readBehaviorUntracked :: forall t m a. Defer (SomeHoldInit t) m => Behavior t a -> m a
      readBehaviorUntracked (Behavior bm) = do
        holdInits :: IORef [SomeHoldInit t]
          <- getDeferralQueue
        liftIO $ (runBehaviorM bm) Nothing holdInits --TODO: Specialize readBehaviorTracked to the Nothing and Just cases
          where
            runBehaviorM
              :: BehaviorM x a
              -> Maybe (Weak (Invalidator x), IORef [SomeBehaviorSubscribed x])
              -> IORef [SomeHoldInit x] -> IO a
            runBehaviorM (BehaviorM b) mwi holdInits =
              runReaderT b (mwi, holdInits)

  (dm, heights, initialParentState)
    <- getInitialSubscribers initialParents
    $ mergeSubscriber m
    where
      mergeSubscriber
        :: forall t k s a
        . ( HasSpiderTimeline t
          , GCompare k
          )
        => Merge t k s
        -> EventM t (k a)
        -> Subscriber t a
      mergeSubscriber m getKey = Subscriber
        { propagate = \a -> do
            oldM <- liftIO $ readIORef $ m.accumRef
            k <- getKey
            let
              newM
                = DMap.insertWith
                    (error $ "Same key fired multiple times for Merge")
                    k
                    (Identity a)
                    oldM
            tracePropagate (Proxy @t)
              $ "  DMap.size oldM = " <> show (DMap.size oldM) <> "; DMap.size newM = " <> show (DMap.size newM)
            liftIO $ writeIORef m.accumRef $! newM
            when (DMap.null oldM) $ do -- Only schedule the firing once
              height <- liftIO $ readIORef $ m.heightRef
              --TODO: assertions about height
              currentHeight <- getCurrentHeight
              when (height <= currentHeight) $ do
                if height /= invalidHeight
                  then do
                    myStack <- liftIO $ whoCreatedIORef undefined --TODO
                    error $ "Height (" ++ show height ++ ") is not greater than current height (" ++ show currentHeight ++ ")\n" ++ unlines (reverse myStack)
                  else liftIO $ do
                    {- NOTE debug
                    nodesInvolvedInCycle <- walkInvalidHeightParents $ eventSubscribedMerge subscribed
                    stacks <- forM nodesInvolvedInCycle $ \(Some.This es) -> whoCreatedEventSubscribed es
                    let cycleInfo = ":\n" <> drawForest (listsToForest stacks)
                    -}
                    let cycleInfo = ""
                    error $ "Causality loop found" <> cycleInfo
              scheduleMergeSelf m height

        , invalidateHeight = \old -> do --TODO: When removing a parent doesn't actually change the height, maybe we can avoid invalidating
            modifyIORef' m.heightBagRef $ heightBagRemove old
            invalidateMergeHeight m
              where
                invalidateMergeHeight :: Merge x k s -> IO ()
                invalidateMergeHeight m = invalidateMergeHeight' (_merge_heightRef m) (_merge_sub m)

        , recalculateHeight = \new -> do
            modifyIORef' m.heightBagRef $ heightBagAdd new
            revalidateMergeHeight m
              where
                revalidateMergeHeight :: Merge x k s -> IO ()
                revalidateMergeHeight m = do
                  currentHeight <- readIORef $ _merge_heightRef m
                  when (currentHeight == invalidHeight) $ do -- revalidateMergeHeight may be called multiple times; perhaps the's a way to finesse it to avoid this check
                    heights <- readIORef $ _merge_heightBagRef m
                    parents <- readIORef $ _merge_parentsRef m
                    -- When the number of heights in the bag reaches the number of parents, we should have a valid height
                    case heightBagSize heights `compare` DMap.size parents of
                      LT -> return ()
                      EQ -> do
                        let height = succHeight $ heightBagMax heights
                        when debugInvalidateHeight $ putStrLn $ "recalculateSubscriberHeight: height: " <> show height
                        writeIORef (_merge_heightRef m) $! height
                        subscriberRecalculateHeight (_merge_sub m) height
                      GT -> error $ "revalidateMergeHeight: more heights (" <> show (heightBagSize heights) <> ") than parents (" <> show (DMap.size parents) <> ") for Merge"

        }

  let
    myHeightBag
      = heightBagFromList
      $ filter (/= invalidHeight) heights
    myHeight
      = if invalidHeight `elem` heights
        then invalidHeight
        else succHeight $ heightBagMax myHeightBag
  currentHeight <- getCurrentHeight
  let
    (occ, accum)
      = if currentHeight >= myHeight -- If we should have fired by now
        then (if DMap.null dm then Nothing else Just dm, DMap.empty)
        else (Nothing, dm)
  unless (DMap.null accum) $ do
    scheduleMergeSelf m myHeight
  liftIO $ writeIORef accumRef $! accum
  liftIO $ writeIORef heightRef $! myHeight
  liftIO $ writeIORef heightBagRef $! myHeightBag
  changeSubdRef <- liftIO $ newIORef $ error "getMergeSubscribed: changeSubdRef not yet initialized"
  liftIO $ writeIORef parentsRef $! initialParentState
  defer $ SomeMergeInit $ do
    let s = Subscriber
          { propagate = \a -> do
              tracePropagate (Proxy @t) $ "SubscriberMerge/Change"
              defer $ updateMerge m updateFunc a
          , invalidateHeight = \_ -> return ()
          , recalculateHeight = \_ -> return ()
          }
    (changeSubscription, change) <- (subscribeAndRead dynamic.updated) s
    forM_ change $ \c -> defer $ updateMerge m updateFunc c
    -- We explicitly hold on to the unsubscribe function from subscribing to the update event.
    -- If we don't do this, there are certain cases where mergeCheap will fail to properly retain
    -- its subscription.
    liftIO $ writeIORef changeSubdRef (s, changeSubscription)
  let unsubscribeAll = destroy =<< readIORef parentsRef
  return ( EventSubscription unsubscribeAll $ EventSubscribed heightRef $ toAny (parentsRef, changeSubdRef)
         , occ
         )

mergeCheap
  :: forall k x
  . (HasSpiderTimeline x, GCompare k)
  => Dynamic x (PatchDMap k (Event x))
  -> Event x (DMap k Identity)
mergeCheap = mergeCheap' getInitialSubscribers updateMe destroy
  where
    getInitialSubscribers :: MergeInitFunc k x (MergeSubscribedParent x)
    getInitialSubscribers initialParents subscriber = do
      subscribers <- forM (DMap.toList initialParents) $ \(k :=> e) -> do
        let s = subscriber $ return k
        (subscription@(EventSubscription _ parentSubd), parentOcc) <- subscribeAndRead e s
        height <- liftIO $ getEventSubscribedHeight parentSubd
        return (fmap (\x -> k :=> Identity x) parentOcc, height, k :=> MergeSubscribedParent subscription)
      return ( DMap.fromDistinctAscList $ mapMaybe (\(x, _, _) -> x) subscribers
              , fmap (\(_, h, _) -> h) subscribers --TODO: Assert that there's no invalidHeight in here
              , DMap.fromDistinctAscList $ map (\(_, _, x) -> x) subscribers
              )

    updateMe :: MergeUpdateFunc k x (PatchDMap k (Event x)) (MergeSubscribedParent x)
    updateMe subscriber heightBagRef oldParents (PatchDMap p) = do
      let f (subscriptionsToKill, ps) (k :=> ComposeMaybe me) = do
            (mOldSubd, newPs) <- case me of
              Nothing -> return $ DMap.updateLookupWithKey (\_ _ -> Nothing) k ps
              Just e -> do
                let s = subscriber $ return k
                subscription@(EventSubscription _ subd) <- subscribe e s
                newParentHeight <- liftIO $ getEventSubscribedHeight subd
                let newParent = MergeSubscribedParent subscription
                liftIO $ modifyIORef' heightBagRef $ heightBagAdd newParentHeight
                return $ DMap.insertLookupWithKey' (\_ new _ -> new) k newParent ps
            forM_ mOldSubd $ \oldSubd -> do
              oldHeight <- liftIO $ getEventSubscribedHeight $ _eventSubscription_subscribed $ unMergeSubscribedParent oldSubd
              liftIO $ modifyIORef heightBagRef $ heightBagRemove oldHeight
            return (maybeToList (unMergeSubscribedParent <$> mOldSubd) ++ subscriptionsToKill, newPs)
      foldM f ([], oldParents) $ DMap.toList p

    destroy :: MergeDestroyFunc k (MergeSubscribedParent x)
    destroy s = forM_ (DMap.toList s) $ \(_ :=> MergeSubscribedParent sub) -> unsubscribe sub

mergeCheapWithMove :: forall k x. (HasSpiderTimeline x, GCompare k) => Dynamic x (PatchDMapWithMove k (Event x)) -> Event x (DMap k Identity)
mergeCheapWithMove = mergeCheap' getInitialSubscribers updateMe destroy
  where
      updateMe :: MergeUpdateFunc k x (PatchDMapWithMove k (Event x)) (MergeSubscribedParentWithMove x k)
      updateMe subscriber heightBagRef oldParents p = do
        -- Prepare new parents for insertion
        let subscribeParent :: forall a. k a -> Event x a -> EventM x (MergeSubscribedParentWithMove x k a)
            subscribeParent k e = do
              keyRef <- liftIO $ newIORef k
              let s = subscriber $ liftIO $ readIORef keyRef
              subscription@(EventSubscription _ subd) <- subscribe e s
              liftIO $ do
                newParentHeight <- getEventSubscribedHeight subd
                modifyIORef' heightBagRef $ heightBagAdd newParentHeight
                return $ MergeSubscribedParentWithMove subscription keyRef
        p' <- PatchDMapWithMove.traversePatchDMapWithMoveWithKey subscribeParent p
        -- Collect old parents for deletion and update the keys of moved parents
        let moveOrDelete :: forall a. k a -> PatchDMapWithMove.NodeInfo k (Event x) a -> MergeSubscribedParentWithMove x k a -> Constant (EventM x (Maybe (EventSubscription x))) a
            moveOrDelete _ ni parent = Constant $ case getComposeMaybe $ PatchDMapWithMove._nodeInfo_to ni of
              Nothing -> do
                oldHeight <- liftIO $ getEventSubscribedHeight $ _eventSubscription_subscribed $ _mergeSubscribedParentWithMove_subscription parent
                liftIO $ modifyIORef heightBagRef $ heightBagRemove oldHeight
                return $ Just $ _mergeSubscribedParentWithMove_subscription parent
              Just toKey -> do
                liftIO $ writeIORef (_mergeSubscribedParentWithMove_key parent) $! toKey
                return Nothing
        toDelete <- fmap catMaybes $ mapM (\(_ :=> v) -> getConstant v) $ DMap.toList $ DMap.intersectionWithKey moveOrDelete (unPatchDMapWithMove p) oldParents
        return (toDelete, applyAlways p' oldParents)
      getInitialSubscribers :: MergeInitFunc k x (MergeSubscribedParentWithMove x k)
      getInitialSubscribers initialParents subscriber = do
        subscribers <- forM (DMap.toList initialParents) $ \(k :=> e) -> do
          keyRef <- liftIO $ newIORef k
          let s = subscriber $ liftIO $ readIORef keyRef
          (subscription@(EventSubscription _ parentSubd), parentOcc) <- subscribeAndRead e s
          height <- liftIO $ getEventSubscribedHeight parentSubd
          return (fmap (\x -> k :=> Identity x) parentOcc, height, k :=> MergeSubscribedParentWithMove subscription keyRef)
        return ( DMap.fromDistinctAscList $ mapMaybe (\(x, _, _) -> x) subscribers
               , fmap (\(_, h, _) -> h) subscribers --TODO: Assert that there's no invalidHeight in here
               , DMap.fromDistinctAscList $ map (\(_, _, x) -> x) subscribers
               )
      destroy :: MergeDestroyFunc k (MergeSubscribedParentWithMove x k)
      destroy s = forM_ (DMap.toList s) $ \(_ :=> MergeSubscribedParentWithMove sub _) -> unsubscribe sub

merge :: forall k x. (HasSpiderTimeline x, GCompare k) => Dynamic x (PatchDMap k (Event x)) -> Event x (DMap k Identity)
merge d = cacheEvent (mergeCheap d)

mergeWithMove :: forall k x. (HasSpiderTimeline x, GCompare k) => Dynamic x (PatchDMapWithMove k (Event x)) -> Event x (DMap k Identity)
mergeWithMove d = cacheEvent (mergeCheapWithMove d)
