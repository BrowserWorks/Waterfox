/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

export class PointerLockParent extends JSWindowActorParent {
  receiveMessage(message) {
    let browser = this.manager.browsingContext.top.embedderElement;
    switch (message.name) {
      case "PointerLock:Entered": {
        browser.documentGlobal.PointerLock.entered(
          this.manager.browsingContext.top.currentWindowGlobal.documentPrincipal
            .originNoSuffix
        );
        break;
      }

      case "PointerLock:Exited": {
        browser.documentGlobal.PointerLock.exited();
        break;
      }
    }
  }
}
