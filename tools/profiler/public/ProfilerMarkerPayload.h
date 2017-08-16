/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef PROFILER_MARKERS_H
#define PROFILER_MARKERS_H

#include "mozilla/TimeStamp.h"
#include "mozilla/Attributes.h"
#include "mozilla/RefPtr.h"

#include "nsString.h"
#include "GeckoProfiler.h"

#include "js/Utility.h"
#include "gfxASurface.h"

namespace mozilla {
namespace layers {
class Layer;
} // namespace layers
} // namespace mozilla

class SpliceableJSONWriter;
class UniqueStacks;

/**
 * This is an abstract object that can be implied to supply
 * data to be attached with a profiler marker. Most data inserted
 * into a profile is stored in a circular buffer. This buffer
 * typically wraps around and overwrites most entries. Because
 * of this, this structure is designed to defer the work of
 * prepare the payload only when 'preparePayload' is called.
 *
 * Note when implementing that this object is typically constructed
 * on a particular thread but 'preparePayload' and the destructor
 * is called from the main thread.
 */
class ProfilerMarkerPayload
{
public:
  explicit ProfilerMarkerPayload(UniqueProfilerBacktrace aStack = nullptr);
  ProfilerMarkerPayload(const mozilla::TimeStamp& aStartTime,
                        const mozilla::TimeStamp& aEndTime,
                        UniqueProfilerBacktrace aStack = nullptr);

  /**
   * Called from the main thread
   */
  virtual ~ProfilerMarkerPayload();

  /**
   * Called from the main thread
   */
  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) = 0;

  mozilla::TimeStamp GetStartTime() const { return mStartTime; }

protected:
  /**
   * Called from the main thread
   */
  void streamCommonProps(const char* aMarkerType,
                         SpliceableJSONWriter& aWriter,
                         const mozilla::TimeStamp& aProcessStartTime,
                         UniqueStacks& aUniqueStacks);

  void SetStack(UniqueProfilerBacktrace aStack) { mStack = mozilla::Move(aStack); }

private:
  mozilla::TimeStamp  mStartTime;
  mozilla::TimeStamp  mEndTime;
  UniqueProfilerBacktrace  mStack;
};

class ProfilerMarkerTracing : public ProfilerMarkerPayload
{
public:
  ProfilerMarkerTracing(const char* aCategory, TracingKind aKind);
  ProfilerMarkerTracing(const char* aCategory, TracingKind aKind,
                        UniqueProfilerBacktrace aCause);

  const char *GetCategory() const { return mCategory; }
  TracingKind GetKind() const { return mKind; }

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  const char *mCategory;
  TracingKind mKind;
};

class ProfilerMarkerImagePayload : public ProfilerMarkerPayload
{
public:
  explicit ProfilerMarkerImagePayload(gfxASurface *aImg);

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  RefPtr<gfxASurface> mImg;
};

class IOMarkerPayload : public ProfilerMarkerPayload
{
public:
  IOMarkerPayload(const char* aSource, const char* aFilename,
                  const mozilla::TimeStamp& aStartTime,
                  const mozilla::TimeStamp& aEndTime,
                  UniqueProfilerBacktrace aStack);
  ~IOMarkerPayload();

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  const char* mSource;
  char* mFilename;
};

class DOMEventMarkerPayload : public ProfilerMarkerPayload
{
public:
  DOMEventMarkerPayload(const nsAString& aType, uint16_t aPhase,
                        const mozilla::TimeStamp& aStartTime,
                        const mozilla::TimeStamp& aEndTime);
  ~DOMEventMarkerPayload();

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  nsString mType;
  uint16_t mPhase;
};

class UserTimingMarkerPayload : public ProfilerMarkerPayload
{
public:
  UserTimingMarkerPayload(const nsAString& aName,
                          const mozilla::TimeStamp& aStartTime);
  UserTimingMarkerPayload(const nsAString& aName,
                          const mozilla::TimeStamp& aStartTime,
                          const mozilla::TimeStamp& aEndTime);
  ~UserTimingMarkerPayload();

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  // Either "mark" or "measure".
  const char* mEntryType;
  nsString mName;
};

