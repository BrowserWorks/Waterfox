# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Вылучаны элемент
compatibility-all-elements-header = Усе праблемы

## Message used as labels for the type of issue

compatibility-issue-deprecated = (састарэлы)
compatibility-issue-experimental = (эксперыментальны)
compatibility-issue-prefixneeded = (патрэбен прэфікс)
compatibility-issue-deprecated-experimental = (састарэлы, эксперыментальны)
compatibility-issue-deprecated-prefixneeded = (састарэлы, патрэбен прэфікс)
compatibility-issue-experimental-prefixneeded = (эксперыментальны, патрэбен прэфікс)
compatibility-issue-deprecated-experimental-prefixneeded = (састарэлы, эксперыментальны, патрэбен прэфікс)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Налады
compatibility-settings-button-title =
    .title = Налады
compatibility-feedback-button-label = Водгукі і прапановы
compatibility-feedback-button-title =
    .title = Водгукі і прапановы

## Messages used as headers in settings pane

compatibility-settings-header = Налады
compatibility-target-browsers-header = Мэтавыя браўзеры

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } выпадак
        [few] { $number } выпадкі
       *[many] { $number } выпадкаў
    }
compatibility-no-issues-found = Праблем з сумяшчальнасцю не выяўлена.
compatibility-close-settings-button =
    .title = Зачыніць налады
