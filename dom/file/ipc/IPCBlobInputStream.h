/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_ipc_IPCBlobInputStream_h
#define mozilla_dom_ipc_IPCBlobInputStream_h

#include "nsIAsyncInputStream.h"
#include "nsICloneableInputStream.h"
#include "nsIFileStreams.h"
#include "nsIIPCSerializableInputStream.h"
#include "nsISeekableStream.h"
#include "nsCOMPtr.h"

namespace mozilla {
namespace dom {

class IPCBlobInputStreamChild;

class IPCBlobInputStream final : public nsIAsyncInputStream
                               , public nsIInputStreamCallback
                               , public nsICloneableInputStream
                               , public nsIIPCSerializableInputStream
                               , public nsISeekableStream
                               , public nsIFileMetadata
{
public:
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIINPUTSTREAM
  NS_DECL_NSIASYNCINPUTSTREAM
  NS_DECL_NSIINPUTSTREAMCALLBACK
  NS_DECL_NSICLONEABLEINPUTSTREAM
  NS_DECL_NSIIPCSERIALIZABLEINPUTSTREAM
  NS_DECL_NSISEEKABLESTREAM
  NS_DECL_NSIFILEMETADATA

  explicit IPCBlobInputStream(IPCBlobInputStreamChild* aActor);

  void
  StreamReady(nsIInputStream* aInputStream);

private:
  ~IPCBlobInputStream();

  nsresult
  MaybeExecuteCallback(nsIInputStreamCallback* aCallback,
                       nsIEventTarget* aEventTarget);

  bool
  IsSeekableStream() const;

  bool
  IsFileMetadata() const;

  RefPtr<IPCBlobInputStreamChild> mActor;

  // This is the list of possible states.
  enum {
    // The initial state. Only ::Available() can be used without receiving an
    // error. The available size is known by the actor.
    eInit,

    // AsyncWait() has been called for the first time. SendStreamNeeded() has
    // been called and we are waiting for the 'real' inputStream.
    ePending,

    // When the child receives the stream from the parent, we move to this
    // state. The received stream is stored in mRemoteStream. From now on, any
    // method call will be forwared to mRemoteStream.
    eRunning,

    // If Close() or CloseWithStatus() is called, we move to this state.
    // mRemoveStream is released and any method will return
    // NS_BASE_STREAM_CLOSED.
    eClosed,
  } mState;

  nsCOMPtr<nsIInputStream> mRemoteStream;

  // These 2 values are set only if mState is ePending.
  nsCOMPtr<nsIInputStreamCallback> mCallback;
  nsCOMPtr<nsIEventTarget> mCallbackEventTarget;
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_ipc_IPCBlobInputStream_h
