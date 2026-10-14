/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_quota_DecryptingInputStream_impl_h
#define mozilla_dom_quota_DecryptingInputStream_impl_h

#include <algorithm>
#include <cstdio>
#include <utility>

#include "CipherStrategy.h"
#include "DecryptingInputStream.h"
#include "mozilla/Assertions.h"
#include "mozilla/RefPtr.h"
#include "mozilla/Result.h"
#include "mozilla/Span.h"
#include "mozilla/fallible.h"
#include "mozilla/ipc/InputStreamUtils.h"
#include "nsDebug.h"
#include "nsError.h"
#include "nsFileStreams.h"
#include "nsID.h"
#include "nsIFileStreams.h"

namespace mozilla::dom::quota {

template <typename CipherStrategy>
DecryptingInputStream<CipherStrategy>::DecryptingInputStream(
    MovingNotNull<nsCOMPtr<nsIInputStream>> aBaseStream, size_t aBlockSize,
    typename CipherStrategy::KeyType aKey)
    : DecryptingInputStreamBase(std::move(aBaseStream), aBlockSize),
      mKey(aKey) {
  MutexAutoLock lock(mMutex);
  // XXX Move this to a fallible init function.
  MOZ_ALWAYS_SUCCEEDS(mCipherStrategy.Init(CipherMode::Decrypt,
                                           CipherStrategy::SerializeKey(aKey)));

  // We used to assert the underlying stream was blocking in DEBUG builds as a
  // proxy for providing synchronous read access (we can't handle AsyncWait),
  // but IsNonBlocking is a bad proxy for this since classes like
  // nsStringInputStream provide sync read access, it just is known to never
  // block because the data is always available.
}

template <typename CipherStrategy>
DecryptingInputStream<CipherStrategy>::~DecryptingInputStream() {
  Close();
}

template <typename CipherStrategy>
DecryptingInputStream<CipherStrategy>::DecryptingInputStream()
    : DecryptingInputStreamBase{} {}

template <typename CipherStrategy>
NS_IMETHODIMP DecryptingInputStream<CipherStrategy>::Close() {
  MutexAutoLock lock(mMutex);
  if (!mBaseStream) {
    return NS_OK;
  }

  (*mBaseStream)->Close();
  mBaseStream.destroy();

  mPlainBuffer.Clear();
  mEncryptedBlock.reset();

  return NS_OK;
}

template <typename CipherStrategy>
NS_IMETHODIMP DecryptingInputStream<CipherStrategy>::Available(
    uint64_t* aLengthOut) {
  MutexAutoLock lock(mMutex);
  if (!mBaseStream) {
    return NS_BASE_STREAM_CLOSED;
  }

  int64_t current;
  nsresult rv = TellInternal(&current, mNextByte);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  rv = EnsureDecryptedStreamSize();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  auto length = CheckedUint64(*mDecryptedStreamSize) - current;
  if (!length.isValid()) {
    return nsresult::NS_ERROR_ILLEGAL_VALUE;
  }
  *aLengthOut = length.value();
  return NS_OK;
}

template <typename CipherStrategy>
NS_IMETHODIMP DecryptingInputStream<CipherStrategy>::StreamStatus() {
  MutexAutoLock lock(mMutex);
  return mBaseStream ? NS_OK : NS_BASE_STREAM_CLOSED;
}

template <typename CipherStrategy>
nsresult DecryptingInputStream<CipherStrategy>::BaseStreamStatus() {
  MutexAutoLock lock(mMutex);
  return mBaseStream ? (*mBaseStream)->StreamStatus() : NS_BASE_STREAM_CLOSED;
}

template <typename CipherStrategy>
NS_IMETHODIMP DecryptingInputStream<CipherStrategy>::ReadSegments(
    nsWriteSegmentFun aWriter, void* aClosure, uint32_t aCount,
    uint32_t* aBytesReadOut) {
  *aBytesReadOut = 0;

  MutexAutoLock lock(mMutex);
  if (!mBaseStream) {
    return NS_BASE_STREAM_CLOSED;
  }

  nsresult rv;

  // Do not try to use the base stream's ReadSegments here.  Its very
  // unlikely we will get a single buffer that contains all of the encrypted
  // data and therefore would have to copy into our own buffer anyways.
  // Instead, focus on making efficient use of the Read() interface.

  while (aCount > 0) {
    // We have some decrypted data in our buffer.  Provide it to the callers
    // writer function.
    if (mNextByte < mPlainBytes) {
      MOZ_ASSERT(!mPlainBuffer.IsEmpty());
      uint32_t remaining = PlainLength();
      uint32_t numToWrite = std::min(aCount, remaining);
      uint32_t numWritten;
      rv = aWriter(this, aClosure,
                   reinterpret_cast<const char*>(&mPlainBuffer[mNextByte]),
                   *aBytesReadOut, numToWrite, &numWritten);

      // As defined in nsIInputputStream.idl, do not pass writer func errors.
      if (NS_FAILED(rv)) {
        return NS_OK;
      }

      // End-of-file
      if (numWritten == 0) {
        return NS_OK;
      }

      *aBytesReadOut += numWritten;
      mNextByte += numWritten;
      MOZ_ASSERT(mNextByte <= mPlainBytes);

      aCount -= numWritten;

      continue;
    }

    // Otherwise decrypt the next chunk and loop.  Any resulting data will set
    // mPlainBytes and mNextByte which we check at the top of the loop.
    uint32_t bytesRead = 0;
    rv = ParseNextChunk(false /* aCheckAvailableBytes */, &bytesRead);
    if (NS_FAILED(rv)) {
      return rv;
    }

    // If we couldn't read anything, then this is EOF.
    if (bytesRead == 0) {
      return NS_OK;
    }

    mPlainBytes = bytesRead;
    mNextByte = 0;
  }

  return NS_OK;
}

template <typename CipherStrategy>
nsresult DecryptingInputStream<CipherStrategy>::ParseNextChunk(
    bool aCheckAvailableBytes, uint32_t* const aBytesReadOut) {
  *aBytesReadOut = 0;

  if (!EnsureBuffers()) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  // Read the data to our internal encrypted buffer.
  auto wholeBlock = mEncryptedBlock->MutableWholeBlock();
  nsresult rv =
      ReadAll(AsWritableChars(wholeBlock).Elements(), wholeBlock.Length(),
              wholeBlock.Length(), aCheckAvailableBytes, aBytesReadOut);
  if (NS_WARN_IF(NS_FAILED(rv)) || *aBytesReadOut == 0) {
    return rv;
  }

  // Reject headers the encryptor can never produce.
  // This also guarantees that a successful return with *aBytesReadOut == 0 only
  // happens at EOF, which ReadSegments and Seek rely on.
  const size_t actualPayloadLength = mEncryptedBlock->ActualPayloadLength();
  if (NS_WARN_IF(actualPayloadLength == 0) ||
      NS_WARN_IF(actualPayloadLength > mEncryptedBlock->MaxPayloadLength())) {
    return NS_ERROR_CORRUPTED_CONTENT;
  }

  // XXX Do we need to know the actual decrypted size?
  rv = mCipherStrategy.Cipher(mEncryptedBlock->MutableCipherPrefix(),
                              mEncryptedBlock->Payload(),
                              AsWritableBytes(Span{mPlainBuffer}));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  *aBytesReadOut = actualPayloadLength;

  return NS_OK;
}

template <typename CipherStrategy>
nsresult DecryptingInputStream<CipherStrategy>::ReadAll(
    char* aBuf, uint32_t aCount, uint32_t aMinValidCount,
    bool aCheckAvailableBytes, uint32_t* aBytesReadOut) {
  MOZ_ASSERT(aCount >= aMinValidCount);
  MOZ_ASSERT(mBaseStream);

  nsresult rv = NS_OK;
  *aBytesReadOut = 0;

  uint32_t offset = 0;
  while (aCount > 0) {
    Maybe<uint64_t> availableBytes;
    if (aCheckAvailableBytes) {
      uint64_t available;
      rv = (*mBaseStream)->Available(&available);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        if (rv == NS_BASE_STREAM_CLOSED) {
          rv = NS_OK;
        }
        break;
      }

      if (available == 0) {
        break;
      }

      availableBytes = Some(available);
    }

    uint32_t bytesRead = 0;
    rv = (*mBaseStream)->Read(aBuf + offset, aCount, &bytesRead);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      break;
    }

