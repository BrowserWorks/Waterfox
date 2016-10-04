// Bug 1506 P0-P5: This is the main Torbutton overlay file. Much needs to be
// preserved here, but in an ideal world, most of this code should perhaps be
// moved into an XPCOM service, and much can also be tossed. See also
// individual 1506 comments for details.

// TODO: check for leaks: http://www.mozilla.org/scriptable/avoiding-leaks.html
// TODO: Double-check there are no strange exploits to defeat:
//       http://kb.mozillazine.org/Links_to_local_pages_don%27t_work

let { LoadContextInfo } = Cu.import('resource://gre/modules/LoadContextInfo.jsm');
let { Services } = Cu.import("resource://gre/modules/Services.jsm");

const k_tb_last_browser_version_pref = "extensions.torbutton.lastBrowserVersion";
const k_tb_browser_update_needed_pref = "extensions.torbutton.updateNeeded";
const k_tb_last_update_check_pref = "extensions.torbutton.lastUpdateCheck";
const k_tb_tor_check_failed_topic = "Torbutton:TorCheckFailed";
const k_tb_tor_resize_warn_pref =
  "extensions.torbutton.startup_resize_period"

// status
var m_tb_wasinited = false;
var m_tb_prefs = false;
var m_tb_plugin_string = false;
var m_tb_is_main_window = false;
var m_tb_hidden_browser = false;

var m_tb_confirming_plugins = false;

var m_tb_window_height = window.outerHeight;
var m_tb_window_width = window.outerWidth;

var m_tb_tbb = false;

var m_tb_control_socket_file = null; // Set if using a UNIX domain socket.
var m_tb_control_port = null;        // Set if not using a socket.
var m_tb_control_host = null;        // Set if not using a socket.
var m_tb_control_pass = null;
var m_tb_control_desc = null;        // For logging.

var m_tb_orig_BrowserOnAboutPageLoad = null;

var m_tb_domWindowUtils = window.QueryInterface(Ci.nsIInterfaceRequestor).
                          getInterface(Ci.nsIDOMWindowUtils);

var m_tb_sliderUpdate = false;

// Bug 1506 P1: This object is only for updating the UI for toggling and style
var torbutton_window_pref_observer =
{
    register: function()
    {
        var pref_service = Components.classes["@mozilla.org/preferences-service;1"]
                                     .getService(Components.interfaces.nsIPrefBranchInternal);
        this._branch = pref_service.QueryInterface(Components.interfaces.nsIPrefBranchInternal);
        this._branch.addObserver("extensions.torbutton", this, false);
    },

    unregister: function()
    {
        if (!this._branch) return;
        this._branch.removeObserver("extensions.torbutton", this);
    },

    // topic:   what event occurred
    // subject: what nsIPrefBranch we're observing
    // data:    which pref has been changed (relative to subject)
    observe: function(subject, topic, data)
    {
        if (topic != "nsPref:changed") return;
        switch (data) {
            case k_tb_browser_update_needed_pref:
                torbutton_notify_if_update_needed();
                break;
        }
    }
}

// Bug 1506 P2: This object keeps Firefox prefs in sync with Torbutton prefs.
// It probably could stand some simplification (See #3100). It also belongs
// in a component, not the XUL overlay.
var torbutton_unique_pref_observer =
{
    register: function()
    {
        this.forced_ua = false;
        var pref_service = Components.classes["@mozilla.org/preferences-service;1"]
                                     .getService(Components.interfaces.nsIPrefBranchInternal);
        this._branch = pref_service.QueryInterface(Components.interfaces.nsIPrefBranchInternal);
        this._branch.addObserver("extensions.torbutton", this, false);
        this._branch.addObserver("network.cookie", this, false);
        this._branch.addObserver("browser.privatebrowsing.autostart", this, false);
        this._branch.addObserver("javascript", this, false);
        this._branch.addObserver("gfx", this, false);
        this._branch.addObserver("noscript", this, false);
        this._branch.addObserver("media", this, false);
        this._branch.addObserver("mathml", this, false);
        this._branch.addObserver("svg", this, false);

        // We observe xpcom-category-entry-added for plugins w/ Gecko-Content-Viewers
        var observerService = Cc["@mozilla.org/observer-service;1"].
            getService(Ci.nsIObserverService);
        observerService.addObserver(this, "xpcom-category-entry-added", false);
    },

    unregister: function()
    {
        if (!this._branch) return;
        this._branch.removeObserver("extensions.torbutton", this);
        this._branch.removeObserver("network.cookie", this);
        this._branch.removeObserver("browser.privatebrowsing.autostart", this);
        this._branch.removeObserver("javascript", this);
        this._branch.removeObserver("gfx", this);
        this._branch.removeObserver("noscript", this);
        this._branch.removeObserver("media", this);
        this._branch.removeObserver("mathml", this);
        this._branch.removeObserver("svg", this);

        var observerService = Cc["@mozilla.org/observer-service;1"].
            getService(Ci.nsIObserverService);
        observerService.removeObserver(this, "xpcom-category-entry-added");
    },

    // topic:   what event occurred
    // subject: what nsIPrefBranch we're observing
    // data:    which pref has been changed (relative to subject)
    observe: function(subject, topic, data)
    {
        if (topic == "xpcom-category-entry-added") {
          // Hrmm. should we inspect subject too? it's just mime type..
          subject.QueryInterface(Ci.nsISupportsCString);
          if (data == "Gecko-Content-Viewers" &&
              !m_tb_prefs.getBoolPref("extensions.torbutton.startup") &&
              m_tb_prefs.getBoolPref("extensions.torbutton.confirm_plugins")) {
             torbutton_log(3, "Got plugin enabled notification: "+subject);

             /* We need to protect this call with a flag becuase we can
              * get multiple observer events for each mime type a plugin
              * registers. Thankfully, these notifications arrive only on
              * the main thread, *however*, our confirmation dialog suspends
              * execution and allows more events to arrive until it is answered
              */ 
             if (!m_tb_confirming_plugins) {
               m_tb_confirming_plugins = true;
               torbutton_confirm_plugins();
               m_tb_confirming_plugins = false;
             } else {
               torbutton_log(3, "Skipping notification for mime type: "+subject);
             }
          }
          return;
        }
 
        if (topic != "nsPref:changed") return;

        switch (data) {
            case "browser.privatebrowsing.autostart":
                var mode = m_tb_prefs.getBoolPref("browser.privatebrowsing.autostart");
                var ourmode = m_tb_prefs.getBoolPref("extensions.torbutton.block_disk");
                if (mode != ourmode)
                  m_tb_prefs.setBoolPref("extensions.torbutton.block_disk", mode);
                break;
            case "network.cookie.cookieBehavior":
                var val = m_tb_prefs.getIntPref("network.cookie.cookieBehavior");
                var block_thirdparty = m_tb_prefs.getBoolPref("extensions.torbutton.restrict_thirdparty");
                if (val == 0 && block_thirdparty) // Allow all cookies
                  m_tb_prefs.setBoolPref("extensions.torbutton.restrict_thirdparty", false);
                else if (val == 1 && !block_thirdparty) // Block third party cookies
                  m_tb_prefs.setBoolPref("extensions.torbutton.restrict_thirdparty", true);
                break;

            case "extensions.torbutton.no_tor_plugins":
                torbutton_toggle_plugins(
                        m_tb_prefs.getBoolPref("extensions.torbutton.no_tor_plugins"));
                break;
            case "extensions.torbutton.block_disk":
                torbutton_update_disk_prefs();
                break;
            case "extensions.torbutton.use_nontor_proxy":
                torbutton_use_nontor_proxy();
                break;
            case "extensions.torbutton.resist_fingerprinting":
            case "extensions.torbutton.spoof_english":
                torbutton_update_fingerprinting_prefs();
                break;
            case "extensions.torbutton.restrict_thirdparty":
                torbutton_update_thirdparty_prefs();
                break;
            case "extensions.torbutton.hide_sync_ui":
                torbutton_update_sync_ui();
                break;
            case "gfx.font_rendering.opentype_svg.enabled":
            case "javascript.options.ion.content":
            case "javascript.options.typeinference":
            case "noscript.forbidMedia":
            case "media.webaudio.enabled":
            case "mathml.disabled":
            case "javascript.options.baselinejit.content":
            case "noscript.forbidFonts":
            case "noscript.globalHttpsWhitelist":
            case "noscript.global":
            case "svg.in-content.enabled":
                // |m_tb_slider_update| is only set if the user updated a
                // preference under control of the security slider via the
                // slider on the Torbutton dialog. This in turn means we can
                // skip the code dealing with setting/unsetting the custom mode
                // in this case.
                if (!m_tb_sliderUpdate) {
                    // Do we already have custom settings?
                    let customSlider = m_tb_prefs.
                        getBoolPref("extensions.torbutton.security_custom");
                    // A preference governed by the security slider got changed
                    // but we are not in custom mode yet. Change that.
                    if (!customSlider) {
                        m_tb_prefs.
                            setBoolPref("extensions.torbutton.security_custom",
                            true);
                    } else {
                        // We are in custom mode. Check whether all prefs are
                        // reset and reset the mode if so. Otherwise we remain
                        // in custom mode.
                        torbutton_log(4, "custom mode and we got: " + data);
                        torbutton_security_slider_custom_check(m_tb_prefs.
                            getIntPref("extensions.torbutton.security_slider"));
                    }
                }
                break;
        }
    }
}

var torbutton_tor_check_observer = {
    register: function()
    {
        this._obsSvc = Cc["@mozilla.org/observer-service;1"]
                         .getService(Ci.nsIObserverService);
        this._obsSvc.addObserver(this, k_tb_tor_check_failed_topic, false);
    },

    unregister: function()
    {
        if (this._obsSvc)
          this._obsSvc.removeObserver(this, k_tb_tor_check_failed_topic);
    },

    observe: function(subject, topic, data)
    {
      if (topic == k_tb_tor_check_failed_topic) {
        // Update toolbar icon and tooltip.
        torbutton_update_toolbutton();

        // Update all open about:tor pages. If the user does not have an
        // about:tor page open in the front most window, open one.
        if (torbutton_update_all_abouttor_pages(undefined, false) < 1) {
          var wm = Cc["@mozilla.org/appshell/window-mediator;1"]
              .getService(Components.interfaces.nsIWindowMediator);
          var win = wm.getMostRecentWindow("navigator:browser");
          if (win == window) {
            gBrowser.selectedTab = gBrowser.addTab("about:tor");
          }
        }
      }
    }
};

function torbutton_init_toolbutton()
{
    try {
      torbutton_log(3, "Initializing the Torbutton button.");
      torbutton_update_toolbutton();
    } catch(e) {
      torbutton_log(4, "Error Initializing Torbutton button: "+e);
    }
}

