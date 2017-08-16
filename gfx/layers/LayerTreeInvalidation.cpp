/*-*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "LayerTreeInvalidation.h"

#include <stdint.h>                     // for uint32_t
#include "ImageContainer.h"             // for ImageContainer
#include "ImageLayers.h"                // for ImageLayer, etc
#include "Layers.h"                     // for Layer, ContainerLayer, etc
#include "Units.h"                      // for ParentLayerIntRect
#include "gfxRect.h"                    // for gfxRect
#include "gfxUtils.h"                   // for gfxUtils
#include "mozilla/gfx/BaseSize.h"       // for BaseSize
#include "mozilla/gfx/Point.h"          // for IntSize
#include "mozilla/mozalloc.h"           // for operator new, etc
#include "nsDataHashtable.h"            // for nsDataHashtable
#include "nsDebug.h"                    // for NS_ASSERTION
#include "nsHashKeys.h"                 // for nsPtrHashKey
#include "nsISupportsImpl.h"            // for Layer::AddRef, etc
#include "nsRect.h"                     // for IntRect
#include "nsTArray.h"                   // for AutoTArray, nsTArray_Impl
#include "mozilla/Poison.h"
#include "mozilla/layers/ImageHost.h"
#include "mozilla/layers/LayerManagerComposite.h"
#include "TreeTraversal.h"              // for ForEachNode
#include "LayersLogging.h"

// LayerTreeInvalidation debugging
#define LTI_DEBUG 0

#if LTI_DEBUG
#  define LTI_DEEPER(aPrefix) nsPrintfCString("%s  ", aPrefix).get()
#  define LTI_DUMP(rgn, label) if (!(rgn).IsEmpty()) printf_stderr("%s%p: " label " portion is %s\n", aPrefix, mLayer.get(), Stringify(rgn).c_str());
#  define LTI_LOG(...) printf_stderr(__VA_ARGS__)
#else
#  define LTI_DEEPER(aPrefix) nullptr
#  define LTI_DUMP(rgn, label)
#  define LTI_LOG(...)
#endif

using namespace mozilla::gfx;

namespace mozilla {
namespace layers {

struct LayerPropertiesBase;
UniquePtr<LayerPropertiesBase> CloneLayerTreePropertiesInternal(Layer* aRoot, bool aIsMask = false);

/**
 * Get accumulated transform of from the context creating layer to the
 * given layer.
 */
static Matrix4x4
GetTransformIn3DContext(Layer* aLayer) {
  Matrix4x4 transform = aLayer->GetLocalTransform();
  for (Layer* layer = aLayer->GetParent();
       layer && layer->Extend3DContext();
       layer = layer->GetParent()) {
    transform = transform * layer->GetLocalTransform();
  }
  return transform;
}

/**
 * Get a transform for the given layer depending on extending 3D
 * context.
 *
 * @return local transform for layers not participating 3D rendering
 * context, or the accmulated transform in the context for else.
 */
static Matrix4x4
GetTransformForInvalidation(Layer* aLayer) {
  return (!aLayer->Is3DContextLeaf() && !aLayer->Extend3DContext() ?
          aLayer->GetLocalTransform() : GetTransformIn3DContext(aLayer));
}

static IntRect
TransformRect(const IntRect& aRect, const Matrix4x4& aTransform)
{
  if (aRect.IsEmpty()) {
    return IntRect();
  }

  Rect rect(aRect.x, aRect.y, aRect.width, aRect.height);
  rect = aTransform.TransformAndClipBounds(rect, Rect::MaxIntRect());
  rect.RoundOut();

  IntRect intRect;
  if (!gfxUtils::GfxRectToIntRect(ThebesRect(rect), &intRect)) {
    return IntRect();
  }

  return intRect;
}

static void
AddTransformedRegion(nsIntRegion& aDest, const nsIntRegion& aSource, const Matrix4x4& aTransform)
{
  for (auto iter = aSource.RectIter(); !iter.Done(); iter.Next()) {
    aDest.Or(aDest, TransformRect(iter.Get(), aTransform));
  }
  aDest.SimplifyOutward(20);
}

static void
AddRegion(nsIntRegion& aDest, const nsIntRegion& aSource)
{
  aDest.Or(aDest, aSource);
  aDest.SimplifyOutward(20);
}

