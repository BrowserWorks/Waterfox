# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Pengurus Sijil

certmgr-tab-mine =
    .label = Sijil Anda

certmgr-tab-people =
    .label = Hubungan

certmgr-tab-servers =
    .label = Pelayan

certmgr-tab-ca =
    .label = Autoriti

certmgr-mine = Anda memiliki sijil daripada organisasi ini yang mengenali anda
certmgr-people = Anda memiliki sijil fail yang mengenal pasti orang ini
certmgr-servers = Anda memiliki sijil fail yang mengenal pasti pelayan ini
certmgr-ca = Anda memiliki sijil fail yang mengenal pasti autoriti sijil ini

certmgr-detail-general-tab-title =
    .label = Umum
    .accesskey = u

certmgr-detail-pretty-print-tab-title =
    .label = Butiran
    .accesskey = B

certmgr-pending-label =
    .value = Sijil sedang disahkan...

certmgr-subject-label = Dikeluarkan Untuk

certmgr-issuer-label = Dikeluarkan Oleh

certmgr-period-of-validity = Tempoh Sah

certmgr-fingerprints = Cap jari

certmgr-cert-detail =
    .title = Perincian Sijil
    .buttonlabelaccept = Tutup
    .buttonaccesskeyaccept = T

certmgr-cert-detail-commonname = Nama Biasa (CN)

certmgr-cert-detail-org = Organisasi (0)

certmgr-cert-detail-orgunit = Unit Organisasi (OU)

certmgr-cert-detail-serial-number = Nombor Siri

certmgr-cert-detail-sha-256-fingerprint = Cap jari SHA-256

certmgr-cert-detail-sha-1-fingerprint = Cap jari SHA1

certmgr-edit-ca-cert =
    .title = Edit tetapan sijil CA dipercaya
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Edit tetapan dipercaya:

certmgr-edit-cert-trust-ssl =
    .label = Sijil ini boleh mengenal pasti identiti laman web.

certmgr-edit-cert-trust-email =
    .label = Sijil ini boleh mengenal pasti pengguna e-mel.

certmgr-delete-cert =
    .title = Buang Sijil
    .style = width: 48em; height: 24em;

certmgr-cert-name =
    .label = Nama Sijil

certmgr-cert-server =
    .label = Pelayan

certmgr-override-lifetime =
    .label = Seumur hidup

certmgr-token-name =
    .label = Peranti Sekuriti

certmgr-begins-on = Bermula Pada

certmgr-begins-label =
    .label = Bermula Pada

certmgr-expires-on = Luput Pada

certmgr-expires-label =
    .label = Luput Pada

certmgr-email =
    .label = Alamat E-Mel

certmgr-serial =
    .label = Nombor Siri

certmgr-view =
    .label = Papar...
    .accesskey = P

certmgr-edit =
    .label = Mengubahkan kepercayaan...
    .accesskey = E

certmgr-export =
    .label = Eksport…
    .accesskey = r

certmgr-delete =
    .label = Buang…
    .accesskey = B

certmgr-delete-builtin =
    .label = Buang atau Tidak Percaya…
    .accesskey = B

certmgr-backup =
    .label = Sandaran…
    .accesskey = S

certmgr-backup-all =
    .label = Backup Semua
    .accesskey = k

certmgr-restore =
    .label = Import…
    .accesskey = m

certmgr-details =
    .value = Sijil Bidang
    .accesskey = S

certmgr-fields =
    .value = Bidang Nilai
    .accesskey = n

certmgr-hierarchy =
    .value = Hierarki Sijil
    .accesskey = H

certmgr-add-exception =
    .label = Tambah Pengecualian…
    .accesskey = T

exception-mgr =
    .title = Tambah Pengecualian Keselamatan

exception-mgr-extra-button =
    .label = Sahkan Pengecualian Keselamatan
    .accesskey = C

exception-mgr-supplemental-warning = Bank, kedai dan laman awam yang sah tidak akan meminta anda untuk melakukan ini.

exception-mgr-cert-location-url =
    .value = Lokasi:

exception-mgr-cert-location-download =
    .label = Dapatkan Sijil
    .accesskey = D

exception-mgr-cert-status-view-cert =
    .label = Papar...
    .accesskey = P

exception-mgr-permanent =
    .label = Simpan pengecualian ini secara tetap
    .accesskey = P

pk11-bad-password = Kata laluan yang dimasukkan tidak betul.
pkcs12-decode-err = Gagal menyahkod fail. Sama ada bukan dalam format PKCS #12, telah rosak, atau kata laluan yang anda masukkan tidak betul.
pkcs12-unknown-err-restore = Gagal memulihkan fail PKCS #12 atas sebab yang tidak diketahui.
pkcs12-unknown-err-backup = Gagal mencipta fail sandaran PKCS #12 untuk sebab tidak diketahui.
pkcs12-unknown-err = Operasi PKCS #12 gagal untuk tindak balas tidak diketahui.
pkcs12-info-no-smartcard-backup = Adalah tidak mustahil untuk membuat sandaran sijil daripada perkakasan peranti sekuriti seperti kad pintar.
pkcs12-dup-data = Sijil dan kunci peribadi sedia wujud pada peranti sekuriti.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nama Fail untuk Sandaran
file-browse-pkcs12-spec = Fail PKCS12
choose-p12-restore-file-dialog = Sijil Fail untuk Diimport

## Import certificate(s) file dialog

file-browse-certificate-spec = Fail Sijil
import-ca-certs-prompt = Pilih fail yang mengandungi Sijil CA yang mahu diimport
import-email-cert-prompt = Pilih Fail yang mengandungi sijil E-mel pengguna yang mahu diimport

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Sijil "{ $certName }" mewakili Autoriti Sijil.

