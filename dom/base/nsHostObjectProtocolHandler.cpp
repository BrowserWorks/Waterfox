/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsHostObjectProtocolHandler.h"

#include "DOMMediaStream.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/Exceptions.h"
#include "mozilla/dom/File.h"
#include "mozilla/dom/ipc/BlobChild.h"
#include "mozilla/dom/ipc/BlobParent.h"
#include "mozilla/dom/MediaSource.h"
#include "mozilla/LoadInfo.h"
#include "mozilla/ModuleUtils.h"
#include "mozilla/Preferences.h"
#include "nsClassHashtable.h"
#include "nsContentUtils.h"
#include "nsError.h"
#include "nsHostObjectURI.h"
#include "nsIMemoryReporter.h"
#include "nsIPrincipal.h"
#include "nsIUUIDGenerator.h"
#include "nsNetUtil.h"

#define RELEASING_TIMER 1000

using mozilla::DOMMediaStream;
using mozilla::dom::BlobImpl;
using mozilla::dom::MediaSource;
using mozilla::ErrorResult;
using mozilla::net::LoadInfo;
using mozilla::Move;

// -----------------------------------------------------------------------
// Hash table
struct DataInfo
{
  enum ObjectType {
    eBlobImpl,
    eMediaStream,
    eMediaSource
  };

  DataInfo(BlobImpl* aBlobImpl, nsIPrincipal* aPrincipal)
    : mObjectType(eBlobImpl)
    , mBlobImpl(aBlobImpl)
    , mPrincipal(aPrincipal)
  {}

  DataInfo(DOMMediaStream* aMediaStream, nsIPrincipal* aPrincipal)
    : mObjectType(eMediaStream)
    , mMediaStream(aMediaStream)
    , mPrincipal(aPrincipal)
  {}

  DataInfo(MediaSource* aMediaSource, nsIPrincipal* aPrincipal)
    : mObjectType(eMediaSource)
    , mMediaSource(aMediaSource)
    , mPrincipal(aPrincipal)
  {}

  ObjectType mObjectType;

  RefPtr<BlobImpl> mBlobImpl;
  RefPtr<DOMMediaStream> mMediaStream;
  RefPtr<MediaSource> mMediaSource;

  nsCOMPtr<nsIPrincipal> mPrincipal;
  nsCString mStack;

  // WeakReferences of nsHostObjectURI objects.
  nsTArray<nsWeakPtr> mURIs;
};

static nsClassHashtable<nsCStringHashKey, DataInfo>* gDataTable;

static DataInfo*
GetDataInfo(const nsACString& aUri)
{
  if (!gDataTable) {
    return nullptr;
  }

  DataInfo* res;

  // Let's remove any fragment and query from this URI.
  int32_t hasFragmentPos = aUri.FindChar('#');
  int32_t hasQueryPos = aUri.FindChar('?');

  int32_t pos = -1;
  if (hasFragmentPos >= 0 && hasQueryPos >= 0) {
    pos = std::min(hasFragmentPos, hasQueryPos);
  } else if (hasFragmentPos >= 0) {
    pos = hasFragmentPos;
  } else {
    pos = hasQueryPos;
  }

  if (pos < 0) {
    gDataTable->Get(aUri, &res);
  } else {
    gDataTable->Get(StringHead(aUri, pos), &res);
  }

  return res;
}

static DataInfo*
GetDataInfoFromURI(nsIURI* aURI)
{
  if (!aURI) {
    return nullptr;
  }

  nsCString spec;
  nsresult rv = aURI->GetSpec(spec);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return nullptr;
  }

  return GetDataInfo(spec);
}

// Memory reporting for the hash table.
namespace mozilla {

void
BroadcastBlobURLRegistration(const nsACString& aURI,
                             BlobImpl* aBlobImpl,
                             nsIPrincipal* aPrincipal)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aBlobImpl);

  if (XRE_IsParentProcess()) {
    dom::ContentParent::BroadcastBlobURLRegistration(aURI, aBlobImpl,
                                                     aPrincipal);
    return;
  }

  dom::ContentChild* cc = dom::ContentChild::GetSingleton();
  dom::BlobChild* actor = cc->GetOrCreateActorForBlobImpl(aBlobImpl);
  if (NS_WARN_IF(!actor)) {
    return;
  }

  Unused << NS_WARN_IF(!cc->SendStoreAndBroadcastBlobURLRegistration(
    nsCString(aURI), actor, IPC::Principal(aPrincipal)));
}