/**
 * Walks over this layer, and all descendant layers.
 * If any of these are a ContainerLayer that reports invalidations to a PresShell,
 * then report that the entire bounds have changed.
 */
static void
NotifySubdocumentInvalidation(Layer* aLayer, NotifySubDocInvalidationFunc aCallback)
{
  ForEachNode<ForwardIterator>(
      aLayer,
      [aCallback] (Layer* layer)
      {
        layer->ClearInvalidRect();
        if (layer->GetMaskLayer()) {
          NotifySubdocumentInvalidation(layer->GetMaskLayer(), aCallback);
        }
        for (size_t i = 0; i < layer->GetAncestorMaskLayerCount(); i++) {
          Layer* maskLayer = layer->GetAncestorMaskLayerAt(i);
          NotifySubdocumentInvalidation(maskLayer, aCallback);
        }
      },
      [aCallback] (Layer* layer)
      {
        ContainerLayer* container = layer->AsContainerLayer();
        if (container) {
          aCallback(container, container->GetLocalVisibleRegion().ToUnknownRegion());
        }
      });
}

struct LayerPropertiesBase : public LayerProperties
{
  explicit LayerPropertiesBase(Layer* aLayer)
    : mLayer(aLayer)
    , mMaskLayer(nullptr)
    , mVisibleRegion(mLayer->GetLocalVisibleRegion().ToUnknownRegion())
    , mPostXScale(aLayer->GetPostXScale())
    , mPostYScale(aLayer->GetPostYScale())
    , mOpacity(aLayer->GetLocalOpacity())
    , mUseClipRect(!!aLayer->GetLocalClipRect())
  {
    MOZ_COUNT_CTOR(LayerPropertiesBase);
    if (aLayer->GetMaskLayer()) {
      mMaskLayer = CloneLayerTreePropertiesInternal(aLayer->GetMaskLayer(), true);
    }
    for (size_t i = 0; i < aLayer->GetAncestorMaskLayerCount(); i++) {
      Layer* maskLayer = aLayer->GetAncestorMaskLayerAt(i);
      mAncestorMaskLayers.AppendElement(CloneLayerTreePropertiesInternal(maskLayer, true));
    }
    if (mUseClipRect) {
      mClipRect = *aLayer->GetLocalClipRect();
    }
    mTransform = GetTransformForInvalidation(aLayer);
  }
  LayerPropertiesBase()
    : mLayer(nullptr)
    , mMaskLayer(nullptr)
  {
    MOZ_COUNT_CTOR(LayerPropertiesBase);
  }
  ~LayerPropertiesBase() override
  {
    MOZ_COUNT_DTOR(LayerPropertiesBase);
  }

protected:
  LayerPropertiesBase(const LayerPropertiesBase& a) = delete;
  LayerPropertiesBase& operator=(const LayerPropertiesBase& a) = delete;

public:
  nsIntRegion ComputeDifferences(Layer* aRoot,
                                 NotifySubDocInvalidationFunc aCallback) override;

  void MoveBy(const IntPoint& aOffset) override;

