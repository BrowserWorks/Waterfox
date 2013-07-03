/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsCRT.h"
#include "nsWEBPEncoder.h"
#include "nsString.h"
#include "nsStreamUtils.h"

using namespace mozilla;

NS_IMPL_ISUPPORTS(nsWEBPEncoder, imgIEncoder, nsIInputStream, nsIAsyncInputStream)

nsWEBPEncoder::nsWEBPEncoder() : picture(), config(), memory_writer(),
                                 mFinished(false),
                                 mImageBuffer(nullptr), mImageBufferSize(0),
                                 mImageBufferUsed(0), mImageBufferReadPoint(0),
                                 mCallback(nullptr),
                                 mCallbackTarget(nullptr), mNotifyThreshold(0),
                                 mReentrantMonitor("nsWEBPEncoder.mReentrantMonitor")
{
}

nsWEBPEncoder::~nsWEBPEncoder()
{
  if (mImageBuffer) {
    free(mImageBuffer);
    mImageBuffer = nullptr;
  }
}

NS_IMETHODIMP nsWEBPEncoder::InitFromData(const uint8_t* aData,
                                          uint32_t aLength, // (unused, req'd by JS)
                                          uint32_t aWidth,
                                          uint32_t aHeight,
                                          uint32_t aStride,
                                          uint32_t aInputFormat,
                                          const nsAString& aOutputOptions)
{
  NS_ENSURE_ARG(aData);
  nsresult rv;

  rv = StartImageEncode(aWidth, aHeight, aInputFormat, aOutputOptions);
  if (!NS_SUCCEEDED(rv))
    return rv;

  rv = AddImageFrame(aData, aLength, aWidth, aHeight, aStride,
                     aInputFormat, aOutputOptions);
  if (!NS_SUCCEEDED(rv))
    return rv;

  rv = EndImageEncode();

  return rv;
}

NS_IMETHODIMP nsWEBPEncoder::StartImageEncode(uint32_t aWidth,
                                              uint32_t aHeight,
                                              uint32_t aInputFormat,
                                              const nsAString& aOutputOptions)
{
  // can't initialize more than once
  if (mImageBuffer != nullptr)
    return NS_ERROR_ALREADY_INITIALIZED;

  // validate input format
  if (aInputFormat != INPUT_FORMAT_RGB &&
      aInputFormat != INPUT_FORMAT_RGBA &&
      aInputFormat != INPUT_FORMAT_HOSTARGB)
    return NS_ERROR_INVALID_ARG;

  // Initializing webp needs
  /* WebPPicture picture;
  WebPConfig config;
  WebPMemoryWriter memory_writer; */

  WebPMemoryWriterInit(&memory_writer);

  // Checking initialization
  if (!WebPConfigInit(&config) || !WebPPictureInit(&picture))
        return NS_ERROR_FAILURE;

  picture.width = aWidth;
  picture.height = aHeight;

  // Memory allocation
  // The memory will be freed on EndImageEncode
  if (!WebPPictureAlloc(&picture))
        return NS_ERROR_OUT_OF_MEMORY;

  // Setting our webp writer
  // picture.writer = WebPMemoryWrite;
  // picture.custom_ptr = &memory_writer;

  // Set up to read the data into our image buffer, start out with an 8K
  // estimated size. Note: we don't have to worry about freeing this data
  // in this function. It will be freed on object destruction.
  mImageBufferSize = 8192;
  mImageBuffer = (uint8_t*)malloc(mImageBufferSize);
  if (!mImageBuffer) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  mImageBufferUsed = 0;

  picture.custom_ptr = &memory_writer;
  picture.writer = WebPMemoryWrite;

  return NS_OK;

}

// Returns the number of bytes in the image buffer used.
NS_IMETHODIMP nsWEBPEncoder::GetImageBufferUsed(uint32_t *aOutputSize)
{
  NS_ENSURE_ARG_POINTER(aOutputSize);
  *aOutputSize = mImageBufferUsed;
  return NS_OK;
}

// Returns a pointer to the start of the image buffer
NS_IMETHODIMP nsWEBPEncoder::GetImageBuffer(char **aOutputBuffer)
{
  NS_ENSURE_ARG_POINTER(aOutputBuffer);
  *aOutputBuffer = reinterpret_cast<char*>(mImageBuffer);
  return NS_OK;
}

// TODO

