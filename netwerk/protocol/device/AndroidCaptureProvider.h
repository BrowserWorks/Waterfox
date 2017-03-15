/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef AndroidDeviceCaptureProvide_h_
#define AndroidDeviceCaptureProvide_h_

#include "nsDeviceCaptureProvider.h"
#include "nsIAsyncInputStream.h"
#include "nsCOMPtr.h"
#include "nsAutoPtr.h"
#include "nsString.h"
#include "mozilla/net/CameraStreamImpl.h"
#include "nsIEventTarget.h"
#include "nsDeque.h"
#include "mozilla/ReentrantMonitor.h"

class AndroidCaptureProvider final : public nsDeviceCaptureProvider {
  private:
    ~AndroidCaptureProvider();

  public:
    AndroidCaptureProvider();

    NS_DECL_THREADSAFE_ISUPPORTS

    MOZ_MUST_USE nsresult Init(nsACString& aContentType, nsCaptureParams* aParams, nsIInputStream** aStream) override;
    static AndroidCaptureProvider* sInstance;
};

class AndroidCameraInputStream final : public nsIAsyncInputStream, mozilla::net::CameraStreamImpl::FrameCallback {
  private:
    ~AndroidCameraInputStream();

  public:
    AndroidCameraInputStream();

    NS_IMETHODIMP Init(nsACString& aContentType, nsCaptureParams* aParams);

    NS_DECL_THREADSAFE_ISUPPORTS
    NS_DECL_NSIINPUTSTREAM
    NS_DECL_NSIASYNCINPUTSTREAM

    void ReceiveFrame(char* frame, uint32_t length) override;

  protected:
    void NotifyListeners();
    void doClose();

    uint32_t mAvailable;
    nsCString mContentType;
    uint32_t mWidth;
    uint32_t mHeight;
    uint32_t mCamera;
    bool mHeaderSent;
    bool mClosed;
    nsDeque *mFrameQueue;
    uint32_t mFrameSize;
    mozilla::ReentrantMonitor mMonitor;

    nsCOMPtr<nsIInputStreamCallback> mCallback;
    nsCOMPtr<nsIEventTarget> mCallbackTarget;
};

already_AddRefed<AndroidCaptureProvider> GetAndroidCaptureProvider();

#endif
