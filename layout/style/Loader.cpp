/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* loading of CSS style sheets using the network APIs */

#include "mozilla/css/Loader.h"

#include "mozilla/ArrayUtils.h"
#include "mozilla/dom/DocGroup.h"
#include "mozilla/dom/SRILogHelper.h"
#include "mozilla/IntegerPrintfMacros.h"
#include "mozilla/AutoRestore.h"
#include "mozilla/LoadInfo.h"
#include "mozilla/Logging.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/PreloadHashKey.h"
#include "mozilla/ResultExtensions.h"
#include "mozilla/SchedulerGroup.h"
#include "mozilla/URLPreloader.h"
#include "nsIRunnable.h"
#include "nsITimedChannel.h"
#include "nsSyncLoadService.h"
#include "nsCOMPtr.h"
#include "nsString.h"
#include "nsIContent.h"
#include "nsIContentInlines.h"
#include "mozilla/dom/Document.h"
#include "nsIURI.h"
#include "nsNetUtil.h"
#include "nsContentUtils.h"
#include "nsIScriptSecurityManager.h"
#include "nsContentPolicyUtils.h"
#include "nsIHttpChannel.h"
#include "nsIHttpChannelInternal.h"
#include "nsIClassOfService.h"
#include "nsIScriptError.h"
#include "nsMimeTypes.h"
#include "nsICSSLoaderObserver.h"
#include "nsThreadUtils.h"
#include "nsGkAtoms.h"
#include "nsIThreadInternal.h"
#include "nsINetworkPredictor.h"
#include "nsStringStream.h"
#include "mozilla/dom/MediaList.h"
#include "mozilla/dom/ShadowRoot.h"
#include "mozilla/dom/URL.h"
#include "mozilla/net/UrlClassifierFeatureFactory.h"
#include "mozilla/AsyncEventDispatcher.h"
#include "mozilla/ServoBindings.h"
#include "mozilla/StyleSheet.h"
#include "mozilla/StyleSheetInlines.h"
#include "mozilla/ConsoleReportCollector.h"
#include "mozilla/ServoUtils.h"
#include "mozilla/css/StreamLoader.h"
#include "ReferrerInfo.h"

#ifdef MOZ_XUL
#  include "nsXULPrototypeCache.h"
#endif

#include "nsError.h"

#include "mozilla/dom/SRICheck.h"

#include "mozilla/Encoding.h"

using namespace mozilla::dom;

// 1024 bytes is specified in https://drafts.csswg.org/css-syntax/
#define SNIFFING_BUFFER_SIZE 1024

/**
 * OVERALL ARCHITECTURE
 *
 * The CSS Loader gets requests to load various sorts of style sheets:
 * inline style from <style> elements, linked style, @import-ed child
 * sheets, non-document sheets.  The loader handles the following tasks:
 * 1) Creation of the actual style sheet objects: CreateSheet()
 * 2) setting of the right media, title, enabled state, etc on the
 *    sheet: PrepareSheet()
 * 3) Insertion of the sheet in the proper cascade order:
 *    InsertSheetInTree() and InsertChildSheet()
 * 4) Load of the sheet: LoadSheet() including security checks
 * 5) Parsing of the sheet: ParseSheet()
 * 6) Cleanup: SheetComplete()
 *
 * The detailed documentation for these functions is found with the
 * function implementations.
 *
 * The following helper object is used:
 *    SheetLoadData -- a small class that is used to store all the
 *                     information needed for the loading of a sheet;
 *                     this class handles listening for the stream
 *                     loader completion and also handles charset
 *                     determination.
 */

static mozilla::LazyLogModule sCssLoaderLog("nsCSSLoader");

static mozilla::LazyLogModule gSriPRLog("SRI");

#define LOG_ERROR(args) MOZ_LOG(sCssLoaderLog, mozilla::LogLevel::Error, args)
#define LOG_WARN(args) MOZ_LOG(sCssLoaderLog, mozilla::LogLevel::Warning, args)
#define LOG_DEBUG(args) MOZ_LOG(sCssLoaderLog, mozilla::LogLevel::Debug, args)
#define LOG(args) LOG_DEBUG(args)

#define LOG_ERROR_ENABLED() \
  MOZ_LOG_TEST(sCssLoaderLog, mozilla::LogLevel::Error)
#define LOG_WARN_ENABLED() \
  MOZ_LOG_TEST(sCssLoaderLog, mozilla::LogLevel::Warning)
#define LOG_DEBUG_ENABLED() \
  MOZ_LOG_TEST(sCssLoaderLog, mozilla::LogLevel::Debug)
#define LOG_ENABLED() LOG_DEBUG_ENABLED()

#define LOG_URI(format, uri)                      \
  PR_BEGIN_MACRO                                  \
  NS_ASSERTION(uri, "Logging null uri");          \
  if (LOG_ENABLED()) {                            \
    LOG((format, uri->GetSpecOrDefault().get())); \
  }                                               \
  PR_END_MACRO

// And some convenience strings...
static const char* const gStateStrings[] = {"Unknown", "NeedsParser", "Pending",
                                            "Loading", "Complete"};

namespace mozilla {

class SheetLoadDataHashKey : public nsURIHashKey {
  using IsPreload = css::Loader::IsPreload;

 public:
  typedef SheetLoadDataHashKey* KeyType;
  typedef const SheetLoadDataHashKey* KeyTypePointer;

  explicit SheetLoadDataHashKey(const SheetLoadDataHashKey* aKey)
      : nsURIHashKey(aKey->mKey),
        mPrincipal(aKey->mPrincipal),
        mReferrerInfo(aKey->mReferrerInfo),
        mCORSMode(aKey->mCORSMode),
        mParsingMode(aKey->mParsingMode),
        mSRIMetadata(aKey->mSRIMetadata),
        mIsLinkPreload(aKey->mIsLinkPreload) {
    MOZ_COUNT_CTOR(SheetLoadDataHashKey);
  }

  SheetLoadDataHashKey(nsIURI* aURI, nsIPrincipal* aPrincipal,
                       nsIReferrerInfo* aReferrerInfo, CORSMode aCORSMode,
                       css::SheetParsingMode aParsingMode,
                       const SRIMetadata& aSRIMetadata, IsPreload aIsPreload)
      : nsURIHashKey(aURI),
        mPrincipal(aPrincipal),
        mReferrerInfo(aReferrerInfo),
        mCORSMode(aCORSMode),
        mParsingMode(aParsingMode),
        mSRIMetadata(aSRIMetadata),
        mIsLinkPreload(aIsPreload == IsPreload::FromLink) {
    MOZ_COUNT_CTOR(SheetLoadDataHashKey);
  }

  SheetLoadDataHashKey(SheetLoadDataHashKey&& toMove)
      : nsURIHashKey(std::move(toMove)),
        mPrincipal(std::move(toMove.mPrincipal)),
        mReferrerInfo(std::move(toMove.mReferrerInfo)),
        mCORSMode(std::move(toMove.mCORSMode)),
        mParsingMode(std::move(toMove.mParsingMode)),
        mSRIMetadata(std::move(toMove.mSRIMetadata)),
        mIsLinkPreload(std::move(toMove.mIsLinkPreload)) {
    MOZ_COUNT_CTOR(SheetLoadDataHashKey);
  }

  explicit SheetLoadDataHashKey(css::SheetLoadData&);

  MOZ_COUNTED_DTOR(SheetLoadDataHashKey)

  SheetLoadDataHashKey* GetKey() const {
    return const_cast<SheetLoadDataHashKey*>(this);
  }
  const SheetLoadDataHashKey* GetKeyPointer() const { return this; }

  bool KeyEquals(const SheetLoadDataHashKey* aKey) const {
    if (!nsURIHashKey::KeyEquals(aKey->mKey)) {
      return false;
    }

    if (!mPrincipal != !aKey->mPrincipal) {
      // One or the other has a principal, but not both... not equal
      return false;
    }

    if (mCORSMode != aKey->mCORSMode) {
      // Different CORS modes; we don't match
      return false;
    }

    if (mParsingMode != aKey->mParsingMode) {
      return false;
    }

    bool eq;
    if (NS_FAILED(mReferrerInfo->Equals(aKey->mReferrerInfo, &eq)) || !eq) {
      return false;
    }

    if (mPrincipal && !mPrincipal->Equals(aKey->mPrincipal)) {
      return false;
    }

    // Consuming stylesheet tags must never coalesce to <link preload> initiated
    // speculative loads with a weaker SRI hash or its different value.  This
    // check makes sure that regular loads will never find such a weaker preload
    // and rather start a new, independent load with new, stronger SRI checker
    // set up, so that integrity is ensured.
    if (mIsLinkPreload != aKey->mIsLinkPreload) {
      const SRIMetadata& linkPreloadMetadata =
          mIsLinkPreload ? mSRIMetadata : aKey->mSRIMetadata;
      const SRIMetadata& consumerPreloadMetadata =
          mIsLinkPreload ? aKey->mSRIMetadata : mSRIMetadata;

      if (!consumerPreloadMetadata.CanTrustBeDelegatedTo(linkPreloadMetadata)) {
        return false;
      }
    }

    return true;
  }

  static const SheetLoadDataHashKey* KeyToPointer(SheetLoadDataHashKey* aKey) {
    return aKey;
  }
  static PLDHashNumber HashKey(const SheetLoadDataHashKey* aKey) {
    return nsURIHashKey::HashKey(aKey->mKey);
  }

  nsIURI* GetURI() const { return nsURIHashKey::GetKey(); }

  nsIPrincipal* GetPrincipal() const { return mPrincipal; }

  css::SheetParsingMode ParsingMode() const { return mParsingMode; }

  enum { ALLOW_MEMMOVE = true };

 protected:
  nsCOMPtr<nsIPrincipal> mPrincipal;
  nsCOMPtr<nsIReferrerInfo> mReferrerInfo;
  CORSMode mCORSMode;
  css::SheetParsingMode mParsingMode;
  SRIMetadata mSRIMetadata;
  bool mIsLinkPreload;
};

SheetLoadDataHashKey::SheetLoadDataHashKey(css::SheetLoadData& aLoadData)
    : nsURIHashKey(aLoadData.mURI),
      mPrincipal(aLoadData.mTriggeringPrincipal),
      mReferrerInfo(aLoadData.ReferrerInfo()),
      mCORSMode(aLoadData.mSheet->GetCORSMode()),
      mParsingMode(aLoadData.mSheet->ParsingMode()),
      mIsLinkPreload(aLoadData.IsLinkPreload()) {
  MOZ_COUNT_CTOR(SheetLoadDataHashKey);
  aLoadData.mSheet->GetIntegrity(mSRIMetadata);
}

}  // namespace mozilla

