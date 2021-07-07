# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Untuk mengirim pesan terenkripsi atau bertanda tangan digital, Anda perlu mengkonfigurasi teknologi enkripsi, baik OpenPGP maupun S/MIME.
e2e-intro-description-more = Pilih kunci pribadi Anda untuk mengaktifkan penggunaan OpenPGP, atau sertifikat pribadi Anda untuk mengaktifkan penggunaan S/MIME. Untuk kunci pribadi atau sertifikat, Anda memiliki kunci rahasia yang sesuai.
openpgp-key-user-id-label = Akun / ID Pengguna
openpgp-keygen-title-label =
    .title = Hasilkan Kunci OpenPGP
openpgp-cancel-key =
    .label = Batalkan
    .tooltiptext = Batalkan Pembuatan Kunci
openpgp-key-gen-expiry-title =
    .label = Kedaluwarsa kunci
openpgp-key-gen-expire-label = Kunci kedaluwarsa dalam
openpgp-key-gen-days-label =
    .label = hari
openpgp-key-gen-months-label =
    .label = bulan
openpgp-key-gen-years-label =
    .label = tahun
openpgp-key-gen-no-expiry-label =
    .label = Kunci tidak kedaluwarsa
openpgp-key-gen-key-size-label = Ukuran kunci
openpgp-key-gen-console-label = Pembuatan Kunci
openpgp-key-gen-key-type-label = Jenis kunci
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (Kurva Eliptik)
openpgp-generate-key =
    .label = Hasilkan kunci
    .tooltiptext = Membuat sebuah kunci kepatuhan OpenPGP baru untuk enkripsi dan atau penandatanganan
openpgp-advanced-prefs-button-label =
    .label = Canggih…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">CATATAN: Pembuatan kunci mungkin membutuhkan waktu hingga beberapa menit untuk menyelesaikannya.</a> Jangan keluar dari aplikasi saat pembuatan kunci sedang berlangsung. Menjelajah secara aktif atau melakukan operasi intensif disk selama pembuatan kunci akan mengisi kembali 'kumpulan keacakan' dan mempercepat proses. Anda akan diberi tahu saat pembuatan kunci selesai.
openpgp-key-expiry-label =
    .label = Kedaluwarsa
openpgp-key-id-label =
    .label = ID Kunci
openpgp-cannot-change-expiry = Ini adalah kunci dengan struktur yang kompleks, mengubah tanggal kedaluwarsa tidak didukung.
openpgp-key-man-title =
    .title = Manajer Kunci OpenPGP
openpgp-key-man-generate =
    .label = Pasangan Kunci Baru
    .accesskey = K
openpgp-key-man-gen-revoke =
    .label = Sertifikat Pencabutan
    .accesskey = R
openpgp-key-man-ctx-gen-revoke-label =
    .label = Hasilkan & Simpan Sertifikat Pencabutan
openpgp-key-man-file-menu =
    .label = File
    .accesskey = F
openpgp-key-man-edit-menu =
    .label = Sunting
    .accesskey = E
openpgp-key-man-view-menu =
    .label = Tampilkan
    .accesskey = V
openpgp-key-man-generate-menu =
    .label = Menghasilkan
    .accesskey = G
openpgp-key-man-keyserver-menu =
    .label = Keyserver
    .accesskey = K
openpgp-key-man-import-public-from-file =
    .label = Impor Kunci Publik Dari File
    .accesskey = I
openpgp-key-man-import-secret-from-file =
    .label = Impor Kunci Rahasia Dari File
openpgp-key-man-import-sig-from-file =
    .label = Impor Pembatalan Dari File
openpgp-key-man-import-from-clipbrd =
    .label = Impor Kunci Dari Papan Klip
    .accesskey = I
openpgp-key-man-import-from-url =
    .label = Impor Kunci Dari URL
    .accesskey = U
openpgp-key-man-export-to-file =
    .label = Ekspor Kunci Publik Ke File
    .accesskey = E
openpgp-key-man-send-keys =
    .label = Kirim Kunci Publik Lewat Surel
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = Cadangkan Kunci Rahasia Ke File
    .accesskey = C
openpgp-key-man-discover-cmd =
    .label = Temukan Kunci Daring
    .accesskey = D
openpgp-key-man-discover-prompt = Untuk menemukan kunci OpenPGP secara daring, pada server kunci atau menggunakan protokol WKD, masukkan salah satu alamat surel atau ID kunci.
openpgp-key-man-discover-progress = Mencari…
openpgp-key-copy-key =
    .label = Salin Kunci Publik
    .accesskey = C