/**
 * Contains the translation applied to a 2d layer so we can
 * track the layer position at each frame.
 */
class LayerTranslationPayload : public ProfilerMarkerPayload
{
public:
  LayerTranslationPayload(mozilla::layers::Layer* aLayer,
                          mozilla::gfx::Point aPoint);

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  mozilla::layers::Layer* mLayer;
  mozilla::gfx::Point mPoint;
};

#include "Units.h"    // For ScreenIntPoint

/**
 * Tracks when touch events are processed by gecko, not when
 * the touch actually occured in gonk/android.
 */
class TouchDataPayload : public ProfilerMarkerPayload
{
public:
  explicit TouchDataPayload(const mozilla::ScreenIntPoint& aPoint);
  virtual ~TouchDataPayload() {}

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  mozilla::ScreenIntPoint mPoint;
};

/**
 * Tracks when a vsync occurs according to the HardwareComposer.
 */
class VsyncPayload : public ProfilerMarkerPayload
{
public:
  explicit VsyncPayload(mozilla::TimeStamp aVsyncTimestamp);
  virtual ~VsyncPayload() {}

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  mozilla::TimeStamp mVsyncTimestamp;
};

class GPUMarkerPayload : public ProfilerMarkerPayload
{
public:
  GPUMarkerPayload(const mozilla::TimeStamp& aCpuTimeStart,
                   const mozilla::TimeStamp& aCpuTimeEnd,
                   uint64_t aGpuTimeStart,
                   uint64_t aGpuTimeEnd);
  ~GPUMarkerPayload() {}

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) override;

private:
  mozilla::TimeStamp mCpuTimeStart;
  mozilla::TimeStamp mCpuTimeEnd;
  uint64_t mGpuTimeStart;
  uint64_t mGpuTimeEnd;
};

class GCSliceMarkerPayload : public ProfilerMarkerPayload
{
public:
  GCSliceMarkerPayload(const mozilla::TimeStamp& aStartTime,
                       const mozilla::TimeStamp& aEndTime,
                       JS::UniqueChars&& aTimingJSON)
   : ProfilerMarkerPayload(aStartTime, aEndTime, nullptr),
     mTimingJSON(mozilla::Move(aTimingJSON))
  {}

  virtual ~GCSliceMarkerPayload() {}

  void StreamPayload(SpliceableJSONWriter& aWriter,
                     const mozilla::TimeStamp& aProcessStartTime,
                     UniqueStacks& aUniqueStacks) override;

private:
  JS::UniqueChars mTimingJSON;
};

class GCMajorMarkerPayload : public ProfilerMarkerPayload
{
public:
  GCMajorMarkerPayload(const mozilla::TimeStamp& aStartTime,
                       const mozilla::TimeStamp& aEndTime,
                       JS::UniqueChars&& aTimingJSON)
   : ProfilerMarkerPayload(aStartTime, aEndTime, nullptr),
     mTimingJSON(mozilla::Move(aTimingJSON))
  {}

  virtual ~GCMajorMarkerPayload() {}

  void StreamPayload(SpliceableJSONWriter& aWriter,
                     const mozilla::TimeStamp& aProcessStartTime,
                     UniqueStacks& aUniqueStacks) override;

private:
  JS::UniqueChars mTimingJSON;
};

class GCMinorMarkerPayload : public ProfilerMarkerPayload
{
public:
  GCMinorMarkerPayload(const mozilla::TimeStamp& aStartTime,
                       const mozilla::TimeStamp& aEndTime,
                       JS::UniqueChars&& aTimingData)
   : ProfilerMarkerPayload(aStartTime, aEndTime, nullptr),
     mTimingData(mozilla::Move(aTimingData))
  {}

  virtual ~GCMinorMarkerPayload() {};

  void StreamPayload(SpliceableJSONWriter& aWriter,
                     const mozilla::TimeStamp& aProcessStartTime,
                     UniqueStacks& aUniqueStacks) override;

private:
  JS::UniqueChars mTimingData;
};


#endif // PROFILER_MARKERS_H
