# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = Menü megnyitása
# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }
# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }
# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = A(z) { $targetURI } megnyitása új lapon
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = A(z) { $tabTitle } eltüntetése
# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = Épp most

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = Törlés
    .accesskey = T
fxviewtabrow-forget-about-this-site = Webhely elfelejtése…
    .accesskey = f
fxviewtabrow-open-in-window = Megnyitás új ablakban
    .accesskey = j
fxviewtabrow-open-in-private-window = Megnyitás új privát ablakban
    .accesskey = p
# “Bookmark” is a verb, as in "Bookmark this page" (add to bookmarks).
fxviewtabrow-add-bookmark = Könyvjelzőzés…
    .accesskey = K
fxviewtabrow-save-to-pocket = Mentés a { -pocket-brand-name }be
    .accesskey = M
fxviewtabrow-copy-link = Hivatkozás másolása
    .accesskey = H
fxviewtabrow-close-tab = Lap bezárása
    .accesskey = b
# Variables:
#   $tabTitle (string) - Title of the tab to which the context menu is associated
fxviewtabrow-options-menu-button =
    .title = A(z) { $tabTitle } beállításai
