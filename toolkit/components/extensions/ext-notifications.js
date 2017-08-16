"use strict";

// The ext-* files are imported into the same scopes.
/* import-globals-from ext-toolkit.js */

XPCOMUtils.defineLazyModuleGetter(this, "EventEmitter",
                                  "resource://gre/modules/EventEmitter.jsm");

var {
  ignoreEvent,
} = ExtensionCommon;

// WeakMap[Extension -> Map[id -> Notification]]
let notificationsMap = new WeakMap();

// Manages a notification popup (notifications API) created by the extension.
function Notification(extension, id, options) {
  this.extension = extension;
  this.id = id;
  this.options = options;

  let imageURL;
  if (options.iconUrl) {
    imageURL = this.extension.baseURI.resolve(options.iconUrl);
  }

  try {
    let svc = Cc["@mozilla.org/alerts-service;1"].getService(Ci.nsIAlertsService);
    svc.showAlertNotification(imageURL,
                              options.title,
                              options.message,
                              true, // textClickable
                              this.id,
                              this,
                              this.id);
  } catch (e) {
    // This will fail if alerts aren't available on the system.
  }
}

Notification.prototype = {
  clear() {
    try {
      let svc = Cc["@mozilla.org/alerts-service;1"].getService(Ci.nsIAlertsService);
      svc.closeAlert(this.id);
    } catch (e) {
      // This will fail if the OS doesn't support this function.
    }
    notificationsMap.get(this.extension).delete(this.id);
  },

  observe(subject, topic, data) {
    let notifications = notificationsMap.get(this.extension);

    let emitAndDelete = event => {
      notifications.emit(event, data);
      notifications.delete(this.id);
    };

    // Don't try to emit events if the extension has been unloaded
    if (!notifications) {
      return;
    }

    if (topic === "alertclickcallback") {
      emitAndDelete("clicked");
    }
    if (topic === "alertfinished") {
      emitAndDelete("closed");
    }
  },
};

this.notifications = class extends ExtensionAPI {
  constructor(extension) {
    super(extension);

    this.nextId = 0;
  }

  onShutdown() {
    let {extension} = this;

    if (notificationsMap.has(extension)) {
      for (let notification of notificationsMap.get(extension).values()) {
        notification.clear();
      }
      notificationsMap.delete(extension);
    }
  }

  getAPI(context) {
    let {extension} = context;

    let map = new Map();
    EventEmitter.decorate(map);
    notificationsMap.set(extension, map);

    return {
      notifications: {
        create: (notificationId, options) => {
          if (!notificationId) {
            notificationId = String(this.nextId++);
          }

          let notifications = notificationsMap.get(extension);
          if (notifications.has(notificationId)) {
            notifications.get(notificationId).clear();
          }

          // FIXME: Lots of options still aren't supported, especially
          // buttons.
          let notification = new Notification(extension, notificationId, options);
          notificationsMap.get(extension).set(notificationId, notification);

          return Promise.resolve(notificationId);
        },

        clear: function(notificationId) {
          let notifications = notificationsMap.get(extension);
          if (notifications.has(notificationId)) {
            notifications.get(notificationId).clear();
            return Promise.resolve(true);
          }
          return Promise.resolve(false);
        },

        getAll: function() {
          let result = {};
          notificationsMap.get(extension).forEach((value, key) => {
            result[key] = value.options;
          });
          return Promise.resolve(result);
        },

        onClosed: new SingletonEventManager(context, "notifications.onClosed", fire => {
          let listener = (event, notificationId) => {
            // FIXME: Support the byUser argument.
            fire.async(notificationId, true);
          };

          notificationsMap.get(extension).on("closed", listener);
          return () => {
            notificationsMap.get(extension).off("closed", listener);
          };
        }).api(),

        onClicked: new SingletonEventManager(context, "notifications.onClicked", fire => {
          let listener = (event, notificationId) => {
            fire.async(notificationId, true);
          };

          notificationsMap.get(extension).on("clicked", listener);
          return () => {
            notificationsMap.get(extension).off("clicked", listener);
          };
        }).api(),

        // Intend to implement this later: https://bugzilla.mozilla.org/show_bug.cgi?id=1190681
        onButtonClicked: ignoreEvent(context, "notifications.onButtonClicked"),
      },
    };
  }
};
