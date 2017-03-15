/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=2 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/AsyncCompositionManager.h"
#include <stdint.h>                     // for uint32_t
#include "apz/src/AsyncPanZoomController.h"
#include "FrameMetrics.h"               // for FrameMetrics
#include "LayerManagerComposite.h"      // for LayerManagerComposite, etc
#include "Layers.h"                     // for Layer, ContainerLayer, etc
#include "gfxPoint.h"                   // for gfxPoint, gfxSize
#include "gfxPrefs.h"                   // for gfxPrefs
#include "mozilla/StyleAnimationValue.h" // for StyleAnimationValue, etc
#include "mozilla/WidgetUtils.h"        // for ComputeTransformForRotation
#include "mozilla/dom/KeyframeEffectReadOnly.h"
#include "mozilla/dom/AnimationEffectReadOnlyBinding.h" // for dom::FillMode
#include "mozilla/dom/KeyframeEffectBinding.h" // for dom::IterationComposite
#include "mozilla/gfx/BaseRect.h"       // for BaseRect
#include "mozilla/gfx/Point.h"          // for RoundedToInt, PointTyped
#include "mozilla/gfx/Rect.h"           // for RoundedToInt, RectTyped
#include "mozilla/gfx/ScaleFactor.h"    // for ScaleFactor
#include "mozilla/layers/APZUtils.h"    // for CompleteAsyncTransform
#include "mozilla/layers/Compositor.h"  // for Compositor
#include "mozilla/layers/CompositorBridgeParent.h" // for CompositorBridgeParent, etc
#include "mozilla/layers/CompositorThread.h"
#include "mozilla/layers/LayerAnimationUtils.h" // for TimingFunctionToComputedTimingFunction
#include "mozilla/layers/LayerMetricsWrapper.h" // for LayerMetricsWrapper
#include "nsCoord.h"                    // for NSAppUnitsToFloatPixels, etc
#include "nsDebug.h"                    // for NS_ASSERTION, etc
#include "nsDeviceContext.h"            // for nsDeviceContext
#include "nsDisplayList.h"              // for nsDisplayTransform, etc
#include "nsMathUtils.h"                // for NS_round
#include "nsPoint.h"                    // for nsPoint
#include "nsRect.h"                     // for mozilla::gfx::IntRect
#include "nsRegion.h"                   // for nsIntRegion
#include "nsTArray.h"                   // for nsTArray, nsTArray_Impl, etc
#include "nsTArrayForwardDeclare.h"     // for InfallibleTArray
#include "UnitTransforms.h"             // for TransformTo
#include "gfxPrefs.h"
#if defined(MOZ_WIDGET_ANDROID)
# include <android/log.h>
# include "mozilla/widget/AndroidCompositorWidget.h"
#endif
#include "GeckoProfiler.h"
#include "FrameUniformityData.h"
#include "TreeTraversal.h"              // for ForEachNode, BreadthFirstSearch
#include "VsyncSource.h"

struct nsCSSValueSharedList;

