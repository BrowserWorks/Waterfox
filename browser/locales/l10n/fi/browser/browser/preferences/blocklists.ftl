# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Estolistat
    .style = width: 50em

blocklist-description = Valitse lista, jota { -brand-short-name } käyttää verkkoseurainten estämiseen. Listat tarjoaa <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Lista

blocklist-button-cancel =
    .label = Peruuta
    .accesskey = P

blocklist-button-ok =
    .label = Tallenna muutokset
    .accesskey = T

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Tason 1 estolista (suositeltu).
blocklist-item-moz-std-description = Sallii jotkin seuraimet, jotta useimmat verkkosivustot eivät rikkoutuisi.
blocklist-item-moz-full-listName = Tason 2 estolista.
blocklist-item-moz-full-description = Estää kaikki havaitut seuraimet. Jotkin sivustot tai niiden sisältö ei välttämättä lataudu kunnolla.
