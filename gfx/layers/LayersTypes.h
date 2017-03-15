/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_LAYERSTYPES_H
#define GFX_LAYERSTYPES_H

#include <stdint.h>                     // for uint32_t

#include "Units.h"
#include "mozilla/gfx/Point.h"          // for IntPoint
#include "mozilla/TypedEnumBits.h"
#include "nsRegion.h"

#include <stdio.h>            // FILE
#include "mozilla/Logging.h"            // for PR_LOG

#ifndef MOZ_LAYERS_HAVE_LOG
#  define MOZ_LAYERS_HAVE_LOG
#endif
#define MOZ_LAYERS_LOG(_args)                             \
  MOZ_LOG(LayerManager::GetLog(), LogLevel::Debug, _args)
#define MOZ_LAYERS_LOG_IF_SHADOWABLE(layer, _args)         \
  do { if (layer->AsShadowableLayer()) { MOZ_LOG(LayerManager::GetLog(), LogLevel::Debug, _args); } } while (0)

#define INVALID_OVERLAY -1

namespace android {
class MOZ_EXPORT GraphicBuffer;
} // namespace android

namespace mozilla {
namespace layers {

class TextureHost;

#undef NONE
#undef OPAQUE

enum class LayersBackend : int8_t {
  LAYERS_NONE = 0,
  LAYERS_BASIC,
  LAYERS_OPENGL,
  LAYERS_D3D9,
  LAYERS_D3D11,
  LAYERS_CLIENT,
  LAYERS_LAST
};

enum class BufferMode : int8_t {
  BUFFER_NONE,
  BUFFERED
};

enum class DrawRegionClip : int8_t {
  DRAW,
  NONE
};

enum class SurfaceMode : int8_t {
  SURFACE_NONE = 0,
  SURFACE_OPAQUE,
  SURFACE_SINGLE_CHANNEL_ALPHA,
  SURFACE_COMPONENT_ALPHA
};

// LayerRenderState for Composer2D
// We currently only support Composer2D using gralloc. If we want to be backed
// by other surfaces we will need a more generic LayerRenderState.
enum class LayerRenderStateFlags : int8_t {
  LAYER_RENDER_STATE_DEFAULT = 0,
  ORIGIN_BOTTOM_LEFT = 1 << 0,
  BUFFER_ROTATION = 1 << 1,
  // Notify Composer2D to swap the RB pixels of gralloc buffer
  FORMAT_RB_SWAP = 1 << 2,
  // We record opaqueness here alongside the actual surface we're going to
  // render. This avoids confusion when a layer might return different kinds
  // of surfaces over time (e.g. video frames).
  OPAQUE = 1 << 3
};
MOZ_MAKE_ENUM_CLASS_BITWISE_OPERATORS(LayerRenderStateFlags)

struct LayerRenderState {
  // Constructors and destructor are defined in LayersTypes.cpp so we don't
  // have to pull in a definition for GraphicBuffer.h here. In KK at least,
  // that results in nasty pollution such as libui's hardware.h #defining
  // 'version_major' and 'version_minor' which conflict with Theora's codec.c...
  LayerRenderState();
  LayerRenderState(const LayerRenderState& aOther);
  ~LayerRenderState();

  void SetOffset(const nsIntPoint& aOffset)
  {
    mOffset = aOffset;
    mHasOwnOffset = true;
  }

  // see LayerRenderStateFlags
  LayerRenderStateFlags mFlags;
  // true if mOffset is applicable
  bool mHasOwnOffset;
  // the location of the layer's origin on mSurface
  nsIntPoint mOffset;
};

enum class ScaleMode : int8_t {
  SCALE_NONE,
  STRETCH,
  SENTINEL
// Unimplemented - PRESERVE_ASPECT_RATIO_CONTAIN
};

struct EventRegions {
  // The hit region for a layer contains all areas on the layer that are
  // sensitive to events. This region is an over-approximation and may
  // contain regions that are not actually sensitive, but any such regions
  // will be included in the mDispatchToContentHitRegion.
  nsIntRegion mHitRegion;
  // The mDispatchToContentHitRegion for a layer contains all areas for
  // which the main-thread must be consulted before responding to events.
  // This region will be a subregion of mHitRegion.
  nsIntRegion mDispatchToContentHitRegion;

  // The following regions represent the touch-action areas of this layer.
  // All of these regions are approximations to the true region, but any
  // variance between the approximation and the true region is guaranteed
  // to be included in the mDispatchToContentHitRegion.
  nsIntRegion mNoActionRegion;
  nsIntRegion mHorizontalPanRegion;
  nsIntRegion mVerticalPanRegion;

  EventRegions()
  {
  }

  explicit EventRegions(nsIntRegion aHitRegion)
    : mHitRegion(aHitRegion)
  {
  }

