# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Tambahkan Kunci OpenPGP Probadi untuk { $identity }

key-wizard-button =
    .buttonlabelaccept = Lanjut
    .buttonlabelhelp = Kembali

key-wizard-warning = <b>Jika Anda sudah memiliki kunci pribadi</b> untuk alamat email ini, Anda harus mengimpornya. Jika tidak, Anda tidak akan memiliki akses ke arsip email terenkripsi, juga tidak dapat membaca email terenkripsi yang masuk dari orang yang masih menggunakan kunci Anda yang ada.

key-wizard-learn-more = Pelajari lebih lanjut

radio-create-key =
    .label = Buat Kunci OpenPGP baru
    .accesskey = C

radio-import-key =
    .label = Impor Kunci OpenPGP yang sudah ada
    .accesskey = I

radio-gnupg-key =
    .label = Gunakan kunci eksternal Anda melalui GnuPG (misalnya dari kartu pintar)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Hasilkan Kunci OpenPGP

openpgp-generate-key-info = <b>Pembuatan kunci mungkin memerlukan hingga beberapa menit untuk penyelesaiannya.</b> Jangan keluar dari aplikasi saat pembuatan kunci sedang berlangsung. Menjelajah secara aktif atau melakukan operasi intensif disk selama pembuatan kunci akan mengisi kembali 'kumpulan keacakan' dan mempercepat proses. Anda akan diberi tahu saat pembuatan kunci selesai.

openpgp-keygen-expiry-title = Kedaluwarsa kunci

openpgp-keygen-expiry-description = Tentukan waktu kedaluwarsa dari kunci yang baru Anda buat. Anda nanti dapat mengontrol tanggal untuk memperpanjangnya jika perlu.

radio-keygen-expiry =
    .label = Kunci kedaluwarsa dalam
    .accesskey = e

radio-keygen-no-expiry =
    .label = Kunci tidak kedaluwarsa
    .accesskey = d

openpgp-keygen-days-label =
    .label = hari
openpgp-keygen-months-label =
    .label = bulan
openpgp-keygen-years-label =
    .label = tahun

openpgp-keygen-advanced-title = Setelan lanjutan

openpgp-keygen-advanced-description = Kontrol pengaturan lanjutan Kunci OpenPGP Anda.

openpgp-keygen-keytype =
    .value = Jenis kunci:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Ukuran kunci:
    .accesskey = s

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Kurva Eliptik)

openpgp-keygen-button = Hasilkan kunci

openpgp-keygen-progress-title = Membuat Kunci OpenPGP baru Anda…

openpgp-keygen-import-progress-title = Mengimpor Kunci OpenPGP Anda…

openpgp-import-success = Kunci OpenPGP berhasil diimpor!

openpgp-import-success-title = Selesaikan proses impor

openpgp-import-success-description = Untuk mulai menggunakan kunci OpenPGP yang Anda impor untuk enkripsi email, tutup dialog ini dan akses Pengaturan Akun Anda untuk memilihnya.

openpgp-keygen-confirm =
    .label = Konfirmasi

openpgp-keygen-dismiss =
    .label = Batalkan

openpgp-keygen-cancel =
    .label = Batalkan proses…

openpgp-keygen-import-complete =
    .label = Tutup
    .accesskey = T

openpgp-keygen-missing-username = Tidak ada nama yang ditentukan untuk akun saat ini. Harap masukkan nilai di bidang "Nama Anda" di pengaturan akun.
openpgp-keygen-long-expiry = Anda tidak dapat membuat kunci yang kedaluwarsanya lebih dari 100 tahun.
openpgp-keygen-short-expiry = Kunci Anda harus valid setidaknya untuk satu hari.

openpgp-keygen-ongoing = Pembuatan kunci sedang berlangsung!

openpgp-keygen-error-core = Tidak dapat menginisialisasi OpenPGP Core Service

openpgp-keygen-error-failed = Pembuatan Kunci OpenPGP tiba-tiba gagal

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Kunci OpenPGP berhasil dibuat, tetapi gagal mendapatkan pencabutan kunci { $key }

openpgp-keygen-abort-title = Batalkan pembuatan kunci?
openpgp-keygen-abort = Pembuatan Kunci OpenPGP saat ini sedang berlangsung, yakin Anda ingin membatalkannya?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Hasilkan kunci publik dan rahasia untuk { $identity }?

## Import Key section

openpgp-import-key-title = Impor Kunci OpenPGP pribadi yang sudah ada

openpgp-import-key-legend = Pilih file yang telah dicadangkan sebelumnya.

openpgp-import-key-description = Anda dapat mengimpor kunci pribadi yang dibuat dengan perangkat lunak OpenPGP lainnya.

openpgp-import-key-info = Perangkat lunak lain mungkin mendeskripsikan kunci pribadi menggunakan istilah alternatif seperti kunci Anda sendiri, kunci rahasia, kunci privat, atau pasangan kunci.

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
       *[other] Thunderbird menemukan { $count } kunci yang dapat diimpor.
    }

openpgp-import-key-list-description = Konfirmasikan kunci mana yang dapat diperlakukan sebagai kunci pribadi Anda. Hanya kunci yang Anda buat sendiri dan yang menunjukkan identitas Anda yang boleh digunakan sebagai kunci pribadi. Anda dapat mengubah opsi ini nanti di dialog Properti Kunci.

openpgp-import-key-list-caption = Kunci yang ditandai untuk diperlakukan sebagai Kunci Pribadi akan dicantumkan di bagian Enkripsi Ujung-ke-Ujung. Yang lainnya akan tersedia di dalam Manajer Kunci.

openpgp-passphrase-prompt-title = Frasa sandi diperlukan

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Harap masukkan frasa sandi untuk membuka kunci berikut: { $key }

openpgp-import-key-button =
    .label = Pilih File untuk Diimpor…
    .accesskey = S

import-key-file = Impor File Kunci OpenPGP

import-key-personal-checkbox =
    .label = Perlakukan kunci ini sebagai Kunci Pribadi

gnupg-file = Berkas GnuPG

import-error-file-size = <b>Kesalahan!</b> File yang lebih besar dari 5MB tidak didukung.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Kesalahan!</b> Gagal mengimpor file. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Kesalahan!</b> Gagal mengimpor kunci. { $error }

openpgp-import-identity-label = Identitas

openpgp-import-fingerprint-label = Sidik jari

openpgp-import-created-label = Dibuat

openpgp-import-bits-label = Bit

openpgp-import-key-props =
    .label = Properti Kunci
    .accesskey = K

## External Key section

openpgp-external-key-title = Kunci GnuPG Eksternal

openpgp-external-key-description = Konfigurasikan kunci GnuPG eksternal dengan memasukkan ID Kunci

openpgp-external-key-info = Selain itu, Anda harus menggunakan Manajer Kunci untuk mengimpor dan menerima Kunci Publik yang sesuai.

openpgp-external-key-warning = <b>Anda hanya dapat mengkonfigurasi satu Kunci GnuPG eksternal.</b> Entri Anda sebelumnya akan diganti.

openpgp-save-external-button = Simpan ID kunci

openpgp-external-key-label = ID Kunci Rahasia:

openpgp-external-key-input =
    .placeholder = 123456789341298340
