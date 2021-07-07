# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Цвета
    .style =
        { PLATFORM() ->
            [macos] width: 57em !important
           *[other] width: 42em !important
        }

colors-dialog-legend = Текст и фон

text-color-label =
    .value = Текст:
    .accesskey = к

background-color-label =
    .value = Фон:
    .accesskey = о

use-system-colors =
    .label = Использовать системные цвета
    .accesskey = с

colors-link-legend = Цвет ссылок

link-color-label =
    .value = Непросмотренные ссылки:
    .accesskey = е

visited-link-color-label =
    .value = Просмотренные ссылки:
    .accesskey = м

underline-link-checkbox =
    .label = Подчёркивать ссылки
    .accesskey = ч

override-color-label =
    .value = Заменять цвета, указанные содержимым, на выбранные мной выше цвета:
    .accesskey = а

override-color-always =
    .label = Всегда

override-color-auto =
    .label = Только с высококонтрастными темами

override-color-never =
    .label = Никогда
