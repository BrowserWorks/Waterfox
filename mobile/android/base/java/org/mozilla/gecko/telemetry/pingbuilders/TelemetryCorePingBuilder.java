/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

package org.mozilla.gecko.telemetry.pingbuilders;

import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.WorkerThread;
import android.text.TextUtils;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.mozilla.gecko.AppConstants;
import org.mozilla.gecko.Experiments;
import org.mozilla.gecko.GeckoApp;
import org.mozilla.gecko.GeckoProfile;
import org.mozilla.gecko.GeckoSharedPrefs;
import org.mozilla.gecko.Locales;
import org.mozilla.gecko.PrefsHelper;
import org.mozilla.gecko.R;
import org.mozilla.gecko.Tabs;
import org.mozilla.gecko.activitystream.homepanel.ActivityStreamPanel;
import org.mozilla.gecko.home.HomeConfig;
import org.mozilla.gecko.preferences.GeckoPreferences;
import org.mozilla.gecko.search.SearchEngine;
import org.mozilla.gecko.sync.ExtendedJSONObject;
import org.mozilla.gecko.telemetry.TelemetryOutgoingPing;
import org.mozilla.gecko.util.DateUtil;
import org.mozilla.gecko.util.HardwareUtils;
import org.mozilla.gecko.util.PackageUtil;
import org.mozilla.gecko.util.StringUtils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import static org.mozilla.gecko.home.HomeConfig.PREF_KEY_HISTORY_PANEL_ENABLED;
import static org.mozilla.gecko.home.HomeConfig.PREF_KEY_TOPSITES_PANEL_ENABLED;

/**
 * Builds a {@link TelemetryOutgoingPing} representing a core ping.
 * <p>
 * See https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/core-ping.html
 * for details on the core ping.
 */
public class TelemetryCorePingBuilder extends TelemetryPingBuilder {
    private static final String LOGTAG = StringUtils.safeSubstring(TelemetryCorePingBuilder.class.getSimpleName(), 0, 23);

    // For legacy reasons, this preference key is not namespaced with "core".
    private static final String PREF_SEQ_COUNT = "telemetry-seqCount";

    private static final String NAME = "core";
    private static final int VERSION_VALUE = 10; // For version history, see toolkit/components/telemetry/docs/core-ping.rst

