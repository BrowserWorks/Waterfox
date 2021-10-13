# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = Seite vereinfachen
    .accesskey = v
    .tooltiptext = Diese Seite kann nicht automatisch vereinfacht werden.
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = Bessere Darstellung für einfacheres Lesen
printpreview-close =
    .label = Schließen
    .accesskey = c
printpreview-portrait =
    .label = Hochformat
    .accesskey = H
printpreview-landscape =
    .label = Querformat
    .accesskey = Q
printpreview-scale =
    .value = Skalierung:
    .accesskey = k
printpreview-shrink-to-fit =
    .label = Auf Seitengröße verkleinern
printpreview-custom =
    .label = Benutzerdefiniert…
printpreview-print =
    .label = Drucken…
    .accesskey = D
printpreview-of =
    .value = von
printpreview-custom-scale-prompt-title = Benutzerdefinierte Skalierung
printpreview-page-setup =
    .label = Seite einrichten…
    .accesskey = e
printpreview-page =
    .value = Seite:
    .accesskey = S

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = { $sheetNum } von { $sheetCount }

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent } %
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = Erste Seite
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = Vorherige Seite
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = Nächste Seite
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = Letzte Seite

printpreview-homearrow-button =
    .title = Erste Seite
printpreview-previousarrow-button =
    .title = Vorherige Seite
printpreview-nextarrow-button =
    .title = Nächste Seite
printpreview-endarrow-button =
    .title = Letzte Seite
