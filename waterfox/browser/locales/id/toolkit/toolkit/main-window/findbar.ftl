# This Source Code Form is subject to the terms of the BrowserWorks Public
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

findbar-not-found = Frasa tidak ditemukan

findbar-wrapped-to-top = Sampai di akhir laman, dilanjutkan dari atas
findbar-wrapped-to-bottom = Sampai di awal laman, dilanjutkan dari bawah

findbar-normal-find =
    .placeholder = Temukan di laman
findbar-fast-find =
    .placeholder = Pencarian cepat
findbar-fast-find-links =
    .placeholder = Pencarian cepat (hanya tautan)

findbar-case-sensitive-status =
    .value = (Cocokkan BESAR/kecilnya huruf)
findbar-match-diacritics-status =
    .value = (Pencocokan diakritik)
findbar-entire-word-status =
    .value = (Hanya seluruh kata)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value = { $current } dari { $total } yang cocok

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value = Lebih dari { $limit } kecocokan
