# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Opret og tilføj et nyt stylesheet til dokumentet
    .accesskey = N
styleeditor-import-button =
    .tooltiptext = Importer og tilføj et eksisterende stylesheet til dokumentet
    .accesskey = I
styleeditor-filter-input =
    .placeholder = Filtrer stylesheets
styleeditor-visibility-toggle =
    .tooltiptext = Skift synlighed af stylesheet
    .accesskey = G
styleeditor-visibility-toggle-system =
    .tooltiptext = System-stylesheets kan ikke deaktiveres
styleeditor-save-button = Gem
    .tooltiptext = Gem dette stylesheet til en fil
    .accesskey = G
styleeditor-options-button =
    .tooltiptext = Indstillinger for CSS-editor
styleeditor-at-rules = @-regler
styleeditor-editor-textbox =
    .data-placeholder = Skriv CSS her.
styleeditor-no-stylesheet = Denne side har intet stylesheet.
styleeditor-no-stylesheet-tip = Måske vil du <a data-l10n-name="append-new-stylesheet">tilføje et nyt stylesheet</a>?
styleeditor-open-link-new-tab =
    .label = Åbn link i et nyt faneblad
styleeditor-copy-url =
    .label = Kopier URL
styleeditor-find =
    .label = Find
    .accesskey = n
styleeditor-find-again =
    .label = Find næste
    .accesskey = d
styleeditor-go-to-line =
    .label = Hop til linje…
    .accesskey = H
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Et matchende stylesheet blev ikke fundet.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } regel.
       *[other] { $ruleCount } regler.
    }
