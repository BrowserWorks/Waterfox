# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Colours
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Text and Background

text-color-label =
    .value = Text:
    .accesskey = T

background-color-label =
    .value = Background:
    .accesskey = B

use-system-colors =
    .label = Use system colours
    .accesskey = s

colors-link-legend = Link Colours

link-color-label =
    .value = Unvisited Links:
    .accesskey = L

visited-link-color-label =
    .value = Visited Links:
    .accesskey = V

underline-link-checkbox =
    .label = Underline links
    .accesskey = U

override-color-label =
    .value = Override the colours specified by the content with my selections above:
    .accesskey = O

override-color-always =
    .label = Always

override-color-auto =
    .label = Only with High Contrast themes

override-color-never =
    .label = Never