    // EOF, but don't immediately return.  We need to validate min read bytes
    // below.
    if (bytesRead == 0) {
      break;
    }

    MOZ_DIAGNOSTIC_ASSERT(!availableBytes || bytesRead <= *availableBytes);

    *aBytesReadOut += bytesRead;
    offset += bytesRead;
    aCount -= bytesRead;
  }

  // Reading zero bytes is not an error. It's the expected EOF condition.
  // Only compare to the minimum valid count if we read at least one byte.
  if (*aBytesReadOut != 0 && *aBytesReadOut < aMinValidCount) {
    return NS_ERROR_CORRUPTED_CONTENT;
  }

  return rv;
}

template <typename CipherStrategy>
bool DecryptingInputStream<CipherStrategy>::EnsureBuffers() {
  // Lazily create our two buffers so we can report OOM during stream
  // operation.  These allocations only happens once.  The buffers are reused
  // until the stream is closed.
  if (!mEncryptedBlock) {
    // XXX Do we need to do this fallible (as the comment above suggests)?
    mEncryptedBlock.emplace(*mBlockSize);

    MOZ_ASSERT(mPlainBuffer.IsEmpty());
    if (NS_WARN_IF(!mPlainBuffer.SetLength(mEncryptedBlock->MaxPayloadLength(),
                                           fallible))) {
      return false;
    }

    // SetLength() does not zero POD elements. Zero-initialize the whole block
    // so that reserved/unused bytes do not expose stale data. This follows the
    // same rationale as EncryptedBlock (see bug 1867394 and bug 2054736).
    std::fill(mPlainBuffer.begin(), mPlainBuffer.end(), 0);

    // Make sure we seek our stream to its start before we do anything.  This is
    // primarily intended to deal with the case of IPC serialization, but this
    // is reasonable in all cases.
    (*mBaseSeekableStream)->Seek(NS_SEEK_SET, 0);
  }

  return true;
}

