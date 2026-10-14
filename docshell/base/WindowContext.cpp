/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/WindowContext.h"
#include "mozilla/dom/WindowGlobalActorsBinding.h"
#include "mozilla/dom/WindowGlobalChild.h"
#include "mozilla/dom/WindowGlobalParent.h"
#include "mozilla/dom/SyncedContextInlines.h"
#include "mozilla/dom/BrowsingContext.h"
#include "mozilla/dom/CloseWatcherManager.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/UserActivationIPCUtils.h"
#include "mozilla/dom/WorkerCommon.h"
#include "mozilla/PermissionDelegateIPCUtils.h"
#include "mozilla/StaticPrefs_dom.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/ClearOnShutdown.h"
#include "nsGlobalWindowInner.h"
#include "nsIScriptError.h"
#include "nsIWebProgressListener.h"
#include "nsIXULRuntime.h"
#include "nsPIDOMWindowInlines.h"
#include "nsRFPTargetSetIDL.h"
#include "nsRefPtrHashtable.h"
#include "nsContentUtils.h"

namespace mozilla {
namespace dom {

// Explicit specialization of the `Transaction` type. Required by the `extern
// template class` declaration in the header.
template class syncedcontext::Transaction<WindowContext>;

static LazyLogModule gWindowContextLog("WindowContext");
static LazyLogModule gWindowContextSyncLog("WindowContextSync");

extern mozilla::LazyLogModule gUserInteractionPRLog;

#define USER_ACTIVATION_LOG(msg, ...) \
  MOZ_LOG(gUserInteractionPRLog, LogLevel::Debug, (msg, ##__VA_ARGS__))

using WindowContextByIdMap = nsTHashMap<nsUint64HashKey, WindowContext*>;
static StaticAutoPtr<WindowContextByIdMap> gWindowContexts;

/* static */
LogModule* WindowContext::GetLog() { return gWindowContextLog; }

/* static */
LogModule* WindowContext::GetSyncLog() { return gWindowContextSyncLog; }

/* static */
already_AddRefed<WindowContext> WindowContext::GetById(
    uint64_t aInnerWindowId) {
  if (!gWindowContexts) {
    return nullptr;
  }
  return do_AddRef(gWindowContexts->Get(aInnerWindowId));
}

BrowsingContextGroup* WindowContext::Group() const {
  return mBrowsingContext->Group();
}

WindowGlobalParent* WindowContext::Canonical() {
  MOZ_RELEASE_ASSERT(XRE_IsParentProcess());
  return static_cast<WindowGlobalParent*>(this);
}

bool WindowContext::IsCurrent() const {
  return mBrowsingContext->mCurrentWindowContext == this;
}

bool WindowContext::IsInBFCache() { return mBrowsingContext->IsInBFCache(); }

already_AddRefed<nsIRFPTargetSetIDL>
WindowContext::GetOverriddenFingerprintingSettingsWebIDL() const {
  Maybe<RFPTargetSet> overriddenFingerprintingSettings =
      GetOverriddenFingerprintingSettings();
  if (overriddenFingerprintingSettings.isNothing()) {
    return nullptr;
  }

  return MakeAndAddRef<nsRFPTargetSetIDL>(
      overriddenFingerprintingSettings.ref());
}

nsGlobalWindowInner* WindowContext::GetInnerWindow() const {
  return mWindowGlobalChild ? mWindowGlobalChild->GetWindowGlobal() : nullptr;
}

Document* WindowContext::GetDocument() const {
  nsGlobalWindowInner* innerWindow = GetInnerWindow();
  return innerWindow ? innerWindow->GetDocument() : nullptr;
}

Document* WindowContext::GetExtantDoc() const {
  nsGlobalWindowInner* innerWindow = GetInnerWindow();
  return innerWindow ? innerWindow->GetExtantDoc() : nullptr;
}

WindowGlobalChild* WindowContext::GetWindowGlobalChild() const {
  return mWindowGlobalChild;
}

WindowContext* WindowContext::GetParentWindowContext() {
  return mBrowsingContext->GetParentWindowContext();
}

WindowContext* WindowContext::TopWindowContext() {
  WindowContext* current = this;
  while (current->GetParentWindowContext()) {
    current = current->GetParentWindowContext();
  }
  return current;
}

bool WindowContext::IsTop() const { return mBrowsingContext->IsTop(); }

bool WindowContext::SameOriginWithTop() const {
  return mBrowsingContext->SameOriginWithTop();
}

nsIGlobalObject* WindowContext::GetParentObject() const {
  return xpc::NativeGlobal(xpc::PrivilegedJunkScope());
}

void WindowContext::AppendChildBrowsingContext(
    BrowsingContext* aBrowsingContext) {
  MOZ_DIAGNOSTIC_ASSERT(Group() == aBrowsingContext->Group(),
                        "Mismatched groups?");
  MOZ_DIAGNOSTIC_ASSERT(!mChildren.Contains(aBrowsingContext));

  ClearLightDOMChildren();

  mChildren.AppendElement(aBrowsingContext);
  if (!aBrowsingContext->IsEmbedderTypeObjectOrEmbed()) {
    mNonSyntheticChildren.AppendElement(aBrowsingContext);
  }

  // If we're the current WindowContext in our BrowsingContext, make sure to
  // clear any cached `children` value.
  if (IsCurrent()) {
    BrowsingContext_Binding::ClearCachedChildrenValue(mBrowsingContext);
  }
}

void WindowContext::RemoveChildBrowsingContext(
    BrowsingContext* aBrowsingContext) {
  MOZ_DIAGNOSTIC_ASSERT(Group() == aBrowsingContext->Group(),
                        "Mismatched groups?");
  ClearLightDOMChildren();

  mChildren.RemoveElement(aBrowsingContext);
  mNonSyntheticChildren.RemoveElement(aBrowsingContext);

  // If we're the current WindowContext in our BrowsingContext, make sure to
  // clear any cached `children` value.
  if (IsCurrent()) {
    BrowsingContext_Binding::ClearCachedChildrenValue(mBrowsingContext);
  }
}

void WindowContext::UpdateChildSynthetic(BrowsingContext* aBrowsingContext,
                                         bool aIsSynthetic) {
  if (aIsSynthetic) {
    mNonSyntheticChildren.RemoveElement(aBrowsingContext);
  } else {
    // The same BrowsingContext will be reused for error pages, so it can be in
    // the list already.
    if (!mNonSyntheticChildren.Contains(aBrowsingContext)) {
      mNonSyntheticChildren.AppendElement(aBrowsingContext);
    }
  }
}

void WindowContext::ClearLightDOMChildren() {
  mNonSyntheticLightDOMChildren.reset();
}

void WindowContext::EnsureLightDOMChildren() {
  if (mNonSyntheticLightDOMChildren.isSome()) {
    return;
  }
  mNonSyntheticLightDOMChildren.emplace();

  for (const RefPtr<BrowsingContext>& bc : mNonSyntheticChildren) {
    if (Element* el = bc->GetEmbedderElement(); el && el->IsInShadowTree()) {
      continue;
    }
    mNonSyntheticLightDOMChildren->AppendElement(bc);
  }
}

BrowsingContext* WindowContext::NonSyntheticLightDOMChildAt(uint32_t aIndex) {
  EnsureLightDOMChildren();
  return aIndex < mNonSyntheticLightDOMChildren->Length()
             ? mNonSyntheticLightDOMChildren->ElementAt(aIndex).get()
             : nullptr;
}

uint32_t WindowContext::NonSyntheticLightDOMChildrenCount() {
  EnsureLightDOMChildren();
  return mNonSyntheticLightDOMChildren->Length();
}

void WindowContext::SendCommitTransaction(ContentParent* aParent,
                                          const BaseTransaction& aTxn,
                                          uint64_t aEpoch) {
  (void)aParent->SendCommitWindowContextTransaction(this, aTxn, aEpoch);
}

void WindowContext::SendCommitTransaction(ContentChild* aChild,
                                          const BaseTransaction& aTxn,
                                          uint64_t aEpoch) {
  aChild->SendCommitWindowContextTransaction(this, aTxn, aEpoch);
}

bool WindowContext::CheckOnlyOwningProcessCanSet(ContentParent* aSource) {
  if (IsInProcess()) {
    return true;
  }

  if (XRE_IsParentProcess() && aSource) {
    return Canonical()->GetContentParent() == aSource;
  }

  return false;
}

void WindowContext::DidSet(FieldIndex<IDX_AllowJavascript>, bool aOldValue) {
  RecomputeCanExecuteScripts();
}

void WindowContext::ProcessCloseRequest() {
  MOZ_ASSERT(XRE_IsParentProcess(), "Window must be Global Parent");
  BrowsingContext* top = mBrowsingContext->Top();
  top->PreOrderWalk([&](BrowsingContext* aBrowsingContext) {
    CanonicalBrowsingContext* canonical = aBrowsingContext->Canonical();
    if (WindowGlobalParent* parent = canonical->GetCurrentWindowGlobal()) {
      (void)parent->SendProcessCloseRequest(aBrowsingContext);
    }
  });
}

void WindowContext::RecomputeCanExecuteScripts(bool aApplyChanges) {
  const bool old = mCanExecuteScripts;
  if (!AllowJavascript()) {
    // Scripting has been explicitly disabled on our WindowContext.
    mCanExecuteScripts = false;
  } else {
    // Otherwise, inherit.
    mCanExecuteScripts = mBrowsingContext->CanExecuteScripts();
  }

  if (aApplyChanges && old != mCanExecuteScripts) {
    // Inform our active DOM window.
    if (nsGlobalWindowInner* window = GetInnerWindow()) {
      // Only update scriptability if the window is current. Windows will have
      // scriptability disabled when entering the bfcache and updated when
      // coming out.
      if (window->IsCurrentInnerWindow()) {
        auto& scriptability =
            xpc::Scriptability::Get(window->GetGlobalJSObject());
        scriptability.SetWindowAllowsScript(mCanExecuteScripts);
      }
    }

    for (const RefPtr<BrowsingContext>& child : Children()) {
      child->RecomputeCanExecuteScripts();
    }
  }
}

void WindowContext::DidSet(FieldIndex<IDX_SHEntryHasUserInteraction>,
                           bool aOldValue) {
  MOZ_ASSERT(
      TopWindowContext() == this,
      "SHEntryHasUserInteraction can only be set on the top window context");
  // This field is set when the child notifies us of new user interaction, so we
  // also set the currently active shentry in the parent as having interaction.
  if (XRE_IsParentProcess() && mBrowsingContext) {
    SessionHistoryEntry* activeEntry =
        mBrowsingContext->Canonical()->GetActiveSessionHistoryEntry();
    if (activeEntry && GetSHEntryHasUserInteraction()) {
      activeEntry->SetHasUserInteraction(true);
    }
  }
}

void WindowContext::DidSet(FieldIndex<IDX_HasActivePeerConnections>,
                           bool aOldValue) {
  MOZ_ASSERT(
      TopWindowContext() == this,
      "IDX_HasActivePeerConnections can only be set on the top window context");

  BrowsingContext* top = mBrowsingContext->Top();

  top->PreOrderWalk([&](BrowsingContext* aBrowsingContext) {
    WindowContext* windowContext = aBrowsingContext->GetCurrentWindowContext();
    if (windowContext) {
      auto* win{windowContext->GetInnerWindow()};
      if (win && (aOldValue != win->HasActivePeerConnections())) {
        dom::UpdateWorkersPeerConnections(*win,
                                          win->HasActivePeerConnections());
      }
    }
  });
}

void WindowContext::DidSet(FieldIndex<IDX_UserActivationStateAndModifiers>) {
  MOZ_ASSERT_IF(!IsInProcess(), mLastActivationTimestamp.IsNull());
  USER_ACTIVATION_LOG("Set user gesture activation 0x%02" PRIu8
                      " for %s browsing context 0x%08" PRIx64,
                      GetUserActivationStateAndModifiers(),
                      XRE_IsParentProcess() ? "Parent" : "Child", Id());
  if (IsInProcess()) {
    USER_ACTIVATION_LOG(
        "Set user gesture start time for %s browsing context 0x%08" PRIx64,
        XRE_IsParentProcess() ? "Parent" : "Child", Id());
    if (GetUserActivationState() == UserActivation::State::FullActivated) {
      mLastActivationTimestamp = TimeStamp::Now();
    } else if (GetUserActivationState() == UserActivation::State::None) {
      mLastActivationTimestamp = TimeStamp();
    }
  }
}

void WindowContext::DidSet(FieldIndex<IDX_HasReportedShadowDOMUsage>,
                           bool aOldValue) {
  if (!aOldValue && GetHasReportedShadowDOMUsage() && IsInProcess()) {
    MOZ_ASSERT(TopWindowContext() == this);
    if (mBrowsingContext) {
      Document* topLevelDoc = mBrowsingContext->GetDocument();
      if (topLevelDoc) {
        nsAutoString uri;
        (void)topLevelDoc->GetDocumentURI(uri);
        if (!uri.IsEmpty()) {
          nsAutoString msg = u"Shadow DOM used in ["_ns + uri +
                             u"] or in some of its subdocuments."_ns;
          nsContentUtils::ReportToConsoleNonLocalized(
              msg, nsIScriptError::infoFlag, "DOM"_ns, topLevelDoc);
        }
      }
    }
  }
}

void WindowContext::CreateFromIPC(IPCInitializer&& aInit) {
  MOZ_RELEASE_ASSERT(XRE_IsContentProcess(),
                     "Should be a WindowGlobalParent in the parent");

  RefPtr<BrowsingContext> bc = BrowsingContext::Get(aInit.mBrowsingContextId);
  MOZ_RELEASE_ASSERT(bc);

  if (bc->IsDiscarded()) {
    // If we have already closed our browsing context, the
    // WindowGlobalChild actor is bound to be destroyed soon and it's
    // safe to ignore creating the WindowContext.
    return;
  }

  RefPtr<WindowContext> context = new WindowContext(
      bc, aInit.mInnerWindowId, aInit.mOuterWindowId, std::move(aInit.mFields));
  context->Init();
}

void WindowContext::Init() {
  MOZ_LOG(GetLog(), LogLevel::Debug,
          ("Registering 0x%" PRIx64 " (bc=0x%" PRIx64 ")", mInnerWindowId,
           mBrowsingContext->Id()));

  // Register the WindowContext in the `WindowContextByIdMap`.
  if (!gWindowContexts) {
    gWindowContexts = new WindowContextByIdMap();
    ClearOnShutdown(&gWindowContexts);
  }
  auto& entry = gWindowContexts->LookupOrInsert(mInnerWindowId);
  MOZ_RELEASE_ASSERT(!entry, "Duplicate WindowContext for ID!");
  entry = this;

  // Register this to the browsing context.
  mBrowsingContext->RegisterWindowContext(this);
  Group()->Register(this);
}

void WindowContext::Discard() {
  MOZ_LOG(GetLog(), LogLevel::Debug,
          ("Discarding 0x%" PRIx64 " (bc=0x%" PRIx64 ")", mInnerWindowId,
           mBrowsingContext->Id()));
  if (mIsDiscarded) {
    return;
  }

  mIsDiscarded = true;
  if (gWindowContexts) {
    gWindowContexts->Remove(InnerWindowId());
  }
  mBrowsingContext->UnregisterWindowContext(this);
  Group()->Unregister(this);
}

void WindowContext::AddSecurityState(uint32_t aStateFlags) {
  MOZ_ASSERT(TopWindowContext() == this);
  MOZ_ASSERT((aStateFlags &
              (nsIWebProgressListener::STATE_LOADED_MIXED_DISPLAY_CONTENT |
               nsIWebProgressListener::STATE_LOADED_MIXED_ACTIVE_CONTENT |
               nsIWebProgressListener::STATE_BLOCKED_MIXED_DISPLAY_CONTENT |
               nsIWebProgressListener::STATE_BLOCKED_MIXED_ACTIVE_CONTENT |
               nsIWebProgressListener::STATE_HTTPS_ONLY_MODE_UPGRADED |
               nsIWebProgressListener::STATE_HTTPS_ONLY_MODE_UPGRADE_FAILED |
               nsIWebProgressListener::STATE_HTTPS_ONLY_MODE_UPGRADED_FIRST)) ==
                 aStateFlags,
             "Invalid flags specified!");

  if (XRE_IsParentProcess()) {
    Canonical()->AddSecurityState(aStateFlags);
  } else {
    ContentChild* child = ContentChild::GetSingleton();
    child->SendAddSecurityState(this, aStateFlags);
  }
}

void WindowContext::NotifyUserGestureActivation(
    UserActivation::Modifiers
        aModifiers /* = UserActivation::Modifiers::None() */) {
  UserActivation::StateAndModifiers stateAndModifiers;
  stateAndModifiers.SetState(UserActivation::State::FullActivated);
  stateAndModifiers.SetModifiers(aModifiers);
  if (auto* innerWindow = GetInnerWindow()) {
    innerWindow->EnsureCloseWatcherManager()->NotifyUserInteraction();
  }
  (void)SetUserActivationStateAndModifiers(stateAndModifiers.GetRawData());
}

void WindowContext::NotifyResetUserGestureActivation() {
  UserActivation::StateAndModifiers stateAndModifiers;
  stateAndModifiers.SetState(UserActivation::State::None);
  (void)SetUserActivationStateAndModifiers(stateAndModifiers.GetRawData());
}

bool WindowContext::HasBeenUserGestureActivated() {
  return GetUserActivationState() != UserActivation::State::None;
}

const TimeStamp& WindowContext::GetUserGestureStart() const {
  MOZ_ASSERT(IsInProcess());
  return mLastActivationTimestamp;
}

// https://html.spec.whatwg.org/#transient-activation
bool WindowContext::HasValidTransientUserGestureActivation() {
  MOZ_ASSERT(IsInProcess());

  if (GetUserActivationState() != UserActivation::State::FullActivated) {
    // mLastActivationTimestamp should be null if the document hasn't ever been
    // activated by user gesture
    MOZ_ASSERT_IF(GetUserActivationState() == UserActivation::State::None,
                  mLastActivationTimestamp.IsNull());
    return false;
  }

  MOZ_ASSERT(
      !mLastActivationTimestamp.IsNull(),
      "mLastActivationTimestamp shouldn't be null if the document has ever "
      "been activated by user gesture");

  TimeDuration timeout = TimeDuration::FromMilliseconds(
      StaticPrefs::dom_user_activation_transient_timeout());

  // "When the current high resolution time given W is greater than or equal to
  // the last activation timestamp in W, and less than the last activation
  // timestamp in W plus the transient activation duration, then W is said to
  // have transient activation."
  return timeout <= TimeDuration() ||
         (TimeStamp::Now() - mLastActivationTimestamp) <= timeout;
}

template <typename F>
static void ConsumeUserGestureActivationBetweenPiP(BrowsingContext* aTop,
                                                   F&& aCallback) {
  // https://wicg.github.io/document-picture-in-picture/#user-activation-propagation
  // Monkey patch to consume user activation
  if (aTop->GetIsDocumentPiP()) {
    // 4. If top is a PIP window, then extend navigables with the opener
    // window's inclusive decendant navigables
    RefPtr<BrowsingContext> opener = aTop->GetOpener();
    if (!opener) {
      return;
    }
    opener->GetBrowsingContext()->PreOrderWalk(aCallback);
  } else {
    // 5. Get top-level navigable's last opened PiP window
    nsGlobalWindowInner* pip = aTop->GetOpenedDocumentPiPWindow();
    if (!pip) {
      return;
    }

    // 6. Extend navigables with the inclusive descendant navigables of the PIP
    // window.
    BrowsingContext* pipBC = pip->GetBrowsingContext();
    NS_ENSURE_TRUE_VOID(pipBC);
    WindowContext* pipWC = pipBC->GetCurrentWindowContext();
    NS_ENSURE_TRUE_VOID(pipWC);
    pipBC->PreOrderWalk(aCallback);
  }
}

// https://html.spec.whatwg.org/#consume-user-activation
bool WindowContext::ConsumeTransientUserGestureActivation() {
  MOZ_ASSERT(IsInProcess());
  // 1. If W's navigable is null, then return.
  if (!IsCurrent()) {
    return false;
  }

  if (!HasValidTransientUserGestureActivation()) {
    return false;
  }

  // 2. Let top be W's navigable's top-level traversable.
  BrowsingContext* top = mBrowsingContext->Top();

  // 3. Let navigables be the inclusive descendant navigables of top's active
  // document.
  auto callback = [&](BrowsingContext* aBrowsingContext) {
    // 4. Let windows be the list of Window objects constructed by taking the
    // active window of each item in navigables.
    WindowContext* windowContext = aBrowsingContext->GetCurrentWindowContext();

    // 5. For each window in windows, if window's last activation timestamp is
    // not positive infinity, then set window's last activation timestamp to
    // negative infinity.
    if (windowContext && windowContext->GetUserActivationState() ==
                             UserActivation::State::FullActivated) {
      auto stateAndModifiers = UserActivation::StateAndModifiers(
          GetUserActivationStateAndModifiers());
      // Setting UserActivationStateAndModifiers will trigger
      // DidSet(FieldIndex<IDX_UserActivationStateAndModifiers>),
      // which in turn updates mLastActivationTimestamp.
      stateAndModifiers.SetState(UserActivation::State::HasBeenActivated);
      (void)windowContext->SetUserActivationStateAndModifiers(
          stateAndModifiers.GetRawData());
    }
  };
  top->PreOrderWalk(callback);

  ConsumeUserGestureActivationBetweenPiP(top, callback);

  return true;
}

// https://html.spec.whatwg.org/multipage/interaction.html#history-action-activation
bool WindowContext::HasValidHistoryActivation() const {
  MOZ_ASSERT(IsInProcess());
  return mHistoryActivation != mLastActivationTimestamp;
}

// https://html.spec.whatwg.org/multipage/interaction.html#consume-history-action-user-activation
// Step 1-2
void WindowContext::ConsumeHistoryActivation() {
  MOZ_ASSERT(IsInProcess());

  // 1. If W's navigable is null, then return.

  // 2. Let top be W's navigable's top-level traversable.
  RefPtr<BrowsingContext> top = mBrowsingContext->Top();

  // Consuming a history activation must happen across all child processes,
  // including for example cross-origin iframes. As such we need to send an
  // message over the IPC boundary to ensure out of processes contexts also
  // consume their activations.
  MOZ_ASSERT(XRE_IsContentProcess());
  ContentChild::GetSingleton()->SendConsumeHistoryActivation(top);

  // Update the local process children immediately.
  top->ConsumeHistoryActivation();
}

void WindowContext::UpdateLastHistoryActivation() {
  mHistoryActivation = mLastActivationTimestamp;
}

bool WindowContext::GetTransientUserGestureActivationModifiers(
    UserActivation::Modifiers* aModifiers) {
  if (!HasValidTransientUserGestureActivation()) {
    return false;
  }

  auto stateAndModifiers =
      UserActivation::StateAndModifiers(GetUserActivationStateAndModifiers());
  *aModifiers = stateAndModifiers.GetModifiers();
  return true;
}

bool WindowContext::CanShowPopup() {
  uint32_t permit = GetPopupPermission();
  if (permit == nsIPermissionManager::ALLOW_ACTION) {
    return true;
  }
  if (permit == nsIPermissionManager::DENY_ACTION) {
    return false;
  }

  return !StaticPrefs::dom_disable_open_during_load();
}

bool WindowContext::CanFramebust() {
  uint32_t permit = GetPopupPermission();
  if (permit == nsIPermissionManager::ALLOW_ACTION) {
    return true;
  }
  if (permit == nsIPermissionManager::DENY_ACTION) {
    return false;
  }

  return !StaticPrefs::dom_security_framebusting_intervention_enabled();
}

void WindowContext::TransientSetHasActivePeerConnections() {
  if (!IsTop()) {
    return;
  }

  mFields.SetWithoutSyncing<IDX_HasActivePeerConnections>(true);
}

WindowContext::IPCInitializer WindowContext::GetIPCInitializer() {
  IPCInitializer init;
  init.mInnerWindowId = mInnerWindowId;
  init.mOuterWindowId = mOuterWindowId;
  init.mBrowsingContextId = mBrowsingContext->Id();
  init.mFields = mFields.RawValues();
  return init;
}

WindowContext::WindowContext(BrowsingContext* aBrowsingContext,
                             uint64_t aInnerWindowId, uint64_t aOuterWindowId,
                             FieldValues&& aInit)
    : mFields(std::move(aInit)),
      mInnerWindowId(aInnerWindowId),
      mOuterWindowId(aOuterWindowId),
      mBrowsingContext(aBrowsingContext) {
  MOZ_ASSERT(mBrowsingContext);
  MOZ_ASSERT(mInnerWindowId);
  MOZ_ASSERT(mOuterWindowId);
  RecomputeCanExecuteScripts(/* aApplyChanges */ false);
}

WindowContext::~WindowContext() {
  if (gWindowContexts) {
    gWindowContexts->Remove(InnerWindowId());
  }
}

JSObject* WindowContext::WrapObject(JSContext* cx,
                                    JS::Handle<JSObject*> aGivenProto) {
  return WindowContext_Binding::Wrap(cx, this, aGivenProto);
}

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(WindowContext)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(WindowContext)
NS_IMPL_CYCLE_COLLECTING_RELEASE(WindowContext)

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE_CLASS(WindowContext)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(WindowContext)
  if (gWindowContexts) {
    gWindowContexts->Remove(tmp->InnerWindowId());
  }

  NS_IMPL_CYCLE_COLLECTION_UNLINK(mBrowsingContext)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mChildren)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mNonSyntheticChildren)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mNonSyntheticLightDOMChildren);
  NS_IMPL_CYCLE_COLLECTION_UNLINK_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(WindowContext)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mBrowsingContext)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mChildren)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mNonSyntheticChildren)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mNonSyntheticLightDOMChildren)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

}  // namespace dom
}  // namespace mozilla

