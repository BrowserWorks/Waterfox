# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Tab Baru
    .accesskey = T
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
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Tutup Tab yang Ada di Kiri Tab Ini
    .accesskey = i
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
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
tab-context-open-in-new-container-tab =
    .label = Buka di Tab Kontainer Baru
    .accesskey = T
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
tab-context-share-url =
    .label = Bagikan
    .accesskey = B
tab-context-share-more =
    .label = Lainnya…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Buka Kembali Tab Tertutup
           *[other] Buka Kembali Tab Tertutup
        }
    .accesskey = u
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

tab-context-send-tabs-to-device =
    .label = Kirim Tab ke { $tabCount } Peranti
    .accesskey = k