NS_IMETHODIMP nsWEBPEncoder::AddImageFrame(const uint8_t* aData,
                                           uint32_t aLength,
                                           uint32_t aWidth,
                                           uint32_t aHeight,
                                           uint32_t aStride,
                                           uint32_t aInputFormat,
                                           const nsAString& aFrameOptions)
{

  // must be initialized
  if (mImageBuffer == nullptr)
    return NS_ERROR_NOT_INITIALIZED;

  // validate input format
  if (aInputFormat != INPUT_FORMAT_RGB &&
      aInputFormat != INPUT_FORMAT_RGBA &&
      aInputFormat != INPUT_FORMAT_HOSTARGB)
    return NS_ERROR_INVALID_ARG;

  // Simple conversion first
  size_t buffSize = sizeof(aData);
  uint8_t* row = new uint8_t[aWidth * 4];
  for (uint32_t y = 0; y < aHeight; y ++) {
      ConvertHostARGBRow(&aData[y * aStride], row, aWidth, 1);
      WebPMemoryWrite(row, buffSize, &picture);
  }

  memory_writer.mem = mImageBuffer;
  memory_writer.size = sizeof(mImageBuffer);

  picture.writer = &WriteCallback;

  int success = WebPEncode(&config, &picture);

  if (!success)
    return NS_ERROR_FAILURE;

  return NS_OK;

}

NS_IMETHODIMP nsWEBPEncoder::EndImageEncode()
{

  // must be initialized
  if (mImageBuffer == nullptr)
    return NS_ERROR_NOT_INITIALIZED;

  // if output callback can't get enough memory, it will free our buffer
  if (!mImageBuffer)
    return NS_ERROR_OUT_OF_MEMORY;

  WebPPictureFree(&picture);

  mFinished = true;
  NotifyListener();

return NS_OK;

}

NS_IMETHODIMP nsWEBPEncoder::Close()
{
  if (mImageBuffer != nullptr) {
    free(mImageBuffer);
    mImageBuffer = nullptr;
    mImageBufferSize = 0;
    mImageBufferUsed = 0;
    mImageBufferReadPoint = 0;
  }
  return NS_OK;
}

NS_IMETHODIMP nsWEBPEncoder::Available(uint64_t *_retval)
{
  if (!mImageBuffer)
    return NS_BASE_STREAM_CLOSED;

  *_retval = mImageBufferUsed - mImageBufferReadPoint;
  return NS_OK;
}

NS_IMETHODIMP nsWEBPEncoder::Read(char * aBuf, uint32_t aCount,
                                 uint32_t *_retval)
{
  return ReadSegments(NS_CopySegmentToBuffer, aBuf, aCount, _retval);
}

NS_IMETHODIMP nsWEBPEncoder::ReadSegments(nsWriteSegmentFun aWriter, void *aClosure, uint32_t aCount, uint32_t *_retval)
{
  // Avoid another thread reallocing the buffer underneath us
  ReentrantMonitorAutoEnter autoEnter(mReentrantMonitor);

  uint32_t maxCount = mImageBufferUsed - mImageBufferReadPoint;
  if (maxCount == 0) {
    *_retval = 0;
    return mFinished ? NS_OK : NS_BASE_STREAM_WOULD_BLOCK;
  }

  if (aCount > maxCount)
    aCount = maxCount;
  nsresult rv = aWriter(this, aClosure,
                        reinterpret_cast<const char*>(mImageBuffer+mImageBufferReadPoint),
                        0, aCount, _retval);
  if (NS_SUCCEEDED(rv)) {
    NS_ASSERTION(*_retval <= aCount, "bad write count");
    mImageBufferReadPoint += *_retval;
  }

  // errors returned from the writer end here!
  return NS_OK;
}

NS_IMETHODIMP nsWEBPEncoder::IsNonBlocking(bool *_retval)
{
  *_retval = true;
  return NS_OK;
}

NS_IMETHODIMP nsWEBPEncoder::AsyncWait(nsIInputStreamCallback *aCallback,
                                      uint32_t aFlags,
                                      uint32_t aRequestedCount,
                                      nsIEventTarget *aTarget)
{
  if (aFlags != 0)
    return NS_ERROR_NOT_IMPLEMENTED;

  if (mCallback || mCallbackTarget)
    return NS_ERROR_UNEXPECTED;

  mCallbackTarget = aTarget;
  // 0 means "any number of bytes except 0"
  mNotifyThreshold = aRequestedCount;
  if (!aRequestedCount)
    mNotifyThreshold = 1024; // We don't want to notify incessantly

  // We set the callback absolutely last, because NotifyListener uses it to
  // determine if someone needs to be notified.  If we don't set it last,
  // NotifyListener might try to fire off a notification to a null target
  // which will generally cause non-threadsafe objects to be used off the main thread
  mCallback = aCallback;

  // What we are being asked for may be present already
  NotifyListener();
  return NS_OK;
}

