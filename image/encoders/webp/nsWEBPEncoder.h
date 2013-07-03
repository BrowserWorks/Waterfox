/* This Source Code Form is subject to the terms of the Mozilla Public
   * License, v. 2.0. If a copy of the MPL was not distributed with this
   * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
  
#include "mozilla/Attributes.h"
#include "mozilla/ReentrantMonitor.h"
  
#include "imgIEncoder.h"

#include "nsCOMPtr.h"

#define NS_WEBPENCODER_CID \
{ /* 05848c32-1722-462d-bb49-688dd1a63ee5 */			\
 	0x05848c32,						\
	0x1722,							\
	0x462d,							\
       {0xbb, 0x49, 0x68, 0x8d, 0xd1, 0xa6, 0x3e, 0xe5} 	\
}

extern "C" {
#include "webp/encode.h"
}

class nsWEBPEncoder final : public imgIEncoder
{
  typedef mozilla::ReentrantMonitor ReentrantMonitor;
public:
  NS_DECL_ISUPPORTS
  NS_DECL_IMGIENCODER
  NS_DECL_NSIINPUTSTREAM
  NS_DECL_NSIASYNCINPUTSTREAM

  nsWEBPEncoder();

private:
  ~nsWEBPEncoder();

protected:

  WebPPicture picture;
  WebPConfig config;
  WebPMemoryWriter memory_writer;

  void NotifyListener();
  bool mFinished;

  // image buffer
  uint8_t* mImageBuffer;
  uint32_t mImageBufferSize;
  uint32_t mImageBufferUsed;

  uint32_t mImageBufferReadPoint;

  nsCOMPtr<nsIInputStreamCallback> mCallback;
  nsCOMPtr<nsIEventTarget> mCallbackTarget;
  uint32_t mNotifyThreshold;
  static int WriteCallback(const uint8_t* data, size_t size, const WebPPicture* const picture);
  void ConvertHostARGBRow(const uint8_t* aSrc, uint8_t* aDest, uint32_t aPixelWidth, bool aUseTransparency);

  /*
    nsWEBPEncoder is designed to allow one thread to pump data into it while another
    reads from it.  We lock to ensure that the buffer remains append-only while
    we read from it (that it is not realloced) and to ensure that only one thread
    dispatches a callback for each call to AsyncWait.
   */
  ReentrantMonitor mReentrantMonitor;
};
