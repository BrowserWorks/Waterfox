// Bug 1506 P1: Most of this code needs to go away. See also Bug 3100.

// PREFERences dialog functions
//   torbutton_prefs_init() -- on dialog load
//   torbutton_prefs_save() -- on dialog save

const Cc = Components.classes, Ci = Components.interfaces;


function torbutton_prefs_init(doc) {
    torbutton_log(2, "called prefs_init()");

    var o_torprefs = torbutton_get_prefbranch('extensions.torbutton.');

    // Privacy and security settings
    doc.getElementById('torbutton_blockDisk').checked = o_torprefs.getBoolPref('block_disk');
    doc.getElementById('torbutton_resistFingerprinting').checked = o_torprefs.getBoolPref('resist_fingerprinting');
    doc.getElementById('torbutton_blockPlugins').checked = o_torprefs.getBoolPref('no_tor_plugins');
    doc.getElementById('torbutton_restrictThirdParty').checked = o_torprefs.getBoolPref('restrict_thirdparty');
    let sec_slider = doc.getElementById('torbutton_sec_slider');
    let sec_custom = doc.getElementById('torbutton_sec_custom');
    let custom_values = o_torprefs.getBoolPref('security_custom');
    sec_slider.value = o_torprefs.getIntPref('security_slider');
    sec_custom.checked = custom_values;
    sec_custom.disabled = !custom_values;
    torbutton_set_slider_text(doc, sec_custom.checked);
    // If the custom checkbox is checked and the user is done with dragging
    // uncheck the checkbox to allow setting the (newly) chosen security level.
    sec_slider.dragStateChanged = function(isDragging) {
        if (!isDragging && sec_custom.checked) {
           sec_custom.checked = false;
           sec_custom.disabled = true;
        }
    }
    sec_slider.valueChanged = function(which, newValue, userChanged) {
        torbutton_set_slider_text(doc, false);
    }
}

function torbutton_prefs_save(doc) {
    // Disable the Accept button once the user clicked on it as clicking on
    // our active Accept button more than once can lead to all sort of weird
    // behavior. See bug 11763 for an example.
    doc.documentElement.getButton("accept").disabled = true;
    torbutton_log(2, "called prefs_save()");
    var o_torprefs = torbutton_get_prefbranch('extensions.torbutton.');

    // Privacy and Security Settings
    o_torprefs.setBoolPref('block_disk', doc.getElementById('torbutton_blockDisk').checked);
    // If we have NoScript enabled we set `noscript.volatilePrivatePermissions`
    // to `true` if we are blocking disk records and to `false` if we are
    // enabling them.
    try {
      if ("@maone.net/noscript-service;1" in Components.classes) {
        let o_noscriptprefs = torbutton_get_prefbranch('noscript.');
        if (o_torprefs.getBoolPref('block_disk')) {
          o_noscriptprefs.setBoolPref('volatilePrivatePermissions', true);
        } else {
          o_noscriptprefs.setBoolPref('volatilePrivatePermissions', false);
        }
      }
    } catch (e) {}

    o_torprefs.setBoolPref('resist_fingerprinting', doc.getElementById('torbutton_resistFingerprinting').checked);
    o_torprefs.setBoolPref('no_tor_plugins', doc.getElementById('torbutton_blockPlugins').checked);
    o_torprefs.setBoolPref('restrict_thirdparty', doc.getElementById('torbutton_restrictThirdParty').checked);
    o_torprefs.setBoolPref('security_custom',
                           doc.getElementById('torbutton_sec_custom').checked);
    o_torprefs.setIntPref('security_slider',
                          doc.getElementById('torbutton_sec_slider').value);

    // If we have non-custom Security Slider settings update them now.
    if (!o_torprefs.getBoolPref('security_custom')) {
      let wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
                         .getService(Components.interfaces.nsIWindowMediator);
      let win = wm.getMostRecentWindow("navigator:browser");
      win.torbutton_update_security_slider();
    }
}