openpgp-key-export-key =
    .label = Ekspor Kunci Publik Ke File
    .accesskey = E
openpgp-key-backup-key =
    .label = Cadangkan Kunci Rahasia Ke File
    .accesskey = C
openpgp-key-send-key =
    .label = Kirim Kunci Publik Lewat Surel
    .accesskey = S
openpgp-key-man-copy-to-clipbrd =
    .label = Salin Kunci Publik Ke Papan Klip
    .accesskey = c
openpgp-key-man-copy-key-ids =
    .label =
        { $count ->
           *[other] Salin ID Kunci ke Papan Klip
        }
    .accesskey = k
openpgp-key-man-copy-fprs =
    .label =
        { $count ->
           *[other] Salin Sidik Jari Ke Papan Klip
        }
    .accesskey = S
openpgp-key-man-copy-to-clipboard =
    .label =
        { $count ->
           *[other] Salin Kunci Publik Ke Papan Klip
        }
    .accesskey = P
openpgp-key-man-ctx-expor-to-file-label =
    .label = Ekspor Kunci Ke File
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Salin Kunci Publik Ke Papan Klip
openpgp-key-man-ctx-copy =
    .label = Salin
    .accesskey = S
openpgp-key-man-ctx-copy-fprs =
    .label =
        { $count ->
           *[other] Sidik Jari
        }
    .accesskey = S
openpgp-key-man-ctx-copy-key-ids =
    .label =
        { $count ->
           *[other] ID Kunci
        }
    .accesskey = K
openpgp-key-man-ctx-copy-public-keys =
    .label =
        { $count ->
           *[other] Kunci Publik
        }
    .accesskey = P
openpgp-key-man-close =
    .label = Tutup
openpgp-key-man-reload =
    .label = Muat Ulang Singgahan Kunci
    .accesskey = M
openpgp-key-man-change-expiry =
    .label = Ubah Tanggal Kedaluwarsa
    .accesskey = e
openpgp-key-man-del-key =
    .label = Hapus Kunci
    .accesskey = H
openpgp-delete-key =
    .label = Hapus Kunci
    .accesskey = H
openpgp-key-man-revoke-key =
    .label = Cabut Kunci
    .accesskey = C
openpgp-key-man-key-props =
    .label = Properti Kunci
    .accesskey = K
openpgp-key-man-key-more =
    .label = Lebih Lanjut
    .accesskey = L
openpgp-key-man-view-photo =
    .label = ID Foto
    .accesskey = F
openpgp-key-man-ctx-view-photo-label =
    .label = Lihat ID Foto
openpgp-key-man-show-invalid-keys =
    .label = Tampilkan kunci yang tidak valid
    .accesskey = d
openpgp-key-man-show-others-keys =
    .label = Tampilkan Kunci Dari Orang Lain
    .accesskey = O
openpgp-key-man-user-id-label =
    .label = Nama
openpgp-key-man-fingerprint-label =
    .label = Sidik Jari
openpgp-key-man-select-all =
    .label = Pilih Semua Kunci
    .accesskey = a
openpgp-key-man-empty-tree-tooltip =
    .label = Masukkan istilah pencarian dalam kotak di atas
openpgp-key-man-nothing-found-tooltip =
    .label = Tidak ada kunci yang cocok dengan istilah pencarian Anda
openpgp-key-man-please-wait-tooltip =
    .label = Harap tunggu sementara kunci sedang dimuat…
openpgp-key-man-filter-label =
    .placeholder = Cari kunci
openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I
openpgp-key-details-title =
    .title = Properti Kunci
openpgp-key-details-signatures-tab =
    .label = Sertifikasi
openpgp-key-details-structure-tab =
    .label = Struktur
openpgp-key-details-uid-certified-col =
    .label = ID Pengguna / Disertifikasi oleh
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Tipe
openpgp-key-details-key-part-label =
    .label = Bagian kunci
openpgp-key-details-algorithm-label =
    .label = Algoritme
openpgp-key-details-size-label =
    .label = Ukuran
openpgp-key-details-created-label =
    .label = Dibuat
openpgp-key-details-created-header = Dibuat
openpgp-key-details-expiry-label =
    .label = Kedaluwarsa
openpgp-key-details-expiry-header = Kedaluwarsa
openpgp-key-details-usage-label =
    .label = Penggunaan
openpgp-key-details-fingerprint-label = Sidik Jari
openpgp-key-details-sel-action =
    .label = Pilih aksi ...
    .accesskey = s
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Tutup
openpgp-acceptance-label =
    .label = Penerimaan Anda
