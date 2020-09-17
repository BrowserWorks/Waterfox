# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Elfennau Dewiswyd
compatibility-all-elements-header = Pob Cyhoeddiad

## Message used as labels for the type of issue

compatibility-issue-deprecated = (anghymeradwy)
compatibility-issue-experimental = (arbrofol)
compatibility-issue-prefixneeded = (angen rhagddodiad)
compatibility-issue-deprecated-experimental = (anghymeradwy, arbrofol)

compatibility-issue-deprecated-prefixneeded = (anghymeradwy, angen rhagddodiad)
compatibility-issue-experimental-prefixneeded = (arbrofol, angen rhagddodiad)
compatibility-issue-deprecated-experimental-prefixneeded = anghymeradwy, arbrofol, angen rhagddodiad)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Gosodiadau
compatibility-settings-button-title =
    .title = Gosodiadau
compatibility-feedback-button-label = Adborth
compatibility-feedback-button-title =
    .title = Adborth

## Messages used as headers in settings pane

compatibility-settings-header = Gosodiadau
compatibility-target-browsers-header = Porwyr Targed

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [zero] { $number } digwyddiad
        [one] { $number } digwyddiad
        [two] { $number } digwyddiad
        [few] { $number } digwyddiad
        [many] { $number } digwyddiad
       *[other] { $number } digwyddiad
    }

compatibility-no-issues-found = Dim materion cydnawsedd. wedi'u canfod.
compatibility-close-settings-button =
    .title = Cau'r gosodiadau
