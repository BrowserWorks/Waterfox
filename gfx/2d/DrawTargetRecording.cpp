/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "DrawTargetRecording.h"
#include "PathRecording.h"
#include <stdio.h>

#include "Logging.h"
#include "Tools.h"
#include "Filters.h"
#include "mozilla/UniquePtr.h"
#include "RecordingTypes.h"
#include "RecordedEventImpl.h"

namespace mozilla {
namespace gfx {

struct RecordingSourceSurfaceUserData
{
  void *refPtr;
  RefPtr<DrawEventRecorderPrivate> recorder;
};

void RecordingSourceSurfaceUserDataFunc(void *aUserData)
{
  RecordingSourceSurfaceUserData *userData =
    static_cast<RecordingSourceSurfaceUserData*>(aUserData);

  userData->recorder->RemoveSourceSurface((SourceSurface*)userData->refPtr);
  userData->recorder->RemoveStoredObject(userData->refPtr);
  userData->recorder->RecordEvent(
    RecordedSourceSurfaceDestruction(ReferencePtr(userData->refPtr)));

  delete userData;
}

static void
StoreSourceSurfaceRecording(DrawEventRecorderPrivate *aRecorder, SourceSurface *aSurface,
                   DataSourceSurface *aDataSurf, const char *reason)
{
  if (!aDataSurf) {
    gfxWarning() << "Recording failed to record SourceSurface for " << reason;
    // Insert a bogus source surface.
    int32_t stride = aSurface->GetSize().width * BytesPerPixel(aSurface->GetFormat());
    UniquePtr<uint8_t[]> sourceData(new uint8_t[stride * aSurface->GetSize().height]());
    aRecorder->RecordEvent(
      RecordedSourceSurfaceCreation(aSurface, sourceData.get(), stride,
                                    aSurface->GetSize(), aSurface->GetFormat()));
  } else {
    DataSourceSurface::ScopedMap map(aDataSurf, DataSourceSurface::READ);
    aRecorder->RecordEvent(
      RecordedSourceSurfaceCreation(aSurface, map.GetData(), map.GetStride(),
                                    aDataSurf->GetSize(), aDataSurf->GetFormat()));
  }
}

static void
EnsureSurfaceStoredRecording(DrawEventRecorderPrivate *aRecorder, SourceSurface *aSurface,
                    const char *reason)
{
  if (aRecorder->HasStoredObject(aSurface)) {
    return;
  }

  RefPtr<DataSourceSurface> dataSurf = aSurface->GetDataSurface();
  StoreSourceSurfaceRecording(aRecorder, aSurface, dataSurf, reason);
  aRecorder->AddStoredObject(aSurface);
  aRecorder->AddSourceSurface(aSurface);

  RecordingSourceSurfaceUserData *userData = new RecordingSourceSurfaceUserData;
  userData->refPtr = aSurface;
  userData->recorder = aRecorder;
  aSurface->AddUserData(reinterpret_cast<UserDataKey*>(aRecorder),
                        userData, &RecordingSourceSurfaceUserDataFunc);
}

class SourceSurfaceRecording : public SourceSurface
{
public:
  MOZ_DECLARE_REFCOUNTED_VIRTUAL_TYPENAME(SourceSurfaceRecording)
  SourceSurfaceRecording(IntSize aSize, SurfaceFormat aFormat, DrawEventRecorderPrivate *aRecorder)
    : mSize(aSize), mFormat(aFormat), mRecorder(aRecorder)
  {
    mRecorder->AddStoredObject(this);
  }

  ~SourceSurfaceRecording()
  {
    mRecorder->RemoveStoredObject(this);
    mRecorder->RecordEvent(RecordedSourceSurfaceDestruction(ReferencePtr(this)));
  }

  virtual SurfaceType GetType() const { return SurfaceType::RECORDING; }
  virtual IntSize GetSize() const { return mSize; }
  virtual SurfaceFormat GetFormat() const { return mFormat; }
  virtual already_AddRefed<DataSourceSurface> GetDataSurface() { return nullptr; }