openpgp-acceptance-rejected-label =
    .label = Tidak, tolak kunci ini.
openpgp-acceptance-undecided-label =
    .label = Belum, mungkin nanti.
openpgp-acceptance-unverified-label =
    .label = Ya, tetapi saya belum memverifikasi bahwa ini adalah kunci yang benar.
openpgp-acceptance-verified-label =
    .label = Ya, saya telah memverifikasi secara langsung kunci ini memiliki sidik jari yang benar.
key-accept-personal =
    Untuk kunci ini, Anda memiliki bagian publik dan rahasia. Anda dapat menggunakannya sebagai kunci pribadi.
    Jika kunci ini diberikan kepada Anda oleh orang lain, jangan gunakan sebagai kunci pribadi.
key-personal-warning = Apakah Anda membuat kunci ini sendiri, dan kepemilikan kunci yang ditampilkan mengacu pada diri Anda sendiri?
openpgp-personal-no-label =
    .label = Tidak, jangan gunakan sebagai kunci pribadi saya.
openpgp-personal-yes-label =
    .label = Ya, perlakukan kunci ini sebagai kunci pribadi.
openpgp-copy-cmd-label =
    .label = Salin

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description =
    { $count ->
        [0] Thunderbird tidak memiliki kunci pribadi OpenPGP yang terkait dengan <b>{ $identity }</b>
       *[other] Thunderbird menemukan { $count } kunci pribadi OpenPGP yang terkait dengan <b>{ $identity }</b>
    }
#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status =
    { $count ->
        [0] Pilih sebuah kunci yang valid untuk memfungsikan protokol OpenPGP.
       *[other] Konfigurasi Anda saat ini menggunakan ID kunci <b>{ $key }</b>
    }
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Konfigurasi Anda saat ini menggunakan kunci <b>{ $key }</b>, yang telah kedaluwarsa.
openpgp-add-key-button =
    .label = Tambahkan Kunci…
    .accesskey = a
e2e-learn-more = Pelajari lebih lanjut
openpgp-keygen-success = Kunci OpenPGP berhasil dibuat!
openpgp-keygen-import-success = Kunci OpenPGP berhasil diimpor!
openpgp-keygen-external-success = ID Kunci GnuPG Eksternal disimpan!

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Nihil
openpgp-radio-none-desc = Jangan gunakan OpenPGP untuk identitas ini.
openpgp-radio-key-not-usable = Kunci ini tidak dapat digunakan sebagai kunci pribadi, karena kunci rahasia hilang!
openpgp-radio-key-not-accepted = Untuk menggunakan kunci ini Anda harus menyetujuinya sebagai kunci pribadi!
openpgp-radio-key-not-found = Kunci ini tidak ditemukan! Jika ingin menggunakannya, Anda harus mengimpornya ke { -brand-short-name }.
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Kedaluwarsa pada: { $date }
openpgp-key-expires-image =
    .tooltiptext = Kunci akan kedaluwarsa dalam waktu kurang dari 6 bulan
#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Kedaluwarsa pada: { $date }
openpgp-key-expired-image =
    .tooltiptext = Kunci kedaluwarsa
openpgp-key-expand-section =
    .tooltiptext = Informasi lebih lanjut
openpgp-key-revoke-title = Cabut Kunci
openpgp-key-edit-title = Ubah Kunci OpenPGP
openpgp-key-edit-date-title = Perpanjang Tanggal Kedaluwarsa
openpgp-manager-description = Gunakan Manajer Kunci OpenPGP untuk melihat dan mengelola kunci publik koresponden Anda dan semua kunci lain yang tidak tercantum di atas.
openpgp-manager-button =
    .label = Manajer Kunci OpenPGP
    .accesskey = K
openpgp-key-remove-external =
    .label = Hapus ID Kunci Eksternal
    .accesskey = E
