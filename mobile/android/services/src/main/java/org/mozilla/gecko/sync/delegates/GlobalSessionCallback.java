/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.sync.delegates;

import java.net.URI;

import org.mozilla.gecko.sync.GlobalSession;
import org.mozilla.gecko.sync.stage.GlobalSyncStage.Stage;

public interface GlobalSessionCallback {
  /**
   * Request that no further syncs occur within the next `backoff` milliseconds.
   * @param backoff a duration in milliseconds.
   */
  void requestBackoff(long backoff);

  /**
   * Called on a 401 HTTP response.
   */
  void informUnauthorizedResponse(GlobalSession globalSession, URI oldClusterURL);


  /**
   * Called when an HTTP failure indicates that a software upgrade is required.
   */
  void informUpgradeRequiredResponse(GlobalSession session);

  /**
   * Called when a migration sentinel has been found and processed successfully.
   * <p>
   * This account should stop syncing immediately, and arrange to delete itself.
   */
  void informMigrated(GlobalSession session);

  void handleAborted(GlobalSession globalSession, String reason);
  void handleError(GlobalSession globalSession, Exception ex, String reason);
  void handleSuccess(GlobalSession globalSession);
  void handleStageCompleted(Stage currentState, GlobalSession globalSession);
  void handleIncompleteStage(Stage currentState, GlobalSession globalSession);
  void handleFullSyncNecessary();

  /**
   * Called when a {@link GlobalSession} wants to know if it should continue
   * to make storage requests.
   *
   * @return false if the session should make no further requests.
   */
  boolean shouldBackOffStorage();
}