// Bug 1506 P2-P4: This code sets some version variables that are irrelevant.
// It does read out some important environment variables, though. It is
// called once per browser window.. This might belong in a component.
function torbutton_init() {
    torbutton_log(3, 'called init()');
    
    if (m_tb_wasinited) {
        return;
    }
    m_tb_wasinited = true;

    m_tb_prefs =  Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefBranch);

    // Determine if we are running inside Tor Browser.
    var cur_version;
    try {
      cur_version = m_tb_prefs.getCharPref("torbrowser.version");
      m_tb_tbb = true;
      torbutton_log(3, "This is a Tor Browser");
    } catch(e) {
      torbutton_log(3, "This is not a Tor Browser: "+e);
    }

    // If the Tor Browser version has changed since the last time Torbutton
    // was loaded, reset the version check preferences in order to avoid
    // incorrectly reporting that the browser needs to be updated.
    var last_version;
    try {
      last_version = m_tb_prefs.getCharPref(k_tb_last_browser_version_pref);
    } catch (e) {}
    if (cur_version != last_version) {
      m_tb_prefs.setBoolPref(k_tb_browser_update_needed_pref, false);
      if (m_tb_prefs.prefHasUserValue(k_tb_last_update_check_pref)) {
        m_tb_prefs.clearUserPref(k_tb_last_update_check_pref);
      }

      if (cur_version)
        m_tb_prefs.setCharPref(k_tb_last_browser_version_pref, cur_version);
    }

    let tlps;
    try {
        tlps = Cc["@torproject.org/torlauncher-protocol-service;1"]
                 .getService(Ci.nsISupports).wrappedJSObject;
    } catch(e) {}

    // Bug 1506 P4: These vars are very important for New Identity
    var environ = Components.classes["@mozilla.org/process/environment;1"]
                   .getService(Components.interfaces.nsIEnvironment);

    if (environ.exists("TOR_CONTROL_PASSWD")) {
        m_tb_control_pass = environ.get("TOR_CONTROL_PASSWD");
    } else if (environ.exists("TOR_CONTROL_COOKIE_AUTH_FILE")) {
        var cookie_path = environ.get("TOR_CONTROL_COOKIE_AUTH_FILE");
        try {
            if ("" != cookie_path) {
                m_tb_control_pass = torbutton_read_authentication_cookie(cookie_path);
            }
        } catch(e) {
            torbutton_log(4, 'unable to read authentication cookie');
        }
    } else try {
        // Try to get password from Tor Launcher.
        m_tb_control_pass = tlps.TorGetPassword(false);
    } catch(e) {}

    // Try to get control port socket (an nsIFile) from Tor Launcher, since
    // Tor Launcher knows how to handle its own preferences and how to
    // resolve relative paths.
    try {
        m_tb_control_socket_file = tlps.TorGetControlSocketFile();
    } catch(e) {}

    if (m_tb_control_socket_file) {
        m_tb_control_desc = m_tb_control_socket_file.path;
    } else {
        if (environ.exists("TOR_CONTROL_PORT")) {
            m_tb_control_port = environ.get("TOR_CONTROL_PORT");
        } else {
            try {
                const kTLControlPortPref = "extensions.torlauncher.control_port";
                m_tb_control_port = m_tb_prefs.getIntPref(kTLControlPortPref);
            } catch(e) {
              // Since we want to disable some features when Tor Launcher is
              // not installed (e.g., New Identity), we do not set a default
              // port value here.
            }
        }

        if (m_tb_control_port) {
          m_tb_control_desc = "" + m_tb_control_port;
        }

        if (environ.exists("TOR_CONTROL_HOST")) {
            m_tb_control_host = environ.get("TOR_CONTROL_HOST");
        } else {
            try {
                const kTLControlHostPref = "extensions.torlauncher.control_host";
                m_tb_control_host = m_tb_prefs.getCharPref(kTLControlHostPref);
            } catch(e) {
              m_tb_control_host = "127.0.0.1";
            }
        }
    }

    // Add event listener for about:tor page loads.
    document.addEventListener("AboutTorLoad", function(aEvent) {
      torbutton_on_abouttor_load(aEvent.target);
    }, false, true);

    // Set some important security prefs according to the chosen security level
    // if there are no custom settings to respect.
    if (!m_tb_prefs.getBoolPref("extensions.torbutton.security_custom")) {
      torbutton_update_security_slider();
    }

    // XXX: Get rid of the cached asmjs (or IndexedDB) files on disk in case we
    // don't allow things saved to disk. This is an ad-hoc fix to work around
    // #19417. Once this is properly solved we should remove this code again.
    if (m_tb_prefs.getBoolPref("extensions.torbutton.block_disk")) {
      let orig_quota_test = m_tb_prefs.getBoolPref("dom.quotaManager.testing");
      try {
        // This works only by setting the pref to `true` otherwise we get an
        // exception and nothing is happening.
        m_tb_prefs.setBoolPref("dom.quotaManager.testing", true);
        Cc["@mozilla.org/dom/quota-manager-service;1"]
          .getService(Ci.nsIQuotaManagerService).clear();
      } catch(e) {
      } finally {
        m_tb_prefs.setBoolPref("dom.quotaManager.testing", orig_quota_test);
      }
    }

    // listen for our toolbar button being added so we can initialize it
    torbutton_init_toolbutton();

    torbutton_log(1, 'registering pref observer');
    torbutton_window_pref_observer.register();

    torbutton_log(1, "registering Tor check observer");
    torbutton_tor_check_observer.register();

    // Detect toolbar customization and update arrow on about:tor pages.
    window.addEventListener("aftercustomization", function() {
      torbutton_update_all_abouttor_pages(undefined, undefined);
    }, false);
    
    //setting up context menu
    //var contextMenu = document.getElementById("contentAreaContextMenu");
    //if (contextMenu)
    //  contextMenu.addEventListener("popupshowing", torbutton_check_contextmenu, false);

    // Add toolbutton to the bar.
    // This should maybe be in the startup function, but we want to add
    // the button to the panel before it's state (color) is set..
    if (!m_tb_prefs.getBoolPref("extensions.torbutton.inserted_button")) {
      torbutton_log(3, 'Adding button');
      try {
        // ESR31-style toolbar is handled by the existing compiled-in pref.
        // We also need to prevent first-run toolbar reorg (#13378), so we
        // reset this toolbar state on first-run.
        try {
          m_tb_prefs.clearUserPref("browser.uiCustomization.state");
        } catch(e) {}
        CustomizableUI.reset();
        CustomizableUI.undoReset();
        torbutton_log(3, 'Button added');
        m_tb_prefs.setBoolPref("extensions.torbutton.inserted_button", true);
      } catch(e) {
        torbutton_log(4, 'Failed to add Torbutton to toolbar: '+e);
      }
    }

    torbutton_update_toolbutton();
    torbutton_notify_if_update_needed();
    torbutton_update_sync_ui();

    createTorCircuitDisplay(m_tb_control_socket_file, m_tb_control_host,
                            m_tb_control_port, m_tb_control_pass,
                            "extensions.torbutton.display_circuit");

    torbutton_log(3, 'init completed');
}


function torbutton_should_prompt_for_language_preference() {
  return torbutton_get_general_useragent_locale().substring(0, 2) != "en" &&
        !m_tb_prefs.getBoolPref("extensions.torbutton.prompted_language");
}


// Bug 1506 P3: This code asks the user once if they want to spoof their
// language to English.
//
// Asks the user whether Torbutton should make "English requests", and updates
// the extensions.torbutton.spoof_english preference accordingly.
function torbutton_prompt_for_language_preference() {
  var prompts = Cc["@mozilla.org/embedcomp/prompt-service;1"]
                  .getService(Ci.nsIPromptService);

  // Display two buttons, both with string titles.
  var flags = prompts.STD_YES_NO_BUTTONS;

  var message = torbutton_get_property_string("torbutton.popup.prompted_language");

  m_tb_prefs.setBoolPref("extensions.torbutton.prompted_language", true);
  // Display modal prompt, anchored to this window.
  var response = prompts.confirmEx(window, "", message, flags,
                                   null, null, null, null, {value: false});

  // Update preferences to reflect their response and to prevent the prompt from
  // being displayed again.
  m_tb_prefs.setBoolPref("extensions.torbutton.spoof_english", response == 0);
}

function torbutton_confirm_plugins() {
  var any_plugins_enabled = false;
  var PH=Cc["@mozilla.org/plugin/host;1"].getService(Ci.nsIPluginHost);
  var P=PH.getPluginTags({});
  for(var i=0; i<P.length; i++) {
      if (!P[i].disabled)
        any_plugins_enabled = true;
  }

  if (!any_plugins_enabled) {
    torbutton_log(3, "False positive on plugin notification. Ignoring");
    return;
  }
  
  torbutton_log(3, "Confirming plugin usage.");

  var prompts = Cc["@mozilla.org/embedcomp/prompt-service;1"]
      .getService(Components.interfaces.nsIPromptService);

  // Display two buttons, both with string titles.
  var flags = prompts.STD_YES_NO_BUTTONS + prompts.BUTTON_DELAY_ENABLE;
      
  var message = torbutton_get_property_string("torbutton.popup.confirm_plugins");
  var askAgainText = torbutton_get_property_string("torbutton.popup.never_ask_again");
  var askAgain = {value: false};

  var wm = Cc["@mozilla.org/appshell/window-mediator;1"]
             .getService(Components.interfaces.nsIWindowMediator);
  var win = wm.getMostRecentWindow("navigator:browser");
  var no_plugins = (prompts.confirmEx(win, "", message, flags, null, null, null,
      askAgainText, askAgain) == 1);

  m_tb_prefs.setBoolPref("extensions.torbutton.confirm_plugins", !askAgain.value);

  // The pref observer for no_tor_plugins will set the appropriate plugin state.
  // So, we only touch the pref if it has changed.
  if (no_plugins != 
      m_tb_prefs.getBoolPref("extensions.torbutton.no_tor_plugins"))
    m_tb_prefs.setBoolPref("extensions.torbutton.no_tor_plugins", no_plugins);
  else
    torbutton_toggle_plugins(no_plugins);

  // Now, if any tabs were open to about:addons, reload them. Our popup
  // messed up that page.
  var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
                     .getService(Components.interfaces.nsIWindowMediator);
  var browserEnumerator = wm.getEnumerator("navigator:browser");
 
  // Check each browser instance for our URL
  while (browserEnumerator.hasMoreElements()) {
    var browserWin = browserEnumerator.getNext();
    var tabbrowser = browserWin.gBrowser;
 
    // Check each tab of this browser instance
    var numTabs = tabbrowser.browsers.length;
    for (var index = 0; index < numTabs; index++) {
      var currentBrowser = tabbrowser.getBrowserAtIndex(index);
      if ("about:addons" == currentBrowser.currentURI.spec) {
        torbutton_log(3, "Got browser: "+currentBrowser.currentURI.spec);
        currentBrowser.reload();
      }
    }
  }
}

function torbutton_inform_about_tbb() {
  var prompts = Cc["@mozilla.org/embedcomp/prompt-service;1"]
      .getService(Components.interfaces.nsIPromptService);

  var message = torbutton_get_property_string("torbutton.popup.prompt_torbrowser");
  var title = torbutton_get_property_string("torbutton.title.prompt_torbrowser");
  var checkbox = {value: false};

  var sb = Components.classes["@mozilla.org/intl/stringbundle;1"]
      .getService(Components.interfaces.nsIStringBundleService);
  var browserstrings = sb.createBundle("chrome://browser/locale/browser.properties");

  var askagain = browserstrings.GetStringFromName("privateBrowsingNeverAsk");

  var response = prompts.alertCheck(null, title, message, askagain, checkbox);

  // Update preferences to reflect their response and to prevent the prompt from
  // being displayed again.
  m_tb_prefs.setBoolPref("extensions.torbutton.prompt_torbrowser", !checkbox.value);
}

// Bug 1506 P2: It might be nice to let people move the button around, I guess?
function torbutton_get_toolbutton() {
    var o_toolbutton = false;

    torbutton_log(1, 'get_toolbutton(): looking for button element');
    if (document.getElementById("torbutton-button")) {
        o_toolbutton = document.getElementById("torbutton-button");
    } else if (document.getElementById("torbutton-button-tb")) {
        o_toolbutton = document.getElementById("torbutton-button-tb");
    } else if (document.getElementById("torbutton-button-tb-msg")) {
        o_toolbutton = document.getElementById("torbutton-button-tb-msg");
    } else {
        torbutton_log(3, 'get_toolbutton(): did not find torbutton-button');
    }

    return o_toolbutton;
}

function torbutton_update_is_needed() {
    var updateNeeded = false;
    try {
        updateNeeded = m_tb_prefs.getBoolPref(k_tb_browser_update_needed_pref);
    } catch (e) {}

    return updateNeeded;
}

function torbutton_notify_if_update_needed() {
    function setOrClearAttribute(aElement, aAttrName, aValue)
    {
        if (!aElement || !aAttrName)
            return;

        if (aValue)
            aElement.setAttribute(aAttrName, aValue);
        else
            aElement.removeAttribute(aAttrName);
    }

    let updateNeeded = torbutton_update_is_needed();

    // Change look of toolbar item (enable/disable animated update icon).
    var btn = torbutton_get_toolbutton();
    setOrClearAttribute(btn, "tbUpdateNeeded", updateNeeded);

    // Update all open about:tor pages.
    torbutton_update_all_abouttor_pages(updateNeeded, undefined);

    // Make the "check for update" menu item bold if an update is needed.
    var item = document.getElementById("torbutton-checkForUpdate");
    setOrClearAttribute(item, "tbUpdateNeeded", updateNeeded);
}

function torbutton_check_for_update() {
    // Open the update prompt in the correct mode.  The update state
    // checks used here were adapted from isPending() and isApplied() in
    // Mozilla's browser/base/content/aboutDialog.js code.
    let updateMgr = Cc["@mozilla.org/updates/update-manager;1"]
                     .getService(Ci.nsIUpdateManager);
    let update = updateMgr.activeUpdate;
    let updateState = (update) ? update.state : undefined;
    let pendingStates = [ "pending", "pending-service",
                          "applied", "applied-service" ];
    let isPending = (updateState && (pendingStates.indexOf(updateState) >= 0));

    let prompter = Cc["@mozilla.org/updates/update-prompt;1"]
                     .createInstance(Ci.nsIUpdatePrompt);
    if (isPending)
        prompter.showUpdateDownloaded(update, false);
    else
        prompter.checkForUpdates();
}

// Pass undefined for a parameter to have this function determine it.
// Returns a count of open pages that were updated,
function torbutton_update_all_abouttor_pages(aUpdateNeeded, aTorIsOn) {
  if (aUpdateNeeded === undefined)
    aUpdateNeeded = torbutton_update_is_needed();
  if (aTorIsOn === undefined)
    aTorIsOn = torbutton_tor_check_ok();

  var count = 0;
  var tabBrowser = top.getBrowser();
  var tabs = tabBrowser.mTabs;
  if (tabs && (tabs.length > 0)) {
    for (var tab = tabs[0]; tab != null; tab = tab.nextSibling) {
      try {
        let doc = tabBrowser.getBrowserForTab(tab).contentDocument;
        if (torbutton_update_abouttor_doc(doc, aTorIsOn, aUpdateNeeded))
          ++count;
      } catch(e) {}
    }
  }

  return count;
}

// Returns true if aDoc is an about:tor page.
function torbutton_update_abouttor_doc(aDoc, aTorOn, aUpdateNeeded) {
  var isAboutTor = torbutton_is_abouttor_doc(aDoc);
  if (isAboutTor) {
    if (aTorOn)
      aDoc.body.setAttribute("toron", "yes");
    else
      aDoc.body.removeAttribute("toron");

    if (aUpdateNeeded)
      aDoc.body.setAttribute("torNeedsUpdate", "yes"); 
    else
      aDoc.body.removeAttribute("torNeedsUpdate");

    // Display product name and TBB version.
    try {
      const kBrandBundle = "chrome://branding/locale/brand.properties";
      let brandBundle = Cc["@mozilla.org/intl/stringbundle;1"]
                          .getService(Ci.nsIStringBundleService)
                          .createBundle(kBrandBundle);
      let productName = brandBundle.GetStringFromName("brandFullName");
      let tbbVersion = m_tb_prefs.getCharPref("torbrowser.version");
      let e = aDoc.getElementById("torstatus-version");

      while (e.firstChild)
        e.removeChild(e.firstChild);
      e.appendChild(aDoc.createTextNode(productName + '\n' + tbbVersion));
    } catch (e) {}

    let containerName = "torstatus-" + (aTorOn ? "on" : "off") + "-container";
    torbutton_adjust_abouttor_fontsizes(aDoc, containerName);
    torbutton_update_abouttor_arrow(aDoc);
  }

  return isAboutTor;
}

