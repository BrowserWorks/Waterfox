# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S

#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Tampilkan Keamanan Pesan (⌃ ⌘ { message-header-show-security-info-key })
           *[other] Tampilkan Keamanan Pesan (Ctrl+Alt+{ message-header-show-security-info-key })
        }

openpgp-view-signer-key =
    .label = Lihat kunci penanda tangan
openpgp-view-your-encryption-key =
    .label = Lihat kunci dekripsi Anda
openpgp-openpgp = OpenPGP

openpgp-no-sig = Tidak Ada Tanda Tangan Digital
openpgp-uncertain-sig = Tanda Tangan Digital Tidak Pasti
openpgp-invalid-sig = Tanda Tangan Digital Tidak Valid
openpgp-good-sig = Tanda Tangan Digital yang Baik

openpgp-sig-uncertain-no-key = Pesan ini berisi tanda tangan digital, tetapi tidak pasti apakah sudah benar. Untuk memverifikasi tanda tangan, Anda perlu mendapatkan salinan kunci publik pengirim.
openpgp-sig-uncertain-uid-mismatch = Pesan ini berisi tanda tangan digital, tetapi terdeteksi ketidakcocokan. Pesan tersebut dikirim dari alamat email yang tidak cocok dengan kunci publik penanda tangan.
openpgp-sig-uncertain-not-accepted = Pesan ini berisi tanda tangan digital, tetapi Anda belum memutuskan apakah kunci penanda tangan dapat Anda terima.
openpgp-sig-invalid-rejected = Pesan ini berisi tanda tangan digital, tetapi Anda sebelumnya telah memutuskan untuk menolak kunci penanda tangan.
openpgp-sig-invalid-technical-problem = Pesan ini berisi tanda tangan digital, tetapi kesalahan teknis terdeteksi. Bisa jadi pesan tersebut telah rusak, atau pesan tersebut telah diubah oleh orang lain.
openpgp-sig-valid-unverified = Pesan ini menyertakan tanda tangan digital yang valid dari kunci yang sudah Anda terima. Namun, Anda belum memverifikasi bahwa kunci tersebut benar-benar dimiliki oleh pengirim.
openpgp-sig-valid-verified = Pesan ini menyertakan tanda tangan digital yang valid dari kunci terverifikasi.
openpgp-sig-valid-own-key = Pesan ini menyertakan tanda tangan digital yang valid dari kunci pribadi Anda.

openpgp-sig-key-id = ID kunci penanda tangan: { $key }
openpgp-sig-key-id-with-subkey-id = ID kunci penanda tangan: { $key } (ID sub kunci: { $subkey })

openpgp-enc-key-id = ID kunci dekripsi Anda: { $key }
openpgp-enc-key-with-subkey-id = ID kunci dekripsi Anda: { $key } (ID sub kunci: { $subkey })

openpgp-unknown-key-id = Kunci tak dikenal

openpgp-other-enc-additional-key-ids = Selain itu, pesan tersebut dienkripsi ke pemilik kunci berikut:
openpgp-other-enc-all-key-ids = Pesan tersebut dienkripsi ke pemilik kunci berikut:

openpgp-message-header-encrypted-ok-icon =
    .alt = Dekripsi berhasil
openpgp-message-header-encrypted-notok-icon =
    .alt = Dekripsi gagal

openpgp-message-header-signed-ok-icon =
    .alt = Tanda tangan baik
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Tanda tangan buruk
openpgp-message-header-signed-unknown-icon =
    .alt = Status tanda tangan tidak diketahui
openpgp-message-header-signed-verified-icon =
    .alt = Tanda tangan terverifikasi
openpgp-message-header-signed-unverified-icon =
    .alt = Tanda tangan belum diverifikasi
