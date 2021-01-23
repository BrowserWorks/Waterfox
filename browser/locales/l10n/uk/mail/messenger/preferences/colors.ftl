# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Кольори
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Текст і тло

text-color-label =
    .value = Текст:
    .accesskey = Т

background-color-label =
    .value = Тло:
    .accesskey = л

use-system-colors =
    .label = Використовувати системні кольори
    .accesskey = с

colors-link-legend = Кольори посилань

link-color-label =
    .value = Невідвідані посилання:
    .accesskey = е

visited-link-color-label =
    .value = Відвідані посилання:
    .accesskey = в

underline-link-checkbox =
    .label = Підкреслювати посилання
    .accesskey = п

override-color-label =
    .value = Замінювати вказані сторінкою кольори на вибрані мною вгорі:
    .accesskey = З

override-color-always =
    .label = Завжди

override-color-auto =
    .label = Лише з висококонтрастними темами

override-color-never =
    .label = Ніколи
