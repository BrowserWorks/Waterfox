# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Muat Ulang Tab
    .accesskey = M
select-all-tabs =
    .label = Pilih Semua Tab
    .accesskey = A
duplicate-tab =
    .label = Gandakan Tab
    .accesskey = G
duplicate-tabs =
    .label = Gandakan Tab
    .accesskey = G
close-tabs-to-the-end =
    .label = Tutup Tab yang Ada di Kanan Tab Ini
    .accesskey = i
close-other-tabs =
    .label = Tutup Tab Lainnya
    .accesskey = L
reload-tabs =
    .label = Muat Ulang Tab
    .accesskey = M
pin-tab =
    .label = Sematkan Tab
    .accesskey = S
unpin-tab =
    .label = Copot dari Tab Permanen
    .accesskey = c
pin-selected-tabs =
    .label = Sematkan Tab
    .accesskey = S
unpin-selected-tabs =
    .label = Lepas Sematan Tab
    .accesskey = L
bookmark-selected-tabs =
    .label = Markahi Tab…
    .accesskey = M
bookmark-tab =
    .label = Markahi Tab
    .accesskey = m
reopen-in-container =
    .label = Buka ulang di Kontainer
    .accesskey = e
move-to-start =
    .label = Pindahkan ke Awal
    .accesskey = a
move-to-end =
    .label = Pindahkan ke Akhir
    .accesskey = k
move-to-new-window =
    .label = Pindahkan ke Jendela Baru
    .accesskey = J
tab-context-close-multiple-tabs =
    .label = Tutup Banyak Tab
    .accesskey = T

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Urungkan Menutup Tab
           *[other] Urungkan Menutup Tab
        }
    .accesskey = U
close-tab =
    .label = Tutup Tab
    .accesskey = u
close-tabs =
    .label = Tutup Tab
    .accesskey = T
move-tabs =
    .label = Pindahkan Tab
    .accesskey = p
move-tab =
    .label = Pindahkan Tab
    .accesskey = p
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Tutup Tab
           *[other] Tutup Tab
        }
    .accesskey = T
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Pindahkan Tab
           *[other] Pindahkan Tab
        }
    .accesskey = P
