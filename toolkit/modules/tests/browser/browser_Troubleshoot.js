/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Ideally this would be an xpcshell test, but Troubleshoot relies on things
// that aren't initialized outside of a XUL app environment like AddonManager
// and the "@mozilla.org/xre/app-info;1" component.

Components.utils.import("resource://gre/modules/AppConstants.jsm");
Components.utils.import("resource://gre/modules/Services.jsm");
Components.utils.import("resource://gre/modules/Troubleshoot.jsm");

function test() {
  waitForExplicitFinish();
  function doNextTest() {
    if (!tests.length) {
      finish();
      return;
    }
    tests.shift()(doNextTest);
  }
  doNextTest();
}

registerCleanupFunction(function() {
  // Troubleshoot.jsm is imported into the global scope -- the window -- above.
  // If it's not deleted, it outlives the test and is reported as a leak.
  delete window.Troubleshoot;
});

var tests = [

  function snapshotSchema(done) {
    Troubleshoot.snapshot(function(snapshot) {
      try {
        validateObject(snapshot, SNAPSHOT_SCHEMA);
        ok(true, "The snapshot should conform to the schema.");
      } catch (err) {
        ok(false, "Schema mismatch, " + err);
      }
      done();
    });
  },

  function modifiedPreferences(done) {
    let prefs = [
      "javascript.troubleshoot",
      "troubleshoot.foo",
      "javascript.print_to_filename",
      "network.proxy.troubleshoot",
    ];
    prefs.forEach(function(p) {
      Services.prefs.setBoolPref(p, true);
      is(Services.prefs.getBoolPref(p), true, "The pref should be set: " + p);
    });
    Troubleshoot.snapshot(function(snapshot) {
      let p = snapshot.modifiedPreferences;
      is(p["javascript.troubleshoot"], true,
         "The pref should be present because it's whitelisted " +
         "but not blacklisted.");
      ok(!("troubleshoot.foo" in p),
         "The pref should be absent because it's not in the whitelist.");
      ok(!("javascript.print_to_filename" in p),
         "The pref should be absent because it's blacklisted.");
      ok(!("network.proxy.troubleshoot" in p),
         "The pref should be absent because it's blacklisted.");
      prefs.forEach(p => Services.prefs.deleteBranch(p));
      done();
    });
  },

  function unicodePreferences(done) {
    let name = "font.name.sans-serif.x-western";
    let utf8Value = "\xc4\x8capk\xc5\xafv Krasopis"
    let unicodeValue = "\u010Capk\u016Fv Krasopis";

    // set/getCharPref work with 8bit strings (utf8)
    Services.prefs.setCharPref(name, utf8Value);

    Troubleshoot.snapshot(function(snapshot) {
      let p = snapshot.modifiedPreferences;
      is(p[name], unicodeValue, "The pref should have correct Unicode value.");
      Services.prefs.deleteBranch(name);
      done();
    });
  }
];

