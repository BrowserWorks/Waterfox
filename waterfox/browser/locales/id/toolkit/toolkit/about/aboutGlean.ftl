# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### "Glean" and "Glean SDK" should remain in English.

### "FOG", "Glean", and "Glean SDK" should remain in English.

-fog-brand-name = FOG
-glean-brand-name = Glean
glean-sdk-brand-name = { -glean-brand-name } SDK
glean-debug-ping-viewer-brand-name = { -glean-brand-name } Debug Ping Viewer

about-glean-page-title2 = Tentang { -glean-brand-name }
about-glean-header = Tentang { -glean-brand-name }
about-glean-interface-description =
    <a data-l10n-name="glean-sdk-doc-link">{ glean-sdk-brand-name }</a>
    adalah pustaka pengumpulan data yang digunakan pada proyek { -vendor-short-name }.
    Antarmuka ini dirancang untuk digunakan oleh pengembang dan penguji secara manual
    <a data-l10n-name="fog-link">instruksi pengujian</a>.

about-glean-upload-enabled = Pengunggahan data diaktifkan.
about-glean-upload-disabled = Pengunggahan data dinonaktifkan.
about-glean-upload-enabled-local = Pengunggahan data diaktifkan hanya untuk mengirim ke server lokal.
about-glean-upload-fake-enabled =
    Pengunggahan data dinonaktifkan,
    tapi kami berbohong dan memberi tahu { glean-sdk-brand-name } itu diaktifkan
    sehingga data masih terekam secara lokal.
    Catatan: Jika Anda menyetel tag debug, ping akan diunggah ke
    <a data-l10n-name="glean-debug-ping-viewer">{ glean-debug-ping-viewer-brand-name }</a> apa pun setelannya.

# This message is followed by a bulleted list.
about-glean-prefs-and-defines = <a data-l10n-name="fog-prefs-and-defines-doc-link">Preferensi dan definisi</a> yang relevan mencakup:
# Variables:
#   $data-upload-pref-value (String): the value of the datareporting.healthreport.uploadEnabled pref. Typically "true", sometimes "false"
# Do not translate strings between <code> </code> tags.
about-glean-data-upload = <code>datareporting.healthreport.uploadEnabled</code>: { $data-upload-pref-value }
# Variables:
#   $local-port-pref-value (Integer): the value of the telemetry.fog.test.localhost_port pref. Typically 0. Can be negative.
# Do not translate strings between <code> </code> tags.
about-glean-local-port = <code>telemetry.fog.test.localhost_port</code>: { $local-port-pref-value }
# Variables:
#   $glean-android-define-value (Boolean): the value of the MOZ_GLEAN_ANDROID define. Typically "false", sometimes "true".
# Do not translate strings between <code> </code> tags.
about-glean-glean-android = <code>MOZ_GLEAN_ANDROID</code>: { $glean-android-define-value }
# Variables:
#   $moz-official-define-value (Boolean): the value of the MOZILLA_OFFICIAL define.
# Do not translate strings between <code> </code> tags.
about-glean-moz-official = <code>MOZILLA_OFFICIAL</code>: { $moz-official-define-value }

about-glean-about-testing-header = Tentang Pengujian
# This message is followed by a numbered list.
about-glean-manual-testing =
    Instruksi lengkap didokumentasikan dalam
    <a data-l10n-name="fog-instrumentation-test-doc-link">{ -fog-brand-name } dokumen pengujian instrumentasi</a>
    dan dalam <a data-l10n-name="glean-sdk-doc-link">dokumentasi { glean-sdk-brand-name }</a>,
    namun, singkatnya, untuk menguji secara manual apakah instrumentasi Anda berfungsi, Anda harus:

# This message is an option in a dropdown filled with untranslated names of pings.
about-glean-no-ping-label = (jangan kirimkan ping apapun)
# An in-line text input field precedes this string.
about-glean-label-for-tag-pings = Di bidang sebelumnya pastikan ada tag debug yang mudah diingat sehingga Anda dapat mengenali ping Anda nanti.
# An in-line drop down list precedes this string.
# Do not translate strings between <code> </code> tags.
about-glean-label-for-ping-names =
    Pilih dari daftar sebelumnya tempat ping instrumentasi Anda berada.
    Jika ada di <a data-l10n-name="custom-ping-link">ping khusus</a>, pilih yang itu.
    Jika tidak, baku untuk metrik <code>event</code> adalah
    ping <code>events</code>
    dan baku untuk semua metrik lainnya adalah
    ping <code>metrik</code>.
# An in-line check box precedes this string.
about-glean-label-for-log-pings =
    (Opsional. Centang kotak sebelumnya jika Anda ingin ping juga dicatat saat dikirimkan.
    Anda juga harus <a data-l10n-name="enable-logging-link">mengaktifkan logging</a>.)
# Variables
#   $debug-tag (String): The user-set value of the debug tag input on this page. Like "about-glean-kV"
# An in-line button labeled "Apply settings and submit ping" precedes this string.
about-glean-label-for-controls-submit =
    Tekan tombol sebelumnya untuk menandai semua ping { -glean-brand-name } dengan tag Anda dan mengirimkan ping yang dipilih.
    (Semua ping yang dikirim sejak saat itu hingga Anda memulai ulang aplikasi akan ditandai
    <code>{ $debug-tag }</code>.)
about-glean-li-for-visit-gdpv =
    <a data-l10n-name="gdpv-tagged-pings-link">Kunjungi laman { glean-debug-ping-viewer-brand-name } untuk mengetahui ping dengan tag Anda</a>.
    Seharusnya tidak perlu lebih dari beberapa detik dari menekan tombol hingga ping Anda tiba.
    Terkadang dibutuhkan beberapa menit.

# Do not translate strings between <code> </code> tags.
about-glean-adhoc-explanation =
    Untuk pengujian <i>ad hoc</i> lainnya,
    Anda juga dapat menentukan nilai instrumen tertentu saat ini
    dengan membuka konsol devtools di sini di <code>about:glean</code>
    dan menggunakan API <code>testGetValue()</code> seperti
    <code>Glean.metricCategory.metricName.testGetValue()</code>.


controls-button-label-verbose = Terapkan pengaturan dan kirimkan ping

about-glean-about-data-header = Tentang Data
about-glean-about-data-explanation =
    Untuk menelusuri daftar data yang dikumpulkan, silakan berkonsultasi dengan
    <a data-l10n-name="glean-dictionary-link">{ -glean-brand-name } Kamus</a>.
