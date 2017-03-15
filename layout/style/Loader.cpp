/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: ft=cpp tw=78 sw=2 et ts=2
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This Original Code has been modified by IBM Corporation.
 * Modifications made by IBM described herein are Copyright (c)
 * International Business Machines Corporation, 2000.  Modifications
 * to Mozilla code or documentation identified per MPL Section 3.3
 *
 * Date             Modified by     Description of modification
 * 04/20/2000       IBM Corp.      OS/2 VisualAge build.
 */

/* loading of CSS style sheets using the network APIs */

#include "mozilla/ArrayUtils.h"
#include "mozilla/LoadInfo.h"
#include "mozilla/MemoryReporting.h"

#include "mozilla/css/Loader.h"
#include "mozilla/StyleSheetInlines.h"
#include "nsIRunnable.h"
#include "nsIUnicharStreamLoader.h"
#include "nsSyncLoadService.h"
#include "nsCOMPtr.h"
#include "nsString.h"
#include "nsIContent.h"
#include "nsIDocument.h"
#include "nsIDOMNode.h"
#include "nsIDOMDocument.h"
#include "nsIURI.h"
#include "nsNetUtil.h"
#include "nsIProtocolHandler.h"
#include "nsContentUtils.h"
#include "nsIScriptSecurityManager.h"
#include "nsContentPolicyUtils.h"
#include "nsIHttpChannel.h"
#include "nsIHttpChannelInternal.h"
#include "nsIClassOfService.h"
#include "nsIScriptError.h"
#include "nsMimeTypes.h"
#include "nsIStyleSheetLinkingElement.h"
#include "nsICSSLoaderObserver.h"
#include "nsCSSParser.h"
#include "mozilla/css/ImportRule.h"
#include "nsThreadUtils.h"
#include "nsGkAtoms.h"
#include "nsIThreadInternal.h"
#include "nsINetworkPredictor.h"
#include "mozilla/dom/ShadowRoot.h"
#include "mozilla/dom/URL.h"
#include "mozilla/AsyncEventDispatcher.h"
#include "mozilla/StyleSheet.h"
#include "mozilla/StyleSheetInlines.h"
#include "mozilla/ConsoleReportCollector.h"

#ifdef MOZ_XUL
#include "nsXULPrototypeCache.h"
#endif

#include "nsIMediaList.h"
#include "nsIDOMStyleSheet.h"
#include "nsError.h"

#include "nsIContentSecurityPolicy.h"
#include "mozilla/dom/SRICheck.h"

#include "mozilla/dom/EncodingUtils.h"
using mozilla::dom::EncodingUtils;

using namespace mozilla::dom;

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
 *    InsertSheetInDoc() and InsertChildSheet()
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

