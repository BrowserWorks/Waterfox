/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const DEFAULT_SITES_MAP = new Map([
  // This first item is the global list fallback for any unexpected geos
  [
    "",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
  [
    "US",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
  [
    "CA",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
  [
    "DE",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
  [
    "PL",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
  [
    "RU",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
  [
    "GB",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
  [
    "FR",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
  [
    "CN",
    "https://www.archive.org/,https://www.bing.com/,https://www.startpage.com/,https://www.wikipedia.org/",
  ],
]);

this.EXPORTED_SYMBOLS = ["DEFAULT_SITES"];

// Immutable for export.
this.DEFAULT_SITES = Object.freeze(DEFAULT_SITES_MAP);