namespace mozilla {
namespace css {

/********************************
 * SheetLoadData implementation *
 ********************************/
NS_IMPL_ISUPPORTS(SheetLoadData, nsIRunnable, nsIThreadObserver)

SheetLoadData::SheetLoadData(Loader* aLoader, const nsAString& aTitle,
                             nsIURI* aURI, StyleSheet* aSheet, bool aSyncLoad,
                             nsINode* aOwningNode, IsAlternate aIsAlternate,
                             MediaMatched aMediaMatches, IsPreload aIsPreload,
                             nsICSSLoaderObserver* aObserver,
                             nsIPrincipal* aTriggeringPrincipal,
                             nsIReferrerInfo* aReferrerInfo,
                             nsINode* aRequestingNode)
    : mLoader(aLoader),
      mTitle(aTitle),
      mEncoding(nullptr),
      mURI(aURI),
      mLineNumber(1),
      mSheet(aSheet),
      mNext(nullptr),
      mPendingChildren(0),
      mSyncLoad(aSyncLoad),
      mIsNonDocumentSheet(false),
      mIsLoading(false),
      mIsBeingParsed(false),
      mIsCancelled(false),
      mMustNotify(false),
      mWasAlternate(aIsAlternate == IsAlternate::Yes),
      mMediaMatched(aMediaMatches == MediaMatched::Yes),
      mUseSystemPrincipal(false),
      mSheetAlreadyComplete(false),
      mIsCrossOriginNoCORS(false),
      mBlockResourceTiming(false),
      mLoadFailed(false),
      mIsPreload(aIsPreload),
      mOwningNode(aOwningNode),
      mObserver(aObserver),
      mTriggeringPrincipal(aTriggeringPrincipal),
      mReferrerInfo(aReferrerInfo),
      mRequestingNode(aRequestingNode),
      mPreloadEncoding(nullptr) {
  MOZ_ASSERT(!mOwningNode || dom::LinkStyle::FromNode(*mOwningNode),
             "Must implement LinkStyle");
  MOZ_ASSERT(mLoader, "Must have a loader!");
}

SheetLoadData::SheetLoadData(Loader* aLoader, nsIURI* aURI, StyleSheet* aSheet,
                             SheetLoadData* aParentData,
                             nsICSSLoaderObserver* aObserver,
                             nsIPrincipal* aTriggeringPrincipal,
                             nsIReferrerInfo* aReferrerInfo,
                             nsINode* aRequestingNode)
    : mLoader(aLoader),
      mEncoding(nullptr),
      mURI(aURI),
      mLineNumber(1),
      mSheet(aSheet),
      mNext(nullptr),
      mParentData(aParentData),
      mPendingChildren(0),
      mSyncLoad(aParentData && aParentData->mSyncLoad),
      mIsNonDocumentSheet(aParentData && aParentData->mIsNonDocumentSheet),
      mIsLoading(false),
      mIsBeingParsed(false),
      mIsCancelled(false),
      mMustNotify(false),
      mWasAlternate(false),
      mMediaMatched(true),
      mUseSystemPrincipal(aParentData && aParentData->mUseSystemPrincipal),
      mSheetAlreadyComplete(false),
      mIsCrossOriginNoCORS(false),
      mBlockResourceTiming(false),
      mLoadFailed(false),
      mIsPreload(IsPreload::No),
      mOwningNode(nullptr),
      mObserver(aObserver),
      mTriggeringPrincipal(aTriggeringPrincipal),
      mReferrerInfo(aReferrerInfo),
      mRequestingNode(aRequestingNode),
      mPreloadEncoding(nullptr) {
  MOZ_ASSERT(mLoader, "Must have a loader!");
  if (mParentData) {
    ++mParentData->mPendingChildren;
  }

  MOZ_ASSERT(!mUseSystemPrincipal || mSyncLoad,
             "Shouldn't use system principal for async loads");
}

SheetLoadData::SheetLoadData(
    Loader* aLoader, nsIURI* aURI, StyleSheet* aSheet, bool aSyncLoad,
    UseSystemPrincipal aUseSystemPrincipal, IsPreload aIsPreload,
    const Encoding* aPreloadEncoding, nsICSSLoaderObserver* aObserver,
    nsIPrincipal* aTriggeringPrincipal, nsIReferrerInfo* aReferrerInfo,
    nsINode* aRequestingNode)
    : mLoader(aLoader),
      mEncoding(nullptr),
      mURI(aURI),
      mLineNumber(1),
      mSheet(aSheet),
      mNext(nullptr),
      mPendingChildren(0),
      mSyncLoad(aSyncLoad),
      mIsNonDocumentSheet(true),
      mIsLoading(false),
      mIsBeingParsed(false),
      mIsCancelled(false),
      mMustNotify(false),
      mWasAlternate(false),
      mMediaMatched(true),
      mUseSystemPrincipal(aUseSystemPrincipal == UseSystemPrincipal::Yes),
      mSheetAlreadyComplete(false),
      mIsCrossOriginNoCORS(false),
      mBlockResourceTiming(false),
      mLoadFailed(false),
      mIsPreload(aIsPreload),
      mOwningNode(nullptr),
      mObserver(aObserver),
      mTriggeringPrincipal(aTriggeringPrincipal),
      mReferrerInfo(aReferrerInfo),
      mRequestingNode(aRequestingNode),
      mPreloadEncoding(aPreloadEncoding) {
  MOZ_ASSERT(mLoader, "Must have a loader!");
  MOZ_ASSERT(!mUseSystemPrincipal || mSyncLoad,
             "Shouldn't use system principal for async loads");
}

SheetLoadData::~SheetLoadData() {
  MOZ_DIAGNOSTIC_ASSERT(mSheetCompleteCalled || mIntentionallyDropped,
                        "Should always call SheetComplete, except when "
                        "dropping the load");

  // Do this iteratively to avoid blowing up the stack.
  RefPtr<SheetLoadData> next = std::move(mNext);
  while (next) {
    next = std::move(next->mNext);
  }
}

NS_IMETHODIMP
SheetLoadData::Run() {
  mLoader->HandleLoadEvent(*this);
  return NS_OK;
}

NS_IMETHODIMP
SheetLoadData::OnDispatchedEvent() { return NS_OK; }

NS_IMETHODIMP
SheetLoadData::OnProcessNextEvent(nsIThreadInternal* aThread, bool aMayWait) {
  // XXXkhuey this is insane!
  // We want to fire our load even before or after event processing,
  // whichever comes first.
  FireLoadEvent(aThread);
  return NS_OK;
}

NS_IMETHODIMP
SheetLoadData::AfterProcessNextEvent(nsIThreadInternal* aThread,
                                     bool aEventWasProcessed) {
  // XXXkhuey this too!
  // We want to fire our load even before or after event processing,
  // whichever comes first.
  FireLoadEvent(aThread);
  return NS_OK;
}

void SheetLoadData::FireLoadEvent(nsIThreadInternal* aThread) {
  // First remove ourselves as a thread observer.  But we need to keep
  // ourselves alive while doing that!
  RefPtr<SheetLoadData> kungFuDeathGrip(this);
  aThread->RemoveObserver(this);

  // Now fire the event
  nsCOMPtr<nsINode> node = mOwningNode;
  MOZ_ASSERT(node, "How did that happen???");

  nsContentUtils::DispatchTrustedEvent(
      node->OwnerDoc(), node,
      mLoadFailed ? NS_LITERAL_STRING("error") : NS_LITERAL_STRING("load"),
      CanBubble::eNo, Cancelable::eNo);

  // And unblock onload
  mLoader->UnblockOnload(true);
}

void SheetLoadData::ScheduleLoadEventIfNeeded() {
  if (!mOwningNode) {
    return;
  }

  nsCOMPtr<nsIThread> thread = do_GetCurrentThread();
  nsCOMPtr<nsIThreadInternal> internalThread = do_QueryInterface(thread);
  if (NS_SUCCEEDED(internalThread->AddObserver(this))) {
    // Make sure to block onload here
    mLoader->BlockOnload();
  }
}

/*********************
 * Style sheet reuse *
 *********************/

static RefPtr<StyleSheet> CloneSheet(StyleSheet& aSheet) {
  return aSheet.Clone(nullptr, nullptr, nullptr, nullptr);
}

bool LoaderReusableStyleSheets::FindReusableStyleSheet(
    nsIURI* aURL, RefPtr<StyleSheet>& aResult) {
  MOZ_ASSERT(aURL);
  for (size_t i = mReusableSheets.Length(); i > 0; --i) {
    size_t index = i - 1;
    bool sameURI;
    MOZ_ASSERT(mReusableSheets[index]->GetOriginalURI());
    nsresult rv =
        aURL->Equals(mReusableSheets[index]->GetOriginalURI(), &sameURI);
    if (!NS_FAILED(rv) && sameURI) {
      aResult = mReusableSheets[index];
      mReusableSheets.RemoveElementAt(index);
      return true;
    }
  }
  return false;
}

// A struct keeping alive various records of sheets that are loading, deferred,
// or already loaded (the later one for caching purposes).
struct Loader::Sheets {
  nsRefPtrHashtable<SheetLoadDataHashKey, StyleSheet> mCompleteSheets;

  nsRefPtrHashtable<SheetLoadDataHashKey, SheetLoadData> mPendingDatas;

  // The SheetLoadData pointers in mLoadingDatas below are weak references.
  nsDataHashtable<SheetLoadDataHashKey, SheetLoadData*> mLoadingDatas;

  nsRefPtrHashtable<nsStringHashKey, StyleSheet> mInlineSheets;

  RefPtr<StyleSheet> LookupInline(const nsAString&);

  // A cache hit or miss. It is a miss if the `StyleSheet` is null.
  using CacheResult = std::tuple<RefPtr<StyleSheet>, SheetState>;
  CacheResult Lookup(SheetLoadDataHashKey&, bool aSyncLoad);

