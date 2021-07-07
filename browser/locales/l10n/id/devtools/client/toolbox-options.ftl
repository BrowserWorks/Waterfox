# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Alat Pengembang Bawaan

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Tidak didukung untuk target kotak alat saat ini

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Alat Pengembang yang diinstal dari pengaya

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Tombol Kotak Alat yang Tersedia

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Tema

## Inspector section

# The heading
options-context-inspector = Inspektur

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Tampilkan Gaya Peramban
options-show-user-agent-styles-tooltip =
    .title = Jika opsi ini diaktifkan, gaya baku yang dimuat peramban akan ditampilkan.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Potong atribut DOM
options-collapse-attrs-tooltip =
    .title = Potong atribut panjang pada inspektur

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unit warna baku
options-default-color-unit-authored = Sesuai Penyusun
options-default-color-unit-hex = Heksa
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = MHB(A)
options-default-color-unit-name = Nama Warna

## Style Editor section

# The heading
options-styleeditor-label = Editor Gaya

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS Lengkapi-Otomasis
options-stylesheet-autocompletion-tooltip =
    .title = Melengkapi secara otomatis properti, nilai, dan selektor CSS pada Editor Gaya seiring dengan ketikan Anda

## Screenshot section

# The heading
options-screenshot-label = Perilaku Tangkapan Layar

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = Cuplikan layar ke papan klip saja
options-screenshot-clipboard-tooltip2 =
    .title = Simpan tangkapan layar langsung ke papan klip

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Bunyikan suara shutter kamera
options-screenshot-audio-tooltip =
    .title = Aktifkan suara audio kamera saat mengambil tangkapan layar

## Editor section

# The heading
options-sourceeditor-label = Pengaturan Editor

options-sourceeditor-detectindentation-tooltip =
    .title = Tebak indentasi berdasarkan isi kode sumber
options-sourceeditor-detectindentation-label = Deteksi indentasi
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Sisipkan kurung penutup secara otomatis
options-sourceeditor-autoclosebrackets-label = Tutup kurung secara otomatis
options-sourceeditor-expandtab-tooltip =
    .title = Gunakan spasi, bukan karakter tab, untuk indentasi
options-sourceeditor-expandtab-label = Indentasi menggunakan spasi
options-sourceeditor-tabsize-label = Ukuran tab
options-sourceeditor-keybinding-label = Ikatan kunci
options-sourceeditor-keybinding-default-label = Baku

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = Setelan lanjutan

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Menonaktifkan HTTP Cache (saat kotak peralatan terbuka)
options-disable-http-cache-tooltip =
    .title = Mengaktifkan opsi ini akan menonaktifkan cache HTTP untuk semua tab yang kotak peralatannya terbuka. Layanan Pekerja tidak terpengaruh oleh opsi ini.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Nonaktifkan JavaScript *
options-disable-javascript-tooltip =
    .title = Dengan mengaktifkan opsi ini, JavaScript pada tab sekarang akan dinonaktifkan. Jika tab atau kotak alat ditutup maka setelan ini akan dilupakan.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Aktifkan kotak alat debug chrome peramban dan pengaya
options-enable-chrome-tooltip =
    .title = Mengaktifkan opsi ini akan dapat digunakan untuk menggunakan berbagai alat pengembang dalam konteks peramban (lewat Alat > Pengembang Web > Kotak Alat Peramban) serta mendebug pengaya dari Pengelola Pengaya

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Aktifkan pendebugan jarak jauh
options-enable-remote-tooltip2 =
    .title = Mengaktifkan opsi ini akan memungkinkan untuk mendebug instans peramban ini dari jarak jauh

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Aktifkan Service Worker lewat HTTP (saat kotak alat terbuka)
options-enable-service-workers-http-tooltip =
    .title = Mengaktifkan opsi ini akan mengaktifkan Service Worker lewat HTTP untuk semua tab yang kotak alatnya terbuka.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Aktifkan Peta Sumber
options-source-maps-tooltip =
    .title = Jika opsi ini diaktifkan, kode sumber akan dipetakan dalam alat.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Hanya sesi ini saja, memulai ulang laman

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Tampilkan data platform Gecko
options-show-platform-data-tooltip =
    .title = Jika Anda mengaktifkan opsi ini, laporan Profiler JavaScript akan menyertakan  simbol platform Gecko
