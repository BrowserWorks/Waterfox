/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsHttpChunkedDecoder_h__
#define nsHttpChunkedDecoder_h__

#include "nsError.h"
#include "nsString.h"
#include "nsHttpHeaderArray.h"

namespace mozilla {
namespace net {

class nsHttpChunkedDecoder {
 public:
  nsHttpChunkedDecoder()
      : mTrailers(nullptr),
        mChunkRemaining(0),
        mReachedEOF(false),
        mWaitEOF(false) {}
  ~nsHttpChunkedDecoder() = default;

  bool ReachedEOF() { return mReachedEOF; }

  // called by the transaction to handle chunked content.
  [[nodiscard]] nsresult HandleChunkedContent(char* buf, uint32_t count,
                                              uint32_t* contentRead,
                                              uint32_t* contentRemaining);

  nsHttpHeaderArray* Trailers() { return mTrailers.get(); }

  UniquePtr<nsHttpHeaderArray> TakeTrailers() { return std::move(mTrailers); }

  // How mush data is still missing(needs to arrive) from the current chunk.
  uint32_t GetChunkRemaining() { return mChunkRemaining; }

 private:
  [[nodiscard]] nsresult ParseChunkRemaining(char* buf, uint32_t count,
                                             uint32_t* countRead);

 private:
  UniquePtr<nsHttpHeaderArray> mTrailers;
  uint32_t mChunkRemaining;
  nsCString mLineBuf;  // may hold a partial line
  bool mReachedEOF;
  bool mWaitEOF;
};

}  // namespace net
}  // namespace mozilla

#endif
