/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * The multiplex stream concatenates a list of input streams into a single
 * stream.
 */

#include "mozilla/Attributes.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/Mutex.h"
#include "mozilla/SystemGroup.h"

#include "base/basictypes.h"

#include "nsMultiplexInputStream.h"
#include "nsICloneableInputStream.h"
#include "nsIMultiplexInputStream.h"
#include "nsISeekableStream.h"
#include "nsCOMPtr.h"
#include "nsCOMArray.h"
#include "nsIClassInfoImpl.h"
#include "nsIIPCSerializableInputStream.h"
#include "mozilla/ipc/InputStreamUtils.h"
#include "nsIAsyncInputStream.h"

using namespace mozilla;
using namespace mozilla::ipc;

using mozilla::DeprecatedAbs;
using mozilla::Maybe;
using mozilla::Nothing;
using mozilla::Some;

class nsMultiplexInputStream final
  : public nsIMultiplexInputStream
  , public nsISeekableStream
  , public nsIIPCSerializableInputStream
  , public nsICloneableInputStream
  , public nsIAsyncInputStream
{
public:
  nsMultiplexInputStream();

  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIINPUTSTREAM
  NS_DECL_NSIMULTIPLEXINPUTSTREAM
  NS_DECL_NSISEEKABLESTREAM
  NS_DECL_NSIIPCSERIALIZABLEINPUTSTREAM
  NS_DECL_NSICLONEABLEINPUTSTREAM
  NS_DECL_NSIASYNCINPUTSTREAM

  void AsyncWaitCompleted();

private:
  ~nsMultiplexInputStream()
  {
  }

  struct MOZ_STACK_CLASS ReadSegmentsState
  {
    nsCOMPtr<nsIInputStream> mThisStream;
    uint32_t mOffset;
    nsWriteSegmentFun mWriter;
    void* mClosure;
    bool mDone;
  };

  static nsresult ReadSegCb(nsIInputStream* aIn, void* aClosure,
                            const char* aFromRawSegment, uint32_t aToOffset,
                            uint32_t aCount, uint32_t* aWriteCount);

  bool IsSeekable() const;
  bool IsIPCSerializable() const;
  bool IsCloneable() const;
  bool IsAsyncInputStream() const;

  Mutex mLock; // Protects access to all data members.
  nsTArray<nsCOMPtr<nsIInputStream>> mStreams;
  uint32_t mCurrentStream;
  bool mStartedReadingCurrent;
  nsresult mStatus;
  nsCOMPtr<nsIInputStreamCallback> mAsyncWaitCallback;
};

NS_IMPL_ADDREF(nsMultiplexInputStream)
NS_IMPL_RELEASE(nsMultiplexInputStream)

NS_IMPL_CLASSINFO(nsMultiplexInputStream, nullptr, nsIClassInfo::THREADSAFE,
                  NS_MULTIPLEXINPUTSTREAM_CID)

NS_INTERFACE_MAP_BEGIN(nsMultiplexInputStream)
  NS_INTERFACE_MAP_ENTRY(nsIMultiplexInputStream)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsIInputStream, nsIMultiplexInputStream)
  NS_INTERFACE_MAP_ENTRY_CONDITIONAL(nsISeekableStream, IsSeekable())
  NS_INTERFACE_MAP_ENTRY_CONDITIONAL(nsIIPCSerializableInputStream,
                                     IsIPCSerializable())
  NS_INTERFACE_MAP_ENTRY_CONDITIONAL(nsICloneableInputStream,
                                     IsCloneable())
  NS_INTERFACE_MAP_ENTRY_CONDITIONAL(nsIAsyncInputStream,
                                     IsAsyncInputStream())
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIMultiplexInputStream)
  NS_IMPL_QUERY_CLASSINFO(nsMultiplexInputStream)
NS_INTERFACE_MAP_END

NS_IMPL_CI_INTERFACE_GETTER(nsMultiplexInputStream,
                            nsIMultiplexInputStream,
                            nsIInputStream,
                            nsISeekableStream)