namespace mozilla {
namespace layers {

using namespace mozilla::gfx;

static bool
IsSameDimension(dom::ScreenOrientationInternal o1, dom::ScreenOrientationInternal o2)
{
  bool isO1portrait = (o1 == dom::eScreenOrientation_PortraitPrimary || o1 == dom::eScreenOrientation_PortraitSecondary);
  bool isO2portrait = (o2 == dom::eScreenOrientation_PortraitPrimary || o2 == dom::eScreenOrientation_PortraitSecondary);
  return !(isO1portrait ^ isO2portrait);
}

static bool
ContentMightReflowOnOrientationChange(const IntRect& rect)
{
  return rect.width != rect.height;
}

AsyncCompositionManager::AsyncCompositionManager(LayerManagerComposite* aManager)
  : mLayerManager(aManager)
  , mIsFirstPaint(true)
  , mLayersUpdated(false)
  , mPaintSyncId(0)
  , mReadyForCompose(true)
{
}

AsyncCompositionManager::~AsyncCompositionManager()
{
}

void
AsyncCompositionManager::ResolveRefLayers(CompositorBridgeParent* aCompositor,
                                          bool* aHasRemoteContent,
                                          bool* aResolvePlugins)
{
  if (aHasRemoteContent) {
    *aHasRemoteContent = false;
  }

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
  // If valid *aResolvePlugins indicates if we need to update plugin geometry
  // when we walk the tree.
  bool resolvePlugins = (aCompositor && aResolvePlugins && *aResolvePlugins);
#endif

  if (!mLayerManager->GetRoot()) {
    // Updated the return value since this result controls completing composition.
    if (aResolvePlugins) {
      *aResolvePlugins = false;
    }
    return;
  }

  mReadyForCompose = true;
  bool hasRemoteContent = false;
  bool didResolvePlugins = false;

  ForEachNode<ForwardIterator>(
    mLayerManager->GetRoot(),
    [&](Layer* layer)
    {
      RefLayer* refLayer = layer->AsRefLayer();
      if (!refLayer) {
        return;
      }

      hasRemoteContent = true;
      const CompositorBridgeParent::LayerTreeState* state =
        CompositorBridgeParent::GetIndirectShadowTree(refLayer->GetReferentId());
      if (!state) {
        return;
      }

      Layer* referent = state->mRoot;
      if (!referent) {
        return;
      }

      if (!refLayer->GetLocalVisibleRegion().IsEmpty()) {
        dom::ScreenOrientationInternal chromeOrientation =
          mTargetConfig.orientation();
        dom::ScreenOrientationInternal contentOrientation =
          state->mTargetConfig.orientation();
        if (!IsSameDimension(chromeOrientation, contentOrientation) &&
            ContentMightReflowOnOrientationChange(mTargetConfig.naturalBounds())) {
          mReadyForCompose = false;
        }
      }

      refLayer->ConnectReferentLayer(referent);

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
      if (resolvePlugins) {
        didResolvePlugins |=
          aCompositor->UpdatePluginWindowState(refLayer->GetReferentId());
      }
#endif
    });

  if (aHasRemoteContent) {
    *aHasRemoteContent = hasRemoteContent;
  }
  if (aResolvePlugins) {
    *aResolvePlugins = didResolvePlugins;
  }
}

void
AsyncCompositionManager::DetachRefLayers()
{
  if (!mLayerManager->GetRoot()) {
    return;
  }

  mReadyForCompose = false;

  ForEachNodePostOrder<ForwardIterator>(mLayerManager->GetRoot(),
    [&](Layer* layer)
    {
      RefLayer* refLayer = layer->AsRefLayer();
      if (!refLayer) {
        return;
      }

      const CompositorBridgeParent::LayerTreeState* state =
        CompositorBridgeParent::GetIndirectShadowTree(refLayer->GetReferentId());
      if (!state) {
        return;
      }

      Layer* referent = state->mRoot;
      if (referent) {
        refLayer->DetachReferentLayer(referent);
      }
    });
}

void
AsyncCompositionManager::ComputeRotation()
{
  if (!mTargetConfig.naturalBounds().IsEmpty()) {
    mWorldTransform =
      ComputeTransformForRotation(mTargetConfig.naturalBounds(),
                                  mTargetConfig.rotation());
  }
}

#ifdef DEBUG
static void
GetBaseTransform(Layer* aLayer, Matrix4x4* aTransform)
{
  // Start with the animated transform if there is one
  *aTransform =
    (aLayer->AsLayerComposite()->GetShadowTransformSetByAnimation()
        ? aLayer->GetLocalTransform()
        : aLayer->GetTransform());
}
#endif

static void
TransformClipRect(Layer* aLayer,
                  const ParentLayerToParentLayerMatrix4x4& aTransform)
{
  MOZ_ASSERT(aTransform.Is2D());
  const Maybe<ParentLayerIntRect>& clipRect = aLayer->AsLayerComposite()->GetShadowClipRect();
  if (clipRect) {
    ParentLayerIntRect transformed = TransformBy(aTransform, *clipRect);
    aLayer->AsLayerComposite()->SetShadowClipRect(Some(transformed));
  }
}

// Similar to TransformFixedClip(), but only transforms the fixed part of the
// clip.
static void
TransformFixedClip(Layer* aLayer,
                   const ParentLayerToParentLayerMatrix4x4& aTransform,
                   AsyncCompositionManager::ClipParts& aClipParts)
{
  MOZ_ASSERT(aTransform.Is2D());
  if (aClipParts.mFixedClip) {
    *aClipParts.mFixedClip = TransformBy(aTransform, *aClipParts.mFixedClip);
    aLayer->AsLayerComposite()->SetShadowClipRect(aClipParts.Intersect());
  }
}

/**
 * Set the given transform as the shadow transform on the layer, assuming
 * that the given transform already has the pre- and post-scales applied.
 * That is, this function cancels out the pre- and post-scales from aTransform
 * before setting it as the shadow transform on the layer, so that when
 * the layer's effective transform is computed, the pre- and post-scales will
 * only be applied once.
 */
static void
SetShadowTransform(Layer* aLayer, LayerToParentLayerMatrix4x4 aTransform)
{
  if (ContainerLayer* c = aLayer->AsContainerLayer()) {
    aTransform.PreScale(1.0f / c->GetPreXScale(),
                        1.0f / c->GetPreYScale(),
                        1);
  }
  aTransform.PostScale(1.0f / aLayer->GetPostXScale(),
                       1.0f / aLayer->GetPostYScale(),
                       1);
  aLayer->AsLayerComposite()->SetShadowBaseTransform(aTransform.ToUnknownMatrix());
}

static void
TranslateShadowLayer(Layer* aLayer,
                     const ParentLayerPoint& aTranslation,
                     bool aAdjustClipRect,
                     AsyncCompositionManager::ClipPartsCache* aClipPartsCache)
{
  // This layer might also be a scrollable layer and have an async transform.
  // To make sure we don't clobber that, we start with the shadow transform.
  // (i.e. GetLocalTransform() instead of GetTransform()).
  // Note that the shadow transform is reset on every frame of composition so
  // we don't have to worry about the adjustments compounding over successive
  // frames.
  LayerToParentLayerMatrix4x4 layerTransform = aLayer->GetLocalTransformTyped();

  // Apply the translation to the layer transform.
  layerTransform.PostTranslate(aTranslation);

  SetShadowTransform(aLayer, layerTransform);
  aLayer->AsLayerComposite()->SetShadowTransformSetByAnimation(false);

  if (aAdjustClipRect) {
    auto transform = ParentLayerToParentLayerMatrix4x4::Translation(aTranslation);
    // If we're passed a clip parts cache, only transform the fixed part of
    // the clip.
    if (aClipPartsCache) {
      auto iter = aClipPartsCache->find(aLayer);
      MOZ_ASSERT(iter != aClipPartsCache->end());
      TransformFixedClip(aLayer, transform, iter->second);
    } else {
      TransformClipRect(aLayer, transform);
    }

    // If a fixed- or sticky-position layer has a mask layer, that mask should
    // move along with the layer, so apply the translation to the mask layer too.
    if (Layer* maskLayer = aLayer->GetMaskLayer()) {
      TranslateShadowLayer(maskLayer, aTranslation, false, aClipPartsCache);
    }
  }
}

#ifdef DEBUG
static void
AccumulateLayerTransforms(Layer* aLayer,
                          Layer* aAncestor,
                          Matrix4x4& aMatrix)
{
  // Accumulate the transforms between this layer and the subtree root layer.
  for (Layer* l = aLayer; l && l != aAncestor; l = l->GetParent()) {
    Matrix4x4 transform;
    GetBaseTransform(l, &transform);
    aMatrix *= transform;
  }
}
#endif

static LayerPoint
GetLayerFixedMarginsOffset(Layer* aLayer,
                           const ScreenMargin& aFixedLayerMargins)
{
  // Work out the necessary translation, in root scrollable layer space.
  // Because fixed layer margins are stored relative to the root scrollable
  // layer, we can just take the difference between these values.
  LayerPoint translation;
  int32_t sides = aLayer->GetFixedPositionSides();

  if ((sides & eSideBitsLeftRight) == eSideBitsLeftRight) {
    translation.x += (aFixedLayerMargins.left - aFixedLayerMargins.right) / 2;
  } else if (sides & eSideBitsRight) {
    translation.x -= aFixedLayerMargins.right;
  } else if (sides & eSideBitsLeft) {
    translation.x += aFixedLayerMargins.left;
  }

  if ((sides & eSideBitsTopBottom) == eSideBitsTopBottom) {
    translation.y += (aFixedLayerMargins.top - aFixedLayerMargins.bottom) / 2;
  } else if (sides & eSideBitsBottom) {
    translation.y -= aFixedLayerMargins.bottom;
  } else if (sides & eSideBitsTop) {
    translation.y += aFixedLayerMargins.top;
  }

  return translation;
}

static gfxFloat
IntervalOverlap(gfxFloat aTranslation, gfxFloat aMin, gfxFloat aMax)
{
  // Determine the amount of overlap between the 1D vector |aTranslation|
  // and the interval [aMin, aMax].
  if (aTranslation > 0) {
    return std::max(0.0, std::min(aMax, aTranslation) - std::max(aMin, 0.0));
  } else {
    return std::min(0.0, std::max(aMin, aTranslation) - std::min(aMax, 0.0));
  }
}

/**
 * Finds the metrics on |aLayer| with scroll id |aScrollId|, and returns a
 * LayerMetricsWrapper representing the (layer, metrics) pair, or the null
 * LayerMetricsWrapper if no matching metrics could be found.
 */
static LayerMetricsWrapper
FindMetricsWithScrollId(Layer* aLayer, FrameMetrics::ViewID aScrollId)
{
  for (uint64_t i = 0; i < aLayer->GetScrollMetadataCount(); ++i) {
    if (aLayer->GetFrameMetrics(i).GetScrollId() == aScrollId) {
      return LayerMetricsWrapper(aLayer, i);
    }
  }
  return LayerMetricsWrapper();
}

/**
 * Checks whether the (layer, metrics) pair (aTransformedLayer, aTransformedMetrics)
 * is on the path from |aFixedLayer| to the metrics with scroll id
 * |aFixedWithRespectTo|, inclusive.
 */
static bool
AsyncTransformShouldBeUnapplied(Layer* aFixedLayer,
                                FrameMetrics::ViewID aFixedWithRespectTo,
                                Layer* aTransformedLayer,
                                FrameMetrics::ViewID aTransformedMetrics)
{
  LayerMetricsWrapper transformed = FindMetricsWithScrollId(aTransformedLayer, aTransformedMetrics);
  if (!transformed.IsValid()) {
    return false;
  }
  // It's important to start at the bottom, because the fixed layer itself
  // could have the transformed metrics, and they can be at the bottom.
  LayerMetricsWrapper current(aFixedLayer, LayerMetricsWrapper::StartAt::BOTTOM);
  bool encounteredTransformedLayer = false;
  // The transformed layer is on the path from |aFixedLayer| to the fixed-to
  // layer if as we walk up the (layer, metrics) tree starting from
  // |aFixedLayer|, we *first* encounter the transformed layer, and *then* (or
  // at the same time) the fixed-to layer.
  while (current) {
    if (!encounteredTransformedLayer && current == transformed) {
      encounteredTransformedLayer = true;
    }
    if (current.Metrics().GetScrollId() == aFixedWithRespectTo) {
      return encounteredTransformedLayer;
    }
    current = current.GetParent();
    // It's possible that we reach a layers id boundary before we reach an
    // ancestor with the scroll id |aFixedWithRespectTo| (this could happen
    // e.g. if the scroll frame with that scroll id uses containerless
    // scrolling). In such a case, stop the walk, as a new layers id could
    // have a different layer with scroll id |aFixedWithRespectTo| which we
    // don't intend to match.
    if (current && current.AsRefLayer() != nullptr) {
      break;
    }
  }
  return false;
}

// If |aLayer| is fixed or sticky, returns the scroll id of the scroll frame
// that it's fixed or sticky to. Otherwise, returns Nothing().
static Maybe<FrameMetrics::ViewID>
IsFixedOrSticky(Layer* aLayer)
{
  bool isRootOfFixedSubtree = aLayer->GetIsFixedPosition() &&
    !aLayer->GetParent()->GetIsFixedPosition();
  if (isRootOfFixedSubtree) {
    return Some(aLayer->GetFixedPositionScrollContainerId());
  }
  if (aLayer->GetIsStickyPosition()) {
    return Some(aLayer->GetStickyScrollContainerId());
  }
  return Nothing();
}

void
AsyncCompositionManager::AlignFixedAndStickyLayers(Layer* aTransformedSubtreeRoot,
                                                   Layer* aStartTraversalAt,
                                                   FrameMetrics::ViewID aTransformScrollId,
                                                   const LayerToParentLayerMatrix4x4& aPreviousTransformForRoot,
                                                   const LayerToParentLayerMatrix4x4& aCurrentTransformForRoot,
                                                   const ScreenMargin& aFixedLayerMargins,
                                                   ClipPartsCache* aClipPartsCache)
{
  // We're going to be inverting |aCurrentTransformForRoot|.
  // If it's singular, there's nothing we can do.
  if (aCurrentTransformForRoot.IsSingular()) {
    return;
  }

  Layer* layer = aStartTraversalAt;
  bool needsAsyncTransformUnapplied = false;
  if (Maybe<FrameMetrics::ViewID> fixedTo = IsFixedOrSticky(layer)) {
    needsAsyncTransformUnapplied = AsyncTransformShouldBeUnapplied(layer,
        *fixedTo, aTransformedSubtreeRoot, aTransformScrollId);
  }

  // We want to process all the fixed and sticky descendants of
  // aTransformedSubtreeRoot. Once we do encounter such a descendant, we don't
  // need to recurse any deeper because the adjustment to the fixed or sticky
  // layer will apply to its subtree.
  if (!needsAsyncTransformUnapplied) {
    for (Layer* child = layer->GetFirstChild(); child; child = child->GetNextSibling()) {
      AlignFixedAndStickyLayers(aTransformedSubtreeRoot, child,
          aTransformScrollId, aPreviousTransformForRoot,
          aCurrentTransformForRoot, aFixedLayerMargins, aClipPartsCache);
    }
    return;
  }

  // Insert a translation so that the position of the anchor point is the same
  // before and after the change to the transform of aTransformedSubtreeRoot.

  // A transform creates a containing block for fixed-position descendants,
  // so there shouldn't be a transform in between the fixed layer and
  // the subtree root layer.
#ifdef DEBUG
  Matrix4x4 ancestorTransform;
  if (layer != aTransformedSubtreeRoot) {
    AccumulateLayerTransforms(layer->GetParent(), aTransformedSubtreeRoot,
                              ancestorTransform);
  }
  ancestorTransform.NudgeToIntegersFixedEpsilon();
  MOZ_ASSERT(ancestorTransform.IsIdentity());
#endif

  // Since we create container layers for fixed layers, there shouldn't
  // a local CSS or OMTA transform on the fixed layer, either (any local
  // transform would go onto a descendant layer inside the container
  // layer).
#ifdef DEBUG
  Matrix4x4 localTransform;
  GetBaseTransform(layer, &localTransform);
  localTransform.NudgeToIntegersFixedEpsilon();
  MOZ_ASSERT(localTransform.IsIdentity());
#endif

  // Now work out the translation necessary to make sure the layer doesn't
  // move given the new sub-tree root transform.

  // Get the layer's fixed anchor point, in the layer's local coordinate space
  // (before any transform is applied).
  LayerPoint anchor = layer->GetFixedPositionAnchor();

  // Offset the layer's anchor point to make sure fixed position content
  // respects content document fixed position margins.
  LayerPoint offsetAnchor = anchor + GetLayerFixedMarginsOffset(layer, aFixedLayerMargins);

  // Additionally transform the anchor to compensate for the change
  // from the old transform to the new transform. We do
  // this by using the old transform to take the offset anchor back into
  // subtree root space, and then the inverse of the new transform
  // to bring it back to layer space.
  ParentLayerPoint offsetAnchorInSubtreeRootSpace =
      aPreviousTransformForRoot.TransformPoint(offsetAnchor);
  LayerPoint transformedAnchor = aCurrentTransformForRoot.Inverse()
      .TransformPoint(offsetAnchorInSubtreeRootSpace);

  // We want to translate the layer by the difference between
  // |transformedAnchor| and |anchor|.
  LayerPoint translation = transformedAnchor - anchor;

  // A fixed layer will "consume" (be unadjusted by) the entire translation
  // calculated above. A sticky layer may consume all, part, or none of it,
  // depending on where we are relative to its sticky scroll range.
  // The remainder of the translation (the unconsumed portion) needs to
  // be propagated to descendant fixed/sticky layers.
  LayerPoint unconsumedTranslation;

  if (layer->GetIsStickyPosition()) {
    // For sticky positioned layers, the difference between the two rectangles
    // defines a pair of translation intervals in each dimension through which
    // the layer should not move relative to the scroll container. To
    // accomplish this, we limit each dimension of the |translation| to that
    // part of it which overlaps those intervals.
    const LayerRect& stickyOuter = layer->GetStickyScrollRangeOuter();
    const LayerRect& stickyInner = layer->GetStickyScrollRangeInner();

    LayerPoint originalTranslation = translation;
    translation.y = IntervalOverlap(translation.y, stickyOuter.y, stickyOuter.YMost()) -
                    IntervalOverlap(translation.y, stickyInner.y, stickyInner.YMost());
    translation.x = IntervalOverlap(translation.x, stickyOuter.x, stickyOuter.XMost()) -
                    IntervalOverlap(translation.x, stickyInner.x, stickyInner.XMost());
    unconsumedTranslation = translation - originalTranslation;
  }

  // Finally, apply the translation to the layer transform. Note that in cases
  // where the async transform on |aTransformedSubtreeRoot| affects this layer's
  // clip rect, we need to apply the same translation to said clip rect, so
  // that the effective transform on the clip rect takes it back to where it was
  // originally, had there been no async scroll.
  TranslateShadowLayer(layer, ViewAs<ParentLayerPixel>(translation,
      PixelCastJustification::NoTransformOnLayer), true, aClipPartsCache);

  // Propragate the unconsumed portion of the translation to descendant
  // fixed/sticky layers.
  if (unconsumedTranslation != LayerPoint()) {
    // Take the computations we performed to derive |translation| from
    // |aCurrentTransformForRoot|, and perform them in reverse, keeping other
    // quantities fixed, to come up with a new transform |newTransform| that
    // would produce |unconsumedTranslation|.
    LayerPoint newTransformedAnchor = unconsumedTranslation + anchor;
    ParentLayerPoint newTransformedAnchorInSubtreeRootSpace =
        aPreviousTransformForRoot.TransformPoint(newTransformedAnchor);
    LayerToParentLayerMatrix4x4 newTransform = aPreviousTransformForRoot;
    newTransform.PostTranslate(newTransformedAnchorInSubtreeRootSpace -
                               offsetAnchorInSubtreeRootSpace);

    // Propagate this new transform to our descendants as the new value of
    // |aCurrentTransformForRoot|. This allows them to consume the unconsumed
    // translation.
    for (Layer* child = layer->GetFirstChild(); child; child = child->GetNextSibling()) {
      AlignFixedAndStickyLayers(aTransformedSubtreeRoot, child, aTransformScrollId,
          aPreviousTransformForRoot, newTransform, aFixedLayerMargins, aClipPartsCache);
    }
  }

  return;
}

static void
SampleValue(float aPortion, Animation& aAnimation,
            const StyleAnimationValue& aStart, const StyleAnimationValue& aEnd,
            const StyleAnimationValue& aLastValue, uint64_t aCurrentIteration,
            Animatable* aValue, Layer* aLayer)
{
  NS_ASSERTION(aStart.GetUnit() == aEnd.GetUnit() ||
               aStart.GetUnit() == StyleAnimationValue::eUnit_None ||
               aEnd.GetUnit() == StyleAnimationValue::eUnit_None,
               "Must have same unit");

  StyleAnimationValue startValue = aStart;
  StyleAnimationValue endValue = aEnd;
  // Iteration composition for accumulate
  if (static_cast<dom::IterationCompositeOperation>
        (aAnimation.iterationComposite()) ==
          dom::IterationCompositeOperation::Accumulate &&
      aCurrentIteration > 0) {
    // FIXME: Bug 1293492: Add a utility function to calculate both of
    // below StyleAnimationValues.
    DebugOnly<bool> accumulateResult =
      StyleAnimationValue::Accumulate(aAnimation.property(),
                                      startValue,
                                      aLastValue,
                                      aCurrentIteration);
    MOZ_ASSERT(accumulateResult, "could not accumulate value");
    accumulateResult =
      StyleAnimationValue::Accumulate(aAnimation.property(),
                                      endValue,
                                      aLastValue,
                                      aCurrentIteration);
    MOZ_ASSERT(accumulateResult, "could not accumulate value");
  }

  StyleAnimationValue interpolatedValue;
  // This should never fail because we only pass transform and opacity values
  // to the compositor and they should never fail to interpolate.
  DebugOnly<bool> uncomputeResult =
    StyleAnimationValue::Interpolate(aAnimation.property(),
                                     startValue, endValue,
                                     aPortion, interpolatedValue);
  MOZ_ASSERT(uncomputeResult, "could not uncompute value");

  if (aAnimation.property() == eCSSProperty_opacity) {
    *aValue = interpolatedValue.GetFloatValue();
    return;
  }

  nsCSSValueSharedList* interpolatedList =
    interpolatedValue.GetCSSValueSharedListValue();

  TransformData& data = aAnimation.data().get_TransformData();
  nsPoint origin = data.origin();
  // we expect all our transform data to arrive in device pixels
  Point3D transformOrigin = data.transformOrigin();
  nsDisplayTransform::FrameTransformProperties props(interpolatedList,
                                                     transformOrigin);

  // If our parent layer is a perspective layer, then the offset into reference
  // frame coordinates is already on that layer. If not, then we need to ask
  // for it to be added here.
  uint32_t flags = 0;
  if (!aLayer->GetParent() || !aLayer->GetParent()->GetTransformIsPerspective()) {
    flags = nsDisplayTransform::OFFSET_BY_ORIGIN;
  }

  Matrix4x4 transform =
    nsDisplayTransform::GetResultingTransformMatrix(props, origin,
                                                    data.appUnitsPerDevPixel(),
                                                    flags, &data.bounds());

  InfallibleTArray<TransformFunction> functions;
  functions.AppendElement(TransformMatrix(transform));
  *aValue = functions;
}

static bool
SampleAnimations(Layer* aLayer, TimeStamp aPoint)
{
  bool activeAnimations = false;

  ForEachNode<ForwardIterator>(
      aLayer,
      [&activeAnimations, &aPoint] (Layer* layer)
      {
        AnimationArray& animations = layer->GetAnimations();
        InfallibleTArray<AnimData>& animationData = layer->GetAnimationData();

        // Process in order, since later animations override earlier ones.
        for (size_t i = 0, iEnd = animations.Length(); i < iEnd; ++i) {
          Animation& animation = animations[i];
          AnimData& animData = animationData[i];

          activeAnimations = true;

          MOZ_ASSERT(!animation.startTime().IsNull(),
                     "Failed to resolve start time of pending animations");
          TimeDuration elapsedDuration =
            (aPoint - animation.startTime()).MultDouble(animation.playbackRate());
          TimingParams timing;
          timing.mDuration.emplace(animation.duration());
          timing.mDelay = animation.delay();
          timing.mIterations = animation.iterations();
          timing.mIterationStart = animation.iterationStart();
          timing.mDirection =
            static_cast<dom::PlaybackDirection>(animation.direction());
          timing.mFill = static_cast<dom::FillMode>(animation.fillMode());
          timing.mFunction =
            AnimationUtils::TimingFunctionToComputedTimingFunction(
              animation.easingFunction());

          ComputedTiming computedTiming =
            dom::AnimationEffectReadOnly::GetComputedTimingAt(
              Nullable<TimeDuration>(elapsedDuration), timing,
              animation.playbackRate());

          if (computedTiming.mProgress.IsNull()) {
            continue;
          }

          uint32_t segmentIndex = 0;
          size_t segmentSize = animation.segments().Length();
          AnimationSegment* segment = animation.segments().Elements();
          while (segment->endPortion() < computedTiming.mProgress.Value() &&
                 segmentIndex < segmentSize - 1) {
            ++segment;
            ++segmentIndex;
          }

          double positionInSegment =
            (computedTiming.mProgress.Value() - segment->startPortion()) /
            (segment->endPortion() - segment->startPortion());

          double portion =
            ComputedTimingFunction::GetPortion(animData.mFunctions[segmentIndex],
                                               positionInSegment,
                                           computedTiming.mBeforeFlag);

          // interpolate the property
          Animatable interpolatedValue;
          SampleValue(portion, animation,
                      animData.mStartValues[segmentIndex],
                      animData.mEndValues[segmentIndex],
                      animData.mEndValues.LastElement(),
                      computedTiming.mCurrentIteration,
                      &interpolatedValue, layer);
          LayerComposite* layerComposite = layer->AsLayerComposite();
          switch (animation.property()) {
          case eCSSProperty_opacity:
          {
            layerComposite->SetShadowOpacity(interpolatedValue.get_float());
            layerComposite->SetShadowOpacitySetByAnimation(true);
            break;
          }
          case eCSSProperty_transform:
          {
            Matrix4x4 matrix = interpolatedValue.get_ArrayOfTransformFunction()[0].get_TransformMatrix().value();
            if (ContainerLayer* c = layer->AsContainerLayer()) {
              matrix.PostScale(c->GetInheritedXScale(), c->GetInheritedYScale(), 1);
            }
            layerComposite->SetShadowBaseTransform(matrix);
            layerComposite->SetShadowTransformSetByAnimation(true);
            break;
          }
          default:
            NS_WARNING("Unhandled animated property");
          }
        }
      });
  return activeAnimations;
}

static bool
SampleAPZAnimations(const LayerMetricsWrapper& aLayer, TimeStamp aSampleTime)
{
  bool activeAnimations = false;

  ForEachNodePostOrder<ForwardIterator>(aLayer,
      [&activeAnimations, &aSampleTime](LayerMetricsWrapper aLayerMetrics)
      {
        if (AsyncPanZoomController* apzc = aLayerMetrics.GetApzc()) {
          apzc->ReportCheckerboard(aSampleTime);
          activeAnimations |= apzc->AdvanceAnimations(aSampleTime);
        }
      }
  );

  return activeAnimations;
}

void
AsyncCompositionManager::RecordShadowTransforms(Layer* aLayer)
{
  MOZ_ASSERT(gfxPrefs::CollectScrollTransforms());
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());

