/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "SelectContentHelper",
                                  "resource://gre/modules/SelectContentHelper.jsm");

addEventListener("mozshowdropdown", event => {
  if (!event.isTrusted)
    return;

  if (!SelectContentHelper.open) {
    new SelectContentHelper(event.target, {isOpenedViaTouch: false}, this);
  }
});

addEventListener("mozshowdropdown-sourcetouch", event => {
  if (!event.isTrusted)
    return;

  if (!SelectContentHelper.open) {
    new SelectContentHelper(event.target, {isOpenedViaTouch: true}, this);
  }
});
