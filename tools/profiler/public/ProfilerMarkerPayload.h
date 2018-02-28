/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef ProfilerMarkerPayload_h
#define ProfilerMarkerPayload_h

#include "mozilla/Attributes.h"
#include "mozilla/RefPtr.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/UniquePtrExtensions.h"

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

// This is an abstract class that can be implemented to supply data to be
// attached with a profiler marker.
//
// When subclassing this, note that the destructor can be called on any thread,
// i.e. not necessarily on the thread that created the object.
class ProfilerMarkerPayload
{
public:
  explicit ProfilerMarkerPayload(UniqueProfilerBacktrace aStack = nullptr)
    : mStack(Move(aStack))
  {}

  ProfilerMarkerPayload(const mozilla::TimeStamp& aStartTime,
                        const mozilla::TimeStamp& aEndTime,
                        UniqueProfilerBacktrace aStack = nullptr)
    : mStartTime(aStartTime)
    , mEndTime(aEndTime)
    , mStack(Move(aStack))
  {}

  virtual ~ProfilerMarkerPayload() {}

  virtual void StreamPayload(SpliceableJSONWriter& aWriter,
                             const mozilla::TimeStamp& aProcessStartTime,
                             UniqueStacks& aUniqueStacks) = 0;

  mozilla::TimeStamp GetStartTime() const { return mStartTime; }

protected:
  void StreamCommonProps(const char* aMarkerType,
                         SpliceableJSONWriter& aWriter,
                         const mozilla::TimeStamp& aProcessStartTime,
                         UniqueStacks& aUniqueStacks);

  void SetStack(UniqueProfilerBacktrace aStack)
  {
    mStack = mozilla::Move(aStack);
  }

private:
  mozilla::TimeStamp mStartTime;
  mozilla::TimeStamp mEndTime;
  UniqueProfilerBacktrace mStack;
};

#define DECL_STREAM_PAYLOAD_BASE  \
  virtual void StreamPayload(SpliceableJSONWriter& aWriter, \
                             const mozilla::TimeStamp& aProcessStartTime, \
                             UniqueStacks& aUniqueStacks) override

// If the profiler is disabled then StreamPayload() will never be called.
#ifdef MOZ_GECKO_PROFILER
# define DECL_STREAM_PAYLOAD DECL_STREAM_PAYLOAD_BASE ;
#else
# define DECL_STREAM_PAYLOAD DECL_STREAM_PAYLOAD_BASE { MOZ_CRASH(); }
#endif

class TracingMarkerPayload : public ProfilerMarkerPayload
{
public:
  TracingMarkerPayload(const char* aCategory, TracingKind aKind,
                       UniqueProfilerBacktrace aCause = nullptr)
    : mCategory(aCategory)
    , mKind(aKind)
  {
    if (aCause) {
      SetStack(Move(aCause));
    }
  }

  DECL_STREAM_PAYLOAD

private:
  const char *mCategory;
  TracingKind mKind;
};

class IOMarkerPayload : public ProfilerMarkerPayload
{
public:
  IOMarkerPayload(const char* aSource, const char* aFilename,
                  const mozilla::TimeStamp& aStartTime,
                  const mozilla::TimeStamp& aEndTime,
                  UniqueProfilerBacktrace aStack)
    : ProfilerMarkerPayload(aStartTime, aEndTime, Move(aStack))
    , mSource(aSource)
    , mFilename(aFilename ? strdup(aFilename) : nullptr)
  {
    MOZ_ASSERT(aSource);
  }

  DECL_STREAM_PAYLOAD

private:
  const char* mSource;
  mozilla::UniqueFreePtr<char> mFilename;
};

class DOMEventMarkerPayload : public ProfilerMarkerPayload
{
public:
  DOMEventMarkerPayload(const nsAString& aEventType, uint16_t aPhase,
                        const mozilla::TimeStamp& aStartTime,
                        const mozilla::TimeStamp& aEndTime)
    : ProfilerMarkerPayload(aStartTime, aEndTime)
    , mEventType(aEventType)
    , mPhase(aPhase)
  {}

  DECL_STREAM_PAYLOAD

private:
  nsString mEventType;
  uint16_t mPhase;
};

