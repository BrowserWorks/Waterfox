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

// Look and feel related preferences
pref("svg.context-properties.content.enabled", true, locked);
pref("layout.css.backdrop-filter.enabled", true, locked);
pref("toolkit.legacyUserProfileCustomizations.stylesheets", true, locked);
pref("browser.uidensity", 1, locked);
pref("browser.download.autohideButton", false);
pref("browser.urlbar.trimURLs", false);
pref("extensions.activeThemeID", "lepton@waterfox.net");
pref("browser.urlbar.showSearchSuggestionsFirst", false);
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"save-to-pocket-button\",\"downloads-button\",\"library-button\",\"fxa-toolbar-menu-button\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"profiler-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\"],\"currentVersion\":17,\"newElementCount\":3}");

pref("xpinstall.signatures.required", false);
pref("general.useragent.compatMode.firefox", true);

// Experimental preferences
pref("fission.autostart", true);
pref("image.avif.enabled", true);
pref("image.jxl.enabled", true);
pref("media.webrtc.hw.h264.enabled", true);
pref("media.webrtc.platformencoder", true);

// Try to nag a bit more about updates: Pop up a restart dialog an hour after the initial dialog
pref("app.update.promptWaitTime", 3600);
pref("app.update.notifyDuringDownload", true);
pref("app.update.badgeWaitTime", 0);
pref("app.releaseNotesURL", "about:blank");


// Misc privacy: Remote
pref("browser.send_pings", false, locked);
pref("geo.provider.network.url", "", locked);
pref("browser.safebrowsing.malware.enabled", false);
pref("browser.safebrowsing.phishing.enabled", false);
pref("browser.safebrowsing.downloads.enabled", false);
pref("browser.safebrowsing.downloads.remote.enabled", false);
pref("browser.safebrowsing.blockedURIs.enabled", false);
pref("browser.safebrowsing.downloads.remote.url", "", locked);
pref("browser.safebrowsing.provider.google.updateURL", "", locked);
pref("browser.safebrowsing.provider.google.gethashURL", "", locked);
pref("browser.safebrowsing.provider.google4.updateURL", "", locked);
pref("browser.safebrowsing.provider.google4.gethashURL", "", locked);
pref("browser.safebrowsing.provider.mozilla.updateURL", "", locked);
pref("browser.safebrowsing.provider.mozilla.gethashURL", "", locked);
pref("datareporting.healthreport.uploadEnabled", false, locked);
pref("datareporting.policy.dataSubmissionEnabled", false, locked);
// Keep an eye on the below settings - if they break things, may need to revert
pref("services.settings.poll_interval", -1, locked); // 24H
// pref("services.settings.default_bucket", "", locked);
// pref("services.settings.server", "", locked);

// Make sure Unified Telemetry is really disabled, see: #18738.
pref("toolkit.telemetry.unified", false, locked);
pref("toolkit.telemetry.enabled", false, locked);
pref("toolkit.telemetry.updatePing.enabled", false, locked); // Make sure updater telemetry is disabled; see #25909.
pref("services.sync.engine.prefs", false, locked); // Never sync prefs, addons, or tabs with other browsers
pref("extensions.getAddons.cache.enabled", false, locked); // https://blog.mozilla.org/addons/how-to-opt-out-of-add-on-metadata-updates/

