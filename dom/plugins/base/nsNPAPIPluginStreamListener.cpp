/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsNPAPIPluginStreamListener.h"
#include "plstr.h"
#include "nsDirectoryServiceDefs.h"
#include "nsDirectoryServiceUtils.h"
#include "nsNetUtil.h"
#include "nsPluginHost.h"
#include "nsNPAPIPlugin.h"
#include "nsPluginLogging.h"
#include "nsPluginStreamListenerPeer.h"

#include <stdint.h>
#include <algorithm>

nsNPAPIStreamWrapper::nsNPAPIStreamWrapper(
    nsIOutputStream* outputStream,
    nsNPAPIPluginStreamListener* streamListener) {
  mOutputStream = outputStream;
  mStreamListener = streamListener;

  memset(&mNPStream, 0, sizeof(mNPStream));
  mNPStream.ndata = static_cast<void*>(this);
}

nsNPAPIStreamWrapper::~nsNPAPIStreamWrapper() {
  if (mOutputStream) {
    mOutputStream->Close();
  }
}

// nsNPAPIPluginStreamListener Methods
NS_IMPL_ISUPPORTS(nsNPAPIPluginStreamListener, nsITimerCallback,
                  nsIHTTPHeaderListener, nsINamed)

nsNPAPIPluginStreamListener::nsNPAPIPluginStreamListener(
    nsNPAPIPluginInstance* inst, void* notifyData, const char* aURL)
    : mStreamBuffer(nullptr),
      mNotifyURL(aURL ? PL_strdup(aURL) : nullptr),
      mInst(inst),
      mStreamBufferSize(0),
      mStreamBufferByteCount(0),
      mStreamState(eStreamStopped),
      mStreamCleanedUp(false),
      mCallNotify(notifyData ? true : false),
      mIsSuspended(false),
      mIsPluginInitJSStream(
          mInst->mInPluginInitCall && aURL &&
          strncmp(aURL, "javascript:", sizeof("javascript:") - 1) == 0),
      mRedirectDenied(false),
      mResponseHeaderBuf(nullptr),
      mStreamStopMode(eNormalStop),
      mPendingStopBindingStatus(NS_OK) {
  mNPStreamWrapper = new nsNPAPIStreamWrapper(nullptr, this);
  mNPStreamWrapper->mNPStream.notifyData = notifyData;
}

nsNPAPIPluginStreamListener::~nsNPAPIPluginStreamListener() {
  // remove this from the plugin instance's stream list
  nsTArray<nsNPAPIPluginStreamListener*>* streamListeners =
      mInst->StreamListeners();
  streamListeners->RemoveElement(this);

  // For those cases when NewStream is never called, we still may need
  // to fire a notification callback. Return network error as fallback
  // reason because for other cases, notify should have already been
  // called for other reasons elsewhere.
  CallURLNotify(NPRES_NETWORK_ERR);

  // lets get rid of the buffer
  if (mStreamBuffer) {
    free(mStreamBuffer);
    mStreamBuffer = nullptr;
  }

  if (mNotifyURL) PL_strfree(mNotifyURL);

  if (mResponseHeaderBuf) PL_strfree(mResponseHeaderBuf);

  if (mNPStreamWrapper) {
    delete mNPStreamWrapper;
  }
}