void
BroadcastBlobURLUnregistration(const nsACString& aURI, DataInfo* aInfo)
{
  MOZ_ASSERT(aInfo);
  MOZ_ASSERT(NS_IsMainThread());

  if (XRE_IsParentProcess()) {
    dom::ContentParent::BroadcastBlobURLUnregistration(aURI);
    return;
  }

  dom::ContentChild* cc = dom::ContentChild::GetSingleton();
  Unused << NS_WARN_IF(!cc->SendUnstoreAndBroadcastBlobURLUnregistration(
    nsCString(aURI)));
}

class HostObjectURLsReporter final : public nsIMemoryReporter
{
  ~HostObjectURLsReporter() {}

 public:
  NS_DECL_ISUPPORTS

  NS_IMETHOD CollectReports(nsIHandleReportCallback* aHandleReport,
                            nsISupports* aData, bool aAnonymize) override
  {
    MOZ_COLLECT_REPORT(
      "host-object-urls", KIND_OTHER, UNITS_COUNT,
      gDataTable ? gDataTable->Count() : 0,
      "The number of host objects stored for access via URLs "
      "(e.g. blobs passed to URL.createObjectURL).");

    return NS_OK;
  }
};

NS_IMPL_ISUPPORTS(HostObjectURLsReporter, nsIMemoryReporter)

class BlobURLsReporter final : public nsIMemoryReporter
{
 public:
  NS_DECL_ISUPPORTS

  NS_IMETHOD CollectReports(nsIHandleReportCallback* aCallback,
                            nsISupports* aData, bool aAnonymize) override
  {
    if (!gDataTable) {
      return NS_OK;
    }

    nsDataHashtable<nsPtrHashKey<BlobImpl>, uint32_t> refCounts;

    // Determine number of URLs per BlobImpl, to handle the case where it's > 1.
    for (auto iter = gDataTable->Iter(); !iter.Done(); iter.Next()) {
      if (iter.UserData()->mObjectType != DataInfo::eBlobImpl) {
        continue;
      }

      BlobImpl* blobImpl = iter.UserData()->mBlobImpl;
      MOZ_ASSERT(blobImpl);

      refCounts.Put(blobImpl, refCounts.Get(blobImpl) + 1);
    }

    for (auto iter = gDataTable->Iter(); !iter.Done(); iter.Next()) {
      nsCStringHashKey::KeyType key = iter.Key();
      DataInfo* info = iter.UserData();

      if (iter.UserData()->mObjectType == DataInfo::eBlobImpl) {
        BlobImpl* blobImpl = iter.UserData()->mBlobImpl;
        MOZ_ASSERT(blobImpl);

        NS_NAMED_LITERAL_CSTRING(desc,
          "A blob URL allocated with URL.createObjectURL; the referenced "
          "blob cannot be freed until all URLs for it have been explicitly "
          "invalidated with URL.revokeObjectURL.");
        nsAutoCString path, url, owner, specialDesc;
        uint64_t size = 0;
        uint32_t refCount = 1;
        DebugOnly<bool> blobImplWasCounted;

        blobImplWasCounted = refCounts.Get(blobImpl, &refCount);
        MOZ_ASSERT(blobImplWasCounted);
        MOZ_ASSERT(refCount > 0);

        bool isMemoryFile = blobImpl->IsMemoryFile();

        if (isMemoryFile) {
          ErrorResult rv;
          size = blobImpl->GetSize(rv);
          if (NS_WARN_IF(rv.Failed())) {
            rv.SuppressException();
            size = 0;
          }
        }

        path = isMemoryFile ? "memory-blob-urls/" : "file-blob-urls/";
        BuildPath(path, key, info, aAnonymize);

        if (refCount > 1) {
          nsAutoCString addrStr;

          addrStr = "0x";
          addrStr.AppendInt((uint64_t)(BlobImpl*)blobImpl, 16);

          path += " ";
          path.AppendInt(refCount);
          path += "@";
          path += addrStr;

          specialDesc = desc;
          specialDesc += "\n\nNOTE: This blob (address ";
          specialDesc += addrStr;
          specialDesc += ") has ";
          specialDesc.AppendInt(refCount);
          specialDesc += " URLs.";
          if (isMemoryFile) {
            specialDesc += " Its size is divided ";
            specialDesc += refCount > 2 ? "among" : "between";
            specialDesc += " them in this report.";
          }
        }

        const nsACString& descString = specialDesc.IsEmpty()
            ? static_cast<const nsACString&>(desc)
            : static_cast<const nsACString&>(specialDesc);
        if (isMemoryFile) {
          aCallback->Callback(EmptyCString(),
              path,
              KIND_OTHER,
              UNITS_BYTES,
              size / refCount,
              descString,
              aData);
        } else {
          aCallback->Callback(EmptyCString(),
              path,
              KIND_OTHER,
              UNITS_COUNT,
              1,
              descString,
              aData);
        }
        continue;
      }

      // Just report the path for the DOMMediaStream or MediaSource.
      nsAutoCString path;
      path = iter.UserData()->mObjectType == DataInfo::eMediaSource
               ? "media-source-urls/" : "dom-media-stream-urls/";
      BuildPath(path, key, info, aAnonymize);

      NS_NAMED_LITERAL_CSTRING(desc,
        "An object URL allocated with URL.createObjectURL; the referenced "
        "data cannot be freed until all URLs for it have been explicitly "
        "invalidated with URL.revokeObjectURL.");

      aCallback->Callback(EmptyCString(), path, KIND_OTHER, UNITS_COUNT, 1,
                          desc, aData);
    }

    return NS_OK;
  }

