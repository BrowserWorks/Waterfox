/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.bookmarks;

import android.app.Activity;
import android.content.ContentResolver;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;

import org.mozilla.gecko.R;
import org.mozilla.gecko.SnackbarBuilder;
import org.mozilla.gecko.Telemetry;
import org.mozilla.gecko.TelemetryContract;
import org.mozilla.gecko.db.BrowserContract;
import org.mozilla.gecko.db.BrowserDB;
import org.mozilla.gecko.util.ThreadUtils;
import org.mozilla.gecko.util.UIAsyncTask;

import java.lang.ref.WeakReference;

public class EditBookmarkTask extends UIAsyncTask.WithoutParams<Void> {
    private final WeakReference<Activity> activityWeakReference;
    private final BrowserDB db;
    private final ContentResolver contentResolver;
    private final Bundle bundle;

    public EditBookmarkTask(Activity activity, @NonNull Bundle bundle) {
        super(ThreadUtils.getBackgroundHandler());

        this.activityWeakReference = new WeakReference<>(activity);
        this.db = BrowserDB.from(activity);
        this.contentResolver = activity.getContentResolver();
        this.bundle = bundle;
    }

    @Override
    public Void doInBackground() {
        final long bookmarkId = bundle.getLong(BrowserContract.Bookmarks._ID);
        final String url = bundle.getString(BrowserContract.Bookmarks.URL);
        final String title = bundle.getString(BrowserContract.Bookmarks.TITLE);
        final String keyword = bundle.getString(BrowserContract.Bookmarks.KEYWORD);
        final int type = bundle.getInt(BrowserContract.Bookmarks.TYPE);

        boolean parentChanged = false;
        if (bundle.containsKey(BrowserContract.Bookmarks.PARENT) &&
            bundle.containsKey(BrowserContract.PARAM_OLD_BOOKMARK_PARENT)) {
            final long newParentId = bundle.getLong(BrowserContract.Bookmarks.PARENT);
            final long oldParentId = bundle.getLong(BrowserContract.PARAM_OLD_BOOKMARK_PARENT);
            db.updateBookmark(contentResolver, bookmarkId, url, title, keyword, newParentId, oldParentId);
            parentChanged = true;
        } else {
            db.updateBookmark(contentResolver, bookmarkId, url, title, keyword);
        }

        String extras;
        if (type == BrowserContract.Bookmarks.TYPE_FOLDER) {
            extras = "bookmark_folder";
        } else {
            extras = "bookmark";
        }
        if (parentChanged) {
            extras += "_parent_changed";
        }
        Telemetry.sendUIEvent(TelemetryContract.Event.EDIT, TelemetryContract.Method.DIALOG, extras);

        return null;
    }

    @Override
    public void onPostExecute(Void result) {
        final Activity activity = activityWeakReference.get();
        if (activity == null || activity.isFinishing()) {
            return;
        }

        SnackbarBuilder.builder(activity)
                .message(R.string.bookmark_updated)
                .duration(Snackbar.LENGTH_LONG)
                .buildAndShow();
    }
}
