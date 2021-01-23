/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* eslint-env mozilla/browser-window */

XPCOMUtils.defineLazyModuleGetters(this, {
  ContentBlockingAllowList:
    "resource://gre/modules/ContentBlockingAllowList.jsm",
  ToolbarPanelHub: "resource://activity-stream/lib/ToolbarPanelHub.jsm",
});

XPCOMUtils.defineLazyServiceGetter(
  this,
  "TrackingDBService",
  "@mozilla.org/tracking-db-service;1",
  "nsITrackingDBService"
);

var Fingerprinting = {
  PREF_ENABLED: "privacy.trackingprotection.fingerprinting.enabled",
  reportBreakageLabel: "fingerprinting",

  strings: {
    get subViewBlocked() {
      delete this.subViewBlocked;
      return (this.subViewBlocked = gNavigatorBundle.getString(
        "contentBlocking.fingerprintersView.blocked.label"
      ));
    },

    get subViewTitleBlocking() {
      delete this.subViewTitleBlocking;
      return (this.subViewTitleBlocking = gNavigatorBundle.getString(
        "protections.blocking.fingerprinters.title"
      ));
    },

    get subViewTitleNotBlocking() {
      delete this.subViewTitleNotBlocking;
      return (this.subViewTitleNotBlocking = gNavigatorBundle.getString(
        "protections.notBlocking.fingerprinters.title"
      ));
    },
  },

  init() {
    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "enabled",
      this.PREF_ENABLED,
      false,
      this.updateCategoryItem.bind(this)
    );
    this.updateCategoryItem();
  },

  get categoryItem() {
    delete this.categoryItem;
    return (this.categoryItem = document.getElementById(
      "protections-popup-category-fingerprinters"
    ));
  },

  updateCategoryItem() {
    this.categoryItem.classList.toggle("blocked", this.enabled);
  },

  get subView() {
    delete this.subView;
    return (this.subView = document.getElementById(
      "protections-popup-fingerprintersView"
    ));
  },

  get subViewList() {
    delete this.subViewList;
    return (this.subViewList = document.getElementById(
      "protections-popup-fingerprintersView-list"
    ));
  },

  isBlocking(state) {
    return (
      (state &
        Ci.nsIWebProgressListener.STATE_BLOCKED_FINGERPRINTING_CONTENT) !=
      0
    );
  },

  isAllowing(state) {
    return (
      (state & Ci.nsIWebProgressListener.STATE_LOADED_FINGERPRINTING_CONTENT) !=
      0
    );
  },

  isDetected(state) {
    return this.isBlocking(state) || this.isAllowing(state);
  },

  updateSubView() {
    let contentBlockingLog = gBrowser.selectedBrowser.getContentBlockingLog();
    contentBlockingLog = JSON.parse(contentBlockingLog);

    let fragment = document.createDocumentFragment();
    for (let [origin, actions] of Object.entries(contentBlockingLog)) {
      let listItem = this._createListItem(origin, actions);
      if (listItem) {
        fragment.appendChild(listItem);
      }
    }

    this.subViewList.textContent = "";
    this.subViewList.append(fragment);
    this.subView.setAttribute(
      "title",
      this.enabled && !gProtectionsHandler.hasException
        ? this.strings.subViewTitleBlocking
        : this.strings.subViewTitleNotBlocking
    );
  },

  _createListItem(origin, actions) {
    let isAllowed = actions.some(([state]) => this.isAllowing(state));
    let isDetected =
      isAllowed || actions.some(([state]) => this.isBlocking(state));

    if (!isDetected) {
      return null;
    }

    let listItem = document.createXULElement("hbox");
    listItem.className = "protections-popup-list-item";
    listItem.classList.toggle("allowed", isAllowed);
    // Repeat the host in the tooltip in case it's too long
    // and overflows in our panel.
    listItem.tooltipText = origin;

    let label = document.createXULElement("label");
    label.value = origin;
    label.className = "protections-popup-list-host-label";
    label.setAttribute("crop", "end");
    listItem.append(label);

    return listItem;
  },
};

var Cryptomining = {
  PREF_ENABLED: "privacy.trackingprotection.cryptomining.enabled",
  reportBreakageLabel: "cryptomining",

  strings: {
    get subViewBlocked() {
      delete this.subViewBlocked;
      return (this.subViewBlocked = gNavigatorBundle.getString(
        "contentBlocking.cryptominersView.blocked.label"
      ));
    },

    get subViewTitleBlocking() {
      delete this.subViewTitleBlocking;
      return (this.subViewTitleBlocking = gNavigatorBundle.getString(
        "protections.blocking.cryptominers.title"
      ));
    },

    get subViewTitleNotBlocking() {
      delete this.subViewTitleNotBlocking;
      return (this.subViewTitleNotBlocking = gNavigatorBundle.getString(
        "protections.notBlocking.cryptominers.title"
      ));
    },
  },

  init() {
    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "enabled",
      this.PREF_ENABLED,
      false,
      this.updateCategoryItem.bind(this)
    );
    this.updateCategoryItem();
  },

  get categoryItem() {
    delete this.categoryItem;
    return (this.categoryItem = document.getElementById(
      "protections-popup-category-cryptominers"
    ));
  },

  updateCategoryItem() {
    this.categoryItem.classList.toggle("blocked", this.enabled);
  },

  get subView() {
    delete this.subView;
    return (this.subView = document.getElementById(
      "protections-popup-cryptominersView"
    ));
  },

  get subViewList() {
    delete this.subViewList;
    return (this.subViewList = document.getElementById(
      "protections-popup-cryptominersView-list"
    ));
  },

  isBlocking(state) {
    return (
      (state & Ci.nsIWebProgressListener.STATE_BLOCKED_CRYPTOMINING_CONTENT) !=
      0
    );
  },

  isAllowing(state) {
    return (
      (state & Ci.nsIWebProgressListener.STATE_LOADED_CRYPTOMINING_CONTENT) != 0
    );
  },

  isDetected(state) {
    return this.isBlocking(state) || this.isAllowing(state);
  },

  updateSubView() {
    let contentBlockingLog = gBrowser.selectedBrowser.getContentBlockingLog();
    contentBlockingLog = JSON.parse(contentBlockingLog);

    let fragment = document.createDocumentFragment();
    for (let [origin, actions] of Object.entries(contentBlockingLog)) {
      let listItem = this._createListItem(origin, actions);
      if (listItem) {
        fragment.appendChild(listItem);
      }
    }

    this.subViewList.textContent = "";
    this.subViewList.append(fragment);
    this.subView.setAttribute(
      "title",
      this.enabled && !gProtectionsHandler.hasException
        ? this.strings.subViewTitleBlocking
        : this.strings.subViewTitleNotBlocking
    );
  },

  _createListItem(origin, actions) {
    let isAllowed = actions.some(([state]) => this.isAllowing(state));
    let isDetected =
      isAllowed || actions.some(([state]) => this.isBlocking(state));

    if (!isDetected) {
      return null;
    }

    let listItem = document.createXULElement("hbox");
    listItem.className = "protections-popup-list-item";
    listItem.classList.toggle("allowed", isAllowed);
    // Repeat the host in the tooltip in case it's too long
    // and overflows in our panel.
    listItem.tooltipText = origin;

    let label = document.createXULElement("label");
    label.value = origin;
    label.className = "protections-popup-list-host-label";
    label.setAttribute("crop", "end");
    listItem.append(label);

    return listItem;
  },
};

