# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Valgt element
compatibility-all-elements-header = Alle problemer

## Message used as labels for the type of issue

compatibility-issue-deprecated = (forældet)
compatibility-issue-experimental = (eksperimentel)
compatibility-issue-prefixneeded = (præfiks påkrævet)
compatibility-issue-deprecated-experimental = (forældet, eksperimentel)
compatibility-issue-deprecated-prefixneeded = (forældet, præfiks påkrævet)
compatibility-issue-experimental-prefixneeded = (eksperimentel, præfiks påkrævet)
compatibility-issue-deprecated-experimental-prefixneeded = (forældet, eksperimentel, præfiks påkrævet)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Indstillinger
compatibility-settings-button-title =
    .title = Indstillinger

## Messages used as headers in settings pane

compatibility-settings-header = Indstillinger
compatibility-target-browsers-header = Mål-browsere

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } forekomst
       *[other] { $number } forekomster
    }

compatibility-no-issues-found = Der blev ikke fundet problemer med kompatibilitet.
compatibility-close-settings-button =
    .title = Luk indstillinger

# Text used in the element containing the browser icons for a given compatibility issue.
# Line breaks are significant.
# Variables:
#   $browsers (String) - A line-separated list of browser information (e.g. Waterfox 98\nChrome 99).
compatibility-issue-browsers-list =
    .title =
        Kompatibilitetsproblemer i:
        { $browsers }