template <typename CipherStrategy>
nsresult DecryptingInputStream<CipherStrategy>::EnsureDecryptedStreamSize() {
  if (mDecryptedStreamSize) {
    return NS_OK;
  }

  // Restore the previous state.
  // mPlainBuffer has to be restored also, because ParseNextChunk changes it.
  int64_t baseCurrent;
  nsresult rv = (*mBaseSeekableStream)->Tell(&baseCurrent);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return Err(rv);
  }
  auto savedPlainBuffer = mPlainBuffer.Clone();
  auto autoRestorePreviousState =
      MakeScopeExit([this, savedBaseCurrent = baseCurrent,
                     &savedPlainBuffer]() MOZ_REQUIRES(mMutex) {
        nsresult rv =
            (*mBaseSeekableStream)->Seek(NS_SEEK_SET, savedBaseCurrent);
        (void)NS_WARN_IF(NS_FAILED(rv));
        mPlainBuffer = std::move(savedPlainBuffer);
      });

  auto decryptedStreamSizeOrErr =
      [this]() MOZ_REQUIRES(mMutex) -> Result<int64_t, nsresult> {
    nsresult rv = (*mBaseSeekableStream)->Seek(NS_SEEK_SET, 0);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return Err(rv);
    }

    uint64_t baseStreamSize;
    rv = (*mBaseStream)->Available(&baseStreamSize);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return Err(rv);
    }

    if (!baseStreamSize) {
      return 0;
    }

    rv = (*mBaseSeekableStream)
             ->Seek(NS_SEEK_END, -static_cast<int64_t>(*mBlockSize));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return Err(rv);
    }

    uint32_t bytesRead = 0;
    rv = ParseNextChunk(true /* aCheckAvailableBytes */, &bytesRead);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return Err(rv);
    }
    MOZ_ASSERT(bytesRead);

    int64_t current;
    rv = TellInternal(&current, bytesRead);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return Err(rv);
    }

    return current;
  }();

  if (decryptedStreamSizeOrErr.isErr()) {
    return decryptedStreamSizeOrErr.unwrapErr();
  }

  mDecryptedStreamSize.init(decryptedStreamSizeOrErr.inspect());

  return NS_OK;
}

template <typename CipherStrategy>
NS_IMETHODIMP DecryptingInputStream<CipherStrategy>::Tell(
    int64_t* const aRetval) {
  MutexAutoLock lock(mMutex);
  return TellInternal(aRetval, mNextByte);
}

