# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Sekmeyi tazele
    .accesskey = z
select-all-tabs =
    .label = Tüm sekmeleri seç
    .accesskey = ü
duplicate-tab =
    .label = Sekmeyi çoğalt
    .accesskey = o
duplicate-tabs =
    .label = Sekmeleri çoğalt
    .accesskey = o
close-tabs-to-the-end =
    .label = Sağdaki sekmeleri kapat
    .accesskey = a
close-other-tabs =
    .label = Diğer sekmeleri kapat
    .accesskey = D
reload-tabs =
    .label = Sekmeleri tazele
    .accesskey = z
pin-tab =
    .label = Sekmeyi sabitle
    .accesskey = S
unpin-tab =
    .label = Normal sekmeye dönüştür
    .accesskey = N
pin-selected-tabs =
    .label = Sekmeleri sabitle
    .accesskey = S
unpin-selected-tabs =
    .label = Normal sekmeye dönüştür
    .accesskey = N
bookmark-selected-tabs =
    .label = Sekmeleri yer imlerine ekle…
    .accesskey = k
bookmark-tab =
    .label = Sekmeyi yer imlerine ekle
    .accesskey = i
reopen-in-container =
    .label = Kapsayıcıda yeniden aç
    .accesskey = K
move-to-start =
    .label = En başa taşı
    .accesskey = E
move-to-end =
    .label = En sona taşı
    .accesskey = s
move-to-new-window =
    .label = Yeni pencereye taşı
    .accesskey = Y
tab-context-close-multiple-tabs =
    .label = Birden çok sekmeyi kapat
    .accesskey = B

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Kapatılan sekmeyi aç
            [one] Kapatılan sekmeyi aç
           *[other] Kapatılan sekmeleri aç
        }
    .accesskey = l
close-tab =
    .label = Sekmeyi kapat
    .accesskey = e
close-tabs =
    .label = Sekmeleri kapat
    .accesskey = S
move-tabs =
    .label = Sekmeleri taşı
    .accesskey = t
move-tab =
    .label = Sekmeyi taşı
    .accesskey = t
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Sekmeyi kapat
            [one] Sekmeyi kapat
           *[other] Sekmeleri kapat
        }
    .accesskey = e
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Sekmeyi taşı
            [one] Sekmeleri taşı
           *[other] Sekmeleri taşı
        }
    .accesskey = t
