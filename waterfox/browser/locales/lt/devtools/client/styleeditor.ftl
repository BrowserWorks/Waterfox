# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Sukurti ir pridėti į dokumentą naują stilių aprašą
    .accesskey = N
styleeditor-import-button =
    .tooltiptext = Importuoti ir pridėti į dokumentą esamą stilių aprašą
    .accesskey = I
styleeditor-visibility-toggle =
    .tooltiptext = Įjungti / išjungti stilių aprašo matomumą
    .accesskey = r
styleeditor-save-button = Įrašyti
    .tooltiptext = Įrašyti šį stilių aprašą į failą
    .accesskey = r
styleeditor-options-button =
    .tooltiptext = Stilių rengyklės nuostatos
styleeditor-editor-textbox =
    .data-placeholder = Čia rašykite CSS taisykles.
styleeditor-no-stylesheet = Šis tinklalapis nenaudoja stilių aprašų.
styleeditor-no-stylesheet-tip = Galbūt norite <a data-l10n-name="append-new-stylesheet">pridėti naują stilių aprašą</a>?
styleeditor-open-link-new-tab =
    .label = Atverti saitą naujoje kortelėje
styleeditor-copy-url =
    .label = Kopijuoti URL
styleeditor-find =
    .label = Ieškoti
    .accesskey = I
styleeditor-find-again =
    .label = Ieškoti toliau
    .accesskey = o
styleeditor-go-to-line =
    .label = Eiti į eilutę…
    .accesskey = E

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } taisyklė.
        [few] { $ruleCount } taisyklės.
       *[other] { $ruleCount } taisyklių.
    }