  size_t SizeOfIncludingThis(MallocSizeOf) const;
};

RefPtr<StyleSheet> Loader::Sheets::LookupInline(const nsAString& aBuffer) {
  auto result = mInlineSheets.Lookup(aBuffer);
  if (!result) {
    return nullptr;
  }
  if (result.Data()->HasModifiedRules()) {
    // Remove it now that we know that we're never going to use this stylesheet
    // again.
    result.Remove();
    return nullptr;
  }
  return result.Data()->Clone(nullptr, nullptr, nullptr, nullptr);
}

static void AssertComplete(const StyleSheet& aSheet) {
  // This sheet came from the XUL cache or our per-document hashtable; it
  // better be a complete sheet.
  MOZ_ASSERT(aSheet.IsComplete(),
             "Sheet thinks it's not complete while we think it is");
}

static void AssertIncompleteSheetMatches(const SheetLoadData& aData,
                                         const SheetLoadDataHashKey& aKey) {
#ifdef DEBUG
  bool debugEqual;
  MOZ_ASSERT((!aKey.GetPrincipal() && !aData.mTriggeringPrincipal) ||
                 (aKey.GetPrincipal() && aData.mTriggeringPrincipal &&
                  NS_SUCCEEDED(aKey.GetPrincipal()->Equals(
                      aData.mTriggeringPrincipal, &debugEqual)) &&
                  debugEqual),
             "Principals should be the same");
#endif
  MOZ_ASSERT(!aData.mSheet->HasForcedUniqueInner(),
             "CSSOM shouldn't allow access to incomplete sheets");
}

auto Loader::Sheets::Lookup(SheetLoadDataHashKey& aKey, bool aSyncLoad)
    -> CacheResult {
  nsIURI* uri = aKey.GetURI();
  // Try to find first in the XUL prototype cache.
#ifdef MOZ_XUL
  if (IsChromeURI(uri)) {
    nsXULPrototypeCache* cache = nsXULPrototypeCache::GetInstance();
    if (cache && cache->IsEnabled()) {
      if (StyleSheet* sheet = cache->GetStyleSheet(uri)) {
        LOG(("  From XUL cache: %p", sheet));
        AssertComplete(*sheet);
        // We need to check the parsing mode manually because the XUL cache only
        // keys off the URI. See below for the unique inner check.
        if (!sheet->HasModifiedRules() &&
            sheet->ParsingMode() == aKey.ParsingMode()) {
          return {CloneSheet(*sheet), SheetState::Complete};
        }
        LOG(
            ("    Not cloning due to forced unique inner or mismatched "
             "parsing mode"));
      }
    }
  }
#endif

  // Now complete sheets.
  if (auto lookup = mCompleteSheets.Lookup(&aKey)) {
    LOG(("  From completed: %p", lookup.Data().get()));
    AssertComplete(*lookup.Data());
    MOZ_ASSERT(lookup.Data()->ParsingMode() == aKey.ParsingMode());
    // Make sure the stylesheet hasn't been modified, as otherwise it may not
    // contain the rules we care about.
    if (!lookup.Data()->HasModifiedRules()) {
      RefPtr<StyleSheet>& cachedSheet = lookup.Data();
      RefPtr<StyleSheet> clone = CloneSheet(*cachedSheet);
      MOZ_ASSERT(!clone->HasForcedUniqueInner());
      MOZ_ASSERT(!clone->HasModifiedRules());

      const bool oldSheetIsWorthKeeping = ([&cachedSheet] {
        // If our current stylesheet in the cache has been touched by CSSOM, we
        // need to do a full copy of it. The new clone still hasn't been
        // touched, so we have better odds of doing a less-expensive clone in
        // the future.
        if (cachedSheet->HasForcedUniqueInner()) {
          return false;
        }
        // The sheet we're cloning isn't actually referenced by anyone.  Replace
        // it in the cache, so that if our CSSOM is later modified we don't end
        // up with two copies of our inner hanging around.
        if (!cachedSheet->GetOwnerNode() && !cachedSheet->GetParentSheet()) {
          return false;
        }
        return true;
      }());

      if (!oldSheetIsWorthKeeping) {
        cachedSheet = clone;
      }

      return {std::move(clone), SheetState::Complete};
    }
    LOG(("    Not cloning due to modified rules"));
    // Remove it now that we know that we're never going to use this stylesheet
    // again.
    lookup.Remove();
  }

  if (aSyncLoad) {
    return {};
  }

  if (SheetLoadData* data = mLoadingDatas.Get(&aKey)) {
    LOG(("  From loading: %p", data->mSheet.get()));
    AssertIncompleteSheetMatches(*data, aKey);
    return {CloneSheet(*data->mSheet), SheetState::Loading};
  }

  if (SheetLoadData* data = mPendingDatas.GetWeak(&aKey)) {
    LOG(("  From pending: %p", data->mSheet.get()));
    AssertIncompleteSheetMatches(*data, aKey);
    return {CloneSheet(*data->mSheet), SheetState::Pending};
  }

  return {};
}

size_t Loader::Sheets::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const {
  size_t n = aMallocSizeOf(this);

  n += mCompleteSheets.ShallowSizeOfExcludingThis(aMallocSizeOf);
  for (auto iter = mCompleteSheets.ConstIter(); !iter.Done(); iter.Next()) {
    // If the sheet has a parent, then its parent will report it so we don't
    // have to worry about it here. Likewise, if aSheet has an owning node, then
    // the document that node is in will report it.
    const StyleSheet* sheet = iter.UserData();
    if (!sheet->GetOwnerNode() && !sheet->GetParentSheet()) {
      n += sheet->SizeOfIncludingThis(aMallocSizeOf);
    }
  }

  n += mInlineSheets.ShallowSizeOfExcludingThis(aMallocSizeOf);
  for (auto iter = mInlineSheets.ConstIter(); !iter.Done(); iter.Next()) {
    n += iter.Key().SizeOfExcludingThisIfUnshared(aMallocSizeOf);
    // If the sheet has a parent, then its parent will report it so we don't
    // have to worry about it here.
    const StyleSheet* sheet = iter.UserData();
    MOZ_ASSERT(!sheet->GetParentSheet(),
               "How did an @import rule end up here?");
    if (!sheet->GetOwnerNode()) {
      n += sheet->SizeOfIncludingThis(aMallocSizeOf);
    }
  }

  // Measurement of the following members may be added later if DMD finds it is
  // worthwhile:
  // - mLoadingDatas: transient, and should be small
  // - mPendingDatas: transient, and should be small
  return n;
}

/*************************
 * Loader Implementation *
 *************************/

Loader::Loader()
    : mDocument(nullptr),
      mDatasToNotifyOn(0),
      mCompatMode(eCompatibility_FullStandards),
      mEnabled(true),
      mReporter(new ConsoleReportCollector()) {}

Loader::Loader(DocGroup* aDocGroup) : Loader() { mDocGroup = aDocGroup; }

Loader::Loader(Document* aDocument) : Loader() {
  MOZ_ASSERT(aDocument, "We should get a valid document from the caller!");
  mDocument = aDocument;
  mCompatMode = aDocument->GetCompatibilityMode();
}

Loader::~Loader() {
  NS_ASSERTION(!mSheets || mSheets->mLoadingDatas.Count() == 0,
               "How did we get destroyed when there are loading data?");
  NS_ASSERTION(!mSheets || mSheets->mPendingDatas.Count() == 0,
               "How did we get destroyed when there are pending data?");
  // Note: no real need to revoke our stylesheet loaded events -- they
  // hold strong references to us, so if we're going away that means
  // they're all done.
}

void Loader::DropDocumentReference(void) {
  mDocument = nullptr;
  // Flush out pending datas just so we don't leak by accident.  These
  // loads should short-circuit through the mDocument check in
  // LoadSheet and just end up in SheetComplete immediately
  if (mSheets) {
    StartDeferredLoads();
  }
}

void Loader::DocumentStyleSheetSetChanged() {
  MOZ_ASSERT(mDocument);

  // start any pending alternates that aren't alternates anymore
  if (!mSheets) {
    return;
  }

  LoadDataArray arr(mSheets->mPendingDatas.Count());
  for (auto iter = mSheets->mPendingDatas.Iter(); !iter.Done(); iter.Next()) {
    RefPtr<SheetLoadData>& data = iter.Data();
    MOZ_ASSERT(data, "Must have a data");

    // Note that we don't want to affect what the selected style set is, so
    // use true for aHasAlternateRel.
    auto isAlternate = data->mLoader->IsAlternateSheet(data->mTitle, true);
    if (isAlternate == IsAlternate::No) {
      arr.AppendElement(std::move(data));
      iter.Remove();
    }
  }

  mDatasToNotifyOn += arr.Length();
  for (RefPtr<SheetLoadData>& data : arr) {
    --mDatasToNotifyOn;
    LoadSheet(*data, SheetState::NeedsParser);
  }
}

static const char kCharsetSym[] = "@charset \"";

static bool GetCharsetFromData(const char* aStyleSheetData,
                               uint32_t aDataLength, nsACString& aCharset) {
  aCharset.Truncate();
  if (aDataLength <= sizeof(kCharsetSym) - 1) return false;

  if (strncmp(aStyleSheetData, kCharsetSym, sizeof(kCharsetSym) - 1)) {
    return false;
  }

  for (uint32_t i = sizeof(kCharsetSym) - 1; i < aDataLength; ++i) {
    char c = aStyleSheetData[i];
    if (c == '"') {
      ++i;
      if (i < aDataLength && aStyleSheetData[i] == ';') {
        return true;
      }
      // fail
      break;
    }
    aCharset.Append(c);
  }

  // Did not see end quote or semicolon
  aCharset.Truncate();
  return false;
}

NotNull<const Encoding*> SheetLoadData::DetermineNonBOMEncoding(
    nsACString const& aSegment, nsIChannel* aChannel) {
  const Encoding* encoding;
  nsAutoCString label;

  // Check HTTP
  if (aChannel && NS_SUCCEEDED(aChannel->GetContentCharset(label))) {
    encoding = Encoding::ForLabel(label);
    if (encoding) {
      return WrapNotNull(encoding);
    }
  }

  // Check @charset
  auto sniffingLength = aSegment.Length();
  if (sniffingLength > SNIFFING_BUFFER_SIZE) {
    sniffingLength = SNIFFING_BUFFER_SIZE;
  }
  if (GetCharsetFromData(aSegment.BeginReading(), sniffingLength, label)) {
    encoding = Encoding::ForLabel(label);
    if (encoding == UTF_16BE_ENCODING || encoding == UTF_16LE_ENCODING) {
      return UTF_8_ENCODING;
    }
    if (encoding) {
      return WrapNotNull(encoding);
    }
  }

  // Now try the charset on the <link> or processing instruction
  // that loaded us
  if (mOwningNode) {
    nsAutoString label16;
    LinkStyle::FromNode(*mOwningNode)->GetCharset(label16);
    encoding = Encoding::ForLabel(label16);
    if (encoding) {
      return WrapNotNull(encoding);
    }
  }

  // In the preload case, the value of the charset attribute on <link> comes
  // in via mPreloadEncoding instead.
  if (mPreloadEncoding) {
    return WrapNotNull(mPreloadEncoding);
  }

  // Try charset from the parent stylesheet.
  if (mParentData) {
    encoding = mParentData->mEncoding;
    if (encoding) {
      return WrapNotNull(encoding);
    }
  }

  if (mLoader->mDocument) {
    // Use the document charset.
    return mLoader->mDocument->GetDocumentCharacterSet();
  }

  return UTF_8_ENCODING;
}

static nsresult VerifySheetIntegrity(const SRIMetadata& aMetadata,
                                     nsIChannel* aChannel,
                                     const nsACString& aFirst,
                                     const nsACString& aSecond,
                                     const nsACString& aSourceFileURI,
                                     nsIConsoleReportCollector* aReporter) {
  NS_ENSURE_ARG_POINTER(aReporter);

  if (MOZ_LOG_TEST(SRILogHelper::GetSriLog(), LogLevel::Debug)) {
    nsAutoCString requestURL;
    nsCOMPtr<nsIURI> originalURI;
    if (aChannel &&
        NS_SUCCEEDED(aChannel->GetOriginalURI(getter_AddRefs(originalURI))) &&
        originalURI) {
      originalURI->GetAsciiSpec(requestURL);
    }
    MOZ_LOG(SRILogHelper::GetSriLog(), LogLevel::Debug,
            ("VerifySheetIntegrity (unichar stream)"));
  }

  SRICheckDataVerifier verifier(aMetadata, aSourceFileURI, aReporter);
  nsresult rv =
      verifier.Update(aFirst.Length(), (const uint8_t*)aFirst.BeginReading());
  NS_ENSURE_SUCCESS(rv, rv);
  rv =
      verifier.Update(aSecond.Length(), (const uint8_t*)aSecond.BeginReading());
  NS_ENSURE_SUCCESS(rv, rv);

  return verifier.Verify(aMetadata, aChannel, aSourceFileURI, aReporter);
}

/*
 * Stream completion code shared by Stylo and the old style system.
 *
 * Here we need to check that the load did not give us an http error
 * page and check the mimetype on the channel to make sure we're not
 * loading non-text/css data in standards mode.
 */
nsresult SheetLoadData::VerifySheetReadyToParse(nsresult aStatus,
                                                const nsACString& aBytes1,
                                                const nsACString& aBytes2,
                                                nsIChannel* aChannel) {
  LOG(("SheetLoadData::VerifySheetReadyToParse"));
  NS_ASSERTION(!mLoader->mSyncCallback, "Synchronous callback from necko");

  if (mIsCancelled) {
    // Just return.  Don't call SheetComplete -- it's already been
    // called and calling it again will lead to an extra NS_RELEASE on
    // this data and a likely crash.
    return NS_OK;
  }

  if (!mLoader->mDocument && !mIsNonDocumentSheet) {
    // Sorry, we don't care about this load anymore
    LOG_WARN(("  No document and not non-document sheet; dropping load"));
    mLoader->SheetComplete(*this, NS_BINDING_ABORTED);
    return NS_OK;
  }

  if (NS_FAILED(aStatus)) {
    LOG_WARN(
        ("  Load failed: status 0x%" PRIx32, static_cast<uint32_t>(aStatus)));
    // Handle sheet not loading error because source was a tracking URL (or
    // fingerprinting, cryptomining, etc).
    // We make a note of this sheet node by including it in a dedicated
    // array of blocked tracking nodes under its parent document.
    //
    // Multiple sheet load instances might be tied to this request,
    // we annotate each one linked to a valid owning element (node).
    if (net::UrlClassifierFeatureFactory::IsClassifierBlockingErrorCode(
            aStatus)) {
      if (Document* doc = mLoader->GetDocument()) {
        for (SheetLoadData* data = this; data; data = data->mNext) {
          // mOwningNode may be null but AddBlockTrackingNode can cope
          doc->AddBlockedNodeByClassifier(
              nsIContent::FromNodeOrNull(data->mOwningNode));
        }
      }
    }
    mLoader->SheetComplete(*this, aStatus);
    return NS_OK;
  }

  if (!aChannel) {
    mLoader->SheetComplete(*this, NS_OK);
    return NS_OK;
  }

  nsCOMPtr<nsIURI> originalURI;
  aChannel->GetOriginalURI(getter_AddRefs(originalURI));

  // If the channel's original URI is "chrome:", we want that, since
  // the observer code in nsXULPrototypeCache depends on chrome stylesheets
  // having a chrome URI.  (Whether or not chrome stylesheets come through
  // this codepath seems nondeterministic.)
  // Otherwise we want the potentially-HTTP-redirected URI.
  nsCOMPtr<nsIURI> channelURI;
  NS_GetFinalChannelURI(aChannel, getter_AddRefs(channelURI));

  if (!channelURI || !originalURI) {
    NS_ERROR("Someone just violated the nsIRequest contract");
    LOG_WARN(("  Channel without a URI.  Bad!"));
    mLoader->SheetComplete(*this, NS_ERROR_UNEXPECTED);
    return NS_OK;
  }

  nsCOMPtr<nsIPrincipal> principal;
  nsIScriptSecurityManager* secMan = nsContentUtils::GetSecurityManager();
  nsresult result = NS_ERROR_NOT_AVAILABLE;
  if (secMan) {  // Could be null if we already shut down
    if (mUseSystemPrincipal) {
      result = secMan->GetSystemPrincipal(getter_AddRefs(principal));
    } else {
      result = secMan->GetChannelResultPrincipal(aChannel,
                                                 getter_AddRefs(principal));
    }
  }

  if (NS_FAILED(result)) {
    LOG_WARN(("  Couldn't get principal"));
    mLoader->SheetComplete(*this, result);
    return NS_OK;
  }

  mSheet->SetPrincipal(principal);

  if (mTriggeringPrincipal && mSheet->GetCORSMode() == CORS_NONE) {
    bool subsumed;
    result = mTriggeringPrincipal->Subsumes(principal, &subsumed);
    if (NS_FAILED(result) || !subsumed) {
      mIsCrossOriginNoCORS = true;
    }
  }

  // If it's an HTTP channel, we want to make sure this is not an
  // error document we got.
  nsCOMPtr<nsIHttpChannel> httpChannel(do_QueryInterface(aChannel));
  if (httpChannel) {
    bool requestSucceeded;
    result = httpChannel->GetRequestSucceeded(&requestSucceeded);
    if (NS_SUCCEEDED(result) && !requestSucceeded) {
      LOG(("  Load returned an error page"));
      mLoader->SheetComplete(*this, NS_ERROR_NOT_AVAILABLE);
      return NS_OK;
    }

    nsAutoCString sourceMapURL;
    if (nsContentUtils::GetSourceMapURL(httpChannel, sourceMapURL)) {
      mSheet->SetSourceMapURL(NS_ConvertUTF8toUTF16(sourceMapURL));
    }
  }

  nsAutoCString contentType;
  aChannel->GetContentType(contentType);

  // In standards mode, a style sheet must have one of these MIME
  // types to be processed at all.  In quirks mode, we accept any
  // MIME type, but only if the style sheet is same-origin with the
  // requesting document or parent sheet.  See bug 524223.

  bool validType = contentType.EqualsLiteral("text/css") ||
                   contentType.EqualsLiteral(UNKNOWN_CONTENT_TYPE) ||
                   contentType.IsEmpty();

  if (!validType) {
    const char* errorMessage;
    uint32_t errorFlag;
    bool sameOrigin = true;

    if (mTriggeringPrincipal) {
      bool subsumed;
      result = mTriggeringPrincipal->Subsumes(principal, &subsumed);
      if (NS_FAILED(result) || !subsumed) {
        sameOrigin = false;
      }
    }

    if (sameOrigin && mLoader->mCompatMode == eCompatibility_NavQuirks) {
      errorMessage = "MimeNotCssWarn";
      errorFlag = nsIScriptError::warningFlag;
    } else {
      errorMessage = "MimeNotCss";
      errorFlag = nsIScriptError::errorFlag;
    }

    AutoTArray<nsString, 2> strings;
    CopyUTF8toUTF16(channelURI->GetSpecOrDefault(), *strings.AppendElement());
    CopyASCIItoUTF16(contentType, *strings.AppendElement());

    nsCOMPtr<nsIURI> referrer = ReferrerInfo()->GetOriginalReferrer();
    nsContentUtils::ReportToConsole(
        errorFlag, NS_LITERAL_CSTRING("CSS Loader"), mLoader->mDocument,
        nsContentUtils::eCSS_PROPERTIES, errorMessage, strings, referrer);

    if (errorFlag == nsIScriptError::errorFlag) {
      LOG_WARN(
          ("  Ignoring sheet with improper MIME type %s", contentType.get()));
      mLoader->SheetComplete(*this, NS_ERROR_NOT_AVAILABLE);
      return NS_OK;
    }
  }

  SRIMetadata sriMetadata;
  mSheet->GetIntegrity(sriMetadata);
  if (!sriMetadata.IsEmpty()) {
    nsAutoCString sourceUri;
    if (mLoader->mDocument && mLoader->mDocument->GetDocumentURI()) {
      mLoader->mDocument->GetDocumentURI()->GetAsciiSpec(sourceUri);
    }
    nsresult rv = VerifySheetIntegrity(sriMetadata, aChannel, aBytes1, aBytes2,
                                       sourceUri, mLoader->mReporter);

    nsCOMPtr<nsILoadGroup> loadGroup;
    aChannel->GetLoadGroup(getter_AddRefs(loadGroup));
    if (loadGroup) {
      mLoader->mReporter->FlushConsoleReports(loadGroup);
    } else {
      mLoader->mReporter->FlushConsoleReports(mLoader->mDocument);
    }

    if (NS_FAILED(rv)) {
      LOG(("  Load was blocked by SRI"));
      MOZ_LOG(gSriPRLog, LogLevel::Debug,
              ("css::Loader::OnStreamComplete, bad metadata"));
      mLoader->SheetComplete(*this, NS_ERROR_SRI_CORRUPT);
      return NS_OK;
    }
  }

  // Enough to set the URIs on mSheet, since any sibling datas we have share
  // the same mInner as mSheet and will thus get the same URI.
  mSheet->SetURIs(channelURI, originalURI, channelURI);

  ReferrerPolicy policy =
      nsContentUtils::GetReferrerPolicyFromChannel(aChannel);
  nsCOMPtr<nsIReferrerInfo> referrerInfo =
      ReferrerInfo::CreateForExternalCSSResources(mSheet, policy);

  mSheet->SetReferrerInfo(referrerInfo);
  return NS_OK_PARSE_SHEET;
}

Loader::IsAlternate Loader::IsAlternateSheet(const nsAString& aTitle,
                                             bool aHasAlternateRel) {
  // A sheet is alternate if it has a nonempty title that doesn't match the
  // currently selected style set.  But if there _is_ no currently selected
  // style set, the sheet wasn't marked as an alternate explicitly, and aTitle
  // is nonempty, we should select the style set corresponding to aTitle, since
  // that's a preferred sheet.
  if (aTitle.IsEmpty()) {
    return IsAlternate::No;
  }

  if (mDocument) {
    const nsString& currentSheetSet = mDocument->GetCurrentStyleSheetSet();
    if (!aHasAlternateRel && currentSheetSet.IsEmpty()) {
      // There's no preferred set yet, and we now have a sheet with a title.
      // Make that be the preferred set.
      // FIXME(emilio): This is kinda wild, can we do it somewhere else?
      mDocument->SetPreferredStyleSheetSet(aTitle);
      // We're definitely not an alternate. Also, beware that at this point
      // currentSheetSet may dangle.
      return IsAlternate::No;
    }

    if (aTitle.Equals(currentSheetSet)) {
      return IsAlternate::No;
    }
  }

  return IsAlternate::Yes;
}

nsresult Loader::CheckContentPolicy(nsIPrincipal* aLoadingPrincipal,
                                    nsIPrincipal* aTriggeringPrincipal,
                                    nsIURI* aTargetURI,
                                    nsINode* aRequestingNode,
                                    const nsAString& aNonce,
                                    IsPreload aIsPreload) {
  // When performing a system load (e.g. aUseSystemPrincipal = true)
  // then aLoadingPrincipal == null; don't consult content policies.
  if (!aLoadingPrincipal) {
    return NS_OK;
  }

  nsContentPolicyType contentPolicyType =
      aIsPreload == IsPreload::No
          ? nsIContentPolicy::TYPE_INTERNAL_STYLESHEET
          : nsIContentPolicy::TYPE_INTERNAL_STYLESHEET_PRELOAD;

  nsCOMPtr<nsILoadInfo> secCheckLoadInfo = new net::LoadInfo(
      aLoadingPrincipal, aTriggeringPrincipal, aRequestingNode,
      nsILoadInfo::SEC_ONLY_FOR_EXPLICIT_CONTENTSEC_CHECK, contentPolicyType);

  // snapshot the nonce at load start time for performing CSP checks
  if (contentPolicyType == nsIContentPolicy::TYPE_INTERNAL_STYLESHEET) {
    secCheckLoadInfo->SetCspNonce(aNonce);
    MOZ_ASSERT_IF(aIsPreload != IsPreload::No, aNonce.IsEmpty());
  }

  int16_t shouldLoad = nsIContentPolicy::ACCEPT;
  nsresult rv = NS_CheckContentLoadPolicy(
      aTargetURI, secCheckLoadInfo, NS_LITERAL_CSTRING("text/css"), &shouldLoad,
      nsContentUtils::GetContentPolicy());
  if (NS_FAILED(rv) || NS_CP_REJECTED(shouldLoad)) {
    return NS_ERROR_CONTENT_BLOCKED;
  }
  return NS_OK;
}

/**
 * CreateSheet() creates a StyleSheet object for the given URI.
 *
 * We check for an existing style sheet object for that uri in various caches
 * and clone it if we find it.  Cloned sheets will have the title/media/enabled
 * state of the sheet they are clones off; make sure to call PrepareSheet() on
 * the result of CreateSheet().
 */
std::tuple<RefPtr<StyleSheet>, Loader::SheetState> Loader::CreateSheet(
    nsIURI* aURI, nsIContent* aLinkingContent,
    nsIPrincipal* aTriggeringPrincipal, css::SheetParsingMode aParsingMode,
    CORSMode aCORSMode, nsIReferrerInfo* aLoadingReferrerInfo,
    const nsAString& aIntegrity, bool aSyncLoad, IsPreload aIsPreload) {
  MOZ_ASSERT(aURI, "This path is not taken for inline stylesheets");
  LOG(("css::Loader::CreateSheet(%s)", aURI->GetSpecOrDefault().get()));

  if (!mSheets) {
    mSheets = MakeUnique<Sheets>();
  }

  SRIMetadata sriMetadata;
  if (!aIntegrity.IsEmpty()) {
    MOZ_LOG(gSriPRLog, LogLevel::Debug,
            ("css::Loader::CreateSheet, integrity=%s",
             NS_ConvertUTF16toUTF8(aIntegrity).get()));
    nsAutoCString sourceUri;
    if (mDocument && mDocument->GetDocumentURI()) {
      mDocument->GetDocumentURI()->GetAsciiSpec(sourceUri);
    }
    SRICheck::IntegrityMetadata(aIntegrity, sourceUri, mReporter, &sriMetadata);
  }

  SheetLoadDataHashKey key(aURI, aTriggeringPrincipal, aLoadingReferrerInfo,
                           aCORSMode, aParsingMode, sriMetadata, aIsPreload);
  auto cacheResult = mSheets->Lookup(key, aSyncLoad);
  if (const auto& [styleSheet, sheetState] = cacheResult; styleSheet) {
    LOG(("  Hit cache with state: %s", gStateStrings[size_t(sheetState)]));
    return cacheResult;
  }

  nsIURI* sheetURI = aURI;
  nsIURI* baseURI = aURI;
  nsIURI* originalURI = aURI;

  auto sheet = MakeRefPtr<StyleSheet>(aParsingMode, aCORSMode, sriMetadata);
  sheet->SetURIs(sheetURI, originalURI, baseURI);
  nsCOMPtr<nsIReferrerInfo> referrerInfo =
      ReferrerInfo::CreateForExternalCSSResources(sheet);
  sheet->SetReferrerInfo(referrerInfo);
  LOG(("  Needs parser"));
  return {std::move(sheet), SheetState::NeedsParser};
}

static Loader::MediaMatched MediaListMatches(const MediaList* aMediaList,
                                             const Document* aDocument) {
  if (!aMediaList || !aDocument) {
    return Loader::MediaMatched::Yes;
  }

  if (aMediaList->Matches(*aDocument)) {
    return Loader::MediaMatched::Yes;
  }

  return Loader::MediaMatched::No;
}

/**
 * PrepareSheet() handles setting the media and title on the sheet, as
 * well as setting the enabled state based on the title and whether
 * the sheet had "alternate" in its rel.
 */
Loader::MediaMatched Loader::PrepareSheet(
    StyleSheet& aSheet, const nsAString& aTitle, const nsAString& aMediaString,
    MediaList* aMediaList, IsAlternate aIsAlternate,
    IsExplicitlyEnabled aIsExplicitlyEnabled) {
  RefPtr<MediaList> mediaList(aMediaList);

  if (!aMediaString.IsEmpty()) {
    NS_ASSERTION(!aMediaList,
                 "must not provide both aMediaString and aMediaList");
    mediaList = MediaList::Create(aMediaString);
  }

  aSheet.SetMedia(do_AddRef(mediaList));

  aSheet.SetTitle(aTitle);
  aSheet.SetEnabled(aIsAlternate == IsAlternate::No ||
                    aIsExplicitlyEnabled == IsExplicitlyEnabled::Yes);
  return MediaListMatches(mediaList, mDocument);
}

/**
 * InsertSheetInTree handles ordering of sheets in the document or shadow root.
 *
 * Here we have two types of sheets -- those with linking elements and
 * those without.  The latter are loaded by Link: headers, and are only added to
 * the document.
 *
 * The following constraints are observed:
 * 1) Any sheet with a linking element comes after all sheets without
 *    linking elements
 * 2) Sheets without linking elements are inserted in the order in
 *    which the inserting requests come in, since all of these are
 *    inserted during header data processing in the content sink
 * 3) Sheets with linking elements are ordered based on document order
 *    as determined by CompareDocumentPosition.
 */
void Loader::InsertSheetInTree(StyleSheet& aSheet,
                               nsIContent* aLinkingContent) {
  LOG(("css::Loader::InsertSheetInTree"));
  MOZ_ASSERT(mDocument, "Must have a document to insert into");
  MOZ_ASSERT(!aLinkingContent || aLinkingContent->IsInUncomposedDoc() ||
                 aLinkingContent->IsInShadowTree(),
             "Why would we insert it anywhere?");

  if (auto* linkStyle = LinkStyle::FromNodeOrNull(aLinkingContent)) {
    linkStyle->SetStyleSheet(&aSheet);
  }

  ShadowRoot* shadow =
      aLinkingContent ? aLinkingContent->GetContainingShadow() : nullptr;

  auto& target = shadow ? static_cast<DocumentOrShadowRoot&>(*shadow)
                        : static_cast<DocumentOrShadowRoot&>(*mDocument);

  // XXX Need to cancel pending sheet loads for this element, if any

  int32_t sheetCount = target.SheetCount();

  /*
   * Start the walk at the _end_ of the list, since in the typical
   * case we'll just want to append anyway.  We want to break out of
   * the loop when insertionPoint points to just before the index we
   * want to insert at.  In other words, when we leave the loop
   * insertionPoint is the index of the stylesheet that immediately
   * precedes the one we're inserting.
   */
  int32_t insertionPoint = sheetCount - 1;
  for (; insertionPoint >= 0; --insertionPoint) {
    nsINode* sheetOwner = target.SheetAt(insertionPoint)->GetOwnerNode();
    if (sheetOwner && !aLinkingContent) {
      // Keep moving; all sheets with a sheetOwner come after all
      // sheets without a linkingNode
      continue;
    }

    if (!sheetOwner) {
      // Aha!  The current sheet has no sheet owner, so we want to insert after
      // it no matter whether we have a linking content or not.
      break;
    }

    MOZ_ASSERT(aLinkingContent != sheetOwner,
               "Why do we still have our old sheet?");

    // Have to compare
    if (nsContentUtils::PositionIsBefore(sheetOwner, aLinkingContent)) {
      // The current sheet comes before us, and it better be the first
      // such, because now we break
      break;
    }
  }

  ++insertionPoint;

  if (shadow) {
    shadow->InsertSheetAt(insertionPoint, aSheet);
  } else {
    mDocument->InsertSheetAt(insertionPoint, aSheet);
  }

  LOG(("  Inserting into target (doc: %d) at position %d",
       target.AsNode().IsDocument(), insertionPoint));
}

/**
 * InsertChildSheet handles ordering of @import-ed sheet in their
 * parent sheets.  Here we want to just insert based on order of the
 * @import rules that imported the sheets.  In theory we can't just
 * append to the end because the CSSOM can insert @import rules.  In
 * practice, we get the call to load the child sheet before the CSSOM
 * has finished inserting the @import rule, so we have no idea where
 * to put it anyway.  So just append for now.  (In the future if we
 * want to insert the sheet at the correct position, we'll need to
 * restore CSSStyleSheet::InsertStyleSheetAt, which was removed in
 * bug 1220506.)
 */
void Loader::InsertChildSheet(StyleSheet& aSheet, StyleSheet& aParentSheet) {
  LOG(("css::Loader::InsertChildSheet"));

  // child sheets should always start out enabled, even if they got
  // cloned off of top-level sheets which were disabled
  aSheet.SetEnabled(true);
  aParentSheet.AppendStyleSheet(aSheet);

  LOG(("  Inserting into parent sheet"));
}

/**
 * LoadSheet handles the actual load of a sheet.  If the load is
 * supposed to be synchronous it just opens a channel synchronously
 * using the given uri, wraps the resulting stream in a converter
 * stream and calls ParseSheet.  Otherwise it tries to look for an
 * existing load for this URI and piggyback on it.  Failing all that,
 * a new load is kicked off asynchronously.
 */
nsresult Loader::LoadSheet(SheetLoadData& aLoadData, SheetState aSheetState) {
  LOG(("css::Loader::LoadSheet"));
  MOZ_ASSERT(aLoadData.mURI, "Need a URI to load");
  MOZ_ASSERT(aLoadData.mSheet, "Need a sheet to load into");
  MOZ_ASSERT(aSheetState != SheetState::Complete, "Why bother?");
  MOZ_ASSERT(!aLoadData.mUseSystemPrincipal || aLoadData.mSyncLoad,
             "Shouldn't use system principal for async loads");
  NS_ASSERTION(mSheets, "mLoadingDatas should be initialized by now.");

  LOG_URI("  Load from: '%s'", aLoadData.mURI);

  nsresult rv = NS_OK;

  if (!mDocument && !aLoadData.mIsNonDocumentSheet) {
    // No point starting the load; just release all the data and such.
    LOG_WARN(("  No document and not non-document sheet; pre-dropping load"));
    SheetComplete(aLoadData, NS_BINDING_ABORTED);
    return NS_BINDING_ABORTED;
  }

  SRIMetadata sriMetadata;
  aLoadData.mSheet->GetIntegrity(sriMetadata);

  if (aLoadData.mSyncLoad) {
    LOG(("  Synchronous load"));
    MOZ_ASSERT(!aLoadData.mObserver, "Observer for a sync load?");
    MOZ_ASSERT(aSheetState == SheetState::NeedsParser,
               "Sync loads can't reuse existing async loads");

    // Create a StreamLoader instance to which we will feed
    // the data from the sync load.  Do this before creating the
    // channel to make error recovery simpler.
    auto streamLoader = MakeRefPtr<StreamLoader>(aLoadData);

    if (mDocument) {
      net::PredictorLearn(aLoadData.mURI, mDocument->GetDocumentURI(),
                          nsINetworkPredictor::LEARN_LOAD_SUBRESOURCE,
                          mDocument);
    }

    nsSecurityFlags securityFlags =
        nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_INHERITS |
        nsILoadInfo::SEC_ALLOW_CHROME;

    nsContentPolicyType contentPolicyType =
        aLoadData.mIsPreload == IsPreload::No
            ? nsIContentPolicy::TYPE_INTERNAL_STYLESHEET
            : nsIContentPolicy::TYPE_INTERNAL_STYLESHEET_PRELOAD;

    // Just load it
    nsCOMPtr<nsIChannel> channel;
    // Note that we are calling NS_NewChannelWithTriggeringPrincipal() with both
    // a node and a principal.
    // This is because of a case where the node is the document being styled and
    // the principal is the stylesheet (perhaps from a different origin) that is
    // applying the styles.
    if (aLoadData.mRequestingNode && aLoadData.mTriggeringPrincipal) {
      rv = NS_NewChannelWithTriggeringPrincipal(
          getter_AddRefs(channel), aLoadData.mURI, aLoadData.mRequestingNode,
          aLoadData.mTriggeringPrincipal, securityFlags, contentPolicyType);
    } else {
      // either we are loading something inside a document, in which case
      // we should always have a requestingNode, or we are loading something
      // outside a document, in which case the loadingPrincipal and the
      // triggeringPrincipal should always be the systemPrincipal.
      auto result = URLPreloader::ReadURI(aLoadData.mURI);
      if (result.isOk()) {
        nsCOMPtr<nsIInputStream> stream;
        MOZ_TRY(
            NS_NewCStringInputStream(getter_AddRefs(stream), result.unwrap()));

        rv = NS_NewInputStreamChannel(getter_AddRefs(channel), aLoadData.mURI,
                                      stream.forget(),
                                      nsContentUtils::GetSystemPrincipal(),
                                      securityFlags, contentPolicyType);
      } else {
        rv = NS_NewChannel(getter_AddRefs(channel), aLoadData.mURI,
                           nsContentUtils::GetSystemPrincipal(), securityFlags,
                           contentPolicyType);
      }
    }
    if (NS_FAILED(rv)) {
      LOG_ERROR(("  Failed to create channel"));
      streamLoader->ChannelOpenFailed(rv);
      SheetComplete(aLoadData, rv);
      return rv;
    }

    // snapshot the nonce at load start time for performing CSP checks
    if (contentPolicyType == nsIContentPolicy::TYPE_INTERNAL_STYLESHEET) {
      if (aLoadData.mRequestingNode) {
        // TODO(bug 1607009) move to SheetLoadData
        nsString* cspNonce = static_cast<nsString*>(
            aLoadData.mRequestingNode->GetProperty(nsGkAtoms::nonce));
        if (cspNonce) {
          nsCOMPtr<nsILoadInfo> loadInfo = channel->LoadInfo();
          loadInfo->SetCspNonce(*cspNonce);
        }
      }
    }

    nsCOMPtr<nsIInputStream> stream;
    rv = channel->Open(getter_AddRefs(stream));

    if (NS_FAILED(rv)) {
      LOG_ERROR(("  Failed to open URI synchronously"));
      streamLoader->ChannelOpenFailed(rv);
      SheetComplete(aLoadData, rv);
      return rv;
    }

    // Force UA sheets to be UTF-8.
    // XXX this is only necessary because the default in
    // SheetLoadData::OnDetermineCharset is wrong (bug 521039).
    channel->SetContentCharset(NS_LITERAL_CSTRING("UTF-8"));

    // Manually feed the streamloader the contents of the stream.
    // This will call back into OnStreamComplete
    // and thence to ParseSheet.  Regardless of whether this fails,
    // SheetComplete has been called.
    return nsSyncLoadService::PushSyncStreamToListener(stream.forget(),
                                                       streamLoader, channel);
  }

  SheetLoadData* existingData = nullptr;

  SheetLoadDataHashKey key(aLoadData);

  if (aSheetState == SheetState::Loading) {
    existingData = mSheets->mLoadingDatas.Get(&key);
    NS_ASSERTION(existingData, "CreateSheet lied about the state");
  } else if (aSheetState == SheetState::Pending) {
    existingData = mSheets->mPendingDatas.GetWeak(&key);
    NS_ASSERTION(existingData, "CreateSheet lied about the state");
  }

  if (existingData) {
    LOG(("  Glomming on to existing load"));
    SheetLoadData* data = existingData;
    while (data->mNext) {
      data = data->mNext;
    }
    data->mNext = &aLoadData;
    if (aSheetState == SheetState::Pending && !aLoadData.ShouldDefer()) {
      // Kick the load off; someone cares about it right away
      RefPtr<SheetLoadData> removedData;
      mSheets->mPendingDatas.Remove(&key, getter_AddRefs(removedData));
      MOZ_ASSERT(removedData == existingData, "Bad loading table");

      LOG(("  Forcing load of pending data"));
      return LoadSheet(*removedData, SheetState::NeedsParser);
    }
    // All done here; once the load completes we'll be marked complete
    // automatically
    return NS_OK;
  }

  nsCOMPtr<nsILoadGroup> loadGroup;
  nsCOMPtr<nsICookieJarSettings> cookieJarSettings;
  if (mDocument) {
    loadGroup = mDocument->GetDocumentLoadGroup();
    // load for a document with no loadgrup indicates that something is
    // completely bogus, let's bail out early.
    if (!loadGroup) {
      LOG_ERROR(("  Failed to query loadGroup from document"));
      SheetComplete(aLoadData, NS_ERROR_UNEXPECTED);
      return NS_ERROR_UNEXPECTED;
    }

    cookieJarSettings = mDocument->CookieJarSettings();
  }

#ifdef DEBUG
  AutoRestore<bool> syncCallbackGuard(mSyncCallback);
  mSyncCallback = true;
#endif

  CORSMode ourCORSMode = aLoadData.mSheet->GetCORSMode();
  nsSecurityFlags securityFlags =
      ourCORSMode == CORS_NONE
          ? nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_INHERITS
          : nsILoadInfo::SEC_REQUIRE_CORS_DATA_INHERITS;
  if (ourCORSMode == CORS_ANONYMOUS) {
    securityFlags |= nsILoadInfo::SEC_COOKIES_SAME_ORIGIN;
  } else if (ourCORSMode == CORS_USE_CREDENTIALS) {
    securityFlags |= nsILoadInfo::SEC_COOKIES_INCLUDE;
  }
  securityFlags |= nsILoadInfo::SEC_ALLOW_CHROME;

  nsContentPolicyType contentPolicyType =
      aLoadData.mIsPreload == IsPreload::No
          ? nsIContentPolicy::TYPE_INTERNAL_STYLESHEET
          : nsIContentPolicy::TYPE_INTERNAL_STYLESHEET_PRELOAD;

  nsCOMPtr<nsIChannel> channel;
  // Note we are calling NS_NewChannelWithTriggeringPrincipal here with a node
  // and a principal. This is because of a case where the node is the document
  // being styled and the principal is the stylesheet (perhaps from a different
  // origin)  that is applying the styles.
  if (aLoadData.mRequestingNode && aLoadData.mTriggeringPrincipal) {
    rv = NS_NewChannelWithTriggeringPrincipal(
        getter_AddRefs(channel), aLoadData.mURI, aLoadData.mRequestingNode,
        aLoadData.mTriggeringPrincipal, securityFlags, contentPolicyType,
        /* PerformanceStorage */ nullptr, loadGroup);
  } else {
    // either we are loading something inside a document, in which case
    // we should always have a requestingNode, or we are loading something
    // outside a document, in which case the loadingPrincipal and the
    // triggeringPrincipal should always be the systemPrincipal.
    rv = NS_NewChannel(getter_AddRefs(channel), aLoadData.mURI,
                       nsContentUtils::GetSystemPrincipal(), securityFlags,
                       contentPolicyType, cookieJarSettings,
                       /* aPerformanceStorage */ nullptr, loadGroup);
  }

  if (NS_FAILED(rv)) {
    LOG_ERROR(("  Failed to create channel"));
    SheetComplete(aLoadData, rv);
    return rv;
  }

  // snapshot the nonce at load start time for performing CSP checks
  if (contentPolicyType == nsIContentPolicy::TYPE_INTERNAL_STYLESHEET) {
    if (aLoadData.mRequestingNode) {
      // TODO(bug 1607009) move to SheetLoadData
      nsString* cspNonce = static_cast<nsString*>(
          aLoadData.mRequestingNode->GetProperty(nsGkAtoms::nonce));
      if (cspNonce) {
        nsCOMPtr<nsILoadInfo> loadInfo = channel->LoadInfo();
        loadInfo->SetCspNonce(*cspNonce);
      }
    }
  }

  if (!aLoadData.ShouldDefer()) {
    if (nsCOMPtr<nsIClassOfService> cos = do_QueryInterface(channel)) {
      cos->AddClassFlags(nsIClassOfService::Leader);
    }
    if (aLoadData.mIsPreload == IsPreload::FromLink) {
      StreamLoader::PrioritizeAsPreload(channel);
      StreamLoader::AddLoadBackgroundFlag(channel);
    }
  }

  if (nsCOMPtr<nsIHttpChannel> httpChannel = do_QueryInterface(channel)) {
    if (nsCOMPtr<nsIReferrerInfo> referrerInfo = aLoadData.ReferrerInfo()) {
      rv = httpChannel->SetReferrerInfo(referrerInfo);
      Unused << NS_WARN_IF(NS_FAILED(rv));
    }

    nsCOMPtr<nsIHttpChannelInternal> internalChannel =
        do_QueryInterface(httpChannel);
    if (internalChannel) {
      rv = internalChannel->SetIntegrityMetadata(
          sriMetadata.GetIntegrityString());
      NS_ENSURE_SUCCESS(rv, rv);
    }

    // Set the initiator type
    if (nsCOMPtr<nsITimedChannel> timedChannel =
            do_QueryInterface(httpChannel)) {
      if (aLoadData.mParentData) {
        timedChannel->SetInitiatorType(NS_LITERAL_STRING("css"));

        // This is a child sheet load.
        //
        // The resource timing of the sub-resources that a document loads
        // should normally be reported to the document.  One exception is any
        // sub-resources of any cross-origin resources that are loaded.  We
        // don't mind reporting timing data for a direct child cross-origin
        // resource since the resource that linked to it (and hence potentially
        // anything in that parent origin) is aware that the cross-origin
        // resources is to be loaded.  However, we do not want to report
        // timings for any sub-resources that a cross-origin resource may load
        // since that obviously leaks information about what the cross-origin
        // resource loads, which is bad.
        //
        // In addition to checking whether we're an immediate child resource of
        // a cross-origin resource (by checking if mIsCrossOriginNoCORS is set
        // to true on our parent), we also check our parent to see whether it
        // itself is a sub-resource of a cross-origin resource by checking
        // mBlockResourceTiming.  If that is set then we too are such a
        // sub-resource and so we set the flag on ourself too to propagate it
        // on down.
        //
        if (aLoadData.mParentData->mIsCrossOriginNoCORS ||
            aLoadData.mParentData->mBlockResourceTiming) {
          // Set a flag so any other stylesheet triggered by this one will
          // not be reported
          aLoadData.mBlockResourceTiming = true;

          // Mark the channel so PerformanceMainThread::AddEntry will not
          // report the resource.
          timedChannel->SetReportResourceTiming(false);
        }

      } else {
        timedChannel->SetInitiatorType(NS_LITERAL_STRING("link"));
      }
    }
  }

  // Now tell the channel we expect text/css data back....  We do
  // this before opening it, so it's only treated as a hint.
  channel->SetContentType(NS_LITERAL_CSTRING("text/css"));

  // We don't have to hold on to the stream loader.  The ownership
  // model is: Necko owns the stream loader, which owns the load data,
  // which owns us
  auto streamLoader = MakeRefPtr<StreamLoader>(aLoadData);
  if (mDocument) {
    net::PredictorLearn(aLoadData.mURI, mDocument->GetDocumentURI(),
                        nsINetworkPredictor::LEARN_LOAD_SUBRESOURCE, mDocument);
  }

  auto preloadKey = PreloadHashKey::CreateAsStyle(aLoadData);
  streamLoader->NotifyOpen(&preloadKey, channel, mDocument,
                           aLoadData.mIsPreload == IsPreload::FromLink);

  rv = channel->AsyncOpen(streamLoader);
  if (NS_FAILED(rv)) {
    LOG_ERROR(("  Failed to create stream loader"));
    // ChannelOpenFailed makes sure that <link preload> nodes will get the
    // proper notification about not being able to load this resource.
    streamLoader->ChannelOpenFailed(rv);
    SheetComplete(aLoadData, rv);
    return rv;
  }

#ifdef MOZ_DIAGNOSTIC_ASSERT_ENABLED
  if (nsCOMPtr<nsIHttpChannelInternal> hci = do_QueryInterface(channel)) {
    hci->DoDiagnosticAssertWhenOnStopNotCalledOnDestroy();
  }
#endif

  mSheets->mLoadingDatas.Put(&key, &aLoadData);
  aLoadData.mIsLoading = true;

  return NS_OK;
}

/**
 * ParseSheet handles parsing the data stream.
 */
Loader::Completed Loader::ParseSheet(const nsACString& aBytes,
                                     SheetLoadData& aLoadData,
                                     AllowAsyncParse aAllowAsync) {
  LOG(("css::Loader::ParseSheet"));
  AUTO_PROFILER_LABEL("css::Loader::ParseSheet", LAYOUT_CSSParsing);
  aLoadData.mIsBeingParsed = true;

  StyleSheet* sheet = aLoadData.mSheet;
  MOZ_ASSERT(sheet);

  // Some cases, like inline style and UA stylesheets, need to be parsed
  // synchronously. The former may trigger child loads, the latter must not.
  if (aLoadData.mSyncLoad || aAllowAsync == AllowAsyncParse::No) {
    sheet->ParseSheetSync(this, aBytes, &aLoadData, aLoadData.mLineNumber);
    aLoadData.mIsBeingParsed = false;

    bool noPendingChildren = aLoadData.mPendingChildren == 0;
    MOZ_ASSERT_IF(aLoadData.mSyncLoad, noPendingChildren);
    if (noPendingChildren) {
      SheetComplete(aLoadData, NS_OK);
      return Completed::Yes;
    }
    return Completed::No;
  }

  // This parse does not need to be synchronous. \o/
  //
  // Note that we need to block onload because there may be no network requests
  // pending.
  BlockOnload();
  nsCOMPtr<nsISerialEventTarget> target = DispatchTarget();
  sheet->ParseSheet(*this, aBytes, aLoadData)
      ->Then(
          target, __func__,
          [loadData = RefPtr<SheetLoadData>(&aLoadData)](bool aDummy) {
            MOZ_ASSERT(NS_IsMainThread());
            loadData->mLoader->UnblockOnload(/* aFireSync = */ false);
            loadData->SheetFinishedParsingAsync();
          },
          [] { MOZ_CRASH("rejected parse promise"); });
  return Completed::No;
}

/**
 * SheetComplete is the do-it-all cleanup function.  It removes the
 * load data from the "loading" hashtable, adds the sheet to the
 * "completed" hashtable, massages the XUL cache, handles siblings of
 * the load data (other loads for the same URI), handles unblocking
 * blocked parent loads as needed, and most importantly calls
 * NS_RELEASE on the load data to destroy the whole mess.
 */
void Loader::SheetComplete(SheetLoadData& aLoadData, nsresult aStatus) {
  LOG(("css::Loader::SheetComplete, status: 0x%" PRIx32,
       static_cast<uint32_t>(aStatus)));

  // If aStatus is a failure we need to mark this data failed.  We also need to
  // mark any ancestors of a failing data as failed and any sibling of a
  // failing data as failed.  Note that SheetComplete is never called on a
  // SheetLoadData that is the mNext of some other SheetLoadData.
  if (NS_FAILED(aStatus)) {
    MarkLoadTreeFailed(aLoadData);
  }

  if (mDocument) {
    mDocument->MaybeWarnAboutZoom();
  }

  // 8 is probably big enough for all our common cases.  It's not likely that
  // imports will nest more than 8 deep, and multiple sheets with the same URI
  // are rare.
  AutoTArray<RefPtr<SheetLoadData>, 8> datasToNotify;
  DoSheetComplete(aLoadData, datasToNotify);

  // Now it's safe to go ahead and notify observers
  uint32_t count = datasToNotify.Length();
  mDatasToNotifyOn += count;
  for (RefPtr<SheetLoadData>& data : datasToNotify) {
    --mDatasToNotifyOn;

    MOZ_ASSERT(data, "How did this data get here?");
    if (data->mObserver) {
      LOG(("  Notifying observer %p for data %p.  deferred: %d",
           data->mObserver.get(), data.get(), data->ShouldDefer()));
      data->mObserver->StyleSheetLoaded(data->mSheet, data->ShouldDefer(),
                                        aStatus);
    }

    nsTObserverArray<nsCOMPtr<nsICSSLoaderObserver>>::ForwardIterator iter(
        mObservers);
    nsCOMPtr<nsICSSLoaderObserver> obs;
    while (iter.HasMore()) {
      obs = iter.GetNext();
      LOG(("  Notifying global observer %p for data %p.  deferred: %d",
           obs.get(), data.get(), data->ShouldDefer()));
      obs->StyleSheetLoaded(data->mSheet, data->ShouldDefer(), aStatus);
    }
  }

  if (mSheets && mSheets->mLoadingDatas.Count() == 0 &&
      mSheets->mPendingDatas.Count() > 0) {
    LOG(("  No more loading sheets; starting deferred loads"));
    StartDeferredLoads();
  }
}

void Loader::DoSheetComplete(SheetLoadData& aLoadData,
                             LoadDataArray& aDatasToNotify) {
  LOG(("css::Loader::DoSheetComplete"));
  MOZ_ASSERT(aLoadData.mSheet, "Must have a sheet");
  NS_ASSERTION(mSheets || !aLoadData.mURI || aLoadData.mSheet->IsConstructed(),
               "mLoadingDatas should be initialized by now.");

  // Twiddle the hashtables
  if (aLoadData.mURI) {
    LOG_URI("  Finished loading: '%s'", aLoadData.mURI);
    // Remove the data from the list of loading datas
    if (aLoadData.mIsLoading) {
      SheetLoadDataHashKey key(aLoadData);
      Maybe<SheetLoadData*> loadingData =
          mSheets->mLoadingDatas.GetAndRemove(&key);
      MOZ_DIAGNOSTIC_ASSERT(loadingData && loadingData.value() == &aLoadData);
      Unused << loadingData;
      aLoadData.mIsLoading = false;
    }
  }

  // Go through and deal with the whole linked list.
  SheetLoadData* data = &aLoadData;
  do {
    MOZ_DIAGNOSTIC_ASSERT(!data->mSheetCompleteCalled);
#ifdef MOZ_DIAGNOSTIC_ASSERT_ENABLED
    data->mSheetCompleteCalled = true;
#endif

    if (!data->mSheetAlreadyComplete) {
      // If mSheetAlreadyComplete, then the sheet could well be modified between
      // when we posted the async call to SheetComplete and now, since the sheet
      // was page-accessible during that whole time.

      // HasForcedUniqueInner() is okay if the sheet is constructed, because
      // constructed sheets are always unique and they may be set to complete
      // multiple times if their rules are replaced via Replace()
      MOZ_ASSERT(data->mSheet->IsConstructed() ||
                     !data->mSheet->HasForcedUniqueInner(),
                 "should not get a forced unique inner during parsing");
      data->mSheet->SetComplete();
      data->ScheduleLoadEventIfNeeded();
    }
    if (data->mMustNotify && (data->mObserver || !mObservers.IsEmpty())) {
      // Don't notify here so we don't trigger script.  Remember the
      // info we need to notify, then do it later when it's safe.
      aDatasToNotify.AppendElement(data);

      // On append failure, just press on.  We'll fail to notify the observer,
      // but not much we can do about that....
    }

    NS_ASSERTION(!data->mParentData || data->mParentData->mPendingChildren != 0,
                 "Broken pending child count on our parent");

    // If we have a parent, our parent is no longer being parsed, and
    // we are the last pending child, then our load completion
    // completes the parent too.  Note that the parent _can_ still be
    // being parsed (eg if the child (us) failed to open the channel
    // or some such).
    if (data->mParentData && --(data->mParentData->mPendingChildren) == 0 &&
        !data->mParentData->mIsBeingParsed) {
      DoSheetComplete(*data->mParentData, aDatasToNotify);
    }

    data = data->mNext;
  } while (data);

  // Now that it's marked complete, put the sheet in our cache.
  // If we ever start doing this for failed loads, we'll need to
  // adjust the PostLoadEvent code that thinks anything already
  // complete must have loaded succesfully.
  // We don't want to use mSheets for constructable stylesheets.
  if (!aLoadData.mLoadFailed && aLoadData.mURI &&
      !aLoadData.mSheet->IsConstructed()) {
    // Pick our sheet to cache carefully.  Ideally, we want to cache
    // one of the sheets that will be kept alive by a document or
    // parent sheet anyway, so that if someone then accesses it via
    // CSSOM we won't have extra clones of the inner lying around.
    data = &aLoadData;
    StyleSheet* sheet = aLoadData.mSheet;
    do {
      if (data->mSheet->GetParentSheet() || data->mSheet->GetOwnerNode()) {
        sheet = data->mSheet;
        break;
      }
      data = data->mNext;
    } while (data);

#ifdef MOZ_XUL
    if (IsChromeURI(aLoadData.mURI)) {
      nsXULPrototypeCache* cache = nsXULPrototypeCache::GetInstance();
      if (cache && cache->IsEnabled()) {
        if (!cache->GetStyleSheet(aLoadData.mURI)) {
          LOG(("  Putting sheet in XUL prototype cache"));
          NS_ASSERTION(sheet->IsComplete(),
                       "Should only be caching complete sheets");
          // We need to clone the sheet on insertion to the cache because
          // if the original sheet has a cyclic reference this can cause
          // leaks until shutdown since the global cache is not cycle-collected

          // NOTE: If we stop cloning sheets before insertion, we need to change
          // nsXULPrototypeCache::CollectMemoryReports() to stop using
          // SizeOfIncludingThis() because it will no longer own the sheets.
          cache->PutStyleSheet(CloneSheet(*sheet));
        }
      }
    } else {
#endif
      SheetLoadDataHashKey key(aLoadData);
      MOZ_ASSERT(sheet->IsComplete(), "Should only be caching complete sheets");

#ifdef MOZ_DIAGNOSTIC_ASSERT_ENABLED
      for (const auto& entry : mSheets->mCompleteSheets) {
        MOZ_DIAGNOSTIC_ASSERT(
            entry.GetData() != sheet || key.KeyEquals(entry.GetKey()),
            "Same sheet, different keys?");
      }
#endif

      mSheets->mCompleteSheets.Put(&key, RefPtr{sheet});
#ifdef MOZ_XUL
    }
#endif
  }
}

void Loader::MarkLoadTreeFailed(SheetLoadData& aLoadData) {
  if (aLoadData.mURI) {
    LOG_URI("  Load failed: '%s'", aLoadData.mURI);
  }

  SheetLoadData* data = &aLoadData;
  do {
    data->mLoadFailed = true;
    data->mSheet->MaybeRejectReplacePromise();

    if (data->mParentData) {
      MarkLoadTreeFailed(*data->mParentData);
    }

    data = data->mNext;
  } while (data);
}

Result<Loader::LoadSheetResult, nsresult> Loader::LoadInlineStyle(
    const SheetInfo& aInfo, const nsAString& aBuffer, uint32_t aLineNumber,
    nsICSSLoaderObserver* aObserver) {
  LOG(("css::Loader::LoadInlineStyle"));
  MOZ_ASSERT(aInfo.mContent);

  if (!mEnabled) {
    LOG_WARN(("  Not enabled"));
    return Err(NS_ERROR_NOT_AVAILABLE);
  }

  if (!mDocument) {
    return Err(NS_ERROR_NOT_INITIALIZED);
  }

  MOZ_ASSERT(LinkStyle::FromNodeOrNull(aInfo.mContent),
             "Element is not a style linking element!");

  // Since we're not planning to load a URI, no need to hand a principal to the
  // load data or to CreateSheet().

  // Check IsAlternateSheet now, since it can mutate our document.
  auto isAlternate = IsAlternateSheet(aInfo.mTitle, aInfo.mHasAlternateRel);
  LOG(("  Sheet is alternate: %d", static_cast<int>(isAlternate)));

  // Use the document's base URL so that @import in the inline sheet picks up
  // the right base.
  nsIURI* baseURI = aInfo.mContent->GetBaseURI();
  nsIURI* sheetURI = aInfo.mContent->OwnerDoc()->GetDocumentURI();
  nsIURI* originalURI = nullptr;

  MOZ_ASSERT(aInfo.mIntegrity.IsEmpty());

  // We only cache sheets if in shadow trees, since regular document sheets are
  // likely to be unique.
  const bool isWorthCaching = aInfo.mContent->IsInShadowTree();
  RefPtr<StyleSheet> sheet;
  if (isWorthCaching) {
    if (!mSheets) {
      mSheets = MakeUnique<Sheets>();
    }
    sheet = mSheets->LookupInline(aBuffer);
  }
  const bool sheetFromCache = !!sheet;
  if (!sheet) {
    sheet = MakeRefPtr<StyleSheet>(eAuthorSheetFeatures, aInfo.mCORSMode,
                                   SRIMetadata{});
    sheet->SetURIs(sheetURI, originalURI, baseURI);
    nsCOMPtr<nsIReferrerInfo> referrerInfo =
        ReferrerInfo::CreateForInternalCSSResources(aInfo.mContent->OwnerDoc());
    sheet->SetReferrerInfo(referrerInfo);

    nsIPrincipal* principal = aInfo.mContent->NodePrincipal();
    if (aInfo.mTriggeringPrincipal) {
      // The triggering principal may be an expanded principal, which is safe to
      // use for URL security checks, but not as the loader principal for a
      // stylesheet. So treat this as principal inheritance, and downgrade if
      // necessary.
      principal =
          BasePrincipal::Cast(aInfo.mTriggeringPrincipal)->PrincipalToInherit();
    }

    // We never actually load this, so just set its principal directly
    sheet->SetPrincipal(principal);
  }

  auto matched = PrepareSheet(*sheet, aInfo.mTitle, aInfo.mMedia, nullptr,
                              isAlternate, aInfo.mIsExplicitlyEnabled);

  InsertSheetInTree(*sheet, aInfo.mContent);

  Completed completed;
  if (sheetFromCache) {
    MOZ_ASSERT(sheet->IsComplete());
    completed = Completed::Yes;
  } else {
    auto data = MakeRefPtr<SheetLoadData>(
        this, aInfo.mTitle, nullptr, sheet, false, aInfo.mContent, isAlternate,
        matched, IsPreload::No, aObserver, nullptr, aInfo.mReferrerInfo,
        aInfo.mContent);
    data->mLineNumber = aLineNumber;
    // Parse completion releases the load data.
    //
    // Note that we need to parse synchronously, since the web expects that the
    // effects of inline stylesheets are visible immediately (aside from
    // @imports).
    NS_ConvertUTF16toUTF8 utf8(aBuffer);
    completed = ParseSheet(utf8, *data, AllowAsyncParse::No);
    if (completed == Completed::Yes) {
      // TODO(emilio): Try to cache sheets with @import rules, maybe?
      if (isWorthCaching) {
        mSheets->mInlineSheets.Put(aBuffer, std::move(sheet));
      }
    } else {
      data->mMustNotify = true;
    }
  }

  return LoadSheetResult{completed, isAlternate, matched};
}

Result<Loader::LoadSheetResult, nsresult> Loader::LoadStyleLink(
    const SheetInfo& aInfo, nsICSSLoaderObserver* aObserver) {
  MOZ_ASSERT(aInfo.mURI, "Must have URL to load");
  LOG(("css::Loader::LoadStyleLink"));
  LOG_URI("  Link uri: '%s'", aInfo.mURI);
  LOG(("  Link title: '%s'", NS_ConvertUTF16toUTF8(aInfo.mTitle).get()));
  LOG(("  Link media: '%s'", NS_ConvertUTF16toUTF8(aInfo.mMedia).get()));
  LOG(("  Link alternate rel: %d", aInfo.mHasAlternateRel));

  if (!mEnabled) {
    LOG_WARN(("  Not enabled"));
    return Err(NS_ERROR_NOT_AVAILABLE);
  }

  if (!mDocument) {
    return Err(NS_ERROR_NOT_INITIALIZED);
  }

  nsIPrincipal* loadingPrincipal = aInfo.mContent
                                       ? aInfo.mContent->NodePrincipal()
                                       : mDocument->NodePrincipal();

  nsIPrincipal* principal = aInfo.mTriggeringPrincipal
                                ? aInfo.mTriggeringPrincipal.get()
                                : loadingPrincipal;

  nsINode* context = aInfo.mContent;
  if (!context) {
    context = mDocument;
  }

  bool syncLoad = aInfo.mContent && aInfo.mContent->IsInUAWidget() &&
                  IsChromeURI(aInfo.mURI);
  LOG(("  Link sync load: '%s'", syncLoad ? "true" : "false"));
  MOZ_ASSERT_IF(syncLoad, !aObserver);

  nsresult rv = CheckContentPolicy(loadingPrincipal, principal, aInfo.mURI,
                                   context, aInfo.mNonce, IsPreload::No);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    // Don't fire the error event if our document is loaded as data.  We're
    // supposed to not even try to do loads in that case... Unfortunately, we
    // implement that via nsDataDocumentContentPolicy, which doesn't have a good
    // way to communicate back to us that _it_ is the thing that blocked the
    // load.
    if (aInfo.mContent && !mDocument->IsLoadedAsData()) {
      // Fire an async error event on it.
      RefPtr<AsyncEventDispatcher> loadBlockingAsyncDispatcher =
          new LoadBlockingAsyncEventDispatcher(
              aInfo.mContent, NS_LITERAL_STRING("error"), CanBubble::eNo,
              ChromeOnlyDispatch::eNo);
      loadBlockingAsyncDispatcher->PostDOMEvent();
    }
    return Err(rv);
  }