  nsIntRegion ComputeChange(const char* aPrefix,
                            NotifySubDocInvalidationFunc aCallback)
  {
    // Bug 1251615: This canary is sometimes hit. We're still not sure why.
    mCanary.Check();
    bool transformChanged = !mTransform.FuzzyEqual(GetTransformForInvalidation(mLayer)) ||
                             mLayer->GetPostXScale() != mPostXScale ||
                             mLayer->GetPostYScale() != mPostYScale;
    const Maybe<ParentLayerIntRect>& otherClip = mLayer->GetLocalClipRect();
    nsIntRegion result;

    bool ancestorMaskChanged = mAncestorMaskLayers.Length() != mLayer->GetAncestorMaskLayerCount();
    if (!ancestorMaskChanged) {
      for (size_t i = 0; i < mAncestorMaskLayers.Length(); i++) {
        if (mLayer->GetAncestorMaskLayerAt(i) != mAncestorMaskLayers[i]->mLayer) {
          ancestorMaskChanged = true;
          break;
        }
      }
    }

    Layer* otherMask = mLayer->GetMaskLayer();
    if ((mMaskLayer ? mMaskLayer->mLayer : nullptr) != otherMask ||
        ancestorMaskChanged ||
        (mUseClipRect != !!otherClip) ||
        mLayer->GetLocalOpacity() != mOpacity ||
        transformChanged)
    {
      result = OldTransformedBounds();
      LTI_DUMP(result, "oldtransform");
      LTI_DUMP(NewTransformedBounds(), "newtransform");
      AddRegion(result, NewTransformedBounds());

      // We can't bail out early because we need to update mChildrenChanged.
    }

    nsIntRegion internal = ComputeChangeInternal(aPrefix, aCallback);
    LTI_DUMP(internal, "internal");
    AddRegion(result, internal);
    LTI_DUMP(mLayer->GetInvalidRegion().GetRegion(), "invalid");
    AddTransformedRegion(result, mLayer->GetInvalidRegion().GetRegion(), mTransform);

    if (mMaskLayer && otherMask) {
      nsIntRegion mask = mMaskLayer->ComputeChange(aPrefix, aCallback);
      LTI_DUMP(mask, "mask");
      AddTransformedRegion(result, mask, mTransform);
    }

    for (size_t i = 0;
         i < std::min(mAncestorMaskLayers.Length(), mLayer->GetAncestorMaskLayerCount());
         i++)
    {
      nsIntRegion mask = mAncestorMaskLayers[i]->ComputeChange(aPrefix, aCallback);
      LTI_DUMP(mask, "ancestormask");
      AddTransformedRegion(result, mask, mTransform);
    }

    if (mUseClipRect && otherClip) {
      if (!mClipRect.IsEqualInterior(*otherClip)) {
        nsIntRegion tmp;
        tmp.Xor(mClipRect.ToUnknownRect(), otherClip->ToUnknownRect());
        LTI_DUMP(tmp, "clip");
        AddRegion(result, tmp);
      }
    }

    mLayer->ClearInvalidRect();
    return result;
  }

  void CheckCanary()
  {
    mCanary.Check();
    mLayer->CheckCanary();
  }

  virtual IntRect NewTransformedBounds()
  {
    return TransformRect(mLayer->GetLocalVisibleRegion().ToUnknownRegion().GetBounds(),
                         GetTransformForInvalidation(mLayer));
  }

  virtual IntRect OldTransformedBounds()
  {
    return TransformRect(mVisibleRegion.ToUnknownRegion().GetBounds(), mTransform);
  }

  virtual nsIntRegion ComputeChangeInternal(const char* aPrefix,
                                            NotifySubDocInvalidationFunc aCallback)
  {
    return IntRect();
  }

  RefPtr<Layer> mLayer;
  UniquePtr<LayerPropertiesBase> mMaskLayer;
  nsTArray<UniquePtr<LayerPropertiesBase>> mAncestorMaskLayers;
  nsIntRegion mVisibleRegion;
  Matrix4x4 mTransform;
  float mPostXScale;
  float mPostYScale;
  float mOpacity;
  ParentLayerIntRect mClipRect;
  bool mUseClipRect;
  mozilla::CorruptionCanary mCanary;
};

