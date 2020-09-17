# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Maklumat Pencarisilapan
page-subtitle =
    Halaman ini mengandungi maklumat teknikal yang mungkin berguna apabila anda
    cuba menyelesaikan masalah. Jika anda mencari jawapan soalan lazim
    berkenaan { -brand-short-name }, semak di <a data-l10n-name="support-link">support website</a>.

crashes-title = Laporan Ranap
crashes-id = ID Laporan
crashes-send-date = Dihantar
crashes-all-reports = Semua Laporan Ranap
crashes-no-config = APlikasi ini tidak dikonfigurkan untuk memaparkan laporan nahas.
extensions-title = Ekstensi
extensions-name = Nama
extensions-enabled = Didayakan
extensions-version = Versi
extensions-id = ID
support-addons-name = Nama
support-addons-version = Versi
support-addons-id = ID
security-software-title = Perisian Keselamatan
security-software-type = Jenis
security-software-name = Nama
security-software-antivirus = Anti-virus
security-software-antispyware = Anti-perisian pengintip
security-software-firewall = Firewall
features-title = Ciri { -brand-short-name }
features-name = Nama
features-version = Versi
features-id = ID
app-basics-title = Asas Aplikasi
app-basics-name = Nama
app-basics-version = Versi
app-basics-build-id = ID Binaan
app-basics-update-channel = Saluran Kemaskini
app-basics-update-history = Sejarah Kemaskini
app-basics-show-update-history = Papar Sejarah Kemaskini
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Direktori Profil
       *[other] Folder Profil
    }
app-basics-enabled-plugins = Dayakan Plugins
app-basics-build-config = Konfigurasi Binaan
app-basics-user-agent = Ejen pengguna
app-basics-os = OS
app-basics-memory-use = Kegunaan Memori
app-basics-performance = Prestasi
app-basics-service-workers = Service Workers Berdaftar
app-basics-profiles = Profil
app-basics-multi-process-support = Tetingkap Multiproses
app-basics-enterprise-policies = Polisi Syarikat
app-basics-key-mozilla = Mozilla Location Service Key
app-basics-safe-mode = Mod Selamat
show-dir-label =
    { PLATFORM() ->
        [macos] Papar dalam Finder
        [windows] Buka Folder
       *[other] Buka Direktori
    }
modified-key-prefs-title = Pengubahan rujukan pilihan yang penting
modified-prefs-name = Nama
modified-prefs-value = Nilai
user-js-title = Keutamaan user.js
user-js-description = Profil folder anda mengandungi satu <a data-l10n-name="user-js-link">fail user.js</a>, dimana termasuk tetapan yang tidak dilakukan oleh { -brand-short-name } .
locked-key-prefs-title = Keutamaan Terkunci Yang Penting
locked-prefs-name = Nama
locked-prefs-value = Nilai
graphics-title = Grafik
graphics-features-title = Ciri
graphics-diagnostics-title = Diagnostik
graphics-failure-log-title = Log Kegagalan
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Log Keputusan
graphics-crash-guards-title = Ciri Crash Guard Dinyahdayakan
graphics-workarounds-title = Workarounds
place-database-title = Tempat Pangkalan Data
place-database-integrity = Integriti
place-database-verify-integrity = Sahkan Integriti
a11y-title = Ketercapaian
a11y-activated = Diaktifkan
a11y-force-disabled = Halang Ketercapaian
a11y-handler-used = Menggunakan Accessible Handler
a11y-instantiator = Penyegera Ketercapaian
library-version-title = Versi Pustaka
copy-text-to-clipboard-label = Salin teks ke klipbod
copy-raw-data-to-clipboard-label = Salin data mentah kepada klipbod
sandbox-title = Sandbox
sandbox-sys-call-log-title = Rejected System Calls
sandbox-sys-call-index = #
sandbox-sys-call-age = Beberapa Saat Lepas
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Jenis Proses
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Arguments
safe-mode-title = Cuba Mod Selamat
restart-in-safe-mode-label = Mula semula dengan Add-ons Dinyahdayakan…

## Media titles

audio-backend = Backend Audio
max-audio-channels = Saluran Max
sample-rate = Kadar Sampel Diutamakan
media-title = Media
media-output-devices-title = Peranti Output
media-input-devices-title = Peranti Input
media-device-name = Nama
media-device-group = Kumpulan
media-device-vendor = Pembekal
media-device-state = Negara
media-device-preferred = Diutamakan
media-device-format = Format
media-device-channels = Saluran
media-device-rate = Kadar
media-device-latency = Kependaman

##

intl-title = Pengantarabangsaan & Lokalisasi
intl-app-title = Tetapan Aplikasi
intl-locales-requested = Lokaliti Diminta
intl-locales-available = Lokaliti Tersedia
intl-locales-supported = Lokaliti Aplikasi
intl-locales-default = Lokaliti Piawai
intl-os-title = Sistem Pengoperasian
intl-os-prefs-system-locales = Lokaliti Sistem
intl-regional-prefs = Keutamaan Wilayah

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/