  // Check IsAlternateSheet now, since it can mutate our document and make
  // pending sheets go to the non-pending state.
  auto isAlternate = IsAlternateSheet(aInfo.mTitle, aInfo.mHasAlternateRel);
  auto [sheet, state] = CreateSheet(aInfo, principal, eAuthorSheetFeatures,
                                    syncLoad, IsPreload::No);

  LOG(("  Sheet is alternate: %d", static_cast<int>(isAlternate)));

  auto matched = PrepareSheet(*sheet, aInfo.mTitle, aInfo.mMedia, nullptr,
                              isAlternate, aInfo.mIsExplicitlyEnabled);

  InsertSheetInTree(*sheet, aInfo.mContent);

  // We may get here with no content for Link: headers for example.
  MOZ_ASSERT(!aInfo.mContent || LinkStyle::FromNode(*aInfo.mContent),
             "If there is any node, it should be a LinkStyle");
  auto data = MakeRefPtr<SheetLoadData>(
      this, aInfo.mTitle, aInfo.mURI, sheet, syncLoad, aInfo.mContent,
      isAlternate, matched, IsPreload::No, aObserver, principal,
      aInfo.mReferrerInfo, context);
  if (state == SheetState::Complete) {
    LOG(("  Sheet already complete: 0x%p", sheet.get()));
    if (aObserver || !mObservers.IsEmpty() || aInfo.mContent) {
      rv = PostLoadEvent(std::move(data));
      if (NS_FAILED(rv)) {
        return Err(rv);
      }
    } else {
#ifdef MOZ_DIAGNOSTIC_ASSERT_ENABLED
      // We don't have to notify anyone of this load, as it was complete, so
      // drop it intentionally.
      data->mIntentionallyDropped = true;
#endif
    }

    // The load hasn't been completed yet, will be done in PostLoadEvent.
    return LoadSheetResult{Completed::No, isAlternate, matched};
  }

