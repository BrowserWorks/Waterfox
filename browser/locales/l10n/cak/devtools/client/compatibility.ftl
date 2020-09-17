# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Xcha' Ch'akulal
compatibility-all-elements-header = Ronojel K'ayewal

## Message used as labels for the type of issue

compatibility-issue-deprecated = (ojer)
compatibility-issue-experimental = (tojtob'äl)
compatibility-issue-prefixneeded = (najowäx ruwäch tzij)
compatibility-issue-deprecated-experimental = (ojer, tojtob'äl)
compatibility-issue-deprecated-prefixneeded = (ojer, najowäx ruwäch tzij)
compatibility-issue-experimental-prefixneeded = (tojtob'enel, najowäch ruwäch tzij)
compatibility-issue-deprecated-experimental-prefixneeded = (ojer, tojtob'enel, najowäx ruwäch tzij)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Taq runuk'ulem
compatibility-settings-button-title =
    .title = Taq runuk'ulem
compatibility-feedback-button-label = Ya'oj na'oj
compatibility-feedback-button-title =
    .title = Ya'oj na'oj

## Messages used as headers in settings pane

compatibility-settings-header = Taq runuk'ulem
compatibility-target-browsers-header = Raponel Okik'amaya'l

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } nojb'äl
       *[other] { $number } taq nojb'äl
    }
compatibility-no-issues-found = Majun k'ayewal rik'in k'amonem xilitäj.
compatibility-close-settings-button =
    .title = Ketz'apïx taq runuk'ulem
