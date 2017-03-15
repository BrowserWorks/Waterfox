/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nspr.h"
#include "mozilla/Logging.h"

#include "nsDocLoader.h"
#include "nsCURILoader.h"
#include "nsNetUtil.h"
#include "nsIHttpChannel.h"
#include "nsIWebProgressListener2.h"

#include "nsIServiceManager.h"
#include "nsXPIDLString.h"

#include "nsIURL.h"
#include "nsCOMPtr.h"
#include "nscore.h"
#include "nsWeakPtr.h"
#include "nsAutoPtr.h"
#include "nsQueryObject.h"

#include "nsIDOMWindow.h"

#include "nsIStringBundle.h"
#include "nsIScriptSecurityManager.h"

#include "nsITransport.h"
#include "nsISocketTransport.h"
#include "nsIDocShell.h"
#include "nsIDOMDocument.h"
#include "nsIDocument.h"
#include "nsPresContext.h"
#include "nsIAsyncVerifyRedirectCallback.h"

using mozilla::DebugOnly;
using mozilla::LogLevel;

static NS_DEFINE_CID(kThisImplCID, NS_THIS_DOCLOADER_IMPL_CID);

//
// Log module for nsIDocumentLoader logging...
//
// To enable logging (see mozilla/Logging.h for full details):
//
//    set MOZ_LOG=DocLoader:5
//    set MOZ_LOG_FILE=debug.log
//
// this enables LogLevel::Debug level information and places all output in
// the file 'debug.log'.
//
mozilla::LazyLogModule gDocLoaderLog("DocLoader");


#if defined(DEBUG)
void GetURIStringFromRequest(nsIRequest* request, nsACString &name)
{
    if (request)
        request->GetName(name);
    else
        name.AssignLiteral("???");
}
#endif /* DEBUG */



void
nsDocLoader::RequestInfoHashInitEntry(PLDHashEntryHdr* entry,
                                      const void* key)
{
  // Initialize the entry with placement new
  new (entry) nsRequestInfo(key);
}

void
nsDocLoader::RequestInfoHashClearEntry(PLDHashTable* table,
                                       PLDHashEntryHdr* entry)
{
  nsRequestInfo* info = static_cast<nsRequestInfo *>(entry);
  info->~nsRequestInfo();
}

// this is used for mListenerInfoList.Contains()
template <>
class nsDefaultComparator <nsDocLoader::nsListenerInfo, nsIWebProgressListener*> {
  public:
    bool Equals(const nsDocLoader::nsListenerInfo& aInfo,
                nsIWebProgressListener* const& aListener) const {
      nsCOMPtr<nsIWebProgressListener> listener =
                                       do_QueryReferent(aInfo.mWeakListener);
      return aListener == listener;
    }
};

/* static */ const PLDHashTableOps nsDocLoader::sRequestInfoHashOps =
{
  PLDHashTable::HashVoidPtrKeyStub,
  PLDHashTable::MatchEntryStub,
  PLDHashTable::MoveEntryStub,
  nsDocLoader::RequestInfoHashClearEntry,
  nsDocLoader::RequestInfoHashInitEntry
};

nsDocLoader::nsDocLoader()
  : mParent(nullptr),
    mCurrentSelfProgress(0),
    mMaxSelfProgress(0),
    mCurrentTotalProgress(0),
    mMaxTotalProgress(0),
    mRequestInfoHash(&sRequestInfoHashOps, sizeof(nsRequestInfo)),
    mCompletedTotalProgress(0),
    mIsLoadingDocument(false),
    mIsRestoringDocument(false),
    mDontFlushLayout(false),
    mIsFlushingLayout(false)
{
  ClearInternalProgress();

  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: created.\n", this));
}

nsresult
nsDocLoader::SetDocLoaderParent(nsDocLoader *aParent)
{
  mParent = aParent;
  return NS_OK;
}

nsresult
nsDocLoader::Init()
{
  nsresult rv = NS_NewLoadGroup(getter_AddRefs(mLoadGroup), this);
  if (NS_FAILED(rv)) return rv;

  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: load group %x.\n", this, mLoadGroup.get()));

  return NS_OK;
}

nsDocLoader::~nsDocLoader()
{
		/*
			|ClearWeakReferences()| here is intended to prevent people holding weak references
			from re-entering this destructor since |QueryReferent()| will |AddRef()| me, and the
			subsequent |Release()| will try to destroy me.  At this point there should be only
			weak references remaining (otherwise, we wouldn't be getting destroyed).

			An alternative would be incrementing our refcount (consider it a compressed flag
			saying "Don't re-destroy.").  I haven't yet decided which is better. [scc]
		*/
  // XXXbz now that NS_IMPL_RELEASE stabilizes by setting refcount to 1, is
  // this needed?
  ClearWeakReferences();

  Destroy();

  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: deleted.\n", this));
}


/*
 * Implementation of ISupports methods...
 */
NS_IMPL_ADDREF(nsDocLoader)
NS_IMPL_RELEASE(nsDocLoader)

NS_INTERFACE_MAP_BEGIN(nsDocLoader)
   NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIRequestObserver)
   NS_INTERFACE_MAP_ENTRY(nsIRequestObserver)
   NS_INTERFACE_MAP_ENTRY(nsIDocumentLoader)
   NS_INTERFACE_MAP_ENTRY(nsISupportsWeakReference)
   NS_INTERFACE_MAP_ENTRY(nsIWebProgress)
   NS_INTERFACE_MAP_ENTRY(nsIProgressEventSink)
   NS_INTERFACE_MAP_ENTRY(nsIInterfaceRequestor)
   NS_INTERFACE_MAP_ENTRY(nsIChannelEventSink)
   NS_INTERFACE_MAP_ENTRY(nsISecurityEventSink)
   NS_INTERFACE_MAP_ENTRY(nsISupportsPriority)
   if (aIID.Equals(kThisImplCID))
     foundInterface = static_cast<nsIDocumentLoader *>(this);
   else
NS_INTERFACE_MAP_END


/*
 * Implementation of nsIInterfaceRequestor methods...
 */
NS_IMETHODIMP nsDocLoader::GetInterface(const nsIID& aIID, void** aSink)
{
  nsresult rv = NS_ERROR_NO_INTERFACE;

  NS_ENSURE_ARG_POINTER(aSink);

  if(aIID.Equals(NS_GET_IID(nsILoadGroup))) {
    *aSink = mLoadGroup;
    NS_IF_ADDREF((nsISupports*)*aSink);
    rv = NS_OK;
  } else {
    rv = QueryInterface(aIID, aSink);
  }

  return rv;
}

