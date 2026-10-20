/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "CookieDBWriteQueue.h"

#include "Cookie.h"
#include "CookieLogging.h"
#include "CookiePersistentStorage.h"
#include "mozilla/StaticPrefs_network.h"
#include "nsITimer.h"

namespace mozilla {
namespace net {

CookieDBWriteQueue::CookieDBWriteQueue(CookiePersistentStorage* aStorage)
    : mStorage(aStorage) {
  MOZ_ASSERT(aStorage);
}

CookieDBWriteQueue::~CookieDBWriteQueue() { CancelTimer(); }

// static
void CookieDBWriteQueue::RowKey(const Cookie* aCookie, nsACString& aKey) {
  nsAutoCString suffix;
  aCookie->OriginAttributesRef().CreateSuffix(suffix);

  aKey.Truncate();
  aKey.Append(aCookie->Host());
  aKey.Append('\0');
  aKey.Append(aCookie->Name());
  aKey.Append('\0');
  aKey.Append(aCookie->Path());
  aKey.Append('\0');
  aKey.Append(suffix);
}

// static
Maybe<CookieDBWriteQueue::OpType> CookieDBWriteQueue::Coalesce(OpType aPending,
                                                               OpType aNew) {
  switch (aNew) {
    case OpType::Insert:
      // An insertion on top of a pending removal has to keep the removal: the
      // row being overwritten can still be on disk.
      MOZ_ASSERT(
          aPending == OpType::Remove || aPending == OpType::RemoveAndInsert,
          "a row is always removed from the list before being stored "
          "again, so only a removal can be followed by an insertion");
      return Some(OpType::RemoveAndInsert);

    case OpType::Update:
      // Every state that rewrites the row already carries the current
      // lastAccessed value.
      MOZ_ASSERT(aPending != OpType::Remove,
                 "a removed row is no longer in the list, so it cannot be "
                 "staled");
      return Some(aPending);

    case OpType::Remove:
      // A buffered insertion cancels out: it is still in this batch, so it
      // never reached the disk and there is no row for the DELETE to remove.
      if (aPending == OpType::Insert) {
        return Nothing();
      }
      // Whatever was buffered never reached the disk, and the DELETE takes
      // care of any row that is already there.
      return Some(OpType::Remove);

    case OpType::RemoveAndInsert:
      MOZ_ASSERT_UNREACHABLE("RemoveAndInsert is never enqueued on its own");
      return Some(aPending);
  }

  MOZ_CRASH("Unhandled OpType");
}

void CookieDBWriteQueue::Enqueue(Cookie* aCookie, OpType aOp) {
  MOZ_ASSERT(aCookie);

  nsAutoCString key;
  RowKey(aCookie, key);

  mPending.WithEntryHandle(key, [&](auto&& aEntry) {
    if (!aEntry) {
      aEntry.Insert(PendingOp{aCookie, aOp});
      return;
    }

    Maybe<OpType> coalesced = Coalesce(aEntry.Data().mType, aOp);
    if (!coalesced) {
      aEntry.Remove();
      return;
    }

    PendingOp& op = aEntry.Data();
    op.mType = *coalesced;
    op.mCookie = aCookie;
  });

  MaybeScheduleFlush();
}

void CookieDBWriteQueue::Insert(Cookie* aCookie) {
  Enqueue(aCookie, OpType::Insert);
}

void CookieDBWriteQueue::Update(Cookie* aCookie) {
  Enqueue(aCookie, OpType::Update);
}

void CookieDBWriteQueue::Remove(Cookie* aCookie) {
  Enqueue(aCookie, OpType::Remove);
}

void CookieDBWriteQueue::Clear() {
  mPending.Clear();
  CancelTimer();
}

void CookieDBWriteQueue::FlushNow() {
  CancelTimer();
  Flush();
}

void CookieDBWriteQueue::OnFlushCompleted() {
  MOZ_ASSERT(mFlushesInFlight > 0);
  --mFlushesInFlight;

  MaybeScheduleFlush();
}

void CookieDBWriteQueue::MaybeScheduleFlush() {
  if (mPending.IsEmpty() || mTimer || mFlushesInFlight > 0) {
    return;
  }

  NS_NewTimerWithFuncCallback(
      getter_AddRefs(mTimer),
      [](nsITimer*, void* aClosure) {
        auto* self = static_cast<CookieDBWriteQueue*>(aClosure);
        self->mTimer = nullptr;
        self->Flush();
      },
      this, StaticPrefs::network_cookie_db_flushIntervalMs(),
      nsITimer::TYPE_ONE_SHOT, "CookieDBWriteQueue::Flush"_ns);
}

void CookieDBWriteQueue::CancelTimer() {
  if (mTimer) {
    mTimer->Cancel();
    mTimer = nullptr;
  }
}

void CookieDBWriteQueue::Flush() {
  if (mPending.IsEmpty()) {
    return;
  }

  nsTArray<RefPtr<Cookie>> removals;
  nsTArray<RefPtr<Cookie>> insertions;
  nsTArray<RefPtr<Cookie>> updates;

  for (const auto& entry : mPending) {
    const PendingOp& op = entry.GetData();

    switch (op.mType) {
      case OpType::Insert:
        insertions.AppendElement(op.mCookie);
        break;

      case OpType::Update:
        updates.AppendElement(op.mCookie);
        break;

      case OpType::Remove:
        removals.AppendElement(op.mCookie);
        break;

      case OpType::RemoveAndInsert:
        removals.AppendElement(op.mCookie);
        insertions.AppendElement(op.mCookie);
        break;
    }
  }

  if (mStorage->ExecuteWriteBatch(removals, insertions, updates)) {
    ++mFlushesInFlight;
  } else {
    // Dispatching only fails when the connection or the statements are gone,
    // which never recovers on its own. Retrying would spin the timer forever.
    COOKIE_LOGSTRING(LogLevel::Warning,
                     ("CookieDBWriteQueue::Flush(): dropping %" PRIu32
                      " changes, the database is unusable",
                      mPending.Count()));
  }

  mPending.Clear();
}

}  // namespace net
}  // namespace mozilla
