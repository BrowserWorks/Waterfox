/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#if !defined(AudioTrimmer_h_)
#  define AudioTrimmer_h_

#  include "PlatformDecoderModule.h"
#  include "mozilla/Mutex.h"

namespace mozilla {

DDLoggedTypeDeclNameAndBase(AudioTrimmer, MediaDataDecoder);

class AudioTrimmer : public MediaDataDecoder {
 public:
  AudioTrimmer(already_AddRefed<MediaDataDecoder> aDecoder,
               const CreateDecoderParams& aParams)
      : mDecoder(aDecoder), mTaskQueue(aParams.mTaskQueue) {}

  RefPtr<InitPromise> Init() override;
  RefPtr<DecodePromise> Decode(MediaRawData* aSample) override;
  bool CanDecodeBatch() override { return mDecoder->CanDecodeBatch(); }
  RefPtr<DecodePromise> DecodeBatch(
      nsTArray<RefPtr<MediaRawData>>&& aSamples) override {
    return mDecoder->DecodeBatch(std::move(aSamples));
  }
  RefPtr<DecodePromise> Drain() override;
  RefPtr<FlushPromise> Flush() override;
  RefPtr<ShutdownPromise> Shutdown() override;
  nsCString GetDescriptionName() const override;
  bool IsHardwareAccelerated(nsACString& aFailureReason) const override;
  void SetSeekThreshold(const media::TimeUnit& aTime) override;
  bool SupportDecoderRecycling() const override;
  ConversionRequired NeedsConversion() const override;

 private:
  RefPtr<DecodePromise> HandleDecodedResult(
      DecodePromise::ResolveOrRejectValue&& aValue, MediaRawData* aRaw);
  RefPtr<MediaDataDecoder> mDecoder;
  RefPtr<AbstractThread> mTaskQueue;
  AutoTArray<Maybe<media::TimeInterval>, 2> mTrimmers;
};

}  // namespace mozilla

#endif  // AudioTrimmer_h_
