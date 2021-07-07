# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Vybraný prvek
compatibility-all-elements-header = Všechny problémy

## Message used as labels for the type of issue

compatibility-issue-deprecated = (zastaralé)
compatibility-issue-experimental = (experimentální)
compatibility-issue-prefixneeded = (vyžaduje prefix)
compatibility-issue-deprecated-experimental = (zastaralé, experimentální)
compatibility-issue-deprecated-prefixneeded = (zastaralé, vyžaduje prefix)
compatibility-issue-experimental-prefixneeded = (experimentální, vyžaduje prefix)
compatibility-issue-deprecated-experimental-prefixneeded = (zastaralé, experimentální, vyžaduje prefix)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Nastavení
compatibility-settings-button-title =
    .title = Nastavení
compatibility-feedback-button-label = Zpětná vazba
compatibility-feedback-button-title =
    .title = Odeslání zpětné vazby

## Messages used as headers in settings pane

compatibility-settings-header = Nastavení
compatibility-target-browsers-header = Cílové prohlížeče

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } výskyt
        [few] { $number } výskyty
       *[other] { $number } výskytů
    }
compatibility-no-issues-found = Nebyly nalezeny žádné problémy s kompatibilitou.
compatibility-close-settings-button =
    .title = Zavřít nastavení
