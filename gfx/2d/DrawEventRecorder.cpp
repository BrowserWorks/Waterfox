/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "DrawEventRecorder.h"
#include "PathRecording.h"
#include "RecordingTypes.h"
#include "RecordedEventImpl.h"

namespace mozilla {
namespace gfx {

DrawEventRecorderPrivate::DrawEventRecorderPrivate() : mExternalFonts(false) {}

void DrawEventRecorderPrivate::StoreExternalSurfaceRecording(
    SourceSurface* aSurface, uint64_t aKey) {
  RecordEvent(RecordedExternalSurfaceCreation(aSurface, aKey));
  mExternalSurfaces.push_back(aSurface);
}

void DrawEventRecorderPrivate::StoreSourceSurfaceRecording(
    SourceSurface* aSurface, const char* aReason) {
  RefPtr<DataSourceSurface> dataSurf = aSurface->GetDataSurface();
  IntSize surfaceSize = aSurface->GetSize();
  if (!dataSurf || !Factory::AllowedSurfaceSize(surfaceSize)) {
    gfxWarning() << "Recording failed to record SourceSurface for " << aReason;

    // If surface size is not allowed, replace with reasonable size.
    if (!Factory::AllowedSurfaceSize(surfaceSize)) {
      surfaceSize.width = std::min(surfaceSize.width, kReasonableSurfaceSize);
      surfaceSize.height = std::min(surfaceSize.height, kReasonableSurfaceSize);
    }

    // Insert a dummy source surface.
    int32_t stride = surfaceSize.width * BytesPerPixel(aSurface->GetFormat());
    UniquePtr<uint8_t[]> sourceData(new uint8_t[stride * surfaceSize.height]());
    RecordEvent(RecordedSourceSurfaceCreation(aSurface, sourceData.get(),
                                              stride, surfaceSize,
                                              aSurface->GetFormat()));
    return;
  }

  DataSourceSurface::ScopedMap map(dataSurf, DataSourceSurface::READ);
  RecordEvent(RecordedSourceSurfaceCreation(
      aSurface, map.GetData(), map.GetStride(), dataSurf->GetSize(),
      dataSurf->GetFormat()));
}

void DrawEventRecorderPrivate::RecordSourceSurfaceDestruction(void* aSurface) {
  RemoveSourceSurface(static_cast<SourceSurface*>(aSurface));
  RemoveStoredObject(aSurface);
  RecordEvent(RecordedSourceSurfaceDestruction(ReferencePtr(aSurface)));
}

void DrawEventRecorderPrivate::DecrementUnscaledFontRefCount(
    const ReferencePtr aUnscaledFont) {
  auto element = mUnscaledFontRefs.find(aUnscaledFont);
  MOZ_DIAGNOSTIC_ASSERT(element != mUnscaledFontRefs.end(),
                        "DecrementUnscaledFontRefCount calls should balance "
                        "with IncrementUnscaledFontRefCount calls");
  if (--(element->second) <= 0) {
    RecordEvent(RecordedUnscaledFontDestruction(aUnscaledFont));
    mUnscaledFontRefs.erase(aUnscaledFont);
  }
}

void DrawEventRecorderFile::RecordEvent(const RecordedEvent& aEvent) {
  aEvent.RecordToStream(mOutputStream);

  Flush();
}

void DrawEventRecorderMemory::RecordEvent(const RecordedEvent& aEvent) {
  aEvent.RecordToStream(mOutputStream);
}

void DrawEventRecorderMemory::AddDependentSurface(uint64_t aDependencyId) {
  mDependentSurfaces.PutEntry(aDependencyId);
}

nsTHashtable<nsUint64HashKey>&&
DrawEventRecorderMemory::TakeDependentSurfaces() {
  return std::move(mDependentSurfaces);
}

DrawEventRecorderFile::DrawEventRecorderFile(const char_type* aFilename)
    : mOutputStream(aFilename, std::ofstream::binary) {
  WriteHeader(mOutputStream);
}

DrawEventRecorderFile::~DrawEventRecorderFile() { mOutputStream.close(); }

void DrawEventRecorderFile::Flush() { mOutputStream.flush(); }

bool DrawEventRecorderFile::IsOpen() { return mOutputStream.is_open(); }

void DrawEventRecorderFile::OpenNew(const char_type* aFilename) {
  MOZ_ASSERT(!mOutputStream.is_open());

  mOutputStream.open(aFilename, std::ofstream::binary);
  WriteHeader(mOutputStream);
}

void DrawEventRecorderFile::Close() {
  MOZ_ASSERT(mOutputStream.is_open());

  mOutputStream.close();
}

DrawEventRecorderMemory::DrawEventRecorderMemory() {
  WriteHeader(mOutputStream);
}

DrawEventRecorderMemory::DrawEventRecorderMemory(
    const SerializeResourcesFn& aFn)
    : mSerializeCallback(aFn) {
  mExternalFonts = !!mSerializeCallback;
  WriteHeader(mOutputStream);
}

void DrawEventRecorderMemory::Flush() {}

void DrawEventRecorderMemory::FlushItem(IntRect aRect) {
  MOZ_RELEASE_ASSERT(!aRect.IsEmpty());
  // Detaching our existing resources will add some
  // destruction events to our stream so we need to do that
  // first.
  DetachResources();

  // See moz2d_renderer.rs for a description of the stream format
  WriteElement(mIndex, mOutputStream.mLength);

  // write out the fonts into the extra data section
  mSerializeCallback(mOutputStream, mScaledFonts);
  WriteElement(mIndex, mOutputStream.mLength);

  WriteElement(mIndex, aRect.x);
  WriteElement(mIndex, aRect.y);
  WriteElement(mIndex, aRect.XMost());
  WriteElement(mIndex, aRect.YMost());
  ClearResources();

  // write out a new header for the next recording in the stream
  WriteHeader(mOutputStream);
}

bool DrawEventRecorderMemory::Finish() {
  // this length might be 0, and things should still work.
  // for example if there are no items in a particular area
  size_t indexOffset = mOutputStream.mLength;
  // write out the index
  mOutputStream.write(mIndex.mData, mIndex.mLength);
  bool hasItems = mIndex.mLength != 0;
  mIndex = MemStream();
  // write out the offset of the Index to the end of the output stream
  WriteElement(mOutputStream, indexOffset);
  ClearResources();
  return hasItems;
}

size_t DrawEventRecorderMemory::RecordingSize() {
  return mOutputStream.mLength;
}

void DrawEventRecorderMemory::WipeRecording() {
  mOutputStream = MemStream();
  mIndex = MemStream();

  WriteHeader(mOutputStream);
}

}  // namespace gfx
}  // namespace mozilla
