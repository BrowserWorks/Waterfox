# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Temukan hasil berikutnya
findbar-previous =
    .tooltiptext = Temukan hasil sebelumnya

findbar-find-button-close =
    .tooltiptext = Tutup bilah pencarian

findbar-highlight-all2 =
    .label = Sorot Semua
    .accesskey =
        { PLATFORM() ->
            [macos] t
           *[other] t
        }
    .tooltiptext = Sorot semua frasa tersebut

findbar-case-sensitive =
    .label = Cocokkan BESAR/kecil
    .accesskey = C
    .tooltiptext = Cari sesuai dengan BESAR/kecilnya huruf

findbar-match-diacritics =
    .label = Pencocokan Diakritik
    .accesskey = i
    .tooltiptext = Bedakan antara huruf dengan diakritik dengan huruf dasarnya (misalnya saat mencari “resume” maka teks “résumé” tidak akan dicocokkan)

findbar-entire-word =
    .label = Seluruh Teks
    .accesskey = S
    .tooltiptext = Cocok dengan seluruh teks saja
