/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/net/NeckoChild.h"
#include "mozilla/net/FTPChannelChild.h"
using namespace mozilla;
using namespace mozilla::net;

#include "nsFtpProtocolHandler.h"
#include "nsFTPChannel.h"
#include "mozilla/Logging.h"
#include "nsIPrefBranch.h"
#include "nsIObserverService.h"
#include "nsEscape.h"
#include "nsAlgorithm.h"

//-----------------------------------------------------------------------------

//
// Log module for FTP Protocol logging...
//
// To enable logging (see prlog.h for full details):
//
//    set MOZ_LOG=nsFtp:5
//    set MOZ_LOG_FILE=ftp.log
//
// This enables LogLevel::Debug level information and places all output in
// the file ftp.log.
//
LazyLogModule gFTPLog("nsFtp");
#undef LOG
#define LOG(args) MOZ_LOG(gFTPLog, mozilla::LogLevel::Debug, args)

//-----------------------------------------------------------------------------

#define IDLE_TIMEOUT_PREF "network.ftp.idleConnectionTimeout"
#define IDLE_CONNECTION_LIMIT 8 /* TODO pref me */

#define ENABLED_PREF "network.ftp.enabled"
#define QOS_DATA_PREF "network.ftp.data.qos"
#define QOS_CONTROL_PREF "network.ftp.control.qos"

nsFtpProtocolHandler* gFtpHandler = nullptr;

//-----------------------------------------------------------------------------

nsFtpProtocolHandler::nsFtpProtocolHandler()
    : mIdleTimeout(-1),
      mEnabled(true),
      mSessionId(0),
      mControlQoSBits(0x00),
      mDataQoSBits(0x00) {
  LOG(("FTP:creating handler @%p\n", this));

  gFtpHandler = this;
}

nsFtpProtocolHandler::~nsFtpProtocolHandler() {
  LOG(("FTP:destroying handler @%p\n", this));

  NS_ASSERTION(mRootConnectionList.Length() == 0, "why wasn't Observe called?");

  gFtpHandler = nullptr;
}

NS_IMPL_ISUPPORTS(nsFtpProtocolHandler, nsIProtocolHandler,
                  nsIProxiedProtocolHandler, nsIObserver,
                  nsISupportsWeakReference)

nsresult nsFtpProtocolHandler::Init() {
  if (IsNeckoChild()) NeckoChild::InitNeckoChild();

  if (mIdleTimeout == -1) {
    nsresult rv;
    nsCOMPtr<nsIPrefBranch> branch =
        do_GetService(NS_PREFSERVICE_CONTRACTID, &rv);
    if (NS_FAILED(rv)) return rv;

    rv = branch->GetIntPref(IDLE_TIMEOUT_PREF, &mIdleTimeout);
    if (NS_FAILED(rv)) mIdleTimeout = 5 * 60;  // 5 minute default

    rv = branch->AddObserver(IDLE_TIMEOUT_PREF, this, true);
    if (NS_FAILED(rv)) return rv;

    rv = branch->GetBoolPref(ENABLED_PREF, &mEnabled);
    if (NS_FAILED(rv)) mEnabled = true;

    rv = branch->AddObserver(ENABLED_PREF, this, true);
    if (NS_FAILED(rv)) return rv;

    int32_t val;
    rv = branch->GetIntPref(QOS_DATA_PREF, &val);
    if (NS_SUCCEEDED(rv)) mDataQoSBits = (uint8_t)clamped(val, 0, 0xff);

    rv = branch->AddObserver(QOS_DATA_PREF, this, true);
    if (NS_FAILED(rv)) return rv;

    rv = branch->GetIntPref(QOS_CONTROL_PREF, &val);
    if (NS_SUCCEEDED(rv)) mControlQoSBits = (uint8_t)clamped(val, 0, 0xff);

    rv = branch->AddObserver(QOS_CONTROL_PREF, this, true);
    if (NS_FAILED(rv)) return rv;
  }

  nsCOMPtr<nsIObserverService> observerService =
      mozilla::services::GetObserverService();
  if (observerService) {
    observerService->AddObserver(this, "network:offline-about-to-go-offline",
                                 true);

    observerService->AddObserver(this, "net:clear-active-logins", true);
  }

  return NS_OK;
}

