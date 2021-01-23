/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */
/* import-globals-from browser_content_sandbox_utils.js */
"use strict";

Services.scriptloader.loadSubScript(
  "chrome://mochitests/content/browser/" +
    "security/sandbox/test/browser_content_sandbox_utils.js",
  this
);

/*
 * This test exercises file I/O from web and file content processes using
 * OS.File methods to validate that calls that are meant to be blocked by
 * content sandboxing are blocked.
 */

// Creates file at |path| and returns a promise that resolves with true
// if the file was successfully created, otherwise false. Include imports
// so this can be safely serialized and run remotely by ContentTask.spawn.
function createFile(path) {
  const { OS } = ChromeUtils.import("resource://gre/modules/osfile.jsm");
  let encoder = new TextEncoder();
  let array = encoder.encode("TEST FILE DUMMY DATA");
  return OS.File.writeAtomic(path, array).then(
    function(value) {
      return true;
    },
    function(reason) {
      return false;
    }
  );
}

// Creates a symlink at |path| and returns a promise that resolves with true
// if the symlink was successfully created, otherwise false. Include imports
// so this can be safely serialized and run remotely by ContentTask.spawn.
function createSymlink(path) {
  const { OS } = ChromeUtils.import("resource://gre/modules/osfile.jsm");
  // source location for the symlink can be anything
  return OS.File.unixSymLink("/Users", path).then(
    function(value) {
      return true;
    },
    function(reason) {
      return false;
    }
  );
}

// Deletes file at |path| and returns a promise that resolves with true
// if the file was successfully deleted, otherwise false. Include imports
// so this can be safely serialized and run remotely by ContentTask.spawn.
function deleteFile(path) {
  const { OS } = ChromeUtils.import("resource://gre/modules/osfile.jsm");
  return OS.File.remove(path, { ignoreAbsent: false })
    .then(function(value) {
      return true;
    })
    .catch(function(err) {
      return false;
    });
}

// Reads the directory at |path| and returns a promise that resolves when
// iteration over the directory finishes or encounters an error. The promise
// resolves with an object where .ok indicates success or failure and
// .numEntries is the number of directory entries found.
function readDir(path) {
  const { OS } = ChromeUtils.import("resource://gre/modules/osfile.jsm");
  let numEntries = 0;
  let iterator = new OS.File.DirectoryIterator(path);
  let promise = iterator
    .forEach(function(dirEntry) {
      numEntries++;
    })
    .then(function() {
      iterator.close();
      return { ok: true, numEntries };
    })
    .catch(function() {
      return { ok: false, numEntries };
    });
  return promise;
}

// Reads the file at |path| and returns a promise that resolves when
// reading is completed. Returned object has boolean .ok to indicate
// success or failure.
function readFile(path) {
  const { OS } = ChromeUtils.import("resource://gre/modules/osfile.jsm");
  let promise = OS.File.read(path)
    .then(function(binaryData) {
      return { ok: true };
    })
    .catch(function(error) {
      return { ok: false };
    });
  return promise;
}

// Does a stat of |path| and returns a promise that resolves if the
// stat is successful. Returned object has boolean .ok to indicate
// success or failure.
function statPath(path) {
  const { OS } = ChromeUtils.import("resource://gre/modules/osfile.jsm");
  let promise = OS.File.stat(path)
    .then(function(stat) {
      return { ok: true };
    })
    .catch(function(error) {
      return { ok: false };
    });
  return promise;
}

// Returns true if the current content sandbox level, passed in
// the |level| argument, supports filesystem sandboxing.
function isContentFileIOSandboxed(level) {
  let fileIOSandboxMinLevel = 0;

  // Set fileIOSandboxMinLevel to the lowest level that has
  // content filesystem sandboxing enabled. For now, this
  // varies across Windows, Mac, Linux, other.
  switch (Services.appinfo.OS) {
    case "WINNT":
      fileIOSandboxMinLevel = 1;
      break;
    case "Darwin":
      fileIOSandboxMinLevel = 1;
      break;
    case "Linux":
      fileIOSandboxMinLevel = 2;
      break;
    default:
      Assert.ok(false, "Unknown OS");
  }

  return level >= fileIOSandboxMinLevel;
}

// Returns the lowest sandbox level where blanket reading of the profile
// directory from the content process should be blocked by the sandbox.
function minProfileReadSandboxLevel(level) {
  switch (Services.appinfo.OS) {
    case "WINNT":
      return 3;
    case "Darwin":
      return 2;
    case "Linux":
      return 3;
    default:
      Assert.ok(false, "Unknown OS");
      return 0;
  }
}