  ForEachNodePostOrder<ForwardIterator>(
      aLayer,
      [this] (Layer* layer)
      {
        for (uint32_t i = 0; i < layer->GetScrollMetadataCount(); i++) {
          AsyncPanZoomController* apzc = layer->GetAsyncPanZoomController(i);
          if (!apzc) {
            continue;
          }
          gfx::Matrix4x4 shadowTransform = layer->AsLayerComposite()->GetShadowBaseTransform();
          if (!shadowTransform.Is2D()) {
            continue;
          }

          Matrix transform = shadowTransform.As2D();
          if (transform.IsTranslation() && !shadowTransform.IsIdentity()) {
            Point translation = transform.GetTranslation();
            mLayerTransformRecorder.RecordTransform(layer, translation);
            return;
          }
        }
      });
}

static AsyncTransformComponentMatrix
AdjustForClip(const AsyncTransformComponentMatrix& asyncTransform, Layer* aLayer)
{
  AsyncTransformComponentMatrix result = asyncTransform;

  // Container layers start at the origin, but they are clipped to where they
  // actually have content on the screen. The tree transform is meant to apply
  // to the clipped area. If the tree transform includes a scale component,
  // then applying it to container as-is will produce incorrect results. To
  // avoid this, translate the layer so that the clip rect starts at the origin,
  // apply the tree transform, and translate back.
  if (const Maybe<ParentLayerIntRect>& shadowClipRect = aLayer->AsLayerComposite()->GetShadowClipRect()) {
    if (shadowClipRect->TopLeft() != ParentLayerIntPoint()) {  // avoid a gratuitous change of basis
      result.ChangeBasis(shadowClipRect->x, shadowClipRect->y, 0);
    }
  }
  return result;
}

static void
ExpandRootClipRect(Layer* aLayer, const ScreenMargin& aFixedLayerMargins)
{
  // For Fennec we want to expand the root scrollable layer clip rect based on
  // the fixed position margins. In particular, we want this while the dynamic
  // toolbar is in the process of sliding offscreen and the area of the
  // LayerView visible to the user is larger than the viewport size that Gecko
  // knows about (and therefore larger than the clip rect). We could also just
  // clear the clip rect on aLayer entirely but this seems more precise.
  Maybe<ParentLayerIntRect> rootClipRect = aLayer->AsLayerComposite()->GetShadowClipRect();
  if (rootClipRect && aFixedLayerMargins != ScreenMargin()) {
#ifndef MOZ_WIDGET_ANDROID
    // We should never enter here on anything other than Fennec, since
    // aFixedLayerMargins should be empty everywhere else.
    MOZ_ASSERT(false);
#endif
    ParentLayerRect rect(rootClipRect.value());
    rect.Deflate(ViewAs<ParentLayerPixel>(aFixedLayerMargins,
      PixelCastJustification::ScreenIsParentLayerForRoot));
    aLayer->AsLayerComposite()->SetShadowClipRect(Some(RoundedOut(rect)));
  }
}

#ifdef MOZ_WIDGET_ANDROID
static void
MoveScrollbarForLayerMargin(Layer* aRoot, FrameMetrics::ViewID aRootScrollId,
                            const ScreenMargin& aFixedLayerMargins)
{
  // See bug 1223928 comment 9 - once we can detect the RCD with just the
  // isRootContent flag on the metrics, we can probably move this code into
  // ApplyAsyncTransformToScrollbar rather than having it as a separate
  // adjustment on the layer tree.
  Layer* scrollbar = BreadthFirstSearch<ReverseIterator>(aRoot,
    [aRootScrollId](Layer* aNode) {
      return (aNode->GetScrollbarDirection() == Layer::HORIZONTAL &&
              aNode->GetScrollbarTargetContainerId() == aRootScrollId);
    });
  if (scrollbar) {
    // Shift the horizontal scrollbar down into the new space exposed by the
    // dynamic toolbar hiding. Technically we should also scale the vertical
    // scrollbar a bit to expand into the new space but it's not as noticeable
    // and it would add a lot more complexity, so we're going with the "it's not
    // worth it" justification.
    TranslateShadowLayer(scrollbar, ParentLayerPoint(0, -aFixedLayerMargins.bottom), true, nullptr);
    if (scrollbar->GetParent()) {
      // The layer that has the HORIZONTAL direction sits inside another
      // ContainerLayer. This ContainerLayer also has a clip rect that causes
      // the scrollbar to get clipped. We need to expand that clip rect to
      // prevent that from happening. This is kind of ugly in that we're
      // assuming a particular layer tree structure but short of adding more
      // flags to the layer there doesn't appear to be a good way to do this.
      ExpandRootClipRect(scrollbar->GetParent(), aFixedLayerMargins);
    }
  }
}
#endif

bool
AsyncCompositionManager::ApplyAsyncContentTransformToTree(Layer *aLayer,
                                                          bool* aOutFoundRoot)
{
  bool appliedTransform = false;
  std::stack<Maybe<ParentLayerIntRect>> stackDeferredClips;

  // Maps layers to their ClipParts. The parts are not stored individually
  // on the layer, but during AlignFixedAndStickyLayers we need access to
  // the individual parts for descendant layers.
  ClipPartsCache clipPartsCache;

  ForEachNode<ForwardIterator>(
      aLayer,
      [&stackDeferredClips] (Layer* layer)
      {
        stackDeferredClips.push(Maybe<ParentLayerIntRect>());
      },
      [this, &aOutFoundRoot, &stackDeferredClips, &appliedTransform, &clipPartsCache] (Layer* layer)
      {
        Maybe<ParentLayerIntRect> clipDeferredFromChildren = stackDeferredClips.top();
        stackDeferredClips.pop();
        LayerToParentLayerMatrix4x4 oldTransform = layer->GetTransformTyped() *
            AsyncTransformMatrix();

        AsyncTransformComponentMatrix combinedAsyncTransform;
        bool hasAsyncTransform = false;
        ScreenMargin fixedLayerMargins;

        // Each layer has multiple clips:
        //  - Its local clip, which is fixed to the layer contents, i.e. it moves
        //    with those async transforms which the layer contents move with.
        //  - Its scrolled clip, which moves with all async transforms.
        //  - For each ScrollMetadata on the layer, a scroll clip. This includes
        //    the composition bounds and any other clips induced by layout. This
        //    moves with async transforms from ScrollMetadatas above it.
        // In this function, these clips are combined into two shadow clip parts:
        //  - The fixed clip, which consists of the local clip only, initially
        //    transformed by all async transforms.
        //  - The scrolled clip, which consists of the other clips, transformed by
        //    the appropriate transforms.
        // These two parts are kept separate for now, because for fixed layers, we
        // need to adjust the fixed clip (to cancel out some async transforms).
        // The parts are kept in a cache which is cleared at the beginning of every
        // composite.
        // The final shadow clip for the layer is the intersection of the (possibly
        // adjusted) fixed clip and the scrolled clip.
        ClipParts& clipParts = clipPartsCache[layer];
        clipParts.mFixedClip = layer->GetClipRect();
        clipParts.mScrolledClip = layer->GetScrolledClipRect();

        // If we are a perspective transform ContainerLayer, apply the clip deferred
        // from our child (if there is any) before we iterate over our frame metrics,
        // because this clip is subject to all async transforms of this layer.
        // Since this clip came from the a scroll clip on the child, it becomes part
        // of our scrolled clip.
        clipParts.mScrolledClip = IntersectMaybeRects(
            clipDeferredFromChildren, clipParts.mScrolledClip);

        // The transform of a mask layer is relative to the masked layer's parent
        // layer. So whenever we apply an async transform to a layer, we need to
        // apply that same transform to the layer's own mask layer.
        // A layer can also have "ancestor" mask layers for any rounded clips from
        // its ancestor scroll frames. A scroll frame mask layer only needs to be
        // async transformed for async scrolls of this scroll frame's ancestor
        // scroll frames, not for async scrolls of this scroll frame itself.
        // In the loop below, we iterate over scroll frames from inside to outside.
        // At each iteration, this array contains the layer's ancestor mask layers
        // of all scroll frames inside the current one.
        nsTArray<Layer*> ancestorMaskLayers;

        // The layer's scrolled clip can have an ancestor mask layer as well,
        // which is moved by all async scrolls on this layer.
        if (const Maybe<LayerClip>& scrolledClip = layer->GetScrolledClip()) {
          if (scrolledClip->GetMaskLayerIndex()) {
            ancestorMaskLayers.AppendElement(
                layer->GetAncestorMaskLayerAt(*scrolledClip->GetMaskLayerIndex()));
          }
        }

        for (uint32_t i = 0; i < layer->GetScrollMetadataCount(); i++) {
          AsyncPanZoomController* controller = layer->GetAsyncPanZoomController(i);
          if (!controller) {
            continue;
          }

          hasAsyncTransform = true;

          AsyncTransform asyncTransformWithoutOverscroll =
              controller->GetCurrentAsyncTransform(AsyncPanZoomController::RESPECT_FORCE_DISABLE);
          AsyncTransformComponentMatrix overscrollTransform =
              controller->GetOverscrollTransform(AsyncPanZoomController::RESPECT_FORCE_DISABLE);
          AsyncTransformComponentMatrix asyncTransform =
              AsyncTransformComponentMatrix(asyncTransformWithoutOverscroll)
            * overscrollTransform;

          if (!layer->IsScrollInfoLayer()) {
            controller->MarkAsyncTransformAppliedToContent();
          }

          const ScrollMetadata& scrollMetadata = layer->GetScrollMetadata(i);
          const FrameMetrics& metrics = scrollMetadata.GetMetrics();

#if defined(MOZ_WIDGET_ANDROID)
          // If we find a metrics which is the root content doc, use that. If not, use
          // the root layer. Since this function recurses on children first we should
          // only end up using the root layer if the entire tree was devoid of a
          // root content metrics. This is a temporary solution; in the long term we
          // should not need the root content metrics at all. See bug 1201529 comment
          // 6 for details.
          if (!(*aOutFoundRoot)) {
            *aOutFoundRoot = metrics.IsRootContent() ||       /* RCD */
                  (layer->GetParent() == nullptr &&          /* rootmost metrics */
                   i + 1 >= layer->GetScrollMetadataCount());
            if (*aOutFoundRoot) {
              mRootScrollableId = metrics.GetScrollId();
              CSSToLayerScale geckoZoom = metrics.LayersPixelsPerCSSPixel().ToScaleFactor();
              if (mIsFirstPaint) {
                LayerIntPoint scrollOffsetLayerPixels = RoundedToInt(metrics.GetScrollOffset() * geckoZoom);
                mContentRect = metrics.GetScrollableRect();
                SetFirstPaintViewport(scrollOffsetLayerPixels,
                                      geckoZoom,
                                      mContentRect);
              } else {
                ParentLayerPoint scrollOffset = controller->GetCurrentAsyncScrollOffset(
                    AsyncPanZoomController::RESPECT_FORCE_DISABLE);
                // Compute the painted displayport in document-relative CSS pixels.
                CSSRect displayPort(metrics.GetCriticalDisplayPort().IsEmpty() ?
                    metrics.GetDisplayPort() :
                    metrics.GetCriticalDisplayPort());
                displayPort += metrics.GetScrollOffset();
                SyncFrameMetrics(scrollOffset,
                    geckoZoom * asyncTransformWithoutOverscroll.mScale,
                    metrics.GetScrollableRect(), displayPort, geckoZoom, mLayersUpdated,
                    mPaintSyncId, fixedLayerMargins);
                mFixedLayerMargins = fixedLayerMargins;
                mLayersUpdated = false;
                mPaintSyncId = 0;
              }
              mIsFirstPaint = false;
            }
          }
#else
          // Non-Android platforms still care about this flag being cleared after
          // the first call to TransformShadowTree().
          mIsFirstPaint = false;
#endif

          // Transform the current local clips by this APZC's async transform. If we're
          // using containerful scrolling, then the clip is not part of the scrolled
          // frame and should not be transformed.
          if (!scrollMetadata.UsesContainerScrolling()) {
            MOZ_ASSERT(asyncTransform.Is2D());
            if (clipParts.mFixedClip) {
              *clipParts.mFixedClip = TransformBy(asyncTransform, *clipParts.mFixedClip);
            }
            if (clipParts.mScrolledClip) {
              *clipParts.mScrolledClip = TransformBy(asyncTransform, *clipParts.mScrolledClip);
            }
          }
          // Note: we don't set the layer's shadow clip rect property yet;
          // AlignFixedAndStickyLayers will use the clip parts from the clip parts
          // cache.

          combinedAsyncTransform *= asyncTransform;

          // For the purpose of aligning fixed and sticky layers, we disregard
          // the overscroll transform as well as any OMTA transform when computing the
          // 'aCurrentTransformForRoot' parameter. This ensures that the overscroll
          // and OMTA transforms are not unapplied, and therefore that the visual
          // effects apply to fixed and sticky layers. We do this by using
          // GetTransform() as the base transform rather than GetLocalTransform(),
          // which would include those factors.
          LayerToParentLayerMatrix4x4 transformWithoutOverscrollOrOmta =
              layer->GetTransformTyped()
            * CompleteAsyncTransform(
                AdjustForClip(asyncTransformWithoutOverscroll, layer));

          AlignFixedAndStickyLayers(layer, layer, metrics.GetScrollId(), oldTransform,
                                    transformWithoutOverscrollOrOmta, fixedLayerMargins,
                                    &clipPartsCache);

          // Combine the local clip with the ancestor scrollframe clip. This is not
          // included in the async transform above, since the ancestor clip should not
          // move with this APZC.
          if (scrollMetadata.HasScrollClip()) {
            ParentLayerIntRect clip = scrollMetadata.ScrollClip().GetClipRect();
            if (layer->GetParent() && layer->GetParent()->GetTransformIsPerspective()) {
              // If our parent layer has a perspective transform, we want to apply
              // our scroll clip to it instead of to this layer (see bug 1168263).
              // A layer with a perspective transform shouldn't have multiple
              // children with FrameMetrics, nor a child with multiple FrameMetrics.
              // (A child with multiple FrameMetrics would mean that there's *another*
              // scrollable element between the one with the CSS perspective and the
              // transformed element. But you'd have to use preserve-3d on the inner
              // scrollable element in order to have the perspective apply to the
              // transformed child, and preserve-3d is not supported on scrollable
              // elements, so this case can't occur.)
              MOZ_ASSERT(!stackDeferredClips.top());
              stackDeferredClips.top().emplace(clip);
            } else {
              clipParts.mScrolledClip = IntersectMaybeRects(Some(clip),
                  clipParts.mScrolledClip);
            }
          }

          // Do the same for the ancestor mask layers: ancestorMaskLayers contains
          // the ancestor mask layers for scroll frames *inside* the current scroll
          // frame, so these are the ones we need to shift by our async transform.
          for (Layer* ancestorMaskLayer : ancestorMaskLayers) {
            SetShadowTransform(ancestorMaskLayer,
                ancestorMaskLayer->GetLocalTransformTyped() * asyncTransform);
          }

          // Append the ancestor mask layer for this scroll frame to ancestorMaskLayers.
          if (scrollMetadata.HasScrollClip()) {
            const LayerClip& scrollClip = scrollMetadata.ScrollClip();
            if (scrollClip.GetMaskLayerIndex()) {
              size_t maskLayerIndex = scrollClip.GetMaskLayerIndex().value();
              Layer* ancestorMaskLayer = layer->GetAncestorMaskLayerAt(maskLayerIndex);
              ancestorMaskLayers.AppendElement(ancestorMaskLayer);
            }
          }
        }

        bool clipChanged = (hasAsyncTransform || clipDeferredFromChildren ||
                            layer->GetScrolledClipRect());
        if (clipChanged) {
          // Intersect the two clip parts and apply them to the layer.
          // During ApplyAsyncContentTransformTree on an ancestor layer,
          // AlignFixedAndStickyLayers may overwrite this with a new clip it
          // computes from the clip parts, but if that doesn't happen, this
          // is the layer's final clip rect.
          layer->AsLayerComposite()->SetShadowClipRect(clipParts.Intersect());
        }

        if (hasAsyncTransform) {
          // Apply the APZ transform on top of GetLocalTransform() here (rather than
          // GetTransform()) in case the OMTA code in SampleAnimations already set a
          // shadow transform; in that case we want to apply ours on top of that one
          // rather than clobber it.
          SetShadowTransform(layer,
              layer->GetLocalTransformTyped()
            * AdjustForClip(combinedAsyncTransform, layer));

          // Do the same for the layer's own mask layer, if it has one.
          if (Layer* maskLayer = layer->GetMaskLayer()) {
            SetShadowTransform(maskLayer,
                maskLayer->GetLocalTransformTyped() * combinedAsyncTransform);
          }

          appliedTransform = true;
        }

        ExpandRootClipRect(layer, fixedLayerMargins);

        if (layer->GetScrollbarDirection() != Layer::NONE) {
          ApplyAsyncTransformToScrollbar(layer);
        }
      });

  return appliedTransform;
}

static bool
LayerIsScrollbarTarget(const LayerMetricsWrapper& aTarget, Layer* aScrollbar)
{
  AsyncPanZoomController* apzc = aTarget.GetApzc();
  if (!apzc) {
    return false;
  }
  const FrameMetrics& metrics = aTarget.Metrics();
  if (metrics.GetScrollId() != aScrollbar->GetScrollbarTargetContainerId()) {
    return false;
  }
  return !aTarget.IsScrollInfoLayer();
}

static void
ApplyAsyncTransformToScrollbarForContent(Layer* aScrollbar,
                                         const LayerMetricsWrapper& aContent,
                                         bool aScrollbarIsDescendant)
{
  // We only apply the transform if the scroll-target layer has non-container
  // children (i.e. when it has some possibly-visible content). This is to
  // avoid moving scroll-bars in the situation that only a scroll information
  // layer has been built for a scroll frame, as this would result in a
  // disparity between scrollbars and visible content.
  if (aContent.IsScrollInfoLayer()) {
    return;
  }

  const FrameMetrics& metrics = aContent.Metrics();
  AsyncPanZoomController* apzc = aContent.GetApzc();
  MOZ_RELEASE_ASSERT(apzc);

  AsyncTransformComponentMatrix asyncTransform =
    apzc->GetCurrentAsyncTransform(AsyncPanZoomController::RESPECT_FORCE_DISABLE);

  // |asyncTransform| represents the amount by which we have scrolled and
  // zoomed since the last paint. Because the scrollbar was sized and positioned based
  // on the painted content, we need to adjust it based on asyncTransform so that
  // it reflects what the user is actually seeing now.
  AsyncTransformComponentMatrix scrollbarTransform;
  if (aScrollbar->GetScrollbarDirection() == Layer::VERTICAL) {
    const ParentLayerCoord asyncScrollY = asyncTransform._42;
    const float asyncZoomY = asyncTransform._22;

    // The scroll thumb needs to be scaled in the direction of scrolling by the
    // inverse of the async zoom. This is because zooming in decreases the
    // fraction of the whole srollable rect that is in view.
    const float yScale = 1.f / asyncZoomY;

    // Note: |metrics.GetZoom()| doesn't yet include the async zoom.
    const CSSToParentLayerScale effectiveZoom(metrics.GetZoom().yScale * asyncZoomY);

    // Here we convert the scrollbar thumb ratio into a true unitless ratio by
    // dividing out the conversion factor from the scrollframe's parent's space
    // to the scrollframe's space.
    const float ratio = aScrollbar->GetScrollbarThumbRatio() /
        (metrics.GetPresShellResolution() * asyncZoomY);
    // The scroll thumb needs to be translated in opposite direction of the
    // async scroll. This is because scrolling down, which translates the layer
    // content up, should result in moving the scroll thumb down.
    ParentLayerCoord yTranslation = -asyncScrollY * ratio;

    // The scroll thumb additionally needs to be translated to compensate for
    // the scale applied above. The origin with respect to which the scale is
    // applied is the origin of the entire scrollbar, rather than the origin of
    // the scroll thumb (meaning, for a vertical scrollbar it's at the top of
    // the composition bounds). This means that empty space above the thumb
    // is scaled too, effectively translating the thumb. We undo that
    // translation here.
    // (One can think of the adjustment being done to the translation here as
    // a change of basis. We have a method to help with that,
    // Matrix4x4::ChangeBasis(), but it wouldn't necessarily make the code
    // cleaner in this case).
    const CSSCoord thumbOrigin = (metrics.GetScrollOffset().y * ratio);
    const CSSCoord thumbOriginScaled = thumbOrigin * yScale;
    const CSSCoord thumbOriginDelta = thumbOriginScaled - thumbOrigin;
    const ParentLayerCoord thumbOriginDeltaPL = thumbOriginDelta * effectiveZoom;
    yTranslation -= thumbOriginDeltaPL;

    if (metrics.IsRootContent()) {
      // Scrollbar for the root are painted at the same resolution as the
      // content. Since the coordinate space we apply this transform in includes
      // the resolution, we need to adjust for it as well here. Note that in
      // another metrics.IsRootContent() hunk below we apply a
      // resolution-cancelling transform which ensures the scroll thumb isn't
      // actually rendered at a larger scale.
      yTranslation *= metrics.GetPresShellResolution();
    }

    scrollbarTransform.PostScale(1.f, yScale, 1.f);
    scrollbarTransform.PostTranslate(0, yTranslation, 0);
  }
  if (aScrollbar->GetScrollbarDirection() == Layer::HORIZONTAL) {
    // See detailed comments under the VERTICAL case.

    const ParentLayerCoord asyncScrollX = asyncTransform._41;
    const float asyncZoomX = asyncTransform._11;

    const float xScale = 1.f / asyncZoomX;

    const CSSToParentLayerScale effectiveZoom(metrics.GetZoom().xScale * asyncZoomX);

    const float ratio = aScrollbar->GetScrollbarThumbRatio() /
        (metrics.GetPresShellResolution() * asyncZoomX);
    ParentLayerCoord xTranslation = -asyncScrollX * ratio;

    const CSSCoord thumbOrigin = (metrics.GetScrollOffset().x * ratio);
    const CSSCoord thumbOriginScaled = thumbOrigin * xScale;
    const CSSCoord thumbOriginDelta = thumbOriginScaled - thumbOrigin;
    const ParentLayerCoord thumbOriginDeltaPL = thumbOriginDelta * effectiveZoom;
    xTranslation -= thumbOriginDeltaPL;

    if (metrics.IsRootContent()) {
      xTranslation *= metrics.GetPresShellResolution();
    }

    scrollbarTransform.PostScale(xScale, 1.f, 1.f);
    scrollbarTransform.PostTranslate(xTranslation, 0, 0);
  }

  LayerToParentLayerMatrix4x4 transform =
      aScrollbar->GetLocalTransformTyped() * scrollbarTransform;

  AsyncTransformComponentMatrix compensation;
  // If the scrollbar layer is for the root then the content's resolution
  // applies to the scrollbar as well. Since we don't actually want the scroll
  // thumb's size to vary with the zoom (other than its length reflecting the
  // fraction of the scrollable length that's in view, which is taken care of
  // above), we apply a transform to cancel out this resolution.
  if (metrics.IsRootContent()) {
    compensation =
        AsyncTransformComponentMatrix::Scaling(
            metrics.GetPresShellResolution(),
            metrics.GetPresShellResolution(),
            1.0f).Inverse();
  }
  // If the scrollbar layer is a child of the content it is a scrollbar for,
  // then we need to adjust for any async transform (including an overscroll
  // transform) on the content. This needs to be cancelled out because layout
  // positions and sizes the scrollbar on the assumption that there is no async
  // transform, and without this adjustment the scrollbar will end up in the
  // wrong place.
  //
  // Note that since the async transform is applied on top of the content's
  // regular transform, we need to make sure to unapply the async transform in
  // the same coordinate space. This requires applying the content transform
  // and then unapplying it after unapplying the async transform.
  if (aScrollbarIsDescendant) {
    AsyncTransformComponentMatrix overscroll =
        apzc->GetOverscrollTransform(AsyncPanZoomController::RESPECT_FORCE_DISABLE);
    Matrix4x4 asyncUntransform = (asyncTransform * overscroll).Inverse().ToUnknownMatrix();
    Matrix4x4 contentTransform = aContent.GetTransform();
    Matrix4x4 contentUntransform = contentTransform.Inverse();

    AsyncTransformComponentMatrix asyncCompensation =
        ViewAs<AsyncTransformComponentMatrix>(
            contentTransform
          * asyncUntransform
          * contentUntransform);

    compensation = compensation * asyncCompensation;

    // We also need to make a corresponding change on the clip rect of all the
    // layers on the ancestor chain from the scrollbar layer up to but not
    // including the layer with the async transform. Otherwise the scrollbar
    // shifts but gets clipped and so appears to flicker.
    for (Layer* ancestor = aScrollbar; ancestor != aContent.GetLayer(); ancestor = ancestor->GetParent()) {
      TransformClipRect(ancestor, asyncCompensation);
    }
  }
  transform = transform * compensation;

  SetShadowTransform(aScrollbar, transform);
}

static LayerMetricsWrapper
FindScrolledLayerForScrollbar(Layer* aScrollbar, bool* aOutIsAncestor)
{
  // First check if the scrolled layer is an ancestor of the scrollbar layer.
  LayerMetricsWrapper root(aScrollbar->Manager()->GetRoot());
  LayerMetricsWrapper prevAncestor(aScrollbar);
  LayerMetricsWrapper scrolledLayer;

  for (LayerMetricsWrapper ancestor(aScrollbar); ancestor; ancestor = ancestor.GetParent()) {
    // Don't walk into remote layer trees; the scrollbar will always be in
    // the same layer space.
    if (ancestor.AsRefLayer()) {
      root = prevAncestor;
      break;
    }
    prevAncestor = ancestor;

    if (LayerIsScrollbarTarget(ancestor, aScrollbar)) {
      *aOutIsAncestor = true;
      return ancestor;
    }
  }

  // Search the entire layer space of the scrollbar.
  ForEachNode<ForwardIterator>(
      root,
      [&root, &scrolledLayer, &aScrollbar](LayerMetricsWrapper aLayerMetrics)
      {
        // Do not recurse into RefLayers, since our initial aSubtreeRoot is the
        // root (or RefLayer root) of a single layer space to search.
        if (root != aLayerMetrics && aLayerMetrics.AsRefLayer()) {
          return TraversalFlag::Skip;
        }
        if (LayerIsScrollbarTarget(aLayerMetrics, aScrollbar)) {
          scrolledLayer = aLayerMetrics;
          return TraversalFlag::Abort;
        }
        return TraversalFlag::Continue;
      }
  );
  return scrolledLayer;
}

void
AsyncCompositionManager::ApplyAsyncTransformToScrollbar(Layer* aLayer)
{
  // If this layer corresponds to a scrollbar, then there should be a layer that
  // is a previous sibling or a parent that has a matching ViewID on its FrameMetrics.
  // That is the content that this scrollbar is for. We pick up the transient
  // async transform from that layer and use it to update the scrollbar position.
  // Note that it is possible that the content layer is no longer there; in
  // this case we don't need to do anything because there can't be an async
  // transform on the content.
  bool isAncestor = false;
  const LayerMetricsWrapper& scrollTarget = FindScrolledLayerForScrollbar(aLayer, &isAncestor);
  if (scrollTarget) {
    ApplyAsyncTransformToScrollbarForContent(aLayer, scrollTarget, isAncestor);
  }
}

void
AsyncCompositionManager::GetFrameUniformity(FrameUniformityData* aOutData)
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  mLayerTransformRecorder.EndTest(aOutData);
}

