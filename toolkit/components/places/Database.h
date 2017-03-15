/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_places_Database_h_
#define mozilla_places_Database_h_

#include "MainThreadUtils.h"
#include "nsWeakReference.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsIObserver.h"
#include "nsIAsyncShutdown.h"
#include "mozilla/storage.h"
#include "mozilla/storage/StatementCache.h"
#include "mozilla/Attributes.h"
#include "nsIEventTarget.h"
#include "Shutdown.h"

// This is the schema version. Update it at any schema change and add a
// corresponding migrateVxx method below.
#define DATABASE_SCHEMA_VERSION 35

// Fired after Places inited.
#define TOPIC_PLACES_INIT_COMPLETE "places-init-complete"
// Fired when initialization fails due to a locked database.
#define TOPIC_DATABASE_LOCKED "places-database-locked"
// This topic is received when the profile is about to be lost.  Places does
// initial shutdown work and notifies TOPIC_PLACES_SHUTDOWN to all listeners.
// Any shutdown work that requires the Places APIs should happen here.
#define TOPIC_PROFILE_CHANGE_TEARDOWN "profile-change-teardown"
// Fired when Places is shutting down.  Any code should stop accessing Places
// APIs after this notification.  If you need to listen for Places shutdown
// you should only use this notification, next ones are intended only for
// internal Places use.
#define TOPIC_PLACES_SHUTDOWN "places-shutdown"
// For Internal use only.  Fired when connection is about to be closed, only
// cleanup tasks should run at this stage, nothing should be added to the
// database, nor APIs should be called.
#define TOPIC_PLACES_WILL_CLOSE_CONNECTION "places-will-close-connection"
// Fired when the connection has gone, nothing will work from now on.
#define TOPIC_PLACES_CONNECTION_CLOSED "places-connection-closed"

// Simulate profile-before-change. This topic may only be used by
// calling `observe` directly on the database. Used for testing only.
#define TOPIC_SIMULATE_PLACES_SHUTDOWN "test-simulate-places-shutdown"

class nsIRunnable;

