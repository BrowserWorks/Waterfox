# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Új stíluslap létrehozása és dokumentumhoz fűzése
    .accesskey = j
styleeditor-import-button =
    .tooltiptext = Meglévő stíluslap importálása és dokumentumhoz fűzése
    .accesskey = I
styleeditor-filter-input =
    .placeholder = Stíluslapok szűrése
styleeditor-visibility-toggle =
    .tooltiptext = Stíluslap láthatóságának átváltása
    .accesskey = s
styleeditor-visibility-toggle-system =
    .tooltiptext = A rendszer stíluslapjait nem lehet letiltani
styleeditor-save-button = Mentés
    .tooltiptext = Stíluslap fájlba mentése
    .accesskey = s
styleeditor-options-button =
    .tooltiptext = Stílusszerkesztő beállításai
styleeditor-at-rules = @-os szabályok
styleeditor-editor-textbox =
    .data-placeholder = Írja ide a CSS-t.
styleeditor-no-stylesheet = Ez az oldal nem rendelkezik stíluslappal.
styleeditor-no-stylesheet-tip = Szeretne <a data-l10n-name="append-new-stylesheet">hozzáfűzni egy új stíluslapot</a>?
styleeditor-open-link-new-tab =
    .label = Hivatkozás megnyitása új lapon
styleeditor-copy-url =
    .label = URL másolása
styleeditor-find =
    .label = Keresés
    .accesskey = e
styleeditor-find-again =
    .label = Következő keresése
    .accesskey = z
styleeditor-go-to-line =
    .label = Ugrás sorra…
    .accesskey = U
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Nem található egyező stíluslap.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } szabály.
       *[other] { $ruleCount } szabály.
    }