class UserTimingMarkerPayload : public ProfilerMarkerPayload
{
public:
  UserTimingMarkerPayload(const nsAString& aName,
                          const mozilla::TimeStamp& aStartTime)
    : ProfilerMarkerPayload(aStartTime, aStartTime)
    , mEntryType("mark")
    , mName(aName)
  {}

  UserTimingMarkerPayload(const nsAString& aName,
                          const mozilla::TimeStamp& aStartTime,
                          const mozilla::TimeStamp& aEndTime)
    : ProfilerMarkerPayload(aStartTime, aEndTime)
    , mEntryType("measure")
    , mName(aName)
  {}

  DECL_STREAM_PAYLOAD

private:
  // Either "mark" or "measure".
  const char* mEntryType;
  nsString mName;
};

// Contains the translation applied to a 2d layer so we can track the layer
// position at each frame.
class LayerTranslationMarkerPayload : public ProfilerMarkerPayload
{
public:
  LayerTranslationMarkerPayload(mozilla::layers::Layer* aLayer,
                                mozilla::gfx::Point aPoint,
                                mozilla::TimeStamp aStartTime)
    : ProfilerMarkerPayload(aStartTime, aStartTime)
    , mLayer(aLayer)
    , mPoint(aPoint)
  {}

  DECL_STREAM_PAYLOAD

private:
  mozilla::layers::Layer* mLayer;
  mozilla::gfx::Point mPoint;
};

#include "Units.h"    // For ScreenIntPoint

// Tracks when a vsync occurs according to the HardwareComposer.
class VsyncMarkerPayload : public ProfilerMarkerPayload
{
public:
  explicit VsyncMarkerPayload(mozilla::TimeStamp aVsyncTimestamp)
    : ProfilerMarkerPayload(aVsyncTimestamp, aVsyncTimestamp)
    , mVsyncTimestamp(aVsyncTimestamp)
  {}

  DECL_STREAM_PAYLOAD

private:
  mozilla::TimeStamp mVsyncTimestamp;
};

class GPUMarkerPayload : public ProfilerMarkerPayload
{
public:
  GPUMarkerPayload(const mozilla::TimeStamp& aCpuTimeStart,
                   const mozilla::TimeStamp& aCpuTimeEnd,
                   uint64_t aGpuTimeStart,
                   uint64_t aGpuTimeEnd)
    : ProfilerMarkerPayload(aCpuTimeStart, aCpuTimeEnd)
    , mCpuTimeStart(aCpuTimeStart)
    , mCpuTimeEnd(aCpuTimeEnd)
    , mGpuTimeStart(aGpuTimeStart)
    , mGpuTimeEnd(aGpuTimeEnd)
  {}

  DECL_STREAM_PAYLOAD

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
   : ProfilerMarkerPayload(aStartTime, aEndTime),
     mTimingJSON(mozilla::Move(aTimingJSON))
  {}

  DECL_STREAM_PAYLOAD

private:
  JS::UniqueChars mTimingJSON;
};

class GCMajorMarkerPayload : public ProfilerMarkerPayload
{
public:
  GCMajorMarkerPayload(const mozilla::TimeStamp& aStartTime,
                       const mozilla::TimeStamp& aEndTime,
                       JS::UniqueChars&& aTimingJSON)
   : ProfilerMarkerPayload(aStartTime, aEndTime),
     mTimingJSON(mozilla::Move(aTimingJSON))
  {}

  DECL_STREAM_PAYLOAD

private:
  JS::UniqueChars mTimingJSON;
};

class GCMinorMarkerPayload : public ProfilerMarkerPayload
{
public:
  GCMinorMarkerPayload(const mozilla::TimeStamp& aStartTime,
                       const mozilla::TimeStamp& aEndTime,
                       JS::UniqueChars&& aTimingData)
   : ProfilerMarkerPayload(aStartTime, aEndTime),
     mTimingData(mozilla::Move(aTimingData))
  {}

  DECL_STREAM_PAYLOAD

private:
  JS::UniqueChars mTimingData;
};

#endif // ProfilerMarkerPayload_h
