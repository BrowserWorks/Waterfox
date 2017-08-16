/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

// Tests that the pref commands work

var prefBranch = Cc["@mozilla.org/preferences-service;1"]
                    .getService(Ci.nsIPrefService).getBranch(null)
                    .QueryInterface(Ci.nsIPrefBranch2);

var supportsString = Cc["@mozilla.org/supports-string;1"]
                      .createInstance(Ci.nsISupportsString);

const TEST_URI = "data:text/html;charset=utf-8,gcli-pref3";

function test() {
  return Task.spawn(spawnTest).then(finish, helpers.handleError);
}

function* spawnTest() {
  let options = yield helpers.openTab(TEST_URI);
  yield helpers.openToolbar(options);

  let remoteHostOrig = prefBranch.getStringPref("devtools.debugger.remote-host");
  info("originally: devtools.debugger.remote-host = " + remoteHostOrig);

  yield helpers.audit(options, [
    {
      setup: "pref show devtools.debugger.remote-host",
      check: {
        args: {
          setting: {
            value: options.requisition.system.settings.get("devtools.debugger.remote-host")
          }
        },
      },
      exec: {
        output: new RegExp("^devtools\.debugger\.remote-host: " + remoteHostOrig + "$"),
      },
    },
    {
      setup: "pref set devtools.debugger.remote-host e.com",
      check: {
        args: {
          setting: {
            value: options.requisition.system.settings.get("devtools.debugger.remote-host")
          },
          value: { value: "e.com" }
        },
      },
      exec: {
        output: "",
      },
    },
    {
      setup: "pref show devtools.debugger.remote-host",
      check: {
        args: {
          setting: {
            value: options.requisition.system.settings.get("devtools.debugger.remote-host")
          }
        },
      },
      exec: {
        output: new RegExp("^devtools\.debugger\.remote-host: e.com$"),
      },
      post: function () {
        var ecom = prefBranch.getStringPref("devtools.debugger.remote-host");
        is(ecom, "e.com", "devtools.debugger.remote-host is e.com");
      }
    },
    {
      setup: "pref set devtools.debugger.remote-host moz.foo",
      check: {
        args: {
          setting: {
            value: options.requisition.system.settings.get("devtools.debugger.remote-host")
          },
          value: { value: "moz.foo" }
        },
      },
      exec: {
        output: "",
      },
    },
    {
      setup: "pref show devtools.debugger.remote-host",
      check: {
        args: {
          setting: {
            value: options.requisition.system.settings.get("devtools.debugger.remote-host")
          }
        },
      },
      exec: {
        output: new RegExp("^devtools\.debugger\.remote-host: moz.foo$"),
      },
      post: function () {
        var mozfoo = prefBranch.getStringPref("devtools.debugger.remote-host");
        is(mozfoo, "moz.foo", "devtools.debugger.remote-host is moz.foo");
      }
    },
  ]);

  supportsString.data = remoteHostOrig;
  prefBranch.setComplexValue("devtools.debugger.remote-host",
                             Ci.nsISupportsString, supportsString);

  yield helpers.closeToolbar(options);
  yield helpers.closeTab(options);
}