key-external-label = Kunci GnuPG Eksternal
# Strings in keyDetailsDlg.xhtml
key-type-public = kunci publik
key-type-primary = kunci utama
key-type-subkey = subkunci
key-type-pair = pasangan kunci (kunci rahasia dan kunci publik)
key-expiry-never = tidak pernah
key-usage-encrypt = Enkripsi
key-usage-sign = Tandatangan
key-usage-certify = Sertifikasi
key-usage-authentication = Otentikasi
key-does-not-expire = Kunci tidak kedaluwarsa
key-expired-date = Kunci kedaluwarsa pada { $keyExpiry }
key-expired-simple = Kunci sudah kedaluwarsa
key-revoked-simple = Kunci sudah dicabut
key-do-you-accept = Apakah Anda menerima kunci ini untuk memverifikasi tanda tangan digital dan untuk mengenkripsi pesan?
key-accept-warning = Hindari menerima kunci tipuan. Gunakan saluran komunikasi selain surel untuk memverifikasi sidik jari kunci koresponden Anda.
# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Tidak dapat mengirim pesan, karena ada masalah dengan kunci pribadi Anda. { $problem }
cannot-encrypt-because-missing = Tidak dapat mengirim pesan ini dengan enkripsi ujung ke ujung, karena ada masalah dengan kunci dari penerima berikut: { $problem }
window-locked = Jendela tulis terkunci; pengiriman dibatalkan
# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Bagian pesan terenkripsi
mime-decrypt-encrypted-part-concealed-data = Ini adalah bagian pesan terenkripsi. Anda perlu membukanya di jendela terpisah dengan mengklik lampiran.
# Strings in keyserver.jsm
keyserver-error-aborted = Dibatalkan
keyserver-error-unknown = Terjadi masalah yang tidak diketahui
keyserver-error-server-error = Server kunci melaporkan kesalahan.
keyserver-error-import-error = Gagal mengimpor kunci yang diunduh.
keyserver-error-unavailable = Server kunci tidak tersedia.
keyserver-error-security-error = Server kunci tidak mendukung akses terenkripsi.
keyserver-error-certificate-error = Sertifikat server kunci tidak valid.
keyserver-error-unsupported = Server kunci tidak didukung.
# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Penyedia surel Anda telah memproses permintaan Anda untuk mengunggah kunci publik Anda ke OpenPGP Web Key Directory.
    Harap konfirmasi untuk menyelesaikan penerbitan kunci publik Anda.
wkd-message-body-process =
    Ini adalah surel yang terkait dengan pemrosesan otomatis untuk mengunggah kunci publik Anda ke OpenPGP Web Key Directory.
    Anda tidak perlu melakukan tindakan manual apa pun pada saat ini.
# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Tidak dapat mendekripsi pesan dengan subjek
    { $subject }.
    Apakah Anda ingin mencoba lagi dengan frasa sandi yang berbeda atau ingin melewatkan pesan?
# Strings in gpg.jsm
unknown-signing-alg = Algoritme penandatanganan tidak diketahui (ID: { $id })
unknown-hash-alg = Hash kriptografi tidak diketahui (ID: { $id })
# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Kunci Anda { $desc } akan kedaluwarsa dalam waktu kurang dari { $days } hari.
    Kami menyarankan Anda untuk membuat pasangan kunci baru dan mengkonfigurasi akun yang sesuai untuk menggunakannya.
expiry-keys-expire-soon =
    Kunci Anda berikut akan kedaluwarsa dalam waktu kurang dari { $days } hari: { $desc }.
    Kami menyarankan Anda membuat kunci baru dan mengkonfigurasi akun yang sesuai untuk menggunakannya.
expiry-key-missing-owner-trust =
    Kunci rahasia Anda { $desc } kurang kepercayaan.
    Kami merekomendasikan agar Anda menetapkan "Anda mengandalkan sertifikasi" ke "ultimate" di properti utama.
expiry-keys-missing-owner-trust =
    Kunci rahasia berikut ini tidak memiliki kepercayaan.
    { $desc }.
    Kami merekomendasikan agar Anda menetapkan "Anda mengandalkan sertifikasi" ke "ultimate" di properti utama.
expiry-open-key-manager = Buka Manajer Kunci OpenPGP
expiry-open-key-properties = Buka Properti Kunci
# Strings filters.jsm
filter-folder-required = Anda harus memilih folder target.
filter-decrypt-move-warn-experimental =
    Peringatan - tindakan filter "Dekripsi secara permanen" dapat menyebabkan pesan rusak.
    Kami sangat menganjurkan agar Anda terlebih dahulu mencoba filter "Buat Salinan yang didekripsi", uji hasilnya dengan cermat, dan hanya mulai gunakan filter ini setelah Anda puas dengan hasilnya.
filter-term-pgpencrypted-label = Dienkripsi OpenPGP
filter-key-required = Anda harus memilih kunci penerima.
filter-key-not-found = Tidak dapat menemukan kunci enkripsi untuk '{ $desc }'.
filter-warn-key-not-secret =
    Peringatan - tindakan filter "Enkripsi ke kunci" menggantikan penerima.
    Jika Anda tidak memiliki kunci rahasia untuk '{ $desc }' Anda tidak dapat lagi membaca surel itu.