static nsresult
AvailableMaybeSeek(nsIInputStream* aStream, uint64_t* aResult)
{
  nsresult rv = aStream->Available(aResult);
  if (rv == NS_BASE_STREAM_CLOSED) {
    // Blindly seek to the current position if Available() returns
    // NS_BASE_STREAM_CLOSED.
    // If nsIFileInputStream is closed in Read() due to CLOSE_ON_EOF flag,
    // Seek() could reopen the file if REOPEN_ON_REWIND flag is set.
    nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(aStream);
    if (seekable) {
      nsresult rvSeek = seekable->Seek(nsISeekableStream::NS_SEEK_CUR, 0);
      if (NS_SUCCEEDED(rvSeek)) {
        rv = aStream->Available(aResult);
      }
    }
  }
  return rv;
}

static nsresult
TellMaybeSeek(nsISeekableStream* aSeekable, int64_t* aResult)
{
  nsresult rv = aSeekable->Tell(aResult);
  if (rv == NS_BASE_STREAM_CLOSED) {
    // Blindly seek to the current position if Tell() returns
    // NS_BASE_STREAM_CLOSED.
    // If nsIFileInputStream is closed in Read() due to CLOSE_ON_EOF flag,
    // Seek() could reopen the file if REOPEN_ON_REWIND flag is set.
    nsresult rvSeek = aSeekable->Seek(nsISeekableStream::NS_SEEK_CUR, 0);
    if (NS_SUCCEEDED(rvSeek)) {
      rv = aSeekable->Tell(aResult);
    }
  }
  return rv;
}

nsMultiplexInputStream::nsMultiplexInputStream()
  : mLock("nsMultiplexInputStream lock"),
    mCurrentStream(0),
    mStartedReadingCurrent(false),
    mStatus(NS_OK)
{
}

NS_IMETHODIMP
nsMultiplexInputStream::GetCount(uint32_t* aCount)
{
  MutexAutoLock lock(mLock);
  *aCount = mStreams.Length();
  return NS_OK;
}

NS_IMETHODIMP
nsMultiplexInputStream::AppendStream(nsIInputStream* aStream)
{
  MutexAutoLock lock(mLock);
  return mStreams.AppendElement(aStream) ? NS_OK : NS_ERROR_OUT_OF_MEMORY;
}

NS_IMETHODIMP
nsMultiplexInputStream::InsertStream(nsIInputStream* aStream, uint32_t aIndex)
{
  MutexAutoLock lock(mLock);
  mStreams.InsertElementAt(aIndex, aStream);
  if (mCurrentStream > aIndex ||
      (mCurrentStream == aIndex && mStartedReadingCurrent)) {
    ++mCurrentStream;
  }
  return NS_OK;
}

NS_IMETHODIMP
nsMultiplexInputStream::RemoveStream(uint32_t aIndex)
{
  MutexAutoLock lock(mLock);
  mStreams.RemoveElementAt(aIndex);
  if (mCurrentStream > aIndex) {
    --mCurrentStream;
  } else if (mCurrentStream == aIndex) {
    mStartedReadingCurrent = false;
  }

  return NS_OK;
}

NS_IMETHODIMP
nsMultiplexInputStream::GetStream(uint32_t aIndex, nsIInputStream** aResult)
{
  MutexAutoLock lock(mLock);
  *aResult = mStreams.SafeElementAt(aIndex, nullptr);
  if (NS_WARN_IF(!*aResult)) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_ADDREF(*aResult);
  return NS_OK;
}

NS_IMETHODIMP
nsMultiplexInputStream::Close()
{
  MutexAutoLock lock(mLock);
  mStatus = NS_BASE_STREAM_CLOSED;

  nsresult rv = NS_OK;

  uint32_t len = mStreams.Length();
  for (uint32_t i = 0; i < len; ++i) {
    nsresult rv2 = mStreams[i]->Close();
    // We still want to close all streams, but we should return an error
    if (NS_FAILED(rv2)) {
      rv = rv2;
    }
  }

  mAsyncWaitCallback = nullptr;

  return rv;
}

NS_IMETHODIMP
nsMultiplexInputStream::Available(uint64_t* aResult)
{
  MutexAutoLock lock(mLock);
  if (NS_FAILED(mStatus)) {
    return mStatus;
  }

  uint64_t avail = 0;

  uint32_t len = mStreams.Length();
  for (uint32_t i = mCurrentStream; i < len; i++) {
    uint64_t streamAvail;
    mStatus = AvailableMaybeSeek(mStreams[i], &streamAvail);
    if (NS_WARN_IF(NS_FAILED(mStatus))) {
      return mStatus;
    }
    avail += streamAvail;
  }
  *aResult = avail;
  return NS_OK;
}

