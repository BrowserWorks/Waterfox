/* -*- Mode: C++; c-basic-offset: 2; indent-tabs-mode: nil; tab-width: 8 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_plugins_BrowserStreamChild_h
#define mozilla_plugins_BrowserStreamChild_h 1

#include "mozilla/plugins/PBrowserStreamChild.h"
#include "mozilla/plugins/AStream.h"
#include "base/task.h"
#include "base/timer.h"

namespace mozilla {
namespace plugins {

class PluginInstanceChild;
class StreamNotifyChild;

class BrowserStreamChild : public PBrowserStreamChild, public AStream
{
public:
  BrowserStreamChild(PluginInstanceChild* instance,
                     const nsCString& url,
                     const uint32_t& length,
                     const uint32_t& lastmodified,
                     StreamNotifyChild* notifyData,
                     const nsCString& headers);
  virtual ~BrowserStreamChild();

  virtual bool IsBrowserStream() override { return true; }

  NPError StreamConstructed(
            const nsCString& mimeType,
            const bool& seekable,
            uint16_t* stype);

  virtual mozilla::ipc::IPCResult RecvWrite(const int32_t& offset,
                                            const uint32_t& newsize,
                                            const Buffer& data) override;
  virtual mozilla::ipc::IPCResult RecvNPP_StreamAsFile(const nsCString& fname) override;
  virtual mozilla::ipc::IPCResult RecvNPP_DestroyStream(const NPReason& reason) override;
  virtual mozilla::ipc::IPCResult Recv__delete__() override;

  void EnsureCorrectInstance(PluginInstanceChild* i)
  {
    if (i != mInstance)
      MOZ_CRASH("Incorrect stream instance");
  }
  void EnsureCorrectStream(NPStream* s)
  {
    if (s != &mStream)
      MOZ_CRASH("Incorrect stream data");
  }

  NPError NPN_RequestRead(NPByteRange* aRangeList);

  void NotifyPending() {
    NS_ASSERTION(!mNotifyPending, "Pending twice?");
    mNotifyPending = true;
    EnsureDeliveryPending();
  }

  /**
   * During instance destruction, artificially cancel all outstanding streams.
   *
   * @return false if we are already in the DELETING state.
   */
  bool InstanceDying() {
    if (DELETING == mState)
      return false;

    mInstanceDying = true;
    return true;
  }

  void FinishDelivery() {
    NS_ASSERTION(mInstanceDying, "Should only be called after InstanceDying");
    NS_ASSERTION(DELETING != mState, "InstanceDying didn't work?");
    mStreamStatus = NPRES_USER_BREAK;
    Deliver();
    NS_ASSERTION(!mStreamNotify, "Didn't deliver NPN_URLNotify?");
  }

private:
  friend class StreamNotifyChild;

  /**
   * Post an event to ensure delivery of pending data/destroy/urlnotify events
   * outside of the current RPC stack.
   */
  void EnsureDeliveryPending();

  /**
   * Deliver data, destruction, notify scheduling
   * or cancelling the suspended timer as needed.
   */
  void Deliver();

  /**
   * Deliver one chunk of pending data.
   * @return true if the plugin indicated a pause was necessary
   */
  bool DeliverPendingData();

  void SetSuspendedTimer();
  void ClearSuspendedTimer();

  PluginInstanceChild* mInstance;
  NPStream mStream;

  static const NPReason kStreamOpen = -1;

  /**
   * The plugin's notion of whether a stream has been "closed" (no more
   * data delivery) differs from the plugin host due to asynchronous delivery
   * of data and stream destruction. While the plugin-visible stream is open,
   * mStreamStatus should be kStreamOpen (-1). mStreamStatus will be a
   * failure code if either the parent or child indicates stream failure.
   */
  NPReason mStreamStatus;

  /**
   * Delivery of NPP_DestroyStream and NPP_URLNotify must be postponed until
   * all data has been delivered.
   */
  enum {
    NOT_DESTROYED, // NPP_DestroyStream not yet received
    DESTROY_PENDING, // NPP_DestroyStream received, not yet delivered
    DESTROYED // NPP_DestroyStream delivered, NPP_URLNotify may still be pending
  } mDestroyPending;
  bool mNotifyPending;
  bool mStreamAsFilePending;
  nsCString mStreamAsFileName;

  // When NPP_Destroy is called for our instance (manager), this flag is set
  // cancels the stream and avoids sending StreamDestroyed.
  bool mInstanceDying;

  enum {
    CONSTRUCTING,
    ALIVE,
    DYING,
    DELETING
  } mState;
  nsCString mURL;
  nsCString mHeaders;
  StreamNotifyChild* mStreamNotify;

  struct PendingData
  {
    int32_t offset;
    Buffer data;
    int32_t curpos;
  };
  nsTArray<PendingData> mPendingData;

  /**
   * Asynchronous RecvWrite messages are never delivered to the plugin
   * immediately, because that may be in the midst of an unexpected RPC
   * stack frame. It instead posts a runnable using this tracker to cancel
   * in case we are destroyed.
   */
  ScopedRunnableMethodFactory<BrowserStreamChild> mDeliveryTracker;
  base::RepeatingTimer<BrowserStreamChild> mSuspendedTimer;
};

} // namespace plugins
} // namespace mozilla

#endif /* mozilla_plugins_BrowserStreamChild_h */
