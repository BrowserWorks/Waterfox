# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Ukuran kualitas sandi

## Change Password dialog

change-device-password-window =
    .title = Ubah Sandi
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Perangkat Keamanan: { $tokenName }
change-password-old = Sandi lama:
change-password-new = Sandi baru:
change-password-reenter = Sandi baru (ulangi):
pippki-failed-pw-change = Gagal mengubah sandi.
pippki-incorrect-pw = Anda tidak memasukkan sandi dengan benar. Silakan coba lagi.
pippki-pw-change-ok = Sandi berhasil diubah.
pippki-pw-empty-warning = Sandi dan kunci pribadi yang Anda simpan akan tidak akan dilindungi.
pippki-pw-erased-ok = Anda telah menghapus sandi Anda. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Peringatan! Anda memutuskan untuk tidak menggunakan sandi. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Saat ini Anda berada pada mode FIPS. FIPS membutuhkan sandi.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Setel Ulang Sandi Utama
    .style = min-width: 40em
reset-password-button-label =
    .label = Setel Ulang
reset-primary-password-text = Jika Anda menyetel ulang sandi utama, semua sandi web dan email, data form, sertifikat pribadi, dan kunci pribadi akan hilang. Yakin akan menyetel ulang Sandi Utama?
pippki-reset-password-confirmation-title = Setel Ulang Sandi Utama
pippki-reset-password-confirmation-message = Sandi Utama telah disetel ulang.

## Downloading cert dialog

download-cert-window2 =
    .title = Mengunduh Sertifikat
    .style = min-width: 46em
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


## Client Authentication Ask dialog

client-auth-window =
    .title = Permintaan Identifikasi Pengguna
client-auth-site-description = Situs telah meminta identifikasi Anda dengan sertifikat:
client-auth-choose-cert = Pilih sertifikat untuk mewakili proses identifikasi:
client-auth-cert-details = Detail sertifikat yang dipilih:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Diterbitkan untuk: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Nomor serial: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Valid dari { $notBefore } hingga { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Penggunaan Kunci: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = Alamat surel: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Diterbitkan oleh: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Disimpan di: { $storedOn }
client-auth-cert-remember-box =
    .label = Ingat pilihan ini

## Set password (p12) dialog

set-password-window =
    .title = Masukkan Sandi Cadangan Sertifikat
set-password-message = Sandi cadangan sertifikat yang dimasukkan melindungi berkas cadangan yang akan dibuat. Anda harus memasukkan sandi untuk meneruskan membuat cadangan.
set-password-backup-pw =
    .value = Sandi cadangan sertifikat:
set-password-repeat-backup-pw =
    .value = Sandi cadangan sertifikat (ulangi):
set-password-reminder = Penting: Jika Anda lupa sandi cadangan sertifikat, Anda tidak akan dapat mengembalikan cadangan ini nantinya. Mohon disimpan di lokasi yang aman.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Autentikasikan dengan token “{ $tokenName }”. Cara melakukannya bergantung pada jenis token (misalnya, menggunakan pembaca sidik jari atau memasukkan kode dengan papan tombol).