nsresult nsNPAPIPluginStreamListener::CleanUpStream(NPReason reason) {
  nsresult rv = NS_ERROR_FAILURE;

  // Various bits of code in the rest of this method may result in the
  // deletion of this object. Use a KungFuDeathGrip to keep ourselves
  // alive during cleanup.
  RefPtr<nsNPAPIPluginStreamListener> kungFuDeathGrip(this);

  if (mStreamCleanedUp) return NS_OK;

  mStreamCleanedUp = true;

  StopDataPump();

  // Release any outstanding redirect callback.
  if (mHTTPRedirectCallback) {
    mHTTPRedirectCallback->OnRedirectVerifyCallback(NS_ERROR_FAILURE);
    mHTTPRedirectCallback = nullptr;
  }

  if (mStreamListenerPeer) {
    mStreamListenerPeer->CancelRequests(NS_BINDING_ABORTED);
    mStreamListenerPeer = nullptr;
  }

  if (!mInst || !mInst->CanFireNotifications()) return rv;

  PluginDestructionGuard guard(mInst);

  nsNPAPIPlugin* plugin = mInst->GetPlugin();
  if (!plugin || !plugin->GetLibrary()) return rv;

  NPPluginFuncs* pluginFunctions = plugin->PluginFuncs();

  NPP npp;
  mInst->GetNPP(&npp);

  if (mStreamState >= eNewStreamCalled && pluginFunctions->destroystream) {
    NPPAutoPusher nppPusher(npp);

    NPError error;
    NS_TRY_SAFE_CALL_RETURN(error,
                            (*pluginFunctions->destroystream)(
                                npp, &mNPStreamWrapper->mNPStream, reason),
                            mInst, NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);

    NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
                   ("NPP DestroyStream called: this=%p, npp=%p, reason=%d, "
                    "return=%d, url=%s\n",
                    this, npp, reason, error, mNPStreamWrapper->mNPStream.url));

    if (error == NPERR_NO_ERROR) rv = NS_OK;
  }

  mStreamState = eStreamStopped;

  // fire notification back to plugin, just like before
  CallURLNotify(reason);

  return rv;
}

void nsNPAPIPluginStreamListener::CallURLNotify(NPReason reason) {
  if (!mCallNotify || !mInst || !mInst->CanFireNotifications()) return;

  PluginDestructionGuard guard(mInst);

  mCallNotify = false;  // only do this ONCE and prevent recursion

  nsNPAPIPlugin* plugin = mInst->GetPlugin();
  if (!plugin || !plugin->GetLibrary()) return;

  NPPluginFuncs* pluginFunctions = plugin->PluginFuncs();

  if (pluginFunctions->urlnotify) {
    NPP npp;
    mInst->GetNPP(&npp);

    NS_TRY_SAFE_CALL_VOID(
        (*pluginFunctions->urlnotify)(npp, mNotifyURL, reason,
                                      mNPStreamWrapper->mNPStream.notifyData),
        mInst, NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);

    NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
                   ("NPP URLNotify called: this=%p, npp=%p, notify=%p, "
                    "reason=%d, url=%s\n",
                    this, npp, mNPStreamWrapper->mNPStream.notifyData, reason,
                    mNotifyURL));
  }
}

nsresult nsNPAPIPluginStreamListener::OnStartBinding(
    nsPluginStreamListenerPeer* streamPeer) {
  AUTO_PROFILER_LABEL("nsNPAPIPluginStreamListener::OnStartBinding", OTHER);
  if (!mInst || !mInst->CanFireNotifications() || mStreamCleanedUp)
    return NS_ERROR_FAILURE;

  PluginDestructionGuard guard(mInst);

  nsNPAPIPlugin* plugin = mInst->GetPlugin();
  if (!plugin || !plugin->GetLibrary()) return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = plugin->PluginFuncs();

  if (!pluginFunctions->newstream) return NS_ERROR_FAILURE;

  NPP npp;
  mInst->GetNPP(&npp);

  char* contentType;
  uint16_t streamType = NP_NORMAL;
  NPError error;

  streamPeer->GetURL(&mNPStreamWrapper->mNPStream.url);
  streamPeer->GetLength((uint32_t*)&(mNPStreamWrapper->mNPStream.end));
  streamPeer->GetLastModified(
      (uint32_t*)&(mNPStreamWrapper->mNPStream.lastmodified));
  streamPeer->GetContentType(&contentType);

  if (!mResponseHeaders.IsEmpty()) {
    mResponseHeaderBuf = PL_strdup(mResponseHeaders.get());
    mNPStreamWrapper->mNPStream.headers = mResponseHeaderBuf;
  }

  mStreamListenerPeer = streamPeer;

  NPPAutoPusher nppPusher(npp);

  NS_TRY_SAFE_CALL_RETURN(error,
                          (*pluginFunctions->newstream)(
                              npp, (char*)contentType,
                              &mNPStreamWrapper->mNPStream, false, &streamType),
                          mInst, NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);

  NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
                 ("NPP NewStream called: this=%p, npp=%p, mime=%s, seek=%d, "
                  "type=%d, return=%d, url=%s\n",
                  this, npp, (char*)contentType, false, streamType, error,
                  mNPStreamWrapper->mNPStream.url));

  if (error != NPERR_NO_ERROR) return NS_ERROR_FAILURE;

  mStreamState = eNewStreamCalled;

  if (streamType != NP_NORMAL) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

