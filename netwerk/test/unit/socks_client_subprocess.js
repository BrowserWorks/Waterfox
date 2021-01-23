/* global arguments */

"use strict";

var CC = Components.Constructor;

var dns = Cc["@mozilla.org/network/dns-service;1"].getService(Ci.nsIDNSService);

const BinaryInputStream = CC(
  "@mozilla.org/binaryinputstream;1",
  "nsIBinaryInputStream",
  "setInputStream"
);
const ProtocolProxyService = CC(
  "@mozilla.org/network/protocol-proxy-service;1",
  "nsIProtocolProxyService"
);
var sts = Cc["@mozilla.org/network/socket-transport-service;1"].getService(
  Ci.nsISocketTransportService
);

function launchConnection(socks_vers, socks_port, dest_host, dest_port, dns) {
  var pi_flags = 0;
  if (dns == "remote") {
    pi_flags = Ci.nsIProxyInfo.TRANSPARENT_PROXY_RESOLVES_HOST;
  }

  var pps = new ProtocolProxyService();
  var pi = pps.newProxyInfo(
    socks_vers,
    "localhost",
    socks_port,
    "",
    "",
    pi_flags,
    -1,
    null
  );
  var trans = sts.createTransport([], dest_host, dest_port, pi);
  var input = trans.openInputStream(Ci.nsITransport.OPEN_BLOCKING, 0, 0);
  var output = trans.openOutputStream(Ci.nsITransport.OPEN_BLOCKING, 0, 0);
  var bin = new BinaryInputStream(input);
  var data = bin.readBytes(5);
  if (data == "PING!") {
    print("client: got ping, sending pong.");
    output.write("PONG!", 5);
  } else {
    print("client: wrong data from server:", data);
    output.write("Error: wrong data received.", 27);
  }
  output.close();
}

for (var arg of arguments) {
  print("client: running test", arg);
  let test = arg.split("|");
  launchConnection(
    test[0],
    parseInt(test[1]),
    test[2],
    parseInt(test[3]),
    test[4]
  );
}
