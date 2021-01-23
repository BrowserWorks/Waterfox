/*
 * LICENSE
 *
 * POCKET MARKS
 *
 * Notwithstanding the permitted uses of the Software (as defined below) pursuant to the license set forth below, "Pocket," "Read It Later" and the Pocket icon and logos (collectively, the “Pocket Marks”) are registered and common law trademarks of Read It Later, Inc. This means that, while you have considerable freedom to redistribute and modify the Software, there are tight restrictions on your ability to use the Pocket Marks. This license does not grant you any rights to use the Pocket Marks except as they are embodied in the Software.
 *
 * ---
 *
 * SOFTWARE
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/*
 * Pocket UI module
 *
 * Handles interactions with Pocket buttons, panels and menus.
 *
 */

// TODO : Get the toolbar icons from Firefox's build (Nikki needs to give us a red saved icon)
// TODO : [needs clarificaiton from Fx] Firefox's plan was to hide Pocket from context menus until the user logs in. Now that it's an extension I'm wondering if we still need to do this.
// TODO : [needs clarificaiton from Fx] Reader mode (might be a something they need to do since it's in html, need to investigate their code)
// TODO : [needs clarificaiton from Fx] Move prefs within pktApi.s to sqlite or a local file so it's not editable (and is safer)
// TODO : [nice to have] - Immediately save, buffer the actions in a local queue and send (so it works offline, works like our native extensions)

/* eslint-disable no-shadow */
/* eslint-env mozilla/browser-window */

ChromeUtils.defineModuleGetter(
  this,
  "PrivateBrowsingUtils",
  "resource://gre/modules/PrivateBrowsingUtils.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "ReaderMode",
  "resource://gre/modules/ReaderMode.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "pktApi",
  "chrome://pocket/content/pktApi.jsm"
);

