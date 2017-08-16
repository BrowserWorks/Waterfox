/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=8 et tw=80 : */

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_HttpBackgroundChannelParent_h
#define mozilla_net_HttpBackgroundChannelParent_h

#include "mozilla/net/PHttpBackgroundChannelParent.h"
#include "mozilla/Atomics.h"
#include "nsID.h"
#include "nsISupportsImpl.h"

class nsIEventTarget;

namespace mozilla {
namespace net {

class HttpChannelParent;

class HttpBackgroundChannelParent final : public PHttpBackgroundChannelParent
{
public:
  explicit HttpBackgroundChannelParent();

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(HttpBackgroundChannelParent)

  // Try to find associated HttpChannelParent with the same
  // channel Id.
  nsresult Init(const uint64_t& aChannelId);

  // Callbacks for BackgroundChannelRegistrar to notify
  // the associated HttpChannelParent is found.
  void LinkToChannel(HttpChannelParent* aChannelParent);

  // Callbacks for HttpChannelParent to close the background
  // IPC channel.
  void OnChannelClosed();

  // To send OnStartRequestSend message over background channel.
  bool OnStartRequestSent();

  // To send OnTransportAndData message over background channel.
  bool OnTransportAndData(const nsresult& aChannelStatus,
                          const nsresult& aTransportStatus,
                          const uint64_t& aOffset,
                          const uint32_t& aCount,
                          const nsCString& aData);

  // To send OnStopRequest message over background channel.
  bool OnStopRequest(const nsresult& aChannelStatus,
                     const ResourceTimingStruct& aTiming);

  // To send OnProgress message over background channel.
  bool OnProgress(const int64_t& aProgress,
                  const int64_t& aProgressMax);

  // To send OnStatus message over background channel.
  bool OnStatus(const nsresult& aStatus);

  // To send FlushedForDiversion and DivertMessages messages
  // over background channel.
  bool OnDiversion();

  // To send NotifyTrackingProtectionDisabled message over background channel.
  bool OnNotifyTrackingProtectionDisabled();

  // To send NotifyTrackingResource message over background channel.
  bool OnNotifyTrackingResource();

  // To send SetClassifierMatchedInfo message over background channel.
  bool OnSetClassifierMatchedInfo(const nsACString& aList,
                                  const nsACString& aProvider,
                                  const nsACString& aPrefix);

protected:
  void ActorDestroy(ActorDestroyReason aWhy) override;

private:
  virtual ~HttpBackgroundChannelParent();

  Atomic<bool> mIPCOpened;

  nsCOMPtr<nsIEventTarget> mBackgroundThread;

  // associated HttpChannelParent for generating the channel events
  RefPtr<HttpChannelParent> mChannelParent;
};

} // namespace net
} // namespace mozilla

#endif // mozilla_net_HttpBackgroundChannelParent_h