struct ContainerLayerProperties : public LayerPropertiesBase
{
  explicit ContainerLayerProperties(ContainerLayer* aLayer)
    : LayerPropertiesBase(aLayer)
    , mPreXScale(aLayer->GetPreXScale())
    , mPreYScale(aLayer->GetPreYScale())
  {
    for (Layer* child = aLayer->GetFirstChild(); child; child = child->GetNextSibling()) {
      child->CheckCanary();
      mChildren.AppendElement(Move(CloneLayerTreePropertiesInternal(child)));
    }
  }

protected:
  ContainerLayerProperties(const ContainerLayerProperties& a) = delete;
  ContainerLayerProperties& operator=(const ContainerLayerProperties& a) = delete;

public:
  nsIntRegion ComputeChangeInternal(const char *aPrefix,
                                    NotifySubDocInvalidationFunc aCallback) override
  {
    // Make sure we got our virtual call right
    mSubtypeCanary.Check();
    ContainerLayer* container = mLayer->AsContainerLayer();
    nsIntRegion invalidOfLayer; // Invalid regions of this layer.
    nsIntRegion result;         // Invliad regions for children only.

    container->CheckCanary();

    bool childrenChanged = false;

    if (mPreXScale != container->GetPreXScale() ||
        mPreYScale != container->GetPreYScale()) {
      invalidOfLayer = OldTransformedBounds();
      AddRegion(invalidOfLayer, NewTransformedBounds());
      childrenChanged = true;

      // Can't bail out early, we need to update the child container layers
    }

    // A low frame rate is especially visible to users when scrolling, so we
    // particularly want to avoid unnecessary invalidation at that time. For us
    // here, that means avoiding unnecessary invalidation of child items when
    // other children are added to or removed from our container layer, since
    // that may be caused by children being scrolled in or out of view. We are
    // less concerned with children changing order.
    // TODO: Consider how we could avoid unnecessary invalidation when children
    // change order, and whether the overhead would be worth it.

    nsDataHashtable<nsPtrHashKey<Layer>, uint32_t> oldIndexMap(mChildren.Length());
    for (uint32_t i = 0; i < mChildren.Length(); ++i) {
      mChildren[i]->CheckCanary();
      oldIndexMap.Put(mChildren[i]->mLayer, i);
    }

    uint32_t i = 0; // cursor into the old child list mChildren
    for (Layer* child = container->GetFirstChild(); child; child = child->GetNextSibling()) {
      bool invalidateChildsCurrentArea = false;
      if (i < mChildren.Length()) {
        uint32_t childsOldIndex;
        if (oldIndexMap.Get(child, &childsOldIndex)) {
          if (childsOldIndex >= i) {
            // Invalidate the old areas of layers that used to be between the
            // current |child| and the previous |child| that was also in the
            // old list mChildren (if any of those children have been reordered
            // rather than removed, we will invalidate their new area when we
            // encounter them in the new list):
            for (uint32_t j = i; j < childsOldIndex; ++j) {
              LTI_DUMP(mChildren[j]->OldTransformedBounds(), "reordered child");
              AddRegion(result, mChildren[j]->OldTransformedBounds());
              childrenChanged |= true;
            }
            if (childsOldIndex >= mChildren.Length()) {
              MOZ_CRASH("Out of bounds");
            }
            // Invalidate any regions of the child that have changed:
            nsIntRegion region = mChildren[childsOldIndex]->ComputeChange(LTI_DEEPER(aPrefix), aCallback);
            i = childsOldIndex + 1;
            if (!region.IsEmpty()) {
              LTI_LOG("%s%p: child %p produced %s\n", aPrefix, mLayer.get(),
                mChildren[childsOldIndex]->mLayer.get(), Stringify(region).c_str());
              AddRegion(result, region);
              childrenChanged |= true;
            }
          } else {
            // We've already seen this child in mChildren (which means it must
            // have been reordered) and invalidated its old area. We need to
            // invalidate its new area too:
            invalidateChildsCurrentArea = true;
          }
        } else {
          // |child| is new
          invalidateChildsCurrentArea = true;
        }
      } else {
        // |child| is new, or was reordered to a higher index
        invalidateChildsCurrentArea = true;
      }
      if (invalidateChildsCurrentArea) {
        LTI_DUMP(child->GetLocalVisibleRegion().ToUnknownRegion(), "invalidateChidlsCurrentArea");
        AddTransformedRegion(result, child->GetLocalVisibleRegion().ToUnknownRegion(),
                             GetTransformForInvalidation(child));
        if (aCallback) {
          NotifySubdocumentInvalidation(child, aCallback);
        } else {
          ClearInvalidations(child);
        }
      }
      childrenChanged |= invalidateChildsCurrentArea;
    }

    // Process remaining removed children.
    while (i < mChildren.Length()) {
      childrenChanged |= true;
      LTI_DUMP(mChildren[i]->OldTransformedBounds(), "removed child");
      AddRegion(result, mChildren[i]->OldTransformedBounds());
      i++;
    }

    if (aCallback) {
      aCallback(container, result);
    }

    if (childrenChanged) {
      container->SetChildrenChanged(true);
    }

    if (!mLayer->Extend3DContext()) {
      // |result| contains invalid regions only of children.
      result.Transform(GetTransformForInvalidation(mLayer));
    }
    // else, effective transforms have applied on children.

    LTI_DUMP(invalidOfLayer, "invalidOfLayer");
    result.OrWith(invalidOfLayer);

    return result;
  }

