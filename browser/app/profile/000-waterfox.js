#filter dumbComments emptyLines substitution

// -*- indent-tabs-mode: nil; js-indent-level: 2 -*-
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#ifdef XP_UNIX
  #ifndef XP_MACOSX
    #define UNIX_BUT_NOT_MAC
  #endif
#endif

# Default Preferences
# Waterfox
# All customised preferences should live here

pref("app.normandy.api_url", "", locked);
pref("app.normandy.dev_mode", false, locked);
pref("app.normandy.enabled", false, locked);
pref("app.normandy.first_run", false, locked);
pref("app.normandy.last_seen_buildid", "", locked);
pref("app.normandy.logging.level", 50, locked);
pref("app.normandy.onsync_skew_sec", -1, locked);
pref("app.normandy.run_interval_seconds", -1, locked);
pref("app.normandy.shieldLearnMoreUrl", "", locked);
pref("app.releaseNotesURL", "about:blank");
pref("app.shield.optoutstudies.enabled", false, locked);
pref("app.update.badgeWaitTime", 0);
pref("app.update.BITS.enabled", false, locked);
pref("app.update.notifyDuringDownload", true);
pref("app.update.promptWaitTime", 3600);
pref("app.update.url.override", "", sticky);
pref("breakpad.reportURL", "", locked);
pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false, locked);
pref("browser.crashReports.unsubmittedCheck.chancesUntilSuppress", 0, locked);
pref("browser.crashReports.unsubmittedCheck.enabled", false, locked);
pref("browser.discovery.containers.enabled", false, locked);
pref("browser.discovery.enabled", false, locked);
pref("browser.discovery.sites", "", locked);
pref("browser.download.autohideButton", false);
pref("browser.download.panel.shown", true);
pref("browser.messaging-system.personalized-cfr.scores", "{}", locked);
pref("browser.messaging-system.whatsNewPanel.enabled", false, locked);
pref("browser.newtabpage.activity-stream.asrouter.providers.cfr", "{}", locked);
pref("browser.newtabpage.activity-stream.asrouter.providers.cfr-fxa", "{}", locked);
pref("browser.newtabpage.activity-stream.asrouter.providers.message-groups", "{}", locked);
pref("browser.newtabpage.activity-stream.asrouter.providers.messaging-experiments", "{}", locked);
pref("browser.newtabpage.activity-stream.asrouter.providers.snippets", "{}", locked);
pref("browser.newtabpage.activity-stream.asrouter.providers.whats-new-panel", "{}", locked);
pref("browser.newtabpage.activity-stream.asrouter.useRemoteL10n", false, locked);
pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false, locked);
pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false, locked);
pref("browser.newtabpage.activity-stream.debug", false, locked);
pref("browser.newtabpage.activity-stream.default.sites", "", locked);
pref("browser.newtabpage.activity-stream.discoverystream.config", "{}");
pref("browser.newtabpage.activity-stream.discoverystream.enabled", false, locked);
pref("browser.newtabpage.activity-stream.discoverystream.hardcoded-basic-layout", false, locked);
pref("browser.newtabpage.activity-stream.discoverystream.locale-list-config", "", locked);
pref("browser.newtabpage.activity-stream.discoverystream.personalization.modelKeys", "", locked);
pref("browser.newtabpage.activity-stream.discoverystream.recs.personalized", false, locked);
pref("browser.newtabpage.activity-stream.discoverystream.region-basic-config", "", locked);
pref("browser.newtabpage.activity-stream.discoverystream.region-spocs-config", "", locked);
pref("browser.newtabpage.activity-stream.discoverystream.region-stories-config", "", locked);
pref("browser.newtabpage.activity-stream.discoverystream.spocs.personalized", false, locked);
pref("browser.newtabpage.activity-stream.discoverystream.spocs-endpoint", "", locked);
pref("browser.newtabpage.activity-stream.discoverystream.spocs-endpoint-query", "", locked);
pref("browser.newtabpage.activity-stream.feeds.section.highlights", true);
pref("browser.newtabpage.activity-stream.feeds.snippets", false, locked);
pref("browser.newtabpage.activity-stream.feeds.section.topstories", false, locked);
pref("browser.newtabpage.activity-stream.feeds.section.topstories.options", "{}", locked);
pref("browser.newtabpage.activity-stream.feeds.system.topstories", false, locked);
pref("browser.newtabpage.activity-stream.feeds.telemetry", false, locked);
pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts", false);
pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false, locked);
pref("browser.newtabpage.activity-stream.section.highlights.rows", 2);
pref("browser.newtabpage.activity-stream.showSponsored", false, locked);
pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false, locked);
pref("browser.newtabpage.activity-stream.telemetry", false, locked);
pref("browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint", "", locked);
pref("browser.newtabpage.activity-stream.telemetry.ut.events", false, locked);
pref("browser.partnerlink.attributionURL", "", locked);
pref("browser.partnerlink.campaign.topsites", "", locked);
pref("browser.ping-centre.telemetry", false, locked);
pref("browser.safebrowsing.blockedURIs.enabled", false);
pref("browser.safebrowsing.downloads.enabled", false);
pref("browser.safebrowsing.downloads.remote.enabled", false);
pref("browser.safebrowsing.downloads.remote.url", "", locked);
pref("browser.safebrowsing.malware.enabled", false);
pref("browser.safebrowsing.phishing.enabled", false);
pref("browser.safebrowsing.provider.google.gethashURL", "", locked);
pref("browser.safebrowsing.provider.google.updateURL", "", locked);
pref("browser.safebrowsing.provider.google4.gethashURL", "", locked);
pref("browser.safebrowsing.provider.google4.updateURL", "", locked);
pref("browser.safebrowsing.provider.mozilla.gethashURL", "", locked);
pref("browser.safebrowsing.provider.mozilla.updateURL", "", locked);
pref("browser.send_pings", false, locked);
pref("browser.tabs.crashReporting.includeURL", false, locked);
pref("browser.tabs.crashReporting.sendReport", false, locked);
pref("browser.tabs.remote.separatedMozillaDomains", "", locked);
pref("browser.topsites.contile.enabled", false, locked);
pref("browser.topsites.contile.endpoint", "", locked);
pref("browser.topsites.useRemoteSetting", false, locked);
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"save-to-pocket-button\",\"downloads-button\",\"library-button\",\"fxa-toolbar-menu-button\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"profiler-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\"],\"currentVersion\":17,\"newElementCount\":3}");
pref("browser.uidensity", 1, locked);
pref("browser.urlbar.dnsResolveSingleWordsAfterSearch", 0, locked);
pref("browser.urlbar.eventTelemetry.enabled", false, locked);
pref("browser.urlbar.showSearchSuggestionsFirst", false);
pref("browser.urlbar.speculativeConnect.enabled", false);
pref("browser.urlbar.sponsoredTopSites", false, locked);
pref("browser.urlbar.trimURLs", false);
pref("browser.xul.error_pages.expert_bad_cert", true);
pref("corroborator.enabled", false, locked);
pref("datareporting.healthreport.uploadEnabled", false, locked);
pref("datareporting.policy.dataSubmissionEnabled", false, locked);
pref("default-browser-agent.enabled", false, locked);
pref("devtools.debugger.chrome-debugging-host", "127.0.0.1");
pref("devtools.webide.autoinstallADBExtension", false);
pref("dom.security.unexpected_system_load_telemetry_enabled", false, locked);
pref("extensions.activeThemeID", "lepton@waterfox.net");
pref("extensions.allowPrivateBrowsingByDefault", true);
pref("extensions.experiments.enabled", true, locked);
pref("extensions.getAddons.cache.enabled", false, locked); // https://blog.mozilla.org/addons/how-to-opt-out-of-add-on-metadata-updates/
pref("extensions.getAddons.langpacks.url", "", locked);
pref("extensions.getAddons.showPane", false, locked);
pref("extensions.htmlaboutaddons.recommendations.enabled", false, locked);
pref("extensions.pocket.api", "", locked);
pref("extensions.pocket.enabled", false, locked);
pref("extensions.pocket.oAuthConsumerKey", "", locked);
pref("extensions.pocket.onSaveRecs", false, locked);
pref("extensions.pocket.onSaveRecs.locales", "", locked);
pref("extensions.pocket.showHome", false, locked);
pref("extensions.recommendations.privacyPolicyUrl", "", locked);
pref("fission.autostart", true);
pref("general.useragent.compatMode.firefox", true);
pref("geo.provider.network.url", "", locked);
pref("identity.mobilepromo.android", "", locked);
pref("identity.mobilepromo.ios", "", locked);
pref("image.avif.enabled", true);
pref("image.jxl.enabled", true);
pref("layout.css.backdrop-filter.enabled", true, locked);
pref("media.eme.enabled", false);
pref("media.gmp-manager.url", "data:application/json,", locked);
pref("media.webrtc.hw.h264.enabled", true);
pref("media.webrtc.platformencoder", true);
pref("messaging-system.rsexperimentloader.collection_id", "", locked);
pref("messaging-system.rsexperimentloader.enabled", false, locked);
pref("network.captive-portal-service.enabled", false);
pref("network.connectivity-service.enabled", false);
pref("network.http.connection-retry-timeout", 0);
pref("network.http.max-persistent-connections-per-proxy", 256);
pref("network.manage-offline-status", false);
pref("network.trr.confirmation_telemetry_enabled", false, locked);
pref("network.trr.exclude-etc-hosts", false, locked);
pref("network.trr.resolvers", "", locked);
pref("plugin.default.state", 1);
pref("plugin.state.flash", 1);
pref("privacy.firstparty.isolate", true); // Always enforce first party isolation
pref("privacy.trackingprotection.origin_telemetry.enabled", false, locked);
pref("privacy.userContext.enabled", true);
pref("privacy.userContext.ui.enabled", true);
pref("security.app_menu.recordEventTelemetry", false, locked);
pref("security.certerrors.mitm.priming.enabled", false, locked);
pref("security.certerrors.recordEventTelemetry", false, locked);
pref("security.family_safety.mode", 0, locked);
pref("security.identitypopup.recordEventTelemetry", false, locked);
pref("security.insecure_connection_text.enabled", true);
pref("security.insecure_connection_text.pbmode.enabled", true);
pref("security.pki.crlite_mode", 0, locked);
pref("security.protectionspopup.recordEventTelemetry", false, locked);
pref("security.sandbox.content.win32k-disable", true);
pref("security.secure_connection_icon_color_gray", false);
pref("security.ssl.enable_false_start", true);
pref("security.ssl.errorReporting.enabled", false, locked);
pref("services.settings.server", "data:application/json,", locked); // 24H
pref("services.sync.engine.prefs", false, locked); // Never sync prefs, addons, or tabs with other browsers
pref("services.sync.prefs.sync.app.shield.optoutstudies.enabled", false, locked);
pref("services.sync.prefs.sync.browser.crashReports.unsubmittedCheck.autoSubmit2", false, locked);
pref("services.sync.prefs.sync.browser.discovery.enabled", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.section.topstories", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.feeds.snippets", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.section.topstories.rows", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites", false, locked);
pref("services.sync.telemetry.maxPayloadCount", "0", locked);
pref("services.sync.telemetry.submissionInterval", "0", locked);
pref("signon.management.page.mobileAndroidURL", "", locked);
pref("signon.management.page.mobileAppleURL", "", locked);
pref("signon.recipes.remoteRecipesEnabled", false, locked);
pref("svg.context-properties.content.enabled", true, locked);
pref("telemetry.origin_telemetry_test_mode.enabled", false, locked);
pref("toolkit.coverage.enabled", false, locked);
pref("toolkit.coverage.endpoint.base", "", locked);
pref("toolkit.coverage.opt-out", true, locked);
pref("toolkit.crashreporter.infoURL", "", locked);
pref("toolkit.legacyUserProfileCustomizations.stylesheets", true, locked);
pref("toolkit.telemetry.archive.enabled", false, locked);
pref("toolkit.telemetry.bhrPing.enabled", false, locked);
pref("toolkit.telemetry.enabled", false, locked);
pref("toolkit.telemetry.firstShutdownPing.enabled", false, locked);
pref("toolkit.telemetry.geckoview.streaming", false, locked);
pref("toolkit.telemetry.newProfilePing.enabled", false, locked);
pref("toolkit.telemetry.pioneer-new-studies-available", false, locked);
pref("toolkit.telemetry.reportingpolicy.firstRun", false, locked);
pref("toolkit.telemetry.server", "", locked);
pred("toolkit.telemetry.server_owner", "", locked);
pref("toolkit.telemetry.shutdownPingSender.enabled", false, locked);
pref("toolkit.telemetry.shutdownPingSender.enabledFirstSession", false, locked);
pref("toolkit.telemetry.testing.overrideProductsCheck", false, locked);
pref("toolkit.telemetry.unified", false, locked);
pref("toolkit.telemetry.updatePing.enabled", false, locked); // Make sure updater telemetry is disabled; see #25909.
pref("trailhead.firstrun.branches", "", locked);
pref("xpinstall.signatures.required", false);
