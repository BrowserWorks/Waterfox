/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Make sure we get replies in the same order that we sent their
 * requests even when earlier requests take several event ticks to
 * complete.
 */

var protocol = require("devtools/shared/protocol");
var { Arg, RetVal } = protocol;

function simpleHello() {
  return {
    from: "root",
    applicationType: "xpcshell-tests",
    traits: [],
  };
}

const rootSpec = protocol.generateActorSpec({
  typeName: "root",

  methods: {
    simpleReturn: {
      response: { value: RetVal() },
    },
    promiseReturn: {
      request: { toWait: Arg(0, "number") },
      response: { value: RetVal("number") },
    },
    simpleThrow: {
      response: { value: RetVal("number") },
    },
    promiseThrow: {
      response: { value: RetVal("number") },
    },
  },
});

var RootActor = protocol.ActorClassWithSpec(rootSpec, {
  initialize: function(conn) {
    protocol.Actor.prototype.initialize.call(this, conn);
    // Root actor owns itself.
    this.manage(this);
    this.actorID = "root";
    this.sequence = 0;
  },

  sayHello: simpleHello,

  simpleReturn: function() {
    return this.sequence++;
  },

  promiseReturn: function(toWait) {
    // Guarantee that this resolves after simpleReturn returns.
    const deferred = defer();
    const sequence = this.sequence++;

    // Wait until the number of requests specified by toWait have
    // happened, to test queuing.
    const check = () => {
      if (this.sequence - sequence < toWait) {
        executeSoon(check);
        return;
      }
      deferred.resolve(sequence);
    };
    executeSoon(check);

    return deferred.promise;
  },

  simpleThrow: function() {
    throw new Error(this.sequence++);
  },

  promiseThrow: function() {
    // Guarantee that this resolves after simpleReturn returns.
    const deferred = defer();
    let sequence = this.sequence++;
    // This should be enough to force a failure if the code is broken.
    do_timeout(150, () => {
      deferred.reject(sequence++);
    });
    return deferred.promise;
  },
});

class RootFront extends protocol.FrontClassWithSpec(rootSpec) {
  constructor(client) {
    super(client);
    this.actorID = "root";
    // Root owns itself.
    this.manage(this);
  }
}
protocol.registerFront(RootFront);

add_task(async function() {
  DevToolsServer.createRootActor = RootActor;
  DevToolsServer.init();

  const trace = connectPipeTracing();
  const client = new DevToolsClient(trace);
  await client.connect();

  const rootFront = client.mainRoot;

  const calls = [];
  let sequence = 0;

  // Execute a call that won't finish processing until 2
  // more calls have happened
  calls.push(
    rootFront.promiseReturn(2).then(ret => {
      // Check right return order
      Assert.equal(sequence, 0);
      // Check request handling order
      Assert.equal(ret, sequence++);
    })
  );

  // Put a few requests into the backlog

  calls.push(
    rootFront.simpleReturn().then(ret => {
      // Check right return order
      Assert.equal(sequence, 1);
      // Check request handling order
      Assert.equal(ret, sequence++);
    })
  );

  calls.push(
    rootFront.simpleReturn().then(ret => {
      // Check right return order
      Assert.equal(sequence, 2);
      // Check request handling order
      Assert.equal(ret, sequence++);
    })
  );

  calls.push(
    rootFront.simpleThrow().then(
      () => {
        Assert.ok(false, "simpleThrow shouldn't succeed!");
      },
      error => {
        // Check right return order
        Assert.equal(sequence++, 3);
      }
    )
  );

  // While packets are sent in the correct order, rejection handlers
  // registered in "Promise.jsm" may be invoked later than fulfillment
  // handlers, meaning that we can't check the actual order with certainty.
  const deferAfterRejection = defer();

  calls.push(
    rootFront.promiseThrow().then(
      () => {
        Assert.ok(false, "promiseThrow shouldn't succeed!");
      },
      error => {
        // Check right return order
        Assert.equal(sequence++, 4);
        Assert.ok(true, "simple throw should throw");
        deferAfterRejection.resolve();
      }
    )
  );

  calls.push(
    rootFront.simpleReturn().then(ret => {
      return deferAfterRejection.promise.then(function() {
        // Check right return order
        Assert.equal(sequence, 5);
        // Check request handling order
        Assert.equal(ret, sequence++);
      });
    })
  );

  // Break up the backlog with a long request that waits
  // for another simpleReturn before completing
  calls.push(
    rootFront.promiseReturn(1).then(ret => {
      return deferAfterRejection.promise.then(function() {
        // Check right return order
        Assert.equal(sequence, 6);
        // Check request handling order
        Assert.equal(ret, sequence++);
      });
    })
  );

  calls.push(
    rootFront.simpleReturn().then(ret => {
      return deferAfterRejection.promise.then(function() {
        // Check right return order
        Assert.equal(sequence, 7);
        // Check request handling order
        Assert.equal(ret, sequence++);
      });
    })
  );

  await Promise.all(calls);
  await client.close();
});