// This is inspired by JSON Schema, or by the example on its Wikipedia page
// anyway.
const SNAPSHOT_SCHEMA = {
  type: "object",
  required: true,
  properties: {
    application: {
      required: true,
      type: "object",
      properties: {
        name: {
          required: true,
          type: "string",
        },
        version: {
          required: true,
          type: "string",
        },
        buildID: {
          required: true,
          type: "string",
        },
        userAgent: {
          required: true,
          type: "string",
        },
        osVersion: {
          required: true,
          type: "string",
        },
        vendor: {
          type: "string",
        },
        updateChannel: {
          type: "string",
        },
        supportURL: {
          type: "string",
        },
        remoteAutoStart: {
          type: "boolean",
          required: true,
        },
        autoStartStatus: {
          type: "number",
        },
        numTotalWindows: {
          type: "number",
        },
        numRemoteWindows: {
          type: "number",
        },
        currentContentProcesses: {
          type: "number",
        },
        maxContentProcesses: {
          type: "number",
        },
        keyGoogleFound: {
          type: "boolean",
        },
        keyMozillaFound: {
          type: "boolean",
        },
        safeMode: {
          type: "boolean",
        },
      },
    },
    crashes: {
      required: false,
      type: "object",
      properties: {
        pending: {
          required: true,
          type: "number",
        },
        submitted: {
          required: true,
          type: "array",
          items: {
            type: "object",
            properties: {
              id: {
                required: true,
                type: "string",
              },
              date: {
                required: true,
                type: "number",
              },
              pending: {
                required: true,
                type: "boolean",
              },
            },
          },
        },
      },
    },
    extensions: {
      required: true,
      type: "array",
      items: {
        type: "object",
        properties: {
          name: {
            required: true,
            type: "string",
          },
          version: {
            required: true,
            type: "string",
          },
          id: {
            required: true,
            type: "string",
          },
          isActive: {
            required: true,
            type: "boolean",
          },
        },
      },
    },
    features: {
      required: true,
      type: "array",
      items: {
        type: "object",
        properties: {
          name: {
            required: true,
            type: "string",
          },
          version: {
            required: true,
            type: "string",
          },
          id: {
            required: true,
            type: "string",
          },
        },
      },
    },
    modifiedPreferences: {
      required: true,
      type: "object",
    },
    lockedPreferences: {
      required: true,
      type: "object",
    },
    graphics: {
      required: true,
      type: "object",
      properties: {
        numTotalWindows: {
          required: true,
          type: "number",
        },
        numAcceleratedWindows: {
          required: true,
          type: "number",
        },
        windowLayerManagerType: {
          type: "string",
        },
        windowLayerManagerRemote: {
          type: "boolean",
        },
        currentAudioBackend: {
          type: "string",
        },
        numAcceleratedWindowsMessage: {
          type: "array",
        },
        adapterDescription: {
          type: "string",
        },
        adapterVendorID: {
          type: "string",
        },
        adapterDeviceID: {
          type: "string",
        },
        adapterSubsysID: {
          type: "string",
        },
        adapterRAM: {
          type: "string",
        },
        adapterDrivers: {
          type: "string",
        },
        driverVersion: {
          type: "string",
        },
        driverDate: {
          type: "string",
        },
        adapterDescription2: {
          type: "string",
        },
        adapterVendorID2: {
          type: "string",
        },
        adapterDeviceID2: {
          type: "string",
        },
        adapterSubsysID2: {
          type: "string",
        },
        adapterRAM2: {
          type: "string",
        },
        adapterDrivers2: {
          type: "string",
        },
        driverVersion2: {
          type: "string",
        },
        driverDate2: {
          type: "string",
        },
        isGPU2Active: {
          type: "boolean",
        },
        direct2DEnabled: {
          type: "boolean",
        },
        directWriteEnabled: {
          type: "boolean",
        },
        directWriteVersion: {
          type: "string",
        },
        clearTypeParameters: {
          type: "string",
        },
        webgl1Renderer: {
          type: "string",
        },
        webgl1Version: {
          type: "string",
        },
        webgl1DriverExtensions: {
          type: "string",
        },
        webgl1Extensions: {
          type: "string",
        },
        webgl1WSIInfo: {
          type: "string",
        },
        webgl2Renderer: {
          type: "string",
        },
        webgl2Version: {
          type: "string",
        },
        webgl2DriverExtensions: {
          type: "string",
        },
        webgl2Extensions: {
          type: "string",
        },
        webgl2WSIInfo: {
          type: "string",
        },
        info: {
          type: "object",
        },
        failures: {
          type: "array",
          items: {
            type: "string",
          },
        },
        indices: {
          type: "array",
          items: {
            type: "number",
          },
        },
        featureLog: {
          type: "object",
        },
        crashGuards: {
          type: "array",
        },
        direct2DEnabledMessage: {
          type: "array",
        },
      },
    },
    javaScript: {
      required: true,
      type: "object",
      properties: {
        incrementalGCEnabled: {
          type: "boolean",
        },
      },
    },
    accessibility: {
      required: true,
      type: "object",
      properties: {
        isActive: {
          required: true,
          type: "boolean",
        },
        forceDisabled: {
          type: "number",
        },
      },
    },
    libraryVersions: {
      required: true,
      type: "object",
      properties: {
        NSPR: {
          required: true,
          type: "object",
          properties: {
            minVersion: {
              required: true,
              type: "string",
            },
            version: {
              required: true,
              type: "string",
            },
          },
        },
        NSS: {
          required: true,
          type: "object",
          properties: {
            minVersion: {
              required: true,
              type: "string",
            },
            version: {
              required: true,
              type: "string",
            },
          },
        },
        NSSUTIL: {
          required: true,
          type: "object",
          properties: {
            minVersion: {
              required: true,
              type: "string",
            },
            version: {
              required: true,
              type: "string",
            },
          },
        },
        NSSSSL: {
          required: true,
          type: "object",
          properties: {
            minVersion: {
              required: true,
              type: "string",
            },
            version: {
              required: true,
              type: "string",
            },
          },
        },
        NSSSMIME: {
          required: true,
          type: "object",
          properties: {
            minVersion: {
              required: true,
              type: "string",
            },
            version: {
              required: true,
              type: "string",
            },
          },
        },
      },
    },
    userJS: {
      required: true,
      type: "object",
      properties: {
        exists: {
          required: true,
          type: "boolean",
        },
      },
    },
    experiments: {
      type: "array",
    },
    sandbox: {
      required: false,
      type: "object",
      properties: {
        hasSeccompBPF: {
          required: AppConstants.platform == "linux",
          type: "boolean"
        },
        hasSeccompTSync: {
          required: AppConstants.platform == "linux",
          type: "boolean"
        },
        hasUserNamespaces: {
          required: AppConstants.platform == "linux",
          type: "boolean"
        },
        hasPrivilegedUserNamespaces: {
          required: AppConstants.platform == "linux",
          type: "boolean"
        },
        canSandboxContent: {
          required: false,
          type: "boolean"
        },
        canSandboxMedia: {
          required: false,
          type: "boolean"
        },
        contentSandboxLevel: {
          required: AppConstants.MOZ_CONTENT_SANDBOX,
          type: "number"
        },
        effectiveContentSandboxLevel: {
          required: AppConstants.MOZ_CONTENT_SANDBOX,
          type: "number"
        },
	syscallLog: {
	  required: AppConstants.platform == "linux",
	  type: "array",
	  items: {
	    type: "object",
	    properties: {
	      index: {
		required: true,
		type: "number",
	      },
	      pid: {
		required: true,
		type: "number",
	      },
	      tid: {
		required: true,
		type: "number",
	      },
	      procType: {
		required: true,
		type: "string",
	      },
	      syscall: {
		required: true,
		type: "number",
	      },
	      args: {
		required: true,
		type: "array",
		items: {
		  type: "string",
		},
	      },
	    },
	  },
	},
      },
    },
  },
};