void nsNPAPIPluginStreamListener::SuspendRequest() {
  NS_ASSERTION(!mIsSuspended, "Suspending a request that's already suspended!");

  nsresult rv = StartDataPump();
  if (NS_FAILED(rv)) return;

  mIsSuspended = true;

  if (mStreamListenerPeer) {
    mStreamListenerPeer->SuspendRequests();
  }
}

void nsNPAPIPluginStreamListener::ResumeRequest() {
  if (mStreamListenerPeer) {
    mStreamListenerPeer->ResumeRequests();
  }
  mIsSuspended = false;
}

nsresult nsNPAPIPluginStreamListener::StartDataPump() {
  // Start pumping data to the plugin every 100ms until it obeys and
  // eats the data.
  return NS_NewTimerWithCallback(getter_AddRefs(mDataPumpTimer), this, 100,
                                 nsITimer::TYPE_REPEATING_SLACK);
}

void nsNPAPIPluginStreamListener::StopDataPump() {
  if (mDataPumpTimer) {
    mDataPumpTimer->Cancel();
    mDataPumpTimer = nullptr;
  }
}

// Return true if a javascript: load that was started while the plugin
// was being initialized is still in progress.
bool nsNPAPIPluginStreamListener::PluginInitJSLoadInProgress() {
  if (!mInst) return false;

  nsTArray<nsNPAPIPluginStreamListener*>* streamListeners =
      mInst->StreamListeners();
  for (unsigned int i = 0; i < streamListeners->Length(); i++) {
    if (streamListeners->ElementAt(i)->mIsPluginInitJSStream) {
      return true;
    }
  }

  return false;
}

