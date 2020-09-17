# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Zaznaczony element
compatibility-all-elements-header = Wszystkie problemy

## Message used as labels for the type of issue

compatibility-issue-deprecated = (przestarzałe)
compatibility-issue-experimental = (eksperymentalne)
compatibility-issue-prefixneeded = (wymagany przedrostek)
compatibility-issue-deprecated-experimental = (przestarzałe, eksperymentalne)

compatibility-issue-deprecated-prefixneeded = (przestarzałe, wymagany przedrostek)
compatibility-issue-experimental-prefixneeded = (eksperymentalne, wymagany przedrostek)
compatibility-issue-deprecated-experimental-prefixneeded = (przestarzałe, eksperymentalne, wymagany przedrostek)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Ustawienia
compatibility-settings-button-title =
    .title = Ustawienia
compatibility-feedback-button-label = Wyślij opinię
compatibility-feedback-button-title =
    .title = Wyślij opinię

## Messages used as headers in settings pane

compatibility-settings-header = Ustawienia
compatibility-target-browsers-header = Przeglądarki docelowe

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } wystąpienie
        [few] { $number } wystąpienia
       *[many] { $number } wystąpień
    }

compatibility-no-issues-found = Nie znaleziono problemów ze zgodnością.
compatibility-close-settings-button =
    .title = Zamknij ustawienia
