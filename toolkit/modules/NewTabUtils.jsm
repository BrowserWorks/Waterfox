/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["NewTabUtils"];

const Ci = Components.interfaces;
const Cc = Components.classes;
const Cu = Components.utils;

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.importGlobalProperties(["btoa"]);

XPCOMUtils.defineLazyModuleGetter(this, "PlacesUtils",
  "resource://gre/modules/PlacesUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "PageThumbs",
  "resource://gre/modules/PageThumbs.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "BinarySearch",
  "resource://gre/modules/BinarySearch.jsm");

XPCOMUtils.defineLazyGetter(this, "gCryptoHash", function() {
  return Cc["@mozilla.org/security/hash;1"].createInstance(Ci.nsICryptoHash);
});

XPCOMUtils.defineLazyGetter(this, "gUnicodeConverter", function() {
  let converter = Cc["@mozilla.org/intl/scriptableunicodeconverter"]
                    .createInstance(Ci.nsIScriptableUnicodeConverter);
  converter.charset = "utf8";
  return converter;
});

// Boolean preferences that control newtab content
const PREF_NEWTAB_ENABLED = "browser.newtabpage.enabled";
const PREF_NEWTAB_ENHANCED = "browser.newtabpage.enhanced";

// The preference that tells the number of rows of the newtab grid.
const PREF_NEWTAB_ROWS = "browser.newtabpage.rows";

// The preference that tells the number of columns of the newtab grid.
const PREF_NEWTAB_COLUMNS = "browser.newtabpage.columns";

// The maximum number of results PlacesProvider retrieves from history.
const HISTORY_RESULTS_LIMIT = 100;

// The maximum number of links Links.getLinks will return.
const LINKS_GET_LINKS_LIMIT = 100;

// The gather telemetry topic.
const TOPIC_GATHER_TELEMETRY = "gather-telemetry";

// The number of top sites to display on Activity Stream page
const TOP_SITES_LENGTH = 6;

// Use double the number to allow for immediate display when blocking sites
const TOP_SITES_LIMIT = TOP_SITES_LENGTH * 2;

/**
 * Calculate the MD5 hash for a string.
 * @param aValue
 *        The string to convert.
 * @return The base64 representation of the MD5 hash.
 */
function toHash(aValue) {
  let value = gUnicodeConverter.convertToByteArray(aValue);
  gCryptoHash.init(gCryptoHash.MD5);
  gCryptoHash.update(value, value.length);
  return gCryptoHash.finish(true);
}

/**
 * Singleton that provides storage functionality.
 */
XPCOMUtils.defineLazyGetter(this, "Storage", function() {
  return new LinksStorage();
});

function LinksStorage() {
  // Handle migration of data across versions.
  try {
    if (this._storedVersion < this._version) {
      // This is either an upgrade, or version information is missing.
      if (this._storedVersion < 1) {
        // Version 1 moved data from DOM Storage to prefs.  Since migrating from
        // version 0 is no more supported, we just reportError a dataloss later.
        throw new Error("Unsupported newTab storage version");
      }
      // Add further migration steps here.
    } else {
      // This is a downgrade.  Since we cannot predict future, upgrades should
      // be backwards compatible.  We will set the version to the old value
      // regardless, so, on next upgrade, the migration steps will run again.
      // For this reason, they should also be able to run multiple times, even
      // on top of an already up-to-date storage.
    }
  } catch (ex) {
    // Something went wrong in the update process, we can't recover from here,
    // so just clear the storage and start from scratch (dataloss!).
    Components.utils.reportError(
      "Unable to migrate the newTab storage to the current version. " +
      "Restarting from scratch.\n" + ex);
    this.clear();
  }

  // Set the version to the current one.
  this._storedVersion = this._version;
}

LinksStorage.prototype = {
  get _version() {
    return 1;
  },

  get _prefs() {
    return Object.freeze({
      pinnedLinks: "browser.newtabpage.pinned",
      blockedLinks: "browser.newtabpage.blocked",
    });
  },

  get _storedVersion() {
    if (this.__storedVersion === undefined) {
      // When the pref is not set, the storage version is unknown, so either:
      // - it's a new profile
      // - it's a profile where versioning information got lost
      // In this case we still run through all of the valid migrations,
      // starting from 1, as if it was a downgrade.  As previously stated the
      // migrations should already support running on an updated store.
      this.__storedVersion =
        Services.prefs.getIntPref("browser.newtabpage.storageVersion", 1);
    }
    return this.__storedVersion;
  },
  set _storedVersion(aValue) {
    Services.prefs.setIntPref("browser.newtabpage.storageVersion", aValue);
    this.__storedVersion = aValue;
    return aValue;
  },

  /**
   * Gets the value for a given key from the storage.
   * @param aKey The storage key (a string).
   * @param aDefault A default value if the key doesn't exist.
   * @return The value for the given key.
   */
  get: function Storage_get(aKey, aDefault) {
    let value;
    try {
      let prefValue = Services.prefs.getStringPref(this._prefs[aKey]);
      value = JSON.parse(prefValue);
    } catch (e) {}
    return value || aDefault;
  },

  /**
   * Sets the storage value for a given key.
   * @param aKey The storage key (a string).
   * @param aValue The value to set.
   */
  set: function Storage_set(aKey, aValue) {
    // Page titles may contain unicode, thus use complex values.
    Services.prefs.setStringPref(this._prefs[aKey], JSON.stringify(aValue));
  },

  /**
   * Removes the storage value for a given key.
   * @param aKey The storage key (a string).
   */
  remove: function Storage_remove(aKey) {
    Services.prefs.clearUserPref(this._prefs[aKey]);
  },

  /**
   * Clears the storage and removes all values.
   */
  clear: function Storage_clear() {
    for (let key in this._prefs) {
      this.remove(key);
    }
  }
};


/**
 * Singleton that serves as a registry for all open 'New Tab Page's.
 */
