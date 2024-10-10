# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window2 =
    .title = Lista blokowanych elementów
    .style = min-width: 57em

blocklist-description = Wybierz listę używaną przez przeglądarkę { -brand-short-name } do blokowania elementów śledzących użytkownika w Internecie. Listy są dostarczane przez <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Lista

blocklist-dialog =
    .buttonlabelaccept = Zachowaj zmiany
    .buttonaccesskeyaccept = Z


# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Lista blokowanych elementów 1. poziomu (zalecana).
blocklist-item-moz-std-description = Zezwala na niektóre elementy śledzące, więc powoduje mniej problemów na stronach.
blocklist-item-moz-full-listName = Lista blokowanych elementów 2. poziomu.
blocklist-item-moz-full-description = Blokuje wszystkie wykryte elementy śledzące. Część stron lub ich treść mogą się niepoprawnie wczytywać.