template <typename CipherStrategy>
nsresult DecryptingInputStream<CipherStrategy>::TellInternal(
    int64_t* const aRetval, uint64_t const aBlockOffset) {
  MOZ_ASSERT(aRetval);

  if (!mBaseStream) {
    return NS_BASE_STREAM_CLOSED;
  }

  if (!EnsureBuffers()) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  int64_t basePosition;
  nsresult rv = (*mBaseSeekableStream)->Tell(&basePosition);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  if (basePosition == 0) {
    *aRetval = 0;
    return NS_OK;
  }

  MOZ_ASSERT(0 == basePosition % *mBlockSize);

  const auto fullBlocks = basePosition / *mBlockSize;
  MOZ_ASSERT(fullBlocks);

  *aRetval =
      (fullBlocks - 1) * mEncryptedBlock->MaxPayloadLength() + aBlockOffset;
  return NS_OK;
}

template <typename CipherStrategy>
NS_IMETHODIMP DecryptingInputStream<CipherStrategy>::Seek(const int32_t aWhence,
                                                          int64_t aOffset) {
  MutexAutoLock lock(mMutex);
  if (!mBaseStream) {
    return NS_BASE_STREAM_CLOSED;
  }

  if (!EnsureBuffers()) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  int64_t baseCurrent;
  nsresult rv = (*mBaseSeekableStream)->Tell(&baseCurrent);
  if (rv == NS_BASE_STREAM_CLOSED) {
    // In the case our underlying stream is CLOSE_ON_EOF and REOPEN_ON_REWIND,
    // as is the case for IDB Files/Blobs in the parent process, then this call
    // to Tell can fail with NS_BASE_STREAM_CLOSED.
    //
    // Requesting any seek in this condition will re-open the file if the flags
    // are set, so try that (but will fail if they are not set).
    rv = (*mBaseSeekableStream)->Seek(NS_SEEK_CUR, 0);
    // If that succeeded, perform the tell call again.
    if (NS_SUCCEEDED(rv)) {
      rv = (*mBaseSeekableStream)->Tell(&baseCurrent);
    }
  }
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return Err(rv);
  }

  int64_t current = 0;
  if (baseCurrent > 0) {
    // The underlying stream is always written in fixed-size units (mBlockSize)
    // with padding, according to the flush implementation of
    // EncryptedOutputStream. And baseCurrent always points to the end of the
    // current block in our buffer, according to ParseNextChunk and Seek. That
    // means baseCurrent is always a multiple of mBlockSize.
    MOZ_DIAGNOSTIC_ASSERT(
        std::has_single_bit(*mBlockSize) &&
        (0 == (static_cast<size_t>(baseCurrent) & (*mBlockSize - 1))));
    // Thus, (baseCurrent / *mBlockSize - 1) gives the number of preceding
    // blocks. We multiply this by MaxPayloadLength() and add mNextByte to
    // arrive at the current logical position.
    current =
        (baseCurrent / *mBlockSize - 1) * mEncryptedBlock->MaxPayloadLength() +
        mNextByte;
  }

  rv = EnsureDecryptedStreamSize();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  switch (aWhence) {
    case NS_SEEK_CUR:
      aOffset += current;
      break;

    case NS_SEEK_SET:
      break;

    case NS_SEEK_END:
      aOffset += *mDecryptedStreamSize;
      break;

    default:
      return NS_ERROR_ILLEGAL_VALUE;
  }

  if (aOffset < 0 || aOffset > *mDecryptedStreamSize) {
    return NS_ERROR_ILLEGAL_VALUE;
  }

  // If the target offset is in the current block, it is enough to move
  // mNextByte.
  int64_t blockStart = current - mNextByte;
  if (blockStart <= aOffset &&
      aOffset <= blockStart + static_cast<int64_t>(mPlainBytes)) {
    mNextByte += aOffset - current;
    return NS_OK;
  }

  // Seek changes the state, so restore the original position if the subsequent
  // operations fail.
  auto autoRestorePreviousState =
      MakeScopeExit([baseSeekableStream = *mBaseSeekableStream,
                     savedBaseCurrent = baseCurrent] {
        nsresult rv = baseSeekableStream->Seek(NS_SEEK_SET, savedBaseCurrent);
        (void)NS_WARN_IF(NS_FAILED(rv));
      });

  const int64_t baseBlocksOffset =
      aOffset / mEncryptedBlock->MaxPayloadLength();
  const int64_t nextByteOffset = aOffset % mEncryptedBlock->MaxPayloadLength();

  rv =
      (*mBaseSeekableStream)->Seek(NS_SEEK_SET, baseBlocksOffset * *mBlockSize);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  uint32_t readBytes;
  rv = ParseNextChunk(true /* aCheckAvailableBytes */, &readBytes);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  if (readBytes == 0 && baseBlocksOffset != 0) {
    // EOF at a block boundary: re-parse the preceding (full) block so that
    // mPlainBuffer really contains mPlainBytes bytes read calls might request.
    // Fabricating the counts without decrypting would let a later
    // in-block seek serve uninitialized buffer contents (see bug 2054736).
    rv = (*mBaseSeekableStream)
             ->Seek(NS_SEEK_SET, (baseBlocksOffset - 1) * *mBlockSize);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    rv = ParseNextChunk(true /* aCheckAvailableBytes */, &readBytes);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    if (NS_WARN_IF(readBytes != mEncryptedBlock->MaxPayloadLength())) {
      return NS_ERROR_CORRUPTED_CONTENT;
    }

    mPlainBytes = readBytes;
    mNextByte = readBytes;
  } else {
    mPlainBytes = readBytes;
    mNextByte = nextByteOffset;
  }

  autoRestorePreviousState.release();

  return NS_OK;
}

