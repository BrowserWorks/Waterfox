# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Geselecteerd element
compatibility-all-elements-header = Alle problemen

## Message used as labels for the type of issue

compatibility-issue-deprecated = (verouderd)
compatibility-issue-experimental = (experimenteel)
compatibility-issue-prefixneeded = (voorvoegsel nodig)
compatibility-issue-deprecated-experimental = (verouderd, experimenteel)
compatibility-issue-deprecated-prefixneeded = (verouderd, voorvoegsel nodig)
compatibility-issue-experimental-prefixneeded = (experimenteel, voorvoegsel nodig)
compatibility-issue-deprecated-experimental-prefixneeded = (verouderd, experimenteel, voorvoegsel nodig)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Instellingen
compatibility-settings-button-title =
    .title = Instellingen
compatibility-feedback-button-label = Feedback
compatibility-feedback-button-title =
    .title = Feedback

## Messages used as headers in settings pane

compatibility-settings-header = Instellingen
compatibility-target-browsers-header = Doelbrowsers

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } keer
       *[other] { $number } keer
    }

compatibility-no-issues-found = Geen compatibiliteitsproblemen gevonden.
compatibility-close-settings-button =
    .title = Instellingen sluiten
