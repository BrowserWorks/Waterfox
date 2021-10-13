# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Pengaturan Profiler
perftools-intro-description =
    Perekaman akan membuka profiler.firefox.com di tab baru. Semua data disimpan
    secara lokal, tetapi Anda bisa memilih untuk mengunggahnya untuk dibagikan.

## All of the headings for the various sections.

perftools-heading-settings = Pengaturan Lengkap
perftools-heading-buffer = Pengaturan Buffer
perftools-heading-features = Fitur
perftools-heading-features-default = Fitur (Direkomendasikan secara baku)
perftools-heading-features-disabled = Fitur Dinonaktifkan
perftools-heading-features-experimental = Eksperimental
perftools-heading-threads = Thread
perftools-heading-local-build = Build lokal

##

perftools-description-intro =
    Perekaman akan membuka <a>profiler.firefox.com</a> di tab baru. Semua data disimpan
    secara lokal, tetapi Anda bisa memilih untuk mengunggahnya untuk dibagikan.
perftools-description-local-build =
    Jika Anda membuat profil untuk sebuah build yang telah Anda kompilasi sendiri, di mesin
    ini, tambahkan objdir build Anda ke daftar di bawah ini agar dapat digunakan untuk mencari informasi simbol.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Interval pengambilan sampel:
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } md

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Ukuran buffer:

perftools-custom-threads-label = Tambahkan thread khusus berdasarkan nama:

perftools-devtools-interval-label = Interval:
perftools-devtools-threads-label = Thread:
perftools-devtools-settings-label = Pengaturan

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    Profiler dinonaktifkan saat Penjelajahan Pribadi diaktifkan.
    Tutup semua Jendela Pribadi untuk mengaktifkan kembali profiler
perftools-status-recording-stopped-by-another-tool = Rekaman dihentikan oleh alat lain.
perftools-status-restart-required = Peramban harus dimulai ulang untuk mengaktifkan fitur ini.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Menghentikan perekaman
perftools-request-to-get-profile-and-stop-profiler = Menangkap profil

##

perftools-button-start-recording = Mulai merekam
perftools-button-capture-recording = Rekam
perftools-button-cancel-recording = Batalkan perekaman
perftools-button-save-settings = Simpan pengaturan dan kembali
perftools-button-restart = Mulai Ulang
perftools-button-add-directory = Tambahkan direktori
perftools-button-remove-directory = Hapus yang dipilih
perftools-button-edit-settings = Edit Pengaturan…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = Proses utama untuk proses induk dan proses konten
perftools-thread-compositor =
    .title = Menggabungkan berbagai elemen yang digambar pada laman
perftools-thread-dom-worker =
    .title = Ini menangani web worker dan service worker
perftools-thread-renderer =
    .title = Saat WebRender diaktifkan, thread yang menjalankan panggilan OpenGL
perftools-thread-render-backend =
    .title = Thread RenderBackend WebRender
perftools-thread-paint-worker =
    .title = Saat proses painting di luar utas utama diaktifkan, utas tempat proses painting terjadi
perftools-thread-style-thread =
    .title = Komputasi gaya dibagi menjadi beberapa thread
pref-thread-stream-trans =
    .title = Transportasi aliran jaringan
perftools-thread-socket-thread =
    .title = Thread tempat kode jaringan menjalankan panggilan semua soket pemblokiran
perftools-thread-img-decoder =
    .title = Thread dekode gambar
perftools-thread-dns-resolver =
    .title = Resolusi DNS terjadi di thread ini

##

perftools-record-all-registered-threads = Lewati pilihan di atas dan rekam semua utas yang terdaftar

perftools-tools-threads-input-label =
    .title = Nama utas ini berupa daftar yang dipisahkan karakter koma, yang akan digunakan untuk mengaktifkan profiling utas pada profiler. Pencocokan nama juga akan dilakukan secara bagian, tidak secara lengkap pada utas yang disertakan. Karakter spasi pada nama berpengaruh.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

perftools-onboarding-message = <b>Baru</b>: { -profiler-brand-name } telah diintegrasikan ke dalam Alat Pengembang. <a>Pelajari lebih lanjut</a> tentang alat baru yang canggih ini.

# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (Untuk waktu yang terbatas, Anda dapat mengakses panel Kinerja lawas melalui <a>{ options-context-advanced-settings }</a>)

perftools-onboarding-close-button =
    .aria-label = Tutup pesan orientasi
