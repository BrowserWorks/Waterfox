/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

var EXPORTED_SYMBOLS = ["MenuBarExtension"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

ChromeUtils.import("resource://gre/modules/XPCOMUtils.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "ExtensibleUtils",
  "resource://extensibles/ExtensibleUtils.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "OverlayHelper",
  "resource://extensibles/OverlayHelper.jsm"
);

class MenuBarExtension extends ExtensibleUtils {
  constructor() {
    super();
    if (AppConstants.platform == "macosx") {
      this.overlayURI = "resource://extensibles/menubar.xhtml";
    } else {
      this.overlayURI = "resource://extensibles/appmenu.xhtml";
    }
    try {
      // ensure overlay loaded into all windows
      this.loadInCurrentAndFutureWindows(OverlayHelper.loadOverlayInWindow, [
        this.overlayURI,
      ]);
      // add menu functions to all active windows
      this.loadInCurrentAndFutureWindows(
        this._loadMenuBarFunctions.bind(this),
        []
      );
      // we only allow toggling of restart button visibility on windows/linux
      if (AppConstants.platform != "macosx") {
        // ensure all windows have the correct hidden param for each item
        this.loadInCurrentAndFutureWindows(
          this._setToolbarItemVisibility.bind(this),
          []
        );
      }
    } catch (ex) {
      // something went wrong
    }
  }

  _setToolbarItemVisibility(aWindow) {
    let menuItems = [
      ["appMenu-restart-button", "browser.restart_menu.showpanelmenubtn"],
    ];
    this.amendMultipleBrowserElementVisibility(aWindow, menuItems);
  }

  _loadMenuBarFunctions(aWindow) {
    var { gBrowser } = aWindow;
    if (gBrowser) {
      gBrowser.restartBrowser = this._restartBrowser;
      gBrowser._attemptRestart = this._attemptRestart;
    }
  }

  _restartBrowser() {
    let browserBundle = Services.strings.createBundle(
      "resource://extensibles/extensibles.properties"
    );
    let brandBundle = Services.strings.createBundle(
      "chrome://branding/locale/brand.properties"
    );
    try {
      if (Services.prefs.getBoolPref("browser.restart_menu.requireconfirm")) {
        if (
          Services.prompt.confirm(
            null,
            browserBundle.formatStringFromName(
              "restartPromptTitle.label",
              [brandBundle.GetStringFromName("brandShortName")],
              1
            ),
            browserBundle.formatStringFromName(
              "restartPromptQuestion.label",
              [brandBundle.GetStringFromName("brandShortName")],
              1
            )
          )
        ) {
          // only restart if confirmation given
          this._attemptRestart();
        }
      } else {
        this._attemptRestart();
      }
    } catch (e) {
      throw new Error(
        "We're sorry but something has gone wrong with 'restartBrowser' " + e
      );
    }
  }
  _attemptRestart() {
    if (Services.prefs.getBoolPref("browser.restart_menu.purgecache")) {
      Services.appinfo.invalidateCachesOnRestart();
    }
    Services.startup.quit(
      Services.startup.eRestart | Services.startup.eAttemptQuit
    );
  }
}
