/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["RemotePageAccessManager"];

/*
 * Used for all kinds of permissions checks which requires explicit
 * whitelisting of specific permissions granted through Remote Pages.
 * An RPM function will be exported into the page only if it appears
 * in the access managers's accessMap for that page's uri.
 *
 * This module may be used from both the child and parent process.
 *
 * Please note that prefs that one wants to update need to be
 * whitelisted within AsyncPrefs.jsm.
 */
let RemotePageAccessManager = {
  /* The accessMap lists the permissions that are allowed per page.
   * The structure should be of the following form:
   *   <URL> : {
   *     <function name>: [<keys>],
   *     ...
   *   }
   * For the page with given URL, permission is allowed for each
   * listed function with a matching key. The first argument to the
   * function must match one of the keys. If keys is an array with a
   * single asterisk element ["*"], then all values are permitted.
   */
  accessMap: {
    "about:certerror": {
      RPMSendAsyncMessage: [
        "Browser:EnableOnlineMode",
        "Browser:ResetSSLPreferences",
        "GetChangedCertPrefs",
        "ReportTLSError",
        "Browser:OpenCaptivePortalPage",
        "Browser:SSLErrorGoBack",
        "Browser:PrimeMitm",
        "Browser:ResetEnterpriseRootsPref",
      ],
      RPMRecordTelemetryEvent: ["*"],
      RPMAddMessageListener: ["*"],
      RPMRemoveMessageListener: ["*"],
      RPMGetFormatURLPref: ["app.support.baseURL"],
      RPMGetBoolPref: [
        "security.certerrors.mitm.priming.enabled",
        "security.certerrors.permanentOverride",
        "security.enterprise_roots.auto-enabled",
        "security.certerror.hideAddException",
        "security.ssl.errorReporting.automatic",
        "security.ssl.errorReporting.enabled",
      ],
      RPMSetBoolPref: [
        "security.ssl.errorReporting.automatic",
        "security.tls.version.enable-deprecated",
      ],
      RPMGetIntPref: [
        "services.settings.clock_skew_seconds",
        "services.settings.last_update_seconds",
      ],
      RPMGetAppBuildID: ["*"],
      RPMIsWindowPrivate: ["*"],
      RPMAddToHistogram: ["*"],
    },
    "about:httpsonlyerror": {
      RPMSendAsyncMessage: ["goBack", "openInsecure"],
    },
    "about:neterror": {
      RPMSendAsyncMessage: [
        "Browser:EnableOnlineMode",
        "Browser:ResetSSLPreferences",
        "GetChangedCertPrefs",
        "ReportTLSError",
        "Browser:OpenCaptivePortalPage",
        "Browser:SSLErrorGoBack",
        "Browser:PrimeMitm",
        "Browser:ResetEnterpriseRootsPref",
      ],
      RPMAddMessageListener: ["*"],
      RPMRemoveMessageListener: ["*"],
      RPMGetFormatURLPref: ["app.support.baseURL"],
      RPMGetBoolPref: [
        "security.certerror.hideAddException",
        "security.ssl.errorReporting.automatic",
        "security.ssl.errorReporting.enabled",
        "security.tls.version.enable-deprecated",
        "security.certerrors.tls.version.show-override",
      ],
      RPMSetBoolPref: [
        "security.ssl.errorReporting.automatic",
        "security.tls.version.enable-deprecated",
      ],
      RPMPrefIsLocked: ["security.tls.version.min"],
      RPMAddToHistogram: ["*"],
    },
    "about:newinstall": {
      RPMGetUpdateChannel: ["*"],
      RPMGetFxAccountsEndpoint: ["*"],
    },
    "about:plugins": {
      RPMSendQuery: ["RequestPlugins"],
    },
    "about:privatebrowsing": {
      RPMSendAsyncMessage: [
        "OpenPrivateWindow",
        "SearchBannerDismissed",
        "OpenSearchPreferences",
        "SearchHandoff",
      ],
      RPMSendQuery: ["ShouldShowSearchBanner"],
      RPMAddMessageListener: ["*"],
      RPMRemoveMessageListener: ["*"],
      RPMGetFormatURLPref: ["app.support.baseURL"],
      RPMIsWindowPrivate: ["*"],
    },
    "about:protections": {
      RPMSendAsyncMessage: [
        "OpenContentBlockingPreferences",
        "OpenAboutLogins",
        "OpenSyncPreferences",
        "ClearMonitorCache",
      ],
      RPMSendQuery: [
        "FetchUserLoginsData",
        "FetchMonitorData",
        "FetchContentBlockingEvents",
        "FetchMobileDeviceConnected",
        "GetShowProxyCard",
      ],
      RPMAddMessageListener: ["*"],
      RPMRemoveMessageListener: ["*"],
      RPMSetBoolPref: [
        "browser.contentblocking.report.hide_lockwise_app",
        "browser.contentblocking.report.show_mobile_app",
      ],
      RPMGetBoolPref: [
        "browser.contentblocking.report.lockwise.enabled",
        "browser.contentblocking.report.monitor.enabled",
        "privacy.socialtracking.block_cookies.enabled",
        "browser.contentblocking.report.proxy.enabled",
        "privacy.trackingprotection.cryptomining.enabled",
        "privacy.trackingprotection.fingerprinting.enabled",
        "privacy.trackingprotection.enabled",
        "privacy.trackingprotection.socialtracking.enabled",
        "browser.contentblocking.report.hide_lockwise_app",
        "browser.contentblocking.report.show_mobile_app",
      ],
      RPMGetStringPref: [
        "browser.contentblocking.category",
        "browser.contentblocking.report.monitor.url",
        "browser.contentblocking.report.monitor.sign_in_url",
        "browser.contentblocking.report.manage_devices.url",
        "browser.contentblocking.report.proxy_extension.url",
        "browser.contentblocking.report.lockwise.mobile-android.url",
        "browser.contentblocking.report.lockwise.mobile-ios.url",
        "browser.contentblocking.report.mobile-ios.url",
        "browser.contentblocking.report.mobile-android.url",
      ],
      RPMGetIntPref: ["network.cookie.cookieBehavior"],
      RPMGetFormatURLPref: [
        "browser.contentblocking.report.monitor.how_it_works.url",
        "browser.contentblocking.report.lockwise.how_it_works.url",
        "browser.contentblocking.report.monitor.preferences_url",
        "browser.contentblocking.report.monitor.home_page_url",
        "browser.contentblocking.report.social.url",
        "browser.contentblocking.report.cookie.url",
        "browser.contentblocking.report.tracker.url",
        "browser.contentblocking.report.fingerprinter.url",
        "browser.contentblocking.report.cryptominer.url",
      ],
      RPMRecordTelemetryEvent: ["*"],
    },
    "about:tabcrashed": {
      RPMSendAsyncMessage: ["Load", "closeTab", "restoreTab", "restoreAll"],
      RPMAddMessageListener: ["*"],
      RPMRemoveMessageListener: ["*"],
    },
  },

  /**
   * Check if access is allowed to the given feature for a given document.
   * This should be called from within the child process. A feature must
   * contain the value in the whitelist array in the list within the
   * accessMap for access to be granted.
   *
   * @param aDocument child process document to call from
   * @param aFeature to feature to check access to
   * @param aValue value that must be included with that feature's whitelist
   * @returns true if access is allowed or false otherwise
   */
  checkAllowAccess(aDocument, aFeature, aValue) {
    let principal = aDocument.nodePrincipal;
    // if there is no content principal; deny access
    if (!principal) {
      return false;
    }

    return this.checkAllowAccessWithPrincipal(
      principal,
      aFeature,
      aValue,
      aDocument
    );
  },

  /**
   * Check if access is allowed to the given feature for a given principal.
   * This may be called from within the child or parent process. A feature
   * must contain the value in the whitelist array in the list within the
   * accessMap for access to be granted.
   *
   * In the parent process, the passed-in document is expected to be null.
   *
   * @param aPrincipal principal being called from
   * @param aFeature to feature to check access to
   * @param aValue value that must be included with that feature's whitelist
   * @param aDocument optional child process document to call from
   * @returns true if access is allowed or false otherwise
   */
  checkAllowAccessWithPrincipal(aPrincipal, aFeature, aValue, aDocument) {
    let accessMapForFeature = this.checkAllowAccessToFeature(
      aPrincipal,
      aFeature,
      aDocument
    );
    if (!accessMapForFeature) {
      Cu.reportError(
        "RemotePageAccessManager does not allow access to Feature: " +
          aFeature +
          " for: " +
          aDocument.location
      );

      return false;
    }

    // If the actual value is in the whitelist for that feature;
    // allow access
    if (accessMapForFeature.includes(aValue) || accessMapForFeature[0] == "*") {
      return true;
    }

    return false;
  },

  /**
   * Check if a particular feature can be accessed without checking for a
   * value within the whitelist.
   *
   * @param aPrincipal principal being called from
   * @param aFeature to feature to check access to
   * @param aDocument optional child process document to call from
   * @returns non-null whitelist if access is allowed or null otherwise
   */
  checkAllowAccessToFeature(aPrincipal, aFeature, aDocument) {
    let uri;
    if (aPrincipal.isNullPrincipal || !aPrincipal.URI) {
      // Null principals have a null-principal URI, but for the sake of remote
      // pages we want to access the "real" document URI directly, e.g. if the
      // about: page is sandboxed.
      if (!aDocument) {
        return null;
      }

      uri = aDocument.documentURIObject;
    } else {
      uri = aPrincipal.URI;
    }

    // Cut query params
    let spec = uri.prePath + uri.filePath;

    if (!uri.schemeIs("about")) {
      return null;
    }

    // Check if there is an entry for that requestying URI in the accessMap;
    // if not, deny access.
    let accessMapForURI = this.accessMap[spec];
    if (!accessMapForURI) {
      return null;
    }

    // Check if the feature is allowed to be accessed for that URI;
    // if not, deny access.
    return accessMapForURI[aFeature];
  },
};
