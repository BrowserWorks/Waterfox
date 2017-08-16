/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko;

import android.support.v7.app.AppCompatActivity;

public abstract class GeckoActivity extends AppCompatActivity {
    /**
     * Display any resources that show strings or encompass locale-specific
     * representations.
     *
     * onLocaleReady must always be called on the UI thread.
     */
    public void onLocaleReady(final String locale) {
    }

    @Override
    public void onCreate(android.os.Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (AppConstants.MOZ_ANDROID_ANR_REPORTER) {
            ANRReporter.register(getApplicationContext());
        }
    }

    @Override
    public void onDestroy() {
        if (AppConstants.MOZ_ANDROID_ANR_REPORTER) {
            ANRReporter.unregister();
        }
        super.onDestroy();
    }

    public boolean isApplicationInBackground() {
        return ((GeckoApplication) getApplication()).isApplicationInBackground();
    }
}
