# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = Opne meny
# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }
# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }
# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = Opne { $targetURI } i ei ny fane
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = Avvis { $tabTitle }
# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = Akkurat no

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = Slett
    .accesskey = S
fxviewtabrow-forget-about-this-site = Gløym denne nettstaden…
    .accesskey = G
fxviewtabrow-open-in-window = Opne i nytt vindauge
    .accesskey = n
fxviewtabrow-open-in-private-window = Opne i nytt privat vindauge
    .accesskey = p
# “Bookmark” is a verb, as in "Bookmark this page" (add to bookmarks).
fxviewtabrow-add-bookmark = Bokmerk…
    .accesskey = B
fxviewtabrow-save-to-pocket = Lagre til { -pocket-brand-name }
    .accesskey = L
fxviewtabrow-copy-link = Kopier lenke
    .accesskey = K
fxviewtabrow-close-tab = Lat att fane
    .accesskey = L
# Variables:
#   $tabTitle (string) - Title of the tab to which the context menu is associated
fxviewtabrow-options-menu-button =
    .title = Innstillingar for { $tabTitle }
