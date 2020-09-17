# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Elenchi de blòcco
    .style = width: 55em

blocklist-description = Çerni a lista da dêuviâ in { -brand-short-name } pe blocâ i elementi che tracian in linia. E liste son fornie da <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Elenco

blocklist-button-cancel =
    .label = Anulla
    .accesskey = A

blocklist-button-ok =
    .label = Sarva modifiche
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Elenco livello 1 (consegiou).
blocklist-item-moz-std-description = Permette quarche elemento ch'o tracia pe limitâ o numero di sciti che fonçionan mâ.
blocklist-item-moz-full-listName = Elenco livello 2
blocklist-item-moz-full-description = Blôca tutti i elementi tracianti trovæ. Çerti sciti o contegnui porieivan no caregase ben.