function torbutton_prefs_reset_defaults() {
    var o_torprefs = torbutton_get_prefbranch('extensions.torbutton.');
    var tmpcnt = new Object();
    var children;
    var i;
    var loglevel = o_torprefs.getIntPref("loglevel");
    var logmthd = o_torprefs.getIntPref("logmethod");
    
    torbutton_log(3, "Starting Pref reset");

    //  1. Clear torbutton settings
    //  2. Clear browser proxy settings
    //  3. Reset Security Slider settings

    // XXX Warning: The only reason this works is because of Firefox's 
    // threading model. As soon as a pref is changed, all observers
    // are notified by that same thread, immediately. Since torbutton's
    // security state is driven by proxy pref observers, this
    // causes everything to be reset in a linear order. If firefox 
    // ever makes pref observers asynchonous, this will all break.
    
    children = o_torprefs.getChildList("" , tmpcnt);
    for(i = 0; i < children.length; i++) {
        if(o_torprefs.prefHasUserValue(children[i]))
            o_torprefs.clearUserPref(children[i]);
    }

    // Keep logging the same.
    o_torprefs.setIntPref("loglevel", loglevel);
    o_torprefs.setIntPref("logmethod", logmthd);

    torbutton_log(3, "Resetting browser prefs");

    // Reset browser prefs that torbutton touches just in case
    // they get horked. Better everything gets set back to default
    // than some arcane pref gets wedged with no clear way to fix it.
    // Technical users who tuned these by themselves will be able to fix it.
    // It's the non-technical ones we should make it easy for
    torbutton_reset_browser_prefs();

    // Resetting the Security Slider preferences
    var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"]
        .getService(Components.interfaces.nsIWindowMediator);
    var win = wm.getMostRecentWindow("navigator:browser");
    o_torprefs.setBoolPref('security_custom', false);
    o_torprefs.setIntPref('security_slider', 4);
    win.torbutton_update_security_slider();

    torbutton_log(4, "Preferences reset to defaults");
    torbutton_prefs_init(window.document);

    // In all cases, force prefs to be synced to disk
    var prefService = Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefService);
    prefService.savePrefFile(null);
}

function torbutton_toggle_slider(doc, pos) {
    doc.getElementById("torbutton_sec_slider").value = pos;
    // Make sure the custom checkbox is unchecked as the user seems to want one
    // of the defined security levels.
    let sec_custom = doc.getElementById("torbutton_sec_custom");
    if (sec_custom.checked) {
        sec_custom.checked = false;
    }
    torbutton_set_slider_text(doc, false);
}

function torbutton_set_slider_text(doc, custom) {
  let level = doc.getElementById("torbutton_sec_slider").value;
  if (custom) {
    level = 5;
  }
  switch (level) {
    case (1):
      doc.getElementById("desc_low").collapsed = true;
      doc.getElementById("desc_medium_low").collapsed = true;
      doc.getElementById("desc_medium_high").collapsed = true;
      doc.getElementById("desc_high").collapsed = false;
      break;
    case (2):
      doc.getElementById("desc_low").collapsed = true;
      doc.getElementById("desc_medium_low").collapsed = true;
      doc.getElementById("desc_medium_high").collapsed = false;
      doc.getElementById("desc_high").collapsed = true;
      break;
   case (3):
      doc.getElementById("desc_low").collapsed = true;
      doc.getElementById("desc_medium_low").collapsed = false;
      doc.getElementById("desc_medium_high").collapsed = true;
      doc.getElementById("desc_high").collapsed = true;
      break;
    case (4):
      doc.getElementById("desc_low").collapsed = false;
      doc.getElementById("desc_medium_low").collapsed = true;
      doc.getElementById("desc_medium_high").collapsed = true;
      doc.getElementById("desc_high").collapsed = true;
      break;
    case (5):
      doc.getElementById("desc_low").collapsed = true;
      doc.getElementById("desc_medium_low").collapsed = true;
      doc.getElementById("desc_medium_high").collapsed = true;
      doc.getElementById("desc_high").collapsed = true;
      break;
  }
}

function torbutton_prefs_check_disk() {
    let o_torprefs = torbutton_get_prefbranch('extensions.torbutton.');
    let old_mode = o_torprefs.getBoolPref('block_disk');
    let mode = document.getElementById('torbutton_blockDisk').checked;

    if (mode === old_mode) {
        // Either revert, or uncheck.
        return;
    }

    let sb = Cc["@mozilla.org/intl/stringbundle;1"]
               .getService(Ci.nsIStringBundleService);
    let bundle = sb.createBundle("chrome://browser/locale/preferences/preferences.properties");
    let brandName = sb.createBundle("chrome://branding/locale/brand.properties").GetStringFromName("brandShortName");

    let msg = bundle.formatStringFromName(mode ?
                                        "featureEnableRequiresRestart" : "featureDisableRequiresRestart",
                                        [brandName], 1);
    let title = bundle.formatStringFromName("shouldRestartTitle", [brandName], 1);
    let prompts = Cc["@mozilla.org/embedcomp/prompt-service;1"].getService(Ci.nsIPromptService);
    let shouldProceed = prompts.confirm(window, title, msg)
    if (shouldProceed) {
      let cancelQuit = Cc["@mozilla.org/supports-PRBool;1"]
                         .createInstance(Ci.nsISupportsPRBool);
      let obsSvc = Cc["@mozilla.org/observer-service;1"]
                    .getService(Ci.nsIObserverService);
      obsSvc.notifyObservers(cancelQuit, "quit-application-requested",
                                   "restart");
      shouldProceed = !cancelQuit.data;

      if (shouldProceed) {
        document.documentElement.acceptDialog();
        let appStartup = Cc["@mozilla.org/toolkit/app-startup;1"]
                           .getService(Ci.nsIAppStartup);
        appStartup.quit(Ci.nsIAppStartup.eAttemptQuit |  Ci.nsIAppStartup.eRestart);
        return;
      }
    }

    document.getElementById('torbutton_blockDisk').checked = old_mode;
}