// Returns the lowest sandbox level where blanket reading of the home
// directory from the content process should be blocked by the sandbox.
function minHomeReadSandboxLevel(level) {
  switch (Services.appinfo.OS) {
    case "WINNT":
      return 3;
    case "Darwin":
      return 3;
    case "Linux":
      return 3;
    default:
      Assert.ok(false, "Unknown OS");
      return 0;
  }
}

//
// Checks that sandboxing is enabled and at the appropriate level
// setting before triggering tests that do the file I/O.
//
// Tests attempting to write to a file in the home directory from the
// content process--expected to fail.
//
// Tests attempting to write to a file in the content temp directory
// from the content process--expected to succeed. Uses "ContentTmpD".
//
// Tests reading various files and directories from file and web
// content processes.
//
add_task(async function() {
  // This test is only relevant in e10s
  if (!gMultiProcessBrowser) {
    ok(false, "e10s is enabled");
    info("e10s is not enabled, exiting");
    return;
  }

  let level = 0;
  let prefExists = true;

  // Read the security.sandbox.content.level pref.
  // eslint-disable-next-line mozilla/use-default-preference-values
  try {
    level = Services.prefs.getIntPref("security.sandbox.content.level");
  } catch (e) {
    prefExists = false;
  }

  ok(prefExists, "pref security.sandbox.content.level exists");
  if (!prefExists) {
    return;
  }

  info(`security.sandbox.content.level=${level}`);
  ok(level > 0, "content sandbox is enabled.");

  let isFileIOSandboxed = isContentFileIOSandboxed(level);

  // Content sandbox enabled, but level doesn't include file I/O sandboxing.
  ok(isFileIOSandboxed, "content file I/O sandboxing is enabled.");
  if (!isFileIOSandboxed) {
    info("content sandbox level too low for file I/O tests, exiting\n");
    return;
  }

  // Test creating a file in the home directory from a web content process
  add_task(createFileInHome);

  // Test creating a file content temp from a web content process
  add_task(createTempFile);

  // Test reading files/dirs from web and file content processes
  add_task(testFileAccess);
});

// Test if the content process can create in $HOME, this should fail
async function createFileInHome() {
  let browser = gBrowser.selectedBrowser;
  let homeFile = fileInHomeDir();
  let path = homeFile.path;
  let fileCreated = await SpecialPowers.spawn(browser, [path], createFile);
  ok(!fileCreated, "creating a file in home dir is not permitted");
  if (fileCreated) {
    // content process successfully created the file, now remove it
    homeFile.remove(false);
  }
}

// Test if the content process can create a temp file, this is disallowed on
// macOS but allowed everywhere else. Also test that the content process cannot
// create symlinks or delete files.
async function createTempFile() {
  let browser = gBrowser.selectedBrowser;
  let path = fileInTempDir().path;
  let fileCreated = await SpecialPowers.spawn(browser, [path], createFile);
  if (isMac()) {
    ok(!fileCreated, "creating a file in content temp is not permitted");
  } else {
    ok(!!fileCreated, "creating a file in content temp is permitted");
  }
  // now delete the file
  let fileDeleted = await SpecialPowers.spawn(browser, [path], deleteFile);
  if (isMac()) {
    // On macOS we do not allow file deletion - it is not needed by the content
    // process itself, and macOS uses a different permission to control access
    // so revoking it is easy.
    ok(!fileDeleted, "deleting a file in content temp is not permitted");

    let path = fileInTempDir().path;
    let symlinkCreated = await SpecialPowers.spawn(
      browser,
      [path],
      createSymlink
    );
    ok(!symlinkCreated, "created a symlink in content temp is not permitted");
  } else {
    ok(!!fileDeleted, "deleting a file in content temp is permitted");
  }
}

