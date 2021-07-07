# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Pasirinktas elementas
compatibility-all-elements-header = Visos problemos

## Message used as labels for the type of issue

compatibility-issue-deprecated = (nenaudotina)
compatibility-issue-experimental = (eksperimentinė)
compatibility-issue-prefixneeded = (reikalingas prefiksas)
compatibility-issue-deprecated-experimental = (nenaudotina, eksperimentinė)
compatibility-issue-deprecated-prefixneeded = (nenaudotina, reikalingas prefiksas)
compatibility-issue-experimental-prefixneeded = (eksperimentinė, reikalingas prefiksas)
compatibility-issue-deprecated-experimental-prefixneeded = (nenaudotina, eksperimentinė, reikalingas prefiksas)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Nuostatos
compatibility-settings-button-title =
    .title = Nuostatos
compatibility-feedback-button-label = Pateikti atsiliepimą
compatibility-feedback-button-title =
    .title = Pateikti atsiliepimą

## Messages used as headers in settings pane

compatibility-settings-header = Nuostatos
compatibility-target-browsers-header = Tikslinės naršyklės

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } pasikartojimas
        [few] { $number } pasikartojimai
       *[other] { $number } pasikartojimų
    }
compatibility-no-issues-found = Nerasta suderinamumo problemų.
compatibility-close-settings-button =
    .title = Užverti nuostatas
