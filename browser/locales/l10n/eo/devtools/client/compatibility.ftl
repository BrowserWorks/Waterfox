# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Elektita elemento
compatibility-all-elements-header = Ĉiuj problemoj

## Message used as labels for the type of issue

compatibility-issue-deprecated = (kaduka)
compatibility-issue-experimental = (eksperimenta)
compatibility-issue-prefixneeded = (prefikso postulata)
compatibility-issue-deprecated-experimental = (kaduka, eksperimenta)

compatibility-issue-deprecated-prefixneeded = (kaduka, prefikso postulata)
compatibility-issue-experimental-prefixneeded = (eksperimenta, prefikso postulata)
compatibility-issue-deprecated-experimental-prefixneeded = (kaduka, eksperimenta, prefikso postulata)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Agordoj
compatibility-settings-button-title =
    .title = Agordoj
compatibility-feedback-button-label = Komentoj
compatibility-feedback-button-title =
    .title = Komentoj

## Messages used as headers in settings pane

compatibility-settings-header = Agordoj
compatibility-target-browsers-header = Celataj retumiloj

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } apero
       *[other] { $number } aperoj
    }

compatibility-no-issues-found = Neniu kongrueca problemo trovita.
compatibility-close-settings-button =
    .title = Fermi agordojn
