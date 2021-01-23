# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Open a Private Window
    .accesskey = P
about-private-browsing-search-placeholder = Search the Web
about-private-browsing-info-title = You’re in a Private Window
about-private-browsing-info-myths = Common myths about private browsing
about-private-browsing =
    .title = Search the Web
about-private-browsing-not-private = You are currently not in a private window.
about-private-browsing-info-description = { -brand-short-name } clears your search and browsing history when you quit the app or close all Private Browsing tabs and windows. While this doesn’t make you anonymous to websites or your internet service provider, it makes it easier to keep what you do online private from anyone else who uses this computer.

# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } is your default search engine in Private Windows
about-private-browsing-search-banner-description = {
  PLATFORM() ->
     [windows] To select a different search engine go to <a data-l10n-name="link-options">Options</a>
    *[other] To select a different search engine go to <a data-l10n-name="link-options">Preferences</a>
  }
about-private-browsing-search-banner-close-button =
    .aria-label = Close