var pktUI = (function() {
  // -- Initialization (on startup and new windows) -- //

  // Init panel id at 0. The first actual panel id will have the number 1 so
  // in case at some point any panel has the id 0 we know there is something
  // wrong
  var _panelId = 0;

  var overflowMenuWidth = 230;
  var overflowMenuHeight = 475;
  var savePanelWidth = 350;
  var savePanelHeights = { collapsed: 153, expanded: 272 };

  // -- Communication to API -- //

  /**
   * Either save or attempt to log the user in
   */
  function tryToSaveCurrentPage() {
    tryToSaveUrl(getCurrentUrl(), getCurrentTitle());
  }

  function tryToSaveUrl(url, title) {
    // If the user is logged in, go ahead and save the current page
    if (pktApi.isUserLoggedIn()) {
      saveAndShowConfirmation(url, title);
      return;
    }

    // If the user is not logged in, show the logged-out state to prompt them to authenticate
    showSignUp();
  }

  // -- Panel UI -- //

  /**
   * Show the sign-up panel
   */
  function showSignUp() {
    // AB test: Direct logged-out users to tab vs panel
    if (pktApi.getSignupPanelTabTestVariant() == "v2") {
      let site = Services.prefs.getCharPref("extensions.pocket.site");
      openTabWithUrl(
        "https://" +
          site +
          "/firefox_learnmore?s=ffi&t=autoredirect&tv=page_learnmore&src=ff_ext",
        Services.scriptSecurityManager.createNullPrincipal({}),
        null
      );

      // force the panel closed before it opens
      getPanel().hidePopup();

      return;
    }

    // Control: Show panel as normal
    getFirefoxAccountSignedInUser(function(userdata) {
      var fxasignedin =
        typeof userdata == "object" && userdata !== null ? "1" : "0";
      var startheight = 490;
      var inOverflowMenu = isInOverflowMenu();
      var controlvariant = pktApi.getSignupPanelTabTestVariant() == "control";

      if (inOverflowMenu) {
        startheight = overflowMenuHeight;
      } else {
        startheight = 460;
        if (fxasignedin == "1") {
          startheight = 406;
        }
      }
      if (!controlvariant) {
        startheight = 427;
      }
      var variant;
      if (inOverflowMenu) {
        variant = "overflow";
      } else {
        variant = "storyboard_lm";
      }

      showPanel(
        "about:pocket-signup?pockethost=" +
          Services.prefs.getCharPref("extensions.pocket.site") +
          "&fxasignedin=" +
          fxasignedin +
          "&variant=" +
          variant +
          "&controlvariant=" +
          controlvariant +
          "&inoverflowmenu=" +
          inOverflowMenu +
          "&locale=" +
          getUILocale(),
        {
          width: inOverflowMenu ? overflowMenuWidth : 300,
          height: startheight,
        }
      );
    });
  }

  /**
   * Show the logged-out state / sign-up panel
   */
  function saveAndShowConfirmation(url, title) {
    // Validate input parameter
    if (typeof url !== "undefined" && url.startsWith("about:reader?url=")) {
      url = ReaderMode.getOriginalUrl(url);
    }

    var isValidURL =
      typeof url !== "undefined" &&
      (url.startsWith("http") || url.startsWith("https"));

    var inOverflowMenu = isInOverflowMenu();
    var startheight =
      pktApi.isPremiumUser() && isValidURL
        ? savePanelHeights.expanded
        : savePanelHeights.collapsed;
    if (inOverflowMenu) {
      startheight = overflowMenuHeight;
    }

    getFirefoxAccountSignedInUser(function(userdata) {
      var panelId = showPanel(
        "about:pocket-saved?pockethost=" +
          Services.prefs.getCharPref("extensions.pocket.site") +
          "&premiumStatus=" +
          (pktApi.isPremiumUser() ? "1" : "0") +
          "&fxasignedin=" +
          (typeof userdata == "object" && userdata !== null ? "1" : "0") +
          "&inoverflowmenu=" +
          inOverflowMenu +
          "&locale=" +
          getUILocale(),
        {
          onShow() {
            var saveLinkMessageId = "saveLink";
            getPanelFrame().setAttribute("itemAdded", "false");

            // Send error message for invalid url
            if (!isValidURL) {
              // TODO: Pass key for localized error in error object
              let error = {
                message: "Only links can be saved",
                localizedKey: "onlylinkssaved",
              };
              pktUIMessaging.sendErrorMessageToPanel(
                panelId,
                saveLinkMessageId,
                error
              );
              return;
            }

            // Check online state
            if (!navigator.onLine) {
              // TODO: Pass key for localized error in error object
              let error = {
                message:
                  "You must be connected to the Internet in order to save to Pocket. Please connect to the Internet and try again.",
              };
              pktUIMessaging.sendErrorMessageToPanel(
                panelId,
                saveLinkMessageId,
                error
              );
              return;
            }

            // Add url
            var options = {
              success(data, request) {
                var item = data.item;
                var ho2 = data.ho2;
                var accountState = data.account_state;
                var displayName = data.display_name;
                var successResponse = {
                  status: "success",
                  accountState,
                  displayName,
                  item,
                  ho2,
                };
                pktUIMessaging.sendMessageToPanel(
                  panelId,
                  saveLinkMessageId,
                  successResponse
                );
                getPanelFrame().setAttribute("itemAdded", "true");
              },
              error(error, request) {
                // If user is not authorized show singup page
                if (request.status === 401) {
                  showSignUp();
                  return;
                }

                // If there is no error message in the error use a
                // complete catch-all
                var errorMessage =
                  error.message ||
                  "There was an error when trying to save to Pocket.";
                var panelError = { message: errorMessage };

                // Send error message to panel
                pktUIMessaging.sendErrorMessageToPanel(
                  panelId,
                  saveLinkMessageId,
                  panelError
                );
              },
            };

            // Add title if given
            if (typeof title !== "undefined") {
              options.title = title;
            }

            // Send the link
            pktApi.addLink(url, options);
          },
          width: inOverflowMenu ? overflowMenuWidth : savePanelWidth,
          height: startheight,
        }
      );
    });
  }

  /**
   * Open a generic panel
   */
  function showPanel(url, options) {
    // Add new panel id
    _panelId += 1;
    url += "&panelId=" + _panelId;

    // We don't have to hide and show the panel again if it's already shown
    // as if the user tries to click again on the toolbar button the overlay
    // will close instead of the button will be clicked
    var iframe = getPanelFrame();
    options.onShow = options.onShow || (() => {});

    // Register event handlers
    registerEventMessages();

    // Load the iframe
    iframe.setAttribute("src", url);

    if (
      iframe.contentDocument &&
      iframe.contentDocument.readyState == "complete" &&
      iframe.contentDocument.documentURI != "about:blank"
    ) {
      options.onShow();
    } else {
      // iframe didn't load yet. This seems to always be the case when in
      // the toolbar panel, but never the case for a subview.
      // XXX this only being fired when it's a _capturing_ listener!
      iframe.addEventListener("load", options.onShow, {
        once: true,
        capture: true,
      });
    }

    resizePanel({
      width: options.width,
      height: options.height,
    });
    return _panelId;
  }

  /**
   * Resize the panel
   * options = {
   *  width: ,
   *  height: ,
   *  animate [default false]
   * }
   */
  function resizePanel(options) {
    var iframe = getPanelFrame();

    // Set an explicit size, panel will adapt.
    iframe.style.width = options.width + "px";
    iframe.style.height = options.height + "px";
  }

  /**
   * Register all of the messages needed for the panels
   */
  function registerEventMessages() {
    var iframe = getPanelFrame();

    // Only register the messages once
    var didInitAttributeKey = "did_init";
    var didInitMessageListener = iframe.getAttribute(didInitAttributeKey);
    if (
      typeof didInitMessageListener !== "undefined" &&
      didInitMessageListener == 1
    ) {
      return;
    }
    iframe.setAttribute(didInitAttributeKey, 1);

    // When the panel is displayed it generated an event called
    // "show": we will listen for that event and when it happens,
    // send our own "show" event to the panel's script, so the
    // script can prepare the panel for display.
    var _showMessageId = "show";
    pktUIMessaging.addMessageListener(iframe, _showMessageId, function(
      panelId,
      data
    ) {
      // Let panel know that it is ready
      pktUIMessaging.sendMessageToPanel(panelId, _showMessageId);
    });

    // Open a new tab with a given url
    var _openTabWithUrlMessageId = "openTabWithUrl";
    pktUIMessaging.addMessageListener(
      iframe,
      _openTabWithUrlMessageId,
      function(panelId, data, contentPrincipal, csp) {
        try {
          urlSecurityCheck(
            data.url,
            contentPrincipal,
            Services.scriptSecurityManager.DISALLOW_INHERIT_PRINCIPAL
          );
        } catch (ex) {
          return;
        }

        var url = data.url;
        openTabWithUrl(url, contentPrincipal, csp);
        pktUIMessaging.sendResponseMessageToPanel(
          panelId,
          _openTabWithUrlMessageId,
          url
        );
      }
    );

    // Close the panel
    var _closeMessageId = "close";
    pktUIMessaging.addMessageListener(iframe, _closeMessageId, function(
      panelId,
      data
    ) {
      getPanel().hidePopup();
    });

    // Send the current url to the panel
    var _getCurrentURLMessageId = "getCurrentURL";
    pktUIMessaging.addMessageListener(iframe, _getCurrentURLMessageId, function(
      panelId,
      data
    ) {
      pktUIMessaging.sendResponseMessageToPanel(
        panelId,
        _getCurrentURLMessageId,
        getCurrentUrl()
      );
    });

    // Get article info
    var _getArticleInfoMessageId = "getArticleInfo";
    pktUIMessaging.addMessageListener(
      iframe,
      _getArticleInfoMessageId,
      function(panelId, data) {
        pktApi.getArticleInfo(getCurrentUrl(), {
          success(res, req) {
            pktUIMessaging.sendResponseMessageToPanel(
              panelId,
              _getArticleInfoMessageId,
              res
            );
          },
          error(err, req) {
            err.fallback_title = getCurrentTitle();
            err.fallback_domain = new URL(getCurrentUrl()).hostname;
            pktUIMessaging.sendResponseMessageToPanel(
              panelId,
              _getArticleInfoMessageId,
              err
            );
          },
        });
      }
    );

    // getMobileDownload
    var _getMobileDownloadMessageId = "getMobileDownload";
    pktUIMessaging.addMessageListener(
      iframe,
      _getMobileDownloadMessageId,
      function(panelId, data) {
        pktApi.getMobileDownload({
          success(res, req) {
            pktUIMessaging.sendResponseMessageToPanel(
              panelId,
              _getMobileDownloadMessageId,
              res
            );
          },
          error(err, req) {
            pktUIMessaging.sendResponseMessageToPanel(
              panelId,
              _getMobileDownloadMessageId,
              err
            );
          },
        });
      }
    );

    var _resizePanelMessageId = "resizePanel";
    pktUIMessaging.addMessageListener(iframe, _resizePanelMessageId, function(
      panelId,
      data
    ) {
      resizePanel(data);
    });

    // Callback post initialization to tell background script that panel is "ready" for communication.
    pktUIMessaging.addMessageListener(iframe, "listenerReady", function(
      panelId,
      data
    ) {});

    pktUIMessaging.addMessageListener(iframe, "collapseSavePanel", function(
      panelId,
      data
    ) {
      if (!pktApi.isPremiumUser() && !isInOverflowMenu()) {
        resizePanel({
          width: savePanelWidth,
          height: savePanelHeights.collapsed,
        });
      }
    });

    pktUIMessaging.addMessageListener(iframe, "expandSavePanel", function(
      panelId,
      data
    ) {
      if (!isInOverflowMenu()) {
        resizePanel({
          width: savePanelWidth,
          height: savePanelHeights.expanded,
        });
      }
    });

    // Ask for recently accessed/used tags for auto complete
    var _getTagsMessageId = "getTags";
    pktUIMessaging.addMessageListener(iframe, _getTagsMessageId, function(
      panelId,
      data
    ) {
      pktApi.getTags(function(tags, usedTags) {
        pktUIMessaging.sendResponseMessageToPanel(panelId, _getTagsMessageId, {
          tags,
          usedTags,
        });
      });
    });

    // Ask for suggested tags based on passed url
    var _getSuggestedTagsMessageId = "getSuggestedTags";
    pktUIMessaging.addMessageListener(
      iframe,
      _getSuggestedTagsMessageId,
      function(panelId, data) {
        pktApi.getSuggestedTagsForURL(data.url, {
          success(data, response) {
            var suggestedTags = data.suggested_tags;
            var successResponse = {
              status: "success",
              value: {
                suggestedTags,
              },
            };
            pktUIMessaging.sendResponseMessageToPanel(
              panelId,
              _getSuggestedTagsMessageId,
              successResponse
            );
          },
          error(error, response) {
            pktUIMessaging.sendErrorResponseMessageToPanel(
              panelId,
              _getSuggestedTagsMessageId,
              error
            );
          },
        });
      }
    );

    // Pass url and array list of tags, add to existing save item accordingly
    var _addTagsMessageId = "addTags";
    pktUIMessaging.addMessageListener(iframe, _addTagsMessageId, function(
      panelId,
      data
    ) {
      pktApi.addTagsToURL(data.url, data.tags, {
        success(data, response) {
          var successResponse = { status: "success" };
          pktUIMessaging.sendResponseMessageToPanel(
            panelId,
            _addTagsMessageId,
            successResponse
          );
        },
        error(error, response) {
          pktUIMessaging.sendErrorResponseMessageToPanel(
            panelId,
            _addTagsMessageId,
            error
          );
        },
      });
    });

    // Based on clicking "remove page" CTA, and passed unique item id, remove the item
    var _deleteItemMessageId = "deleteItem";
    pktUIMessaging.addMessageListener(iframe, _deleteItemMessageId, function(
      panelId,
      data
    ) {
      pktApi.deleteItem(data.itemId, {
        success(data, response) {
          var successResponse = { status: "success" };
          pktUIMessaging.sendResponseMessageToPanel(
            panelId,
            _deleteItemMessageId,
            successResponse
          );
          getPanelFrame().setAttribute("itemAdded", "false");
        },
        error(error, response) {
          pktUIMessaging.sendErrorResponseMessageToPanel(
            panelId,
            _deleteItemMessageId,
            error
          );
        },
      });
    });

    var _initL10NMessageId = "initL10N";
    pktUIMessaging.addMessageListener(iframe, _initL10NMessageId, function(
      panelId,
      data
    ) {
      var strings = {};
      var bundle = Services.strings.createBundle(
        "chrome://browser/locale/pocket.properties"
      );
      for (let str of bundle.getSimpleEnumeration()) {
        if (str.key in data) {
          strings[str.key] = bundle.formatStringFromName(
            str.key,
            data[str.key]
          );
        } else {
          strings[str.key] = str.value;
        }
      }
      pktUIMessaging.sendResponseMessageToPanel(panelId, _initL10NMessageId, {
        strings,
        dir: Services.locale.isAppLocaleRTL ? "rtl" : "ltr",
      });
    });
  }

  // -- Browser Navigation -- //

  /**
   * Open a new tab with a given url and notify the iframe panel that it was opened
   */

  function openTabWithUrl(url, aTriggeringPrincipal, aCsp) {
    let recentWindow = Services.wm.getMostRecentWindow("navigator:browser");
    if (!recentWindow) {
      Cu.reportError("Pocket: No open browser windows to openTabWithUrl");
      return;
    }

    // If the user is in permanent private browsing than this is not an issue,
    // since the current window will always share the same cookie jar as the other
    // windows.
    if (
      !PrivateBrowsingUtils.isWindowPrivate(recentWindow) ||
      PrivateBrowsingUtils.permanentPrivateBrowsing
    ) {
      recentWindow.openWebLinkIn(url, "tab", {
        triggeringPrincipal: aTriggeringPrincipal,
        csp: aCsp,
      });
      return;
    }

    for (let win of Services.wm.getEnumerator("navigator:browser")) {
      if (!PrivateBrowsingUtils.isWindowPrivate(win)) {
        win.openWebLinkIn(url, "tab", {
          triggeringPrincipal: aTriggeringPrincipal,
          csp: aCsp,
        });
        return;
      }
    }

    // If there were no non-private windows opened already.
    recentWindow.openWebLinkIn(url, "window", {
      triggeringPrincipal: aTriggeringPrincipal,
      csp: aCsp,
    });
  }

  // -- Helper Functions -- //

  function getCurrentUrl() {
    return gBrowser.currentURI.spec;
  }

  function getCurrentTitle() {
    return gBrowser.contentTitle;
  }

  function getPanel() {
    var frame = getPanelFrame();
    var panel = frame;
    while (panel && panel.localName != "panel") {
      panel = panel.parentNode;
    }
    return panel;
  }

  var photonPageActionPanelFrame;

  function setPhotonPageActionPanelFrame(frame) {
    photonPageActionPanelFrame = frame;
  }

  function getPanelFrame() {
    return photonPageActionPanelFrame;
  }

  function isInOverflowMenu() {
    return false;
  }

  function getFirefoxAccountSignedInUser(callback) {
    fxAccounts
      .getSignedInUser()
      .then(userData => {
        callback(userData);
      })
      .then(null, error => {
        callback();
      });
  }

  function getUILocale() {
    return Services.locale.appLocaleAsBCP47;
  }

  /**
   * Public functions
   */
  return {
    setPhotonPageActionPanelFrame,
    getPanelFrame,

    openTabWithUrl,

    tryToSaveUrl,
    tryToSaveCurrentPage,
  };
})();

