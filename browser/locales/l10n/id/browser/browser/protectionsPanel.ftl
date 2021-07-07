# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Ada masalah saat mengirim laporan. Silakan coba lagi nanti.
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = Situs selesai diperbaiki? Kirim laporan

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Ketat
    .label = Ketat
protections-popup-footer-protection-label-custom = Ubahsuai
    .label = Ubahsuai
protections-popup-footer-protection-label-standard = Standar
    .label = Standar

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Informasi lebih lanjut tentang Perlindungan Pelacakan yang Ditingkatkan
protections-panel-etp-on-header = Perlindungan Pelacakan yang Ditingkatkan AKTIF untuk situs ini
protections-panel-etp-off-header = Perlindungan Pelacakan yang Ditingkatkan NONAKTIF untuk situs ini
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Situs tidak berfungsi?
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Situs Tidak Berfungsi?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Mengapa?
protections-panel-not-blocking-why-etp-on-tooltip = Memblokir yang berikut dapat merusak elemen pada beberapa situs web. Tanpa pelacak, beberapa tombol, formulir, dan bidang info masuk mungkin tidak berfungsi.
protections-panel-not-blocking-why-etp-off-tooltip = Semua pelacak di situs ini telah dimuat karena perlindungan dinonaktifkan.

##

protections-panel-no-trackers-found = Tidak ada pelacak yang dikenali { -brand-short-name } terdeteksi di laman ini.
protections-panel-content-blocking-tracking-protection = Pelacakan Konten
protections-panel-content-blocking-socialblock = Pelacak Media Sosial
protections-panel-content-blocking-cryptominers-label = Penambang Kripto
protections-panel-content-blocking-fingerprinters-label = Pelacak Sidik

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Diblokir
protections-panel-not-blocking-label = Diizinkan
protections-panel-not-found-label = Tidak Terdeteksi

##

protections-panel-settings-label = Setelan Perlindungan
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = Dasbor Perlindungan

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Nonaktifkan perlindungan jika Anda memiliki masalah dengan:
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Bidang info masuk
protections-panel-site-not-working-view-issue-list-forms = Formulir
protections-panel-site-not-working-view-issue-list-payments = Pembayaran
protections-panel-site-not-working-view-issue-list-comments = Komentar
protections-panel-site-not-working-view-issue-list-videos = Video
protections-panel-site-not-working-view-send-report = Kirim laporan

##

protections-panel-cross-site-tracking-cookies = Kuki ini mengikuti Anda dari situs ke situs untuk mengumpulkan data tentang apa yang Anda lakukan daring. Mereka ditetapkan oleh pihak ketiga seperti pengiklan dan perusahaan analitik.
protections-panel-cryptominers = Penambang kripto menggunakan kekuatan komputasi sistem Anda untuk menambang uang digital. Skrip penambangan kripto menguras baterai Anda, memperlambat komputer Anda, dan dapat meningkatkan tagihan listrik Anda.
protections-panel-fingerprinters = Pelacak sidik mengumpulkan pengaturan dari browser dan komputer Anda untuk membuat profil tentang Anda. Dengan menggunakan pelacak sidik digital ini, mereka dapat melacak Anda di berbagai situs web.
protections-panel-tracking-content = Situs web dapat memuat iklan eksternal, video, dan konten lainnya dengan kode pelacakan. Pemblokiran konten pelacak dapat membantu situs dimuat lebih cepat, tetapi beberapa tombol, formulir, dan bidang info masuk mungkin tidak berfungsi.
protections-panel-social-media-trackers = Situs jejaring sosial menempatkan pelacak di situs web lain untuk mengikuti apa yang Anda lakukan, lihat, dan tonton secara daring. Ini memungkinkan perusahaan media sosial untuk belajar lebih banyak tentang Anda, di luar apa yang Anda bagikan di profil media sosial Anda.
protections-panel-description-shim-allowed = Beberapa pelacak yang ditandai di bawah telah diblokir sebagian pada laman ini karena Anda berinteraksi dengan mereka.
protections-panel-description-shim-allowed-learn-more = Pelajari lebih lanjut
protections-panel-shim-allowed-indicator =
    .tooltiptext = Pelacak sebagian tidak diblokir
protections-panel-content-blocking-manage-settings =
    .label = Kelola Setelan Perlindungan
    .accesskey = K
protections-panel-content-blocking-breakage-report-view =
    .title = Laporkan Situs yang Rusak
protections-panel-content-blocking-breakage-report-view-description = Pemblokiran pelacak tertentu bisa menyebabkan beberapa situs web tidak berfungsi dengan baik. Saat Anda melaporkan masalahnya, Anda membantu agar { -brand-short-name } menjadi lebih baik bagi semua orang. Pengiriman laporan ini akan mengirimkan URL serta informasi tentang pengaturan peramban Anda ke Mozilla. <label data-l10n-name="learn-more">Pelajari lebih lanjut</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = Opsional: Jelaskan masalahnya
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Opsional: Jelaskan masalahnya
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Batal
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Kirim Laporan
