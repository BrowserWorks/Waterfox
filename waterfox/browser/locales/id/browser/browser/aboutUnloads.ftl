# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Pembongkaran Tab
about-unloads-intro =
    { -brand-short-name } memiliki fitur yang secara otomatis membongkar tab
    untuk mencegah aplikasi rusak karena kekurangan memori
    saat memori sistem yang tersedia hampir habis. Tab yang akan dibongkar
    dipilih berdasarkan beberapa jenis data. Laman ini menunjukkan cara 
    { -brand-short-name } memprioritaskan tab dan tab mana yang akan dibongkar
    saat pembongkaran tab terpicu. Anda dapat memicu tab dibongkat secara manual
    dengan mengeklik tombol <em>Bongkar</em> di bawah ini.

# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    Lihat <a data-l10n-name="doc-link">Pembongkaran Tab</a> untuk mempelajari lebih lanjut tentang
    fitur dan halaman ini.

about-unloads-last-updated = Terakhir diperbarui: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Bongkar
    .title = Bongkar tab dengan prioritas tertinggi
about-unloads-no-unloadable-tab = Tidak ada tab yang dapat dibongkar.

about-unloads-column-priority = Prioritas
about-unloads-column-host = Host
about-unloads-column-last-accessed = Diakses Terakhir
about-unloads-column-weight = Nilai Dasar
    .title = Tab pertama kali akan diurutkan berdasarkan nilai berikut, yang  berasal dari beberapa atribut spesial seperti memainkan suara, WebRTC, dan sebagainya.
about-unloads-column-sortweight = Nilai Sekunder
    .title = Jika tersedia, tab akan diurutkan berdasarkan nilai berikut setelah pengurutan berdasarkan nilai dasar selesai dilakukan. Nilainya berasal dari penggunaan memori dan jumlah proses.
about-unloads-column-memory = Memori
    .title = Perkiraan memori yang digunakan tab
about-unloads-column-processes = ID Proses
    .title = ID dari proses yang menjalankan tab

about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
