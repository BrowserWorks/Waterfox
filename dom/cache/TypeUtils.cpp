/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/cache/TypeUtils.h"

#include "mozilla/Unused.h"
#include "mozilla/dom/CacheBinding.h"
#include "mozilla/dom/FetchTypes.h"
#include "mozilla/dom/InternalRequest.h"
#include "mozilla/dom/Request.h"
#include "mozilla/dom/Response.h"
#include "mozilla/dom/cache/CacheTypes.h"
#include "mozilla/dom/cache/ReadStream.h"
#include "mozilla/ipc/BackgroundChild.h"
#include "mozilla/ipc/IPCStreamUtils.h"
#include "mozilla/ipc/PBackgroundChild.h"
#include "mozilla/ipc/PFileDescriptorSetChild.h"
#include "mozilla/ipc/InputStreamUtils.h"
#include "nsCOMPtr.h"
#include "nsIIPCSerializableInputStream.h"
#include "nsQueryObject.h"
#include "nsPromiseFlatString.h"
#include "nsStreamUtils.h"
#include "nsString.h"
#include "nsURLParsers.h"
#include "nsCRT.h"
#include "nsHttp.h"

namespace mozilla {
namespace dom {
namespace cache {

using mozilla::ipc::AutoIPCStream;
using mozilla::ipc::BackgroundChild;
using mozilla::ipc::FileDescriptor;
using mozilla::ipc::PBackgroundChild;
using mozilla::ipc::PFileDescriptorSetChild;

namespace {

static bool HasVaryStar(mozilla::dom::InternalHeaders* aHeaders) {
  nsCString varyHeaders;
  ErrorResult rv;
  aHeaders->Get(NS_LITERAL_CSTRING("vary"), varyHeaders, rv);
  MOZ_ALWAYS_TRUE(!rv.Failed());

  char* rawBuffer = varyHeaders.BeginWriting();
  char* token = nsCRT::strtok(rawBuffer, NS_HTTP_HEADER_SEPS, &rawBuffer);
  for (; token;
       token = nsCRT::strtok(rawBuffer, NS_HTTP_HEADER_SEPS, &rawBuffer)) {
    nsDependentCString header(token);
    if (header.EqualsLiteral("*")) {
      return true;
    }
  }
  return false;
}

void ToHeadersEntryList(nsTArray<HeadersEntry>& aOut,
                        InternalHeaders* aHeaders) {
  MOZ_DIAGNOSTIC_ASSERT(aHeaders);

  AutoTArray<InternalHeaders::Entry, 16> entryList;
  aHeaders->GetEntries(entryList);

  for (uint32_t i = 0; i < entryList.Length(); ++i) {
    InternalHeaders::Entry& entry = entryList[i];
    aOut.AppendElement(HeadersEntry(entry.mName, entry.mValue));
  }
}

}  // namespace

SafeRefPtr<InternalRequest> TypeUtils::ToInternalRequest(
    JSContext* aCx, const RequestOrUSVString& aIn, BodyAction aBodyAction,
    ErrorResult& aRv) {
  if (aIn.IsRequest()) {
    Request& request = aIn.GetAsRequest();

    // Check and set bodyUsed flag immediately because its on Request
    // instead of InternalRequest.
    CheckAndSetBodyUsed(aCx, request, aBodyAction, aRv);
    if (aRv.Failed()) {
      return nullptr;
    }

    return request.GetInternalRequest();
  }

  return ToInternalRequest(aIn.GetAsUSVString(), aRv);
}

SafeRefPtr<InternalRequest> TypeUtils::ToInternalRequest(
    JSContext* aCx, const OwningRequestOrUSVString& aIn, BodyAction aBodyAction,
    ErrorResult& aRv) {
  if (aIn.IsRequest()) {
    Request& request = aIn.GetAsRequest();

    // Check and set bodyUsed flag immediately because its on Request
    // instead of InternalRequest.
    CheckAndSetBodyUsed(aCx, request, aBodyAction, aRv);
    if (aRv.Failed()) {
      return nullptr;
    }

    return request.GetInternalRequest();
  }

  return ToInternalRequest(aIn.GetAsUSVString(), aRv);
}

void TypeUtils::ToCacheRequest(
    CacheRequest& aOut, const InternalRequest& aIn, BodyAction aBodyAction,
    SchemeAction aSchemeAction,
    nsTArray<UniquePtr<AutoIPCStream>>& aStreamCleanupList, ErrorResult& aRv) {
  aIn.GetMethod(aOut.method());
  nsCString url(aIn.GetURLWithoutFragment());
  bool schemeValid;
  ProcessURL(url, &schemeValid, &aOut.urlWithoutQuery(), &aOut.urlQuery(), aRv);
  if (aRv.Failed()) {
    return;
  }
  if (!schemeValid) {
    if (aSchemeAction == TypeErrorOnInvalidScheme) {
      aRv.ThrowTypeError<MSG_INVALID_URL_SCHEME>("Request", url);
      return;
    }
  }
  aOut.urlFragment() = aIn.GetFragment();

  aIn.GetReferrer(aOut.referrer());
  aOut.referrerPolicy() = aIn.ReferrerPolicy_();
  RefPtr<InternalHeaders> headers = aIn.Headers();
  MOZ_DIAGNOSTIC_ASSERT(headers);
  ToHeadersEntryList(aOut.headers(), headers);
  aOut.headersGuard() = headers->Guard();
  aOut.mode() = aIn.Mode();
  aOut.credentials() = aIn.GetCredentialsMode();
  aOut.contentPolicyType() = aIn.ContentPolicyType();
  aOut.requestCache() = aIn.GetCacheMode();
  aOut.requestRedirect() = aIn.GetRedirectMode();

  aOut.integrity() = aIn.GetIntegrity();
  aOut.loadingEmbedderPolicy() = aIn.GetEmbedderPolicy();
  const mozilla::UniquePtr<mozilla::ipc::PrincipalInfo>& principalInfo =
      aIn.GetPrincipalInfo();
  if (principalInfo) {
    aOut.principalInfo() = Some(*(principalInfo.get()));
  }

  if (aBodyAction == IgnoreBody) {
    aOut.body() = Nothing();
    return;
  }

  // BodyUsed flag is checked and set previously in ToInternalRequest()

  nsCOMPtr<nsIInputStream> stream;
  aIn.GetBody(getter_AddRefs(stream));
  SerializeCacheStream(stream, &aOut.body(), aStreamCleanupList, aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }
}

void TypeUtils::ToCacheResponseWithoutBody(CacheResponse& aOut,
                                           InternalResponse& aIn,
                                           ErrorResult& aRv) {
  aOut.type() = aIn.Type();

  aIn.GetUnfilteredURLList(aOut.urlList());
  AutoTArray<nsCString, 4> urlList;
  aIn.GetURLList(urlList);

  for (uint32_t i = 0; i < aOut.urlList().Length(); i++) {
    MOZ_DIAGNOSTIC_ASSERT(!aOut.urlList()[i].IsEmpty());
    // Pass all Response URL schemes through... The spec only requires we take
    // action on invalid schemes for Request objects.
    ProcessURL(aOut.urlList()[i], nullptr, nullptr, nullptr, aRv);
  }

  aOut.status() = aIn.GetUnfilteredStatus();
  aOut.statusText() = aIn.GetUnfilteredStatusText();
  RefPtr<InternalHeaders> headers = aIn.UnfilteredHeaders();
  MOZ_DIAGNOSTIC_ASSERT(headers);
  if (HasVaryStar(headers)) {
    aRv.ThrowTypeError("Invalid Response object with a 'Vary: *' header.");
    return;
  }
  ToHeadersEntryList(aOut.headers(), headers);
  aOut.headersGuard() = headers->Guard();
  aOut.channelInfo() = aIn.GetChannelInfo().AsIPCChannelInfo();
  if (aIn.GetPrincipalInfo()) {
    aOut.principalInfo() = Some(*aIn.GetPrincipalInfo());
  } else {
    aOut.principalInfo() = Nothing();
  }

  aOut.paddingInfo() = aIn.GetPaddingInfo();
  aOut.paddingSize() = aIn.GetPaddingSize();
}

void TypeUtils::ToCacheResponse(
    JSContext* aCx, CacheResponse& aOut, Response& aIn,
    nsTArray<UniquePtr<AutoIPCStream>>& aStreamCleanupList, ErrorResult& aRv) {
  bool bodyUsed = aIn.GetBodyUsed(aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }
  if (bodyUsed) {
    aRv.ThrowTypeError<MSG_FETCH_BODY_CONSUMED_ERROR>();
    return;
  }

  RefPtr<InternalResponse> ir = aIn.GetInternalResponse();
  ToCacheResponseWithoutBody(aOut, *ir, aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }

  nsCOMPtr<nsIInputStream> stream;
  ir->GetUnfilteredBody(getter_AddRefs(stream));
  if (stream) {
    aIn.SetBodyUsed(aCx, aRv);
    if (NS_WARN_IF(aRv.Failed())) {
      return;
    }
  }

  SerializeCacheStream(stream, &aOut.body(), aStreamCleanupList, aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }
}

// static
void TypeUtils::ToCacheQueryParams(CacheQueryParams& aOut,
                                   const CacheQueryOptions& aIn) {
  aOut.ignoreSearch() = aIn.mIgnoreSearch;
  aOut.ignoreMethod() = aIn.mIgnoreMethod;
  aOut.ignoreVary() = aIn.mIgnoreVary;
  aOut.cacheNameSet() = aIn.mCacheName.WasPassed();
  if (aOut.cacheNameSet()) {
    aOut.cacheName() = aIn.mCacheName.Value();
  } else {
    aOut.cacheName() = NS_LITERAL_STRING("");
  }
}

already_AddRefed<Response> TypeUtils::ToResponse(const CacheResponse& aIn) {
  if (aIn.type() == ResponseType::Error) {
    // We don't bother tracking the internal error code for cached responses...
    RefPtr<InternalResponse> error =
        InternalResponse::NetworkError(NS_ERROR_FAILURE);
    RefPtr<Response> r = new Response(GetGlobalObject(), error, nullptr);
    return r.forget();
  }

  RefPtr<InternalResponse> ir =
      new InternalResponse(aIn.status(), aIn.statusText());
  ir->SetURLList(aIn.urlList());

  RefPtr<InternalHeaders> internalHeaders =
      ToInternalHeaders(aIn.headers(), aIn.headersGuard());
  ErrorResult result;

  // Be careful to fill the headers before setting the guard in order to
  // correctly re-create the original headers.
  ir->Headers()->Fill(*internalHeaders, result);
  MOZ_DIAGNOSTIC_ASSERT(!result.Failed());
  ir->Headers()->SetGuard(aIn.headersGuard(), result);
  MOZ_DIAGNOSTIC_ASSERT(!result.Failed());

  ir->InitChannelInfo(aIn.channelInfo());
  if (aIn.principalInfo().isSome()) {
    UniquePtr<mozilla::ipc::PrincipalInfo> info(
        new mozilla::ipc::PrincipalInfo(aIn.principalInfo().ref()));
    ir->SetPrincipalInfo(std::move(info));
  }

  nsCOMPtr<nsIInputStream> stream = ReadStream::Create(aIn.body());
  ir->SetBody(stream, InternalResponse::UNKNOWN_BODY_SIZE);

  switch (aIn.type()) {
    case ResponseType::Basic:
      ir = ir->BasicResponse();
      break;
    case ResponseType::Cors:
      ir = ir->CORSResponse();
      break;
    case ResponseType::Default:
      break;
    case ResponseType::Opaque:
      ir = ir->OpaqueResponse();
      break;
    case ResponseType::Opaqueredirect:
      ir = ir->OpaqueRedirectResponse();
      break;
    default:
      MOZ_CRASH("Unexpected ResponseType!");
  }
  MOZ_DIAGNOSTIC_ASSERT(ir);

  ir->SetPaddingSize(aIn.paddingSize());

  RefPtr<Response> ref = new Response(GetGlobalObject(), ir, nullptr);
  return ref.forget();
}
SafeRefPtr<InternalRequest> TypeUtils::ToInternalRequest(
    const CacheRequest& aIn) {
  nsAutoCString url(aIn.urlWithoutQuery());
  url.Append(aIn.urlQuery());
  auto internalRequest =
      MakeSafeRefPtr<InternalRequest>(url, aIn.urlFragment());
  internalRequest->SetMethod(aIn.method());
  internalRequest->SetReferrer(aIn.referrer());
  internalRequest->SetReferrerPolicy(aIn.referrerPolicy());
  internalRequest->SetMode(aIn.mode());
  internalRequest->SetCredentialsMode(aIn.credentials());
  internalRequest->SetContentPolicyType(aIn.contentPolicyType());
  internalRequest->SetCacheMode(aIn.requestCache());
  internalRequest->SetRedirectMode(aIn.requestRedirect());
  internalRequest->SetIntegrity(aIn.integrity());

  RefPtr<InternalHeaders> internalHeaders =
      ToInternalHeaders(aIn.headers(), aIn.headersGuard());
  ErrorResult result;

  // Be careful to fill the headers before setting the guard in order to
  // correctly re-create the original headers.
  internalRequest->Headers()->Fill(*internalHeaders, result);
  MOZ_DIAGNOSTIC_ASSERT(!result.Failed());

  internalRequest->Headers()->SetGuard(aIn.headersGuard(), result);
  MOZ_DIAGNOSTIC_ASSERT(!result.Failed());

  nsCOMPtr<nsIInputStream> stream = ReadStream::Create(aIn.body());

  internalRequest->SetBody(stream, -1);

  return internalRequest;
}

SafeRefPtr<Request> TypeUtils::ToRequest(const CacheRequest& aIn) {
  return MakeSafeRefPtr<Request>(GetGlobalObject(), ToInternalRequest(aIn),
                                 nullptr);
}

// static
already_AddRefed<InternalHeaders> TypeUtils::ToInternalHeaders(
    const nsTArray<HeadersEntry>& aHeadersEntryList, HeadersGuardEnum aGuard) {
  nsTArray<InternalHeaders::Entry> entryList(aHeadersEntryList.Length());

  for (uint32_t i = 0; i < aHeadersEntryList.Length(); ++i) {
    const HeadersEntry& headersEntry = aHeadersEntryList[i];
    entryList.AppendElement(
        InternalHeaders::Entry(headersEntry.name(), headersEntry.value()));
  }

  RefPtr<InternalHeaders> ref =
      new InternalHeaders(std::move(entryList), aGuard);
  return ref.forget();
}

// Utility function to remove the fragment from a URL, check its scheme, and
// optionally provide a URL without the query.  We're not using nsIURL or URL to
// do this because they require going to the main thread. static
void TypeUtils::ProcessURL(nsACString& aUrl, bool* aSchemeValidOut,
                           nsACString* aUrlWithoutQueryOut,
                           nsACString* aUrlQueryOut, ErrorResult& aRv) {
  const nsCString& flatURL = PromiseFlatCString(aUrl);
  const char* url = flatURL.get();

  // off the main thread URL parsing using nsStdURLParser.
  nsCOMPtr<nsIURLParser> urlParser = new nsStdURLParser();

  uint32_t pathPos;
  int32_t pathLen;
  uint32_t schemePos;
  int32_t schemeLen;
  aRv = urlParser->ParseURL(url, flatURL.Length(), &schemePos, &schemeLen,
                            nullptr, nullptr,  // ignore authority
                            &pathPos, &pathLen);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }

