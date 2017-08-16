/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_StunAddrsRequestParent_h
#define mozilla_net_StunAddrsRequestParent_h

#include "mozilla/net/PStunAddrsRequestParent.h"

namespace mozilla {
namespace net {

class StunAddrsRequestParent : public PStunAddrsRequestParent
{
public:
  StunAddrsRequestParent();

  NS_IMETHOD_(MozExternalRefCountType) AddRef();
  NS_IMETHOD_(MozExternalRefCountType) Release();

  mozilla::ipc::IPCResult Recv__delete__() override;

protected:
  virtual ~StunAddrsRequestParent() {}

  virtual mozilla::ipc::IPCResult RecvGetStunAddrs() override;
  virtual void ActorDestroy(ActorDestroyReason why) override;

  nsCOMPtr<nsIThread> mMainThread;
  nsCOMPtr<nsIEventTarget> mSTSThread;

  void GetStunAddrs_s();
  void SendStunAddrs_m(const NrIceStunAddrArray& addrs);

  ThreadSafeAutoRefCnt mRefCnt;
  NS_DECL_OWNINGTHREAD

private:
  bool mIPCClosed;  // true if IPDL channel has been closed (child crash)
};

} // namespace net
} // namespace mozilla

#endif // mozilla_net_StunAddrsRequestParent_h