NS_IMETHODIMP
nsMultiplexInputStream::Read(char* aBuf, uint32_t aCount, uint32_t* aResult)
{
  MutexAutoLock lock(mLock);
  // It is tempting to implement this method in terms of ReadSegments, but
  // that would prevent this class from being used with streams that only
  // implement Read (e.g., file streams).

  *aResult = 0;

  if (mStatus == NS_BASE_STREAM_CLOSED) {
    return NS_OK;
  }
  if (NS_FAILED(mStatus)) {
    return mStatus;
  }

  nsresult rv = NS_OK;

  uint32_t len = mStreams.Length();
  while (mCurrentStream < len && aCount) {
    uint32_t read;
    rv = mStreams[mCurrentStream]->Read(aBuf, aCount, &read);

    // XXX some streams return NS_BASE_STREAM_CLOSED to indicate EOF.
    // (This is a bug in those stream implementations)
    if (rv == NS_BASE_STREAM_CLOSED) {
      NS_NOTREACHED("Input stream's Read method returned NS_BASE_STREAM_CLOSED");
      rv = NS_OK;
      read = 0;
    } else if (NS_FAILED(rv)) {
      break;
    }

    if (read == 0) {
      ++mCurrentStream;
      mStartedReadingCurrent = false;
    } else {
      NS_ASSERTION(aCount >= read, "Read more than requested");
      *aResult += read;
      aCount -= read;
      aBuf += read;
      mStartedReadingCurrent = true;
    }
  }
  return *aResult ? NS_OK : rv;
}

NS_IMETHODIMP
nsMultiplexInputStream::ReadSegments(nsWriteSegmentFun aWriter, void* aClosure,
                                     uint32_t aCount, uint32_t* aResult)
{
  MutexAutoLock lock(mLock);

  if (mStatus == NS_BASE_STREAM_CLOSED) {
    *aResult = 0;
    return NS_OK;
  }
  if (NS_FAILED(mStatus)) {
    return mStatus;
  }

  NS_ASSERTION(aWriter, "missing aWriter");

  nsresult rv = NS_OK;
  ReadSegmentsState state;
  state.mThisStream = static_cast<nsIMultiplexInputStream*>(this);
  state.mOffset = 0;
  state.mWriter = aWriter;
  state.mClosure = aClosure;
  state.mDone = false;

  uint32_t len = mStreams.Length();
  while (mCurrentStream < len && aCount) {
    uint32_t read;
    rv = mStreams[mCurrentStream]->ReadSegments(ReadSegCb, &state, aCount, &read);

    // XXX some streams return NS_BASE_STREAM_CLOSED to indicate EOF.
    // (This is a bug in those stream implementations)
    if (rv == NS_BASE_STREAM_CLOSED) {
      NS_NOTREACHED("Input stream's Read method returned NS_BASE_STREAM_CLOSED");
      rv = NS_OK;
      read = 0;
    }

    // if |aWriter| decided to stop reading segments...
    if (state.mDone || NS_FAILED(rv)) {
      break;
    }

    // if stream is empty, then advance to the next stream.
    if (read == 0) {
      ++mCurrentStream;
      mStartedReadingCurrent = false;
    } else {
      NS_ASSERTION(aCount >= read, "Read more than requested");
      state.mOffset += read;
      aCount -= read;
      mStartedReadingCurrent = true;
    }
  }

  // if we successfully read some data, then this call succeeded.
  *aResult = state.mOffset;
  return state.mOffset ? NS_OK : rv;
}

nsresult
nsMultiplexInputStream::ReadSegCb(nsIInputStream* aIn, void* aClosure,
                                  const char* aFromRawSegment,
                                  uint32_t aToOffset, uint32_t aCount,
                                  uint32_t* aWriteCount)
{
  nsresult rv;
  ReadSegmentsState* state = (ReadSegmentsState*)aClosure;
  rv = (state->mWriter)(state->mThisStream,
                        state->mClosure,
                        aFromRawSegment,
                        aToOffset + state->mOffset,
                        aCount,
                        aWriteCount);
  if (NS_FAILED(rv)) {
    state->mDone = true;
  }
  return rv;
}

