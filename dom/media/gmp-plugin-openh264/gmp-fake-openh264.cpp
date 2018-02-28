/*!
 * \copy
 *     Copyright (c)  2009-2014, Cisco Systems
 *     Copyright (c)  2014, Mozilla
 *     All rights reserved.
 *
 *     Redistribution and use in source and binary forms, with or without
 *     modification, are permitted provided that the following conditions
 *     are met:
 *
 *        * Redistributions of source code must retain the above copyright
 *          notice, this list of conditions and the following disclaimer.
 *
 *        * Redistributions in binary form must reproduce the above copyright
 *          notice, this list of conditions and the following disclaimer in
 *          the documentation and/or other materials provided with the
 *          distribution.
 *
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *     "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *     LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 *     FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *     COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 *     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 *     BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *     LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 *     ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *     POSSIBILITY OF SUCH DAMAGE.
 *
 *
 *************************************************************************************
 */

#include <stdint.h>
#include <time.h>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <string>
#include <memory>
#include <assert.h>
#include <limits.h>

#include "gmp-platform.h"
#include "gmp-video-host.h"
#include "gmp-video-encode.h"
#include "gmp-video-decode.h"
#include "gmp-video-frame-i420.h"
#include "gmp-video-frame-encoded.h"

#if defined(GMP_FAKE_SUPPORT_DECRYPT)
#include "gmp-decryption.h"
#include "gmp-test-decryptor.h"
#include "gmp-test-storage.h"
#endif

#include "mozilla/PodOperations.h"

#if defined(_MSC_VER)
#define PUBLIC_FUNC __declspec(dllexport)
#else
#define PUBLIC_FUNC
#endif

#define BIG_FRAME 10000

#define GL_CRIT 0
#define GL_ERROR 1
#define GL_INFO  2
#define GL_DEBUG 3

const char* kLogStrings[] = {
  "Critical",
  "Error",
  "Info",
  "Debug"
};

static int g_log_level = GL_CRIT;

#define GMPLOG(l, x) do {                                  \
        if (l <= g_log_level) {                            \
        const char *log_string = "unknown";                \
        if ((l >= 0) && (l <= 3)) {                        \
        log_string = kLogStrings[l];                       \
        }                                                  \
        std::cerr << log_string << ": " << x << std::endl; \
        }                                                  \
    } while(0)


GMPPlatformAPI* g_platform_api = nullptr;

class FakeVideoEncoder;
class FakeVideoDecoder;

struct EncodedFrame {
  uint32_t length_;
  uint8_t h264_compat_;
  uint32_t magic_;
  uint32_t width_;
  uint32_t height_;
  uint8_t y_;
  uint8_t u_;
  uint8_t v_;
  uint32_t timestamp_;
};

#define ENCODED_FRAME_MAGIC 0x4652414d

template <typename T> class SelfDestruct {
 public:
  explicit SelfDestruct (T* t) : t_ (t) {}
  ~SelfDestruct() {
    if (t_) {
      t_->Destroy();
    }
  }

#if 0 // unused
  T* forget() {
    T* t = t_;
    t_ = nullptr;

    return t;
  }
#endif

 private:
  T* t_;
};

class FakeEncoderTask : public GMPTask {
 public:
  FakeEncoderTask(FakeVideoEncoder* encoder,
                  GMPVideoi420Frame* frame,
                  GMPVideoFrameType type)
      : encoder_(encoder), frame_(frame), type_(type) {}

  void Run() override;
  void Destroy() override { delete this; }

  FakeVideoEncoder* encoder_;
  GMPVideoi420Frame* frame_;
  GMPVideoFrameType type_;
};

class FakeVideoEncoder : public GMPVideoEncoder {
 public:
  explicit FakeVideoEncoder (GMPVideoHost* hostAPI) :
    host_ (hostAPI),
    callback_ (nullptr),
    frames_encoded_(0) {}

  void InitEncode (const GMPVideoCodec& codecSettings,
                   const uint8_t* aCodecSpecific,
                   uint32_t aCodecSpecificSize,
                   GMPVideoEncoderCallback* callback,
                   int32_t numberOfCores,
                   uint32_t maxPayloadSize) override {
    callback_ = callback;

    const char *env = getenv("GMP_LOGGING");
    if (env) {
      g_log_level = atoi(env);
    }
    GMPLOG (GL_INFO, "Initialized encoder");
  }

