# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Markerade element
compatibility-all-elements-header = Alla problem

## Message used as labels for the type of issue

compatibility-issue-deprecated = (föråldrad)
compatibility-issue-experimental = (experimentell)
compatibility-issue-prefixneeded = (prefix behövs)
compatibility-issue-deprecated-experimental = (föråldrad, experimentell)

compatibility-issue-deprecated-prefixneeded = (föråldrad, prefix behövs)
compatibility-issue-experimental-prefixneeded = (experimentellt, prefix behövs)
compatibility-issue-deprecated-experimental-prefixneeded = (föråldrad, experimentellt, prefix behövs)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Inställningar
compatibility-settings-button-title =
    .title = Inställningar
compatibility-feedback-button-label = Återkoppling
compatibility-feedback-button-title =
    .title = Återkoppling

## Messages used as headers in settings pane

compatibility-settings-header = Inställningar
compatibility-target-browsers-header = Målwebbläsare

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } händelse
       *[other] { $number } händelser
    }

compatibility-no-issues-found = Inga kompatibilitetsproblem hittades.
compatibility-close-settings-button =
    .title = Stäng inställningarna
