/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=8 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsJAR.h"
#include "nsJARChannel.h"
#include "nsJARProtocolHandler.h"
#include "nsMimeTypes.h"
#include "nsNetUtil.h"
#include "nsEscape.h"
#include "nsContentUtils.h"
#include "nsProxyRelease.h"
#include "nsContentSecurityManager.h"

#include "nsIFileURL.h"

#include "mozilla/BasePrincipal.h"
#include "mozilla/IntegerPrintfMacros.h"
#include "mozilla/Preferences.h"
#include "private/pprio.h"
#include "nsInputStreamPump.h"
#include "nsThreadUtils.h"
#include "nsJARProtocolHandler.h"

using namespace mozilla;
using namespace mozilla::net;

static NS_DEFINE_CID(kZipReaderCID, NS_ZIPREADER_CID);

// the entry for a directory will either be empty (in the case of the
// top-level directory) or will end with a slash
#define ENTRY_IS_DIRECTORY(_entry) \
  ((_entry).IsEmpty() || '/' == (_entry).Last())

//-----------------------------------------------------------------------------

// Ignore any LOG macro that we inherit from arbitrary headers. (We define our
// own LOG macro below.)
#ifdef LOG
#  undef LOG
#endif

//
// set NSPR_LOG_MODULES=nsJarProtocol:5
//
static LazyLogModule gJarProtocolLog("nsJarProtocol");

#define LOG(args) MOZ_LOG(gJarProtocolLog, mozilla::LogLevel::Debug, args)
#define LOG_ENABLED() MOZ_LOG_TEST(gJarProtocolLog, mozilla::LogLevel::Debug)

//-----------------------------------------------------------------------------
// nsJARInputThunk
//
// this class allows us to do some extra work on the stream transport thread.
//-----------------------------------------------------------------------------

class nsJARInputThunk : public nsIInputStream {
 public:
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIINPUTSTREAM

  nsJARInputThunk(nsIZipReader* zipReader, nsIURI* fullJarURI,
                  const nsACString& jarEntry, bool usingJarCache)
      : mUsingJarCache(usingJarCache),
        mJarReader(zipReader),
        mJarEntry(jarEntry),
        mContentLength(-1) {
    if (fullJarURI) {
#ifdef DEBUG
      nsresult rv =
#endif
          fullJarURI->GetAsciiSpec(mJarDirSpec);
      NS_ASSERTION(NS_SUCCEEDED(rv), "this shouldn't fail");
    }
  }

  int64_t GetContentLength() { return mContentLength; }

  nsresult Init();

 private:
  virtual ~nsJARInputThunk() { Close(); }

  bool mUsingJarCache;
  nsCOMPtr<nsIZipReader> mJarReader;
  nsCString mJarDirSpec;
  nsCOMPtr<nsIInputStream> mJarStream;
  nsCString mJarEntry;
  int64_t mContentLength;
};

NS_IMPL_ISUPPORTS(nsJARInputThunk, nsIInputStream)

nsresult nsJARInputThunk::Init() {
  nsresult rv;
  if (ENTRY_IS_DIRECTORY(mJarEntry)) {
    // A directory stream also needs the Spec of the FullJarURI
    // because is included in the stream data itself.

    NS_ENSURE_STATE(!mJarDirSpec.IsEmpty());

    rv = mJarReader->GetInputStreamWithSpec(mJarDirSpec, mJarEntry,
                                            getter_AddRefs(mJarStream));
  } else {
    rv = mJarReader->GetInputStream(mJarEntry, getter_AddRefs(mJarStream));
  }
  if (NS_FAILED(rv)) {
    // convert to the proper result if the entry wasn't found
    // so that error pages work
    if (rv == NS_ERROR_FILE_TARGET_DOES_NOT_EXIST) rv = NS_ERROR_FILE_NOT_FOUND;
    return rv;
  }

  // ask the JarStream for the content length
  uint64_t avail;
  rv = mJarStream->Available((uint64_t*)&avail);
  if (NS_FAILED(rv)) return rv;

  mContentLength = avail < INT64_MAX ? (int64_t)avail : -1;

  return NS_OK;
}

NS_IMETHODIMP
nsJARInputThunk::Close() {
  nsresult rv = NS_OK;

  if (mJarStream) rv = mJarStream->Close();

  if (!mUsingJarCache && mJarReader) mJarReader->Close();

  mJarReader = nullptr;

  return rv;
}

