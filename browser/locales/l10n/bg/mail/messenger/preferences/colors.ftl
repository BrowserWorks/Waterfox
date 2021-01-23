# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Цветове
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Текст и фон

text-color-label =
    .value = Текст:
    .accesskey = Т

background-color-label =
    .value = Фон:
    .accesskey = Ф

use-system-colors =
    .label = Използване на системни цветове
    .accesskey = с

colors-link-legend = Цветове на препратки

link-color-label =
    .value = Непосетени:
    .accesskey = о

visited-link-color-label =
    .value = Посетени:
    .accesskey = с

underline-link-checkbox =
    .label = Подчертаване на препратки
    .accesskey = П

override-color-label =
    .value = Предпочитане на избраните от мен цветове пред зададените от съдържанието:
    .accesskey = р

override-color-always =
    .label = Винаги

override-color-auto =
    .label = Само за теми с висок контраст

override-color-never =
    .label = Никога
