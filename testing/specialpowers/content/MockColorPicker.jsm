/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["MockColorPicker"];

const Cc = Components.classes;
const Ci = Components.interfaces;
const Cm = Components.manager;
const Cu = Components.utils;

const CONTRACT_ID = "@mozilla.org/colorpicker;1";

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");

// Allow stuff from this scope to be accessed from non-privileged scopes. This
// would crash if used outside of automation.
Cu.forcePermissiveCOWs();

var registrar = Cm.QueryInterface(Ci.nsIComponentRegistrar);
var oldClassID = "", oldFactory = null;
var newClassID = Cc["@mozilla.org/uuid-generator;1"].getService(Ci.nsIUUIDGenerator).generateUUID();
var newFactory = function(window) {
  return {
    createInstance(aOuter, aIID) {
      if (aOuter)
        throw Components.results.NS_ERROR_NO_AGGREGATION;
      return new MockColorPickerInstance(window).QueryInterface(aIID);
    },
    lockFactory(aLock) {
      throw Components.results.NS_ERROR_NOT_IMPLEMENTED;
    },
    QueryInterface: XPCOMUtils.generateQI([Ci.nsIFactory])
  };
}

this.MockColorPicker = {
  init(window) {
    this.reset();
    this.factory = newFactory(window);
    if (!registrar.isCIDRegistered(newClassID)) {
      try {
        oldClassID = registrar.contractIDToCID(CONTRACT_ID);
        oldFactory = Cm.getClassObject(Cc[CONTRACT_ID], Ci.nsIFactory);
      } catch (ex) {
        oldClassID = "";
        oldFactory = null;
        dump("TEST-INFO | can't get colorpicker registered component, " +
             "assuming there is none");
      }
      if (oldClassID != "" && oldFactory != null) {
        registrar.unregisterFactory(oldClassID, oldFactory);
      }
      registrar.registerFactory(newClassID, "", CONTRACT_ID, this.factory);
    }
  },

  reset() {
    this.returnColor = "";
    this.showCallback = null;
    this.shown = false;
    this.showing = false;
  },

  cleanup() {
    var previousFactory = this.factory;
    this.reset();
    this.factory = null;

    registrar.unregisterFactory(newClassID, previousFactory);
    if (oldClassID != "" && oldFactory != null) {
      registrar.registerFactory(oldClassID, "", CONTRACT_ID, oldFactory);
    }
  }
};

function MockColorPickerInstance(window) {
  this.window = window;
}
MockColorPickerInstance.prototype = {
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIColorPicker]),
  init(aParent, aTitle, aInitialColor) {
    this.parent = aParent;
    this.initialColor = aInitialColor;
  },
  initialColor: "",
  parent: null,
  open(aColorPickerShownCallback) {
    MockColorPicker.showing = true;
    MockColorPicker.shown = true;

    this.window.setTimeout(() => {
      let result = "";
      try {
        if (typeof MockColorPicker.showCallback == "function") {
          var updateCb = function(color) {
            result = color;
            aColorPickerShownCallback.update(color);
          };
          let returnColor = MockColorPicker.showCallback(this, updateCb);
          if (typeof returnColor === "string") {
            result = returnColor;
          }
        } else if (typeof MockColorPicker.returnColor === "string") {
          result = MockColorPicker.returnColor;
        }
      } catch (ex) {
        dump("TEST-UNEXPECTED-FAIL | Exception in MockColorPicker.jsm open() " +
             "method: " + ex + "\n");
      }
      if (aColorPickerShownCallback) {
        aColorPickerShownCallback.done(result);
      }
    }, 0);
  }
};