namespace mozilla {
namespace places {

enum JournalMode {
  // Default SQLite journal mode.
  JOURNAL_DELETE = 0
  // Can reduce fsyncs on Linux when journal is deleted (See bug 460315).
  // We fallback to this mode when WAL is unavailable.
, JOURNAL_TRUNCATE
  // Unsafe in case of crashes on database swap or low memory.
, JOURNAL_MEMORY
  // Can reduce number of fsyncs.  We try to use this mode by default.
, JOURNAL_WAL
};

class ClientsShutdownBlocker;
class ConnectionShutdownBlocker;

class Database final : public nsIObserver
                     , public nsSupportsWeakReference
{
  typedef mozilla::storage::StatementCache<mozIStorageStatement> StatementCache;
  typedef mozilla::storage::StatementCache<mozIStorageAsyncStatement> AsyncStatementCache;

public:
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIOBSERVER

  Database();

  /**
   * Initializes the database connection and the schema.
   * In case of corruption the database is copied to a backup file and replaced.
   */
  nsresult Init();

  /**
   * The AsyncShutdown client used by clients of this API to be informed of shutdown.
   */
  already_AddRefed<nsIAsyncShutdownClient> GetClientsShutdown();

  /**
   * Getter to use when instantiating the class.
   *
   * @return Singleton instance of this class.
   */
  static already_AddRefed<Database> GetDatabase();

  /**
   * Returns last known database status.
   *
   * @return one of the nsINavHistoryService::DATABASE_STATUS_* constants.
   */
  uint16_t GetDatabaseStatus() const
  {
    return mDatabaseStatus;
  }

  /**
   * Returns a pointer to the storage connection.
   *
   * @return The connection handle.
   */
  mozIStorageConnection* MainConn() const
  {
    return mMainConn;
  }

  /**
   * Dispatches a runnable to the connection async thread, to be serialized
   * with async statements.
   *
   * @param aEvent
   *        The runnable to be dispatched.
   */
  void DispatchToAsyncThread(nsIRunnable* aEvent) const
  {
    if (mClosed) {
      return;
    }
    nsCOMPtr<nsIEventTarget> target = do_GetInterface(mMainConn);
    if (target) {
      (void)target->Dispatch(aEvent, NS_DISPATCH_NORMAL);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //// Statements Getters.

  /**
   * Gets a cached synchronous statement.
   *
   * @param aQuery
   *        SQL query literal.
   * @return The cached statement.
   * @note Always null check the result.
   * @note Always use a scoper to reset the statement.
   */
  template<int N>
  already_AddRefed<mozIStorageStatement>
  GetStatement(const char (&aQuery)[N]) const
  {
    nsDependentCString query(aQuery, N - 1);
    return GetStatement(query);
  }

  /**
   * Gets a cached synchronous statement.
   *
   * @param aQuery
   *        nsCString of SQL query.
   * @return The cached statement.
   * @note Always null check the result.
   * @note Always use a scoper to reset the statement.
   */
  already_AddRefed<mozIStorageStatement>  GetStatement(const nsACString& aQuery) const;

  /**
   * Gets a cached asynchronous statement.
   *
   * @param aQuery
   *        SQL query literal.
   * @return The cached statement.
   * @note Always null check the result.
   * @note AsyncStatements are automatically reset on execution.
   */
  template<int N>
  already_AddRefed<mozIStorageAsyncStatement>
  GetAsyncStatement(const char (&aQuery)[N]) const
  {
    nsDependentCString query(aQuery, N - 1);
    return GetAsyncStatement(query);
  }

  /**
   * Gets a cached asynchronous statement.
   *
   * @param aQuery
   *        nsCString of SQL query.
   * @return The cached statement.
   * @note Always null check the result.
   * @note AsyncStatements are automatically reset on execution.
   */
  already_AddRefed<mozIStorageAsyncStatement> GetAsyncStatement(const nsACString& aQuery) const;

  uint32_t MaxUrlLength();

protected:
  /**
   * Finalizes the cached statements and closes the database connection.
   * A TOPIC_PLACES_CONNECTION_CLOSED notification is fired when done.
   */
  void Shutdown();

  bool IsShutdownStarted() const;

  /**
   * Initializes the database file.  If the database does not exist or is
   * corrupt, a new one is created.  In case of corruption it also creates a
   * backup copy of the database.
   *
   * @param aStorage
   *        mozStorage service instance.
   * @param aNewDatabaseCreated
   *        whether a new database file has been created.
   */
  nsresult InitDatabaseFile(nsCOMPtr<mozIStorageService>& aStorage,
                            bool* aNewDatabaseCreated);

  /**
   * Creates a database backup and replaces the original file with a new
   * one.
   *
   * @param aStorage
   *        mozStorage service instance.
   */
  nsresult BackupAndReplaceDatabaseFile(nsCOMPtr<mozIStorageService>& aStorage);

  /**
   * Initializes the database.  This performs any necessary migrations for the
   * database.  All migration is done inside a transaction that is rolled back
   * if any error occurs.
   * @param aDatabaseMigrated
   *        Whether a schema upgrade happened.
   */
  nsresult InitSchema(bool* aDatabaseMigrated);

  /**
   * Creates bookmark roots in a new DB.
   */
  nsresult CreateBookmarkRoots();

  /**
   * Initializes additionale SQLite functions, defined in SQLFunctions.h
   */
  nsresult InitFunctions();

  /**
   * Initializes temp entities, like triggers, tables, views...
   */
  nsresult InitTempEntities();

  /**
   * Helpers used by schema upgrades.
   */
  nsresult MigrateV13Up();
  nsresult MigrateV15Up();
  nsresult MigrateV17Up();
  nsresult MigrateV18Up();
  nsresult MigrateV19Up();
  nsresult MigrateV20Up();
  nsresult MigrateV21Up();
  nsresult MigrateV22Up();
  nsresult MigrateV23Up();
  nsresult MigrateV24Up();
  nsresult MigrateV25Up();
  nsresult MigrateV26Up();
  nsresult MigrateV27Up();
  nsresult MigrateV28Up();
  nsresult MigrateV30Up();
  nsresult MigrateV31Up();
  nsresult MigrateV32Up();
  nsresult MigrateV33Up();
  nsresult MigrateV34Up();
  nsresult MigrateV35Up();

  nsresult UpdateBookmarkRootTitles();

  friend class ConnectionShutdownBlocker;

  int64_t CreateMobileRoot();
  nsresult GetItemsWithAnno(const nsACString& aAnnoName, int32_t aItemType,
                            nsTArray<int64_t>& aItemIds);
  nsresult DeleteBookmarkItem(int32_t aItemId);

private:
  ~Database();

  /**
   * Singleton getter, invoked by class instantiation.
   */
  static already_AddRefed<Database> GetSingleton();

  static Database* gDatabase;

  nsCOMPtr<mozIStorageConnection> mMainConn;

  mutable StatementCache mMainThreadStatements;
  mutable AsyncStatementCache mMainThreadAsyncStatements;
  mutable StatementCache mAsyncThreadStatements;

  int32_t mDBPageSize;
  uint16_t mDatabaseStatus;
  bool mClosed;

  /**
   * Phases for shutting down the Database.
   * See Shutdown.h for further details about the shutdown procedure.
   */
  already_AddRefed<nsIAsyncShutdownClient> GetProfileChangeTeardownPhase();
  already_AddRefed<nsIAsyncShutdownClient> GetProfileBeforeChangePhase();

  /**
   * Blockers in charge of waiting for the Places clients and then shutting
   * down the mozStorage connection.
   * See Shutdown.h for further details about the shutdown procedure.
   *
   * Cycles with these are broken in `Shutdown()`.
   */
  RefPtr<ClientsShutdownBlocker> mClientsShutdown;
  RefPtr<ConnectionShutdownBlocker> mConnectionShutdown;

  // Maximum length of a stored url.
  // For performance reasons we don't store very long urls in history, since
  // they are slower to search through and cause abnormal database growth,
  // affecting the awesomebar fetch time.
  uint32_t mMaxUrlLength;
};

} // namespace places
} // namespace mozilla

#endif // mozilla_places_Database_h_