  IntRect NewTransformedBounds() override
  {
    if (mLayer->Extend3DContext()) {
      IntRect result;
      for (UniquePtr<LayerPropertiesBase>& child : mChildren) {
        result = result.Union(child->NewTransformedBounds());
      }
      return result;
    }

    return LayerPropertiesBase::NewTransformedBounds();
  }

  IntRect OldTransformedBounds() override
  {
    if (mLayer->Extend3DContext()) {
      IntRect result;
      for (UniquePtr<LayerPropertiesBase>& child : mChildren) {
        result = result.Union(child->OldTransformedBounds());
      }
      return result;
    }
    return LayerPropertiesBase::OldTransformedBounds();
  }

  // The old list of children:
  mozilla::CorruptionCanary mSubtypeCanary;
  nsTArray<UniquePtr<LayerPropertiesBase>> mChildren;
  float mPreXScale;
  float mPreYScale;
};

struct ColorLayerProperties : public LayerPropertiesBase
{
  explicit ColorLayerProperties(ColorLayer *aLayer)
    : LayerPropertiesBase(aLayer)
    , mColor(aLayer->GetColor())
    , mBounds(aLayer->GetBounds())
  { }

protected:
  ColorLayerProperties(const ColorLayerProperties& a) = delete;
  ColorLayerProperties& operator=(const ColorLayerProperties& a) = delete;

public:
  nsIntRegion ComputeChangeInternal(const char* aPrefix,
                                    NotifySubDocInvalidationFunc aCallback) override
  {
    ColorLayer* color = static_cast<ColorLayer*>(mLayer.get());

    if (mColor != color->GetColor()) {
      LTI_DUMP(NewTransformedBounds(), "color");
      return NewTransformedBounds();
    }

    nsIntRegion boundsDiff;
    boundsDiff.Xor(mBounds, color->GetBounds());
    LTI_DUMP(boundsDiff, "colorbounds");

    nsIntRegion result;
    AddTransformedRegion(result, boundsDiff, mTransform);

    return result;
  }

  Color mColor;
  IntRect mBounds;
};

struct BorderLayerProperties : public LayerPropertiesBase
{
  explicit BorderLayerProperties(BorderLayer *aLayer)
    : LayerPropertiesBase(aLayer)
    , mColors(aLayer->GetColors())
    , mRect(aLayer->GetRect())
    , mCorners(aLayer->GetCorners())
    , mWidths(aLayer->GetWidths())
  { }

protected:
  BorderLayerProperties(const BorderLayerProperties& a) = delete;
  BorderLayerProperties& operator=(const BorderLayerProperties& a) = delete;

public:
  nsIntRegion ComputeChangeInternal(const char* aPrefix,
                                    NotifySubDocInvalidationFunc aCallback) override
  {
    BorderLayer* border = static_cast<BorderLayer*>(mLayer.get());

    if (!border->GetLocalVisibleRegion().ToUnknownRegion().IsEqual(mVisibleRegion)) {
      IntRect result = NewTransformedBounds();
      result = result.Union(OldTransformedBounds());
      return result;
    }

    if (!PodEqual(&mColors[0], &border->GetColors()[0], 4) ||
        !PodEqual(&mWidths[0], &border->GetWidths()[0], 4) ||
        !PodEqual(&mCorners[0], &border->GetCorners()[0], 4) ||
        !mRect.IsEqualEdges(border->GetRect())) {
      LTI_DUMP(NewTransformedBounds(), "bounds");
      return NewTransformedBounds();
    }

    return nsIntRegion();
  }

  BorderColors mColors;
  LayerRect mRect;
  BorderCorners mCorners;
  BorderWidths mWidths;
};

