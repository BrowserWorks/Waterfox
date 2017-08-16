/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=2 et lcs=trail\:.,tab\:>~ :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsAutoPtr.h"

#include "sqlite3.h"

#include "mozIStorageStatementCallback.h"
#include "mozStorageBindingParams.h"
#include "mozStorageHelper.h"
#include "mozStorageResultSet.h"
#include "mozStorageRow.h"
#include "mozStorageConnection.h"
#include "mozStorageError.h"
#include "mozStoragePrivateHelpers.h"
#include "mozStorageStatementData.h"
#include "mozStorageAsyncStatementExecution.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/Telemetry.h"

namespace mozilla {
namespace storage {

/**
 * The following constants help batch rows into result sets.
 * MAX_MILLISECONDS_BETWEEN_RESULTS was chosen because any user-based task that
 * takes less than 200 milliseconds is considered to feel instantaneous to end
 * users.  MAX_ROWS_PER_RESULT was arbitrarily chosen to reduce the number of
 * dispatches to calling thread, while also providing reasonably-sized sets of
 * data for consumers.  Both of these constants are used because we assume that
 * consumers are trying to avoid blocking their execution thread for long
 * periods of time, and dispatching many small events to the calling thread will
 * end up blocking it.
 */
#define MAX_MILLISECONDS_BETWEEN_RESULTS 75
#define MAX_ROWS_PER_RESULT 15

////////////////////////////////////////////////////////////////////////////////
//// Local Classes

namespace {

typedef AsyncExecuteStatements::ExecutionState ExecutionState;
typedef AsyncExecuteStatements::StatementDataArray StatementDataArray;

/**
 * Notifies a callback with a result set.
 */
class CallbackResultNotifier : public Runnable
{
public:
  CallbackResultNotifier(mozIStorageStatementCallback *aCallback,
                         mozIStorageResultSet *aResults,
                         AsyncExecuteStatements *aEventStatus) :
      Runnable("storage::CallbackResultNotifier")
    , mCallback(aCallback)
    , mResults(aResults)
    , mEventStatus(aEventStatus)
  {
  }

  NS_IMETHOD Run() override
  {
    NS_ASSERTION(mCallback, "Trying to notify about results without a callback!");

    if (mEventStatus->shouldNotify()) {
      // Hold a strong reference to the callback while notifying it, so that if
      // it spins the event loop, the callback won't be released and freed out
      // from under us.
      nsCOMPtr<mozIStorageStatementCallback> callback = mCallback;

      (void)callback->HandleResult(mResults);
    }

    return NS_OK;
  }

private:
  mozIStorageStatementCallback *mCallback;
  nsCOMPtr<mozIStorageResultSet> mResults;
  RefPtr<AsyncExecuteStatements> mEventStatus;
};

/**
 * Notifies the calling thread that an error has occurred.
 */
class ErrorNotifier : public Runnable
{
public:
  ErrorNotifier(mozIStorageStatementCallback *aCallback,
                mozIStorageError *aErrorObj,
                AsyncExecuteStatements *aEventStatus) :
      Runnable("storage::ErrorNotifier")
    , mCallback(aCallback)
    , mErrorObj(aErrorObj)
    , mEventStatus(aEventStatus)
  {
  }

  NS_IMETHOD Run() override
  {
    if (mEventStatus->shouldNotify() && mCallback) {
      // Hold a strong reference to the callback while notifying it, so that if
      // it spins the event loop, the callback won't be released and freed out
      // from under us.
      nsCOMPtr<mozIStorageStatementCallback> callback = mCallback;

      (void)callback->HandleError(mErrorObj);
    }

    return NS_OK;
  }

private:
  mozIStorageStatementCallback *mCallback;
  nsCOMPtr<mozIStorageError> mErrorObj;
  RefPtr<AsyncExecuteStatements> mEventStatus;
};

/**
 * Notifies the calling thread that the statement has finished executing.  Takes
 * ownership of the StatementData so it is released on the proper thread.
 */
class CompletionNotifier : public Runnable
{
public:
  /**
   * This takes ownership of the callback and the StatementData.  They are
   * released on the thread this is dispatched to (which should always be the
   * calling thread).
   */
  CompletionNotifier(already_AddRefed<mozIStorageStatementCallback> aCallback,
                     ExecutionState aReason)
    : Runnable("storage::CompletionNotifier")
    , mCallback(aCallback)
    , mReason(aReason)
  {
  }

