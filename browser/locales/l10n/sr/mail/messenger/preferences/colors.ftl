# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Боје
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Текст и позадина

text-color-label =
    .value = Текст:
    .accesskey = Т

background-color-label =
    .value = Позадина:
    .accesskey = П

use-system-colors =
    .label = Користи системске боје
    .accesskey = с

colors-link-legend = Боје везе

link-color-label =
    .value = Непосећене везе:
    .accesskey = з

visited-link-color-label =
    .value = Посећене везе:
    .accesskey = с

underline-link-checkbox =
    .label = Подвуци везе
    .accesskey = в

override-color-label =
    .value = Премости боје наведене у садржају са мојим изборима испод:
    .accesskey = м

override-color-always =
    .label = Увек

override-color-auto =
    .label = Само са темама високог контраста

override-color-never =
    .label = Никада
