# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Odabrani element
compatibility-all-elements-header = Svi problemi

## Message used as labels for the type of issue

compatibility-issue-deprecated = (obustavljeno)
compatibility-issue-experimental = (eksperimentalno)
compatibility-issue-deprecated-experimental = (obustavljeno, eksperimentalno)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Postavke
compatibility-settings-button-title =
    .title = Postavke
compatibility-feedback-button-label = Povratne informacije
compatibility-feedback-button-title =
    .title = Povratne informacije

## Messages used as headers in settings pane

compatibility-settings-header = Postavke
compatibility-target-browsers-header = Ciljani preglednici

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } pojavljivanje
        [few] { $number } pojavljivanja
       *[other] { $number } pojavljivanja
    }

compatibility-no-issues-found = Nema problema s kompatibilnošću.
compatibility-close-settings-button =
    .title = Zatvori postavke