var TrackingProtection = {
  reportBreakageLabel: "trackingprotection",
  PREF_ENABLED_GLOBALLY: "privacy.trackingprotection.enabled",
  PREF_ENABLED_IN_PRIVATE_WINDOWS: "privacy.trackingprotection.pbmode.enabled",
  PREF_TRACKING_TABLE: "urlclassifier.trackingTable",
  PREF_TRACKING_ANNOTATION_TABLE: "urlclassifier.trackingAnnotationTable",
  PREF_ANNOTATIONS_LEVEL_2_ENABLED:
    "privacy.annotate_channels.strict_list.enabled",
  enabledGlobally: false,
  enabledInPrivateWindows: false,

  get categoryItem() {
    delete this.categoryItem;
    return (this.categoryItem = document.getElementById(
      "protections-popup-category-tracking-protection"
    ));
  },

  get subView() {
    delete this.subView;
    return (this.subView = document.getElementById(
      "protections-popup-trackersView"
    ));
  },

  get subViewList() {
    delete this.subViewList;
    return (this.subViewList = document.getElementById(
      "protections-popup-trackersView-list"
    ));
  },

  strings: {
    get subViewBlocked() {
      delete this.subViewBlocked;
      return (this.subViewBlocked = gNavigatorBundle.getString(
        "contentBlocking.trackersView.blocked.label"
      ));
    },

    get subViewTitleBlocking() {
      delete this.subViewTitleBlocking;
      return (this.subViewTitleBlocking = gNavigatorBundle.getString(
        "protections.blocking.trackingContent.title"
      ));
    },

    get subViewTitleNotBlocking() {
      delete this.subViewTitleNotBlocking;
      return (this.subViewTitleNotBlocking = gNavigatorBundle.getString(
        "protections.notBlocking.trackingContent.title"
      ));
    },
  },

  init() {
    this.updateEnabled();

    Services.prefs.addObserver(this.PREF_ENABLED_GLOBALLY, this);
    Services.prefs.addObserver(this.PREF_ENABLED_IN_PRIVATE_WINDOWS, this);

    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "trackingTable",
      this.PREF_TRACKING_TABLE,
      false
    );
    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "trackingAnnotationTable",
      this.PREF_TRACKING_ANNOTATION_TABLE,
      false
    );
    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "annotationsLevel2Enabled",
      this.PREF_ANNOTATIONS_LEVEL_2_ENABLED,
      false
    );
  },

  uninit() {
    Services.prefs.removeObserver(this.PREF_ENABLED_GLOBALLY, this);
    Services.prefs.removeObserver(this.PREF_ENABLED_IN_PRIVATE_WINDOWS, this);
  },

  observe() {
    this.updateEnabled();
  },

  get trackingProtectionLevel2Enabled() {
    const CONTENT_TABLE = "content-track-digest256";
    return this.trackingTable.includes(CONTENT_TABLE);
  },

  get enabled() {
    return (
      this.enabledGlobally ||
      (this.enabledInPrivateWindows &&
        PrivateBrowsingUtils.isWindowPrivate(window))
    );
  },

  updateEnabled() {
    this.enabledGlobally = Services.prefs.getBoolPref(
      this.PREF_ENABLED_GLOBALLY
    );
    this.enabledInPrivateWindows = Services.prefs.getBoolPref(
      this.PREF_ENABLED_IN_PRIVATE_WINDOWS
    );
    this.categoryItem.classList.toggle("blocked", this.enabled);
  },

  isBlocking(state) {
    return (
      (state & Ci.nsIWebProgressListener.STATE_BLOCKED_TRACKING_CONTENT) != 0
    );
  },

  isAllowingLevel1(state) {
    return (
      (state &
        Ci.nsIWebProgressListener.STATE_LOADED_LEVEL_1_TRACKING_CONTENT) !=
      0
    );
  },

  isAllowingLevel2(state) {
    return (
      (state &
        Ci.nsIWebProgressListener.STATE_LOADED_LEVEL_2_TRACKING_CONTENT) !=
      0
    );
  },

  isAllowing(state) {
    return this.isAllowingLevel1(state) || this.isAllowingLevel2(state);
  },

  isDetected(state) {
    return this.isBlocking(state) || this.isAllowing(state);
  },

  async updateSubView() {
    let previousURI = gBrowser.currentURI.spec;
    let previousWindow = gBrowser.selectedBrowser.innerWindowID;

    let contentBlockingLog = gBrowser.selectedBrowser.getContentBlockingLog();
    contentBlockingLog = JSON.parse(contentBlockingLog);

    let fragment = document.createDocumentFragment();
    for (let [origin, actions] of Object.entries(contentBlockingLog)) {
      let listItem = await this._createListItem(origin, actions);
      if (listItem) {
        fragment.appendChild(listItem);
      }
    }

    // If we don't have trackers we would usually not show the menu item
    // allowing the user to show the sub-panel. However, in the edge case
    // that we annotated trackers on the page using the strict list but did
    // not detect trackers on the page using the basic list, we currently
    // still show the panel. To reduce the confusion, tell the user that we have
    // not detected any tracker.
    if (!fragment.childNodes.length) {
      let emptyBox = document.createXULElement("vbox");
      let emptyImage = document.createXULElement("image");
      emptyImage.classList.add("protections-popup-trackersView-empty-image");
      emptyImage.classList.add("tracking-protection-icon");

      let emptyLabel = document.createXULElement("label");
      emptyLabel.classList.add("protections-popup-empty-label");
      emptyLabel.textContent = gNavigatorBundle.getString(
        "contentBlocking.trackersView.empty.label"
      );

      emptyBox.appendChild(emptyImage);
      emptyBox.appendChild(emptyLabel);
      fragment.appendChild(emptyBox);

      this.subViewList.classList.add("empty");
    } else {
      this.subViewList.classList.remove("empty");
    }

    // This might have taken a while. Only update the list if we're still on the same page.
    if (
      previousURI == gBrowser.currentURI.spec &&
      previousWindow == gBrowser.selectedBrowser.innerWindowID
    ) {
      this.subViewList.textContent = "";
      this.subViewList.append(fragment);
      this.subView.setAttribute(
        "title",
        this.enabled && !gProtectionsHandler.hasException
          ? this.strings.subViewTitleBlocking
          : this.strings.subViewTitleNotBlocking
      );
    }
  },

  async _createListItem(origin, actions) {
    // Figure out if this list entry was actually detected by TP or something else.
    let isAllowed = actions.some(([state]) => this.isAllowing(state));
    let isDetected =
      isAllowed || actions.some(([state]) => this.isBlocking(state));

    if (!isDetected) {
      return null;
    }

    // Because we might use different lists for annotation vs. blocking, we
    // need to make sure that this is a tracker that we would actually have blocked
    // before showing it to the user.
    if (
      this.annotationsLevel2Enabled &&
      !this.trackingProtectionLevel2Enabled &&
      actions.some(
        ([state]) =>
          (state &
            Ci.nsIWebProgressListener.STATE_LOADED_LEVEL_2_TRACKING_CONTENT) !=
          0
      )
    ) {
      return null;
    }

    let listItem = document.createXULElement("hbox");
    listItem.className = "protections-popup-list-item";
    listItem.classList.toggle("allowed", isAllowed);
    // Repeat the host in the tooltip in case it's too long
    // and overflows in our panel.
    listItem.tooltipText = origin;

    let label = document.createXULElement("label");
    label.value = origin;
    label.className = "protections-popup-list-host-label";
    label.setAttribute("crop", "end");
    listItem.append(label);

    return listItem;
  },
};

