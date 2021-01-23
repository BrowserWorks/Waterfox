"use strict";
// https://bugzilla.mozilla.org/show_bug.cgi?id=760955

const { HttpServer } = ChromeUtils.import("resource://testing-common/httpd.js");

var httpServer = null;
const testFileName = "test_nsHttpChannel_CacheForOfflineUse-no-store";
const cacheClientID = testFileName + "|fake-group-id";
const basePath = "/" + testFileName + "/";

XPCOMUtils.defineLazyGetter(this, "baseURI", function() {
  return "http://localhost:" + httpServer.identity.primaryPort + basePath;
});

const normalEntry = "normal";
const noStoreEntry = "no-store";

var cacheUpdateObserver = null;
var appCache = null;

function make_channel_for_offline_use(url, callback, ctx) {
  var chan = NetUtil.newChannel({ uri: url, loadUsingSystemPrincipal: true });

  var cacheService = Cc[
    "@mozilla.org/network/application-cache-service;1"
  ].getService(Ci.nsIApplicationCacheService);
  appCache = cacheService.getApplicationCache(cacheClientID);

  var appCacheChan = chan.QueryInterface(Ci.nsIApplicationCacheChannel);
  appCacheChan.applicationCacheForWrite = appCache;
  return chan;
}

function make_uri(url) {
  var ios = Cc["@mozilla.org/network/io-service;1"].getService(Ci.nsIIOService);
  return ios.newURI(url);
}

const responseBody = "response body";

// A HTTP channel for updating the offline cache should normally succeed.
function normalHandler(metadata, response) {
  info("normalHandler");
  response.setHeader("Content-Type", "text/plain");
  response.bodyOutputStream.write(responseBody, responseBody.length);
}
function checkNormal(request, buffer) {
  Assert.equal(buffer, responseBody);
  asyncCheckCacheEntryPresence(
    baseURI + normalEntry,
    "appcache",
    true,
    run_next_test,
    appCache
  );
}
add_test(function test_normal() {
  var chan = make_channel_for_offline_use(baseURI + normalEntry);
  chan.asyncOpen(new ChannelListener(checkNormal, chan));
});

// An HTTP channel for updating the offline cache should fail when it gets a
// response with Cache-Control: no-store.
function noStoreHandler(metadata, response) {
  info("noStoreHandler");
  response.setHeader("Content-Type", "text/plain");
  response.setHeader("Cache-Control", "no-store");
  response.bodyOutputStream.write(responseBody, responseBody.length);
}
function checkNoStore(request, buffer) {
  Assert.equal(buffer, "");
  asyncCheckCacheEntryPresence(
    baseURI + noStoreEntry,
    "appcache",
    false,
    run_next_test,
    appCache
  );
}
add_test(function test_noStore() {
  var chan = make_channel_for_offline_use(baseURI + noStoreEntry);
  // The no-store should cause the channel to fail to load.
  chan.asyncOpen(new ChannelListener(checkNoStore, chan, CL_EXPECT_FAILURE));
});

function run_test() {
  do_get_profile();

  var ps = Cc["@mozilla.org/preferences-service;1"].getService(
    Ci.nsIPrefBranch
  );
  ps.setBoolPref("browser.cache.offline.enable", true);
  ps.setBoolPref("browser.cache.offline.storage.enable", true);

  httpServer = new HttpServer();
  httpServer.registerPathHandler(basePath + normalEntry, normalHandler);
  httpServer.registerPathHandler(basePath + noStoreEntry, noStoreHandler);
  httpServer.start(-1);
  run_next_test();
}

function finish_test(request, buffer) {
  httpServer.stop(do_test_finished);
}
