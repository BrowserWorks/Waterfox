# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } menggunakan sertifikat keamanan yang tidak valid.

cert-error-mitm-intro = Situs web membuktikan identitas mereka melalui sertifikat, yang diterbitkan oleh pewenang sertifikat.

cert-error-mitm-mozilla = { -brand-short-name } disokong oleh Waterfox yang bersifat nirlaba, yang mengelola penyimpanan otoritas sertifikat (CA/Certificate Authority) yang sepenuhnya terbuka. Penyimpanan CA membantu memastikan bahwa otoritas sertifikat mengikuti penerapan terbaik demi keamanan pengguna.

cert-error-mitm-connection = { -brand-short-name } menggunakan penyimpanan CA Waterfox untuk memverifikasi keamanan koneksi yang digunakan, alih-alih sertifikat yang diberikan oleh sistem operasi pengguna. Jadi, jika sebuah program antivirus maupun jaringan mencegat koneksi dengan sertifikat keamanan yang dikeluarkan oleh CA yang tidak ada dalam penyimpanan CA Waterfox, koneksi tersebut dianggap tidak aman.

cert-error-trust-unknown-issuer-intro = Ada pihak yang mencoba menyamar sebagai situs ini dan sebaiknya tidak Anda lanjutkan.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Situs web membuktikan identitas mereka menggunakan sertifikat. { -brand-short-name } tidak mempercayai { $hostname } karena penerbit sertifikatnya tidak dikenali, sertifikatnya ditandatangani sendiri, atau server tidak mengirimkan sertifikat perantara yang benar.

cert-error-trust-cert-invalid = Sertifikat tidak dapat dipercaya karena dikeluarkan oleh sertifikat CA yang tidak valid.

cert-error-trust-untrusted-issuer = Sertifikat tidak dapat dipercaya karena sertifikat penerbit tidak dipercaya.

cert-error-trust-signature-algorithm-disabled = Sertifikat tidak dapat dipercaya karena ditandatangani menggunakan algoritma tanda tangan yang dinonaktifkan dengan alasan algoritmanya tidak aman.

cert-error-trust-expired-issuer = Sertifikat tidak dapat dipercaya karena sertifikat penerbit telah kedaluwarsa.

cert-error-trust-self-signed = Sertifikat tidak dapat dipercaya karena hanya ditandatangani sendiri.

cert-error-trust-symantec = Sertifikat yang diterbitkan oleh GeoTrust, RapidSSL, Symantec, Thawte, dan VeriSign tidak lagi dianggap aman karena dahulu pewenang sertifikat tersebut gagal mematuhi praktik keamanan.

cert-error-untrusted-default = Sertifikat tidak didapat dari sumber yang terpercaya.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Situs web membuktikan identitas mereka melalui sertifikat. { -brand-short-name } tidak memercayai situs ini karena menggunakan sertifikat yang tidak valid untuk { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Situs web membuktikan identitas mereka melalui sertifikat. { -brand-short-name } tidak memercayai situs ini karena menggunakan sertifikat yang tidak valid untuk { $hostname }. Sertifikat hanya valid untuk <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Situs web membuktikan identitas mereka melalui sertifikat. { -brand-short-name } tidak memercayai situs ini karena menggunakan sertifikat yang tidak valid untuk { $hostname }. Sertifikat hanya valid untuk { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Situs web membuktikan identitas mereka melalui sertifikat. { -brand-short-name } tidak memercayai situs ini karena menggunakan sertifikat yang tidak valid untuk { $hostname }. Sertifikat ini hanya valid untuk nama-nama berikut: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Situs web membuktikan identitas mereka melalui sertifikat yang berlaku dalam rentang waktu tertentu. Sertifikat untuk { $hostname } akan berakhir pada { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Situs web membuktikan identitas mereka melalui sertifikat yang berlaku dalam rentang waktu tertentu. Sertifikat untuk { $hostname } tidak akan berlaku lagi pada { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Kode kesalahan: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Situs web membuktikan identitas mereka melalui sertifikat, yang diterbitkan oleh pewenang otoritas. Sebagian besar peramban tidak lagi memercayai sertifikat yang diterbitkan oleh GeoTrust, RapidSSL, Symantec, Thawte, dan VeriSign. { $hostname } menggunakan sertifikat dari salah satu pewenang ini sehingga identitas situs web tidak dapat dibuktikan.

cert-error-symantec-distrust-admin = Anda mungkin dapat memberitahu administrator situs web tentang masalah ini.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Rangkaian sertifikat:

open-in-new-window-for-csp-or-xfo-error = Buka Situs di Jendela Baru

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Untuk melindungi keamanan Anda, { $hostname } tidak akan mengizinkan { -brand-short-name } untuk menampilkan laman jika situs lain telah menyematkannya. Untuk melihat laman ini, Anda harus membukanya di jendela baru.

## Messages used for certificate error titles

connectionFailure-title = Tidak dapat tersambung
deniedPortAccess-title = Penggunaan alamat ini dibatasi
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Kami kesulitan menemukan situsnya.
fileNotFound-title = Berkas tidak ditemukan
fileAccessDenied-title = Akses terhadap berkas ditolak
generic-title = Ups.
captivePortal-title = Masuk ke jaringan
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Alamat tersebut tampaknya tidak benar.
netInterrupt-title = Sambungan terputus
notCached-title = Dokumen Kedaluwarsa
netOffline-title = Mode luring
contentEncodingError-title = Kesalahan Pengodean Isi (Content Encoding)
unsafeContentType-title = Jenis Berkas Tidak Aman
netReset-title = Sambungan diputus
netTimeout-title = Tenggang waktu tersambung habis
unknownProtocolFound-title = Alamat tidak dipahami
proxyConnectFailure-title = Server proksi menolak sambungan
proxyResolveFailure-title = Tidak dapat menemukan server proksi
redirectLoop-title = Laman tidak teralihkan dengan benar
unknownSocketType-title = Jawaban yang tidak diharapkan dari server
nssFailure2-title = Sambungan Aman Gagal
csp-xfo-error-title = { -brand-short-name } Tidak Dapat Membuka Laman Ini
corruptedContentError-title = Galat Konten Rusak
remoteXUL-title = XUL Jarak Jauh
sslv3Used-title = Gagal Tersambung dengan Aman
inadequateSecurityError-title = Sambungan Anda tidak aman
blockedByPolicy-title = Laman Diblokir
clockSkewError-title = Jam komputer Anda salah
networkProtocolError-title = Protokol Jaringan Bermasalah
nssBadCert-title = Peringatan: Potensi Risiko Keamanan Menghadang
nssBadCert-sts-title = Tidak Tersambung: Dugaan Masalah Keamanan
certerror-mitm-title = Perangkat Lunak Menghalangi { -brand-short-name } untuk Tersambung dengan Aman ke Situs Ini
