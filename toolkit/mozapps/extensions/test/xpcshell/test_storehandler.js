/* Any copyright is dedicated to the Public Domain.
http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const MANIFESTS = {
  success: {

  },
  fail: {

  }
};

const profileDir = gProfD.clone();
profileDir.append("extensions");

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
  let res = await StoreHandler._removeChromeHeaders(crx);
  equal(res, true);
  // assert that reading the updated crx starts with correct bytes
  let updatedCrx = await OS.File.read(crx);
  let magic = new Uint8Array(updatedCrx.slice(0,4));
  equal(JSON.stringify(Array.from(magic)), JSON.stringify([80,75,3,4]));
  // corrupt file (no zip magic) should fail
  let small = "data/invalid.xpi";
  let res2 = await StoreHandler._removeChromeHeaders(small);
  equal(res2, false);
});

add_task(async function test_parse_manifest() {
  // parse manifest
  let xpi = do_get_file("data/nolocale.xpi");
  let zr = new ZipReader(xpi);
  let res = StoreHandler._parseManifest(zr);
  equal(typeof res, "object");
});

add_task(async function test_locale_check() {
  // _locales and subdir en present, no default_locale in manifest
  let locale = do_get_file("data/locale.xpi")
  let zr = new ZipReader(locale);
  let manifest = StoreHandler._parseManifest(zr);
  equal(manifest.default_locale, undefined);
  let res = StoreHandler._localeCheck(manifest, zr);
  // en should be added as default_locale
  equal(res.default_locale, "en")
  // _locales not present, default_locale in manifest
  let noLocale = do_get_file("data/nolocale.xpi");
  let zr2 = new ZipReader(noLocale);
  let manifest2 = StoreHandler._parseManifest(zr2);
  equal(manifest2.default_locale, "en");
  let res2 = StoreHandler._localeCheck(manifest2, zr2);
  // default_locale should be deleted from manifest
  equal(res2.default_locale, undefined);
}).only();

add_task(async function test_compat_check() {
  // compat check
  // should return list of all unsupported APIs
});

add_task(async function test_amend_manifest() {
  // fail if manifest v > 2
  // manifest_version not present
  // if unsupportedAPIs return Array, else Object
  // add guid
  // delete update url
  // stringify manifest
// failure
});

// test write tmp manifest
add_task(async function test_write_tmp_manifest() {

});
// failure
// test replace xpi manifest
add_task(async function test_replace_manifest() {

});
// failure
// test install updated addon
add_task(async function test_install_xpi() {

});
// failure