// This method is called when there's more data available off the
// network, but it's also called from our data pump when we're feeding
// the plugin data that we already got off the network, but the plugin
// was unable to consume it at the point it arrived. In the case when
// the plugin pump calls this method, the input argument will be null,
// and the length will be the number of bytes available in our
// internal buffer.
nsresult nsNPAPIPluginStreamListener::OnDataAvailable(
    nsPluginStreamListenerPeer* streamPeer, nsIInputStream* input,
    uint32_t length) {
  if (!length || !mInst || !mInst->CanFireNotifications())
    return NS_ERROR_FAILURE;

  PluginDestructionGuard guard(mInst);

  // Just in case the caller switches plugin info on us.
  mStreamListenerPeer = streamPeer;

  nsNPAPIPlugin* plugin = mInst->GetPlugin();
  if (!plugin || !plugin->GetLibrary()) return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = plugin->PluginFuncs();

  // check out if plugin implements NPP_Write call
  if (!pluginFunctions->write)
    return NS_ERROR_FAILURE;  // it'll cancel necko transaction

  if (!mStreamBuffer) {
    // To optimize the mem usage & performance we have to allocate
    // mStreamBuffer here in first ODA when length of data available
    // in input stream is known.  mStreamBuffer will be freed in DTOR.
    // we also have to remember the size of that buff to make safe
    // consecutive Read() calls form input stream into our buff.

    uint32_t contentLength;
    streamPeer->GetLength(&contentLength);

    mStreamBufferSize = std::max(length, contentLength);

    // Limit the size of the initial buffer to MAX_PLUGIN_NECKO_BUFFER
    // (16k). This buffer will grow if needed, as in the case where
    // we're getting data faster than the plugin can process it.
    mStreamBufferSize =
        std::min(mStreamBufferSize, uint32_t(MAX_PLUGIN_NECKO_BUFFER));

    mStreamBuffer = (char*)malloc(mStreamBufferSize);
    if (!mStreamBuffer) return NS_ERROR_OUT_OF_MEMORY;
  }

  // prepare NPP_ calls params
  NPP npp;
  mInst->GetNPP(&npp);

  int32_t streamPosition;
  streamPeer->GetStreamOffset(&streamPosition);
  int32_t streamOffset = streamPosition;

  if (input) {
    streamOffset += length;

    // Set new stream offset for the next ODA call regardless of how
    // following NPP_Write call will behave we pretend to consume all
    // data from the input stream.  It's possible that current steam
    // position will be overwritten from NPP_RangeRequest call made
    // from NPP_Write, so we cannot call SetStreamOffset after
    // NPP_Write.
    //
    // Note: there is a special case when data flow should be
    // temporarily stopped if NPP_WriteReady returns 0 (bug #89270)
    streamPeer->SetStreamOffset(streamOffset);

    // set new end in case the content is compressed
    // initial end is less than end of decompressed stream
    // and some plugins (e.g. acrobat) can fail.
    if ((int32_t)mNPStreamWrapper->mNPStream.end < streamOffset)
      mNPStreamWrapper->mNPStream.end = streamOffset;
  }

  nsresult rv = NS_OK;
  while (NS_SUCCEEDED(rv) && length > 0) {
    if (input && length) {
      if (mStreamBufferSize < mStreamBufferByteCount + length) {
        // We're in the ::OnDataAvailable() call that we might get
        // after suspending a request, or we suspended the request
        // from within this ::OnDataAvailable() call while there's
        // still data in the input, or we have resumed a previously
        // suspended request and our buffer is already full, and we
        // don't have enough space to store what we got off the network.
        // Reallocate our internal buffer.
        mStreamBufferSize = mStreamBufferByteCount + length;
        char* buf = (char*)realloc(mStreamBuffer, mStreamBufferSize);
        if (!buf) return NS_ERROR_OUT_OF_MEMORY;

        mStreamBuffer = buf;
      }

      uint32_t bytesToRead =
          std::min(length, mStreamBufferSize - mStreamBufferByteCount);
      MOZ_ASSERT(bytesToRead > 0);

      uint32_t amountRead = 0;
      rv = input->Read(mStreamBuffer + mStreamBufferByteCount, bytesToRead,
                       &amountRead);
      NS_ENSURE_SUCCESS(rv, rv);

      if (amountRead == 0) {
        MOZ_ASSERT_UNREACHABLE(
            "input->Read() returns no data, it's almost "
            "impossible to get here");

        break;
      }

      mStreamBufferByteCount += amountRead;
      length -= amountRead;
    } else {
      // No input, nothing to read. Set length to 0 so that we don't
      // keep iterating through this outer loop any more.

      length = 0;
    }

    // Temporary pointer to the beginning of the data we're writing as
    // we loop and feed the plugin data.
    char* ptrStreamBuffer = mStreamBuffer;

    // it is possible plugin's NPP_Write() returns 0 byte consumed. We
    // use zeroBytesWriteCount to count situation like this and break
    // the loop
    int32_t zeroBytesWriteCount = 0;

    // mStreamBufferByteCount tells us how many bytes there are in the
    // buffer. WriteReady returns to us how many bytes the plugin is
    // ready to handle.
    while (mStreamBufferByteCount > 0) {
      int32_t numtowrite;
      if (pluginFunctions->writeready) {
        NPPAutoPusher nppPusher(npp);

        NS_TRY_SAFE_CALL_RETURN(
            numtowrite,
            (*pluginFunctions->writeready)(npp, &mNPStreamWrapper->mNPStream),
            mInst, NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);
        NPP_PLUGIN_LOG(
            PLUGIN_LOG_NOISY,
            ("NPP WriteReady called: this=%p, npp=%p, "
             "return(towrite)=%d, url=%s\n",
             this, npp, numtowrite, mNPStreamWrapper->mNPStream.url));

        if (mStreamState == eStreamStopped) {
          // The plugin called NPN_DestroyStream() from within
          // NPP_WriteReady(), kill the stream.

          return NS_BINDING_ABORTED;
        }

        // if WriteReady returned 0, the plugin is not ready to handle
        // the data, suspend the stream (if it isn't already
        // suspended).
        //
        // Also suspend the stream if the stream we're loading is not
        // a javascript: URL load that was initiated during plugin
        // initialization and there currently is such a stream
        // loading. This is done to work around a Windows Media Player
        // plugin bug where it can't deal with being fed data for
        // other streams while it's waiting for data from the
        // javascript: URL loads it requests during
        // initialization. See bug 386493 for more details.

        if (numtowrite <= 0 ||
            (!mIsPluginInitJSStream && PluginInitJSLoadInProgress())) {
          if (!mIsSuspended) {
            SuspendRequest();
          }

          // Break out of the inner loop, but keep going through the
          // outer loop in case there's more data to read from the
          // input stream.

          break;
        }

        numtowrite = std::min(numtowrite, mStreamBufferByteCount);
      } else {
        // if WriteReady is not supported by the plugin, just write
        // the whole buffer
        numtowrite = mStreamBufferByteCount;
      }

      NPPAutoPusher nppPusher(npp);

      int32_t writeCount = 0;  // bytes consumed by plugin instance
      NS_TRY_SAFE_CALL_RETURN(writeCount,
                              (*pluginFunctions->write)(
                                  npp, &mNPStreamWrapper->mNPStream,
                                  streamPosition, numtowrite, ptrStreamBuffer),
                              mInst, NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);

      NPP_PLUGIN_LOG(
          PLUGIN_LOG_NOISY,
          ("NPP Write called: this=%p, npp=%p, pos=%d, len=%d, "
           "buf=%.*s, return(written)=%d,  url=%s\n",
           this, npp, streamPosition, numtowrite, numtowrite, ptrStreamBuffer,
           writeCount, mNPStreamWrapper->mNPStream.url));

      if (mStreamState == eStreamStopped) {
        // The plugin called NPN_DestroyStream() from within
        // NPP_Write(), kill the stream.
        return NS_BINDING_ABORTED;
      }

      if (writeCount > 0) {
        NS_ASSERTION(writeCount <= mStreamBufferByteCount,
                     "Plugin read past the end of the available data!");

        writeCount = std::min(writeCount, mStreamBufferByteCount);
        mStreamBufferByteCount -= writeCount;

        streamPosition += writeCount;

        zeroBytesWriteCount = 0;

        if (mStreamBufferByteCount > 0) {
          // This alignment code is most likely bogus, but we'll leave
          // it in for now in case it matters for some plugins on some
          // architectures. Who knows...
          if (writeCount % sizeof(intptr_t)) {
            // memmove will take care  about alignment
            memmove(mStreamBuffer, ptrStreamBuffer + writeCount,
                    mStreamBufferByteCount);
            ptrStreamBuffer = mStreamBuffer;
          } else {
            // if aligned we can use ptrStreamBuffer += to eliminate
            // memmove()
            ptrStreamBuffer += writeCount;
          }
        }
      } else if (writeCount == 0) {
        // if NPP_Write() returns writeCount == 0 lets say 3 times in
        // a row, suspend the request and continue feeding the plugin
        // the data we got so far. Once that data is consumed, we'll
        // resume the request.
        if (mIsSuspended || ++zeroBytesWriteCount == 3) {
          if (!mIsSuspended) {
            SuspendRequest();
          }

          // Break out of the for loop, but keep going through the
          // while loop in case there's more data to read from the
          // input stream.

          break;
        }
      } else {
        // Something's really wrong, kill the stream.
        rv = NS_ERROR_FAILURE;

        break;
      }
    }  // end of inner while loop

    if (mStreamBufferByteCount && mStreamBuffer != ptrStreamBuffer) {
      memmove(mStreamBuffer, ptrStreamBuffer, mStreamBufferByteCount);
    }
  }

  if (streamPosition != streamOffset) {
    // The plugin didn't consume all available data, or consumed some
    // of our cached data while we're pumping cached data. Adjust the
    // plugin info's stream offset to match reality, except if the
    // plugin info's stream offset was set by a re-entering
    // NPN_RequestRead() call.

    int32_t postWriteStreamPosition;
    streamPeer->GetStreamOffset(&postWriteStreamPosition);

    if (postWriteStreamPosition == streamOffset) {
      streamPeer->SetStreamOffset(streamPosition);
    }
  }

  return rv;
}