  // Now we need to actually load it.

  auto result = LoadSheetResult{Completed::No, isAlternate, matched};

  MOZ_ASSERT(result.ShouldBlock() == !data->ShouldDefer(),
             "These should better match!");

  // If we have to parse and it's a non-blocking non-inline sheet, defer it.
  if (!syncLoad && state == SheetState::NeedsParser &&
      mSheets->mLoadingDatas.Count() != 0 && !result.ShouldBlock()) {
    LOG(("  Deferring sheet load"));
    SheetLoadDataHashKey key(*data);
    mSheets->mPendingDatas.Put(&key, RefPtr{data});
    data->mMustNotify = true;
    return result;
  }

  // Load completion will free the data
  rv = LoadSheet(*data, state);
  if (NS_FAILED(rv)) {
    return Err(rv);
  }

  if (!syncLoad) {
    data->mMustNotify = true;
  }
  return result;
}

static bool HaveAncestorDataWithURI(SheetLoadData& aData, nsIURI* aURI) {
  if (!aData.mURI) {
    // Inline style; this won't have any ancestors
    MOZ_ASSERT(!aData.mParentData, "How does inline style have a parent?");
    return false;
  }

  bool equal;
  if (NS_FAILED(aData.mURI->Equals(aURI, &equal)) || equal) {
    return true;
  }

  // Datas down the mNext chain have the same URI as aData, so we
  // don't have to compare to them.  But they might have different
  // parents, and we have to check all of those.
  SheetLoadData* data = &aData;
  do {
    if (data->mParentData &&
        HaveAncestorDataWithURI(*data->mParentData, aURI)) {
      return true;
    }

    data = data->mNext;
  } while (data);

  return false;
}

nsresult Loader::LoadChildSheet(StyleSheet& aParentSheet,
                                SheetLoadData* aParentData, nsIURI* aURL,
                                dom::MediaList* aMedia,
                                LoaderReusableStyleSheets* aReusableSheets) {
  LOG(("css::Loader::LoadChildSheet"));
  MOZ_ASSERT(aURL, "Must have a URI to load");

  if (!mEnabled) {
    LOG_WARN(("  Not enabled"));
    return NS_ERROR_NOT_AVAILABLE;
  }

  LOG_URI("  Child uri: '%s'", aURL);

  nsCOMPtr<nsINode> owningNode;

  // Check for an associated document or shadow root: if none, don't bother
  // walking up the parent sheets.
  if (aParentSheet.GetAssociatedDocumentOrShadowRoot()) {
    StyleSheet* topSheet = &aParentSheet;
    while (StyleSheet* parent = topSheet->GetParentSheet()) {
      topSheet = parent;
    }
    owningNode = topSheet->GetOwnerNode();
  }

  nsINode* context = nullptr;
  nsIPrincipal* loadingPrincipal = nullptr;
  if (owningNode) {
    context = owningNode;
    loadingPrincipal = owningNode->NodePrincipal();
  } else if (mDocument) {
    context = mDocument;
    loadingPrincipal = mDocument->NodePrincipal();
  }

  nsIPrincipal* principal = aParentSheet.Principal();
  nsresult rv = CheckContentPolicy(loadingPrincipal, principal, aURL, context,
                                   EmptyString(), IsPreload::No);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    if (aParentData) {
      MarkLoadTreeFailed(*aParentData);
    }
    return rv;
  }

