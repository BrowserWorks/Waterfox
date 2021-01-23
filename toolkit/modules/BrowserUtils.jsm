/* -*- mode: js; indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["BrowserUtils"];

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
ChromeUtils.defineModuleGetter(
  this,
  "PlacesUtils",
  "resource://gre/modules/PlacesUtils.jsm"
);

var BrowserUtils = {
  /**
   * Prints arguments separated by a space and appends a new line.
   */
  dumpLn(...args) {
    for (let a of args) {
      dump(a + " ");
    }
    dump("\n");
  },

  /**
   * restartApplication: Restarts the application, keeping it in
   * safe mode if it is already in safe mode.
   */
  restartApplication() {
    let cancelQuit = Cc["@mozilla.org/supports-PRBool;1"].createInstance(
      Ci.nsISupportsPRBool
    );
    Services.obs.notifyObservers(
      cancelQuit,
      "quit-application-requested",
      "restart"
    );
    if (cancelQuit.data) {
      // The quit request has been canceled.
      return false;
    }
    // if already in safe mode restart in safe mode
    if (Services.appinfo.inSafeMode) {
      Services.startup.restartInSafeMode(
        Ci.nsIAppStartup.eAttemptQuit | Ci.nsIAppStartup.eRestart
      );
      return undefined;
    }
    Services.startup.quit(
      Ci.nsIAppStartup.eAttemptQuit | Ci.nsIAppStartup.eRestart
    );
    return undefined;
  },

  /**
   * Check whether a page can be considered as 'empty', that its URI
   * reflects its origin, and that if it's loaded in a tab, that tab
   * could be considered 'empty' (e.g. like the result of opening
   * a 'blank' new tab).
   *
   * We have to do more than just check the URI, because especially
   * for things like about:blank, it is possible that the opener or
   * some other page has control over the contents of the page.
   *
   * @param {Browser} browser
   *        The browser whose page we're checking.
   * @param {nsIURI} [uri]
   *        The URI against which we're checking (the browser's currentURI
   *        if omitted).
   *
   * @return {boolean} false if the page was opened by or is controlled by
   *         arbitrary web content, unless that content corresponds with the URI.
   *         true if the page is blank and controlled by a principal matching
   *         that URI (or the system principal if the principal has no URI)
   */
  checkEmptyPageOrigin(browser, uri = browser.currentURI) {
    // If another page opened this page with e.g. window.open, this page might
    // be controlled by its opener.
    if (browser.hasContentOpener) {
      return false;
    }
    let contentPrincipal = browser.contentPrincipal;
    // Not all principals have URIs...
    if (contentPrincipal.URI) {
      // There are two special-cases involving about:blank. One is where
      // the user has manually loaded it and it got created with a null
      // principal. The other involves the case where we load
      // some other empty page in a browser and the current page is the
      // initial about:blank page (which has that as its principal, not
      // just URI in which case it could be web-based). Especially in
      // e10s, we need to tackle that case specifically to avoid race
      // conditions when updating the URL bar.
      //
      // Note that we check the documentURI here, since the currentURI on
      // the browser might have been set by SessionStore in order to
      // support switch-to-tab without having actually loaded the content
      // yet.
      let uriToCheck = browser.documentURI || uri;
      if (
        (uriToCheck.spec == "about:blank" &&
          contentPrincipal.isNullPrincipal) ||
        contentPrincipal.URI.spec == "about:blank"
      ) {
        return true;
      }
      return contentPrincipal.URI.equals(uri);
    }
    // ... so for those that don't have them, enforce that the page has the
    // system principal (this matches e.g. on about:newtab).
    return contentPrincipal.isSystemPrincipal;
  },

  /**
   * urlSecurityCheck: JavaScript wrapper for checkLoadURIWithPrincipal
   * and checkLoadURIStrWithPrincipal.
   * If |aPrincipal| is not allowed to link to |aURL|, this function throws with
   * an error message.
   *
   * @param aURL
   *        The URL a page has linked to. This could be passed either as a string
   *        or as a nsIURI object.
   * @param aPrincipal
   *        The principal of the document from which aURL came.
   * @param aFlags
   *        Flags to be passed to checkLoadURIStr. If undefined,
   *        nsIScriptSecurityManager.STANDARD will be passed.
   */
  urlSecurityCheck(aURL, aPrincipal, aFlags) {
    var secMan = Services.scriptSecurityManager;
    if (aFlags === undefined) {
      aFlags = secMan.STANDARD;
    }

    try {
      if (aURL instanceof Ci.nsIURI) {
        secMan.checkLoadURIWithPrincipal(aPrincipal, aURL, aFlags);
      } else {
        secMan.checkLoadURIStrWithPrincipal(aPrincipal, aURL, aFlags);
      }
    } catch (e) {
      let principalStr = "";
      try {
        principalStr = " from " + aPrincipal.URI.spec;
      } catch (e2) {}

      throw new Error(`Load of ${aURL + principalStr} denied.`);
    }
  },

  /**
   * Return or create a principal with the content of one, and the originAttributes
   * of an existing principal (e.g. on a docshell, where the originAttributes ought
   * not to change, that is, we should keep the userContextId, privateBrowsingId,
   * etc. the same when changing the principal).
   *
   * @param principal
   *        The principal whose content/null/system-ness we want.
   * @param existingPrincipal
   *        The principal whose originAttributes we want, usually the current
   *        principal of a docshell.
   * @return an nsIPrincipal that matches the content/null/system-ness of the first
   *         param, and the originAttributes of the second.
   */
  principalWithMatchingOA(principal, existingPrincipal) {
    // Don't care about system principals:
    if (principal.isSystemPrincipal) {
      return principal;
    }

    // If the originAttributes already match, just return the principal as-is.
    if (existingPrincipal.originSuffix == principal.originSuffix) {
      return principal;
    }

    let secMan = Services.scriptSecurityManager;
    if (principal.isContentPrincipal) {
      return secMan.createContentPrincipal(
        principal.URI,
        existingPrincipal.originAttributes
      );
    }

    if (principal.isNullPrincipal) {
      return secMan.createNullPrincipal(existingPrincipal.originAttributes);
    }
    throw new Error(
      "Can't change the originAttributes of an expanded principal!"
    );
  },

  /**
   * Constructs a new URI, using nsIIOService.
   * @param aURL The URI spec.
   * @param aOriginCharset The charset of the URI.
   * @param aBaseURI Base URI to resolve aURL, or null.
   * @return an nsIURI object based on aURL.
   *
   * @deprecated Use Services.io.newURI directly instead.
   */
  makeURI(aURL, aOriginCharset, aBaseURI) {
    return Services.io.newURI(aURL, aOriginCharset, aBaseURI);
  },

  /**
   * @deprecated Use Services.io.newFileURI directly instead.
   */
  makeFileURI(aFile) {
    return Services.io.newFileURI(aFile);
  },

  /**
   * For a given DOM element, returns its position in "screen"
   * coordinates. In a content process, the coordinates returned will
   * be relative to the left/top of the tab. In the chrome process,
   * the coordinates are relative to the user's screen.
   */
  getElementBoundingScreenRect(aElement) {
    return this.getElementBoundingRect(aElement, true);
  },

  /**
   * For a given DOM element, returns its position as an offset from the topmost
   * window. In a content process, the coordinates returned will be relative to
   * the left/top of the topmost content area. If aInScreenCoords is true,
   * screen coordinates will be returned instead.
   */
  getElementBoundingRect(aElement, aInScreenCoords) {
    let rect = aElement.getBoundingClientRect();
    let win = aElement.ownerGlobal;

    let x = rect.left,
      y = rect.top;

    // We need to compensate for any iframes that might shift things
    // over. We also need to compensate for zooming.
    let parentFrame = win.frameElement;
    while (parentFrame) {
      win = parentFrame.ownerGlobal;
      let cstyle = win.getComputedStyle(parentFrame);

      let framerect = parentFrame.getBoundingClientRect();
      x +=
        framerect.left +
        parseFloat(cstyle.borderLeftWidth) +
        parseFloat(cstyle.paddingLeft);
      y +=
        framerect.top +
        parseFloat(cstyle.borderTopWidth) +
        parseFloat(cstyle.paddingTop);

      parentFrame = win.frameElement;
    }

    if (aInScreenCoords) {
      x += win.mozInnerScreenX;
      y += win.mozInnerScreenY;
    }

    let fullZoom = win.windowUtils.fullZoom;
    rect = {
      left: x * fullZoom,
      top: y * fullZoom,
      width: rect.width * fullZoom,
      height: rect.height * fullZoom,
    };

    return rect;
  },

  onBeforeLinkTraversal(originalTarget, linkURI, linkNode, isAppTab) {
    // Don't modify non-default targets or targets that aren't in top-level app
    // tab docshells (isAppTab will be false for app tab subframes).
    if (originalTarget != "" || !isAppTab) {
      return originalTarget;
    }

    // External links from within app tabs should always open in new tabs
    // instead of replacing the app tab's page (Bug 575561)
    let linkHost;
    let docHost;
    try {
      linkHost = linkURI.host;
      docHost = linkNode.ownerDocument.documentURIObject.host;
    } catch (e) {
      // nsIURI.host can throw for non-nsStandardURL nsIURIs.
      // If we fail to get either host, just return originalTarget.
      return originalTarget;
    }

    if (docHost == linkHost) {
      return originalTarget;
    }

    // Special case: ignore "www" prefix if it is part of host string
    let [longHost, shortHost] =
      linkHost.length > docHost.length
        ? [linkHost, docHost]
        : [docHost, linkHost];
    if (longHost == "www." + shortHost) {
      return originalTarget;
    }

    return "_blank";
  },

  /**
   * Map the plugin's name to a filtered version more suitable for UI.
   *
   * @param aName The full-length name string of the plugin.
   * @return the simplified name string.
   */
  makeNicePluginName(aName) {
    if (aName == "Shockwave Flash") {
      return "Adobe Flash";
    }
    // Regex checks if aName begins with "Java" + non-letter char
    if (/^Java\W/.exec(aName)) {
      return "Java";
    }

    // Clean up the plugin name by stripping off parenthetical clauses,
    // trailing version numbers or "plugin".
    // EG, "Foo Bar (Linux) Plugin 1.23_02" --> "Foo Bar"
    // Do this by first stripping the numbers, etc. off the end, and then
    // removing "Plugin" (and then trimming to get rid of any whitespace).
    // (Otherwise, something like "Java(TM) Plug-in 1.7.0_07" gets mangled)
    let newName = aName
      .replace(/\(.*?\)/g, "")
      .replace(/[\s\d\.\-\_\(\)]+$/, "")
      .replace(/\bplug-?in\b/i, "")
      .trim();
    return newName;
  },

  /**
   * Returns true if |mimeType| is text-based, or false otherwise.
   *
   * @param mimeType
   *        The MIME type to check.
   */
  mimeTypeIsTextBased(mimeType) {
    return (
      mimeType.startsWith("text/") ||
      mimeType.endsWith("+xml") ||
      mimeType == "application/x-javascript" ||
      mimeType == "application/javascript" ||
      mimeType == "application/json" ||
      mimeType == "application/xml"
    );
  },

  /**
   * Returns true if we can show a find bar, including FAYT, for the specified
   * document location. The location must not be in a blacklist of specific
   * "about:" pages for which find is disabled.
   *
   * This can be called from the parent process or from content processes.
   */
  canFindInPage(location) {
    return (
      !location.startsWith("about:addons") &&
      !location.startsWith(
        "chrome://mozapps/content/extensions/aboutaddons.html"
      ) &&
      !location.startsWith("about:preferences")
    );
  },

  _visibleToolbarsMap: new WeakMap(),

  /**
   * Return true if any or a specific toolbar that interacts with the content
   * document is visible.
   *
   * @param  {nsIDocShell} docShell The docShell instance that a toolbar should
   *                                be interacting with
   * @param  {String}      which    Identifier of a specific toolbar
   * @return {Boolean}
   */
  isToolbarVisible(docShell, which) {
    let window = this.getRootWindow(docShell);
    if (!this._visibleToolbarsMap.has(window)) {
      return false;
    }
    let toolbars = this._visibleToolbarsMap.get(window);
    return !!toolbars && toolbars.has(which);
  },

  /**
   * Sets the --toolbarbutton-button-height CSS property on the closest
   * toolbar to the provided element. Useful if you need to vertically
   * center a position:absolute element within a toolbar that uses
   * -moz-pack-align:stretch, and thus a height which is dependant on
   * the font-size.
   *
   * @param element An element within the toolbar whose height is desired.
   */
  async setToolbarButtonHeightProperty(element) {
    let window = element.ownerGlobal;
    let dwu = window.windowUtils;
    let toolbarItem = element;
    let urlBarContainer = element.closest("#urlbar-container");
    if (urlBarContainer) {
      // The stop-reload-button, which is contained in #urlbar-container,
      // needs to use #urlbar-container to calculate the bounds.
      toolbarItem = urlBarContainer;
    }
    if (!toolbarItem) {
      return;
    }
    let bounds = dwu.getBoundsWithoutFlushing(toolbarItem);
    if (!bounds.height) {
      await window.promiseDocumentFlushed(() => {
        bounds = dwu.getBoundsWithoutFlushing(toolbarItem);
      });
    }
    if (bounds.height) {
      toolbarItem.style.setProperty(
        "--toolbarbutton-height",
        bounds.height + "px"
      );
    }
  },

  /**
   * Track whether a toolbar is visible for a given a docShell.
   *
   * @param  {nsIDocShell} docShell  The docShell instance that a toolbar should
   *                                 be interacting with
   * @param  {String}      which     Identifier of a specific toolbar
   * @param  {Boolean}     [visible] Whether the toolbar is visible. Optional,
   *                                 defaults to `true`.
   */
  trackToolbarVisibility(docShell, which, visible = true) {
    // We have to get the root window object, because XPConnect WrappedNatives
    // can't be used as WeakMap keys.
    let window = this.getRootWindow(docShell);
    let toolbars = this._visibleToolbarsMap.get(window);
    if (!toolbars) {
      toolbars = new Set();
      this._visibleToolbarsMap.set(window, toolbars);
    }
    if (!visible) {
      toolbars.delete(which);
    } else {
      toolbars.add(which);
    }
  },

  /**
   * Retrieve the root window object (i.e. the top-most content global) for a
   * specific docShell object.
   *
   * @param  {nsIDocShell} docShell
   * @return {nsIDOMWindow}
   */
  getRootWindow(docShell) {
    return docShell.browsingContext.top.window;
  },

  /**
   * Trim the selection text to a reasonable size and sanitize it to make it
   * safe for search query input.
   *
   * @param aSelection
   *        The selection text to trim.
   * @param aMaxLen
   *        The maximum string length, defaults to a reasonable size if undefined.
   * @return The trimmed selection text.
   */
  trimSelection(aSelection, aMaxLen) {
    // Selections of more than 150 characters aren't useful.
    const maxLen = Math.min(aMaxLen || 150, aSelection.length);

    if (aSelection.length > maxLen) {
      // only use the first maxLen important chars. see bug 221361
      let pattern = new RegExp("^(?:\\s*.){0," + maxLen + "}");
      pattern.test(aSelection);
      aSelection = RegExp.lastMatch;
    }

    aSelection = aSelection.trim().replace(/\s+/g, " ");

    if (aSelection.length > maxLen) {
      aSelection = aSelection.substr(0, maxLen);
    }

    return aSelection;
  },

  /**
   * Retrieve the text selection details for the given window.
   *
   * @param  aTopWindow
   *         The top window of the element containing the selection.
   * @param  aCharLen
   *         The maximum string length for the selection text.
   * @return The selection details containing the full and trimmed selection text
   *         and link details for link selections.
   */
  getSelectionDetails(aTopWindow, aCharLen) {
    let focusedWindow = {};
    let focusedElement = Services.focus.getFocusedElementForWindow(
      aTopWindow,
      true,
      focusedWindow
    );
    focusedWindow = focusedWindow.value;

    let selection = focusedWindow.getSelection();
    let selectionStr = selection.toString();
    let fullText;

    let url;
    let linkText;

    // try getting a selected text in text input.
    if (!selectionStr && focusedElement) {
      // Don't get the selection for password fields. See bug 565717.
      if (
        ChromeUtils.getClassName(focusedElement) === "HTMLTextAreaElement" ||
        (ChromeUtils.getClassName(focusedElement) === "HTMLInputElement" &&
          focusedElement.mozIsTextField(true))
      ) {
        selection = focusedElement.editor.selection;
        selectionStr = selection.toString();
      }
    }

    let collapsed = selection.isCollapsed;

    if (selectionStr) {
      // Have some text, let's figure out if it looks like a URL that isn't
      // actually a link.
      linkText = selectionStr.trim();
      if (/^(?:https?|ftp):/i.test(linkText)) {
        try {
          url = this.makeURI(linkText);
        } catch (ex) {}
      } else if (/^(?:[a-z\d-]+\.)+[a-z]+$/i.test(linkText)) {
        // Check if this could be a valid url, just missing the protocol.
        // Now let's see if this is an intentional link selection. Our guess is
        // based on whether the selection begins/ends with whitespace or is
        // preceded/followed by a non-word character.

        // selection.toString() trims trailing whitespace, so we look for
        // that explicitly in the first and last ranges.
        let beginRange = selection.getRangeAt(0);
        let delimitedAtStart = /^\s/.test(beginRange);
        if (!delimitedAtStart) {
          let container = beginRange.startContainer;
          let offset = beginRange.startOffset;
          if (container.nodeType == container.TEXT_NODE && offset > 0) {
            delimitedAtStart = /\W/.test(container.textContent[offset - 1]);
          } else {
            delimitedAtStart = true;
          }
        }

        let delimitedAtEnd = false;
        if (delimitedAtStart) {
          let endRange = selection.getRangeAt(selection.rangeCount - 1);
          delimitedAtEnd = /\s$/.test(endRange);
          if (!delimitedAtEnd) {
            let container = endRange.endContainer;
            let offset = endRange.endOffset;
            if (
              container.nodeType == container.TEXT_NODE &&
              offset < container.textContent.length
            ) {
              delimitedAtEnd = /\W/.test(container.textContent[offset]);
            } else {
              delimitedAtEnd = true;
            }
          }
        }

        if (delimitedAtStart && delimitedAtEnd) {
          try {
            url = Services.uriFixup.createFixupURI(
              linkText,
              Services.uriFixup.FIXUP_FLAG_NONE
            );
          } catch (ex) {}
        }
      }
    }

    if (selectionStr) {
      // Pass up to 16K through unmolested.  If an add-on needs more, they will
      // have to use a content script.
      fullText = selectionStr.substr(0, 16384);
      selectionStr = this.trimSelection(selectionStr, aCharLen);
    }

    if (url && !url.host) {
      url = null;
    }

    return {
      text: selectionStr,
      docSelectionIsCollapsed: collapsed,
      fullText,
      linkURL: url ? url.spec : null,
      linkText: url ? linkText : "",
    };
  },

  // Iterates through every docshell in the window and calls PermitUnload.
  canCloseWindow(window) {
    let docShell = window.docShell;
    for (let i = 0; i < docShell.childCount; ++i) {
      let childShell = docShell.getChildAt(i).QueryInterface(Ci.nsIDocShell);
      let contentViewer = childShell.contentViewer;
      if (contentViewer && !contentViewer.permitUnload()) {
        return false;
      }
    }

    return true;
  },

  /**
   * Replaces %s or %S in the provided url or postData with the given parameter,
   * acccording to the best charset for the given url.
   *
   * @return [url, postData]
   * @throws if nor url nor postData accept a param, but a param was provided.
   */
  async parseUrlAndPostData(url, postData, param) {
    let hasGETParam = /%s/i.test(url);
    let decodedPostData = postData ? unescape(postData) : "";
    let hasPOSTParam = /%s/i.test(decodedPostData);

    if (!hasGETParam && !hasPOSTParam) {
      if (param) {
        // If nor the url, nor postData contain parameters, but a parameter was
        // provided, return the original input.
        throw new Error(
          "A param was provided but there's nothing to bind it to"
        );
      }
      return [url, postData];
    }

    let charset = "";
    const re = /^(.*)\&mozcharset=([a-zA-Z][_\-a-zA-Z0-9]+)\s*$/;
    let matches = url.match(re);
    if (matches) {
      [, url, charset] = matches;
    } else {
      // Try to fetch a charset from History.
      try {
        // Will return an empty string if character-set is not found.
        let pageInfo = await PlacesUtils.history.fetch(url, {
          includeAnnotations: true,
        });
        if (pageInfo && pageInfo.annotations.has(PlacesUtils.CHARSET_ANNO)) {
          charset = pageInfo.annotations.get(PlacesUtils.CHARSET_ANNO);
        }
      } catch (ex) {
        // makeURI() throws if url is invalid.
        Cu.reportError(ex);
      }
    }

    // encodeURIComponent produces UTF-8, and cannot be used for other charsets.
    // escape() works in those cases, but it doesn't uri-encode +, @, and /.
    // Therefore we need to manually replace these ASCII characters by their
    // encodeURIComponent result, to match the behavior of nsEscape() with
    // url_XPAlphas.
    let encodedParam = "";
    if (charset && charset != "UTF-8") {
      try {
        let converter = Cc[
          "@mozilla.org/intl/scriptableunicodeconverter"
        ].createInstance(Ci.nsIScriptableUnicodeConverter);
        converter.charset = charset;
        encodedParam = converter.ConvertFromUnicode(param) + converter.Finish();
      } catch (ex) {
        encodedParam = param;
      }
      encodedParam = escape(encodedParam).replace(
        /[+@\/]+/g,
        encodeURIComponent
      );
    } else {
      // Default charset is UTF-8
      encodedParam = encodeURIComponent(param);
    }

    url = url.replace(/%s/g, encodedParam).replace(/%S/g, param);
    if (hasPOSTParam) {
      postData = decodedPostData
        .replace(/%s/g, encodedParam)
        .replace(/%S/g, param);
    }
    return [url, postData];
  },

  /**
   * Generate a document fragment for a localized string that has DOM
   * node replacements. This avoids using getFormattedString followed
   * by assigning to innerHTML. Fluent can probably replace this when
   * it is in use everywhere.
   *
   * @param {Document} doc
   * @param {String}   msg
   *                   The string to put replacements in. Fetch from
   *                   a stringbundle using getString or GetStringFromName,
   *                   or even an inserted dtd string.
   * @param {Node|String} nodesOrStrings
   *                   The replacement items. Can be a mix of Nodes
   *                   and Strings. However, for correct behaviour, the
   *                   number of items provided needs to exactly match
   *                   the number of replacement strings in the l10n string.
   * @returns {DocumentFragment}
   *                   A document fragment. In the trivial case (no
   *                   replacements), this will simply be a fragment with 1
   *                   child, a text node containing the localized string.
   */
  getLocalizedFragment(doc, msg, ...nodesOrStrings) {
    // Ensure replacement points are indexed:
    for (let i = 1; i <= nodesOrStrings.length; i++) {
      if (!msg.includes("%" + i + "$S")) {
        msg = msg.replace(/%S/, "%" + i + "$S");
      }
    }
    let numberOfInsertionPoints = msg.match(/%\d+\$S/g).length;
    if (numberOfInsertionPoints != nodesOrStrings.length) {
      Cu.reportError(
        `Message has ${numberOfInsertionPoints} insertion points, ` +
          `but got ${nodesOrStrings.length} replacement parameters!`
      );
    }

    let fragment = doc.createDocumentFragment();
    let parts = [msg];
    let insertionPoint = 1;
    for (let replacement of nodesOrStrings) {
      let insertionString = "%" + insertionPoint++ + "$S";
      let partIndex = parts.findIndex(
        part => typeof part == "string" && part.includes(insertionString)
      );
      if (partIndex == -1) {
        fragment.appendChild(doc.createTextNode(msg));
        return fragment;
      }

      if (typeof replacement == "string") {
        parts[partIndex] = parts[partIndex].replace(
          insertionString,
          replacement
        );
      } else {
        let [firstBit, lastBit] = parts[partIndex].split(insertionString);
        parts.splice(partIndex, 1, firstBit, replacement, lastBit);
      }
    }

    // Put everything in a document fragment:
    for (let part of parts) {
      if (typeof part == "string") {
        if (part) {
          fragment.appendChild(doc.createTextNode(part));
        }
      } else {
        fragment.appendChild(part);
      }
    }
    return fragment;
  },

  /**
   * Returns a Promise which resolves when the given observer topic has been
   * observed.
   *
   * @param {string} topic
   *        The topic to observe.
   * @param {function(nsISupports, string)} [test]
   *        An optional test function which, when called with the
   *        observer's subject and data, should return true if this is the
   *        expected notification, false otherwise.
   * @returns {Promise<object>}
   */
  promiseObserved(topic, test = () => true) {
    return new Promise(resolve => {
      let observer = (subject, topic, data) => {
        if (test(subject, data)) {
          Services.obs.removeObserver(observer, topic);
          resolve({ subject, data });
        }
      };
      Services.obs.addObserver(observer, topic);
    });
  },

  removeSingleTrailingSlashFromURL(aURL) {
    // remove single trailing slash for http/https/ftp URLs
    return aURL.replace(/^((?:http|https|ftp):\/\/[^/]+)\/$/, "$1");
  },

  /**
   * Returns a URL which has been trimmed by removing 'http://' and any
   * trailing slash (in http/https/ftp urls).
   * Note that a trimmed url may not load the same page as the original url, so
   * before loading it, it must be passed through URIFixup, to check trimming
   * doesn't change its destination. We don't run the URIFixup check here,
   * because trimURL is in the page load path (see onLocationChange), so it
   * must be fast and simple.
   *
   * @param {string} aURL The URL to trim.
   * @returns {string} The trimmed string.
   */
  get trimURLProtocol() {
    return "http://";
  },
  trimURL(aURL) {
    let url = this.removeSingleTrailingSlashFromURL(aURL);
    // Remove "http://" prefix.
    return url.startsWith(this.trimURLProtocol)
      ? url.substring(this.trimURLProtocol.length)
      : url;
  },

  recordSiteOriginTelemetry(aWindows, aIsGeckoView) {
    Services.tm.idleDispatchToMainThread(() => {
      this._recordSiteOriginTelemetry(aWindows, aIsGeckoView);
    });
  },

  _recordSiteOriginTelemetry(aWindows, aIsGeckoView) {
    let currentTime = Date.now();

    // default is 5 minutes
    if (!this.min_interval) {
      this.min_interval = Services.prefs.getIntPref(
        "telemetry.number_of_site_origin.min_interval",
        300000
      );
    }

    // Discard the first load because most of the time the first load only has 1
    // tab and 1 window open, so it is useless to report it.
    if (
      !this._lastRecordSiteOrigin ||
      currentTime < this._lastRecordSiteOrigin + this.min_interval
    ) {
      if (!this._lastRecordSiteOrigin) {
        this._lastRecordSiteOrigin = currentTime;
      }
      return;
    }

    this._lastRecordSiteOrigin = currentTime;

    // Geckoview and Desktop work differently. On desktop, aBrowser objects
    // holds an array of tabs which we can use to get the <browser> objects.
    // In Geckoview, it is apps' responsibility to keep track of the tabs, so
    // there isn't an easy way for us to get the tabs.
    let tabs = [];
    if (aIsGeckoView) {
      // To get all active windows; Each tab has its own window
      tabs = aWindows;
    } else {
      for (const win of aWindows) {
        tabs = tabs.concat(win.gBrowser.tabs);
      }
    }

    let topLevelBC = [];

    for (const tab of tabs) {
      let browser;
      if (aIsGeckoView) {
        browser = tab.browser;
      } else {
        browser = tab.linkedBrowser;
      }

      if (browser.browsingContext) {
        // This is the top level browsingContext
        topLevelBC.push(browser.browsingContext);
      }
    }

    const count = CanonicalBrowsingContext.countSiteOrigins(topLevelBC);

    Services.telemetry
      .getHistogramById("FX_NUMBER_OF_UNIQUE_SITE_ORIGINS_ALL_TABS")
      .add(count);
  },

  /**
   * Converts a property bag to object.
   * @param {nsIPropertyBag} bag - The property bag to convert
   * @returns {Object} - The object representation of the nsIPropertyBag
   */
  propBagToObject(bag) {
    function toValue(property) {
      if (typeof property != "object") {
        return property;
      }
      if (Array.isArray(property)) {
        return property.map(this.toValue, this);
      }
      if (property && property instanceof Ci.nsIPropertyBag) {
        return this.propBagToObject(property);
      }
      return property;
    }
    if (!(bag instanceof Ci.nsIPropertyBag)) {
      throw new TypeError("Not a property bag");
    }
    let result = {};
    for (let { name, value: property } of bag.enumerator) {
      let value = toValue(property);
      result[name] = value;
    }
    return result;
  },

  /**
   * Converts an object to a property bag.
   * @param {Object} obj - The object to convert.
   * @returns {nsIPropertyBag} - The property bag representation of the object.
   */
  objectToPropBag(obj) {
    function fromValue(value) {
      if (typeof value == "function") {
        return null; // Emulating the behavior of JSON.stringify with functions
      }
      if (Array.isArray(value)) {
        return value.map(this.fromValue, this);
      }
      if (value == null || typeof value != "object") {
        // Auto-converted to nsIVariant
        return value;
      }
      return this.objectToPropBag(value);
    }

    if (obj == null || typeof obj != "object") {
      throw new TypeError("Invalid object: " + obj);
    }
    let bag = Cc["@mozilla.org/hash-property-bag;1"].createInstance(
      Ci.nsIWritablePropertyBag
    );
    for (let k of Object.keys(obj)) {
      let value = fromValue(obj[k]);
      bag.setProperty(k, value);
    }
    return bag;
  },
};