  void SendFrame(GMPVideoi420Frame* inputImage,
                 GMPVideoFrameType frame_type,
                 uint8_t nal_type)
  {
    // Encode this in a frame that looks a little bit like H.264.
    // Send SPS/PPS/IDR to avoid confusing people
    // Copy the data. This really should convert this to network byte order.
    EncodedFrame eframe;
    eframe.length_ = sizeof(eframe) - sizeof(uint32_t);
    eframe.h264_compat_ = nal_type; // 7 = SPS, 8 = PPS, 5 = IFrame/IDR slice, 1=PFrame/slice
    eframe.magic_ = ENCODED_FRAME_MAGIC;
    eframe.width_ = inputImage->Width();
    eframe.height_ = inputImage->Height();
    eframe.y_ = AveragePlane(inputImage->Buffer(kGMPYPlane),
                             inputImage->AllocatedSize(kGMPYPlane));
    eframe.u_ = AveragePlane(inputImage->Buffer(kGMPUPlane),
                             inputImage->AllocatedSize(kGMPUPlane));
    eframe.v_ = AveragePlane(inputImage->Buffer(kGMPVPlane),
                             inputImage->AllocatedSize(kGMPVPlane));

    eframe.timestamp_ = inputImage->Timestamp();

    // Now return the encoded data back to the parent.
    GMPVideoFrame* ftmp;
    GMPErr err = host_->CreateFrame(kGMPEncodedVideoFrame, &ftmp);
    if (err != GMPNoErr) {
      GMPLOG (GL_ERROR, "Error creating encoded frame");
      return;
    }

    GMPVideoEncodedFrame* f = static_cast<GMPVideoEncodedFrame*> (ftmp);

    err = f->CreateEmptyFrame (sizeof(eframe) +
                               (nal_type == 5 ? sizeof(uint32_t) + BIG_FRAME : 0));
    if (err != GMPNoErr) {
      GMPLOG (GL_ERROR, "Error allocating frame data");
      f->Destroy();
      return;
    }
    memcpy(f->Buffer(), &eframe, sizeof(eframe));
    if (nal_type == 5) {
      // set the size for the fake iframe
      *((uint32_t*) (f->Buffer() + sizeof(eframe))) = BIG_FRAME;
    }

    f->SetEncodedWidth(eframe.width_);
    f->SetEncodedHeight(eframe.height_);
    f->SetTimeStamp(eframe.timestamp_);
    f->SetFrameType(frame_type);
    f->SetCompleteFrame(true);
    f->SetBufferType(GMP_BufferLength32);

    GMPLOG (GL_DEBUG, "Encoding complete. type= "
            << f->FrameType()
            << " NAL_type="
            << (int) eframe.h264_compat_
            << " length="
            << f->Size()
            << " timestamp="
            << f->TimeStamp()
            << " width/height="
            << eframe.width_
            << "x" << eframe.height_);

    // Return the encoded frame.
    GMPCodecSpecificInfo info;
    mozilla::PodZero(&info);
    info.mCodecType = kGMPVideoCodecH264;
    info.mBufferType = GMP_BufferLength32;
    info.mCodecSpecific.mH264.mSimulcastIdx = 0;
    GMPLOG (GL_DEBUG, "Calling callback");
    callback_->Encoded (f, reinterpret_cast<uint8_t*> (&info), sizeof(info));
    GMPLOG (GL_DEBUG, "Callback called");
  }

  void Encode (GMPVideoi420Frame* inputImage,
               const uint8_t* aCodecSpecificInfo,
               uint32_t aCodecSpecificInfoLength,
               const GMPVideoFrameType* aFrameTypes,
               uint32_t aFrameTypesLength) override {
    GMPLOG (GL_DEBUG,
            __FUNCTION__
            << " size="
            << inputImage->Width() << "x" << inputImage->Height());

    assert (aFrameTypesLength != 0);

    g_platform_api->runonmainthread(new FakeEncoderTask(this,
                                                        inputImage,
                                                        aFrameTypes[0]));
  }