/* static */
already_AddRefed<nsDocLoader>
nsDocLoader::GetAsDocLoader(nsISupports* aSupports)
{
  RefPtr<nsDocLoader> ret = do_QueryObject(aSupports);
  return ret.forget();
}

/* static */
nsresult
nsDocLoader::AddDocLoaderAsChildOfRoot(nsDocLoader* aDocLoader)
{
  nsresult rv;
  nsCOMPtr<nsIDocumentLoader> docLoaderService =
    do_GetService(NS_DOCUMENTLOADER_SERVICE_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  RefPtr<nsDocLoader> rootDocLoader = GetAsDocLoader(docLoaderService);
  NS_ENSURE_TRUE(rootDocLoader, NS_ERROR_UNEXPECTED);

  return rootDocLoader->AddChildLoader(aDocLoader);
}

NS_IMETHODIMP
nsDocLoader::Stop(void)
{
  nsresult rv = NS_OK;

  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: Stop() called\n", this));

  NS_OBSERVER_ARRAY_NOTIFY_XPCOM_OBSERVERS(mChildList, nsDocLoader, Stop, ());

  if (mLoadGroup)
    rv = mLoadGroup->Cancel(NS_BINDING_ABORTED);

  // Don't report that we're flushing layout so IsBusy returns false after a
  // Stop call.
  mIsFlushingLayout = false;

  // Clear out mChildrenInOnload.  We want to make sure to fire our
  // onload at this point, and there's no issue with mChildrenInOnload
  // after this, since mDocumentRequest will be null after the
  // DocLoaderIsEmpty() call.
  mChildrenInOnload.Clear();

  // Make sure to call DocLoaderIsEmpty now so that we reset mDocumentRequest,
  // etc, as needed.  We could be getting into here from a subframe onload, in
  // which case the call to DocLoaderIsEmpty() is coming but hasn't quite
  // happened yet, Canceling the loadgroup did nothing (because it was already
  // empty), and we're about to start a new load (which is what triggered this
  // Stop() call).

  // XXXbz If the child frame loadgroups were requests in mLoadgroup, I suspect
  // we wouldn't need the call here....

  NS_ASSERTION(!IsBusy(), "Shouldn't be busy here");
  DocLoaderIsEmpty(false);

  return rv;
}


bool
nsDocLoader::IsBusy()
{
  nsresult rv;

  //
  // A document loader is busy if either:
  //
  //   1. One of its children is in the middle of an onload handler.  Note that
  //      the handler may have already removed this child from mChildList!
  //   2. It is currently loading a document and either has parts of it still
  //      loading, or has a busy child docloader.
  //   3. It's currently flushing layout in DocLoaderIsEmpty().
  //

  if (mChildrenInOnload.Count() || mIsFlushingLayout) {
    return true;
  }

  /* Is this document loader busy? */
  if (!mIsLoadingDocument) {
    return false;
  }

  bool busy;
  rv = mLoadGroup->IsPending(&busy);
  if (NS_FAILED(rv)) {
    return false;
  }
  if (busy) {
    return true;
  }

  /* check its child document loaders... */
  uint32_t count = mChildList.Length();
  for (uint32_t i=0; i < count; i++) {
    nsIDocumentLoader* loader = ChildAt(i);

    // This is a safe cast, because we only put nsDocLoader objects into the
    // array
    if (loader && static_cast<nsDocLoader*>(loader)->IsBusy())
      return true;
  }

  return false;
}

NS_IMETHODIMP
nsDocLoader::GetContainer(nsISupports** aResult)
{
   NS_ADDREF(*aResult = static_cast<nsIDocumentLoader*>(this));

   return NS_OK;
}

NS_IMETHODIMP
nsDocLoader::GetLoadGroup(nsILoadGroup** aResult)
{
  nsresult rv = NS_OK;

  if (nullptr == aResult) {
    rv = NS_ERROR_NULL_POINTER;
  } else {
    *aResult = mLoadGroup;
    NS_IF_ADDREF(*aResult);
  }
  return rv;
}

void
nsDocLoader::Destroy()
{
  Stop();

  // Remove the document loader from the parent list of loaders...
  if (mParent)
  {
    DebugOnly<nsresult> rv = mParent->RemoveChildLoader(this);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "RemoveChildLoader failed");
  }

  // Release all the information about network requests...
  ClearRequestInfoHash();

  mListenerInfoList.Clear();
  mListenerInfoList.Compact();

  mDocumentRequest = nullptr;

  if (mLoadGroup)
    mLoadGroup->SetGroupObserver(nullptr);

  DestroyChildren();
}

void
nsDocLoader::DestroyChildren()
{
  uint32_t count = mChildList.Length();
  // if the doc loader still has children...we need to enumerate the
  // children and make them null out their back ptr to the parent doc
  // loader
  for (uint32_t i=0; i < count; i++)
  {
    nsIDocumentLoader* loader = ChildAt(i);

    if (loader) {
      // This is a safe cast, as we only put nsDocLoader objects into the
      // array
      DebugOnly<nsresult> rv =
        static_cast<nsDocLoader*>(loader)->SetDocLoaderParent(nullptr);
      NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "SetDocLoaderParent failed");
    }
  }
  mChildList.Clear();
}