  nsCOMPtr<nsICSSLoaderObserver> observer;

  if (aParentData) {
    LOG(("  Have a parent load"));
    // Check for cycles
    if (HaveAncestorDataWithURI(*aParentData, aURL)) {
      // Houston, we have a loop, blow off this child and pretend this never
      // happened
      LOG_ERROR(("  @import cycle detected, dropping load"));
      return NS_OK;
    }

    NS_ASSERTION(aParentData->mSheet == &aParentSheet,
                 "Unexpected call to LoadChildSheet");
  } else {
    LOG(("  No parent load; must be CSSOM"));
    // No parent load data, so the sheet will need to be notified when
    // we finish, if it can be, if we do the load asynchronously.
    observer = &aParentSheet;
  }

  // Now that we know it's safe to load this (passes security check and not a
  // loop) do so.
  RefPtr<StyleSheet> sheet;
  SheetState state;
  if (aReusableSheets && aReusableSheets->FindReusableStyleSheet(aURL, sheet)) {
    state = SheetState::Complete;
  } else {
    // For now, use CORS_NONE for child sheets
    std::tie(sheet, state) =
        CreateSheet(aURL, nullptr, principal, aParentSheet.ParsingMode(),
                    CORS_NONE, aParentSheet.GetReferrerInfo(),
                    EmptyString(),  // integrity is only checked on main sheet
                    aParentData && aParentData->mSyncLoad, IsPreload::No);
    PrepareSheet(*sheet, EmptyString(), EmptyString(), aMedia, IsAlternate::No,
                 IsExplicitlyEnabled::No);
  }

