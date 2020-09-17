# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = Renkler
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = Metin ve Arka Plan

text-color-label =
    .value = Metin:
    .accesskey = t

background-color-label =
    .value = Arka Plan:
    .accesskey = A

use-system-colors =
    .label = Sistem renklerini kullan
    .accesskey = S

colors-link-legend = Bağlantı Renkleri

link-color-label =
    .value = Ziyaret edilmemiş bağlantılar:
    .accesskey = b

visited-link-color-label =
    .value = Ziyaret edilmiş bağlantılar:
    .accesskey = Z

underline-link-checkbox =
    .label = Bağlantıların altını çiz
    .accesskey = n

override-color-label =
    .value = İçerikte belirtilen renkler yerine aşağıdaki tercihlerimi kullan:
    .accesskey = u

override-color-always =
    .label = Her zaman

override-color-auto =
    .label = Yalnızca yüksek karşıtlıklı temalarda

override-color-never =
    .label = Asla
