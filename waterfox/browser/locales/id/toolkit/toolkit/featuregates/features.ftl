# This Source Code Form is subject to the terms of the Waterfox Public
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
experimental-features-media-jxl =
    .label = Media: JPEG XL
experimental-features-media-jxl-description = Dengan fitur ini diaktifkan, { -brand-short-name } mendukung format JPEG XL (JXL). Ini adalah format file gambar yang disempurnakan yang mendukung transisi lossless dari file JPEG tradisional. Lihat <a data-l10n-name="bugzilla">bug 1539075</a> untuk detail selengkapnya.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheet
experimental-features-css-constructable-stylesheets-description = Penambahan konstruktor untuk antarmuka <a data-l10n-name="mdn-cssstylesheet">CSSylesheet</a> serta berbagai perubahan yang terkait memungkinkan pembuatan stylesheet baru secara langsung tanpa harus menambahkan stylesheet ke HTML. Ini mempermudah penggunaan ulang stylesheet untuk digunakan dengan <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Lihat <a data-l10n-name="bugzilla">bug 1520690</a> untuk detal lebih lanjut.
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
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Aktifkan Warp, sebuah proyek untuk meningkatkan kinerja JavaScript dan penggunaan memori.
# Search during IME
experimental-features-ime-search =
    .label = Bilah Alamat: Tampilkan hasil selama komposisi IME
experimental-features-ime-search-description = IME (Input Method Editor) adalah alat yang memungkinkan Anda memasukkan simbol kompleks, seperti yang digunakan dalam bahasa tulis Asia Timur atau India, menggunakan papan ketik standar. Mengaktifkan eksperimen ini akan membuat panel alamat terbuka, menampilkan hasil pencarian dan saran, ketika menggunakan IME untuk memasukkan teks. Perhatikan bahwa IME mungkin menampilkan panel yang menutupi hasil bilah alamat, karena itu preferensi ini hanya disarankan bagi IME tidak menggunakan panel jenis ini.
# Text recognition for images
experimental-features-text-recognition =
    .label = Pengenalan Teks
experimental-features-text-recognition-description = Aktifkan fitur untuk mengenali teks dalam gambar.
