# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Pengelola Sertifikat

certmgr-tab-mine =
    .label = Sertifikat Anda

certmgr-tab-remembered =
    .label = Keputusan Otentikasi

certmgr-tab-people =
    .label = Perseorangan

certmgr-tab-servers =
    .label = Server

certmgr-tab-ca =
    .label = Otoritas

certmgr-mine = Anda memiliki sertifikat dari organisasi berikut ini yang mengenali Anda
certmgr-remembered = Sertifikat ini digunakan untuk mengidentifikasi Anda ke situs web.
certmgr-people = Anda memiliki sertifikat di berkas yang mengenali orang ini
certmgr-servers = Anda memiliki sertifikat pada berkas yang bisa mengidentifikasi server berikut
certmgr-ca = Anda memiliki sertifikat pada berkas yang mengidentifikasi otoritas sertifikat ini

certmgr-detail-general-tab-title =
    .label = Umum
    .accesskey = U

certmgr-detail-pretty-print-tab-title =
    .label = Detail
    .accesskey = D

certmgr-pending-label =
    .value = Sedang memverifikasi sertifikat…

certmgr-subject-label = Diterbitkan untuk

certmgr-issuer-label = Diterbitkan Oleh

certmgr-period-of-validity = Periode Kevalidan

certmgr-fingerprints = Sidik Jari

certmgr-cert-detail =
    .title = Detail Sertifikat
    .buttonlabelaccept = Tutup
    .buttonaccesskeyaccept = T

certmgr-cert-detail-commonname = Common Name (CN)

certmgr-cert-detail-org = Organisasi (O)

certmgr-cert-detail-orgunit = Unit Organisasi (OU)

certmgr-cert-detail-serial-number = Nomor Seri

certmgr-cert-detail-sha-256-fingerprint = Sidik jari SHA-256

certmgr-cert-detail-sha-1-fingerprint = Sidik jari SHA1

certmgr-edit-ca-cert =
    .title = Ubah pengaturan kepercayaan sertifikat CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Ubah pengaturan kepercayaan:

certmgr-edit-cert-trust-ssl =
    .label = Sertifikat ini dapat mengidentifikasi situs web.

certmgr-edit-cert-trust-email =
    .label = Sertifikat ini dapat mengidentifikasi pengguna email.

certmgr-delete-cert =
    .title = Hapus Sertifikat
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Host

certmgr-cert-name =
    .label = Nama Sertifikat

certmgr-cert-server =
    .label = Server

certmgr-override-lifetime =
    .label = Umur

certmgr-token-name =
    .label = Perangkat Keamanan

certmgr-begins-on = Mulai Sejak

certmgr-begins-label =
    .label = Mulai Sejak

certmgr-expires-on = Kedaluwarsa Pada

certmgr-expires-label =
    .label = Kedaluwarsa Pada

certmgr-email =
    .label = Alamat Surel

certmgr-serial =
    .label = Nomor Seri

certmgr-view =
    .label = Tampilkan…
    .accesskey = T

certmgr-edit =
    .label = Ubah Kepercayaan…
    .accesskey = K

certmgr-export =
    .label = Ekspor…
    .accesskey = k

certmgr-delete =
    .label = Hapus…
    .accesskey = H

certmgr-delete-builtin =
    .label = Hapus atau Tidak Lagi Percayai…
    .accesskey = L

certmgr-backup =
    .label = Buat Cadangan…
    .accesskey = C

certmgr-backup-all =
    .label = Buat Cadangan Keseluruhan…
    .accesskey = u

certmgr-restore =
    .label = Impor…
    .accesskey = I

certmgr-details =
    .value = Field Sertifikat
    .accesskey = F

certmgr-fields =
    .value = Nilai Field
    .accesskey = N

certmgr-hierarchy =
    .value = Hierarki Sertifikat
    .accesskey = H

certmgr-add-exception =
    .label = Tambah Pengecualian…
    .accesskey = P

