/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const { RootActor } = require("devtools/server/actors/root");

function test_requestTypes_request(client, anActor) {
  client.request({ to: "root", type: "requestTypes" }, function (response) {
    let expectedRequestTypes = Object.keys(RootActor
                                           .prototype
                                           .requestTypes);

    do_check_true(Array.isArray(response.requestTypes));
    do_check_eq(JSON.stringify(response.requestTypes),
                JSON.stringify(expectedRequestTypes));

    client.close().then(() => {
      do_test_finished();
    });
  });
}

function run_test() {
  DebuggerServer.init();
  DebuggerServer.addBrowserActors();

  let client = new DebuggerClient(DebuggerServer.connectPipe());
  client.connect().then(function () {
    test_requestTypes_request(client);
  });

  do_test_pending();
}
