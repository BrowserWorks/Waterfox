# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Mengaktifkan dukungan untuk fitur Layout CSS Masonry eksperimental. Lihat <a data-l10n-name="explainer">penjelasan</a> untuk mendapatkan deskripsi fitur yang lebih lengkap. Untuk memberikan umpan balik, silakan berkomentar di <a data-l10n-name="w3c-issue">isu GitHub ini</a> atau <a data-l10n-name="bug">bug ini</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = API Web: WebGPU
experimental-features-web-gpu-description2 = API baru ini menyediakan dukungan tingkat-rendah untuk melakukan komputasi dan perenderan grafis dengan menggunakan <a data-l10n-name="wikipedia">Unit Pemrosesan Grafik (GPU)</a> dari perangkat atau komputer pengguna. <a data-l10n-name="spec">Spesifikasi</a> masih dalam proses pengembangan. Lihat <a data-l10n-name="bugzilla">bug 1602129</a> untuk detail lebih lanjut.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Jika fitur ini diaktifkan, { -brand-short-name } akan mendukung format Berkas Gambar AV1 (AVIF). Ini adalah format berkas gambar diam yang memanfaatkan kemampuan algoritme kompresi video AV1 untuk mengurangi ukuran gambar. Lihat <a data-l10n-name="bugzilla">bug 1443863</a> untuk detail lebih lanjut.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Media: JPEG XL
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = API Web: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Implementasi kami untuk atribut global <a data-l10n-name="mdn-inputmode">inputmode</a> telah diperbarui sesuai <a data-l10n-name="whatwg">spesifikasi WHATWG</a>. Namun kami masih perlu membuat perubahan lain juga, seperti memperbarui hal yang sama untuk konten contenteditable. Lihat <a data-l10n-name="bugzilla">bug 1205133</a> untuk detail lebih lanjut.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheet
experimental-features-css-constructable-stylesheets-description = Penambahan konstruktor untuk antarmuka <a data-l10n-name="mdn-cssstylesheet">CSSylesheet</a> serta berbagai perubahan yang terkait memungkinkan pembuatan stylesheet baru secara langsung tanpa harus menambahkan stylesheet ke HTML. Ini mempermudah penggunaan ulang stylesheet untuk digunakan dengan <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Lihat <a data-l10n-name="bugzilla">bug 1520690</a> untuk detal lebih lanjut.
experimental-features-devtools-color-scheme-simulation =
    .label = Alat Pengembang: Simulasi Skema Warna
experimental-features-devtools-color-scheme-simulation-description = Menambahkan opsi untuk simulasi berbagai skema warna yang memungkinkan Anda untuk menguji media query <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a>. Menggunakan query ini memungkinkan stylesheet Anda merespons apakah pengguna lebih suka antarmuka yang terang atau gelap. Fitur ini memungkinkan Anda menguji kode tanpa harus mengubah setelan di peramban (atau sistem operasi, jika peramban mengikuti setelan skema warna keseluruhan sistem). Lihat <a data-l10n-name="bugzilla1">bug 1550804</a> dan <a data-l10n-name="bugzilla2">bug 1137699</a> untuk detail lebih lanjut.
experimental-features-devtools-execution-context-selector =
    .label = Alat Pengembang: Pemilih Konteks Eksekusi
experimental-features-devtools-execution-context-selector-description = Fitur ini menampilkan tombol pada baris perintah konsol yang memungkinkan Anda mengubah konteks pada ekspresi yang dimasukkan untuk dieksekusi. Lihat <a data-l10n-name="bugzilla1">bug 1605154</a> dan <a data-l10n-name="bugzilla2">bug 1605153</a> untuk detail lebih lanjut.
experimental-features-devtools-compatibility-panel =
    .label = Alat Pengembang: Panel Kompabilitas
