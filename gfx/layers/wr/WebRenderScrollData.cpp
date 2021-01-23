/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/WebRenderScrollData.h"

#include "Layers.h"
#include "LayersLogging.h"
#include "mozilla/layers/WebRenderLayerManager.h"
#include "mozilla/Unused.h"
#include "nsDisplayList.h"
#include "nsTArray.h"
#include "UnitTransforms.h"

namespace mozilla {
namespace layers {

WebRenderLayerScrollData::WebRenderLayerScrollData()
    : mDescendantCount(-1),
      mTransformIsPerspective(false),
      mEventRegionsOverride(EventRegionsOverride::NoOverride),
      mFixedPositionSides(mozilla::SideBits::eNone),
      mFixedPosScrollContainerId(ScrollableLayerGuid::NULL_SCROLL_ID),
      mStickyPosScrollContainerId(ScrollableLayerGuid::NULL_SCROLL_ID) {}

WebRenderLayerScrollData::~WebRenderLayerScrollData() = default;

void WebRenderLayerScrollData::InitializeRoot(int32_t aDescendantCount) {
  mDescendantCount = aDescendantCount;
}

void WebRenderLayerScrollData::Initialize(
    WebRenderScrollData& aOwner, nsDisplayItem* aItem, int32_t aDescendantCount,
    const ActiveScrolledRoot* aStopAtAsr,
    const Maybe<gfx::Matrix4x4>& aAncestorTransform) {
  MOZ_ASSERT(aDescendantCount >= 0);  // Ensure value is valid
  MOZ_ASSERT(mDescendantCount ==
             -1);  // Don't allow re-setting an already set value
  mDescendantCount = aDescendantCount;

  MOZ_ASSERT(aItem);
  aItem->UpdateScrollData(&aOwner, this);

  const ActiveScrolledRoot* asr = aItem->GetActiveScrolledRoot();
  if (ActiveScrolledRoot::IsAncestor(asr, aStopAtAsr)) {
    // If the item's ASR is an ancestor of the stop-at ASR, then we don't need
    // any more metrics information because we'll end up duplicating what the
    // ancestor WebRenderLayerScrollData already has.
    asr = nullptr;
  }

  while (asr && asr != aStopAtAsr) {
    MOZ_ASSERT(aOwner.GetManager());
    ScrollableLayerGuid::ViewID scrollId = asr->GetViewId();
    if (Maybe<size_t> index = aOwner.HasMetadataFor(scrollId)) {
      mScrollIds.AppendElement(index.ref());
    } else {
      Maybe<ScrollMetadata> metadata =
          asr->mScrollableFrame->ComputeScrollMetadata(
              aOwner.GetManager(), aItem->ReferenceFrame(), Nothing(), nullptr);
      asr->mScrollableFrame->NotifyApzTransaction();
      if (metadata) {
        MOZ_ASSERT(metadata->GetMetrics().GetScrollId() == scrollId);
        mScrollIds.AppendElement(aOwner.AddMetadata(metadata.ref()));
      } else {
        MOZ_ASSERT_UNREACHABLE("Expected scroll metadata to be available!");
      }
    }
    asr = asr->mParent;
  }

  // See the comments on StackingContextHelper::mDeferredTransformItem for an
  // overview of what deferred transforms are.
  // aAncestorTransform, if present, is the transform from a deferred transform
  // item that is an ancestor of |aItem|. We store this transform value
  // separately from mTransform because in the case where we have multiple
  // scroll metadata on this layer item, the mAncestorTransform is associated
  // with the "topmost" scroll metadata, and the mTransform is associated with
  // the "bottommost" scroll metadata. The code in
  // WebRenderScrollDataWrapper::GetTransform() is responsible for combining
  // these transforms and exposing them appropriately. Also, we don't save the
  // ancestor transform for thumb layers, because those are a special case in
  // APZ; we need to keep the ancestor transform for the scrollable content that
  // the thumb scrolls, but not for the thumb itself, as it will result in
  // incorrect visual positioning of the thumb.
  if (aAncestorTransform &&
      mScrollbarData.mScrollbarLayerType != ScrollbarLayerType::Thumb) {
    mAncestorTransform = *aAncestorTransform;
  }
}

int32_t WebRenderLayerScrollData::GetDescendantCount() const {
  MOZ_ASSERT(mDescendantCount >= 0);  // check that it was set
  return mDescendantCount;
}

size_t WebRenderLayerScrollData::GetScrollMetadataCount() const {
  return mScrollIds.Length();
}

void WebRenderLayerScrollData::AppendScrollMetadata(
    WebRenderScrollData& aOwner, const ScrollMetadata& aData) {
  mScrollIds.AppendElement(aOwner.AddMetadata(aData));
}

const ScrollMetadata& WebRenderLayerScrollData::GetScrollMetadata(
    const WebRenderScrollData& aOwner, size_t aIndex) const {
  MOZ_ASSERT(aIndex < mScrollIds.Length());
  return aOwner.GetScrollMetadata(mScrollIds[aIndex]);
}

CSSTransformMatrix WebRenderLayerScrollData::GetTransformTyped() const {
  return ViewAs<CSSTransformMatrix>(GetTransform());
}

void WebRenderLayerScrollData::Dump(const WebRenderScrollData& aOwner) const {
  printf_stderr("LayerScrollData(%p) descendants %d\n", this, mDescendantCount);
  for (size_t i : mScrollIds) {
    printf_stderr("  metadata: %s\n",
                  Stringify(aOwner.GetScrollMetadata(i)).c_str());
  }
  printf_stderr("  ancestor transform: %s\n",
                Stringify(mAncestorTransform).c_str());
  printf_stderr("  transform: %s perspective: %d visible: %s\n",
                Stringify(mTransform).c_str(), mTransformIsPerspective,
                Stringify(mVisibleRegion).c_str());
  printf_stderr("  event regions override: 0x%x\n", mEventRegionsOverride);
  if (mReferentId) {
    printf_stderr("  ref layers id: 0x%" PRIx64 "\n", uint64_t(*mReferentId));
  }
  printf_stderr("  scrollbar type: %d animation: %" PRIx64 "\n",
                (int)mScrollbarData.mScrollbarLayerType,
                mScrollbarAnimationId.valueOr(0));
  printf_stderr("  fixed container: %" PRIu64 " animation %" PRIx64 "\n",
                mFixedPosScrollContainerId,
                mFixedPositionAnimationId.valueOr(0));
  printf_stderr("  sticky container: %" PRIu64 " animation %" PRIx64
                " inner: %s outer: %s\n",
                mStickyPosScrollContainerId,
                mStickyPositionAnimationId.valueOr(0),
                Stringify(mStickyScrollRangeInner).c_str(),
                Stringify(mStickyScrollRangeOuter).c_str());
  printf_stderr("  fixed/sticky side bits: 0x%x\n", (int)mFixedPositionSides);
}

WebRenderScrollData::WebRenderScrollData()
    : mManager(nullptr), mIsFirstPaint(false), mPaintSequenceNumber(0) {}

WebRenderScrollData::WebRenderScrollData(WebRenderLayerManager* aManager)
    : mManager(aManager), mIsFirstPaint(false), mPaintSequenceNumber(0) {}

WebRenderLayerManager* WebRenderScrollData::GetManager() const {
  return mManager;
}

size_t WebRenderScrollData::AddMetadata(const ScrollMetadata& aMetadata) {
  ScrollableLayerGuid::ViewID scrollId = aMetadata.GetMetrics().GetScrollId();
  auto p = mScrollIdMap.lookupForAdd(scrollId);
  if (!p) {
    // It's a scrollId we hadn't seen before
    bool ok = mScrollIdMap.add(p, scrollId, mScrollMetadatas.Length());
    MOZ_RELEASE_ASSERT(ok);
    mScrollMetadatas.AppendElement(aMetadata);
  }  // else we didn't insert, because it already existed
  return p->value();
}

size_t WebRenderScrollData::AddLayerData(
    const WebRenderLayerScrollData& aData) {
  mLayerScrollData.AppendElement(aData);
  return mLayerScrollData.Length() - 1;
}

size_t WebRenderScrollData::GetLayerCount() const {
  return mLayerScrollData.Length();
}

const WebRenderLayerScrollData* WebRenderScrollData::GetLayerData(
    size_t aIndex) const {
  if (aIndex >= mLayerScrollData.Length()) {
    return nullptr;
  }
  return &(mLayerScrollData.ElementAt(aIndex));
}

const ScrollMetadata& WebRenderScrollData::GetScrollMetadata(
    size_t aIndex) const {
  MOZ_ASSERT(aIndex < mScrollMetadatas.Length());
  return mScrollMetadatas[aIndex];
}

Maybe<size_t> WebRenderScrollData::HasMetadataFor(
    const ScrollableLayerGuid::ViewID& aScrollId) const {
  auto ptr = mScrollIdMap.lookup(aScrollId);
  return (ptr ? Some(ptr->value()) : Nothing());
}

void WebRenderScrollData::SetIsFirstPaint() { mIsFirstPaint = true; }

bool WebRenderScrollData::IsFirstPaint() const { return mIsFirstPaint; }

void WebRenderScrollData::SetPaintSequenceNumber(
    uint32_t aPaintSequenceNumber) {
  mPaintSequenceNumber = aPaintSequenceNumber;
}

uint32_t WebRenderScrollData::GetPaintSequenceNumber() const {
  return mPaintSequenceNumber;
}

void WebRenderScrollData::ApplyUpdates(ScrollUpdatesMap& aUpdates,
                                       uint32_t aPaintSequenceNumber) {
  for (auto it = aUpdates.Iter(); !it.Done(); it.Next()) {
    if (Maybe<size_t> index = HasMetadataFor(it.Key())) {
      mScrollMetadatas[*index].GetMetrics().UpdatePendingScrollInfo(it.Data());
    }
  }
  mPaintSequenceNumber = aPaintSequenceNumber;
}

void WebRenderScrollData::Dump() const {
  printf_stderr("WebRenderScrollData with %zu layers firstpaint: %d\n",
                mLayerScrollData.Length(), mIsFirstPaint);
  for (size_t i = 0; i < mLayerScrollData.Length(); i++) {
    mLayerScrollData.ElementAt(i).Dump(*this);
  }
}

bool WebRenderScrollData::RepopulateMap() {
  MOZ_ASSERT(mScrollIdMap.empty());
  for (size_t i = 0; i < mScrollMetadatas.Length(); i++) {
    ScrollableLayerGuid::ViewID scrollId =
        mScrollMetadatas[i].GetMetrics().GetScrollId();
    bool ok = mScrollIdMap.putNew(scrollId, i);
    MOZ_RELEASE_ASSERT(ok);
  }
  return true;
}

}  // namespace layers
}  // namespace mozilla