NS_IMETHODIMP
nsMultiplexInputStream::IsNonBlocking(bool* aNonBlocking)
{
  MutexAutoLock lock(mLock);

  uint32_t len = mStreams.Length();
  if (len == 0) {
    // Claim to be non-blocking, since we won't block the caller.
    // On the other hand we'll never return NS_BASE_STREAM_WOULD_BLOCK,
    // so maybe we should claim to be blocking?  It probably doesn't
    // matter in practice.
    *aNonBlocking = true;
    return NS_OK;
  }
  for (uint32_t i = 0; i < len; ++i) {
    nsresult rv = mStreams[i]->IsNonBlocking(aNonBlocking);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
    // If one is non-blocking the entire stream becomes non-blocking
    // (except that we don't implement nsIAsyncInputStream, so there's
    //  not much for the caller to do if Read returns "would block")
    if (*aNonBlocking) {
      return NS_OK;
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsMultiplexInputStream::Seek(int32_t aWhence, int64_t aOffset)
{
  MutexAutoLock lock(mLock);

  if (NS_FAILED(mStatus)) {
    return mStatus;
  }

  nsresult rv;

  uint32_t oldCurrentStream = mCurrentStream;
  bool oldStartedReadingCurrent = mStartedReadingCurrent;

  if (aWhence == NS_SEEK_SET) {
    int64_t remaining = aOffset;
    if (aOffset == 0) {
      mCurrentStream = 0;
    }
    for (uint32_t i = 0; i < mStreams.Length(); ++i) {
      nsCOMPtr<nsISeekableStream> stream =
        do_QueryInterface(mStreams[i]);
      if (!stream) {
        return NS_ERROR_FAILURE;
      }

      // See if all remaining streams should be rewound
      if (remaining == 0) {
        if (i < oldCurrentStream ||
            (i == oldCurrentStream && oldStartedReadingCurrent)) {
          rv = stream->Seek(NS_SEEK_SET, 0);
          if (NS_WARN_IF(NS_FAILED(rv))) {
            return rv;
          }
          continue;
        } else {
          break;
        }
      }

      // Get position in current stream
      int64_t streamPos;
      if (i > oldCurrentStream ||
          (i == oldCurrentStream && !oldStartedReadingCurrent)) {
        streamPos = 0;
      } else {
        rv = TellMaybeSeek(stream, &streamPos);
        if (NS_WARN_IF(NS_FAILED(rv))) {
          return rv;
        }
      }

      // See if we need to seek current stream forward or backward
      if (remaining < streamPos) {
        rv = stream->Seek(NS_SEEK_SET, remaining);
        if (NS_WARN_IF(NS_FAILED(rv))) {
          return rv;
        }

        mCurrentStream = i;
        mStartedReadingCurrent = remaining != 0;

        remaining = 0;
      } else if (remaining > streamPos) {
        if (i < oldCurrentStream) {
          // We're already at end so no need to seek this stream
          remaining -= streamPos;
          NS_ASSERTION(remaining >= 0, "Remaining invalid");
        } else {
          uint64_t avail;
          rv = AvailableMaybeSeek(mStreams[i], &avail);
          if (NS_WARN_IF(NS_FAILED(rv))) {
            return rv;
          }

          int64_t newPos = XPCOM_MIN(remaining, streamPos + (int64_t)avail);

          rv = stream->Seek(NS_SEEK_SET, newPos);
          if (NS_WARN_IF(NS_FAILED(rv))) {
            return rv;
          }

          mCurrentStream = i;
          mStartedReadingCurrent = true;

          remaining -= newPos;
          NS_ASSERTION(remaining >= 0, "Remaining invalid");
        }
      } else {
        NS_ASSERTION(remaining == streamPos, "Huh?");
        MOZ_ASSERT(remaining != 0, "Zero remaining should be handled earlier");
        remaining = 0;
        mCurrentStream = i;
        mStartedReadingCurrent = true;
      }
    }

    return NS_OK;
  }

  if (aWhence == NS_SEEK_CUR && aOffset > 0) {
    int64_t remaining = aOffset;
    for (uint32_t i = mCurrentStream; remaining && i < mStreams.Length(); ++i) {
      nsCOMPtr<nsISeekableStream> stream =
        do_QueryInterface(mStreams[i]);

      uint64_t avail;
      rv = AvailableMaybeSeek(mStreams[i], &avail);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }

      int64_t seek = XPCOM_MIN((int64_t)avail, remaining);

      rv = stream->Seek(NS_SEEK_CUR, seek);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }

      mCurrentStream = i;
      mStartedReadingCurrent = true;

      remaining -= seek;
    }

    return NS_OK;
  }

  if (aWhence == NS_SEEK_CUR && aOffset < 0) {
    int64_t remaining = -aOffset;
    for (uint32_t i = mCurrentStream; remaining && i != (uint32_t)-1; --i) {
      nsCOMPtr<nsISeekableStream> stream =
        do_QueryInterface(mStreams[i]);

      int64_t pos;
      rv = TellMaybeSeek(stream, &pos);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }

      int64_t seek = XPCOM_MIN(pos, remaining);

      rv = stream->Seek(NS_SEEK_CUR, -seek);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }

      mCurrentStream = i;
      mStartedReadingCurrent = seek != -pos;

      remaining -= seek;
    }

    return NS_OK;
  }

  if (aWhence == NS_SEEK_CUR) {
    NS_ASSERTION(aOffset == 0, "Should have handled all non-zero values");

    return NS_OK;
  }

  if (aWhence == NS_SEEK_END) {
    if (aOffset > 0) {
      return NS_ERROR_INVALID_ARG;
    }
    int64_t remaining = aOffset;
    for (uint32_t i = mStreams.Length() - 1; i != (uint32_t)-1; --i) {
      nsCOMPtr<nsISeekableStream> stream =
        do_QueryInterface(mStreams[i]);

      // See if all remaining streams should be seeked to end
      if (remaining == 0) {
        if (i >= oldCurrentStream) {
          rv = stream->Seek(NS_SEEK_END, 0);
          if (NS_WARN_IF(NS_FAILED(rv))) {
            return rv;
          }
        } else {
          break;
        }
      }

      // Get position in current stream
      int64_t streamPos;
      if (i < oldCurrentStream) {
        streamPos = 0;
      } else {
        uint64_t avail;
        rv = AvailableMaybeSeek(mStreams[i], &avail);
        if (NS_WARN_IF(NS_FAILED(rv))) {
          return rv;
        }

        streamPos = avail;
      }

      // See if we have enough data in the current stream.
      if (DeprecatedAbs(remaining) < streamPos) {
        rv = stream->Seek(NS_SEEK_END, remaining);
        if (NS_WARN_IF(NS_FAILED(rv))) {
          return rv;
        }

        mCurrentStream = i;
        mStartedReadingCurrent = true;

        remaining = 0;
      } else if (DeprecatedAbs(remaining) > streamPos) {
        if (i > oldCurrentStream ||
            (i == oldCurrentStream && !oldStartedReadingCurrent)) {
          // We're already at start so no need to seek this stream
          remaining += streamPos;
        } else {
          int64_t avail;
          rv = TellMaybeSeek(stream, &avail);
          if (NS_WARN_IF(NS_FAILED(rv))) {
            return rv;
          }

          int64_t newPos = streamPos + XPCOM_MIN(avail, DeprecatedAbs(remaining));

          rv = stream->Seek(NS_SEEK_END, -newPos);
          if (NS_WARN_IF(NS_FAILED(rv))) {
            return rv;
          }

          mCurrentStream = i;
          mStartedReadingCurrent = true;

          remaining += newPos;
        }
      } else {
        NS_ASSERTION(remaining == streamPos, "Huh?");
        remaining = 0;
      }
    }

    return NS_OK;
  }

  // other Seeks not implemented yet
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsMultiplexInputStream::Tell(int64_t* aResult)
{
  MutexAutoLock lock(mLock);

  if (NS_FAILED(mStatus)) {
    return mStatus;
  }

  nsresult rv;
  int64_t ret64 = 0;
  uint32_t i, last;
  last = mStartedReadingCurrent ? mCurrentStream + 1 : mCurrentStream;
  for (i = 0; i < last; ++i) {
    nsCOMPtr<nsISeekableStream> stream = do_QueryInterface(mStreams[i]);
    if (NS_WARN_IF(!stream)) {
      return NS_ERROR_NO_INTERFACE;
    }

    int64_t pos;
    rv = TellMaybeSeek(stream, &pos);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
    ret64 += pos;
  }
  *aResult =  ret64;

  return NS_OK;
}

