# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Sorun giderme bilgileri
page-subtitle = Bu sayfa, bir sorunu gidermeye çalışırken işinize yarabilecek teknik bilgiler içerir. { -brand-short-name } hakkında genel sorularla ilgili yanıt arıyorsanız <a data-l10n-name="support-link">destek sitemizi</a> ziyaret edin.
crashes-title = Çökme Raporları
crashes-id = Rapor numarası
crashes-send-date = Gönderilme tarihi
crashes-all-reports = Tüm çökme raporları
crashes-no-config = Bu uygulama, çökme raporlarını görüntülemek için yapılandırılmamış.
extensions-title = Uzantılar
extensions-name = Adı
extensions-enabled = Etkin mi?
extensions-version = Sürüm
extensions-id = Kimlik
support-addons-title = Eklentiler
support-addons-name = Adı
support-addons-type = Tür
support-addons-enabled = Etkin
support-addons-version = Sürüm
support-addons-id = Kimlik
security-software-title = Güvenlik yazılımları
security-software-type = Türü
security-software-name = Adı
security-software-antivirus = Antivirüs
security-software-antispyware = Antispyware
security-software-firewall = Güvenlik duvarı
features-title = { -brand-short-name } özellikleri
features-name = Adı
features-version = Sürüm
features-id = Kimlik
processes-title = Uzak işlemler
processes-type = Tür
processes-count = Sayaç
app-basics-title = Uygulama temelleri
app-basics-name = Adı
app-basics-version = Sürüm
app-basics-build-id = Yapı numarası
app-basics-distribution-id = Dağıtım kimliği
app-basics-update-channel = Güncelleme kanalı
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Güncelleme dizini
       *[other] Güncelleme klasörü
    }
app-basics-update-history = Güncelleme geçmişi
app-basics-show-update-history = Güncelleme geçmişini göster
# Represents the path to the binary used to start the application.
app-basics-binary = Çalıştırılabilir uygulama dosyası
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Profil dizini
       *[other] Profil klasörü
    }
app-basics-enabled-plugins = Devredeki yan uygulamalar
app-basics-build-config = Yapılandırma
app-basics-user-agent = Kullanıcı istemcisi
app-basics-os = İşletim sistemi
app-basics-memory-use = Bellek kullanımı
app-basics-performance = Performans
app-basics-service-workers = Kayıtlı Service Worker'lar
app-basics-profiles = Profiller
app-basics-launcher-process-status = Başlatıcı işlemi
app-basics-multi-process-support = Çok işlemli pencereler
app-basics-remote-processes-count = Uzak işlemler
app-basics-enterprise-policies = Kurumsal ilkeler
app-basics-location-service-key-google = Google Konum Hizmeti anahtarı
app-basics-safebrowsing-key-google = Google Safebrowsing anahtarı
app-basics-key-mozilla = Mozilla Konum Hizmeti anahtarı
app-basics-safe-mode = Güvenli kip
show-dir-label =
    { PLATFORM() ->
        [macos] Finder'da göster
        [windows] Klasörü aç
       *[other] Dizini aç
    }
environment-variables-title = Ortam değişkenleri
environment-variables-name = Adı
environment-variables-value = Değer
experimental-features-title = Deneysel özellikler
experimental-features-name = Adı
experimental-features-value = Değer
modified-key-prefs-title = Değiştirilmiş önemli tercihler
modified-prefs-name = Adı
modified-prefs-value = Değer
user-js-title = user.js tercihleri
user-js-description = Profil klasörünüz { -brand-short-name } tarafından oluşturulmamış tercihler içeren bir <a data-l10n-name="user-js-link">user.js dosyası</a> içeriyor.
locked-key-prefs-title = Kilitlenmiş önemli tercihler
locked-prefs-name = Adı
locked-prefs-value = Değer
graphics-title = Grafikler
graphics-features-title = Özellikler
graphics-diagnostics-title = Tanılama
graphics-failure-log-title = Hata günlüğü
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Karar günlüğü
graphics-crash-guards-title = Çökme koruyucusu tarafından kapatılan özellikler
graphics-workarounds-title = Çözümler
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Pencere protokolü
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Masaüstü ortamı
place-database-title = Places veritabanı
place-database-integrity = Bütünlük
place-database-verify-integrity = Bütünlüğü doğrula
a11y-title = Erişilebilirlik
a11y-activated = Etkinleştirildi mi?
a11y-force-disabled = Erişilebilirliği engelle
a11y-handler-used = Erişilebilir işleyici kullanımı
a11y-instantiator = Erişilebilirlik temsilcisi
library-version-title = Kitaplık sürümleri
copy-text-to-clipboard-label = Metni panoya kopyala
copy-raw-data-to-clipboard-label = Ham metni panoya kopyala
sandbox-title = Kum havuzu
sandbox-sys-call-log-title = Reddedilen sistem çağrıları
sandbox-sys-call-index = #
sandbox-sys-call-age = saniye önce
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = İşlem türü
sandbox-sys-call-number = Sistem çağrısı
sandbox-sys-call-args = Parametreler
safe-mode-title = Güvenli kipi deneyin
restart-in-safe-mode-label = Eklentileri devre dışı bırakıp yeniden başlat…
clear-startup-cache-title = Başlangıç önbelleğini temizlemeyi deneyin
clear-startup-cache-label = Başlangıç önbelleğini temizle…
startup-cache-dialog-title = Başlangıç önbelleğini temizle
startup-cache-dialog-body = Başlangıç önbelleğini temizlemek için { -brand-short-name } tarayıcınızı yeniden başlatın. Bu işlem, ayarlarınızı değiştirmez ve mevcut eklentilerinizi kaldırmaz.
restart-button-label = Yeniden başlat