## For Deleting Certificates

delete-user-cert-title =
    .title = Buang Sijil anda
delete-user-cert-confirm = Adakah anda pasti mahu menghapuskan sijil ini?
delete-user-cert-impact = Jika anda hapus salah satu daripada sijil anda sendiri, anda tidak lagi dapat menggunakannya untuk memperkenalkan diri.


delete-ssl-cert-title =
    .title = Buang Pengecualian Sijil Pelayan
delete-ssl-cert-confirm = Adakah anda pasti mahu menghapuskan pengecualian daripada pelayan ini?
delete-ssl-cert-impact = Jika anda menghapuskan pengecualian pelayan, anda perlu perbaharui pemeriksaan sekuriti untuk pelayar dan perlu menggunakan sijil yang diiktiraf.

delete-ca-cert-title =
    .title = Buang atau Tidak Percaya Sijil CA
delete-ca-cert-confirm = Anda meminta untuk menghapuskan sijil CA berikut. Untuk sijil yang terbina-dalam semua kepercayaan yang disingkirkan, juga menerima akibat yang sama. Anda pasti mahu menghapuskan atau tidak mempercayainya?
delete-ca-cert-impact = Jika anda menghapuskan atau tidak mempercayai sijil autoriti pensijilan (CA), aplikasi ini tidak lagi percaya sebarang sijil yang diterbitkan oleh CA berkenaaan.


delete-email-cert-title =
    .title = Buang Sijil E-mel
delete-email-cert-confirm = Adakah anda pasti mahu menghapuskan sijil e-mel pengguna berikut?
delete-email-cert-impact = Jika anda menghapuskan sijil e-mel seseorang pengguna, anda tidak dapat menghantar e-mel yang dienkripsi kepada pengguna tersebut.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Sijil dengan nombor siri: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Certificate Viewer: “{ $certName }”

not-present =
    .value = <Bukan Sebahagian Dari Sijil>

# Cert verification
cert-verified = Sijil telah disahkan untuk pengguna berikut:

# Add usage
verify-ssl-client =
    .value = SSL Sijil Klien

verify-ssl-server =
    .value = Sijil Pelayan SSL

verify-ssl-ca =
    .value = SSL Autoriti Sijil

verify-email-signer =
    .value = E-mel Sijil Penandatangan

verify-email-recip =
    .value = E-mel Sijil Penerima

# Cert verification
cert-not-verified-cert-revoked = Tidak dapat mengesahkan sijil ini kerana ianya telah ditarik balik.
cert-not-verified-cert-expired = Tidak dapat mengesahkan sijil ini kerana ianya telah luput.
cert-not-verified-cert-not-trusted = Tidak dapat mengesahkan sijil ini kerana ianya tidak dipercayai.
cert-not-verified-issuer-not-trusted = Tidak dapat mengesahkan sijil ini kerana pengeluar tidak dipercayai.
cert-not-verified-issuer-unknown = Tidak dapat mengesahkan sijil ini kerana ianya pengeluar tidak diketahui.
cert-not-verified-ca-invalid = Tidak dapat mengesahkan sijil ini kerana sijil CA tidak sah.
cert-not-verified_algorithm-disabled = Tidak dapat mengesahkan sijil ini kerana ditandatangi menggunakan algoritma tanda tangan yang telah dinyahdayakan kerana algoritma itu tidak selamat.
cert-not-verified-unknown = Tidak dapat mengesahkan siil ini kerana sebab yang tidak diketahui.

## Add Security Exception dialog

add-exception-branded-warning = Anda bakal menindan cara { -brand-short-name } mengenal pasti laman ini.
add-exception-invalid-header = Laman ini cuba untuk memperkenalkan diri sendiri dengan maklumat yang tidak sah.
add-exception-domain-mismatch-short = Laman Salah
add-exception-domain-mismatch-long = Sijil ini kepunyaan laman lain, yang mungkin bermakna bahawa ada seseorang yang cuba menyamar sebagai laman ini.
add-exception-expired-short = Maklumat yang lapuk
add-exception-expired-long = Sijil tidak sah pada masa ini. Mungkin telah dicuri atau hilang, dan mungkin digunakan oleh seseorang untuk menyamar laman ini.
add-exception-unverified-or-bad-signature-short = Identiti Tidak Diketahui
add-exception-unverified-or-bad-signature-long = Sijil ini tidak boleh dipercayai, kerana ia telah dikenalpasti oleh autoriti berdaftar menggunakan tanda tangan yang selamat.
add-exception-valid-short = Sijil sah
add-exception-valid-long = Laman ini menyediakan pengenalan yang sah. Tiada keperluan untuk menambahkan pengecualian.
add-exception-checking-short = Semakan Maklumat
add-exception-checking-long = Cubaan mengenal pasti laman ini…
add-exception-no-cert-short = Tiada Maklumat wujud
add-exception-no-cert-long = Tidak dapat mendapatkan status identifikasi laman ini.

## Certificate export "Save as" and error dialogs

save-cert-as = Simpan Sijil Kepada Fail
cert-format-base64 = X.509 Certificate (PEM)
cert-format-base64-chain = X.509 Sijil dengan rantaian (PEM)
cert-format-der = X.509 Sijil (DER)
cert-format-pkcs7 = X.509 Sijil (PKCS#7)
cert-format-pkcs7-chain = X.509 Sijil dengan  (PKCS#7)
write-file-failure = Ralat File
