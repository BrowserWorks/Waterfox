# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

styleeditor-new-button =
    .tooltiptext = Ein neues Stil-Dokument erstellen und auf die Webseite anwenden
    .accesskey = N
styleeditor-import-button =
    .tooltiptext = Ein Stil-Dokument importieren und auf die Webseite anwenden
    .accesskey = m
styleeditor-filter-input =
    .placeholder = Stil-Dokumente filtern
styleeditor-visibility-toggle =
    .tooltiptext = Anwendung des Stil-Dokuments umschalten
    .accesskey = S
styleeditor-visibility-toggle-system =
    .tooltiptext = System-Stil-Dokumente können nicht deaktiviert werden
styleeditor-save-button = Speichern
    .tooltiptext = Stil-Dokument als Datei speichern
    .accesskey = S
styleeditor-options-button =
    .tooltiptext = Einstellungen für Stilbearbeitung
styleeditor-at-rules = @-Regeln
styleeditor-editor-textbox =
    .data-placeholder = CSS hier eingeben.
styleeditor-no-stylesheet = Diese Seite verfügt über kein Stil-Dokument.
styleeditor-no-stylesheet-tip = Vielleicht möchten Sie <a data-l10n-name="append-new-stylesheet">ein neues Stil-Dokument</a> erstellen?
styleeditor-open-link-new-tab =
    .label = Link in neuem Tab öffnen
styleeditor-copy-url =
    .label = Adresse kopieren
styleeditor-find =
    .label = Suchen
    .accesskey = S
styleeditor-find-again =
    .label = Weitersuchen
    .accesskey = w
styleeditor-go-to-line =
    .label = Gehe zu Zeile…
    .accesskey = G
# Label displayed when searching a term that is not found in any stylesheet path
styleeditor-stylesheet-all-filtered = Es wurde kein passendes Stil-Dokument gefunden.

# This string is shown in the style sheets list
# Variables:
#   $ruleCount (Integer) - The number of rules in the stylesheet.
styleeditor-stylesheet-rule-count =
    { $ruleCount ->
        [one] { $ruleCount } Regel.
       *[other] { $ruleCount } Regeln.
    }