## Media titles

audio-backend = Ses arka ucu
max-audio-channels = En fazla kanal
sample-rate = Tercih edilen örnek oranı
roundtrip-latency = Gidiş dönüş gecikmesi (standart sapma)
media-title = Ortam
media-output-devices-title = Çıktı cihazları
media-input-devices-title = Girdi cihazları
media-device-name = Adı
media-device-group = Grup
media-device-vendor = Sağlayıcı
media-device-state = Durumu
media-device-preferred = Tercih edilen
media-device-format = Biçim
media-device-channels = Kanallar
media-device-rate = Oran
media-device-latency = Gecikme
media-capabilities-title = Çoku ortam yetenekleri
# List all the entries of the database.
media-capabilities-enumerate = Veritabanını numaralandır

##

intl-title = Uluslararasılaştırma ve yerelleştirme
intl-app-title = Uygulama ayarları
intl-locales-requested = İstenen diller
intl-locales-available = Mevcut diller
intl-locales-supported = Uygulama dilleri
intl-locales-default = Varsayılan dil
intl-os-title = İşletim sistemi
intl-os-prefs-system-locales = Sistem dilleri
intl-regional-prefs = Bölgesel tercihler

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Uzaktan hata ayıklama (Chromium protokolü)
remote-debugging-accepting-connections = Bağlantılar kabul ediliyor mu?
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Son { $days } günün çökme raporları
       *[other] Son { $days } günün çökme raporları
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } dakika önce
       *[other] { $minutes } dakika önce
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } saat önce
       *[other] { $hours } saat önce
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } gün önce
       *[other] { $days } gün önce
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Tüm çökme raporları (belirtilen zaman aralığındaki { $reports } bekleyen çökme dahil)
       *[other] Tüm çökme raporları (belirtilen zaman aralığındaki { $reports } bekleyen çökme dahil)
    }
