# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Laporan untuk { $addon-name }

abuse-report-title-extension = Laporkan Ekstensi Ini ke { -vendor-short-name }
abuse-report-title-theme = Laporkan Tema Ini ke { -vendor-short-name }
abuse-report-subtitle = Apa masalahnya?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = oleh <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Tidak yakin masalah apa yang harus dipilih?
    <a data-l10n-name="learnmore-link">Pelajari lebih lanjut tentang melaporkan ekstensi dan tema</a>

abuse-report-submit-description = Jelaskan masalahnya (opsional)
abuse-report-textarea =
    .placeholder = Akan lebih memudahkan bagi kami untuk menangani masalah jika memahami rinciannya. Harap jelaskan apa yang Anda alami. Terima kasih telah membantu kami menjaga Internet tetap sehat.
abuse-report-submit-note =
    Catatan: Jangan menyertakan informasi pribadi (seperti nama, alamat email, nomor telepon, alamat fisik).
    { -vendor-short-name } menyimpan laporan ini secara permanen.

## Panel buttons.

abuse-report-cancel-button = Batal
abuse-report-next-button = Lanjut
abuse-report-goback-button = Kembali
abuse-report-submit-button = Kirim

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Laporan untuk <span data-l10n-name="addon-name">{ $addon-name }</span> dibatalkan.
abuse-report-messagebar-submitting = Mengirim laporan untuk <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Terima kasih telah mengirimkan laporan. Apakah Anda ingin menghapus <span data-l10n-name="addon-name">{ $addon-name }</span>?
abuse-report-messagebar-submitted-noremove = Terima kasih telah mengirimkan laporan.
abuse-report-messagebar-removed-extension = Terima kasih telah mengirimkan laporan. Anda telah menghapus ekstensi <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Terima kasih telah mengirimkan laporan. Anda telah menghapus tema <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Terjadi kesalahan saat mengirim laporan untuk <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Laporan untuk <span data-l10n-name="addon-name">{ $addon-name }</span> tidak terkirim karena laporan lain telah dikirimkan baru-baru ini.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ya, Hapus
abuse-report-messagebar-action-keep-extension = Tidak, Saya akan Menyimpannya
abuse-report-messagebar-action-remove-theme = Ya, Hapus
abuse-report-messagebar-action-keep-theme = Tidak, Saya akan Menyimpannya
abuse-report-messagebar-action-retry = Ulangi
abuse-report-messagebar-action-cancel = Batal

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Ini merusak komputer saya atau membahayakan data saya
abuse-report-damage-example = Misal: memuat malware atau mencuri data

abuse-report-spam-reason-v2 = Ini mengandung spam atau menyisipkan iklan yang tidak diinginkan
abuse-report-spam-example = Misal: Memuat iklan di laman web

abuse-report-settings-reason-v2 = Ini mengubah setelan pencarian, beranda, atau tab baru tanpa memberitahu atau bertanya pada saya
abuse-report-settings-suggestions = Sebelum melaporkan ekstensi, Anda dapat mencoba mengubah pengaturan Anda:
abuse-report-settings-suggestions-search = Ubah setelan pencarian baku Anda
abuse-report-settings-suggestions-homepage = Ubah beranda dan tab baru Anda

abuse-report-deceptive-reason-v2 = Berpura-pura menjadi sesuatu
abuse-report-deceptive-example = Contoh: Deskripsi atau gambar yang menyesatkan

abuse-report-broken-reason-extension-v2 = Ini tidak berfungsi, tampilan situs web rusak, atau memperlambat { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Ini tidak berfungsi atau merusak tampilan peramban
abuse-report-broken-example = Contoh: Fitur lambat, sulit digunakan, atau tidak berfungsi; bagian dari situs web tidak bisa dimuat atau terlihat aneh
abuse-report-broken-suggestions-extension =
    Sepertinya Anda telah menemukan bug. Selain mengirimkan laporan di sini, cara terbaik
    untuk menyelesaikan masalah fungsionalitas adalah menghubungi pengembang ekstensi.
    <a data-l10n-name="support-link">Kunjungi situs web ekstensi</a> untuk mendapatkan informasi pengembang.
abuse-report-broken-suggestions-theme =
    Sepertinya Anda telah menemukan bug. Selain mengirimkan laporan di sini, cara terbaik
    untuk menyelesaikan masalah fungsionalitas adalah menghubungi pengembang tema.
    <a data-l10n-name="support-link">Kunjungi situs web tema</a> untuk mendapatkan informasi pengembang.

abuse-report-policy-reason-v2 = Ini mengandung konten yang berisi kebencian, kekerasan, atau melanggar hukum
abuse-report-policy-suggestions = Catatan: Masalah berkaitan dengan hak cipta dan merek dagang wajib dilaporkan dalama proses terpisah. <a data-l10n-name="report-infringement-link">Gunakan langkah ini</a> untuk melaporkannya.

abuse-report-unwanted-reason-v2 = Saya tidak pernah menginginkannya dan tidak tahu bagaimana cara menghilangkannya
abuse-report-unwanted-example = Contoh: Sebuah aplikasi memasang sesuatu tanpa izin saya

abuse-report-other-reason = Lainnya

