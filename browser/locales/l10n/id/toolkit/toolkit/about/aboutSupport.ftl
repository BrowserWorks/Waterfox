# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Informasi Pemecahan Masalah
page-subtitle = Laman ini berisi informasi teknis yang mungkin berguna ketika Anda berusaha mengatasi masalah. Jika Anda mencari jawaban untuk pertanyaan umum tentang { -brand-short-name }, silakan kunjungi <a data-l10n-name="support-link">situs web layanan dukungan kami</a>.

crashes-title = Laporan Kerusakan
crashes-id = ID Laporan
crashes-send-date = Dikirim
crashes-all-reports = Semua Laporan Kerusakan
crashes-no-config = Aplikasi ini tidak dikonfigurasikan untuk menampilkan laporan kerusakan.
support-addons-title = Pengaya
support-addons-name = Nama
support-addons-type = Tipe
support-addons-enabled = Diaktifkan
support-addons-version = Versi
support-addons-id = ID
security-software-title = Perangkat Lunak Keamanan
security-software-type = Jenis
security-software-name = Nama
security-software-antivirus = Antivirus
security-software-antispyware = Antiperangkatpengintai
security-software-firewall = Tembok Api
features-title = Fitur { -brand-short-name }
features-name = Nama
features-version = Versi
features-id = ID
processes-title = Proses Jarak Jauh
processes-type = Tipe
processes-count = Jumlah
app-basics-title = Informasi Dasar Aplikasi
app-basics-name = Nama
app-basics-version = Versi
app-basics-build-id = ID Build
app-basics-distribution-id = ID Distribusi
app-basics-update-channel = Kanal Pemutakhiran
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Pemutakhiran Direktori
       *[other] Pemutakhiran Folder
    }
app-basics-update-history = Riwayat Pemutakhiran
app-basics-show-update-history = Tampilkan Riwayat Pemutakhiran
# Represents the path to the binary used to start the application.
app-basics-binary = Biner Aplikasi
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Direktori Profil
       *[other] Folder Profil
    }
app-basics-enabled-plugins = Plugin Terpasang
app-basics-build-config = Konfigurasi Build
app-basics-user-agent = User Agent
app-basics-os = OS
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = Rosetta Translated
app-basics-memory-use = Penggunaan Memori
app-basics-performance = Kinerja
app-basics-service-workers = Service Worker Terdaftar
app-basics-profiles = Profil
app-basics-launcher-process-status = Proses Peluncur
app-basics-multi-process-support = Jendela Multiproses
app-basics-fission-support = Jendela Fission
app-basics-remote-processes-count = Proses Jarak Jauh
app-basics-enterprise-policies = Kebijakan Perusahaan
app-basics-location-service-key-google = Google Location Service Key
app-basics-safebrowsing-key-google = Google Safebrowsing Key
app-basics-key-mozilla = Kunci Layanan Lokasi Waterfox
app-basics-safe-mode = Mode Aman
show-dir-label =
    { PLATFORM() ->
        [macos] Tampilkan di Finder
        [windows] Buka Folder
       *[other] Buka Direktori
    }
environment-variables-title = Variabel Lingkungan
environment-variables-name = Nama
environment-variables-value = Nilai
experimental-features-title = Fitur Eksperimental
experimental-features-name = Nama
experimental-features-value = Nilai
modified-key-prefs-title = Pengaturan Penting yang Diubah
modified-prefs-name = Nama
modified-prefs-value = Nilai
user-js-title = Preferensi user.js
user-js-description = Folder profil Anda berisi sebuah <a data-l10n-name="user-js-link">berkas user.js</a>, yang berisi data preferensi yang tidak diciptakan oleh { -brand-short-name }.
locked-key-prefs-title = Preferensi Penting yang Dikunci
locked-prefs-name = Nama
locked-prefs-value = Nilai
graphics-title = Grafik
graphics-features-title = Fitur
graphics-diagnostics-title = Diagnostik
graphics-failure-log-title = Log Kegagalan
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Log Keputusan
graphics-crash-guards-title = Fitur Penjaga Kerusakan yang Dinonaktifkan
graphics-workarounds-title = Solusi sementara
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Protokol Jendela
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Lingkungan Desktop
place-database-title = Basis Data Places
place-database-integrity = Integritas
place-database-verify-integrity = Verifikasikan Integritas
a11y-title = Aksesibilitas
a11y-activated = Aktif
a11y-force-disabled = Aksesibilitas Dicegah
a11y-handler-used = Penanganan Terakses Digunakan
a11y-instantiator = Accessibility Instantiator
library-version-title = Versi Pustaka
copy-text-to-clipboard-label = Salin teks ke papan klip
copy-raw-data-to-clipboard-label = Salin data mentah ke papan klip
sandbox-title = Sandbox
sandbox-sys-call-log-title = Panggilan Sistem yang Tertolak
sandbox-sys-call-index = #
sandbox-sys-call-age = Detik Lalu
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Jenis Proses
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Argumen