// Disable the Pocket extension (Bug #18886 and #31602)
pref("extensions.pocket.enabled", false, locked);
pref("extensions.pocket.api", "", locked);
pref("extensions.pocket.oAuthConsumerKey", "", locked);
pref("extensions.pocket.showHome", false, locked);
pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false, locked);
pref("browser.newtabpage.activity-stream.showSponsored", false, locked);
pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false, locked);
pref("browser.newtabpage.activity-stream.feeds.section.topstories", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored", false, locked);
pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites", false, locked);

// New tab preferences
pref("browser.topsites.useRemoteSetting", false, locked);
// Fetch sponsored Top Sites from Mozilla Tiles Service (Contile)
pref("browser.topsites.contile.enabled", false, locked);
pref("browser.topsites.contile.endpoint", "", locked);

// The base URL for the Quick Suggest anonymizing proxy. To make a request to
// the proxy, include a campaign ID in the path.
pref("browser.partnerlink.attributionURL", "", locked);
pref("browser.partnerlink.campaign.topsites", "", locked);

// Don't load Mozilla domains in a separate tab process
pref("browser.tabs.remote.separatedMozillaDomains", "", locked);

// Avoid DNS lookups on search terms
pref("browser.urlbar.dnsResolveSingleWordsAfterSearch", 0, locked);

// Disable about:newtab and "first run" experiments
pref("messaging-system.rsexperimentloader.enabled", false, locked);
pref("trailhead.firstrun.branches", "", locked);

// Clear the list of trusted recursive resolver services
pref("network.trr.resolvers", "", locked);

// Disable the /etc/hosts parser
pref("network.trr.exclude-etc-hosts", false, locked);

// Disable crlite
pref("security.pki.crlite_mode", 0, locked);

// Remove mobile app tracking URLs
pref("signon.management.page.mobileAndroidURL", "", locked);
pref("signon.management.page.mobileAppleURL", "", locked);

// Disable remote "password recipes"
pref("signon.recipes.remoteRecipesEnabled", false, locked);

// Third party stuff
pref("privacy.firstparty.isolate", true); // Always enforce first party isolation
pref("plugin.state.flash", 0, locked); // Disable for defense-in-depth

// Mozilla is relying on preferences to make sure no DRM blob is downloaded and
// run. Even though those prefs should be set correctly by specifying
// --disable-eme (which we do), we disable all of them here as well for defense
// in depth (see bug 16285 for more details).
pref("media.eme.enabled", false);
// WebIDE can bypass proxy settings for remote debugging. It also downloads
// some additional addons that we have not reviewed. Turn all that off.
pref("devtools.webide.autoinstallADBExtension", false);
// The in-browser debugger for debugging chrome code is not coping with our
// restrictive DNS look-up policy. We use "127.0.0.1" instead of "localhost" as
// a workaround. See bug 16523 for more details.
pref("devtools.debugger.chrome-debugging-host", "127.0.0.1");

// Network and performance
pref("security.ssl.enable_false_start", true);
pref("network.http.connection-retry-timeout", 0);
pref("network.http.max-persistent-connections-per-proxy", 256);
pref("network.manage-offline-status", false);
// No need to leak things to Mozilla, see bug 21790 and tor-browser#40322
pref("network.captive-portal-service.enabled", false);
pref("network.connectivity-service.enabled", false);
// As a "defense in depth" measure, configure an empty push server URL (the
// DOM Push features are disabled by default via other prefs).

// We don't know what extensions Mozilla is advertising to our users and we
// don't want to have some random Google Analytics script running either on the
// about:addons page, see bug 22073, 22900 and 31601.
pref("extensions.getAddons.showPane", false, locked);
pref("extensions.htmlaboutaddons.recommendations.enabled", false, locked);
// Bug 28896: Make sure our bundled WebExtensions are running in Private Browsing Mode
pref("extensions.allowPrivateBrowsingByDefault", true);

// Don't allow MitM via Microsoft Family Safety, see bug 21686
pref("security.family_safety.mode", 0, locked);

// Don't ping Mozilla for MitM detection, see bug 32321
pref("security.certerrors.mitm.priming.enabled", false, locked);

// Avoid report TLS errors to Mozilla. We might want to repurpose this feature
// one day to help detecting bad relays (which is bug 19119). For now we just
// hide the checkbox, see bug 22072.
pref("security.ssl.errorReporting.enabled", false, locked);

// Workaround for https://bugs.torproject.org/13579. Progress on
// `about:downloads` is only shown if the following preference is set to `true`
// in case the download panel got removed from the toolbar.
pref("browser.download.panel.shown", true);

// Skip checking omni.ja and other files for corruption since the result
// is only reported via telemetry (which is disabled).
pref("corroborator.enabled", false, locked);