//-----------------------------------------------------------------------------
// nsIProtocolHandler methods:

NS_IMETHODIMP
nsFtpProtocolHandler::GetScheme(nsACString& result) {
  result.AssignLiteral("ftp");
  return NS_OK;
}

NS_IMETHODIMP
nsFtpProtocolHandler::GetDefaultPort(int32_t* result) {
  *result = 21;
  return NS_OK;
}

NS_IMETHODIMP
nsFtpProtocolHandler::GetProtocolFlags(uint32_t* result) {
  *result = URI_STD | ALLOWS_PROXY | ALLOWS_PROXY_HTTP | URI_LOADABLE_BY_ANYONE;
  return NS_OK;
}

NS_IMETHODIMP
nsFtpProtocolHandler::NewChannel(nsIURI* url, nsILoadInfo* aLoadInfo,
                                 nsIChannel** result) {
  return NewProxiedChannel(url, nullptr, 0, nullptr, aLoadInfo, result);
}

NS_IMETHODIMP
nsFtpProtocolHandler::NewProxiedChannel(nsIURI* uri, nsIProxyInfo* proxyInfo,
                                        uint32_t proxyResolveFlags,
                                        nsIURI* proxyURI,
                                        nsILoadInfo* aLoadInfo,
                                        nsIChannel** result) {
  if (!mEnabled) {
    return NS_ERROR_UNKNOWN_PROTOCOL;
  }

  NS_ENSURE_ARG_POINTER(uri);
  RefPtr<nsBaseChannel> channel;
  if (IsNeckoChild())
    channel = new FTPChannelChild(uri);
  else
    channel = new nsFtpChannel(uri, proxyInfo);

  // set the loadInfo on the new channel
  nsresult rv = channel->SetLoadInfo(aLoadInfo);
  NS_ENSURE_SUCCESS(rv, rv);

  channel.forget(result);
  return rv;
}

NS_IMETHODIMP
nsFtpProtocolHandler::AllowPort(int32_t port, const char* scheme,
                                bool* _retval) {
  *_retval = (port == 21 || port == 22);
  return NS_OK;
}

// connection cache methods

void nsFtpProtocolHandler::Timeout(nsITimer* aTimer, void* aClosure) {
  LOG(("FTP:timeout reached for %p\n", aClosure));

  bool found = gFtpHandler->mRootConnectionList.RemoveElement(aClosure);
  if (!found) {
    NS_ERROR("timerStruct not found");
    return;
  }

  timerStruct* s = (timerStruct*)aClosure;
  delete s;
}

nsresult nsFtpProtocolHandler::RemoveConnection(
    nsIURI* aKey, nsFtpControlConnection** _retval) {
  NS_ASSERTION(_retval, "null pointer");
  NS_ASSERTION(aKey, "null pointer");

  *_retval = nullptr;

  nsAutoCString spec;
  aKey->GetPrePath(spec);

  LOG(("FTP:removing connection for %s\n", spec.get()));

  timerStruct* ts = nullptr;
  uint32_t i;
  bool found = false;

  for (i = 0; i < mRootConnectionList.Length(); ++i) {
    ts = mRootConnectionList[i];
    if (strcmp(spec.get(), ts->key) == 0) {
      found = true;
      mRootConnectionList.RemoveElementAt(i);
      break;
    }
  }

  if (!found) return NS_ERROR_FAILURE;

  // swap connection ownership
  ts->conn.forget(_retval);
  delete ts;

  return NS_OK;
}