  // Initialize info->mStack to record JS stack info, if enabled.
  // The string generated here is used in ReportCallback, below.
  static void GetJSStackForBlob(DataInfo* aInfo)
  {
    nsCString& stack = aInfo->mStack;
    MOZ_ASSERT(stack.IsEmpty());
    const uint32_t maxFrames = Preferences::GetUint("memory.blob_report.stack_frames");

    if (maxFrames == 0) {
      return;
    }

    nsCOMPtr<nsIStackFrame> frame = dom::GetCurrentJSStack(maxFrames);

    nsAutoCString origin;
    nsCOMPtr<nsIURI> principalURI;
    if (NS_SUCCEEDED(aInfo->mPrincipal->GetURI(getter_AddRefs(principalURI)))
        && principalURI) {
      principalURI->GetPrePath(origin);
    }

    // If we got a frame, we better have a current JSContext.  This is cheating
    // a bit; ideally we'd have our caller pass in a JSContext, or have
    // GetCurrentJSStack() hand out the JSContext it found.
    JSContext* cx = frame ? nsContentUtils::GetCurrentJSContext() : nullptr;

    for (uint32_t i = 0; frame; ++i) {
      nsString fileNameUTF16;
      int32_t lineNumber = 0;

      frame->GetFilename(cx, fileNameUTF16);
      frame->GetLineNumber(cx, &lineNumber);

      if (!fileNameUTF16.IsEmpty()) {
        NS_ConvertUTF16toUTF8 fileName(fileNameUTF16);
        stack += "js(";
        if (!origin.IsEmpty()) {
          // Make the file name root-relative for conciseness if possible.
          const char* originData;
          uint32_t originLen;

          originLen = origin.GetData(&originData);
          // If fileName starts with origin + "/", cut up to that "/".
          if (fileName.Length() >= originLen + 1 &&
              memcmp(fileName.get(), originData, originLen) == 0 &&
              fileName[originLen] == '/') {
            fileName.Cut(0, originLen);
          }
        }
        fileName.ReplaceChar('/', '\\');
        stack += fileName;
        if (lineNumber > 0) {
          stack += ", line=";
          stack.AppendInt(lineNumber);
        }
        stack += ")/";
      }

      nsCOMPtr<nsIStackFrame> caller;
      nsresult rv = frame->GetCaller(cx, getter_AddRefs(caller));
      NS_ENSURE_SUCCESS_VOID(rv);
      caller.swap(frame);
    }
  }

 private:
  ~BlobURLsReporter() {}