  NS_IMETHOD Run() override
  {
    if (mCallback) {
      (void)mCallback->HandleCompletion(mReason);
    }

    return NS_OK;
  }

private:
  RefPtr<mozIStorageStatementCallback> mCallback;
  ExecutionState mReason;
};

} // namespace

////////////////////////////////////////////////////////////////////////////////
//// AsyncExecuteStatements

/* static */
nsresult
AsyncExecuteStatements::execute(StatementDataArray &aStatements,
                                Connection *aConnection,
                                sqlite3 *aNativeConnection,
                                mozIStorageStatementCallback *aCallback,
                                mozIStoragePendingStatement **_stmt)
{
  // Create our event to run in the background
  RefPtr<AsyncExecuteStatements> event =
    new AsyncExecuteStatements(aStatements, aConnection, aNativeConnection,
                               aCallback);
  NS_ENSURE_TRUE(event, NS_ERROR_OUT_OF_MEMORY);

  // Dispatch it to the background
  nsIEventTarget *target = aConnection->getAsyncExecutionTarget();

  // If we don't have a valid target, this is a bug somewhere else. In the past,
  // this assert found cases where a Run method would schedule a new statement
  // without checking if asyncClose had been called. The caller must prevent
  // that from happening or, if the work is not critical, just avoid creating
  // the new statement during shutdown. See bug 718449 for an example.
  MOZ_ASSERT(target);
  if (!target) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  nsresult rv = target->Dispatch(event, NS_DISPATCH_NORMAL);
  NS_ENSURE_SUCCESS(rv, rv);

  // Return it as the pending statement object and track it.
  event.forget(_stmt);
  return NS_OK;
}

AsyncExecuteStatements::AsyncExecuteStatements(StatementDataArray &aStatements,
                                               Connection *aConnection,
                                               sqlite3 *aNativeConnection,
                                               mozIStorageStatementCallback *aCallback)
: mConnection(aConnection)
, mNativeConnection(aNativeConnection)
, mHasTransaction(false)
, mCallback(aCallback)
, mCallingThread(::do_GetCurrentThread())
, mMaxWait(TimeDuration::FromMilliseconds(MAX_MILLISECONDS_BETWEEN_RESULTS))
, mIntervalStart(TimeStamp::Now())
, mState(PENDING)
, mCancelRequested(false)
, mMutex(aConnection->sharedAsyncExecutionMutex)
, mDBMutex(aConnection->sharedDBMutex)
, mRequestStartDate(TimeStamp::Now())
{
  (void)mStatements.SwapElements(aStatements);
  NS_ASSERTION(mStatements.Length(), "We weren't given any statements!");
}

AsyncExecuteStatements::~AsyncExecuteStatements()
{
  MOZ_ASSERT(!mCallback, "Never called the Completion callback!");
  MOZ_ASSERT(!mHasTransaction, "There should be no transaction at this point");
}

bool
AsyncExecuteStatements::shouldNotify()
{
#ifdef DEBUG
  mMutex.AssertNotCurrentThreadOwns();

  bool onCallingThread = false;
  (void)mCallingThread->IsOnCurrentThread(&onCallingThread);
  NS_ASSERTION(onCallingThread, "runEvent not running on the calling thread!");
#endif

  // We do not need to acquire mMutex here because it can only ever be written
  // to on the calling thread, and the only thread that can call us is the
  // calling thread, so we know that our access is serialized.
  return !mCancelRequested;
}

bool
AsyncExecuteStatements::bindExecuteAndProcessStatement(StatementData &aData,
                                                       bool aLastStatement)
{
  mMutex.AssertNotCurrentThreadOwns();

  sqlite3_stmt *aStatement = nullptr;
  // This cannot fail; we are only called if it's available.
  (void)aData.getSqliteStatement(&aStatement);
  NS_ASSERTION(aStatement, "You broke the code; do not call here like that!");
  BindingParamsArray *paramsArray(aData);

  // Iterate through all of our parameters, bind them, and execute.
  bool continueProcessing = true;
  BindingParamsArray::iterator itr = paramsArray->begin();
  BindingParamsArray::iterator end = paramsArray->end();
  while (itr != end && continueProcessing) {
    // Bind the data to our statement.
    nsCOMPtr<IStorageBindingParamsInternal> bindingInternal = 
      do_QueryInterface(*itr);
    nsCOMPtr<mozIStorageError> error = bindingInternal->bind(aStatement);
    if (error) {
      // Set our error state.
      mState = ERROR;

      // And notify.
      (void)notifyError(error);
      return false;
    }

    // Advance our iterator, execute, and then process the statement.
    itr++;
    bool lastStatement = aLastStatement && itr == end;
    continueProcessing = executeAndProcessStatement(aStatement, lastStatement);

    // Always reset our statement.
    (void)::sqlite3_reset(aStatement);
  }

  return continueProcessing;
}

bool
AsyncExecuteStatements::executeAndProcessStatement(sqlite3_stmt *aStatement,
                                                   bool aLastStatement)
{
  mMutex.AssertNotCurrentThreadOwns();

  // Execute our statement
  bool hasResults;
  do {
    hasResults = executeStatement(aStatement);

    // If we had an error, bail.
    if (mState == ERROR)
      return false;

    // If we have been canceled, there is no point in going on...
    {
      MutexAutoLock lockedScope(mMutex);
      if (mCancelRequested) {
        mState = CANCELED;
        return false;
      }
    }

    // Build our result set and notify if we got anything back and have a
    // callback to notify.
    if (mCallback && hasResults &&
        NS_FAILED(buildAndNotifyResults(aStatement))) {
      // We had an error notifying, so we notify on error and stop processing.
      mState = ERROR;

      // Notify, and stop processing statements.
      (void)notifyError(mozIStorageError::ERROR,
                        "An error occurred while notifying about results");

      return false;
    }
  } while (hasResults);

#ifndef MOZ_STORAGE_SORTWARNING_SQL_DUMP
  if (MOZ_LOG_TEST(gStorageLog, LogLevel::Warning))
#endif
  {
    // Check to make sure that this statement was smart about what it did.
    checkAndLogStatementPerformance(aStatement);
  }

  // If we are done, we need to set our state accordingly while we still hold
  // our mutex.  We would have already returned if we were canceled or had
  // an error at this point.
  if (aLastStatement)
    mState = COMPLETED;

  return true;
}

bool
AsyncExecuteStatements::executeStatement(sqlite3_stmt *aStatement)
{
  mMutex.AssertNotCurrentThreadOwns();
  Telemetry::AutoTimer<Telemetry::MOZ_STORAGE_ASYNC_REQUESTS_MS> finallySendExecutionDuration(mRequestStartDate);
  while (true) {
    // lock the sqlite mutex so sqlite3_errmsg cannot change
    SQLiteMutexAutoLock lockedScope(mDBMutex);

    int rc = mConnection->stepStatement(mNativeConnection, aStatement);
    // Stop if we have no more results.
    if (rc == SQLITE_DONE)
    {
      Telemetry::Accumulate(Telemetry::MOZ_STORAGE_ASYNC_REQUESTS_SUCCESS, true);
      return false;
    }

    // If we got results, we can return now.
    if (rc == SQLITE_ROW)
    {
      Telemetry::Accumulate(Telemetry::MOZ_STORAGE_ASYNC_REQUESTS_SUCCESS, true);
      return true;
    }

    // Some errors are not fatal, and we can handle them and continue.
    if (rc == SQLITE_BUSY) {
      // Don't hold the lock while we call outside our module.
      SQLiteMutexAutoUnlock unlockedScope(mDBMutex);

      // Yield, and try again
      (void)::PR_Sleep(PR_INTERVAL_NO_WAIT);
      continue;
    }

    // Set an error state.
    mState = ERROR;
    Telemetry::Accumulate(Telemetry::MOZ_STORAGE_ASYNC_REQUESTS_SUCCESS, false);

    // Construct the error message before giving up the mutex (which we cannot
    // hold during the call to notifyError).
    nsCOMPtr<mozIStorageError> errorObj(
      new Error(rc, ::sqlite3_errmsg(mNativeConnection))
    );
    // We cannot hold the DB mutex while calling notifyError.
    SQLiteMutexAutoUnlock unlockedScope(mDBMutex);
    (void)notifyError(errorObj);

    // Finally, indicate that we should stop processing.
    return false;
  }
}

nsresult
AsyncExecuteStatements::buildAndNotifyResults(sqlite3_stmt *aStatement)
{
  NS_ASSERTION(mCallback, "Trying to dispatch results without a callback!");
  mMutex.AssertNotCurrentThreadOwns();

  // Build result object if we need it.
  if (!mResultSet)
    mResultSet = new ResultSet();
  NS_ENSURE_TRUE(mResultSet, NS_ERROR_OUT_OF_MEMORY);

  RefPtr<Row> row(new Row());
  NS_ENSURE_TRUE(row, NS_ERROR_OUT_OF_MEMORY);

  nsresult rv = row->initialize(aStatement);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = mResultSet->add(row);
  NS_ENSURE_SUCCESS(rv, rv);

  // If we have hit our maximum number of allowed results, or if we have hit
  // the maximum amount of time we want to wait for results, notify the
  // calling thread about it.
  TimeStamp now = TimeStamp::Now();
  TimeDuration delta = now - mIntervalStart;
  if (mResultSet->rows() >= MAX_ROWS_PER_RESULT || delta > mMaxWait) {
    // Notify the caller
    rv = notifyResults();
    if (NS_FAILED(rv))
      return NS_OK; // we'll try again with the next result

    // Reset our start time
    mIntervalStart = now;
  }

  return NS_OK;
}

nsresult
AsyncExecuteStatements::notifyComplete()
{
  mMutex.AssertNotCurrentThreadOwns();
  NS_ASSERTION(mState != PENDING,
               "Still in a pending state when calling Complete!");

  // Reset our statements before we try to commit or rollback.  If we are
  // canceling and have statements that think they have pending work, the
  // rollback will fail.
  for (uint32_t i = 0; i < mStatements.Length(); i++)
    mStatements[i].reset();

  // Release references to the statement data as soon as possible. If this
  // is the last reference, statements will be finalized immediately on the
  // async thread, hence avoiding several bounces between threads and possible
  // race conditions with AsyncClose().
  mStatements.Clear();

  // Handle our transaction, if we have one
  if (mHasTransaction) {
    if (mState == COMPLETED) {
      nsresult rv = mConnection->commitTransactionInternal(mNativeConnection);
      if (NS_FAILED(rv)) {
        mState = ERROR;
        (void)notifyError(mozIStorageError::ERROR,
                          "Transaction failed to commit");
      }
    }
    else {
      DebugOnly<nsresult> rv =
        mConnection->rollbackTransactionInternal(mNativeConnection);
      NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "Transaction failed to rollback");
    }
    mHasTransaction = false;
  }

