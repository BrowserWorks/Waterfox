"use strict";

var {classes: Cc, interfaces: Ci, utils: Cu} = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "ExtensionManagement",
                                  "resource://gre/modules/ExtensionManagement.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "MatchURLFilters",
                                  "resource://gre/modules/MatchPattern.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "WebNavigation",
                                  "resource://gre/modules/WebNavigation.jsm");

Cu.import("resource://gre/modules/ExtensionUtils.jsm");
var {
  SingletonEventManager,
  ignoreEvent,
} = ExtensionUtils;

const defaultTransitionTypes = {
  topFrame: "link",
  subFrame: "auto_subframe",
};

const frameTransitions = {
  anyFrame: {
    qualifiers: ["server_redirect", "client_redirect", "forward_back"],
  },
  topFrame: {
    types: ["reload", "form_submit"],
  },
};

const tabTransitions = {
  topFrame: {
    qualifiers: ["from_address_bar"],
    types: ["auto_bookmark", "typed", "keyword", "generated", "link"],
  },
  subFrame: {
    types: ["manual_subframe"],
  },
};

function isTopLevelFrame({frameId, parentFrameId}) {
  return frameId == 0 && parentFrameId == -1;
}

function fillTransitionProperties(eventName, src, dst) {
  if (eventName == "onCommitted" || eventName == "onHistoryStateUpdated") {
    let frameTransitionData = src.frameTransitionData || {};
    let tabTransitionData = src.tabTransitionData || {};

    let transitionType, transitionQualifiers = [];

    // Fill transition properties for any frame.
    for (let qualifier of frameTransitions.anyFrame.qualifiers) {
      if (frameTransitionData[qualifier]) {
        transitionQualifiers.push(qualifier);
      }
    }

    if (isTopLevelFrame(dst)) {
      for (let type of frameTransitions.topFrame.types) {
        if (frameTransitionData[type]) {
          transitionType = type;
        }
      }

      for (let qualifier of tabTransitions.topFrame.qualifiers) {
        if (tabTransitionData[qualifier]) {
          transitionQualifiers.push(qualifier);
        }
      }

      for (let type of tabTransitions.topFrame.types) {
        if (tabTransitionData[type]) {
          transitionType = type;
        }
      }

      // If transitionType is not defined, defaults it to "link".
      if (!transitionType) {
        transitionType = defaultTransitionTypes.topFrame;
      }
    } else {
      // If it is sub-frame, transitionType defaults it to "auto_subframe",
      // "manual_subframe" is set only in case of a recent user interaction.
      transitionType = tabTransitionData.link ?
        "manual_subframe" : defaultTransitionTypes.subFrame;
    }

    // Fill the transition properties in the webNavigation event object.
    dst.transitionType = transitionType;
    dst.transitionQualifiers = transitionQualifiers;
  }
}

// Similar to WebRequestEventManager but for WebNavigation.
function WebNavigationEventManager(context, eventName) {
  let name = `webNavigation.${eventName}`;
  let register = (callback, urlFilters) => {
    // Don't create a MatchURLFilters instance if the listener does not include any filter.
    let filters = urlFilters ?
          new MatchURLFilters(urlFilters.url) : null;

    let listener = data => {
      if (!data.browser) {
        return;
      }

      let data2 = {
        url: data.url,
        timeStamp: Date.now(),
        frameId: ExtensionManagement.getFrameId(data.windowId),
        parentFrameId: ExtensionManagement.getParentFrameId(data.parentWindowId, data.windowId),
      };

      if (eventName == "onErrorOccurred") {
        data2.error = data.error;
      }

      // Fills in tabId typically.
      extensions.emit("fill-browser-data", data.browser, data2);
      if (data2.tabId < 0) {
        return;
      }

      fillTransitionProperties(eventName, data, data2);

      context.runSafe(callback, data2);
    };

    WebNavigation[eventName].addListener(listener, filters);
    return () => {
      WebNavigation[eventName].removeListener(listener);
    };
  };

  return SingletonEventManager.call(this, context, name, register);
}

WebNavigationEventManager.prototype = Object.create(SingletonEventManager.prototype);

function convertGetFrameResult(tabId, data) {
  return {
    errorOccurred: data.errorOccurred,
    url: data.url,
    tabId,
    frameId: ExtensionManagement.getFrameId(data.windowId),
    parentFrameId: ExtensionManagement.getParentFrameId(data.parentWindowId, data.windowId),
  };
}

extensions.registerSchemaAPI("webNavigation", "addon_parent", context => {
  return {
    webNavigation: {
      onTabReplaced: ignoreEvent(context, "webNavigation.onTabReplaced"),
      onBeforeNavigate: new WebNavigationEventManager(context, "onBeforeNavigate").api(),
      onCommitted: new WebNavigationEventManager(context, "onCommitted").api(),
      onDOMContentLoaded: new WebNavigationEventManager(context, "onDOMContentLoaded").api(),
      onCompleted: new WebNavigationEventManager(context, "onCompleted").api(),
      onErrorOccurred: new WebNavigationEventManager(context, "onErrorOccurred").api(),
      onReferenceFragmentUpdated: new WebNavigationEventManager(context, "onReferenceFragmentUpdated").api(),
      onHistoryStateUpdated: new WebNavigationEventManager(context, "onHistoryStateUpdated").api(),
      onCreatedNavigationTarget: ignoreEvent(context, "webNavigation.onCreatedNavigationTarget"),
      getAllFrames(details) {
        let tab = TabManager.getTab(details.tabId, context);

        let {innerWindowID, messageManager} = tab.linkedBrowser;
        let recipient = {innerWindowID};

        return context.sendMessage(messageManager, "WebNavigation:GetAllFrames", {}, {recipient})
                      .then((results) => results.map(convertGetFrameResult.bind(null, details.tabId)));
      },
      getFrame(details) {
        let tab = TabManager.getTab(details.tabId, context);

        let recipient = {
          innerWindowID: tab.linkedBrowser.innerWindowID,
        };

        let mm = tab.linkedBrowser.messageManager;
        return context.sendMessage(mm, "WebNavigation:GetFrame", {options: details}, {recipient})
                      .then((result) => {
                        return result ?
                          convertGetFrameResult(details.tabId, result) :
                          Promise.reject({message: `No frame found with frameId: ${details.frameId}`});
                      });
      },
    },
  };
});
