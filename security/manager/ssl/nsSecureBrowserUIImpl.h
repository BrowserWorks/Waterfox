/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsSecureBrowserUIImpl_h
#define nsSecureBrowserUIImpl_h

#include "PLDHashTable.h"
#include "mozilla/ReentrancyGuard.h"
#include "nsCOMPtr.h"
#include "nsINetUtil.h"
#include "nsISSLStatusProvider.h"
#include "nsISecureBrowserUI.h"
#include "nsISecurityEventSink.h"
#include "nsIURI.h"
#include "nsIWebProgressListener.h"
#include "nsWeakReference.h"

class nsISSLStatus;
class nsIChannel;

#define NS_SECURE_BROWSER_UI_CID \
{ 0xcc75499a, 0x1dd1, 0x11b2, {0x8a, 0x82, 0xca, 0x41, 0x0a, 0xc9, 0x07, 0xb8}}


class nsSecureBrowserUIImpl : public nsISecureBrowserUI,
                              public nsIWebProgressListener,
                              public nsSupportsWeakReference,
                              public nsISSLStatusProvider
{
  friend class mozilla::ReentrancyGuard;

public:
  nsSecureBrowserUIImpl();

  NS_DECL_ISUPPORTS
  NS_DECL_NSIWEBPROGRESSLISTENER
  NS_DECL_NSISECUREBROWSERUI
  NS_DECL_NSISSLSTATUSPROVIDER

protected:
  virtual ~nsSecureBrowserUIImpl() {};

  nsWeakPtr mWindow;
  nsWeakPtr mDocShell;
  nsCOMPtr<nsINetUtil> mIOService;
  nsCOMPtr<nsIURI> mCurrentURI;
  nsCOMPtr<nsISecurityEventSink> mToplevelEventSink;

  enum lockIconState {
    lis_no_security,
    lis_broken_security,
    lis_mixed_security,
    lis_high_security
  };

  lockIconState mNotifiedSecurityState;
  bool mNotifiedToplevelIsEV;

  void ResetStateTracking();
  uint32_t mNewToplevelSecurityState;
  bool mNewToplevelIsEV;
  bool mNewToplevelSecurityStateKnown;
  bool mIsViewSource;

  int32_t mDocumentRequestsInProgress;
  int32_t mSubRequestsBrokenSecurity;
  int32_t mSubRequestsNoSecurity;
  bool mCertUserOverridden;
  bool mRestoreSubrequests;
  bool mOnLocationChangeSeen;
#ifdef DEBUG
  bool mEntered; // For ReentrancyGuard.
#endif

  static already_AddRefed<nsISupports> ExtractSecurityInfo(nsIRequest* aRequest);
  nsresult MapInternalToExternalState(uint32_t* aState, lockIconState lock, bool ev);
  void UpdateSecurityState(nsIRequest* aRequest, bool withNewLocation,
                           bool withUpdateStatus);
  void TellTheWorld(nsIRequest* aRequest);

  void EvaluateAndUpdateSecurityState(nsIRequest* aRequest, nsISupports *info,
                                      bool withNewLocation, bool withNewSink);
  void UpdateSubrequestMembers(nsISupports* securityInfo, nsIRequest* request);

  void ObtainEventSink(nsIChannel *channel,
                       nsCOMPtr<nsISecurityEventSink> &sink);

  nsCOMPtr<nsISSLStatus> mSSLStatus;
  nsCOMPtr<nsISupports> mCurrentToplevelSecurityInfo;

  PLDHashTable mTransferringRequests;
};

#endif // nsSecureBrowserUIImpl_h