  static void BuildPath(nsAutoCString& path,
                        nsCStringHashKey::KeyType aKey,
                        DataInfo* aInfo,
                        bool anonymize)
  {
    nsCOMPtr<nsIURI> principalURI;
    nsAutoCString url, owner;
    if (NS_SUCCEEDED(aInfo->mPrincipal->GetURI(getter_AddRefs(principalURI))) &&
        principalURI != nullptr &&
        NS_SUCCEEDED(principalURI->GetSpec(owner)) &&
        !owner.IsEmpty()) {
      owner.ReplaceChar('/', '\\');
      path += "owner(";
      if (anonymize) {
        path += "<anonymized>";
      } else {
        path += owner;
      }
      path += ")";
    } else {
      path += "owner unknown";
    }
    path += "/";
    if (anonymize) {
      path += "<anonymized-stack>";
    } else {
      path += aInfo->mStack;
    }
    url = aKey;
    url.ReplaceChar('/', '\\');
    if (anonymize) {
      path += "<anonymized-url>";
    } else {
      path += url;
    }
  }
};

NS_IMPL_ISUPPORTS(BlobURLsReporter, nsIMemoryReporter)

class ReleasingTimerHolder final : public nsITimerCallback
{
public:
  NS_DECL_ISUPPORTS

  static void
  Create(nsTArray<nsWeakPtr>&& aArray)
  {
    RefPtr<ReleasingTimerHolder> holder = new ReleasingTimerHolder(Move(aArray));
    holder->mTimer = do_CreateInstance(NS_TIMER_CONTRACTID);

    // If we are shutting down, we are not able to create a timer.
    if (!holder->mTimer) {
      return;
    }

    nsresult rv = holder->mTimer->InitWithCallback(holder, RELEASING_TIMER,
                                                   nsITimer::TYPE_ONE_SHOT);
    NS_ENSURE_SUCCESS_VOID(rv);
  }

  NS_IMETHOD
  Notify(nsITimer* aTimer) override
  {
    for (uint32_t i = 0; i < mURIs.Length(); ++i) {
      nsCOMPtr<nsIURI> uri = do_QueryReferent(mURIs[i]);
      if (uri) {
        static_cast<nsHostObjectURI*>(uri.get())->ForgetBlobImpl();
      }
    }

    return NS_OK;
  }

private:
  explicit ReleasingTimerHolder(nsTArray<nsWeakPtr>&& aArray)
    : mURIs(aArray)
  {}

  ~ReleasingTimerHolder()
  {}

  nsTArray<nsWeakPtr> mURIs;
  nsCOMPtr<nsITimer> mTimer;
};

NS_IMPL_ISUPPORTS(ReleasingTimerHolder, nsITimerCallback)

} // namespace mozilla

template<typename T>
static nsresult
AddDataEntryInternal(const nsACString& aURI, T aObject,
                     nsIPrincipal* aPrincipal)
{
  if (!gDataTable) {
    gDataTable = new nsClassHashtable<nsCStringHashKey, DataInfo>;
  }

  DataInfo* info = new DataInfo(aObject, aPrincipal);
  mozilla::BlobURLsReporter::GetJSStackForBlob(info);

  gDataTable->Put(aURI, info);
  return NS_OK;
}

void
nsHostObjectProtocolHandler::Init(void)
{
  static bool initialized = false;

  if (!initialized) {
    initialized = true;
    RegisterStrongMemoryReporter(new mozilla::HostObjectURLsReporter());
    RegisterStrongMemoryReporter(new mozilla::BlobURLsReporter());
  }
}

nsHostObjectProtocolHandler::nsHostObjectProtocolHandler()
{
  Init();
}

/* static */ nsresult
nsHostObjectProtocolHandler::AddDataEntry(BlobImpl* aBlobImpl,
                                          nsIPrincipal* aPrincipal,
                                          nsACString& aUri)
{
  Init();

  nsresult rv = GenerateURIStringForBlobURL(aPrincipal, aUri);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = AddDataEntryInternal(aUri, aBlobImpl, aPrincipal);
  NS_ENSURE_SUCCESS(rv, rv);

  mozilla::BroadcastBlobURLRegistration(aUri, aBlobImpl, aPrincipal);
  return NS_OK;
}

