/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/* globals ExtensionAPI */

const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");

ChromeUtils.defineModuleGetter(
  this,
  "Extensibles",
  "resource:///modules/extensibles.js"
);

this.extensibles = class extends ExtensionAPI {
  getAPI(context) {
    return {
      extensibles: {
        init() {
          Extensibles.loadContextOverlays();
        },
      },
    };
  }
};
