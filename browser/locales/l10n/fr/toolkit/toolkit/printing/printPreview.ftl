# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = Simplifier la page
    .accesskey = i
    .tooltiptext = Cette page ne peut pas être automatiquement simplifiée
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = Modifier la mise en page pour faciliter la lecture
printpreview-close =
    .label = Fermer
    .accesskey = F
printpreview-portrait =
    .label = Portrait
    .accesskey = o
printpreview-landscape =
    .label = Paysage
    .accesskey = y
printpreview-scale =
    .value = Échelle :
    .accesskey = l
printpreview-shrink-to-fit =
    .label = Adapter à la page
printpreview-custom =
    .label = Personnaliser…
printpreview-print =
    .label = Imprimer…
    .accesskey = p
printpreview-of =
    .value = sur
printpreview-custom-scale-prompt-title = Échelle personnalisée
printpreview-page-setup =
    .label = Mise en page…
    .accesskey = i
printpreview-page =
    .value = Page :
    .accesskey = a

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = { $sheetNum } sur { $sheetCount }

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent } %
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = Première page
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = Page précédente
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = Page suivante
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = Dernière page

printpreview-homearrow-button =
    .title = Première page
printpreview-previousarrow-button =
    .title = Page précédente
printpreview-nextarrow-button =
    .title = Page suivante
printpreview-endarrow-button =
    .title = Dernière page
