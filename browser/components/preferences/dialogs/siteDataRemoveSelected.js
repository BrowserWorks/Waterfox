/* -*- indent-tabs-mode: nil; js-indent-level: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

let gSiteDataRemoveSelected = {
  init() {
    let hosts = window.arguments[0].hosts;
    hosts.sort();
    let list = document.getElementById("removalList");
    let fragment = document.createDocumentFragment();
    for (let host of hosts) {
      let listItem = document.createXULElement("richlistitem");
      let label = document.createXULElement("label");
      if (host) {
        label.setAttribute("value", host);
      } else {
        document.l10n.setAttributes(label, "site-data-local-file-host");
      }
      listItem.appendChild(label);
      fragment.appendChild(listItem);
    }
    list.appendChild(fragment);
    document.addEventListener("dialogaccept", function() {
      window.arguments[0].allowed = true;
    });
    document.addEventListener("dialogcancel", function() {
      window.arguments[0].allowed = false;
    });
  },
};