NS_IMETHODIMP
nsDocLoader::OnStartRequest(nsIRequest *request, nsISupports *aCtxt)
{
  // called each time a request is added to the group.

  if (MOZ_LOG_TEST(gDocLoaderLog, LogLevel::Debug)) {
    nsAutoCString name;
    request->GetName(name);

    uint32_t count = 0;
    if (mLoadGroup)
      mLoadGroup->GetActiveCount(&count);

    MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
           ("DocLoader:%p: OnStartRequest[%p](%s) mIsLoadingDocument=%s, %u active URLs",
            this, request, name.get(),
            (mIsLoadingDocument ? "true" : "false"),
            count));
  }

  bool bJustStartedLoading = false;

  nsLoadFlags loadFlags = 0;
  request->GetLoadFlags(&loadFlags);

  if (!mIsLoadingDocument && (loadFlags & nsIChannel::LOAD_DOCUMENT_URI)) {
      bJustStartedLoading = true;
      mIsLoadingDocument = true;
      ClearInternalProgress(); // only clear our progress if we are starting a new load....
  }

  //
  // Create a new nsRequestInfo for the request that is starting to
  // load...
  //
  AddRequestInfo(request);

  //
  // Only fire a doStartDocumentLoad(...) if the document loader
  // has initiated a load...  Otherwise, this notification has
  // resulted from a request being added to the load group.
  //
  if (mIsLoadingDocument) {
    if (loadFlags & nsIChannel::LOAD_DOCUMENT_URI) {
      //
      // Make sure that the document channel is null at this point...
      // (unless its been redirected)
      //
      NS_ASSERTION((loadFlags & nsIChannel::LOAD_REPLACE) ||
                   !(mDocumentRequest.get()),
                   "Overwriting an existing document channel!");

      // This request is associated with the entire document...
      mDocumentRequest = request;
      mLoadGroup->SetDefaultLoadRequest(request);

      // Only fire the start document load notification for the first
      // document URI...  Do not fire it again for redirections
      //
      if (bJustStartedLoading) {
        // Update the progress status state
        mProgressStateFlags = nsIWebProgressListener::STATE_START;

        // Fire the start document load notification
        doStartDocumentLoad();
        return NS_OK;
      }
    }
  }

  NS_ASSERTION(!mIsLoadingDocument || mDocumentRequest,
               "mDocumentRequest MUST be set for the duration of a page load!");

  doStartURLLoad(request);

  return NS_OK;
}

NS_IMETHODIMP
nsDocLoader::OnStopRequest(nsIRequest *aRequest,
                           nsISupports *aCtxt,
                           nsresult aStatus)
{
  nsresult rv = NS_OK;

  if (MOZ_LOG_TEST(gDocLoaderLog, LogLevel::Debug)) {
    nsAutoCString name;
    aRequest->GetName(name);

    uint32_t count = 0;
    if (mLoadGroup)
      mLoadGroup->GetActiveCount(&count);

    MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
           ("DocLoader:%p: OnStopRequest[%p](%s) status=%x mIsLoadingDocument=%s, %u active URLs",
           this, aRequest, name.get(),
           aStatus, (mIsLoadingDocument ? "true" : "false"),
           count));
  }

  bool bFireTransferring = false;

  //
  // Set the Maximum progress to the same value as the current progress.
  // Since the URI has finished loading, all the data is there.  Also,
  // this will allow a more accurate estimation of the max progress (in case
  // the old value was unknown ie. -1)
  //
  nsRequestInfo *info = GetRequestInfo(aRequest);
  if (info) {
    // Null out mLastStatus now so we don't find it when looking for
    // status from now on.  This destroys the nsStatusInfo and hence
    // removes it from our list.
    info->mLastStatus = nullptr;

    int64_t oldMax = info->mMaxProgress;

    info->mMaxProgress = info->mCurrentProgress;

    //
    // If a request whose content-length was previously unknown has just
    // finished loading, then use this new data to try to calculate a
    // mMaxSelfProgress...
    //
    if ((oldMax < int64_t(0)) && (mMaxSelfProgress < int64_t(0))) {
      mMaxSelfProgress = CalculateMaxProgress();
    }

    // As we know the total progress of this request now, save it to be part
    // of CalculateMaxProgress() result. We need to remove the info from the
    // hash, see bug 480713.
    mCompletedTotalProgress += info->mMaxProgress;

    //
    // Determine whether a STATE_TRANSFERRING notification should be
    // 'synthesized'.
    //
    // If nsRequestInfo::mMaxProgress (as stored in oldMax) and
    // nsRequestInfo::mCurrentProgress are both 0, then the
    // STATE_TRANSFERRING notification has not been fired yet...
    //
    if ((oldMax == 0) && (info->mCurrentProgress == 0)) {
      nsCOMPtr<nsIChannel> channel(do_QueryInterface(aRequest));

      // Only fire a TRANSFERRING notification if the request is also a
      // channel -- data transfer requires a nsIChannel!
      //
      if (channel) {
        if (NS_SUCCEEDED(aStatus)) {
          bFireTransferring = true;
        }
        //
        // If the request failed (for any reason other than being
        // redirected or retargeted), the TRANSFERRING notification can
        // still be fired if a HTTP connection was established to a server.
        //
        else if (aStatus != NS_BINDING_REDIRECTED &&
                 aStatus != NS_BINDING_RETARGETED) {
          //
          // Only if the load has been targeted (see bug 268483)...
          //
          uint32_t lf;
          channel->GetLoadFlags(&lf);
          if (lf & nsIChannel::LOAD_TARGETED) {
            nsCOMPtr<nsIHttpChannel> httpChannel(do_QueryInterface(aRequest));
            if (httpChannel) {
              uint32_t responseCode;
              rv = httpChannel->GetResponseStatus(&responseCode);
              if (NS_SUCCEEDED(rv)) {
                //
                // A valid server status indicates that a connection was
                // established to the server... So, fire the notification
                // even though a failure occurred later...
                //
                bFireTransferring = true;
              }
            }
          }
        }
      }
    }
  }

  if (bFireTransferring) {
    // Send a STATE_TRANSFERRING notification for the request.
    int32_t flags;

    flags = nsIWebProgressListener::STATE_TRANSFERRING |
            nsIWebProgressListener::STATE_IS_REQUEST;
    //
    // Move the WebProgress into the STATE_TRANSFERRING state if necessary...
    //
    if (mProgressStateFlags & nsIWebProgressListener::STATE_START) {
      mProgressStateFlags = nsIWebProgressListener::STATE_TRANSFERRING;

      // Send STATE_TRANSFERRING for the document too...
      flags |= nsIWebProgressListener::STATE_IS_DOCUMENT;
    }

    FireOnStateChange(this, aRequest, flags, NS_OK);
  }

  //
  // Fire the OnStateChange(...) notification for stop request
  //
  doStopURLLoad(aRequest, aStatus);

  // Clear this request out of the hash to avoid bypass of FireOnStateChange
  // when address of the request is reused.
  RemoveRequestInfo(aRequest);

  //
  // Only fire the DocLoaderIsEmpty(...) if the document loader has initiated a
  // load.  This will handle removing the request from our hashtable as needed.
  //
  if (mIsLoadingDocument) {
    nsCOMPtr<nsIDocShell> ds = do_QueryInterface(static_cast<nsIRequestObserver*>(this));
    bool doNotFlushLayout = false;
    if (ds) {
      // Don't do unexpected layout flushes while we're in process of restoring
      // a document from the bfcache.
      ds->GetRestoringDocument(&doNotFlushLayout);
    }
    DocLoaderIsEmpty(!doNotFlushLayout);
  }

  return NS_OK;
}


