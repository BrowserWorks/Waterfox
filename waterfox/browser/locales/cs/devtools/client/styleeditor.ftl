# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Vytvoří nový stylopis a připojí ho k dokumentu
    .accesskey = N
styleeditor-import-button =
    .tooltiptext = Naimportuje stávající stylopis a připojí ho k dokumentu
    .accesskey = I
styleeditor-filter-input =
    .placeholder = Filtrovat kaskádové styly
styleeditor-visibility-toggle =
    .tooltiptext = Přepne viditelnost stylopisu
    .accesskey = U
styleeditor-visibility-toggle-system =
    .tooltiptext = Systémové styly není možné deaktivovat
styleeditor-save-button = Uložit
    .tooltiptext = Uloží stylopis do souboru
    .accesskey = U
styleeditor-options-button =
    .tooltiptext = Možnosti Editoru stylů
styleeditor-at-rules = @-pravidla
styleeditor-editor-textbox =
    .data-placeholder = Zde vložte CSS.
styleeditor-no-stylesheet = Tato stránka nemá připojený stylopis.
styleeditor-no-stylesheet-tip = Můžete <a data-l10n-name="append-new-stylesheet">připojit nový stylopis</a>.
styleeditor-open-link-new-tab =
    .label = Otevřít odkaz v novém panelu
styleeditor-copy-url =
    .label = Kopírovat URL
styleeditor-find =
    .label = Najít
    .accesskey = j
styleeditor-find-again =
    .label = Najít další
    .accesskey = t
styleeditor-go-to-line =
    .label = Přejít na řádek…
    .accesskey = n
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Nebyly nalezeny žádná odpovídající kaskádové styly.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } pravidlo.
        [few] { $ruleCount } pravidla..
       *[other] { $ruleCount } pravidel.
    }
