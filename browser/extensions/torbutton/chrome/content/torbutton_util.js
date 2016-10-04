// Bug 1506 P0-P3: These utility functions might be useful, but 
// you probably just want to rewrite them or use the underlying
// code directly. I don't see any of them as essential for 1506,
// really.

var m_tb_torlog = Components.classes["@torproject.org/torbutton-logger;1"]
.getService(Components.interfaces.nsISupports).wrappedJSObject;

var m_tb_string_bundle = torbutton_get_stringbundle();

// Bug 1506 P0: Use the log service directly
function torbutton_eclog(nLevel, sMsg) {
    m_tb_torlog.eclog(nLevel, sMsg);
    return true;
}

function torbutton_safelog(nLevel, sMsg, scrub) {
    m_tb_torlog.safe_log(nLevel, sMsg, scrub);
    return true;
}

function torbutton_log(nLevel, sMsg) {
    m_tb_torlog.log(nLevel, sMsg);

    // So we can use it in boolean expressions to determine where the 
    // short-circuit is..
    return true; 
}

// get a preferences branch object
// FIXME: this is lame.
function torbutton_get_prefbranch(branch_name) {
    var o_prefs = false;
    var o_branch = false;

    torbutton_log(1, "called get_prefbranch()");
    o_prefs = Components.classes["@mozilla.org/preferences-service;1"]
                        .getService(Components.interfaces.nsIPrefService);
    if (!o_prefs)
    {
        torbutton_log(5, "Failed to get preferences-service!");
        return false;
    }

    o_branch = o_prefs.getBranch(branch_name);
    if (!o_branch)
    {
        torbutton_log(5, "Failed to get prefs branch!");
        return false;
    }

    return o_branch;
}

// Bug 1506 P3: This would be a semi-polite thing to do on uninstall 
// for pure Firefox users. The most polite thing would be to save
// all their original prefs.. But meh?
function torbutton_reset_browser_prefs() {
    var o_all_prefs = torbutton_get_prefbranch('');
    var prefs = ["network.http.sendSecureXSiteReferrer", 
        "network.http.sendRefererHeader", "dom.storage.enabled", 
        "extensions.update.enabled", "app.update.enabled",
        "app.update.auto", "browser.search.update", 
        "browser.cache.memory.enable", "network.http.use-cache", 
        "browser.cache.disk.enable", "browser.safebrowsing.enabled",
        "browser.send_pings", "browser.safebrowsing.remoteLookups",
        "network.security.ports.banned", "browser.search.suggest.enabled",
        "security.enable_java", "browser.history_expire_days",
        "browser.download.manager.retention", "browser.formfill.enable",
        "signon.rememberSignons", "plugin.disable_full_page_plugin_for_types",
        "browser.bookmarks.livemark_refresh_seconds", 
        "network.cookie.lifetimePolicy" ];
    for(var i = 0; i < prefs.length; i++) {
        if(o_all_prefs.prefHasUserValue(prefs[i]))
            o_all_prefs.clearUserPref(prefs[i]);
    }
}

// load localization strings
function torbutton_get_stringbundle()
{
    var o_stringbundle = false;

    try {
        var oBundle = Components.classes["@mozilla.org/intl/stringbundle;1"]
                                .getService(Components.interfaces.nsIStringBundleService);
        o_stringbundle = oBundle.createBundle("chrome://torbutton/locale/torbutton.properties");
    } catch(err) {
        o_stringbundle = false;
    }
    if (!o_stringbundle) {
        torbutton_log(5, 'ERROR (init): failed to find torbutton-bundle');
    }

    return o_stringbundle;
}

function torbutton_get_property_string(propertyname)
{
    try { 
        if (!m_tb_string_bundle) {
            m_tb_string_bundle = torbutton_get_stringbundle();
        }

        return m_tb_string_bundle.GetStringFromName(propertyname);
    } catch(e) {
        torbutton_log(4, "Unlocalized string "+propertyname);
    }

    return propertyname;
}

