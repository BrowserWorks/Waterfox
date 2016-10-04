// debug prefs
pref("extensions.torbutton.loglevel",4);
pref("extensions.torbutton.logmethod",1); // 0=stdout, 1=errorconsole, 2=debuglog

// Display prefs
pref("extensions.torbutton.display_circuit", true);
pref("extensions.torbutton@torproject.org.description", "chrome://torbutton/locale/torbutton.properties");
pref("extensions.torbutton.updateNeeded", false);
pref("extensions.torbutton.hide_sync_ui", true);

// Tor check and proxy prefs
pref("extensions.torbutton.test_enabled",true);
pref("extensions.torbutton.test_url","https://check.torproject.org/?TorButton=true");
pref("extensions.torbutton.test_url_interactive", "https://check.torproject.org/?lang=__LANG__");
pref("extensions.torbutton.local_tor_check",true);
pref("extensions.torbutton.versioncheck_url","https://www.torproject.org/projects/torbrowser/RecommendedTBBVersions");
pref("extensions.torbutton.versioncheck_enabled",true);
pref("extensions.torbutton.use_nontor_proxy",false);

// State prefs:
pref("extensions.torbutton.startup",false);
pref("extensions.torbutton.inserted_button",false);
pref("extensions.torbutton.prompted_language",false);

// TODO: This is just part of a stopgap until #14429 gets properly implemented.
// See #7255 for details. We display the warning three times to make sure the
// user did not click on it by accident.
pref("extensions.torbutton.maximize_warnings_remaining", 0);
pref("extensions.torbutton.startup_resize_period", true);

// Security prefs:
pref("extensions.torbutton.no_tor_plugins",true);
pref("extensions.torbutton.cookie_protections",true);
pref("extensions.torbutton.cookie_auto_protect",false);
pref("extensions.torbutton.spoof_english",true);
pref("extensions.torbutton.clear_http_auth",true);
pref("extensions.torbutton.close_newnym",true);
pref("extensions.torbutton.resize_new_windows",true);
pref("extensions.torbutton.resize_windows",true);
pref("extensions.torbutton.startup_state", 2); // 0=non-tor, 1=tor, 2=last
pref("extensions.torbutton.tor_memory_jar",false);
pref("extensions.torbutton.nontor_memory_jar",false);
pref("extensions.torbutton.launch_warning",true);
// Opt out of Firefox addon pings:
// https://developer.mozilla.org/en/Addons/Working_with_AMO
pref("extensions.torbutton@torproject.org.getAddons.cache.enabled", false);

pref("extensions.torbutton.block_disk", true);
pref("extensions.torbutton.resist_fingerprinting", true);
pref("extensions.torbutton.restrict_thirdparty", true);

// Security Slider
pref("extensions.torbutton.security_slider", 4);
pref("extensions.torbutton.security_custom", false);
pref("extensions.torbutton.show_slider_notification", true);

pref("extensions.torbutton.prompt_torbrowser", true);
pref("extensions.torbutton.confirm_plugins", true);
pref("extensions.torbutton.confirm_newnym", true);

// Browser home page:
pref("browser.startup.homepage", "chrome://torbutton/content/locale/non-localized.properties");

// Browser window maximum size (used when setting the size during startup):
pref("extensions.torbutton.window.maxHeight", 1000);
pref("extensions.torbutton.window.maxWidth", 1000);

// This pref specifies an ad-hoc "version" for various pref update hacks we need to do
pref("extensions.torbutton.pref_fixup_version", 0);