  void Encode_m (GMPVideoi420Frame* inputImage,
                 GMPVideoFrameType frame_type) {
    SelfDestruct<GMPVideoi420Frame> ifd (inputImage);

    if (frame_type  == kGMPKeyFrame) {
      if (!inputImage)
        return;
    }
    if (!inputImage) {
      GMPLOG (GL_ERROR, "no input image");
      return;
    }

    if (frame_type  == kGMPKeyFrame ||
        frames_encoded_++ % 10 == 0) { // periodically send iframes anyways
      SendFrame(inputImage, kGMPKeyFrame, 7); // 7 = SPS, 8 = PPS, 5 = IFrame/IDR slice, 1=PFrame/slice
      SendFrame(inputImage, kGMPKeyFrame, 8);
      SendFrame(inputImage, kGMPKeyFrame, 5);
    } else {
      SendFrame(inputImage, frame_type, 1);
    }
  }

  void SetChannelParameters (uint32_t aPacketLoss, uint32_t aRTT) override {
  }

  void SetRates (uint32_t aNewBitRate, uint32_t aFrameRate) override {
  }

  void SetPeriodicKeyFrames (bool aEnable) override {
  }

  void EncodingComplete() override {
    delete this;
  }

 private:
  uint8_t AveragePlane(uint8_t* ptr, size_t len) {
    uint64_t val = 0;

    for (size_t i=0; i<len; ++i) {
      val += ptr[i];
    }

    return (val / len) % 0xff;
  }

  GMPVideoHost* host_;
  GMPVideoEncoderCallback* callback_;
  uint32_t frames_encoded_;
};

void FakeEncoderTask::Run() {
  encoder_->Encode_m(frame_, type_);
  frame_ = nullptr; // Encode_m() destroys the frame
}

class FakeDecoderTask : public GMPTask {
 public:
  FakeDecoderTask(FakeVideoDecoder* decoder,
                  GMPVideoEncodedFrame* frame,
                  int64_t time)
      : decoder_(decoder), frame_(frame), time_(time) {}

  void Run() override;
  void Destroy() override { delete this; }

  FakeVideoDecoder* decoder_;
  GMPVideoEncodedFrame* frame_;
  int64_t time_;
};

class FakeVideoDecoder : public GMPVideoDecoder {
 public:
  explicit FakeVideoDecoder (GMPVideoHost* hostAPI) :
    host_ (hostAPI),
    callback_ (nullptr) {}

  ~FakeVideoDecoder() override = default;

  void InitDecode (const GMPVideoCodec& codecSettings,
                   const uint8_t* aCodecSpecific,
                   uint32_t aCodecSpecificSize,
                   GMPVideoDecoderCallback* callback,
                   int32_t coreCount) override {
    GMPLOG (GL_INFO, "InitDecode");

    const char *env = getenv("GMP_LOGGING");
    if (env) {
      g_log_level = atoi(env);
    }
    callback_ = callback;
  }

  void Decode (GMPVideoEncodedFrame* inputFrame,
               bool missingFrames,
               const uint8_t* aCodecSpecificInfo,
               uint32_t aCodecSpecificInfoLength,
               int64_t renderTimeMs = -1) override {
    GMPLOG (GL_DEBUG, __FUNCTION__
            << "Decoding frame size=" << inputFrame->Size()
            << " timestamp=" << inputFrame->TimeStamp());
    g_platform_api->runonmainthread(new FakeDecoderTask(this, inputFrame, renderTimeMs));
  }

  void Reset() override {
  }

  void Drain() override {
  }

  void DecodingComplete() override {
    delete this;
  }

