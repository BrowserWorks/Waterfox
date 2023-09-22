# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

fxviewtabrow-open-menu-button =
    .title = Åbn menu
# Variables:
#   $date (string) - Date to be formatted based on locale
fxviewtabrow-date = { DATETIME($date, dateStyle: "short") }
# Variables:
#   $time (string) - Time to be formatted based on locale
fxviewtabrow-time = { DATETIME($time, timeStyle: "short") }
# Variables:
#   $targetURI (string) - URL of tab that will be opened in the new tab
fxviewtabrow-tabs-list-tab =
    .title = Åbn { $targetURI } i et nyt faneblad
# Variables:
#   $tabTitle (string) - Title of tab being dismissed
fxviewtabrow-dismiss-tab-button =
    .title = Afvis { $tabTitle }
# Used instead of the localized relative time when a timestamp is within a minute or so of now
fxviewtabrow-just-now-timestamp = Nu

# Strings below are used for context menu options within panel-list.
# For developers, this duplicates command because the label attribute is required.

fxviewtabrow-delete = Slet
    .accesskey = S
fxviewtabrow-forget-about-this-site = Glem dette websted…
    .accesskey = G
fxviewtabrow-open-in-window = Åbn i nyt vindue
    .accesskey = n
fxviewtabrow-open-in-private-window = Åbn i et nyt privat vindue
    .accesskey = p
# “Bookmark” is a verb, as in "Bookmark this page" (add to bookmarks).
fxviewtabrow-add-bookmark = Gem bogmærke…
    .accesskey = b
fxviewtabrow-save-to-pocket = Gem til { -pocket-brand-name }
    .accesskey = e
fxviewtabrow-copy-link = Kopier link
    .accesskey = K
fxviewtabrow-close-tab = Luk faneblad
    .accesskey = L
# Variables:
#   $tabTitle (string) - Title of the tab to which the context menu is associated
fxviewtabrow-options-menu-button =
    .title = Valgmuligheder for { $tabTitle }