nsresult nsDocLoader::RemoveChildLoader(nsDocLoader* aChild)
{
  nsresult rv = mChildList.RemoveElement(aChild) ? NS_OK : NS_ERROR_FAILURE;
  if (NS_SUCCEEDED(rv)) {
    rv = aChild->SetDocLoaderParent(nullptr);
  }
  return rv;
}

nsresult nsDocLoader::AddChildLoader(nsDocLoader* aChild)
{
  nsresult rv = mChildList.AppendElement(aChild) ? NS_OK : NS_ERROR_OUT_OF_MEMORY;
  if (NS_SUCCEEDED(rv)) {
    rv = aChild->SetDocLoaderParent(this);
  }
  return rv;
}

NS_IMETHODIMP nsDocLoader::GetDocumentChannel(nsIChannel ** aChannel)
{
  if (!mDocumentRequest) {
    *aChannel = nullptr;
    return NS_OK;
  }

  return CallQueryInterface(mDocumentRequest, aChannel);
}


void nsDocLoader::DocLoaderIsEmpty(bool aFlushLayout)
{
  if (mIsLoadingDocument) {
    /* In the unimagineably rude circumstance that onload event handlers
       triggered by this function actually kill the window ... ok, it's
       not unimagineable; it's happened ... this deathgrip keeps this object
       alive long enough to survive this function call. */
    nsCOMPtr<nsIDocumentLoader> kungFuDeathGrip(this);

    // Don't flush layout if we're still busy.
    if (IsBusy()) {
      return;
    }

    NS_ASSERTION(!mIsFlushingLayout, "Someone screwed up");
    NS_ASSERTION(mDocumentRequest, "No Document Request!");

    // The load group for this DocumentLoader is idle.  Flush if we need to.
    if (aFlushLayout && !mDontFlushLayout) {
      nsCOMPtr<nsIDOMDocument> domDoc = do_GetInterface(GetAsSupports(this));
      nsCOMPtr<nsIDocument> doc = do_QueryInterface(domDoc);
      if (doc) {
        // We start loads from style resolution, so we need to flush out style
        // no matter what.  If we have user fonts, we also need to flush layout,
        // since the reflow is what starts font loads.
        mozFlushType flushType = Flush_Style;
        nsIPresShell* shell = doc->GetShell();
        if (shell) {
          // Be safe in case this presshell is in teardown now
          nsPresContext* presContext = shell->GetPresContext();
          if (presContext && presContext->GetUserFontSet()) {
            flushType = Flush_Layout;
          }
        }
        mDontFlushLayout = mIsFlushingLayout = true;
        doc->FlushPendingNotifications(flushType);
        mDontFlushLayout = mIsFlushingLayout = false;
      }
    }

    // And now check whether we're really busy; that might have changed with
    // the layout flush.
    // Note, mDocumentRequest can be null if the flushing above re-entered this
    // method.
    if (!IsBusy() && mDocumentRequest) {
      // Clear out our request info hash, now that our load really is done and
      // we don't need it anymore to CalculateMaxProgress().
      ClearInternalProgress();

      MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
             ("DocLoader:%p: Is now idle...\n", this));

      nsCOMPtr<nsIRequest> docRequest = mDocumentRequest;

      mDocumentRequest = nullptr;
      mIsLoadingDocument = false;

      // Update the progress status state - the document is done
      mProgressStateFlags = nsIWebProgressListener::STATE_STOP;


      nsresult loadGroupStatus = NS_OK;
      mLoadGroup->GetStatus(&loadGroupStatus);

      //
      // New code to break the circular reference between
      // the load group and the docloader...
      //
      mLoadGroup->SetDefaultLoadRequest(nullptr);

      // Take a ref to our parent now so that we can call DocLoaderIsEmpty() on
      // it even if our onload handler removes us from the docloader tree.
      RefPtr<nsDocLoader> parent = mParent;

      // Note that if calling ChildEnteringOnload() on the parent returns false
      // then calling our onload handler is not safe.  That can only happen on
      // OOM, so that's ok.
      if (!parent || parent->ChildEnteringOnload(this)) {
        // Do nothing with our state after firing the
        // OnEndDocumentLoad(...). The document loader may be loading a *new*
        // document - if LoadDocument() was called from a handler!
        //
        doStopDocumentLoad(docRequest, loadGroupStatus);

        if (parent) {
          parent->ChildDoneWithOnload(this);
        }
      }
    }
  }
}

void nsDocLoader::doStartDocumentLoad(void)
{

#if defined(DEBUG)
  nsAutoCString buffer;

  GetURIStringFromRequest(mDocumentRequest, buffer);
  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: ++ Firing OnStateChange for start document load (...)."
          "\tURI: %s \n",
          this, buffer.get()));
#endif /* DEBUG */

  // Fire an OnStatus(...) notification STATE_START.  This indicates
  // that the document represented by mDocumentRequest has started to
  // load...
  FireOnStateChange(this,
                    mDocumentRequest,
                    nsIWebProgressListener::STATE_START |
                    nsIWebProgressListener::STATE_IS_DOCUMENT |
                    nsIWebProgressListener::STATE_IS_REQUEST |
                    nsIWebProgressListener::STATE_IS_WINDOW |
                    nsIWebProgressListener::STATE_IS_NETWORK,
                    NS_OK);
}

void nsDocLoader::doStartURLLoad(nsIRequest *request)
{
#if defined(DEBUG)
  nsAutoCString buffer;

  GetURIStringFromRequest(request, buffer);
    MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
          ("DocLoader:%p: ++ Firing OnStateChange start url load (...)."
           "\tURI: %s\n",
            this, buffer.get()));
#endif /* DEBUG */

  FireOnStateChange(this,
                    request,
                    nsIWebProgressListener::STATE_START |
                    nsIWebProgressListener::STATE_IS_REQUEST,
                    NS_OK);
}

