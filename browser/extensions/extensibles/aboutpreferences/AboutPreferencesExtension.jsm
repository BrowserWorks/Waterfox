/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* global */

const EXPORTED_SYMBOLS = ["PrefsExt"];

const PrefsExt = {
  get style() {
    return `
            @-moz-document url(about:preferences) {
                .extensiblesHeader {
                    font-weight: 600;
                    margin: 16px 0 4px;
                    font-size: 1.14em;
                    line-height: normal;
                }
            }
            `;
  },
};
