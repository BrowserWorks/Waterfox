# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Kolory
    .style =
        { PLATFORM() ->
            [macos] width: 46em !important
           *[other] width: 43em !important
        }

colors-dialog-legend = Tekst i tło

text-color-label =
    .value = Tekst:
    .accesskey = e

background-color-label =
    .value = Tło:
    .accesskey = T

use-system-colors =
    .label = Używaj kolorów systemowych
    .accesskey = U

colors-link-legend = Kolory odnośników

link-color-label =
    .value = Nieodwiedzone odnośniki:
    .accesskey = N

visited-link-color-label =
    .value = Odwiedzone odnośniki:
    .accesskey = O

underline-link-checkbox =
    .label = Podkreślaj odnośniki
    .accesskey = d

override-color-label =
    .value = Nadpisuj kolory określone w treści wybranymi poniżej:
    .accesskey = N

override-color-always =
    .label = Zawsze

override-color-auto =
    .label = Tylko w motywach o wysokim kontraście

override-color-never =
    .label = Nigdy