// Ensure that text in top area does not overlap the tor on/off (onion) image.
// This is done by reducing the font sizes as necessary.
function torbutton_adjust_abouttor_fontsizes(aDoc, aContainerName)
{
  let imgElem = aDoc.getElementById("torstatus-image");
  let containerElem = aDoc.getElementById(aContainerName);
  if (!imgElem || !containerElem)
    return;

  try
  {
    let imgRect = imgElem.getBoundingClientRect();

    for (let textElem = containerElem.firstChild; textElem;
         textElem = textElem.nextSibling)
    {
      if ((textElem.nodeType != textElem.ELEMENT_NODE) ||
          (textElem.nodeName.toLowerCase() == "br"))
      {
        continue;
      }

      let textRect = textElem.getBoundingClientRect();
      if (0 == textRect.width)
        continue;

      // Reduce font to 90% of previous size, repeating the process up to 7
      // times.  This allows for a maximum reduction to just less than 50% of
      // the original size.
      let maxTries = 7;
      while ((textRect.left < imgRect.right) && (--maxTries >= 0))
      {
        let style = aDoc.defaultView.getComputedStyle(textElem, null);
        let fontSize = parseFloat(style.getPropertyValue("font-size"));
        textElem.style.fontSize = (fontSize * 0.9) + "px";
        textRect = textElem.getBoundingClientRect();
      }
    }
  } catch (e) {}
}

// Determine X position of torbutton toolbar item and pass it through
// to the xhtml document by setting a torbutton-xpos attribute on the body.
// The value that is set takes retina displays and content zoom into account.
function torbutton_update_abouttor_arrow(aDoc) {
  try {
    let tbXpos = -1;
    let tbItem = torbutton_get_toolbutton();
    if (tbItem) {
      let tbItemRect = tbItem.getBoundingClientRect();
      let contentElem = document.getElementById("content");
      let contentRect = contentElem.getBoundingClientRect();
      if (tbItemRect.top < contentRect.top) {
        tbXpos = tbItemRect.left + (tbItemRect.width / 2.0) - contentRect.left;
      }
    }

    if (tbXpos >= 0) {
      // Convert to device-independent units, compensating for retina display
      // and content zoom that may be in effect on the about:tor page.
      // Because window.devicePixelRatio always returns 1.0 for non-Chrome
      // windows (see bug 13875), we use screenPixelsPerCSSPixel for the
      // content window.
      tbXpos *= window.devicePixelRatio;
      let pixRatio = gBrowser.contentWindow
                             .QueryInterface(Ci.nsIInterfaceRequestor)
                             .getInterface(Ci.nsIDOMWindowUtils)
                             .screenPixelsPerCSSPixel;
      tbXpos = Math.round(tbXpos / pixRatio);
      aDoc.body.setAttribute("torbutton-xpos", tbXpos);
    } else {
      aDoc.body.removeAttribute("torbutton-xpos");
    }

    let evt = new Event("AboutTorAdjustArrow");
    aDoc.dispatchEvent(evt);
  } catch(e) {}
}

function torbutton_on_abouttor_load(aDoc) {
  if (torbutton_is_abouttor_doc(aDoc) &&
      !aDoc.documentElement.hasAttribute("aboutTorLoaded")) {
    aDoc.documentElement.setAttribute("aboutTorLoaded", true);

    // Show correct Tor on/off and "update needed" status.
    let torOn = torbutton_tor_check_ok();
    let needsUpdate = torbutton_update_is_needed();
    torbutton_update_abouttor_doc(aDoc, torOn, needsUpdate);

    aDoc.defaultView.addEventListener("resize",
                      function() { torbutton_update_abouttor_arrow(aDoc); },
                      false);

    // Insert "Test Tor Network Settings" url.
    let elem = aDoc.getElementById("testTorSettings");
    if (elem) {
      let locale = m_tb_prefs.getCharPref("general.useragent.locale");
      locale = locale.replace(/-/g, '_');
      let url = m_tb_prefs.getCharPref(
                      "extensions.torbutton.test_url_interactive");
      elem.href = url.replace(/__LANG__/g, locale);
    }
  }

  if (m_tb_orig_BrowserOnAboutPageLoad)
    m_tb_orig_BrowserOnAboutPageLoad(aDoc);

  // Show the notification about the new security slider.
  if (m_tb_prefs.
      getBoolPref("extensions.torbutton.show_slider_notification")) {
    let sb = torbutton_get_stringbundle();
    let button_label =
      torbutton_get_property_string("torbutton.slider_notification_button");
    let box = gBrowser.getNotificationBox();

    let buttons = [{
      label: button_label,
      accessKey: 'S',
      popup: null,
      callback: function() {
        window.openDialog("chrome://torbutton/content/preferences.xul",
        "torbutton-preferences","chrome");}
    }];

    let priority = box.PRIORITY_INFO_LOW;
    let message =
      torbutton_get_property_string("torbutton.slider_notification");

    box.appendNotification(message, 'new-menu-notification',
                           "chrome://torbutton/skin/tor-enabled-16.png",
                           priority, buttons);
    m_tb_prefs.
      setBoolPref("extensions.torbutton.show_slider_notification", false);
  }
}

function torbutton_is_abouttor_doc(aDoc) {
  return (aDoc && /^about:tor$/i.test(aDoc.documentURI.toLowerCase()));
}

// Bug 1506 P4: Checking for Tor Browser updates is pretty important,
// probably even as a fallback if we ever do get a working updater.
function torbutton_do_async_versioncheck() {
  if (!m_tb_tbb || !m_tb_prefs.getBoolPref("extensions.torbutton.versioncheck_enabled")) {
    return;
  }

  // Suppress update check if done recently.
  const kMinSecsBetweenChecks = 120 * 60; // 2.0 hours
  var now = Date.now() / 1000;
  var lastCheckTime;
  try {
    lastCheckTime = parseFloat(m_tb_prefs.getCharPref(k_tb_last_update_check_pref));
    if (isNaN(lastCheckTime))
      lastCheckTime = undefined;
  } catch (e) {}

  if (lastCheckTime && ((now - lastCheckTime) < kMinSecsBetweenChecks))
    return;

  m_tb_prefs.setCharPref(k_tb_last_update_check_pref, now);

  torbutton_log(3, "Checking version with socks port: "
          +m_tb_prefs.getIntPref("network.proxy.socks_port"));
  try {
    var req = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"]
                            .createInstance(Components.interfaces.nsIXMLHttpRequest);
    //var req = new XMLHttpRequest(); Blocked by content policy
    var url = m_tb_prefs.getCharPref("extensions.torbutton.versioncheck_url");
    req.open('GET', url, true);
    req.channel.loadFlags |= Ci.nsIRequest.LOAD_BYPASS_CACHE;
    req.overrideMimeType("text/json");
    req.onreadystatechange = function (oEvent) {  
      if (req.readyState === 4) {
        if(req.status == 200) {
          if(!req.responseText) {
            torbutton_log(5, "Version check failed! No JSON present!");
            return -1;
          }
          try {
            var version_list = JSON.parse(req.responseText);
            var my_version = m_tb_prefs.getCharPref("torbrowser.version");
            for (var v in version_list) {
              if (version_list[v] == my_version) {
                torbutton_log(3, "Version check passed.");
                m_tb_prefs.setBoolPref(k_tb_browser_update_needed_pref, false);
                return;
              }
            }
            torbutton_log(5, "Your Tor Browser is out of date.");
            m_tb_prefs.setBoolPref(k_tb_browser_update_needed_pref, true);
            return;
          } catch(e) {
            torbutton_log(5, "Version check failed! JSON parsing error: "+e);
            return;
          }
        } else if (req.status == 404) {
          // We're going to assume 404 means the service is not implemented yet.
          torbutton_log(3, "Version check failed. Versions file is 404.");
          return -1;
        }
        torbutton_log(5, "Version check failed! Web server error: "+req.status);
        return -1;
      }  
    };  
    req.send(null);
  } catch(e) {
    if(e.result == 0x80004005) { // NS_ERROR_FAILURE
      torbutton_log(5, "Version check failed! Is tor running?");
      return -1;
    }
    torbutton_log(5, "Version check failed! Tor internal error: "+e);
    return -1;
  }

}

function torbutton_update_toolbutton()
{
  let o_toolbutton = torbutton_get_toolbutton();
  if (!o_toolbutton) return;

  let isOK = torbutton_tor_check_ok();
  let tbstatus = isOK ? "on" : "off";
  o_toolbutton.setAttribute("tbstatus", tbstatus);

  let tooltipKey = isOK ? "torbutton.panel.label.enabled"
                        : "torbutton.panel.label.disabled";
  o_toolbutton.setAttribute("tooltiptext",
                            torbutton_get_property_string(tooltipKey));
}

// Bug 1506 P4: Timezone spoofing is pretty important
function torbutton_set_timezone() {
    /* Windows doesn't call tzset() automatically.. Linux and MacOS
     * both do though.. FF3.5 now calls _tzset() for us on windows.
     */
    torbutton_log(3, "Setting timezone to UTC");
    var environ = Components.classes["@mozilla.org/process/environment;1"]
                   .getService(Components.interfaces.nsIEnvironment);
    environ.set("TZ", "UTC");
}

// Bug 1506 P3: Support code for language+uagent spoofing
function torbutton_get_general_useragent_locale() {
   try {
        var locale = m_tb_prefs.getCharPref("general.useragent.locale");
        if (/chrome:\/\//.test(locale)) {
            return m_tb_prefs.getComplexValue("general.useragent.locale",
                       Components.interfaces.nsIPrefLocalizedString).data;
        }
        return locale;
    } catch(err) {
        torbutton_log(4, "Error while getting general.useragent.locale:" + err);
        return 'en-US';
    }
}

// Bug 1506 P4: Control port interaction. Needed for New Identity.
function torbutton_socket_readline(input) {
  var str = "";
  var bytes;
  while((bytes = input.readBytes(1)) != "\n") {
    if (bytes != '\r')
      str += bytes;
  }
  return str;
}

// Bug 1506 P4: Control port interaction. Needed for New Identity.
function torbutton_read_authentication_cookie(path) {
  var file = Components.classes['@mozilla.org/file/local;1']
             .createInstance(Components.interfaces.nsILocalFile);
  file.initWithPath(path);
  var fileStream = Components.classes['@mozilla.org/network/file-input-stream;1']
                   .createInstance(Components.interfaces.nsIFileInputStream);
  fileStream.init(file, 1, 0, false);
  var binaryStream = Components.classes['@mozilla.org/binaryinputstream;1']
                     .createInstance(Components.interfaces.nsIBinaryInputStream);
  binaryStream.setInputStream(fileStream);
  var array = binaryStream.readByteArray(fileStream.available());
  binaryStream.close();
  fileStream.close();
  return torbutton_array_to_hexdigits(array);
}

// Bug 1506 P4: Control port interaction. Needed for New Identity.
function torbutton_array_to_hexdigits(array) {
  return array.map(function(c) {
                     return String("0" + c.toString(16)).slice(-2)
                   }).join('');
};

// Bug 1506 P4: Control port interaction. Needed for New Identity.
//
// Executes a command on the control port.
// Return a string response upon success and null upon error.
function torbutton_send_ctrl_cmd(command) {

  // We spin the event queue until it is empty and we can be sure that sending
  // NEWNYM is not leading to a deadlock (see bug 9531 comment 23 for an
  // invstigation on why and when this may happen). This is surrounded by
  // suppressing/unsuppressing user initiated events in a window's document to
  // be sure that these events are not interfering with processing events being
  // in the event queue.
  var thread = Cc["@mozilla.org/thread-manager;1"].
               getService(Ci.nsIThreadManager).currentThread;
  m_tb_domWindowUtils.suppressEventHandling(true);
  while (thread.processNextEvent(false)) {}
  m_tb_domWindowUtils.suppressEventHandling(false);

  try {
    let sts = Cc["@mozilla.org/network/socket-transport-service;1"]
        .getService(Ci.nsISocketTransportService);
    let socket;
    if (m_tb_control_socket_file) {
      socket = sts.createUnixDomainTransport(m_tb_control_socket_file);
    } else {
      socket = sts.createTransport(null, 0, m_tb_control_host,
                                   m_tb_control_port, null);
    }

    // If we don't get a response from the control port in 2 seconds, someting is wrong..
    socket.setTimeout(Ci.nsISocketTransport.TIMEOUT_READ_WRITE, 2);

    var input = socket.openInputStream(3, 1, 1); // 3 == OPEN_BLOCKING|OPEN_UNBUFFERED
    var output = socket.openOutputStream(3, 1, 1); // 3 == OPEN_BLOCKING|OPEN_UNBUFFERED

    var inputStream     = Cc["@mozilla.org/binaryinputstream;1"].createInstance(Ci.nsIBinaryInputStream);
    var outputStream    = Cc["@mozilla.org/binaryoutputstream;1"].createInstance(Ci.nsIBinaryOutputStream);

    inputStream.setInputStream(input);
    outputStream.setOutputStream(output);

    var auth_cmd = "AUTHENTICATE "+m_tb_control_pass+"\r\n";
    outputStream.writeBytes(auth_cmd, auth_cmd.length);

    var bytes = torbutton_socket_readline(inputStream);

    if (bytes.indexOf("250") != 0) {
      torbutton_safelog(4, "Unexpected auth response on control port "+m_tb_control_desc+":", bytes);
      return null;
    }

    outputStream.writeBytes(command, command.length);
    bytes = torbutton_socket_readline(inputStream);
    if(bytes.indexOf("250") != 0) {
      torbutton_safelog(4, "Unexpected command response on control port "+m_tb_control_desc+":", bytes);
      return null;
    }

    // Closing these streams prevents a shutdown hang on Mac OS. See bug 10201.
    inputStream.close();
    outputStream.close();
    socket.close(Cr.NS_OK);
    return bytes.substr(4);
  } catch(e) {
    torbutton_log(4, "Exception on control port "+e);
    return null;
  }
}

