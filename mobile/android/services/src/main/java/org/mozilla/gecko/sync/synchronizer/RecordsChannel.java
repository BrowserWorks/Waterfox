/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.sync.synchronizer;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.VisibleForTesting;

import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.atomic.AtomicInteger;

import org.mozilla.gecko.background.common.log.Logger;
import org.mozilla.gecko.sync.ReflowIsNecessaryException;
import org.mozilla.gecko.sync.ThreadPool;
import org.mozilla.gecko.sync.repositories.InvalidSessionTransitionException;
import org.mozilla.gecko.sync.repositories.NoStoreDelegateException;
import org.mozilla.gecko.sync.repositories.RepositorySession;
import org.mozilla.gecko.sync.repositories.delegates.DeferredRepositorySessionBeginDelegate;
import org.mozilla.gecko.sync.repositories.delegates.DeferredRepositorySessionStoreDelegate;
import org.mozilla.gecko.sync.repositories.delegates.RepositorySessionBeginDelegate;
import org.mozilla.gecko.sync.repositories.delegates.RepositorySessionFetchRecordsDelegate;
import org.mozilla.gecko.sync.repositories.delegates.RepositorySessionStoreDelegate;
import org.mozilla.gecko.sync.repositories.domain.Record;

/**
 * Pulls records from `source`, applying them to `sink`.
 * Notifies its delegate of errors and completion.
 *
 * All stores (initiated by a fetch) must have been completed before storeDone
 * is invoked on the sink. This is to avoid the existing stored items being
 * considered as the total set, with onStoreCompleted being called when they're
 * done:
 *
 *   store(A) store(B)
 *   store(C) storeDone()
 *   store(A) finishes. Store job begins.
 *   store(C) finishes. Store job begins.
 *   storeDone() finishes.
 *   Storing of A complete.
 *   Storing of C complete.
 *   We're done! Call onStoreCompleted.
 *   store(B) finishes... uh oh.
 *
 * In other words, storeDone must be gated on the synchronous invocation of every store.
 *
 * Similarly, we require that every store callback have returned before onStoreCompleted is invoked.
 *
 * This whole set of guarantees should be achievable thusly:
 *
 * * The fetch process must run in a single thread, and invoke store()
 *   synchronously. After processing every incoming record, storeDone is called,
 *   setting a flag.
 *   If the fetch cannot be implicitly queued, it must be explicitly queued.
 *   In this implementation, we assume that fetch callbacks are strictly ordered in this way.
 *
 * * The store process must be (implicitly or explicitly) queued. When the
 *   queue empties, the consumer checks the storeDone flag. If it's set, and the
 *   queue is exhausted, invoke onStoreCompleted.
 *
 * RecordsChannel exists to enforce this ordering of operations.
 *
 * @author rnewman
 *
 */
