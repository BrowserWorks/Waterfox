/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_CookieDummyStorage_h
#define mozilla_net_CookieDummyStorage_h

#include "CookieStorage.h"

class nsICookieTransactionCallback;

namespace mozilla {
namespace net {

class CookieDummyStorage final : public CookieStorage {
 public:
  CookieDummyStorage() = default;

  void StaleCookies(const nsTArray<RefPtr<Cookie>>& aCookieList,
                    int64_t aCurrentTimeInUsec) override {}

  void Close() override {}

  void EnsureInitialized() override {}

  nsresult RunInTransaction(nsICookieTransactionCallback* aCallback) override {
    return NS_OK;
  }

 protected:
  const char* NotificationTopic() const override {
    return "dummy-cookie-changed";
  }

  void NotifyChangedInternal(nsICookieNotification* aNotification,
                             bool aOldCookieIsSession) override {}

  void RemoveAllInternal() override {}

  void RemoveCookieFromDB(Cookie* aCookie) override {}

  already_AddRefed<nsIArray> PurgeCookies(int64_t aCurrentTimeInUsec,
                                          uint16_t aMaxNumberOfCookies,
                                          int64_t aCookiePurgeAge) override {
    return nullptr;
  }

  void StoreCookie(const nsACString& aBaseDomain,
                   const OriginAttributes& aOriginAttributes,
                   Cookie* aCookie) override {}

 private:
  void CollectCookieJarSizeData() override {}
};

}  // namespace net
}  // namespace mozilla

#endif  // mozilla_net_CookieDummyStorage_h