// Bug 1506 P4: Needed for New IP Address
function torbutton_new_circuit() {
  let thirdPartyUtil = Cc["@mozilla.org/thirdpartyutil;1"]
                         .getService(Ci.mozIThirdPartyUtil);

  let firstPartyDomain = thirdPartyUtil
                             .getFirstPartyHostForIsolation(gBrowser.currentURI);

  let domainIsolator = Cc["@torproject.org/domain-isolator;1"]
                          .getService(Ci.nsISupports).wrappedJSObject;

  domainIsolator.newCircuitForDomain(firstPartyDomain);

  gBrowser.reloadWithFlags(Ci.nsIWebNavigation.LOAD_FLAGS_BYPASS_CACHE);
}

// Bug 1506 P4: Needed for New Identity.
function torbutton_new_identity() {
  try {
    // Make sure that we can only click once on New Identiy to avoid race
    // conditions leading to failures (see bug 11783 for an example).
    document.getElementById("torbutton-new-identity").disabled = true;

    let shouldConfirm =  m_tb_prefs.getBoolPref("extensions.torbutton.confirm_newnym");

    if (shouldConfirm) {
      let prompts = Cc["@mozilla.org/embedcomp/prompt-service;1"]
                      .getService(Ci.nsIPromptService);

      // Display two buttons, both with string titles.
      let flags = prompts.STD_YES_NO_BUTTONS;

      let message = torbutton_get_property_string("torbutton.popup.confirm_newnym");
      let askAgainText = torbutton_get_property_string("torbutton.popup.never_ask_again");
      let askAgain = {value: false};

      let confirmed = (prompts.confirmEx(null, "", message, flags, null, null, null,
          askAgainText, askAgain) == 0);

      m_tb_prefs.setBoolPref("extensions.torbutton.confirm_newnym", !askAgain.value);

      if (confirmed) {
        torbutton_do_new_identity();
      } else {
        document.getElementById("torbutton-new-identity").disabled = false;
      }
    } else {
        torbutton_do_new_identity();
    }
  } catch(e) {
    // If something went wrong make sure we have the New Identity button
    // enabled (again).
    document.getElementById("torbutton-new-identity").disabled = false;
    torbutton_log(5, "Unexpected error on new identity: "+e);
    window.alert("Torbutton: Unexpected error on new identity: "+e);
  }
}

/* The "New Identity" implementation does the following:
 *   1. Disables Javascript and plugins on all tabs
 *   2. Clears state:
 *      a. OCSP
 *      b. Cache + image cache
 *      c. Site-specific zoom
 *      d. Cookies+DOM Storage+safe browsing key
 *      e. google wifi geolocation token
 *      f. http auth
 *      g. SSL Session IDs
 *      h. last open location url
 *      i. clear content prefs
 *      j. permissions
 *      k. site security settings (e.g. HSTS)
 *      l. IndexedDB and asmjscache storage
 *   3. Sends tor the NEWNYM signal to get a new circuit
 *   4. Opens a new window with the default homepage
 *   5. Closes this window
 *
 * XXX: intermediate SSL certificates are not cleared.
 */
// Bug 1506 P4: Needed for New Identity.
function torbutton_do_new_identity() {
  var obsSvc = Components.classes["@mozilla.org/observer-service;1"].getService(Ci.nsIObserverService);
  torbutton_log(3, "New Identity: Disabling JS");
  torbutton_disable_all_js();

  m_tb_prefs.setBoolPref("browser.zoom.siteSpecific",
                         !m_tb_prefs.getBoolPref("browser.zoom.siteSpecific"));
  m_tb_prefs.setBoolPref("browser.zoom.siteSpecific",
                         !m_tb_prefs.getBoolPref("browser.zoom.siteSpecific"));

  try {
      if(m_tb_prefs.prefHasUserValue("geo.wifi.access_token")) {
          m_tb_prefs.clearUserPref("geo.wifi.access_token");
      }
  } catch(e) {
      torbutton_log(3, "Exception on wifi token clear: "+e);
  }

  try {
      if(m_tb_prefs.prefHasUserValue("general.open_location.last_url")) {
          m_tb_prefs.clearUserPref("general.open_location.last_url");
      }
  } catch(e) {
      torbutton_log(3, "Exception on wifi token clear: "+e);
  }

  torbutton_log(3, "New Identity: Closing tabs and clearing searchbox");

  torbutton_close_tabs_on_new_identity();

  // Bug #10800: Trying to clear search/find can cause exceptions
  // in unknown cases. Just log for now.
  try {
    var searchBar = window.document.getElementById("searchbar");
    if (searchBar)
        searchBar.textbox.reset();
  } catch(e) {
    torbutton_log(5, "New Identity: Exception on clearing search box: "+e);
  }

  try {
    if (gFindBarInitialized) {
        var findbox = gFindBar.getElement("findbar-textbox");
        findbox.reset();
        gFindBar.close();
    }
  } catch(e) {
    torbutton_log(5, "New Identity: Exception on clearing find bar: "+e);
  }

  torbutton_log(3, "New Identity: Emitting Private Browsing Session clear event");
  obsSvc.notifyObservers(null, "browser:purge-session-history", "");

  torbutton_log(3, "New Identity: Clearing NoScript Temporary Permissions");

  try {
    if ("@maone.net/noscript-service;1" in Components.classes) {
      var nsSvc = Components.classes["@maone.net/noscript-service;1"].getService().wrappedJSObject
      nsSvc.eraseTemp();
    }
  } catch(e) {
    torbutton_log(5, "New Identity: Error clearing NoScript Temporary Permissions: "+e);
    window.alert("Torbutton: Error clearing NoScript Temporary Permissions: "+e);
  }

  torbutton_log(3, "New Identity: Clearing HTTP Auth");

  if(m_tb_prefs.getBoolPref('extensions.torbutton.clear_http_auth')) {
      var auth = Components.classes["@mozilla.org/network/http-auth-manager;1"].
          getService(Components.interfaces.nsIHttpAuthManager);
      auth.clearAll();
  }

  torbutton_log(3, "New Identity: Clearing Crypto Tokens");

  // Clear all crypto auth tokens. This includes calls to PK11_LogoutAll(),
  // nsNSSComponent::LogoutAuthenticatedPK11() and clearing the SSL session
  // cache.
  let sdr = Components.classes["@mozilla.org/security/sdr;1"].
                       getService(Components.interfaces.nsISecretDecoderRing);
  sdr.logoutAndTeardown();

  // This clears the OCSP cache.
  //
  // nsNSSComponent::Observe() watches security.OCSP.enabled, which calls
  // setValidationOptions(), which in turn calls setNonPkixOcspEnabled() which,
  // if security.OCSP.enabled is set to 0, calls CERT_DisableOCSPChecking(),
  // which calls CERT_ClearOCSPCache().
  // See: https://mxr.mozilla.org/comm-esr24/source/mozilla/security/manager/ssl/src/nsNSSComponent.cpp
  var ocsp = m_tb_prefs.getIntPref("security.OCSP.enabled");
  m_tb_prefs.setIntPref("security.OCSP.enabled", 0);
  m_tb_prefs.setIntPref("security.OCSP.enabled", ocsp);

  // This clears the site permissions on Tor Browser
  // XXX: Tie to some kind of disk-ok pref?
  try {
      Services.perms.removeAll();
  } catch(e) {
      // Actually, this catch does not appear to be needed. Leaving it in for
      // safety though.
      torbutton_log(3, "Can't clear permissions: Not Tor Browser: "+e);
  }

   // Clear site security settings
   let sss = Cc["@mozilla.org/ssservice;1"].
     getService(Ci.nsISiteSecurityService);
   sss.clearAll();

  // This clears the undo tab history.
  var tabs = m_tb_prefs.getIntPref("browser.sessionstore.max_tabs_undo");
  m_tb_prefs.setIntPref("browser.sessionstore.max_tabs_undo", 0);
  m_tb_prefs.setIntPref("browser.sessionstore.max_tabs_undo", tabs);

  torbutton_log(3, "New Identity: Clearing Image Cache");
  torbutton_clear_image_caches();

  torbutton_log(3, "New Identity: Clearing Offline Cache");

  try {
    for (let contextInfo of [LoadContextInfo.default, LoadContextInfo.private]) {
      let appCacheStorage = Services.cache2.appCacheStorage(contextInfo, null);
      // The following call (asyncEvictStorage) is actually synchronous, either
      // if we have pref "browser.cache.use_new_backend" -> 1 or
      // "browser.cache.use_new_backend_temp" -> true,
      // then we are using the new cache (cache2) which operates synchronously.
      // If we are using the old cache, then the tor-browser.git patch for
      // #5715 also makes this synchronous. So we pass a null callback.
      appCacheStorage.asyncEvictStorage(null);
    }
  } catch(e) {
      torbutton_log(5, "Exception on cache clearing: "+e);
      window.alert("Torbutton: Unexpected error during offline cache clearing: "+e);
  }

  torbutton_log(3, "New Identity: Clearing Disk and Memory Caches");

  try {
      Services.cache2.clear();
  } catch(e) {
      torbutton_log(5, "Exception on cache clearing: "+e);
      window.alert("Torbutton: Unexpected error during cache clearing: "+e);
  }

  torbutton_log(3, "New Identity: Clearing storage");

  let orig_quota_test = m_tb_prefs.getBoolPref("dom.quotaManager.testing");
  try {
      // This works only by setting the pref to `true` otherwise we get an
      // exception and nothing is happening.
      m_tb_prefs.setBoolPref("dom.quotaManager.testing", true);
      Cc["@mozilla.org/dom/quota-manager-service;1"]
          .getService(Ci.nsIQuotaManagerService).clear();
  } catch(e) {
      torbutton_log(5, "Exception on storage clearing: "+e);
  } finally {
      m_tb_prefs.setBoolPref("dom.quotaManager.testing", orig_quota_test);
  }

  torbutton_log(3, "New Identity: Clearing Cookies and DOM Storage");

  if (m_tb_prefs.getBoolPref('extensions.torbutton.cookie_protections')) {
    var selector = Components.classes["@torproject.org/cookie-jar-selector;1"]
                    .getService(Components.interfaces.nsISupports)
                    .wrappedJSObject;
    // This emits "cookie-changed", "cleared", which kills DOM storage
    // and the safe browsing API key
    selector.clearUnprotectedCookies("tor");
  } else {
    torbutton_clear_cookies();
  }

  torbutton_log(3, "New Identity: Closing open connections");

  // Clear keep-alive
  obsSvc.notifyObservers(this, "net:prune-all-connections", null);

  torbutton_log(3, "New Identity: Clearing Content Preferences");

  // XXX: This may not clear zoom site-specific
  // browser.content.full-zoom
  if (Ci.nsIContentPrefService2) {   // Firefox >= 20
    XPCOMUtils.defineLazyModuleGetter(this, "PrivateBrowsingUtils",
                            "resource://gre/modules/PrivateBrowsingUtils.jsm");
    var pbCtxt = PrivateBrowsingUtils.privacyContextFromWindow(window);
    var cps = Cc["@mozilla.org/content-pref/service;1"]
                .getService(Ci.nsIContentPrefService2);
    cps.removeAllDomains(pbCtxt);
  } else {                           // Firefox < 20
    var cps = Cc["@mozilla.org/content-pref/service;1"].
        createInstance(Ci.nsIContentPrefService);
    cps.removeGroupedPrefs();
  }

  torbutton_log(3, "New Identity: Syncing prefs");

  // Force prefs to be synced to disk
  var prefService = Components.classes["@mozilla.org/preferences-service;1"]
      .getService(Components.interfaces.nsIPrefService);
  prefService.savePrefFile(null);

  torbutton_log(3, "New Identity: Clearing permissions");

  let pm = Cc["@mozilla.org/permissionmanager;1"].
           getService(Ci.nsIPermissionManager);
  pm.removeAll();

  // Clear the domain isolation state.
  torbutton_log(3, "New Identity: Clearing domain isolator");

  let domainIsolator = Cc["@torproject.org/domain-isolator;1"]
      .getService(Ci.nsISupports).wrappedJSObject;
  domainIsolator.clearIsolation();

  torbutton_log(3, "New Identity: Sending NEWNYM");

  // We only support TBB for newnym.
  if (!m_tb_control_pass || (!m_tb_control_socket_file && !m_tb_control_port)) {
    var warning = torbutton_get_property_string("torbutton.popup.no_newnym");
    torbutton_log(5, "Torbutton cannot safely newnym. It does not have access to the Tor Control Port.");
    window.alert(warning);
  } else {
    if (!torbutton_send_ctrl_cmd("SIGNAL NEWNYM\r\n")) {
      var warning = torbutton_get_property_string("torbutton.popup.no_newnym");
      torbutton_log(5, "Torbutton was unable to request a new circuit from Tor");
      window.alert(warning);
    }
  }

  torbutton_log(3, "Ending any remaining private browsing sessions.");
  obsSvc.notifyObservers(null, "last-pb-context-exited", "");

  torbutton_log(3, "New Identity: Opening a new browser window");

  // Open a new window with the TBB check homepage
  // In Firefox >=19, can pass {private: true} but we do not need it because
  // we have browser.privatebrowsing.autostart = true
  OpenBrowserWindow();

  torbutton_log(3, "New identity successful");

  // Run garbage collection and cycle collection after window is gone.
  // This ensures that blob URIs are forgotten.
  window.addEventListener("unload", function (event) {
    torbutton_log(3, "Initiating New Identity GC pass");
    // Clear out potential pending sInterSliceGCTimer:
    m_tb_domWindowUtils.runNextCollectorTimer();

    // Clear out potential pending sICCTimer:
    m_tb_domWindowUtils.runNextCollectorTimer();

    // Schedule a garbage collection in 4000-1000ms...
    m_tb_domWindowUtils.garbageCollect();

    // To ensure the GC runs immediately instead of 4-10s from now, we need
    // to poke it at least 11 times.
    // We need 5 pokes for GC, 1 poke for the interSliceGC, and 5 pokes for CC.
    // See nsJSContext::RunNextCollectorTimer() in
    // https://mxr.mozilla.org/mozilla-central/source/dom/base/nsJSEnvironment.cpp#1970.
    // XXX: We might want to make our own method for immediate full GC...
    for (let poke = 0; poke < 11; poke++) {
       m_tb_domWindowUtils.runNextCollectorTimer();
    }

    // And now, since the GC probably actually ran *after* the CC last time,
    // run the whole thing again.
    m_tb_domWindowUtils.garbageCollect();
    for (let poke = 0; poke < 11; poke++) {
       m_tb_domWindowUtils.runNextCollectorTimer();
    }

    torbutton_log(3, "Completed New Identity GC pass");
  });

  // Close the current window for added safety
  window.close();
}

