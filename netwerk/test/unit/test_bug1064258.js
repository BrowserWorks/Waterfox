/**
 * Check how nsICachingChannel.cacheOnlyMetadata works.
 * - all channels involved in this test are set cacheOnlyMetadata = true
 * - do a previously uncached request for a long living content
 * - check we have downloaded the content from the server (channel provides it)
 * - check the entry has metadata, but zero-length content
 * - load the same URL again, now cached
 * - check the channel is giving no content (no call to OnDataAvailable) but succeeds
 * - repeat again, but for a different URL that is not cached (immediately expires)
 * - only difference is that we get a newer version of the content from the server during the second request
 */

Cu.import("resource://testing-common/httpd.js");
Cu.import("resource://gre/modules/NetUtil.jsm");

XPCOMUtils.defineLazyGetter(this, "URL", function() {
  return "http://localhost:" + httpServer.identity.primaryPort;
});

var httpServer = null;

function make_channel(url, callback, ctx) {
  return NetUtil.newChannel({uri: url, loadUsingSystemPrincipal: true});
}

const responseBody1 = "response body 1";
const responseBody2a = "response body 2a";
const responseBody2b = "response body 2b";

function contentHandler1(metadata, response)
{
  response.setHeader("Content-Type", "text/plain");
  response.setHeader("Cache-control", "max-age=999999");
  response.bodyOutputStream.write(responseBody1, responseBody1.length);
}

var content2passCount = 0;

function contentHandler2(metadata, response)
{
  response.setHeader("Content-Type", "text/plain");
  response.setHeader("Cache-control", "no-cache");
  switch (content2passCount++) {
    case 0:
      response.setHeader("ETag", "testetag");
      response.bodyOutputStream.write(responseBody2a, responseBody2a.length);
      break;
    case 1:
      do_check_true(metadata.hasHeader("If-None-Match"));
      do_check_eq(metadata.getHeader("If-None-Match"), "testetag");
      response.bodyOutputStream.write(responseBody2b, responseBody2b.length);
      break;
    default:
      throw "Unexpected request in the test";
  }
}


function run_test()
{
  httpServer = new HttpServer();
  httpServer.registerPathHandler("/content1", contentHandler1);
  httpServer.registerPathHandler("/content2", contentHandler2);
  httpServer.start(-1);

  run_test_content1a();
  do_test_pending();
}

function run_test_content1a()
{
  var chan = make_channel(URL + "/content1");
  caching = chan.QueryInterface(Ci.nsICachingChannel);
  caching.cacheOnlyMetadata = true;
  chan.asyncOpen2(new ChannelListener(contentListener1a, null));
}

function contentListener1a(request, buffer)
{
  do_check_eq(buffer, responseBody1);

  asyncOpenCacheEntry(URL + "/content1", "disk", 0, null, cacheCheck1)
}

function cacheCheck1(status, entry)
{
  do_check_eq(status, 0);
  do_check_eq(entry.dataSize, 0);
  try {
    do_check_neq(entry.getMetaDataElement("response-head"), null);
  }
  catch (ex) {
    do_throw("Missing response head");
  }

  var chan = make_channel(URL + "/content1");
  caching = chan.QueryInterface(Ci.nsICachingChannel);
  caching.cacheOnlyMetadata = true;
  chan.asyncOpen2(new ChannelListener(contentListener1b, null, CL_IGNORE_CL));
}

function contentListener1b(request, buffer)
{
  request.QueryInterface(Ci.nsIHttpChannel);
  do_check_eq(request.requestMethod, "GET");
  do_check_eq(request.responseStatus, 200);
  do_check_eq(request.getResponseHeader("Cache-control"), "max-age=999999");

  do_check_eq(buffer, "");
  run_test_content2a();
}

// Now same set of steps but this time for an immediately expiring content.

function run_test_content2a()
{
  var chan = make_channel(URL + "/content2");
  caching = chan.QueryInterface(Ci.nsICachingChannel);
  caching.cacheOnlyMetadata = true;
  chan.asyncOpen2(new ChannelListener(contentListener2a, null));
}

function contentListener2a(request, buffer)
{
  do_check_eq(buffer, responseBody2a);

  asyncOpenCacheEntry(URL + "/content2", "disk", 0, null, cacheCheck2)
}

function cacheCheck2(status, entry)
{
  do_check_eq(status, 0);
  do_check_eq(entry.dataSize, 0);
  try {
    do_check_neq(entry.getMetaDataElement("response-head"), null);
    do_check_true(entry.getMetaDataElement("response-head").match('etag: testetag'));
  }
  catch (ex) {
    do_throw("Missing response head");
  }

  var chan = make_channel(URL + "/content2");
  caching = chan.QueryInterface(Ci.nsICachingChannel);
  caching.cacheOnlyMetadata = true;
  chan.asyncOpen2(new ChannelListener(contentListener2b, null));
}

function contentListener2b(request, buffer)
{
  do_check_eq(buffer, responseBody2b);

  httpServer.stop(do_test_finished);
}
