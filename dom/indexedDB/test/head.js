/**
 * Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

var gActiveListeners = {};

// These event (un)registration handlers only work for one window, DONOT use
// them with multiple windows.
function registerPopupEventHandler(eventName, callback, win) {
  if (!win) {
    win = window;
  }
  gActiveListeners[eventName] = function(event) {
    if (event.target != win.PopupNotifications.panel)
      return;
    win.PopupNotifications.panel.removeEventListener(
                                                   eventName,
                                                   gActiveListeners[eventName]);
    delete gActiveListeners[eventName];

    callback.call(win.PopupNotifications.panel);
  }
  win.PopupNotifications.panel.addEventListener(eventName,
                                                gActiveListeners[eventName]);
}

function unregisterPopupEventHandler(eventName, win)
{
  if (!win) {
    win = window;
  }
  win.PopupNotifications.panel.removeEventListener(eventName,
                                                   gActiveListeners[eventName]);
  delete gActiveListeners[eventName];
}

function unregisterAllPopupEventHandlers(win)
{
  if (!win) {
    win = window;
  }
  for (let eventName in gActiveListeners) {
    win.PopupNotifications.panel.removeEventListener(
                                                   eventName,
                                                   gActiveListeners[eventName]);
  }
  gActiveListeners = {};
}

function triggerMainCommand(popup)
{
  info("triggering main command");
  let notifications = popup.childNodes;
  ok(notifications.length > 0, "at least one notification displayed");
  let notification = notifications[0];
  info("triggering command: " + notification.getAttribute("buttonlabel"));

  EventUtils.synthesizeMouseAtCenter(notification.button, {});
}

function triggerSecondaryCommand(popup)
{
  info("triggering secondary command");
  let notifications = popup.childNodes;
  ok(notifications.length > 0, "at least one notification displayed");
  let notification = notifications[0];
  EventUtils.synthesizeMouseAtCenter(notification.secondaryButton, {});
}

function dismissNotification(popup)
{
  info("dismissing notification");
  executeSoon(function() {
    EventUtils.synthesizeKey("VK_ESCAPE", {});
  });
}

function waitForMessage(aMessage, browser)
{
  return new Promise((resolve, reject) => {
    /* eslint-disable no-undef */
    function contentScript() {
      addEventListener("message", function(event) {
        sendAsyncMessage("testLocal:message",
          {message: event.data});
      }, {once: true}, true);
    }
    /* eslint-enable no-undef */

    let script = "data:,(" + contentScript.toString() + ")();";

    let mm = browser.selectedBrowser.messageManager;

    mm.addMessageListener("testLocal:message", function listener(msg) {
      mm.removeMessageListener("testLocal:message", listener);
      mm.removeDelayedFrameScript(script);
      is(msg.data.message, aMessage, "received " + aMessage);
      if (msg.data.message == aMessage) {
        resolve();
      } else {
        reject();
      }
    });

    mm.loadFrameScript(script, true);
  });
}

function dispatchEvent(eventName)
{
  info("dispatching event: " + eventName);
  let event = document.createEvent("Events");
  event.initEvent(eventName, false, false);
  gBrowser.selectedBrowser.contentWindow.dispatchEvent(event);
}

function setPermission(url, permission)
{
  const nsIPermissionManager = Components.interfaces.nsIPermissionManager;

  let uri = Components.classes["@mozilla.org/network/io-service;1"]
                      .getService(Components.interfaces.nsIIOService)
                      .newURI(url);
  let ssm = Components.classes["@mozilla.org/scriptsecuritymanager;1"]
                      .getService(Ci.nsIScriptSecurityManager);
  let principal = ssm.createCodebasePrincipal(uri, {});

  Components.classes["@mozilla.org/permissionmanager;1"]
            .getService(nsIPermissionManager)
            .addFromPrincipal(principal, permission,
                              nsIPermissionManager.ALLOW_ACTION);
}

function removePermission(url, permission)
{
  let uri = Components.classes["@mozilla.org/network/io-service;1"]
                      .getService(Components.interfaces.nsIIOService)
                      .newURI(url);
  let ssm = Components.classes["@mozilla.org/scriptsecuritymanager;1"]
                      .getService(Ci.nsIScriptSecurityManager);
  let principal = ssm.createCodebasePrincipal(uri, {});

  Components.classes["@mozilla.org/permissionmanager;1"]
            .getService(Components.interfaces.nsIPermissionManager)
            .removeFromPrincipal(principal, permission);
}

function getPermission(url, permission)
{
  let uri = Components.classes["@mozilla.org/network/io-service;1"]
                      .getService(Components.interfaces.nsIIOService)
                      .newURI(url);
  let ssm = Components.classes["@mozilla.org/scriptsecuritymanager;1"]
                      .getService(Ci.nsIScriptSecurityManager);
  let principal = ssm.createCodebasePrincipal(uri, {});

  return Components.classes["@mozilla.org/permissionmanager;1"]
                   .getService(Components.interfaces.nsIPermissionManager)
                   .testPermissionFromPrincipal(principal, permission);
}
