# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = Öppna meny
# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }
# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }
# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = Öppna { $targetURI } i en ny flik
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = Ignorera { $tabTitle }
# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = Nyss

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = Ta bort
    .accesskey = T
fxviewtabrow-forget-about-this-site = Glöm den här sidan…
    .accesskey = G
fxviewtabrow-open-in-window = Öppna i nytt fönster
    .accesskey = n
fxviewtabrow-open-in-private-window = Öppna i nytt privat fönster
    .accesskey = p
# “Bookmark” is a verb, as in "Bookmark this page" (add to bookmarks).
fxviewtabrow-add-bookmark = Bokmärk…
    .accesskey = B
fxviewtabrow-save-to-pocket = Spara till { -pocket-brand-name }
    .accesskey = r
fxviewtabrow-copy-link = Kopiera länk
    .accesskey = K
fxviewtabrow-close-tab = Stäng flik
    .accesskey = S
# Variables:
#   $tabTitle (string) - Title of the tab to which the context menu is associated
fxviewtabrow-options-menu-button =
    .title = Alternativ för { $tabTitle }
