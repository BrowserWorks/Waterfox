/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 et tw=78: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_ImageData_h
#define mozilla_dom_ImageData_h

#include "nsIDOMCanvasRenderingContext2D.h"

#include "mozilla/Attributes.h"
#include "mozilla/dom/BindingUtils.h"
#include "mozilla/dom/TypedArray.h"
#include <stdint.h>

#include "nsCycleCollectionParticipant.h"
#include "nsISupportsImpl.h"
#include "js/GCAPI.h"

namespace mozilla {
namespace dom {

class ImageData final : public nsISupports
{
  ~ImageData()
  {
    MOZ_COUNT_DTOR(ImageData);
    DropData();
  }

public:
  ImageData(uint32_t aWidth, uint32_t aHeight, JSObject& aData)
    : mWidth(aWidth)
    , mHeight(aHeight)
    , mData(&aData)
  {
    MOZ_COUNT_CTOR(ImageData);
    HoldData();
  }

  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(ImageData)

  static already_AddRefed<ImageData>
    Constructor(const GlobalObject& aGlobal,
                const uint32_t aWidth,
                const uint32_t aHeight,
                ErrorResult& aRv);

  static already_AddRefed<ImageData>
    Constructor(const GlobalObject& aGlobal,
                const Uint8ClampedArray& aData,
                const uint32_t aWidth,
                const Optional<uint32_t>& aHeight,
                ErrorResult& aRv);

  uint32_t Width() const
  {
    return mWidth;
  }
  uint32_t Height() const
  {
    return mHeight;
  }
  void GetData(JSContext* cx, JS::MutableHandle<JSObject*> aData) const
  {
    aData.set(GetDataObject());
  }
  JSObject* GetDataObject() const
  {
    return mData;
  }

  bool WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto, JS::MutableHandle<JSObject*> aReflector);

private:
  void HoldData();
  void DropData();

  ImageData() = delete;

  uint32_t mWidth, mHeight;
  JS::Heap<JSObject*> mData;
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_ImageData_h
