# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = Alatan Pembangun Piawai

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * Tidak disokong untuk sasaran kekotak alatan semasa

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = Alatan Pembangun dipasang oleh add-ons

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = Butang Kotak Alatan Yang Ada

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = Tema

## Inspector section

# The heading
options-context-inspector = Pemeriksa

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = Papar Gaya Pelayar
options-show-user-agent-styles-tooltip =
    .title = Mengaktifkan ini akan dapat memaparkan gaya piawai yang dimuatkan oleh pelayar.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = Trunkat atribut DOM
options-collapse-attrs-tooltip =
    .title = Trunkat atribut panjang dalam pemeriksa

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = Unit warna piawai
options-default-color-unit-authored = Seperti yang Ditetapkan
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = Nama Warna

## Style Editor section

# The heading
options-styleeditor-label = Editor Gaya

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS Auto-lengkap
options-stylesheet-autocompletion-tooltip =
    .title = Ciri, nilai dan pemilih CSS auto-lengkap dalam Editor Gaya sebaik sahaja anda menaip

## Screenshot section

# The heading
options-screenshot-label = Perilaku Skrinsyot

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = Skrinsyot ke klipbod
options-screenshot-clipboard-tooltip =
    .title = Simpan skrinsyot terus ke klipbod

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = Mainkan bunyi pengatup kamera
options-screenshot-audio-tooltip =
    .title = Dayakan audio kamera apabila mengambil skrinshot

## Editor section

# The heading
options-sourceeditor-label = Keutamaan Editor

options-sourceeditor-detectindentation-tooltip =
    .title = Mengandai berasaskan inden pada konteks sumber
options-sourceeditor-detectindentation-label = Mengesan inden
options-sourceeditor-autoclosebrackets-tooltip =
    .title = Menyelitkan tutup pendakap secara automatik
options-sourceeditor-autoclosebrackets-label = Auto tutup pendakap
options-sourceeditor-expandtab-tooltip =
    .title = Gunakan ruang dan bukannya aksara tab
options-sourceeditor-expandtab-label = Inden menggunakan ruang
options-sourceeditor-tabsize-label = Saiz tab
options-sourceeditor-keybinding-label = Keybindings
options-sourceeditor-keybinding-default-label = Piawai

## Advanced section

# The heading
options-context-advanced-settings = Tetapan lanjutan

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = Nyahdayakan Cache HTTP (apabila kotak alat dibuka)
options-disable-http-cache-tooltip =
    .title = Mengaktifkan pilihan ini akan menyahdayakan cache HTTP untuk semua tab yang ada kotak alat yang dibuka. Service Workers tidak terkesan dengan pilihan ini.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = Nyahdayakan JavaScript *
options-disable-javascript-tooltip =
    .title = Mengaktifkan pilihan ini akan menyahdayakan JavaScript untuk tab semasa. Jika tab atau kotak alat ditutup maka tetapan ini akan diabaikan.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = Dayakan pelayar chrome dan kotak alatan menyahpepijat add-ons
options-enable-chrome-tooltip =
    .title = Mengaktifkan pilihan ini akan membolehkan anda untuk menggunakan pelbagai alat pembangun dalam konteks pelayar (via Alatan > Pembangun Web > Kotak Alatan Pelayar) dan debug add-ons dari Pengurus Add-ons

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = Dayakan nyahpepijat jauh

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = Dayakan Service Workers menerusi HTTP (apabila kotak alatan terbuka)
options-enable-service-workers-http-tooltip =
    .title = Mengaktifkan pilihan ini akan mendayakan service workers menerusi HTTP untuk semua tab yang ada kotak alatan terbuka.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = Dayakan Sumber Peta
options-source-maps-tooltip =
    .title = Jika anda aktifkan pilihan ini, sumber ini akan dipetakan di dalam alatan.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * Sesi semasa sahaja, ulang muat laman

##

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Papar data platform Gecko
options-show-platform-data-tooltip =
    .title =
        Jika anda dayakan pilihan ini JavaScript laporan Profiler akan memasukkan
        simbol platfom Gecko