# Strings filtersWrapper.jsm
filter-decrypt-move-label = Dekripsi secara permanen (OpenPGP)
filter-decrypt-copy-label = Buat Salinan yang didekripsi (OpenPGP)
filter-encrypt-label = Enkripsi ke kunci (OpenPGP)
# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Sukses! Kunci diimpor
import-info-bits = Bit
import-info-created = Dibuat
import-info-fpr = Sidik Jari
import-info-details = Lihat Rincian dan kelola penerimaan kunci
import-info-no-keys = Tidak ada kunci yang diimpor.
# Strings in enigmailKeyManager.js
import-from-clip = Apakah Anda ingin mengimpor beberapa kunci dari papan klip?
import-from-url = Unduh kunci publik dari URL ini:
copy-to-clipbrd-failed = Tidak dapat menyalin kunci yang dipilih ke papan klip.
copy-to-clipbrd-ok = Kunci disalin ke papan klip
delete-secret-key =
    PERINGATAN: Anda akan menghapus kunci rahasia!
    
    Jika Anda menghapus kunci rahasia, Anda tidak lagi dapat mendekripsi pesan apa pun yang dienkripsi untuk kunci itu, Anda juga tidak akan dapat mencabutnya.
    
    Apakah Anda benar-benar ingin menghapus KEDUANYA, kunci rahasia dan kunci publik
    { $userId }?
delete-mix =
    PERINGATAN: Anda akan menghapus kunci rahasia!
    Jika Anda menghapus kunci rahasia, Anda tidak lagi dapat mendekripsi pesan apa pun yang dienkripsi untuk kunci itu.
    Anda yakin ingin menghapus KEDUANYA, kunci rahasia dan publik yang dipilih?
delete-pub-key =
    Apakah Anda ingin menghapus kunci publik
    '{ $userId }'?
delete-selected-pub-key = Apakah Anda ingin menghapus kunci publik?
refresh-all-question = Anda tidak memilih kunci apa pun. Apakah Anda ingin menyegarkan SEMUA kunci?
key-man-button-export-sec-key = Ek&spor Kunci Rahasia
key-man-button-export-pub-key = Ekspor Kunci &Publik Saja
key-man-button-refresh-all = Sega&rkan Semua Kunci
key-man-loading-keys = Memuat kunci, harap tunggu…
ascii-armor-file = File Dilapis ASCII (*.asc)
no-key-selected = Anda harus memilih setidaknya satu kunci untuk melakukan operasi yang dipilih
export-to-file = Ekspor Kunci Publik Ke File
export-keypair-to-file = Ekspor Kunci Rahasia dan Publik Ke File
export-secret-key = Apakah Anda ingin menyertakan kunci rahasia dalam file kunci OpenPGP yang disimpan?
save-keys-ok = Kunci berhasil disimpan
save-keys-failed = Gagal menyimpan kunci
refresh-key-warn = Peringatan: tergantung pada banyaknya kunci dan kecepatan koneksi, menyegarkan semua kunci bisa menjadi proses yang cukup lama!
preview-failed = Tidak dapat membaca file kunci publik.
general-error = Kesalahan: { $reason }
dlg-button-delete = &Hapus

## Account settings export output

openpgp-export-public-success = <b>Kunci Publik berhasil diekspor!</b>
openpgp-export-public-fail = <b>Tidak dapat mengekspor kunci publik yang dipilih!</b>
openpgp-export-secret-success = <b>Kunci Rahasia berhasil diekspor!</b>
openpgp-export-secret-fail = <b>Tidak dapat mengekspor kunci rahasia yang dipilih!</b>
# Strings in keyObj.jsm
key-ring-pub-key-revoked = Kunci { $userId } (ID kunci { $keyId }) dicabut.
key-ring-pub-key-expired = Kunci { $userId } (ID kunci { $keyId }) telah kedaluwarsa.
key-ring-no-secret-key = Anda tampaknya tidak memiliki kunci rahasia untuk { $userId } (ID kunci { $keyId }) pada keyring Anda; Anda tidak dapat menggunakan kunci untuk menandatangani.
key-ring-pub-key-not-for-signing = Kunci { $userId } (ID kunci { $keyId }) tidak dapat digunakan untuk penandatanganan.
key-ring-pub-key-not-for-encryption = Kunci { $userId } (ID kunci { $keyId }) tidak dapat digunakan untuk enkripsi.
key-ring-sign-sub-keys-revoked = Semua subkunci penandatanganan dari kunci { $userId } (ID kunci { $keyId }) dicabut.
key-ring-sign-sub-keys-expired = Semua subkunci penandatanganan dari kunci { $userId } (ID kunci { $keyId }) telah kedaluwarsa.
key-ring-enc-sub-keys-revoked = Semua subkunci enkripsi dari kunci { $userId } (ID kunci { $keyId }) dicabut.
key-ring-enc-sub-keys-expired = Semua subkunci enkripsi dari kunci { $userId } (ID kunci { $keyId }) telah kedaluwarsa.
# Strings in gnupg-keylist.jsm
keyring-photo = Foto
user-att-photo = Atribut pengguna (gambar JPEG)
# Strings in key.jsm
already-revoked = Kunci ini sudah dicabut.
#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Anda akan mencabut kunci '{ $identity }'.
    Anda tidak lagi dapat masuk dengan kunci ini, dan setelah didistribusikan, orang lain tidak lagi dapat mengenkripsi dengan kunci itu. Anda masih dapat menggunakan kunci tersebut untuk mendekripsi pesan lama.
    Apakah Anda ingin melanjutkan?