function torbutton_clear_image_caches()
{
  try {
    let imgCache;
    let imgTools = Cc["@mozilla.org/image/tools;1"].getService(Ci.imgITools);
    if (!("getImgCacheForDocument" in imgTools)) {
      // In Firefox 17 and older, there is one global image cache.  Clear it.
      imgCache = Cc["@mozilla.org/image/cache;1"].getService(Ci.imgICache);
      imgCache.clearCache(false); // evict all but chrome cache
    } else {
      // In Firefox 18 and newer, there are two image caches:  one that is
      // used for regular browsing and one that is used for private browsing.

      // Clear the non-private browsing image cache.
      imgCache = imgTools.getImgCacheForDocument(null);
      imgCache.clearCache(false); // evict all but chrome cache

      // Try to clear the private browsing cache.  To do so, we must locate
      // a content document that is contained within a private browsing window.
      let didClearPBCache = false;
      let wm = Cc["@mozilla.org/appshell/window-mediator;1"]
                 .getService(Ci.nsIWindowMediator);
      let enumerator = wm.getEnumerator("navigator:browser");
      while (!didClearPBCache && enumerator.hasMoreElements()) {
        let win = enumerator.getNext();
        let browserDoc = win.document.documentElement;
        if (!browserDoc.hasAttribute("privatebrowsingmode"))
          continue;

        let tabbrowser = win.getBrowser();
        if (!tabbrowser)
          continue;

        var tabCount = tabbrowser.browsers.length;
        for (var i = 0; i < tabCount; i++) {
          let doc = tabbrowser.browsers[i].contentDocument;
          if (doc) {
            imgCache = imgTools.getImgCacheForDocument(doc);
            imgCache.clearCache(false); // evict all but chrome cache
            didClearPBCache = true;
            break;
          }
        }
      }
    }
  } catch(e) {
    // FIXME: This can happen in some rare cases involving XULish image data
    // in combination with our image cache isolation patch. Sure isn't
    // a good thing, but it's not really a super-cookie vector either.
    // We should fix it eventually.
    torbutton_log(4, "Exception on image cache clearing: "+e);
  }
}

/* Called when we switch the use_nontor_proxy pref in either direction.
 *
 * Enables/disables domain isolation and NoScript ABE, and then does
 * new identity
 */
function torbutton_use_nontor_proxy()
{
  let domainIsolator = Cc["@torproject.org/domain-isolator;1"]
      .getService(Ci.nsISupports).wrappedJSObject;

  if (m_tb_prefs.getBoolPref("extensions.torbutton.use_nontor_proxy")) {
    // We need to enable ABE because non-tor proxies won't reject localhost
    // and RFC1918, and we should block them. (The default ABE policy does this).
    m_tb_prefs.setBoolPref("noscript.ABE.enabled", true);

    // Disable domain isolation
    domainIsolator.disableIsolation();
  } else {
    m_tb_prefs.setBoolPref("noscript.ABE.enabled", false);

    domainIsolator.enableIsolation();
  }

  // Always reset our identity if the proxy has changed from tor
  // to non-tor.
  torbutton_do_new_identity();
}

function torbutton_do_tor_check()
{
  let checkSvc = Cc["@torproject.org/torbutton-torCheckService;1"]
                   .getService(Ci.nsISupports).wrappedJSObject;
  if (checkSvc.kCheckNotInitiated != checkSvc.statusOfTorCheck ||
      m_tb_prefs.getBoolPref("extensions.torbutton.use_nontor_proxy") ||
      !m_tb_prefs.getBoolPref("extensions.torbutton.test_enabled"))
    return; // Only do the check once.

  // If we have a tor control port and transparent torification is off,
  // perform a check via the control port.
  const kEnvSkipControlPortTest = "TOR_SKIP_CONTROLPORTTEST";
  const kEnvUseTransparentProxy = "TOR_TRANSPROXY";
  var env = Cc["@mozilla.org/process/environment;1"]
                 .getService(Ci.nsIEnvironment);
  if ((m_tb_control_socket_file || m_tb_control_port) &&
      !env.exists(kEnvUseTransparentProxy) &&
      !env.exists(kEnvSkipControlPortTest) &&
      m_tb_prefs.getBoolPref("extensions.torbutton.local_tor_check")) {
    if (torbutton_local_tor_check())
      checkSvc.statusOfTorCheck = checkSvc.kCheckSuccessful;
    else {
      // The check failed.  Update toolbar icon and tooltip.
      checkSvc.statusOfTorCheck = checkSvc.kCheckFailed;
      torbutton_update_toolbutton();
    }
  }
  else {
    // A local check is not possible, so perform a remote check.
    torbutton_initiate_remote_tor_check();
  }
}

function torbutton_local_tor_check()
{
  let didLogError = false;

  let proxyType = m_tb_prefs.getIntPref("network.proxy.type");
  if (0 == proxyType)
    return false;

  // Ask tor for its SOCKS listener address and port and compare to the
  // browser preferences.
  const kCmdArg = "net/listeners/socks";
  let resp = torbutton_send_ctrl_cmd("GETINFO " + kCmdArg + "\r\n");
  if (!resp)
    return false;

  function logUnexpectedResponse()
  {
    if (!didLogError) {
      didLogError = true;
      torbutton_log(5, "Local Tor check: unexpected GETINFO response: " + resp);
    }
  }

  function removeBrackets(aStr)
  {
    // Remove enclosing square brackets if present.
    if (aStr.startsWith('[') && aStr.endsWith(']'))
      return aStr.substr(1, aStr.length - 2);

    return aStr;
  }

  // Sample response: net/listeners/socks="127.0.0.1:9149" "127.0.0.1:9150"
  // First, check for command argument prefix.
  if (0 != resp.indexOf(kCmdArg + '=')) {
    logUnexpectedResponse();
    return false;
  }

  // Retrieve configured proxy settings and check each listener against them.
  // When a Unix domain socket is configured, a file URL should be present in
  // network.proxy.socks.
  // See: https://bugzilla.mozilla.org/show_bug.cgi?id=1211567
  let socksAddr = m_tb_prefs.getCharPref("network.proxy.socks");
  let socksPort = m_tb_prefs.getIntPref("network.proxy.socks_port");
  let socketPath;
  if (socksAddr && socksAddr.startsWith("file:")) {
    // Convert the file URL to a file path.
    try {
      let ioService = Cc["@mozilla.org/network/io-service;1"]
                        .getService(Ci.nsIIOService);
      let fph = ioService.getProtocolHandler("file")
                         .QueryInterface(Ci.nsIFileProtocolHandler);
      socketPath = fph.getFileFromURLSpec(socksAddr).path;
    } catch (e) {
      torbutton_log(5, "Local Tor check: Unix domain socket error: " + e);
      return false;
    }
  } else {
    socksAddr = removeBrackets(socksAddr);
  }

  let addrArray = resp.substr(kCmdArg.length + 1).split(' ');
  let foundSocksListener = false;
  for (let i = 0; !foundSocksListener && (i < addrArray.length); ++i) {
    let addr = addrArray[i];

    // Remove double quotes if present.
    let len = addr.length;
    if ((len > 2) && ('"' == addr.charAt(0)) && ('"' == addr.charAt(len - 1)))
      addr = addr.substring(1, len - 1);

    if (addr.startsWith("unix:")) {
      if (!socketPath)
        continue;

      // Check against the configured UNIX domain socket proxy.
      let path = addr.substring(5);
      torbutton_log(2, "Tor socks listener (socket): " + path);
      foundSocksListener = (socketPath === path);
    } else if (!socketPath) {
      // Check against the configured TCP proxy. We expect addr:port where addr
      // may be an IPv6 address; that is, it may contain colon characters.
      // Also, we remove enclosing square brackets before comparing addresses
      // because tor requires them but Firefox does not.
      let idx = addr.lastIndexOf(':');
      if (idx < 0) {
        logUnexpectedResponse();
      } else {
        let torSocksAddr = removeBrackets(addr.substring(0, idx));
        let torSocksPort = parseInt(addr.substring(idx + 1), 10);
        if ((torSocksAddr.length < 1) || isNaN(torSocksPort)) {
          logUnexpectedResponse();
        } else {
          torbutton_log(2, "Tor socks listener: " + torSocksAddr + ':'
                           + torSocksPort);
          foundSocksListener = ((socksAddr === torSocksAddr) &&
                                (socksPort === torSocksPort));
        }
      }
    }
  }

  return foundSocksListener;
} // torbutton_local_tor_check


function torbutton_initiate_remote_tor_check()
{
  let obsSvc = Cc["@mozilla.org/observer-service;1"]
                 .getService(Ci.nsIObserverService);

  try {
      let checkSvc = Cc["@torproject.org/torbutton-torCheckService;1"]
                       .getService(Ci.nsISupports).wrappedJSObject;
      let req = checkSvc.createCheckRequest(true); // async
      req.onreadystatechange = function (aEvent) {
          if (req.readyState === 4) {
            let ret = checkSvc.parseCheckResponse(req);

            // If we received an error response from check.torproject.org,
            // set the status of the tor check to failure (we don't want
            // to indicate failure if we didn't receive a response).
            if (ret == 2 || ret == 3 || ret == 5 || ret == 6
                || ret == 7 || ret == 8) {
              checkSvc.statusOfTorCheck = checkSvc.kCheckFailed;
              obsSvc.notifyObservers(null, k_tb_tor_check_failed_topic, null);
            } else if (ret == 4) {
              checkSvc.statusOfTorCheck = checkSvc.kCheckSuccessful;
            } // Otherwise, redo the check later

            torbutton_log(3, "Tor remote check done. Result: " + ret);
          }
      };

      torbutton_log(3, "Sending async Tor remote check");
      req.send(null);
  } catch(e) {
    if (e.result == 0x80004005) // NS_ERROR_FAILURE
      torbutton_log(5, "Tor check failed! Is tor running?");
    else
      torbutton_log(5, "Tor check failed! Tor internal error: "+e);

    checkSvc.statusOfTorCheck = checkSvc.kCheckFailed;
    obsSvc.notifyObservers(null, k_tb_tor_check_failed_topic, null);
  }
} // torbutton_initiate_remote_tor_check()

function torbutton_tor_check_ok()
{
  let checkSvc = Cc["@torproject.org/torbutton-torCheckService;1"]
                   .getService(Ci.nsISupports).wrappedJSObject;
  return (checkSvc.kCheckFailed != checkSvc.statusOfTorCheck);
}

// Bug 1506 P5: Despite the name, this is the way we disable
// plugins for Tor Browser, too.
//
// toggles plugins: true for disabled, false for enabled
function torbutton_toggle_plugins(disable_plugins) {
  if (m_tb_tbb) {
    m_tb_prefs.setBoolPref("plugin.disable", disable_plugins);

    var PH=Cc["@mozilla.org/plugin/host;1"].getService(Ci.nsIPluginHost);
    var P=PH.getPluginTags({});
    for(var i=0; i<P.length; i++) {
        if ("enabledState" in P[i]) { // FF24
          // FIXME: DOCDOC the reasoning for the isDisabled check, or remove it.
          var isDisabled = (P[i].enabledState == Ci.nsIPluginTag.STATE_DISABLED);
          if (!isDisabled && disable_plugins)
            P[i].enabledState = Ci.nsIPluginTag.STATE_DISABLED;
          else if (isDisabled && !disable_plugins)
            P[i].enabledState = Ci.nsIPluginTag.STATE_CLICKTOPLAY;
        } else if (P[i].disabled != disable_plugins) { // FF17
          P[i].disabled=disable_plugins;
        }
    }
  }
}

function torbutton_update_disk_prefs() {
    var mode = m_tb_prefs.getBoolPref("extensions.torbutton.block_disk");

    m_tb_prefs.setBoolPref("browser.privatebrowsing.autostart", mode);
    m_tb_prefs.setBoolPref("browser.cache.disk.enable", !mode);
    m_tb_prefs.setBoolPref("places.history.enabled", !mode);

    m_tb_prefs.setBoolPref("security.nocertdb", mode);

    // No way to clear this beast during New Identity. Leave it off.
    //m_tb_prefs.setBoolPref("dom.indexedDB.enabled", !mode);

    if (m_tb_tbb) m_tb_prefs.setBoolPref("permissions.memory_only", mode);

    // Third party abuse. Leave it off for now.
    //m_tb_prefs.setBoolPref("browser.cache.offline.enable", !mode);

    if (mode) {
        m_tb_prefs.setIntPref("network.cookie.lifetimePolicy", 2);
        m_tb_prefs.setIntPref("browser.download.manager.retention", 1);
    } else {
        m_tb_prefs.setIntPref("network.cookie.lifetimePolicy", 0);
        m_tb_prefs.setIntPref("browser.download.manager.retention", 2);
    }

    // Force prefs to be synced to disk
    var prefService = Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefService);
    prefService.savePrefFile(null);
}