  MOZ_ASSERT(sheet);
  InsertChildSheet(*sheet, aParentSheet);

  if (state == SheetState::Complete) {
    LOG(("  Sheet already complete"));
    // We're completely done.  No need to notify, even, since the
    // @import rule addition/modification will trigger the right style
    // changes automatically.
    return NS_OK;
  }

  auto data = MakeRefPtr<SheetLoadData>(
      this, aURL, sheet, aParentData, observer, principal,
      aParentSheet.GetReferrerInfo(), context);

  bool syncLoad = data->mSyncLoad;

  // Load completion will release the data
  rv = LoadSheet(*data, state);
  NS_ENSURE_SUCCESS(rv, rv);

  if (!syncLoad) {
    data->mMustNotify = true;
  }
  return rv;
}

Result<RefPtr<StyleSheet>, nsresult> Loader::LoadSheetSync(
    nsIURI* aURL, SheetParsingMode aParsingMode,
    UseSystemPrincipal aUseSystemPrincipal) {
  LOG(("css::Loader::LoadSheetSync"));
  nsCOMPtr<nsIReferrerInfo> referrerInfo = new ReferrerInfo(nullptr);
  return InternalLoadNonDocumentSheet(
      aURL, IsPreload::No, aParsingMode, aUseSystemPrincipal, nullptr,
      referrerInfo, nullptr, CORS_NONE, EmptyString());
}

