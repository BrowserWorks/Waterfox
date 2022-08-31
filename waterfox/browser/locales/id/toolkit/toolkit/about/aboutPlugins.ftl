# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Tentang Plugin

installed-plugins-label = Plugin terinstal
no-plugins-are-installed-label = Tidak ada plugin terinstal yang ditemukan

deprecation-description = Kehilangan sesuatu? Beberapa plugin tidak lagi didukung. <a data-l10n-name="deprecation-link">Pelajari Lebih Lanjut.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Nama berkas:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Direktori:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versi:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Status:</span> Aktif
state-dd-enabled-block-list-state = <span data-l10n-name="state">Status:</span> Aktif ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Status:</span> Nonaktif
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Status:</span> Nonaktif ({ $blockListState })

mime-type-label = Jenis MIME
description-label = Deskripsi
suffixes-label = Awalan

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = Informasi lisensi
plugins-gmp-privacy-info = Informasi Privasi

plugins-openh264-name = Codec Video OpenH264 disediakan oleh Cisco Systems, Inc.
plugins-openh264-description = Plugin ini diinstal secara otomatis oleh Waterfox untuk memenuhi spesifikasi WebRTC dan untuk mengaktifkan panggilan WebRTC dengan perangkat yang menggunakan codec video H.264. Kunjungi http://www.openh264.org/ untuk melihat kode sumber codec dan mempelajari implementasinya lebih lanjut.

plugins-widevine-name = Modul Dekripsi Konten Widevine disediakan oleh Google Inc.
plugins-widevine-description = Plugin ini memungkinkan pemutaran media terenkripsi sesuai dengan spesifikasi Encrypted Media Extensions. Media terenkripsi biasanya digunakan oleh situs untuk perlindungan terhadap penyalinan konten media premium. Kunjungi https://www.w3.org/TR/encrypted-media/ untuk informasi lebih lanjut tentang Encrypted Media Extensions.