function torbutton_update_fingerprinting_prefs() {
    var mode = m_tb_prefs.getBoolPref("extensions.torbutton.resist_fingerprinting");

    if (m_tb_tbb) {
      if (mode) {
        // Use TBB pref defaults for these two.
        if(m_tb_prefs.prefHasUserValue("browser.display.max_font_attempts"))
          m_tb_prefs.clearUserPref("browser.display.max_font_attempts");
        if(m_tb_prefs.prefHasUserValue("browser.display.max_font_count"))
          m_tb_prefs.clearUserPref("browser.display.max_font_count");

        // Governed also by the spoof_english dialog..
        if (m_tb_prefs.getBoolPref("extensions.torbutton.spoof_english")) {
          m_tb_prefs.setCharPref("intl.accept_languages", "en-US, en");
          m_tb_prefs.setBoolPref("javascript.use_us_english_locale", true);
        } else {
          if(m_tb_prefs.prefHasUserValue("intl.accept_languages"))
            m_tb_prefs.clearUserPref("intl.accept_languages");
          m_tb_prefs.setBoolPref("javascript.use_us_english_locale", false);
        }
      } else {
        m_tb_prefs.setIntPref("browser.display.max_font_attempts",-1);
        m_tb_prefs.setIntPref("browser.display.max_font_count",-1);

        if(m_tb_prefs.prefHasUserValue("intl.accept_languages"))
          m_tb_prefs.clearUserPref("intl.accept_languages");
      }
    }

    m_tb_prefs.setBoolPref("webgl.min_capability_mode", mode);
    m_tb_prefs.setBoolPref("webgl.disable-extensions", mode);
    m_tb_prefs.setBoolPref("dom.battery.enabled", !mode);
    m_tb_prefs.setBoolPref("dom.network.enabled", !mode);
    m_tb_prefs.setBoolPref("dom.enable_performance", !mode);
    m_tb_prefs.setBoolPref("plugin.expose_full_path", !mode);
    m_tb_prefs.setBoolPref("browser.zoom.siteSpecific", !mode);
    m_tb_prefs.setBoolPref("privacy.resistFingerprinting", mode);

    m_tb_prefs.setBoolPref("extensions.torbutton.resize_new_windows", mode);

    // XXX: How do we undo timezone?

    // Force prefs to be synced to disk
    var prefService = Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefService);
    prefService.savePrefFile(null);
}

function torbutton_update_thirdparty_prefs() {
    var mode = m_tb_prefs.getBoolPref("extensions.torbutton.restrict_thirdparty");

    try {
        if (mode) {
            m_tb_prefs.setIntPref("privacy.thirdparty.isolate", 2);
        } else {
            m_tb_prefs.setIntPref("privacy.thirdparty.isolate", 0);
        }
    } catch(e) {}

    if (mode) {
      m_tb_prefs.setIntPref("network.cookie.cookieBehavior", 1);
    } else {
      m_tb_prefs.setIntPref("network.cookie.cookieBehavior", 0);
    }

    m_tb_prefs.setBoolPref("dom.workers.sharedWorkers.enabled", !mode);
    m_tb_prefs.setBoolPref("security.enable_tls_session_tickets", !mode);

    // Force prefs to be synced to disk
    var prefService = Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefService);
    prefService.savePrefFile(null);
}

var torbutton_sec_ml_bool_prefs = {
  "javascript.options.ion.content" : false,
  "javascript.options.typeinference" : false,
  "noscript.forbidMedia" : true,
  "media.webaudio.enabled" : false,
  "mathml.disabled" : true
};

var torbutton_sec_mh_bool_prefs = {
  "javascript.options.baselinejit.content" : false,
  "gfx.font_rendering.opentype_svg.enabled" : false,
  "noscript.global" : false,
  "noscript.globalHttpsWhitelist" : true
};

var torbutton_sec_h_bool_prefs = {
  "noscript.forbidFonts" : true,
  "noscript.global" : false,
  "svg.in-content.enabled" : false
};

function torbutton_update_security_slider() {
  // Avoid checking the custom settings checkbox.
  m_tb_sliderUpdate = true;
  let mode = m_tb_prefs.getIntPref("extensions.torbutton.security_slider");
  let capValue = m_tb_prefs.getCharPref("capability.policy.maonoscript.sites");
  switch (mode) {
   case 1:
      for (p in torbutton_sec_ml_bool_prefs) {
        m_tb_prefs.setBoolPref(p, torbutton_sec_ml_bool_prefs[p])
      }
      for (p in torbutton_sec_mh_bool_prefs) {
        m_tb_prefs.setBoolPref(p, torbutton_sec_mh_bool_prefs[p])
        // noscript.globalHttpsWhitelist is special: We don't want it in this
        // mode.
        if (p === "noscript.globalHttpsWhitelist") {
          m_tb_prefs.setBoolPref(p, !torbutton_sec_mh_bool_prefs[p])
        }
      }
      for (p in torbutton_sec_h_bool_prefs) {
        m_tb_prefs.setBoolPref(p, torbutton_sec_h_bool_prefs[p])
      }
      // Removing "https:" is needed due to a bug in older Noscript versions.
      // We leave that in for a while as there may be users that were affected
      // by this bug. Removing it immediately and having the auto-updater might
      // leave users exposed to the problem.
      if (capValue.indexOf(" https:") >= 0) {
        m_tb_prefs.setCharPref("capability.policy.maonoscript.sites",
          capValue.replace(" https:", ""));
      }
      break;
    case 2:
      for (p in torbutton_sec_ml_bool_prefs) {
        m_tb_prefs.setBoolPref(p, torbutton_sec_ml_bool_prefs[p])
      }
      // Order matters here as both the high mode and the medium-high mode
      // share some preferences/values. So, let's revert the high mode
      // preferences first and set the medium-high mode ones afterwards.
      for (p in torbutton_sec_h_bool_prefs) {
        m_tb_prefs.setBoolPref(p, !torbutton_sec_h_bool_prefs[p])
      }
      for (p in torbutton_sec_mh_bool_prefs) {
        m_tb_prefs.setBoolPref(p, torbutton_sec_mh_bool_prefs[p])
      }
      break;
    case 3:
      for (p in torbutton_sec_ml_bool_prefs) {
        m_tb_prefs.setBoolPref(p, torbutton_sec_ml_bool_prefs[p])
      }
      for (p in torbutton_sec_mh_bool_prefs) {
        m_tb_prefs.setBoolPref(p, !torbutton_sec_mh_bool_prefs[p])
      }
      for (p in torbutton_sec_h_bool_prefs) {
        m_tb_prefs.setBoolPref(p, !torbutton_sec_h_bool_prefs[p])
      }
      // Removing "https:" is needed due to a bug in older Noscript versions.
      // We leave that in for a while as there may be users that were affected
      // by this bug. Removing it immediately and having the auto-updater might
      // leave users exposed to the problem.
      if (capValue.indexOf(" https:") >= 0) {
        m_tb_prefs.setCharPref("capability.policy.maonoscript.sites",
          capValue.replace(" https:", ""));
      }
      break;
    case 4:
      for (p in torbutton_sec_ml_bool_prefs) {
        m_tb_prefs.setBoolPref(p, !torbutton_sec_ml_bool_prefs[p])
      }
      for (p in torbutton_sec_mh_bool_prefs) {
        m_tb_prefs.setBoolPref(p, !torbutton_sec_mh_bool_prefs[p])
      }
      for (p in torbutton_sec_h_bool_prefs) {
        m_tb_prefs.setBoolPref(p, !torbutton_sec_h_bool_prefs[p])
      }
      // Removing "https:" is needed due to a bug in older Noscript versions.
      // We leave that in for a while as there may be users that were affected
      // by this bug. Removing it immediately and having the auto-updater might
      // leave users exposed to the problem.
      if (capValue.indexOf(" https:") >= 0) {
        m_tb_prefs.setCharPref("capability.policy.maonoscript.sites",
          capValue.replace(" https:", ""));
      }
      break;
  }
  /* Update the NoScript button to reflect any changes */
  try {
      let wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
                         .getService(Components.interfaces.nsIWindowMediator);
      let browserEnumerator = wm.getEnumerator("navigator:browser");

      // Update every window's NoScript status...
      while (browserEnumerator.hasMoreElements()) {
          let win = browserEnumerator.getNext();
          win.noscriptOverlay._syncUINow();
      }
      torbutton_log(3, 'Updated NoScript status for security slider');
  } catch(e) {
      torbutton_log(4, 'Failed to update NoScript status for security slider: '+e);
  }
  torbutton_log(3, 'Security Slider Pref Update Complete');
  m_tb_sliderUpdate = false;
}

// The user (re)set a pref which is relevant to the security slider while she
// was in custom mode. Check whether the preference values fit to the mode which
// is still on the slider. Iff so, we are leaving the custom mode.
function torbutton_security_slider_custom_check(mode) {
  let capValue = m_tb_prefs.getCharPref("capability.policy.maonoscript.sites");
  switch (mode) {
    case 1:
      for (p in torbutton_sec_ml_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) !== torbutton_sec_ml_bool_prefs[p]) {
          return;
        }
      }
      for (p in torbutton_sec_mh_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) !== torbutton_sec_mh_bool_prefs[p]) {
          // We don't want to have the whitelist in high mode. JavaScript is
          // disabled globally.
          if (p === "noscript.globalHttpsWhitelist") {
            continue;
          }
          return;
        }
      }
      for (p in torbutton_sec_h_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) !== torbutton_sec_h_bool_prefs[p]) {
          return;
        }
      }
      // We are still here which means all preferences are properly reset. Leave
      // custom mode.
      m_tb_prefs.setBoolPref("extensions.torbutton.security_custom", false);
      break;
    case 2:
      for (p in torbutton_sec_ml_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) !== torbutton_sec_ml_bool_prefs[p]) {
          return;
        }
      }
      for (p in torbutton_sec_mh_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) !== torbutton_sec_mh_bool_prefs[p]) {
          return;
        }
      }
      for (p in torbutton_sec_h_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) === torbutton_sec_h_bool_prefs[p]) {
          // We have the whitelist and JavaScript is disabled in medium-high
          // mode as well.
          if (p === "noscript.global") {
            continue;
          }
          return;
        }
      }
      // We are still here which means all preferences are properly reset. Leave
      // custom mode.
      m_tb_prefs.setBoolPref("extensions.torbutton.security_custom", false);
      break;
    case 3:
      for (p in torbutton_sec_ml_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) !== torbutton_sec_ml_bool_prefs[p]) {
          return;
        }
      }
      for (p in torbutton_sec_mh_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) === torbutton_sec_mh_bool_prefs[p]) {
          return;
        }
      }
      for (p in torbutton_sec_h_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) === torbutton_sec_h_bool_prefs[p]) {
          return;
        }
      }
      // We are still here which means all preferences are properly reset. Leave
      // custom mode.
      m_tb_prefs.setBoolPref("extensions.torbutton.security_custom", false);
      break;
    case 4:
      for (p in torbutton_sec_ml_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) === torbutton_sec_ml_bool_prefs[p]) {
          return;
        }
      }
      for (p in torbutton_sec_mh_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) === torbutton_sec_mh_bool_prefs[p]) {
          return;
        }
      }
      for (p in torbutton_sec_h_bool_prefs) {
        if (m_tb_prefs.getBoolPref(p) === torbutton_sec_h_bool_prefs[p]) {
          return;
        }
      }
      // We are still here which means all preferences are properly reset. Leave
      // custom mode.
      m_tb_prefs.setBoolPref("extensions.torbutton.security_custom", false);
      break;
  }
}

function torbutton_close_tabs_on_new_identity() {
    var close_newnym = m_tb_prefs.getBoolPref("extensions.torbutton.close_newnym");
    if (!close_newnym) {
      torbutton_log(3, "Not closing tabs");
      return;
    }

    // TODO: muck around with browser.tabs.warnOnClose.. maybe..
    torbutton_log(3, "Closing tabs...");
    var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
        .getService(Components.interfaces.nsIWindowMediator);
    var enumerator = wm.getEnumerator("navigator:browser");
    var closeWins = new Array();
    while(enumerator.hasMoreElements()) {
        var win = enumerator.getNext();
        var browser = win.getBrowser();
        if(!browser) {
          torbutton_log(5, "No browser for possible closed window");
          continue;
        }
        var tabs = browser.browsers.length;

        torbutton_log(3, "Length: "+browser.browsers.length);

        var remove = new Array();
        for(var i = 0; i < tabs; i++) {
            remove.push(browser.browsers[i]);
        }

        if(browser.browsers.length == remove.length) {
            // It is a bad idea to alter the window list while
            // iterating over it.
            browser.addTab("about:blank");
            if(win != window) {
                closeWins.push(win);
            }
        }

        for(var i = 0; i < remove.length; i++) {
            remove[i].contentWindow.close();
        }
    }

    torbutton_log(2, "Closing windows...");

    for(var i = 0; i < closeWins.length; ++i) {
        closeWins[i].close();
    }

    torbutton_log(3, "Closed all tabs");
}

// Bug 1506 P2: This code is only important for disabling
// New Identity where it is not supported (ie no control port).
function torbutton_check_protections()
{
  var env = Cc["@mozilla.org/process/environment;1"]
              .getService(Ci.nsIEnvironment);

  // Bug 14100: check for the existence of an environment variable
  // in order to toggle the visibility of networksettings menuitem
  if (env.exists("TOR_NO_DISPLAY_NETWORK_SETTINGS"))
    document.getElementById("torbutton-networksettings").hidden = true;
  else
    document.getElementById("torbutton-networksettings").hidden = false;

  var cookie_pref = m_tb_prefs.getBoolPref("extensions.torbutton.cookie_protections");
  document.getElementById("torbutton-cookie-protector").disabled = !cookie_pref;

  // XXX: Bug 14632: The cookie dialog is useless in private browsing mode in FF31ESR
  // See https://trac.torproject.org/projects/tor/ticket/10353 for more info.
  document.getElementById("torbutton-cookie-protector").hidden = m_tb_prefs.getBoolPref("extensions.torbutton.block_disk");

  if (!m_tb_control_pass || (!m_tb_control_socket_file && !m_tb_control_port)) {
    document.getElementById("torbutton-new-identity").disabled = true;
  }

  if (!m_tb_tbb && m_tb_prefs.getBoolPref("extensions.torbutton.prompt_torbrowser")) {
      torbutton_inform_about_tbb();
  }
}

// Bug 1506 P2: I think cookie protections is a neat feature.
function torbutton_open_cookie_dialog() {
  window.openDialog('chrome://torbutton/content/torcookiedialog.xul','Cookie Protections',
                                   'centerscreen,chrome,dialog,modal,resizable');
}

