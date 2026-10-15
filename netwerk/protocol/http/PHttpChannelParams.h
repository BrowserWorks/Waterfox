/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_PHttpChannelParams_h
#define mozilla_net_PHttpChannelParams_h

#define ALLOW_LATE_NSHTTP_H_INCLUDE 1
#include <algorithm>

#include "base/basictypes.h"

#include "ipc/EnumSerializer.h"
#include "ipc/IPCMessageUtils.h"
#include "ipc/IPCMessageUtilsSpecializations.h"
#include "nsHttp.h"
#include "nsHttpHeaderArray.h"
#include "nsHttpRequestHead.h"
#include "nsHttpResponseHead.h"

namespace mozilla {
namespace net {

struct RequestHeaderTuple {
  nsCString mHeader;
  nsCString mValue;
  bool mMerge;
  bool mEmpty;

  bool operator==(const RequestHeaderTuple& other) const {
    return mHeader.Equals(other.mHeader) && mValue.Equals(other.mValue) &&
           mMerge == other.mMerge && mEmpty == other.mEmpty;
  }
};

typedef CopyableTArray<RequestHeaderTuple> RequestHeaderTuples;

struct HttpVersionValidator {
  using IntegralType = std::underlying_type_t<HttpVersion>;

  static bool IsLegalValue(const IntegralType e) {
    return e == static_cast<IntegralType>(HttpVersion::UNKNOWN) ||
           e == static_cast<IntegralType>(HttpVersion::v0_9) ||
           e == static_cast<IntegralType>(HttpVersion::v1_0) ||
           e == static_cast<IntegralType>(HttpVersion::v1_1) ||
           e == static_cast<IntegralType>(HttpVersion::v2_0) ||
           e == static_cast<IntegralType>(HttpVersion::v3_0);
  }
};

}  // namespace net
}  // namespace mozilla

namespace IPC {

template <>
struct ParamTraits<mozilla::net::RequestHeaderTuple> {
  typedef mozilla::net::RequestHeaderTuple paramType;

  static void Write(MessageWriter* aWriter, const paramType& aParam) {
    WriteParam(aWriter, aParam.mHeader);
    WriteParam(aWriter, aParam.mValue);
    WriteParam(aWriter, aParam.mMerge);
    WriteParam(aWriter, aParam.mEmpty);
  }

  static bool Read(MessageReader* aReader, paramType* aResult) {
    if (!ReadParam(aReader, &aResult->mHeader) ||
        !ReadParam(aReader, &aResult->mValue) ||
        !ReadParam(aReader, &aResult->mMerge) ||
        !ReadParam(aReader, &aResult->mEmpty))
      return false;

    return true;
  }
};

template <>
struct ParamTraits<mozilla::net::HttpVersion>
    : public EnumSerializer<mozilla::net::HttpVersion,
                            mozilla::net::HttpVersionValidator> {};

template <>
struct ParamTraits<mozilla::net::nsHttpRequestHead::ParsedMethodType>
    : public ContiguousEnumSerializerInclusive<
          mozilla::net::nsHttpRequestHead::ParsedMethodType,
          mozilla::net::nsHttpRequestHead::kMethod_Custom,
          mozilla::net::nsHttpRequestHead::kMethod_Trace> {};

template <>
struct ParamTraits<mozilla::net::nsHttpAtom> {
  typedef mozilla::net::nsHttpAtom paramType;

  static void Write(MessageWriter* aWriter, const paramType& aParam) {
    // aParam.get() cannot be null.
    MOZ_ASSERT(aParam.get(), "null nsHTTPAtom value");
    nsAutoCString value(aParam.get());
    WriteParam(aWriter, value);
  }

  static bool Read(MessageReader* aReader, paramType* aResult) {
    nsAutoCString value;
    if (!ReadParam(aReader, &value)) return false;

    *aResult = mozilla::net::nsHttp::ResolveAtom(value);
    MOZ_ASSERT(aResult->get(), "atom table not initialized");
    return true;
  }
};

template <>
struct ParamTraits<mozilla::net::nsHttpHeaderArray::nsEntry> {
  typedef mozilla::net::nsHttpHeaderArray::nsEntry paramType;

