# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Таңдалған элемент
compatibility-all-elements-header = Барлық мәселелер

## Message used as labels for the type of issue

compatibility-issue-deprecated = (ескірген)
compatibility-issue-experimental = (тәжірибелік)
compatibility-issue-prefixneeded = (префикс қажет)
compatibility-issue-deprecated-experimental = (ескірген, тәжірибелік)

compatibility-issue-deprecated-prefixneeded = (ескірген, префикс қажет)
compatibility-issue-experimental-prefixneeded = (тәжірибелік, префикс қажет)
compatibility-issue-deprecated-experimental-prefixneeded = (ескірген, тәжірибелік, префикс қажет)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Баптаулар
compatibility-settings-button-title =
    .title = Баптаулар
compatibility-feedback-button-label = Кері байланыс
compatibility-feedback-button-title =
    .title = Кері байланыс

## Messages used as headers in settings pane

compatibility-settings-header = Баптаулар
compatibility-target-browsers-header = Мақсатты браузерлер

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } кездесу
       *[other] { $number } кездесу
    }

compatibility-no-issues-found = Үйлесімділік мәселелері табылмады.
compatibility-close-settings-button =
    .title = Баптауларды жабу