exception-mgr =
    .title = Tambahkan Pengecualian Keamanan

exception-mgr-extra-button =
    .label = Konfirmasi Pengecualian Keamanan
    .accesskey = K

exception-mgr-supplemental-warning = Bank, toko, atau situs publik yang sah tidak akan menanyakan hal berikut kepada Anda.

exception-mgr-cert-location-url =
    .value = Lokasi:

exception-mgr-cert-location-download =
    .label = Unduh Sertifikat
    .accesskey = U

exception-mgr-cert-status-view-cert =
    .label = Tampilkan…
    .accesskey = T

exception-mgr-permanent =
    .label = Simpan pengecualian secara permanen
    .accesskey = m

pk11-bad-password = Sandi yang dimasukkan salah.
pkcs12-decode-err = Gagal mendekode berkas. Format PKCS #12 salah, terkorupsi, atau sandi yang dimasukkan salah.
pkcs12-unknown-err-restore = Gagal memulihkan berkas PKCS #12 karena alasan yang tidak diketahui.
pkcs12-unknown-err-backup = Gagal membuat berkas cadangan PKCS #12 karena alasan yang tidak diketahui.
pkcs12-unknown-err = Operasi PKCS #12 gagal karena alasan yang tidak diketahui.
pkcs12-info-no-smartcard-backup = Tidak dimungkinkan untuk membuat cadangan sertifikat dari perangkat keras peralatan keamanan seperti halnya smart card.
pkcs12-dup-data = Sertifikat dan kunci pribadi telah ada pada peralatan keamanan.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nama Berkas untuk Cadangan
file-browse-pkcs12-spec = Berkas PKCS12
choose-p12-restore-file-dialog = Berkas Sertifikat untuk diimpor

## Import certificate(s) file dialog

file-browse-certificate-spec = Berkas Sertifikat
import-ca-certs-prompt = Pilih Berkas yang mengandung sertifikat CA untuk diimpor:
import-email-cert-prompt = Pilih Berkas yang mengandung sertifikat dalam email untuk diimpor:

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Sertifikat "{ $certName }" mewakili Otoritas Sertifikat.

## For Deleting Certificates

delete-user-cert-title =
    .title = Hapus Sertifikat Anda
delete-user-cert-confirm = Yakin untuk menghapus sertifikat berikut?
delete-user-cert-impact = Jika Anda menghapus salah satu sertifikat Anda, Anda tidak akan dapat menggunakannya lagi untuk memastikan identitas Anda.


delete-ssl-cert-title =
    .title = Hapus Pengecualian untuk Sertifikat Server
delete-ssl-cert-confirm = Yakin akan menghapus pengecualian ini?
delete-ssl-cert-impact = Jika server dihapus dari pengecualian, Anda memulihkan pemeriksaan yang biasanya dilakukan untuk server tersebut dan mengharuskan server tersebut untuk menggunakan sertifikat yang valid.

delete-ca-cert-title =
    .title = Hapus atau Tidak Lagi Mempercayai Sertifikat CA
delete-ca-cert-confirm = Anda telah meminta untuk menghapus sertifikat CA ini. Untuk sertifikat bawaan, semua kepercayaan akan dihapus yang efeknya sama. Yakin ingin menghapus atau tidak lagi mempercayai sertifikat ini?
delete-ca-cert-impact = Jika Anda menghapus atau tidak lagi mempercayai sertifikat milik otoritas sertifikat (CA), aplikasi ini tidak akan lagi mempercayai sertifikat yang diterbitkan CA tersebut.


delete-email-cert-title =
    .title = Hapus Sertifikat Surel
delete-email-cert-confirm = Yakin ingin menghapus sertifikat email perorangan ini?
delete-email-cert-impact = Jika Anda menghapus sertifikat email seseorang, Anda tidak akan bisa lagi mengirim email terenkripsi kepada orang tersebut.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Sertifikat dengan nomor seri: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Penampil Sertifikat: “{ $certName }”

