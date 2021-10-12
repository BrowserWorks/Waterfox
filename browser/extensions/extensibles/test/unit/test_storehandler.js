/* Any copyright is dedicated to the Public Domain.
http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const MANIFESTS = {
  success: {},
  fail: {},
};

const UNSUPPORTED_APIS = [
  "externally_connectable",
  "storage",
  "chrome_settings_overrides.search_provider.alternate_urls",
  "chrome_settings_overrides.search_provider.image_url",
  "chrome_settings_overrides.search_provider.image_url_post_params",
  "chrome_settings_overrides.search_provider.instant_url",
  "chrome_settings_overrides.search_provider.instant_url_post_params",
  "chrome_settings_overrides.search_provider.prepopulated_id",
  "chrome_settings_overrides.startup_pages",
  "chrome_url_overrides.bookmarks",
  "chrome_url_overrides.history",
  "commands.global",
  "incognito: split",
  "offline_enabled",
  "optional_permissions.background",
  "optional_permissions.contentSettings",
  "optional_permissions.contextMenus",
  "optional_permissions.debugger",
  "optional_permissions.pageCapture",
  "optional_permissions.tabCapture",
  "options_page",
  "permissions.background",
  "permissions.contentSettings",
  "permissions.debugger",
  "permissions.pageCapture",
  "permissions.tabCapture",
  "version_name",
];

const profileDir = gProfD.clone();
profileDir.append("extensions");

function arraysEqual(arr1, arr2) {
  if (arr1.length !== arr2.length) return false;
  for (var i = arr1.length; i--; ) {
    if (arr1[i] !== arr2[i]) return false;
  }

  return true;
}

add_task(async function setup() {
  await promiseStartupManager();
});

// test remove chrome headers
add_task(async function test_remove_chrome_header() {
  // set up example crx file
  let crx = OS.Path.join(profileDir.path, "test.crx");
  let testCrx = do_get_file("data/test.crx");
  testCrx.copyTo(profileDir, "test.crx");
  // call StoreHandler func
  let sh = new StoreHandler();
  let res = await sh._removeChromeHeaders(crx);
  equal(res, true);
  // assert that reading the updated crx starts with correct bytes
  let updatedCrx = await OS.File.read(crx);
  let magic = new Uint8Array(updatedCrx.slice(0, 4));
  equal(JSON.stringify(Array.from(magic)), JSON.stringify([80, 75, 3, 4]));
  // corrupt file (no zip magic) should fail
  let small = "data/invalid.xpi";
  let res2 = await sh._removeChromeHeaders(small);
  equal(res2, false);
});

add_task(async function test_parse_manifest() {
  // parse manifest
  let xpi = do_get_file("data/nolocale.xpi");
  let zr = new ZipReader(xpi);
  let res = new StoreHandler()._parseManifest(zr);
  equal(typeof res, "object");
});

add_task(async function test_locale_check() {
  // _locales and subdir en present, no default_locale in manifest
  let locale = do_get_file("data/locale.xpi");
  let zr = new ZipReader(locale);
  let manifest = StoreHandler._parseManifest(zr);
  equal(manifest.default_locale, undefined);
  let res = StoreHandler._localeCheck(manifest, zr);
  // en should be added as default_locale
  equal(res.default_locale, "en");
  // _locales not present, default_locale in manifest
  let noLocale = do_get_file("data/nolocale.xpi");
  let zr2 = new ZipReader(noLocale);
  let manifest2 = StoreHandler._parseManifest(zr2);
  equal(manifest2.default_locale, "en");
  let res2 = StoreHandler._localeCheck(manifest2, zr2);
  // default_locale should be deleted from manifest
  equal(res2.default_locale, undefined);
});

add_task(async function test_compat_check() {
  // compat check
  let manifestFile = do_get_file("data/failure_manifest.json");
  let inputStream = new FileStream(manifestFile, -1, -1, null);
  let rsi = new ReusableStreamInstance(inputStream);
  let fileContents = rsi.read(manifestFile.fileSize);
  let manifest = JSON.parse(fileContents);
  let manifestRes = StoreHandler._manifestCompatCheck(manifest);
  // should return list of all unsupported APIs
  equal(arraysEqual(manifestRes, UNSUPPORTED_APIS), true);
});

add_task(async function test_amend_manifest() {
  let xpi = do_get_file("data/high_manifest.xpi");
  let xpi2 = do_get_file("data/no_manifest.xpi");
  let xpi3 = do_get_file("data/unsupported.xpi");
  // fail if manifest v > 2
  let res = StoreHandler._amendManifest(xpi);
  equal(res, false);
  // manifest_version not present
  let res2 = StoreHandler._amendManifest(xpi2);
  equal(res, false);
  // if unsupportedAPIs return Array, else Object
  let res3 = StoreHandler._amendManifest(xpi3);
  equal(Array.isArray(res3), true);
  equal(arraysEqual(res3, UNSUPPORTED_APIS), true);
  // stringify manifest
  // if successful should add id and delete update url
  let xpi4 = do_get_file("data/locale.xpi");
  let manifest = JSON.parse(StoreHandler._amendManifest(xpi4));
  equal(typeof manifest.applications.gecko.id, "string");
  equal(manifest.update_url, undefined);
});

// test replace xpi manifest
add_task(async function test_replace_manifest() {});
// test install updated addon
add_task(async function test_install_xpi() {});
