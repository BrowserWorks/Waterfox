# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Culori
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Text și fundal

text-color-label =
    .value = Text:
    .accesskey = T

background-color-label =
    .value = Fundal:
    .accesskey = F

use-system-colors =
    .label = Folosește culorile sistemului
    .accesskey = o

colors-link-legend = Culori pentru linkuri

link-color-label =
    .value = Linkuri nevizitate:
    .accesskey = L

visited-link-color-label =
    .value = Linkuri vizitate:
    .accesskey = v

underline-link-checkbox =
    .label = Subliniază linkurile
    .accesskey = u

override-color-label =
    .value = Înlocuiește culorile specificate de conținut cu selecțiile mele de mai sus:
    .accesskey = o

override-color-always =
    .label = Întotdeauna

override-color-auto =
    .label = Numai cu teme cu contrast puternic

override-color-never =
    .label = Niciodată