// Test reading files and dirs from web and file content processes.
async function testFileAccess() {
  // for tests that run in a web content process
  let webBrowser = gBrowser.selectedBrowser;

  // Ensure that the file content process is enabled.
  let fileContentProcessEnabled = Services.prefs.getBoolPref(
    "browser.tabs.remote.separateFileUriProcess"
  );
  ok(fileContentProcessEnabled, "separate file content process is enabled");

  // for tests that run in a file content process
  let fileBrowser = undefined;
  if (fileContentProcessEnabled) {
    // open a tab in a file content process
    gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser, "about:blank", {
      preferredRemoteType: "file",
    });
    // get the browser for the file content process tab
    fileBrowser = gBrowser.getBrowserForTab(gBrowser.selectedTab);
  }

  // Current level
  let level = Services.prefs.getIntPref("security.sandbox.content.level");

  // Directories/files to test accessing from content processes.
  // For directories, we test whether a directory listing is allowed
  // or blocked. For files, we test if we can read from the file.
  // Each entry in the array represents a test file or directory
  // that will be read from either a web or file process.
  let tests = [];

  let profileDir = GetProfileDir();
  tests.push({
    desc: "profile dir", // description
    ok: false, // expected to succeed?
    browser: webBrowser, // browser to run test in
    file: profileDir, // nsIFile object
    minLevel: minProfileReadSandboxLevel(), // min level to enable test
    func: readDir,
  });
  if (fileContentProcessEnabled) {
    tests.push({
      desc: "profile dir",
      ok: true,
      browser: fileBrowser,
      file: profileDir,
      minLevel: 0,
      func: readDir,
    });
  }

  let homeDir = GetHomeDir();
  tests.push({
    desc: "home dir",
    ok: false,
    browser: webBrowser,
    file: homeDir,
    minLevel: minHomeReadSandboxLevel(),
    func: readDir,
  });
  if (fileContentProcessEnabled) {
    tests.push({
      desc: "home dir",
      ok: true,
      browser: fileBrowser,
      file: homeDir,
      minLevel: 0,
      func: readDir,
    });
  }

  let sysExtDevDir = GetSystemExtensionsDevDir();
  tests.push({
    desc: "system extensions dev dir",
    ok: true,
    browser: webBrowser,
    file: sysExtDevDir,
    minLevel: 0,
    func: readDir,
  });

  if (isWin()) {
    let extDir = GetPerUserExtensionDir();
    tests.push({
      desc: "per-user extensions dir",
      ok: true,
      browser: webBrowser,
      file: extDir,
      minLevel: minHomeReadSandboxLevel(),
      func: readDir,
    });
  }

  if (isMac()) {
    // If ~/Library/Caches/TemporaryItems exists, when level <= 2 we
    // make sure it's readable. For level 3, we make sure it isn't.
    let homeTempDir = GetHomeDir();
    homeTempDir.appendRelativePath("Library/Caches/TemporaryItems");
    if (homeTempDir.exists()) {
      let shouldBeReadable, minLevel;
      if (level >= minHomeReadSandboxLevel()) {
        shouldBeReadable = false;
        minLevel = minHomeReadSandboxLevel();
      } else {
        shouldBeReadable = true;
        minLevel = 0;
      }
      tests.push({
        desc: "home library cache temp dir",
        ok: shouldBeReadable,
        browser: webBrowser,
        file: homeTempDir,
        minLevel,
        func: readDir,
      });
    }
  }

  if (isMac() || isLinux()) {
    let varDir = GetDir("/var");

    if (isMac()) {
      // Mac sandbox rules use /private/var because /var is a symlink
      // to /private/var on OS X. Make sure that hasn't changed.
      varDir.normalize();
      Assert.ok(
        varDir.path === "/private/var",
        "/var resolves to /private/var"
      );
    }

    tests.push({
      desc: "/var",
      ok: false,
      browser: webBrowser,
      file: varDir,
      minLevel: minHomeReadSandboxLevel(),
      func: readDir,
    });
    if (fileContentProcessEnabled) {
      tests.push({
        desc: "/var",
        ok: true,
        browser: fileBrowser,
        file: varDir,
        minLevel: 0,
        func: readDir,
      });
    }
  }

  // Test /proc/self/fd, because that can be used to unfreeze
  // frozen shared memory.
  if (isLinux()) {
    let selfFdDir = GetDir("/proc/self/fd");

    tests.push({
      desc: "/proc/self/fd",
      ok: false,
      browser: webBrowser,
      file: selfFdDir,
      minLevel: isContentFileIOSandboxed(),
      func: readDir,
    });
  }

  if (isMac()) {
    // Test if we can read from $TMPDIR because we expect it
    // to be within /private/var. Reading from it should be
    // prevented in a 'web' process.
    let macTempDir = GetDirFromEnvVariable("TMPDIR");

    macTempDir.normalize();
    Assert.ok(
      macTempDir.path.startsWith("/private/var"),
      "$TMPDIR is in /private/var"
    );

    tests.push({
      desc: `$TMPDIR (${macTempDir.path})`,
      ok: false,
      browser: webBrowser,
      file: macTempDir,
      minLevel: minHomeReadSandboxLevel(),
      func: readDir,
    });
    if (fileContentProcessEnabled) {
      tests.push({
        desc: `$TMPDIR (${macTempDir.path})`,
        ok: true,
        browser: fileBrowser,
        file: macTempDir,
        minLevel: 0,
        func: readDir,
      });
    }

    // Test that we cannot read from /Volumes at level 3
    let volumes = GetDir("/Volumes");
    tests.push({
      desc: "/Volumes",
      ok: false,
      browser: webBrowser,
      file: volumes,
      minLevel: minHomeReadSandboxLevel(),
      func: readDir,
    });

    // /Network is not present on macOS 10.15 (xnu 19). Don't
    // test this directory on 10.15 and later.
    if (AppConstants.isPlatformAndVersionAtMost("macosx", 18)) {
      // Test that we cannot read from /Network at level 3
      let network = GetDir("/Network");
      tests.push({
        desc: "/Network",
        ok: false,
        browser: webBrowser,
        file: network,
        minLevel: minHomeReadSandboxLevel(),
        func: readDir,
      });
    }
    // Test that we cannot read from /Users at level 3
    let users = GetDir("/Users");
    tests.push({
      desc: "/Users",
      ok: false,
      browser: webBrowser,
      file: users,
      minLevel: minHomeReadSandboxLevel(),
      func: readDir,
    });

    // Test that we can stat /Users at level 3
    tests.push({
      desc: "/Users",
      ok: true,
      browser: webBrowser,
      file: users,
      minLevel: minHomeReadSandboxLevel(),
      func: statPath,
    });

    // Test that we can stat /Library at level 3, but can't get a
    // directory listing of /Library. This test uses "/Library"
    // because it's a path that is expected to always be present.
    let libraryDir = GetDir("/Library");
    tests.push({
      desc: "/Library",
      ok: true,
      browser: webBrowser,
      file: libraryDir,
      minLevel: minHomeReadSandboxLevel(),
      func: statPath,
    });
    tests.push({
      desc: "/Library",
      ok: false,
      browser: webBrowser,
      file: libraryDir,
      minLevel: minHomeReadSandboxLevel(),
      func: readDir,
    });

    // Similarly, test that we can stat /private, but not /private/etc.
    let privateDir = GetDir("/private");
    tests.push({
      desc: "/private",
      ok: true,
      browser: webBrowser,
      file: privateDir,
      minLevel: minHomeReadSandboxLevel(),
      func: statPath,
    });
  }

  let extensionsDir = GetProfileEntry("extensions");
  if (extensionsDir.exists() && extensionsDir.isDirectory()) {
    tests.push({
      desc: "extensions dir",
      ok: true,
      browser: webBrowser,
      file: extensionsDir,
      minLevel: 0,
      func: readDir,
    });
  } else {
    ok(false, `${extensionsDir.path} is a valid dir`);
  }

  let chromeDir = GetProfileEntry("chrome");
  if (chromeDir.exists() && chromeDir.isDirectory()) {
    tests.push({
      desc: "chrome dir",
      ok: true,
      browser: webBrowser,
      file: chromeDir,
      minLevel: 0,
      func: readDir,
    });
  } else {
    ok(false, `${chromeDir.path} is valid dir`);
  }

  let cookiesFile = GetProfileEntry("cookies.sqlite");
  if (cookiesFile.exists() && !cookiesFile.isDirectory()) {
    tests.push({
      desc: "cookies file",
      ok: false,
      browser: webBrowser,
      file: cookiesFile,
      minLevel: minProfileReadSandboxLevel(),
      func: readFile,
    });
    if (fileContentProcessEnabled) {
      tests.push({
        desc: "cookies file",
        ok: true,
        browser: fileBrowser,
        file: cookiesFile,
        minLevel: 0,
        func: readFile,
      });
    }
  } else {
    ok(false, `${cookiesFile.path} is a valid file`);
  }

  // remove tests not enabled by the current sandbox level
  tests = tests.filter(test => test.minLevel <= level);

  for (let test of tests) {
    let okString = test.ok ? "allowed" : "blocked";
    let processType = test.browser === webBrowser ? "web" : "file";

    // ensure the file/dir exists before we ask a content process to stat
    // it so we know a failure is not due to a nonexistent file/dir
    if (test.func === statPath) {
      ok(test.file.exists(), `${test.file.path} exists`);
    }

    let result = await ContentTask.spawn(
      test.browser,
      test.file.path,
      test.func
    );

    ok(
      result.ok == test.ok,
      `reading ${test.desc} from a ${processType} process ` +
        `is ${okString} (${test.file.path})`
    );

    // if the directory is not expected to be readable,
    // ensure the listing has zero entries
    if (test.func === readDir && !test.ok) {
      ok(result.numEntries == 0, `directory list is empty (${test.file.path})`);
    }
  }

  if (fileContentProcessEnabled) {
    gBrowser.removeTab(gBrowser.selectedTab);
  }
}
