/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WMFDecoderModule.h"
#include "GfxDriverInfo.h"
#include "MFTDecoder.h"
#include "MP4Decoder.h"
#include "MediaInfo.h"
#include "MediaPrefs.h"
#include "VPXDecoder.h"
#include "WMF.h"
#include "WMFAudioMFTManager.h"
#include "WMFMediaDataDecoder.h"
#include "WMFVideoMFTManager.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/Maybe.h"
#include "mozilla/Services.h"
#include "mozilla/StaticMutex.h"
#include "mozilla/WindowsVersion.h"
#include "mozilla/gfx/gfxVars.h"
#include "nsAutoPtr.h"
#include "nsComponentManagerUtils.h"
#include "nsIGfxInfo.h"
#include "nsIWindowsRegKey.h"
#include "nsServiceManagerUtils.h"
#include "nsWindowsHelpers.h"
#include "prsystem.h"
#include "nsIXULRuntime.h"

namespace mozilla {

static Atomic<bool> sDXVAEnabled(false);

WMFDecoderModule::~WMFDecoderModule()
{
  if (mWMFInitialized) {
    DebugOnly<HRESULT> hr = wmf::MFShutdown();
    NS_ASSERTION(SUCCEEDED(hr), "MFShutdown failed");
  }
}

/* static */
void
WMFDecoderModule::Init()
{
  if (XRE_IsContentProcess()) {
    // If we're in the content process and the UseGPUDecoder pref is set, it
    // means that we've given up on the GPU process (it's been crashing) so we
    // should disable DXVA
    sDXVAEnabled = !MediaPrefs::PDMUseGPUDecoder();
  } else if (XRE_IsGPUProcess()) {
    // Always allow DXVA in the GPU process.
    sDXVAEnabled = true;
  } else {
    // Only allow DXVA in the UI process if we aren't in e10s Firefox
    sDXVAEnabled = !mozilla::BrowserTabsRemoteAutostart();
  }

  sDXVAEnabled = sDXVAEnabled && gfx::gfxVars::CanUseHardwareVideoDecoding();
}

/* static */
int
WMFDecoderModule::GetNumDecoderThreads()
{
  int32_t numCores = PR_GetNumberOfProcessors();

  // If we have more than 4 cores, let the decoder decide how many threads.
  // On an 8 core machine, WMF chooses 4 decoder threads
  const int WMF_DECODER_DEFAULT = -1;
  int32_t prefThreadCount = WMF_DECODER_DEFAULT;
  if (XRE_GetProcessType() != GeckoProcessType_GPU) {
    prefThreadCount = MediaPrefs::PDMWMFThreadCount();
  }
  if (prefThreadCount != WMF_DECODER_DEFAULT) {
    return std::max(prefThreadCount, 1);
  } else if (numCores > 4) {
    return WMF_DECODER_DEFAULT;
  }
  return std::max(numCores - 1, 1);
}

nsresult
WMFDecoderModule::Startup()
{
  mWMFInitialized = SUCCEEDED(wmf::MFStartup());
  return mWMFInitialized ? NS_OK : NS_ERROR_FAILURE;
}

already_AddRefed<MediaDataDecoder>
WMFDecoderModule::CreateVideoDecoder(const CreateDecoderParams& aParams)
{
  if (aParams.mOptions.contains(CreateDecoderParams::Option::LowLatency)) {
    // Latency on Windows is bad. Let's not attempt to decode with WMF decoders
    // when low latency is required.
    return nullptr;
  }

  nsAutoPtr<WMFVideoMFTManager> manager(
    new WMFVideoMFTManager(aParams.VideoConfig(),
                           aParams.mKnowsCompositor,
                           aParams.mImageContainer,
                           sDXVAEnabled));

  MediaResult result = manager->Init();
  if (NS_FAILED(result)) {
    if (aParams.mError) {
      *aParams.mError = result;
    }
    return nullptr;
  }

  RefPtr<MediaDataDecoder> decoder =
    new WMFMediaDataDecoder(manager.forget(), aParams.mTaskQueue);

  return decoder.forget();
}

already_AddRefed<MediaDataDecoder>
WMFDecoderModule::CreateAudioDecoder(const CreateDecoderParams& aParams)
{
  nsAutoPtr<WMFAudioMFTManager> manager(
    new WMFAudioMFTManager(aParams.AudioConfig()));

  if (!manager->Init()) {
    return nullptr;
  }

  RefPtr<MediaDataDecoder> decoder =
    new WMFMediaDataDecoder(manager.forget(), aParams.mTaskQueue);
  return decoder.forget();
}

static bool
CanCreateMFTDecoder(const GUID& aGuid)
{
  if (FAILED(wmf::MFStartup())) {
    return false;
  }
  bool hasdecoder = false;
  {
    RefPtr<MFTDecoder> decoder(new MFTDecoder());
    hasdecoder = SUCCEEDED(decoder->Create(aGuid));
  }
  wmf::MFShutdown();
  return hasdecoder;
}

template<const GUID& aGuid>
static bool
CanCreateWMFDecoder()
{
  static StaticMutex sMutex;
  StaticMutexAutoLock lock(sMutex);
  static Maybe<bool> result;
  if (result.isNothing()) {
    result.emplace(CanCreateMFTDecoder(aGuid));
  }
  return result.value();
}

/* static */ bool
WMFDecoderModule::HasH264()
{
  return CanCreateWMFDecoder<CLSID_CMSH264DecoderMFT>();
}

/* static */ bool
WMFDecoderModule::HasAAC()
{
  return CanCreateWMFDecoder<CLSID_CMSAACDecMFT>();
}

bool
WMFDecoderModule::SupportsMimeType(
  const nsACString& aMimeType,
  DecoderDoctorDiagnostics* aDiagnostics) const
{
  UniquePtr<TrackInfo> trackInfo = CreateTrackInfoWithMIMEType(aMimeType);
  if (!trackInfo) {
    return false;
  }
  return Supports(*trackInfo, aDiagnostics);
}

bool
WMFDecoderModule::Supports(const TrackInfo& aTrackInfo,
                           DecoderDoctorDiagnostics* aDiagnostics) const
{
  if ((aTrackInfo.mMimeType.EqualsLiteral("audio/mp4a-latm") ||
       aTrackInfo.mMimeType.EqualsLiteral("audio/mp4")) &&
       WMFDecoderModule::HasAAC()) {
    return true;
  }
  if (MP4Decoder::IsH264(aTrackInfo.mMimeType)
      && WMFDecoderModule::HasH264()) {
    return true;
  }
  if (aTrackInfo.mMimeType.EqualsLiteral("audio/mpeg") &&
      CanCreateWMFDecoder<CLSID_CMP3DecMediaObject>()) {
    return true;
  }
  if (MediaPrefs::PDMWMFVP9DecoderEnabled()) {
    if (VPXDecoder::IsVP9(aTrackInfo.mMimeType)
        && CanCreateWMFDecoder<CLSID_WebmMfVpxDec>()) {
      return true;
    }
  }

  // Some unsupported codec.
  return false;
}

} // namespace mozilla
