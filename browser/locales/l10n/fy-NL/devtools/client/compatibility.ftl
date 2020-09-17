# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Selektearre elemint
compatibility-all-elements-header = Alle problemen

## Message used as labels for the type of issue

compatibility-issue-deprecated = (ferâldere)
compatibility-issue-experimental = (eksperiminteel)
compatibility-issue-prefixneeded = (foarheaksel nedich)
compatibility-issue-deprecated-experimental = (ferâldere, eksperiminteel)
compatibility-issue-deprecated-prefixneeded = (ferâldere, foarheaksel nedich)
compatibility-issue-experimental-prefixneeded = (eksperiminteel, foarheaksel nedich)
compatibility-issue-deprecated-experimental-prefixneeded = (ferâldere, eksperiminteel, foarheaksel nedich)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Ynstellingen
compatibility-settings-button-title =
    .title = Ynstellingen
compatibility-feedback-button-label = Kommentaar
compatibility-feedback-button-title =
    .title = Kommentaar

## Messages used as headers in settings pane

compatibility-settings-header = Ynstellingen
compatibility-target-browsers-header = Doelbrowsers

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } kear
       *[other] { $number } kear
    }
compatibility-no-issues-found = Gjin kompatibiliteitsproblemen fûn.
compatibility-close-settings-button =
    .title = Ynstellingen slute