// Bug 1506 P2/P3: Prefs are handled differently on android, I guess?
function torbutton_open_prefs_dialog() {
    window.openDialog("chrome://torbutton/content/preferences.xul","torbutton-preferences","centerscreen, chrome");
    torbutton_log(2, 'opened preferences window');
}

// Bug 1506 P0: Support code for checking Firefox versions. Not needed.
function torbutton_gecko_compare(aVersion) {
    var ioService = Components.classes["@mozilla.org/network/io-service;1"]
                    .getService(Components.interfaces.nsIIOService);
    var httpProtocolHandler = ioService.getProtocolHandler("http")
                              .QueryInterface(Components.interfaces.nsIHttpProtocolHandler);
    var versionComparator = null;

    if ("nsIVersionComparator" in Components.interfaces) {
        versionComparator = Components.classes["@mozilla.org/xpcom/version-comparator;1"]
                            .getService(Components.interfaces.nsIVersionComparator);
    } else {
        versionComparator = Components.classes["@mozilla.org/updates/version-checker;1"]
                            .getService(Components.interfaces.nsIVersionChecker);
    }
    var geckoVersion = httpProtocolHandler.misc.match(/rv:([0-9.]+)/)[1];
    return versionComparator.compare(aVersion, geckoVersion);
}

// -------------- HISTORY & COOKIES ---------------------

// Bug 1506 P4: Used by New Identity if cookie protections are
// not in use.
function torbutton_clear_cookies() {
    torbutton_log(2, 'called torbutton_clear_cookies');
    var cm = Components.classes["@mozilla.org/cookiemanager;1"]
                    .getService(Components.interfaces.nsICookieManager);
   
    cm.removeAll();
}

// -------------- JS/PLUGIN HANDLING CODE ---------------------
// Bug 1506 P3: Defense in depth. Disables JS and events for New Identity.
function torbutton_disable_browser_js(browser) {
    var eventSuppressor = null;

    /* Solution from: https://bugzilla.mozilla.org/show_bug.cgi?id=409737 */
    // XXX: This kills the entire window. We need to redirect
    // focus and inform the user via a lightbox.
    try {
        if (!browser.contentWindow)
            torbutton_log(3, "No content window to disable JS events.");
        else
            eventSuppressor = browser.contentWindow.
                QueryInterface(Components.interfaces.nsIInterfaceRequestor).
                       getInterface(Ci.nsIDOMWindowUtils);
    } catch(e) {
        torbutton_log(4, "Failed to disable JS events: "+e)
    }
   
    if (browser.docShell)
      browser.docShell.allowJavascript = false;

    try {
        // My estimation is that this does not get the inner iframe windows,
        // but that does not matter, because iframes should be destroyed
        // on the next load.
        browser.contentWindow.name = null;
        browser.contentWindow.window.name = null;
    } catch(e) {
        torbutton_log(4, "Failed to reset window.name: "+e)
    }

    if (eventSuppressor)
        eventSuppressor.suppressEventHandling(true);
}

// Bug 1506 P3: The JS-killing bits of this are used by
// New Identity as a defense-in-depth measure.
function torbutton_disable_window_js(win) {
    var browser = win.getBrowser();
    if(!browser) {
      torbutton_log(5, "No browser for plugin window...");
      return;
    }
    var browsers = browser.browsers;
    torbutton_log(1, "Toggle window plugins");

    for (var i = 0; i < browsers.length; ++i) {
        var b = browser.browsers[i];
        if (b && !b.docShell) {
            try {
                if (b.currentURI) 
                    torbutton_log(5, "DocShell is null for: "+b.currentURI.spec);
                else 
                    torbutton_log(5, "DocShell is null for unknown URL");
            } catch(e) {
                torbutton_log(5, "DocShell is null for unparsable URL: "+e);
            }
        }
        if (b && b.docShell) {
            torbutton_disable_browser_js(b);

            // kill meta-refresh and existing page loading
            // XXX: Despite having JUST checked b.docShell, it can
            // actually end up NULL here in some cases?
            try {
              if (b.docShell && b.webNavigation)
                b.webNavigation.stop(b.webNavigation.STOP_ALL);
            } catch(e) {
              torbutton_log(4, "DocShell error: "+e);
            }
        }
    }
}

// Bug 1506 P3: The JS-killing bits of this are used by
// New Identity as a defense-in-depth measure.
//
// This is an ugly beast.. But unfortunately it has to be so..
// Looping over all tabs twice is not somethign we wanna do..
function torbutton_disable_all_js() {
    var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
                       .getService(Components.interfaces.nsIWindowMediator);
    var enumerator = wm.getEnumerator("navigator:browser");
    while(enumerator.hasMoreElements()) {
        var win = enumerator.getNext();
        torbutton_disable_window_js(win);
    }
}

// Bug 1506 P1: This function just cleans up prefs that got set badly in previous releases
function torbutton_fixup_old_prefs()
{
    if(m_tb_prefs.getIntPref('extensions.torbutton.pref_fixup_version') < 1) {
        // TBB 5.0a3 had bad Firefox code that silently flipped this pref on us
        if (m_tb_prefs.prefHasUserValue("browser.newtabpage.enhanced")) {
            m_tb_prefs.clearUserPref("browser.newtabpage.enhanced");
            // TBB 5.0a3 users had all the necessary data cached in
            // directoryLinks.json. This meant that resetting the pref above
            // alone was not sufficient as the tiles features uses the cache
            // even if the pref indicates that feature should be disabled.
            // We flip the preference below as this forces a refetching which
            // effectively results in an empty JSON file due to our spoofed
            // URLs.
            let matchOS = m_tb_prefs.getBoolPref("intl.locale.matchOS");
            m_tb_prefs.setBoolPref("intl.locale.matchOS", !matchOS);
            m_tb_prefs.setBoolPref("intl.locale.matchOS", matchOS);
        }

        // Prior to TBB 5.0, NoScript was allowed to update its whitelist. This caused
        // odd things to appear in people's whitelists.
        if (m_tb_prefs.prefHasUserValue("capability.policy.maonoscript.sites")) {
            m_tb_prefs.clearUserPref("capability.policy.maonoscript.sites");
        }

        // For some reason, the Share This Page button also survived the
        // TBB 5.0a4 update's attempt to remove it.
        if (m_tb_prefs.prefHasUserValue("browser.uiCustomization.state")) {
            m_tb_prefs.clearUserPref("browser.uiCustomization.state");
        }

        m_tb_prefs.setIntPref('extensions.torbutton.pref_fixup_version', 1);
    }
}

// ---------------------- Event handlers -----------------

// Bug 1506 P1-P3: Most of these observers aren't very important.
// See their comments for details
function torbutton_do_main_window_startup()
{
    torbutton_log(3, "Torbutton main window startup");
    m_tb_is_main_window = true;
    torbutton_unique_pref_observer.register();
}

// Bug 1506 P4: Most of this function is now useless, save
// for the very important SOCKS environment vars at the end.
// Those could probably be rolled into a function with the
// control port vars, though. See 1506 comments inside.
function torbutton_do_startup()
{
    if(m_tb_prefs.getBoolPref("extensions.torbutton.startup")) {
        // Bug 1506: Still want to do this
        torbutton_toggle_plugins(
                m_tb_prefs.getBoolPref("extensions.torbutton.no_tor_plugins"));

        // Bug 1506: Should probably be moved to an XPCOM component
        torbutton_do_main_window_startup();

        // Bug 1506: Still want to do this
        torbutton_set_timezone();

        // For charsets
        torbutton_update_fingerprinting_prefs();

        // #5758: Last ditch effort to keep Vanilla Torbutton users from totally
        // being pwnt.  This is a pretty darn ugly hack, too. But because of #5863,
        // we really don't care about preserving the user's values for this.
        if (!m_tb_tbb) {
            // Bug 1506 P5: You have to set these two for non-TBB Firefoxen
            m_tb_prefs.setBoolPref("network.websocket.enabled", false);
            m_tb_prefs.setBoolPref("dom.indexedDB.enabled", false);
        }

        // Still need this in case people shove this thing back into FF
        if (!m_tb_tbb && m_tb_prefs.getBoolPref("extensions.torbutton.prompt_torbrowser")) {
          var warning = torbutton_get_property_string("torbutton.popup.short_torbrowser");
          var title = torbutton_get_property_string("torbutton.title.prompt_torbrowser");
          var prompts = Cc["@mozilla.org/embedcomp/prompt-service;1"].getService(Components.interfaces.nsIPromptService);
          prompts.alert(null, title, warning);
        }

        // For general pref fixups to handle pref damage in older versions
        torbutton_fixup_old_prefs();

        m_tb_prefs.setBoolPref("extensions.torbutton.startup", false);
    }
}

// Bug 1506 P0: Perform version check when a new tab is opened.
function torbutton_new_tab(event)
{
    // listening for new tabs
    torbutton_log(3, "New tab");

    /* Perform the version check on new tab, module timer */
    torbutton_do_async_versioncheck();
}

// Bug 1506 P3: Used to decide if we should resize the window.
//
// Returns true if the window wind is neither maximized, full screen,
// ratpoisioned/evilwmed, nor minimized.
function torbutton_is_windowed(wind) {
    torbutton_log(3, "Window: (" + wind.outerWidth + "," + wind.outerHeight + ") ?= ("
                     + wind.screen.availWidth + "," + wind.screen.availHeight + ")");
    if(wind.windowState == Components.interfaces.nsIDOMChromeWindow.STATE_MINIMIZED
      || wind.windowState == Components.interfaces.nsIDOMChromeWindow.STATE_MAXIMIZED) {
        torbutton_log(2, "Window is minimized/maximized");
        return false;
    }
    if ("fullScreen" in wind && wind.fullScreen) {
        torbutton_log(2, "Window is fullScreen");
        return false;
    }
    if(wind.outerHeight == wind.screen.availHeight 
            && wind.outerWidth == wind.screen.availWidth) {
        torbutton_log(3, "Window is ratpoisoned/evilwm'ed");
        return false;
    }
        
    torbutton_log(2, "Window is normal");
    return true;
}

// Bug 1506 P3: This is needed pretty much only for the version check
// and the window resizing. See comments for individual functions for
// details
function torbutton_new_window(event)
{
    torbutton_log(3, "New window");
    var browser = getBrowser();

    if(!browser) {
      torbutton_log(5, "No browser for new window.");
      return;
    }

    m_tb_window_height = window.outerHeight;
    m_tb_window_width = window.outerWidth;

    if (!m_tb_wasinited) {
        torbutton_init();
    }
    // Add tab open listener..
    browser.tabContainer.addEventListener("TabOpen", torbutton_new_tab, false);

    torbutton_do_startup();

    let progress = Cc["@mozilla.org/docloaderservice;1"]
                     .getService(Ci.nsIWebProgress);

    if (m_tb_prefs.getBoolPref("extensions.torbutton.resize_new_windows")
            && torbutton_is_windowed(window)) {
      progress.addProgressListener(torbutton_resizelistener,
                                   Ci.nsIWebProgress.NOTIFY_STATE_DOCUMENT);
    }

    // If the default language is not English and we have not already asked,
    // add a web progress listener that will show a "request English language
    // web pages?" prompt the first time an http or https page is opened.
    if (torbutton_should_prompt_for_language_preference()) {
      progress.addProgressListener(torbutton_langPromptListener,
                                   Ci.nsIWebProgress.NOTIFY_STATE_DOCUMENT);
    }

    // Check the version on every new window. We're already pinging check in these cases.    
    torbutton_do_async_versioncheck();

    torbutton_do_tor_check();
}

// Bug 1506 P2: This is only needed because we have observers
// in XUL that should be in an XPCOM component
function torbutton_close_window(event) {
    torbutton_window_pref_observer.unregister();
    torbutton_tor_check_observer.unregister();

    window.removeEventListener("sizemodechange", m_tb_resize_handler,
        false);

    // TODO: This is a real ghetto hack.. When the original window
    // closes, we need to find another window to handle observing 
    // unique events... The right way to do this is to move the 
    // majority of torbutton functionality into a XPCOM component.. 
    // But that is a major overhaul..
    if (m_tb_is_main_window) {
        torbutton_log(3, "Original window closed. Searching for another");
        var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
            .getService(Components.interfaces.nsIWindowMediator);
        var enumerator = wm.getEnumerator("navigator:browser");
        while(enumerator.hasMoreElements()) {
            var win = enumerator.getNext();
            // For some reason, when New Identity is called from a pref
            // observer (ex: torbutton_use_nontor_proxy) on an ASAN build,
            // we sometimes don't have this symbol set in the new window yet.
            // However, the new window will run this init later in that case,
            // as it does in the OSX case.
            if(win != window && "torbutton_do_main_window_startup" in win) {
                torbutton_log(3, "Found another window");
                win.torbutton_do_main_window_startup();
                m_tb_is_main_window = false;
                break;
            }
        }

        torbutton_unique_pref_observer.unregister();

        if(m_tb_is_main_window) { // main window not reset above
            // This happens on Mac OS because they allow firefox
            // to still persist without a navigator window
            torbutton_log(3, "Last window closed. None remain.");
            m_tb_prefs.setBoolPref("extensions.torbutton.startup", true);
            m_tb_is_main_window = false;
        }
    }
}


function torbutton_open_network_settings() {
  var obsSvc = Components.classes["@mozilla.org/observer-service;1"]
                .getService(Ci.nsIObserverService);
  obsSvc.notifyObservers(this, "TorOpenNetworkSettings", null);
}


window.addEventListener('load',torbutton_new_window,false);
window.addEventListener('unload', torbutton_close_window, false);

var m_tb_resize_handler = null;
var m_tb_resize_date = null;