var AllPages = {
  /**
   * The array containing all active pages.
   */
  _pages: [],

  /**
   * Cached value that tells whether the New Tab Page feature is enabled.
   */
  _enabled: null,

  /**
   * Cached value that tells whether the New Tab Page feature is enhanced.
   */
  _enhanced: null,

  /**
   * Adds a page to the internal list of pages.
   * @param aPage The page to register.
   */
  register: function AllPages_register(aPage) {
    this._pages.push(aPage);
    this._addObserver();
  },

  /**
   * Removes a page from the internal list of pages.
   * @param aPage The page to unregister.
   */
  unregister: function AllPages_unregister(aPage) {
    let index = this._pages.indexOf(aPage);
    if (index > -1)
      this._pages.splice(index, 1);
  },

  /**
   * Returns whether the 'New Tab Page' is enabled.
   */
  get enabled() {
    if (this._enabled === null)
      this._enabled = Services.prefs.getBoolPref(PREF_NEWTAB_ENABLED);

    return this._enabled;
  },

  /**
   * Enables or disables the 'New Tab Page' feature.
   */
  set enabled(aEnabled) {
    if (this.enabled != aEnabled)
      Services.prefs.setBoolPref(PREF_NEWTAB_ENABLED, !!aEnabled);
  },

  /**
   * Returns whether the history tiles are enhanced.
   */
  get enhanced() {
    if (this._enhanced === null)
      this._enhanced = Services.prefs.getBoolPref(PREF_NEWTAB_ENHANCED);

    return this._enhanced;
  },

  /**
   * Enables or disables the enhancement of history tiles feature.
   */
  set enhanced(aEnhanced) {
    if (this.enhanced != aEnhanced)
      Services.prefs.setBoolPref(PREF_NEWTAB_ENHANCED, !!aEnhanced);
  },

  /**
   * Returns the number of registered New Tab Pages (i.e. the number of open
   * about:newtab instances).
   */
  get length() {
    return this._pages.length;
  },

  /**
   * Updates all currently active pages but the given one.
   * @param aExceptPage The page to exclude from updating.
   * @param aReason The reason for updating all pages.
   */
  update(aExceptPage, aReason = "") {
    for (let page of this._pages.slice()) {
      if (aExceptPage != page) {
        page.update(aReason);
      }
    }
  },

  /**
   * Implements the nsIObserver interface to get notified when the preference
   * value changes or when a new copy of a page thumbnail is available.
   */
  observe: function AllPages_observe(aSubject, aTopic, aData) {
    if (aTopic == "nsPref:changed") {
      // Clear the cached value.
      switch (aData) {
        case PREF_NEWTAB_ENABLED:
          this._enabled = null;
          break;
        case PREF_NEWTAB_ENHANCED:
          this._enhanced = null;
          break;
      }
    }
    // and all notifications get forwarded to each page.
    this._pages.forEach(function(aPage) {
      aPage.observe(aSubject, aTopic, aData);
    }, this);
  },

  /**
   * Adds a preference and new thumbnail observer and turns itself into a
   * no-op after the first invokation.
   */
  _addObserver: function AllPages_addObserver() {
    Services.prefs.addObserver(PREF_NEWTAB_ENABLED, this, true);
    Services.prefs.addObserver(PREF_NEWTAB_ENHANCED, this, true);
    Services.obs.addObserver(this, "page-thumbnail:create", true);
    this._addObserver = function() {};
  },

  QueryInterface: XPCOMUtils.generateQI([Ci.nsIObserver,
                                         Ci.nsISupportsWeakReference])
};

/**
 * Singleton that keeps Grid preferences
 */
var GridPrefs = {
  /**
   * Cached value that tells the number of rows of newtab grid.
   */
  _gridRows: null,
  get gridRows() {
    if (!this._gridRows) {
      this._gridRows = Math.max(1, Services.prefs.getIntPref(PREF_NEWTAB_ROWS));
    }

    return this._gridRows;
  },

  /**
   * Cached value that tells the number of columns of newtab grid.
   */
  _gridColumns: null,
  get gridColumns() {
    if (!this._gridColumns) {
      this._gridColumns = Math.max(1, Services.prefs.getIntPref(PREF_NEWTAB_COLUMNS));
    }

    return this._gridColumns;
  },


  /**
   * Initializes object. Adds a preference observer
   */
  init: function GridPrefs_init() {
    Services.prefs.addObserver(PREF_NEWTAB_ROWS, this);
    Services.prefs.addObserver(PREF_NEWTAB_COLUMNS, this);
  },

 /**
  * Uninitializes object. Removes the preference observers
  */
  uninit: function GridPrefs_uninit() {
    Services.prefs.removeObserver(PREF_NEWTAB_ROWS, this);
    Services.prefs.removeObserver(PREF_NEWTAB_COLUMNS, this);
  },

  /**
   * Implements the nsIObserver interface to get notified when the preference
   * value changes.
   */
  observe: function GridPrefs_observe(aSubject, aTopic, aData) {
    if (aData == PREF_NEWTAB_ROWS) {
      this._gridRows = null;
    } else {
      this._gridColumns = null;
    }

    AllPages.update();
  }
};

GridPrefs.init();

/**
 * Singleton that keeps track of all pinned links and their positions in the
 * grid.
 */
var PinnedLinks = {
  /**
   * The cached list of pinned links.
   */
  _links: null,

  /**
   * The array of pinned links.
   */
  get links() {
    if (!this._links)
      this._links = Storage.get("pinnedLinks", []);

    return this._links;
  },

  /**
   * Pins a link at the given position.
   * @param aLink The link to pin.
   * @param aIndex The grid index to pin the cell at.
   * @return true if link changes, false otherwise
   */
  pin: function PinnedLinks_pin(aLink, aIndex) {
    // Clear the link's old position, if any.
    this.unpin(aLink);

    // change pinned link into a history link
    let changed = this._makeHistoryLink(aLink);
    this.links[aIndex] = aLink;
    this.save();
    return changed;
  },

  /**
   * Unpins a given link.
   * @param aLink The link to unpin.
   */
  unpin: function PinnedLinks_unpin(aLink) {
    let index = this._indexOfLink(aLink);
    if (index == -1)
      return;
    let links = this.links;
    links[index] = null;
    // trim trailing nulls
    let i = links.length - 1;
    while (i >= 0 && links[i] == null)
      i--;
    links.splice(i + 1);
    this.save();
  },

  /**
   * Saves the current list of pinned links.
   */
  save: function PinnedLinks_save() {
    Storage.set("pinnedLinks", this.links);
  },

  /**
   * Checks whether a given link is pinned.
   * @params aLink The link to check.
   * @return whether The link is pinned.
   */
  isPinned: function PinnedLinks_isPinned(aLink) {
    return this._indexOfLink(aLink) != -1;
  },

  /**
   * Resets the links cache.
   */
  resetCache: function PinnedLinks_resetCache() {
    this._links = null;
  },

  /**
   * Finds the index of a given link in the list of pinned links.
   * @param aLink The link to find an index for.
   * @return The link's index.
   */
  _indexOfLink: function PinnedLinks_indexOfLink(aLink) {
    for (let i = 0; i < this.links.length; i++) {
      let link = this.links[i];
      if (link && link.url == aLink.url)
        return i;
    }

    // The given link is unpinned.
    return -1;
  },

  /**
   * Transforms link into a "history" link
   * @param aLink The link to change
   * @return true if link changes, false otherwise
   */
  _makeHistoryLink: function PinnedLinks_makeHistoryLink(aLink) {
    if (!aLink.type || aLink.type == "history") {
      return false;
    }
    aLink.type = "history";
    return true;
  },

  /**
   * Replaces existing link with another link.
   * @param aUrl The url of existing link
   * @param aLink The replacement link
   */
  replace: function PinnedLinks_replace(aUrl, aLink) {
    let index = this._indexOfLink({url: aUrl});
    if (index == -1) {
      return;
    }
    this.links[index] = aLink;
    this.save();
  },

};

