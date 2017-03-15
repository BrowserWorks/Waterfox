/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef WebrtcTelemetry_h__
#define WebrtcTelemetry_h__

#include "nsBaseHashtable.h"
#include "nsHashKeys.h"
#include "TelemetryCommon.h"

class WebrtcTelemetry {
public:
  struct WebrtcIceCandidateStats {
    uint32_t successCount;
    uint32_t failureCount;
    WebrtcIceCandidateStats() :
      successCount(0),
      failureCount(0)
    {
    }
  };
  struct WebrtcIceStatsCategory {
    struct WebrtcIceCandidateStats webrtc;
  };
  typedef nsBaseHashtableET<nsUint32HashKey, WebrtcIceStatsCategory> WebrtcIceCandidateType;

  void RecordIceCandidateMask(const uint32_t iceCandidateBitmask, bool success);

  bool GetWebrtcStats(JSContext *cx, JS::MutableHandle<JS::Value> ret);

  size_t SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf) const;

private:

  bool AddIceInfo(JSContext *cx, JS::Handle<JSObject*> rootObj);

  mozilla::Telemetry::Common::AutoHashtable<WebrtcIceCandidateType> mWebrtcIceCandidates;
};

#endif // WebrtcTelemetry_h__