struct TextLayerProperties : public LayerPropertiesBase
{
  explicit TextLayerProperties(TextLayer *aLayer)
    : LayerPropertiesBase(aLayer)
    , mBounds(aLayer->GetBounds())
    , mGlyphs(aLayer->GetGlyphs())
    , mFont(aLayer->GetScaledFont())
  { }

protected:
  TextLayerProperties(const TextLayerProperties& a) = delete;
  TextLayerProperties& operator=(const TextLayerProperties& a) = delete;

public:
  nsIntRegion ComputeChangeInternal(const char* aPrefix,
                                    NotifySubDocInvalidationFunc aCallback) override
  {
    TextLayer* text = static_cast<TextLayer*>(mLayer.get());

    if (!text->GetLocalVisibleRegion().ToUnknownRegion().IsEqual(mVisibleRegion)) {
      IntRect result = NewTransformedBounds();
      result = result.Union(OldTransformedBounds());
      return result;
    }

    if (!mBounds.IsEqualEdges(text->GetBounds()) ||
        mGlyphs != text->GetGlyphs() ||
        mFont != text->GetScaledFont()) {
      LTI_DUMP(NewTransformedBounds(), "bounds");
      return NewTransformedBounds();
    }

    return nsIntRegion();
  }

  gfx::IntRect mBounds;
  nsTArray<GlyphArray> mGlyphs;
  gfx::ScaledFont* mFont;
};

static ImageHost* GetImageHost(Layer* aLayer)
{
  HostLayer* compositor = aLayer->AsHostLayer();
  if (compositor) {
    return static_cast<ImageHost*>(compositor->GetCompositableHost());
  }
  return nullptr;
}

struct ImageLayerProperties : public LayerPropertiesBase
{
  explicit ImageLayerProperties(ImageLayer* aImage, bool aIsMask)
    : LayerPropertiesBase(aImage)
    , mContainer(aImage->GetContainer())
    , mImageHost(GetImageHost(aImage))
    , mSamplingFilter(aImage->GetSamplingFilter())
    , mScaleToSize(aImage->GetScaleToSize())
    , mScaleMode(aImage->GetScaleMode())
    , mLastProducerID(-1)
    , mLastFrameID(-1)
    , mIsMask(aIsMask)
  {
    if (mImageHost) {
      mLastProducerID = mImageHost->GetLastProducerID();
      mLastFrameID = mImageHost->GetLastFrameID();
    }
  }

  nsIntRegion ComputeChangeInternal(const char* aPrefix,
                                    NotifySubDocInvalidationFunc aCallback) override
  {
    ImageLayer* imageLayer = static_cast<ImageLayer*>(mLayer.get());

    if (!imageLayer->GetLocalVisibleRegion().ToUnknownRegion().IsEqual(mVisibleRegion)) {
      IntRect result = NewTransformedBounds();
      result = result.Union(OldTransformedBounds());
      return result;
    }

    ImageContainer* container = imageLayer->GetContainer();
    ImageHost* host = GetImageHost(imageLayer);
    if (mContainer != container ||
        mSamplingFilter != imageLayer->GetSamplingFilter() ||
        mScaleToSize != imageLayer->GetScaleToSize() ||
        mScaleMode != imageLayer->GetScaleMode() ||
        host != mImageHost ||
        (host && host->GetProducerID() != mLastProducerID) ||
        (host && host->GetFrameID() != mLastFrameID)) {

      if (mIsMask) {
        // Mask layers have an empty visible region, so we have to
        // use the image size instead.
        IntSize size;
        if (container) {
          size = container->GetCurrentSize();
        }
        if (host) {
          size = host->GetImageSize();
        }
        IntRect rect(0, 0, size.width, size.height);
        LTI_DUMP(rect, "mask");
        return TransformRect(rect, GetTransformForInvalidation(mLayer));
      }
      LTI_DUMP(NewTransformedBounds(), "bounds");
      return NewTransformedBounds();
    }

    return IntRect();
  }

  RefPtr<ImageContainer> mContainer;
  RefPtr<ImageHost> mImageHost;
  SamplingFilter mSamplingFilter;
  gfx::IntSize mScaleToSize;
  ScaleMode mScaleMode;
  int32_t mLastProducerID;
  int32_t mLastFrameID;
  bool mIsMask;
};

struct CanvasLayerProperties : public LayerPropertiesBase
{
  explicit CanvasLayerProperties(CanvasLayer* aCanvas)
    : LayerPropertiesBase(aCanvas)
    , mImageHost(GetImageHost(aCanvas))
  {
    mFrameID = mImageHost ? mImageHost->GetFrameID() : -1;
  }

