/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_CookiePersistentStorage_h
#define mozilla_net_CookiePersistentStorage_h

#include "Cookie.h"
#include "CookieStorage.h"
#include "mozIStorageCompletionCallback.h"
#include "mozIStorageStatement.h"
#include "mozIStorageStatementCallback.h"
#include "mozilla/Atomics.h"
#include "mozilla/Monitor.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/net/NeckoChannelParams.h"
#include "nsIAsyncShutdown.h"

class mozIStorageAsyncStatement;
class mozIStorageService;
class nsICookieTransactionCallback;
class nsIEffectiveTLDService;
class nsIURI;

namespace mozilla {
namespace net {

class CookieDBWriteQueue;

class CookiePersistentStorage final : public CookieStorage,
                                      public nsIAsyncShutdownBlocker {
 public:
  // Result codes for TryInitDB() and Read().
  enum OpenDBResult { RESULT_OK, RESULT_RETRY, RESULT_FAILURE };

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_NSIASYNCSHUTDOWNBLOCKER

  static already_AddRefed<CookiePersistentStorage> Create();

  void HandleCorruptDB();

  void StaleCookies(const nsTArray<RefPtr<Cookie>>& aCookieList,
                    int64_t aCurrentTimeInUsec) override;

  void Close() override;

  void EnsureInitialized() override;

  void CleanupCachedStatements();
  void CleanupDBConnection();

  void Activate();

  void RebuildCorruptDB();
  void HandleDBClosed();

  nsresult RunInTransaction(nsICookieTransactionCallback* aCallback) override;

  // State of the database connection.
  enum CorruptFlag {
    OK,                   // normal
    CLOSING_FOR_REBUILD,  // corruption detected, connection closing
    REBUILDING            // close complete, rebuilding database from memory
  };

  void OnWriteBatchCompleted(uint16_t aReason);

 protected:
  const char* NotificationTopic() const override { return "cookie-changed"; }

  void NotifyChangedInternal(nsICookieNotification* aNotification,
                             bool aOldCookieIsSession) override;

  void RemoveAllInternal() override;

  void RemoveCookieFromDB(Cookie* aCookie) override;

  void StoreCookie(const nsACString& aBaseDomain,
                   const OriginAttributes& aOriginAttributes,
                   Cookie* aCookie) override;

 private:
  friend class CookieDBWriteQueue;

  CookiePersistentStorage();
  ~CookiePersistentStorage();

  // Writes a batch of coalesced changes in a single transaction. Returns true
  // if an asynchronous execution was started, in which case
  // OnWriteBatchCompleted() will eventually run.
  bool ExecuteWriteBatch(const nsTArray<RefPtr<Cookie>>& aRemovals,
                         const nsTArray<RefPtr<Cookie>>& aInsertions,
                         const nsTArray<RefPtr<Cookie>>& aUpdates);

  void InitDBConn();
  nsresult InitDBConnInternal();

  OpenDBResult TryInitDB(bool aRecreateDB);
  OpenDBResult Read();
  void MoveUnpartitionedChipsCookies();

  void RecordValidationTelemetry();

  nsresult CreateTableWorker(const char* aName);
  nsresult CreateTable();
  nsresult CreateTableForSchemaVersion6();
  nsresult CreateTableForSchemaVersion5();

  static UniquePtr<CookieStruct> GetCookieFromRow(mozIStorageStatement* aRow);

  already_AddRefed<nsIArray> PurgeCookies(int64_t aCurrentTimeInUsec,
                                          uint16_t aMaxNumberOfCookies,
                                          int64_t aCookiePurgeAge) override;

  void CollectCookieJarSizeData() override;

  UniquePtr<CookieDBWriteQueue> mWriteQueue;

  nsCOMPtr<nsIThread> mThread;
  nsCOMPtr<mozIStorageService> mStorageService;
  nsCOMPtr<nsIEffectiveTLDService> mTLDService;
  // Created on the main thread in Activate(); used read-only in Read() on the
  // Cookie thread for hostname validation via Mutate()->SetHost().
  nsCOMPtr<nsIURI> mPlaceholderURI;

  // encapsulates a (key, Cookie) tuple for temporary storage purposes.
  struct CookieDomainTuple {
    CookieKey key;
    OriginAttributes originAttributes;
    RefPtr<Cookie> cookie;
  };

  // thread
  TimeStamp mEndInitDBConn;
  nsTArray<CookieDomainTuple> mReadArray;
  // Cookies with invalid hostnames found during Read(), to be removed from DB
  // on the main thread after InitDBConn() sets up the DB connection.
  // Synchronized by the same mMonitor + mInitialized pattern as mReadArray.
  nsTArray<CookieDomainTuple> mCleanupArray;

  Monitor mMonitor MOZ_ANNOTATED;

  Atomic<bool> mInitialized;
  Atomic<bool> mInitializedDBConn;

  nsCOMPtr<nsIFile> mCookieFile;
  nsCOMPtr<mozIStorageConnection> mDBConn;
  nsCOMPtr<mozIStorageAsyncStatement> mStmtInsert;
  nsCOMPtr<mozIStorageAsyncStatement> mStmtDelete;
  nsCOMPtr<mozIStorageAsyncStatement> mStmtUpdate;

  Atomic<CorruptFlag, Relaxed> mCorruptFlag;

  // Various parts representing asynchronous read state. These are useful
  // while the background read is taking place.
  nsCOMPtr<mozIStorageConnection> mSyncConn;

  // DB completion handlers.
  nsCOMPtr<mozIStorageStatementCallback> mFlushListener;
  nsCOMPtr<mozIStorageStatementCallback> mRemoveListener;
  nsCOMPtr<mozIStorageCompletionCallback> mCloseListener;

  nsCOMPtr<nsIAsyncShutdownClient> mShutdownBarrier;
  void RemoveShutdownBlocker();
};

}  // namespace net
}  // namespace mozilla

#endif  // mozilla_net_CookiePersistentStorage_h