    private static final String DEFAULT_BROWSER = "defaultBrowser";
    private static final String ARCHITECTURE = "arch";
    private static final String CAMPAIGN_ID = "campaignId";
    private static final String CLIENT_ID = "clientId";
    private static final String DEFAULT_SEARCH_ENGINE = "defaultSearch";
    private static final String DEVICE = "device";
    private static final String DISTRIBUTION_ID = "distributionId";
    private static final String DISPLAY_VERSION = "displayVersion";
    private static final String EXPERIMENTS = "experiments";
    private static final String LOCALE = "locale";
    private static final String OS_ATTR = "os";
    private static final String OS_VERSION = "osversion";
    private static final String PING_CREATION_DATE = "created";
    private static final String PROFILE_CREATION_DATE = "profileDate";
    private static final String SEARCH_COUNTS = "searches";
    private static final String SEQ = "seq";
    private static final String SESSION_COUNT = "sessions";
    private static final String FENNEC = "fennec";
    private static final String NEW_TAB = "new_tab";
    private static final String TOP_SITES_CLICKED = "top_sites_clicked";
    private static final String POCKET_STORIES_CLICKED = "pocket_stories_clicked";
    private static final String SETTINGS_ADVANCED = "settings_advanced";
    private static final String RESTORE_TABS = "restore_tabs";
    private static final String SHOW_IMAGES = "show_images";
    private static final String SHOW_WEB_FONTS = "show_web_fonts";
    private static final String SETTINGS_GENERAL = "settings_general";
    private static final String FULL_SCREEN_BROWSING = "full_screen_browsing";
    private static final String TAB_QUEUE = "tab_queue";
    private static final String TAB_QUEUE_USAGE_COUNT = "tab_queue_usage_count";
    private static final String COMPACT_TABS = "compact_tabs";
    private static final String HOMEPAGE = "homepage";
    private static final String CUSTOM_HOMEPAGE = "custom_homepage";
    private static final String CUSTOM_HOMEPAGE_USE_FOR_NEWTAB = "custom_homepage_use_for_newtab";
    private static final String TOPSITES_ENABLED = "topsites_enabled";
    private static final String POCKET_ENABLED = "pocket_enabled";
    private static final String RECENT_BOOKMARKS_ENABLED = "recent_bookmarks_enabled";
    private static final String VISITED_ENABLED = "visited_enabled";
    private static final String BOOKMARKS_ENABLED = "bookmarks_enabled";
    private static final String HISTORY_ENABLED = "history_enabled";
    private static final String SETTINGS_PRIVACY = "settings_privacy";
    private static final String DO_NOT_TRACK = "do_not_track";
    private static final String MASTER_PASSWORD = "master_password";
    private static final String MASTER_PASSWORD_USAGE_COUNT = "master_password_usage_count";
    private static final String SETTINGS_NOTIFICATIONS = "settings_notifications";
    private static final String PRODUCT_FEATURE_TIPS = "product_feature_tips";
    private static final String ADDONS = "addons";
    private static final String ACTIVE = "active";
    private static final String DISABLED = "disabled";
    private static final String PAGE_OPTIONS = "page_options";
    private static final String SAVE_AS_PDF = "save_as_pdf";
    private static final String PRINT = "print";
    private static final String TOTAL_ADDED_SEARCH_ENGINES = "total_added_search_engines";
    private static final String TOTAL_SITES_PINNED_TO_TOPSITES = "total_sites_pinned_to_topsites";
    private static final String VIEW_SOURCE = "view_source";
    private static final String BOOKMARK_WITH_STAR = "bookmark_with_star";
    private static final String SYNC = "sync";
    private static final String ONLY_OVER_WIFI = "only_over_wifi";
    private static final String SESSION_DURATION = "durations";
    private static final String TIMEZONE_OFFSET = "tz";
    private static final String VERSION_ATTR = "v";
    private static final String FLASH_USAGE = "flashUsage";
    private static final String ACCESSIBILITY_SERVICES = "accessibilityServices";
    private static final String HAD_CANARY_CLIENT_ID = "bug_1501329_affected";

    public TelemetryCorePingBuilder(final Context context, int[] settingsAdvanced, boolean[] privacyPrefs, List<String> activeAddons,
                                    List<String> disabledAddons) {
        initPayloadConstants(context, settingsAdvanced, privacyPrefs, activeAddons, disabledAddons);
    }

    private void initPayloadConstants(final Context context, int[] settingsAdvanced, boolean[] privacyPrefs, List<String> activeAddons,
                                      List<String> disabledAddons) {
        payload.put(VERSION_ATTR, VERSION_VALUE);
        payload.put(OS_ATTR, TelemetryPingBuilder.OS_NAME);

        // We limit the device descriptor to 32 characters because it can get long. We give fewer characters to the
        // manufacturer because we're less likely to have manufacturers with similar names than we are for a
        // manufacturer to have two devices with the similar names (e.g. Galaxy S6 vs. Galaxy Note 6).
        final String deviceDescriptor =
                StringUtils.safeSubstring(Build.MANUFACTURER, 0, 12) + '-' + StringUtils.safeSubstring(Build.MODEL, 0, 19);

        final Calendar nowCalendar = Calendar.getInstance();
        final DateFormat pingCreationDateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.US);