NS_IMETHODIMP
nsMultiplexInputStream::SetEOF()
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsMultiplexInputStream::CloseWithStatus(nsresult aStatus)
{
  return Close();
}

// This class is used to inform nsMultiplexInputStream that it's time to execute
// the asyncWait callback.
class AsyncWaitRunnable final : public Runnable
{
  RefPtr<nsMultiplexInputStream> mStream;

public:
  explicit AsyncWaitRunnable(nsMultiplexInputStream* aStream)
    : Runnable("AsyncWaitRunnable")
    , mStream(aStream)
  {
    MOZ_ASSERT(aStream);
  }

  NS_IMETHOD
  Run() override
  {
    mStream->AsyncWaitCompleted();
    return NS_OK;
  }
};

// This helper class processes an array of nsIAsyncInputStreams, calling
// AsyncWait() for each one of them. When all of them have answered, this helper
// dispatches a AsyncWaitRunnable object. If there is an error calling
// AsyncWait(), AsyncWaitRunnable is not dispatched.
class AsyncStreamHelper final : public nsIInputStreamCallback
{
public:
  NS_DECL_THREADSAFE_ISUPPORTS

  static nsresult
  Process(nsMultiplexInputStream* aStream,
          nsTArray<nsCOMPtr<nsIAsyncInputStream>>& aAsyncStreams,
          uint32_t aFlags, uint32_t aRequestedCount,
          nsIEventTarget* aEventTarget)
  {
    MOZ_ASSERT(aStream);
    MOZ_ASSERT(!aAsyncStreams.IsEmpty());
    MOZ_ASSERT(aEventTarget);

    RefPtr<AsyncStreamHelper> helper =
      new AsyncStreamHelper(aStream, aAsyncStreams, aEventTarget);
    return helper->Run(aFlags, aRequestedCount);
  }

private:
  AsyncStreamHelper(nsMultiplexInputStream* aStream,
                    nsTArray<nsCOMPtr<nsIAsyncInputStream>>& aAsyncStreams,
                    nsIEventTarget* aEventTarget)
    : mMutex("AsyncStreamHelper::mMutex")
    , mStream(aStream)
    , mEventTarget(aEventTarget)
    , mValid(true)
  {
    mPendingStreams.SwapElements(aAsyncStreams);
  }

