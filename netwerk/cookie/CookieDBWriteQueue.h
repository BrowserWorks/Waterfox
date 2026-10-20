/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_CookieDBWriteQueue_h
#define mozilla_net_CookieDBWriteQueue_h

#include "gtest/MozGtestFriend.h"
#include "mozilla/Maybe.h"
#include "mozilla/RefPtr.h"
#include "nsCOMPtr.h"
#include "nsHashKeys.h"
#include "nsString.h"
#include "nsTArray.h"
#include "nsTHashMap.h"

class nsITimer;

namespace mozilla {
namespace net {

class Cookie;
class CookiePersistentStorage;

// Buffers the changes CookiePersistentStorage wants to persist and writes them
// out in batches.
//
// Changes are coalesced per database row, keyed on the (host, name, path,
// originAttributes) tuple that moz_cookies is UNIQUE on: operations on distinct
// rows commute, and for a given row only the final state matters. Within a
// batch every DELETE is emitted before every INSERT, so an overwrite stays
// ordered.
class CookieDBWriteQueue final {
 public:
  explicit CookieDBWriteQueue(CookiePersistentStorage* aStorage);
  ~CookieDBWriteQueue();

  void Insert(Cookie* aCookie);
  void Update(Cookie* aCookie);
  void Remove(Cookie* aCookie);

  bool IsIdle() const { return mPending.IsEmpty() && mFlushesInFlight == 0; }

  void Clear();

  void FlushNow();

  void OnFlushCompleted();

 private:
  FRIEND_TEST(TestCookieDBWriteQueue, Coalesce);

  enum class OpType : uint8_t {
    Insert,           // the row must exist with these values
    Update,           // the row exists, only lastAccessed changed
    Remove,           // the row must not exist
    RemoveAndInsert,  // overwrite: drop the old row, then insert the new one
  };

  struct PendingOp {
    RefPtr<Cookie> mCookie;
    OpType mType;
  };

  static void RowKey(const Cookie* aCookie, nsACString& aKey);
  static Maybe<OpType> Coalesce(OpType aPending, OpType aNew);

  void Enqueue(Cookie* aCookie, OpType aOp);
  void MaybeScheduleFlush();
  void CancelTimer();
  void Flush();

  CookiePersistentStorage* MOZ_NON_OWNING_REF mStorage;

  nsTHashMap<nsCStringHashKey, PendingOp> mPending;
  nsCOMPtr<nsITimer> mTimer;
  // Usually at most one: only the timer waits for the batch in flight.
  // FlushNow() dispatches unconditionally, because at shutdown a deferred
  // flush would come after the connection is already closing.
  uint32_t mFlushesInFlight = 0;
};

}  // namespace net
}  // namespace mozilla

#endif  // mozilla_net_CookieDBWriteQueue_h