  nsIntRegion ComputeChangeInternal(const char* aPrefix,
                                    NotifySubDocInvalidationFunc aCallback) override
  {
    CanvasLayer* canvasLayer = static_cast<CanvasLayer*>(mLayer.get());

    ImageHost* host = GetImageHost(canvasLayer);
    if (host && host->GetFrameID() != mFrameID) {
      LTI_DUMP(NewTransformedBounds(), "frameId");
      return NewTransformedBounds();
    }

    return IntRect();
  }

  RefPtr<ImageHost> mImageHost;
  int32_t mFrameID;
};

UniquePtr<LayerPropertiesBase>
CloneLayerTreePropertiesInternal(Layer* aRoot, bool aIsMask /* = false */)
{
  if (!aRoot) {
    return MakeUnique<LayerPropertiesBase>();
  }

  MOZ_ASSERT(!aIsMask || aRoot->GetType() == Layer::TYPE_IMAGE);

  aRoot->CheckCanary();

  switch (aRoot->GetType()) {
    case Layer::TYPE_CONTAINER:
    case Layer::TYPE_REF:
      return MakeUnique<ContainerLayerProperties>(aRoot->AsContainerLayer());
    case Layer::TYPE_COLOR:
      return MakeUnique<ColorLayerProperties>(static_cast<ColorLayer*>(aRoot));
    case Layer::TYPE_IMAGE:
      return MakeUnique<ImageLayerProperties>(static_cast<ImageLayer*>(aRoot), aIsMask);
    case Layer::TYPE_CANVAS:
      return MakeUnique<CanvasLayerProperties>(static_cast<CanvasLayer*>(aRoot));
    case Layer::TYPE_BORDER:
      return MakeUnique<BorderLayerProperties>(static_cast<BorderLayer*>(aRoot));
    case Layer::TYPE_TEXT:
      return MakeUnique<TextLayerProperties>(static_cast<TextLayer*>(aRoot));
    case Layer::TYPE_DISPLAYITEM:
    case Layer::TYPE_READBACK:
    case Layer::TYPE_SHADOW:
    case Layer::TYPE_PAINTED:
      return MakeUnique<LayerPropertiesBase>(aRoot);
  }

  MOZ_ASSERT_UNREACHABLE("Unexpected root layer type");
  return MakeUnique<LayerPropertiesBase>(aRoot);
}

/* static */ UniquePtr<LayerProperties>
LayerProperties::CloneFrom(Layer* aRoot)
{
  return CloneLayerTreePropertiesInternal(aRoot);
}

/* static */ void
LayerProperties::ClearInvalidations(Layer *aLayer)
{
  ForEachNode<ForwardIterator>(
        aLayer,
        [] (Layer* layer)
        {
          layer->ClearInvalidRect();
          if (layer->GetMaskLayer()) {
            ClearInvalidations(layer->GetMaskLayer());
          }
          for (size_t i = 0; i < layer->GetAncestorMaskLayerCount(); i++) {
            ClearInvalidations(layer->GetAncestorMaskLayerAt(i));
          }

        }
      );
}

nsIntRegion
LayerPropertiesBase::ComputeDifferences(Layer* aRoot, NotifySubDocInvalidationFunc aCallback)
{
  NS_ASSERTION(aRoot, "Must have a layer tree to compare against!");
  if (mLayer != aRoot) {
    if (aCallback) {
      NotifySubdocumentInvalidation(aRoot, aCallback);
    } else {
      ClearInvalidations(aRoot);
    }
    IntRect result = TransformRect(
      aRoot->GetLocalVisibleRegion().ToUnknownRegion().GetBounds(),
      aRoot->GetLocalTransform());
    result = result.Union(OldTransformedBounds());
    return result;
  }
  nsIntRegion invalid = ComputeChange("  ", aCallback);
  return invalid;
}

void
LayerPropertiesBase::MoveBy(const IntPoint& aOffset)
{
  mTransform.PostTranslate(aOffset.x, aOffset.y, 0);
}

} // namespace layers
} // namespace mozilla