NS_IMETHODIMP nsWEBPEncoder::CloseWithStatus(nsresult aStatus)
{
  return Close();
}

// nsWEBPEncoder::ConvertHostARGBRow
//
//    Our colors are stored with premultiplied alphas, but PNGs use
//    post-multiplied alpha. This swaps to PNG-style alpha.
//
//    Copied from gfx/cairo/cairo/src/cairo-png.c

void
nsWEBPEncoder::ConvertHostARGBRow(const uint8_t* aSrc, uint8_t* aDest,
                                 uint32_t aPixelWidth,
                                 bool aUseTransparency)
{
  uint32_t pixelStride = aUseTransparency ? 4 : 3;
  for (uint32_t x = 0; x < aPixelWidth; x ++) {
    const uint32_t& pixelIn = ((const uint32_t*)(aSrc))[x];
    uint8_t *pixelOut = &aDest[x * pixelStride];

    uint8_t alpha = (pixelIn & 0xff000000) >> 24;
    if (alpha == 0) {
      pixelOut[0] = pixelOut[1] = pixelOut[2] = pixelOut[3] = 0;
    } else {
      pixelOut[0] = (((pixelIn & 0xff0000) >> 16) * 255 + alpha / 2) / alpha;
      pixelOut[1] = (((pixelIn & 0x00ff00) >>  8) * 255 + alpha / 2) / alpha;
      pixelOut[2] = (((pixelIn & 0x0000ff) >>  0) * 255 + alpha / 2) / alpha;
      if (aUseTransparency)
        pixelOut[3] = alpha;
    }
  }
}

// nsWEBPEncoder::WriteCallback

int // static
nsWEBPEncoder::WriteCallback(const uint8_t* data, size_t size, const WebPPicture* const picture)
{
  nsWEBPEncoder* that = static_cast<nsWEBPEncoder*>(picture->custom_ptr);
  if (! that->mImageBuffer)
    return 0;

  if (that->mImageBufferUsed + size > that->mImageBufferSize) {
    // When we're reallocing the buffer we need to take the lock to ensure
    // that nobody is trying to read from the buffer we are destroying
    ReentrantMonitorAutoEnter autoEnter(that->mReentrantMonitor);

    // expand buffer, just double each time
    that->mImageBufferSize *= 2;
    uint8_t* newBuf = (uint8_t*)realloc(that->mImageBuffer,
                                        that->mImageBufferSize);
    if (! newBuf) {
      // can't resize, just zero (this will keep us from writing more)
      free(that->mImageBuffer);
      that->mImageBuffer = nullptr;
      that->mImageBufferSize = 0;
      that->mImageBufferUsed = 0;
      return 0;
    }
    that->mImageBuffer = newBuf;
  }
  memcpy(&that->mImageBuffer[that->mImageBufferUsed], data, size);
  that->mImageBufferUsed += size;
  that->NotifyListener();
  return 1;
}

void
nsWEBPEncoder::NotifyListener()
{
  // We might call this function on multiple threads (any threads that call
  // AsyncWait and any that do encoding) so we lock to avoid notifying the
  // listener twice about the same data (which generally leads to a truncated
  // image).
  ReentrantMonitorAutoEnter autoEnter(mReentrantMonitor);

  if (mCallback &&
      (mImageBufferUsed - mImageBufferReadPoint >= mNotifyThreshold ||
       mFinished)) {
    nsCOMPtr<nsIInputStreamCallback> callback;
    if (mCallbackTarget) {
      callback = NS_NewInputStreamReadyEvent("nsWEBPEncoder::NotifyListener",
                                             mCallback, mCallbackTarget);
    } else {
      callback = mCallback;
    }

    NS_ASSERTION(callback, "Shouldn't fail to make the callback");
    // Null the callback first because OnInputStreamReady could reenter
    // AsyncWait
    mCallback = nullptr;
    mCallbackTarget = nullptr;
    mNotifyThreshold = 0;

    callback->OnInputStreamReady(this);
  }
}