  // Always generate a completion notification; it is what guarantees that our
  // destruction does not happen here on the async thread.
  RefPtr<CompletionNotifier> completionEvent =
    new CompletionNotifier(mCallback.forget(), mState);
  // We no longer own mCallback (the CompletionNotifier takes ownership).
  // Make sure we don't delete the event on this thread, since it has
  // other-thread-only members.
  (void)mCallingThread->Dispatch(completionEvent.forget(), NS_DISPATCH_NORMAL);

  return NS_OK;
}

nsresult
AsyncExecuteStatements::notifyError(int32_t aErrorCode,
                                    const char *aMessage)
{
  mMutex.AssertNotCurrentThreadOwns();
  mDBMutex.assertNotCurrentThreadOwns();

  if (!mCallback)
    return NS_OK;

  nsCOMPtr<mozIStorageError> errorObj(new Error(aErrorCode, aMessage));
  NS_ENSURE_TRUE(errorObj, NS_ERROR_OUT_OF_MEMORY);

  return notifyError(errorObj);
}

nsresult
AsyncExecuteStatements::notifyError(mozIStorageError *aError)
{
  mMutex.AssertNotCurrentThreadOwns();
  mDBMutex.assertNotCurrentThreadOwns();

  if (!mCallback)
    return NS_OK;

  RefPtr<ErrorNotifier> notifier =
    new ErrorNotifier(mCallback, aError, this);
  NS_ENSURE_TRUE(notifier, NS_ERROR_OUT_OF_MEMORY);

  // Make sure we don't delete the event on this thread, since it has
  // other-thread-only members.
  return mCallingThread->Dispatch(notifier.forget(), NS_DISPATCH_NORMAL);
}

nsresult
AsyncExecuteStatements::notifyResults()
{
  mMutex.AssertNotCurrentThreadOwns();
  NS_ASSERTION(mCallback, "notifyResults called without a callback!");

  RefPtr<CallbackResultNotifier> notifier =
    new CallbackResultNotifier(mCallback, mResultSet, this);
  NS_ENSURE_TRUE(notifier, NS_ERROR_OUT_OF_MEMORY);

  // Make sure we don't delete the event on this thread, since it has
  // other-thread-only members.
  nsresult rv = mCallingThread->Dispatch(notifier.forget(), NS_DISPATCH_NORMAL);
  if (NS_SUCCEEDED(rv)) {
    // it may be freed here or on the CallingThread
    mResultSet = nullptr; // we no longer own it on success
  }
  return rv;
}

NS_IMPL_ISUPPORTS(
  AsyncExecuteStatements,
  nsIRunnable,
  mozIStoragePendingStatement
)

bool
AsyncExecuteStatements::statementsNeedTransaction()
{
  // If there is more than one write statement, run in a transaction.
  // Additionally, if we have only one statement but it needs a transaction, due
  // to multiple BindingParams, we will wrap it in one.
  for (uint32_t i = 0, transactionsCount = 0; i < mStatements.Length(); ++i) {
    transactionsCount += mStatements[i].needsTransaction();
    if (transactionsCount > 1) {
      return true;
    }
  }
  return false;
}

////////////////////////////////////////////////////////////////////////////////
//// mozIStoragePendingStatement

NS_IMETHODIMP
AsyncExecuteStatements::Cancel()
{
#ifdef DEBUG
  bool onCallingThread = false;
  (void)mCallingThread->IsOnCurrentThread(&onCallingThread);
  NS_ASSERTION(onCallingThread, "Not canceling from the calling thread!");
#endif

  // If we have already canceled, we have an error, but always indicate that
  // we are trying to cancel.
  NS_ENSURE_FALSE(mCancelRequested, NS_ERROR_UNEXPECTED);

  {
    MutexAutoLock lockedScope(mMutex);

    // We need to indicate that we want to try and cancel now.
    mCancelRequested = true;
  }

  return NS_OK;
}

////////////////////////////////////////////////////////////////////////////////
//// nsIRunnable

NS_IMETHODIMP
AsyncExecuteStatements::Run()
{
  MOZ_ASSERT(!mConnection->isClosed());

  // Do not run if we have been canceled.
  {
    MutexAutoLock lockedScope(mMutex);
    if (mCancelRequested)
      mState = CANCELED;
  }
  if (mState == CANCELED)
    return notifyComplete();

  if (statementsNeedTransaction() && mConnection->getAutocommit()) {
    if (NS_SUCCEEDED(mConnection->beginTransactionInternal(mNativeConnection,
                                                           mozIStorageConnection::TRANSACTION_IMMEDIATE))) {
      mHasTransaction = true;
    }
#ifdef DEBUG
    else {
      NS_WARNING("Unable to create a transaction for async execution.");
    }
#endif
  }

  // Execute each statement, giving the callback results if it returns any.
  for (uint32_t i = 0; i < mStatements.Length(); i++) {
    bool finished = (i == (mStatements.Length() - 1));

    sqlite3_stmt *stmt;
    { // lock the sqlite mutex so sqlite3_errmsg cannot change
      SQLiteMutexAutoLock lockedScope(mDBMutex);

      int rc = mStatements[i].getSqliteStatement(&stmt);
      if (rc != SQLITE_OK) {
        // Set our error state.
        mState = ERROR;

        // Build the error object; can't call notifyError with the lock held
        nsCOMPtr<mozIStorageError> errorObj(
          new Error(rc, ::sqlite3_errmsg(mNativeConnection))
        );
        {
          // We cannot hold the DB mutex and call notifyError.
          SQLiteMutexAutoUnlock unlockedScope(mDBMutex);
          (void)notifyError(errorObj);
        }
        break;
      }
    }

    // If we have parameters to bind, bind them, execute, and process.
    if (mStatements[i].hasParametersToBeBound()) {
      if (!bindExecuteAndProcessStatement(mStatements[i], finished))
        break;
    }
    // Otherwise, just execute and process the statement.
    else if (!executeAndProcessStatement(stmt, finished)) {
      break;
    }
  }

  // If we still have results that we haven't notified about, take care of
  // them now.
  if (mResultSet)
    (void)notifyResults();

  // Notify about completion
  return notifyComplete();
}

} // namespace storage
} // namespace mozilla
