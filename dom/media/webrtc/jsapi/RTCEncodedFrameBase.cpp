/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

#include "jsapi/RTCEncodedFrameBase.h"

#include <cstddef>
#include <span>

#include "api/frame_transformer_interface.h"
#include "js/ArrayBuffer.h"
#include "js/GCAPI.h"
#include "mozilla/HoldDropJSObjects.h"
#include "mozilla/dom/RTCRtpScriptTransformer.h"
#include "mozilla/dom/ScriptSettings.h"
#include "nsIGlobalObject.h"

namespace mozilla::dom {

NS_IMPL_CYCLE_COLLECTION_CLASS(RTCEncodedFrameBase)
NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(RTCEncodedFrameBase)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mOwner, mGlobal)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mData)
  NS_IMPL_CYCLE_COLLECTION_UNLINK_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_UNLINK_END
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(RTCEncodedFrameBase)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mOwner, mGlobal)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END
NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN(RTCEncodedFrameBase)
  NS_IMPL_CYCLE_COLLECTION_TRACE_JS_MEMBERS(mData)
  NS_IMPL_CYCLE_COLLECTION_TRACE_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(RTCEncodedFrameBase)
NS_IMPL_CYCLE_COLLECTING_RELEASE(RTCEncodedFrameBase)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(RTCEncodedFrameBase)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

RTCEncodedFrameBase::RTCEncodedFrameBase(nsIGlobalObject* aGlobal,
                                         RTCEncodedFrameState& aState,
                                         RTCRtpScriptTransformer* aOwner)
    : mGlobal(aGlobal), mOwner(aOwner), mState(aState), mData(nullptr) {
  mState.mTimestamp = mState.mFrame->GetTimestamp();
  AutoJSAPI jsapi;
  if (NS_WARN_IF(!jsapi.Init(mGlobal))) {
    return;
  }

  mozilla::HoldJSObjects(this);

  const auto& frame = mState.mFrame->GetData();
  if (frame.data()) {
    UniquePtr<void, JS::FreePolicy> data(js_pod_arena_malloc<uint8_t>(
        js::ArrayBufferContentsArena, frame.size()));
    memcpy(data.get(), frame.data(), frame.size());
    mData = JS::NewArrayBufferWithContents(jsapi.cx(), frame.size(),
                                           std::move(data));
  } else {
    mData = JS::NewArrayBuffer(jsapi.cx(), 0);
  }
}

RTCEncodedFrameState::RTCEncodedFrameState(
    std::unique_ptr<webrtc::TransformableFrameInterface> aFrame,
    uint64_t aCounter, unsigned long aTimestamp)
    : mFrame(std::move(aFrame)), mCounter(aCounter), mTimestamp(aTimestamp) {}

RTCEncodedFrameBase::~RTCEncodedFrameBase() { mozilla::DropJSObjects(this); }

void RTCEncodedFrameBase::DetachData() {
  // We might have handled this in unlink already
  if (mGlobal && mData) {
    AutoJSAPI jsapi;
    if (NS_WARN_IF(!jsapi.Init(mGlobal))) {
      return;
    }

    JS::Rooted<JSObject*> rootedData(jsapi.cx(), mData);
    if (rootedData) {
      JS::DetachArrayBuffer(jsapi.cx(), rootedData);
    }
  }
}

nsIGlobalObject* RTCEncodedFrameBase::GetParentObject() const {
  return mGlobal;
}

unsigned long RTCEncodedFrameBase::Timestamp() const {
  return mState.mTimestamp;
}

void RTCEncodedFrameBase::SetData(const ArrayBuffer& aData) {
  mData.set(aData.Obj());
  if (mState.mFrame) {
    aData.ProcessData([&](const Span<uint8_t>& aData, JS::AutoCheckCannotGC&&) {
      mState.mFrame->SetData(
          std::span<const uint8_t>(aData.Elements(), aData.Length()));
    });
  }
}

void RTCEncodedFrameBase::GetData(JSContext* aCx,
                                  JS::Rooted<JSObject*>* aObj) const {
  aObj->set(mData);
}

uint64_t RTCEncodedFrameBase::GetCounter() const { return mState.mCounter; }

std::unique_ptr<webrtc::TransformableFrameInterface>
RTCEncodedFrameBase::TakeFrame() {
  DetachData();
  return std::move(mState.mFrame);
}

size_t RTCEncodedFrameBase::Size() const {
  return GetArrayBufferByteLength(mData);
}

RTCEncodedFrameState::~RTCEncodedFrameState() = default;

}  // namespace mozilla::dom