troubleshoot-mode-title = Diagnosis masalah
restart-in-troubleshoot-mode-label = Mode Pemecahan Masalah…
clear-startup-cache-title = Coba bersihkan tembolok permulaan
clear-startup-cache-label = Hapus tembolok permulaan...
startup-cache-dialog-title2 = Mulai ulang { -brand-short-name } untuk membersihkan tembolok mulai?
startup-cache-dialog-body2 = Ini tidak akan mengubah pengaturan Anda atau menghapus ekstensi.
restart-button-label = Mulai Ulang

## Media titles

audio-backend = Backend Audio
max-audio-channels = Kanal Maksimal
sample-rate = Tingkat Sampel Pilihan
roundtrip-latency = Roundtrip latency (standar deviasi)
media-title = Media
media-output-devices-title = Peranti Keluaran
media-input-devices-title = Peranti Masukan
media-device-name = Nama
media-device-group = Grup
media-device-vendor = Vendor
media-device-state = Provinsi
media-device-preferred = Disukai
media-device-format = Format
media-device-channels = Kanal
media-device-rate = Nilai
media-device-latency = Latensi
media-capabilities-title = Kemampuan Media
# List all the entries of the database.
media-capabilities-enumerate = Daftar basis data

##

intl-title = Pelokalan dan Internasional
intl-app-title = Setelan Aplikasi
intl-locales-requested = Bahasa yang Diminta
intl-locales-available = Bahasa yang Tersedia
intl-locales-supported = Bahasa Aplikasi
intl-locales-default = Bahasa Baku
intl-os-title = Sistem Operasi
intl-os-prefs-system-locales = Bahasa Sistem
intl-regional-prefs = Pengaturan Regional

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Debugging Jarak Jauh (Protokol Chromium)
remote-debugging-accepting-connections = Menerima Koneksi
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days = Laporan Kerusakan dalam { $days } Hari Terakhir

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes = { $minutes } menit yang lalu

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours = { $hours } jam yang lalu

# Variables
# $days (integer) - Number of days since crash
crashes-time-days = { $days } hari yang lalu

# Variables
# $reports (integer) - Number of pending reports
pending-reports = Semua Laporan Kerusakan (termasuk { $reports } kerusakan yang tertunda pada rentang waktu yang ditentukan)

raw-data-copied = Data mentah telah disalin ke papan klip
text-copied = Teks telah disalin ke clipboard

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Diblokir untuk versi penggerak grafik Anda.
blocked-gfx-card = Diblokir untuk kartu grafik Anda karena masalah pada penggerak yang tidak bisa diatasi.
blocked-os-version = Diblokir untuk versi sistem operasi Anda.
blocked-mismatched-version = Diblokir karena versi driver kartu grafis Anda tidak cocok antara registry dan DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Diblokir untuk versi penggerak grafik Anda. Coba perbarui penggerak grafik Anda ke versi { $driverVersion } atau yang lebih baru.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parameter ClearType