var ThirdPartyCookies = {
  PREF_ENABLED: "network.cookie.cookieBehavior",
  PREF_ENABLED_VALUES: [
    // These values match the ones exposed under the Content Blocking section
    // of the Preferences UI.
    Ci.nsICookieService.BEHAVIOR_REJECT_FOREIGN, // Block all third-party cookies
    Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER, // Block third-party cookies from trackers
    Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN, // Block trackers and patition third-party trackers
    Ci.nsICookieService.BEHAVIOR_REJECT, // Block all cookies
  ],

  get categoryItem() {
    delete this.categoryItem;
    return (this.categoryItem = document.getElementById(
      "protections-popup-category-cookies"
    ));
  },

  get subView() {
    delete this.subView;
    return (this.subView = document.getElementById(
      "protections-popup-cookiesView"
    ));
  },

  get subViewHeading() {
    delete this.subViewHeading;
    return (this.subViewHeading = document.getElementById(
      "protections-popup-cookiesView-heading"
    ));
  },

  get subViewList() {
    delete this.subViewList;
    return (this.subViewList = document.getElementById(
      "protections-popup-cookiesView-list"
    ));
  },

  strings: {
    get subViewAllowed() {
      delete this.subViewAllowed;
      return (this.subViewAllowed = gNavigatorBundle.getString(
        "contentBlocking.cookiesView.allowed.label"
      ));
    },

    get subViewBlocked() {
      delete this.subViewAllowed;
      return (this.subViewAllowed = gNavigatorBundle.getString(
        "contentBlocking.cookiesView.blocked.label"
      ));
    },

    get subViewTitleNotBlocking() {
      delete this.subViewTitleNotBlocking;
      return (this.subViewTitleNotBlocking = gNavigatorBundle.getString(
        "protections.notBlocking.crossSiteTrackingCookies.title"
      ));
    },
  },

  get reportBreakageLabel() {
    switch (this.behaviorPref) {
      case Ci.nsICookieService.BEHAVIOR_ACCEPT:
        return "nocookiesblocked";
      case Ci.nsICookieService.BEHAVIOR_REJECT_FOREIGN:
        return "allthirdpartycookiesblocked";
      case Ci.nsICookieService.BEHAVIOR_REJECT:
        return "allcookiesblocked";
      case Ci.nsICookieService.BEHAVIOR_LIMIT_FOREIGN:
        return "cookiesfromunvisitedsitesblocked";
      default:
        Cu.reportError(
          `Error: Unknown cookieBehavior pref observed: ${this.behaviorPref}`
        );
      // fall through
      case Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER:
        return "cookierestrictions";
      case Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN:
        return "cookierestrictionsforeignpartitioned";
    }
  },

  init() {
    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "behaviorPref",
      this.PREF_ENABLED,
      Ci.nsICookieService.BEHAVIOR_ACCEPT,
      this.updateCategoryItem.bind(this)
    );
    this.updateCategoryItem();
  },

  get categoryLabel() {
    delete this.categoryLabel;
    return (this.categoryLabel = document.getElementById(
      "protections-popup-cookies-category-label"
    ));
  },

  updateCategoryItem() {
    this.categoryItem.classList.toggle("blocked", this.enabled);

    let label;

    if (!this.enabled) {
      label = "contentBlocking.cookies.blockingTrackers3.label";
    } else {
      switch (this.behaviorPref) {
        case Ci.nsICookieService.BEHAVIOR_REJECT_FOREIGN:
          label = "contentBlocking.cookies.blocking3rdParty2.label";
          break;
        case Ci.nsICookieService.BEHAVIOR_REJECT:
          label = "contentBlocking.cookies.blockingAll2.label";
          break;
        case Ci.nsICookieService.BEHAVIOR_LIMIT_FOREIGN:
          label = "contentBlocking.cookies.blockingUnvisited2.label";
          break;
        case Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER:
        case Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN:
          label = "contentBlocking.cookies.blockingTrackers3.label";
          break;
        default:
          Cu.reportError(
            `Error: Unknown cookieBehavior pref observed: ${this.behaviorPref}`
          );
          break;
      }
    }
    this.categoryLabel.textContent = label
      ? gNavigatorBundle.getString(label)
      : "";
  },

  get enabled() {
    return this.PREF_ENABLED_VALUES.includes(this.behaviorPref);
  },

  isBlocking(state) {
    return (
      (state & Ci.nsIWebProgressListener.STATE_COOKIES_BLOCKED_TRACKER) != 0 ||
      (state & Ci.nsIWebProgressListener.STATE_COOKIES_BLOCKED_SOCIALTRACKER) !=
        0 ||
      (state & Ci.nsIWebProgressListener.STATE_COOKIES_BLOCKED_ALL) != 0 ||
      (state & Ci.nsIWebProgressListener.STATE_COOKIES_BLOCKED_BY_PERMISSION) !=
        0 ||
      (state & Ci.nsIWebProgressListener.STATE_COOKIES_BLOCKED_FOREIGN) != 0
    );
  },

  isDetected(state) {
    if (this.isBlocking(state)) {
      return true;
    }

    if (
      [
        Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN,
        Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER,
        Ci.nsICookieService.BEHAVIOR_ACCEPT,
      ].includes(this.behaviorPref)
    ) {
      return (
        (state & Ci.nsIWebProgressListener.STATE_COOKIES_LOADED_TRACKER) != 0 ||
        (SocialTracking.enabled &&
          (state &
            Ci.nsIWebProgressListener.STATE_COOKIES_LOADED_SOCIALTRACKER) !=
            0)
      );
    }

    // We don't have specific flags for the other cookie behaviors so just
    // fall back to STATE_COOKIES_LOADED.
    return (state & Ci.nsIWebProgressListener.STATE_COOKIES_LOADED) != 0;
  },

  updateSubView() {
    let contentBlockingLog = gBrowser.selectedBrowser.getContentBlockingLog();
    contentBlockingLog = JSON.parse(contentBlockingLog);

    let categories = this._processContentBlockingLog(contentBlockingLog);

    this.subViewList.textContent = "";

    let categoryNames = ["trackers"];
    switch (this.behaviorPref) {
      case Ci.nsICookieService.BEHAVIOR_REJECT:
        categoryNames.push("firstParty");
      // eslint-disable-next-line no-fallthrough
      case Ci.nsICookieService.BEHAVIOR_REJECT_FOREIGN:
        categoryNames.push("thirdParty");
    }

    for (let category of categoryNames) {
      let itemsToShow = categories[category];

      if (!itemsToShow.length) {
        continue;
      }

      let box = document.createXULElement("vbox");
      box.className = "protections-popup-cookiesView-list-section";
      let label = document.createXULElement("label");
      label.className = "protections-popup-cookiesView-list-header";
      label.textContent = gNavigatorBundle.getString(
        `contentBlocking.cookiesView.${
          category == "trackers" ? "trackers2" : category
        }.label`
      );
      box.appendChild(label);

      for (let info of itemsToShow) {
        box.appendChild(this._createListItem(info));
      }

      this.subViewList.appendChild(box);
    }

    this.subViewHeading.hidden = false;
    if (!this.enabled) {
      this.subView.setAttribute("title", this.strings.subViewTitleNotBlocking);
      return;
    }

    let title;
    let siteException = gProtectionsHandler.hasException;
    let titleStringPrefix = `protections.${
      siteException ? "notBlocking" : "blocking"
    }.cookies.`;
    switch (this.behaviorPref) {
      case Ci.nsICookieService.BEHAVIOR_REJECT_FOREIGN:
        title = titleStringPrefix + "3rdParty.title";
        this.subViewHeading.hidden = true;
        break;
      case Ci.nsICookieService.BEHAVIOR_REJECT:
        title = titleStringPrefix + "all.title";
        this.subViewHeading.hidden = true;
        break;
      case Ci.nsICookieService.BEHAVIOR_LIMIT_FOREIGN:
        title = "protections.blocking.cookies.unvisited.title";
        this.subViewHeading.hidden = true;
        break;
      case Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER:
      case Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN:
        title = siteException
          ? "protections.notBlocking.crossSiteTrackingCookies.title"
          : "protections.blocking.cookies.trackers.title";
        break;
      default:
        Cu.reportError(
          `Error: Unknown cookieBehavior pref when updating subview: ${this.behaviorPref}`
        );
        break;
    }

    this.subView.setAttribute("title", gNavigatorBundle.getString(title));
  },

  _getExceptionState(origin) {
    for (let perm of Services.perms.getAllForPrincipal(
      gBrowser.contentPrincipal
    )) {
      if (perm.type == "3rdPartyStorage^" + origin) {
        return perm.capability;
      }
    }

    let principal = Services.scriptSecurityManager.createContentPrincipalFromOrigin(
      origin
    );
    // Cookie exceptions get "inherited" from parent- to sub-domain, so we need to
    // make sure to include parent domains in the permission check for "cookie".
    return Services.perms.testPermissionFromPrincipal(principal, "cookie");
  },

  _clearException(origin) {
    for (let perm of Services.perms.getAllForPrincipal(
      gBrowser.contentPrincipal
    )) {
      if (perm.type == "3rdPartyStorage^" + origin) {
        Services.perms.removePermission(perm);
      }
    }

    // OAs don't matter here, so we can just use the hostname.
    let host = Services.io.newURI(origin).host;

    // Cookie exceptions get "inherited" from parent- to sub-domain, so we need to
    // clear any cookie permissions from parent domains as well.
    for (let perm of Services.perms.all) {
      if (
        perm.type == "cookie" &&
        Services.eTLD.hasRootDomain(host, perm.principal.URI.host)
      ) {
        Services.perms.removePermission(perm);
      }
    }
  },

  // Transforms and filters cookie entries in the content blocking log
  // so that we can categorize and display them in the UI.
  _processContentBlockingLog(log) {
    let newLog = {
      firstParty: [],
      trackers: [],
      thirdParty: [],
    };

    let firstPartyDomain = null;
    try {
      firstPartyDomain = Services.eTLD.getBaseDomain(gBrowser.currentURI);
    } catch (e) {
      // There are nasty edge cases here where someone is trying to set a cookie
      // on a public suffix or an IP address. Just categorize those as third party...
      if (
        e.result != Cr.NS_ERROR_HOST_IS_IP_ADDRESS &&
        e.result != Cr.NS_ERROR_INSUFFICIENT_DOMAIN_LEVELS
      ) {
        throw e;
      }
    }

    for (let [origin, actions] of Object.entries(log)) {
      if (!origin.startsWith("http")) {
        continue;
      }

      let info = {
        origin,
        isAllowed: true,
        exceptionState: this._getExceptionState(origin),
      };
      let hasCookie = false;
      let isTracker = false;

      // Extract information from the states entries in the content blocking log.
      // Each state will contain a single state flag from nsIWebProgressListener.
      // Note that we are using the same helper functions that are applied to the
      // bit map passed to onSecurityChange (which contains multiple states), thus
      // not checking exact equality, just presence of bits.
      for (let [state, blocked] of actions) {
        if (this.isDetected(state)) {
          hasCookie = true;
        }
        if (TrackingProtection.isAllowing(state)) {
          isTracker = true;
        }
        // blocked tells us whether the resource was actually blocked
        // (which it may not be in case of an exception).
        if (this.isBlocking(state)) {
          info.isAllowed = !blocked;
        }
      }

      if (!hasCookie) {
        continue;
      }

      let isFirstParty = false;
      try {
        let uri = Services.io.newURI(origin);
        isFirstParty = Services.eTLD.getBaseDomain(uri) == firstPartyDomain;
      } catch (e) {
        if (
          e.result != Cr.NS_ERROR_HOST_IS_IP_ADDRESS &&
          e.result != Cr.NS_ERROR_INSUFFICIENT_DOMAIN_LEVELS
        ) {
          throw e;
        }
      }

      if (isFirstParty) {
        newLog.firstParty.push(info);
      } else if (isTracker) {
        newLog.trackers.push(info);
      } else {
        newLog.thirdParty.push(info);
      }
    }

    return newLog;
  },

  _createListItem({ origin, isAllowed, exceptionState }) {
    let listItem = document.createXULElement("hbox");
    listItem.className = "protections-popup-list-item";
    // Repeat the origin in the tooltip in case it's too long
    // and overflows in our panel.
    listItem.tooltipText = origin;

    let label = document.createXULElement("label");
    label.value = origin;
    label.className = "protections-popup-list-host-label";
    label.setAttribute("crop", "end");
    listItem.append(label);

    if (
      (isAllowed && exceptionState == Services.perms.ALLOW_ACTION) ||
      (!isAllowed && exceptionState == Services.perms.DENY_ACTION)
    ) {
      let stateLabel;
      if (isAllowed) {
        stateLabel = document.createXULElement("label");
        stateLabel.value = this.strings.subViewAllowed;
        stateLabel.className = "protections-popup-list-state-label";
        listItem.append(stateLabel);
        listItem.classList.toggle("allowed", true);
      } else {
        stateLabel = document.createXULElement("label");
        stateLabel.value = this.strings.subViewBlocked;
        stateLabel.className = "protections-popup-list-state-label";
        listItem.append(stateLabel);
      }

      let removeException = document.createXULElement("button");
      removeException.className = "identity-popup-permission-remove-button";
      removeException.tooltipText = gNavigatorBundle.getFormattedString(
        "contentBlocking.cookiesView.removeButton.tooltip",
        [origin]
      );
      removeException.addEventListener(
        "click",
        () => {
          this._clearException(origin);
          stateLabel.remove();
          removeException.remove();
          listItem.classList.toggle("allowed", !isAllowed);
        },
        { once: true }
      );
      listItem.append(removeException);
    }

    return listItem;
  },
};