/**
 * Throws an Error if obj doesn't conform to schema.  That way you get a nice
 * error message and a stack to help you figure out what went wrong, which you
 * wouldn't get if this just returned true or false instead.  There's still
 * room for improvement in communicating validation failures, however.
 *
 * @param obj    The object to validate.
 * @param schema The schema that obj should conform to.
 */
function validateObject(obj, schema) {
  if (obj === undefined && !schema.required)
    return;
  if (typeof(schema.type) != "string")
    throw schemaErr("'type' must be a string", schema);
  if (objType(obj) != schema.type)
    throw validationErr("Object is not of the expected type", obj, schema);
  let validatorFnName = "validateObject_" + schema.type;
  if (!(validatorFnName in this))
    throw schemaErr("Validator function not defined for type", schema);
  this[validatorFnName](obj, schema);
}

function validateObject_object(obj, schema) {
  if (typeof(schema.properties) != "object")
    // Don't care what obj's properties are.
    return;
  // First check that all the schema's properties match the object.
  for (let prop in schema.properties)
    validateObject(obj[prop], schema.properties[prop]);
  // Now check that the object doesn't have any properties not in the schema.
  for (let prop in obj)
    if (!(prop in schema.properties))
      throw validationErr("Object has property " + prop + " not in schema", obj, schema);
}

function validateObject_array(array, schema) {
  if (typeof(schema.items) != "object")
    // Don't care what the array's elements are.
    return;
  array.forEach(elt => validateObject(elt, schema.items));
}

function validateObject_string(str, schema) {}
function validateObject_boolean(bool, schema) {}
function validateObject_number(num, schema) {}

function validationErr(msg, obj, schema) {
  return new Error("Validation error: " + msg +
                   ": object=" + JSON.stringify(obj) +
                   ", schema=" + JSON.stringify(schema));
}

function schemaErr(msg, schema) {
  return new Error("Schema error: " + msg + ": " + JSON.stringify(schema));
}

function objType(obj) {
  let type = typeof(obj);
  if (type != "object")
    return type;
  if (Array.isArray(obj))
    return "array";
  if (obj === null)
    return "null";
  return type;
}