#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Anda tidak memiliki kunci (0x{ $keyId }) yang cocok dengan sertifikat pencabutan ini!
    Jika Anda kehilangan kunci, Anda harus mengimpornya (mis. dari server kunci) sebelum mengimpor sertifikat pencabutan!
#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Kunci 0x { $keyId } sudah pernah dicabut.
key-man-button-revoke-key = &Cabut Kunci
openpgp-key-revoke-success = Kunci berhasil dicabut.
after-revoke-info =
    Kunci telah dicabut.
    Bagikan kunci publik ini lagi, dengan mengirimkannya melalui surel, atau dengan mengunggahnya ke server kunci, untuk memberi tahu orang lain bahwa Anda telah mencabut kunci Anda.
    Segera setelah perangkat lunak yang digunakan oleh orang lain mengetahui tentang pencabutan tersebut, itu akan berhenti memakai kunci lama Anda.
    Jika Anda menggunakan kunci baru untuk alamat surel yang sama, dan Anda melampirkan kunci publik baru ke surel yang Anda kirim, maka informasi tentang kunci lama Anda yang dicabut akan secara otomatis disertakan.
# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = &Impor
delete-key-title = Hapus Kunci OpenPGP
delete-external-key-title = Buamg Kunci GnuPG Eksternal
delete-external-key-description = Apakah Anda ingin membuang ID kunci GnuPG Eksternal ini?
key-in-use-title = Kunci OpenPGP sedang digunakan
delete-key-in-use-description = Tidak dapat melanjutkan! Kunci yang Anda pilih untuk dihapus saat ini sedang digunakan oleh identitas ini. Pilih kunci lain, atau pilih tidak ada, dan coba lagi.
revoke-key-in-use-description = Tidak dapat melanjutkan! Kunci yang Anda pilih untuk pencabutan sedang digunakan oleh identitas ini. Pilih kunci lain, atau pilih tidak ada, dan coba lagi.
# Strings used in errorHandling.jsm
key-error-key-spec-not-found = Alamat surel '{ $keySpec }' tidak bisa dicocokkan dengan kunci di keyring Anda.
key-error-key-id-not-found = ID kunci yang dikonfigurasi '{ $keySpec }' tidak dapat ditemukan di keyring Anda.
key-error-not-accepted-as-personal = Anda belum mengonfirmasi bahwa kunci dengan ID '{ $keySpec }' adalah kunci pribadi Anda.
# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Fungsi yang Anda pilih tidak tersedia dalam mode luring. Pergilah daring dan coba lagi.
# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Kami tidak dapat menemukan kunci yang cocok dengan kriteria pencarian yang ditentukan.
# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Kesalahan - perintah ekstraksi kunci gagal
# Strings used in keyRing.jsm
fail-cancel = Kesalahan - Penerimaan kunci dibatalkan oleh pengguna
not-first-block = Kesalahan - Blok OpenPGP pertama bukan blok kunci publik
import-key-confirm = Impor kunci publik yang disematkan dalam pesan?
fail-key-import = Kesalahan - impor kunci gagal
file-write-failed = Gagal menulis ke berkas  { $output }
no-pgp-block = Kesalahan - Tidak ditemukan blok data OpenPGP terbungkus yang valid
confirm-permissive-import = Impor gagal. Kunci yang Anda coba impor mungkin rusak atau menggunakan atribut yang tidak diketahui. Apakah Anda ingin mencoba mengimpor bagian yang benar? Ini mungkin mengakibatkan impor kunci yang tidak lengkap dan tidak dapat digunakan.
# Strings used in trust.jsm
key-valid-unknown = tidak dikenal
key-valid-invalid = tidak valid
key-valid-disabled = dinonaktifkan
key-valid-revoked = dicabut
key-valid-expired = kedaluwarsa
key-trust-untrusted = tidak terpercaya
key-trust-marginal = marjinal
key-trust-full = dipercaya
key-trust-group = (grup)
# Strings used in commonWorkflows.js
import-key-file = Impor Berkas Kunci OpenPGP
import-rev-file = Impor Berkas Pencabutan OpenPGP
gnupg-file = Berkas GnuPG
import-keys-failed = Pengimporan kunci gagal
passphrase-prompt = Harap masukkan frasa sandi untuk membuka kunci berikut: { $key }
file-to-big-to-import = File ini terlalu besar. Harap jangan mengimpor banyak kunci sekaligus.
# Strings used in enigmailKeygen.js
save-revoke-cert-as = Buat & Simpan Sertifikat Pencabutan
revoke-cert-ok = Sertifikat pencabutan telah berhasil dibuat. Anda dapat menggunakannya untuk membuat kunci publik Anda tidak valid, mis. seandainya Anda kehilangan kunci rahasia Anda.
revoke-cert-failed = Sertifikat pencabutan tidak dapat dibuat.
gen-going = Pembuatan kunci sedang berlangsung!
keygen-missing-user-name = Tidak ada nama yang ditentukan untuk akun/identitas yang dipilih. Harap masukkan nilai di bidang "Nama Anda" di pengaturan akun.
expiry-too-short = Kunci Anda harus valid setidaknya untuk satu hari.
expiry-too-long = Anda tidak dapat membuat kunci yang kedaluwarsanya lebih dari 100 tahun.
key-confirm = Hasilkan kunci publik dan rahasia untuk '{ $id }'?
key-man-button-generate-key = &Hasilkan Kunci
key-abort = Batalkan pembuatan kunci?
key-man-button-generate-key-abort = B&atalkan Pembuatan Kunci
key-man-button-generate-key-continue = Lanjutkan Pembuatan Kun&ci