  bool operator==(const EventRegions& aRegions) const
  {
    return mHitRegion == aRegions.mHitRegion &&
           mDispatchToContentHitRegion == aRegions.mDispatchToContentHitRegion &&
           mNoActionRegion == aRegions.mNoActionRegion &&
           mHorizontalPanRegion == aRegions.mHorizontalPanRegion &&
           mVerticalPanRegion == aRegions.mVerticalPanRegion;
  }
  bool operator!=(const EventRegions& aRegions) const
  {
    return !(*this == aRegions);
  }

  void ApplyTranslationAndScale(float aXTrans, float aYTrans, float aXScale, float aYScale)
  {
    mHitRegion.ScaleRoundOut(aXScale, aYScale);
    mDispatchToContentHitRegion.ScaleRoundOut(aXScale, aYScale);
    mNoActionRegion.ScaleRoundOut(aXScale, aYScale);
    mHorizontalPanRegion.ScaleRoundOut(aXScale, aYScale);
    mVerticalPanRegion.ScaleRoundOut(aXScale, aYScale);

    mHitRegion.MoveBy(aXTrans, aYTrans);
    mDispatchToContentHitRegion.MoveBy(aXTrans, aYTrans);
    mNoActionRegion.MoveBy(aXTrans, aYTrans);
    mHorizontalPanRegion.MoveBy(aXTrans, aYTrans);
    mVerticalPanRegion.MoveBy(aXTrans, aYTrans);
  }

  void Transform(const gfx::Matrix4x4& aTransform)
  {
    mHitRegion.Transform(aTransform);
    mDispatchToContentHitRegion.Transform(aTransform);
    mNoActionRegion.Transform(aTransform);
    mHorizontalPanRegion.Transform(aTransform);
    mVerticalPanRegion.Transform(aTransform);
  }

  bool IsEmpty() const
  {
    return mHitRegion.IsEmpty()
        && mDispatchToContentHitRegion.IsEmpty()
        && mNoActionRegion.IsEmpty()
        && mHorizontalPanRegion.IsEmpty()
        && mVerticalPanRegion.IsEmpty();
  }

  nsCString ToString() const
  {
    nsCString result = mHitRegion.ToString();
    result.AppendLiteral(";dispatchToContent=");
    result.Append(mDispatchToContentHitRegion.ToString());
    return result;
  }
};

// Bit flags that go on a ContainerLayer (or RefLayer) and override the
// event regions in the entire subtree below. This is needed for propagating
// various flags across processes since the child-process layout code doesn't
// know about parent-process listeners or CSS rules.
enum EventRegionsOverride {
  // The default, no flags set
  NoOverride             = 0,
  // Treat all hit regions in the subtree as dispatch-to-content
  ForceDispatchToContent = (1 << 0),
  // Treat all hit regions in the subtree as empty
  ForceEmptyHitRegion    = (1 << 1),
  // OR union of all valid bit flags, for use in BitFlagsEnumSerializer
  ALL_BITS               = (1 << 2) - 1
};

MOZ_ALWAYS_INLINE EventRegionsOverride
operator|(EventRegionsOverride a, EventRegionsOverride b)
{
  return (EventRegionsOverride)((int)a | (int)b);
}

MOZ_ALWAYS_INLINE EventRegionsOverride&
operator|=(EventRegionsOverride& a, EventRegionsOverride b)
{
  a = a | b;
  return a;
}

// Flags used as an argument to functions that dump textures.
enum TextureDumpMode {
  Compress,      // dump texture with LZ4 compression
  DoNotCompress  // dump texture uncompressed
};

// Some specialized typedefs of Matrix4x4Typed.
typedef gfx::Matrix4x4Typed<LayerPixel, CSSTransformedLayerPixel> CSSTransformMatrix;
// Several different async transforms can contribute to a layer's transform
// (specifically, an async animation can contribute a transform, and each APZC
// that scrolls a layer can contribute async scroll/zoom and overscroll
// transforms).
// To try to model this with typed units, we represent individual async
// transforms as ParentLayer -> ParentLayer transforms (aliased as
// AsyncTransformComponentMatrix), and we represent the product of all of them
// as a CSSTransformLayer -> ParentLayer transform (aliased as
// AsyncTransformMatrix). To create an AsyncTransformMatrix from component
// matrices, a ViewAs operation is needed. A MultipleAsyncTransforms
// PixelCastJustification is provided for this purpose.
typedef gfx::Matrix4x4Typed<ParentLayerPixel, ParentLayerPixel> AsyncTransformComponentMatrix;
typedef gfx::Matrix4x4Typed<CSSTransformedLayerPixel, ParentLayerPixel> AsyncTransformMatrix;

} // namespace layers
} // namespace mozilla

#endif /* GFX_LAYERSTYPES_H */
