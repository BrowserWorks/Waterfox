/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.sync.net;

import android.support.annotation.Nullable;

import org.mozilla.gecko.sync.Utils;

import ch.boye.httpclientandroidlib.HttpResponse;

public class SyncResponse extends MozResponse {
  public static final String X_WEAVE_BACKOFF = "x-weave-backoff";
  public static final String X_BACKOFF = "x-backoff";
  public static final String X_LAST_MODIFIED = "x-last-modified";
  public static final String X_WEAVE_TIMESTAMP = "x-weave-timestamp";
  public static final String X_WEAVE_RECORDS = "x-weave-records";
  public static final String X_WEAVE_QUOTA_REMAINING = "x-weave-quota-remaining";
  public static final String X_WEAVE_ALERT = "x-weave-alert";
  public static final String X_WEAVE_NEXT_OFFSET = "x-weave-next-offset";

  public SyncResponse(HttpResponse res) {
    super(res);
  }

  /**
   * @return A number of seconds, or -1 if the 'X-Weave-Backoff' header was not
   *         present.
   */
  public int weaveBackoffInSeconds() throws NumberFormatException {
    return this.getIntegerHeader(X_WEAVE_BACKOFF);
  }

  /**
   * @return A number of seconds, or -1 if the 'X-Backoff' header was not
   *         present.
   */
  public int xBackoffInSeconds() throws NumberFormatException {
    return this.getIntegerHeader(X_BACKOFF);
  }

  /**
   * Extract a number of seconds, or -1 if none of the specified headers were present.
   *
   * @param includeRetryAfter
   *          if <code>true</code>, the Retry-After header is excluded. This is
   *          useful for processing non-error responses where a Retry-After
   *          header would be unexpected.
   * @return the maximum of the three possible backoff headers, in seconds.
   */
  public int totalBackoffInSeconds(boolean includeRetryAfter) {
    int retryAfterInSeconds = -1;
    if (includeRetryAfter) {
      try {
        retryAfterInSeconds = retryAfterInSeconds();
      } catch (NumberFormatException e) {
      }
    }

    int weaveBackoffInSeconds = -1;
    try {
      weaveBackoffInSeconds = weaveBackoffInSeconds();
    } catch (NumberFormatException e) {
    }

    int backoffInSeconds = -1;
    try {
      backoffInSeconds = xBackoffInSeconds();
    } catch (NumberFormatException e) {
    }

    int totalBackoff = Math.max(retryAfterInSeconds, Math.max(backoffInSeconds, weaveBackoffInSeconds));
    if (totalBackoff < 0) {
      return -1;
    } else {
      return totalBackoff;
    }
  }

  /**
   * @return A number of milliseconds, or -1 if neither the 'Retry-After',
   *         'X-Backoff', or 'X-Weave-Backoff' header were present.
   */
  public long totalBackoffInMilliseconds() {
    long totalBackoff = totalBackoffInSeconds(true);
    if (totalBackoff < 0) {
      return -1;
    } else {
      return 1000 * totalBackoff;
    }
  }

  public long normalizedWeaveTimestamp() {
    return normalizedTimestampForHeader(X_WEAVE_TIMESTAMP);
  }

  /**
   * Timestamps returned from a Sync server are decimal numbers of seconds,
   * e.g., 1323393518.04.
   *
   * We want milliseconds since epoch.
   *
   * @return milliseconds since the epoch, as a long, or -1 if the header
   *         was missing or invalid.
   */
  public long normalizedTimestampForHeader(String header) {
    if (!this.hasHeader(header)) {
      return -1;
    }

    return Utils.decimalSecondsToMilliseconds(
            this.response.getFirstHeader(header).getValue()
    );
  }

  public int weaveRecords() throws NumberFormatException {
    return this.getIntegerHeader(X_WEAVE_RECORDS);
  }

  public int weaveQuotaRemaining() throws NumberFormatException {
    return this.getIntegerHeader(X_WEAVE_QUOTA_REMAINING);
  }

  public String weaveAlert() {
    return this.getNonMissingHeader(X_WEAVE_ALERT);
  }

  /**
   * This header may be sent back with multi-record responses where the request included a limit parameter.
   * Its presence indicates that the number of available records exceeded the given limit.
   * The value from this header can be passed back in the offset parameter to retrieve additional records.
   * The value of this header will always be a string of characters from the urlsafe-base64 alphabet.
   * The specific contents of the string are an implementation detail of the server,
   * so clients should treat it as an opaque token.
   *
   * @return the offset header
   */
  public String weaveOffset() {
    return this.getNonMissingHeader(X_WEAVE_NEXT_OFFSET);
  }

  /**
   * This header gives the last-modified time of the target resource as seen during processing of the request,
   * and will be included in all success responses (200, 201, 204).
   * When given in response to a write request, this will be equal to the server’s current time and
   * to the new last-modified time of any BSOs created or changed by the request.
   * It is similar to the standard HTTP Last-Modified header,
   * but the value is a decimal timestamp rather than a HTTP-format date.
   *
   * @return the last modified header
   */
  @Nullable
  public String lastModified() {
    return this.getNonMissingHeader(X_LAST_MODIFIED);
  }
}