compositing = Compositing
hardware-h264 = Dekode H264 Perangkat Keras
main-thread-no-omtc = thread utama, tanpa OMTC
yes = Ya
no = Tidak
unknown = Tidak diketahui
virtual-monitor-disp = Layar Monitor Virtual

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Ditemukan
missing = Hilang

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Deskripsi
gpu-vendor-id = ID Vendor
gpu-device-id = ID Perangkat
gpu-subsys-id = ID Subsistem
gpu-drivers = Driver
gpu-ram = RAM
gpu-driver-vendor = Vendor Driver
gpu-driver-version = Versi Penggerak
gpu-driver-date = Tanggal Penggerak
gpu-active = Aktif
webgl1-wsiinfo = Info WSI Penggerak WebGL 1
webgl1-renderer = Perender Penggerak WebGL 1
webgl1-version = Versi Penggerak WebGL 1
webgl1-driver-extensions = Ekstensi Penggerak WebGL 1
webgl1-extensions = Ekstensi WebGL 1
webgl2-wsiinfo = Info WSI Penggerak WebGL 2
webgl2-renderer = Perender WebGL2
webgl2-version = Versi Penggerak WebGL 2
webgl2-driver-extensions = Ekstensi Penggerak WebGL 2
webgl2-extensions = Ekstensi WebGL 2

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Dicekal karena masalah yang diketahui: <a data-l10n-name="bug-link">bug { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Dicekal: kode kegagalan { $failureCode }

d3d11layers-crash-guard = Compositor D3D11
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX Video Decoder

reset-on-next-restart = Setel Ulang pada Mulai Ulang Berikutnya
gpu-process-kill-button = Matikan Proses GPU
gpu-device-reset = Reset Perangkat
gpu-device-reset-button = Picu Pengaturan Ulang Perangkat
uses-tiling = Gunakan Tiling
content-uses-tiling = Gunakan Tiling (Konten)
off-main-thread-paint-enabled = Off Main Thread Painting Diaktifkan
off-main-thread-paint-worker-count = Jumlah Off Main Thread Painting Worker
target-frame-rate = Tingkat Target Bingkai

min-lib-versions = Versi minimum diharapkan
loaded-lib-versions = Versi yang digunakan

has-seccomp-bpf = Seccomp-BPF (Pemfilteran Pemanggilan Sistem - System Call Filtering)
has-seccomp-tsync = Sinkronisasi Utas Seccomp
has-user-namespaces = Ruang Nama Pengguna
has-privileged-user-namespaces = Ruang Nama Pengguna untuk proses istimewa
can-sandbox-content = Sandbox Proses Konten
can-sandbox-media = Media Plugin Sandboxing
content-sandbox-level = Tingkat Proses Konten Sandbox
effective-content-sandbox-level = Tingkat Sandbox Proses Konten Efektif
content-win32k-lockdown-state = Status Penguncian Win32k untuk Proses Konten
sandbox-proc-type-content = konten
sandbox-proc-type-file = konten berkas
sandbox-proc-type-media-plugin = plugin media
sandbox-proc-type-data-decoder = dekoder data

startup-cache-title = Tembolok Permulaan
startup-cache-disk-cache-path = Jalur Tembolok Disk
startup-cache-ignore-disk-cache = Abaikan Tembolok Disk
startup-cache-found-disk-cache-on-init = Tembolok Disk di Init ditemukan
startup-cache-wrote-to-disk-cache = Menulis ke Tembolok Disk

launcher-process-status-0 = Diaktifkan
launcher-process-status-1 = Dinonaktifkan karena kegagalan
launcher-process-status-2 = Dinonaktifkan secara paksa
launcher-process-status-unknown = Status tak diketahui

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }

# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = Dinonaktifkan oleh eksperimen
fission-status-experiment-treatment = Diaktifkan oleh eksperimen
fission-status-disabled-by-e10s-env = Dinonaktifkan oleh lingkungan
fission-status-enabled-by-env = Diaktifkan oleh lingkungan
fission-status-disabled-by-safe-mode = Dinonaktifkan oleh mode aman
fission-status-enabled-by-default = Diaktifkan secara baku
fission-status-disabled-by-default = Dinonaktifkan secara baku
fission-status-enabled-by-user-pref = Diaktifkan oleh pengguna
fission-status-disabled-by-user-pref = Dinonaktifkan oleh pengguna
fission-status-disabled-by-e10s-other = E10s dinonaktifkan

async-pan-zoom = Geser/Perbesaran Asinkron
apz-none = tidak ada
wheel-enabled = input wheel diaktifkan
touch-enabled = input sentuh diaktifkan
drag-enabled = penyeretan bilah penggulung aktif
keyboard-enabled = papan tik diaktifkan
autoscroll-enabled = gulir otomatis diaktifkan
zooming-enabled = pinch-zoom halus diaktifkan

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = input wheel asinkron dinonaktifkan karena preferensi yang tidak didukung: { $preferenceKey }
touch-warning = input sentuh asinkron dinonaktifkan karena preferensi yang tidak didukung: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Tidak Aktif
policies-active = Aktif
policies-error = Galat

## Printing section

support-printing-title = Pencetakan
support-printing-troubleshoot = Pemecahan Masalah
support-printing-clear-settings-button = Bersihkan setelan cetak tersimpan
support-printing-modified-settings = Pengaturan cetak yang diubah
support-printing-prefs-name = Nama
support-printing-prefs-value = Nilai

## Normandy sections

support-remote-experiments-title = Eksperimen Jarak Jauh
support-remote-experiments-name = Nama
support-remote-experiments-branch = Cabang Eksperimen
support-remote-experiments-see-about-studies = Lihat <a data-l10n-name="support-about-studies-link">about:studies</a> untuk informasi lebih lanjut, termasuk cara menonaktifkan masing-masing percobaan atau menonaktifkan { -brand-short-name } untuk menjalankan jenis eksperimen ini di masa mendatang.

support-remote-features-title = Fitur Jarak Jauh
support-remote-features-name = Nama
support-remote-features-status = Status
