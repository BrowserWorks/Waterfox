# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Kiválasztott elem
compatibility-all-elements-header = Összes probléma

## Message used as labels for the type of issue

compatibility-issue-deprecated = (elavult)
compatibility-issue-experimental = (kísérleti)
compatibility-issue-prefixneeded = (előtag szükséges)
compatibility-issue-deprecated-experimental = (elavult, kísérleti)
compatibility-issue-deprecated-prefixneeded = (elavult, előtag szükséges)
compatibility-issue-experimental-prefixneeded = (kísérleti, előtag szükséges)
compatibility-issue-deprecated-experimental-prefixneeded = (elavult, kísérleti, előtag szükséges)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Beállítások
compatibility-settings-button-title =
    .title = Beállítások

## Messages used as headers in settings pane

compatibility-settings-header = Beállítások
compatibility-target-browsers-header = Célzott böngészők

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } előfordulás
       *[other] { $number } előfordulás
    }

compatibility-no-issues-found = Nem található kompatibilitási probléma.
compatibility-close-settings-button =
    .title = Beállítások bezárása

# Text used in the element containing the browser icons for a given compatibility issue.
# Line breaks are significant.
# Variables:
#   $browsers (String) - A line-separated list of browser information (e.g. Waterfox 98\nChrome 99).
compatibility-issue-browsers-list =
    .title =
        Kompatibilitási problémák itt:
        { $browsers }