/**
 * Singleton that keeps track of all blocked links in the grid.
 */
var BlockedLinks = {
  /**
   * A list of objects that are observing blocked link changes.
   */
  _observers: [],

  /**
   * The cached list of blocked links.
   */
  _links: null,

  /**
   * Registers an object that will be notified when the blocked links change.
   */
  addObserver(aObserver) {
    this._observers.push(aObserver);
  },

  /**
   * Remove the observers.
   */
  removeObservers() {
    this._observers = [];
  },

  /**
   * The list of blocked links.
   */
  get links() {
    if (!this._links)
      this._links = Storage.get("blockedLinks", {});

    return this._links;
  },

  /**
   * Blocks a given link. Adjusts siteMap accordingly, and notifies listeners.
   * @param aLink The link to block.
   */
  block: function BlockedLinks_block(aLink) {
    this._callObservers("onLinkBlocked", aLink);
    this.links[toHash(aLink.url)] = 1;
    this.save();

    // Make sure we unpin blocked links.
    PinnedLinks.unpin(aLink);
  },

  /**
   * Unblocks a given link. Adjusts siteMap accordingly, and notifies listeners.
   * @param aLink The link to unblock.
   */
  unblock: function BlockedLinks_unblock(aLink) {
    if (this.isBlocked(aLink)) {
      delete this.links[toHash(aLink.url)];
      this.save();
      this._callObservers("onLinkUnblocked", aLink);
    }
  },

  /**
   * Saves the current list of blocked links.
   */
  save: function BlockedLinks_save() {
    Storage.set("blockedLinks", this.links);
  },

  /**
   * Returns whether a given link is blocked.
   * @param aLink The link to check.
   */
  isBlocked: function BlockedLinks_isBlocked(aLink) {
    return (toHash(aLink.url) in this.links);
  },

  /**
   * Checks whether the list of blocked links is empty.
   * @return Whether the list is empty.
   */
  isEmpty: function BlockedLinks_isEmpty() {
    return Object.keys(this.links).length == 0;
  },

  /**
   * Resets the links cache.
   */
  resetCache: function BlockedLinks_resetCache() {
    this._links = null;
  },

  _callObservers(methodName, ...args) {
    for (let obs of this._observers) {
      if (typeof(obs[methodName]) == "function") {
        try {
          obs[methodName](...args);
        } catch (err) {
          Cu.reportError(err);
        }
      }
    }
  }
};

/**
 * Singleton that serves as the default link provider for the grid. It queries
 * the history to retrieve the most frequently visited sites.
 */
var PlacesProvider = {
  /**
   * A count of how many batch updates are under way (batches may be nested, so
   * we keep a counter instead of a simple bool).
   **/
  _batchProcessingDepth: 0,

  /**
   * A flag that tracks whether onFrecencyChanged was notified while a batch
   * operation was in progress, to tell us whether to take special action after
   * the batch operation completes.
   **/
  _batchCalledFrecencyChanged: false,

  /**
   * Set this to change the maximum number of links the provider will provide.
   */
  maxNumLinks: HISTORY_RESULTS_LIMIT,

  /**
   * Must be called before the provider is used.
   */
  init: function PlacesProvider_init() {
    PlacesUtils.history.addObserver(this, true);
  },

  /**
   * Gets the current set of links delivered by this provider.
   * @param aCallback The function that the array of links is passed to.
   */
  getLinks: function PlacesProvider_getLinks(aCallback) {
    let options = PlacesUtils.history.getNewQueryOptions();
    options.maxResults = this.maxNumLinks;

    // Sort by frecency, descending.
    options.sortingMode = Ci.nsINavHistoryQueryOptions.SORT_BY_FRECENCY_DESCENDING

    let links = [];

    let callback = {
      handleResult(aResultSet) {
        let row;

        while ((row = aResultSet.getNextRow())) {
          let url = row.getResultByIndex(1);
          if (LinkChecker.checkLoadURI(url)) {
            let title = row.getResultByIndex(2);
            let frecency = row.getResultByIndex(12);
            let lastVisitDate = row.getResultByIndex(5);
            links.push({
              url,
              title,
              frecency,
              lastVisitDate,
              type: "history",
            });
          }
        }
      },

      handleError(aError) {
        // Should we somehow handle this error?
        aCallback([]);
      },

      handleCompletion(aReason) {
        // The Places query breaks ties in frecency by place ID descending, but
        // that's different from how Links.compareLinks breaks ties, because
        // compareLinks doesn't have access to place IDs.  It's very important
        // that the initial list of links is sorted in the same order imposed by
        // compareLinks, because Links uses compareLinks to perform binary
        // searches on the list.  So, ensure the list is so ordered.
        let i = 1;
        let outOfOrder = [];
        while (i < links.length) {
          if (Links.compareLinks(links[i - 1], links[i]) > 0)
            outOfOrder.push(links.splice(i, 1)[0]);
          else
            i++;
        }
        for (let link of outOfOrder) {
          i = BinarySearch.insertionIndexOf(Links.compareLinks, links, link);
          links.splice(i, 0, link);
        }

        aCallback(links);
      }
    };

    // Execute the query.
    let query = PlacesUtils.history.getNewQuery();
    let db = PlacesUtils.history.QueryInterface(Ci.nsPIPlacesDatabase);
    db.asyncExecuteLegacyQueries([query], 1, options, callback);
  },

  /**
   * Registers an object that will be notified when the provider's links change.
   * @param aObserver An object with the following optional properties:
   *        * onLinkChanged: A function that's called when a single link
   *          changes.  It's passed the provider and the link object.  Only the
   *          link's `url` property is guaranteed to be present.  If its `title`
   *          property is present, then its title has changed, and the
   *          property's value is the new title.  If any sort properties are
   *          present, then its position within the provider's list of links may
   *          have changed, and the properties' values are the new sort-related
   *          values.  Note that this link may not necessarily have been present
   *          in the lists returned from any previous calls to getLinks.
   *        * onManyLinksChanged: A function that's called when many links
   *          change at once.  It's passed the provider.  You should call
   *          getLinks to get the provider's new list of links.
   */
  addObserver: function PlacesProvider_addObserver(aObserver) {
    this._observers.push(aObserver);
  },

  _observers: [],

  /**
   * Called by the history service.
   */
  onBeginUpdateBatch() {
    this._batchProcessingDepth += 1;
  },

  onEndUpdateBatch() {
    this._batchProcessingDepth -= 1;
    if (this._batchProcessingDepth == 0 && this._batchCalledFrecencyChanged) {
      this.onManyFrecenciesChanged();
      this._batchCalledFrecencyChanged = false;
    }
  },

  onVisit(aURI, aVisitId, aTime, aSessionId, aReferrerVisitId, aTransitionType,
          aGuid, aHidden, aVisitCount, aTyped, aLastKnownTitle) {
    // For new visits, if we're not batch processing, notify for a title // update
    if (!this._batchProcessingDepth && aVisitCount == 1 && aLastKnownTitle) {
      this.onTitleChanged(aURI, aLastKnownTitle, aGuid);
    }
  },

  onDeleteURI: function PlacesProvider_onDeleteURI(aURI, aGUID, aReason) {
    // let observers remove sensetive data associated with deleted visit
    this._callObservers("onDeleteURI", {
      url: aURI.spec,
    });
  },

  onClearHistory() {
    this._callObservers("onClearHistory")
  },

  /**
   * Called by the history service.
   */
  onFrecencyChanged: function PlacesProvider_onFrecencyChanged(aURI, aNewFrecency, aGUID, aHidden, aLastVisitDate) {
    // If something is doing a batch update of history entries we don't want
    // to do lots of work for each record. So we just track the fact we need
    // to call onManyFrecenciesChanged() once the batch is complete.
    if (this._batchProcessingDepth > 0) {
      this._batchCalledFrecencyChanged = true;
      return;
    }
    // The implementation of the query in getLinks excludes hidden and
    // unvisited pages, so it's important to exclude them here, too.
    if (!aHidden && aLastVisitDate) {
      this._callObservers("onLinkChanged", {
        url: aURI.spec,
        frecency: aNewFrecency,
        lastVisitDate: aLastVisitDate,
        type: "history",
      });
    }
  },

  /**
   * Called by the history service.
   */
  onManyFrecenciesChanged: function PlacesProvider_onManyFrecenciesChanged() {
    this._callObservers("onManyLinksChanged");
  },

  /**
   * Called by the history service.
   */
  onTitleChanged: function PlacesProvider_onTitleChanged(aURI, aNewTitle, aGUID) {
    this._callObservers("onLinkChanged", {
      url: aURI.spec,
      title: aNewTitle
    });
  },

  _callObservers: function PlacesProvider__callObservers(aMethodName, aArg) {
    for (let obs of this._observers) {
      if (obs[aMethodName]) {
        try {
          obs[aMethodName](this, aArg);
        } catch (err) {
          Cu.reportError(err);
        }
      }
    }
  },

  QueryInterface: XPCOMUtils.generateQI([Ci.nsINavHistoryObserver,
                                         Ci.nsISupportsWeakReference]),
};

