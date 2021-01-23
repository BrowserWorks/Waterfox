/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {
  ResourceWatcher,
} = require("devtools/shared/resources/resource-watcher");

module.exports = async function({
  targetList,
  targetFront,
  isFissionEnabledOnContentToolbox,
  onAvailable,
}) {
  // Allow the top level target unconditionnally.
  // Also allow frame, but only in content toolbox, when the fission/content toolbox pref is
  // set. i.e. still ignore them in the content of the browser toolbox as we inspect
  // messages via the process targets
  // Also ignore workers as they are not supported yet. (see bug 1592584)
  const isContentToolbox = targetList.targetFront.isLocalTab;
  const listenForFrames = isContentToolbox && isFissionEnabledOnContentToolbox;
  const isAllowed =
    targetFront.isTopLevel ||
    targetFront.targetType === targetList.TYPES.PROCESS ||
    (targetFront.targetType === targetList.TYPES.FRAME && listenForFrames);

  if (!isAllowed) {
    return;
  }

  const webConsoleFront = await targetFront.getFront("console");

  // Request notifying about new messages. Here the "PageError" type start listening for
  // both actual PageErrors (emitted as "pageError" events) as well as LogMessages (
  // emitted as "logMessage" events). This function only set up the listener on the
  // webConsoleFront for "pageError".
  await webConsoleFront.startListeners(["PageError"]);

  // Fetch already existing messages
  // /!\ The actor implementation requires to call startListeners("PageError") first /!\
  let { messages } = await webConsoleFront.getCachedMessages(["PageError"]);

  // On older server (< v77), we're also getting LogMessage cached messages, so we need
  // to ignore those.
  messages = messages.filter(message => {
    return (
      webConsoleFront.traits.newCacheStructure ||
      !message._type ||
      message._type == "PageError"
    );
  });

  messages = messages.map(message => {
    // Handling cached messages for servers older than Firefox 78.
    // Wrap the message into a `pageError` attribute, to match `pageError` behavior
    if (message._type) {
      return {
        pageError: message,
        resourceType: ResourceWatcher.TYPES.ERROR_MESSAGE,
      };
    }
    message.resourceType = ResourceWatcher.TYPES.ERROR_MESSAGE;
    return message;
  });
  // Cached messages don't have the same shape as live messages,
  // so we need to transform them.
  onAvailable(messages);

  webConsoleFront.on("pageError", message => {
    message.resourceType = ResourceWatcher.TYPES.ERROR_MESSAGE;
    onAvailable([message]);
  });
};
