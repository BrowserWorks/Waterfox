# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Een nieuw stijlblad aanmaken en aan het document toevoegen
    .accesskey = n
styleeditor-import-button =
    .tooltiptext = Een bestaand stijlblad importeren en aan het document toevoegen
    .accesskey = m
styleeditor-filter-input =
    .placeholder = Stijlbladen filteren
styleeditor-visibility-toggle =
    .tooltiptext = Zichtbaarheid van stijlblad in-/uitschakelen
    .accesskey = s
styleeditor-visibility-toggle-system =
    .tooltiptext = Systeemstylesheets kunnen niet worden uitgeschakeld
styleeditor-save-button = Opslaan
    .tooltiptext = Dit stijlblad opslaan als bestand
    .accesskey = s
styleeditor-options-button =
    .tooltiptext = Stijleditoropties
styleeditor-at-rules = At-regels
styleeditor-editor-textbox =
    .data-placeholder = Voer hier CSS in.
styleeditor-no-stylesheet = Deze pagina heeft geen stijlblad.
styleeditor-no-stylesheet-tip = Misschien wilt u <a data-l10n-name="append-new-stylesheet">een nieuw stijlblad toevoegen</a>?
styleeditor-open-link-new-tab =
    .label = Koppeling openen in nieuw tabblad
styleeditor-copy-url =
    .label = URL kopiëren
styleeditor-find =
    .label = Zoeken
    .accesskey = Z
styleeditor-find-again =
    .label = Opnieuw zoeken
    .accesskey = e
styleeditor-go-to-line =
    .label = Spring naar regel…
    .accesskey = S
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Er is geen overeenkomend stijlblad gevonden.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } regel.
       *[other] { $ruleCount } regels.
    }
