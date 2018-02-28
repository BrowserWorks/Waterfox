/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/WebRenderScrollData.h"

#include "Layers.h"
#include "LayersLogging.h"
#include "mozilla/layout/RenderFrameParent.h"
#include "mozilla/Unused.h"
#include "nsTArray.h"
#include "UnitTransforms.h"

namespace mozilla {
namespace layers {

WebRenderLayerScrollData::WebRenderLayerScrollData()
  : mDescendantCount(-1)
  , mTransformIsPerspective(false)
  , mEventRegionsOverride(EventRegionsOverride::NoOverride)
  , mScrollbarAnimationId(0)
  , mScrollbarTargetContainerId(FrameMetrics::NULL_SCROLL_ID)
  , mIsScrollbarContainer(false)
  , mFixedPosScrollContainerId(FrameMetrics::NULL_SCROLL_ID)
{
}

WebRenderLayerScrollData::~WebRenderLayerScrollData()
{
}

void
WebRenderLayerScrollData::Initialize(WebRenderScrollData& aOwner,
                                     Layer* aLayer,
                                     int32_t aDescendantCount)
{
  MOZ_ASSERT(aDescendantCount >= 0); // Ensure value is valid
  MOZ_ASSERT(mDescendantCount == -1); // Don't allow re-setting an already set value
  mDescendantCount = aDescendantCount;

  MOZ_ASSERT(aLayer);
  for (uint32_t i = 0; i < aLayer->GetScrollMetadataCount(); i++) {
    mScrollIds.AppendElement(aOwner.AddMetadata(aLayer->GetScrollMetadata(i)));
  }

  mTransform = aLayer->GetTransform();
  mTransformIsPerspective = aLayer->GetTransformIsPerspective();
  mEventRegions = aLayer->GetEventRegions();
  mVisibleRegion = aLayer->GetVisibleRegion();
  mReferentId = aLayer->AsRefLayer()
      ? Some(aLayer->AsRefLayer()->GetReferentId())
      : Nothing();
  mEventRegionsOverride = aLayer->AsContainerLayer()
      ? aLayer->AsContainerLayer()->GetEventRegionsOverride()
      : EventRegionsOverride::NoOverride;
  mScrollThumbData = aLayer->GetScrollThumbData();
  mScrollbarAnimationId = aLayer->GetCompositorAnimationsId();
  mScrollbarTargetContainerId = aLayer->GetScrollbarTargetContainerId();
  mIsScrollbarContainer = aLayer->IsScrollbarContainer();
  mFixedPosScrollContainerId = aLayer->GetFixedPositionScrollContainerId();
}

void
WebRenderLayerScrollData::InitializeRoot(int32_t aDescendantCount)
{
  mDescendantCount = aDescendantCount;
}

void
WebRenderLayerScrollData::Initialize(WebRenderScrollData& aOwner,
                                     nsDisplayItem* aItem,
                                     int32_t aDescendantCount,
                                     const ActiveScrolledRoot* aStopAtAsr)
{
  MOZ_ASSERT(aDescendantCount >= 0); // Ensure value is valid
  MOZ_ASSERT(mDescendantCount == -1); // Don't allow re-setting an already set value
  mDescendantCount = aDescendantCount;

  MOZ_ASSERT(aItem);
  aItem->UpdateScrollData(&aOwner, this);
  for (const ActiveScrolledRoot* asr = aItem->GetActiveScrolledRoot();
       asr && asr != aStopAtAsr;
       asr = asr->mParent) {
    Maybe<ScrollMetadata> metadata = asr->mScrollableFrame->ComputeScrollMetadata(
        nullptr, aItem->ReferenceFrame(), ContainerLayerParameters(), nullptr);
    MOZ_ASSERT(metadata);
    mScrollIds.AppendElement(aOwner.AddMetadata(metadata.ref()));
  }
}

int32_t
WebRenderLayerScrollData::GetDescendantCount() const
{
  MOZ_ASSERT(mDescendantCount >= 0); // check that it was set
  return mDescendantCount;
}

size_t
WebRenderLayerScrollData::GetScrollMetadataCount() const
{
  return mScrollIds.Length();
}

void
WebRenderLayerScrollData::AppendScrollMetadata(WebRenderScrollData& aOwner,
                                               const ScrollMetadata& aData)
{
  mScrollIds.AppendElement(aOwner.AddMetadata(aData));
}

const ScrollMetadata&
WebRenderLayerScrollData::GetScrollMetadata(const WebRenderScrollData& aOwner,
                                            size_t aIndex) const
{
  MOZ_ASSERT(aIndex < mScrollIds.Length());
  return aOwner.GetScrollMetadata(mScrollIds[aIndex]);
}

CSSTransformMatrix
WebRenderLayerScrollData::GetTransformTyped() const
{
  return ViewAs<CSSTransformMatrix>(GetTransform());
}

void
WebRenderLayerScrollData::Dump(const WebRenderScrollData& aOwner) const
{
  printf_stderr("LayerScrollData(%p) descendants %d\n", this, mDescendantCount);
  for (size_t i : mScrollIds) {
    printf_stderr("  metadata: %s\n", Stringify(aOwner.GetScrollMetadata(i)).c_str());
  }
  printf_stderr("  transform: %s perspective: %d visible: %s\n",
    Stringify(mTransform).c_str(), mTransformIsPerspective,
    Stringify(mVisibleRegion).c_str());
  printf_stderr("  event regions: %s override: 0x%x\n",
    Stringify(mEventRegions).c_str(), mEventRegionsOverride);
  printf_stderr("  ref layers id: %" PRIu64 "\n", mReferentId.valueOr(0));
  //printf_stderr("  scroll thumb: %s animation: %" PRIu64 "\n",
  //  Stringify(mScrollThumbData).c_str(), mScrollbarAnimationId);
  printf_stderr("  scroll container: %d target: %" PRIu64 "\n",
    mIsScrollbarContainer, mScrollbarTargetContainerId);
  printf_stderr("  fixed pos container: %" PRIu64 "\n",
    mFixedPosScrollContainerId);
}

WebRenderScrollData::WebRenderScrollData()
  : mIsFirstPaint(false)
  , mPaintSequenceNumber(0)
{
}

WebRenderScrollData::~WebRenderScrollData()
{
}

size_t
WebRenderScrollData::AddMetadata(const ScrollMetadata& aMetadata)
{
  FrameMetrics::ViewID scrollId = aMetadata.GetMetrics().GetScrollId();
  auto insertResult = mScrollIdMap.insert(std::make_pair(scrollId, 0));
  if (insertResult.second) {
    // Insertion took place, therefore it's a scrollId we hadn't seen before
    insertResult.first->second = mScrollMetadatas.Length();
    mScrollMetadatas.AppendElement(aMetadata);
  } // else we didn't insert, because it already existed
  return insertResult.first->second;
}

size_t
WebRenderScrollData::AddNewLayerData()
{
  size_t len = mLayerScrollData.Length();
  Unused << mLayerScrollData.AppendElement();
  return len;
}

size_t
WebRenderScrollData::AddLayerData(const WebRenderLayerScrollData& aData)
{
  mLayerScrollData.AppendElement(aData);
  return mLayerScrollData.Length() - 1;
}

size_t
WebRenderScrollData::GetLayerCount() const
{
  return mLayerScrollData.Length();
}

WebRenderLayerScrollData*
WebRenderScrollData::GetLayerDataMutable(size_t aIndex)
{
  if (aIndex >= mLayerScrollData.Length()) {
    return nullptr;
  }
  return &(mLayerScrollData.ElementAt(aIndex));
}

const WebRenderLayerScrollData*
WebRenderScrollData::GetLayerData(size_t aIndex) const
{
  if (aIndex >= mLayerScrollData.Length()) {
    return nullptr;
  }
  return &(mLayerScrollData.ElementAt(aIndex));
}

const ScrollMetadata&
WebRenderScrollData::GetScrollMetadata(size_t aIndex) const
{
  MOZ_ASSERT(aIndex < mScrollMetadatas.Length());
  return mScrollMetadatas[aIndex];
}

void
WebRenderScrollData::SetFocusTarget(const FocusTarget& aFocusTarget)
{
  mFocusTarget = aFocusTarget;
}

void
WebRenderScrollData::SetIsFirstPaint()
{
  mIsFirstPaint = true;
}

bool
WebRenderScrollData::IsFirstPaint() const
{
  return mIsFirstPaint;
}

void
WebRenderScrollData::SetPaintSequenceNumber(uint32_t aPaintSequenceNumber)
{
  mPaintSequenceNumber = aPaintSequenceNumber;
}

uint32_t
WebRenderScrollData::GetPaintSequenceNumber() const
{
  return mPaintSequenceNumber;
}

void
WebRenderScrollData::Dump() const
{
  printf_stderr("WebRenderScrollData with %zu layers firstpaint: %d\n",
      mLayerScrollData.Length(), mIsFirstPaint);
  for (size_t i = 0; i < mLayerScrollData.Length(); i++) {
    mLayerScrollData.ElementAt(i).Dump(*this);
  }
}

} // namespace layers
} // namespace mozilla