var SocialTracking = {
  PREF_STP_TP_ENABLED: "privacy.trackingprotection.socialtracking.enabled",
  PREF_STP_COOKIE_ENABLED: "privacy.socialtracking.block_cookies.enabled",
  PREF_COOKIE_BEHAVIOR: "network.cookie.cookieBehavior",
  reportBreakageLabel: "socialtracking",

  strings: {
    get subViewBlocked() {
      delete this.subViewBlocked;
      return (this.subViewBlocked = gNavigatorBundle.getString(
        "contentBlocking.fingerprintersView.blocked.label"
      ));
    },

    get subViewTitleBlocking() {
      delete this.subViewTitleBlocking;
      return (this.subViewTitleBlocking = gNavigatorBundle.getString(
        "protections.blocking.socialMediaTrackers.title"
      ));
    },

    get subViewTitleNotBlocking() {
      delete this.subViewTitleNotBlocking;
      return (this.subViewTitleNotBlocking = gNavigatorBundle.getString(
        "protections.notBlocking.socialMediaTrackers.title"
      ));
    },
  },

  init() {
    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "socialTrackingProtectionEnabled",
      this.PREF_STP_TP_ENABLED,
      false,
      this.updateCategoryItem.bind(this)
    );
    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "rejectTrackingCookies",
      this.PREF_COOKIE_BEHAVIOR,
      false,
      this.updateCategoryItem.bind(this),
      val =>
        [
          Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER,
          Ci.nsICookieService.BEHAVIOR_REJECT_TRACKER_AND_PARTITION_FOREIGN,
        ].includes(val)
    );
    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "enabled",
      this.PREF_STP_COOKIE_ENABLED,
      false,
      this.updateCategoryItem.bind(this)
    );
    this.updateCategoryItem();
  },

  get blockingEnabled() {
    return (
      (this.socialTrackingProtectionEnabled || this.rejectTrackingCookies) &&
      this.enabled
    );
  },

  updateCategoryItem() {
    if (this.enabled) {
      this.categoryItem.removeAttribute("uidisabled");
    } else {
      this.categoryItem.setAttribute("uidisabled", true);
    }
    this.categoryItem.classList.toggle("blocked", this.blockingEnabled);
  },

  isBlocking(state) {
    let socialtrackingContentBlocked =
      (state &
        Ci.nsIWebProgressListener.STATE_BLOCKED_SOCIALTRACKING_CONTENT) !=
      0;
    let socialtrackingCookieBlocked =
      (state & Ci.nsIWebProgressListener.STATE_COOKIES_BLOCKED_SOCIALTRACKER) !=
      0;
    return socialtrackingCookieBlocked || socialtrackingContentBlocked;
  },

  isAllowing(state) {
    if (this.socialTrackingProtectionEnabled) {
      return (
        (state &
          Ci.nsIWebProgressListener.STATE_LOADED_SOCIALTRACKING_CONTENT) !=
        0
      );
    }

    return (
      (state & Ci.nsIWebProgressListener.STATE_COOKIES_LOADED_SOCIALTRACKER) !=
      0
    );
  },

  isDetected(state) {
    return this.isBlocking(state) || this.isAllowing(state);
  },

  get categoryItem() {
    delete this.categoryItem;
    return (this.categoryItem = document.getElementById(
      "protections-popup-category-socialblock"
    ));
  },

  get subView() {
    delete this.subView;
    return (this.subView = document.getElementById(
      "protections-popup-socialblockView"
    ));
  },

  get subViewList() {
    delete this.subViewList;
    return (this.subViewList = document.getElementById(
      "protections-popup-socialblockView-list"
    ));
  },

  updateSubView() {
    let contentBlockingLog = gBrowser.selectedBrowser.getContentBlockingLog();
    contentBlockingLog = JSON.parse(contentBlockingLog);

    let fragment = document.createDocumentFragment();
    for (let [origin, actions] of Object.entries(contentBlockingLog)) {
      let listItem = this._createListItem(origin, actions);
      if (listItem) {
        fragment.appendChild(listItem);
      }
    }

    this.subViewList.textContent = "";
    this.subViewList.append(fragment);
    this.subView.setAttribute(
      "title",
      this.blockingEnabled && !gProtectionsHandler.hasException
        ? this.strings.subViewTitleBlocking
        : this.strings.subViewTitleNotBlocking
    );
  },

  _createListItem(origin, actions) {
    let isAllowed = actions.some(([state]) => this.isAllowing(state));
    let isDetected =
      isAllowed || actions.some(([state]) => this.isBlocking(state));

    if (!isDetected) {
      return null;
    }

    let listItem = document.createXULElement("hbox");
    listItem.className = "protections-popup-list-item";
    listItem.classList.toggle("allowed", isAllowed);
    // Repeat the host in the tooltip in case it's too long
    // and overflows in our panel.
    listItem.tooltipText = origin;

    let label = document.createXULElement("label");
    label.value = origin;
    label.className = "protections-popup-list-host-label";
    label.setAttribute("crop", "end");
    listItem.append(label);

    return listItem;
  },
};

/**
 * Utility object to handle manipulations of the protections indicators in the UI
 */