        payload.put(DEFAULT_BROWSER, PackageUtil.isDefaultBrowser(context));
        payload.put(ARCHITECTURE, HardwareUtils.getRealAbi());
        payload.put(DEVICE, deviceDescriptor);
        payload.put(LOCALE, Locales.getLanguageTag(Locale.getDefault()));
        payload.put(OS_VERSION, Integer.toString(Build.VERSION.SDK_INT)); // A String for cross-platform reasons.
        payload.put(PING_CREATION_DATE, pingCreationDateFormat.format(nowCalendar.getTime()));
        payload.put(TIMEZONE_OFFSET, DateUtil.getTimezoneOffsetInMinutesForGivenDate(nowCalendar));
        payload.put(DISPLAY_VERSION, AppConstants.MOZ_APP_VERSION_DISPLAY);
        payload.putArray(EXPERIMENTS, Experiments.getActiveExperiments(context));
        synchronized (this) {
            SharedPreferences prefs = GeckoSharedPrefs.forApp(context);
            final int count = prefs.getInt(GeckoApp.PREFS_FLASH_USAGE, 0);
            final int defaultSearchEnginesCount = 6;
            payload.put(FLASH_USAGE, count);
            prefs.edit().putInt(GeckoApp.PREFS_FLASH_USAGE, 0).apply();

            final boolean searchUsed = prefs.getBoolean(GeckoApp.PREFS_ENHANCED_SEARCH_USAGE, false);
            payload.put(GeckoApp.PREFS_ENHANCED_SEARCH_USAGE, searchUsed);
            final boolean searchReady = prefs.getBoolean(GeckoApp.PREFS_ENHANCED_SEARCH_READY, false);
            payload.put(GeckoApp.PREFS_ENHANCED_SEARCH_READY, searchReady);
            final String searchVersion = prefs.getString(GeckoApp.PREFS_ENHANCED_SEARCH_VERSION, "");
            payload.put(GeckoApp.PREFS_ENHANCED_SEARCH_VERSION, searchVersion);
            final int topSitesClicked = prefs.getInt("android.not_a_preference.top_sites_clicked", 0);
            final int pocketStoriesClicked = prefs.getInt("android.not_a_preference.pocket_stories_clicked", 0);
            final boolean fullScreenBrowsing = prefs.getBoolean("browser.chrome.dynamictoolbar", true);
            final boolean tabQueue = prefs.getBoolean("android.not_a_preference.tab_queue", false);
            final int tabQueueUsageCount = prefs.getInt("android.not_a_preference.tab_queue_usage_count", 0);
            final boolean compactTabs = prefs.getBoolean("android.not_a_preference.compact_tabs", true);
            final boolean customHomepage = (Tabs.getHomepage(context) != null && !"about:home".equalsIgnoreCase(Tabs.getHomepage(context)));
            final boolean customHomepageForNewTab = prefs.getBoolean("android.not_a_preference.newtab.load_homepage", false);
            final boolean historyEnabled = GeckoSharedPrefs.forProfile(context).getBoolean(PREF_KEY_HISTORY_PANEL_ENABLED, true);
            final boolean bookmarksEnabled = GeckoSharedPrefs.forProfile(context).getBoolean(HomeConfig.PREF_KEY_BOOKMARKS_PANEL_ENABLED, true);
            final boolean topsitesEnabled = GeckoSharedPrefs.forProfile(context).getBoolean(PREF_KEY_TOPSITES_PANEL_ENABLED, true);
            final boolean pocketEnabled =  GeckoSharedPrefs.forProfile(context).getBoolean("pref_activitystream_pocket_enabled", true);
            final boolean visitedEnabled = GeckoSharedPrefs.forProfile(context).getBoolean("pref_activitystream_visited_enabled", true);
            final boolean recentBookmarksEnabled = GeckoSharedPrefs.forProfile(context).getBoolean("pref_activitystream_recentbookmarks_enabled", true);
            final boolean onlyOverWifi = prefs.getBoolean("sync.restrict_metered", false);
            final boolean productFeatureTipsEnabled = prefs.getBoolean(GeckoPreferences.PREFS_NOTIFICATIONS_FEATURES_TIPS, true);
            final boolean restoreTabs = !"quit".equals(prefs.getString(GeckoPreferences.PREFS_RESTORE_SESSION, "always"));
            final boolean showWebFonts = prefs.getBoolean("browser.display.use_document_fonts", false);
            final int totalSearchEngines = prefs.getInt("android.not_a_preference.total_added_search_engines", 0);
            final int totalAddedSearchEngines = totalSearchEngines > 0 ? totalSearchEngines - defaultSearchEnginesCount : 0;
            final int bookmarksWithStar = prefs.getInt("android.not_a_preference.bookmarks_with_star", 0);
            final int totalSitesPinnedToTopsites = prefs.getInt("android.not_a_preference.total_sites_pinned_to_topsites", 0);
            final int saveAsPdf = prefs.getInt("android.not_a_preference.save_as_pdf", 0);
            final int print = prefs.getInt("android.not_a_preference.print", 0);
            final int viewPageSource = prefs.getInt("android.not_a_preference.view_page_source", 0);
            final String showImages = getShowImages(settingsAdvanced[0]);
            final int masterPasswordUsageCount = prefs.getInt("android.not_a_preference.master_password_usage_count", 0);
            final ExtendedJSONObject fennec = getFennec(getNewTab(topSitesClicked, pocketStoriesClicked),
                    getSettingsAdvanced(restoreTabs, showImages, showWebFonts),
                    getSettingsGeneral(fullScreenBrowsing, tabQueue, tabQueueUsageCount, compactTabs,
                            getHomepage(customHomepage, customHomepageForNewTab,
                                    topsitesEnabled, pocketEnabled, recentBookmarksEnabled,
                                    visitedEnabled, bookmarksEnabled, historyEnabled)),
                    getSettingsPrivacy(privacyPrefs[0], privacyPrefs[1], masterPasswordUsageCount),
                    getSettingsNotifications(productFeatureTipsEnabled),
                    getAddons(activeAddons, disabledAddons),
                    getPageOptions(saveAsPdf, print, totalAddedSearchEngines, totalSitesPinnedToTopsites, viewPageSource, bookmarksWithStar),
                    getSync(onlyOverWifi));
            payload.put(FENNEC, fennec);
            resetCounts(prefs);
        }
    }

    private static void resetCounts(SharedPreferences prefs) {
        prefs.edit().putInt("android.not_a_preference.master_password_usage_count", 0).apply();
        prefs.edit().putInt("android.not_a_preference.tab_queue_usage_count", 0).apply();
        prefs.edit().putInt("android.not_a_preference.top_sites_clicked", 0).apply();
        prefs.edit().putInt("android.not_a_preference.pocket_stories_clicked", 0).apply();
        prefs.edit().putInt("android.not_a_preference.print", 0).apply();
        prefs.edit().putInt("android.not_a_preference.save_as_pdf", 0).apply();
        prefs.edit().putInt("android.not_a_preference.bookmarks_with_star", 0).apply();
        prefs.edit().putInt("android.not_a_preference.view_page_source", 0).apply();
    }

    private static String getShowImages(int showImages) {
        switch (showImages) {
            case 0:
            case 2:
                return "user-specified";
            default:
                return "default";
        }
    }

    @Override
    public String getDocType() {
        return NAME;
    }

    @Override
    public String[] getMandatoryFields() {
        return new String[]{
                ARCHITECTURE,
                CLIENT_ID,
                DEFAULT_SEARCH_ENGINE,
                DEVICE,
                LOCALE,
                OS_ATTR,
                OS_VERSION,
                PING_CREATION_DATE,
                PROFILE_CREATION_DATE,
                SEQ,
                TIMEZONE_OFFSET,
                VERSION_ATTR,
                HAD_CANARY_CLIENT_ID,
                FENNEC
        };
    }

    public TelemetryCorePingBuilder setClientID(@NonNull final String clientID) {
        if (clientID == null) {
            throw new IllegalArgumentException("Expected non-null clientID");
        }
        payload.put(CLIENT_ID, clientID);
        return this;
    }

    public TelemetryCorePingBuilder setHadCanaryClientId(final boolean hadCanaryClientId) {
        payload.put(HAD_CANARY_CLIENT_ID, hadCanaryClientId);
        return this;
    }

    /**
     * @param engine the default search engine identifier, or null if there is an error.
     */
    public TelemetryCorePingBuilder setDefaultSearchEngine(@Nullable final String engine) {
        if (engine != null && engine.isEmpty()) {
            throw new IllegalArgumentException("Received empty string. Expected identifier or null.");
        }
        payload.put(DEFAULT_SEARCH_ENGINE, engine);
        return this;
    }

    public TelemetryCorePingBuilder setOptDistributionID(@NonNull final String distributionID) {
        if (distributionID == null) {
            throw new IllegalArgumentException("Expected non-null distribution ID");
        }
        payload.put(DISTRIBUTION_ID, distributionID);
        return this;
    }

    /**
     * @param searchCounts non-empty JSON with {"engine.where": <int-count>}
     */
    public TelemetryCorePingBuilder setOptSearchCounts(@NonNull final ExtendedJSONObject searchCounts) {
        if (searchCounts == null) {
            throw new IllegalStateException("Expected non-null search counts");
        } else if (searchCounts.size() == 0) {
            throw new IllegalStateException("Expected non-empty search counts");
        }

        payload.put(SEARCH_COUNTS, searchCounts);
        return this;
    }

    /**
     * Get enabled accessibility services that might start gecko accessibility.
     */
    public TelemetryCorePingBuilder setOptAccessibility(@NonNull final List<AccessibilityServiceInfo> enabledServices) {
        // Some services, like TalkBack, register themselves several times. We
        // only record unique services.
        final Set<String> services = new HashSet<String>();
        for (AccessibilityServiceInfo service : enabledServices) {
            services.add(service.getId());
        }

        payload.putArray(ACCESSIBILITY_SERVICES, new ArrayList<String>(services));
        return this;
    }

    public TelemetryCorePingBuilder setOptCampaignId(final String campaignId) {
        if (campaignId == null) {
            throw new IllegalStateException("Expected non-null campaign ID.");
        }
        payload.put(CAMPAIGN_ID, campaignId);
        return this;
    }

    /**
     * @param date The profile creation date in days to the unix epoch (not millis!), or null if there is an error.
     */
    public TelemetryCorePingBuilder setProfileCreationDate(@Nullable final Long date) {
        if (date != null && date < 0) {
            throw new IllegalArgumentException("Expect positive date value. Received: " + date);
        }
        payload.put(PROFILE_CREATION_DATE, date);
        return this;
    }

    /**
     * @param seq a positive sequence number.
     */
    public TelemetryCorePingBuilder setSequenceNumber(final int seq) {
        if (seq < 0) {
            // Since this is an increasing value, it's possible we can overflow into negative values and get into a
            // crash loop so we don't crash on invalid arg - we can investigate if we see negative values on the server.
            Log.w(LOGTAG, "Expected positive sequence number. Received: " + seq);
        }
        payload.put(SEQ, seq);
        return this;
    }

    public TelemetryCorePingBuilder setSessionCount(final int sessionCount) {
        if (sessionCount < 0) {
            // Since this is an increasing value, it's possible we can overflow into negative values and get into a
            // crash loop so we don't crash on invalid arg - we can investigate if we see negative values on the server.
            Log.w(LOGTAG, "Expected positive session count. Received: " + sessionCount);
        }
        payload.put(SESSION_COUNT, sessionCount);
        return this;
    }

    public ExtendedJSONObject getFennec(final ExtendedJSONObject newTab, final ExtendedJSONObject settingsAdvanced,
                                        final ExtendedJSONObject settingsGeneral, final ExtendedJSONObject settingsPrivacy,
                                        final ExtendedJSONObject settingsNotifications, final ExtendedJSONObject addons,
                                        final ExtendedJSONObject pageOptions, final ExtendedJSONObject sync) {
        final ExtendedJSONObject fennec = new ExtendedJSONObject();

        fennec.put(NEW_TAB, newTab);
        fennec.put(SETTINGS_ADVANCED, settingsAdvanced);
        fennec.put(SETTINGS_GENERAL, settingsGeneral);
        fennec.put(SETTINGS_PRIVACY, settingsPrivacy);
        fennec.put(SETTINGS_NOTIFICATIONS, settingsNotifications);
        fennec.put(ADDONS, addons);
        fennec.put(PAGE_OPTIONS, pageOptions);
        fennec.put(SYNC, sync);

        return fennec;
    }

    public ExtendedJSONObject getNewTab(final Integer topSitesClicked, final Integer pocketStoriesClicked) {
        final ExtendedJSONObject newTab = new ExtendedJSONObject();

        newTab.put(TOP_SITES_CLICKED, topSitesClicked);
        newTab.put(POCKET_STORIES_CLICKED, pocketStoriesClicked);

        return newTab;
    }

    public ExtendedJSONObject getSettingsAdvanced(final Boolean restoreTabs, final String showImages,
                                                  final Boolean showWebFonts) {
        final ExtendedJSONObject settingsAdvanced = new ExtendedJSONObject();

        settingsAdvanced.put(RESTORE_TABS, restoreTabs);
        settingsAdvanced.put(SHOW_IMAGES, showImages);
        settingsAdvanced.put(SHOW_WEB_FONTS, showWebFonts);

        return settingsAdvanced;
    }

    public ExtendedJSONObject getSettingsGeneral(final Boolean fullScreenBrowsing, final Boolean tabQueue,
                                                 final Integer tabQueueUsageCount, final Boolean compactTabs,
                                                 final ExtendedJSONObject homepage) {
        final ExtendedJSONObject settingsGeneral = new ExtendedJSONObject();

        settingsGeneral.put(FULL_SCREEN_BROWSING, fullScreenBrowsing);
        settingsGeneral.put(TAB_QUEUE, tabQueue);
        settingsGeneral.put(TAB_QUEUE_USAGE_COUNT, tabQueueUsageCount);
        settingsGeneral.put(COMPACT_TABS, compactTabs);
        settingsGeneral.put(HOMEPAGE, homepage);

        return settingsGeneral;
    }

    public ExtendedJSONObject getHomepage(final Boolean customHomepage, final Boolean customHomepageUseForNewTab,
                                          final Boolean topsitesEnabled, final Boolean pocketEnabled,
                                          final Boolean recentBookmarksEnabled, final Boolean visitedEnabled,
                                          final Boolean bookmarksEnabled, final Boolean historyEnabled) {
        final ExtendedJSONObject homepage = new ExtendedJSONObject();

        homepage.put(CUSTOM_HOMEPAGE, customHomepage);
        homepage.put(CUSTOM_HOMEPAGE_USE_FOR_NEWTAB, customHomepageUseForNewTab);
        homepage.put(TOPSITES_ENABLED, topsitesEnabled);
        homepage.put(POCKET_ENABLED, pocketEnabled);
        homepage.put(RECENT_BOOKMARKS_ENABLED, recentBookmarksEnabled);
        homepage.put(VISITED_ENABLED, visitedEnabled);
        homepage.put(BOOKMARKS_ENABLED, bookmarksEnabled);
        homepage.put(HISTORY_ENABLED, historyEnabled);

        return homepage;
    }

    public ExtendedJSONObject getSettingsPrivacy(final Boolean doNotTrack, final Boolean masterPassword,
                                                 final Integer masterPasswordUsageCount) {
        final ExtendedJSONObject settingsPrivacy = new ExtendedJSONObject();

        settingsPrivacy.put(DO_NOT_TRACK, doNotTrack);
        settingsPrivacy.put(MASTER_PASSWORD, masterPassword);
        settingsPrivacy.put(MASTER_PASSWORD_USAGE_COUNT, masterPasswordUsageCount);

        return settingsPrivacy;
    }

    public ExtendedJSONObject getSettingsNotifications(final Boolean productFeatureTips) {
        final ExtendedJSONObject settingsNotifications = new ExtendedJSONObject();

        settingsNotifications.put(PRODUCT_FEATURE_TIPS, productFeatureTips);

        return settingsNotifications;
    }

    public ExtendedJSONObject getAddons(final List<String> active, final List<String> disabled) {
        final ExtendedJSONObject addons = new ExtendedJSONObject();

        addons.putArray(ACTIVE, active);
        addons.putArray(DISABLED, disabled);

        return addons;
    }

    public ExtendedJSONObject getPageOptions(final Integer saveAsPdf, final Integer print, final Integer totalAddedSearchEngines,
                                             final Integer totalSitesPinnedToTopsites, final Integer viewSource,
                                             final Integer bookmarkWithStar) {
        final ExtendedJSONObject pageOptions = new ExtendedJSONObject();

        pageOptions.put(SAVE_AS_PDF, saveAsPdf);
        pageOptions.put(PRINT, print);
        pageOptions.put(TOTAL_ADDED_SEARCH_ENGINES, totalAddedSearchEngines);
        pageOptions.put(TOTAL_SITES_PINNED_TO_TOPSITES, totalSitesPinnedToTopsites);
        pageOptions.put(VIEW_SOURCE, viewSource);
        pageOptions.put(BOOKMARK_WITH_STAR, bookmarkWithStar);

        return pageOptions;
    }

    public ExtendedJSONObject getSync(final Boolean onlyOverWifi) {
        final ExtendedJSONObject sync = new ExtendedJSONObject();

        sync.put(ONLY_OVER_WIFI, onlyOverWifi);

        return sync;
    }

    public TelemetryCorePingBuilder setSessionDuration(final long sessionDuration) {
        if (sessionDuration < 0) {
            // Since this is an increasing value, it's possible we can overflow into negative values and get into a
            // crash loop so we don't crash on invalid arg - we can investigate if we see negative values on the server.
            Log.w(LOGTAG, "Expected positive session duration. Received: " + sessionDuration);
        }
        payload.put(SESSION_DURATION, sessionDuration);
        return this;
    }

    /**
     * Gets the sequence number from shared preferences and increments it in the prefs. This method
     * is not thread safe.
     */
    @WorkerThread // synchronous shared prefs write.
    public static int getAndIncrementSequenceNumber(final SharedPreferences sharedPrefsForProfile) {
        final int seq = sharedPrefsForProfile.getInt(PREF_SEQ_COUNT, 1);

        sharedPrefsForProfile.edit().putInt(PREF_SEQ_COUNT, seq + 1).apply();
        return seq;
    }

    /**
     * @return the profile creation date in the format expected by
     * {@link TelemetryCorePingBuilder#setProfileCreationDate(Long)}.
     */
    @WorkerThread
    public static Long getProfileCreationDate(final Context context, final GeckoProfile profile) {
        final long profileMillis = profile.getAndPersistProfileCreationDate(context);
        if (profileMillis < 0) {
            return null;
        }
        return (long) Math.floor((double) profileMillis / TimeUnit.DAYS.toMillis(1));
    }

    /**
     * @return the search engine identifier in the format expected by the core ping.
     */
    @Nullable
    public static String getEngineIdentifier(@Nullable final SearchEngine searchEngine) {
        if (searchEngine == null) {
            return null;
        }
        final String identifier = searchEngine.getIdentifier();
        return TextUtils.isEmpty(identifier) ? null : identifier;
    }
}
