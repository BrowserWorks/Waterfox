Cu.import("resource://testing-common/httpd.js");
Cu.import("resource://gre/modules/NetUtil.jsm");

var httpserver = new HttpServer();
var pass = 0;
var responseBody = [0x0B, 0x02, 0x80, 0x74, 0x65, 0x73, 0x74, 0x0A, 0x03];
var responseLen = 5;
var testUrl = "/test/brotli";


function setupChannel() {
    return NetUtil.newChannel({
        uri: "http://localhost:" + httpserver.identity.primaryPort + testUrl,
        loadUsingSystemPrincipal: true
    });
}

function Listener() {}

Listener.prototype = {
  _buffer: null,

  QueryInterface: function(iid) {
    if (iid.equals(Components.interfaces.nsIStreamListener) ||
        iid.equals(Components.interfaces.nsIRequestObserver) ||
        iid.equals(Components.interfaces.nsISupports))
      return this;
    throw Components.results.NS_ERROR_NO_INTERFACE;
  },

  onStartRequest: function(request, ctx) {
    do_check_eq(request.status, Cr.NS_OK);
    this._buffer = "";
  },

  onDataAvailable: function(request, cx, stream, offset, cnt) {
    if (pass == 0) {
      this._buffer = this._buffer.concat(read_stream(stream, cnt));
    } else {
      request.QueryInterface(Ci.nsICachingChannel);
      if (!request.isFromCache()) {
        do_throw("Response is not from the cache");
      }

      request.cancel(Cr.NS_ERROR_ABORT);
    }
  },

  onStopRequest: function(request, ctx, status) {
    if (pass == 0) {
      do_check_eq(this._buffer.length, responseLen);
      pass++;

      var channel = setupChannel();
      channel.loadFlags = Ci.nsIRequest.VALIDATE_NEVER;
      channel.asyncOpen2(new Listener());
    } else {
      httpserver.stop(do_test_finished);
      prefs.setCharPref("network.http.accept-encoding", cePref);
    }
  }
};

var prefs;
var cePref;
function run_test() {
  do_get_profile();

  prefs = Cc["@mozilla.org/preferences-service;1"].getService(Ci.nsIPrefBranch);
  cePref = prefs.getCharPref("network.http.accept-encoding");
  prefs.setCharPref("network.http.accept-encoding", "gzip, deflate, br");

  // Disable rcwn to make cache behavior deterministic.
  prefs.setBoolPref("network.http.rcwn.enabled", false);

  httpserver.registerPathHandler(testUrl, handler);
  httpserver.start(-1);

  var channel = setupChannel();
  channel.asyncOpen2(new Listener());

  do_test_pending();
}

function handler(metadata, response) {
  do_check_eq(pass, 0); // the second response must be server from the cache

  response.setStatusLine(metadata.httpVersion, 200, "OK");
  response.setHeader("Content-Type", "text/plain", false);
  response.setHeader("Content-Encoding", "br", false);
  response.setHeader("Content-Length", "" + responseBody.length, false);

  var bos = Components.classes["@mozilla.org/binaryoutputstream;1"]
            .createInstance(Components.interfaces.nsIBinaryOutputStream);
  bos.setOutputStream(response.bodyOutputStream);

  response.processAsync();
  bos.writeByteArray(responseBody, responseBody.length);
  response.finish();
}