nsresult nsFtpProtocolHandler::InsertConnection(nsIURI* aKey,
                                                nsFtpControlConnection* aConn) {
  NS_ASSERTION(aConn, "null pointer");
  NS_ASSERTION(aKey, "null pointer");

  if (aConn->mSessionId != mSessionId) return NS_ERROR_FAILURE;

  nsAutoCString spec;
  aKey->GetPrePath(spec);

  LOG(("FTP:inserting connection for %s\n", spec.get()));

  timerStruct* ts = new timerStruct();
  if (!ts) return NS_ERROR_OUT_OF_MEMORY;

  nsCOMPtr<nsITimer> timer;
  nsresult rv = NS_NewTimerWithFuncCallback(
      getter_AddRefs(timer), nsFtpProtocolHandler::Timeout, ts,
      mIdleTimeout * 1000, nsITimer::TYPE_REPEATING_SLACK,
      "nsFtpProtocolHandler::InsertConnection");
  if (NS_FAILED(rv)) {
    delete ts;
    return rv;
  }

  ts->key = ToNewCString(spec, mozilla::fallible);
  if (!ts->key) {
    delete ts;
    return NS_ERROR_OUT_OF_MEMORY;
  }

  // ts->conn is a RefPtr
  ts->conn = aConn;
  ts->timer = timer;

  //
  // limit number of idle connections.  if limit is reached, then prune
  // eldest connection with matching key.  if none matching, then prune
  // eldest connection.
  //
  if (mRootConnectionList.Length() == IDLE_CONNECTION_LIMIT) {
    uint32_t i;
    for (i = 0; i < mRootConnectionList.Length(); ++i) {
      timerStruct* candidate = mRootConnectionList[i];
      if (strcmp(candidate->key, ts->key) == 0) {
        mRootConnectionList.RemoveElementAt(i);
        delete candidate;
        break;
      }
    }
    if (mRootConnectionList.Length() == IDLE_CONNECTION_LIMIT) {
      timerStruct* eldest = mRootConnectionList[0];
      mRootConnectionList.RemoveElementAt(0);
      delete eldest;
    }
  }

  mRootConnectionList.AppendElement(ts);
  return NS_OK;
}

//-----------------------------------------------------------------------------
// nsIObserver

NS_IMETHODIMP
nsFtpProtocolHandler::Observe(nsISupports* aSubject, const char* aTopic,
                              const char16_t* aData) {
  LOG(("FTP:observing [%s]\n", aTopic));

  if (!strcmp(aTopic, NS_PREFBRANCH_PREFCHANGE_TOPIC_ID)) {
    nsCOMPtr<nsIPrefBranch> branch = do_QueryInterface(aSubject);
    if (!branch) {
      NS_ERROR("no prefbranch");
      return NS_ERROR_UNEXPECTED;
    }
    int32_t val;
    nsresult rv = branch->GetIntPref(IDLE_TIMEOUT_PREF, &val);
    if (NS_SUCCEEDED(rv)) mIdleTimeout = val;
    bool enabled;
    rv = branch->GetBoolPref(ENABLED_PREF, &enabled);
    if (NS_SUCCEEDED(rv)) mEnabled = enabled;

    rv = branch->GetIntPref(QOS_DATA_PREF, &val);
    if (NS_SUCCEEDED(rv)) mDataQoSBits = (uint8_t)clamped(val, 0, 0xff);

    rv = branch->GetIntPref(QOS_CONTROL_PREF, &val);
    if (NS_SUCCEEDED(rv)) mControlQoSBits = (uint8_t)clamped(val, 0, 0xff);
  } else if (!strcmp(aTopic, "network:offline-about-to-go-offline")) {
    ClearAllConnections();
  } else if (!strcmp(aTopic, "net:clear-active-logins")) {
    ClearAllConnections();
    mSessionId++;
  } else {
    MOZ_ASSERT_UNREACHABLE("unexpected topic");
  }

  return NS_OK;
}

void nsFtpProtocolHandler::ClearAllConnections() {
  uint32_t i;
  for (i = 0; i < mRootConnectionList.Length(); ++i)
    delete mRootConnectionList[i];
  mRootConnectionList.Clear();
}
