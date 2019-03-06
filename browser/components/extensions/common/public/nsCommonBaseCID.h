/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsgCommonBaseCID_h__
#define nsgCommonBaseCID_h__

#include "nsISupports.h"
#include "nsIFactory.h"
#include "nsIComponentManager.h"

// nsComponentManagerExtra
#define NS_COMPONENTMANAGEREXTRA_CONTRACTID "@mozilla.org/component-manager-extra;1"
#define NS_COMPONENTMANAGEREXTRA_CID \
  { 0xb4359b53, 0x3060, 0x46ff, { 0xad, 0x42, 0xe6, 0x7e, 0xea, 0x6c, 0xcf, 0x59 } }

#define NS_BASECOMMANDCONTROLLER_CONTRACTID "@mozilla.org/embedcomp/base-command-controller;1"
#define NS_BASECOMMANDCONTROLLER_CID \
  { 0xbf88b48c, 0xfd8e, 0x40b4, { 0xba, 0x36, 0xc7, 0xc3, 0xad, 0x6d, 0x8a, 0xc9 } }

#define NS_TRANSACTIONMANAGER_CONTRACTID "@mozilla.org/transactionmanager;1"
#define NS_TRANSACTIONMANAGER_CID \
  { 0x9c8f9601, 0x801a, 0x11d2, { 0x98, 0xba, 0x0, 0x80, 0x5f, 0x29, 0x7d, 0x89 } }

#define NS_SYNCSTREAMLISTENER_CONTRACTID "@mozilla.org/network/sync-stream-listener;1"
#define NS_SYNCSTREAMLISTENER_CID \
  { 0x439400d3, 0x6f23, 0x43db, {0x8b, 0x06, 0x8a, 0xaf, 0xe1, 0x86, 0x9b, 0xd8 } }

#endif // nsCommonBaseCID_h__