raw-data-copied = Ham veriler panoya kopyalandı
text-copied = Metin panoya kopyalandı

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Grafik kartı sürücüsü sürümünüz için engellenmiştir.
blocked-gfx-card = Çözülemeyen sürücü sorunları nedeniyle grafik kartınız için engellenmiştir.
blocked-os-version = İşletim sistemi sürümünüz için engellenmiştir.
blocked-mismatched-version = Kayıt defteriyle DLL arasındaki grafik sürücüsü uyumsuzluğunuz nedeniyle engellendi.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Grafik kartı sürücüsü sürümünüz için engellenmiştir. Grafik kartı sürücünüzü { $driverVersion } veya daha yeni bir sürüme güncellemeyi deneyin.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType parametreleri
compositing = Çizici
hardware-h264 = Donanımsal H264 çözme
main-thread-no-omtc = ana işlem parçacığı, OMTC yok
yes = Evet
no = Hayır
unknown = Bilinmiyor
virtual-monitor-disp = Sanal monitör ekranı

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Bulundu
missing = Eksik
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Tanım
gpu-vendor-id = Satıcı numarası
gpu-device-id = Aygıt numarası
gpu-subsys-id = Subsys numarası
gpu-drivers = Sürücüler
gpu-ram = RAM
gpu-driver-vendor = Sürücü sağlayıcı
gpu-driver-version = Sürücü sürümü
gpu-driver-date = Sürücü tarihi
gpu-active = Etkin
webgl1-wsiinfo = WebGL 1 sürücü WSI bilgileri
webgl1-renderer = WebGL 1 sürücü renderer'ı
webgl1-version = WebGL 1 sürücü sürümü
webgl1-driver-extensions = WebGL 1 sürücü uzantıları
webgl1-extensions = WebGL 1 uzantıları
webgl2-wsiinfo = WebGL 2 sürücü WSI bilgileri
webgl2-renderer = WebGL2 çizici
webgl2-version = WebGL 2 sürücü sürümü
webgl2-driver-extensions = WebGL 2 sürücü uzantıları
webgl2-extensions = WebGL 2 uzantıları
blocklisted-bug = Bilinen sorunlar nedeniyle engellendi
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = bug { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Bilinen sorunlar nedeniyle engellendi: <a data-l10n-name="bug-link">bug { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Engellendi. Hata kodu { $failureCode }
d3d11layers-crash-guard = D3D11 Compositor
d3d11video-crash-guard = D3D11 Video Çözücüsü
d3d9video-crash-guard = D3D9 Video Çözücüsü
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX video çözücüsü
reset-on-next-restart = Sonraki yeniden başlatmada sıfırla
gpu-process-kill-button = GPU işlemini sonlandır
gpu-device-reset = Aygıtı sıfırla
gpu-device-reset-button = Aygıt sıfırlamayı tetikle
uses-tiling = Tiling kullanımı
content-uses-tiling = Tiling kullanımı (içerik)
off-main-thread-paint-enabled = Off main thread painting etkin
off-main-thread-paint-worker-count = Off main thread painting işçi sayısı
target-frame-rate = Hedef kare hızı
min-lib-versions = Beklenen minimum sürüm
loaded-lib-versions = Kullanılan sürüm
has-seccomp-bpf = Seccomp-BPF (sistem çağrısı filtreleme)
has-seccomp-tsync = Seccomp işlem senkronizasyonu
has-user-namespaces = Kullanıcı isim uzayları
has-privileged-user-namespaces = Ayrıcalıklı işlemler için kullanıcı isim uzayları
can-sandbox-content = İçerik işlemi kum havuzu
can-sandbox-media = Medya yan uygulaması kum havuzu
content-sandbox-level = İçerik işlemi kum havuzu düzeyi
effective-content-sandbox-level = Etkin içerik işlemi kum havuzu düzeyi
sandbox-proc-type-content = içerik
sandbox-proc-type-file = dosya içeriği
sandbox-proc-type-media-plugin = ortam yan uygulaması
sandbox-proc-type-data-decoder = veri çözücü
startup-cache-title = Başlangıç önbelleği
startup-cache-disk-cache-path = Disk önbellek yolu
startup-cache-ignore-disk-cache = Disk önbelleğini yok say
startup-cache-found-disk-cache-on-init = Başlangıçta disk önbelleği bulundu
startup-cache-wrote-to-disk-cache = Disk önbelleğine yazıldı
launcher-process-status-0 = Etkin
launcher-process-status-1 = Hata nedeniyle devre dışı
launcher-process-status-2 = Zorla devre dışı bırakıldı
launcher-process-status-unknown = Bilinmeyen durum
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = kullanıcı tarafından etkinleştirildi
multi-process-status-1 = Varsayılan olarak etkin
multi-process-status-2 = Devre dışı
multi-process-status-4 = Erişilebilirlik araçları tarafından devre dışı bırakıldı
multi-process-status-6 = Desteklenmeyen metin girdisi tarafından devre dışı bırakıldı
multi-process-status-7 = Eklentiler tarafından devre dışı bırakıldı
multi-process-status-8 = Zorla devre dışı bırakıldı
multi-process-status-unknown = Bilinmeyen durum
async-pan-zoom = Asenkron kaydır/yakınlaştır
apz-none = yok
wheel-enabled = tekerlek girdisi etkin
touch-enabled = dokunma girdisi etkin
drag-enabled = kaydırma çubuğu sürükleme etkin
keyboard-enabled = klavye etkin
autoscroll-enabled = otomatik kaydırma etkin
zooming-enabled = yumuşak pinch-zoom etkin

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = desteklenmeyen tercih nedeniyle asenkron tekerlek girdisi devre dışı bırakıldı: { $preferenceKey }
touch-warning = desteklenmeyen tercih nedeniyle asenkron dokunma girdisi devre dışı bırakıldı: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Pasif
policies-active = Aktif
policies-error = Hata