# Strings used in enigmailMessengerOverlay.js

failed-decrypt = Kesalahan - dekripsi gagal
fix-broken-exchange-msg-failed = Tidak berhasil memperbaiki pesan.
attachment-no-match-from-signature = Tidak dapat mencocokkan file tanda tangan '{ $attachment }' dengan lampiran
attachment-no-match-to-signature = Tidak dapat mencocokkan lampiran '{ $attachment }' dengan file tanda tangan
signature-verified-ok = Tanda tangan untuk lampiran { $attachment } berhasil diverifikasi
signature-verify-failed = Tanda tangan untuk lampiran { $attachment } tidak dapat diverifikasi
decrypt-ok-no-sig =
    Peringatan
    Dekripsi berhasil, tetapi tanda tangan tidak dapat diverifikasi dengan benar
msg-ovl-button-cont-anyway = &Lanjutkan Saja
enig-content-note = *Lampiran pesan ini belum ditandatangani atau dienkripsi*
# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = Kirim Pe&san
msg-compose-details-button-label = Rincian...
msg-compose-details-button-access-key = R
send-aborted = Operasi pengiriman dibatalkan.
key-not-trusted = Tidak cukup kepercayaan untuk kunci '{ $key }'
key-not-found = Kunci '{ $key }' tidak ditemukan
key-revoked = Kunci '{ $key }' dicabut
key-expired = Kunci '{ $key }' kedaluwarsa
msg-compose-internal-error = Kesalahan internal telah terjadi.
keys-to-export = Pilih Kunci OpenPGP untuk Disisipkan
msg-compose-partially-encrypted-inlinePGP =
    Pesan yang Anda balas berisi bagian yang tidak terenkripsi dan terenkripsi. Jika pengirim awalnya tidak dapat mendekripsi beberapa bagian pesan, Anda mungkin membocorkan informasi rahasia yang awalnya tidak dapat didekripsi sendiri oleh pengirim.
    Harap pertimbangkan untuk menghapus semua teks kutipan dari balasan Anda ke pengirim ini.
msg-compose-cannot-save-draft = Kesalahan saat menyimpan draf
msg-compose-partially-encrypted-short = Waspadai kebocoran informasi sensitif - surel yang dienkripsi sebagian.
quoted-printable-warn =
    Anda telah mengaktifkan pengkodean 'quote-printable' untuk mengirim pesan. Hal ini dapat mengakibatkan kesalahan dekripsi dan/atau verifikasi pesan Anda.
    Apakah Anda ingin mematikan pengiriman pesan yang 'quote-printable' sekarang?
