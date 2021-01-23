/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * Retrieves and displays icons in native menu items on Mac OS X.
 */

#ifndef nsIconLoaderService_h_
#define nsIconLoaderService_h_

#include "imgINotificationObserver.h"
#include "mozilla/RefPtr.h"
#include "nsCOMPtr.h"
#include "nsIconLoaderObserver.h"
#include "nsIContentPolicy.h"

class nsIURI;
class nsINode;
class nsIPrincipal;
class imgRequestProxy;

class nsIconLoaderService : public imgINotificationObserver {
 public:
  // If aScaleFactor is not specified, then an image with both regular and
  // HiDPI representations will be loaded.
  nsIconLoaderService(nsINode* aContent, nsIntRect* aImageRegionRect,
                      RefPtr<nsIconLoaderObserver> aObserver, uint32_t aIconHeight,
                      uint32_t aIconWidth, CGFloat aScaleFactor = 0.0f);

 public:
  NS_DECL_ISUPPORTS
  NS_DECL_IMGINOTIFICATIONOBSERVER

  // LoadIcon will start a load request for the icon.
  // The request may not complete until after LoadIcon returns.
  // If aIsInternalIcon is true, the document and principal will not be
  // used when loading.
  nsresult LoadIcon(nsIURI* aIconURI, bool aIsInternalIcon);

  NSImage* GetNativeIconImage();

  void ReleaseJSObjects() { mContent = nil; }

  void Destroy();

 protected:
  virtual ~nsIconLoaderService();

 private:
  nsresult OnFrameComplete(imgIRequest* aRequest);

  nsCOMPtr<nsINode> mContent;
  nsContentPolicyType mContentType;
  RefPtr<imgRequestProxy> mIconRequest;
  nsIntRect* mImageRegionRect;
  bool mLoadedIcon;
  NSImage* mNativeIconImage;
  uint32_t mIconHeight;
  uint32_t mIconWidth;
  CGFloat mScaleFactor;
  RefPtr<nsIconLoaderObserver> mCompletionHandler;
};
#endif  // nsIconLoaderService_h_
