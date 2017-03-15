/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this file,
* You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["SessionHistory"];

const Cu = Components.utils;
const Cc = Components.classes;
const Ci = Components.interfaces;

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "Utils",
  "resource://gre/modules/sessionstore/Utils.jsm");

function debug(msg) {
  Services.console.logStringMessage("SessionHistory: " + msg);
}

/**
 * The external API exported by this module.
 */
this.SessionHistory = Object.freeze({
  isEmpty: function (docShell) {
    return SessionHistoryInternal.isEmpty(docShell);
  },

  collect: function (docShell) {
    return SessionHistoryInternal.collect(docShell);
  },

  restore: function (docShell, tabData) {
    SessionHistoryInternal.restore(docShell, tabData);
  }
});

/**
 * The internal API for the SessionHistory module.
 */
var SessionHistoryInternal = {
  /**
   * Returns whether the given docShell's session history is empty.
   *
   * @param docShell
   *        The docShell that owns the session history.
   */
  isEmpty: function (docShell) {
    let webNavigation = docShell.QueryInterface(Ci.nsIWebNavigation);
    let history = webNavigation.sessionHistory;
    if (!webNavigation.currentURI) {
      return true;
    }
    let uri = webNavigation.currentURI.spec;
    return uri == "about:blank" && history.count == 0;
  },

  /**
   * Collects session history data for a given docShell.
   *
   * @param docShell
   *        The docShell that owns the session history.
   */
  collect: function (docShell) {
    let loadContext = docShell.QueryInterface(Ci.nsILoadContext);
    let webNavigation = docShell.QueryInterface(Ci.nsIWebNavigation);
    let history = webNavigation.sessionHistory.QueryInterface(Ci.nsISHistoryInternal);

    let data = {entries: [], userContextId: loadContext.originAttributes.userContextId };

    if (history && history.count > 0) {
      // Loop over the transaction linked list directly so we can get the
      // persist property for each transaction.
      for (let txn = history.rootTransaction; txn; txn = txn.next) {
        let entry = this.serializeEntry(txn.sHEntry);
        entry.persist = txn.persist;
        data.entries.push(entry);
      }

      // Ensure the index isn't out of bounds if an exception was thrown above.
      data.index = Math.min(history.index + 1, data.entries.length);
    }

    // If either the session history isn't available yet or doesn't have any
    // valid entries, make sure we at least include the current page.
    if (data.entries.length == 0) {
      let uri = webNavigation.currentURI.spec;
      let body = webNavigation.document.body;
      // We landed here because the history is inaccessible or there are no
      // history entries. In that case we should at least record the docShell's
      // current URL as a single history entry. If the URL is not about:blank
      // or it's a blank tab that was modified (like a custom newtab page),
      // record it. For about:blank we explicitly want an empty array without
      // an 'index' property to denote that there are no history entries.
      if (uri != "about:blank" || (body && body.hasChildNodes())) {
        data.entries.push({ url: uri });
        data.index = 1;
      }
    }

    return data;
  },

  /**
   * Get an object that is a serialized representation of a History entry.
   *
   * @param shEntry
   *        nsISHEntry instance
   * @return object
   */
  serializeEntry: function (shEntry) {
    let entry = { url: shEntry.URI.spec };

    // Save some bytes and don't include the title property
    // if that's identical to the current entry's URL.
    if (shEntry.title && shEntry.title != entry.url) {
      entry.title = shEntry.title;
    }
    if (shEntry.isSubFrame) {
      entry.subframe = true;
    }

    entry.charset = shEntry.URI.originCharset;

    let cacheKey = shEntry.cacheKey;
    if (cacheKey && cacheKey instanceof Ci.nsISupportsPRUint32 &&
        cacheKey.data != 0) {
      // XXXbz would be better to have cache keys implement
      // nsISerializable or something.
      entry.cacheKey = cacheKey.data;
    }
    entry.ID = shEntry.ID;
    entry.docshellID = shEntry.docshellID;

    // We will include the property only if it's truthy to save a couple of
    // bytes when the resulting object is stringified and saved to disk.
    if (shEntry.referrerURI) {
      entry.referrer = shEntry.referrerURI.spec;
      entry.referrerPolicy = shEntry.referrerPolicy;
    }

    if (shEntry.originalURI) {
      entry.originalURI = shEntry.originalURI.spec;
    }

    if (shEntry.loadReplace) {
      entry.loadReplace = shEntry.loadReplace;
    }

    if (shEntry.srcdocData)
      entry.srcdocData = shEntry.srcdocData;

    if (shEntry.isSrcdocEntry)
      entry.isSrcdocEntry = shEntry.isSrcdocEntry;

    if (shEntry.baseURI)
      entry.baseURI = shEntry.baseURI.spec;

    if (shEntry.contentType)
      entry.contentType = shEntry.contentType;

    if (shEntry.scrollRestorationIsManual) {
      entry.scrollRestorationIsManual = true;
    } else {
      let x = {}, y = {};
      shEntry.getScrollPosition(x, y);
      if (x.value != 0 || y.value != 0)
        entry.scroll = x.value + "," + y.value;
    }

    // Collect triggeringPrincipal data for the current history entry.
    // Please note that before Bug 1297338 there was no concept of a
    // principalToInherit. To remain backward/forward compatible we
    // serialize the principalToInherit as triggeringPrincipal_b64.
    // Once principalToInherit is well established (within FF55)
    // we can update this code, remove triggeringPrincipal_b64 and
    // just keep triggeringPrincipal_base64 as well as
    // principalToInherit_base64;  see Bug 1301666.
    if (shEntry.principalToInherit) {
      try {
        let principalToInherit = Utils.serializePrincipal(shEntry.principalToInherit);
        if (principalToInherit) {
          entry.triggeringPrincipal_b64 = principalToInherit;
          entry.principalToInherit_base64 = principalToInherit;
        }
      } catch (e) {
        debug(e);
      }
    }

    if (shEntry.triggeringPrincipal) {
      try {
        let triggeringPrincipal = Utils.serializePrincipal(shEntry.triggeringPrincipal);
        if (triggeringPrincipal) {
          entry.triggeringPrincipal_base64 = triggeringPrincipal;
        }
      } catch (e) {
        debug(e);
      }
    }

    entry.docIdentifier = shEntry.BFCacheEntry.ID;

    if (shEntry.stateData != null) {
      entry.structuredCloneState = shEntry.stateData.getDataAsBase64();
      entry.structuredCloneVersion = shEntry.stateData.formatVersion;
    }

    if (!(shEntry instanceof Ci.nsISHContainer)) {
      return entry;
    }

    if (shEntry.childCount > 0 && !shEntry.hasDynamicallyAddedChild()) {
      let children = [];
      for (let i = 0; i < shEntry.childCount; i++) {
        let child = shEntry.GetChildAt(i);

        if (child) {
          // Don't try to restore framesets containing wyciwyg URLs.
          // (cf. bug 424689 and bug 450595)
          if (child.URI.schemeIs("wyciwyg")) {
            children.length = 0;
            break;
          }

          children.push(this.serializeEntry(child));
        }
      }

      if (children.length) {
        entry.children = children;
      }
    }

    return entry;
  },

  /**
   * Restores session history data for a given docShell.
   *
   * @param docShell
   *        The docShell that owns the session history.
   * @param tabData
   *        The tabdata including all history entries.
   */
  restore: function (docShell, tabData) {
    let webNavigation = docShell.QueryInterface(Ci.nsIWebNavigation);
    let history = webNavigation.sessionHistory;
    if (history.count > 0) {
      history.PurgeHistory(history.count);
    }
    history.QueryInterface(Ci.nsISHistoryInternal);

    let idMap = { used: {} };
    let docIdentMap = {};
    for (let i = 0; i < tabData.entries.length; i++) {
      let entry = tabData.entries[i];
      //XXXzpao Wallpaper patch for bug 514751
      if (!entry.url)
        continue;
      let persist = "persist" in entry ? entry.persist : true;
      history.addEntry(this.deserializeEntry(entry, idMap, docIdentMap), persist);
    }

    // Select the right history entry.
    let index = tabData.index - 1;
    if (index < history.count && history.index != index) {
      history.getEntryAtIndex(index, true);
    }
  },

  /**
   * Expands serialized history data into a session-history-entry instance.
   *
   * @param entry
   *        Object containing serialized history data for a URL
   * @param idMap
   *        Hash for ensuring unique frame IDs
   * @param docIdentMap
   *        Hash to ensure reuse of BFCache entries
   * @returns nsISHEntry
   */
  deserializeEntry: function (entry, idMap, docIdentMap) {

    var shEntry = Cc["@mozilla.org/browser/session-history-entry;1"].
                  createInstance(Ci.nsISHEntry);

    shEntry.setURI(Utils.makeURI(entry.url, entry.charset));
    shEntry.setTitle(entry.title || entry.url);
    if (entry.subframe)
      shEntry.setIsSubFrame(entry.subframe || false);
    shEntry.loadType = Ci.nsIDocShellLoadInfo.loadHistory;
    if (entry.contentType)
      shEntry.contentType = entry.contentType;
    if (entry.referrer) {
      shEntry.referrerURI = Utils.makeURI(entry.referrer);
      shEntry.referrerPolicy = entry.referrerPolicy;
    }
    if (entry.originalURI) {
      shEntry.originalURI = Utils.makeURI(entry.originalURI);
    }
    if (entry.loadReplace) {
      shEntry.loadReplace = entry.loadReplace;
    }
    if (entry.isSrcdocEntry)
      shEntry.srcdocData = entry.srcdocData;
    if (entry.baseURI)
      shEntry.baseURI = Utils.makeURI(entry.baseURI);

    if (entry.cacheKey) {
      var cacheKey = Cc["@mozilla.org/supports-PRUint32;1"].
                     createInstance(Ci.nsISupportsPRUint32);
      cacheKey.data = entry.cacheKey;
      shEntry.cacheKey = cacheKey;
    }

    if (entry.ID) {
      // get a new unique ID for this frame (since the one from the last
      // start might already be in use)
      var id = idMap[entry.ID] || 0;
      if (!id) {
        for (id = Date.now(); id in idMap.used; id++);
        idMap[entry.ID] = id;
        idMap.used[id] = true;
      }
      shEntry.ID = id;
    }

    if (entry.docshellID)
      shEntry.docshellID = entry.docshellID;

    if (entry.structuredCloneState && entry.structuredCloneVersion) {
      shEntry.stateData =
        Cc["@mozilla.org/docshell/structured-clone-container;1"].
        createInstance(Ci.nsIStructuredCloneContainer);

      shEntry.stateData.initFromBase64(entry.structuredCloneState,
                                       entry.structuredCloneVersion);
    }

    if (entry.scrollRestorationIsManual) {
      shEntry.scrollRestorationIsManual = true;
    } else if (entry.scroll) {
      var scrollPos = (entry.scroll || "0,0").split(",");
      scrollPos = [parseInt(scrollPos[0]) || 0, parseInt(scrollPos[1]) || 0];
      shEntry.setScrollPosition(scrollPos[0], scrollPos[1]);
    }

    let childDocIdents = {};
    if (entry.docIdentifier) {
      // If we have a serialized document identifier, try to find an SHEntry
      // which matches that doc identifier and adopt that SHEntry's
      // BFCacheEntry.  If we don't find a match, insert shEntry as the match
      // for the document identifier.
      let matchingEntry = docIdentMap[entry.docIdentifier];
      if (!matchingEntry) {
        matchingEntry = {shEntry: shEntry, childDocIdents: childDocIdents};
        docIdentMap[entry.docIdentifier] = matchingEntry;
      }
      else {
        shEntry.adoptBFCacheEntry(matchingEntry.shEntry);
        childDocIdents = matchingEntry.childDocIdents;
      }
    }

    // The field entry.owner_b64 got renamed to entry.triggeringPricipal_b64 in
    // Bug 1286472. To remain backward compatible we still have to support that
    // field for a few cycles before we can remove it within Bug 1289785.
    if (entry.owner_b64) {
      entry.triggeringPricipal_b64 = entry.owner_b64;
      delete entry.owner_b64;
    }

    // Before introducing the concept of principalToInherit we only had
    // a triggeringPrincipal within every entry which basically is the
    // equivalent of the new principalToInherit. To avoid compatibility
    // issues, we first check if the entry has entries for
    // triggeringPrincipal_base64 and principalToInherit_base64. If not
    // we fall back to using the principalToInherit (which is stored
    // as triggeringPrincipal_b64) as the triggeringPrincipal and
    // the principalToInherit.
    // FF55 will remove the triggeringPrincipal_b64, see Bug 1301666.
    if (entry.triggeringPrincipal_base64 || entry.principalToInherit_base64) {
      if (entry.triggeringPrincipal_base64) {
        try {
          shEntry.triggeringPrincipal =
            Utils.deserializePrincipal(entry.triggeringPrincipal_base64);
        } catch (e) {
          debug(e);
        }
      }
      if (entry.principalToInherit_base64) {
        try {
          shEntry.principalToInherit =
            Utils.deserializePrincipal(entry.principalToInherit_base64);
        } catch (e) {
          debug(e);
        }
      }
    } else if (entry.triggeringPrincipal_b64) {
      try {
        shEntry.triggeringPrincipal = Utils.deserializePrincipal(entry.triggeringPrincipal_b64);
        shEntry.principalToInherit = shEntry.triggeringPrincipal;
      }
      catch (e) {
        debug(e);
      }
    }

    if (entry.children && shEntry instanceof Ci.nsISHContainer) {
      for (var i = 0; i < entry.children.length; i++) {
        //XXXzpao Wallpaper patch for bug 514751
        if (!entry.children[i].url)
          continue;

        // We're getting sessionrestore.js files with a cycle in the
        // doc-identifier graph, likely due to bug 698656.  (That is, we have
        // an entry where doc identifier A is an ancestor of doc identifier B,
        // and another entry where doc identifier B is an ancestor of A.)
        //
        // If we were to respect these doc identifiers, we'd create a cycle in
        // the SHEntries themselves, which causes the docshell to loop forever
        // when it looks for the root SHEntry.
        //
        // So as a hack to fix this, we restrict the scope of a doc identifier
        // to be a node's siblings and cousins, and pass childDocIdents, not
        // aDocIdents, to _deserializeHistoryEntry.  That is, we say that two
        // SHEntries with the same doc identifier have the same document iff
        // they have the same parent or their parents have the same document.

        shEntry.AddChild(this.deserializeEntry(entry.children[i], idMap,
                                               childDocIdents), i);
      }
    }

    return shEntry;
  },

};
