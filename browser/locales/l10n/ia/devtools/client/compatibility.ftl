# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Elemento seligite
compatibility-all-elements-header = Tote le problemas

## Message used as labels for the type of issue

compatibility-issue-deprecated = (obsolete)
compatibility-issue-experimental = (experimental)
compatibility-issue-prefixneeded = (prefixo necessari)
compatibility-issue-deprecated-experimental = (obsolete, experimental)

compatibility-issue-deprecated-prefixneeded = (obsolete, prefixo necessari)
compatibility-issue-experimental-prefixneeded = (experimental, prefixo necessari)
compatibility-issue-deprecated-experimental-prefixneeded = (obsolete, experimental, prefixo necessari)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Parametros
compatibility-settings-button-title =
    .title = Parametros
compatibility-feedback-button-label = Reaction
compatibility-feedback-button-title =
    .title = Reaction

## Messages used as headers in settings pane

compatibility-settings-header = Parametros
compatibility-target-browsers-header = Navigatores objectivo

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } occurrentia
       *[other] { $number } occurrentias
    }

compatibility-no-issues-found = Nulle problema de compatibilitate trovate.
compatibility-close-settings-button =
    .title = Clauder le parametros
