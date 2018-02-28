/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const NS_APP_USER_PROFILE_50_DIR = "ProfD";

var Ci = Components.interfaces;
var Cc = Components.classes;
var Cr = Components.results;
var Cu = Components.utils;

function do_check_throws(f, result, stack)
{
  if (!stack)
    stack = Components.stack.caller;

  try {
    f();
  } catch (exc) {
    equal(exc.result, result, "Correct exception was thrown");
    return;
  }
  ok(false, "expected result " + result + ", none thrown");
}

var dirSvc = Cc["@mozilla.org/file/directory_service;1"].getService(Ci.nsIProperties);

// Register current test directory as provider for the profile directory.
var provider = {
  getFile: function(prop, persistent) {
    persistent.value = true;
    if (prop == NS_APP_USER_PROFILE_50_DIR)
      return dirSvc.get("CurProcD", Ci.nsIFile);
    throw Components.Exception("Tried to get test directory '" + prop + "'", Cr.NS_ERROR_FAILURE);
  },
  QueryInterface: function(iid) {
    if (iid.equals(Ci.nsIDirectoryServiceProvider) ||
        iid.equals(Ci.nsISupports)) {
      return this;
    }
    throw Cr.NS_ERROR_NO_INTERFACE;
  }
};
dirSvc.QueryInterface(Ci.nsIDirectoryService).registerProvider(provider);
