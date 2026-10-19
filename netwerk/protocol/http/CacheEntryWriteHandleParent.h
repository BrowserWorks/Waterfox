/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_CacheEntryWriteHandleParent_h
#define mozilla_net_CacheEntryWriteHandleParent_h

#include "mozilla/net/PCacheEntryWriteHandleParent.h"
#include "nsCOMPtr.h"
#include "nsICacheEntry.h"
#include "nsICacheInfoChannel.h"
#include "nsString.h"

namespace mozilla {
namespace net {

/**
 * CacheEntryWriteHandleParent is a wrapper for nsICacheEntry, for the
 * asynchronous OpenAlternativeOutputStream call.
 */
class CacheEntryWriteHandleParent final : public nsICacheEntryWriteHandle,
                                          public PCacheEntryWriteHandleParent {
 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSICACHEENTRYWRITEHANDLE
  CacheEntryWriteHandleParent(nsICacheEntry* aCacheEntry,
                              const nsACString& aBindingOrigin);

 private:
  virtual ~CacheEntryWriteHandleParent() = default;

  nsCOMPtr<nsICacheEntry> mCacheEntry;
  // Origin of the principal that requested this write handle, used to bind
  // any alt-data written through it to that principal.
  nsCString mBindingOrigin;
};

}  // namespace net
}  // namespace mozilla

#endif  // mozilla_net_DocumentChannelChild_h
