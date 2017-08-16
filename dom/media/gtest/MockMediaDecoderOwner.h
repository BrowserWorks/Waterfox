/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOCK_MEDIA_DECODER_OWNER_H_
#define MOCK_MEDIA_DECODER_OWNER_H_

#include "MediaDecoderOwner.h"
#include "mozilla/AbstractThread.h"
#include "nsAutoPtr.h"

namespace mozilla
{

class MockMediaDecoderOwner : public MediaDecoderOwner
{
public:
  nsresult DispatchAsyncEvent(const nsAString& aName) override
  {
    return NS_OK;
  }
  void FireTimeUpdate(bool aPeriodic) override {}
  bool GetPaused() override { return false; }
  void MetadataLoaded(const MediaInfo* aInfo,
                      nsAutoPtr<const MetadataTags> aTags) override
  {
  }
  void NetworkError() override {}
  void DecodeError(const MediaResult& aError) override {}
  bool HasError() const override { return false; }
  void LoadAborted() override {}
  void PlaybackEnded() override {}
  void SeekStarted() override {}
  void SeekCompleted() override {}
  void DownloadProgressed() override {}
  void UpdateReadyState() override {}
  void FirstFrameLoaded() override {}
  void DispatchEncrypted(const nsTArray<uint8_t>& aInitData,
                         const nsAString& aInitDataType) override {}
  bool IsActive() const override { return true; }
  bool IsHidden() const override { return false; }
  void DownloadSuspended() override {}
  void DownloadResumed(bool aForceNetworkLoading) override {}
  void NotifySuspendedByCache(bool aIsSuspended) override {}
  void NotifyDecoderPrincipalChanged() override {}
  VideoFrameContainer* GetVideoFrameContainer() override
  {
    return nullptr;
  }
  void SetAudibleState(bool aAudible) override {}
  void NotifyXPCOMShutdown() override {}
  AbstractThread* AbstractMainThread() const override
  {
    // Non-DocGroup version for Mock.
    return AbstractThread::MainThread();
  }
  nsIDocument* GetDocument() const { return nullptr; }
  void ConstructMediaTracks(const MediaInfo* aInfo) {}
  void RemoveMediaTracks() {}
  already_AddRefed<GMPCrashHelper> CreateGMPCrashHelper() { return nullptr; }
  void AsyncResolveSeekDOMPromiseIfExists() override {}
  void AsyncRejectSeekDOMPromiseIfExists() override {}
};
}

#endif