  // Return the decoded data back to the parent.
  void Decode_m (GMPVideoEncodedFrame* inputFrame,
                 int64_t renderTimeMs) {
    // Attach a self-destructor so that the input frame is destroyed on return.
    SelfDestruct<GMPVideoEncodedFrame> ifd (inputFrame);

    EncodedFrame *eframe;
    eframe = reinterpret_cast<EncodedFrame*>(inputFrame->Buffer());
    GMPLOG(GL_DEBUG,"magic="  << eframe->magic_ << " h264_compat="  << (int) eframe->h264_compat_
           << " width=" << eframe->width_ << " height=" << eframe->height_
           << " timestamp=" << inputFrame->TimeStamp()
           << " y/u/v=" << (int) eframe->y_ << ":" << (int) eframe->u_ << ":" << (int) eframe->v_);
    if (inputFrame->Size() != (sizeof(*eframe))) {
      GMPLOG (GL_ERROR, "Couldn't decode frame. Size=" << inputFrame->Size());
      return;
    }

    if (eframe->magic_ != ENCODED_FRAME_MAGIC) {
      GMPLOG (GL_ERROR, "Couldn't decode frame. Magic=" << eframe->magic_);
      return;
    }
    if (eframe->h264_compat_ != 5 && eframe->h264_compat_ != 1) {
      // only return video for iframes or pframes
      GMPLOG (GL_DEBUG, "Not a video frame: NAL type " << (int) eframe->h264_compat_);
      // Decode it anyways
    }

    int width = eframe->width_;
    int height = eframe->height_;
    int ystride = eframe->width_;
    int uvstride = eframe->width_/2;

    GMPLOG (GL_DEBUG, "Video frame ready for display "
            << width
            << "x"
            << height
            << " timestamp="
            << inputFrame->TimeStamp());

    GMPVideoFrame* ftmp = nullptr;

    // Translate the image.
    GMPErr err = host_->CreateFrame (kGMPI420VideoFrame, &ftmp);
    if (err != GMPNoErr) {
      GMPLOG (GL_ERROR, "Couldn't allocate empty I420 frame");
      return;
    }

    GMPVideoi420Frame* frame = static_cast<GMPVideoi420Frame*> (ftmp);
    err = frame->CreateEmptyFrame (
        width, height,
        ystride, uvstride, uvstride);
    if (err != GMPNoErr) {
      GMPLOG (GL_ERROR, "Couldn't make decoded frame");
      return;
    }

    memset(frame->Buffer(kGMPYPlane),
           eframe->y_,
           frame->AllocatedSize(kGMPYPlane));
    memset(frame->Buffer(kGMPUPlane),
           eframe->u_,
           frame->AllocatedSize(kGMPUPlane));
    memset(frame->Buffer(kGMPVPlane),
           eframe->v_,
           frame->AllocatedSize(kGMPVPlane));

    GMPLOG (GL_DEBUG, "Allocated size = "
            << frame->AllocatedSize (kGMPYPlane));
    frame->SetTimestamp (inputFrame->TimeStamp());
    frame->SetDuration (inputFrame->Duration());
    callback_->Decoded (frame);
  }

  GMPVideoHost* host_;
  GMPVideoDecoderCallback* callback_;
};

void FakeDecoderTask::Run() {
  decoder_->Decode_m(frame_, time_);
  frame_ = nullptr; // Decode_m() destroys the frame
}

extern "C" {

  PUBLIC_FUNC GMPErr
  GMPInit (GMPPlatformAPI* aPlatformAPI) {
    g_platform_api = aPlatformAPI;
    return GMPNoErr;
  }

  PUBLIC_FUNC GMPErr
  GMPGetAPI (const char* aApiName, void* aHostAPI, void** aPluginApi) {
    if (!strcmp (aApiName, GMP_API_VIDEO_DECODER)) {
      *aPluginApi = new FakeVideoDecoder (static_cast<GMPVideoHost*> (aHostAPI));
      return GMPNoErr;
    }
    if (!strcmp (aApiName, GMP_API_VIDEO_ENCODER)) {
      *aPluginApi = new FakeVideoEncoder (static_cast<GMPVideoHost*> (aHostAPI));
      return GMPNoErr;
#if defined(GMP_FAKE_SUPPORT_DECRYPT)
    }
    if (!strcmp (aApiName, GMP_API_DECRYPTOR)) {
      *aPluginApi = new FakeDecryptor();
      return GMPNoErr;
#endif
    }
    return GMPGenericErr;
  }

  PUBLIC_FUNC void
  GMPShutdown (void) {
    g_platform_api = nullptr;
  }

} // extern "C"
