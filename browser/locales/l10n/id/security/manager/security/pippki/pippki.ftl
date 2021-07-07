# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Ukuran kualitas sandi

## Change Password dialog

change-password-window =
    .title = Ubah Sandi Utama
change-device-password-window =
    .title = Ubah Sandi
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Perangkat Keamanan: { $tokenName }
change-password-old = Sandi lama:
change-password-new = Sandi baru:
change-password-reenter = Sandi baru (ulangi):

## Reset Password dialog

reset-password-window =
    .title = Setel Ulang Sandi Utama
    .style = width: 40em
pippki-failed-pw-change = Gagal mengubah sandi.
pippki-incorrect-pw = Anda tidak memasukkan sandi dengan benar. Silakan coba lagi.
pippki-pw-change-ok = Sandi berhasil diubah.
pippki-pw-empty-warning = Sandi dan kunci pribadi yang Anda simpan akan tidak akan dilindungi.
pippki-pw-erased-ok = Anda telah menghapus sandi Anda. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Peringatan! Anda memutuskan untuk tidak menggunakan sandi. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Saat ini Anda berada pada mode FIPS. FIPS membutuhkan sandi.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Setel Ulang Sandi Utama
    .style = width: 40em
reset-password-button-label =
    .label = Setel Ulang
reset-password-text = Jika Anda menyetel ulang sandi utama, semua sandi web dan email, data form, sertifikat pribadi, dan kunci pribadi akan hilang. Yakin akan menyetel ulang sandi utama?
reset-primary-password-text = Jika Anda menyetel ulang sandi utama, semua sandi web dan email, data form, sertifikat pribadi, dan kunci pribadi akan hilang. Yakin akan menyetel ulang Sandi Utama?
pippki-reset-password-confirmation-title = Setel Ulang Sandi Utama
pippki-reset-password-confirmation-message = Sandi Utama telah disetel ulang.

## Downloading cert dialog

download-cert-window =
    .title = Mengunduh Sertifikat
    .style = width: 46em
download-cert-message = Anda diminta untuk mempercayai Otoritas Sertifikat (CA) yang baru.
download-cert-trust-ssl =
    .label = Percayai CA ini untuk mengidentifikasi situs web.
download-cert-trust-email =
    .label = Percayai CA ini untuk mengidentifikasi pengguna email.
download-cert-message-desc = Sebelum mempercayai CA ini untuk kegunaan apa pun, sebaiknya Anda memeriksa sertifikat ini serta kebijakan dan prosedurnya jika ada.
download-cert-view-cert =
    .label = Tampilkan
download-cert-view-text = Periksa sertifikat CA

## Client Authorization Ask dialog

client-auth-window =
    .title = Permintaan Identifikasi Pengguna
client-auth-site-description = Situs telah meminta identifikasi Anda dengan sertifikat:
client-auth-choose-cert = Pilih sertifikat untuk mewakili proses identifikasi:
client-auth-cert-details = Detail sertifikat yang dipilih:

## Set password (p12) dialog

set-password-window =
    .title = Masukkan Sandi Cadangan Sertifikat
set-password-message = Sandi cadangan sertifikat yang dimasukkan melindungi berkas cadangan yang akan dibuat. Anda harus memasukkan sandi untuk meneruskan membuat cadangan.
set-password-backup-pw =
    .value = Sandi cadangan sertifikat:
set-password-repeat-backup-pw =
    .value = Sandi cadangan sertifikat (ulangi):
set-password-reminder = Penting: Jika Anda lupa sandi cadangan sertifikat, Anda tidak akan dapat mengembalikan cadangan ini nantinya. Mohon disimpan di lokasi yang aman.

## Protected Auth dialog

protected-auth-window =
    .title = Autentikasi Token Terproteksi
protected-auth-msg = Silakan token berikut diautentikasi. Metode autentikasi bergantung pada tipe token Anda.
protected-auth-token = Token:
