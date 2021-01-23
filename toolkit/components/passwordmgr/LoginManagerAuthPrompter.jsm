/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
const { PrivateBrowsingUtils } = ChromeUtils.import(
  "resource://gre/modules/PrivateBrowsingUtils.jsm"
);
const { PromptUtils } = ChromeUtils.import(
  "resource://gre/modules/SharedPromptUtils.jsm"
);

/* eslint-disable block-scoped-var, no-var */

ChromeUtils.defineModuleGetter(
  this,
  "LoginHelper",
  "resource://gre/modules/LoginHelper.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "LoginManagerPrompter",
  "resource://gre/modules/LoginManagerPrompter.jsm"
);

const LoginInfo = Components.Constructor(
  "@mozilla.org/login-manager/loginInfo;1",
  "nsILoginInfo",
  "init"
);

/**
 * A helper module to prevent modal auth prompt abuse.
 */
const PromptAbuseHelper = {
  getBaseDomainOrFallback(hostname) {
    try {
      return Services.eTLD.getBaseDomainFromHost(hostname);
    } catch (e) {
      return hostname;
    }
  },

  incrementPromptAbuseCounter(baseDomain, browser) {
    if (!browser) {
      return;
    }

    if (!browser.authPromptAbuseCounter) {
      browser.authPromptAbuseCounter = {};
    }

    if (!browser.authPromptAbuseCounter[baseDomain]) {
      browser.authPromptAbuseCounter[baseDomain] = 0;
    }

    browser.authPromptAbuseCounter[baseDomain] += 1;
  },

  resetPromptAbuseCounter(baseDomain, browser) {
    if (!browser || !browser.authPromptAbuseCounter) {
      return;
    }

    browser.authPromptAbuseCounter[baseDomain] = 0;
  },

  hasReachedAbuseLimit(baseDomain, browser) {
    if (!browser || !browser.authPromptAbuseCounter) {
      return false;
    }

    let abuseCounter = browser.authPromptAbuseCounter[baseDomain];
    // Allow for setting -1 to turn the feature off.
    if (this.abuseLimit < 0) {
      return false;
    }
    return !!abuseCounter && abuseCounter >= this.abuseLimit;
  },
};

XPCOMUtils.defineLazyPreferenceGetter(
  PromptAbuseHelper,
  "abuseLimit",
  "prompts.authentication_dialog_abuse_limit"
);

/**
 * Implements nsIPromptFactory
 *
 * Invoked by [toolkit/components/prompts/src/Prompter.jsm]
 */
function LoginManagerAuthPromptFactory() {
  Services.obs.addObserver(this, "quit-application-granted", true);
  Services.obs.addObserver(this, "passwordmgr-crypto-login", true);
  Services.obs.addObserver(this, "passwordmgr-crypto-loginCanceled", true);
}

LoginManagerAuthPromptFactory.prototype = {
  classID: Components.ID("{749e62f4-60ae-4569-a8a2-de78b649660e}"),
  QueryInterface: ChromeUtils.generateQI([
    Ci.nsIPromptFactory,
    Ci.nsIObserver,
    Ci.nsISupportsWeakReference,
  ]),

  _asyncPrompts: {},
  _asyncPromptInProgress: false,

  observe(subject, topic, data) {
    this.log("Observed: " + topic);
    if (topic == "quit-application-granted") {
      this._cancelPendingPrompts();
    } else if (topic == "passwordmgr-crypto-login") {
      // Start processing the deferred prompters.
      this._doAsyncPrompt();
    } else if (topic == "passwordmgr-crypto-loginCanceled") {
      // User canceled a Master Password prompt, so go ahead and cancel
      // all pending auth prompts to avoid nagging over and over.
      this._cancelPendingPrompts();
    }
  },

  getPrompt(aWindow, aIID) {
    var prompt = new LoginManagerAuthPrompter().QueryInterface(aIID);
    prompt.init(aWindow, this);
    return prompt;
  },

  _doAsyncPrompt() {
    if (this._asyncPromptInProgress) {
      this.log("_doAsyncPrompt bypassed, already in progress");
      return;
    }

    // Find the first prompt key we have in the queue
    var hashKey = null;
    for (hashKey in this._asyncPrompts) {
      break;
    }

    if (!hashKey) {
      this.log("_doAsyncPrompt:run bypassed, no prompts in the queue");
      return;
    }

    // If login manger has logins for this host, defer prompting if we're
    // already waiting on a master password entry.
    var prompt = this._asyncPrompts[hashKey];
    var prompter = prompt.prompter;
    var [origin, httpRealm] = prompter._getAuthTarget(
      prompt.channel,
      prompt.authInfo
    );
    var hasLogins = Services.logins.countLogins(origin, null, httpRealm) > 0;
    if (
      !hasLogins &&
      LoginHelper.schemeUpgrades &&
      origin.startsWith("https://")
    ) {
      let httpOrigin = origin.replace(/^https:\/\//, "http://");
      hasLogins = Services.logins.countLogins(httpOrigin, null, httpRealm) > 0;
    }
    if (hasLogins && Services.logins.uiBusy) {
      this.log("_doAsyncPrompt:run bypassed, master password UI busy");
      return;
    }

    var self = this;

    var runnable = {
      cancel: false,
      run() {
        var ok = false;
        if (!this.cancel) {
          try {
            self.log(
              "_doAsyncPrompt:run - performing the prompt for '" + hashKey + "'"
            );
            ok = prompter.promptAuth(
              prompt.channel,
              prompt.level,
              prompt.authInfo
            );
          } catch (e) {
            if (
              e instanceof Components.Exception &&
              e.result == Cr.NS_ERROR_NOT_AVAILABLE
            ) {
              self.log(
                "_doAsyncPrompt:run bypassed, UI is not available in this context"
              );
            } else {
              Cu.reportError(
                "LoginManagerAuthPrompter: _doAsyncPrompt:run: " + e + "\n"
              );
            }
          }

          delete self._asyncPrompts[hashKey];
          prompt.inProgress = false;
          self._asyncPromptInProgress = false;
        }

        for (var consumer of prompt.consumers) {
          if (!consumer.callback) {
            // Not having a callback means that consumer didn't provide it
            // or canceled the notification
            continue;
          }

          self.log("Calling back to " + consumer.callback + " ok=" + ok);
          try {
            if (ok) {
              consumer.callback.onAuthAvailable(
                consumer.context,
                prompt.authInfo
              );
            } else {
              consumer.callback.onAuthCancelled(consumer.context, !this.cancel);
            }
          } catch (e) {
            /* Throw away exceptions caused by callback */
          }
        }
        self._doAsyncPrompt();
      },
    };

    this._asyncPromptInProgress = true;
    prompt.inProgress = true;

    Services.tm.dispatchToMainThread(runnable);
    this.log("_doAsyncPrompt:run dispatched");
  },

  _cancelPendingPrompts() {
    this.log("Canceling all pending prompts...");
    var asyncPrompts = this._asyncPrompts;
    this.__proto__._asyncPrompts = {};

    for (var hashKey in asyncPrompts) {
      let prompt = asyncPrompts[hashKey];
      // Watch out! If this prompt is currently prompting, let it handle
      // notifying the callbacks of success/failure, since it's already
      // asking the user for input. Reusing a callback can be crashy.
      if (prompt.inProgress) {
        this.log("skipping a prompt in progress");
        continue;
      }

      for (var consumer of prompt.consumers) {
        if (!consumer.callback) {
          continue;
        }

        this.log("Canceling async auth prompt callback " + consumer.callback);
        try {
          consumer.callback.onAuthCancelled(consumer.context, true);
        } catch (e) {
          /* Just ignore exceptions from the callback */
        }
      }
    }
  },
}; // end of LoginManagerAuthPromptFactory implementation

XPCOMUtils.defineLazyGetter(
  LoginManagerAuthPromptFactory.prototype,
  "log",
  () => {
    let logger = LoginHelper.createLogger("LoginManagerAuthPromptFactory");
    return logger.log.bind(logger);
  }
);

/* ==================== LoginManagerAuthPrompter ==================== */

/**
 * Implements interfaces for prompting the user to enter/save/change auth info.
 *
 * nsIAuthPrompt: Used by SeaMonkey, Thunderbird, but not Firefox.
 *
 * nsIAuthPrompt2: Is invoked by a channel for protocol-based authentication
 * (eg HTTP Authenticate, FTP login).
 *
 * nsILoginManagerAuthPrompter: Used by consumers to indicate which tab/window a
 * prompt should appear on.
 */
function LoginManagerAuthPrompter() {}

LoginManagerAuthPrompter.prototype = {
  classID: Components.ID("{8aa66d77-1bbb-45a6-991e-b8f47751c291}"),
  QueryInterface: ChromeUtils.generateQI([
    Ci.nsIAuthPrompt,
    Ci.nsIAuthPrompt2,
    Ci.nsILoginManagerAuthPrompter,
  ]),

  _factory: null,
  _chromeWindow: null,
  _browser: null,
  _openerBrowser: null,

  __strBundle: null, // String bundle for L10N
  get _strBundle() {
    if (!this.__strBundle) {
      this.__strBundle = Services.strings.createBundle(
        "chrome://passwordmgr/locale/passwordmgr.properties"
      );
      if (!this.__strBundle) {
        throw new Error("String bundle for Login Manager not present!");
      }
    }

    return this.__strBundle;
  },

  __ellipsis: null,
  get _ellipsis() {
    if (!this.__ellipsis) {
      this.__ellipsis = "\u2026";
      try {
        this.__ellipsis = Services.prefs.getComplexValue(
          "intl.ellipsis",
          Ci.nsIPrefLocalizedString
        ).data;
      } catch (e) {}
    }
    return this.__ellipsis;
  },

  // Whether we are in private browsing mode
  get _inPrivateBrowsing() {
    if (this._chromeWindow) {
      return PrivateBrowsingUtils.isWindowPrivate(this._chromeWindow);
    }
    // If we don't that we're in private browsing mode if the caller did
    // not provide a window.  The callers which really care about this
    // will indeed pass down a window to us, and for those who don't,
    // we can just assume that we don't want to save the entered login
    // information.
    this.log("We have no chromeWindow so assume we're in a private context");
    return true;
  },

  get _allowRememberLogin() {
    if (!this._inPrivateBrowsing) {
      return true;
    }
    return LoginHelper.privateBrowsingCaptureEnabled;
  },

  /* ---------- nsIAuthPrompt prompts ---------- */

  /**
   * Wrapper around the prompt service prompt. Saving random fields here
   * doesn't really make sense and therefore isn't implemented.
   */
  prompt(
    aDialogTitle,
    aText,
    aPasswordRealm,
    aSavePassword,
    aDefaultText,
    aResult
  ) {
    if (aSavePassword != Ci.nsIAuthPrompt.SAVE_PASSWORD_NEVER) {
      throw new Components.Exception(
        "prompt only supports SAVE_PASSWORD_NEVER",
        Cr.NS_ERROR_NOT_IMPLEMENTED
      );
    }

    this.log("===== prompt() called =====");

    if (aDefaultText) {
      aResult.value = aDefaultText;
    }

    return Services.prompt.prompt(
      this._chromeWindow,
      aDialogTitle,
      aText,
      aResult,
      null,
      {}
    );
  },

  /**
   * Looks up a username and password in the database. Will prompt the user
   * with a dialog, even if a username and password are found.
   */
  promptUsernameAndPassword(
    aDialogTitle,
    aText,
    aPasswordRealm,
    aSavePassword,
    aUsername,
    aPassword
  ) {
    this.log("===== promptUsernameAndPassword() called =====");

    if (aSavePassword == Ci.nsIAuthPrompt.SAVE_PASSWORD_FOR_SESSION) {
      throw new Components.Exception(
        "promptUsernameAndPassword doesn't support SAVE_PASSWORD_FOR_SESSION",
        Cr.NS_ERROR_NOT_IMPLEMENTED
      );
    }

    let foundLogins = null;
    var selectedLogin = null;
    var checkBox = { value: false };
    var checkBoxLabel = null;
    var [origin, realm, unused] = this._getRealmInfo(aPasswordRealm);

    // If origin is null, we can't save this login.
    if (origin) {
      var canRememberLogin = false;
      if (this._allowRememberLogin) {
        canRememberLogin =
          aSavePassword == Ci.nsIAuthPrompt.SAVE_PASSWORD_PERMANENTLY &&
          Services.logins.getLoginSavingEnabled(origin);
      }

      // if checkBoxLabel is null, the checkbox won't be shown at all.
      if (canRememberLogin) {
        checkBoxLabel = this._getLocalizedString("rememberPassword");
      }

      // Look for existing logins.
      foundLogins = Services.logins.findLogins(origin, null, realm);

      // XXX Like the original code, we can't deal with multiple
      // account selection. (bug 227632)
      if (foundLogins.length) {
        selectedLogin = foundLogins[0];

        // If the caller provided a username, try to use it. If they
        // provided only a password, this will try to find a password-only
        // login (or return null if none exists).
        if (aUsername.value) {
          selectedLogin = this._repickSelectedLogin(
            foundLogins,
            aUsername.value
          );
        }

        if (selectedLogin) {
          checkBox.value = true;
          aUsername.value = selectedLogin.username;
          // If the caller provided a password, prefer it.
          if (!aPassword.value) {
            aPassword.value = selectedLogin.password;
          }
        }
      }
    }

    let autofilled = !!aPassword.value;
    var ok = Services.prompt.promptUsernameAndPassword(
      this._chromeWindow,
      aDialogTitle,
      aText,
      aUsername,
      aPassword,
      checkBoxLabel,
      checkBox
    );

    if (!ok || !checkBox.value || !origin) {
      return ok;
    }

    if (!aPassword.value) {
      this.log("No password entered, so won't offer to save.");
      return ok;
    }

    // XXX We can't prompt with multiple logins yet (bug 227632), so
    // the entered login might correspond to an existing login
    // other than the one we originally selected.
    selectedLogin = this._repickSelectedLogin(foundLogins, aUsername.value);

    // If we didn't find an existing login, or if the username
    // changed, save as a new login.
    let newLogin = new LoginInfo(
      origin,
      null,
      realm,
      aUsername.value,
      aPassword.value
    );
    if (!selectedLogin) {
      // add as new
      this.log("New login seen for " + realm);
      Services.logins.addLogin(newLogin);
    } else if (aPassword.value != selectedLogin.password) {
      // update password
      this.log("Updating password for  " + realm);
      this._updateLogin(selectedLogin, newLogin);
    } else {
      this.log("Login unchanged, no further action needed.");
      Services.logins.recordPasswordUse(
        selectedLogin,
        this._inPrivateBrowsing,
        "prompt_login",
        autofilled
      );
    }

    return ok;
  },

  /**
   * If a password is found in the database for the password realm, it is
   * returned straight away without displaying a dialog.
   *
   * If a password is not found in the database, the user will be prompted
   * with a dialog with a text field and ok/cancel buttons. If the user
   * allows it, then the password will be saved in the database.
   */
  promptPassword(
    aDialogTitle,
    aText,
    aPasswordRealm,
    aSavePassword,
    aPassword
  ) {
    this.log("===== promptPassword called() =====");

    if (aSavePassword == Ci.nsIAuthPrompt.SAVE_PASSWORD_FOR_SESSION) {
      throw new Components.Exception(
        "promptPassword doesn't support SAVE_PASSWORD_FOR_SESSION",
        Cr.NS_ERROR_NOT_IMPLEMENTED
      );
    }

    var checkBox = { value: false };
    var checkBoxLabel = null;
    var [origin, realm, username] = this._getRealmInfo(aPasswordRealm);

    username = decodeURIComponent(username);

    // If origin is null, we can't save this login.
    if (origin && !this._inPrivateBrowsing) {
      var canRememberLogin =
        aSavePassword == Ci.nsIAuthPrompt.SAVE_PASSWORD_PERMANENTLY &&
        Services.logins.getLoginSavingEnabled(origin);

      // if checkBoxLabel is null, the checkbox won't be shown at all.
      if (canRememberLogin) {
        checkBoxLabel = this._getLocalizedString("rememberPassword");
      }

      if (!aPassword.value) {
        // Look for existing logins.
        var foundLogins = Services.logins.findLogins(origin, null, realm);

        // XXX Like the original code, we can't deal with multiple
        // account selection (bug 227632). We can deal with finding the
        // account based on the supplied username - but in this case we'll
        // just return the first match.
        for (var i = 0; i < foundLogins.length; ++i) {
          if (foundLogins[i].username == username) {
            aPassword.value = foundLogins[i].password;
            // wallet returned straight away, so this mimics that code
            return true;
          }
        }
      }
    }

    var ok = Services.prompt.promptPassword(
      this._chromeWindow,
      aDialogTitle,
      aText,
      aPassword,
      checkBoxLabel,
      checkBox
    );

    if (ok && checkBox.value && origin && aPassword.value) {
      let newLogin = new LoginInfo(
        origin,
        null,
        realm,
        username,
        aPassword.value
      );

      this.log("New login seen for " + realm);

      Services.logins.addLogin(newLogin);
    }

    return ok;
  },

  /* ---------- nsIAuthPrompt helpers ---------- */

  /**
   * Given aRealmString, such as "http://user@example.com/foo", returns an
   * array of:
   *   - the formatted origin
   *   - the realm (origin + path)
   *   - the username, if present
   *
   * If aRealmString is in the format produced by NS_GetAuthKey for HTTP[S]
   * channels, e.g. "example.com:80 (httprealm)", null is returned for all
   * arguments to let callers know the login can't be saved because we don't
   * know whether it's http or https.
   */
  _getRealmInfo(aRealmString) {
    var httpRealm = /^.+ \(.+\)$/;
    if (httpRealm.test(aRealmString)) {
      return [null, null, null];
    }

    var uri = Services.io.newURI(aRealmString);
    var pathname = "";

    if (uri.pathQueryRef != "/") {
      pathname = uri.pathQueryRef;
    }

    var formattedOrigin = this._getFormattedOrigin(uri);

    return [formattedOrigin, formattedOrigin + pathname, uri.username];
  },

  /* ---------- nsIAuthPrompt2 prompts ---------- */

  /**
   * Implementation of nsIAuthPrompt2.
   *
   * @param {nsIChannel} aChannel
   * @param {int}        aLevel
   * @param {nsIAuthInformation} aAuthInfo
   */
  promptAuth(aChannel, aLevel, aAuthInfo) {
    var selectedLogin = null;
    var checkbox = { value: false };
    var checkboxLabel = null;
    var epicfail = false;
    var canAutologin = false;
    var notifyObj;
    var foundLogins;
    let autofilled = false;

    try {
      this.log("===== promptAuth called =====");

      // If the user submits a login but it fails, we need to remove the
      // notification prompt that was displayed. Conveniently, the user will
      // be prompted for authentication again, which brings us here.
      this._removeLoginNotifications();

      var [origin, httpRealm] = this._getAuthTarget(aChannel, aAuthInfo);

      // Looks for existing logins to prefill the prompt with.
      foundLogins = LoginHelper.searchLoginsWithObject({
        origin,
        httpRealm,
        schemeUpgrades: LoginHelper.schemeUpgrades,
      });
      this.log("found", foundLogins.length, "matching logins.");
      let resolveBy = ["scheme", "timePasswordChanged"];
      foundLogins = LoginHelper.dedupeLogins(
        foundLogins,
        ["username"],
        resolveBy,
        origin
      );
      this.log(foundLogins.length, "matching logins remain after deduping");

      // XXX Can't select from multiple accounts yet. (bug 227632)
      if (foundLogins.length) {
        selectedLogin = foundLogins[0];
        this._SetAuthInfo(
          aAuthInfo,
          selectedLogin.username,
          selectedLogin.password
        );
        autofilled = true;

        // Allow automatic proxy login
        if (
          aAuthInfo.flags & Ci.nsIAuthInformation.AUTH_PROXY &&
          !(aAuthInfo.flags & Ci.nsIAuthInformation.PREVIOUS_FAILED) &&
          Services.prefs.getBoolPref("signon.autologin.proxy") &&
          !PrivateBrowsingUtils.permanentPrivateBrowsing
        ) {
          this.log("Autologin enabled, skipping auth prompt.");
          canAutologin = true;
        }

        checkbox.value = true;
      }

      var canRememberLogin = Services.logins.getLoginSavingEnabled(origin);
      if (!this._allowRememberLogin) {
        canRememberLogin = false;
      }

      // if checkboxLabel is null, the checkbox won't be shown at all.
      notifyObj = this._getPopupNote();
      if (canRememberLogin && !notifyObj) {
        checkboxLabel = this._getLocalizedString("rememberPassword");
      }
    } catch (e) {
      // Ignore any errors and display the prompt anyway.
      epicfail = true;
      Cu.reportError(
        "LoginManagerAuthPrompter: Epic fail in promptAuth: " + e + "\n"
      );
    }

    var ok = canAutologin;
    let browser = this._browser;
    let baseDomain;

    // We might not have a browser or browser.currentURI.host could fail
    // (e.g. on about:blank). Fall back to the subresource hostname in that case.
    try {
      let topLevelHost = browser.currentURI.host;
      baseDomain = PromptAbuseHelper.getBaseDomainOrFallback(topLevelHost);
    } catch (e) {
      baseDomain = PromptAbuseHelper.getBaseDomainOrFallback(origin);
    }

    if (!ok) {
      if (PromptAbuseHelper.hasReachedAbuseLimit(baseDomain, browser)) {
        this.log("Blocking auth dialog, due to exceeding dialog bloat limit");
        return false;
      }

      // Set up a counter for ensuring that the basic auth prompt can not
      // be abused for DOS-style attacks. With this counter, each eTLD+1
      // per browser will get a limited number of times a user can
      // cancel the prompt until we stop showing it.
      PromptAbuseHelper.incrementPromptAbuseCounter(baseDomain, browser);

      if (this._chromeWindow) {
        PromptUtils.fireDialogEvent(
          this._chromeWindow,
          "DOMWillOpenModalDialog",
          this._browser
        );
      }
      ok = Services.prompt.promptAuth(
        this._chromeWindow,
        aChannel,
        aLevel,
        aAuthInfo,
        checkboxLabel,
        checkbox
      );
    }

    let [username, password] = this._GetAuthInfo(aAuthInfo);

    // Reset the counter state if the user replied to a prompt and actually
    // tried to login (vs. simply clicking any button to get out).
    if (ok && (username || password)) {
      PromptAbuseHelper.resetPromptAbuseCounter(baseDomain, browser);
    }

    // If there's a notification prompt, use it to allow the user to
    // determine if the login should be saved. If there isn't a
    // notification prompt, only save the login if the user set the
    // checkbox to do so.
    var rememberLogin = notifyObj ? canRememberLogin : checkbox.value;
    if (!ok || !rememberLogin || epicfail) {
      return ok;
    }

    try {
      if (!password) {
        this.log("No password entered, so won't offer to save.");
        return ok;
      }

      // XXX We can't prompt with multiple logins yet (bug 227632), so
      // the entered login might correspond to an existing login
      // other than the one we originally selected.
      selectedLogin = this._repickSelectedLogin(foundLogins, username);

      // If we didn't find an existing login, or if the username
      // changed, save as a new login.
      let newLogin = new LoginInfo(origin, null, httpRealm, username, password);
      if (!selectedLogin) {
        this.log(
          "New login seen for " +
            username +
            " @ " +
            origin +
            " (" +
            httpRealm +
            ")"
        );

        if (notifyObj) {
          let promptBrowser = LoginHelper.getBrowserForPrompt(browser);
          LoginManagerPrompter._showLoginCaptureDoorhanger(
            promptBrowser,
            newLogin,
            "password-save",
            {
              dismissed: this._inPrivateBrowsing,
            }
          );
          Services.obs.notifyObservers(newLogin, "passwordmgr-prompt-save");
        } else {
          Services.logins.addLogin(newLogin);
        }
      } else if (password != selectedLogin.password) {
        this.log(
          "Updating password for " +
            username +
            " @ " +
            origin +
            " (" +
            httpRealm +
            ")"
        );
        if (notifyObj) {
          this._showChangeLoginNotification(browser, selectedLogin, newLogin);
        } else {
          this._updateLogin(selectedLogin, newLogin);
        }
      } else {
        this.log("Login unchanged, no further action needed.");
        Services.logins.recordPasswordUse(
          selectedLogin,
          this._inPrivateBrowsing,
          "auth_login",
          autofilled
        );
      }
    } catch (e) {
      Cu.reportError("LoginManagerAuthPrompter: Fail2 in promptAuth: " + e);
    }

    return ok;
  },

  asyncPromptAuth(aChannel, aCallback, aContext, aLevel, aAuthInfo) {
    var cancelable = null;

    try {
      this.log("===== asyncPromptAuth called =====");

      // If the user submits a login but it fails, we need to remove the
      // notification prompt that was displayed. Conveniently, the user will
      // be prompted for authentication again, which brings us here.
      this._removeLoginNotifications();

      cancelable = this._newAsyncPromptConsumer(aCallback, aContext);

      var [origin, httpRealm] = this._getAuthTarget(aChannel, aAuthInfo);

      var hashKey = aLevel + "|" + origin + "|" + httpRealm;
      this.log("Async prompt key = " + hashKey);
      var asyncPrompt = this._factory._asyncPrompts[hashKey];
      if (asyncPrompt) {
        this.log(
          "Prompt bound to an existing one in the queue, callback = " +
            aCallback
        );
        asyncPrompt.consumers.push(cancelable);
        return cancelable;
      }

      this.log("Adding new prompt to the queue, callback = " + aCallback);
      asyncPrompt = {
        consumers: [cancelable],
        channel: aChannel,
        authInfo: aAuthInfo,
        level: aLevel,
        inProgress: false,
        prompter: this,
      };

      this._factory._asyncPrompts[hashKey] = asyncPrompt;
      this._factory._doAsyncPrompt();
    } catch (e) {
      Cu.reportError(
        "LoginManagerAuthPrompter: " +
          "asyncPromptAuth: " +
          e +
          "\nFalling back to promptAuth\n"
      );
      // Fail the prompt operation to let the consumer fall back
      // to synchronous promptAuth method
      throw e;
    }

    return cancelable;
  },

  /* ---------- nsILoginManagerAuthPrompter prompts ---------- */

  init(aWindow = null, aFactory = null) {
    if (!aWindow) {
      // There may be no applicable window e.g. in a Sandbox or JSM.
      this._chromeWindow = null;
      this._browser = null;
    } else if (aWindow.isChromeWindow) {
      this._chromeWindow = aWindow;
      // needs to be set explicitly using setBrowser
      this._browser = null;
    } else {
      let { win, browser } = this._getChromeWindow(aWindow);
      this._chromeWindow = win;
      this._browser = browser;
    }
    this._openerBrowser = null;
    this._factory = aFactory || null;

    this.log("===== initialized =====");
  },

  set browser(aBrowser) {
    this._browser = aBrowser;
  },

  set openerBrowser(aOpenerBrowser) {
    this._openerBrowser = aOpenerBrowser;
  },

  _removeLoginNotifications() {
    var popupNote = this._getPopupNote();
    if (popupNote) {
      popupNote = popupNote.getNotification("password");
    }
    if (popupNote) {
      popupNote.remove();
    }
  },

  /**
   * Shows the Change Password popup notification.
   *
   * @param aBrowser
   *        The relevant <browser>.
   * @param aOldLogin
   *        The stored login we want to update.
   * @param aNewLogin
   *        The login object with the changes we want to make.
   * @param dismissed
   *        A boolean indicating if the prompt should be automatically
   *        dismissed on being shown.
   * @param notifySaved
   *        A boolean value indicating whether the notification should indicate that
   *        a login has been saved
   */
  _showChangeLoginNotification(
    aBrowser,
    aOldLogin,
    aNewLogin,
    dismissed = false,
    notifySaved = false,
    autoSavedLoginGuid = ""
  ) {
    let login = aOldLogin.clone();
    login.origin = aNewLogin.origin;
    login.formActionOrigin = aNewLogin.formActionOrigin;
    login.password = aNewLogin.password;
    login.username = aNewLogin.username;

    let messageStringID;
    if (
      aOldLogin.username === "" &&
      login.username !== "" &&
      login.password == aOldLogin.password
    ) {
      // If the saved password matches the password we're prompting with then we
      // are only prompting to let the user add a username since there was one in
      // the form. Change the message so the purpose of the prompt is clearer.
      messageStringID = "updateLoginMsgAddUsername";
    }

    let promptBrowser = LoginHelper.getBrowserForPrompt(aBrowser);
    LoginManagerPrompter._showLoginCaptureDoorhanger(
      promptBrowser,
      login,
      "password-change",
      {
        dismissed,
        extraAttr: notifySaved ? "attention" : "",
      },
      {
        notifySaved,
        messageStringID,
        autoSavedLoginGuid,
      }
    );

    let oldGUID = aOldLogin.QueryInterface(Ci.nsILoginMetaInfo).guid;
    Services.obs.notifyObservers(
      aNewLogin,
      "passwordmgr-prompt-change",
      oldGUID
    );
  },

  /* ---------- Internal Methods ---------- */

  _updateLogin(login, aNewLogin) {
    var now = Date.now();
    var propBag = Cc["@mozilla.org/hash-property-bag;1"].createInstance(
      Ci.nsIWritablePropertyBag
    );
    propBag.setProperty("formActionOrigin", aNewLogin.formActionOrigin);
    propBag.setProperty("origin", aNewLogin.origin);
    propBag.setProperty("password", aNewLogin.password);
    propBag.setProperty("username", aNewLogin.username);
    // Explicitly set the password change time here (even though it would
    // be changed automatically), to ensure that it's exactly the same
    // value as timeLastUsed.
    propBag.setProperty("timePasswordChanged", now);
    propBag.setProperty("timeLastUsed", now);
    propBag.setProperty("timesUsedIncrement", 1);
    // Note that we don't call `recordPasswordUse` so we won't potentially record
    // both a use and a save/update. See bug 1640096.
    Services.logins.modifyLogin(login, propBag);
  },

  /**
   * Given a content DOM window, returns the chrome window and browser it's in.
   */
  _getChromeWindow(aWindow) {
    let browser = aWindow.docShell.chromeEventHandler;
    if (!browser) {
      return null;
    }

    let chromeWin = browser.ownerGlobal;
    if (!chromeWin) {
      return null;
    }

    return { win: chromeWin, browser };
  },

  _getNotifyWindow() {
    if (this._openerBrowser) {
      let chromeDoc = this._chromeWindow.document.documentElement;

      // Check to see if the current window was opened with chrome
      // disabled, and if so use the opener window. But if the window
      // has been used to visit other pages (ie, has a history),
      // assume it'll stick around and *don't* use the opener.
      if (chromeDoc.getAttribute("chromehidden") && !this._browser.canGoBack) {
        this.log("Using opener window for notification prompt.");
        return {
          win: this._openerBrowser.ownerGlobal,
          browser: this._openerBrowser,
        };
      }
    }

    return {
      win: this._chromeWindow,
      browser: this._browser,
    };
  },

  /**
   * Returns the popup notification to this prompter,
   * or null if there isn't one available.
   */
  _getPopupNote() {
    let popupNote = null;

    try {
      let { win: notifyWin } = this._getNotifyWindow();

      // .wrappedJSObject needed here -- see bug 422974 comment 5.
      popupNote = notifyWin.wrappedJSObject.PopupNotifications;
    } catch (e) {
      this.log("Popup notifications not available on window");
    }

    return popupNote;
  },

  /**
   * The user might enter a login that isn't the one we prefilled, but
   * is the same as some other existing login. So, pick a login with a
   * matching username, or return null.
   */
  _repickSelectedLogin(foundLogins, username) {
    for (var i = 0; i < foundLogins.length; i++) {
      if (foundLogins[i].username == username) {
        return foundLogins[i];
      }
    }
    return null;
  },

  /**
   * Can be called as:
   *   _getLocalizedString("key1");
   *   _getLocalizedString("key2", ["arg1"]);
   *   _getLocalizedString("key3", ["arg1", "arg2"]);
   *   (etc)
   *
   * Returns the localized string for the specified key,
   * formatted if required.
   *
   */
  _getLocalizedString(key, formatArgs) {
    if (formatArgs) {
      return this._strBundle.formatStringFromName(key, formatArgs);
    }
    return this._strBundle.GetStringFromName(key);
  },

  /**
   * Sanitizes the specified username, by stripping quotes and truncating if
   * it's too long. This helps prevent an evil site from messing with the
   * "save password?" prompt too much.
   */
  _sanitizeUsername(username) {
    if (username.length > 30) {
      username = username.substring(0, 30);
      username += this._ellipsis;
    }
    return username.replace(/['"]/g, "");
  },

  /**
   * The aURI parameter may either be a string uri, or an nsIURI instance.
   *
   * Returns the origin to use in a nsILoginInfo object (for example,
   * "http://example.com").
   */
  _getFormattedOrigin(aURI) {
    let uri;
    if (aURI instanceof Ci.nsIURI) {
      uri = aURI;
    } else {
      uri = Services.io.newURI(aURI);
    }

    return uri.scheme + "://" + uri.displayHostPort;
  },

  /**
   * Converts a login's origin field (a URL) to a short string for
   * prompting purposes. Eg, "http://foo.com" --> "foo.com", or
   * "ftp://www.site.co.uk" --> "site.co.uk".
   */
  _getShortDisplayHost(aURIString) {
    var displayHost;

    var idnService = Cc["@mozilla.org/network/idn-service;1"].getService(
      Ci.nsIIDNService
    );
    try {
      var uri = Services.io.newURI(aURIString);
      var baseDomain = Services.eTLD.getBaseDomain(uri);
      displayHost = idnService.convertToDisplayIDN(baseDomain, {});
    } catch (e) {
      this.log("_getShortDisplayHost couldn't process " + aURIString);
    }

    if (!displayHost) {
      displayHost = aURIString;
    }

    return displayHost;
  },

  /**
   * Returns the origin and realm for which authentication is being
   * requested, in the format expected to be used with nsILoginInfo.
   */
  _getAuthTarget(aChannel, aAuthInfo) {
    var origin, realm;

    // If our proxy is demanding authentication, don't use the
    // channel's actual destination.
    if (aAuthInfo.flags & Ci.nsIAuthInformation.AUTH_PROXY) {
      this.log("getAuthTarget is for proxy auth");
      if (!(aChannel instanceof Ci.nsIProxiedChannel)) {
        throw new Error("proxy auth needs nsIProxiedChannel");
      }

      var info = aChannel.proxyInfo;
      if (!info) {
        throw new Error("proxy auth needs nsIProxyInfo");
      }

      // Proxies don't have a scheme, but we'll use "moz-proxy://"
      // so that it's more obvious what the login is for.
      var idnService = Cc["@mozilla.org/network/idn-service;1"].getService(
        Ci.nsIIDNService
      );
      origin =
        "moz-proxy://" +
        idnService.convertUTF8toACE(info.host) +
        ":" +
        info.port;
      realm = aAuthInfo.realm;
      if (!realm) {
        realm = origin;
      }

      return [origin, realm];
    }

    origin = this._getFormattedOrigin(aChannel.URI);

    // If a HTTP WWW-Authenticate header specified a realm, that value
    // will be available here. If it wasn't set or wasn't HTTP, we'll use
    // the formatted origin instead.
    realm = aAuthInfo.realm;
    if (!realm) {
      realm = origin;
    }

    return [origin, realm];
  },

  /**
   * Returns [username, password] as extracted from aAuthInfo (which
   * holds this info after having prompted the user).
   *
   * If the authentication was for a Windows domain, we'll prepend the
   * return username with the domain. (eg, "domain\user")
   */
  _GetAuthInfo(aAuthInfo) {
    var username, password;

    var flags = aAuthInfo.flags;
    if (flags & Ci.nsIAuthInformation.NEED_DOMAIN && aAuthInfo.domain) {
      username = aAuthInfo.domain + "\\" + aAuthInfo.username;
    } else {
      username = aAuthInfo.username;
    }

    password = aAuthInfo.password;

    return [username, password];
  },

  /**
   * Given a username (possibly in DOMAIN\user form) and password, parses the
   * domain out of the username if necessary and sets domain, username and
   * password on the auth information object.
   */
  _SetAuthInfo(aAuthInfo, username, password) {
    var flags = aAuthInfo.flags;
    if (flags & Ci.nsIAuthInformation.NEED_DOMAIN) {
      // Domain is separated from username by a backslash
      var idx = username.indexOf("\\");
      if (idx == -1) {
        aAuthInfo.username = username;
      } else {
        aAuthInfo.domain = username.substring(0, idx);
        aAuthInfo.username = username.substring(idx + 1);
      }
    } else {
      aAuthInfo.username = username;
    }
    aAuthInfo.password = password;
  },

  _newAsyncPromptConsumer(aCallback, aContext) {
    return {
      QueryInterface: ChromeUtils.generateQI([Ci.nsICancelable]),
      callback: aCallback,
      context: aContext,
      cancel() {
        this.callback.onAuthCancelled(this.context, false);
        this.callback = null;
        this.context = null;
      },
    };
  },
}; // end of LoginManagerAuthPrompter implementation

XPCOMUtils.defineLazyGetter(LoginManagerAuthPrompter.prototype, "log", () => {
  let logger = LoginHelper.createLogger("LoginManagerAuthPrompter");
  return logger.log.bind(logger);
});

const EXPORTED_SYMBOLS = [
  "LoginManagerAuthPromptFactory",
  "LoginManagerAuthPrompter",
];
