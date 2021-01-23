# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Wubrany element
compatibility-all-elements-header = Wšě problemy

## Message used as labels for the type of issue

compatibility-issue-deprecated = (zestarjeny)
compatibility-issue-experimental = (eksperimentelny)
compatibility-issue-prefixneeded = (prefiks trěbny)
compatibility-issue-deprecated-experimental = (zestarjeny, eksperimentelny)

compatibility-issue-deprecated-prefixneeded = (zestarjeny, prefiks trěbny)
compatibility-issue-experimental-prefixneeded = (eksperimentelny, prefiks trěbny)
compatibility-issue-deprecated-experimental-prefixneeded = (zestarjeny, eksperimentelny, prefiks trěbny)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Nastajenja
compatibility-settings-button-title =
    .title = Nastajenja
compatibility-feedback-button-label = Komentary
compatibility-feedback-button-title =
    .title = Komentary

## Messages used as headers in settings pane

compatibility-settings-header = Nastajenja
compatibility-target-browsers-header = Cilowe wobhladowaki

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } wustupowanje
        [two] { $number } wustupowani
        [few] { $number } wustupowanja
       *[other] { $number } wustupowanjow
    }

compatibility-no-issues-found = Žane problemy kompatibelnosće namakane.
compatibility-close-settings-button =
    .title = Nastajenja začinić
