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
-- NOTE (Spider) (Maybe (Invalidator, [Subscribed]), Hold) -> IO a

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

## cacheEvent

data CacheSubscribed t a = CacheSubscribed
  { subscribers :: !(FastWeakBag (Subscriber t a))
  , parent :: !(EventSubscription t)
  , occurrence :: !(IORef (Maybe a))
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
  Event $
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

    in
      \(sub :: Subscriber t a) -> do
        -- unless (BS8.null callSite) $ liftIO $ BS8.hPutStrLn stderr callSite -- NOTE debug
        subscribedTicket :: FastWeakTicket (CacheSubscribed t a)
          <- liftIO
              ( readIORef mSubscribedRef
              >>= (getFastWeakTicket
                    :: FastWeak (CacheSubscribed t a)
                    -> IO (Maybe (FastWeakTicket (CacheSubscribed t a))))
              )
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
                        propagateFast a subscribers
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
                      subscribed.parent.unsubscribe
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

# push

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

# Pull

type BehaviorEnv t =
  ( Maybe ( Weak (Invalidator t)
          , IORef [SomeBehaviorSubscribed t]
          )
  , IORef [SomeHoldInit t]
  )
newtype BehaviorM t a = BehaviorM (ReaderT (BehaviorEnv t) IO a)
newtype Behavior t a = Behavior (BehaviorM t a)

data Pull t a = Pull
  { value :: !(IORef (Maybe (PullSubscribed t a)))
  , compute :: !(BehaviorM t a)
  , nodeId :: Int -- NOTE debug
  }
data PullSubscribed t a = PullSubscribed
  { value :: !a
  , invalidators :: !(IORef [Weak (Invalidator t)])
  , ownInvalidator :: !(Invalidator t)
  , parents :: ![SomeBehaviorSubscribed t] -- Need to keep parent behaviors alive, or they won't let us know when they're invalidated
  }

behaviorPull :: Pull x a -> Behavior x a
behaviorPull !p = Behavior
  $ (liftIO $ readIORef $ p.value :: IORef (Maybe (PullSubscribed t a)))
  >>= \case
    Just (subscribed :: PullSubscribed t a) -> do
      askParentsRef >>= traverse_ \(r :: IORef [SomeBehaviorSubscribed t]) ->
        liftIO $ modifyIORef' r
          (SomeBehaviorSubscribed (BehaviorSubscribedPull subscribed) : _)
        where
          askParentsRef :: BehaviorM t (Maybe (IORef [SomeBehaviorSubscribed t]))
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
      askParentsRef >>= mapM_ (\r -> liftIO $ modifyIORef' r (SomeBehaviorSubscribed (BehaviorSubscribedPull subscribed) :))
      return a

pull :: BehaviorM x a -> Behavior x a
pull a = behaviorPull $ Pull
  { value = unsafeNewIORef a Nothing
  , compute = a
  , nodeId = unsafeNodeId a -- NOTE debug
  }