  if (aSchemeValidOut) {
    nsAutoCString scheme(Substring(flatURL, schemePos, schemeLen));
    *aSchemeValidOut = scheme.LowerCaseEqualsLiteral("http") ||
                       scheme.LowerCaseEqualsLiteral("https");
  }

  uint32_t queryPos;
  int32_t queryLen;

  aRv = urlParser->ParsePath(url + pathPos, flatURL.Length() - pathPos, nullptr,
                             nullptr,  // ignore filepath
                             &queryPos, &queryLen, nullptr, nullptr);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }

  if (!aUrlWithoutQueryOut) {
    return;
  }

  MOZ_DIAGNOSTIC_ASSERT(aUrlQueryOut);

  if (queryLen < 0) {
    *aUrlWithoutQueryOut = aUrl;
    *aUrlQueryOut = EmptyCString();
    return;
  }

  // ParsePath gives us query position relative to the start of the path
  queryPos += pathPos;

  *aUrlWithoutQueryOut = Substring(aUrl, 0, queryPos - 1);
  *aUrlQueryOut = Substring(aUrl, queryPos - 1, queryLen + 1);
}

void TypeUtils::CheckAndSetBodyUsed(JSContext* aCx, Request& aRequest,
                                    BodyAction aBodyAction, ErrorResult& aRv) {
  if (aBodyAction == IgnoreBody) {
    return;
  }

  bool bodyUsed = aRequest.GetBodyUsed(aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }
  if (bodyUsed) {
    aRv.ThrowTypeError<MSG_FETCH_BODY_CONSUMED_ERROR>();
    return;
  }

  nsCOMPtr<nsIInputStream> stream;
  aRequest.GetBody(getter_AddRefs(stream));
  if (stream) {
    aRequest.SetBodyUsed(aCx, aRv);
    if (NS_WARN_IF(aRv.Failed())) {
      return;
    }
  }
}

SafeRefPtr<InternalRequest> TypeUtils::ToInternalRequest(const nsAString& aIn,
                                                         ErrorResult& aRv) {
  RequestOrUSVString requestOrString;
  requestOrString.SetAsUSVString().ShareOrDependUpon(aIn);

  // Re-create a GlobalObject stack object so we can use webidl Constructors.
  AutoJSAPI jsapi;
  if (NS_WARN_IF(!jsapi.Init(GetGlobalObject()))) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
    return nullptr;
  }
  JSContext* cx = jsapi.cx();
  GlobalObject global(cx, GetGlobalObject()->GetGlobalJSObject());
  MOZ_DIAGNOSTIC_ASSERT(!global.Failed());

  SafeRefPtr<Request> request =
      Request::Constructor(global, requestOrString, RequestInit(), aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return nullptr;
  }

  return request->GetInternalRequest();
}

void TypeUtils::SerializeCacheStream(
    nsIInputStream* aStream, Maybe<CacheReadStream>* aStreamOut,
    nsTArray<UniquePtr<AutoIPCStream>>& aStreamCleanupList, ErrorResult& aRv) {
  *aStreamOut = Nothing();
  if (!aStream) {
    return;
  }

  RefPtr<ReadStream> controlled = do_QueryObject(aStream);
  if (controlled) {
    controlled->Serialize(aStreamOut, aStreamCleanupList, aRv);
    return;
  }

  aStreamOut->emplace(CacheReadStream());
  CacheReadStream& cacheStream = aStreamOut->ref();

  cacheStream.controlChild() = nullptr;
  cacheStream.controlParent() = nullptr;

  UniquePtr<AutoIPCStream> autoStream(new AutoIPCStream(cacheStream.stream()));
  autoStream->Serialize(aStream, GetIPCManager());

  aStreamCleanupList.AppendElement(std::move(autoStream));
}

}  // namespace cache
}  // namespace dom
}  // namespace mozilla
