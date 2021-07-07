# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Farben
    .style =
        { PLATFORM() ->
            [macos] width: 44em !important
           *[other] width: 44em !important
        }

colors-dialog-legend = Text und Hintergrund

text-color-label =
    .value = Text:
    .accesskey = T

background-color-label =
    .value = Hintergrund:
    .accesskey = H

use-system-colors =
    .label = Systemfarben verwenden
    .accesskey = S

colors-link-legend = Link-Farben

link-color-label =
    .value = Unbesuchte Links:
    .accesskey = U

visited-link-color-label =
    .value = Besuchte Links:
    .accesskey = B

underline-link-checkbox =
    .label = Links unterstreichen
    .accesskey = L

override-color-label =
    .value = Ausgewählte Farben anstatt der Farben des Inhalts verwenden:
    .accesskey = A

override-color-always =
    .label = Immer

override-color-auto =
    .label = Nur in Designs mit hohem Kontrast

override-color-never =
    .label = Nie