/**
 * Queries history to retrieve the most frecent sites. Emits events when the
 * history changes.
 */
var ActivityStreamProvider = {

  /**
   * Process links after getting them from the database.
   *
   * @param {Array} aLinks
   *          an array containing link objects
   *
   * @returns {Array} an array of checked links with favicons and eTLDs added
   */
  _processLinks(aLinks) {
    let links_ = aLinks.filter(link => LinkChecker.checkLoadURI(link.url));
    links_ = this._faviconBytesToDataURI(links_);
    return this._addETLD(links_);
  },

  /**
   * From an Array of links, if favicons are present, convert to data URIs
   *
   * @param {Array} aLinks
   *          an array containing objects with favicon data and mimeTypes
   *
   * @returns {Array} an array of links with favicons as data uri
   */
  _faviconBytesToDataURI(aLinks) {
    return aLinks.map(link => {
      if (link.favicon) {
        let encodedData = btoa(String.fromCharCode.apply(null, link.favicon));
        link.favicon = `data:${link.mimeType};base64,${encodedData}`;
      }
      delete link.mimeType;
      return link;
    });
  },

  /**
   * Computes favicon data for each url in a set of links
   *
   * @param {Array} links
   *          an array containing objects without favicon data or mimeTypes yet
   *
   * @returns {Promise} Returns a promise with the array of links with favicon data,
   *                    mimeType, and byte array length
   */
  async _addFavicons(aLinks) {
    if (aLinks.length) {
      // Each link in the array needs a favicon for it's page - so we fire off
      // a promise for each link to compute the favicon data and attach it back
      // to the original link object. We must wait until all favicons for
      // the array of links are computed before returning
      await Promise.all(aLinks.map(link => new Promise(resolve => {
        return PlacesUtils.favicons.getFaviconDataForPage(
            Services.io.newURI(link.url),
            (iconuri, len, data, mime) => {
              // Due to the asynchronous behaviour of inserting a favicon into
              // moz_favicons, the data may not be available to us just yet,
              // since we listen on a history entry being inserted. As a result,
              // we don't want to throw if the icon uri is not here yet, we
              // just want to resolve on an empty favicon. Activity Stream
              // knows how to handle null favicons
              if (!iconuri) {
                link.favicon = null;
                link.mimeType = null;
              } else {
                link.favicon = data;
                link.mimeType = mime;
                link.faviconLength = len;
              }
              return resolve(link);
            });
        }).catch(() => {
          // If something goes wrong - that's ok - just return a null favicon
          // without rejecting the entire Promise.all
          link.favicon = null;
          link.mimeType = null;
          return link;
        })
      ));
    }
    return aLinks;
  },

  /**
   * Add the eTLD to each link in the array of links.
   *
   * @param {Array} aLinks
   *          an array containing objects with urls
   *
   * @returns {Array} an array of links with eTLDs added
   */
  _addETLD(aLinks) {
    return aLinks.map(link => {
      try {
        link.eTLD = Services.eTLD.getPublicSuffix(Services.io.newURI(link.url));
      } catch (e) {
        link.eTLD = "";
      }
      return link;
    });
  },

  /*
   * Gets the top frecent sites for Activity Stream.
   *
   * @param {Object} aOptions
   *          options.ignoreBlocked: Do not filter out blocked links .
   *
   * @returns {Promise} Returns a promise with the array of links as payload.
   */
  async getTopFrecentSites(aOptions = {}) {
    let {ignoreBlocked} = aOptions;

    // GROUP first by rev_host to get the most-frecent page of an exact host
    // then GROUP by rev_nowww to dedupe between top two pages of nowww host.
    // Note that unlike mysql, sqlite picks the last raw from groupby bucket.
    // Which is why subselect orders frecency and last_visit_date backwards.
    // In general the groupby behavior in the absence of aggregates is not
    // defined in SQL, hence we are relying on sqlite implementation that may
    // change in the future.

    const limit = Object.keys(BlockedLinks.links).length + TOP_SITES_LIMIT;
    let sqlQuery = `/* do not warn (bug N/A): do not need index */
                    SELECT url, title, SUM(frecency) frecency, guid, bookmarkGuid,
                     last_visit_date / 1000 as lastVisitDate, "history" as type
                    FROM (SELECT * FROM (
                      SELECT
                        rev_host,
                        fixup_url(get_unreversed_host(rev_host)) AS rev_nowww,
                        moz_places.url,
                        moz_places.title,
                        frecency,
                        last_visit_date,
                        moz_places.guid AS guid,
                        moz_bookmarks.guid AS bookmarkGuid
                      FROM moz_places
                      LEFT JOIN moz_bookmarks
                      on moz_places.id = moz_bookmarks.fk
                      WHERE hidden = 0 AND last_visit_date NOTNULL
                      AND (SUBSTR(moz_places.url, 1, 6) == "https:" OR SUBSTR(moz_places.url, 1, 5) == "http:")
                      ORDER BY frecency, last_visit_date, moz_places.url DESC
                    ) GROUP BY rev_host)
                    GROUP BY rev_nowww
                    ORDER BY frecency DESC, lastVisitDate DESC, url
                    LIMIT ${limit}`;

    let links = await this.executePlacesQuery(sqlQuery, {
      columns: [
        "bookmarkGuid",
        "frecency",
        "guid",
        "lastVisitDate",
        "title",
        "type",
        "url"
      ]
    });

    if (!ignoreBlocked) {
      links = links.filter(link => !BlockedLinks.isBlocked(link));
    }
    links = links.slice(0, TOP_SITES_LIMIT);
    links = await this._addFavicons(links);
    return this._processLinks(links);
  },

  /**
   * Gets a specific bookmark given an id
   *
   * @param {String} aGuid
   *          A bookmark guid to use as a refrence to fetch the bookmark
   */
  async getBookmark(aGuid) {
    let bookmark = await PlacesUtils.bookmarks.fetch(aGuid);
    if (!bookmark) {
      return null;
    }
    let result = {};
    result.bookmarkGuid = bookmark.guid;
    result.bookmarkTitle = bookmark.title;
    result.lastModified = bookmark.lastModified.getTime();
    result.url = bookmark.url.href;
    return result;
  },

  /**
   * Gets History size
   *
   * @returns {Promise} Returns a promise with the count of moz_places records
   */
  async getHistorySize() {
    let sqlQuery = `SELECT count(*) FROM moz_places
                    WHERE hidden = 0 AND last_visit_date NOT NULL`;

    let result = await this.executePlacesQuery(sqlQuery);
    return result;
  },

  /**
   * Gets Bookmarks count
   *
   * @returns {Promise} Returns a promise with the count of bookmarks
   */
  async getBookmarksSize() {
    let sqlQuery = `SELECT count(*) FROM moz_bookmarks WHERE type = :type`;

    let result = await this.executePlacesQuery(sqlQuery, {params: {type: PlacesUtils.bookmarks.TYPE_BOOKMARK}});
    return result;
  },

  /**
   * Executes arbitrary query against places database
   *
   * @param {String} aQuery
   *        SQL query to execute
   * @param {Object} [optional] aOptions
   *          aOptions.columns - an array of column names. if supplied the return
   *          items will consists of objects keyed on column names. Otherwise
   *          array of raw values is returned in the select order
   *          aOptions.param - an object of SQL binding parameters
   *
   * @returns {Promise} Returns a promise with the array of retrieved items
   */
  async executePlacesQuery(aQuery, aOptions = {}) {
    let {columns, params} = aOptions;
    let items = [];
    let queryError = null;
    let conn = await PlacesUtils.promiseDBConnection();
    await conn.executeCached(aQuery, params, aRow => {
      try {
        let item = null;
        // if columns array is given construct an object
        if (columns && Array.isArray(columns)) {
          item = {};
          columns.forEach(column => {
            item[column] = aRow.getResultByName(column);
          });
        } else {
          // if no columns - make an array of raw values
          item = [];
          for (let i = 0; i < aRow.numEntries; i++) {
            item.push(aRow.getResultByIndex(i));
          }
        }
        items.push(item);
      } catch (e) {
        queryError = e;
        throw StopIteration;
      }
    });
    if (queryError) {
      throw new Error(queryError);
    }
    return items;
  }
};