NS_IMETHODIMP
nsJARInputThunk::Available(uint64_t* avail) {
  return mJarStream->Available(avail);
}

NS_IMETHODIMP
nsJARInputThunk::Read(char* buf, uint32_t count, uint32_t* countRead) {
  return mJarStream->Read(buf, count, countRead);
}

NS_IMETHODIMP
nsJARInputThunk::ReadSegments(nsWriteSegmentFun writer, void* closure,
                              uint32_t count, uint32_t* countRead) {
  // stream transport does only calls Read()
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsJARInputThunk::IsNonBlocking(bool* nonBlocking) {
  *nonBlocking = false;
  return NS_OK;
}

//-----------------------------------------------------------------------------
// nsJARChannel
//-----------------------------------------------------------------------------

nsJARChannel::nsJARChannel()
    : mOpened(false),
      mCanceled(false),
      mContentLength(-1),
      mLoadFlags(LOAD_NORMAL),
      mStatus(NS_OK),
      mIsPending(false),
      mEnableOMT(true),
      mPendingEvent() {
  LOG(("nsJARChannel::nsJARChannel [this=%p]\n", this));
  // hold an owning reference to the jar handler
  mJarHandler = gJarHandler;
}

nsJARChannel::~nsJARChannel() {
  LOG(("nsJARChannel::~nsJARChannel [this=%p]\n", this));
  if (NS_IsMainThread()) {
    return;
  }

  // Proxy release the following members to main thread.
  NS_ReleaseOnMainThread("nsJARChannel::mLoadInfo", mLoadInfo.forget());
  NS_ReleaseOnMainThread("nsJARChannel::mCallbacks", mCallbacks.forget());
  NS_ReleaseOnMainThread("nsJARChannel::mProgressSink", mProgressSink.forget());
  NS_ReleaseOnMainThread("nsJARChannel::mLoadGroup", mLoadGroup.forget());
  NS_ReleaseOnMainThread("nsJARChannel::mListener", mListener.forget());
}

NS_IMPL_ISUPPORTS_INHERITED(nsJARChannel, nsHashPropertyBag, nsIRequest,
                            nsIChannel, nsIStreamListener, nsIRequestObserver,
                            nsIThreadRetargetableRequest,
                            nsIThreadRetargetableStreamListener, nsIJARChannel)

nsresult nsJARChannel::Init(nsIURI* uri) {
  LOG(("nsJARChannel::Init [this=%p]\n", this));
  nsresult rv;

  mWorker = do_GetService(NS_STREAMTRANSPORTSERVICE_CONTRACTID, &rv);
  if (NS_FAILED(rv)) {
    return rv;
  }

  mJarURI = do_QueryInterface(uri, &rv);
  if (NS_FAILED(rv)) return rv;

  mOriginalURI = mJarURI;

  // Prevent loading jar:javascript URIs (see bug 290982).
  nsCOMPtr<nsIURI> innerURI;
  rv = mJarURI->GetJARFile(getter_AddRefs(innerURI));
  if (NS_FAILED(rv)) {
    return rv;
  }

  if (innerURI->SchemeIs("javascript")) {
    NS_WARNING("blocking jar:javascript:");
    return NS_ERROR_INVALID_ARG;
  }

  mJarURI->GetSpec(mSpec);
  return rv;
}

nsresult nsJARChannel::CreateJarInput(nsIZipReaderCache* jarCache,
                                      nsJARInputThunk** resultInput) {
  LOG(("nsJARChannel::CreateJarInput [this=%p]\n", this));
  MOZ_ASSERT(resultInput);
  MOZ_ASSERT(mJarFile);

  // important to pass a clone of the file since the nsIFile impl is not
  // necessarily MT-safe
  nsCOMPtr<nsIFile> clonedFile;
  nsresult rv = NS_OK;
  if (mJarFile) {
    rv = mJarFile->Clone(getter_AddRefs(clonedFile));
    if (NS_FAILED(rv)) return rv;
  }

  nsCOMPtr<nsIZipReader> reader;
  if (mPreCachedJarReader) {
    reader = mPreCachedJarReader;
  } else if (jarCache) {
    if (mInnerJarEntry.IsEmpty())
      rv = jarCache->GetZip(clonedFile, getter_AddRefs(reader));
    else
      rv = jarCache->GetInnerZip(clonedFile, mInnerJarEntry,
                                 getter_AddRefs(reader));
  } else {
    // create an uncached jar reader
    nsCOMPtr<nsIZipReader> outerReader = do_CreateInstance(kZipReaderCID, &rv);
    if (NS_FAILED(rv)) return rv;

    rv = outerReader->Open(clonedFile);
    if (NS_FAILED(rv)) return rv;

    if (mInnerJarEntry.IsEmpty())
      reader = outerReader;
    else {
      reader = do_CreateInstance(kZipReaderCID, &rv);
      if (NS_FAILED(rv)) return rv;

      rv = reader->OpenInner(outerReader, mInnerJarEntry);
    }
  }
  if (NS_FAILED(rv)) return rv;

  RefPtr<nsJARInputThunk> input =
      new nsJARInputThunk(reader, mJarURI, mJarEntry, jarCache != nullptr);
  rv = input->Init();
  if (NS_FAILED(rv)) return rv;

  // Make GetContentLength meaningful
  mContentLength = input->GetContentLength();

  input.forget(resultInput);
  return NS_OK;
}

nsresult nsJARChannel::LookupFile() {
  LOG(("nsJARChannel::LookupFile [this=%p %s]\n", this, mSpec.get()));

  if (mJarFile) return NS_OK;

  nsresult rv;

  rv = mJarURI->GetJARFile(getter_AddRefs(mJarBaseURI));
  if (NS_FAILED(rv)) return rv;

  rv = mJarURI->GetJAREntry(mJarEntry);
  if (NS_FAILED(rv)) return rv;

  // The name of the JAR entry must not contain URL-escaped characters:
  // we're moving from URL domain to a filename domain here. nsStandardURL
  // does basic escaping by default, which breaks reading zipped files which
  // have e.g. spaces in their filenames.
  NS_UnescapeURL(mJarEntry);

  if (mJarFileOverride) {
    mJarFile = mJarFileOverride;
    LOG(("nsJARChannel::LookupFile [this=%p] Overriding mJarFile\n", this));
    return NS_OK;
  }

  // try to get a nsIFile directly from the url, which will often succeed.
  {
    nsCOMPtr<nsIFileURL> fileURL = do_QueryInterface(mJarBaseURI);
    if (fileURL) fileURL->GetFile(getter_AddRefs(mJarFile));
  }

  // try to handle a nested jar
  if (!mJarFile) {
    nsCOMPtr<nsIJARURI> jarURI = do_QueryInterface(mJarBaseURI);
    if (jarURI) {
      nsCOMPtr<nsIFileURL> fileURL;
      nsCOMPtr<nsIURI> innerJarURI;
      rv = jarURI->GetJARFile(getter_AddRefs(innerJarURI));
      if (NS_SUCCEEDED(rv)) fileURL = do_QueryInterface(innerJarURI);
      if (fileURL) {
        fileURL->GetFile(getter_AddRefs(mJarFile));
        jarURI->GetJAREntry(mInnerJarEntry);
      }
    }
  }

  return rv;
}

nsresult CreateLocalJarInput(nsIZipReaderCache* aJarCache, nsIFile* aFile,
                             const nsACString& aInnerJarEntry,
                             nsIJARURI* aJarURI, const nsACString& aJarEntry,
                             nsJARInputThunk** aResultInput) {
  LOG(("nsJARChannel::CreateLocalJarInput [aJarCache=%p, %s, %s]\n", aJarCache,
       PromiseFlatCString(aInnerJarEntry).get(),
       PromiseFlatCString(aJarEntry).get()));

  MOZ_ASSERT(!NS_IsMainThread());
  MOZ_ASSERT(aJarCache);
  MOZ_ASSERT(aResultInput);

  nsresult rv;

  nsCOMPtr<nsIZipReader> reader;
  if (aInnerJarEntry.IsEmpty()) {
    rv = aJarCache->GetZip(aFile, getter_AddRefs(reader));
  } else {
    rv = aJarCache->GetInnerZip(aFile, aInnerJarEntry, getter_AddRefs(reader));
  }
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  RefPtr<nsJARInputThunk> input =
      new nsJARInputThunk(reader, aJarURI, aJarEntry, aJarCache != nullptr);
  rv = input->Init();
  if (NS_FAILED(rv)) {
    return rv;
  }

  input.forget(aResultInput);
  return NS_OK;
}

nsresult nsJARChannel::OpenLocalFile() {
  LOG(("nsJARChannel::OpenLocalFile [this=%p]\n", this));

  MOZ_ASSERT(NS_IsMainThread());

  MOZ_ASSERT(mWorker);
  MOZ_ASSERT(mIsPending);
  MOZ_ASSERT(mJarFile);

  nsresult rv;

  // Set mLoadGroup and mOpened before AsyncOpen return, and set back if
  // if failed when callback.
  if (mLoadGroup) {
    mLoadGroup->AddRequest(this, nullptr);
  }
  mOpened = true;

  if (mPreCachedJarReader || !mEnableOMT) {
    RefPtr<nsJARInputThunk> input;
    rv = CreateJarInput(gJarHandler->JarCache(), getter_AddRefs(input));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return OnOpenLocalFileComplete(rv, true);
    }
    return ContinueOpenLocalFile(input, true);
  }

  nsCOMPtr<nsIZipReaderCache> jarCache = gJarHandler->JarCache();
  if (NS_WARN_IF(!jarCache)) {
    return NS_ERROR_UNEXPECTED;
  }

  nsCOMPtr<nsIFile> clonedFile;
  rv = mJarFile->Clone(getter_AddRefs(clonedFile));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsCOMPtr<nsIJARURI> localJARURI = mJarURI;

  nsAutoCString jarEntry(mJarEntry);
  nsAutoCString innerJarEntry(mInnerJarEntry);

  RefPtr<nsJARChannel> self = this;
  return mWorker->Dispatch(NS_NewRunnableFunction(
      "nsJARChannel::OpenLocalFile", [self, jarCache, clonedFile, localJARURI,
                                      jarEntry, innerJarEntry]() mutable {
        RefPtr<nsJARInputThunk> input;
        nsresult rv =
            CreateLocalJarInput(jarCache, clonedFile, innerJarEntry,
                                localJARURI, jarEntry, getter_AddRefs(input));

        nsCOMPtr<nsIRunnable> target;
        if (NS_SUCCEEDED(rv)) {
          target = NewRunnableMethod<RefPtr<nsJARInputThunk>, bool>(
              "nsJARChannel::ContinueOpenLocalFile", self,
              &nsJARChannel::ContinueOpenLocalFile, input, false);
        } else {
          target = NewRunnableMethod<nsresult, bool>(
              "nsJARChannel::OnOpenLocalFileComplete", self,
              &nsJARChannel::OnOpenLocalFileComplete, rv, false);
        }

        // nsJARChannel must be release on main thread, and sometimes
        // this still hold nsJARChannel after dispatched.
        self = nullptr;

        NS_DispatchToMainThread(target.forget());
      }));
}

