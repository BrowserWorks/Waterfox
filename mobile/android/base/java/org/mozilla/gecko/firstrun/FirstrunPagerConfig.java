/* -*- Mode: Java; c-basic-offset: 4; tab-width: 4; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.firstrun;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import org.mozilla.gecko.GeckoSharedPrefs;
import org.mozilla.gecko.R;
import org.mozilla.gecko.Telemetry;
import org.mozilla.gecko.TelemetryContract;
import org.mozilla.gecko.Experiments;

import java.util.LinkedList;
import java.util.List;

public class FirstrunPagerConfig {
    public static final String LOGTAG = "FirstrunPagerConfig";

    public static final String KEY_IMAGE = "imageRes";
    public static final String KEY_TEXT = "textRes";
    public static final String KEY_SUBTEXT = "subtextRes";

   public static List<FirstrunPanelConfig> getDefault(Context context) {
        final List<FirstrunPanelConfig> panels = new LinkedList<>();

            panels.add(SimplePanelConfigs.urlbarPanelConfig);
            panels.add(SimplePanelConfigs.bookmarksPanelConfig);
            panels.add(SimplePanelConfigs.dataPanelConfig);
            panels.add(SimplePanelConfigs.syncPanelConfig);
            panels.add(SimplePanelConfigs.signInPanelConfig);
            Telemetry.startUISession(TelemetryContract.Session.EXPERIMENT, Experiments.ONBOARDING3_B);
            GeckoSharedPrefs.forProfile(context).edit().putString(Experiments.PREF_ONBOARDING_VERSION, Experiments.ONBOARDING3_B).apply();
        return panels;
    }

    public static List<FirstrunPanelConfig> getRestricted() {
        final List<FirstrunPanelConfig> panels = new LinkedList<>();
        panels.add(new FirstrunPanelConfig(RestrictedWelcomePanel.class.getName(), RestrictedWelcomePanel.TITLE_RES));
        return panels;
    }

    public static class FirstrunPanelConfig {

        private String classname;
        private int titleRes;
        private Bundle args;

        public FirstrunPanelConfig(String resource, int titleRes) {
            this(resource, titleRes, -1, -1, -1, true);
        }

        public FirstrunPanelConfig(String classname, int titleRes, int imageRes, int textRes, int subtextRes) {
            this(classname, titleRes, imageRes, textRes, subtextRes, false);
        }

        private FirstrunPanelConfig(String classname, int titleRes, int imageRes, int textRes, int subtextRes, boolean isCustom) {
            this.classname = classname;
            this.titleRes = titleRes;

            if (!isCustom) {
                this.args = new Bundle();
                this.args.putInt(KEY_IMAGE, imageRes);
                this.args.putInt(KEY_TEXT, textRes);
                this.args.putInt(KEY_SUBTEXT, subtextRes);
            }
        }

        public String getClassname() {
            return this.classname;
        }

        public int getTitleRes() {
            return this.titleRes;
        }

        public Bundle getArgs() {
            return args;
        }
    }

    private static class SimplePanelConfigs {
        public static final FirstrunPanelConfig urlbarPanelConfig = new FirstrunPanelConfig(FirstrunPanel.class.getName(), R.string.firstrun_panel_title_welcome, R.drawable.firstrun_urlbar, R.string.firstrun_urlbar_message, R.string.firstrun_urlbar_subtext);
        public static final FirstrunPanelConfig bookmarksPanelConfig = new FirstrunPanelConfig(FirstrunPanel.class.getName(), R.string.firstrun_bookmarks_title, R.drawable.firstrun_bookmarks, R.string.firstrun_bookmarks_message, R.string.firstrun_bookmarks_subtext);
        public static final FirstrunPanelConfig dataPanelConfig = new FirstrunPanelConfig(DataPanel.class.getName(), R.string.firstrun_data_title, R.drawable.firstrun_data_off, R.string.firstrun_data_message, R.string.firstrun_data_subtext);
        public static final FirstrunPanelConfig syncPanelConfig = new FirstrunPanelConfig(FirstrunPanel.class.getName(), R.string.firstrun_sync_title, R.drawable.firstrun_sync, R.string.firstrun_sync_message, R.string.firstrun_sync_subtext);
        public static final FirstrunPanelConfig signInPanelConfig = new FirstrunPanelConfig(SyncPanel.class.getName(), R.string.pref_sync, R.drawable.firstrun_signin, R.string.firstrun_signin_message, R.string.firstrun_welcome_button_browser);

        public static final FirstrunPanelConfig tabqueuePanelConfig = new FirstrunPanelConfig(TabQueuePanel.class.getName(), R.string.firstrun_tabqueue_title, R.drawable.firstrun_tabqueue_off, R.string.firstrun_tabqueue_message_off, R.string.firstrun_tabqueue_subtext_off);
        public static final FirstrunPanelConfig readerviewPanelConfig = new FirstrunPanelConfig(FirstrunPanel.class.getName(), R.string.firstrun_readerview_title, R.drawable.firstrun_readerview, R.string.firstrun_readerview_message, R.string.firstrun_readerview_subtext);
        public static final FirstrunPanelConfig accountPanelConfig = new FirstrunPanelConfig(SyncPanel.class.getName(), R.string.firstrun_account_title, R.drawable.firstrun_account, R.string.firstrun_account_message, R.string.firstrun_button_notnow);
    }
}