##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days = Laporan Ranap untuk { $days } Hari Terakhir

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes = { $minutes } minit yang lalu

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours = { $hours } jam yang lalu

# Variables
# $days (integer) - Number of days since crash
crashes-time-days = { $days } hari yang lalu

# Variables
# $reports (integer) - Number of pending reports
pending-reports = Semua Laporan Ranap (termasuk { $reports } ranap tertangguh dalam julat masa yang diberikan)

raw-data-copied = Data mentah telah disalin pada klipbod
text-copied = Teks disalin ke klipbod

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Disekat bagi versi pemacu grafik anda.
blocked-gfx-card = Disekat kerana isu pemacu kad grafik anda yang tidak dapat diselesaikan.
blocked-os-version = Disekat kerana versi sistem operasi anda.
blocked-mismatched-version = Disekat kerana versi pemacu grafik anda tidak sepadan dengan registry dan DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Disekat kerana versi pemacu grafik anda. Cuba kemaskini peranti grafik anda kepada versi { $driverVersion } atau yang terkini.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Parameter ClearType

compositing = Penggubahan
hardware-h264 = Perkakasan Penyahkodan H264
main-thread-no-omtc = rantaian utama, tidak OMTC
yes = Ya
no = Tidak

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Found
missing = Tiada

gpu-description = Keterangan
gpu-vendor-id = ID Vendor
gpu-device-id = ID Alatan
gpu-subsys-id = IS Subsys
gpu-drivers = Pemacu
gpu-ram = RAM
gpu-driver-version = Versi Pemacu
gpu-driver-date = Tarikh Pemacu
gpu-active = Aktif
webgl1-wsiinfo = WebGL 1 Driver WSI Info
webgl1-renderer = WebGL 1 Driver Renderer
webgl1-version = WebGL 1 Driver Version
webgl1-driver-extensions = WebGL 1 Driver Extensions
webgl1-extensions = WebGL 1 Extensions
webgl2-wsiinfo = WebGL 2 Driver WSI Info
webgl2-renderer = Pemapar WebGL2
webgl2-version = WebGL 2 Driver Version
webgl2-driver-extensions = WebGL 2 Driver Extensions
webgl2-extensions = WebGL 2 Extensions
blocklisted-bug = Disenarai-sekat oleh sebab isu-isu yang diketahui

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = pepijat { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Disenarai-sekat; kod kegagalan { $failureCode }

d3d11layers-crash-guard = Pengatur huruf D3D11
d3d11video-crash-guard = D3D11 Dekoder Video
d3d9video-crash-guard = Penyahkodan Video D3D9
glcontext-crash-guard = OpenGL

reset-on-next-restart = Set semula pada Mula semula yang Seterusnya
gpu-process-kill-button = Batalkan Proses GPU
gpu-device-reset-button = Set semula Trigger Device
uses-tiling = Menggunakan Jubin
content-uses-tiling = Guna Jubin (Kandungan)
off-main-thread-paint-enabled = Tutup Lukisan Thread Utama Didayakan
off-main-thread-paint-worker-count = Tutup Kiraan Main Thread Painting Worker

min-lib-versions = Versi minimum yang dijangka
loaded-lib-versions = Versi yang digunakan

has-seccomp-bpf = Seccomp-BPF (sistem panggil penapisan)
has-seccomp-tsync = Seccomp Thread Synchronization
has-user-namespaces = User Namespaces
has-privileged-user-namespaces = User Namespaces untuk keutamaan memproses
can-sandbox-content = Kandungan proses Sandboxing
can-sandbox-media = Media Plugin Sandboxing
content-sandbox-level = Content Process Sandbox Level
effective-content-sandbox-level = Effective Content Process Sandbox Level
sandbox-proc-type-content = kandungan
sandbox-proc-type-file = kandungan fail
sandbox-proc-type-media-plugin = media plugin

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Didayakan oleh pengguna
multi-process-status-1 = Didayakan mengikut piawai
multi-process-status-2 = Dinyahdayakan
multi-process-status-4 = Dinyahdayakan oleh alatan ketercapaian
multi-process-status-6 = Dinyahdayakan oleh input teks tidak disokong
multi-process-status-7 = Dinyahdayakan oleh add-ons
multi-process-status-8 = Dinyahdayakan secara paksa
multi-process-status-unknown = Status tidak diketahui

async-pan-zoom = Asynchronous Pan/Zoom
apz-none = tiada
wheel-enabled = input wheel didayakan
touch-enabled = input sentuh didayakan
drag-enabled = seret scrollbar didayakan
keyboard-enabled = papan kekunci didayakan
autoscroll-enabled = auto-skrol diaktifkan

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = async wheel input dinyahdaya kerana pref tidak disokong: { $preferenceKey }
touch-warning = async touch input dinyahdaya kerana pref tidak disokong: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Tidak aktif
policies-active = Aktif
policies-error = Ralat