nsresult nsJARChannel::ContinueOpenLocalFile(nsJARInputThunk* aInput,
                                             bool aIsSyncCall) {
  LOG(("nsJARChannel::ContinueOpenLocalFile [this=%p %p]\n", this, aInput));

  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mIsPending);

  // Make GetContentLength meaningful
  mContentLength = aInput->GetContentLength();

  nsresult rv;
  RefPtr<nsJARInputThunk> input = aInput;
  // Create input stream pump and call AsyncRead as a block.
  rv = NS_NewInputStreamPump(getter_AddRefs(mPump), input.forget());
  if (NS_SUCCEEDED(rv)) {
    rv = mPump->AsyncRead(this, nullptr);
  }

  if (NS_SUCCEEDED(rv)) {
    rv = CheckPendingEvents();
  }

  return OnOpenLocalFileComplete(rv, aIsSyncCall);
}

nsresult nsJARChannel::OnOpenLocalFileComplete(nsresult aResult,
                                               bool aIsSyncCall) {
  LOG(("nsJARChannel::OnOpenLocalFileComplete [this=%p %08x]\n", this,
       static_cast<uint32_t>(aResult)));

  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mIsPending);

  if (NS_FAILED(aResult)) {
    if (!aIsSyncCall) {
      NotifyError(aResult);
    }

    if (mLoadGroup) {
      mLoadGroup->RemoveRequest(this, nullptr, aResult);
    }

    mOpened = false;
    mIsPending = false;
    mListener = nullptr;
    mCallbacks = nullptr;
    mProgressSink = nullptr;

    return aResult;
  }

  return NS_OK;
}