void nsDocLoader::doStopURLLoad(nsIRequest *request, nsresult aStatus)
{
#if defined(DEBUG)
  nsAutoCString buffer;

  GetURIStringFromRequest(request, buffer);
    MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
          ("DocLoader:%p: ++ Firing OnStateChange for end url load (...)."
           "\tURI: %s status=%x\n",
            this, buffer.get(), aStatus));
#endif /* DEBUG */

  FireOnStateChange(this,
                    request,
                    nsIWebProgressListener::STATE_STOP |
                    nsIWebProgressListener::STATE_IS_REQUEST,
                    aStatus);

  // Fire a status change message for the most recent unfinished
  // request to make sure that the displayed status is not outdated.
  if (!mStatusInfoList.isEmpty()) {
    nsStatusInfo* statusInfo = mStatusInfoList.getFirst();
    FireOnStatusChange(this, statusInfo->mRequest,
                       statusInfo->mStatusCode,
                       statusInfo->mStatusMessage.get());
  }
}

void nsDocLoader::doStopDocumentLoad(nsIRequest *request,
                                         nsresult aStatus)
{
#if defined(DEBUG)
  nsAutoCString buffer;

  GetURIStringFromRequest(request, buffer);
  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: ++ Firing OnStateChange for end document load (...)."
         "\tURI: %s Status=%x\n",
          this, buffer.get(), aStatus));
#endif /* DEBUG */

  // Firing STATE_STOP|STATE_IS_DOCUMENT will fire onload handlers.
  // Grab our parent chain before doing that so we can still dispatch
  // STATE_STOP|STATE_IS_WINDW_STATE_IS_NETWORK to them all, even if
  // the onload handlers rearrange the docshell tree.
  WebProgressList list;
  GatherAncestorWebProgresses(list);

  //
  // Fire an OnStateChange(...) notification indicating the the
  // current document has finished loading...
  //
  int32_t flags = nsIWebProgressListener::STATE_STOP |
                  nsIWebProgressListener::STATE_IS_DOCUMENT;
  for (uint32_t i = 0; i < list.Length(); ++i) {
    list[i]->DoFireOnStateChange(this, request, flags, aStatus);
  }

  //
  // Fire a final OnStateChange(...) notification indicating the the
  // current document has finished loading...
  //
  flags = nsIWebProgressListener::STATE_STOP |
          nsIWebProgressListener::STATE_IS_WINDOW |
          nsIWebProgressListener::STATE_IS_NETWORK;
  for (uint32_t i = 0; i < list.Length(); ++i) {
    list[i]->DoFireOnStateChange(this, request, flags, aStatus);
  }
}

////////////////////////////////////////////////////////////////////////////////////
// The following section contains support for nsIWebProgress and related stuff
////////////////////////////////////////////////////////////////////////////////////

NS_IMETHODIMP
nsDocLoader::AddProgressListener(nsIWebProgressListener *aListener,
                                 uint32_t aNotifyMask)
{
  if (mListenerInfoList.Contains(aListener)) {
    // The listener is already registered!
    return NS_ERROR_FAILURE;
  }

  nsWeakPtr listener = do_GetWeakReference(aListener);
  if (!listener) {
    return NS_ERROR_INVALID_ARG;
  }

  return mListenerInfoList.AppendElement(nsListenerInfo(listener, aNotifyMask)) ?
         NS_OK : NS_ERROR_OUT_OF_MEMORY;
}

NS_IMETHODIMP
nsDocLoader::RemoveProgressListener(nsIWebProgressListener *aListener)
{
  return mListenerInfoList.RemoveElement(aListener) ? NS_OK : NS_ERROR_FAILURE;
}

NS_IMETHODIMP
nsDocLoader::GetDOMWindow(mozIDOMWindowProxy **aResult)
{
  return CallGetInterface(this, aResult);
}

NS_IMETHODIMP
nsDocLoader::GetDOMWindowID(uint64_t *aResult)
{
  *aResult = 0;

  nsCOMPtr<mozIDOMWindowProxy> window;
  nsresult rv = GetDOMWindow(getter_AddRefs(window));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsPIDOMWindowOuter> piwindow = nsPIDOMWindowOuter::From(window);
  NS_ENSURE_STATE(piwindow);

  MOZ_ASSERT(piwindow->IsOuterWindow());
  *aResult = piwindow->WindowID();
  return NS_OK;
}

NS_IMETHODIMP
nsDocLoader::GetIsTopLevel(bool *aResult)
{
  *aResult = false;

  nsCOMPtr<mozIDOMWindowProxy> window;
  GetDOMWindow(getter_AddRefs(window));
  if (window) {
    nsCOMPtr<nsPIDOMWindowOuter> piwindow = nsPIDOMWindowOuter::From(window);
    NS_ENSURE_STATE(piwindow);

    nsCOMPtr<nsPIDOMWindowOuter> topWindow = piwindow->GetTop();
    *aResult = piwindow == topWindow;
  }

  return NS_OK;
}

NS_IMETHODIMP
nsDocLoader::GetIsLoadingDocument(bool *aIsLoadingDocument)
{
  *aIsLoadingDocument = mIsLoadingDocument;

  return NS_OK;
}

NS_IMETHODIMP
nsDocLoader::GetLoadType(uint32_t *aLoadType)
{
  *aLoadType = 0;

  return NS_ERROR_NOT_IMPLEMENTED;
}

int64_t nsDocLoader::GetMaxTotalProgress()
{
  int64_t newMaxTotal = 0;

  uint32_t count = mChildList.Length();
  for (uint32_t i=0; i < count; i++)
  {
    int64_t individualProgress = 0;
    nsIDocumentLoader* docloader = ChildAt(i);
    if (docloader)
    {
      // Cast is safe since all children are nsDocLoader too
      individualProgress = ((nsDocLoader *) docloader)->GetMaxTotalProgress();
    }
    if (individualProgress < int64_t(0)) // if one of the elements doesn't know it's size
                                         // then none of them do
    {
       newMaxTotal = int64_t(-1);
       break;
    }
    else
     newMaxTotal += individualProgress;
  }

  int64_t progress = -1;
  if (mMaxSelfProgress >= int64_t(0) && newMaxTotal >= int64_t(0))
    progress = newMaxTotal + mMaxSelfProgress;

  return progress;
}

////////////////////////////////////////////////////////////////////////////////////
// The following section contains support for nsIProgressEventSink which is used to
// pass progress and status between the actual request and the doc loader. The doc loader
// then turns around and makes the right web progress calls based on this information.
////////////////////////////////////////////////////////////////////////////////////