nsresult nsNPAPIPluginStreamListener::OnFileAvailable(
    nsPluginStreamListenerPeer* streamPeer, const char* fileName) {
  if (!mInst || !mInst->CanFireNotifications()) return NS_ERROR_FAILURE;

  PluginDestructionGuard guard(mInst);

  nsNPAPIPlugin* plugin = mInst->GetPlugin();
  if (!plugin || !plugin->GetLibrary()) return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = plugin->PluginFuncs();

  if (!pluginFunctions->asfile) return NS_ERROR_FAILURE;

  NPP npp;
  mInst->GetNPP(&npp);

  NS_TRY_SAFE_CALL_VOID(
      (*pluginFunctions->asfile)(npp, &mNPStreamWrapper->mNPStream, fileName),
      mInst, NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);

  NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
                 ("NPP StreamAsFile called: this=%p, npp=%p, url=%s, file=%s\n",
                  this, npp, mNPStreamWrapper->mNPStream.url, fileName));

  return NS_OK;
}

nsresult nsNPAPIPluginStreamListener::OnStopBinding(
    nsPluginStreamListenerPeer* streamPeer, nsresult status) {
  if (NS_FAILED(status)) {
    // The stream was destroyed, or died for some reason. Make sure we
    // cancel the underlying request.
    if (mStreamListenerPeer) {
      mStreamListenerPeer->CancelRequests(status);
    }
  }

  if (!mInst || !mInst->CanFireNotifications()) {
    StopDataPump();
    return NS_ERROR_FAILURE;
  }

  // We need to detect that the stop is due to async stream init completion.
  if (mStreamStopMode == eDoDeferredStop) {
    // We shouldn't be delivering this until async init is done
    mStreamStopMode = eStopPending;
    mPendingStopBindingStatus = status;
    if (!mDataPumpTimer) {
      StartDataPump();
    }
    return NS_OK;
  }

  StopDataPump();

  NPReason reason = NS_FAILED(status) ? NPRES_NETWORK_ERR : NPRES_DONE;
  if (mRedirectDenied || status == NS_BINDING_ABORTED) {
    reason = NPRES_USER_BREAK;
  }

  // The following code can result in the deletion of 'this'. Don't
  // assume we are alive after this!
  return CleanUpStream(reason);
}