  ~AsyncStreamHelper() = default;

  nsresult
  Run(uint32_t aFlags, uint32_t aRequestedCount)
  {
    MutexAutoLock lock(mMutex);

    for (uint32_t i = 0; i < mPendingStreams.Length(); ++i) {
      nsresult rv =
        mPendingStreams[i]->AsyncWait(this, aFlags, aRequestedCount,
                                      mEventTarget);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        mValid = false;
        return rv;
      }
    }

    return NS_OK;
  }

  NS_IMETHOD
  OnInputStreamReady(nsIAsyncInputStream* aStream) override
  {
    MOZ_ASSERT(aStream, "This cannot be one of ours.");

    MutexAutoLock lock(mMutex);

    // We failed during the Run().
    if (!mValid) {
      return NS_OK;
    }

    MOZ_ASSERT(mPendingStreams.Contains(aStream));
    mPendingStreams.RemoveElement(aStream);

    // The last asyncStream answered. We can inform nsMultiplexInputStream.
    if (mPendingStreams.IsEmpty()) {
      RefPtr<AsyncWaitRunnable> runnable = new AsyncWaitRunnable(mStream);
      return mEventTarget->Dispatch(runnable.forget(), NS_DISPATCH_NORMAL);
    }

    return NS_OK;
  }

  Mutex mMutex;
  RefPtr<nsMultiplexInputStream> mStream;
  nsTArray<nsCOMPtr<nsIAsyncInputStream>> mPendingStreams;
  nsCOMPtr<nsIEventTarget> mEventTarget;
  bool mValid;
};

NS_IMPL_ISUPPORTS(AsyncStreamHelper, nsIInputStreamCallback)

