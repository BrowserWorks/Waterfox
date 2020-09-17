# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = Listas de blocage
    .style = width: 55em

blocklist-description = Elige le lista que { -brand-short-name } usa pro blocar le traciatores online. Listas fornite per <a data-l10n-name="disconnect-link" title="Disconnect">Disconnecter</a>.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = Lista

blocklist-button-cancel =
    .label = Cancellar
    .accesskey = C

blocklist-button-ok =
    .label = Salvar le cambios
    .accesskey = S

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = Lista de blocage de nivello 1 (recommendate).
blocklist-item-moz-std-description = Permitte alcun traciatores de sorta que minus sitos web cessa de functionar.
blocklist-item-moz-full-listName = Lista de blocage de nivello 2.
blocklist-item-moz-full-description = Bloca tote le traciatores detegite. Qualque sitos web o contento pote non esser cargate correctemente.
