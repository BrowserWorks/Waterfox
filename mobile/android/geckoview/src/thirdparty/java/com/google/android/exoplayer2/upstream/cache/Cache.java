/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.android.exoplayer2.upstream.cache;

import java.io.File;
import java.io.IOException;
import java.util.NavigableSet;
import java.util.Set;

/**
 * An interface for cache.
 */
public interface Cache {

  /**
   * Listener of {@link Cache} events.
   */
  interface Listener {

    /**
     * Called when a {@link CacheSpan} is added to the cache.
     *
     * @param cache The source of the event.
     * @param span The added {@link CacheSpan}.
     */
    void onSpanAdded(Cache cache, CacheSpan span);

    /**
     * Called when a {@link CacheSpan} is removed from the cache.
     *
     * @param cache The source of the event.
     * @param span The removed {@link CacheSpan}.
     */
    void onSpanRemoved(Cache cache, CacheSpan span);

    /**
     * Called when an existing {@link CacheSpan} is accessed, causing it to be replaced. The new
     * {@link CacheSpan} is guaranteed to represent the same data as the one it replaces, however
     * {@link CacheSpan#file} and {@link CacheSpan#lastAccessTimestamp} may have changed.
     * <p>
     * Note that for span replacement, {@link #onSpanAdded(Cache, CacheSpan)} and
     * {@link #onSpanRemoved(Cache, CacheSpan)} are not called in addition to this method.
     *
     * @param cache The source of the event.
     * @param oldSpan The old {@link CacheSpan}, which has been removed from the cache.
     * @param newSpan The new {@link CacheSpan}, which has been added to the cache.
     */
    void onSpanTouched(Cache cache, CacheSpan oldSpan, CacheSpan newSpan);

  }
  
  /**
   * Thrown when an error is encountered when writing data.
   */
  class CacheException extends IOException {

    public CacheException(String message) {
      super(message);
    }

    public CacheException(IOException cause) {
      super(cause);
    }

  }

  /**
   * Registers a listener to listen for changes to a given key.
   * <p>
   * No guarantees are made about the thread or threads on which the listener is called, but it is
   * guaranteed that listener methods will be called in a serial fashion (i.e. one at a time) and in
   * the same order as events occurred.
   *
   * @param key The key to listen to.
   * @param listener The listener to add.
   * @return The current spans for the key.
   */
  NavigableSet<CacheSpan> addListener(String key, Listener listener);

  /**
   * Unregisters a listener.
   *
   * @param key The key to stop listening to.
   * @param listener The listener to remove.
   */
  void removeListener(String key, Listener listener);

  /**
   * Returns the cached spans for a given cache key.
   *
   * @param key The key for which spans should be returned.
   * @return The spans for the key. May be null if there are no such spans.
   */
  NavigableSet<CacheSpan> getCachedSpans(String key);

  /**
   * Returns all keys in the cache.
   *
   * @return All the keys in the cache.
   */
  Set<String> getKeys();

  /**
   * Returns the total disk space in bytes used by the cache.
   *
   * @return The total disk space in bytes.
   */
  long getCacheSpace();

  /**
   * A caller should invoke this method when they require data from a given position for a given
   * key.
   * <p>
   * If there is a cache entry that overlaps the position, then the returned {@link CacheSpan}
   * defines the file in which the data is stored. {@link CacheSpan#isCached} is true. The caller
   * may read from the cache file, but does not acquire any locks.
   * <p>
   * If there is no cache entry overlapping {@code offset}, then the returned {@link CacheSpan}
   * defines a hole in the cache starting at {@code position} into which the caller may write as it
   * obtains the data from some other source. The returned {@link CacheSpan} serves as a lock.
   * Whilst the caller holds the lock it may write data into the hole. It may split data into
   * multiple files. When the caller has finished writing a file it should commit it to the cache
   * by calling {@link #commitFile(File)}. When the caller has finished writing, it must release
   * the lock by calling {@link #releaseHoleSpan}.
   *
   * @param key The key of the data being requested.
   * @param position The position of the data being requested.
   * @return The {@link CacheSpan}.
   * @throws InterruptedException
   */
  CacheSpan startReadWrite(String key, long position) throws InterruptedException, CacheException;

  /**
   * Same as {@link #startReadWrite(String, long)}. However, if the cache entry is locked, then
   * instead of blocking, this method will return null as the {@link CacheSpan}.
   *
   * @param key The key of the data being requested.
   * @param position The position of the data being requested.
   * @return The {@link CacheSpan}. Or null if the cache entry is locked.
   */
  CacheSpan startReadWriteNonBlocking(String key, long position) throws CacheException;

  /**
   * Obtains a cache file into which data can be written. Must only be called when holding a
   * corresponding hole {@link CacheSpan} obtained from {@link #startReadWrite(String, long)}.
   *
   * @param key The cache key for the data.
   * @param position The starting position of the data.
   * @param maxLength The maximum length of the data to be written. Used only to ensure that there
   *     is enough space in the cache.
   * @return The file into which data should be written.
   */
  File startFile(String key, long position, long maxLength) throws CacheException;

  /**
   * Commits a file into the cache. Must only be called when holding a corresponding hole
   * {@link CacheSpan} obtained from {@link #startReadWrite(String, long)}
   *
   * @param file A newly written cache file.
   */
  void commitFile(File file) throws CacheException;

  /**
   * Releases a {@link CacheSpan} obtained from {@link #startReadWrite(String, long)} which
   * corresponded to a hole in the cache.
   *
   * @param holeSpan The {@link CacheSpan} being released.
   */
  void releaseHoleSpan(CacheSpan holeSpan);

  /**
   * Removes a cached {@link CacheSpan} from the cache, deleting the underlying file.
   *
   * @param span The {@link CacheSpan} to remove.
   */
  void removeSpan(CacheSpan span) throws CacheException;

 /**
  * Queries if a range is entirely available in the cache.
  *
  * @param key The cache key for the data.
  * @param position The starting position of the data.
  * @param length The length of the data.
  * @return true if the data is available in the Cache otherwise false;
  */
  boolean isCached(String key, long position, long length);

  /**
   * Returns the length of the cached data block starting from the {@code position} to the block end
   * up to {@code length} bytes. If the {@code position} isn't cached then -(the length of the gap
   * to the next cached data up to {@code length} bytes) is returned.
   *
   * @param key The cache key for the data.
   * @param position The starting position of the data.
   * @param length The maximum length of the data to be returned.
   * @return the length of the cached or not cached data block length.
   */
  long getCachedBytes(String key, long position, long length);

  /**
   * Sets the content length for the given key.
   *
   * @param key The cache key for the data.
   * @param length The length of the data.
   */
  void setContentLength(String key, long length) throws CacheException;

  /**
   * Returns the content length for the given key if one set, or {@link
   * com.google.android.exoplayer2.C#LENGTH_UNSET} otherwise.
   *
   * @param key The cache key for the data.
   */
  long getContentLength(String key);

}
