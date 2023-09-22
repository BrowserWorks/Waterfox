# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = Otwórz menu
# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }
# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }
# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = Otwórz { $targetURI } w nowej karcie
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = Odrzuć kartę „{ $tabTitle }”
# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = Przed chwilą

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = Usuń
    .accesskey = U
fxviewtabrow-forget-about-this-site = Usuń całą witrynę…
    .accesskey = c
fxviewtabrow-open-in-window = Otwórz w nowym oknie
    .accesskey = O
fxviewtabrow-open-in-private-window = Otwórz w nowym oknie prywatnym
    .accesskey = w
# “Bookmark” is a verb, as in "Bookmark this page" (add to bookmarks).
fxviewtabrow-add-bookmark = Dodaj zakładkę…
    .accesskey = D
fxviewtabrow-save-to-pocket = Wyślij do { -pocket-brand-name }
    .accesskey = P
fxviewtabrow-copy-link = Kopiuj odnośnik
    .accesskey = K
fxviewtabrow-close-tab = Zamknij kartę
    .accesskey = Z
# Variables:
#   $tabTitle (string) - Title of the tab to which the context menu is associated
fxviewtabrow-options-menu-button =
    .title = Opcje karty „{ $tabTitle }”