nsresult nsJARChannel::CheckPendingEvents() {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mIsPending);
  MOZ_ASSERT(mPump);

  nsresult rv;

  auto suspendCount = mPendingEvent.suspendCount;
  while (suspendCount--) {
    if (NS_WARN_IF(NS_FAILED(rv = mPump->Suspend()))) {
      return rv;
    }
  }

  if (mPendingEvent.isCanceled) {
    if (NS_WARN_IF(NS_FAILED(rv = mPump->Cancel(mStatus)))) {
      return rv;
    }
    mPendingEvent.isCanceled = false;
  }

  return NS_OK;
}

void nsJARChannel::NotifyError(nsresult aError) {
  MOZ_ASSERT(NS_FAILED(aError));

  mStatus = aError;

  OnStartRequest(nullptr);
  OnStopRequest(nullptr, aError);
}

void nsJARChannel::FireOnProgress(uint64_t aProgress) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mProgressSink);

  mProgressSink->OnProgress(this, aProgress, mContentLength);
}

//-----------------------------------------------------------------------------
// nsIRequest
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsJARChannel::GetName(nsACString& result) { return mJarURI->GetSpec(result); }

NS_IMETHODIMP
nsJARChannel::IsPending(bool* result) {
  *result = mIsPending;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetStatus(nsresult* status) {
  if (mPump && NS_SUCCEEDED(mStatus))
    mPump->GetStatus(status);
  else
    *status = mStatus;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::Cancel(nsresult status) {
  mCanceled = true;
  mStatus = status;
  if (mPump) {
    return mPump->Cancel(status);
  }

  if (mIsPending) {
    mPendingEvent.isCanceled = true;
  }

  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetCanceled(bool* aCanceled) {
  *aCanceled = mCanceled;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::Suspend() {
  ++mPendingEvent.suspendCount;

  if (mPump) {
    return mPump->Suspend();
  }

  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::Resume() {
  if (NS_WARN_IF(mPendingEvent.suspendCount == 0)) {
    return NS_ERROR_UNEXPECTED;
  }
  --mPendingEvent.suspendCount;

  if (mPump) {
    return mPump->Resume();
  }

  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetLoadFlags(nsLoadFlags* aLoadFlags) {
  *aLoadFlags = mLoadFlags;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetLoadFlags(nsLoadFlags aLoadFlags) {
  mLoadFlags = aLoadFlags;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetTRRMode(nsIRequest::TRRMode* aTRRMode) {
  return GetTRRModeImpl(aTRRMode);
}

NS_IMETHODIMP
nsJARChannel::SetTRRMode(nsIRequest::TRRMode aTRRMode) {
  return SetTRRModeImpl(aTRRMode);
}

NS_IMETHODIMP
nsJARChannel::GetIsDocument(bool* aIsDocument) {
  return NS_GetIsDocumentChannel(this, aIsDocument);
}

NS_IMETHODIMP
nsJARChannel::GetLoadGroup(nsILoadGroup** aLoadGroup) {
  NS_IF_ADDREF(*aLoadGroup = mLoadGroup);
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetLoadGroup(nsILoadGroup* aLoadGroup) {
  mLoadGroup = aLoadGroup;
  return NS_OK;
}

//-----------------------------------------------------------------------------
// nsIChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsJARChannel::GetOriginalURI(nsIURI** aURI) {
  *aURI = mOriginalURI;
  NS_ADDREF(*aURI);
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetOriginalURI(nsIURI* aURI) {
  NS_ENSURE_ARG_POINTER(aURI);
  mOriginalURI = aURI;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetURI(nsIURI** aURI) {
  NS_IF_ADDREF(*aURI = mJarURI);

  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetOwner(nsISupports** aOwner) {
  // JAR signatures are not processed to avoid main-thread network I/O (bug
  // 726125)
  *aOwner = mOwner;
  NS_IF_ADDREF(*aOwner);
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetOwner(nsISupports* aOwner) {
  mOwner = aOwner;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetLoadInfo(nsILoadInfo** aLoadInfo) {
  NS_IF_ADDREF(*aLoadInfo = mLoadInfo);
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetLoadInfo(nsILoadInfo* aLoadInfo) {
  MOZ_RELEASE_ASSERT(aLoadInfo, "loadinfo can't be null");
  mLoadInfo = aLoadInfo;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetNotificationCallbacks(nsIInterfaceRequestor** aCallbacks) {
  NS_IF_ADDREF(*aCallbacks = mCallbacks);
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetNotificationCallbacks(nsIInterfaceRequestor* aCallbacks) {
  mCallbacks = aCallbacks;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetSecurityInfo(nsISupports** aSecurityInfo) {
  MOZ_ASSERT(aSecurityInfo, "Null out param");
  NS_IF_ADDREF(*aSecurityInfo = mSecurityInfo);
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetContentType(nsACString& result) {
  // If the Jar file has not been open yet,
  // We return application/x-unknown-content-type
  if (!mOpened) {
    result.AssignLiteral(UNKNOWN_CONTENT_TYPE);
    return NS_OK;
  }

  if (mContentType.IsEmpty()) {
    //
    // generate content type and set it
    //
    const char *ext = nullptr, *fileName = mJarEntry.get();
    int32_t len = mJarEntry.Length();

    // check if we're displaying a directory
    // mJarEntry will be empty if we're trying to display
    // the topmost directory in a zip, e.g. jar:foo.zip!/
    if (ENTRY_IS_DIRECTORY(mJarEntry)) {
      mContentType.AssignLiteral(APPLICATION_HTTP_INDEX_FORMAT);
    } else {
      // not a directory, take a guess by its extension
      for (int32_t i = len - 1; i >= 0; i--) {
        if (fileName[i] == '.') {
          ext = &fileName[i + 1];
          break;
        }
      }
      if (ext) {
        nsIMIMEService* mimeServ = gJarHandler->MimeService();
        if (mimeServ)
          mimeServ->GetTypeFromExtension(nsDependentCString(ext), mContentType);
      }
      if (mContentType.IsEmpty())
        mContentType.AssignLiteral(UNKNOWN_CONTENT_TYPE);
    }
  }
  result = mContentType;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetContentType(const nsACString& aContentType) {
  // If someone gives us a type hint we should just use that type instead of
  // doing our guessing.  So we don't care when this is being called.

  // mContentCharset is unchanged if not parsed
  NS_ParseResponseContentType(aContentType, mContentType, mContentCharset);
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetContentCharset(nsACString& aContentCharset) {
  // If someone gives us a charset hint we should just use that charset.
  // So we don't care when this is being called.
  aContentCharset = mContentCharset;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetContentCharset(const nsACString& aContentCharset) {
  mContentCharset = aContentCharset;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetContentDisposition(uint32_t* aContentDisposition) {
  return NS_ERROR_NOT_AVAILABLE;
}

NS_IMETHODIMP
nsJARChannel::SetContentDisposition(uint32_t aContentDisposition) {
  return NS_ERROR_NOT_AVAILABLE;
}

NS_IMETHODIMP
nsJARChannel::GetContentDispositionFilename(
    nsAString& aContentDispositionFilename) {
  return NS_ERROR_NOT_AVAILABLE;
}

NS_IMETHODIMP
nsJARChannel::SetContentDispositionFilename(
    const nsAString& aContentDispositionFilename) {
  return NS_ERROR_NOT_AVAILABLE;
}

NS_IMETHODIMP
nsJARChannel::GetContentDispositionHeader(
    nsACString& aContentDispositionHeader) {
  return NS_ERROR_NOT_AVAILABLE;
}

NS_IMETHODIMP
nsJARChannel::GetContentLength(int64_t* result) {
  *result = mContentLength;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetContentLength(int64_t aContentLength) {
  // XXX does this really make any sense at all?
  mContentLength = aContentLength;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::Open(nsIInputStream** aStream) {
  LOG(("nsJARChannel::Open [this=%p]\n", this));
  nsCOMPtr<nsIStreamListener> listener;
  nsresult rv =
      nsContentSecurityManager::doContentSecurityCheck(this, listener);
  NS_ENSURE_SUCCESS(rv, rv);

  LOG(("nsJARChannel::Open [this=%p]\n", this));

  NS_ENSURE_TRUE(!mOpened, NS_ERROR_IN_PROGRESS);
  NS_ENSURE_TRUE(!mIsPending, NS_ERROR_IN_PROGRESS);

  mJarFile = nullptr;

  rv = LookupFile();
  if (NS_FAILED(rv)) return rv;

  // If mJarFile was not set by LookupFile, we can't open a channel.
  if (!mJarFile) {
    MOZ_ASSERT_UNREACHABLE("only file-backed jars are supported");
    return NS_ERROR_NOT_IMPLEMENTED;
  }

  RefPtr<nsJARInputThunk> input;
  rv = CreateJarInput(gJarHandler->JarCache(), getter_AddRefs(input));
  if (NS_FAILED(rv)) return rv;

  input.forget(aStream);
  mOpened = true;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::AsyncOpen(nsIStreamListener* aListener) {
  LOG(("nsJARChannel::AsyncOpen [this=%p]\n", this));
  nsCOMPtr<nsIStreamListener> listener = aListener;
  nsresult rv =
      nsContentSecurityManager::doContentSecurityCheck(this, listener);
  if (NS_FAILED(rv)) {
    mIsPending = false;
    mListener = nullptr;
    mCallbacks = nullptr;
    mProgressSink = nullptr;
    return rv;
  }

  LOG(("nsJARChannel::AsyncOpen [this=%p]\n", this));
  MOZ_ASSERT(
      mLoadInfo->GetSecurityMode() == 0 ||
          mLoadInfo->GetInitialSecurityCheckDone() ||
          (mLoadInfo->GetSecurityMode() ==
               nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_IS_NULL &&
           mLoadInfo->GetLoadingPrincipal() &&
           mLoadInfo->GetLoadingPrincipal()->IsSystemPrincipal()),
      "security flags in loadInfo but doContentSecurityCheck() not called");

  NS_ENSURE_ARG_POINTER(listener);
  NS_ENSURE_TRUE(!mOpened, NS_ERROR_IN_PROGRESS);
  NS_ENSURE_TRUE(!mIsPending, NS_ERROR_IN_PROGRESS);

  mJarFile = nullptr;

  // Initialize mProgressSink
  NS_QueryNotificationCallbacks(mCallbacks, mLoadGroup, mProgressSink);

  mListener = listener;
  mIsPending = true;

  rv = LookupFile();
  if (NS_FAILED(rv) || !mJarFile) {
    // Not a local file...
    mIsPending = false;
    mListener = nullptr;
    mCallbacks = nullptr;
    mProgressSink = nullptr;
    return mJarFile ? rv : NS_ERROR_UNSAFE_CONTENT_TYPE;
  }

  rv = OpenLocalFile();
  if (NS_FAILED(rv)) {
    mIsPending = false;
    mListener = nullptr;
    mCallbacks = nullptr;
    mProgressSink = nullptr;
    return rv;
  }

  return NS_OK;
}

//-----------------------------------------------------------------------------
// nsIJARChannel
//-----------------------------------------------------------------------------
NS_IMETHODIMP
nsJARChannel::GetJarFile(nsIFile** aFile) {
  NS_IF_ADDREF(*aFile = mJarFile);
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::SetJarFile(nsIFile* aFile) {
  if (mOpened) {
    return NS_ERROR_IN_PROGRESS;
  }
  mJarFileOverride = aFile;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::EnsureCached(bool* aIsCached) {
  nsresult rv;
  *aIsCached = false;

  if (mOpened) {
    return NS_ERROR_ALREADY_OPENED;
  }

  if (mPreCachedJarReader) {
    // We've already been called and found the JAR is cached
    *aIsCached = true;
    return NS_OK;
  }

  nsCOMPtr<nsIURI> innerFileURI;
  rv = mJarURI->GetJARFile(getter_AddRefs(innerFileURI));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIFileURL> innerFileURL = do_QueryInterface(innerFileURI, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIFile> jarFile;
  rv = innerFileURL->GetFile(getter_AddRefs(jarFile));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIIOService> ioService = do_GetIOService(&rv);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIProtocolHandler> handler;
  rv = ioService->GetProtocolHandler("jar", getter_AddRefs(handler));
  NS_ENSURE_SUCCESS(rv, rv);

  auto jarHandler = static_cast<nsJARProtocolHandler*>(handler.get());
  MOZ_ASSERT(jarHandler);

  nsIZipReaderCache* jarCache = jarHandler->JarCache();

  rv = jarCache->GetZipIfCached(jarFile, getter_AddRefs(mPreCachedJarReader));
  if (rv == NS_ERROR_CACHE_KEY_NOT_FOUND) {
    return NS_OK;
  }
  NS_ENSURE_SUCCESS(rv, rv);

  *aIsCached = true;
  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::GetZipEntry(nsIZipEntry** aZipEntry) {
  nsresult rv = LookupFile();
  if (NS_FAILED(rv)) return rv;

  if (!mJarFile) return NS_ERROR_NOT_AVAILABLE;

  nsCOMPtr<nsIZipReader> reader;
  rv = gJarHandler->JarCache()->GetZip(mJarFile, getter_AddRefs(reader));
  if (NS_FAILED(rv)) return rv;

  return reader->GetEntry(mJarEntry, aZipEntry);
}

//-----------------------------------------------------------------------------
// nsIStreamListener
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsJARChannel::OnStartRequest(nsIRequest* req) {
  LOG(("nsJARChannel::OnStartRequest [this=%p %s]\n", this, mSpec.get()));

  mRequest = req;
  nsresult rv = mListener->OnStartRequest(this);
  if (NS_FAILED(rv)) {
    return rv;
  }

  // Restrict loadable content types.
  nsAutoCString contentType;
  GetContentType(contentType);
  auto contentPolicyType = mLoadInfo->GetExternalContentPolicyType();
  if (contentType.Equals(APPLICATION_HTTP_INDEX_FORMAT) &&
      contentPolicyType != nsIContentPolicy::TYPE_DOCUMENT &&
      contentPolicyType != nsIContentPolicy::TYPE_FETCH) {
    return NS_ERROR_CORRUPTED_CONTENT;
  }
  if (contentPolicyType == nsIContentPolicy::TYPE_STYLESHEET &&
      !contentType.EqualsLiteral(TEXT_CSS)) {
    return NS_ERROR_CORRUPTED_CONTENT;
  }
  if (contentPolicyType == nsIContentPolicy::TYPE_SCRIPT &&
      !nsContentUtils::IsJavascriptMIMEType(
          NS_ConvertUTF8toUTF16(contentType))) {
    return NS_ERROR_CORRUPTED_CONTENT;
  }

  return rv;
}

NS_IMETHODIMP
nsJARChannel::OnStopRequest(nsIRequest* req, nsresult status) {
  LOG(("nsJARChannel::OnStopRequest [this=%p %s status=%" PRIx32 "]\n", this,
       mSpec.get(), static_cast<uint32_t>(status)));

  if (NS_SUCCEEDED(mStatus)) mStatus = status;

  if (mListener) {
    mListener->OnStopRequest(this, status);
    mListener = nullptr;
  }

  if (mLoadGroup) mLoadGroup->RemoveRequest(this, nullptr, status);

  mRequest = nullptr;
  mPump = nullptr;
  mIsPending = false;

  // Drop notification callbacks to prevent cycles.
  mCallbacks = nullptr;
  mProgressSink = nullptr;

#if defined(XP_WIN) || defined(MOZ_WIDGET_COCOA)
#else
  // To deallocate file descriptor by RemoteOpenFileChild destructor.
  mJarFile = nullptr;
#endif

  return NS_OK;
}

NS_IMETHODIMP
nsJARChannel::OnDataAvailable(nsIRequest* req, nsIInputStream* stream,
                              uint64_t offset, uint32_t count) {
  LOG(("nsJARChannel::OnDataAvailable [this=%p %s]\n", this, mSpec.get()));

  nsresult rv;

  rv = mListener->OnDataAvailable(this, stream, offset, count);

  // simply report progress here instead of hooking ourselves up as a
  // nsITransportEventSink implementation.
  // XXX do the 64-bit stuff for real
  if (mProgressSink && NS_SUCCEEDED(rv)) {
    if (NS_IsMainThread()) {
      FireOnProgress(offset + count);
    } else {
      NS_DispatchToMainThread(NewRunnableMethod<uint64_t>(
          "nsJARChannel::FireOnProgress", this, &nsJARChannel::FireOnProgress,
          offset + count));
    }
  }

  return rv;  // let the pump cancel on failure
}

NS_IMETHODIMP
nsJARChannel::RetargetDeliveryTo(nsIEventTarget* aEventTarget) {
  MOZ_ASSERT(NS_IsMainThread());

  nsCOMPtr<nsIThreadRetargetableRequest> request = do_QueryInterface(mRequest);
  if (!request) {
    return NS_ERROR_NO_INTERFACE;
  }

  return request->RetargetDeliveryTo(aEventTarget);
}

NS_IMETHODIMP
nsJARChannel::GetDeliveryTarget(nsIEventTarget** aEventTarget) {
  MOZ_ASSERT(NS_IsMainThread());

  nsCOMPtr<nsIThreadRetargetableRequest> request = do_QueryInterface(mRequest);
  if (!request) {
    return NS_ERROR_NO_INTERFACE;
  }

  return request->GetDeliveryTarget(aEventTarget);
}

NS_IMETHODIMP
nsJARChannel::CheckListenerChain() {
  MOZ_ASSERT(NS_IsMainThread());

  nsCOMPtr<nsIThreadRetargetableStreamListener> listener =
      do_QueryInterface(mListener);
  if (!listener) {
    return NS_ERROR_NO_INTERFACE;
  }

  return listener->CheckListenerChain();
}