bool
AsyncCompositionManager::TransformShadowTree(TimeStamp aCurrentFrame,
                                             TimeDuration aVsyncRate,
                                             TransformsToSkip aSkip)
{
  PROFILER_LABEL("AsyncCompositionManager", "TransformShadowTree",
    js::ProfileEntry::Category::GRAPHICS);

  Layer* root = mLayerManager->GetRoot();
  if (!root) {
    return false;
  }

  // First, compute and set the shadow transforms from OMT animations.
  // NB: we must sample animations *before* sampling pan/zoom
  // transforms.
  // Use a previous vsync time to make main thread animations and compositor
  // more in sync with each other.
  // On the initial frame we use aVsyncTimestamp here so the timestamp on the
  // second frame are the same as the initial frame, but it does not matter.
  bool wantNextFrame = SampleAnimations(root,
    !mPreviousFrameTimeStamp.IsNull() ?
      mPreviousFrameTimeStamp : aCurrentFrame);

  // Reset the previous time stamp if we don't already have any running
  // animations to avoid using the time which is far behind for newly
  // started animations.
  mPreviousFrameTimeStamp = wantNextFrame ? aCurrentFrame : TimeStamp();

  if (!(aSkip & TransformsToSkip::APZ)) {
    // FIXME/bug 775437: unify this interface with the ~native-fennec
    // derived code
    //
    // Attempt to apply an async content transform to any layer that has
    // an async pan zoom controller (which means that it is rendered
    // async using Gecko). If this fails, fall back to transforming the
    // primary scrollable layer.  "Failing" here means that we don't
    // find a frame that is async scrollable.  Note that the fallback
    // code also includes Fennec which is rendered async.  Fennec uses
    // its own platform-specific async rendering that is done partially
    // in Gecko and partially in Java.
    bool foundRoot = false;
    if (ApplyAsyncContentTransformToTree(root, &foundRoot)) {
#if defined(MOZ_WIDGET_ANDROID)
      MOZ_ASSERT(foundRoot);
      if (foundRoot && mFixedLayerMargins != ScreenMargin()) {
        MoveScrollbarForLayerMargin(root, mRootScrollableId, mFixedLayerMargins);
      }
#endif
    }

    // Advance APZ animations to the next expected vsync timestamp, if we can
    // get it.
    TimeStamp nextFrame = aCurrentFrame;

    MOZ_ASSERT(aVsyncRate != TimeDuration::Forever());
    if (aVsyncRate != TimeDuration::Forever()) {
      nextFrame += aVsyncRate;
    }

    wantNextFrame |= SampleAPZAnimations(LayerMetricsWrapper(root), nextFrame);
  }

  LayerComposite* rootComposite = root->AsLayerComposite();

  gfx::Matrix4x4 trans = rootComposite->GetShadowBaseTransform();
  trans *= gfx::Matrix4x4::From2D(mWorldTransform);
  rootComposite->SetShadowBaseTransform(trans);

  if (gfxPrefs::CollectScrollTransforms()) {
    RecordShadowTransforms(root);
  }

  return wantNextFrame;
}