namespace IPC {

using mozilla::dom::MaybeDiscarded;
using mozilla::dom::WindowContext;

void ParamTraits<MaybeDiscarded<WindowContext>>::Write(
    MessageWriter* aWriter, const MaybeDiscarded<WindowContext>& aParam) {
  uint64_t id = aParam.ContextId();
  WriteParam(aWriter, id);
}

bool ParamTraits<MaybeDiscarded<WindowContext>>::Read(
    MessageReader* aReader, MaybeDiscarded<WindowContext>* aResult) {
  uint64_t id = 0;
  if (!ReadParam(aReader, &id)) {
    return false;
  }

  if (id == 0) {
    *aResult = nullptr;
  } else if (RefPtr<WindowContext> wc = WindowContext::GetById(id)) {
    if (!wc->Group()->IsKnownForMessageReader(aReader)) {
      return false;
    }

    *aResult = std::move(wc);
  } else {
    aResult->SetDiscarded(id);
  }
  return true;
}

void ParamTraits<WindowContext::IPCInitializer>::Write(
    MessageWriter* aWriter, const WindowContext::IPCInitializer& aInit) {
  // Write actor ID parameters.
  WriteParam(aWriter, aInit.mInnerWindowId);
  WriteParam(aWriter, aInit.mOuterWindowId);
  WriteParam(aWriter, aInit.mBrowsingContextId);
  WriteParam(aWriter, aInit.mFields);
}

bool ParamTraits<WindowContext::IPCInitializer>::Read(
    MessageReader* aReader, WindowContext::IPCInitializer* aInit) {
  // Read actor ID parameters.
  return ReadParam(aReader, &aInit->mInnerWindowId) &&
         ReadParam(aReader, &aInit->mOuterWindowId) &&
         ReadParam(aReader, &aInit->mBrowsingContextId) &&
         ReadParam(aReader, &aInit->mFields);
}

template struct ParamTraits<WindowContext::BaseTransaction>;

}  // namespace IPC
