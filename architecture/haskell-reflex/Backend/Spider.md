# Spider

--type role PullSubscribed representational
data PullSubscribed t a = PullSubscribed
  { pullSubscribedValue :: !a
  , pullSubscribedInvalidators :: !(IORef [Weak (Invalidator t)])
  , pullSubscribedOwnInvalidator :: !(Invalidator t)
  , pullSubscribedParents :: ![SomeBehaviorSubscribed t] -- Need to keep parent behaviors alive, or they won't let us know when they're invalidated
  }
newtype Height = Height Int
data Subscriber t a = Subscriber
  { subscriberPropagate :: !(a -> EventM t ())
  , subscriberInvalidateHeight :: !(Height -> IO ())
  , subscriberRecalculateHeight :: !(Height -> IO ())
  }
data EventSubscription t = EventSubscription
  { _eventSubscription_unsubscribe :: !(IO ())
  , _eventSubscription_subscribed :: !(EventSubscribed t)
  }

--type role Pull representational
data Pull t a = Pull
  { pullValue :: !(IORef (Maybe (PullSubscribed t a)))
  , pullCompute :: !(BehaviorM t a)
  , pullNodeId :: Int -- NOTE debug
  }
data SwitchSubscribed t a = SwitchSubscribed
  { switchSubscribedCachedSubscribed :: !(IORef (Maybe (SwitchSubscribed t a)))
  , switchSubscribedOccurrence :: !(IORef (Maybe a))
  , switchSubscribedHeight :: !(IORef Height)
  , switchSubscribedSubscribers :: !(WeakBag (Subscriber t a))
  , switchSubscribedOwnInvalidator ::  !(Invalidator t)
  , switchSubscribedOwnWeakInvalidator :: !(IORef (Weak (Invalidator t)))
  , switchSubscribedBehaviorParents :: !(IORef [SomeBehaviorSubscribed t])
  , switchSubscribedParent :: !(Behavior t (Event t a))
  , switchSubscribedCurrentParent :: !(IORef (EventSubscription t))
  , switchSubscribedWeakSelf :: !(IORef (Weak (SwitchSubscribed t a)))
  , switchSubscribedNodeId :: Int -- NOTE debug
  }
data BehaviorSubscribed t a
   = forall p. BehaviorSubscribedHold (Hold t p)
   | BehaviorSubscribedPull (PullSubscribed t a)
data Hold t p = Hold
  { holdValue :: !(IORef (PatchTarget p))
  , holdInvalidators :: !(IORef [Weak (Invalidator t)])
  , holdEvent :: Event t p -- This must be lazy, or holds cannot be defined before their input Events
  , holdParent :: !(IORef (Maybe (EventSubscription t))) -- Keeps its parent alive (will be undefined until the hold is initialized) --TODO: Probably shouldn't be an IORef
  , holdNodeId :: Int -- NOTE debug
  }

data Invalidator t
   = forall a. InvalidatorPull (Pull t a)
   | forall a. InvalidatorSwitch (SwitchSubscribed t a)
data SomeBehaviorSubscribed t
  = forall a. SomeBehaviorSubscribed (BehaviorSubscribed t a)
data SomeHoldInit t = forall p. Patch p => SomeHoldInit !(Hold t p)

## Event

-- EventM can do everything BehaviorM can, plus create holds
newtype EventM t a = EventM { unEventM :: IO a } -- The environment should be Nothing if we are not in a frame, and Just if we are - in which case it is a list of assignments to be done after the frame is over
newtype Event t a = Event { unEvent :: Subscriber t a -> EventM t (EventSubscription t, Maybe a) }

## Bahavior

type BehaviorEnv t =
  ( Maybe ( Weak (Invalidator t)
          , IORef [SomeBehaviorSubscribed t]
          )
  , IORef [SomeHoldInit t]
  )
newtype BehaviorM t a = BehaviorM (ReaderT (BehaviorEnv t) IO a)
newtype Behavior t a = Behavior (BehaviorM t a)

## Dynamic

data Dynamic x p = Dynamic
  { dynamicCurrent :: !(Behavior x (PatchTarget p))
  , dynamicUpdated :: !(Event x p)
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