  IntSize mSize;
  SurfaceFormat mFormat;
  RefPtr<DrawEventRecorderPrivate> mRecorder;
};

class DataSourceSurfaceRecording : public DataSourceSurface
{
public:
  MOZ_DECLARE_REFCOUNTED_VIRTUAL_TYPENAME(DataSourceSurfaceRecording, override)
  DataSourceSurfaceRecording(UniquePtr<uint8_t[]> aData, IntSize aSize,
                             int32_t aStride, SurfaceFormat aFormat)
    : mData(Move(aData))
    , mSize(aSize)
    , mStride(aStride)
    , mFormat(aFormat)
  {
  }

  ~DataSourceSurfaceRecording()
  {
  }

  static already_AddRefed<DataSourceSurface>
  Init(uint8_t *aData, IntSize aSize, int32_t aStride, SurfaceFormat aFormat)
  {
    //XXX: do we need to ensure any alignment here?
    auto data = MakeUnique<uint8_t[]>(aStride * aSize.height * BytesPerPixel(aFormat));
    if (data) {
      memcpy(data.get(), aData, aStride * aSize.height * BytesPerPixel(aFormat));
      RefPtr<DataSourceSurfaceRecording> surf = new DataSourceSurfaceRecording(Move(data), aSize, aStride, aFormat);
      return surf.forget();
    }
    return nullptr;
  }

  virtual SurfaceType GetType() const override { return SurfaceType::RECORDING; }
  virtual IntSize GetSize() const override { return mSize; }
  virtual int32_t Stride() override { return mStride; }
  virtual SurfaceFormat GetFormat() const override { return mFormat; }
  virtual uint8_t* GetData() override { return mData.get(); }

  UniquePtr<uint8_t[]> mData;
  IntSize mSize;
  int32_t mStride;
  SurfaceFormat mFormat;
};


class GradientStopsRecording : public GradientStops
{
public:
  MOZ_DECLARE_REFCOUNTED_VIRTUAL_TYPENAME(GradientStopsRecording)
  explicit GradientStopsRecording(DrawEventRecorderPrivate *aRecorder)
    : mRecorder(aRecorder)
  {
    mRecorder->AddStoredObject(this);
  }

  ~GradientStopsRecording()
  {
    mRecorder->RemoveStoredObject(this);
    mRecorder->RecordEvent(RecordedGradientStopsDestruction(ReferencePtr(this)));
  }

  virtual BackendType GetBackendType() const { return BackendType::RECORDING; }

  RefPtr<DrawEventRecorderPrivate> mRecorder;
};

class FilterNodeRecording : public FilterNode
{
public:
  MOZ_DECLARE_REFCOUNTED_VIRTUAL_TYPENAME(FilterNodeRecording, override)
  using FilterNode::SetAttribute;

  explicit FilterNodeRecording(DrawEventRecorderPrivate *aRecorder)
    : mRecorder(aRecorder)
  {
    mRecorder->AddStoredObject(this);
  }

  ~FilterNodeRecording()
  {
    mRecorder->RemoveStoredObject(this);
    mRecorder->RecordEvent(RecordedFilterNodeDestruction(ReferencePtr(this)));
  }