/* static */ nsresult
nsHostObjectProtocolHandler::AddDataEntry(DOMMediaStream* aMediaStream,
                                          nsIPrincipal* aPrincipal,
                                          nsACString& aUri)
{
  Init();

  nsresult rv = GenerateURIStringForBlobURL(aPrincipal, aUri);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = AddDataEntryInternal(aUri, aMediaStream, aPrincipal);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

/* static */ nsresult
nsHostObjectProtocolHandler::AddDataEntry(MediaSource* aMediaSource,
                                          nsIPrincipal* aPrincipal,
                                          nsACString& aUri)
{
  Init();

  nsresult rv = GenerateURIStringForBlobURL(aPrincipal, aUri);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = AddDataEntryInternal(aUri, aMediaSource, aPrincipal);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

/* static */ nsresult
nsHostObjectProtocolHandler::AddDataEntry(const nsACString& aURI,
                                          nsIPrincipal* aPrincipal,
                                          mozilla::dom::BlobImpl* aBlobImpl)
{
  return AddDataEntryInternal(aURI, aBlobImpl, aPrincipal);
}

/* static */ bool
nsHostObjectProtocolHandler::GetAllBlobURLEntries(
  nsTArray<mozilla::dom::BlobURLRegistrationData>& aRegistrations,
  mozilla::dom::ContentParent* aCP)
{
  MOZ_ASSERT(aCP);

  if (!gDataTable) {
    return true;
  }

  for (auto iter = gDataTable->ConstIter(); !iter.Done(); iter.Next()) {
    DataInfo* info = iter.UserData();
    MOZ_ASSERT(info);

    if (info->mObjectType != DataInfo::eBlobImpl) {
      continue;
    }

    MOZ_ASSERT(info->mBlobImpl);
    mozilla::dom::PBlobParent* blobParent =
      aCP->GetOrCreateActorForBlobImpl(info->mBlobImpl);
    if (!blobParent) {
      return false;
    }

    aRegistrations.AppendElement(mozilla::dom::BlobURLRegistrationData(
      nsCString(iter.Key()), blobParent, nullptr,
      IPC::Principal(info->mPrincipal)));
  }

  return true;
}

/*static */ void
nsHostObjectProtocolHandler::RemoveDataEntry(const nsACString& aUri,
                                             bool aBroadcastToOtherProcesses)
{
  if (!gDataTable) {
    return;
  }

  DataInfo* info = GetDataInfo(aUri);
  if (!info) {
    return;
  }

  if (aBroadcastToOtherProcesses && info->mObjectType == DataInfo::eBlobImpl) {
    mozilla::BroadcastBlobURLUnregistration(aUri, info);
  }

  if (!info->mURIs.IsEmpty()) {
    mozilla::ReleasingTimerHolder::Create(Move(info->mURIs));
  }

  gDataTable->Remove(aUri);
  if (gDataTable->Count() == 0) {
    delete gDataTable;
    gDataTable = nullptr;
  }
}

/* static */ void
nsHostObjectProtocolHandler::RemoveDataEntries()
{
  MOZ_ASSERT(XRE_IsContentProcess());

  if (!gDataTable) {
    return;
  }

  gDataTable->Clear();
  delete gDataTable;
  gDataTable = nullptr;
}

/* static */ bool
nsHostObjectProtocolHandler::HasDataEntry(const nsACString& aUri)
{
  return !!GetDataInfo(aUri);
}

/* static */ nsresult
nsHostObjectProtocolHandler::GenerateURIString(const nsACString &aScheme,
                                               nsIPrincipal* aPrincipal,
                                               nsACString& aUri)
{
  nsresult rv;
  nsCOMPtr<nsIUUIDGenerator> uuidgen =
    do_GetService("@mozilla.org/uuid-generator;1", &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  nsID id;
  rv = uuidgen->GenerateUUIDInPlace(&id);
  NS_ENSURE_SUCCESS(rv, rv);

  char chars[NSID_LENGTH];
  id.ToProvidedString(chars);

  aUri = aScheme;
  aUri.Append(':');

  if (aPrincipal) {
    nsAutoCString origin;
    rv = nsContentUtils::GetASCIIOrigin(aPrincipal, origin);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    aUri.Append(origin);
    aUri.Append('/');
  }

  aUri += Substring(chars + 1, chars + NSID_LENGTH - 2);

  return NS_OK;
}

/* static */ nsresult
nsHostObjectProtocolHandler::GenerateURIStringForBlobURL(nsIPrincipal* aPrincipal,
                                                         nsACString& aUri)
{
  return
    GenerateURIString(NS_LITERAL_CSTRING(BLOBURI_SCHEME), aPrincipal, aUri);
}

/* static */ nsIPrincipal*
nsHostObjectProtocolHandler::GetDataEntryPrincipal(const nsACString& aUri)
{
  if (!gDataTable) {
    return nullptr;
  }

  DataInfo* res = GetDataInfo(aUri);

  if (!res) {
    return nullptr;
  }

  return res->mPrincipal;
}

/* static */ void
nsHostObjectProtocolHandler::Traverse(const nsACString& aUri,
                                      nsCycleCollectionTraversalCallback& aCallback)
{
  if (!gDataTable) {
    return;
  }

  DataInfo* res;
  gDataTable->Get(aUri, &res);
  if (!res) {
    return;
  }

  NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(aCallback, "HostObjectProtocolHandler DataInfo.mBlobImpl");
  aCallback.NoteXPCOMChild(res->mBlobImpl);

  NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(aCallback, "HostObjectProtocolHandler DataInfo.mMediaSource");
  aCallback.NoteXPCOMChild(res->mMediaSource);

  NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(aCallback, "HostObjectProtocolHandler DataInfo.mMediaStream");
  aCallback.NoteXPCOMChild(res->mMediaStream);
}

// -----------------------------------------------------------------------
// Protocol handler

NS_IMPL_ISUPPORTS(nsHostObjectProtocolHandler, nsIProtocolHandler)

NS_IMETHODIMP
nsHostObjectProtocolHandler::GetDefaultPort(int32_t *result)
{
  *result = -1;
  return NS_OK;
}

NS_IMETHODIMP
nsHostObjectProtocolHandler::GetProtocolFlags(uint32_t *result)
{
  *result = URI_NORELATIVE | URI_NOAUTH | URI_LOADABLE_BY_SUBSUMERS |
            URI_IS_LOCAL_RESOURCE | URI_NON_PERSISTABLE;
  return NS_OK;
}

NS_IMETHODIMP
nsHostObjectProtocolHandler::NewURI(const nsACString& aSpec,
                                    const char *aCharset,
                                    nsIURI *aBaseURI,
                                    nsIURI **aResult)
{
  *aResult = nullptr;
  nsresult rv;

  DataInfo* info = GetDataInfo(aSpec);

  RefPtr<nsHostObjectURI> uri;
  if (info && info->mObjectType == DataInfo::eBlobImpl) {
    MOZ_ASSERT(info->mBlobImpl);
    uri = new nsHostObjectURI(info->mPrincipal, info->mBlobImpl);
  } else {
    uri = new nsHostObjectURI(nullptr, nullptr);
  }

  rv = uri->SetSpec(aSpec);
  NS_ENSURE_SUCCESS(rv, rv);

  NS_TryToSetImmutable(uri);
  uri.forget(aResult);

  if (info && info->mObjectType == DataInfo::eBlobImpl) {
    info->mURIs.AppendElement(do_GetWeakReference(*aResult));
  }

  return NS_OK;
}

NS_IMETHODIMP
nsHostObjectProtocolHandler::NewChannel2(nsIURI* uri,
                                         nsILoadInfo* aLoadInfo,
                                         nsIChannel** result)
{
  *result = nullptr;

  nsCOMPtr<nsIURIWithBlobImpl> uriBlobImpl = do_QueryInterface(uri);
  if (!uriBlobImpl) {
    return NS_ERROR_DOM_BAD_URI;
  }

  nsCOMPtr<nsISupports> tmp;
  MOZ_ALWAYS_SUCCEEDS(uriBlobImpl->GetBlobImpl(getter_AddRefs(tmp)));
  nsCOMPtr<BlobImpl> blobImpl = do_QueryInterface(tmp);
  if (!blobImpl) {
    return NS_ERROR_DOM_BAD_URI;
  }

#ifdef DEBUG
  DataInfo* info = GetDataInfoFromURI(uri);

  // Info can be null, in case this blob URL has been revoked already.
  if (info) {
    nsCOMPtr<nsIURIWithPrincipal> uriPrinc = do_QueryInterface(uri);
    nsCOMPtr<nsIPrincipal> principal;
    uriPrinc->GetPrincipal(getter_AddRefs(principal));
    NS_ASSERTION(info->mPrincipal == principal, "Wrong principal!");
  }
#endif

  ErrorResult rv;
  nsCOMPtr<nsIInputStream> stream;
  blobImpl->GetInternalStream(getter_AddRefs(stream), rv);
  if (NS_WARN_IF(rv.Failed())) {
    return rv.StealNSResult();
  }

  nsAutoString contentType;
  blobImpl->GetType(contentType);

  nsCOMPtr<nsIChannel> channel;
  rv = NS_NewInputStreamChannelInternal(getter_AddRefs(channel),
                                        uri,
                                        stream,
                                        NS_ConvertUTF16toUTF8(contentType),
                                        EmptyCString(), // aContentCharset
                                        aLoadInfo);
  if (NS_WARN_IF(rv.Failed())) {
    return rv.StealNSResult();
  }

  if (blobImpl->IsFile()) {
    nsString filename;
    blobImpl->GetName(filename);
    channel->SetContentDispositionFilename(filename);
  }

  uint64_t size = blobImpl->GetSize(rv);
  if (NS_WARN_IF(rv.Failed())) {
    return rv.StealNSResult();
  }

  channel->SetOriginalURI(uri);
  channel->SetContentType(NS_ConvertUTF16toUTF8(contentType));
  channel->SetContentLength(size);

  channel.forget(result);

  return NS_OK;
}

NS_IMETHODIMP
nsHostObjectProtocolHandler::NewChannel(nsIURI* uri, nsIChannel* *result)
{
  return NewChannel2(uri, nullptr, result);
}

NS_IMETHODIMP
nsHostObjectProtocolHandler::AllowPort(int32_t port, const char *scheme,
                                       bool *_retval)
{
  // don't override anything.
  *_retval = false;
  return NS_OK;
}

NS_IMETHODIMP
nsBlobProtocolHandler::GetScheme(nsACString &result)
{
  result.AssignLiteral(BLOBURI_SCHEME);
  return NS_OK;
}

NS_IMETHODIMP
nsFontTableProtocolHandler::GetScheme(nsACString &result)
{
  result.AssignLiteral(FONTTABLEURI_SCHEME);
  return NS_OK;
}

nsresult
NS_GetBlobForBlobURI(nsIURI* aURI, BlobImpl** aBlob)
{
  NS_ASSERTION(IsBlobURI(aURI), "Only call this with blob URIs");

  *aBlob = nullptr;

  DataInfo* info = GetDataInfoFromURI(aURI);
  if (!info || info->mObjectType != DataInfo::eBlobImpl) {
    return NS_ERROR_DOM_BAD_URI;
  }

  RefPtr<BlobImpl> blob = info->mBlobImpl;
  blob.forget(aBlob);
  return NS_OK;
}

nsresult
NS_GetBlobForBlobURISpec(const nsACString& aSpec, BlobImpl** aBlob)
{
  *aBlob = nullptr;

  DataInfo* info = GetDataInfo(aSpec);
  if (!info || info->mObjectType != DataInfo::eBlobImpl) {
    return NS_ERROR_DOM_BAD_URI;
  }

  RefPtr<BlobImpl> blob = info->mBlobImpl;
  blob.forget(aBlob);
  return NS_OK;
}

nsresult
NS_GetStreamForBlobURI(nsIURI* aURI, nsIInputStream** aStream)
{
  RefPtr<BlobImpl> blobImpl;
  ErrorResult rv;
  rv = NS_GetBlobForBlobURI(aURI, getter_AddRefs(blobImpl));
  if (NS_WARN_IF(rv.Failed())) {
    return rv.StealNSResult();
  }

  blobImpl->GetInternalStream(aStream, rv);
  if (NS_WARN_IF(rv.Failed())) {
    return rv.StealNSResult();
  }

  return NS_OK;
}

nsresult
NS_GetStreamForMediaStreamURI(nsIURI* aURI, mozilla::DOMMediaStream** aStream)
{
  NS_ASSERTION(IsMediaStreamURI(aURI), "Only call this with mediastream URIs");

  DataInfo* info = GetDataInfoFromURI(aURI);
  if (!info || info->mObjectType != DataInfo::eMediaStream) {
    return NS_ERROR_DOM_BAD_URI;
  }

  RefPtr<DOMMediaStream> mediaStream = info->mMediaStream;
  mediaStream.forget(aStream);
  return NS_OK;
}

NS_IMETHODIMP
nsFontTableProtocolHandler::NewURI(const nsACString& aSpec,
                                   const char *aCharset,
                                   nsIURI *aBaseURI,
                                   nsIURI **aResult)
{
  RefPtr<nsIURI> uri;

  // Either you got here via a ref or a fonttable: uri
  if (aSpec.Length() && aSpec.CharAt(0) == '#') {
    nsresult rv = aBaseURI->CloneIgnoringRef(getter_AddRefs(uri));
    NS_ENSURE_SUCCESS(rv, rv);

    uri->SetRef(aSpec);
  } else {
    // Relative URIs (other than #ref) are not meaningful within the
    // fonttable: scheme.
    // If aSpec is a relative URI -other- than a bare #ref,
    // this will leave uri empty, and we'll return a failure code below.
    uri = new mozilla::net::nsSimpleURI();
    nsresult rv = uri->SetSpec(aSpec);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  bool schemeIs;
  if (NS_FAILED(uri->SchemeIs(FONTTABLEURI_SCHEME, &schemeIs)) || !schemeIs) {
    NS_WARNING("Non-fonttable spec in nsFontTableProtocolHander");
    return NS_ERROR_NOT_AVAILABLE;
  }

  uri.forget(aResult);
  return NS_OK;
}

nsresult
NS_GetSourceForMediaSourceURI(nsIURI* aURI, mozilla::dom::MediaSource** aSource)
{
  NS_ASSERTION(IsMediaSourceURI(aURI), "Only call this with mediasource URIs");

  *aSource = nullptr;

  DataInfo* info = GetDataInfoFromURI(aURI);
  if (!info || info->mObjectType != DataInfo::eMediaSource) {
    return NS_ERROR_DOM_BAD_URI;
  }

  RefPtr<MediaSource> mediaSource = info->mMediaSource;
  mediaSource.forget(aSource);
  return NS_OK;
}

#define NS_BLOBPROTOCOLHANDLER_CID \
{ 0xb43964aa, 0xa078, 0x44b2, \
  { 0xb0, 0x6b, 0xfd, 0x4d, 0x1b, 0x17, 0x2e, 0x66 } }

#define NS_FONTTABLEPROTOCOLHANDLER_CID \
{ 0x3fc8f04e, 0xd719, 0x43ca, \
  { 0x9a, 0xd0, 0x18, 0xee, 0x32, 0x02, 0x11, 0xf2 } }

NS_GENERIC_FACTORY_CONSTRUCTOR(nsBlobProtocolHandler)
NS_GENERIC_FACTORY_CONSTRUCTOR(nsFontTableProtocolHandler)

NS_DEFINE_NAMED_CID(NS_BLOBPROTOCOLHANDLER_CID);
NS_DEFINE_NAMED_CID(NS_FONTTABLEPROTOCOLHANDLER_CID);

static const mozilla::Module::CIDEntry kHostObjectProtocolHandlerCIDs[] = {
  { &kNS_BLOBPROTOCOLHANDLER_CID, false, nullptr, nsBlobProtocolHandlerConstructor },
  { &kNS_FONTTABLEPROTOCOLHANDLER_CID, false, nullptr, nsFontTableProtocolHandlerConstructor },
  { nullptr }
};

static const mozilla::Module::ContractIDEntry kHostObjectProtocolHandlerContracts[] = {
  { NS_NETWORK_PROTOCOL_CONTRACTID_PREFIX BLOBURI_SCHEME, &kNS_BLOBPROTOCOLHANDLER_CID },
  { NS_NETWORK_PROTOCOL_CONTRACTID_PREFIX FONTTABLEURI_SCHEME, &kNS_FONTTABLEPROTOCOLHANDLER_CID },
  { nullptr }
};

static const mozilla::Module kHostObjectProtocolHandlerModule = {
  mozilla::Module::kVersion,
  kHostObjectProtocolHandlerCIDs,
  kHostObjectProtocolHandlerContracts
};

NSMODULE_DEFN(HostObjectProtocolHandler) = &kHostObjectProtocolHandlerModule;

bool IsType(nsIURI* aUri, DataInfo::ObjectType aType)
{
  DataInfo* info = GetDataInfoFromURI(aUri);
  if (!info) {
    return false;
  }

  return info->mObjectType == aType;
}

bool IsBlobURI(nsIURI* aUri)
{
  return IsType(aUri, DataInfo::eBlobImpl);
}

bool IsMediaStreamURI(nsIURI* aUri)
{
  return IsType(aUri, DataInfo::eMediaStream);
}

bool IsMediaSourceURI(nsIURI* aUri)
{
  return IsType(aUri, DataInfo::eMediaSource);
}
