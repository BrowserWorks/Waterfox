# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Listoj de blokado
    .style = width: 50em

blocklist-description = Elektu la liston, kiun { -brand-short-name } uzas por bloki retajn spurilojn. Listoj provizitaj de <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Listo

blocklist-button-cancel =
    .label = Nuligi
    .accesskey = N

blocklist-button-ok =
    .label = Konservi ŝanĝojn
    .accesskey = K

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Nivelo 1 - Listo de blokado (rekomendita).
blocklist-item-moz-std-description = Tio ĉi permesas kelkajn spurilojn, tiel ke malpli da retejoj ĉesas funkcii.
blocklist-item-moz-full-listName = Nivelo 2 - Listo de blokado.
blocklist-item-moz-full-description = Tio ĉi blokas ĉiun trovitajn spurilojn. Kelkaj retejoj aŭ enhavo povus malĝuste ŝargiĝi.
