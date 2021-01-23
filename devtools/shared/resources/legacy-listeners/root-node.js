/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {
  ResourceWatcher,
} = require("devtools/shared/resources/resource-watcher");

module.exports = async function({ targetList, targetFront, onAvailable }) {
  if (!targetFront.isTopLevel) {
    return;
  }

  const inspectorFront = await targetFront.getFront("inspector");
  await inspectorFront.walker.watchRootNode(node => {
    node.resourceType = ResourceWatcher.TYPES.ROOT_NODE;
    return onAvailable([node]);
  });
};
