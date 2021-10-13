# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Ausgewähltes Element
compatibility-all-elements-header = Alle Probleme

## Message used as labels for the type of issue

compatibility-issue-deprecated = (veraltet)
compatibility-issue-experimental = (experimentell)
compatibility-issue-prefixneeded = (Präfix erforderlich)
compatibility-issue-deprecated-experimental = (veraltet, experimentell)

compatibility-issue-deprecated-prefixneeded = (veraltet, Präfix erforderlich)
compatibility-issue-experimental-prefixneeded = (experimentell, Präfix erforderlich)
compatibility-issue-deprecated-experimental-prefixneeded = (veraltet, experimentell, Präfix erforderlich)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Einstellungen
compatibility-settings-button-title =
    .title = Einstellungen
compatibility-feedback-button-label = Feedback
compatibility-feedback-button-title =
    .title = Feedback

## Messages used as headers in settings pane

compatibility-settings-header = Einstellungen
compatibility-target-browsers-header = Zielbrowser

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } Vorkommen
       *[other] { $number } Vorkommen
    }

compatibility-no-issues-found = Keine Kompatibilitätsprobleme gefunden.
compatibility-close-settings-button =
    .title = Einstellungen schließen