  static void Write(MessageWriter* aWriter, const paramType& aParam) {
    if (aParam.headerNameOriginal.IsEmpty()) {
      WriteParam(aWriter, aParam.header);
    } else {
      WriteParam(aWriter, aParam.headerNameOriginal);
    }
    WriteParam(aWriter, aParam.value);
    switch (aParam.variety) {
      case mozilla::net::nsHttpHeaderArray::eVarietyUnknown:
        WriteParam(aWriter, (uint8_t)0);
        break;
      case mozilla::net::nsHttpHeaderArray::eVarietyRequestOverride:
        WriteParam(aWriter, (uint8_t)1);
        break;
      case mozilla::net::nsHttpHeaderArray::eVarietyRequestDefault:
        WriteParam(aWriter, (uint8_t)2);
        break;
      case mozilla::net::nsHttpHeaderArray::eVarietyRequestEnforceDefault:
        WriteParam(aWriter, (uint8_t)3);
        break;
      case mozilla::net::nsHttpHeaderArray::
          eVarietyResponseNetOriginalAndResponse:
        WriteParam(aWriter, (uint8_t)4);
        break;
      case mozilla::net::nsHttpHeaderArray::eVarietyResponseNetOriginal:
        WriteParam(aWriter, (uint8_t)5);
        break;
      case mozilla::net::nsHttpHeaderArray::eVarietyResponse:
        WriteParam(aWriter, (uint8_t)6);
        break;
      case mozilla::net::nsHttpHeaderArray::eVarietyResponseOverride:
        WriteParam(aWriter, (uint8_t)7);
        break;
    }
  }

  static bool Read(MessageReader* aReader, paramType* aResult) {
    uint8_t variety;
    nsAutoCString header;
    if (!ReadParam(aReader, &header) || !ReadParam(aReader, &aResult->value) ||
        !ReadParam(aReader, &variety))
      return false;

    mozilla::net::nsHttpAtom atom = mozilla::net::nsHttp::ResolveAtom(header);
    aResult->header = atom;
    if (!header.Equals(atom.get())) {
      aResult->headerNameOriginal = header;
    }

    switch (variety) {
      case 0:
        aResult->variety = mozilla::net::nsHttpHeaderArray::eVarietyUnknown;
        break;
      case 1:
        aResult->variety =
            mozilla::net::nsHttpHeaderArray::eVarietyRequestOverride;
        break;
      case 2:
        aResult->variety =
            mozilla::net::nsHttpHeaderArray::eVarietyRequestDefault;
        break;
      case 3:
        aResult->variety =
            mozilla::net::nsHttpHeaderArray::eVarietyRequestEnforceDefault;
        break;
      case 4:
        aResult->variety = mozilla::net::nsHttpHeaderArray::
            eVarietyResponseNetOriginalAndResponse;
        break;
      case 5:
        aResult->variety =
            mozilla::net::nsHttpHeaderArray::eVarietyResponseNetOriginal;
        break;
      case 6:
        aResult->variety = mozilla::net::nsHttpHeaderArray::eVarietyResponse;
        break;
      case 7:
        aResult->variety =
            mozilla::net::nsHttpHeaderArray::eVarietyResponseOverride;
        break;
      default:
        return false;
    }

    return true;
  }
};

template <>
struct ParamTraits<mozilla::net::nsHttpHeaderArray> {
  typedef mozilla::net::nsHttpHeaderArray paramType;

  static bool IsSetCookie(const paramType::nsEntry& aEntry) {
    return aEntry.header == mozilla::net::nsHttp::Set_Cookie;
  }

  // Writes in the same format as ParamTraits<nsTArray>, skipping Set-Cookie
  // entries so they never reach another process.
  static void Write(MessageWriter* aWriter, const paramType& aParam) {
    const auto& headers = aParam.mHeaders;
    auto stripped = std::count_if(headers.begin(), headers.end(), IsSetCookie);
    aWriter->WriteUInt32(headers.Length() - stripped);
    for (const auto& entry : headers) {
      if (!IsSetCookie(entry)) {
        WriteParam(aWriter, entry);
      }
    }
  }

  static bool Read(MessageReader* aReader, paramType* aResult) {
    if (!ReadParam(aReader, &aResult->mHeaders)) return false;

    return true;
  }
};

template <>
struct ParamTraits<mozilla::net::nsHttpRequestHead> {
  typedef mozilla::net::nsHttpRequestHead paramType;