/**
 * A set of actions which influence what sites shown on the Activity Stream page
 */
var ActivityStreamLinks = {
  /**
   * Block a url
   *
   * @param {Object} aLink
   *          The link which contains a URL to add to the block list
   */
  blockURL(aLink) {
    BlockedLinks.block(aLink);
  },

  onLinkBlocked(aLink) {
    Services.obs.notifyObservers(null, "newtab-linkBlocked", aLink.url);
  },

  /**
   * Adds a bookmark
   *
   * @param {String} aUrl
   *          The url to bookmark
   *
   * @returns {Promise} Returns a promise set to an object representing the bookmark
   */
  addBookmark(aUrl) {
    return PlacesUtils.bookmarks.insert({
      url: aUrl,
      parentGuid: PlacesUtils.bookmarks.unfiledGuid
    });
  },

  /**
   * Removes a bookmark
   *
   * @param {String} aBookmarkGuid
   *          The bookmark guid associated with the bookmark to remove
   *
   * @returns {Promise} Returns a promise set to an object representing the
   *            removed bookmark
   */
  deleteBookmark(aBookmarkGuid) {
    return PlacesUtils.bookmarks.remove(aBookmarkGuid);
  },

  /**
   * Removes a history link
   *
   * @param {String} aUrl
   *           The url to be removed from history
   *
   * @returns {Promise} Returns a promise set to true if link was removed
   */
  deleteHistoryEntry(aUrl) {
    return PlacesUtils.history.remove(aUrl);
  },

  /**
   * Get the top sites to show on Activity Stream
   *
   * @return {Promise} Returns a promise with the array of links as the payload
   */
  async getTopSites(aOptions = {}) {
    return ActivityStreamProvider.getTopFrecentSites(aOptions);
  }
};

/**
 * Singleton that provides access to all links contained in the grid (including
 * the ones that don't fit on the grid). A link is a plain object that looks
 * like this:
 *
 * {
 *   url: "http://www.mozilla.org/",
 *   title: "Mozilla",
 *   frecency: 1337,
 *   lastVisitDate: 1394678824766431,
 * }
 */
