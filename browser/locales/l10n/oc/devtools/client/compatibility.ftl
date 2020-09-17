# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Element seleccionat
compatibility-all-elements-header = Totes los problèmas

## Message used as labels for the type of issue

compatibility-issue-deprecated = (obsolèt)
compatibility-issue-experimental = (experimental)
compatibility-issue-prefixneeded = (prefix requerit)
compatibility-issue-deprecated-experimental = (obsolèt, experimental)

compatibility-issue-deprecated-prefixneeded = (obsolèt, prefix requerit)
compatibility-issue-experimental-prefixneeded = (experimental, prefix requerit)
compatibility-issue-deprecated-experimental-prefixneeded = (obsolèt, experimental, prefix requerit)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Paramètres
compatibility-settings-button-title =
    .title = Paramètres
compatibility-feedback-button-label = Comentaris
compatibility-feedback-button-title =
    .title = Comentaris

## Messages used as headers in settings pane

compatibility-settings-header = Paramètres
compatibility-target-browsers-header = Navegadors ciblas

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } occuréncia
       *[other] { $number } occuréncias
    }

compatibility-no-issues-found = Cap de problèma de compatibilitat pas trobat.
compatibility-close-settings-button =
    .title = Tampar los paramètres