void
AsyncCompositionManager::SetFirstPaintViewport(const LayerIntPoint& aOffset,
                                               const CSSToLayerScale& aZoom,
                                               const CSSRect& aCssPageRect)
{
#ifdef MOZ_WIDGET_ANDROID
  widget::AndroidCompositorWidget* widget =
      mLayerManager->GetCompositor()->GetWidget()->AsAndroid();
  if (!widget) {
    return;
  }
  widget->SetFirstPaintViewport(aOffset, aZoom, aCssPageRect);
#endif
}

void
AsyncCompositionManager::SyncFrameMetrics(const ParentLayerPoint& aScrollOffset,
                                          const CSSToParentLayerScale& aZoom,
                                          const CSSRect& aCssPageRect,
                                          const CSSRect& aDisplayPort,
                                          const CSSToLayerScale& aPaintedResolution,
                                          bool aLayersUpdated,
                                          int32_t aPaintSyncId,
                                          ScreenMargin& aFixedLayerMargins)
{
#ifdef MOZ_WIDGET_ANDROID
  widget::AndroidCompositorWidget* widget =
      mLayerManager->GetCompositor()->GetWidget()->AsAndroid();
  if (!widget) {
    return;
  }
  widget->SyncFrameMetrics(
      aScrollOffset, aZoom, aCssPageRect, aDisplayPort, aPaintedResolution,
      aLayersUpdated, aPaintSyncId, aFixedLayerMargins);
#endif
}

} // namespace layers
} // namespace mozilla
