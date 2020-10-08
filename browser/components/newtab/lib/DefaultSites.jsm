/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const DEFAULT_SITES_MAP = new Map([
  // This first item is the global list fallback for any unexpected geos
  [
    "",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
  [
    "US",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
  [
    "CA",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
  [
    "DE",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
  [
    "PL",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
  [
    "RU",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
  [
    "GB",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
  [
    "FR",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
  [
    "CN",
    "https://www.waterfox.net/,https://www.wikipedia.org/,https://www.archive.org/",
  ],
]);

this.EXPORTED_SYMBOLS = ["DEFAULT_SITES"];

// Immutable for export.
this.DEFAULT_SITES = Object.freeze(DEFAULT_SITES_MAP);
