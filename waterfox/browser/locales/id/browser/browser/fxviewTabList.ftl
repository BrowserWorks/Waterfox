# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = Buka menu
# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }
# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }
# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = Buka { $targetURI } di tab baru
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = Tutup { $tabTitle }
# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = Baru saja

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = Hapus
    .accesskey = H