  static void Write(MessageWriter* aWriter,
                    const paramType& aParam) MOZ_NO_THREAD_SAFETY_ANALYSIS {
    aParam.Enter();
    WriteParam(aWriter, aParam.mHeaders);
    WriteParam(aWriter, aParam.mMethod);
    WriteParam(aWriter, aParam.mVersion);
    WriteParam(aWriter, aParam.mRequestURI);
    WriteParam(aWriter, aParam.mPath);
    WriteParam(aWriter, aParam.mOrigin);
    WriteParam(aWriter, aParam.mParsedMethod);
    WriteParam(aWriter, aParam.mHTTPS);
    aParam.Exit();
  }

  static bool Read(MessageReader* aReader, paramType* aResult) {
    aResult->Enter();
    if (!ReadParam(aReader, &aResult->mHeaders) ||
        !ReadParam(aReader, &aResult->mMethod) ||
        !ReadParam(aReader, &aResult->mVersion) ||
        !ReadParam(aReader, &aResult->mRequestURI) ||
        !ReadParam(aReader, &aResult->mPath) ||
        !ReadParam(aReader, &aResult->mOrigin) ||
        !ReadParam(aReader, &aResult->mParsedMethod) ||
        !ReadParam(aReader, &aResult->mHTTPS)) {
      aResult->Exit();
      return false;
    }

    aResult->Exit();
    return true;
  }
};

// Note that the code below MUST be synchronized with the code in
// nsHttpRequestHead's copy constructor.
template <>
struct ParamTraits<mozilla::net::nsHttpResponseHead> {
  typedef mozilla::net::nsHttpResponseHead paramType;

  static void Write(MessageWriter* aWriter,
                    const paramType& aParam) MOZ_NO_THREAD_SAFETY_ANALYSIS {
    aParam.Enter();
    WriteParam(aWriter, aParam.mHeaders);
    WriteParam(aWriter, aParam.mVersion);
    WriteParam(aWriter, aParam.mStatus);
    WriteParam(aWriter, aParam.mStatusText);
    WriteParam(aWriter, aParam.mContentLength);
    WriteParam(aWriter, aParam.mContentType);
    WriteParam(aWriter, aParam.mContentCharset);
    WriteParam(aWriter, aParam.mHasCacheControl);
    WriteParam(aWriter, aParam.mCacheControlPublic);
    WriteParam(aWriter, aParam.mCacheControlPrivate);
    WriteParam(aWriter, aParam.mCacheControlNoStore);
    WriteParam(aWriter, aParam.mCacheControlNoCache);
    WriteParam(aWriter, aParam.mCacheControlImmutable);
    WriteParam(aWriter, aParam.mCacheControlStaleWhileRevalidateSet);
    WriteParam(aWriter, aParam.mCacheControlStaleWhileRevalidate);
    WriteParam(aWriter, aParam.mCacheControlMaxAgeSet);
    WriteParam(aWriter, aParam.mCacheControlMaxAge);
    WriteParam(aWriter, aParam.mPragmaNoCache);
    aParam.Exit();
  }

  static bool Read(MessageReader* aReader, paramType* aResult) {
    aResult->Enter();
    if (!ReadParam(aReader, &aResult->mHeaders) ||
        !ReadParam(aReader, &aResult->mVersion) ||
        !ReadParam(aReader, &aResult->mStatus) ||
        !ReadParam(aReader, &aResult->mStatusText) ||
        !ReadParam(aReader, &aResult->mContentLength) ||
        !ReadParam(aReader, &aResult->mContentType) ||
        !ReadParam(aReader, &aResult->mContentCharset) ||
        !ReadParam(aReader, &aResult->mHasCacheControl) ||
        !ReadParam(aReader, &aResult->mCacheControlPublic) ||
        !ReadParam(aReader, &aResult->mCacheControlPrivate) ||
        !ReadParam(aReader, &aResult->mCacheControlNoStore) ||
        !ReadParam(aReader, &aResult->mCacheControlNoCache) ||
        !ReadParam(aReader, &aResult->mCacheControlImmutable) ||
        !ReadParam(aReader, &aResult->mCacheControlStaleWhileRevalidateSet) ||
        !ReadParam(aReader, &aResult->mCacheControlStaleWhileRevalidate) ||
        !ReadParam(aReader, &aResult->mCacheControlMaxAgeSet) ||
        !ReadParam(aReader, &aResult->mCacheControlMaxAge) ||
        !ReadParam(aReader, &aResult->mPragmaNoCache)) {
      aResult->Exit();
      return false;
    }

    aResult->Exit();
    return true;
  }
};

}  // namespace IPC

#endif  // mozilla_net_PHttpChannelParams_h
