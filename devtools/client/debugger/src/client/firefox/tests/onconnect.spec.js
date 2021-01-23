/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at <http://mozilla.org/MPL/2.0/>. */

// @flow

import { onConnect } from "../../firefox";

const threadFront = {
  on: () => {},
  reconfigure: () => {},
  getSources: () => {
    return {
      sources: [
        {
          id: "s.js",
          url: "file:///tmp/s.js",
        },
      ],
    };
  },
  getLastPausePacket: () => null,
  _parent: {
    addListener: () => {},
    listWorkers: () => new Promise(resolve => resolve({ workers: [] })),
  },
};

const targetList = {
  targetFront: {
    on: () => {},
    _form: {
      url: "url",
    },
    threadFront,
  },
};

const devToolsClient = {
  mainRoot: {
    traits: {},
  },
};

const actions = {
  _sources: [],
  connect: () => {},
  setWorkers: () => {},
  newSources: function(sources) {
    return new Promise(resolve => {
      setTimeout(() => {
        this._sources = sources;
        resolve();
      }, 0);
    });
  },
};

describe("firefox onConnect", () => {
  it("wait for sources at startup", async () => {
    await onConnect(
      {
        targetList,
        devToolsClient,
      },
      actions
    );
    expect(actions._sources).toHaveLength(1);
    expect(actions._sources[0].url).toEqual("file:///tmp/s.js");
  });
});