// Bug 1506 P1/P3: Setting a fixed window size is important, but
// probably not for android.
var torbutton_resizelistener =
{
  QueryInterface: function(aIID)
  {
   if (aIID.equals(Components.interfaces.nsIWebProgressListener) ||
       aIID.equals(Components.interfaces.nsISupportsWeakReference) ||
       aIID.equals(Components.interfaces.nsISupports))
     return this;
   throw Components.results.NS_NOINTERFACE;
  },

  onLocationChange: function(aProgress, aRequest, aURI) {},
  onStateChange: function(aProgress, aRequest, aFlag, aStatus) {
    if (aFlag & Components.interfaces.nsIWebProgressListener.STATE_STOP) {
      var progress =
        Components.classes["@mozilla.org/docloaderservice;1"].
        getService(Components.interfaces.nsIWebProgress);
      var win = getBrowser().contentWindow,
          container = getBrowser().parentElement;
      if (!win || typeof(win) == "undefined") {
        torbutton_log(5, "No initial browser content window?");
        progress.removeProgressListener(this);
        return;
      }

      // We need to set the inner width to an initial value because it has none
      // at this point... Choosing "300" as this works even on Windows
      // reliably.
      win.innerWidth = 300;
      win.innerHeight = 300;

      var screenMan = Components.classes["@mozilla.org/gfx/screenmanager;1"].
        getService(Components.interfaces.nsIScreenManager);
      var junk = {}, availWidth = {}, availHeight = {};
      screenMan.primaryScreen.GetAvailRect(junk, junk, availWidth, availHeight);

      torbutton_log(3, "About to resize window: " +
                    window.outerWidth + "x" + window.outerHeight +
                    " inner: " + win.innerWidth + "x" + win.innerHeight +
                    " in state " + window.windowState +
                    " Available: " + availWidth.value + "x" +
                    availHeight.value);

      var diff_width = window.outerWidth - win.innerWidth;
      var diff_height = window.outerHeight - win.innerHeight;
      var delta_fix = 0;

      // The following block tries to cope with funny corner cases where the
      // title bar is not included in window.outerHeight. What could happen in
      // this case? Well, assume the difference between window.outerHeight and
      // win.innerHeight is 39. And lets further assume the available height is
      // 725x539. If we resize the window in this case we get 600x500 for the
      // inner window. And the outer window has a height of 539 *plus* the
      // height of the titlebar (as it occupies some screen space at least
      // after resizing) which probably leads to parts of the browser being not
      // visible.
      if (window.outerHeight == window.innerHeight) {
          // XXX: Let's assume a reasonable safety margin.
          // |delta_fix = Math.floor(window.mozInnerScreenY) - window.screenY;|
          // is not working at this stage of the browser start-up. Although it
          // would give us slightly better values. But calling it later makes
          // the resizing visible even on fast computers which is bad for UX.
          delta_fix = Math.floor(diff_height / 2);
      }

      // Check the DPI value and take it into acctount later when calculating
      // the max* values.
      var dpi = m_tb_domWindowUtils.screenPixelsPerCSSPixel;

      // We can't use screen resolution here as it does not account for e.g.
      // taskbars. We can't use window.screen.avail* either as it does not
      // report correct values on some platforms when used at this stage in the
      // startup process. Therefore, we resort to nsIScreenManager.
      // XXX: Note though, there are probably still some OS/window manager
      // configurations where this approach is not working. E.g. on a Debian
      // with XFCE the available height is the same as the screen height.
      // This is said to happen as well on Windows with Aero:
      // https://stackoverflow.com/questions/3044230/
      // difference-between-screen-availheight-and-window-height
      var maxHeight = Math.floor(availHeight.value / dpi) -
                     (diff_height + delta_fix);
      var maxWidth = Math.floor(availWidth.value / dpi) - diff_width ;

      var width;
      var height;

      // Allow the user to overwrite the Torbutton logic in case it is still
      // wrong when resizing the window.
      try {
        width = m_tb_prefs.getIntPref("extensions.torbutton.window.innerWidth");
      } catch(e) {
        let cappedWidth = m_tb_prefs.getIntPref("extensions.torbutton.window.maxWidth");
        if (maxWidth > cappedWidth) {
          maxWidth = cappedWidth;
        }
        width = Math.floor(maxWidth/200.0)*200;
      }

      try {
        height = m_tb_prefs.getIntPref("extensions.torbutton.window.innerHeight");
      } catch(e) {
        let cappedHeight = m_tb_prefs.getIntPref("extensions.torbutton.window.maxHeight");
        if (maxHeight > cappedHeight) {
          maxHeight = cappedHeight;
        }
        height = Math.floor(maxHeight/100.0)*100;
      }

      let resizeInnerWindowTo = function (width, height) {
        window.resizeBy(width - win.innerWidth,
                        height - win.innerHeight);
        torbutton_log(3, "Resized new window from: " + container.clientWidth + "x" +
                      container.clientHeight + " to " + width + "x" + height +
                      " in state " + window.windowState);
      }

      m_tb_resize_handler = function() {
        if (window.windowState === 1) {
          if (m_tb_prefs.
              getIntPref("extensions.torbutton.maximize_warnings_remaining") > 0) {

            // Do not add another notification if one is already showing.
            const kNotificationName = "torbutton-maximize-notification";
            let box = gBrowser.getNotificationBox();
            if (box.getNotificationWithValue(kNotificationName))
              return;

            // Rate-limit showing our notification if needed.
            if (m_tb_resize_date === null) {
              m_tb_resize_date = Date.now();
            } else {
              // We wait at least another second before we show a new
              // notification. Should be enough to rule out OSes that call our
              // handler rapidly due to internal workings.
              if (Date.now() - m_tb_resize_date < 1000) {
                return;
              }
              // Resizing but we need to reset |m_tb_resize_date| now.
              m_tb_resize_date = Date.now();
            }

            let sb = torbutton_get_stringbundle();
            // No need to get "OK" translated again.
            let sbSvc = Cc["@mozilla.org/intl/stringbundle;1"].
              getService(Ci.nsIStringBundleService);
            let bundle = sbSvc.
              createBundle("chrome://global/locale/commonDialogs.properties");
            let button_label = bundle.GetStringFromName("OK");

            let buttons = [{
              label: button_label,
              accessKey: 'O',
              popup: null,
              callback:
                function() {
                  m_tb_prefs.setIntPref("extensions.torbutton.maximize_warnings_remaining",
                  m_tb_prefs.getIntPref("extensions.torbutton.maximize_warnings_remaining") - 1);
                }
            }];

            let priority = box.PRIORITY_WARNING_LOW;
            let message =
              torbutton_get_property_string("torbutton.maximize_warning");

            box.appendNotification(message, kNotificationName, null,
                                   priority, buttons);
            return;
          }
          // This is for some weird OS-specific behavior on start-up where,
          // depending on the available screen size, the OS thinks it has to
          // maximize the window. We don't want to do that AND don't want to
          // show the user our notification in this case.
          if (m_tb_prefs.
                getBoolPref(k_tb_tor_resize_warn_pref)) {
            window.addEventListener("resize",
              function() {
                resizeInnerWindowTo(width, height);
                var calling_function = arguments.callee;
                setTimeout(function() {
                             torbutton_log(3, "Removing resize listener..");
                             window.removeEventListener("resize",
                               calling_function, false);
                           }, 1000);
              }, false);
          }
        }
      };

      // We need to handle OSes that auto-maximize windows depending on user
      // settings and/or screen resolution in the start-up phase and users that
      // try to shoot themselves in the foot by maximizing the window manually.
      // We add a listener which is triggerred as soon as the window gets
      // maximized (windowState = 1). We are resizing during start-up but not
      // later as the user should see only a warning there as a stopgap before
      // #14229 lands.
      // Alas, the Firefox window code is handling the event not itself:
      // "// Note the current implementation of SetSizeMode just stores
      //  // the new state; it doesn't actually resize. So here we store
      //  // the state and pass the event on to the OS."
      // (See: https://mxr.mozilla.org/mozilla-esr31/source/xpfe/appshell/src/
      // nsWebShellWindow.cpp#348)
      // This means we have to cope with race conditions and resizing in the
      // sizemodechange listener is likely to fail. Thus, we add a specific
      // resize listener that is doing the work for us. It seems (at least on
      // Ubuntu) to be the case that maximizing (and then again normalizing) of
      // the window triggers more than one resize event the first being not the
      // one we need. Thus we can't remove the listener after the first resize
      // event got fired. Thus, we have the rather klunky setTimeout() call.
      m_tb_prefs.setBoolPref(k_tb_tor_resize_warn_pref, true);
      window.addEventListener("sizemodechange", m_tb_resize_handler, false);

      // This is fun. any attempt to directly set the inner window actually
      // resizes the outer width to that value instead. Must use resizeBy()
      // instead of assignment or resizeTo()
      resizeInnerWindowTo(width, height);

      // Resizing within this progress listener does not always work as overlays
      // of other extensions might still influence the height/width of the
      // chrome and therefore the height/width of the content window. Doing a
      // fallback resize with setTimeout(0) from this progess listener does not
      // work on some machines (probably due to race conditions which are all
      // over the place). Thus we need a point later in the start-up process
      // where we can do this... Please welcome the mutation observer.
      let mut_target = document.getElementById("main-window");
      let mut_observer = new MutationObserver(
        function(mutations) {
          mutations.forEach(
            function(mutation) {
              setTimeout(function() {
                           resizeInnerWindowTo(width, height);
                           quantizeBrowserSize(window, 100, 100);
                           // OS-specific window maximization on start-up should
                           // be done by now. Disable the respective preference
                           // to make sure the user is seeing our notification.
                           m_tb_prefs.setBoolPref(k_tb_tor_resize_warn_pref,
                             false);
                         }, 0);
              mut_observer.disconnect();
            }
          );
        }
      );
      // Configuration of the observer. Looking at added nodes is enough as
      // DevTools related code is manipulating the DOM which we can capture.
      // From that on we can start our fallback resizing.
      let mut_config = { attributes: false, childList: true,
        characterData: false };
      mut_observer.observe(mut_target, mut_config);

      progress.removeProgressListener(this);
    }
  },

  onProgressChange: function(aProgress, aRequest, curSelfProgress,
                             maxSelfProgress, curTotalProgress,
                             maxTotalProgress) {},
  onStatusChange: function(aProgress, aRequest, stat, message) {},
  onSecurityChange: function() {}
};

var torbutton_langPromptListener =
{
  QueryInterface: function(aIID)
  {
   if (aIID.equals(Ci.nsIWebProgressListener) ||
       aIID.equals(Ci.nsISupportsWeakReference) ||
       aIID.equals(Ci.nsISupports))
     return this;
   throw Cr.NS_NOINTERFACE;
  },

  onLocationChange: function(aProgress, aRequest, aURI) {},

  onStateChange: function(aProgress, aRequest, aFlag, aStatus) {
    if (aFlag & Ci.nsIWebProgressListener.STATE_START) {
      // If we are loading an HTTP page, show the
      // "request English language web pages?" prompt.
      try {
        let httpChannel = aRequest.QueryInterface(Ci.nsIHttpChannel);

        // The above QI did not throw, so we must have an HTTP request.
        // Remove this listener and display the prompt if another window has
        // not already done so.
        let progress = Cc["@mozilla.org/docloaderservice;1"]
                         .getService(Ci.nsIWebProgress);
        progress.removeProgressListener(torbutton_langPromptListener,
                            Ci.nsIWebProgress.NOTIFY_STATE_DOCUMENT);

        if (torbutton_should_prompt_for_language_preference()) {
          if (torbutton_is_homepage_url(aRequest.URI)) {
            // If the homepage is being loaded, display the prompt after a
            // delay to avoid a problem where a blank prompt is displayed.
            // In this case, the homepage will be loaded using the current
            // spoof English setting, which is OK.
            setTimeout(function() {
              if (torbutton_should_prompt_for_language_preference())
                torbutton_prompt_for_language_preference();
            }, 2000);
          } else {
            // No delay is needed. Display the prompt and fix up the
            // Accept-Language header before allowing the load to continue.
            torbutton_prompt_for_language_preference();

            // The Accept-Language header for this request was set when the
            // channel was created. Reset it to match the value that will be
            // used for future requests.
            let val = torbutton_get_current_accept_language_value(aRequest.URI);
            if (val)
              httpChannel.setRequestHeader("Accept-Language", val, false);
          }
        }
      } catch (e) {}
    }
  },

  onProgressChange: function(aProgress, aRequest, curSelfProgress,
                             maxSelfProgress, curTotalProgress,
                             maxTotalProgress) {},
  onStatusChange: function(aProgress, aRequest, stat, message) {},
  onSecurityChange: function() {}
};


// aURI should be an http or https nsIURI object.
function torbutton_get_current_accept_language_value(aURI)
{
  try {
    let ioService = Cc["@mozilla.org/network/io-service;1"]
                      .getService(Ci.nsIIOService);
    let channel = ioService.newChannelFromURI(aURI);
    let httpChannel = channel.QueryInterface(Ci.nsIHttpChannel);
    return httpChannel.getRequestHeader("Accept-Language");
  } catch (e) {}

  return null;
}

function torbutton_is_homepage_url(aURI)
{
  if (!aURI)
    return false;

  let homePageURLs;
  let choice = m_tb_prefs.getIntPref("browser.startup.page");
  if ((1 == choice) || (3 == choice)) try {
     // A homepage may be used at startup. Get the values and check against
     // aURI.spec.
     homePageURLs = m_tb_prefs.getComplexValue("browser.startup.homepage",
                                               Ci.nsIPrefLocalizedString).data;
  } catch (e) {}

  if (!homePageURLs)
    return false;

  let urls = homePageURLs.split('|');
  return (urls.indexOf(aURI.spec) >= 0);
}

// Check if "extensions.torbutton.hide_sync_ui" is enabled, and if so,
// hide the "Sign in to Sync" button on the hamburger menu.
function torbutton_update_sync_ui()
{
  try {
    document.getElementById("PanelUI-footer-fxa").style.display =
      getBoolPref("extensions.torbutton.hide_sync_ui") ? "none" : "";
  } catch (e) {
    torbutton_log(5, 'Error updating the Sync UI: ' + e);
  }
}

//vim:set ts=4