not-present =
    .value = <Bukan Bagian dari Sertifikat>

# Cert verification
cert-verified = Sertifikat ini telah diperiksa untuk penggunaan berikut:

# Add usage
verify-ssl-client =
    .value = Sertifikat SSL Klien

verify-ssl-server =
    .value = Sertifikat SSL Server

verify-ssl-ca =
    .value = Otoritas Sertifikat SSL

verify-email-signer =
    .value = Yang Mengesahkan Sertifikat Email

verify-email-recip =
    .value = Penerima Sertifikat Email

# Cert verification
cert-not-verified-cert-revoked = Tidak dapat memeriksa sertifikat ini karena telah dicabut.
cert-not-verified-cert-expired = Tidak dapat memeriksa sertifikat ini karena telah kedaluwarsa.
cert-not-verified-cert-not-trusted = Tidak dapat memeriksa sertifikat ini karena tidak dipercaya.
cert-not-verified-issuer-not-trusted = Tidak dapat memeriksa sertifikat ini karena penerbit tidak dipercaya.
cert-not-verified-issuer-unknown = Tidak dapat memeriksa sertifikat ini karena penerbit tidak dikenali.
cert-not-verified-ca-invalid = Tidak dapat memeriksa sertifikat karena sertifikat CA tidak sah.
cert-not-verified_algorithm-disabled = Tidak dapat memeriksa sertifikat ini karena ditandatangani menggunakan algoritma tanda tangan yang dinonaktifkan dengan alasan algoritmanya tidak aman.
cert-not-verified-unknown = Tidak dapat memeriksa sertifikat ini karena alasan yang tidak diketahui.

## Add Security Exception dialog

add-exception-branded-warning = Anda akan membuat pengaturan khusus yang berbeda dengan pengaturan bawaan { -brand-short-name } untuk mengidentifikasi situs ini.
add-exception-invalid-header = Situs ini mencoba mengidentifikasi dirinya sendiri dengan informasi yang tidak valid.
add-exception-domain-mismatch-short = Situs Salah
add-exception-domain-mismatch-long = Sertifikat dimiliki oleh situs lain yang berbeda, yang mengindikasikan bahwa ada pihak yang menyamar sebagai situs ini.
add-exception-expired-short = Informasi yang Kuno
add-exception-expired-long = Sertifikat saat ini tidak valid. Sertifikat ini mungkin telah dicuri atau hilang, dan dapat digunakan oleh pihak tertentu untuk menyamar sebagai situs ini.
add-exception-unverified-or-bad-signature-short = Identitas Tidak Dikenali
add-exception-unverified-or-bad-signature-long = Sertifikat tidak dipercaya karena tidak diverifikasi sebagai diterbitkan oleh otoritas yang dipercaya menggunakan tanda tangan yang aman.
add-exception-valid-short = Sertifikat Valid
add-exception-valid-long = Situs ini menyediakan identifikasi yang valid dan terverifikasi. Tidak perlu dimasukkan ke dalam pengecualian.
add-exception-checking-short = Memeriksa Informasi
add-exception-checking-long = Mencoba mengidentifikasi situs ini…
add-exception-no-cert-short = Tidak ada informasi tersedia
add-exception-no-cert-long = Gagal mendapatkan status identifikasi situs ini.

## Certificate export "Save as" and error dialogs

save-cert-as = Simpan Sertifikat menjadi Berkas
cert-format-base64 = Sertifikat X.509 (PEM)
cert-format-base64-chain = Sertifikat berantai X.509 (PEM)
cert-format-der = Sertifikat X.509 (DER)
cert-format-pkcs7 = Sertifikat X.509 (PKCS#7)
cert-format-pkcs7-chain = Sertifikat X.509 dengan rantai (PKCS#7)
write-file-failure = Kesalahan Berkas