NS_IMETHODIMP nsDocLoader::OnProgress(nsIRequest *aRequest, nsISupports* ctxt,
                                      int64_t aProgress, int64_t aProgressMax)
{
  int64_t progressDelta = 0;

  //
  // Update the RequestInfo entry with the new progress data
  //
  if (nsRequestInfo* info = GetRequestInfo(aRequest)) {
    // Update info->mCurrentProgress before we call FireOnStateChange,
    // since that can make the "info" pointer invalid.
    int64_t oldCurrentProgress = info->mCurrentProgress;
    progressDelta = aProgress - oldCurrentProgress;
    info->mCurrentProgress = aProgress;

    // suppress sending STATE_TRANSFERRING if this is upload progress (see bug 240053)
    if (!info->mUploading && (int64_t(0) == oldCurrentProgress) && (int64_t(0) == info->mMaxProgress)) {
      //
      // If we receive an OnProgress event from a toplevel channel that the URI Loader
      // has not yet targeted, then we must suppress the event.  This is necessary to
      // ensure that webprogresslisteners do not get confused when the channel is
      // finally targeted.  See bug 257308.
      //
      nsLoadFlags lf = 0;
      aRequest->GetLoadFlags(&lf);
      if ((lf & nsIChannel::LOAD_DOCUMENT_URI) && !(lf & nsIChannel::LOAD_TARGETED)) {
        MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
            ("DocLoader:%p Ignoring OnProgress while load is not targeted\n", this));
        return NS_OK;
      }

      //
      // This is the first progress notification for the entry.  If
      // (aMaxProgress != -1) then the content-length of the data is known,
      // so update mMaxSelfProgress...  Otherwise, set it to -1 to indicate
      // that the content-length is no longer known.
      //
      if (aProgressMax != -1) {
        mMaxSelfProgress  += aProgressMax;
        info->mMaxProgress = aProgressMax;
      } else {
        mMaxSelfProgress   =  int64_t(-1);
        info->mMaxProgress =  int64_t(-1);
      }

      // Send a STATE_TRANSFERRING notification for the request.
      int32_t flags;

      flags = nsIWebProgressListener::STATE_TRANSFERRING |
              nsIWebProgressListener::STATE_IS_REQUEST;
      //
      // Move the WebProgress into the STATE_TRANSFERRING state if necessary...
      //
      if (mProgressStateFlags & nsIWebProgressListener::STATE_START) {
        mProgressStateFlags = nsIWebProgressListener::STATE_TRANSFERRING;

        // Send STATE_TRANSFERRING for the document too...
        flags |= nsIWebProgressListener::STATE_IS_DOCUMENT;
      }

      FireOnStateChange(this, aRequest, flags, NS_OK);
    }

    // Update our overall current progress count.
    mCurrentSelfProgress += progressDelta;
  }
  //
  // The request is not part of the load group, so ignore its progress
  // information...
  //
  else {
#if defined(DEBUG)
    nsAutoCString buffer;

    GetURIStringFromRequest(aRequest, buffer);
    MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
           ("DocLoader:%p OOPS - No Request Info for: %s\n",
            this, buffer.get()));
#endif /* DEBUG */

    return NS_OK;
  }

  //
  // Fire progress notifications out to any registered nsIWebProgressListeners
  //
  FireOnProgressChange(this, aRequest, aProgress, aProgressMax, progressDelta,
                       mCurrentTotalProgress, mMaxTotalProgress);

  return NS_OK;
}

NS_IMETHODIMP nsDocLoader::OnStatus(nsIRequest* aRequest, nsISupports* ctxt,
                                        nsresult aStatus, const char16_t* aStatusArg)
{
  //
  // Fire progress notifications out to any registered nsIWebProgressListeners
  //
  if (aStatus != NS_OK) {
    // Remember the current status for this request
    nsRequestInfo *info;
    info = GetRequestInfo(aRequest);
    if (info) {
      bool uploading = (aStatus == NS_NET_STATUS_WRITING ||
                        aStatus == NS_NET_STATUS_SENDING_TO);
      // If switching from uploading to downloading (or vice versa), then we
      // need to reset our progress counts.  This is designed with HTTP form
      // submission in mind, where an upload is performed followed by download
      // of possibly several documents.
      if (info->mUploading != uploading) {
        mCurrentSelfProgress  = mMaxSelfProgress  = 0;
        mCurrentTotalProgress = mMaxTotalProgress = 0;
        mCompletedTotalProgress = 0;
        info->mUploading = uploading;
        info->mCurrentProgress = 0;
        info->mMaxProgress = 0;
      }
    }

    nsCOMPtr<nsIStringBundleService> sbs =
      mozilla::services::GetStringBundleService();
    if (!sbs)
      return NS_ERROR_FAILURE;
    nsXPIDLString msg;
    nsresult rv = sbs->FormatStatusMessage(aStatus, aStatusArg,
                                           getter_Copies(msg));
    if (NS_FAILED(rv))
      return rv;

    // Keep around the message. In case a request finishes, we need to make sure
    // to send the status message of another request to our user to that we
    // don't display, for example, "Transferring" messages for requests that are
    // already done.
    if (info) {
      if (!info->mLastStatus) {
        info->mLastStatus = new nsStatusInfo(aRequest);
      } else {
        // We're going to move it to the front of the list, so remove
        // it from wherever it is now.
        info->mLastStatus->remove();
      }
      info->mLastStatus->mStatusMessage = msg;
      info->mLastStatus->mStatusCode = aStatus;
      // Put the info at the front of the list
      mStatusInfoList.insertFront(info->mLastStatus);
    }
    FireOnStatusChange(this, aRequest, aStatus, msg);
  }
  return NS_OK;
}

void nsDocLoader::ClearInternalProgress()
{
  ClearRequestInfoHash();

  mCurrentSelfProgress  = mMaxSelfProgress  = 0;
  mCurrentTotalProgress = mMaxTotalProgress = 0;
  mCompletedTotalProgress = 0;

  mProgressStateFlags = nsIWebProgressListener::STATE_STOP;
}

/**
 * |_code| is executed for every listener matching |_flag|
 * |listener| should be used inside |_code| as the nsIWebProgressListener var.
 */
