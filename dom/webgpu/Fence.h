/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GPU_Fence_H_
#define GPU_Fence_H_

#include "nsWrapperCache.h"
#include "ObjectModel.h"

namespace mozilla {
namespace dom {
class Promise;
}  // namespace dom
namespace webgpu {

class Device;

class Fence final : public ObjectBase, public ChildOf<Device> {
 public:
  GPU_DECL_CYCLE_COLLECTION(Fence)
  GPU_DECL_JS_WRAP(Fence)

 private:
  Fence() = delete;
  ~Fence() = default;
  void Cleanup() {}

 public:
};

}  // namespace webgpu
}  // namespace mozilla

#endif  // GPU_Fence_H_
