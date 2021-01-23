/* vim: set sw=2 ts=8 et tw=80 : */

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_DocumentLoadListener_h
#define mozilla_net_DocumentLoadListener_h

#include "mozilla/MozPromise.h"
#include "mozilla/Variant.h"
#include "mozilla/net/NeckoCommon.h"
#include "mozilla/net/NeckoParent.h"
#include "mozilla/net/PDocumentChannelParent.h"
#include "mozilla/net/ParentChannelListener.h"
#include "mozilla/net/ADocumentChannelBridge.h"
#include "mozilla/dom/SessionHistoryEntry.h"
#include "nsDOMNavigationTiming.h"
#include "nsIInterfaceRequestor.h"
#include "nsIParentChannel.h"
#include "nsIParentRedirectingChannel.h"
#include "nsIRedirectResultListener.h"
#include "nsIMultiPartChannel.h"

#define DOCUMENT_LOAD_LISTENER_IID                   \
  {                                                  \
    0x3b393c56, 0x9e01, 0x11e9, {                    \
      0xa2, 0xa3, 0x2a, 0x2a, 0xe2, 0xdb, 0xcc, 0xe4 \
    }                                                \
  }

namespace mozilla {
namespace dom {
class CanonicalBrowsingContext;
}
namespace net {
using ChildEndpointPromise =
    MozPromise<ipc::Endpoint<extensions::PStreamFilterChild>, bool, true>;

// If we've been asked to attach a stream filter to our channel,
// then we return this promise and defer until we know the final
// content process. At that point we setup Endpoints between
// mStramFilterProcessId and the new content process, and send
// the parent Endpoint to the new process.
// Once we have confirmation of that being bound in the content
// process, we resolve the promise the child Endpoint.
struct StreamFilterRequest {
  StreamFilterRequest() = default;
  StreamFilterRequest(StreamFilterRequest&&) = default;
  ~StreamFilterRequest() {
    if (mPromise) {
      mPromise->Reject(false, __func__);
    }
  }
  RefPtr<ChildEndpointPromise::Private> mPromise;
  base::ProcessId mChildProcessId;
  ipc::Endpoint<extensions::PStreamFilterChild> mChildEndpoint;
};
}  // namespace net
}  // namespace mozilla
MOZ_DECLARE_RELOCATE_USING_MOVE_CONSTRUCTOR(mozilla::net::StreamFilterRequest)

