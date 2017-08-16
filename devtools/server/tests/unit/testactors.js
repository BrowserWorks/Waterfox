/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const { ActorPool, appendExtraActors, createExtraActors } = require("devtools/server/actors/common");
const { RootActor } = require("devtools/server/actors/root");
const { ThreadActor } = require("devtools/server/actors/script");
const { DebuggerServer } = require("devtools/server/main");
const { TabSources } = require("devtools/server/actors/utils/TabSources");
const makeDebugger = require("devtools/server/actors/utils/make-debugger");

var gTestGlobals = [];
DebuggerServer.addTestGlobal = function (global) {
  gTestGlobals.push(global);
};

DebuggerServer.getTestGlobal = function (name) {
  for (let g of gTestGlobals) {
    if (g.__name == name) {
      return g;
    }
  }

  return null;
};

// A mock tab list, for use by tests. This simply presents each global in
// gTestGlobals as a tab, and the list is fixed: it never calls its
// onListChanged handler.
//
// As implemented now, we consult gTestGlobals when we're constructed, not
// when we're iterated over, so tests have to add their globals before the
// root actor is created.
function TestTabList(connection) {
  this.conn = connection;

  // An array of actors for each global added with
  // DebuggerServer.addTestGlobal.
  this._tabActors = [];

  // A pool mapping those actors' names to the actors.
  this._tabActorPool = new ActorPool(connection);

  for (let global of gTestGlobals) {
    let actor = new TestTabActor(connection, global);
    actor.selected = false;
    this._tabActors.push(actor);
    this._tabActorPool.addActor(actor);
  }
  if (this._tabActors.length > 0) {
    this._tabActors[0].selected = true;
  }

  connection.addActorPool(this._tabActorPool);
}

TestTabList.prototype = {
  constructor: TestTabList,
  getList: function () {
    return Promise.resolve([...this._tabActors]);
  }
};

function createRootActor(connection) {
  let root = new RootActor(connection, {
    tabList: new TestTabList(connection),
    globalActorFactories: DebuggerServer.globalActorFactories,
  });

  root.applicationType = "xpcshell-tests";
  return root;
}

function TestTabActor(connection, global) {
  this.conn = connection;
  this._global = global;
  this._global.wrappedJSObject = global;
  this.threadActor = new ThreadActor(this, this._global);
  this.conn.addActor(this.threadActor);
  this._attached = false;
  this._extraActors = {};
  this.makeDebugger = makeDebugger.bind(null, {
    findDebuggees: () => [this._global],
    shouldAddNewGlobalAsDebuggee: g => g.hostAnnotations &&
                                       g.hostAnnotations.type == "document" &&
                                       g.hostAnnotations.element === this._global

  });
}

TestTabActor.prototype = {
  constructor: TestTabActor,
  actorPrefix: "TestTabActor",

  get window() {
    return this._global;
  },

  get url() {
    return this._global.__name;
  },

  get sources() {
    if (!this._sources) {
      this._sources = new TabSources(this.threadActor);
    }
    return this._sources;
  },

  form: function () {
    let response = { actor: this.actorID, title: this._global.__name };

    // Walk over tab actors added by extensions and add them to a new ActorPool.
    let actorPool = new ActorPool(this.conn);
    this._createExtraActors(DebuggerServer.tabActorFactories, actorPool);
    if (!actorPool.isEmpty()) {
      this._tabActorPool = actorPool;
      this.conn.addActorPool(this._tabActorPool);
    }

    this._appendExtraActors(response);

    return response;
  },

  onAttach: function (request) {
    this._attached = true;

    let response = { type: "tabAttached", threadActor: this.threadActor.actorID };
    this._appendExtraActors(response);

    return response;
  },

  onDetach: function (request) {
    if (!this._attached) {
      return { "error": "wrongState" };
    }
    return { type: "detached" };
  },

  onReload: function (request) {
    this.sources.reset({ sourceMaps: true });
    this.threadActor.clearDebuggees();
    this.threadActor.dbg.addDebuggees();
    return {};
  },

  removeActorByName: function (name) {
    const actor = this._extraActors[name];
    if (this._tabActorPool) {
      this._tabActorPool.removeActor(actor);
    }
    delete this._extraActors[name];
  },

  /* Support for DebuggerServer.addTabActor. */
  _createExtraActors: createExtraActors,
  _appendExtraActors: appendExtraActors
};

TestTabActor.prototype.requestTypes = {
  "attach": TestTabActor.prototype.onAttach,
  "detach": TestTabActor.prototype.onDetach,
  "reload": TestTabActor.prototype.onReload
};

exports.register = function (handle) {
  handle.setRootActor(createRootActor);
};

exports.unregister = function (handle) {
  handle.setRootActor(null);
};
