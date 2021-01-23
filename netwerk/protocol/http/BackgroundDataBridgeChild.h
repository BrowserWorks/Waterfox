/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_BackgroundDataBridgeChild_h
#define mozilla_net_BackgroundDataBridgeChild_h

#include "mozilla/net/PBackgroundDataBridgeChild.h"
#include "mozilla/ipc/BackgroundChild.h"

namespace mozilla {
namespace net {

class HttpBackgroundChannelChild;

class BackgroundDataBridgeChild final : public PBackgroundDataBridgeChild {
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(BackgroundDataBridgeChild, override)

  explicit BackgroundDataBridgeChild(HttpBackgroundChannelChild* aBgChild);
  void Destroy();

 protected:
  virtual ~BackgroundDataBridgeChild();

  RefPtr<HttpBackgroundChannelChild> mBgChild;
  nsCOMPtr<nsIThread> mBackgroundThread;

 public:
  mozilla::ipc::IPCResult RecvOnTransportAndData(const uint64_t& offset,
                                                 const uint32_t& count,
                                                 const nsCString& data);
};

}  // namespace net
}  // namespace mozilla

#endif  // mozilla_net_BackgroundDataBridgeChild_h