var Links = {
  /**
   * The maximum number of links returned by getLinks.
   */
  maxNumLinks: LINKS_GET_LINKS_LIMIT,

  /**
   * A mapping from each provider to an object { sortedLinks, siteMap, linkMap }.
   * sortedLinks is the cached, sorted array of links for the provider.
   * siteMap is a mapping from base domains to URL count associated with the domain.
   *         The count does not include blocked URLs. siteMap is used to look up a
   *         user's top sites that can be targeted with a suggested tile.
   * linkMap is a Map from link URLs to link objects.
   */
  _providers: new Map(),

  /**
   * The properties of link objects used to sort them.
   */
  _sortProperties: [
    "frecency",
    "lastVisitDate",
    "url",
  ],

  /**
   * List of callbacks waiting for the cache to be populated.
   */
  _populateCallbacks: [],

  /**
   * A list of objects that are observing links updates.
   */
  _observers: [],

  /**
   * Registers an object that will be notified when links updates.
   */
  addObserver(aObserver) {
    this._observers.push(aObserver);
  },

  /**
   * Adds a link provider.
   * @param aProvider The link provider.
   */
  addProvider: function Links_addProvider(aProvider) {
    this._providers.set(aProvider, null);
    aProvider.addObserver(this);
  },

  /**
   * Removes a link provider.
   * @param aProvider The link provider.
   */
  removeProvider: function Links_removeProvider(aProvider) {
    if (!this._providers.delete(aProvider))
      throw new Error("Unknown provider");
  },

  /**
   * Populates the cache with fresh links from the providers.
   * @param aCallback The callback to call when finished (optional).
   * @param aForce When true, populates the cache even when it's already filled.
   */
  populateCache: function Links_populateCache(aCallback, aForce) {
    let callbacks = this._populateCallbacks;

    // Enqueue the current callback.
    callbacks.push(aCallback);

    // There was a callback waiting already, thus the cache has not yet been
    // populated.
    if (callbacks.length > 1)
      return;

    function executeCallbacks() {
      while (callbacks.length) {
        let callback = callbacks.shift();
        if (callback) {
          try {
            callback();
          } catch (e) {
            // We want to proceed even if a callback fails.
          }
        }
      }
    }

    let numProvidersRemaining = this._providers.size;
    for (let [provider /* , links */] of this._providers) {
      this._populateProviderCache(provider, () => {
        if (--numProvidersRemaining == 0)
          executeCallbacks();
      }, aForce);
    }

    this._addObserver();
  },

  /**
   * Gets the current set of links contained in the grid.
   * @return The links in the grid.
   */
  getLinks: function Links_getLinks() {
    let pinnedLinks = Array.slice(PinnedLinks.links);
    let links = this._getMergedProviderLinks();

    let sites = new Set();
    for (let link of pinnedLinks) {
      if (link)
        sites.add(NewTabUtils.extractSite(link.url));
    }

    // Filter blocked and pinned links and duplicate base domains.
    links = links.filter(function(link) {
      let site = NewTabUtils.extractSite(link.url);
      if (site == null || sites.has(site))
        return false;
      sites.add(site);

      return !BlockedLinks.isBlocked(link) && !PinnedLinks.isPinned(link);
    });

    // Try to fill the gaps between pinned links.
    for (let i = 0; i < pinnedLinks.length && links.length; i++)
      if (!pinnedLinks[i])
        pinnedLinks[i] = links.shift();

    // Append the remaining links if any.
    if (links.length)
      pinnedLinks = pinnedLinks.concat(links);

    for (let link of pinnedLinks) {
      if (link) {
        link.baseDomain = NewTabUtils.extractSite(link.url);
      }
    }
    return pinnedLinks;
  },

  /**
   * Resets the links cache.
   */
  resetCache: function Links_resetCache() {
    for (let provider of this._providers.keys()) {
      this._providers.set(provider, null);
    }
  },

  /**
   * Compares two links.
   * @param aLink1 The first link.
   * @param aLink2 The second link.
   * @return A negative number if aLink1 is ordered before aLink2, zero if
   *         aLink1 and aLink2 have the same ordering, or a positive number if
   *         aLink1 is ordered after aLink2.
   *
   * @note compareLinks's this object is bound to Links below.
   */
  compareLinks: function Links_compareLinks(aLink1, aLink2) {
    for (let prop of this._sortProperties) {
      if (!(prop in aLink1) || !(prop in aLink2))
        throw new Error("Comparable link missing required property: " + prop);
    }
    return aLink2.frecency - aLink1.frecency ||
           aLink2.lastVisitDate - aLink1.lastVisitDate ||
           aLink1.url.localeCompare(aLink2.url);
  },

  _incrementSiteMap(map, link) {
    if (NewTabUtils.blockedLinks.isBlocked(link)) {
      // Don't count blocked URLs.
      return;
    }
    let site = NewTabUtils.extractSite(link.url);
    map.set(site, (map.get(site) || 0) + 1);
  },

  _decrementSiteMap(map, link) {
    if (NewTabUtils.blockedLinks.isBlocked(link)) {
      // Blocked URLs are not included in map.
      return;
    }
    let site = NewTabUtils.extractSite(link.url);
    let previousURLCount = map.get(site);
    if (previousURLCount === 1) {
      map.delete(site);
    } else {
      map.set(site, previousURLCount - 1);
    }
  },

  /**
    * Update the siteMap cache based on the link given and whether we need
    * to increment or decrement it. We do this by iterating over all stored providers
    * to find which provider this link already exists in. For providers that
    * have this link, we will adjust siteMap for them accordingly.
    *
    * @param aLink The link that will affect siteMap
    * @param increment A boolean for whether to increment or decrement siteMap
    */
  _adjustSiteMapAndNotify(aLink, increment = true) {
    for (let [/* provider */, cache] of this._providers) {
      // We only update siteMap if aLink is already stored in linkMap.
      if (cache.linkMap.get(aLink.url)) {
        if (increment) {
          this._incrementSiteMap(cache.siteMap, aLink);
          continue;
        }
        this._decrementSiteMap(cache.siteMap, aLink);
      }
    }
    this._callObservers("onLinkChanged", aLink);
  },

  onLinkBlocked(aLink) {
    this._adjustSiteMapAndNotify(aLink, false);
  },

  onLinkUnblocked(aLink) {
    this._adjustSiteMapAndNotify(aLink);
  },

  populateProviderCache(provider, callback) {
    if (!this._providers.has(provider)) {
      throw new Error("Can only populate provider cache for existing provider.");
    }

    return this._populateProviderCache(provider, callback, false);
  },

  /**
   * Calls getLinks on the given provider and populates our cache for it.
   * @param aProvider The provider whose cache will be populated.
   * @param aCallback The callback to call when finished.
   * @param aForce When true, populates the provider's cache even when it's
   *               already filled.
   */
  _populateProviderCache(aProvider, aCallback, aForce) {
    let cache = this._providers.get(aProvider);
    let createCache = !cache;
    if (createCache) {
      cache = {
        // Start with a resolved promise.
        populatePromise: new Promise(resolve => resolve()),
      };
      this._providers.set(aProvider, cache);
    }
    // Chain the populatePromise so that calls are effectively queued.
    cache.populatePromise = cache.populatePromise.then(() => {
      return new Promise(resolve => {
        if (!createCache && !aForce) {
          aCallback();
          resolve();
          return;
        }
        aProvider.getLinks(links => {
          // Filter out null and undefined links so we don't have to deal with
          // them in getLinks when merging links from providers.
          links = links.filter((link) => !!link);
          cache.sortedLinks = links;
          cache.siteMap = links.reduce((map, link) => {
            this._incrementSiteMap(map, link);
            return map;
          }, new Map());
          cache.linkMap = links.reduce((map, link) => {
            map.set(link.url, link);
            return map;
          }, new Map());
          aCallback();
          resolve();
        });
      });
    });
  },

  /**
   * Merges the cached lists of links from all providers whose lists are cached.
   * @return The merged list.
   */
  _getMergedProviderLinks: function Links__getMergedProviderLinks() {
    // Build a list containing a copy of each provider's sortedLinks list.
    let linkLists = [];
    for (let provider of this._providers.keys()) {
      if (!AllPages.enhanced && provider != PlacesProvider) {
        // Only show history tiles if we're not in 'enhanced' mode.
        continue;
      }
      let links = this._providers.get(provider);
      if (links && links.sortedLinks) {
        linkLists.push(links.sortedLinks.slice());
      }
    }

    return this.mergeLinkLists(linkLists);
  },

  mergeLinkLists: function Links_mergeLinkLists(linkLists) {
    if (linkLists.length == 1) {
      return linkLists[0];
    }

    function getNextLink() {
      let minLinks = null;
      for (let links of linkLists) {
        if (links.length &&
            (!minLinks || Links.compareLinks(links[0], minLinks[0]) < 0))
          minLinks = links;
      }
      return minLinks ? minLinks.shift() : null;
    }

    let finalLinks = [];
    for (let nextLink = getNextLink();
         nextLink && finalLinks.length < this.maxNumLinks;
         nextLink = getNextLink()) {
      finalLinks.push(nextLink);
    }

    return finalLinks;
  },

  /**
   * Called by a provider to notify us when a single link changes.
   * @param aProvider The provider whose link changed.
   * @param aLink The link that changed.  If the link is new, it must have all
   *              of the _sortProperties.  Otherwise, it may have as few or as
   *              many as is convenient.
   * @param aIndex The current index of the changed link in the sortedLinks
                   cache in _providers. Defaults to -1 if the provider doesn't know the index
   * @param aDeleted Boolean indicating if the provider has deleted the link.
   */
  onLinkChanged: function Links_onLinkChanged(aProvider, aLink, aIndex = -1, aDeleted = false) {
    if (!("url" in aLink))
      throw new Error("Changed links must have a url property");

    let links = this._providers.get(aProvider);
    if (!links)
      // This is not an error, it just means that between the time the provider
      // was added and the future time we call getLinks on it, it notified us of
      // a change.
      return;

    let { sortedLinks, siteMap, linkMap } = links;
    let existingLink = linkMap.get(aLink.url);
    let insertionLink = null;
    let updatePages = false;

    if (existingLink) {
      // Update our copy's position in O(lg n) by first removing it from its
      // list.  It's important to do this before modifying its properties.
      if (this._sortProperties.some(prop => prop in aLink)) {
        let idx = aIndex;
        if (idx < 0) {
          idx = this._indexOf(sortedLinks, existingLink);
        } else if (this.compareLinks(aLink, sortedLinks[idx]) != 0) {
          throw new Error("aLink should be the same as sortedLinks[idx]");
        }

        if (idx < 0) {
          throw new Error("Link should be in _sortedLinks if in _linkMap");
        }
        sortedLinks.splice(idx, 1);

        if (aDeleted) {
          updatePages = true;
          linkMap.delete(existingLink.url);
          this._decrementSiteMap(siteMap, existingLink);
        } else {
          // Update our copy's properties.
          Object.assign(existingLink, aLink);

          // Finally, reinsert our copy below.
          insertionLink = existingLink;
        }
      }
      // Update our copy's title in O(1).
      if ("title" in aLink && aLink.title != existingLink.title) {
        existingLink.title = aLink.title;
        updatePages = true;
      }
    } else if (this._sortProperties.every(prop => prop in aLink)) {
      // Before doing the O(lg n) insertion below, do an O(1) check for the
      // common case where the new link is too low-ranked to be in the list.
      if (sortedLinks.length && sortedLinks.length == aProvider.maxNumLinks) {
        let lastLink = sortedLinks[sortedLinks.length - 1];
        if (this.compareLinks(lastLink, aLink) < 0) {
          return;
        }
      }
      // Copy the link object so that changes later made to it by the caller
      // don't affect our copy.
      insertionLink = {};
      for (let prop in aLink) {
        insertionLink[prop] = aLink[prop];
      }
      linkMap.set(aLink.url, insertionLink);
      this._incrementSiteMap(siteMap, aLink);
    }

    if (insertionLink) {
      let idx = this._insertionIndexOf(sortedLinks, insertionLink);
      sortedLinks.splice(idx, 0, insertionLink);
      if (sortedLinks.length > aProvider.maxNumLinks) {
        let lastLink = sortedLinks.pop();
        linkMap.delete(lastLink.url);
        this._decrementSiteMap(siteMap, lastLink);
      }
      updatePages = true;
    }

    if (updatePages) {
      AllPages.update(null, "links-changed");
    }
  },

  /**
   * Called by a provider to notify us when many links change.
   */
  onManyLinksChanged: function Links_onManyLinksChanged(aProvider) {
    this._populateProviderCache(aProvider, () => {
      AllPages.update(null, "links-changed");
    }, true);
  },

  _indexOf: function Links__indexOf(aArray, aLink) {
    return this._binsearch(aArray, aLink, "indexOf");
  },

  _insertionIndexOf: function Links__insertionIndexOf(aArray, aLink) {
    return this._binsearch(aArray, aLink, "insertionIndexOf");
  },

  _binsearch: function Links__binsearch(aArray, aLink, aMethod) {
    return BinarySearch[aMethod](this.compareLinks, aArray, aLink);
  },

  /**
   * Implements the nsIObserver interface to get notified about browser history
   * sanitization.
   */
  observe: function Links_observe(aSubject, aTopic, aData) {
    // Make sure to update open about:newtab instances. If there are no opened
    // pages we can just wait for the next new tab to populate the cache again.
    if (AllPages.length && AllPages.enabled)
      this.populateCache(function() { AllPages.update() }, true);
    else
      this.resetCache();
  },

  _callObservers(methodName, ...args) {
    for (let obs of this._observers) {
      if (typeof(obs[methodName]) == "function") {
        try {
          obs[methodName](this, ...args);
        } catch (err) {
          Cu.reportError(err);
        }
      }
    }
  },

  /**
   * Adds a sanitization observer and turns itself into a no-op after the first
   * invokation.
   */
  _addObserver: function Links_addObserver() {
    Services.obs.addObserver(this, "browser:purge-session-history", true);
    this._addObserver = function() {};
  },

  QueryInterface: XPCOMUtils.generateQI([Ci.nsIObserver,
                                         Ci.nsISupportsWeakReference])
};