bool nsNPAPIPluginStreamListener::MaybeRunStopBinding() {
  if (mIsSuspended || mStreamStopMode != eStopPending) {
    return false;
  }
  OnStopBinding(mStreamListenerPeer, mPendingStopBindingStatus);
  mStreamStopMode = eNormalStop;
  return true;
}

NS_IMETHODIMP
nsNPAPIPluginStreamListener::Notify(nsITimer* aTimer) {
  NS_ASSERTION(aTimer == mDataPumpTimer, "Uh, wrong timer?");

  int32_t oldStreamBufferByteCount = mStreamBufferByteCount;

  nsresult rv =
      OnDataAvailable(mStreamListenerPeer, nullptr, mStreamBufferByteCount);

  if (NS_FAILED(rv)) {
    // We ran into an error, no need to keep firing this timer then.
    StopDataPump();
    MaybeRunStopBinding();
    return NS_OK;
  }

  if (mStreamBufferByteCount != oldStreamBufferByteCount &&
      ((mStreamState == eStreamTypeSet && mStreamBufferByteCount < 1024) ||
       mStreamBufferByteCount == 0)) {
    // The plugin read some data and we've got less than 1024 bytes in
    // our buffer (or its empty and the stream is already
    // done). Resume the request so that we get more data off the
    // network.
    ResumeRequest();
    // Necko will pump data now that we've resumed the request.
    StopDataPump();
  }

  MaybeRunStopBinding();
  return NS_OK;
}

