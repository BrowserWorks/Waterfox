# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Element selectat
compatibility-all-elements-header = Toate problemele

## Message used as labels for the type of issue

compatibility-issue-deprecated = (perimate)
compatibility-issue-experimental = (experimentale)
compatibility-issue-prefixneeded = (este nevoie de prefix)
compatibility-issue-deprecated-experimental = (perimate, experimentale)

compatibility-issue-deprecated-prefixneeded = (perimat, este nevoie de prefix)
compatibility-issue-experimental-prefixneeded = (experimental, este nevoie de prefix)
compatibility-issue-deprecated-experimental-prefixneeded = (perimat, experimental, este nevoie de prefix)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Setări
compatibility-settings-button-title =
    .title = Setări
compatibility-feedback-button-label = Feedback
compatibility-feedback-button-title =
    .title = Feedback

## Messages used as headers in settings pane

compatibility-settings-header = Setări
compatibility-target-browsers-header = Browsere-țintă

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } ocurență
        [few] { $number } ocurențe
       *[other] { $number } de ocurențe
    }

compatibility-no-issues-found = Nu s-a depistat nicio problemă de compatibilitate.
compatibility-close-settings-button =
    .title = Închide setările
