/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.sync.stage;

import java.net.URISyntaxException;

import org.mozilla.gecko.sync.MetaGlobalException;
import org.mozilla.gecko.sync.repositories.ConstrainedServer11Repository;
import org.mozilla.gecko.sync.repositories.RecordFactory;
import org.mozilla.gecko.sync.repositories.Repository;
import org.mozilla.gecko.sync.repositories.android.AndroidBrowserHistoryRepository;
import org.mozilla.gecko.sync.repositories.domain.HistoryRecordFactory;
import org.mozilla.gecko.sync.repositories.domain.VersionConstants;

public class AndroidBrowserHistoryServerSyncStage extends ServerSyncStage {
  protected static final String LOG_TAG = "HistoryStage";

  // Eventually this kind of sync stage will be data-driven,
  // and all this hard-coding can go away.
  private static final String HISTORY_SORT          = "index";
  // Sanity limit. Batch and total limit are the same for now, and will be adjusted
  // once buffer and high water mark are in place. See Bug 730142.
  private static final long HISTORY_BATCH_LIMIT = 250;
  private static final long HISTORY_TOTAL_LIMIT = 250;

  @Override
  protected String getCollection() {
    return "history";
  }

  @Override
  protected String getEngineName() {
    return "history";
  }

  @Override
  public Integer getStorageVersion() {
    return VersionConstants.HISTORY_ENGINE_VERSION;
  }

  @Override
  protected Repository getLocalRepository() {
    return new AndroidBrowserHistoryRepository();
  }

  @Override
  protected Repository getRemoteRepository() throws URISyntaxException {
    String collection = getCollection();
    return new ConstrainedServer11Repository(
                                             collection,
                                             session.config.storageURL(),
                                             session.getAuthHeaderProvider(),
                                             session.config.infoCollections,
                                             session.config.infoConfiguration,
                                             HISTORY_BATCH_LIMIT,
                                             HISTORY_TOTAL_LIMIT,
                                             HISTORY_SORT);
  }

  @Override
  protected RecordFactory getRecordFactory() {
    return new HistoryRecordFactory();
  }

  @Override
  protected boolean isEnabled() throws MetaGlobalException {
    if (session == null || session.getContext() == null) {
      return false;
    }
    return super.isEnabled();
  }
}