minimal-line-wrapping =
    Anda telah menyetel pelipatan baris ke { $width } karakter. Untuk enkripsi dan/atau penandatanganan yang benar, nilai ini harus minimal 68.
    Apakah Anda ingin mengubah pelipatan baris menjadi 68 karakter sekarang?
sending-hidden-rcpt = Penerima BCC (blind copy) tidak dapat digunakan saat mengirim pesan terenkripsi. Untuk mengirim pesan terenkripsi ini, hapus penerima BCC atau pindahkan ke kolom CC.
sending-news =
    Operasi pengiriman terenkripsi dibatalkan.
    Pesan ini tidak dapat dienkripsi karena ada penerima newsgroup. Harap kirim ulang pesan tanpa enkripsi.
send-to-news-warning =
    Peringatan: Anda akan mengirim surel terenkripsi ke newsgroup.
    Hal ini tidak disarankan karena hanya masuk akal jika semua anggota grup dapat mendekripsi pesan, yaitu pesan perlu dienkripsi dengan kunci semua peserta grup. Harap kirim pesan ini hanya jika Anda tahu persis apa yang Anda lakukan.
    Lanjutkan?
save-attachment-header = Simpan lampiran yang didekripsi
no-temp-dir =
    Tidak dapat menemukan direktori sementara untuk menulis
    Harap setel variabel lingkungan TEMP
possibly-pgp-mime = Mungkin pesan yang dienkripsi atau ditandatangani PGP/MIME; gunakan fungsi 'Dekripsi/Verifikasi' untuk memverifikasi
cannot-send-sig-because-no-own-key = Tidak dapat menandatangani pesan ini secara digital, karena Anda belum mengonfigurasi enkripsi ujung-ke-ujung untuk <{ $key }>
cannot-send-enc-because-no-own-key = Tidak dapat mengirim pesan ini dengan enkripsi, karena Anda belum mengonfigurasi enkripsi ujung-ke-ujung untuk <{ $key }>
# Strings used in decryption.jsm
do-import-multiple =
    Impor kunci berikut?
    { $key }
do-import-one = Impor { $name } ({ $id })?
cant-import = Terjadi kesalahan saat mengimpor kunci publik
unverified-reply = Bagian pesan yang diberi indentasi (balasan) mungkin telah diubah
key-in-message-body = Sebuah kunci ditemukan di badan pesan. Klik 'Impor Kunci' untuk mengimpor kunci
sig-mismatch = Kesalahan - Tanda tangan tidak cocok
invalid-email = Kesalahan - alamat surel tidak valid
attachment-pgp-key =
    Lampiran '{ $name }' yang Anda buka tampaknya seperti berkas kunci OpenPGP.
    Klik 'Impor' untuk mengimpor kunci yang ada atau 'Lihat' untuk melihat konten berkas di jendela peramban
# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Pesan yang didekripsi (format surel PGP rusak yang dipulihkan mungkin disebabkan oleh server Exchange lama, sehingga hasilnya mungkin tidak sempurna untuk dibaca)
# Strings used in encryption.jsm
not-required = Kesalahan - tidak diperlukan enkripsi
# Strings used in windows.jsm
no-photo-available = Tidak ada Foto tersedia
error-photo-path-not-readable = Path foto '{ $photo }' tidak dapat dibaca
debug-log-title = Log Debug OpenPGP
# Strings used in dialog.jsm
repeat-prefix = Lansiran ini akan berulang { $count }
repeat-suffix-singular = kali lagi.
repeat-suffix-plural = kali lagi.
no-repeat = Lansiran ini tidak akan ditampilkan lagi.
dlg-keep-setting = Ingat jawaban saya dan jangan tanya saya lagi
dlg-button-ok = &OK
dlg-button-close = T&utup
dlg-button-cancel = &Batal
dlg-no-prompt = Jangan tampilkan dialog ini lagi.
enig-prompt = Sapaan PromptPGP
enig-confirm = Konfirmasi OpenPGP
enig-alert = Lansiran OpenPGP
enig-info = Informasi OpenPGP
# Strings used in persistentCrypto.jsm
dlg-button-retry = &Coba Lagi
dlg-button-skip = &Lewati
# Strings used in enigmailCommon.js
enig-error = Kesalahan OpenPGP
# Strings used in enigmailMsgBox.js
enig-alert-title =
    .title = Lansiran OpenPGP