#define NOTIFY_LISTENERS(_flag, _code)                     \
PR_BEGIN_MACRO                                             \
  nsCOMPtr<nsIWebProgressListener> listener;               \
  ListenerArray::BackwardIterator iter(mListenerInfoList); \
  while (iter.HasMore()) {                                 \
    nsListenerInfo &info = iter.GetNext();                 \
    if (!(info.mNotifyMask & (_flag))) {                   \
      continue;                                            \
    }                                                      \
    listener = do_QueryReferent(info.mWeakListener);       \
    if (!listener) {                                       \
      iter.Remove();                                       \
      continue;                                            \
    }                                                      \
    _code                                                  \
  }                                                        \
  mListenerInfoList.Compact();                             \
PR_END_MACRO

void nsDocLoader::FireOnProgressChange(nsDocLoader *aLoadInitiator,
                                       nsIRequest *request,
                                       int64_t aProgress,
                                       int64_t aProgressMax,
                                       int64_t aProgressDelta,
                                       int64_t aTotalProgress,
                                       int64_t aMaxTotalProgress)
{
  if (mIsLoadingDocument) {
    mCurrentTotalProgress += aProgressDelta;
    mMaxTotalProgress = GetMaxTotalProgress();

    aTotalProgress    = mCurrentTotalProgress;
    aMaxTotalProgress = mMaxTotalProgress;
  }

#if defined(DEBUG)
  nsAutoCString buffer;

  GetURIStringFromRequest(request, buffer);
  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: Progress (%s): curSelf: %d maxSelf: %d curTotal: %d maxTotal %d\n",
          this, buffer.get(), aProgress, aProgressMax, aTotalProgress, aMaxTotalProgress));
#endif /* DEBUG */

  NOTIFY_LISTENERS(nsIWebProgress::NOTIFY_PROGRESS,
    // XXX truncates 64-bit to 32-bit
    listener->OnProgressChange(aLoadInitiator,request,
                               int32_t(aProgress), int32_t(aProgressMax),
                               int32_t(aTotalProgress), int32_t(aMaxTotalProgress));
  );

  // Pass the notification up to the parent...
  if (mParent) {
    mParent->FireOnProgressChange(aLoadInitiator, request,
                                  aProgress, aProgressMax,
                                  aProgressDelta,
                                  aTotalProgress, aMaxTotalProgress);
  }
}

void nsDocLoader::GatherAncestorWebProgresses(WebProgressList& aList)
{
  for (nsDocLoader* loader = this; loader; loader = loader->mParent) {
    aList.AppendElement(loader);
  }
}

void nsDocLoader::FireOnStateChange(nsIWebProgress *aProgress,
                                    nsIRequest *aRequest,
                                    int32_t aStateFlags,
                                    nsresult aStatus)
{
  WebProgressList list;
  GatherAncestorWebProgresses(list);
  for (uint32_t i = 0; i < list.Length(); ++i) {
    list[i]->DoFireOnStateChange(aProgress, aRequest, aStateFlags, aStatus);
  }
}

void nsDocLoader::DoFireOnStateChange(nsIWebProgress * const aProgress,
                                      nsIRequest * const aRequest,
                                      int32_t &aStateFlags,
                                      const nsresult aStatus)
{
  //
  // Remove the STATE_IS_NETWORK bit if necessary.
  //
  // The rule is to remove this bit, if the notification has been passed
  // up from a child WebProgress, and the current WebProgress is already
  // active...
  //
  if (mIsLoadingDocument &&
      (aStateFlags & nsIWebProgressListener::STATE_IS_NETWORK) &&
      (this != aProgress)) {
    aStateFlags &= ~nsIWebProgressListener::STATE_IS_NETWORK;
  }

  // Add the STATE_RESTORING bit if necessary.
  if (mIsRestoringDocument)
    aStateFlags |= nsIWebProgressListener::STATE_RESTORING;

#if defined(DEBUG)
  nsAutoCString buffer;

  GetURIStringFromRequest(aRequest, buffer);
  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: Status (%s): code: %x\n",
         this, buffer.get(), aStateFlags));
#endif /* DEBUG */

  NS_ASSERTION(aRequest, "Firing OnStateChange(...) notification with a NULL request!");

  NOTIFY_LISTENERS(((aStateFlags >> 16) & nsIWebProgress::NOTIFY_STATE_ALL),
    listener->OnStateChange(aProgress, aRequest, aStateFlags, aStatus);
  );
}



void
nsDocLoader::FireOnLocationChange(nsIWebProgress* aWebProgress,
                                  nsIRequest* aRequest,
                                  nsIURI *aUri,
                                  uint32_t aFlags)
{
  NOTIFY_LISTENERS(nsIWebProgress::NOTIFY_LOCATION,
    MOZ_LOG(gDocLoaderLog, LogLevel::Debug, ("DocLoader [%p] calling %p->OnLocationChange", this, listener.get()));
    listener->OnLocationChange(aWebProgress, aRequest, aUri, aFlags);
  );

  // Pass the notification up to the parent...
  if (mParent) {
    mParent->FireOnLocationChange(aWebProgress, aRequest, aUri, aFlags);
  }
}

void
nsDocLoader::FireOnStatusChange(nsIWebProgress* aWebProgress,
                                nsIRequest* aRequest,
                                nsresult aStatus,
                                const char16_t* aMessage)
{
  NOTIFY_LISTENERS(nsIWebProgress::NOTIFY_STATUS,
    listener->OnStatusChange(aWebProgress, aRequest, aStatus, aMessage);
  );

  // Pass the notification up to the parent...
  if (mParent) {
    mParent->FireOnStatusChange(aWebProgress, aRequest, aStatus, aMessage);
  }
}

bool
nsDocLoader::RefreshAttempted(nsIWebProgress* aWebProgress,
                              nsIURI *aURI,
                              int32_t aDelay,
                              bool aSameURI)
{
  /*
   * Returns true if the refresh may proceed,
   * false if the refresh should be blocked.
   */
  bool allowRefresh = true;

  NOTIFY_LISTENERS(nsIWebProgress::NOTIFY_REFRESH,
    nsCOMPtr<nsIWebProgressListener2> listener2 =
      do_QueryReferent(info.mWeakListener);
    if (!listener2)
      continue;

    bool listenerAllowedRefresh;
    nsresult listenerRV = listener2->OnRefreshAttempted(
        aWebProgress, aURI, aDelay, aSameURI, &listenerAllowedRefresh);
    if (NS_FAILED(listenerRV))
      continue;

    allowRefresh = allowRefresh && listenerAllowedRefresh;
  );

  // Pass the notification up to the parent...
  if (mParent) {
    allowRefresh = allowRefresh &&
      mParent->RefreshAttempted(aWebProgress, aURI, aDelay, aSameURI);
  }

  return allowRefresh;
}