template <typename CipherStrategy>
NS_IMETHODIMP DecryptingInputStream<CipherStrategy>::Clone(
    nsIInputStream** _retval) {
  MutexAutoLock lock(mMutex);
  if (!mBaseStream) {
    return NS_BASE_STREAM_CLOSED;
  }

  if (!(*mBaseCloneableInputStream)->GetCloneable()) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIInputStream> clonedStream;
  nsresult rv =
      (*mBaseCloneableInputStream)->Clone(getter_AddRefs(clonedStream));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  *_retval = MakeAndAddRef<DecryptingInputStream>(
                 WrapNotNull(std::move(clonedStream)), *mBlockSize, *mKey)
                 .take();

  return NS_OK;
}

template <typename CipherStrategy>
void DecryptingInputStream<CipherStrategy>::Serialize(
    mozilla::ipc::InputStreamParams& aParams, uint32_t aMaxSize,
    uint32_t* aSizeUsed) {
  MutexAutoLock lock(mMutex);
  MOZ_ASSERT(mBaseStream);
  MOZ_ASSERT(mBaseIPCSerializableInputStream);

  mozilla::ipc::EncryptedFileInputStreamParams encryptedFileInputStreamParams;
  mozilla::ipc::InputStreamHelper::SerializeInputStream(
      *mBaseStream, encryptedFileInputStreamParams.inputStreamParams(),
      aMaxSize, aSizeUsed);

  encryptedFileInputStreamParams.key().AppendElements(
      mCipherStrategy.SerializeKey(*mKey));
  encryptedFileInputStreamParams.blockSize() = *mBlockSize;

  aParams = std::move(encryptedFileInputStreamParams);
}

template <typename CipherStrategy>
bool DecryptingInputStream<CipherStrategy>::Deserialize(
    const mozilla::ipc::InputStreamParams& aParams) {
  const auto& params = aParams.get_EncryptedFileInputStreamParams();

  nsCOMPtr<nsIInputStream> stream =
      mozilla::ipc::InputStreamHelper::DeserializeInputStream(
          params.inputStreamParams());
  if (NS_WARN_IF(!stream)) {
    return false;
  }

  MutexAutoLock lock(mMutex);
  Init(WrapNotNull<nsCOMPtr<nsIInputStream>>(std::move(stream)),
       params.blockSize());

  auto key = mCipherStrategy.DeserializeKey(params.key());
  if (NS_WARN_IF(!key)) {
    return false;
  }

  mKey.init(*key);
  if (NS_WARN_IF(
          NS_FAILED(mCipherStrategy.Init(CipherMode::Decrypt, params.key())))) {
    return false;
  }

  return true;
}

}  // namespace mozilla::dom::quota

#endif