namespace mozilla {
namespace css {

/*********************************************
 * Data needed to properly load a stylesheet *
 *********************************************/

static_assert(eAuthorSheetFeatures == 0 &&
              eUserSheetFeatures == 1 &&
              eAgentSheetFeatures == 2,
              "sheet parsing mode constants won't fit "
              "in SheetLoadData::mParsingMode");

class SheetLoadData final : public nsIRunnable,
                            public nsIUnicharStreamLoaderObserver,
                            public nsIThreadObserver
{
protected:
  virtual ~SheetLoadData(void);

public:
  // Data for loading a sheet linked from a document
  SheetLoadData(Loader* aLoader,
                const nsSubstring& aTitle,
                nsIURI* aURI,
                StyleSheet* aSheet,
                nsIStyleSheetLinkingElement* aOwningElement,
                bool aIsAlternate,
                nsICSSLoaderObserver* aObserver,
                nsIPrincipal* aLoaderPrincipal,
                nsINode* aRequestingNode);

  // Data for loading a sheet linked from an @import rule
  SheetLoadData(Loader* aLoader,
                nsIURI* aURI,
                StyleSheet* aSheet,
                SheetLoadData* aParentData,
                nsICSSLoaderObserver* aObserver,
                nsIPrincipal* aLoaderPrincipal,
                nsINode* aRequestingNode);

  // Data for loading a non-document sheet
  SheetLoadData(Loader* aLoader,
                nsIURI* aURI,
                StyleSheet* aSheet,
                bool aSyncLoad,
                bool aUseSystemPrincipal,
                const nsCString& aCharset,
                nsICSSLoaderObserver* aObserver,
                nsIPrincipal* aLoaderPrincipal,
                nsINode* aRequestingNode);

  already_AddRefed<nsIURI> GetReferrerURI();

  void ScheduleLoadEventIfNeeded(nsresult aStatus);

  NS_DECL_ISUPPORTS
  NS_DECL_NSIRUNNABLE
  NS_DECL_NSITHREADOBSERVER
  NS_DECL_NSIUNICHARSTREAMLOADEROBSERVER

  // Hold a ref to the CSSLoader so we can call back to it to let it
  // know the load finished
  RefPtr<Loader>           mLoader;

  // Title needed to pull datas out of the pending datas table when
  // the preferred title is changed
  nsString                   mTitle;

  // Charset we decided to use for the sheet
  nsCString                  mCharset;

  // URI we're loading.  Null for inline sheets
  nsCOMPtr<nsIURI>           mURI;

  // Should be 1 for non-inline sheets.
  uint32_t                   mLineNumber;

  // The sheet we're loading data for
  RefPtr<StyleSheet> mSheet;

  // Linked list of datas for the same URI as us
  SheetLoadData*             mNext;  // strong ref

  // Load data for the sheet that @import-ed us if we were @import-ed
  // during the parse
  RefPtr<SheetLoadData>    mParentData;

  // Number of sheets we @import-ed that are still loading
  uint32_t                   mPendingChildren;

  // mSyncLoad is true when the load needs to be synchronous -- right
  // now only for LoadSheetSync and children of sync loads.
  bool                       mSyncLoad : 1;

  // mIsNonDocumentSheet is true if the load was triggered by LoadSheetSync or
  // LoadSheet or an @import from such a sheet.  Non-document sheet loads can
  // proceed even if we have no document.
  bool                       mIsNonDocumentSheet : 1;

  // mIsLoading is true from the moment we are placed in the loader's
  // "loading datas" table (right after the async channel is opened)
  // to the moment we are removed from said table (due to the load
  // completing or being cancelled).
  bool                       mIsLoading : 1;

  // mIsCancelled is set to true when a sheet load is stopped by
  // Stop() or StopLoadingSheet() (which was removed in Bug 556446).
  // SheetLoadData::OnStreamComplete() checks this to avoid parsing
  // sheets that have been cancelled and such.
  bool                       mIsCancelled : 1;

  // mMustNotify is true if the load data is being loaded async and
  // the original function call that started the load has returned.
  // This applies only to observer notifications; load/error events
  // are fired for any SheetLoadData that has a non-null
  // mOwningElement.
  bool                       mMustNotify : 1;

  // mWasAlternate is true if the sheet was an alternate when the load data was
  // created.
  bool                       mWasAlternate : 1;

  // mUseSystemPrincipal is true if the system principal should be used for
  // this sheet, no matter what the channel principal is.  Only true for sync
  // loads.
  bool                       mUseSystemPrincipal : 1;

  // If true, this SheetLoadData is being used as a way to handle
  // async observer notification for an already-complete sheet.
  bool                       mSheetAlreadyComplete : 1;

  // This is the element that imported the sheet.  Needed to get the
  // charset set on it and to fire load/error events.
  nsCOMPtr<nsIStyleSheetLinkingElement> mOwningElement;

  // The observer that wishes to be notified of load completion
  nsCOMPtr<nsICSSLoaderObserver>        mObserver;

  // The principal that identifies who started loading us.
  nsCOMPtr<nsIPrincipal>                mLoaderPrincipal;

  // The node that identifies who started loading us.
  nsCOMPtr<nsINode>                     mRequestingNode;

  // The charset to use if the transport and sheet don't indicate one.
  // May be empty.  Must be empty if mOwningElement is non-null.
  nsCString                             mCharsetHint;

  // The status our load ended up with; this determines whether we
  // should fire error events or load events.  This gets initialized
  // by ScheduleLoadEventIfNeeded, and is only used after that has
  // been called.
  MOZ_INIT_OUTSIDE_CTOR nsresult        mStatus;

private:
  void FireLoadEvent(nsIThreadInternal* aThread);
};

#include "mozilla/Logging.h"

static mozilla::LazyLogModule sCssLoaderLog("nsCSSLoader");

static mozilla::LazyLogModule gSriPRLog("SRI");

#define LOG_ERROR(args) MOZ_LOG(sCssLoaderLog, mozilla::LogLevel::Error, args)
#define LOG_WARN(args) MOZ_LOG(sCssLoaderLog, mozilla::LogLevel::Warning, args)
#define LOG_DEBUG(args) MOZ_LOG(sCssLoaderLog, mozilla::LogLevel::Debug, args)
#define LOG(args) LOG_DEBUG(args)

#define LOG_ERROR_ENABLED() MOZ_LOG_TEST(sCssLoaderLog, mozilla::LogLevel::Error)
#define LOG_WARN_ENABLED() MOZ_LOG_TEST(sCssLoaderLog, mozilla::LogLevel::Warning)
#define LOG_DEBUG_ENABLED() MOZ_LOG_TEST(sCssLoaderLog, mozilla::LogLevel::Debug)
#define LOG_ENABLED() LOG_DEBUG_ENABLED()

#define LOG_URI(format, uri)                        \
  PR_BEGIN_MACRO                                    \
    NS_ASSERTION(uri, "Logging null uri");          \
    if (LOG_ENABLED()) {                            \
      LOG((format, uri->GetSpecOrDefault().get())); \
    }                                               \
  PR_END_MACRO

// And some convenience strings...
static const char* const gStateStrings[] = {
  "eSheetStateUnknown",
  "eSheetNeedsParser",
  "eSheetPending",
  "eSheetLoading",
  "eSheetComplete"
};

/********************************
 * SheetLoadData implementation *
 ********************************/
NS_IMPL_ISUPPORTS(SheetLoadData, nsIUnicharStreamLoaderObserver, nsIRunnable,
                  nsIThreadObserver)

SheetLoadData::SheetLoadData(Loader* aLoader,
                             const nsSubstring& aTitle,
                             nsIURI* aURI,
                             StyleSheet* aSheet,
                             nsIStyleSheetLinkingElement* aOwningElement,
                             bool aIsAlternate,
                             nsICSSLoaderObserver* aObserver,
                             nsIPrincipal* aLoaderPrincipal,
                             nsINode* aRequestingNode)
  : mLoader(aLoader),
    mTitle(aTitle),
    mURI(aURI),
    mLineNumber(1),
    mSheet(aSheet),
    mNext(nullptr),
    mPendingChildren(0),
    mSyncLoad(false),
    mIsNonDocumentSheet(false),
    mIsLoading(false),
    mIsCancelled(false),
    mMustNotify(false),
    mWasAlternate(aIsAlternate),
    mUseSystemPrincipal(false),
    mSheetAlreadyComplete(false),
    mOwningElement(aOwningElement),
    mObserver(aObserver),
    mLoaderPrincipal(aLoaderPrincipal),
    mRequestingNode(aRequestingNode)
{
  NS_PRECONDITION(mLoader, "Must have a loader!");
}

SheetLoadData::SheetLoadData(Loader* aLoader,
                             nsIURI* aURI,
                             StyleSheet* aSheet,
                             SheetLoadData* aParentData,
                             nsICSSLoaderObserver* aObserver,
                             nsIPrincipal* aLoaderPrincipal,
                             nsINode* aRequestingNode)
  : mLoader(aLoader),
    mURI(aURI),
    mLineNumber(1),
    mSheet(aSheet),
    mNext(nullptr),
    mParentData(aParentData),
    mPendingChildren(0),
    mSyncLoad(false),
    mIsNonDocumentSheet(false),
    mIsLoading(false),
    mIsCancelled(false),
    mMustNotify(false),
    mWasAlternate(false),
    mUseSystemPrincipal(false),
    mSheetAlreadyComplete(false),
    mOwningElement(nullptr),
    mObserver(aObserver),
    mLoaderPrincipal(aLoaderPrincipal),
    mRequestingNode(aRequestingNode)
{
  NS_PRECONDITION(mLoader, "Must have a loader!");
  if (mParentData) {
    mSyncLoad = mParentData->mSyncLoad;
    mIsNonDocumentSheet = mParentData->mIsNonDocumentSheet;
    mUseSystemPrincipal = mParentData->mUseSystemPrincipal;
    ++(mParentData->mPendingChildren);
  }

  NS_POSTCONDITION(!mUseSystemPrincipal || mSyncLoad,
                   "Shouldn't use system principal for async loads");
}

SheetLoadData::SheetLoadData(Loader* aLoader,
                             nsIURI* aURI,
                             StyleSheet* aSheet,
                             bool aSyncLoad,
                             bool aUseSystemPrincipal,
                             const nsCString& aCharset,
                             nsICSSLoaderObserver* aObserver,
                             nsIPrincipal* aLoaderPrincipal,
                             nsINode* aRequestingNode)
  : mLoader(aLoader),
    mURI(aURI),
    mLineNumber(1),
    mSheet(aSheet),
    mNext(nullptr),
    mPendingChildren(0),
    mSyncLoad(aSyncLoad),
    mIsNonDocumentSheet(true),
    mIsLoading(false),
    mIsCancelled(false),
    mMustNotify(false),
    mWasAlternate(false),
    mUseSystemPrincipal(aUseSystemPrincipal),
    mSheetAlreadyComplete(false),
    mOwningElement(nullptr),
    mObserver(aObserver),
    mLoaderPrincipal(aLoaderPrincipal),
    mRequestingNode(aRequestingNode),
    mCharsetHint(aCharset)
{
  NS_PRECONDITION(mLoader, "Must have a loader!");
  NS_POSTCONDITION(!mUseSystemPrincipal || mSyncLoad,
                   "Shouldn't use system principal for async loads");
}

SheetLoadData::~SheetLoadData()
{
  NS_CSS_NS_RELEASE_LIST_MEMBER(SheetLoadData, this, mNext);
}

NS_IMETHODIMP
SheetLoadData::Run()
{
  mLoader->HandleLoadEvent(this);
  return NS_OK;
}

NS_IMETHODIMP
SheetLoadData::OnDispatchedEvent(nsIThreadInternal* aThread)
{
  return NS_OK;
}

NS_IMETHODIMP
SheetLoadData::OnProcessNextEvent(nsIThreadInternal* aThread,
                                  bool aMayWait)
{
  // XXXkhuey this is insane!
  // We want to fire our load even before or after event processing,
  // whichever comes first.
  FireLoadEvent(aThread);
  return NS_OK;
}

NS_IMETHODIMP
SheetLoadData::AfterProcessNextEvent(nsIThreadInternal* aThread,
                                     bool aEventWasProcessed)
{
  // XXXkhuey this too!
  // We want to fire our load even before or after event processing,
  // whichever comes first.
  FireLoadEvent(aThread);
  return NS_OK;
}

void
SheetLoadData::FireLoadEvent(nsIThreadInternal* aThread)
{

  // First remove ourselves as a thread observer.  But we need to keep
  // ourselves alive while doing that!
  RefPtr<SheetLoadData> kungFuDeathGrip(this);
  aThread->RemoveObserver(this);

  // Now fire the event
  nsCOMPtr<nsINode> node = do_QueryInterface(mOwningElement);
  NS_ASSERTION(node, "How did that happen???");

  nsContentUtils::DispatchTrustedEvent(node->OwnerDoc(),
                                       node,
                                       NS_SUCCEEDED(mStatus) ?
                                         NS_LITERAL_STRING("load") :
                                         NS_LITERAL_STRING("error"),
                                       false, false);

  // And unblock onload
  if (mLoader->mDocument) {
    mLoader->mDocument->UnblockOnload(true);
  }
}

void
SheetLoadData::ScheduleLoadEventIfNeeded(nsresult aStatus)
{
  if (!mOwningElement) {
    return;
  }

  mStatus = aStatus;

  nsCOMPtr<nsIThread> thread = do_GetMainThread();
  nsCOMPtr<nsIThreadInternal> internalThread = do_QueryInterface(thread);
  if (NS_SUCCEEDED(internalThread->AddObserver(this))) {
    // Make sure to block onload here
    if (mLoader->mDocument) {
      mLoader->mDocument->BlockOnload();
    }
  }
}

/*********************
 * Style sheet reuse *
 *********************/

bool
LoaderReusableStyleSheets::FindReusableStyleSheet(nsIURI* aURL,
                                                  RefPtr<CSSStyleSheet>& aResult)
{
  MOZ_ASSERT(aURL);
  for (size_t i = mReusableSheets.Length(); i > 0; --i) {
    size_t index = i - 1;
    bool sameURI;
    MOZ_ASSERT(mReusableSheets[index]->GetOriginalURI());
    nsresult rv = aURL->Equals(mReusableSheets[index]->GetOriginalURI(),
                               &sameURI);
    if (!NS_FAILED(rv) && sameURI) {
      aResult = mReusableSheets[index];
      mReusableSheets.RemoveElementAt(index);
      return true;
    }
  }
  return false;
}

/*************************
 * Loader Implementation *
 *************************/

Loader::Loader(StyleBackendType aType)
  : mDocument(nullptr)
  , mDatasToNotifyOn(0)
  , mCompatMode(eCompatibility_FullStandards)
  , mStyleBackendType(Some(aType))
  , mEnabled(true)
  , mReporter(new ConsoleReportCollector())
#ifdef DEBUG
  , mSyncCallback(false)
#endif
{
}

Loader::Loader(nsIDocument* aDocument)
  : mDocument(aDocument)
  , mDatasToNotifyOn(0)
  , mCompatMode(eCompatibility_FullStandards)
  , mEnabled(true)
  , mReporter(new ConsoleReportCollector())
#ifdef DEBUG
  , mSyncCallback(false)
#endif
{
  // We can just use the preferred set, since there are no sheets in the
  // document yet (if there are, how did they get there? _we_ load the sheets!)
  // and hence the selected set makes no sense at this time.
  nsCOMPtr<nsIDOMDocument> domDoc = do_QueryInterface(mDocument);
  if (domDoc) {
    domDoc->GetPreferredStyleSheetSet(mPreferredSheet);
  }
}

Loader::~Loader()
{
  NS_ASSERTION(!mSheets || mSheets->mLoadingDatas.Count() == 0,
               "How did we get destroyed when there are loading data?");
  NS_ASSERTION(!mSheets || mSheets->mPendingDatas.Count() == 0,
               "How did we get destroyed when there are pending data?");
  // Note: no real need to revoke our stylesheet loaded events -- they
  // hold strong references to us, so if we're going away that means
  // they're all done.
}

void
Loader::DropDocumentReference(void)
{
  mDocument = nullptr;
  // Flush out pending datas just so we don't leak by accident.  These
  // loads should short-circuit through the mDocument check in
  // LoadSheet and just end up in SheetComplete immediately
  if (mSheets) {
    StartAlternateLoads();
  }
}

nsresult
Loader::SetPreferredSheet(const nsAString& aTitle)
{
#ifdef DEBUG
  nsCOMPtr<nsIDOMDocument> doc = do_QueryInterface(mDocument);
  if (doc) {
    nsAutoString currentPreferred;
    doc->GetLastStyleSheetSet(currentPreferred);
    if (DOMStringIsNull(currentPreferred)) {
      doc->GetPreferredStyleSheetSet(currentPreferred);
    }
    NS_ASSERTION(currentPreferred.Equals(aTitle),
                 "Unexpected argument to SetPreferredSheet");
  }
#endif

  mPreferredSheet = aTitle;

  // start any pending alternates that aren't alternates anymore
  if (mSheets) {
    LoadDataArray arr(mSheets->mPendingDatas.Count());
    for (auto iter = mSheets->mPendingDatas.Iter(); !iter.Done(); iter.Next()) {
      SheetLoadData* data = iter.Data();
      MOZ_ASSERT(data, "Must have a data");

      // Note that we don't want to affect what the selected style set is, so
      // use true for aHasAlternateRel.
      if (!data->mLoader->IsAlternate(data->mTitle, true)) {
        arr.AppendElement(data);
        iter.Remove();
      }
    }

    mDatasToNotifyOn += arr.Length();
    for (uint32_t i = 0; i < arr.Length(); ++i) {
      --mDatasToNotifyOn;
      LoadSheet(arr[i], eSheetNeedsParser, false);
    }
  }

  return NS_OK;
}

static const char kCharsetSym[] = "@charset \"";

static bool GetCharsetFromData(const char* aStyleSheetData,
                               uint32_t aDataLength,
                               nsACString& aCharset)
{
  aCharset.Truncate();
  if (aDataLength <= sizeof(kCharsetSym) - 1)
    return false;

  if (strncmp(aStyleSheetData,
              kCharsetSym,
              sizeof(kCharsetSym) - 1)) {
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

NS_IMETHODIMP
SheetLoadData::OnDetermineCharset(nsIUnicharStreamLoader* aLoader,
                                  nsISupports* aContext,
                                  nsACString const& aSegment,
                                  nsACString& aCharset)
{
  NS_PRECONDITION(!mOwningElement || mCharsetHint.IsEmpty(),
                  "Can't have element _and_ charset hint");

  LOG_URI("SheetLoadData::OnDetermineCharset for '%s'", mURI);

  // The precedence is (per CSS3 Syntax 2012-11-08 ED):
  // BOM
  // Channel
  // @charset rule
  // charset attribute on the referrer
  // encoding of the referrer
  // UTF-8

  aCharset.Truncate();

  if (nsContentUtils::CheckForBOM((const unsigned char*)aSegment.BeginReading(),
                                  aSegment.Length(),
                                  aCharset)) {
    // aCharset is now either "UTF-16BE", "UTF-16BE" or "UTF-8"
    // which will swallow the BOM.
    mCharset.Assign(aCharset);
    LOG(("  Setting from BOM to: %s", PromiseFlatCString(aCharset).get()));
    return NS_OK;
  }

  nsCOMPtr<nsIChannel> channel;
  nsAutoCString specified;
  aLoader->GetChannel(getter_AddRefs(channel));
  if (channel) {
    channel->GetContentCharset(specified);
    if (EncodingUtils::FindEncodingForLabel(specified, aCharset)) {
      mCharset.Assign(aCharset);
      LOG(("  Setting from HTTP to: %s", PromiseFlatCString(aCharset).get()));
      return NS_OK;
    }
  }

  if (GetCharsetFromData(aSegment.BeginReading(),
                         aSegment.Length(),
                         specified)) {
    if (EncodingUtils::FindEncodingForLabel(specified, aCharset)) {
      // FindEncodingForLabel currently never returns UTF-16LE but will
      // probably change to never return UTF-16 instead, so check both here
      // to avoid relying on the exact behavior.
      if (aCharset.EqualsLiteral("UTF-16") ||
          aCharset.EqualsLiteral("UTF-16BE") ||
          aCharset.EqualsLiteral("UTF-16LE")) {
        // Be consistent with HTML <meta> handling in face of impossibility.
        // When the @charset rule itself evidently was not UTF-16-encoded,
        // it saying UTF-16 has to be a lie.
        aCharset.AssignLiteral("UTF-8");
      }
      mCharset.Assign(aCharset);
      LOG(("  Setting from @charset rule to: %s",
          PromiseFlatCString(aCharset).get()));
      return NS_OK;
    }
  }

  // Now try the charset on the <link> or processing instruction
  // that loaded us
  if (mOwningElement) {
    nsAutoString specified16;
    mOwningElement->GetCharset(specified16);
    if (EncodingUtils::FindEncodingForLabel(specified16, aCharset)) {
      mCharset.Assign(aCharset);
      LOG(("  Setting from charset attribute to: %s",
          PromiseFlatCString(aCharset).get()));
      return NS_OK;
    }
  }

  // In the preload case, the value of the charset attribute on <link> comes
  // in via mCharsetHint instead.
  if (EncodingUtils::FindEncodingForLabel(mCharsetHint, aCharset)) {
    mCharset.Assign(aCharset);
      LOG(("  Setting from charset attribute (preload case) to: %s",
          PromiseFlatCString(aCharset).get()));
    return NS_OK;
  }

  // Try charset from the parent stylesheet.
  if (mParentData) {
    aCharset = mParentData->mCharset;
    if (!aCharset.IsEmpty()) {
      mCharset.Assign(aCharset);
      LOG(("  Setting from parent sheet to: %s",
          PromiseFlatCString(aCharset).get()));
      return NS_OK;
    }
  }

  if (mLoader->mDocument) {
    // no useful data on charset.  Try the document charset.
    aCharset = mLoader->mDocument->GetDocumentCharacterSet();
    MOZ_ASSERT(!aCharset.IsEmpty());
    mCharset.Assign(aCharset);
    LOG(("  Setting from document to: %s", PromiseFlatCString(aCharset).get()));
    return NS_OK;
  }

  aCharset.AssignLiteral("UTF-8");
  mCharset = aCharset;
  LOG(("  Setting from default to: %s", PromiseFlatCString(aCharset).get()));
  return NS_OK;
}

already_AddRefed<nsIURI>
SheetLoadData::GetReferrerURI()
{
  nsCOMPtr<nsIURI> uri;
  if (mParentData)
    uri = mParentData->mSheet->GetSheetURI();
  if (!uri && mLoader->mDocument)
    uri = mLoader->mDocument->GetDocumentURI();
  return uri.forget();
}

/*
 * Here we need to check that the load did not give us an http error
 * page and check the mimetype on the channel to make sure we're not
 * loading non-text/css data in standards mode.
 */
NS_IMETHODIMP
SheetLoadData::OnStreamComplete(nsIUnicharStreamLoader* aLoader,
                                nsISupports* aContext,
                                nsresult aStatus,
                                const nsAString& aBuffer)
{
  LOG(("SheetLoadData::OnStreamComplete"));
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
    mLoader->SheetComplete(this, NS_BINDING_ABORTED);
    return NS_OK;
  }

  if (NS_FAILED(aStatus)) {
    LOG_WARN(("  Load failed: status 0x%x", aStatus));
    // Handle sheet not loading error because source was a tracking URL.
    // We make a note of this sheet node by including it in a dedicated
    // array of blocked tracking nodes under its parent document.
    //
    // Multiple sheet load instances might be tied to this request,
    // we annotate each one linked to a valid owning element (node).
    if (aStatus == NS_ERROR_TRACKING_URI) {
      nsIDocument* doc = mLoader->GetDocument();
      if (doc) {
        for (SheetLoadData* data = this; data; data = data->mNext) {
          // mOwningElement may be null but AddBlockTrackingNode can cope
          nsCOMPtr<nsIContent> content = do_QueryInterface(data->mOwningElement);
          doc->AddBlockedTrackingNode(content);
        }
      }
    }
    mLoader->SheetComplete(this, aStatus);
    return NS_OK;
  }

  nsCOMPtr<nsIChannel> channel;
  nsresult result = aLoader->GetChannel(getter_AddRefs(channel));
  if (NS_FAILED(result)) {
    LOG_WARN(("  No channel from loader"));
    mLoader->SheetComplete(this, result);
    return NS_OK;
  }

  nsCOMPtr<nsIURI> originalURI;
  channel->GetOriginalURI(getter_AddRefs(originalURI));

  // If the channel's original URI is "chrome:", we want that, since
  // the observer code in nsXULPrototypeCache depends on chrome stylesheets
  // having a chrome URI.  (Whether or not chrome stylesheets come through
  // this codepath seems nondeterministic.)
  // Otherwise we want the potentially-HTTP-redirected URI.
  nsCOMPtr<nsIURI> channelURI;
  NS_GetFinalChannelURI(channel, getter_AddRefs(channelURI));

  if (!channelURI || !originalURI) {
    NS_ERROR("Someone just violated the nsIRequest contract");
    LOG_WARN(("  Channel without a URI.  Bad!"));
    mLoader->SheetComplete(this, NS_ERROR_UNEXPECTED);
    return NS_OK;
  }

  nsCOMPtr<nsIPrincipal> principal;
  nsIScriptSecurityManager* secMan = nsContentUtils::GetSecurityManager();
  result = NS_ERROR_NOT_AVAILABLE;
  if (secMan) {  // Could be null if we already shut down
    if (mUseSystemPrincipal) {
      result = secMan->GetSystemPrincipal(getter_AddRefs(principal));
    } else {
      result = secMan->GetChannelResultPrincipal(channel, getter_AddRefs(principal));
    }
  }

  if (NS_FAILED(result)) {
    LOG_WARN(("  Couldn't get principal"));
    mLoader->SheetComplete(this, result);
    return NS_OK;
  }

  mSheet->SetPrincipal(principal);

  // If it's an HTTP channel, we want to make sure this is not an
  // error document we got.
  nsCOMPtr<nsIHttpChannel> httpChannel(do_QueryInterface(channel));
  if (httpChannel) {
    bool requestSucceeded;
    result = httpChannel->GetRequestSucceeded(&requestSucceeded);
    if (NS_SUCCEEDED(result) && !requestSucceeded) {
      LOG(("  Load returned an error page"));
      mLoader->SheetComplete(this, NS_ERROR_NOT_AVAILABLE);
      return NS_OK;
    }
  }

  nsAutoCString contentType;
  if (channel) {
    channel->GetContentType(contentType);
  }

  // In standards mode, a style sheet must have one of these MIME
  // types to be processed at all.  In quirks mode, we accept any
  // MIME type, but only if the style sheet is same-origin with the
  // requesting document or parent sheet.  See bug 524223.

  bool validType = contentType.EqualsLiteral("text/css") ||
    contentType.EqualsLiteral(UNKNOWN_CONTENT_TYPE) ||
    contentType.IsEmpty();

  if (!validType) {
    const char *errorMessage;
    uint32_t errorFlag;
    bool sameOrigin = true;

    if (mLoaderPrincipal) {
      bool subsumed;
      result = mLoaderPrincipal->Subsumes(principal, &subsumed);
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

    const nsAFlatString& specUTF16 =
      NS_ConvertUTF8toUTF16(channelURI->GetSpecOrDefault());
    const nsAFlatString& ctypeUTF16 = NS_ConvertASCIItoUTF16(contentType);
    const char16_t *strings[] = { specUTF16.get(), ctypeUTF16.get() };

    nsCOMPtr<nsIURI> referrer = GetReferrerURI();
    nsContentUtils::ReportToConsole(errorFlag,
                                    NS_LITERAL_CSTRING("CSS Loader"),
                                    mLoader->mDocument,
                                    nsContentUtils::eCSS_PROPERTIES,
                                    errorMessage,
                                    strings, ArrayLength(strings),
                                    referrer);

    if (errorFlag == nsIScriptError::errorFlag) {
      LOG_WARN(("  Ignoring sheet with improper MIME type %s",
                contentType.get()));
      mLoader->SheetComplete(this, NS_ERROR_NOT_AVAILABLE);
      return NS_OK;
    }
  }

  SRIMetadata sriMetadata;
  mSheet->GetIntegrity(sriMetadata);
  if (sriMetadata.IsEmpty()) {
    nsCOMPtr<nsILoadInfo> loadInfo = channel->GetLoadInfo();
    if (loadInfo->GetEnforceSRI()) {
      LOG(("  Load was blocked by SRI"));
      MOZ_LOG(gSriPRLog, mozilla::LogLevel::Debug,
              ("css::Loader::OnStreamComplete, required SRI not found"));
      mLoader->SheetComplete(this, NS_ERROR_SRI_CORRUPT);
      // log the failed load to web console
      nsCOMPtr<nsIContentSecurityPolicy> csp;
      loadInfo->LoadingPrincipal()->GetCsp(getter_AddRefs(csp));
      nsAutoCString spec;
      mLoader->mDocument->GetDocumentURI()->GetAsciiSpec(spec);
      // line number unknown. mRequestingNode doesn't bear this info.
      csp->LogViolationDetails(
        nsIContentSecurityPolicy::VIOLATION_TYPE_REQUIRE_SRI_FOR_STYLE,
        NS_ConvertUTF8toUTF16(spec), EmptyString(),
        0, EmptyString(), EmptyString());
      return NS_OK;
    }
  } else {
    nsAutoCString sourceUri;
    if (mLoader->mDocument && mLoader->mDocument->GetDocumentURI()) {
      mLoader->mDocument->GetDocumentURI()->GetAsciiSpec(sourceUri);
    }
    nsresult rv = SRICheck::VerifyIntegrity(sriMetadata, aLoader, aBuffer,
                                            sourceUri, mLoader->mReporter);
    mLoader->mReporter->FlushConsoleReports(mLoader->mDocument);
    if (NS_FAILED(rv)) {
      LOG(("  Load was blocked by SRI"));
      MOZ_LOG(gSriPRLog, mozilla::LogLevel::Debug,
              ("css::Loader::OnStreamComplete, bad metadata"));
      mLoader->SheetComplete(this, NS_ERROR_SRI_CORRUPT);
      return NS_OK;
    }
  }

  // Enough to set the URIs on mSheet, since any sibling datas we have share
  // the same mInner as mSheet and will thus get the same URI.
  mSheet->SetURIs(channelURI, originalURI, channelURI);

  bool completed;
  result = mLoader->ParseSheet(aBuffer, this, completed);
  NS_ASSERTION(completed || !mSyncLoad, "sync load did not complete");
  return result;
}

bool
Loader::IsAlternate(const nsAString& aTitle, bool aHasAlternateRel)
{
  // A sheet is alternate if it has a nonempty title that doesn't match the
  // currently selected style set.  But if there _is_ no currently selected
  // style set, the sheet wasn't marked as an alternate explicitly, and aTitle
  // is nonempty, we should select the style set corresponding to aTitle, since
  // that's a preferred sheet.
  if (aTitle.IsEmpty()) {
    return false;
  }

  if (!aHasAlternateRel && mDocument && mPreferredSheet.IsEmpty()) {
    // There's no preferred set yet, and we now have a sheet with a title.
    // Make that be the preferred set.
    mDocument->SetHeaderData(nsGkAtoms::headerDefaultStyle, aTitle);
    // We're definitely not an alternate
    return false;
  }

  return !aTitle.Equals(mPreferredSheet);
}

nsresult
Loader::ObsoleteSheet(nsIURI* aURI)
{
  if (!mSheets) {
    return NS_OK;
  }
  if (!aURI) {
    return NS_ERROR_INVALID_ARG;
  }
  for (auto iter = mSheets->mCompleteSheets.Iter(); !iter.Done(); iter.Next()) {
    nsIURI* sheetURI = iter.Key()->GetURI();
    bool areEqual;
    nsresult rv = sheetURI->Equals(aURI, &areEqual);
    if (NS_SUCCEEDED(rv) && areEqual) {
      iter.Remove();
    }
  }
  return NS_OK;
}

nsresult
Loader::CheckContentPolicy(nsIPrincipal* aSourcePrincipal,
                          nsIURI* aTargetURI,
                          nsISupports* aContext,
                          bool aIsPreload)
{
  // When performing a system load (e.g. aUseSystemPrincipal = true)
  // then aSourcePrincipal == null; don't consult content policies.
  if (!aSourcePrincipal) {
    return NS_OK;
  }

  nsContentPolicyType contentPolicyType =
    aIsPreload ? nsIContentPolicy::TYPE_INTERNAL_STYLESHEET_PRELOAD
               : nsIContentPolicy::TYPE_INTERNAL_STYLESHEET;

  int16_t shouldLoad = nsIContentPolicy::ACCEPT;
  nsresult rv = NS_CheckContentLoadPolicy(contentPolicyType,
                                          aTargetURI,
                                          aSourcePrincipal,
                                          aContext,
                                          NS_LITERAL_CSTRING("text/css"),
                                          nullptr,  //extra param
                                          &shouldLoad,
                                          nsContentUtils::GetContentPolicy(),
                                          nsContentUtils::GetSecurityManager());
   if (NS_FAILED(rv) || NS_CP_REJECTED(shouldLoad)) {
     return NS_ERROR_CONTENT_BLOCKED;
   }
   return NS_OK;
}

/**
 * CreateSheet() creates a CSSStyleSheet object for the given URI,
 * if any.  If there is no URI given, we just create a new style sheet
 * object.  Otherwise, we check for an existing style sheet object for
 * that uri in various caches and clone it if we find it.  Cloned
 * sheets will have the title/media/enabled state of the sheet they
 * are clones off; make sure to call PrepareSheet() on the result of
 * CreateSheet().
 */
nsresult
Loader::CreateSheet(nsIURI* aURI,
                    nsIContent* aLinkingContent,
                    nsIPrincipal* aLoaderPrincipal,
                    css::SheetParsingMode aParsingMode,
                    CORSMode aCORSMode,
                    ReferrerPolicy aReferrerPolicy,
                    const nsAString& aIntegrity,
                    bool aSyncLoad,
                    bool aHasAlternateRel,
                    const nsAString& aTitle,
                    StyleSheetState& aSheetState,
                    bool *aIsAlternate,
                    RefPtr<StyleSheet>* aSheet)
{
  LOG(("css::Loader::CreateSheet"));
  NS_PRECONDITION(aSheet, "Null out param!");

  if (!mSheets) {
    mSheets = new Sheets();
  }

  *aSheet = nullptr;
  aSheetState = eSheetStateUnknown;

  // Check the alternate state before doing anything else, because it
  // can mess with our hashtables.
  *aIsAlternate = IsAlternate(aTitle, aHasAlternateRel);

  // XXXheycam Cached sheets currently must be CSSStyleSheets.
  if (aURI && GetStyleBackendType() == StyleBackendType::Gecko) {
    aSheetState = eSheetComplete;
    RefPtr<StyleSheet> sheet;

    // First, the XUL cache
#ifdef MOZ_XUL
    if (IsChromeURI(aURI)) {
      nsXULPrototypeCache* cache = nsXULPrototypeCache::GetInstance();
      if (cache) {
        if (cache->IsEnabled()) {
          sheet = cache->GetStyleSheet(aURI);
          LOG(("  From XUL cache: %p", sheet.get()));
        }
      }
    }
#endif

    bool fromCompleteSheets = false;
    if (!sheet) {
      // Then our per-document complete sheets.
      URIPrincipalReferrerPolicyAndCORSModeHashKey key(aURI, aLoaderPrincipal, aCORSMode, aReferrerPolicy);

      StyleSheet* completeSheet = nullptr;
      mSheets->mCompleteSheets.Get(&key, &completeSheet);
      sheet = completeSheet;
      LOG(("  From completed: %p", sheet.get()));

      fromCompleteSheets = !!sheet;
    }

    if (sheet) {
      if (sheet->IsServo()) {
        MOZ_CRASH("stylo: can't clone ServoStyleSheets yet");
      }

      // This sheet came from the XUL cache or our per-document hashtable; it
      // better be a complete sheet.
      NS_ASSERTION(sheet->AsGecko()->IsComplete(),
                   "Sheet thinks it's not complete while we think it is");

      // Make sure it hasn't been modified; if it has, we can't use it
      if (sheet->AsGecko()->IsModified()) {
        LOG(("  Not cloning completed sheet %p because it's been modified",
             sheet.get()));
        sheet = nullptr;
        fromCompleteSheets = false;
      }
    }

    // Then loading sheets
    if (!sheet && !aSyncLoad) {
      aSheetState = eSheetLoading;
      SheetLoadData* loadData = nullptr;
      URIPrincipalReferrerPolicyAndCORSModeHashKey key(aURI, aLoaderPrincipal, aCORSMode, aReferrerPolicy);
      mSheets->mLoadingDatas.Get(&key, &loadData);
      if (loadData) {
        sheet = loadData->mSheet;
        LOG(("  From loading: %p", sheet.get()));

#ifdef DEBUG
        bool debugEqual;
        NS_ASSERTION((!aLoaderPrincipal && !loadData->mLoaderPrincipal) ||
                     (aLoaderPrincipal && loadData->mLoaderPrincipal &&
                      NS_SUCCEEDED(aLoaderPrincipal->
                                   Equals(loadData->mLoaderPrincipal,
                                          &debugEqual)) && debugEqual),
                     "Principals should be the same");
#endif
      }

      // Then alternate sheets
      if (!sheet) {
        aSheetState = eSheetPending;
        loadData = nullptr;
        mSheets->mPendingDatas.Get(&key, &loadData);
        if (loadData) {
          sheet = loadData->mSheet;
          LOG(("  From pending: %p", sheet.get()));

#ifdef DEBUG
          bool debugEqual;
          NS_ASSERTION((!aLoaderPrincipal && !loadData->mLoaderPrincipal) ||
                       (aLoaderPrincipal && loadData->mLoaderPrincipal &&
                        NS_SUCCEEDED(aLoaderPrincipal->
                                     Equals(loadData->mLoaderPrincipal,
                                            &debugEqual)) && debugEqual),
                       "Principals should be the same");
#endif
        }
      }
    }

    if (sheet) {
      // The sheet we have now should be either incomplete or unmodified
      if (sheet->IsServo()) {
        MOZ_CRASH("stylo: can't clone ServoStyleSheets yet");
      }
      NS_ASSERTION(!sheet->AsGecko()->IsModified() ||
                   !sheet->AsGecko()->IsComplete(),
                   "Unexpected modified complete sheet");
      NS_ASSERTION(sheet->AsGecko()->IsComplete() ||
                   aSheetState != eSheetComplete,
                   "Sheet thinks it's not complete while we think it is");

      RefPtr<CSSStyleSheet> clonedSheet =
        sheet->AsGecko()->Clone(nullptr, nullptr, nullptr, nullptr);
      *aSheet = Move(clonedSheet);
      if (*aSheet && fromCompleteSheets &&
          !sheet->AsGecko()->GetOwnerNode() &&
          !sheet->AsGecko()->GetParentSheet()) {
        // The sheet we're cloning isn't actually referenced by
        // anyone.  Replace it in the cache, so that if our CSSOM is
        // later modified we don't end up with two copies of our inner
        // hanging around.
        URIPrincipalReferrerPolicyAndCORSModeHashKey key(aURI, aLoaderPrincipal, aCORSMode, aReferrerPolicy);
        NS_ASSERTION((*aSheet)->AsGecko()->IsComplete(),
                     "Should only be caching complete sheets");
        mSheets->mCompleteSheets.Put(&key, *aSheet);
      }
    }
  }

  if (!*aSheet) {
    aSheetState = eSheetNeedsParser;
    nsIURI *sheetURI;
    nsCOMPtr<nsIURI> baseURI;
    nsIURI* originalURI;
    if (!aURI) {
      // Inline style.  Use the document's base URL so that @import in
      // the inline sheet picks up the right base.
      NS_ASSERTION(aLinkingContent, "Inline stylesheet without linking content?");
      baseURI = aLinkingContent->GetBaseURI();
      sheetURI = aLinkingContent->OwnerDoc()->GetDocumentURI();
      originalURI = nullptr;
    } else {
      baseURI = aURI;
      sheetURI = aURI;
      originalURI = aURI;
    }

    SRIMetadata sriMetadata;
    if (!aIntegrity.IsEmpty()) {
      MOZ_LOG(gSriPRLog, mozilla::LogLevel::Debug,
              ("css::Loader::CreateSheet, integrity=%s",
               NS_ConvertUTF16toUTF8(aIntegrity).get()));
      nsAutoCString sourceUri;
      if (mDocument && mDocument->GetDocumentURI()) {
        mDocument->GetDocumentURI()->GetAsciiSpec(sourceUri);
      }
      SRICheck::IntegrityMetadata(aIntegrity, sourceUri, mReporter,
                                  &sriMetadata);
    }

    if (GetStyleBackendType() == StyleBackendType::Gecko) {
      *aSheet = new CSSStyleSheet(aParsingMode, aCORSMode, aReferrerPolicy, sriMetadata);
    } else {
      *aSheet = new ServoStyleSheet(aParsingMode, aCORSMode, aReferrerPolicy, sriMetadata);
    }
    (*aSheet)->SetURIs(sheetURI, originalURI, baseURI);
  }

  NS_ASSERTION(*aSheet, "We should have a sheet by now!");
  NS_ASSERTION(aSheetState != eSheetStateUnknown, "Have to set a state!");
  LOG(("  State: %s", gStateStrings[aSheetState]));

  return NS_OK;
}

/**
 * PrepareSheet() handles setting the media and title on the sheet, as
 * well as setting the enabled state based on the title and whether
 * the sheet had "alternate" in its rel.
 */
void
Loader::PrepareSheet(StyleSheet* aSheet,
                     const nsSubstring& aTitle,
                     const nsSubstring& aMediaString,
                     nsMediaList* aMediaList,
                     Element* aScopeElement,
                     bool isAlternate)
{
  NS_PRECONDITION(aSheet, "Must have a sheet!");

  // XXXheycam Need to set media, title, etc. on ServoStyleSheets.
  if (aSheet->IsServo()) {
    NS_WARNING("stylo: should set metadata on ServoStyleSheets. See bug 1290209.");
    return;
  }

  CSSStyleSheet* sheet = aSheet->AsGecko();

  RefPtr<nsMediaList> mediaList(aMediaList);

  if (!aMediaString.IsEmpty()) {
    NS_ASSERTION(!aMediaList,
                 "must not provide both aMediaString and aMediaList");
    mediaList = new nsMediaList();

    nsCSSParser mediumParser(this);

    // We have aMediaString only when linked from link elements, style
    // elements, or PIs, so pass true.
    mediumParser.ParseMediaList(aMediaString, nullptr, 0, mediaList, true);
  }

  sheet->SetMedia(mediaList);

  sheet->SetTitle(aTitle);
  sheet->SetEnabled(!isAlternate);
  sheet->SetScopeElement(aScopeElement);
}

/**
 * InsertSheetInDoc handles ordering of sheets in the document.  Here
 * we have two types of sheets -- those with linking elements and
 * those without.  The latter are loaded by Link: headers.
 * The following constraints are observed:
 * 1) Any sheet with a linking element comes after all sheets without
 *    linking elements
 * 2) Sheets without linking elements are inserted in the order in
 *    which the inserting requests come in, since all of these are
 *    inserted during header data processing in the content sink
 * 3) Sheets with linking elements are ordered based on document order
 *    as determined by CompareDocumentPosition.
 */
nsresult
Loader::InsertSheetInDoc(StyleSheet* aSheet,
                         nsIContent* aLinkingContent,
                         nsIDocument* aDocument)
{
  LOG(("css::Loader::InsertSheetInDoc"));
  NS_PRECONDITION(aSheet, "Nothing to insert");
  NS_PRECONDITION(aDocument, "Must have a document to insert into");

  // XXX Need to cancel pending sheet loads for this element, if any

  int32_t sheetCount = aDocument->GetNumberOfStyleSheets();

  /*
   * Start the walk at the _end_ of the list, since in the typical
   * case we'll just want to append anyway.  We want to break out of
   * the loop when insertionPoint points to just before the index we
   * want to insert at.  In other words, when we leave the loop
   * insertionPoint is the index of the stylesheet that immediately
   * precedes the one we're inserting.
   */
  int32_t insertionPoint;
  for (insertionPoint = sheetCount - 1; insertionPoint >= 0; --insertionPoint) {
    StyleSheet* curSheet = aDocument->GetStyleSheetAt(insertionPoint);
    NS_ASSERTION(curSheet, "There must be a sheet here!");
    nsCOMPtr<nsINode> sheetOwner = curSheet->GetOwnerNode();
    if (sheetOwner && !aLinkingContent) {
      // Keep moving; all sheets with a sheetOwner come after all
      // sheets without a linkingNode
      continue;
    }

    if (!sheetOwner) {
      // Aha!  The current sheet has no sheet owner, so we want to
      // insert after it no matter whether we have a linkingNode
      break;
    }

    NS_ASSERTION(aLinkingContent != sheetOwner,
                 "Why do we still have our old sheet?");

    // Have to compare
    if (nsContentUtils::PositionIsBefore(sheetOwner, aLinkingContent)) {
      // The current sheet comes before us, and it better be the first
      // such, because now we break
      break;
    }
  }

  ++insertionPoint; // adjust the index to the spot we want to insert in

  // XXX <meta> elements do not implement nsIStyleSheetLinkingElement;
  // need to fix this for them to be ordered correctly.
  nsCOMPtr<nsIStyleSheetLinkingElement>
    linkingElement = do_QueryInterface(aLinkingContent);
  if (linkingElement) {
    linkingElement->SetStyleSheet(aSheet); // This sets the ownerNode on the sheet
  }

  aDocument->BeginUpdate(UPDATE_STYLE);
  aDocument->InsertStyleSheetAt(aSheet, insertionPoint);
  aDocument->EndUpdate(UPDATE_STYLE);
  LOG(("  Inserting into document at position %d", insertionPoint));

  return NS_OK;
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
nsresult
Loader::InsertChildSheet(StyleSheet* aSheet,
                         StyleSheet* aParentSheet,
                         ImportRule* aParentRule)
{
  LOG(("css::Loader::InsertChildSheet"));
  NS_PRECONDITION(aSheet, "Nothing to insert");
  NS_PRECONDITION(aParentSheet, "Need a parent to insert into");
  NS_PRECONDITION(aParentSheet, "How did we get imported?");

  // XXXheycam The InsertChildSheet API doesn't work with ServoStyleSheets,
  // since they won't have Gecko ImportRules in them.
  if (aSheet->IsServo()) {
    return NS_ERROR_FAILURE;
  }

  // child sheets should always start out enabled, even if they got
  // cloned off of top-level sheets which were disabled
  aSheet->AsGecko()->SetEnabled(true);

  aParentSheet->AppendStyleSheet(aSheet);
  aParentRule->SetSheet(aSheet->AsGecko()); // This sets the ownerRule on the sheet

  LOG(("  Inserting into parent sheet"));
  //  LOG(("  Inserting into parent sheet at position %d", insertionPoint));

  return NS_OK;
}

/**
 * LoadSheet handles the actual load of a sheet.  If the load is
 * supposed to be synchronous it just opens a channel synchronously
 * using the given uri, wraps the resulting stream in a converter
 * stream and calls ParseSheet.  Otherwise it tries to look for an
 * existing load for this URI and piggyback on it.  Failing all that,
 * a new load is kicked off asynchronously.
 */
nsresult
Loader::LoadSheet(SheetLoadData* aLoadData,
                  StyleSheetState aSheetState,
                  bool aIsPreload)
{
  LOG(("css::Loader::LoadSheet"));
  NS_PRECONDITION(aLoadData, "Need a load data");
  NS_PRECONDITION(aLoadData->mURI, "Need a URI to load");
  NS_PRECONDITION(aLoadData->mSheet, "Need a sheet to load into");
  NS_PRECONDITION(aSheetState != eSheetComplete, "Why bother?");
  NS_PRECONDITION(!aLoadData->mUseSystemPrincipal || aLoadData->mSyncLoad,
                  "Shouldn't use system principal for async loads");
  NS_ASSERTION(mSheets, "mLoadingDatas should be initialized by now.");

  LOG_URI("  Load from: '%s'", aLoadData->mURI);

  nsresult rv = NS_OK;

  if (!mDocument && !aLoadData->mIsNonDocumentSheet) {
    // No point starting the load; just release all the data and such.
    LOG_WARN(("  No document and not non-document sheet; pre-dropping load"));
    SheetComplete(aLoadData, NS_BINDING_ABORTED);
    return NS_BINDING_ABORTED;
  }

  SRIMetadata sriMetadata;
  aLoadData->mSheet->GetIntegrity(sriMetadata);

  if (aLoadData->mSyncLoad) {
    LOG(("  Synchronous load"));
    NS_ASSERTION(!aLoadData->mObserver, "Observer for a sync load?");
    NS_ASSERTION(aSheetState == eSheetNeedsParser,
                 "Sync loads can't reuse existing async loads");

    // Create a nsIUnicharStreamLoader instance to which we will feed
    // the data from the sync load.  Do this before creating the
    // channel to make error recovery simpler.
    nsCOMPtr<nsIUnicharStreamLoader> streamLoader;
    rv = NS_NewUnicharStreamLoader(getter_AddRefs(streamLoader), aLoadData);
    if (NS_FAILED(rv)) {
      LOG_ERROR(("  Failed to create stream loader for sync load"));
      SheetComplete(aLoadData, rv);
      return rv;
    }

    if (mDocument) {
      mozilla::net::PredictorLearn(aLoadData->mURI, mDocument->GetDocumentURI(),
                                   nsINetworkPredictor::LEARN_LOAD_SUBRESOURCE,
                                   mDocument);
    }

    nsSecurityFlags securityFlags =
      nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_INHERITS |
      nsILoadInfo::SEC_ALLOW_CHROME;

    nsContentPolicyType contentPolicyType =
      aIsPreload ? nsIContentPolicy::TYPE_INTERNAL_STYLESHEET_PRELOAD
                 : nsIContentPolicy::TYPE_INTERNAL_STYLESHEET;

    // Just load it
    nsCOMPtr<nsIChannel> channel;
    // Note that we are calling NS_NewChannelWithTriggeringPrincipal() with both
    // a node and a principal.
    // This is because of a case where the node is the document being styled and
    // the principal is the stylesheet (perhaps from a different origin) that is
    // applying the styles.
    if (aLoadData->mRequestingNode && aLoadData->mLoaderPrincipal) {
      rv = NS_NewChannelWithTriggeringPrincipal(getter_AddRefs(channel),
                                                aLoadData->mURI,
                                                aLoadData->mRequestingNode,
                                                aLoadData->mLoaderPrincipal,
                                                securityFlags,
                                                contentPolicyType);
    }
    else {
      // either we are loading something inside a document, in which case
      // we should always have a requestingNode, or we are loading something
      // outside a document, in which case the loadingPrincipal and the
      // triggeringPrincipal should always be the systemPrincipal.
      rv = NS_NewChannel(getter_AddRefs(channel),
                         aLoadData->mURI,
                         nsContentUtils::GetSystemPrincipal(),
                         securityFlags,
                         contentPolicyType);
    }
    if (NS_FAILED(rv)) {
      LOG_ERROR(("  Failed to create channel"));
      SheetComplete(aLoadData, rv);
      return rv;
    }

    nsCOMPtr<nsIInputStream> stream;
    rv = channel->Open2(getter_AddRefs(stream));

    if (NS_FAILED(rv)) {
      LOG_ERROR(("  Failed to open URI synchronously"));
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
    return nsSyncLoadService::PushSyncStreamToListener(stream,
                                                       streamLoader,
                                                       channel);
  }

  SheetLoadData* existingData = nullptr;

  URIPrincipalReferrerPolicyAndCORSModeHashKey key(aLoadData->mURI,
                                     aLoadData->mLoaderPrincipal,
                                     aLoadData->mSheet->GetCORSMode(),
                                     aLoadData->mSheet->GetReferrerPolicy());
  if (aSheetState == eSheetLoading) {
    mSheets->mLoadingDatas.Get(&key, &existingData);
    NS_ASSERTION(existingData, "CreateSheet lied about the state");
  }
  else if (aSheetState == eSheetPending){
    mSheets->mPendingDatas.Get(&key, &existingData);
    NS_ASSERTION(existingData, "CreateSheet lied about the state");
  }

  if (existingData) {
    LOG(("  Glomming on to existing load"));
    SheetLoadData* data = existingData;
    while (data->mNext) {
      data = data->mNext;
    }
    data->mNext = aLoadData; // transfer ownership
    if (aSheetState == eSheetPending && !aLoadData->mWasAlternate) {
      // Kick the load off; someone cares about it right away

#ifdef DEBUG
      SheetLoadData* removedData;
      NS_ASSERTION(mSheets->mPendingDatas.Get(&key, &removedData) &&
                   removedData == existingData,
                   "Bad pending table.");
#endif

      mSheets->mPendingDatas.Remove(&key);

      LOG(("  Forcing load of pending data"));
      return LoadSheet(existingData, eSheetNeedsParser, aIsPreload);
    }
    // All done here; once the load completes we'll be marked complete
    // automatically
    return NS_OK;
  }

  nsCOMPtr<nsILoadGroup> loadGroup;
  if (mDocument) {
    loadGroup = mDocument->GetDocumentLoadGroup();
    // load for a document with no loadgrup indicates that something is
    // completely bogus, let's bail out early.
    if (!loadGroup) {
      LOG_ERROR(("  Failed to query loadGroup from document"));
      SheetComplete(aLoadData, NS_ERROR_UNEXPECTED);
      return NS_ERROR_UNEXPECTED;
    }
  }
#ifdef DEBUG
  mSyncCallback = true;
#endif

  CORSMode ourCORSMode = aLoadData->mSheet->GetCORSMode();
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
    aIsPreload ? nsIContentPolicy::TYPE_INTERNAL_STYLESHEET_PRELOAD
               : nsIContentPolicy::TYPE_INTERNAL_STYLESHEET;

  nsCOMPtr<nsIChannel> channel;
  // Note we are calling NS_NewChannelWithTriggeringPrincipal here with a node
  // and a principal. This is because of a case where the node is the document
  // being styled and the principal is the stylesheet (perhaps from a different
  // origin)  that is applying the styles.
  if (aLoadData->mRequestingNode && aLoadData->mLoaderPrincipal) {
    rv = NS_NewChannelWithTriggeringPrincipal(getter_AddRefs(channel),
                                              aLoadData->mURI,
                                              aLoadData->mRequestingNode,
                                              aLoadData->mLoaderPrincipal,
                                              securityFlags,
                                              contentPolicyType,
                                              loadGroup,
                                              nullptr,   // aCallbacks
                                              nsIChannel::LOAD_NORMAL |
                                              nsIChannel::LOAD_CLASSIFY_URI);
  }
  else {
    // either we are loading something inside a document, in which case
    // we should always have a requestingNode, or we are loading something
    // outside a document, in which case the loadingPrincipal and the
    // triggeringPrincipal should always be the systemPrincipal.
    rv = NS_NewChannel(getter_AddRefs(channel),
                       aLoadData->mURI,
                       nsContentUtils::GetSystemPrincipal(),
                       securityFlags,
                       contentPolicyType,
                       loadGroup,
                       nullptr,   // aCallbacks
                       nsIChannel::LOAD_NORMAL |
                       nsIChannel::LOAD_CLASSIFY_URI);
  }

  if (NS_FAILED(rv)) {
#ifdef DEBUG
    mSyncCallback = false;
#endif
    LOG_ERROR(("  Failed to create channel"));
    SheetComplete(aLoadData, rv);
    return rv;
  }

  if (!aLoadData->mWasAlternate) {
    nsCOMPtr<nsIClassOfService> cos(do_QueryInterface(channel));
    if (cos) {
      cos->AddClassFlags(nsIClassOfService::Leader);
    }
  }

  nsCOMPtr<nsIHttpChannel> httpChannel(do_QueryInterface(channel));
  if (httpChannel) {
    // Send a minimal Accept header for text/css
    httpChannel->SetRequestHeader(NS_LITERAL_CSTRING("Accept"),
                                  NS_LITERAL_CSTRING("text/css,*/*;q=0.1"),
                                  false);
    nsCOMPtr<nsIURI> referrerURI = aLoadData->GetReferrerURI();
    if (referrerURI)
      httpChannel->SetReferrerWithPolicy(referrerURI,
                                         aLoadData->mSheet->GetReferrerPolicy());

    nsCOMPtr<nsIHttpChannelInternal> internalChannel = do_QueryInterface(httpChannel);
    if (internalChannel) {
      internalChannel->SetIntegrityMetadata(sriMetadata.GetIntegrityString());
    }

    // Set the initiator type
    nsCOMPtr<nsITimedChannel> timedChannel(do_QueryInterface(httpChannel));
    if (timedChannel) {
      if (aLoadData->mParentData) {
        timedChannel->SetInitiatorType(NS_LITERAL_STRING("css"));
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
  nsCOMPtr<nsIUnicharStreamLoader> streamLoader;
  rv = NS_NewUnicharStreamLoader(getter_AddRefs(streamLoader), aLoadData);
  if (NS_FAILED(rv)) {
#ifdef DEBUG
    mSyncCallback = false;
#endif
    LOG_ERROR(("  Failed to create stream loader"));
    SheetComplete(aLoadData, rv);
    return rv;
  }

  if (mDocument) {
    mozilla::net::PredictorLearn(aLoadData->mURI, mDocument->GetDocumentURI(),
                                 nsINetworkPredictor::LEARN_LOAD_SUBRESOURCE,
                                 mDocument);
  }

  rv = channel->AsyncOpen2(streamLoader);

#ifdef DEBUG
  mSyncCallback = false;
#endif

  if (NS_FAILED(rv)) {
    LOG_ERROR(("  Failed to create stream loader"));
    SheetComplete(aLoadData, rv);
    return rv;
  }

  mSheets->mLoadingDatas.Put(&key, aLoadData);
  aLoadData->mIsLoading = true;

  return NS_OK;
}

/**
 * ParseSheet handles parsing the data stream.  The main idea here is
 * to push the current load data onto the parse stack before letting
 * the CSS parser at the data stream.  That lets us handle @import
 * correctly.
 */
nsresult
Loader::ParseSheet(const nsAString& aInput,
                   SheetLoadData* aLoadData,
                   bool& aCompleted)
{
  LOG(("css::Loader::ParseSheet"));
  NS_PRECONDITION(aLoadData, "Must have load data");
  NS_PRECONDITION(aLoadData->mSheet, "Must have sheet to parse into");

  aCompleted = false;

  // Push our load data on the stack so any kids can pick it up
  mParsingDatas.AppendElement(aLoadData);
  nsIURI* sheetURI = aLoadData->mSheet->GetSheetURI();
  nsIURI* baseURI = aLoadData->mSheet->GetBaseURI();

  nsresult rv;

  if (aLoadData->mSheet->IsGecko()) {
    nsCSSParser parser(this, aLoadData->mSheet->AsGecko());
    rv = parser.ParseSheet(aInput, sheetURI, baseURI,
                           aLoadData->mSheet->Principal(),
                           aLoadData->mLineNumber);
  } else {
    rv =
      aLoadData->mSheet->AsServo()->ParseSheet(aInput, sheetURI, baseURI,
                                               aLoadData->mSheet->Principal(),
                                               aLoadData->mLineNumber);
  }

  mParsingDatas.RemoveElementAt(mParsingDatas.Length() - 1);

  if (NS_FAILED(rv)) {
    LOG_ERROR(("  Low-level error in parser!"));
    SheetComplete(aLoadData, rv);
    return rv;
  }

  NS_ASSERTION(aLoadData->mPendingChildren == 0 || !aLoadData->mSyncLoad,
               "Sync load has leftover pending children!");

  if (aLoadData->mPendingChildren == 0) {
    LOG(("  No pending kids from parse"));
    aCompleted = true;
    SheetComplete(aLoadData, NS_OK);
  }
  // Otherwise, the children are holding strong refs to the data and
  // will call SheetComplete() on it when they complete.

  return NS_OK;
}

/**
 * SheetComplete is the do-it-all cleanup function.  It removes the
 * load data from the "loading" hashtable, adds the sheet to the
 * "completed" hashtable, massages the XUL cache, handles siblings of
 * the load data (other loads for the same URI), handles unblocking
 * blocked parent loads as needed, and most importantly calls
 * NS_RELEASE on the load data to destroy the whole mess.
 */
void
Loader::SheetComplete(SheetLoadData* aLoadData, nsresult aStatus)
{
  LOG(("css::Loader::SheetComplete"));

  if (aLoadData->mSheet->IsServo() && NS_FAILED(aStatus)) {
    aLoadData->mSheet->AsServo()->LoadFailed();
  }

  // 8 is probably big enough for all our common cases.  It's not likely that
  // imports will nest more than 8 deep, and multiple sheets with the same URI
  // are rare.
  AutoTArray<RefPtr<SheetLoadData>, 8> datasToNotify;
  DoSheetComplete(aLoadData, aStatus, datasToNotify);

  // Now it's safe to go ahead and notify observers
  uint32_t count = datasToNotify.Length();
  mDatasToNotifyOn += count;
  for (uint32_t i = 0; i < count; ++i) {
    --mDatasToNotifyOn;

    SheetLoadData* data = datasToNotify[i];
    NS_ASSERTION(data && data->mMustNotify, "How did this data get here?");
    if (data->mObserver) {
      LOG(("  Notifying observer %p for data %p.  wasAlternate: %d",
           data->mObserver.get(), data, data->mWasAlternate));
      data->mObserver->StyleSheetLoaded(data->mSheet, data->mWasAlternate,
                                        aStatus);
    }

    nsTObserverArray<nsCOMPtr<nsICSSLoaderObserver> >::ForwardIterator iter(mObservers);
    nsCOMPtr<nsICSSLoaderObserver> obs;
    while (iter.HasMore()) {
      obs = iter.GetNext();
      LOG(("  Notifying global observer %p for data %p.  wasAlternate: %d",
           obs.get(), data, data->mWasAlternate));
      obs->StyleSheetLoaded(data->mSheet, data->mWasAlternate, aStatus);
    }
  }

  if (mSheets->mLoadingDatas.Count() == 0 && mSheets->mPendingDatas.Count() > 0) {
    LOG(("  No more loading sheets; starting alternates"));
    StartAlternateLoads();
  }
}

void
Loader::DoSheetComplete(SheetLoadData* aLoadData, nsresult aStatus,
                        LoadDataArray& aDatasToNotify)
{
  LOG(("css::Loader::DoSheetComplete"));
  NS_PRECONDITION(aLoadData, "Must have a load data!");
  NS_PRECONDITION(aLoadData->mSheet, "Must have a sheet");
  NS_ASSERTION(mSheets, "mLoadingDatas should be initialized by now.");

  LOG(("Load completed, status: 0x%x", aStatus));

  // Twiddle the hashtables
  if (aLoadData->mURI) {
    LOG_URI("  Finished loading: '%s'", aLoadData->mURI);
    // Remove the data from the list of loading datas
    if (aLoadData->mIsLoading) {
      URIPrincipalReferrerPolicyAndCORSModeHashKey key(aLoadData->mURI,
                                         aLoadData->mLoaderPrincipal,
                                         aLoadData->mSheet->GetCORSMode(),
                                         aLoadData->mSheet->GetReferrerPolicy());
#ifdef DEBUG
      SheetLoadData *loadingData;
      NS_ASSERTION(mSheets->mLoadingDatas.Get(&key, &loadingData) &&
                   loadingData == aLoadData,
                   "Bad loading table");
#endif

      mSheets->mLoadingDatas.Remove(&key);
      aLoadData->mIsLoading = false;
    }
  }

  // Go through and deal with the whole linked list.
  SheetLoadData* data = aLoadData;
  while (data) {
    if (!data->mSheetAlreadyComplete) {
      // If mSheetAlreadyComplete, then the sheet could well be modified between
      // when we posted the async call to SheetComplete and now, since the sheet
      // was page-accessible during that whole time.
      MOZ_ASSERT(!(data->mSheet->IsGecko() &&
                   data->mSheet->AsGecko()->IsModified()),
                 "should not get marked modified during parsing");
      data->mSheet->SetComplete();
      data->ScheduleLoadEventIfNeeded(aStatus);
    }
    if (data->mMustNotify && (data->mObserver || !mObservers.IsEmpty())) {
      // Don't notify here so we don't trigger script.  Remember the
      // info we need to notify, then do it later when it's safe.
      aDatasToNotify.AppendElement(data);

      // On append failure, just press on.  We'll fail to notify the observer,
      // but not much we can do about that....
    }

    NS_ASSERTION(!data->mParentData ||
                 data->mParentData->mPendingChildren != 0,
                 "Broken pending child count on our parent");

    // If we have a parent, our parent is no longer being parsed, and
    // we are the last pending child, then our load completion
    // completes the parent too.  Note that the parent _can_ still be
    // being parsed (eg if the child (us) failed to open the channel
    // or some such).
    if (data->mParentData &&
        --(data->mParentData->mPendingChildren) == 0 &&
        !mParsingDatas.Contains(data->mParentData)) {
      DoSheetComplete(data->mParentData, aStatus, aDatasToNotify);
    }

    data = data->mNext;
  }

  // Now that it's marked complete, put the sheet in our cache.
  // If we ever start doing this for failure aStatus, we'll need to
  // adjust the PostLoadEvent code that thinks anything already
  // complete must have loaded succesfully.
  if (NS_SUCCEEDED(aStatus) && aLoadData->mURI) {
    // Pick our sheet to cache carefully.  Ideally, we want to cache
    // one of the sheets that will be kept alive by a document or
    // parent sheet anyway, so that if someone then accesses it via
    // CSSOM we won't have extra clones of the inner lying around.
    if (aLoadData->mSheet->IsGecko()) {
      data = aLoadData;
      CSSStyleSheet* sheet = aLoadData->mSheet->AsGecko();
      while (data) {
        if (data->mSheet->GetParentSheet() || data->mSheet->GetOwnerNode()) {
          sheet = data->mSheet->AsGecko();
          break;
        }
        data = data->mNext;
      }
#ifdef MOZ_XUL
      if (IsChromeURI(aLoadData->mURI)) {
        nsXULPrototypeCache* cache = nsXULPrototypeCache::GetInstance();
        if (cache && cache->IsEnabled()) {
          if (!cache->GetStyleSheet(aLoadData->mURI)) {
            LOG(("  Putting sheet in XUL prototype cache"));
            NS_ASSERTION(sheet->IsComplete(),
                         "Should only be caching complete sheets");
            cache->PutStyleSheet(sheet);
          }
        }
      }
      else {
#endif
        URIPrincipalReferrerPolicyAndCORSModeHashKey key(aLoadData->mURI,
                                           aLoadData->mLoaderPrincipal,
                                           aLoadData->mSheet->GetCORSMode(),
                                           aLoadData->mSheet->GetReferrerPolicy());
        NS_ASSERTION(sheet->IsComplete(),
                     "Should only be caching complete sheets");
        mSheets->mCompleteSheets.Put(&key, sheet);
#ifdef MOZ_XUL
      }
#endif
    } else {
      NS_WARNING("stylo: Stylesheet caching not yet supported - see bug 1290218.");
    }
  }

  NS_RELEASE(aLoadData);  // this will release parents and siblings and all that
}

nsresult
Loader::LoadInlineStyle(nsIContent* aElement,
                        const nsAString& aBuffer,
                        uint32_t aLineNumber,
                        const nsAString& aTitle,
                        const nsAString& aMedia,
                        Element* aScopeElement,
                        nsICSSLoaderObserver* aObserver,
                        bool* aCompleted,
                        bool* aIsAlternate)
{
  LOG(("css::Loader::LoadInlineStyle"));
  NS_ASSERTION(mParsingDatas.Length() == 0, "We're in the middle of a parse?");

  *aCompleted = true;

  if (!mEnabled) {
    LOG_WARN(("  Not enabled"));
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_INITIALIZED);

  nsCOMPtr<nsIStyleSheetLinkingElement> owningElement(do_QueryInterface(aElement));
  NS_ASSERTION(owningElement, "Element is not a style linking element!");

  // Since we're not planning to load a URI, no need to hand a principal to the
  // load data or to CreateSheet().  Also, OK to use CORS_NONE for the CORS
  // mode and mDocument's ReferrerPolicy.
  StyleSheetState state;
  RefPtr<StyleSheet> sheet;
  nsresult rv = CreateSheet(nullptr, aElement, nullptr, eAuthorSheetFeatures,
                            CORS_NONE, mDocument->GetReferrerPolicy(),
                            EmptyString(), // no inline integrity checks
                            false, false, aTitle, state, aIsAlternate,
                            &sheet);
  NS_ENSURE_SUCCESS(rv, rv);
  NS_ASSERTION(state == eSheetNeedsParser,
               "Inline sheets should not be cached");

  LOG(("  Sheet is alternate: %d", *aIsAlternate));

  PrepareSheet(sheet, aTitle, aMedia, nullptr, aScopeElement, *aIsAlternate);

  if (aElement->HasFlag(NODE_IS_IN_SHADOW_TREE)) {
    ShadowRoot* containingShadow = aElement->GetContainingShadow();
    MOZ_ASSERT(containingShadow);
    containingShadow->InsertSheet(sheet, aElement);
  } else {
    rv = InsertSheetInDoc(sheet, aElement, mDocument);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  SheetLoadData* data = new SheetLoadData(this, aTitle, nullptr, sheet,
                                          owningElement, *aIsAlternate,
                                          aObserver, nullptr, static_cast<nsINode*>(aElement));

  // We never actually load this, so just set its principal directly
  sheet->SetPrincipal(aElement->NodePrincipal());

  NS_ADDREF(data);
  data->mLineNumber = aLineNumber;
  // Parse completion releases the load data
  rv = ParseSheet(aBuffer, data, *aCompleted);
  NS_ENSURE_SUCCESS(rv, rv);

  // If aCompleted is true, |data| may well be deleted by now.
  if (!*aCompleted) {
    data->mMustNotify = true;
  }
  return rv;
}

nsresult
Loader::LoadStyleLink(nsIContent* aElement,
                      nsIURI* aURL,
                      const nsAString& aTitle,
                      const nsAString& aMedia,
                      bool aHasAlternateRel,
                      CORSMode aCORSMode,
                      ReferrerPolicy aReferrerPolicy,
                      const nsAString& aIntegrity,
                      nsICSSLoaderObserver* aObserver,
                      bool* aIsAlternate)
{
  LOG(("css::Loader::LoadStyleLink"));
  NS_PRECONDITION(aURL, "Must have URL to load");
  NS_ASSERTION(mParsingDatas.Length() == 0, "We're in the middle of a parse?");

  LOG_URI("  Link uri: '%s'", aURL);
  LOG(("  Link title: '%s'", NS_ConvertUTF16toUTF8(aTitle).get()));
  LOG(("  Link media: '%s'", NS_ConvertUTF16toUTF8(aMedia).get()));
  LOG(("  Link alternate rel: %d", aHasAlternateRel));

  if (!mEnabled) {
    LOG_WARN(("  Not enabled"));
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_INITIALIZED);

  nsIPrincipal* principal =
    aElement ? aElement->NodePrincipal() : mDocument->NodePrincipal();

  nsISupports* context = aElement;
  if (!context) {
    context = mDocument;
  }

  nsresult rv = CheckContentPolicy(principal, aURL, context, false);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    // Don't fire the error event if our document is loaded as data.  We're
    // supposed to not even try to do loads in that case... Unfortunately, we
    // implement that via nsDataDocumentContentPolicy, which doesn't have a good
    // way to communicate back to us that _it_ is the thing that blocked the
    // load.
    if (aElement && !mDocument->IsLoadedAsData()) {
      // Fire an async error event on it.
      RefPtr<AsyncEventDispatcher> loadBlockingAsyncDispatcher =
        new LoadBlockingAsyncEventDispatcher(aElement,
                                             NS_LITERAL_STRING("error"),
                                             false, false);
      loadBlockingAsyncDispatcher->PostDOMEvent();
    }
    return rv;
  }

  StyleSheetState state;
  RefPtr<StyleSheet> sheet;
  rv = CreateSheet(aURL, aElement, principal, eAuthorSheetFeatures,
                   aCORSMode, aReferrerPolicy, aIntegrity, false,
                   aHasAlternateRel, aTitle, state, aIsAlternate,
                   &sheet);
  NS_ENSURE_SUCCESS(rv, rv);

  LOG(("  Sheet is alternate: %d", *aIsAlternate));

  PrepareSheet(sheet, aTitle, aMedia, nullptr, nullptr, *aIsAlternate);

  rv = InsertSheetInDoc(sheet, aElement, mDocument);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIStyleSheetLinkingElement> owningElement(do_QueryInterface(aElement));

  if (state == eSheetComplete) {
    LOG(("  Sheet already complete: 0x%p", sheet.get()));
    if (aObserver || !mObservers.IsEmpty() || owningElement) {
      rv = PostLoadEvent(aURL, sheet, aObserver, *aIsAlternate,
                         owningElement);
      return rv;
    }

    return NS_OK;
  }

  // Now we need to actually load it
  nsCOMPtr<nsINode> requestingNode = do_QueryInterface(context);
  SheetLoadData* data = new SheetLoadData(this, aTitle, aURL, sheet,
                                          owningElement, *aIsAlternate,
                                          aObserver, principal, requestingNode);
  NS_ADDREF(data);

  // If we have to parse and it's an alternate non-inline, defer it
  if (aURL && state == eSheetNeedsParser && mSheets->mLoadingDatas.Count() != 0 &&
      *aIsAlternate) {
    LOG(("  Deferring alternate sheet load"));
    URIPrincipalReferrerPolicyAndCORSModeHashKey key(data->mURI,
                                                     data->mLoaderPrincipal,
                                                     data->mSheet->GetCORSMode(),
                                                     data->mSheet->GetReferrerPolicy());
    mSheets->mPendingDatas.Put(&key, data);

    data->mMustNotify = true;
    return NS_OK;
  }

  // Load completion will free the data
  rv = LoadSheet(data, state, false);
  NS_ENSURE_SUCCESS(rv, rv);

  data->mMustNotify = true;
  return rv;
}

static bool
HaveAncestorDataWithURI(SheetLoadData *aData, nsIURI *aURI)
{
  if (!aData->mURI) {
    // Inline style; this won't have any ancestors
    MOZ_ASSERT(!aData->mParentData,
               "How does inline style have a parent?");
    return false;
  }

  bool equal;
  if (NS_FAILED(aData->mURI->Equals(aURI, &equal)) || equal) {
    return true;
  }

  // Datas down the mNext chain have the same URI as aData, so we
  // don't have to compare to them.  But they might have different
  // parents, and we have to check all of those.
  while (aData) {
    if (aData->mParentData &&
        HaveAncestorDataWithURI(aData->mParentData, aURI)) {
      return true;
    }

    aData = aData->mNext;
  }

  return false;
}

nsresult
Loader::LoadChildSheet(StyleSheet* aParentSheet,
                       nsIURI* aURL,
                       nsMediaList* aMedia,
                       ImportRule* aParentRule,
                       LoaderReusableStyleSheets* aReusableSheets)
{
  LOG(("css::Loader::LoadChildSheet"));
  NS_PRECONDITION(aURL, "Must have a URI to load");
  NS_PRECONDITION(aParentSheet, "Must have a parent sheet");

  if (!mEnabled) {
    LOG_WARN(("  Not enabled"));
    return NS_ERROR_NOT_AVAILABLE;
  }

  LOG_URI("  Child uri: '%s'", aURL);

  nsCOMPtr<nsINode> owningNode;

  // check for an owning document: if none, don't bother walking up the parent
  // sheets
  if (aParentSheet->GetOwningDocument()) {
    StyleSheet* topSheet = aParentSheet;
    while (StyleSheet* parent = topSheet->GetParentSheet()) {
      topSheet = parent;
    }
    owningNode = topSheet->GetOwnerNode();
  }

  nsISupports* context = owningNode;
  if (!context) {
    context = mDocument;
  }

  nsIPrincipal* principal = aParentSheet->Principal();
  nsresult rv = CheckContentPolicy(principal, aURL, context, false);
  NS_ENSURE_SUCCESS(rv, rv);

  SheetLoadData* parentData = nullptr;
  nsCOMPtr<nsICSSLoaderObserver> observer;

  int32_t count = mParsingDatas.Length();
  if (count > 0) {
    LOG(("  Have a parent load"));
    parentData = mParsingDatas.ElementAt(count - 1);
    // Check for cycles
    if (HaveAncestorDataWithURI(parentData, aURL)) {
      // Houston, we have a loop, blow off this child and pretend this never
      // happened
      LOG_ERROR(("  @import cycle detected, dropping load"));
      return NS_OK;
    }

    NS_ASSERTION(parentData->mSheet == aParentSheet,
                 "Unexpected call to LoadChildSheet");
  } else {
    LOG(("  No parent load; must be CSSOM"));
    // No parent load data, so the sheet will need to be notified when
    // we finish, if it can be, if we do the load asynchronously.
    // XXXheycam ServoStyleSheet doesn't implement nsICSSLoaderObserver yet.
    MOZ_ASSERT(aParentSheet->IsGecko(),
               "stylo: ServoStyleSheets don't support child sheet loading yet");
    observer = aParentSheet->AsGecko();
  }

  // Now that we know it's safe to load this (passes security check and not a
  // loop) do so.
  RefPtr<StyleSheet> sheet;
  RefPtr<CSSStyleSheet> reusableSheet;
  StyleSheetState state;
  if (aReusableSheets && aReusableSheets->FindReusableStyleSheet(aURL, reusableSheet)) {
    sheet = reusableSheet;
    aParentRule->SetSheet(reusableSheet);
    state = eSheetComplete;
  } else {
    bool isAlternate;
    const nsSubstring& empty = EmptyString();
    // For now, use CORS_NONE for child sheets
    rv = CreateSheet(aURL, nullptr, principal,
                     aParentSheet->ParsingMode(),
                     CORS_NONE, aParentSheet->GetReferrerPolicy(),
                     EmptyString(), // integrity is only checked on main sheet
                     parentData ? parentData->mSyncLoad : false,
                     false, empty, state, &isAlternate, &sheet);
    NS_ENSURE_SUCCESS(rv, rv);

    PrepareSheet(sheet, empty, empty, aMedia, nullptr, isAlternate);
  }

  rv = InsertChildSheet(sheet, aParentSheet, aParentRule);
  NS_ENSURE_SUCCESS(rv, rv);

  if (state == eSheetComplete) {
    LOG(("  Sheet already complete"));
    // We're completely done.  No need to notify, even, since the
    // @import rule addition/modification will trigger the right style
    // changes automatically.
    return NS_OK;
  }

  nsCOMPtr<nsINode> requestingNode = do_QueryInterface(context);
  SheetLoadData* data = new SheetLoadData(this, aURL, sheet, parentData,
                                          observer, principal, requestingNode);

  NS_ADDREF(data);
  bool syncLoad = data->mSyncLoad;

  // Load completion will release the data
  rv = LoadSheet(data, state, false);
  NS_ENSURE_SUCCESS(rv, rv);

  // If syncLoad is true, |data| will be deleted by now.
  if (!syncLoad) {
    data->mMustNotify = true;
  }
  return rv;
}

nsresult
Loader::LoadSheetSync(nsIURI* aURL,
                      SheetParsingMode aParsingMode,
                      bool aUseSystemPrincipal,
                      RefPtr<StyleSheet>* aSheet)
{
  LOG(("css::Loader::LoadSheetSync"));
  return InternalLoadNonDocumentSheet(aURL,
                                      false, aParsingMode, aUseSystemPrincipal,
                                      nullptr, EmptyCString(),
                                      aSheet, nullptr);
}

nsresult
Loader::LoadSheet(nsIURI* aURL,
                  nsIPrincipal* aOriginPrincipal,
                  const nsCString& aCharset,
                  nsICSSLoaderObserver* aObserver,
                  RefPtr<StyleSheet>* aSheet)
{
  LOG(("css::Loader::LoadSheet(aURL, aObserver, aSheet) api call"));
  NS_PRECONDITION(aSheet, "aSheet is null");
  return InternalLoadNonDocumentSheet(aURL,
                                      false, eAuthorSheetFeatures, false,
                                      aOriginPrincipal, aCharset,
                                      aSheet, aObserver);
}

nsresult
Loader::LoadSheet(nsIURI* aURL,
                  bool aIsPreload,
                  nsIPrincipal* aOriginPrincipal,
                  const nsCString& aCharset,
                  nsICSSLoaderObserver* aObserver,
                  CORSMode aCORSMode,
                  ReferrerPolicy aReferrerPolicy,
                  const nsAString& aIntegrity)
{
  LOG(("css::Loader::LoadSheet(aURL, aObserver) api call"));
  return InternalLoadNonDocumentSheet(aURL,
                                      aIsPreload, eAuthorSheetFeatures, false,
                                      aOriginPrincipal, aCharset,
                                      nullptr, aObserver,
                                      aCORSMode, aReferrerPolicy, aIntegrity);
}

nsresult
Loader::InternalLoadNonDocumentSheet(nsIURI* aURL,
                                     bool aIsPreload,
                                     SheetParsingMode aParsingMode,
                                     bool aUseSystemPrincipal,
                                     nsIPrincipal* aOriginPrincipal,
                                     const nsCString& aCharset,
                                     RefPtr<StyleSheet>* aSheet,
                                     nsICSSLoaderObserver* aObserver,
                                     CORSMode aCORSMode,
                                     ReferrerPolicy aReferrerPolicy,
                                     const nsAString& aIntegrity)
{
  NS_PRECONDITION(aURL, "Must have a URI to load");
  NS_PRECONDITION(aSheet || aObserver, "Sheet and observer can't both be null");
  NS_PRECONDITION(!aUseSystemPrincipal || !aObserver,
                  "Shouldn't load system-principal sheets async");
  NS_ASSERTION(mParsingDatas.Length() == 0, "We're in the middle of a parse?");

  LOG_URI("  Non-document sheet uri: '%s'", aURL);

  if (aSheet) {
    *aSheet = nullptr;
  }

  if (!mEnabled) {
    LOG_WARN(("  Not enabled"));
    return NS_ERROR_NOT_AVAILABLE;
  }

  nsresult rv = CheckContentPolicy(aOriginPrincipal, aURL, mDocument, aIsPreload);
  NS_ENSURE_SUCCESS(rv, rv);

  StyleSheetState state;
  bool isAlternate;
  RefPtr<StyleSheet> sheet;
  bool syncLoad = (aObserver == nullptr);
  const nsSubstring& empty = EmptyString();

  rv = CreateSheet(aURL, nullptr, aOriginPrincipal, aParsingMode,
                   aCORSMode, aReferrerPolicy, aIntegrity, syncLoad,
                   false, empty, state, &isAlternate, &sheet);
  NS_ENSURE_SUCCESS(rv, rv);

  PrepareSheet(sheet, empty, empty, nullptr, nullptr, isAlternate);

  if (state == eSheetComplete) {
    LOG(("  Sheet already complete"));
    if (aObserver || !mObservers.IsEmpty()) {
      rv = PostLoadEvent(aURL, sheet, aObserver, false, nullptr);
    }
    if (aSheet) {
      sheet.swap(*aSheet);
    }
    return rv;
  }

  SheetLoadData* data =
    new SheetLoadData(this, aURL, sheet, syncLoad,
                      aUseSystemPrincipal, aCharset, aObserver,
                      aOriginPrincipal, mDocument);

  NS_ADDREF(data);
  rv = LoadSheet(data, state, aIsPreload);
  NS_ENSURE_SUCCESS(rv, rv);

  if (aSheet) {
    sheet.swap(*aSheet);
  }
  if (aObserver) {
    data->mMustNotify = true;
  }

  return rv;
}

nsresult
Loader::PostLoadEvent(nsIURI* aURI,
                      StyleSheet* aSheet,
                      nsICSSLoaderObserver* aObserver,
                      bool aWasAlternate,
                      nsIStyleSheetLinkingElement* aElement)
{
  LOG(("css::Loader::PostLoadEvent"));
  NS_PRECONDITION(aSheet, "Must have sheet");
  NS_PRECONDITION(aObserver || !mObservers.IsEmpty() || aElement,
                  "Must have observer or element");

  RefPtr<SheetLoadData> evt =
    new SheetLoadData(this, EmptyString(), // title doesn't matter here
                      aURI,
                      aSheet,
                      aElement,
                      aWasAlternate,
                      aObserver,
                      nullptr,
                      mDocument);
  NS_ENSURE_TRUE(evt, NS_ERROR_OUT_OF_MEMORY);

  if (!mPostedEvents.AppendElement(evt)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  nsresult rv = NS_DispatchToCurrentThread(evt);
  if (NS_FAILED(rv)) {
    NS_WARNING("failed to dispatch stylesheet load event");
    mPostedEvents.RemoveElement(evt);
  } else {
    // We'll unblock onload when we handle the event.
    if (mDocument) {
      mDocument->BlockOnload();
    }

    // We want to notify the observer for this data.
    evt->mMustNotify = true;
    evt->mSheetAlreadyComplete = true;

    // If we get to this code, aSheet loaded correctly at some point, so
    // we can just use NS_OK for the status.  Note that we do this here
    // and not from inside our SheetComplete so that we don't end up
    // running the load event async.
    evt->ScheduleLoadEventIfNeeded(NS_OK);
  }

  return rv;
}

void
Loader::HandleLoadEvent(SheetLoadData* aEvent)
{
  // XXXbz can't assert this yet.... May not have an observer because
  // we're unblocking the parser
  // NS_ASSERTION(aEvent->mObserver, "Must have observer");
  NS_ASSERTION(aEvent->mSheet, "Must have sheet");

  // Very important: this needs to come before the SheetComplete call
  // below, so that HasPendingLoads() will test true as needed under
  // notifications we send from that SheetComplete call.
  mPostedEvents.RemoveElement(aEvent);

  if (!aEvent->mIsCancelled) {
    // SheetComplete will call Release(), so give it a reference to do
    // that with.
    NS_ADDREF(aEvent);
    SheetComplete(aEvent, NS_OK);
  }

  if (mDocument) {
    mDocument->UnblockOnload(true);
  }
}

static void
StopLoadingSheets(
  nsDataHashtable<URIPrincipalReferrerPolicyAndCORSModeHashKey, SheetLoadData*>& aDatas,
  Loader::LoadDataArray& aArr)
{
  for (auto iter = aDatas.Iter(); !iter.Done(); iter.Next()) {
    SheetLoadData* data = iter.Data();
    MOZ_ASSERT(data, "Must have a data!");

    data->mIsLoading = false; // we will handle the removal right here
    data->mIsCancelled = true;

    aArr.AppendElement(data);

    iter.Remove();
  }
}

nsresult
Loader::Stop()
{
  uint32_t pendingCount = mSheets ? mSheets->mPendingDatas.Count() : 0;
  uint32_t loadingCount = mSheets ? mSheets->mLoadingDatas.Count() : 0;
  LoadDataArray arr(pendingCount + loadingCount + mPostedEvents.Length());

  if (pendingCount) {
    StopLoadingSheets(mSheets->mPendingDatas, arr);
  }
  if (loadingCount) {
    StopLoadingSheets(mSheets->mLoadingDatas, arr);
  }

  uint32_t i;
  for (i = 0; i < mPostedEvents.Length(); ++i) {
    SheetLoadData* data = mPostedEvents[i];
    data->mIsCancelled = true;
    if (arr.AppendElement(data)) {
      // SheetComplete() calls Release(), so give this an extra ref.
      NS_ADDREF(data);
    }
#ifdef DEBUG
    else {
      NS_NOTREACHED("We preallocated this memory... shouldn't really fail, "
                    "except we never check that preallocation succeeds.");
    }
#endif
  }
  mPostedEvents.Clear();

  mDatasToNotifyOn += arr.Length();
  for (i = 0; i < arr.Length(); ++i) {
    --mDatasToNotifyOn;
    SheetComplete(arr[i], NS_BINDING_ABORTED);
  }
  return NS_OK;
}

bool
Loader::HasPendingLoads()
{
  return
    (mSheets && mSheets->mLoadingDatas.Count() != 0) ||
    (mSheets && mSheets->mPendingDatas.Count() != 0) ||
    mPostedEvents.Length() != 0 ||
    mDatasToNotifyOn != 0;
}

nsresult
Loader::AddObserver(nsICSSLoaderObserver* aObserver)
{
  NS_PRECONDITION(aObserver, "Must have observer");
  if (mObservers.AppendElementUnlessExists(aObserver)) {
    return NS_OK;
  }

  return NS_ERROR_OUT_OF_MEMORY;
}

void
Loader::RemoveObserver(nsICSSLoaderObserver* aObserver)
{
  mObservers.RemoveElement(aObserver);
}

void
Loader::StartAlternateLoads()
{
  NS_PRECONDITION(mSheets, "Don't call me!");
  LoadDataArray arr(mSheets->mPendingDatas.Count());
  for (auto iter = mSheets->mPendingDatas.Iter(); !iter.Done(); iter.Next()) {
    arr.AppendElement(iter.Data());
    iter.Remove();
  }

  mDatasToNotifyOn += arr.Length();
  for (uint32_t i = 0; i < arr.Length(); ++i) {
    --mDatasToNotifyOn;
    LoadSheet(arr[i], eSheetNeedsParser, false);
  }
}

NS_IMPL_CYCLE_COLLECTION_CLASS(Loader)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(Loader)
  if (tmp->mSheets) {
    for (auto iter = tmp->mSheets->mCompleteSheets.Iter();
         !iter.Done();
         iter.Next()) {
      NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "Sheet cache nsCSSLoader");
      if (iter.UserData()->IsGecko()) {
        CSSStyleSheet* sheet = iter.UserData()->AsGecko();
        cb.NoteXPCOMChild(NS_ISUPPORTS_CAST(nsIDOMCSSStyleSheet*, sheet));
      }
    }
  }
  nsTObserverArray<nsCOMPtr<nsICSSLoaderObserver>>::ForwardIterator
    it(tmp->mObservers);
  while (it.HasMore()) {
    ImplCycleCollectionTraverse(cb, it.GetNext(),
                                "mozilla::css::Loader.mObservers");
  }
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(Loader)
  if (tmp->mSheets) {
    tmp->mSheets->mCompleteSheets.Clear();
  }
  tmp->mObservers.Clear();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_ROOT_NATIVE(Loader, AddRef)
NS_IMPL_CYCLE_COLLECTION_UNROOT_NATIVE(Loader, Release)

size_t
Loader::SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf) const
{
  size_t n = aMallocSizeOf(this);

  if (mSheets) {
    n += mSheets->mCompleteSheets.ShallowSizeOfExcludingThis(aMallocSizeOf);
    for (auto iter = mSheets->mCompleteSheets.ConstIter();
         !iter.Done();
         iter.Next()) {
      // If aSheet has a parent, then its parent will report it so we don't
      // have to worry about it here. Likewise, if aSheet has an owning node,
      // then the document that node is in will report it.
      const StyleSheet* sheet = iter.UserData();
      n += (sheet->GetOwnerNode() || sheet->GetParentSheet())
         ? 0
         : sheet->SizeOfIncludingThis(aMallocSizeOf);
    }
  }
  n += mObservers.ShallowSizeOfExcludingThis(aMallocSizeOf);

  // Measurement of the following members may be added later if DMD finds it is
  // worthwhile:
  // - mLoadingDatas: transient, and should be small
  // - mPendingDatas: transient, and should be small
  // - mParsingDatas: transient, and should be small
  // - mPostedEvents: transient, and should be small
  //
  // The following members aren't measured:
  // - mDocument, because it's a weak backpointer
  // - mPreferredSheet, because it can be a shared string

  return n;
}

StyleBackendType
Loader::GetStyleBackendType() const
{
  MOZ_ASSERT(mStyleBackendType || mDocument,
             "you must construct a Loader with a document or set a "
             "StyleBackendType on it before calling GetStyleBackendType");
  if (mStyleBackendType) {
    return *mStyleBackendType;
  }
  return mDocument->GetStyleBackendType();
}

} // namespace css
} // namespace mozilla
