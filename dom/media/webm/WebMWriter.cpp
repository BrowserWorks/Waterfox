/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-*/
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebMWriter.h"
#include "EbmlComposer.h"
#include "GeckoProfiler.h"
#include "OpusTrackEncoder.h"

namespace mozilla {

WebMWriter::WebMWriter(uint32_t aTrackTypes) : ContainerWriter()
{
  mMetadataRequiredFlag = aTrackTypes;
  mEbmlComposer = new EbmlComposer();
}

WebMWriter::~WebMWriter()
{
  // Out-of-line dtor so mEbmlComposer nsAutoPtr can delete a complete type.
}

nsresult
WebMWriter::WriteEncodedTrack(const EncodedFrameContainer& aData,
                              uint32_t aFlags)
{
  AUTO_PROFILER_LABEL("WebMWriter::WriteEncodedTrack", OTHER);
  for (uint32_t i = 0 ; i < aData.GetEncodedFrames().Length(); i++) {
    mEbmlComposer->WriteSimpleBlock(aData.GetEncodedFrames().ElementAt(i).get());
  }
  return NS_OK;
}

nsresult
WebMWriter::GetContainerData(nsTArray<nsTArray<uint8_t> >* aOutputBufs,
                             uint32_t aFlags)
{
  AUTO_PROFILER_LABEL("WebMWriter::GetContainerData", OTHER);
  mEbmlComposer->ExtractBuffer(aOutputBufs, aFlags);
  if (aFlags & ContainerWriter::FLUSH_NEEDED) {
    mIsWritingComplete = true;
  }
  return NS_OK;
}

nsresult
WebMWriter::SetMetadata(TrackMetadataBase* aMetadata)
{
  MOZ_ASSERT(aMetadata);
  AUTO_PROFILER_LABEL("WebMWriter::SetMetadata", OTHER);

  if (aMetadata->GetKind() == TrackMetadataBase::METADATA_VP8) {
    VP8Metadata* meta = static_cast<VP8Metadata*>(aMetadata);
    MOZ_ASSERT(meta, "Cannot find vp8 encoder metadata");
    mEbmlComposer->SetVideoConfig(meta->mWidth, meta->mHeight,
                                  meta->mDisplayWidth, meta->mDisplayHeight);
    mMetadataRequiredFlag = mMetadataRequiredFlag & ~ContainerWriter::CREATE_VIDEO_TRACK;
  }

  if (aMetadata->GetKind() == TrackMetadataBase::METADATA_VORBIS) {
    VorbisMetadata* meta = static_cast<VorbisMetadata*>(aMetadata);
    MOZ_ASSERT(meta, "Cannot find vorbis encoder metadata");
    mEbmlComposer->SetAudioConfig(meta->mSamplingFrequency, meta->mChannels);
    mEbmlComposer->SetAudioCodecPrivateData(meta->mData);
    mMetadataRequiredFlag = mMetadataRequiredFlag & ~ContainerWriter::CREATE_AUDIO_TRACK;
  }

  if (aMetadata->GetKind() == TrackMetadataBase::METADATA_OPUS) {
    OpusMetadata* meta = static_cast<OpusMetadata*>(aMetadata);
    MOZ_ASSERT(meta, "Cannot find Opus encoder metadata");
    mEbmlComposer->SetAudioConfig(meta->mSamplingFrequency, meta->mChannels);
    mEbmlComposer->SetAudioCodecPrivateData(meta->mIdHeader);
    mMetadataRequiredFlag = mMetadataRequiredFlag & ~ContainerWriter::CREATE_AUDIO_TRACK;
  }

  if (!mMetadataRequiredFlag) {
    mEbmlComposer->GenerateHeader();
  }
  return NS_OK;
}

} // namespace mozilla
