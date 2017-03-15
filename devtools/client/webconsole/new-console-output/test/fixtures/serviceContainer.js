/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

module.exports = {
  attachRefToHud: () => {},
  emitNewMessage: () => {},
  hudProxyClient: {},
  onViewSourceInDebugger: () => {},
  openNetworkPanel: () => {},
  sourceMapService: {
    subscribe: () => {},
  },
  openLink: () => {},
  createElement: tagName => document.createElement(tagName)
};