public class RecordsChannel implements
  RepositorySessionFetchRecordsDelegate,
  RepositorySessionStoreDelegate,
  RecordsConsumerDelegate,
  RepositorySessionBeginDelegate {

  private static final String LOG_TAG = "RecordsChannel";
  public RepositorySession source;
  private RepositorySession sink;
  private final RecordsChannelDelegate delegate;
  private long fetchEnd = -1;

  private volatile ReflowIsNecessaryException reflowException;

  private final AtomicInteger fetchedCount = new AtomicInteger();
  private final AtomicInteger fetchFailedCount = new AtomicInteger();

  // Expected value relationships:
  // attempted = accepted + failed
  // reconciled <= accepted <= attempted
  // reconciled = accepted - `new`, where `new` is inferred.
  private final AtomicInteger storeAttemptedCount = new AtomicInteger();
  private final AtomicInteger storeAcceptedCount = new AtomicInteger();
  private final AtomicInteger storeFailedCount = new AtomicInteger();
  private final AtomicInteger storeReconciledCount = new AtomicInteger();

  public RecordsChannel(RepositorySession source, RepositorySession sink, RecordsChannelDelegate delegate) {
    this.source    = source;
    this.sink      = sink;
    this.delegate  = delegate;
  }

  /*
   * We push fetched records into a queue.
   * A separate thread is waiting for us to notify it of work to do.
   * When we tell it to stop, it'll stop. We do that when the fetch
   * is completed.
   * When it stops, we tell the sink that there are no more records,
   * and wait for the sink to tell us that storing is done.
   * Then we notify our delegate of completion.
   */
  private RecordConsumer consumer;
  private volatile boolean waitingForQueueDone = false;
  private final ConcurrentLinkedQueue<Record> toProcess = new ConcurrentLinkedQueue<Record>();

  @Override
  public ConcurrentLinkedQueue<Record> getQueue() {
    return toProcess;
  }

  protected boolean isReady() {
    return source.isActive() && sink.isActive();
  }

  /**
   * Get the number of records fetched so far.
   *
   * @return number of fetches.
   */
  public int getFetchCount() {
    return fetchedCount.get();
  }

  /**
   * Get the number of fetch failures recorded so far.
   *
   * @return number of fetch failures.
   */
  public int getFetchFailureCount() {
    return fetchFailedCount.get();
  }

  /**
   * Get the number of store attempts (successful or not) so far.
   *
   * @return number of stores attempted.
   */
  public int getStoreAttemptedCount() {
    return storeAttemptedCount.get();
  }

  public int getStoreAcceptedCount() {
    return storeAcceptedCount.get();
  }

  /**
   * Get the number of store failures recorded so far.
   *
   * @return number of store failures.
   */
  public int getStoreFailureCount() {
    return storeFailedCount.get();
  }

  public int getStoreReconciledCount() {
    return storeReconciledCount.get();
  }

  /**
   * Start records flowing through the channel.
   */
  public void flow() {
    if (!isReady()) {
      RepositorySession failed = source;
      if (source.isActive()) {
        failed = sink;
      }
      this.delegate.onFlowBeginFailed(this, new SessionNotBegunException(failed));
      return;
    }

    if (!source.dataAvailable()) {
      Logger.info(LOG_TAG, "No data available: short-circuiting flow from source " + source);
      long now = System.currentTimeMillis();
      this.delegate.onFlowCompleted(this, now, now);
      return;
    }

    sink.setStoreDelegate(this);
    fetchedCount.set(0);
    fetchFailedCount.set(0);
    storeAttemptedCount.set(0);
    storeAcceptedCount.set(0);
    storeFailedCount.set(0);
    storeReconciledCount.set(0);
    // Start a consumer thread.
    this.consumer = new ConcurrentRecordConsumer(this);
    ThreadPool.run(this.consumer);
    waitingForQueueDone = true;
    source.fetchSince(source.getLastSyncTimestamp(), this);
  }

  /**
   * Begin both sessions, invoking flow() when done.
   * @throws InvalidSessionTransitionException
   */
  public void beginAndFlow() throws InvalidSessionTransitionException {
    Logger.trace(LOG_TAG, "Beginning source.");
    source.begin(this);
  }

  @Override
  public void store(Record record) {
    storeAttemptedCount.incrementAndGet();
    try {
      sink.store(record);
    } catch (NoStoreDelegateException e) {
      Logger.error(LOG_TAG, "Got NoStoreDelegateException in RecordsChannel.store(). This should not occur. Aborting.", e);
      delegate.onFlowStoreFailed(this, e, record.guid);
    }
  }

  @Override
  public void onFetchFailed(Exception ex) {
    Logger.warn(LOG_TAG, "onFetchFailed. Calling for immediate stop.", ex);
    fetchFailedCount.incrementAndGet();
    if (ex instanceof ReflowIsNecessaryException) {
      setReflowException((ReflowIsNecessaryException) ex);
    }
    delegate.onFlowFetchFailed(this, ex);
    // Sink will be informed once consumer finishes.
    this.consumer.halt();
  }

  @Override
  public void onFetchedRecord(Record record) {
    fetchedCount.incrementAndGet();
    this.toProcess.add(record);
    this.consumer.doNotify();
  }

  @Override
  public void onFetchCompleted(final long fetchEnd) {
    Logger.trace(LOG_TAG, "onFetchCompleted. Stopping consumer once stores are done.");
    Logger.trace(LOG_TAG, "Fetch timestamp is " + fetchEnd);
    this.fetchEnd = fetchEnd;
    this.consumer.queueFilled();
  }

  @Override
  public void onBatchCompleted() {
    this.sink.storeFlush();
  }

  @Override
  public void onRecordStoreFailed(Exception ex, String recordGuid) {
    Logger.trace(LOG_TAG, "Failed to store record with guid " + recordGuid);
    storeFailedCount.incrementAndGet();
    this.consumer.stored();
    delegate.onFlowStoreFailed(this, ex, recordGuid);
    // TODO: abort?
  }

  @Override
  public void onRecordStoreSucceeded(String guid) {
    Logger.trace(LOG_TAG, "Stored record with guid " + guid);
    storeAcceptedCount.incrementAndGet();
    this.consumer.stored();
  }

  @Override
  public void onRecordStoreReconciled(String guid) {
    Logger.trace(LOG_TAG, "Reconciled record with guid " + guid);
    storeReconciledCount.incrementAndGet();
  }

  @Override
  public void consumerIsDoneFull() {
    Logger.trace(LOG_TAG, "Consumer is done, processed all records. Are we waiting for it? " + waitingForQueueDone);
    if (waitingForQueueDone) {
      waitingForQueueDone = false;

      // Now we'll be waiting for sink to call its delegate's onStoreCompleted or onStoreFailed.
      this.sink.storeDone();
    }
  }

  @Override
  public void consumerIsDonePartial() {
    Logger.trace(LOG_TAG, "Consumer is done, processed some records. Are we waiting for it? " + waitingForQueueDone);
    if (waitingForQueueDone) {
      waitingForQueueDone = false;

      // Let sink clean up or flush records if necessary.
      this.sink.storeIncomplete();

      delegate.onFlowCompleted(this, fetchEnd, System.currentTimeMillis());
    }
  }

  @Override
  public void onStoreCompleted(long storeEnd) {
    Logger.trace(LOG_TAG, "onStoreCompleted. Notifying delegate of onFlowCompleted. " +
                          "Fetch end is " + fetchEnd + ", store end is " + storeEnd);
    // Source might have used caches used to facilitate flow of records, so now is a good
    // time to clean up. Particularly pertinent for buffered sources.
    // Rephrasing this in a more concrete way, buffers are cleared only once records have been merged
    // locally and results of the merge have been uploaded to the server successfully.
    this.source.performCleanup();
    delegate.onFlowCompleted(this, fetchEnd, storeEnd);

  }

  @Override
  public void onStoreFailed(Exception ex) {
    Logger.warn(LOG_TAG, "onStoreFailed. Calling for immediate stop.", ex);
    if (ex instanceof ReflowIsNecessaryException) {
      setReflowException((ReflowIsNecessaryException) ex);
    }

    // NB: consumer might or might not be running at this point. There are two cases here:
    // 1) If we're storing records remotely, we might fail due to a 412.
    // -- we might hit 412 at any point, so consumer might be in either state.
    // Action: ignore consumer state, we have nothing else to do other to inform our delegate
    // that we're done with this flow. Based on the reflow exception, it'll determine what to do.

    // 2) If we're storing (merging) records locally, we might fail due to a sync deadline.
    // -- we might hit a deadline only prior to attempting to merge records,
    // -- at which point consumer would have finished already, and storeDone was called.
    // Action: consumer state is known (done), so we can ignore it safely and inform our delegate
    // that we're done.

    // Prevent "once consumer is done..." actions from taking place. They already have (case 2), or
    // we don't need them (case 1).
    waitingForQueueDone = false;

    // If consumer is still going at it, tell it to stop.
    this.consumer.halt();

    delegate.onFlowStoreFailed(this, ex, null);
    delegate.onFlowCompleted(this, fetchEnd, System.currentTimeMillis());
  }

  @Override
  public void onBeginFailed(Exception ex) {
    delegate.onFlowBeginFailed(this, ex);
  }

  @Override
  public void onBeginSucceeded(RepositorySession session) {
    if (session == source) {
      Logger.trace(LOG_TAG, "Source session began. Beginning sink session.");
      try {
        sink.begin(this);
      } catch (InvalidSessionTransitionException e) {
        onBeginFailed(e);
        return;
      }
    }
    if (session == sink) {
      Logger.trace(LOG_TAG, "Sink session began. Beginning flow.");
      this.flow();
      return;
    }

    // TODO: error!
  }

  @Override
  public RepositorySessionStoreDelegate deferredStoreDelegate(final ExecutorService executor) {
    return new DeferredRepositorySessionStoreDelegate(this, executor);
  }

  @Override
  public RepositorySessionBeginDelegate deferredBeginDelegate(final ExecutorService executor) {
    return new DeferredRepositorySessionBeginDelegate(this, executor);
  }

  @Override
  public RepositorySessionFetchRecordsDelegate deferredFetchDelegate(ExecutorService executor) {
    // Lie outright. We know that all of our fetch methods are safe.
    return this;
  }

  @Nullable
  public synchronized ReflowIsNecessaryException getReflowException() {
    return reflowException;
  }

  private synchronized void setReflowException(@NonNull ReflowIsNecessaryException e) {
    // It is a mistake to set reflow exception multiple times.
    if (reflowException != null) {
      throw new IllegalStateException("Reflow exception already set: " + reflowException);
    }
    reflowException = e;
  }
}
