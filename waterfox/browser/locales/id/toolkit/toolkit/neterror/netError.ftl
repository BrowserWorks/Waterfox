# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Memuat laman bermasalah
certerror-page-title = Peringatan: Potensi Risiko Keamanan Menghadang
certerror-sts-page-title = Tidak Tersambung: Dugaan Masalah Keamanan
neterror-blocked-by-policy-page-title = Laman Diblokir
neterror-captive-portal-page-title = Masuk ke jaringan
neterror-dns-not-found-title = Server Tidak Ditemukan
neterror-malformed-uri-page-title = URL tidak valid

## Error page actions

neterror-advanced-button = Tingkat Lanjut…
neterror-copy-to-clipboard-button = Salin teks ke papan klip
neterror-learn-more-link = Pelajari lebih lanjut…
neterror-open-portal-login-page-button = Buka Laman Masuk Jaringan
neterror-override-exception-button = Terima Risikonya dan Lanjutkan
neterror-pref-reset-button = Pulihkan setelan baku
neterror-return-to-previous-page-button = Mundur
neterror-return-to-previous-page-recommended-button = Kembali (Disarankan)
neterror-try-again-button = Coba Lagi
neterror-add-exception-button = Selalu lanjutkan untuk situs ini
neterror-settings-button = Ubah Pengaturan DNS
neterror-view-certificate-link = Tampilkan Sertifikat
neterror-disable-native-feedback-warning = Selalu lanjutkan

##

neterror-pref-reset = Tampaknya setelan keamanan jaringan Anda yang mungkin menyebabkan ini. Ingin setelan baku dipulihkan?
neterror-error-reporting-automatic = Laporkan kesalahan seperti ini untuk membantu { -vendor-short-name } mengidentifikasi dan memblokir situs yang mencurigakan.

## Specific error messages

neterror-generic-error = Untuk alasan tertentu { -brand-short-name } tidak dapat memuat laman ini.

neterror-load-error-try-again = Sementara ini mungkin situs terlalu sibuk atau tidak menyala. Cobalah beberapa saat lagi.
neterror-load-error-connection = Apabila Anda tidak dapat memuat laman apa pun, periksa sambungan jaringan komputer Anda.
neterror-load-error-firewall = Apabila komputer atau jaringan Anda dilindungi firewall atau proksi, pastikan bahwa { -brand-short-name } diizinkan mengakses Web.

neterror-captive-portal = Anda harus masuk ke dalam jaringan ini sebelum dapat mengakses Internet.

# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Apakah Anda bermaksud membuka <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Jika Anda memasukkan alamat yang benar, Anda dapat:</strong>
neterror-dns-not-found-hint-try-again = Coba lagi nanti
neterror-dns-not-found-hint-check-network = Periksa sambungan jaringan Anda
neterror-dns-not-found-hint-firewall = Periksa apakah { -brand-short-name } memiliki izin untuk mengakses web (Anda mungkin tersambung tetapi berada di balik firewall)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } tidak dapat melindungi permintaan Anda untuk alamat situs ini melalui resolusi DNS yang terpercaya kami. Alasannya adalah sebagai berikut:

neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } tidak dapat terhubung ke { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = Sambungan ke { $trrDomain } memakan waktu lebih lama dari yang diharapkan.
neterror-dns-not-found-trr-offline = Anda tidak tersambung ke internet.
neterror-dns-not-found-trr-server-problem = Ada masalah dengan { $trrDomain }.
neterror-dns-not-found-trr-unknown-problem = Kesalahan tak terduga.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } tidak dapat melindungi permintaan Anda untuk alamat situs ini melalui resolusi DNS yang terpercaya kami. Alasannya adalah sebagai berikut:
neterror-dns-not-found-native-fallback-heuristic = DNS lewat HTTP telah dinonaktifkan pada jaringan Anda.

##

