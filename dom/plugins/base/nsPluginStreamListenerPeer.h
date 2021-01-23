/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsPluginStreamListenerPeer_h_
#define nsPluginStreamListenerPeer_h_

#include "nscore.h"
#include "nsIFile.h"
#include "nsIRequest.h"
#include "nsIStreamListener.h"
#include "nsIProgressEventSink.h"
#include "nsIHttpHeaderVisitor.h"
#include "nsWeakReference.h"
#include "nsNPAPIPluginStreamListener.h"
#include "nsDataHashtable.h"
#include "nsHashKeys.h"
#include "nsNPAPIPluginInstance.h"
#include "nsIInterfaceRequestor.h"
#include "nsIChannelEventSink.h"

class nsIChannel;

/**
 * When a plugin requests opens multiple requests to the same URL and
 * the request must be satified by saving a file to disk, each stream
 * listener holds a reference to the backing file: the file is only removed
 * when all the listeners are done.
 */
class CachedFileHolder {
 public:
  explicit CachedFileHolder(nsIFile* cacheFile);
  ~CachedFileHolder();

  void AddRef();
  void Release();

  nsIFile* file() const { return mFile; }

 private:
  nsAutoRefCnt mRefCnt;
  nsCOMPtr<nsIFile> mFile;
};

class nsPluginStreamListenerPeer : public nsIStreamListener,
                                   public nsIProgressEventSink,
                                   public nsIHttpHeaderVisitor,
                                   public nsSupportsWeakReference,
                                   public nsIInterfaceRequestor,
                                   public nsIChannelEventSink {
  virtual ~nsPluginStreamListenerPeer();

 public:
  nsPluginStreamListenerPeer();

  NS_DECL_ISUPPORTS
  NS_DECL_NSIPROGRESSEVENTSINK
  NS_DECL_NSIREQUESTOBSERVER
  NS_DECL_NSISTREAMLISTENER
  NS_DECL_NSIHTTPHEADERVISITOR
  NS_DECL_NSIINTERFACEREQUESTOR
  NS_DECL_NSICHANNELEVENTSINK

  // Called by GetURL and PostURL (via NewStream) or by the host in the case of
  // the initial plugin stream.
  nsresult Initialize(nsIURI* aURL, nsNPAPIPluginInstance* aInstance,
                      nsNPAPIPluginStreamListener* aListener);

  nsNPAPIPluginInstance* GetPluginInstance() { return mPluginInstance; }

  nsresult GetLength(uint32_t* result);
  nsresult GetURL(const char** result);
  nsresult GetLastModified(uint32_t* result);
  nsresult GetContentType(char** result);
  nsresult GetStreamOffset(int32_t* result);
  nsresult SetStreamOffset(int32_t value);

  void TrackRequest(nsIRequest* request) { mRequests.AppendObject(request); }

  void ReplaceRequest(nsIRequest* oldRequest, nsIRequest* newRequest) {
    int32_t i = mRequests.IndexOfObject(oldRequest);
    if (i == -1) {
      NS_ASSERTION(mRequests.Count() == 0,
                   "Only our initial stream should be unknown!");
      mRequests.AppendObject(oldRequest);
    } else {
      mRequests.ReplaceObjectAt(newRequest, i);
    }
  }

  void CancelRequests(nsresult status) {
    // Copy the array to avoid modification during the loop.
    nsCOMArray<nsIRequest> requestsCopy(mRequests);
    for (int32_t i = 0; i < requestsCopy.Count(); ++i)
      requestsCopy[i]->Cancel(status);
  }

  void SuspendRequests() {
    nsCOMArray<nsIRequest> requestsCopy(mRequests);
    for (int32_t i = 0; i < requestsCopy.Count(); ++i)
      requestsCopy[i]->Suspend();
  }

  void ResumeRequests() {
    nsCOMArray<nsIRequest> requestsCopy(mRequests);
    for (int32_t i = 0; i < requestsCopy.Count(); ++i)
      requestsCopy[i]->Resume();
  }

 private:
  nsresult SetUpStreamListener(nsIRequest* request, nsIURI* aURL);
  nsresult GetInterfaceGlobal(const nsIID& aIID, void** result);

  nsCOMPtr<nsIURI> mURL;
  nsCString
      mURLSpec;  // Have to keep this member because GetURL hands out char*
  RefPtr<nsNPAPIPluginStreamListener> mPStreamListener;

  // Set to true if we request failed (like with a HTTP response of 404)
  bool mRequestFailed;

  /*
   * Set to true after nsNPAPIPluginStreamListener::OnStartBinding() has
   * been called.  Checked in ::OnStopRequest so we can call the
   * plugin's OnStartBinding if, for some reason, it has not already
   * been called.
   */
  bool mStartBinding;
  bool mHaveFiredOnStartRequest;
  // these get passed to the plugin stream listener
  uint32_t mLength;
  int32_t mStreamType;

  nsCString mContentType;
  bool mUseLocalCache;
  nsCOMPtr<nsIRequest> mRequest;
  uint32_t mModified;
  RefPtr<nsNPAPIPluginInstance> mPluginInstance;
  int32_t mStreamOffset;
  bool mStreamComplete;

 public:
  int32_t mPendingRequests;
  nsWeakPtr mWeakPtrChannelCallbacks;
  nsWeakPtr mWeakPtrChannelLoadGroup;
  nsCOMArray<nsIRequest> mRequests;
};

#endif  // nsPluginStreamListenerPeer_h_