Links.compareLinks = Links.compareLinks.bind(Links);

/**
 * Singleton used to collect telemetry data.
 *
 */
var Telemetry = {
  /**
   * Initializes object.
   */
  init: function Telemetry_init() {
    Services.obs.addObserver(this, TOPIC_GATHER_TELEMETRY);
  },

  uninit: function Telemetry_uninit() {
    Services.obs.removeObserver(this, TOPIC_GATHER_TELEMETRY);
  },

  /**
   * Collects data.
   */
  _collect: function Telemetry_collect() {
    let probes = [
      { histogram: "NEWTAB_PAGE_ENABLED",
        value: AllPages.enabled },
      { histogram: "NEWTAB_PAGE_ENHANCED",
        value: AllPages.enhanced },
      { histogram: "NEWTAB_PAGE_PINNED_SITES_COUNT",
        value: PinnedLinks.links.length },
      { histogram: "NEWTAB_PAGE_BLOCKED_SITES_COUNT",
        value: Object.keys(BlockedLinks.links).length }
    ];

    probes.forEach(function Telemetry_collect_forEach(aProbe) {
      Services.telemetry.getHistogramById(aProbe.histogram)
        .add(aProbe.value);
    });
  },

  /**
   * Listens for gather telemetry topic.
   */
  observe: function Telemetry_observe(aSubject, aTopic, aData) {
    this._collect();
  }
};