Result<RefPtr<StyleSheet>, nsresult> Loader::LoadSheet(
    nsIURI* aURI, SheetParsingMode aParsingMode,
    UseSystemPrincipal aUseSystemPrincipal, nsICSSLoaderObserver* aObserver) {
  nsCOMPtr<nsIReferrerInfo> referrerInfo = new ReferrerInfo(nullptr);
  return InternalLoadNonDocumentSheet(
      aURI, IsPreload::No, aParsingMode, aUseSystemPrincipal, nullptr,
      referrerInfo, aObserver, CORS_NONE, EmptyString());
}

Result<RefPtr<StyleSheet>, nsresult> Loader::LoadSheet(
    nsIURI* aURL, IsPreload aIsPreload, const Encoding* aPreloadEncoding,
    nsIReferrerInfo* aReferrerInfo, nsICSSLoaderObserver* aObserver,
    CORSMode aCORSMode, const nsAString& aIntegrity) {
  LOG(("css::Loader::LoadSheet(aURL, aObserver) api call"));
  return InternalLoadNonDocumentSheet(
      aURL, aIsPreload, eAuthorSheetFeatures, UseSystemPrincipal::No,
      aPreloadEncoding, aReferrerInfo, aObserver, aCORSMode, aIntegrity);
}

Result<RefPtr<StyleSheet>, nsresult> Loader::InternalLoadNonDocumentSheet(
    nsIURI* aURL, IsPreload aIsPreload, SheetParsingMode aParsingMode,
    UseSystemPrincipal aUseSystemPrincipal, const Encoding* aPreloadEncoding,
    nsIReferrerInfo* aReferrerInfo, nsICSSLoaderObserver* aObserver,
    CORSMode aCORSMode, const nsAString& aIntegrity) {
  MOZ_ASSERT(aURL, "Must have a URI to load");
  MOZ_ASSERT(aUseSystemPrincipal == UseSystemPrincipal::No || !aObserver,
             "Shouldn't load system-principal sheets async");
  MOZ_ASSERT(aReferrerInfo, "Must have referrerInfo");

  LOG_URI("  Non-document sheet uri: '%s'", aURL);

  if (!mEnabled) {
    LOG_WARN(("  Not enabled"));
    return Err(NS_ERROR_NOT_AVAILABLE);
  }

  nsCOMPtr<nsIPrincipal> loadingPrincipal =
      mDocument ? mDocument->NodePrincipal() : nullptr;
  nsresult rv = CheckContentPolicy(loadingPrincipal, loadingPrincipal, aURL,
                                   mDocument, EmptyString(), aIsPreload);
  if (NS_FAILED(rv)) {
    return Err(rv);
  }

  bool syncLoad = !aObserver;
  auto [sheet, state] =
      CreateSheet(aURL, nullptr, loadingPrincipal, aParsingMode, aCORSMode,
                  aReferrerInfo, aIntegrity, syncLoad, aIsPreload);

  PrepareSheet(*sheet, EmptyString(), EmptyString(), nullptr, IsAlternate::No,
               IsExplicitlyEnabled::No);

  auto data = MakeRefPtr<SheetLoadData>(
      this, aURL, sheet, syncLoad, aUseSystemPrincipal, aIsPreload,
      aPreloadEncoding, aObserver, loadingPrincipal, aReferrerInfo, mDocument);
  if (state == SheetState::Complete) {
    LOG(("  Sheet already complete"));
    if (aObserver || !mObservers.IsEmpty()) {
      rv = PostLoadEvent(std::move(data));
      if (NS_FAILED(rv)) {
        return Err(rv);
      }
    } else {
      // We don't have to notify anyone of this load, as it was complete, so
      // drop it intentionally.
#ifdef MOZ_DIAGNOSTIC_ASSERT_ENABLED
      data->mIntentionallyDropped = true;
#endif
    }
    return sheet;
  }

  rv = LoadSheet(*data, state);
  if (NS_FAILED(rv)) {
    return Err(rv);
  }
  if (aObserver) {
    data->mMustNotify = true;
  }
  return sheet;
}

nsresult Loader::PostLoadEvent(RefPtr<SheetLoadData> aLoadData) {
  LOG(("css::Loader::PostLoadEvent"));
  mPostedEvents.AppendElement(aLoadData);

  nsresult rv;
  RefPtr<SheetLoadData> runnable(aLoadData);
  if (mDocument) {
    rv = mDocument->Dispatch(TaskCategory::Other, runnable.forget());
  } else if (mDocGroup) {
    rv = mDocGroup->Dispatch(TaskCategory::Other, runnable.forget());
  } else {
    rv = SchedulerGroup::Dispatch(TaskCategory::Other, runnable.forget());
  }

  if (NS_FAILED(rv)) {
    NS_WARNING("failed to dispatch stylesheet load event");
    mPostedEvents.RemoveElement(aLoadData);
  } else {
    // We'll unblock onload when we handle the event.
    BlockOnload();

    // We want to notify the observer for this data.
    aLoadData->mMustNotify = true;
    aLoadData->mSheetAlreadyComplete = true;

    // If we get to this code, aSheet loaded correctly at some point, so
    // we can just schedule a load event and don't need to touch the
    // data's mLoadFailed.  Note that we do this here and not from
    // inside our SheetComplete so that we don't end up running the load
    // event async.
    MOZ_ASSERT(!aLoadData->mLoadFailed, "Why are we marked as failed?");
    aLoadData->ScheduleLoadEventIfNeeded();
  }

  return rv;
}

void Loader::HandleLoadEvent(SheetLoadData& aEvent) {
  // XXXbz can't assert this yet.... May not have an observer because
  // we're unblocking the parser
  // NS_ASSERTION(aEvent->mObserver, "Must have observer");
  NS_ASSERTION(aEvent.mSheet, "Must have sheet");

  // Very important: this needs to come before the SheetComplete call
  // below, so that HasPendingLoads() will test true as needed under
  // notifications we send from that SheetComplete call.
  mPostedEvents.RemoveElement(&aEvent);

  if (!aEvent.mIsCancelled) {
    SheetComplete(aEvent, NS_OK);
  }

  UnblockOnload(true);
}

void Loader::Stop() {
  uint32_t pendingCount = mSheets ? mSheets->mPendingDatas.Count() : 0;
  uint32_t loadingCount = mSheets ? mSheets->mLoadingDatas.Count() : 0;
  LoadDataArray arr(pendingCount + loadingCount + mPostedEvents.Length());

  if (pendingCount) {
    for (auto iter = mSheets->mPendingDatas.Iter(); !iter.Done(); iter.Next()) {
      RefPtr<SheetLoadData>& data = iter.Data();
      data->mIsLoading = false;  // we will handle the removal right here
      data->mIsCancelled = true;
      arr.AppendElement(std::move(data));
    }
    mSheets->mPendingDatas.Clear();
  }
  if (loadingCount) {
    for (auto iter = mSheets->mLoadingDatas.Iter(); !iter.Done(); iter.Next()) {
      SheetLoadData* data = iter.Data();
      data->mIsLoading = false;  // we will handle the removal right here
      data->mIsCancelled = true;
      arr.AppendElement(data);
    }
    mSheets->mLoadingDatas.Clear();
  }

  for (RefPtr<SheetLoadData>& data : mPostedEvents) {
    data->mIsCancelled = true;
    // Move since we're about to get rid of the array below.
    arr.AppendElement(std::move(data));
  }
  mPostedEvents.Clear();

  mDatasToNotifyOn += arr.Length();
  for (RefPtr<SheetLoadData>& data : arr) {
    --mDatasToNotifyOn;
    SheetComplete(*data, NS_BINDING_ABORTED);
  }
}

bool Loader::HasPendingLoads() {
  return (mSheets && mSheets->mLoadingDatas.Count() != 0) ||
         (mSheets && mSheets->mPendingDatas.Count() != 0) ||
         mPostedEvents.Length() != 0 || mDatasToNotifyOn != 0;
}

void Loader::AddObserver(nsICSSLoaderObserver* aObserver) {
  MOZ_ASSERT(aObserver, "Must have observer");
  mObservers.AppendElementUnlessExists(aObserver);
}

void Loader::RemoveObserver(nsICSSLoaderObserver* aObserver) {
  mObservers.RemoveElement(aObserver);
}

void Loader::StartDeferredLoads() {
  MOZ_ASSERT(mSheets, "Don't call me!");
  LoadDataArray arr(mSheets->mPendingDatas.Count());
  for (auto iter = mSheets->mPendingDatas.Iter(); !iter.Done(); iter.Next()) {
    arr.AppendElement(iter.Data());
    iter.Remove();
  }

  mDatasToNotifyOn += arr.Length();
  for (RefPtr<SheetLoadData>& data : arr) {
    --mDatasToNotifyOn;
    LoadSheet(*data, SheetState::NeedsParser);
  }
}

NS_IMPL_CYCLE_COLLECTION_CLASS(Loader)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(Loader)
  if (tmp->mSheets) {
    for (auto iter = tmp->mSheets->mCompleteSheets.Iter(); !iter.Done();
         iter.Next()) {
      NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "OOL sheet cache in Loader");
      cb.NoteXPCOMChild(iter.UserData());
    }
    for (auto iter = tmp->mSheets->mInlineSheets.Iter(); !iter.Done();
         iter.Next()) {
      NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "Inline sheet cache in Loader");
      cb.NoteXPCOMChild(iter.UserData());
    }
  }
  nsTObserverArray<nsCOMPtr<nsICSSLoaderObserver>>::ForwardIterator it(
      tmp->mObservers);
  while (it.HasMore()) {
    ImplCycleCollectionTraverse(cb, it.GetNext(),
                                "mozilla::css::Loader.mObservers");
  }
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(Loader)
  if (tmp->mSheets) {
    tmp->mSheets->mCompleteSheets.Clear();
    tmp->mSheets->mInlineSheets.Clear();
  }
  tmp->mObservers.Clear();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_ROOT_NATIVE(Loader, AddRef)
NS_IMPL_CYCLE_COLLECTION_UNROOT_NATIVE(Loader, Release)

size_t Loader::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const {
  size_t n = aMallocSizeOf(this);

  if (mSheets) {
    n += mSheets->SizeOfIncludingThis(aMallocSizeOf);
  }
  n += mObservers.ShallowSizeOfExcludingThis(aMallocSizeOf);

  // Measurement of the following members may be added later if DMD finds it is
  // worthwhile:
  // - mPostedEvents: transient, and should be small
  //
  // The following members aren't measured:
  // - mDocument, because it's a weak backpointer

  return n;
}

void Loader::BlockOnload() {
  if (mDocument) {
    mDocument->BlockOnload();
  }
}

void Loader::UnblockOnload(bool aFireSync) {
  if (mDocument) {
    mDocument->UnblockOnload(aFireSync);
  }
}

already_AddRefed<nsISerialEventTarget> Loader::DispatchTarget() {
  nsCOMPtr<nsISerialEventTarget> target;
  if (mDocument) {
    // If you change this, you may want to change StyleSheet::Replace
    target = mDocument->EventTargetFor(TaskCategory::Other);
  } else if (mDocGroup) {
    target = mDocGroup->EventTargetFor(TaskCategory::Other);
  } else {
    target = GetMainThreadSerialEventTarget();
  }

  return target.forget();
}

}  // namespace css
}  // namespace mozilla
