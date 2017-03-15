/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=4 ts=8 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_MetricsSharingController_h
#define mozilla_layers_MetricsSharingController_h

#include "FrameMetrics.h" // for FrameMetrics
#include "mozilla/ipc/CrossProcessMutex.h" // for CrossProcessMutexHandle
#include "mozilla/ipc/SharedMemoryBasic.h" // for SharedMemoryBasic
#include "mozilla/RefCountType.h" // for MozExternalRefCountType
#include "nscore.h" // for NS_IMETHOD_

namespace mozilla {
namespace layers {

class MetricsSharingController
{
public:
  NS_IMETHOD_(MozExternalRefCountType) AddRef() = 0;
  NS_IMETHOD_(MozExternalRefCountType) Release() = 0;

  virtual base::ProcessId RemotePid() = 0;
  virtual bool StartSharingMetrics(mozilla::ipc::SharedMemoryBasic::Handle aHandle,
                                   CrossProcessMutexHandle aMutexHandle,
                                   uint64_t aLayersId,
                                   uint32_t aApzcId) = 0;
  virtual bool StopSharingMetrics(FrameMetrics::ViewID aScrollId,
                                  uint32_t aApzcId) = 0;

protected:
  virtual ~MetricsSharingController() {}
};

} // namespace layers
} // namespace mozilla

#endif // mozilla_layers_MetricsSharingController_h