  virtual void SetInput(uint32_t aIndex, SourceSurface *aSurface) override
  {
    EnsureSurfaceStoredRecording(mRecorder, aSurface,  "SetInput");

    mRecorder->RecordEvent(RecordedFilterNodeSetInput(this, aIndex, aSurface));
  }
  virtual void SetInput(uint32_t aIndex, FilterNode *aFilter) override
  {
    MOZ_ASSERT(mRecorder->HasStoredObject(aFilter));

    mRecorder->RecordEvent(RecordedFilterNodeSetInput(this, aIndex, aFilter));
  }

#define FORWARD_SET_ATTRIBUTE(type, argtype) \
  virtual void SetAttribute(uint32_t aIndex, type aValue) override { \
    mRecorder->RecordEvent(RecordedFilterNodeSetAttribute(this, aIndex, aValue, RecordedFilterNodeSetAttribute::ARGTYPE_##argtype)); \
  }

  FORWARD_SET_ATTRIBUTE(bool, BOOL);
  FORWARD_SET_ATTRIBUTE(uint32_t, UINT32);
  FORWARD_SET_ATTRIBUTE(Float, FLOAT);
  FORWARD_SET_ATTRIBUTE(const Size&, SIZE);
  FORWARD_SET_ATTRIBUTE(const IntSize&, INTSIZE);
  FORWARD_SET_ATTRIBUTE(const IntPoint&, INTPOINT);
  FORWARD_SET_ATTRIBUTE(const Rect&, RECT);
  FORWARD_SET_ATTRIBUTE(const IntRect&, INTRECT);
  FORWARD_SET_ATTRIBUTE(const Point&, POINT);
  FORWARD_SET_ATTRIBUTE(const Matrix&, MATRIX);
  FORWARD_SET_ATTRIBUTE(const Matrix5x4&, MATRIX5X4);
  FORWARD_SET_ATTRIBUTE(const Point3D&, POINT3D);
  FORWARD_SET_ATTRIBUTE(const Color&, COLOR);

#undef FORWARD_SET_ATTRIBUTE

  virtual void SetAttribute(uint32_t aIndex, const Float* aFloat, uint32_t aSize) override {
    mRecorder->RecordEvent(RecordedFilterNodeSetAttribute(this, aIndex, aFloat, aSize));
  }

  virtual FilterBackend GetBackendType() override { return FILTER_BACKEND_RECORDING; }

  RefPtr<DrawEventRecorderPrivate> mRecorder;
};

DrawTargetRecording::DrawTargetRecording(DrawEventRecorder *aRecorder, DrawTarget *aDT, IntSize aSize, bool aHasData)
  : mRecorder(static_cast<DrawEventRecorderPrivate*>(aRecorder))
  , mFinalDT(aDT)
  , mSize(aSize)
{
  RefPtr<SourceSurface> snapshot = aHasData ? mFinalDT->Snapshot() : nullptr;
  mRecorder->RecordEvent(RecordedDrawTargetCreation(this,
                                                    mFinalDT->GetBackendType(),
                                                    mSize,
                                                    mFinalDT->GetFormat(),
                                                    aHasData, snapshot));
  mFormat = mFinalDT->GetFormat();
}

DrawTargetRecording::DrawTargetRecording(const DrawTargetRecording *aDT,
                                         IntSize aSize,
                                         SurfaceFormat aFormat)
  : mRecorder(aDT->mRecorder)
  , mFinalDT(aDT->mFinalDT)
  , mSize(aSize)
{
  mRecorder->RecordEvent(RecordedCreateSimilarDrawTarget(this,
                                                         aSize,
                                                         aFormat));
  mFormat = aFormat;
}

DrawTargetRecording::~DrawTargetRecording()
{
  mRecorder->RecordEvent(RecordedDrawTargetDestruction(ReferencePtr(this)));
}

void
DrawTargetRecording::FillRect(const Rect &aRect,
                              const Pattern &aPattern,
                              const DrawOptions &aOptions)
{
  EnsurePatternDependenciesStored(aPattern);

  mRecorder->RecordEvent(RecordedFillRect(this, aRect, aPattern, aOptions));
}

void
DrawTargetRecording::StrokeRect(const Rect &aRect,
                                const Pattern &aPattern,
                                const StrokeOptions &aStrokeOptions,
                                const DrawOptions &aOptions)
{
  EnsurePatternDependenciesStored(aPattern);

  mRecorder->RecordEvent(RecordedStrokeRect(this, aRect, aPattern, aStrokeOptions, aOptions));
}

void
DrawTargetRecording::StrokeLine(const Point &aBegin,
                                const Point &aEnd,
                                const Pattern &aPattern,
                                const StrokeOptions &aStrokeOptions,
                                const DrawOptions &aOptions)
{
  EnsurePatternDependenciesStored(aPattern);

  mRecorder->RecordEvent(RecordedStrokeLine(this, aBegin, aEnd, aPattern, aStrokeOptions, aOptions));
}

void
DrawTargetRecording::Fill(const Path *aPath,
                          const Pattern &aPattern,
                          const DrawOptions &aOptions)
{
  RefPtr<PathRecording> pathRecording = EnsurePathStored(aPath);
  EnsurePatternDependenciesStored(aPattern);

  mRecorder->RecordEvent(RecordedFill(this, pathRecording, aPattern, aOptions));
}

struct RecordingFontUserData
{
  void *refPtr;
  RefPtr<DrawEventRecorderPrivate> recorder;
};

void RecordingFontUserDataDestroyFunc(void *aUserData)
{
  RecordingFontUserData *userData =
    static_cast<RecordingFontUserData*>(aUserData);

  userData->recorder->RecordEvent(RecordedScaledFontDestruction(ReferencePtr(userData->refPtr)));
  userData->recorder->RemoveScaledFont((ScaledFont*)userData->refPtr);
  delete userData;
}

void
DrawTargetRecording::FillGlyphs(ScaledFont *aFont,
                                const GlyphBuffer &aBuffer,
                                const Pattern &aPattern,
                                const DrawOptions &aOptions,
                                const GlyphRenderingOptions *aRenderingOptions)
{
  EnsurePatternDependenciesStored(aPattern);

  UserDataKey* userDataKey = reinterpret_cast<UserDataKey*>(mRecorder.get());
  if (!aFont->GetUserData(userDataKey)) {
    UnscaledFont* unscaledFont = aFont->GetUnscaledFont();
    if (!mRecorder->HasStoredObject(unscaledFont)) {
      RecordedFontData fontData(unscaledFont);
      RecordedFontDetails fontDetails;
      if (fontData.GetFontDetails(fontDetails)) {
        // Try to serialise the whole font, just in case this is a web font that
        // is not present on the system.
        if (!mRecorder->HasStoredFontData(fontDetails.fontDataKey)) {
          mRecorder->RecordEvent(fontData);
          mRecorder->AddStoredFontData(fontDetails.fontDataKey);
        }
        mRecorder->RecordEvent(RecordedUnscaledFontCreation(unscaledFont, fontDetails));
      } else {
        // If that fails, record just the font description and try to load it from
        // the system on the other side.
        RecordedFontDescriptor fontDesc(unscaledFont);
        if (fontDesc.IsValid()) {
          mRecorder->RecordEvent(fontDesc);
        } else {
          gfxWarning() << "DrawTargetRecording::FillGlyphs failed to serialise UnscaledFont";
        }
      }
      mRecorder->AddStoredObject(unscaledFont);
    }

    mRecorder->RecordEvent(RecordedScaledFontCreation(aFont, unscaledFont));

    RecordingFontUserData *userData = new RecordingFontUserData;
    userData->refPtr = aFont;
    userData->recorder = mRecorder;
    aFont->AddUserData(userDataKey, userData, &RecordingFontUserDataDestroyFunc);
    userData->recorder->AddScaledFont(aFont);
  }

  mRecorder->RecordEvent(RecordedFillGlyphs(this, aFont, aPattern, aOptions, aBuffer.mGlyphs, aBuffer.mNumGlyphs));
}

void
DrawTargetRecording::Mask(const Pattern &aSource,
                          const Pattern &aMask,
                          const DrawOptions &aOptions)
{
  EnsurePatternDependenciesStored(aSource);
  EnsurePatternDependenciesStored(aMask);

  mRecorder->RecordEvent(RecordedMask(this, aSource, aMask, aOptions));
}

void
DrawTargetRecording::MaskSurface(const Pattern &aSource,
                                 SourceSurface *aMask,
                                 Point aOffset,
                                 const DrawOptions &aOptions)
{
  EnsurePatternDependenciesStored(aSource);
  EnsureSurfaceStoredRecording(mRecorder, aMask, "MaskSurface");

  mRecorder->RecordEvent(RecordedMaskSurface(this, aSource, aMask, aOffset, aOptions));
}

void
DrawTargetRecording::Stroke(const Path *aPath,
                            const Pattern &aPattern,
                            const StrokeOptions &aStrokeOptions,
                            const DrawOptions &aOptions)
{
  RefPtr<PathRecording> pathRecording = EnsurePathStored(aPath);
  EnsurePatternDependenciesStored(aPattern);

  mRecorder->RecordEvent(RecordedStroke(this, pathRecording, aPattern, aStrokeOptions, aOptions));
}

already_AddRefed<SourceSurface>
DrawTargetRecording::Snapshot()
{
  RefPtr<SourceSurface> retSurf = new SourceSurfaceRecording(mSize, mFormat, mRecorder);

  mRecorder->RecordEvent(RecordedSnapshot(retSurf, this));

  return retSurf.forget();
}

already_AddRefed<SourceSurface>
DrawTargetRecording::IntoLuminanceSource(LuminanceType aLuminanceType, float aOpacity)
{
  RefPtr<SourceSurface> retSurf = new SourceSurfaceRecording(mSize, SurfaceFormat::A8, mRecorder);

  mRecorder->RecordEvent(RecordedIntoLuminanceSource(retSurf, this, aLuminanceType, aOpacity));

  return retSurf.forget();
}

void
DrawTargetRecording::DetachAllSnapshots()
{
}

void
DrawTargetRecording::DrawSurface(SourceSurface *aSurface,
                                 const Rect &aDest,
                                 const Rect &aSource,
                                 const DrawSurfaceOptions &aSurfOptions,
                                 const DrawOptions &aOptions)
{
  EnsureSurfaceStoredRecording(mRecorder, aSurface, "DrawSurface");

  mRecorder->RecordEvent(RecordedDrawSurface(this, aSurface, aDest, aSource, aSurfOptions, aOptions));
}

void
DrawTargetRecording::DrawSurfaceWithShadow(SourceSurface *aSurface,
                                           const Point &aDest,
                                           const Color &aColor,
                                           const Point &aOffset,
                                           Float aSigma,
                                           CompositionOp aOp)
{
  EnsureSurfaceStoredRecording(mRecorder, aSurface, "DrawSurfaceWithShadow");

  mRecorder->RecordEvent(RecordedDrawSurfaceWithShadow(this, aSurface, aDest, aColor, aOffset, aSigma, aOp));
}

void
DrawTargetRecording::DrawFilter(FilterNode *aNode,
                                const Rect &aSourceRect,
                                const Point &aDestPoint,
                                const DrawOptions &aOptions)
{
  MOZ_ASSERT(mRecorder->HasStoredObject(aNode));

  mRecorder->RecordEvent(RecordedDrawFilter(this, aNode, aSourceRect, aDestPoint, aOptions));
}

already_AddRefed<FilterNode>
DrawTargetRecording::CreateFilter(FilterType aType)
{
  RefPtr<FilterNode> retNode = new FilterNodeRecording(mRecorder);

  mRecorder->RecordEvent(RecordedFilterNodeCreation(retNode, aType));

  return retNode.forget();
}

void
DrawTargetRecording::ClearRect(const Rect &aRect)
{
  mRecorder->RecordEvent(RecordedClearRect(this, aRect));
}

void
DrawTargetRecording::CopySurface(SourceSurface *aSurface,
                                 const IntRect &aSourceRect,
                                 const IntPoint &aDestination)
{
  EnsureSurfaceStoredRecording(mRecorder, aSurface, "CopySurface");

  mRecorder->RecordEvent(RecordedCopySurface(this, aSurface, aSourceRect, aDestination));
}

void
DrawTargetRecording::PushClip(const Path *aPath)
{
  RefPtr<PathRecording> pathRecording = EnsurePathStored(aPath);

  mRecorder->RecordEvent(RecordedPushClip(this, pathRecording));
}

void
DrawTargetRecording::PushClipRect(const Rect &aRect)
{
  mRecorder->RecordEvent(RecordedPushClipRect(this, aRect));
}

void
DrawTargetRecording::PopClip()
{
  mRecorder->RecordEvent(RecordedPopClip(static_cast<DrawTarget*>(this)));
}

void
DrawTargetRecording::PushLayer(bool aOpaque, Float aOpacity,
                               SourceSurface* aMask,
                               const Matrix& aMaskTransform,
                               const IntRect& aBounds, bool aCopyBackground)
{
  if (aMask) {
    EnsureSurfaceStoredRecording(mRecorder, aMask, "PushLayer");
  }

  mRecorder->RecordEvent(RecordedPushLayer(this, aOpaque, aOpacity, aMask,
                                           aMaskTransform, aBounds,
                                           aCopyBackground));
}

void
DrawTargetRecording::PopLayer()
{
  mRecorder->RecordEvent(RecordedPopLayer(static_cast<DrawTarget*>(this)));
}

already_AddRefed<SourceSurface>
DrawTargetRecording::CreateSourceSurfaceFromData(unsigned char *aData,
                                                 const IntSize &aSize,
                                                 int32_t aStride,
                                                 SurfaceFormat aFormat) const
{
  RefPtr<SourceSurface> surf = DataSourceSurfaceRecording::Init(aData, aSize, aStride, aFormat);

  RefPtr<SourceSurface> retSurf = new SourceSurfaceRecording(aSize, aFormat, mRecorder);

  mRecorder->RecordEvent(RecordedSourceSurfaceCreation(retSurf, aData, aStride, aSize, aFormat));

  return retSurf.forget();
}

already_AddRefed<SourceSurface>
DrawTargetRecording::OptimizeSourceSurface(SourceSurface *aSurface) const
{
  RefPtr<SourceSurface> surf(aSurface);
  return surf.forget();
}

already_AddRefed<SourceSurface>
DrawTargetRecording::CreateSourceSurfaceFromNativeSurface(const NativeSurface &aSurface) const
{
  MOZ_ASSERT(false);
  return nullptr;
}

already_AddRefed<DrawTarget>
DrawTargetRecording::CreateSimilarDrawTarget(const IntSize &aSize, SurfaceFormat aFormat) const
{
  RefPtr<DrawTarget> similarDT = new DrawTargetRecording(this, aSize, aFormat);
  return similarDT.forget();
}

already_AddRefed<PathBuilder>
DrawTargetRecording::CreatePathBuilder(FillRule aFillRule) const
{
  RefPtr<PathBuilder> builder = mFinalDT->CreatePathBuilder(aFillRule);
  return MakeAndAddRef<PathBuilderRecording>(builder, aFillRule);
}

already_AddRefed<GradientStops>
DrawTargetRecording::CreateGradientStops(GradientStop *aStops,
                                         uint32_t aNumStops,
                                         ExtendMode aExtendMode) const
{
  RefPtr<GradientStops> retStops = new GradientStopsRecording(mRecorder);

  mRecorder->RecordEvent(RecordedGradientStopsCreation(retStops, aStops, aNumStops, aExtendMode));

  return retStops.forget();
}

void
DrawTargetRecording::SetTransform(const Matrix &aTransform)
{
  mRecorder->RecordEvent(RecordedSetTransform(this, aTransform));
  DrawTarget::SetTransform(aTransform);
}

already_AddRefed<PathRecording>
DrawTargetRecording::EnsurePathStored(const Path *aPath)
{
  RefPtr<PathRecording> pathRecording;
  if (aPath->GetBackendType() == BackendType::RECORDING) {
    pathRecording = const_cast<PathRecording*>(static_cast<const PathRecording*>(aPath));
    if (mRecorder->HasStoredObject(aPath)) {
      return pathRecording.forget();
    }
  } else {
    MOZ_ASSERT(!mRecorder->HasStoredObject(aPath));
    FillRule fillRule = aPath->GetFillRule();
    RefPtr<PathBuilder> builder = mFinalDT->CreatePathBuilder(fillRule);
    RefPtr<PathBuilderRecording> builderRecording =
      new PathBuilderRecording(builder, fillRule);
    aPath->StreamToSink(builderRecording);
    pathRecording = builderRecording->Finish().downcast<PathRecording>();
  }

  mRecorder->RecordEvent(RecordedPathCreation(pathRecording.get()));
  mRecorder->AddStoredObject(pathRecording);
  pathRecording->mStoredRecorders.push_back(mRecorder);

  return pathRecording.forget();
}

void
DrawTargetRecording::EnsurePatternDependenciesStored(const Pattern &aPattern)
{
  switch (aPattern.GetType()) {
  case PatternType::COLOR:
    // No dependencies here.
    return;
  case PatternType::LINEAR_GRADIENT:
    {
      MOZ_ASSERT(mRecorder->HasStoredObject(static_cast<const LinearGradientPattern*>(&aPattern)->mStops));
      return;
    }
  case PatternType::RADIAL_GRADIENT:
    {
      MOZ_ASSERT(mRecorder->HasStoredObject(static_cast<const RadialGradientPattern*>(&aPattern)->mStops));
      return;
    }
  case PatternType::SURFACE:
    {
      const SurfacePattern *pat = static_cast<const SurfacePattern*>(&aPattern);
      EnsureSurfaceStoredRecording(mRecorder, pat->mSurface, "EnsurePatternDependenciesStored");
      return;
    }
  }
}

} // namespace gfx
} // namespace mozilla
