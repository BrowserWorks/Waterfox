/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "DOMSVGPoint.h"

#include "DOMSVGPointList.h"
#include "gfx2DGlue.h"
#include "mozAutoDocUpdate.h"
#include "nsCOMPtr.h"
#include "nsError.h"
#include "SVGPoint.h"
#include "mozilla/dom/SVGElement.h"
#include "mozilla/dom/SVGMatrix.h"

// See the architecture comment in DOMSVGPointList.h.

using namespace mozilla::gfx;

namespace mozilla {
namespace dom {

//----------------------------------------------------------------------
// Helper class: AutoChangePointNotifier
// Stack-based helper class to pair calls to WillChangePointList and
// DidChangePointList.
class MOZ_RAII AutoChangePointNotifier : public mozAutoDocUpdate {
 public:
  explicit AutoChangePointNotifier(
      DOMSVGPoint* aPoint MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : mozAutoDocUpdate(aPoint->Element()->GetComposedDoc(), true),
        mPoint(aPoint) {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    MOZ_ASSERT(mPoint, "Expecting non-null point");
    MOZ_ASSERT(mPoint->HasOwner(),
               "Expecting list to have an owner for notification");
    mEmptyOrOldValue = mPoint->Element()->WillChangePointList(*this);
  }

  ~AutoChangePointNotifier() {
    mPoint->Element()->DidChangePointList(mEmptyOrOldValue, *this);
    // Null check mPoint->mList, since DidChangePointList can run script,
    // potentially removing mPoint from its list.
    if (mPoint->mList && mPoint->mList->AttrIsAnimating()) {
      mPoint->Element()->AnimationNeedsResample();
    }
  }

 private:
  DOMSVGPoint* const mPoint;
  nsAttrValue mEmptyOrOldValue;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

float DOMSVGPoint::X() {
  if (mIsAnimValItem && HasOwner()) {
    Element()->FlushAnimations();  // May make HasOwner() == false
  }
  return HasOwner() ? InternalItem().mX : mPt.mX;
}

void DOMSVGPoint::SetX(float aX, ErrorResult& rv) {
  if (mIsAnimValItem || mIsReadonly) {
    rv.Throw(NS_ERROR_DOM_NO_MODIFICATION_ALLOWED_ERR);
    return;
  }

  if (HasOwner()) {
    if (InternalItem().mX == aX) {
      return;
    }
    AutoChangePointNotifier notifier(this);
    InternalItem().mX = aX;
    return;
  }
  mPt.mX = aX;
}

float DOMSVGPoint::Y() {
  if (mIsAnimValItem && HasOwner()) {
    Element()->FlushAnimations();  // May make HasOwner() == false
  }
  return HasOwner() ? InternalItem().mY : mPt.mY;
}

void DOMSVGPoint::SetY(float aY, ErrorResult& rv) {
  if (mIsAnimValItem || mIsReadonly) {
    rv.Throw(NS_ERROR_DOM_NO_MODIFICATION_ALLOWED_ERR);
    return;
  }

  if (HasOwner()) {
    if (InternalItem().mY == aY) {
      return;
    }
    AutoChangePointNotifier notifier(this);
    InternalItem().mY = aY;
    return;
  }
  mPt.mY = aY;
}

already_AddRefed<nsISVGPoint> DOMSVGPoint::MatrixTransform(
    dom::SVGMatrix& matrix) {
  float x = HasOwner() ? InternalItem().mX : mPt.mX;
  float y = HasOwner() ? InternalItem().mY : mPt.mY;

  Point pt = ToMatrix(matrix.GetMatrix()).TransformPoint(Point(x, y));
  nsCOMPtr<nsISVGPoint> newPoint = new DOMSVGPoint(pt);
  return newPoint.forget();
}

}  // namespace dom
}  // namespace mozilla
