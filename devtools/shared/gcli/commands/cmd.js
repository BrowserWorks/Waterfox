/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { Cc, Ci, Cu } = require("chrome");
const { OS } = Cu.import("resource://gre/modules/osfile.jsm", {});
const { Task } = require("devtools/shared/task");

const gcli = require("gcli/index");
const l10n = require("gcli/l10n");

loader.lazyGetter(this, "prefBranch", function () {
  let prefService = Cc["@mozilla.org/preferences-service;1"]
                      .getService(Ci.nsIPrefService);
  return prefService.getBranch(null).QueryInterface(Ci.nsIPrefBranch2);
});

loader.lazyImporter(this, "NetUtil", "resource://gre/modules/NetUtil.jsm");

const PREF_DIR = "devtools.commands.dir";

/**
 * Load all the .mozcmd files in the directory pointed to by PREF_DIR
 * @return A promise of an array of items suitable for gcli.addItems or
 * using in gcli.addItemsByModule
 */
function loadItemsFromMozDir() {
  let dirName = prefBranch.getStringPref(PREF_DIR).trim();
  if (dirName == "") {
    return Promise.resolve([]);
  }

  // replaces ~ with the home directory path in unix and windows
  if (dirName.indexOf("~") == 0) {
    let dirService = Cc["@mozilla.org/file/directory_service;1"]
                      .getService(Ci.nsIProperties);
    let homeDirFile = dirService.get("Home", Ci.nsIFile);
    let homeDir = homeDirFile.path;
    dirName = dirName.substr(1);
    dirName = homeDir + dirName;
  }

  // statPromise resolves to nothing if dirName is a directory, or it
  // rejects with an error message otherwise
  let statPromise = OS.File.stat(dirName);
  statPromise = statPromise.then(
    function onSuccess(stat) {
      if (!stat.isDir) {
        throw new Error("'" + dirName + "' is not a directory.");
      }
    },
    function onFailure(reason) {
      if (reason instanceof OS.File.Error && reason.becauseNoSuchFile) {
        throw new Error("'" + dirName + "' does not exist.");
      } else {
        throw reason;
      }
    }
  );

  // We need to return (a promise of) an array of items from the *.mozcmd
  // files in dirName (which we can assume to be a valid directory now)
  return Task.async(function* () {
    yield statPromise;
    let itemPromises = [];

    let iterator = new OS.File.DirectoryIterator(dirName);
    try {
      yield iterator.forEach(entry => {
        if (entry.name.match(/.*\.mozcmd$/) && !entry.isDir) {
          itemPromises.push(loadCommandFile(entry));
        }
      });
      iterator.close();
      let itemsArray = yield Promise.all(itemPromises);
      return itemsArray.reduce((prev, curr) => {
        return prev.concat(curr);
      }, []);
    } catch (e) {
      iterator.close();
      throw e;
    }
  });
}

exports.mozDirLoader = function (name) {
  return loadItemsFromMozDir().then(items => {
    return { items };
  });
};

/**
 * Load the commands from a single file
 * @param OS.File.DirectoryIterator.Entry entry The DirectoryIterator
 * Entry of the file containing the commands that we should read
 */
function loadCommandFile(entry) {
  let readPromise = OS.File.read(entry.path);
  readPromise = readPromise.then(array => {
    let decoder = new TextDecoder();
    let source = decoder.decode(array);
    let principal = Cc["@mozilla.org/systemprincipal;1"]
                      .createInstance(Ci.nsIPrincipal);

    let sandbox = new Cu.Sandbox(principal, {
      sandboxName: entry.path
    });
    let data = Cu.evalInSandbox(source, sandbox, "1.8", entry.name, 1);

    if (!Array.isArray(data)) {
      console.error("Command file '" + entry.name + "' does not have top level array.");
      return null;
    }

    return data;
  });
  return readPromise;
}

exports.items = [
  {
    name: "cmd",
    get hidden() {
      return !prefBranch.prefHasUserValue(PREF_DIR);
    },
    description: l10n.lookup("cmdDesc")
  },
  {
    item: "command",
    runAt: "client",
    name: "cmd refresh",
    description: l10n.lookup("cmdRefreshDesc"),
    get hidden() {
      return !prefBranch.prefHasUserValue(PREF_DIR);
    },
    exec: function (args, context) {
      gcli.load();

      let dirName = prefBranch.getStringPref(PREF_DIR).trim();
      return l10n.lookupFormat("cmdStatus3", [ dirName ]);
    }
  },
  {
    item: "command",
    runAt: "client",
    name: "cmd setdir",
    description: l10n.lookup("cmdSetdirDesc"),
    manual: l10n.lookup("cmdSetdirManual3"),
    params: [
      {
        name: "directory",
        description: l10n.lookup("cmdSetdirDirectoryDesc"),
        type: {
          name: "file",
          filetype: "directory",
          existing: "yes"
        },
        defaultValue: null
      }
    ],
    returnType: "string",
    get hidden() {
      // !prefBranch.prefHasUserValue(PREF_DIR);
      return true;
    },
    exec: function (args, context) {
      prefBranch.setStringPref(PREF_DIR, args.directory);

      gcli.load();

      return l10n.lookupFormat("cmdStatus3", [ args.directory ]);
    }
  }
];
