/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_SOURCEBUFFERRESOURCE_H_
#define MOZILLA_SOURCEBUFFERRESOURCE_H_

#include "MediaCache.h"
#include "MediaResource.h"
#include "ResourceQueue.h"
#include "mozilla/Attributes.h"
#include "nsCOMPtr.h"
#include "nsError.h"
#include "nsIPrincipal.h"
#include "nsTArray.h"
#include "nscore.h"
#include "mozilla/Logging.h"

#define UNIMPLEMENTED() { /* Logging this is too spammy to do by default */ }

class nsIStreamListener;

namespace mozilla {

class MediaDecoder;
class MediaByteBuffer;
class TaskQueue;

namespace dom {

class SourceBuffer;

} // namespace dom

// SourceBufferResource is not thread safe.
class SourceBufferResource final : public MediaResource
{
public:
  explicit SourceBufferResource(const MediaContainerType& aType);
  nsresult Close() override;
  void Suspend(bool aCloseImmediately) override { UNIMPLEMENTED(); }
  void Resume() override { UNIMPLEMENTED(); }
  already_AddRefed<nsIPrincipal> GetCurrentPrincipal() override
  {
    UNIMPLEMENTED();
    return nullptr;
  }
  already_AddRefed<MediaResource> CloneData(MediaResourceCallback*) override
  {
    UNIMPLEMENTED();
    return nullptr;
  }
  void SetReadMode(MediaCacheStream::ReadMode aMode) override
  {
    UNIMPLEMENTED();
  }
  void SetPlaybackRate(uint32_t aBytesPerSecond) override { UNIMPLEMENTED(); }
  nsresult ReadAt(int64_t aOffset,
                  char* aBuffer,
                  uint32_t aCount,
                  uint32_t* aBytes) override;
  // Memory-based and no locks, caching discouraged.
  bool ShouldCacheReads() override { return false; }
  int64_t Tell() override { return mOffset; }
  void Pin() override { UNIMPLEMENTED(); }
  void Unpin() override { UNIMPLEMENTED(); }
  double GetDownloadRate(bool* aIsReliable) override
  {
    UNIMPLEMENTED();
    *aIsReliable = false;
    return 0;
  }
  int64_t GetLength() override { return mInputBuffer.GetLength(); }
  int64_t GetNextCachedData(int64_t aOffset) override
  {
    MOZ_ASSERT(OnTaskQueue());
    MOZ_ASSERT(aOffset >= 0);
    if (uint64_t(aOffset) < mInputBuffer.GetOffset()) {
      return mInputBuffer.GetOffset();
    } else if (aOffset == GetLength()) {
      return -1;
    }
    return aOffset;
  }
  int64_t GetCachedDataEnd(int64_t aOffset) override
  {
    MOZ_ASSERT(OnTaskQueue());
    MOZ_ASSERT(aOffset >= 0);
    if (uint64_t(aOffset) < mInputBuffer.GetOffset() ||
        aOffset >= GetLength()) {
      // aOffset is outside of the buffered range.
      return aOffset;
    }
    return GetLength();
  }
  bool IsDataCachedToEndOfResource(int64_t aOffset) override { return false; }
  bool IsSuspendedByCache() override
  {
    UNIMPLEMENTED();
    return false;
  }
  bool IsSuspended() override
  {
    UNIMPLEMENTED();
    return false;
  }
  nsresult ReadFromCache(char* aBuffer,
                         int64_t aOffset,
                         uint32_t aCount) override;
  bool IsTransportSeekable() override
  {
    UNIMPLEMENTED();
    return true;
  }
  nsresult Open(nsIStreamListener** aStreamListener) override
  {
    UNIMPLEMENTED();
    return NS_ERROR_FAILURE;
  }

  nsresult GetCachedRanges(MediaByteRangeSet& aRanges) override
  {
    MOZ_ASSERT(OnTaskQueue());
    if (mInputBuffer.GetLength()) {
      aRanges += MediaByteRange(mInputBuffer.GetOffset(),
                                mInputBuffer.GetLength());
    }
    return NS_OK;
  }

  const MediaContainerType& GetContentType() const override { return mType; }

  size_t SizeOfExcludingThis(MallocSizeOf aMallocSizeOf) const override
  {
    MOZ_ASSERT(OnTaskQueue());

    size_t size = MediaResource::SizeOfExcludingThis(aMallocSizeOf);
    size += mType.SizeOfExcludingThis(aMallocSizeOf);
    size += mInputBuffer.SizeOfExcludingThis(aMallocSizeOf);

    return size;
  }

  size_t SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const override
  {
    return aMallocSizeOf(this) + SizeOfExcludingThis(aMallocSizeOf);
  }

  bool IsExpectingMoreData() override
  {
    return false;
  }

  // Used by SourceBuffer.
  void AppendData(MediaByteBuffer* aData);
  void Ended();
  bool IsEnded()
  {
    MOZ_ASSERT(OnTaskQueue());
    return mEnded;
  }
  // Remove data from resource if it holds more than the threshold reduced by
  // the given number of bytes. Returns amount evicted.
  uint32_t EvictData(uint64_t aPlaybackOffset, int64_t aThresholdReduct,
                     ErrorResult& aRv);

  // Remove data from resource before the given offset.
  void EvictBefore(uint64_t aOffset, ErrorResult& aRv);

  // Remove all data from the resource
  uint32_t EvictAll();

  // Returns the amount of data currently retained by this resource.
  int64_t GetSize()
  {
    MOZ_ASSERT(OnTaskQueue());
    return mInputBuffer.GetLength() - mInputBuffer.GetOffset();
  }

#if defined(DEBUG)
  void Dump(const char* aPath)
  {
    mInputBuffer.Dump(aPath);
  }
#endif

private:
  virtual ~SourceBufferResource();
  nsresult ReadAtInternal(int64_t aOffset,
                          char* aBuffer,
                          uint32_t aCount,
                          uint32_t* aBytes);
  const MediaContainerType mType;

#if defined(DEBUG)
  const RefPtr<TaskQueue> mTaskQueue;
  // TaskQueue methods and objects.
  AbstractThread* GetTaskQueue() const;
  bool OnTaskQueue() const;
#endif

  // The buffer holding resource data.
  ResourceQueue mInputBuffer;

  uint64_t mOffset;
  bool mClosed;
  bool mEnded;
};

} // namespace mozilla

#undef UNIMPLEMENTED

#endif /* MOZILLA_SOURCEBUFFERRESOURCE_H_ */