var gProtectionsHandler = {
  PREF_REPORT_BREAKAGE_URL: "browser.contentblocking.reportBreakage.url",
  PREF_CB_CATEGORY: "browser.contentblocking.category",

  // smart getters
  get _protectionsPopup() {
    delete this._protectionsPopup;
    return (this._protectionsPopup = document.getElementById(
      "protections-popup"
    ));
  },
  get iconBox() {
    delete this.iconBox;
    return (this.iconBox = document.getElementById(
      "tracking-protection-icon-box"
    ));
  },
  get animatedIcon() {
    delete this.animatedIcon;
    return (this.animatedIcon = document.getElementById(
      "tracking-protection-icon-animatable-image"
    ));
  },
  get _protectionsIconBox() {
    delete this._protectionsIconBox;
    return (this._protectionsIconBox = document.getElementById(
      "tracking-protection-icon-animatable-box"
    ));
  },
  get _protectionsPopupMultiView() {
    delete this._protectionsPopupMultiView;
    return (this._protectionsPopupMultiView = document.getElementById(
      "protections-popup-multiView"
    ));
  },
  get _protectionsPopupMainView() {
    delete this._protectionsPopupMainView;
    return (this._protectionsPopupMainView = document.getElementById(
      "protections-popup-mainView"
    ));
  },
  get _protectionsPopupMainViewHeaderLabel() {
    delete this._protectionsPopupMainViewHeaderLabel;
    return (this._protectionsPopupMainViewHeaderLabel = document.getElementById(
      "protections-popup-mainView-panel-header-span"
    ));
  },
  get _protectionsPopupTPSwitchBreakageLink() {
    delete this._protectionsPopupTPSwitchBreakageLink;
    return (this._protectionsPopupTPSwitchBreakageLink = document.getElementById(
      "protections-popup-tp-switch-breakage-link"
    ));
  },
  get _protectionsPopupTPSwitchBreakageFixedLink() {
    delete this._protectionsPopupTPSwitchBreakageFixedLink;
    return (this._protectionsPopupTPSwitchBreakageFixedLink = document.getElementById(
      "protections-popup-tp-switch-breakage-fixed-link"
    ));
  },
  get _protectionsPopupTPSwitchSection() {
    delete this._protectionsPopupTPSwitchSection;
    return (this._protectionsPopupTPSwitchSection = document.getElementById(
      "protections-popup-tp-switch-section"
    ));
  },
  get _protectionsPopupTPSwitch() {
    delete this._protectionsPopupTPSwitch;
    return (this._protectionsPopupTPSwitch = document.getElementById(
      "protections-popup-tp-switch"
    ));
  },
  get _protectionsPopupBlockingHeader() {
    delete this._protectionsPopupBlockingHeader;
    return (this._protectionsPopupBlockingHeader = document.getElementById(
      "protections-popup-blocking-section-header"
    ));
  },
  get _protectionsPopupNotBlockingHeader() {
    delete this._protectionsPopupNotBlockingHeader;
    return (this._protectionsPopupNotBlockingHeader = document.getElementById(
      "protections-popup-not-blocking-section-header"
    ));
  },
  get _protectionsPopupNotFoundHeader() {
    delete this._protectionsPopupNotFoundHeader;
    return (this._protectionsPopupNotFoundHeader = document.getElementById(
      "protections-popup-not-found-section-header"
    ));
  },
  get _protectionsPopupSettingsButton() {
    delete this._protectionsPopupSettingsButton;
    return (this._protectionsPopupSettingsButton = document.getElementById(
      "protections-popup-settings-button"
    ));
  },
  get _protectionsPopupFooter() {
    delete this._protectionsPopupFooter;
    return (this._protectionsPopupFooter = document.getElementById(
      "protections-popup-footer"
    ));
  },
  get _protectionsPopupTrackersCounterBox() {
    delete this._protectionsPopupTrackersCounterBox;
    return (this._protectionsPopupTrackersCounterBox = document.getElementById(
      "protections-popup-trackers-blocked-counter-box"
    ));
  },
  get _protectionsPopupTrackersCounterDescription() {
    delete this._protectionsPopupTrackersCounterDescription;
    return (this._protectionsPopupTrackersCounterDescription = document.getElementById(
      "protections-popup-trackers-blocked-counter-description"
    ));
  },
  get _protectionsPopupFooterProtectionTypeLabel() {
    delete this._protectionsPopupFooterProtectionTypeLabel;
    return (this._protectionsPopupFooterProtectionTypeLabel = document.getElementById(
      "protections-popup-footer-protection-type-label"
    ));
  },
  get _protectionsPopupSiteNotWorkingTPSwitch() {
    delete this._protectionsPopupSiteNotWorkingTPSwitch;
    return (this._protectionsPopupSiteNotWorkingTPSwitch = document.getElementById(
      "protections-popup-siteNotWorking-tp-switch"
    ));
  },
  get _protectionsPopupSiteNotWorkingReportError() {
    delete this._protectionsPopupSiteNotWorkingReportError;
    return (this._protectionsPopupSiteNotWorkingReportError = document.getElementById(
      "protections-popup-sendReportView-report-error"
    ));
  },
  get _protectionsPopupSendReportURL() {
    delete this._protectionsPopupSendReportURL;
    return (this._protectionsPopupSendReportURL = document.getElementById(
      "protections-popup-sendReportView-collection-url"
    ));
  },
  get _protectionsPopupSendReportButton() {
    delete this._protectionsPopupSendReportButton;
    return (this._protectionsPopupSendReportButton = document.getElementById(
      "protections-popup-sendReportView-submit"
    ));
  },
  get _trackingProtectionIconTooltipLabel() {
    delete this._trackingProtectionIconTooltipLabel;
    return (this._trackingProtectionIconTooltipLabel = document.getElementById(
      "tracking-protection-icon-tooltip-label"
    ));
  },
  get _trackingProtectionIconContainer() {
    delete this._trackingProtectionIconContainer;
    return (this._trackingProtectionIconContainer = document.getElementById(
      "tracking-protection-icon-container"
    ));
  },

  get noTrackersDetectedDescription() {
    delete this.noTrackersDetectedDescription;
    return (this.noTrackersDetectedDescription = document.getElementById(
      "protections-popup-no-trackers-found-description"
    ));
  },

  get _protectionsPopupMilestonesText() {
    delete this._protectionsPopupMilestonesText;
    return (this._protectionsPopupMilestonesText = document.getElementById(
      "protections-popup-milestones-text"
    ));
  },

  get _notBlockingWhyLink() {
    delete this._notBlockingWhyLink;
    return (this._notBlockingWhyLink = document.getElementById(
      "protections-popup-not-blocking-section-why"
    ));
  },

  get hasException() {
    return this._protectionsPopup.hasAttribute("hasException");
  },

  strings: {
    get activeTooltipText() {
      delete this.activeTooltipText;
      return (this.activeTooltipText = gNavigatorBundle.getString(
        "trackingProtection.icon.activeTooltip2"
      ));
    },

    get disabledTooltipText() {
      delete this.disabledTooltipText;
      return (this.disabledTooltipText = gNavigatorBundle.getString(
        "trackingProtection.icon.disabledTooltip2"
      ));
    },

    get noTrackerTooltipText() {
      delete this.noTrackerTooltipText;
      return (this.noTrackerTooltipText = gNavigatorBundle.getFormattedString(
        "trackingProtection.icon.noTrackersDetectedTooltip",
        [gBrandBundle.GetStringFromName("brandShortName")]
      ));
    },
  },

  // A list of blockers that will be displayed in the categories list
  // when blockable content is detected. A blocker must be an object
  // with at least the following two properties:
  //  - enabled: Whether the blocker is currently turned on.
  //  - isDetected(state): Given a content blocking state, whether the blocker has
  //                       either allowed or blocked elements.
  //  - categoryItem: The DOM item that represents the entry in the category list.
  //
  // It may also contain an init() and uninit() function, which will be called
  // on gProtectionsHandler.init() and gProtectionsHandler.uninit().
  // The buttons in the protections panel will appear in the same order as this array.
  blockers: [
    SocialTracking,
    ThirdPartyCookies,
    TrackingProtection,
    Fingerprinting,
    Cryptomining,
  ],

  init() {
    this.animatedIcon.addEventListener("animationend", () =>
      this.iconBox.removeAttribute("animate")
    );

    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "_protectionsPopupToastTimeout",
      "browser.protections_panel.toast.timeout",
      3000
    );

    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "milestoneListPref",
      "browser.contentblocking.cfr-milestone.milestones",
      [],
      () => this.maybeSetMilestoneCounterText(),
      val => JSON.parse(val)
    );

    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "milestonePref",
      "browser.contentblocking.cfr-milestone.milestone-achieved",
      0,
      () => this.maybeSetMilestoneCounterText()
    );

    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "milestoneTimestampPref",
      "browser.contentblocking.cfr-milestone.milestone-shown-time",
      0,
      null,
      val => parseInt(val)
    );

    XPCOMUtils.defineLazyPreferenceGetter(
      this,
      "milestonesEnabledPref",
      "browser.contentblocking.cfr-milestone.enabled",
      false,
      () => this.maybeSetMilestoneCounterText()
    );

    this.maybeSetMilestoneCounterText();

    for (let blocker of this.blockers) {
      if (blocker.init) {
        blocker.init();
      }
    }

    let baseURL = Services.urlFormatter.formatURLPref("app.support.baseURL");
    document.getElementById(
      "protections-popup-sendReportView-learn-more"
    ).href = baseURL + "blocking-breakage";

    // Add an observer to observe that the history has been cleared.
    Services.obs.addObserver(this, "browser:purge-session-history");
  },

  uninit() {
    for (let blocker of this.blockers) {
      if (blocker.uninit) {
        blocker.uninit();
      }
    }

    Services.obs.removeObserver(this, "browser:purge-session-history");
  },

  getTrackingProtectionLabel() {
    const value = Services.prefs.getStringPref(this.PREF_CB_CATEGORY);

    switch (value) {
      case "strict":
        return "protections-popup-footer-protection-label-strict";
      case "custom":
        return "protections-popup-footer-protection-label-custom";
      case "standard":
      /* fall through */
      default:
        return "protections-popup-footer-protection-label-standard";
    }
  },

  openPreferences(origin) {
    openPreferences("privacy-trackingprotection", { origin });
  },

  openProtections(relatedToCurrent = false) {
    switchToTabHavingURI("about:protections", true, {
      replaceQueryString: true,
      relatedToCurrent,
      triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal(),
    });

    // Don't show the milestones section anymore.
    Services.prefs.clearUserPref(
      "browser.contentblocking.cfr-milestone.milestone-shown-time"
    );
  },

  async showTrackersSubview(event) {
    await TrackingProtection.updateSubView();
    this._protectionsPopupMultiView.showSubView(
      "protections-popup-trackersView"
    );
  },

  async showSocialblockerSubview(event) {
    await SocialTracking.updateSubView();
    this._protectionsPopupMultiView.showSubView(
      "protections-popup-socialblockView"
    );
  },

  async showCookiesSubview(event) {
    await ThirdPartyCookies.updateSubView();
    this._protectionsPopupMultiView.showSubView(
      "protections-popup-cookiesView"
    );
  },

  async showFingerprintersSubview(event) {
    await Fingerprinting.updateSubView();
    this._protectionsPopupMultiView.showSubView(
      "protections-popup-fingerprintersView"
    );
  },

  async showCryptominersSubview(event) {
    await Cryptomining.updateSubView();
    this._protectionsPopupMultiView.showSubView(
      "protections-popup-cryptominersView"
    );
  },

  recordClick(object, value = null, source = "protectionspopup") {
    Services.telemetry.recordEvent(
      `security.ui.${source}`,
      "click",
      object,
      value
    );
  },

  shieldHistogramAdd(value) {
    if (PrivateBrowsingUtils.isWindowPrivate(window)) {
      return;
    }
    Services.telemetry
      .getHistogramById("TRACKING_PROTECTION_SHIELD")
      .add(value);
  },

  cryptominersHistogramAdd(value) {
    Services.telemetry
      .getHistogramById("CRYPTOMINERS_BLOCKED_COUNT")
      .add(value);
  },

  fingerprintersHistogramAdd(value) {
    Services.telemetry
      .getHistogramById("FINGERPRINTERS_BLOCKED_COUNT")
      .add(value);
  },

  handleProtectionsButtonEvent(event) {
    event.stopPropagation();
    if (
      (event.type == "click" && event.button != 0) ||
      (event.type == "keypress" &&
        event.charCode != KeyEvent.DOM_VK_SPACE &&
        event.keyCode != KeyEvent.DOM_VK_RETURN)
    ) {
      return; // Left click, space or enter only
    }

    this.showProtectionsPopup({ event });
  },

  onPopupShown(event) {
    if (event.target == this._protectionsPopup) {
      window.addEventListener("focus", this, true);

      // Add the "open" attribute to the tracking protection icon container
      // for styling.
      this._trackingProtectionIconContainer.setAttribute("open", "true");

      // Insert the info message if needed. This will be shown once and then
      // remain collapsed.
      ToolbarPanelHub.insertProtectionPanelMessage(event);

      if (!event.target.hasAttribute("toast")) {
        Services.telemetry.recordEvent(
          "security.ui.protectionspopup",
          "open",
          "protections_popup"
        );
      }
    }
  },

  onPopupHidden(event) {
    if (event.target == this._protectionsPopup) {
      window.removeEventListener("focus", this, true);
      this._trackingProtectionIconContainer.removeAttribute("open");
    }
  },

  onHeaderClicked(event) {
    // Display the whole protections panel if the toast has been clicked.
    if (this._protectionsPopup.hasAttribute("toast")) {
      // Hide the toast first.
      PanelMultiView.hidePopup(this._protectionsPopup);

      // Open the full protections panel.
      this.showProtectionsPopup({ event });
    }
  },

  async onTrackingProtectionIconHoveredOrFocused() {
    // We would try to pre-fetch the data whenever the shield icon is hovered or
    // focused. We check focus event here due to the keyboard navigation.
    if (this._updatingFooter) {
      return;
    }
    this._updatingFooter = true;

    // Get the tracker count and set it to the counter in the footer.
    const trackerCount = await TrackingDBService.sumAllEvents();
    this.setTrackersBlockedCounter(trackerCount);

    // Set tracking protection label
    const l10nId = this.getTrackingProtectionLabel();
    const elem = this._protectionsPopupFooterProtectionTypeLabel;
    document.l10n.setAttributes(elem, l10nId);

    // Try to get the earliest recorded date in case that there was no record
    // during the initiation but new records come after that.
    await this.maybeUpdateEarliestRecordedDateTooltip();

    this._updatingFooter = false;
  },

  // This triggers from top level location changes.
  onLocationChange() {
    if (this._showToastAfterRefresh) {
      this._showToastAfterRefresh = false;

      // We only display the toast if we're still on the same page.
      if (
        this._previousURI == gBrowser.currentURI.spec &&
        this._previousOuterWindowID == gBrowser.selectedBrowser.outerWindowID
      ) {
        this.showProtectionsPopup({
          toast: true,
        });
      }
    }

    // Reset blocking and exception status so that we can send telemetry
    this.hadShieldState = false;

    // Don't deal with about:, file: etc.
    if (!ContentBlockingAllowList.canHandle(gBrowser.selectedBrowser)) {
      // We hide the icon and thus avoid showing the doorhanger, since
      // the information contained there would mostly be broken and/or
      // irrelevant anyway.
      this._trackingProtectionIconContainer.hidden = true;
      return;
    }
    this._trackingProtectionIconContainer.hidden = false;

    // Check whether the user has added an exception for this site.
    let hasException = ContentBlockingAllowList.includes(
      gBrowser.selectedBrowser
    );

    this._protectionsPopup.toggleAttribute("hasException", hasException);
    this.iconBox.toggleAttribute("hasException", hasException);

    // Add to telemetry per page load as a baseline measurement.
    this.fingerprintersHistogramAdd("pageLoad");
    this.cryptominersHistogramAdd("pageLoad");
    this.shieldHistogramAdd(0);
  },

  notifyContentBlockingEvent(event) {
    // We don't notify observers until the document stops loading, therefore
    // a merged event can be sent, which gives an opportunity to decide the
    // priority by the handler.
    // Content blocking events coming after stopping will not be merged, and are
    // sent directly.
    if (!this._isStoppedState || !this.anyDetected) {
      return;
    }

    let uri = gBrowser.currentURI;
    let uriHost = uri.asciiHost ? uri.host : uri.spec;
    Services.obs.notifyObservers(
      {
        wrappedJSObject: {
          browser: gBrowser.selectedBrowser,
          host: uriHost,
          event,
        },
      },
      "SiteProtection:ContentBlockingEvent"
    );
  },

  onStateChange(aWebProgress, stateFlags) {
    if (!aWebProgress.isTopLevel) {
      return;
    }

    this._isStoppedState = !!(
      stateFlags & Ci.nsIWebProgressListener.STATE_STOP
    );
    this.notifyContentBlockingEvent(
      gBrowser.selectedBrowser.getContentBlockingEvents()
    );
  },

  onContentBlockingEvent(event, webProgress, isSimulated, previousState) {
    // Don't deal with about:, file: etc.
    if (!ContentBlockingAllowList.canHandle(gBrowser.selectedBrowser)) {
      this.iconBox.removeAttribute("animate");
      this.iconBox.removeAttribute("active");
      this.iconBox.removeAttribute("hasException");
      return;
    }

    this.anyDetected = false;
    let anyBlocking = false;
    this.noTrackersDetectedDescription.hidden = false;

    for (let blocker of this.blockers) {
      if (blocker.categoryItem.hasAttribute("uidisabled")) {
        continue;
      }
      // Store data on whether the blocker is activated in the current document for
      // reporting it using the "report breakage" dialog. Under normal circumstances this
      // dialog should only be able to open in the currently selected tab and onSecurityChange
      // runs on tab switch, so we can avoid associating the data with the document directly.
      blocker.activated = blocker.isBlocking(event);
      let detected = blocker.isDetected(event);
      blocker.categoryItem.classList.toggle("notFound", !detected);
      this.anyDetected = this.anyDetected || detected;
      anyBlocking = anyBlocking || blocker.activated;
    }

    // Check whether the user has added an exception for this site.
    let hasException = ContentBlockingAllowList.includes(
      gBrowser.selectedBrowser
    );

    // Reset the animation in case the user is switching tabs or if no blockers were detected
    // (this is most likely happening because the user navigated on to a different site). This
    // allows us to play it from the start without choppiness next time.
    if (isSimulated || !anyBlocking) {
      this.iconBox.removeAttribute("animate");
      // Only play the animation when the shield is not already shown on the page (the visibility
      // of the shield based on this onSecurityChange be determined afterwards).
    } else if (anyBlocking && !this.iconBox.hasAttribute("active")) {
      this.iconBox.setAttribute("animate", "true");
    }

    // We consider the shield state "active" when some kind of blocking activity
    // occurs on the page.  Note that merely allowing the loading of content that
    // we could have blocked does not trigger the appearance of the shield.
    // This state will be overriden later if there's an exception set for this site.
    this._protectionsPopup.toggleAttribute("detected", this.anyDetected);
    this._protectionsPopup.toggleAttribute("blocking", anyBlocking);
    this._protectionsPopup.toggleAttribute("hasException", hasException);

    this._categoryItemOrderInvalidated = true;

    if (this.anyDetected) {
      this.noTrackersDetectedDescription.hidden = true;

      if (["showing", "open"].includes(this._protectionsPopup.state)) {
        this.reorderCategoryItems();

        // Until we encounter a site that triggers them, category elements might
        // be invisible when descriptionHeightWorkaround gets called, i.e. they
        // are omitted from the workaround and the content overflows the panel.
        // Solution: call it manually here.
        PanelMultiView.forNode(
          this._protectionsPopupMainView
        ).descriptionHeightWorkaround();
      }
    }

    this.iconBox.toggleAttribute("active", anyBlocking);
    this.iconBox.toggleAttribute("hasException", hasException);

    if (hasException) {
      this.showDisabledTooltipForTPIcon();
      if (!this.hadShieldState && !isSimulated) {
        this.hadShieldState = true;
        this.shieldHistogramAdd(1);
      }
    } else if (anyBlocking) {
      this.showActiveTooltipForTPIcon();
      if (!this.hadShieldState && !isSimulated) {
        this.hadShieldState = true;
        this.shieldHistogramAdd(2);
      }
    } else {
      this.showNoTrackerTooltipForTPIcon();
    }

    // Don't send a content blocking event to CFR for
    // tab switches since this will already be done via
    // onStateChange.
    if (!isSimulated) {
      this.notifyContentBlockingEvent(event);
    }

    // We report up to one instance of fingerprinting and cryptomining
    // blocking and/or allowing per page load.
    let fingerprintingBlocking =
      Fingerprinting.isBlocking(event) &&
      !Fingerprinting.isBlocking(previousState);
    let fingerprintingAllowing =
      Fingerprinting.isAllowing(event) &&
      !Fingerprinting.isAllowing(previousState);
    let cryptominingBlocking =
      Cryptomining.isBlocking(event) && !Cryptomining.isBlocking(previousState);
    let cryptominingAllowing =
      Cryptomining.isAllowing(event) && !Cryptomining.isAllowing(previousState);

    if (fingerprintingBlocking) {
      this.fingerprintersHistogramAdd("blocked");
    } else if (fingerprintingAllowing) {
      this.fingerprintersHistogramAdd("allowed");
    }

    if (cryptominingBlocking) {
      this.cryptominersHistogramAdd("blocked");
    } else if (cryptominingAllowing) {
      this.cryptominersHistogramAdd("allowed");
    }
  },
  handleEvent(event) {
    let elem = document.activeElement;
    let position = elem.compareDocumentPosition(this._protectionsPopup);

    if (
      !(
        position &
        (Node.DOCUMENT_POSITION_CONTAINS | Node.DOCUMENT_POSITION_CONTAINED_BY)
      ) &&
      !this._protectionsPopup.hasAttribute("noautohide")
    ) {
      // Hide the panel when focusing an element that is
      // neither an ancestor nor descendant unless the panel has
      // @noautohide (e.g. for a tour).
      PanelMultiView.hidePopup(this._protectionsPopup);
    }
  },

  observe(subject, topic, data) {
    switch (topic) {
      case "browser:purge-session-history":
        // We need to update the earliest recorded date if history has been
        // cleared.
        this._hasEarliestRecord = false;
        this.maybeUpdateEarliestRecordedDateTooltip();
        break;
    }
  },

  refreshProtectionsPopup() {
    let host = gIdentityHandler.getHostForDisplay();

    // Push the appropriate strings out to the UI.
    this._protectionsPopupMainViewHeaderLabel.textContent = gNavigatorBundle.getFormattedString(
      "protections.header",
      [host]
    );

    let currentlyEnabled = !this._protectionsPopup.hasAttribute("hasException");

    for (let tpSwitch of [
      this._protectionsPopupTPSwitch,
      this._protectionsPopupSiteNotWorkingTPSwitch,
    ]) {
      tpSwitch.toggleAttribute("enabled", currentlyEnabled);
    }

    this._notBlockingWhyLink.setAttribute(
      "tooltip",
      currentlyEnabled
        ? "protections-popup-not-blocking-why-etp-on-tooltip"
        : "protections-popup-not-blocking-why-etp-off-tooltip"
    );

    // Toggle the breakage link according to the current enable state.
    this.toggleBreakageLink();

    // Display a short TP switch section depending on the enable state. We need
    // to use a separate attribute here since the 'hasException' attribute will
    // be toggled as well as the TP switch, we cannot rely on that to decide the
    // height of TP switch section, or it will change when toggling the switch,
    // which is not desirable for us. So, we need to use a different attribute
    // here.
    this._protectionsPopupTPSwitchSection.toggleAttribute(
      "short",
      !currentlyEnabled
    );

    // Give the button an accessible label for screen readers.
    if (currentlyEnabled) {
      this._protectionsPopupTPSwitch.setAttribute(
        "aria-label",
        gNavigatorBundle.getFormattedString("protections.disableAriaLabel", [
          host,
        ])
      );
    } else {
      this._protectionsPopupTPSwitch.setAttribute(
        "aria-label",
        gNavigatorBundle.getFormattedString("protections.enableAriaLabel", [
          host,
        ])
      );
    }

    // Update the tooltip of the blocked tracker counter.
    this.maybeUpdateEarliestRecordedDateTooltip();

    let today = Date.now();
    let threeDaysMillis = 72 * 60 * 60 * 1000;
    let expired = today - this.milestoneTimestampPref > threeDaysMillis;

    if (this._milestoneTextSet && !expired) {
      this._protectionsPopup.setAttribute("milestone", this.milestonePref);
    } else {
      this._protectionsPopup.removeAttribute("milestone");
    }
  },

  /*
   * This function sorts the category items into the Blocked/Allowed/None Detected
   * sections. It's called immediately in onContentBlockingEvent if the popup
   * is presently open. Otherwise, the next time the popup is shown.
   */
  reorderCategoryItems() {
    if (!this._categoryItemOrderInvalidated) {
      return;
    }

    delete this._categoryItemOrderInvalidated;

    // Hide all the headers to start with.
    this._protectionsPopupBlockingHeader.hidden = true;
    this._protectionsPopupNotBlockingHeader.hidden = true;
    this._protectionsPopupNotFoundHeader.hidden = true;

    for (let { categoryItem } of this.blockers) {
      if (
        categoryItem.classList.contains("notFound") ||
        categoryItem.hasAttribute("uidisabled")
      ) {
        // Add the item to the bottom of the list. This will be under
        // the "None Detected" section.
        categoryItem.parentNode.insertAdjacentElement(
          "beforeend",
          categoryItem
        );
        categoryItem.setAttribute("disabled", true);
        // We have an undetected category, show the header.
        this._protectionsPopupNotFoundHeader.hidden = false;
        continue;
      }

      // Clear the disabled attribute in case we are moving the item out of
      // "None Detected"
      categoryItem.removeAttribute("disabled");

      if (categoryItem.classList.contains("blocked") && !this.hasException) {
        // Add the item just above the "Allowed" section - this will be the
        // bottom of the "Blocked" section.
        categoryItem.parentNode.insertBefore(
          categoryItem,
          this._protectionsPopupNotBlockingHeader
        );
        // We have a blocking category, show the header.
        this._protectionsPopupBlockingHeader.hidden = false;
        continue;
      }

      // Add the item just above the "None Detected" section - this will be the
      // bottom of the "Allowed" section.
      categoryItem.parentNode.insertBefore(
        categoryItem,
        this._protectionsPopupNotFoundHeader
      );
      // We have an allowing category, show the header.
      this._protectionsPopupNotBlockingHeader.hidden = false;
    }
  },

  disableForCurrentPage(shouldReload = true) {
    ContentBlockingAllowList.add(gBrowser.selectedBrowser);
    if (shouldReload) {
      PanelMultiView.hidePopup(this._protectionsPopup);
      BrowserReload();
    }
  },

  enableForCurrentPage(shouldReload = true) {
    ContentBlockingAllowList.remove(gBrowser.selectedBrowser);
    if (shouldReload) {
      PanelMultiView.hidePopup(this._protectionsPopup);
      BrowserReload();
    }
  },

  async onTPSwitchCommand(event) {
    // When the switch is clicked, we wait 500ms and then disable/enable
    // protections, causing the page to refresh, and close the popup.
    // We need to ensure we don't handle more clicks during the 500ms delay,
    // so we keep track of state and return early if needed.
    if (this._TPSwitchCommanding) {
      return;
    }

    this._TPSwitchCommanding = true;

    // Toggling the 'hasException' on the protections panel in order to do some
    // styling after toggling the TP switch.
    let newExceptionState = this._protectionsPopup.toggleAttribute(
      "hasException"
    );
    for (let tpSwitch of [
      this._protectionsPopupTPSwitch,
      this._protectionsPopupSiteNotWorkingTPSwitch,
    ]) {
      tpSwitch.toggleAttribute("enabled", !newExceptionState);
    }

    // Toggle the breakage link if needed.
    this.toggleBreakageLink();

    // Change the tooltip of the tracking protection icon.
    if (newExceptionState) {
      this.showDisabledTooltipForTPIcon();
    } else {
      this.showNoTrackerTooltipForTPIcon();
    }

    // Change the state of the tracking protection icon.
    this.iconBox.toggleAttribute("hasException", newExceptionState);

    // Indicating that we need to show a toast after refreshing the page.
    // And caching the current URI and window ID in order to only show the mini
    // panel if it's still on the same page.
    this._showToastAfterRefresh = true;
    this._previousURI = gBrowser.currentURI.spec;
    this._previousOuterWindowID = gBrowser.selectedBrowser.outerWindowID;

    if (newExceptionState) {
      this.disableForCurrentPage(false);
      this.recordClick("etp_toggle_off");
    } else {
      this.enableForCurrentPage(false);
      this.recordClick("etp_toggle_on");
    }

    // We need to flush the TP state change immediately without waiting the
    // 500ms delay if the Tab get switched out.
    let targetTab = gBrowser.selectedTab;
    let onTabSelectHandler;
    let tabSelectPromise = new Promise(resolve => {
      onTabSelectHandler = () => resolve();
      gBrowser.tabContainer.addEventListener("TabSelect", onTabSelectHandler);
    });
    let timeoutPromise = new Promise(resolve => setTimeout(resolve, 500));

    await Promise.race([tabSelectPromise, timeoutPromise]);
    gBrowser.tabContainer.removeEventListener("TabSelect", onTabSelectHandler);
    PanelMultiView.hidePopup(this._protectionsPopup);
    gBrowser.reloadTab(targetTab);

    delete this._TPSwitchCommanding;
  },

  setTrackersBlockedCounter(trackerCount) {
    let forms = gNavigatorBundle.getString(
      "protections.footer.blockedTrackerCounter.description"
    );
    this._protectionsPopupTrackersCounterDescription.textContent = PluralForm.get(
      trackerCount,
      forms
    ).replace(
      "#1",
      trackerCount.toLocaleString(Services.locale.appLocalesAsBCP47)
    );

    // Show the counter if the number of tracker is not zero.
    this._protectionsPopupTrackersCounterBox.toggleAttribute(
      "showing",
      trackerCount != 0
    );
  },

  // Whenever one of the milestone prefs are changed, we attempt to update
  // the milestone section string. This requires us to fetch the earliest
  // recorded date from the Tracking DB, hence this process is async.
  // When completed, we set _milestoneSetText to signal that the section
  // is populated and ready to be shown - which happens next time we call
  // refreshProtectionsPopup.
  _milestoneTextSet: false,
  async maybeSetMilestoneCounterText() {
    let trackerCount = this.milestonePref;
    if (
      !this.milestonesEnabledPref ||
      !trackerCount ||
      !this.milestoneListPref.includes(trackerCount)
    ) {
      this._milestoneTextSet = false;
      return;
    }

    let date = await TrackingDBService.getEarliestRecordedDate();
    let dateLocaleStr = new Date(date).toLocaleDateString("default", {
      month: "short",
      year: "numeric",
    });

    let desc = PluralForm.get(
      trackerCount,
      gNavigatorBundle.getString("protections.milestone.description")
    );

    this._protectionsPopupMilestonesText.textContent = desc
      .replace("#1", gBrandBundle.GetStringFromName("brandShortName"))
      .replace(
        "#2",
        trackerCount.toLocaleString(Services.locale.appLocalesAsBCP47)
      )
      .replace("#3", dateLocaleStr);

    this._milestoneTextSet = true;
  },

  showDisabledTooltipForTPIcon() {
    this._trackingProtectionIconTooltipLabel.textContent = this.strings.disabledTooltipText;
    this._trackingProtectionIconContainer.setAttribute(
      "aria-label",
      this.strings.disabledTooltipText
    );
  },

  showActiveTooltipForTPIcon() {
    this._trackingProtectionIconTooltipLabel.textContent = this.strings.activeTooltipText;
    this._trackingProtectionIconContainer.setAttribute(
      "aria-label",
      this.strings.activeTooltipText
    );
  },

  showNoTrackerTooltipForTPIcon() {
    this._trackingProtectionIconTooltipLabel.textContent = this.strings.noTrackerTooltipText;
    this._trackingProtectionIconContainer.setAttribute(
      "aria-label",
      this.strings.noTrackerTooltipText
    );
  },

  /**
   * Showing the protections popup.
   *
   * @param {Object} options
   *                 The object could have two properties.
   *                 event:
   *                   The event triggers the protections popup to be opened.
   *                 toast:
   *                   A boolean to indicate if we need to open the protections
   *                   popup as a toast. A toast only has a header section and
   *                   will be hidden after a certain amount of time.
   */
  showProtectionsPopup(options = {}) {
    const { event, toast } = options;

    // We need to clear the toast timer if it exists before showing the
    // protections popup.
    if (this._toastPanelTimer) {
      clearTimeout(this._toastPanelTimer);
      delete this._toastPanelTimer;
    }

    // Make sure that the display:none style we set in xul is removed now that
    // the popup is actually needed
    this._protectionsPopup.hidden = false;

    this._protectionsPopup.toggleAttribute("toast", !!toast);
    if (!toast) {
      // Refresh strings if we want to open it as a standard protections popup.
      this.refreshProtectionsPopup();
    }

    if (toast) {
      this._protectionsPopup.addEventListener(
        "popupshown",
        () => {
          this._toastPanelTimer = setTimeout(() => {
            PanelMultiView.hidePopup(this._protectionsPopup);
            delete this._toastPanelTimer;
          }, this._protectionsPopupToastTimeout);
        },
        { once: true }
      );
    }

    // Add the "open" attribute to the tracking protection icon container
    // for styling.
    this._trackingProtectionIconContainer.setAttribute("open", "true");

    // Check the panel state of the identity panel. Hide it if needed.
    if (gIdentityHandler._identityPopup.state != "closed") {
      PanelMultiView.hidePopup(gIdentityHandler._identityPopup);
    }

    // Now open the popup, anchored off the primary chrome element
    PanelMultiView.openPopup(
      this._protectionsPopup,
      this._trackingProtectionIconContainer,
      {
        position: "bottomcenter topleft",
        triggerEvent: event,
      }
    ).catch(Cu.reportError);
  },

  showSiteNotWorkingView() {
    this._protectionsPopupMultiView.showSubView(
      "protections-popup-siteNotWorkingView"
    );
  },

  showSendReportView() {
    // Save this URI to make sure that the user really only submits the location
    // they see in the report breakage dialog.
    this.reportURI = gBrowser.currentURI;
    let urlWithoutQuery = this.reportURI.asciiSpec.replace(
      "?" + this.reportURI.query,
      ""
    );
    let commentsTextarea = document.getElementById(
      "protections-popup-sendReportView-collection-comments"
    );
    commentsTextarea.value = "";
    this._protectionsPopupSendReportURL.value = urlWithoutQuery;
    this._protectionsPopupSiteNotWorkingReportError.hidden = true;
    this._protectionsPopupMultiView.showSubView(
      "protections-popup-sendReportView"
    );
  },

  toggleBreakageLink() {
    // The breakage link will only be shown if tracking protection is enabled
    // for the site and the TP toggle state is on. And we won't show the
    // link as toggling TP switch to On from Off. In order to do so, we need to
    // know the previous TP state. We check the ContentBlockingAllowList instead
    // of 'hasException' attribute of the protection popup for the previous
    // since the 'hasException' will also be toggled as well as toggling the TP
    // switch. We won't be able to know the previous TP state through the
    // 'hasException' attribute. So we fallback to check the
    // ContentBlockingAllowList here.
    this._protectionsPopupTPSwitchBreakageLink.hidden =
      ContentBlockingAllowList.includes(gBrowser.selectedBrowser) ||
      !this._protectionsPopup.hasAttribute("blocking") ||
      !this._protectionsPopupTPSwitch.hasAttribute("enabled");
    // The "Site Fixed?" link behaves similarly but for the opposite state.
    this._protectionsPopupTPSwitchBreakageFixedLink.hidden =
      !ContentBlockingAllowList.includes(gBrowser.selectedBrowser) ||
      this._protectionsPopupTPSwitch.hasAttribute("enabled");
  },

  submitBreakageReport(uri) {
    let reportEndpoint = Services.prefs.getStringPref(
      this.PREF_REPORT_BREAKAGE_URL
    );
    if (!reportEndpoint) {
      return;
    }

    let commentsTextarea = document.getElementById(
      "protections-popup-sendReportView-collection-comments"
    );

    let formData = new FormData();
    formData.set("title", uri.host);

    // Leave the ? at the end of the URL to signify that this URL had its query stripped.
    let urlWithoutQuery = uri.asciiSpec.replace(uri.query, "");
    let body = `Full URL: ${urlWithoutQuery}\n`;
    body += `userAgent: ${navigator.userAgent}\n`;

    body += "\n**Preferences**\n";
    body += `${
      TrackingProtection.PREF_ENABLED_GLOBALLY
    }: ${Services.prefs.getBoolPref(
      TrackingProtection.PREF_ENABLED_GLOBALLY
    )}\n`;
    body += `${
      TrackingProtection.PREF_ENABLED_IN_PRIVATE_WINDOWS
    }: ${Services.prefs.getBoolPref(
      TrackingProtection.PREF_ENABLED_IN_PRIVATE_WINDOWS
    )}\n`;
    body += `urlclassifier.trackingTable: ${Services.prefs.getStringPref(
      "urlclassifier.trackingTable"
    )}\n`;
    body += `network.http.referer.defaultPolicy: ${Services.prefs.getIntPref(
      "network.http.referer.defaultPolicy"
    )}\n`;
    body += `network.http.referer.defaultPolicy.pbmode: ${Services.prefs.getIntPref(
      "network.http.referer.defaultPolicy.pbmode"
    )}\n`;
    body += `${ThirdPartyCookies.PREF_ENABLED}: ${Services.prefs.getIntPref(
      ThirdPartyCookies.PREF_ENABLED
    )}\n`;
    body += `network.cookie.lifetimePolicy: ${Services.prefs.getIntPref(
      "network.cookie.lifetimePolicy"
    )}\n`;
    body += `privacy.annotate_channels.strict_list.enabled: ${Services.prefs.getBoolPref(
      "privacy.annotate_channels.strict_list.enabled"
    )}\n`;
    body += `privacy.restrict3rdpartystorage.expiration: ${Services.prefs.getIntPref(
      "privacy.restrict3rdpartystorage.expiration"
    )}\n`;
    body += `${Fingerprinting.PREF_ENABLED}: ${Services.prefs.getBoolPref(
      Fingerprinting.PREF_ENABLED
    )}\n`;
    body += `${Cryptomining.PREF_ENABLED}: ${Services.prefs.getBoolPref(
      Cryptomining.PREF_ENABLED
    )}\n`;
    body += `\nhasException: ${this.hasException}\n`;

    body += "\n**Comments**\n" + commentsTextarea.value;

    formData.set("body", body);

    let activatedBlockers = [];
    for (let blocker of this.blockers) {
      if (blocker.activated) {
        activatedBlockers.push(blocker.reportBreakageLabel);
      }
    }

    formData.set("labels", activatedBlockers.join(","));

    this._protectionsPopupSendReportButton.disabled = true;

    fetch(reportEndpoint, {
      method: "POST",
      credentials: "omit",
      body: formData,
    })
      .then(response => {
        this._protectionsPopupSendReportButton.disabled = false;
        if (!response.ok) {
          Cu.reportError(
            `Content Blocking report to ${reportEndpoint} failed with status ${response.status}`
          );
          this._protectionsPopupSiteNotWorkingReportError.hidden = false;
        } else {
          this._protectionsPopup.hidePopup();
          ConfirmationHint.show(this.iconBox, "breakageReport");
        }
      })
      .catch(Cu.reportError);
  },

  onSendReportClicked() {
    this.submitBreakageReport(this.reportURI);
  },

  async maybeUpdateEarliestRecordedDateTooltip() {
    if (this._hasEarliestRecord) {
      return;
    }

    let date = await TrackingDBService.getEarliestRecordedDate();

    // If there is no record for any blocked tracker, we don't have to do anything
    // since the tracker counter won't be shown.
    if (!date) {
      return;
    }
    this._hasEarliestRecord = true;

    const dateLocaleStr = new Date(date).toLocaleDateString("default", {
      month: "long",
      day: "numeric",
      year: "numeric",
    });

    const tooltipStr = gNavigatorBundle.getFormattedString(
      "protections.footer.blockedTrackerCounter.tooltip",
      [dateLocaleStr]
    );

    this._protectionsPopupTrackersCounterDescription.setAttribute(
      "tooltiptext",
      tooltipStr
    );
  },
};
