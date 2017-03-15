/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_ASYNCCOMPOSITIONMANAGER_H
#define GFX_ASYNCCOMPOSITIONMANAGER_H

#include "Units.h"                      // for ScreenPoint, etc
#include "mozilla/layers/LayerManagerComposite.h"  // for LayerManagerComposite
#include "mozilla/Attributes.h"         // for final, etc
#include "mozilla/RefPtr.h"             // for RefCounted
#include "mozilla/TimeStamp.h"          // for TimeStamp
#include "mozilla/dom/ScreenOrientation.h"  // for ScreenOrientation
#include "mozilla/gfx/BasePoint.h"      // for BasePoint
#include "mozilla/gfx/Matrix.h"         // for Matrix4x4
#include "mozilla/layers/FrameUniformityData.h" // For FrameUniformityData
#include "mozilla/layers/LayersMessages.h"  // for TargetConfig
#include "mozilla/RefPtr.h"                   // for nsRefPtr
#include "nsISupportsImpl.h"            // for LayerManager::AddRef, etc

namespace mozilla {
namespace layers {

class AsyncPanZoomController;
class Layer;
class LayerManagerComposite;
class AutoResolveRefLayers;
class CompositorBridgeParent;

// Represents async transforms consisting of a scale and a translation.
struct AsyncTransform {
  explicit AsyncTransform(LayerToParentLayerScale aScale = LayerToParentLayerScale(),
                          ParentLayerPoint aTranslation = ParentLayerPoint())
    : mScale(aScale)
    , mTranslation(aTranslation)
  {}

  operator AsyncTransformComponentMatrix() const
  {
    return AsyncTransformComponentMatrix::Scaling(mScale.scale, mScale.scale, 1)
        .PostTranslate(mTranslation.x, mTranslation.y, 0);
  }

  bool operator==(const AsyncTransform& rhs) const {
    return mTranslation == rhs.mTranslation && mScale == rhs.mScale;
  }

  bool operator!=(const AsyncTransform& rhs) const {
    return !(*this == rhs);
  }

  LayerToParentLayerScale mScale;
  ParentLayerPoint mTranslation;
};

/**
 * Manage async composition effects. This class is only used with OMTC and only
 * lives on the compositor thread. It is a layer on top of the layer manager
 * (LayerManagerComposite) which deals with elements of composition which are
 * usually dealt with by dom or layout when main thread rendering, but which can
 * short circuit that stuff to directly affect layers as they are composited,
 * for example, off-main thread animation, async video, async pan/zoom.
 */
class AsyncCompositionManager final
{
  friend class AutoResolveRefLayers;
  ~AsyncCompositionManager();

public:
  NS_INLINE_DECL_REFCOUNTING(AsyncCompositionManager)

  explicit AsyncCompositionManager(LayerManagerComposite* aManager);

  /**
   * This forces the is-first-paint flag to true. This is intended to
   * be called by the widget code when it loses its viewport information
   * (or for whatever reason wants to refresh the viewport information).
   * The information refresh happens because the compositor will call
   * SetFirstPaintViewport on the next frame of composition.
   */
  void ForceIsFirstPaint() { mIsFirstPaint = true; }

  // Sample transforms for layer trees.  Return true to request
  // another animation frame.
  enum class TransformsToSkip : uint8_t { NoneOfThem = 0, APZ = 1 };
  bool TransformShadowTree(TimeStamp aCurrentFrame,
                           TimeDuration aVsyncRate,
                           TransformsToSkip aSkip = TransformsToSkip::NoneOfThem);

  // Calculates the correct rotation and applies the transform to
  // our layer manager
  void ComputeRotation();

  // Call after updating our layer tree.
  void Updated(bool isFirstPaint, const TargetConfig& aTargetConfig,
               int32_t aPaintSyncId)
  {
    mIsFirstPaint |= isFirstPaint;
    mLayersUpdated = true;
    mTargetConfig = aTargetConfig;
    if (aPaintSyncId) {
      mPaintSyncId = aPaintSyncId;
    }
  }

  bool RequiresReorientation(mozilla::dom::ScreenOrientationInternal aOrientation) const
  {
    return mTargetConfig.orientation() != aOrientation;
  }

  // True if the underlying layer tree is ready to be composited.
  bool ReadyForCompose() { return mReadyForCompose; }

  // Returns true if the next composition will be the first for a
  // particular document.
  bool IsFirstPaint() { return mIsFirstPaint; }

  // GetFrameUniformity will return the frame uniformity for each layer attached to an APZ
  // from the recorded data in RecordShadowTransform
  void GetFrameUniformity(FrameUniformityData* aFrameUniformityData);

  // Stores the clip rect of a layer in two parts: a fixed part and a scrolled
  // part. When a layer is fixed, the clip needs to be adjusted to account for
  // async transforms. Only the fixed part needs to be adjusted, so we need
  // to store the two parts separately.
  struct ClipParts {
    Maybe<ParentLayerIntRect> mFixedClip;
    Maybe<ParentLayerIntRect> mScrolledClip;

    Maybe<ParentLayerIntRect> Intersect() const {
      return IntersectMaybeRects(mFixedClip, mScrolledClip);
    }
  };

  typedef std::map<Layer*, ClipParts> ClipPartsCache;
private:
  // Return true if an AsyncPanZoomController content transform was
  // applied for |aLayer|. |*aOutFoundRoot| is set to true on Android only, if
  // one of the metrics on one of the layers was determined to be the "root"
  // and its state was synced to the Java front-end. |aOutFoundRoot| must be
  // non-null.
  bool ApplyAsyncContentTransformToTree(Layer* aLayer,
                                        bool* aOutFoundRoot);
  /**
   * Update the shadow transform for aLayer assuming that is a scrollbar,
   * so that it stays in sync with the content that is being scrolled by APZ.
   */
  void ApplyAsyncTransformToScrollbar(Layer* aLayer);