namespace mozilla {
namespace net {

class LoadInfo;

/**
 * DocumentLoadListener represents a connecting document load for a
 * CanonicalBrowsingContext (in the parent process).
 *
 * It creates a network channel for the document load and then waits for it to
 * receive a response (after all redirects are resolved). It then decides where
 * to handle that load (could be in a different process from the initiator),
 * and then sets up a real network nsIChannel to deliver the data to the final
 * destination docshell, maybe through an nsIParentChannel/nsIChildChannel IPDL
 * layer.
 *
 * In the case where this was initiated from an nsDocShell, we also create an
 * nsIChannel to act as a placeholder within the docshell while this process
 * completes, and then notify the docshell of a 'redirect' when we replace this
 * channel with the real one.
 */

// TODO: We currently don't implement nsIProgressEventSink and forward those
// to the child. Should we? We get the interface requested.
class DocumentLoadListener : public nsIInterfaceRequestor,
                             public nsIAsyncVerifyRedirectReadyCallback,
                             public nsIParentChannel,
                             public nsIChannelEventSink,
                             public HttpChannelSecurityWarningReporter,
                             public nsIMultiPartChannelListener {
 public:
  explicit DocumentLoadListener(dom::CanonicalBrowsingContext* aBrowsingContext,
                                ADocumentChannelBridge* aBridge);

  // Creates the channel, and then calls AsyncOpen on it.
  bool Open(nsDocShellLoadState* aLoadState, uint32_t aCacheKey,
            const Maybe<uint64_t>& aChannelId, const TimeStamp& aAsyncOpenTime,
            nsDOMNavigationTiming* aTiming, Maybe<dom::ClientInfo>&& aInfo,
            uint64_t aOuterWindowId, bool aHasGesture, Maybe<bool> aUriModified,
            Maybe<bool> aIsXFOError, nsresult* aRv);

  // Creates a DocumentLoadListener directly in the parent process without
  // an associated DocumentChannelBridge.
  // If successful it registers a unique identifier (return in aOutIdent) to
  // keep it alive until a future bridge can attach to it, or we fail and clean
  // up.
  static bool OpenFromParent(dom::CanonicalBrowsingContext* aBrowsingContext,
                             nsDocShellLoadState* aLoadState,
                             uint64_t aOuterWindowId, uint32_t* aOutIdent);

  // Ensures that a load identifier allocated by OpenFromParent has
  // been deregistered if it hasn't already been claimed.
  // This also cancels the load.
  static void CleanupParentLoadAttempt(uint32_t aLoadIdent);

  // Looks up aLoadIdent to find the associated, cleans up the registration
  // and attaches aBridge as the listener.
  static already_AddRefed<DocumentLoadListener> ClaimParentLoad(
      uint32_t aLoadIdent, ADocumentChannelBridge* aBridge);

  NS_DECL_ISUPPORTS
  NS_DECL_NSIREQUESTOBSERVER
  NS_DECL_NSISTREAMLISTENER
  NS_DECL_NSIPARENTCHANNEL
  NS_DECL_NSIINTERFACEREQUESTOR
  NS_DECL_NSIASYNCVERIFYREDIRECTREADYCALLBACK
  NS_DECL_NSICHANNELEVENTSINK
  NS_DECL_NSIMULTIPARTCHANNELLISTENER

  // We suspend the underlying channel when replacing ourselves with
  // the real listener channel.
  // This helper resumes the underlying channel again, and manually
  // forwards any nsIStreamListener messages that arrived while we
  // were suspended (which might have failed).
  // Returns true if the channel was finished before we could resume it.
  bool ResumeSuspendedChannel(nsIStreamListener* aListener);

  NS_DECLARE_STATIC_IID_ACCESSOR(DOCUMENT_LOAD_LISTENER_IID)

  void Cancel(const nsresult& status);

  nsIChannel* GetChannel() const { return mChannel; }

  nsresult ReportSecurityMessage(const nsAString& aMessageTag,
                                 const nsAString& aMessageCategory) override {
    ReportSecurityMessageParams params;
    params.mMessageTag = aMessageTag;
    params.mMessageCategory = aMessageCategory;
    mSecurityWarningFunctions.AppendElement(
        SecurityWarningFunction{VariantIndex<0>{}, std::move(params)});
    return NS_OK;
  }

  nsresult LogBlockedCORSRequest(const nsAString& aMessage,
                                 const nsACString& aCategory) override {
    LogBlockedCORSRequestParams params;
    params.mMessage = aMessage;
    params.mCategory = aCategory;
    mSecurityWarningFunctions.AppendElement(
        SecurityWarningFunction{VariantIndex<1>{}, std::move(params)});
    return NS_OK;
  }

  nsresult LogMimeTypeMismatch(const nsACString& aMessageName, bool aWarning,
                               const nsAString& aURL,
                               const nsAString& aContentType) override {
    LogMimeTypeMismatchParams params;
    params.mMessageName = aMessageName;
    params.mWarning = aWarning;
    params.mURL = aURL;
    params.mContentType = aContentType;
    mSecurityWarningFunctions.AppendElement(
        SecurityWarningFunction{VariantIndex<2>{}, std::move(params)});
    return NS_OK;
  }

  // Called by the bridge when it disconnects, so that we can drop
  // our reference to it.
  void DocumentChannelBridgeDisconnected();

  void DisconnectChildListeners(nsresult aStatus, nsresult aLoadGroupStatus);

  base::ProcessId OtherPid() const {
    if (mDocumentChannelBridge) {
      return mDocumentChannelBridge->OtherPid();
    }
    if (mPendingDocumentChannelBridgeProcess) {
      return *mPendingDocumentChannelBridgeProcess;
    }
    return 0;
  }

  [[nodiscard]] RefPtr<ChildEndpointPromise> AttachStreamFilter(
      base::ProcessId aChildProcessId);

  using ParentEndpoint = ipc::Endpoint<extensions::PStreamFilterParent>;

  // Serializes all data needed to setup the new replacement channel
  // in the content process into the RedirectToRealChannelArgs struct.
  void SerializeRedirectData(RedirectToRealChannelArgs& aArgs,
                             bool aIsCrossProcess, uint32_t aRedirectFlags,
                             uint32_t aLoadFlags,
                             dom::ContentParent* aParent) const;

 protected:
  DocumentLoadListener(dom::CanonicalBrowsingContext* aBrowsingContext,
                       base::ProcessId aPendingBridgeProcess);
  virtual ~DocumentLoadListener();

  // Called when we were created without a document channel bridge,
  // and now it has been created and attached.
  void NotifyBridgeConnected(ADocumentChannelBridge* aBridge);

  // Called when we were created without a document channel bridge,
  // and creation has failed, and won't ever be attached.
  void NotifyBridgeFailed();

  // Returns a promise that resolves with the document channel bridge,
  // waiting for a pending one if necessary.
  // If we've failed to create a bridge, or a bridge has already been
  // detached then rejects.
  typedef MozPromise<RefPtr<ADocumentChannelBridge>, bool, false>
      EnsureBridgePromise;
  RefPtr<EnsureBridgePromise> EnsureBridge();

  // Initiates the switch from DocumentChannel to the real protocol-specific
  // channel, and ensures that RedirectToRealChannelFinished is called when
  // this is complete.
  void TriggerRedirectToRealChannel(
      const Maybe<uint64_t>& aDestinationProcess = Nothing());

  // Called once the content-process side on setting up a replacement
  // channel is complete. May wait for the new parent channel to
  // finish, and then calls into FinishReplacementChannelSetup.
  void RedirectToRealChannelFinished(nsresult aRv);

  // Completes the replacement of the new channel.
  // This redirects the ParentChannelListener to forward any future
  // messages to the new channel, manually forwards any being held
  // by us, and resumes the underlying source channel.
  void FinishReplacementChannelSetup(nsresult aResult);

  // Called from `OnStartRequest` to make the decision about whether or not to
  // change process. This method will return `nullptr` if the current target
  // process is appropriate.
  // aWillSwitchToRemote is set to true if we initiate a process switch,
  // and that the new remote type will be something other than NOT_REMOTE
  bool MaybeTriggerProcessSwitch(bool* aWillSwitchToRemote);

  // A helper for TriggerRedirectToRealChannel that abstracts over
  // the same-process and cross-process switch cases and returns
  // a single promise to wait on.
  RefPtr<PDocumentChannelParent::RedirectToRealChannelPromise>
  RedirectToRealChannel(uint32_t aRedirectFlags, uint32_t aLoadFlags,
                        const Maybe<uint64_t>& aDestinationProcess,
                        nsTArray<ParentEndpoint>&& aStreamFilterEndpoints);

  // Construct a LoadInfo object to use for the internal channel.
  already_AddRefed<LoadInfo> CreateLoadInfo(
      dom::CanonicalBrowsingContext* aBrowsingContext,
      nsDocShellLoadState* aLoadState, uint64_t aOuterWindowId);

  dom::CanonicalBrowsingContext* GetBrowsingContext();

  void AddURIVisit(nsIChannel* aChannel, uint32_t aLoadFlags);
  bool HasCrossOriginOpenerPolicyMismatch() const;
  void ApplyPendingFunctions(nsISupports* aChannel) const;

  // This defines a variant that describes all the attribute setters (and their
  // parameters) from nsIParentChannel
  //
  // NotifyFlashPluginStateChanged(nsIHttpChannel::FlashPluginState aState) = 0;
  // SetClassifierMatchedInfo(const nsACString& aList, const nsACString&
  // aProvider, const nsACString& aFullHash) = 0;
  // SetClassifierMatchedTrackingInfo(const nsACString& aLists, const
  // nsACString& aFullHashes) = 0; NotifyClassificationFlags(uint32_t
  // aClassificationFlags, bool aIsThirdParty) = 0;
  struct ClassifierMatchedInfoParams {
    nsCString mList;
    nsCString mProvider;
    nsCString mFullHash;
  };

  struct ClassifierMatchedTrackingInfoParams {
    nsCString mLists;
    nsCString mFullHashes;
  };

  struct ClassificationFlagsParams {
    uint32_t mClassificationFlags;
    bool mIsThirdParty;
  };

  typedef mozilla::Variant<
      nsIHttpChannel::FlashPluginState, ClassifierMatchedInfoParams,
      ClassifierMatchedTrackingInfoParams, ClassificationFlagsParams>
      IParentChannelFunction;

  // Store a list of all the attribute setters that have been called on this
  // channel, so that we can repeat them on the real channel that we redirect
  // to.
  nsTArray<IParentChannelFunction> mIParentChannelFunctions;

  // This defines a variant this describes all the functions
  // from HttpChannelSecurityWarningReporter so that we can forward
  // them on to the real channel.

  struct ReportSecurityMessageParams {
    nsString mMessageTag;
    nsString mMessageCategory;
  };

  struct LogBlockedCORSRequestParams {
    nsString mMessage;
    nsCString mCategory;
  };

  struct LogMimeTypeMismatchParams {
    nsCString mMessageName;
    bool mWarning;
    nsString mURL;
    nsString mContentType;
  };

  typedef mozilla::Variant<ReportSecurityMessageParams,
                           LogBlockedCORSRequestParams,
                           LogMimeTypeMismatchParams>
      SecurityWarningFunction;
  nsTArray<SecurityWarningFunction> mSecurityWarningFunctions;

  struct OnStartRequestParams {
    nsCOMPtr<nsIRequest> request;
  };
  struct OnDataAvailableParams {
    nsCOMPtr<nsIRequest> request;
    nsCString data;
    uint64_t offset;
    uint32_t count;
  };
  struct OnStopRequestParams {
    nsCOMPtr<nsIRequest> request;
    nsresult status;
  };
  struct OnAfterLastPartParams {
    nsresult status;
  };
  typedef mozilla::Variant<OnStartRequestParams, OnDataAvailableParams,
                           OnStopRequestParams, OnAfterLastPartParams>
      StreamListenerFunction;
  // TODO Backtrack this.
  // The set of nsIStreamListener functions that got called on this
  // listener, so that we can replay them onto the replacement channel's
  // listener. This should generally only be OnStartRequest, since we
  // Suspend() the channel at that point, but it can fail sometimes
  // so we have to support holding a list.
  nsTArray<StreamListenerFunction> mStreamListenerFunctions;

  nsCOMPtr<nsIChannel> mChannel;

  // An instance of ParentChannelListener that we use as a listener
  // between mChannel (and any future redirected mChannels) and us.
  // This handles service worker interception, and retargetting
  // OnDataAvailable/OnStopRequest messages onto the listener that
  // replaces us.
  RefPtr<ParentChannelListener> mParentChannelListener;

  // The bridge to the nsIChannel in the originating docshell.
  // This reference forms a cycle with the bridge, and we expect
  // the bridge to call DisonnectDocumentChannelBridge when it
  // shuts down to break this.
  RefPtr<ADocumentChannelBridge> mDocumentChannelBridge;

  // If we were created without a bridge, then this is set
  // to Some() with the process id of the content process
  // that will be creating our bridge soon.
  Maybe<base::ProcessId> mPendingDocumentChannelBridgeProcess;

  // Holds a promise for callers that want to wait on the document
  // channel bridge becoming available.
  MozPromiseHolder<EnsureBridgePromise> mBridgePromise;

  // The original URI of the current channel. If there are redirects,
  // then the value on the channel gets overwritten with the original
  // URI of the first channel in the redirect chain, so we cache the
  // value we need here.
  nsCOMPtr<nsIURI> mChannelCreationURI;

  // The original navigation timing information containing various timestamps
  // such as when the original load started.
  // This will be passed back to the new content process should a process
  // switch occurs.
  RefPtr<nsDOMNavigationTiming> mTiming;

  // Used to identify an internal redirect in redirect chain.
  // True when we have seen at least one non-interal redirect.
  bool mHaveVisibleRedirect = false;

  nsTArray<StreamFilterRequest> mStreamFilterRequests;

  nsString mSrcdocData;
  nsCOMPtr<nsIURI> mBaseURI;

  mozilla::UniquePtr<mozilla::dom::SessionHistoryInfoAndId> mSessionHistoryInfo;

  // Flags from nsDocShellLoadState::LoadFlags/Type that we want to make
  // available to the new docshell if we switch processes.
  uint32_t mLoadStateLoadFlags = 0;
  uint32_t mLoadStateLoadType = 0;

  // Corresponding redirect channel registrar Id for the final channel that
  // we want to use when redirecting the child, or doing a process switch.
  // 0 means redirection is not started.
  uint32_t mRedirectChannelId = 0;
  // Set to true once we initiate the redirect to a real channel (either
  // via a process switch or a same-process redirect, and Suspend the
  // underlying channel.
  bool mInitiatedRedirectToRealChannel = false;
  // Set to true if we're currently in the middle of replacing this with
  // a new channel connected a different process.
  bool mDoingProcessSwitch = false;
  // The value of GetApplyConversion on mChannel when OnStartRequest
  // was called. We override it to false to prevent a conversion
  // helper from being installed, but we need to restore the value
  // later.
  bool mOldApplyConversion = false;
  // Set to true if any previous channel that we redirected away
  // from had a COOP mismatch.
  bool mHasCrossOriginOpenerPolicyMismatch = false;
  // Set to true if we've received OnStopRequest, and shouldn't
  // setup a reference from the ParentChannelListener to the replacement
  // channel.
  bool mIsFinished = false;

  // This identifier is set by MaybeTriggerProcessSwitch, and is later
  // passed to the childChannel in order to identify it in the new process.
  uint64_t mCrossProcessRedirectIdentifier = 0;

  // True if cancelled.
  bool mCancelled = false;
};

NS_DEFINE_STATIC_IID_ACCESSOR(DocumentLoadListener, DOCUMENT_LOAD_LISTENER_IID)

inline nsISupports* ToSupports(DocumentLoadListener* aObj) {
  return static_cast<nsIInterfaceRequestor*>(aObj);
}

}  // namespace net
}  // namespace mozilla

#endif  // mozilla_net_DocumentChannelParent_h
