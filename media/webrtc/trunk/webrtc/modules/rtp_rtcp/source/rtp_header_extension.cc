/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/rtp_rtcp/source/rtp_header_extension.h"

#include "webrtc/base/arraysize.h"
#include "webrtc/base/checks.h"
#include "webrtc/base/logging.h"
#include "webrtc/modules/rtp_rtcp/source/rtp_header_extensions.h"
#include "webrtc/modules/rtp_rtcp/source/rtp_utility.h"

namespace webrtc {
namespace {

using RtpUtility::Word32Align;

struct ExtensionInfo {
  RTPExtensionType type;
  const char* uri;
};

template <typename Extension>
constexpr ExtensionInfo CreateExtensionInfo() {
  return {Extension::kId, Extension::kUri};
}

constexpr ExtensionInfo kExtensions[] = {
    CreateExtensionInfo<TransmissionOffset>(),
    CreateExtensionInfo<AudioLevel>(),
    CreateExtensionInfo<AbsoluteSendTime>(),
    CreateExtensionInfo<VideoOrientation>(),
    CreateExtensionInfo<TransportSequenceNumber>(),
    CreateExtensionInfo<PlayoutDelayLimits>(),
    CreateExtensionInfo<RtpStreamId>(),
    CreateExtensionInfo<RepairedRtpStreamId>(),
};

// Because of kRtpExtensionNone, NumberOfExtension is 1 bigger than the actual
// number of known extensions.
static_assert(arraysize(kExtensions) ==
                  static_cast<int>(kRtpExtensionNumberOfExtensions) - 1,
              "kExtensions expect to list all known extensions");

}  // namespace

constexpr RTPExtensionType RtpHeaderExtensionMap::kInvalidType;
constexpr uint8_t RtpHeaderExtensionMap::kInvalidId;
constexpr uint8_t RtpHeaderExtensionMap::kMinId;
constexpr uint8_t RtpHeaderExtensionMap::kMaxId;

RtpHeaderExtensionMap::RtpHeaderExtensionMap() {
  for (auto& type : types_)
    type = kInvalidType;
  for (auto& id : ids_)
    id = kInvalidId;
}

RtpHeaderExtensionMap::RtpHeaderExtensionMap(
    rtc::ArrayView<const RtpExtension> extensions)
    : RtpHeaderExtensionMap() {
  for (const RtpExtension& extension : extensions)
    RegisterByUri(extension.id, extension.uri);
}

bool RtpHeaderExtensionMap::RegisterByType(uint8_t id, RTPExtensionType type) {
  for (const ExtensionInfo& extension : kExtensions)
    if (type == extension.type)
      return Register(id, extension.type, extension.uri);
  RTC_NOTREACHED();
  return false;
}

bool RtpHeaderExtensionMap::RegisterByUri(uint8_t id, const std::string& uri) {
  for (const ExtensionInfo& extension : kExtensions)
    if (uri == extension.uri)
      return Register(id, extension.type, extension.uri);
  LOG(LS_WARNING) << "Unknown extension uri:'" << uri
                  << "', id: " << static_cast<int>(id) << '.';
  return false;
}

size_t RtpHeaderExtensionMap::GetTotalLengthInBytes(
    rtc::ArrayView<const RtpExtensionSize> extensions) const {
  // Header size of each individual extension, see RFC5285 Section 4.2
  static constexpr size_t kExtensionHeaderLength = 1;
  size_t values_size = 0;
  for (const RtpExtensionSize& extension : extensions) {
    if (IsRegistered(extension.type))
      values_size += extension.value_size + kExtensionHeaderLength;
  }
  if (values_size == 0)
    return 0;
  return Word32Align(kRtpOneByteHeaderLength + values_size);
}

int32_t RtpHeaderExtensionMap::Deregister(RTPExtensionType type) {
  if (IsRegistered(type)) {
    uint8_t id = GetId(type);
    types_[id] = kInvalidType;
    ids_[type] = kInvalidId;
  }
  return 0;
}

bool RtpHeaderExtensionMap::Register(uint8_t id,
                                     RTPExtensionType type,
                                     const char* uri) {
  RTC_DCHECK_GT(type, kRtpExtensionNone);
  RTC_DCHECK_LT(type, kRtpExtensionNumberOfExtensions);

  if (id < kMinId || id > kMaxId) {
    LOG(LS_WARNING) << "Failed to register extension uri:'" << uri
                    << "' with invalid id:" << static_cast<int>(id) << ".";
    return false;
  }

  if (GetType(id) == type) {  // Same type/id pair already registered.
    LOG(LS_VERBOSE) << "Reregistering extension uri:'" << uri
                    << "', id:" << static_cast<int>(id);
    return true;
  }

  if (GetType(id) != kInvalidType) {  // |id| used by another extension type.
    LOG(LS_WARNING) << "Failed to register extension uri:'" << uri
                    << "', id:" << static_cast<int>(id)
                    << ". Id already in use by extension type "
                    << static_cast<int>(GetType(id));
    return false;
  }
  RTC_DCHECK(!IsRegistered(type));

  types_[id] = type;
  ids_[type] = id;
  return true;
}

}  // namespace webrtc