  void SetFirstPaintViewport(const LayerIntPoint& aOffset,
                             const CSSToLayerScale& aZoom,
                             const CSSRect& aCssPageRect);
  void SyncFrameMetrics(const ParentLayerPoint& aScrollOffset,
                        const CSSToParentLayerScale& aZoom,
                        const CSSRect& aCssPageRect,
                        const CSSRect& aDisplayPort,
                        const CSSToLayerScale& aPaintedResolution,
                        bool aLayersUpdated,
                        int32_t aPaintSyncId,
                        ScreenMargin& aFixedLayerMargins);

  /**
   * Adds a translation to the transform of any fixed position (whose parent
   * layer is not fixed) or sticky position layer descendant of
   * |aTransformedSubtreeRoot|. The translation is chosen so that the layer's
   * anchor point relative to |aTransformedSubtreeRoot|'s parent layer is the same
   * as it was when |aTransformedSubtreeRoot|'s GetLocalTransform() was
   * |aPreviousTransformForRoot|. |aCurrentTransformForRoot| is
   * |aTransformedSubtreeRoot|'s current GetLocalTransform() modulo any
   * overscroll-related transform, which we don't want to adjust for.
   * For sticky position layers, the translation is further intersected with
   * the layer's sticky scroll ranges.
   * This function will also adjust layers so that the given content document
   * fixed position margins will be respected during asynchronous panning and
   * zooming.
   * |aTransformScrollId| is the scroll id of the scroll frame that scrolls
   * |aTransformedSubtreeRoot|.
   * |aClipPartsCache| optionally maps layers to separate fixed and scrolled
   * clips, so we can only adjust the fixed portion.
   * This function has a recursive implementation; aStartTraversalAt specifies
   * where to start the current recursion of the traversal. For the initial
   * call, it should be the same as aTrasnformedSubtreeRoot.
   */
  void AlignFixedAndStickyLayers(Layer* aTransformedSubtreeRoot,
                                 Layer* aStartTraversalAt,
                                 FrameMetrics::ViewID aTransformScrollId,
                                 const LayerToParentLayerMatrix4x4& aPreviousTransformForRoot,
                                 const LayerToParentLayerMatrix4x4& aCurrentTransformForRoot,
                                 const ScreenMargin& aFixedLayerMargins,
                                 ClipPartsCache* aClipPartsCache);

  /**
   * DRAWING PHASE ONLY
   *
   * For reach RefLayer in our layer tree, look up its referent and connect it
   * to the layer tree, if found.
   * aHasRemoteContent - indicates if the layer tree contains a remote reflayer.
   *  May be null.
   * aResolvePlugins - incoming value indicates if plugin windows should be
   *  updated through a call on aCompositor's UpdatePluginWindowState. Applies
   *  to linux and windows only, may be null. On return value indicates
   *  if any updates occured.
   */
  void ResolveRefLayers(CompositorBridgeParent* aCompositor, bool* aHasRemoteContent,
                        bool* aResolvePlugins);

  /**
   * Detaches all referents resolved by ResolveRefLayers.
   * Assumes that mLayerManager->GetRoot() and mTargetConfig have not changed
   * since ResolveRefLayers was called.
   */
  void DetachRefLayers();

  // Records the shadow transforms for the tree of layers rooted at the given layer
  void RecordShadowTransforms(Layer* aLayer);

  TargetConfig mTargetConfig;
  CSSRect mContentRect;

  RefPtr<LayerManagerComposite> mLayerManager;
  // When this flag is set, the next composition will be the first for a
  // particular document (i.e. the document displayed on the screen will change).
  // This happens when loading a new page or switching tabs. We notify the
  // front-end (e.g. Java on Android) about this so that it take the new page
  // size and zoom into account when providing us with the next view transform.
  bool mIsFirstPaint;

  // This flag is set during a layers update, so that the first composition
  // after a layers update has it set. It is cleared after that first composition.
  bool mLayersUpdated;

  int32_t mPaintSyncId;

  bool mReadyForCompose;

  gfx::Matrix mWorldTransform;
  LayerTransformRecorder mLayerTransformRecorder;

  TimeStamp mPreviousFrameTimeStamp;

#ifdef MOZ_WIDGET_ANDROID
  // The following two fields are only needed on Fennec with C++ APZ, because
  // then we need to reposition the gecko scrollbar to deal with the
  // dynamic toolbar shifting content around.
  FrameMetrics::ViewID mRootScrollableId;
  ScreenMargin mFixedLayerMargins;
#endif
};

MOZ_MAKE_ENUM_CLASS_BITWISE_OPERATORS(AsyncCompositionManager::TransformsToSkip)

class MOZ_STACK_CLASS AutoResolveRefLayers {
public:
  explicit AutoResolveRefLayers(AsyncCompositionManager* aManager,
                                CompositorBridgeParent* aCompositor = nullptr,
                                bool* aHasRemoteContent = nullptr,
                                bool* aResolvePlugins = nullptr) :
    mManager(aManager)
  {
    if (mManager) {
      mManager->ResolveRefLayers(aCompositor, aHasRemoteContent, aResolvePlugins);
    }
  }

  ~AutoResolveRefLayers()
  {
    if (mManager) {
      mManager->DetachRefLayers();
    }
  }

private:
  AsyncCompositionManager* mManager;

  AutoResolveRefLayers(const AutoResolveRefLayers&) = delete;
  AutoResolveRefLayers& operator=(const AutoResolveRefLayers&) = delete;
};

} // namespace layers
} // namespace mozilla

#endif