nsresult nsDocLoader::AddRequestInfo(nsIRequest *aRequest)
{
  if (!mRequestInfoHash.Add(aRequest, mozilla::fallible)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  return NS_OK;
}

void nsDocLoader::RemoveRequestInfo(nsIRequest *aRequest)
{
  mRequestInfoHash.Remove(aRequest);
}

nsDocLoader::nsRequestInfo* nsDocLoader::GetRequestInfo(nsIRequest* aRequest)
{
  return static_cast<nsRequestInfo*>(mRequestInfoHash.Search(aRequest));
}

void nsDocLoader::ClearRequestInfoHash(void)
{
  mRequestInfoHash.Clear();
}

int64_t nsDocLoader::CalculateMaxProgress()
{
  int64_t max = mCompletedTotalProgress;
  for (auto iter = mRequestInfoHash.Iter(); !iter.Done(); iter.Next()) {
    auto info = static_cast<const nsRequestInfo*>(iter.Get());

    if (info->mMaxProgress < info->mCurrentProgress) {
      return int64_t(-1);
    }
    max += info->mMaxProgress;
  }
  return max;
}

NS_IMETHODIMP nsDocLoader::AsyncOnChannelRedirect(nsIChannel *aOldChannel,
                                                  nsIChannel *aNewChannel,
                                                  uint32_t aFlags,
                                                  nsIAsyncVerifyRedirectCallback *cb)
{
  if (aOldChannel)
  {
    nsLoadFlags loadFlags = 0;
    int32_t stateFlags = nsIWebProgressListener::STATE_REDIRECTING |
                         nsIWebProgressListener::STATE_IS_REQUEST;

    aOldChannel->GetLoadFlags(&loadFlags);
    // If the document channel is being redirected, then indicate that the
    // document is being redirected in the notification...
    if (loadFlags & nsIChannel::LOAD_DOCUMENT_URI)
    {
      stateFlags |= nsIWebProgressListener::STATE_IS_DOCUMENT;

#if defined(DEBUG)
      nsCOMPtr<nsIRequest> request(do_QueryInterface(aOldChannel));
      NS_ASSERTION(request == mDocumentRequest, "Wrong Document Channel");
#endif /* DEBUG */
    }

    OnRedirectStateChange(aOldChannel, aNewChannel, aFlags, stateFlags);
    FireOnStateChange(this, aOldChannel, stateFlags, NS_OK);
  }

  cb->OnRedirectVerifyCallback(NS_OK);
  return NS_OK;
}

/*
 * Implementation of nsISecurityEventSink method...
 */

NS_IMETHODIMP nsDocLoader::OnSecurityChange(nsISupports * aContext,
                                            uint32_t aState)
{
  //
  // Fire progress notifications out to any registered nsIWebProgressListeners.
  //

  nsCOMPtr<nsIRequest> request = do_QueryInterface(aContext);
  nsIWebProgress* webProgress = static_cast<nsIWebProgress*>(this);

  NOTIFY_LISTENERS(nsIWebProgress::NOTIFY_SECURITY,
    listener->OnSecurityChange(webProgress, request, aState);
  );

  // Pass the notification up to the parent...
  if (mParent) {
    mParent->OnSecurityChange(aContext, aState);
  }
  return NS_OK;
}

/*
 * Implementation of nsISupportsPriority methods...
 *
 * The priority of the DocLoader _is_ the priority of its LoadGroup.
 *
 * XXX(darin): Once we start storing loadgroups in loadgroups, this code will
 * go away.
 */

NS_IMETHODIMP nsDocLoader::GetPriority(int32_t *aPriority)
{
  nsCOMPtr<nsISupportsPriority> p = do_QueryInterface(mLoadGroup);
  if (p)
    return p->GetPriority(aPriority);

  *aPriority = 0;
  return NS_OK;
}

NS_IMETHODIMP nsDocLoader::SetPriority(int32_t aPriority)
{
  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: SetPriority(%d) called\n", this, aPriority));

  nsCOMPtr<nsISupportsPriority> p = do_QueryInterface(mLoadGroup);
  if (p)
    p->SetPriority(aPriority);

  NS_OBSERVER_ARRAY_NOTIFY_XPCOM_OBSERVERS(mChildList, nsDocLoader,
                                           SetPriority, (aPriority));

  return NS_OK;
}

NS_IMETHODIMP nsDocLoader::AdjustPriority(int32_t aDelta)
{
  MOZ_LOG(gDocLoaderLog, LogLevel::Debug,
         ("DocLoader:%p: AdjustPriority(%d) called\n", this, aDelta));

  nsCOMPtr<nsISupportsPriority> p = do_QueryInterface(mLoadGroup);
  if (p)
    p->AdjustPriority(aDelta);

  NS_OBSERVER_ARRAY_NOTIFY_XPCOM_OBSERVERS(mChildList, nsDocLoader,
                                           AdjustPriority, (aDelta));

  return NS_OK;
}




#if 0
void nsDocLoader::DumpChannelInfo()
{
  nsChannelInfo *info;
  int32_t i, count;
  int32_t current=0, max=0;


  printf("==== DocLoader=%x\n", this);

  count = mChannelInfoList.Count();
  for(i=0; i<count; i++) {
    info = (nsChannelInfo *)mChannelInfoList.ElementAt(i);

#if defined(DEBUG)
    nsAutoCString buffer;
    nsresult rv = NS_OK;
    if (info->mURI) {
      rv = info->mURI->GetSpec(buffer);
    }

    printf("  [%d] current=%d  max=%d [%s]\n", i,
           info->mCurrentProgress,
           info->mMaxProgress, buffer.get());
#endif /* DEBUG */

    current += info->mCurrentProgress;
    if (max >= 0) {
      if (info->mMaxProgress < info->mCurrentProgress) {
        max = -1;
      } else {
        max += info->mMaxProgress;
      }
    }
  }

  printf("\nCurrent=%d   Total=%d\n====\n", current, max);
}
#endif /* 0 */