// -- Communication to Background -- //
// https://developer.mozilla.org/en-US/Add-ons/Code_snippets/Interaction_between_privileged_and_non-privileged_pages
var pktUIMessaging = (function() {
  /**
   * Prefix message id for message listening
   */
  function prefixedMessageId(messageId) {
    return "PKT_" + messageId;
  }

  /**
   * Register a listener and callback for a specific messageId
   */
  function addMessageListener(iframe, messageId, callback) {
    iframe.addEventListener(
      prefixedMessageId(messageId),
      function(e) {
        var nodePrincipal = e.target.nodePrincipal;
        // ignore to ensure we do not pick up other events in the browser
        if (
          !nodePrincipal ||
          !nodePrincipal.URI ||
          !nodePrincipal.URI.spec.startsWith("about:pocket")
        ) {
          return;
        }

        // Pass in information to callback
        var payload = JSON.parse(e.target.getAttribute("payload"))[0];
        var panelId = payload.panelId;
        var data = payload.data;
        var csp = e.target.ownerDocument.csp;
        callback(panelId, data, nodePrincipal, csp);

        // Cleanup the element
        e.target.remove();
      },
      false,
      true
    );
  }

  /**
   * Send a message to the panel's iframe
   */
  function sendMessageToPanel(panelId, messageId, payload) {
    if (!isPanelIdValid(panelId)) {
      return;
    }

    var panelFrame = pktUI.getPanelFrame();
    if (!isPocketPanelFrameValid(panelFrame)) {
      return;
    }

    var doc = panelFrame.contentWindow.document;
    var documentElement = doc.documentElement;

    // Send message to panel
    var panelMessageId = prefixedMessageId(panelId + "_" + messageId);

    var AnswerEvt = doc.createElement("PKTMessage");
    AnswerEvt.setAttribute("payload", JSON.stringify([payload]));
    documentElement.appendChild(AnswerEvt);

    var event = doc.createEvent("HTMLEvents");
    event.initEvent(panelMessageId, true, false);
    AnswerEvt.dispatchEvent(event);
  }

  function sendResponseMessageToPanel(panelId, messageId, payload) {
    var responseMessageId = messageId + "Response";
    sendMessageToPanel(panelId, responseMessageId, payload);
  }

  /**
   * Helper function to package an error object and send it to the panel
   * iframe as a message response
   */
  function sendErrorMessageToPanel(panelId, messageId, error) {
    var errorResponse = { status: "error", error };
    sendMessageToPanel(panelId, messageId, errorResponse);
  }

  function sendErrorResponseMessageToPanel(panelId, messageId, error) {
    var errorResponse = { status: "error", error };
    sendResponseMessageToPanel(panelId, messageId, errorResponse);
  }

  /**
   * Validation
   */

  function isPanelIdValid(panelId) {
    // First check if panelId has a valid value > 0. We set the panelId to
    // 0 to start. But if for some reason the message is attempted to be
    // sent before the panel has a panelId, then it's going to send out
    // a message with panelId 0, which is never going to be heard. If this
    // happens, it means some race condition occurred where the panel was
    // trying to communicate before it should.
    if (panelId === 0) {
      console.warn("Tried to send message to panel with id 0.");
      return false;
    }

    return true;
  }

  function isPocketPanelFrameValid(panelFrame) {
    // Check if panel is available if not throw a warning and bailout.
    // We likely try to send to a panel that is not visible anymore
    if (typeof panelFrame === "undefined") {
      console.warn("Pocket panel frame is undefined");
      return false;
    }

    var contentWindow = panelFrame.contentWindow;
    if (typeof contentWindow == "undefined") {
      console.warn("Pocket panel frame content window is undefined");
      return false;
    }

    var doc = contentWindow.document;
    if (typeof doc === "undefined") {
      console.warn("Pocket panel frame content window document is undefined");
      return false;
    }

    var documentElement = doc.documentElement;
    if (typeof documentElement === "undefined") {
      console.warn(
        "Pocket panel frame content window document document element is undefined"
      );
      return false;
    }

    return true;
  }

  /**
   * Public
   */
  return {
    addMessageListener,
    sendMessageToPanel,
    sendResponseMessageToPanel,
    sendErrorMessageToPanel,
    sendErrorResponseMessageToPanel,
  };
})();
