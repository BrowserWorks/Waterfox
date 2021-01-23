/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsNPAPIPluginStreamListener_h_
#define nsNPAPIPluginStreamListener_h_

#include "nscore.h"
#include "nsIHTTPHeaderListener.h"
#include "nsINamed.h"
#include "nsITimer.h"
#include "nsCOMArray.h"
#include "nsIOutputStream.h"
#include "nsString.h"
#include "nsIAsyncVerifyRedirectCallback.h"
#include "mozilla/PluginLibrary.h"

#define MAX_PLUGIN_NECKO_BUFFER 16384

class nsPluginStreamListenerPeer;
class nsNPAPIPluginStreamListener;
class nsNPAPIPluginInstance;
class nsIChannel;

class nsNPAPIStreamWrapper {
 public:
  nsNPAPIStreamWrapper(nsIOutputStream* outputStream,
                       nsNPAPIPluginStreamListener* streamListener);
  ~nsNPAPIStreamWrapper();

  nsIOutputStream* GetOutputStream() { return mOutputStream.get(); }
  nsNPAPIPluginStreamListener* GetStreamListener() { return mStreamListener; }

  NPStream mNPStream;

 protected:
  nsCOMPtr<nsIOutputStream>
      mOutputStream;  // only valid if not browser initiated
  nsNPAPIPluginStreamListener*
      mStreamListener;  // only valid if browser initiated
};

class nsNPAPIPluginStreamListener : public nsITimerCallback,
                                    public nsIHTTPHeaderListener,
                                    public nsINamed {
 private:
  typedef mozilla::PluginLibrary PluginLibrary;

 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSITIMERCALLBACK
  NS_DECL_NSIHTTPHEADERLISTENER
  NS_DECL_NSINAMED

  nsNPAPIPluginStreamListener(nsNPAPIPluginInstance* inst, void* notifyData,
                              const char* aURL);

  nsresult OnStartBinding(nsPluginStreamListenerPeer* streamPeer);
  nsresult OnDataAvailable(nsPluginStreamListenerPeer* streamPeer,
                           nsIInputStream* input, uint32_t length);
  nsresult OnFileAvailable(nsPluginStreamListenerPeer* streamPeer,
                           const char* fileName);
  nsresult OnStopBinding(nsPluginStreamListenerPeer* streamPeer,
                         nsresult status);

  bool IsStarted();
  nsresult CleanUpStream(NPReason reason);
  void CallURLNotify(NPReason reason);
  void SetCallNotify(bool aCallNotify) { mCallNotify = aCallNotify; }
  void SuspendRequest();
  void ResumeRequest();
  nsresult StartDataPump();
  void StopDataPump();
  bool PluginInitJSLoadInProgress();

  void* GetNotifyData();
  nsPluginStreamListenerPeer* GetStreamListenerPeer() {
    return mStreamListenerPeer;
  }
  void SetStreamListenerPeer(nsPluginStreamListenerPeer* aPeer) {
    mStreamListenerPeer = aPeer;
  }

  // Returns true if the redirect will be handled by NPAPI, false otherwise.
  bool HandleRedirectNotification(nsIChannel* oldChannel,
                                  nsIChannel* newChannel,
                                  nsIAsyncVerifyRedirectCallback* callback);
  void URLRedirectResponse(NPBool allow);

 protected:
  enum StreamState {
    eStreamStopped = 0,  // The stream is stopped
    eNewStreamCalled,    // NPP_NewStream was called but has not completed yet
    eStreamTypeSet       // The stream is fully initialized
  };

  enum StreamStopMode { eNormalStop = 0, eDoDeferredStop, eStopPending };

  virtual ~nsNPAPIPluginStreamListener();
  bool MaybeRunStopBinding();

  char* mStreamBuffer;
  char* mNotifyURL;
  RefPtr<nsNPAPIPluginInstance> mInst;
  nsNPAPIStreamWrapper* mNPStreamWrapper;
  uint32_t mStreamBufferSize;
  int32_t mStreamBufferByteCount;
  StreamState mStreamState;
  bool mStreamCleanedUp;
  bool mCallNotify;
  bool mIsSuspended;
  bool mIsPluginInitJSStream;
  bool mRedirectDenied;
  nsCString mResponseHeaders;
  char* mResponseHeaderBuf;
  nsCOMPtr<nsITimer> mDataPumpTimer;
  nsCOMPtr<nsIAsyncVerifyRedirectCallback> mHTTPRedirectCallback;
  StreamStopMode mStreamStopMode;
  nsresult mPendingStopBindingStatus;

 public:
  RefPtr<nsPluginStreamListenerPeer> mStreamListenerPeer;
};

#endif  // nsNPAPIPluginStreamListener_h_
