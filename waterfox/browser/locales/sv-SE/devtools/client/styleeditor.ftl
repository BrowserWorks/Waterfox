# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Skapa och lägg till en ny stilmall till dokumentet
    .accesskey = S
styleeditor-import-button =
    .tooltiptext = Importera och lägg till en befintlig stilmall till dokumentet
    .accesskey = m
styleeditor-filter-input =
    .placeholder = Filtrera stilmallar
styleeditor-visibility-toggle =
    .tooltiptext = Växla visning av stilmall
    .accesskey = V
styleeditor-visibility-toggle-system =
    .tooltiptext = Systemformatmallar kan inte inaktiveras
styleeditor-save-button = Spara
    .tooltiptext = Spara den här stilmallen till en fil
    .accesskey = S
styleeditor-options-button =
    .tooltiptext = Alternativ för stilredigerare
styleeditor-at-rules = At-rules
styleeditor-editor-textbox =
    .data-placeholder = Skriv in CSS här.
styleeditor-no-stylesheet = Den här sidan har ingen stilmall.
styleeditor-no-stylesheet-tip = Kanske vill du <a data-l10n-name="append-new-stylesheet">lägga till en ny stilmall</a>?
styleeditor-open-link-new-tab =
    .label = Öppna länk i ny flik
styleeditor-copy-url =
    .label = Kopiera URL
styleeditor-find =
    .label = Sök
    .accesskey = S
styleeditor-find-again =
    .label = Sök igen
    .accesskey = ö
styleeditor-go-to-line =
    .label = Gå till rad…
    .accesskey = G
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Ingen matchande stilmall har hittats.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } regel.
       *[other] { $ruleCount } regler.
    }