NS_IMETHODIMP
nsMultiplexInputStream::AsyncWait(nsIInputStreamCallback* aCallback,
                                  uint32_t aFlags,
                                  uint32_t aRequestedCount,
                                  nsIEventTarget* aEventTarget)
{
  // When AsyncWait() is called, it's better to call AsyncWait() to any sub
  // stream if they are valid nsIAsyncInputStream instances. In this way, when
  // they all call OnInputStreamReady(), we can proceed with the Read().

  MutexAutoLock lock(mLock);

  if (NS_FAILED(mStatus)) {
    return mStatus;
  }

  if (mAsyncWaitCallback && aCallback) {
    return NS_ERROR_FAILURE;
  }

  mAsyncWaitCallback = aCallback;

  if (!mAsyncWaitCallback) {
      return NS_OK;
  }

  nsTArray<nsCOMPtr<nsIAsyncInputStream>> asyncStreams;
  for (uint32_t i = mCurrentStream; i < mStreams.Length(); ++i) {
    nsCOMPtr<nsIAsyncInputStream> asyncStream =
      do_QueryInterface(mStreams.SafeElementAt(i, nullptr));
    if (asyncStream) {
      asyncStreams.AppendElement(asyncStream);
    }
  }

  if (!aEventTarget) {
    aEventTarget = SystemGroup::EventTargetFor(TaskCategory::Other);
  }

  if (asyncStreams.IsEmpty()) {
    RefPtr<AsyncWaitRunnable> runnable = new AsyncWaitRunnable(this);
    return aEventTarget->Dispatch(runnable.forget(), NS_DISPATCH_NORMAL);
  }

  return AsyncStreamHelper::Process(this, asyncStreams, aFlags, aRequestedCount,
                                    aEventTarget);
}

void
nsMultiplexInputStream::AsyncWaitCompleted()
{
  nsCOMPtr<nsIInputStreamCallback> callback;

  {
    MutexAutoLock lock(mLock);

    // The callback has been nullified in the meantime.
    if (!mAsyncWaitCallback) {
      return;
    }

    mAsyncWaitCallback.swap(callback);
  }

  callback->OnInputStreamReady(this);
}

nsresult
nsMultiplexInputStreamConstructor(nsISupports* aOuter,
                                  REFNSIID aIID,
                                  void** aResult)
{
  *aResult = nullptr;

  if (aOuter) {
    return NS_ERROR_NO_AGGREGATION;
  }

  RefPtr<nsMultiplexInputStream> inst = new nsMultiplexInputStream();

  return inst->QueryInterface(aIID, aResult);
}

void
nsMultiplexInputStream::Serialize(InputStreamParams& aParams,
                                  FileDescriptorArray& aFileDescriptors)
{
  MutexAutoLock lock(mLock);

  MultiplexInputStreamParams params;

  uint32_t streamCount = mStreams.Length();

  if (streamCount) {
    InfallibleTArray<InputStreamParams>& streams = params.streams();

    streams.SetCapacity(streamCount);
    for (uint32_t index = 0; index < streamCount; index++) {
      InputStreamParams childStreamParams;
      InputStreamHelper::SerializeInputStream(mStreams[index],
                                              childStreamParams,
                                              aFileDescriptors);

      streams.AppendElement(childStreamParams);
    }
  }

  params.currentStream() = mCurrentStream;
  params.status() = mStatus;
  params.startedReadingCurrent() = mStartedReadingCurrent;

  aParams = params;
}

bool
nsMultiplexInputStream::Deserialize(const InputStreamParams& aParams,
                                    const FileDescriptorArray& aFileDescriptors)
{
  if (aParams.type() !=
      InputStreamParams::TMultiplexInputStreamParams) {
    NS_ERROR("Received unknown parameters from the other process!");
    return false;
  }

  const MultiplexInputStreamParams& params =
    aParams.get_MultiplexInputStreamParams();

  const InfallibleTArray<InputStreamParams>& streams = params.streams();

  uint32_t streamCount = streams.Length();
  for (uint32_t index = 0; index < streamCount; index++) {
    nsCOMPtr<nsIInputStream> stream =
      InputStreamHelper::DeserializeInputStream(streams[index],
                                                aFileDescriptors);
    if (!stream) {
      NS_WARNING("Deserialize failed!");
      return false;
    }

    if (NS_FAILED(AppendStream(stream))) {
      NS_WARNING("AppendStream failed!");
      return false;
    }
  }

  mCurrentStream = params.currentStream();
  mStatus = params.status();
  mStartedReadingCurrent = params.startedReadingCurrent();

  return true;
}

