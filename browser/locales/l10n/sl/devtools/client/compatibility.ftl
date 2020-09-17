# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Izbran element
compatibility-all-elements-header = Vse težave

## Message used as labels for the type of issue

compatibility-issue-deprecated = (zastarelo)
compatibility-issue-experimental = (poskusno)
compatibility-issue-prefixneeded = (potrebna je predpona)
compatibility-issue-deprecated-experimental = (zastarelo, poskusno)
compatibility-issue-deprecated-prefixneeded = (zastarelo, potrebna je predpona)
compatibility-issue-experimental-prefixneeded = (poskusno, potrebna je predpona)
compatibility-issue-deprecated-experimental-prefixneeded = (zastarelo, poskusno, potrebna je predpona)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Nastavitve
compatibility-settings-button-title =
    .title = Nastavitve
compatibility-feedback-button-label = Povratne informacije
compatibility-feedback-button-title =
    .title = Povratne informacije

## Messages used as headers in settings pane

compatibility-settings-header = Nastavitve
compatibility-target-browsers-header = Ciljni brskalniki

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } pojavitev
        [two] { $number } pojavitvi
        [few] { $number } pojavitve
       *[other] { $number } pojavitev
    }
compatibility-close-settings-button =
    .title = Zapri nastavitve