/**
 * Singleton that checks if a given link should be displayed on about:newtab
 * or if we should rather not do it for security reasons. URIs that inherit
 * their caller's principal will be filtered.
 */
var LinkChecker = {
  _cache: {},

  get flags() {
    return Ci.nsIScriptSecurityManager.DISALLOW_INHERIT_PRINCIPAL |
           Ci.nsIScriptSecurityManager.DONT_REPORT_ERRORS;
  },

  checkLoadURI: function LinkChecker_checkLoadURI(aURI) {
    if (!(aURI in this._cache))
      this._cache[aURI] = this._doCheckLoadURI(aURI);

    return this._cache[aURI];
  },

  _doCheckLoadURI: function Links_doCheckLoadURI(aURI) {
    try {
      // about:newtab is currently privileged. In any case, it should be
      // possible for tiles to point to pretty much everything - but not
      // to stuff that inherits the system principal, so we check:
      let systemPrincipal = Services.scriptSecurityManager.getSystemPrincipal();
      Services.scriptSecurityManager.
        checkLoadURIStrWithPrincipal(systemPrincipal, aURI, this.flags);
      return true;
    } catch (e) {
      // We got a weird URI or one that would inherit the caller's principal.
      return false;
    }
  }
};

var ExpirationFilter = {
  init: function ExpirationFilter_init() {
    PageThumbs.addExpirationFilter(this);
  },

  filterForThumbnailExpiration:
  function ExpirationFilter_filterForThumbnailExpiration(aCallback) {
    if (!AllPages.enabled) {
      aCallback([]);
      return;
    }

    Links.populateCache(function() {
      let urls = [];

      // Add all URLs to the list that we want to keep thumbnails for.
      for (let link of Links.getLinks().slice(0, 25)) {
        if (link && link.url)
          urls.push(link.url);
      }

      aCallback(urls);
    });
  }
};

/**
 * Singleton that provides the public API of this JSM.
 */
this.NewTabUtils = {
  _initialized: false,

  /**
   * Extract a "site" from a url in a way that multiple urls of a "site" returns
   * the same "site."
   * @param aUrl Url spec string
   * @return The "site" string or null
   */
  extractSite: function Links_extractSite(url) {
    let host;
    try {
      // Note that nsIURI.asciiHost throws NS_ERROR_FAILURE for some types of
      // URIs, including jar and moz-icon URIs.
      host = Services.io.newURI(url).asciiHost;
    } catch (ex) {
      return null;
    }

    // Strip off common subdomains of the same site (e.g., www, load balancer)
    return host.replace(/^(m|mobile|www\d*)\./, "");
  },

  init: function NewTabUtils_init() {
    if (this.initWithoutProviders()) {
      PlacesProvider.init();
      Links.addProvider(PlacesProvider);
      BlockedLinks.addObserver(Links);
      BlockedLinks.addObserver(ActivityStreamLinks);
    }
  },

  initWithoutProviders: function NewTabUtils_initWithoutProviders() {
    if (!this._initialized) {
      this._initialized = true;
      ExpirationFilter.init();
      Telemetry.init();
      return true;
    }
    return false;
  },

  uninit: function NewTabUtils_uninit() {
    if (this.initialized) {
      Telemetry.uninit();
      GridPrefs.uninit();
      BlockedLinks.removeObservers();
    }
  },

  getProviderLinks(aProvider) {
    let cache = Links._providers.get(aProvider);
    if (cache && cache.sortedLinks) {
      return cache.sortedLinks;
    }
    return [];
  },

  isTopSiteGivenProvider(aSite, aProvider) {
    let cache = Links._providers.get(aProvider);
    if (cache && cache.siteMap) {
      return cache.siteMap.has(aSite);
    }
    return false;
  },

  isTopPlacesSite(aSite) {
    return this.isTopSiteGivenProvider(aSite, PlacesProvider);
  },

  /**
   * Restores all sites that have been removed from the grid.
   */
  restore: function NewTabUtils_restore() {
    Storage.clear();
    Links.resetCache();
    PinnedLinks.resetCache();
    BlockedLinks.resetCache();

    Links.populateCache(function() {
      AllPages.update();
    }, true);
  },

  /**
   * Undoes all sites that have been removed from the grid and keep the pinned
   * tabs.
   * @param aCallback the callback method.
   */
  undoAll: function NewTabUtils_undoAll(aCallback) {
    Storage.remove("blockedLinks");
    Links.resetCache();
    BlockedLinks.resetCache();
    Links.populateCache(aCallback, true);
  },

  links: Links,
  allPages: AllPages,
  linkChecker: LinkChecker,
  pinnedLinks: PinnedLinks,
  blockedLinks: BlockedLinks,
  gridPrefs: GridPrefs,
  placesProvider: PlacesProvider,
  activityStreamLinks: ActivityStreamLinks,
  activityStreamProvider: ActivityStreamProvider
};