Maybe<uint64_t>
nsMultiplexInputStream::ExpectedSerializedLength()
{
  MutexAutoLock lock(mLock);

  bool lengthValueExists = false;
  uint64_t expectedLength = 0;
  uint32_t streamCount = mStreams.Length();
  for (uint32_t index = 0; index < streamCount; index++) {
    nsCOMPtr<nsIIPCSerializableInputStream> stream = do_QueryInterface(mStreams[index]);
    if (!stream) {
      continue;
    }
    Maybe<uint64_t> length = stream->ExpectedSerializedLength();
    if (length.isNothing()) {
      continue;
    }
    lengthValueExists = true;
    expectedLength += length.value();
  }
  return lengthValueExists ? Some(expectedLength) : Nothing();
}

NS_IMETHODIMP
nsMultiplexInputStream::GetCloneable(bool* aCloneable)
{
  MutexAutoLock lock(mLock);
  //XXXnsm Cloning a multiplex stream which has started reading is not permitted
  //right now.
  if (mCurrentStream > 0 || mStartedReadingCurrent) {
    *aCloneable = false;
    return NS_OK;
  }

  uint32_t len = mStreams.Length();
  for (uint32_t i = 0; i < len; ++i) {
    nsCOMPtr<nsICloneableInputStream> cis = do_QueryInterface(mStreams[i]);
    if (!cis || !cis->GetCloneable()) {
      *aCloneable = false;
      return NS_OK;
    }
  }

  *aCloneable = true;
  return NS_OK;
}

NS_IMETHODIMP
nsMultiplexInputStream::Clone(nsIInputStream** aClone)
{
  MutexAutoLock lock(mLock);

  //XXXnsm Cloning a multiplex stream which has started reading is not permitted
  //right now.
  if (mCurrentStream > 0 || mStartedReadingCurrent) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIMultiplexInputStream> clone = new nsMultiplexInputStream();

  nsresult rv;
  uint32_t len = mStreams.Length();
  for (uint32_t i = 0; i < len; ++i) {
    nsCOMPtr<nsICloneableInputStream> substream = do_QueryInterface(mStreams[i]);
    if (NS_WARN_IF(!substream)) {
      return NS_ERROR_FAILURE;
    }

    nsCOMPtr<nsIInputStream> clonedSubstream;
    rv = substream->Clone(getter_AddRefs(clonedSubstream));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    rv = clone->AppendStream(clonedSubstream);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }

  clone.forget(aClone);
  return NS_OK;
}

bool
nsMultiplexInputStream::IsSeekable() const
{
  for (uint32_t i = 0, len = mStreams.Length(); i < len; ++i) {
    nsCOMPtr<nsISeekableStream> substream = do_QueryInterface(mStreams[i]);
    if (!substream) {
      return false;
    }
  }
  return true;
}

bool
nsMultiplexInputStream::IsIPCSerializable() const
{
  for (uint32_t i = 0, len = mStreams.Length(); i < len; ++i) {
    nsCOMPtr<nsIIPCSerializableInputStream> substream = do_QueryInterface(mStreams[i]);
    if (!substream) {
      return false;
    }
  }
  return true;
}

bool
nsMultiplexInputStream::IsCloneable() const
{
  for (uint32_t i = 0, len = mStreams.Length(); i < len; ++i) {
    nsCOMPtr<nsICloneableInputStream> substream = do_QueryInterface(mStreams[i]);
    if (!substream) {
      return false;
    }
  }
  return true;
}

bool
nsMultiplexInputStream::IsAsyncInputStream() const
{
  // nsMultiplexInputStream is nsIAsyncInputStream if at least 1 of the
  // substream implements that interface.
  for (uint32_t i = 0, len = mStreams.Length(); i < len; ++i) {
    nsCOMPtr<nsIAsyncInputStream> substream = do_QueryInterface(mStreams[i]);
    if (substream) {
      return true;
    }
  }
  return false;
}
