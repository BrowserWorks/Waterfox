/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_NullHttpTransaction_h
#define mozilla_net_NullHttpTransaction_h

#include "nsAHttpTransaction.h"
#include "mozilla/Attributes.h"
#include "TimingStruct.h"

// This is the minimal nsAHttpTransaction implementation. A NullHttpTransaction
// can be used to drive connection level semantics (such as SSL handshakes
// tunnels) so that a nsHttpConnection becomes fully established in
// anticipation of a real transaction needing to use it soon.

class nsIHttpActivityObserver;

namespace mozilla { namespace net {

class nsAHttpConnection;
class nsHttpConnectionInfo;
class nsHttpRequestHead;

// 6c445340-3b82-4345-8efa-4902c3b8805a
#define NS_NULLHTTPTRANSACTION_IID \
{ 0x6c445340, 0x3b82, 0x4345, {0x8e, 0xfa, 0x49, 0x02, 0xc3, 0xb8, 0x80, 0x5a }}

class NullHttpTransaction : public nsAHttpTransaction
{
public:
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_NULLHTTPTRANSACTION_IID)
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSAHTTPTRANSACTION

  NullHttpTransaction(nsHttpConnectionInfo *ci,
                      nsIInterfaceRequestor *callbacks,
                      uint32_t caps);

  MOZ_MUST_USE bool Claim();
  void Unclaim();

  // Overload of nsAHttpTransaction methods
  bool IsNullTransaction() override final { return true; }
  NullHttpTransaction *QueryNullTransaction() override final { return this; }
  bool ResponseTimeoutEnabled() const override final {return true; }
  PRIntervalTime ResponseTimeout() override final
  {
    return PR_SecondsToInterval(15);
  }

  // We have to override this function because |mTransaction| in nsHalfOpenSocket
  // could be either nsHttpTransaction or NullHttpTransaction.
  // NullHttpTransaction will be activated on the connection immediately after
  // creation and be never put in a pending queue, so it's OK to just return 0.
  uint64_t TopLevelOuterContentWindowId() override { return 0; }

  TimingStruct Timings() { return mTimings; }

protected:
  virtual ~NullHttpTransaction();

private:
  nsresult mStatus;
protected:
  uint32_t mCaps;
  nsHttpRequestHead *mRequestHead;
private:
  // mCapsToClear holds flags that should be cleared in mCaps, e.g. unset
  // NS_HTTP_REFRESH_DNS when DNS refresh request has completed to avoid
  // redundant requests on the network. The member itself is atomic, but
  // access to it from the networking thread may happen either before or
  // after the main thread modifies it. To deal with raciness, only unsetting
  // bitfields should be allowed: 'lost races' will thus err on the
  // conservative side, e.g. by going ahead with a 2nd DNS refresh.
  Atomic<uint32_t> mCapsToClear;
  bool mIsDone;
  bool mClaimed;
  TimingStruct mTimings;

protected:
  RefPtr<nsAHttpConnection> mConnection;
  nsCOMPtr<nsIInterfaceRequestor> mCallbacks;
  RefPtr<nsHttpConnectionInfo> mConnectionInfo;
  nsCOMPtr<nsIHttpActivityObserver> mActivityDistributor;
};

NS_DEFINE_STATIC_IID_ACCESSOR(NullHttpTransaction, NS_NULLHTTPTRANSACTION_IID)

} // namespace net
} // namespace mozilla

#endif // mozilla_net_NullHttpTransaction_h
