# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Colors
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Text and Background

text-color-label =
    .value = Text:
    .accesskey = t

background-color-label =
    .value = Background:
    .accesskey = b

use-system-colors =
    .label = Use system colors
    .accesskey = s

colors-link-legend = Link Colors

link-color-label =
    .value = Unvisited Links:
    .accesskey = l

visited-link-color-label =
    .value = Visited Links:
    .accesskey = v

underline-link-checkbox =
    .label = Underline links
    .accesskey = u