NS_IMETHODIMP
nsNPAPIPluginStreamListener::GetName(nsACString& aName) {
  aName.AssignLiteral("nsNPAPIPluginStreamListener");
  return NS_OK;
}

NS_IMETHODIMP
nsNPAPIPluginStreamListener::StatusLine(const char* line) {
  mResponseHeaders.Append(line);
  mResponseHeaders.Append('\n');
  return NS_OK;
}

NS_IMETHODIMP
nsNPAPIPluginStreamListener::NewResponseHeader(const char* headerName,
                                               const char* headerValue) {
  mResponseHeaders.Append(headerName);
  mResponseHeaders.AppendLiteral(": ");
  mResponseHeaders.Append(headerValue);
  mResponseHeaders.Append('\n');
  return NS_OK;
}

bool nsNPAPIPluginStreamListener::HandleRedirectNotification(
    nsIChannel* oldChannel, nsIChannel* newChannel,
    nsIAsyncVerifyRedirectCallback* callback) {
  nsCOMPtr<nsIHttpChannel> oldHttpChannel = do_QueryInterface(oldChannel);
  nsCOMPtr<nsIHttpChannel> newHttpChannel = do_QueryInterface(newChannel);
  if (!oldHttpChannel || !newHttpChannel) {
    return false;
  }

  if (!mInst || !mInst->CanFireNotifications()) {
    return false;
  }

  nsNPAPIPlugin* plugin = mInst->GetPlugin();
  if (!plugin || !plugin->GetLibrary()) {
    return false;
  }

  NPPluginFuncs* pluginFunctions = plugin->PluginFuncs();
  if (!pluginFunctions->urlredirectnotify) {
    return false;
  }

  // A non-null closure is required for redirect handling support.
  if (mNPStreamWrapper->mNPStream.notifyData) {
    uint32_t status;
    if (NS_SUCCEEDED(oldHttpChannel->GetResponseStatus(&status))) {
      nsCOMPtr<nsIURI> uri;
      if (NS_SUCCEEDED(newHttpChannel->GetURI(getter_AddRefs(uri))) && uri) {
        nsAutoCString spec;
        if (NS_SUCCEEDED(uri->GetAsciiSpec(spec))) {
          // At this point the plugin will be responsible for making the
          // callback so save the callback object.
          mHTTPRedirectCallback = callback;

          NPP npp;
          mInst->GetNPP(&npp);
#if defined(XP_WIN)
          NS_TRY_SAFE_CALL_VOID(
              (*pluginFunctions->urlredirectnotify)(
                  npp, spec.get(), static_cast<int32_t>(status),
                  mNPStreamWrapper->mNPStream.notifyData),
              mInst, NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);
#else
          (*pluginFunctions->urlredirectnotify)(
              npp, spec.get(), static_cast<int32_t>(status),
              mNPStreamWrapper->mNPStream.notifyData);
#endif
          return true;
        }
      }
    }
  }

  callback->OnRedirectVerifyCallback(NS_ERROR_FAILURE);
  return true;
}

void nsNPAPIPluginStreamListener::URLRedirectResponse(NPBool allow) {
  if (mHTTPRedirectCallback) {
    mHTTPRedirectCallback->OnRedirectVerifyCallback(allow ? NS_OK
                                                          : NS_ERROR_FAILURE);
    mRedirectDenied = !allow;
    mHTTPRedirectCallback = nullptr;
  }
}

void* nsNPAPIPluginStreamListener::GetNotifyData() {
  if (mNPStreamWrapper) {
    return mNPStreamWrapper->mNPStream.notifyData;
  }
  return nullptr;
}
