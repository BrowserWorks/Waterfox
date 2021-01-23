/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

var EXPORTED_SYMBOLS = ["ParentProcessDomains"];

const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);

const ParentProcessDomains = {};

XPCOMUtils.defineLazyModuleGetters(ParentProcessDomains, {
  Browser: "chrome://remote/content/domains/parent/Browser.jsm",
  Emulation: "chrome://remote/content/domains/parent/Emulation.jsm",
  Input: "chrome://remote/content/domains/parent/Input.jsm",
  IO: "chrome://remote/content/domains/parent/IO.jsm",
  Network: "chrome://remote/content/domains/parent/Network.jsm",
  Page: "chrome://remote/content/domains/parent/Page.jsm",
  Security: "chrome://remote/content/domains/parent/Security.jsm",
  Target: "chrome://remote/content/domains/parent/Target.jsm",
});