experimental-features-devtools-compatibility-panel-description = Panel samping untuk Inspektur Laman yang menampilkan informasi yang merinci status kompatibilitas lintas peramban aplikasi Anda. Lihat <a data-l10n-name="bugzilla">bug 158464</a> untuk detail lebih lanjut.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Kuki: SameSite=Lax secara baku
experimental-features-cookie-samesite-lax-by-default2-description = Perlakukan kuki sebagai “SameSite=Lax” secara baku jika tidak ada atribut “SameSite” ditentukan. Pengembang harus memilih status quo saat ini dari penggunaan yang tidak terbatas dengan secara eksplisit menyatakan “SameSite=None””.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Kuki: SameSite=None memerlukan atribut aman
experimental-features-cookie-samesite-none-requires-secure2-description = Kuki dengan atribut “SameSite=None” memerlukan atribut aman. Fitur ini memerlukan "Kuki: SameSite=Lax secara baku".
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = Tembolok awal about:home
experimental-features-abouthome-startup-cache-description = Tembolok untuk dokumen about:home awal yang dimuat secara baku pada saat memulai. Tujuan dari tembolok ini adalah untuk meningkatkan kinerja proses mulai.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Kuki: SameSite Berskema
experimental-features-cookie-samesite-schemeful-description = Perlakukan kuki dari domain sama, tetapi dengan skema berbeda (contoh: http://example.com dan https://example.com) sebagai situs silang dan bukan situs yang sama. Hal ini meningkatkan keamanan tetapi mengandung potensi kerusakan.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Alat Pengembang: Debugging Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Mengaktifkan dukungan eksperimental untuk Service Worker di panel Debugger. Fitur ini mungkin memperlambat Alat Pengembang dan meningkatkan penggunaan memori.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Aktifkan/Nonaktifkan Kesenyapan WebRTC Global
experimental-features-webrtc-global-mute-toggles-description = Tambahkan kontrol ke indikator berbagi global WebRTC yang memungkinkan pengguna menonaktfikan suara mikrofon dan umpan kamera secara global.
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Win32k Lockdown
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Aktifkan Warp, sebuah proyek untuk meningkatkan kinerja JavaScript dan penggunaan memori.
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (Isolasi Situs)
experimental-features-fission-description = Fission (isolasi situs) adalah fitur eksperimental di { -brand-short-name } untuk menyediakan lapisan pertahanan tambahan terhadap bug keamanan. Dengan mengisolasi masing-masing situs ke dalam proses terpisah, Fission mempersulit situs web berbahaya mendapatkan akses ke informasi laman lain yang Anda kunjungi. Ini adalah perubahan arsitektur besar-besaran pada { -brand-short-name } dan kami berterima kasih jika Anda menguji dan melaporkan masalah yang mungkin dialami. Untuk detail lebih lanjut, lihat <a data-l10n-name="wiki">wiki</a>.
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = Dukungan Beberapa Gambar-dalam-Gambar
experimental-features-multi-pip-description = Dukungan eksperimental untuk memungkinkan beberapa jendela Gambar-dalam-Gambar dibuka pada saat yang sama.
experimental-features-http3 =
    .label = Protokol HTTP/3
experimental-features-http3-description = Dukungan eksperimental untuk protokol HTTP/3.
# Search during IME
experimental-features-ime-search =
    .label = Bilah Alamat: Tampilkan hasil selama komposisi IME
experimental-features-ime-search-description = IME (Input Method Editor) adalah alat yang memungkinkan Anda memasukkan simbol kompleks, seperti yang digunakan dalam bahasa tulis Asia Timur atau India, menggunakan papan ketik standar. Mengaktifkan eksperimen ini akan membuat panel alamat terbuka, menampilkan hasil pencarian dan saran, ketika menggunakan IME untuk memasukkan teks. Perhatikan bahwa IME mungkin menampilkan panel yang menutupi hasil bilah alamat, karena itu preferensi ini hanya disarankan bagi IME tidak menggunakan panel jenis ini.
