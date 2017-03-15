/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.preferences;

import android.content.Context;
import android.preference.Preference;
import android.util.AttributeSet;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.mozilla.gecko.EventDispatcher;
import org.mozilla.gecko.GeckoApp;
import org.mozilla.gecko.GeckoAppShell;
import org.mozilla.gecko.Telemetry;
import org.mozilla.gecko.TelemetryContract;
import org.mozilla.gecko.TelemetryContract.Method;
import org.mozilla.gecko.util.GeckoEventListener;
import org.mozilla.gecko.util.ThreadUtils;

public class SearchPreferenceCategory extends CustomListCategory implements GeckoEventListener {
    public static final String LOGTAG = "SearchPrefCategory";

    public SearchPreferenceCategory(Context context) {
        super(context);
    }

    public SearchPreferenceCategory(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public SearchPreferenceCategory(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    protected void onAttachedToActivity() {
        super.onAttachedToActivity();

        // Register for SearchEngines messages and request list of search engines from Gecko.
        GeckoApp.getEventDispatcher().registerGeckoThreadListener(this, "SearchEngines:Data");
        GeckoAppShell.notifyObservers("SearchEngines:GetVisible", null);
    }

    @Override
    protected void onPrepareForRemoval() {
        super.onPrepareForRemoval();

        GeckoApp.getEventDispatcher().unregisterGeckoThreadListener(this, "SearchEngines:Data");
    }

    @Override
    public void setDefault(CustomListPreference item) {
        super.setDefault(item);

        sendGeckoEngineEvent("SearchEngines:SetDefault", item.getTitle().toString());

        final String identifier = ((SearchEnginePreference) item).getIdentifier();
        Telemetry.sendUIEvent(TelemetryContract.Event.SEARCH_SET_DEFAULT, Method.DIALOG, identifier);
    }

    @Override
    public void uninstall(CustomListPreference item) {
        super.uninstall(item);

        sendGeckoEngineEvent("SearchEngines:Remove", item.getTitle().toString());

        final String identifier = ((SearchEnginePreference) item).getIdentifier();
        Telemetry.sendUIEvent(TelemetryContract.Event.SEARCH_REMOVE, Method.DIALOG, identifier);
    }

    @Override
    public void handleMessage(String event, final JSONObject data) {
        if (event.equals("SearchEngines:Data")) {
            // Parse engines array from JSON.
            JSONArray engines;
            try {
                engines = data.getJSONArray("searchEngines");
            } catch (JSONException e) {
                Log.e(LOGTAG, "Unable to decode search engine data from Gecko.", e);
                return;
            }

            // Clear the preferences category from this thread.
            this.removeAll();

            // Create an element in this PreferenceCategory for each engine.
            for (int i = 0; i < engines.length(); i++) {
                try {
                    final JSONObject engineJSON = engines.getJSONObject(i);

                    final SearchEnginePreference enginePreference = new SearchEnginePreference(getContext(), this);
                    enginePreference.setSearchEngineFromJSON(engineJSON);
                    enginePreference.setOnPreferenceClickListener(new OnPreferenceClickListener() {
                        @Override
                        public boolean onPreferenceClick(Preference preference) {
                            SearchEnginePreference sPref = (SearchEnginePreference) preference;
                            // Display the configuration dialog associated with the tapped engine.
                            sPref.showDialog();
                            return true;
                        }
                    });

                    addPreference(enginePreference);

                    // The first element in the array is the default engine.
                    if (i == 0) {
                        // We set this here, not in setSearchEngineFromJSON, because it allows us to
                        // keep a reference  to the default engine to use when the AlertDialog
                        // callbacks are used.
                        ThreadUtils.postToUiThread(new Runnable() {
                            @Override
                            public void run() {
                                enginePreference.setIsDefault(true);
                            }
                        });
                        mDefaultReference = enginePreference;
                    }
                } catch (JSONException e) {
                    Log.e(LOGTAG, "JSONException parsing engine at index " + i, e);
                }
            }
        }
    }

    /**
     * Helper method to send a particular event string to Gecko with an associated engine name.
     * @param event The type of event to send.
     * @param engine The engine to which the event relates.
     */
    private void sendGeckoEngineEvent(String event, String engineName) {
        JSONObject json = new JSONObject();
        try {
            json.put("engine", engineName);
        } catch (JSONException e) {
            Log.e(LOGTAG, "JSONException creating search engine configuration change message for Gecko.", e);
            return;
        }
        GeckoAppShell.notifyObservers(event, json.toString());
    }
}