neterror-file-not-found-filename = Periksa penggunaan huruf besar/kecil pada nama berkas atau kesalahan pengetikan lain.
neterror-file-not-found-moved = Periksa apakah berkas sudah dipindah, diganti namanya, atau dihapus.

neterror-access-denied = Berkas mungkin sudah dihapus, dipindahkan, atau hak akses yang ada mencegah akses terhadap berkas.

neterror-unknown-protocol = Anda mungkin perlu untuk menginstal perangkat lunak lain untuk membuka alamat ini.

neterror-redirect-loop = Masalah ini kadangkala disebabkan karena mematikan fungsi atau menolak menerima kuki.

neterror-unknown-socket-type-psm-installed = Pastikan sistem Anda telah terpasang Pengelola Keamanan Pribadi.
neterror-unknown-socket-type-server-config = Hal ini mungkin disebabkan konfigurasi server yang tidak standar.

neterror-not-cached-intro = Dokumen yang diminta tidak tersedia pada tembolok { -brand-short-name }.
neterror-not-cached-sensitive = Sebagai tindakan pencegahan keamanan, { -brand-short-name } tidak meminta ulang dokumen sensitif secara otomatis.
neterror-not-cached-try-again = Klik Coba Lagi untuk meminta ulang dokumen dari situs web.

neterror-net-offline = Tekan “Coba Lagi” untuk kembali ke mode daring dan memuat ulang lamannya.

neterror-proxy-resolve-failure-settings = Periksa pengaturan proksi, pastikan sudah benar.
neterror-proxy-resolve-failure-connection = Pastikan sambungan ke jaringan komputer Anda berjalan dengan baik.
neterror-proxy-resolve-failure-firewall = Apabila komputer atau jaringan Anda dilindungi firewall atau proksi, pastikan bahwa { -brand-short-name } diizinkan mengakses Web.

neterror-proxy-connect-failure-settings = Periksa pengaturan proksi, pastikan sudah benar.
neterror-proxy-connect-failure-contact-admin = Hubungi administrator jaringan Anda untuk memastikan server proksi sudah berjalan.

neterror-content-encoding-error = Mohon hubungi pemilik situs web mengenai masalah ini.

neterror-unsafe-content-type = Mohon hubungi pemilik situs web mengenai masalah ini.

neterror-nss-failure-not-verified = Laman yang ingin dibuka tidak dapat ditampilkan karena keaslian data yang diterima tidak bisa diverifikasi.
neterror-nss-failure-contact-website = Mohon hubungi pemilik situs web mengenai masalah ini.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } mendeteksi potensi ancaman keamanan dan tidak melanjutkan ke <b>{ $hostname }</b>. Jika Anda mengunjungi situs ini, penyerang bisa saja mencuri informasi seperti sandi, surel, atau rincian kartu kredit Anda.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } mendeteksi potensi ancaman keamanan dan tidak dapat melanjutkan ke <b>{ $hostname }</b> karena situs ini memerlukan sambungan aman.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } mendeteksi masalah dan tidak melanjutkan ke <b>{ $hostname }</b>. Situs web salah dikonfigurasi atau jam komputer Anda disetel ke waktu yang salah.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> sepertinya situs yang aman, tapi sambungan yang aman tidak terjalin. Masalah ini disebabkan oleh <b>{ $mitm }</b>, yang bisa berasal dari peranti lunak dalam komputer atau jaringan Anda.

neterror-corrupted-content-intro = Laman yang akan dibuka tidak dapat ditampilkan karena ada terdeteksi galat pada pengiriman data.
neterror-corrupted-content-contact-website = Mohon hubungi pemilik situs web mengenai masalah ini.

# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Info lebih lanjut: SSL_ERROR_UNSUPPORTED_VERSION

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> menggunakan teknologi keamanan yang sudah kedaluwarsa dan rentan diserang. Penyerang dapat dengan mudah mengungkapkan informasi yang Anda anggap aman. Administrator situs web perlu memperbaiki server terlebih dahulu sebelum Anda dapat mengunjungi situsnya.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Kode galat: NS_ERROR_NET_INADEQUATE_SECURITY

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Menurut komputer Anda waktu sekarang adalah { DATETIME($now, dateStyle: "medium") }, yang mencegah { -brand-short-name } tersambung dengan aman. Untuk mengunjungi <b>{ $hostname }</b>, perbarui jam komputer Anda di pengaturan sistem agar diatur ke tanggal, jam, dan zona waktu yang benar, lalu segarkan <b>{ $hostname }</b>.

neterror-network-protocol-error-intro = Laman yang ingin Anda lihat tidak dapat ditampilkan karena ada yang salah dalam protokol jaringan.
neterror-network-protocol-error-contact-website = Harap hubungi pemilik situs web untuk memberi tahu mereka tentang masalah ini.

certerror-expired-cert-second-para = Sepertinya sertifikat situs ini telah kedaluwarsa, yang mencegah { -brand-short-name } tersambung secara aman. Jika Anda mengunjungi situs ini, penyerang dapat mencoba mencuri informasi seperti kata sandi, surel, atau rincian kartu kredit Anda.
certerror-expired-cert-sts-second-para = Sepertinya sertifikat situs web telah kedaluwarsa, yang menghalangi { -brand-short-name } untuk menyambungkan dengan aman.

certerror-what-can-you-do-about-it-title = Apa yang bisa Anda lakukan mengenai masalah ini?

certerror-unknown-issuer-what-can-you-do-about-it-website = Masalahnya mungkin berasal dari situs webnya, dan tidak ada yang bisa Anda lakukan untuk mengatasinya.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Jika Anda berada di jaringan kantor atau menggunakan perangkat lunak antivirus, Anda bisa menghubungi tim dukungan untuk mendapatkan bantuan. Anda juga bisa memberi tahu administrator situs web tentang masalahnya.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Jam komputer Anda disetel ke { DATETIME($now, dateStyle: "medium") }. Pastikan waktu komputer Anda disetel ke tanggal, jam, dan zona waktu yang benar pada pengaturan sistem Anda, lalu segarkan <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Jika jam Anda telah disetel ke waktu yang benar, situs web mungkin salah dikonfigurasikan, dan tidak ada yang bisa Anda lakukan untuk mengatasi masalahnya. Anda bisa memberi tahu administrator situs web tentang masalahnya.

certerror-bad-cert-domain-what-can-you-do-about-it = Masalahnya sangat mungkin bersumber pada situs web, dan tidak ada yang bisa Anda lakukan untuk mengatasi masalahnya. Anda bisa memberi tahu administrator sistem tentang masalahnya.

certerror-mitm-what-can-you-do-about-it-antivirus = Jika perangkat lunak antivirus Anda menyertakan fitur pemindai koneksi terenkripsi (sering disebut “pemindaian web” atau “pemindaian https”), Anda dapat menonaktifkan fitur ini. Jika tidak berhasil, Anda dapat menghapus dan menginstal ulang perangkat lunak antivirus.
certerror-mitm-what-can-you-do-about-it-corporate = Jika Anda berada di jaringan perusahaan, Anda dapat menghubungi departemen TI Anda.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Jika Anda tidak akrab dengan <b>{ $mitm }</b>, bisa jadi ini sebuah serangan dan Anda sebaiknya tidak melanjutkan ke situs.

# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Jika Anda tidak akrab dengan <b>{ $mitm }</b>, bisa jadi ini sebuah serangan, dan tidak ada yang dapat Anda lakukan untuk mengakses situs.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> memiliki kebijakan keamanan yang disebut sebagai HTTP Strict Transport Security (HSTS), yang berarti { -brand-short-name } hanya bisa tersambung dengannya secara aman. Anda tidak bisa menambahkan pengecualian untuk mengunjungi situs.
