# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Мәселелерді шешу ақпараты
page-subtitle = Бұл парақта мәселелерді шешуде пайдалы бола алатын техникалық ақпарат бар. Егер сіз { -brand-short-name } туралы жалпы сұрақтарға жауапты іздесеңіз, біздің <a data-l10n-name="support-link">қолдау көрсету</a> сайтын шолыңыз.
crashes-title = Құлау туралы хабарлар
crashes-id = Хабарлама ID
crashes-send-date = Жіберілген
crashes-all-reports = Барлық құлау туралы хабарламалары
crashes-no-config = Бұл қолданба құлау хабарламаларын көрсетуге бапталмаған.
extensions-title = Кеңейтулер
extensions-name = Аты
extensions-enabled = Іске қосулы
extensions-version = Нұсқасы
extensions-id = ID
support-addons-title = Қосымшалар
support-addons-name = Аты
support-addons-type = Түрі
support-addons-enabled = Іске қосылған
support-addons-version = Нұсқасы
support-addons-id = ID
security-software-title = Қауіпсіздік БҚ-сы
security-software-type = Түрі
security-software-name = Аты
security-software-antivirus = Антивирус
security-software-antispyware = Антитыңшы
security-software-firewall = Желіаралық экран
features-title = { -brand-short-name } мүмкіндіктері
features-name = Аты
features-version = Нұсқасы
features-id = ID
processes-title = Қашықтағы үрдістер
processes-type = Түрі
processes-count = Саны
app-basics-title = Қолданба негіздері
app-basics-name = Аты
app-basics-version = Нұсқасы
app-basics-build-id = Жинақ ID-і
app-basics-distribution-id = Таратылым ID
app-basics-update-channel = Жаңарту арнасы
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Буманы жаңарту
       *[other] Буманы жаңарту
    }
app-basics-update-history = Жаңартулар тарихы
app-basics-show-update-history = Жаңартулар тарихын көрсету
# Represents the path to the binary used to start the application.
app-basics-binary = Қолданбаның бинарлы файлы
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Профайл бумасы
       *[other] Профиль сақталатын бума
    }
app-basics-enabled-plugins = Іске қосулы плагиндер
app-basics-build-config = Жинау баптаулары
app-basics-user-agent = User Agent
app-basics-os = ОЖ
app-basics-memory-use = Жады қолданылуы
app-basics-performance = Өнімділік
app-basics-service-workers = Тіркелген жұмыс үрдістері
app-basics-profiles = Профильдер
app-basics-launcher-process-status = Жөнелтетін үрдіс
app-basics-multi-process-support = Мультипроцесс терезелері
app-basics-remote-processes-count = Қашықтағы үрдістер
app-basics-enterprise-policies = Кәсіпоорындық саясаттар
app-basics-location-service-key-google = Google орналасулар қызметінің кілті
app-basics-safebrowsing-key-google = Google Safebrowsing кілті
app-basics-key-mozilla = Mozilla орналасулар қызметінің кілті
app-basics-safe-mode = Қауіпсіз режимі
show-dir-label =
    { PLATFORM() ->
        [macos] Finder ішінен көрсету
        [windows] Буманы ашу
       *[other] Буманы ашу
    }
environment-variables-title = Қоршам айнымалылары
environment-variables-name = Аты
environment-variables-value = Мәні
experimental-features-title = Эксперименталды мүмкіндіктер
experimental-features-name = Аты
experimental-features-value = Мәні
modified-key-prefs-title = Өзгертілген маңызды баптаулар
modified-prefs-name = Аты
modified-prefs-value = Мәні
user-js-title = user.js баптаулары
user-js-description = Профиль сақталатын бумада <a data-l10n-name="user-js-link">user.js файлды</a> бар, оның ішінде { -brand-short-name } жасамаған баптаулары сақталған.
locked-key-prefs-title = Маңызды бекітілген баптаулар
locked-prefs-name = Аты
locked-prefs-value = Мәні
graphics-title = Графика
graphics-features-title = Мүмкіндіктер
graphics-diagnostics-title = Диагностика
graphics-failure-log-title = Ақаулықтар журналы
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Шешімдер журналы
graphics-crash-guards-title = Қулаудан қорғаныс сөндірген мүмкіндіктері
graphics-workarounds-title = Арнайы қолдау
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Терезелерді басқару хаттамасы
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Жұмыс үстелі ортасы
place-database-title = Орналасулар дерекқоры
place-database-integrity = Бүтіндігі
place-database-verify-integrity = Бүтіндігін тексеру
a11y-title = Қолжетерлілік
a11y-activated = Белсендірілген
a11y-force-disabled = Кеңейтілген мүмкіндіктерге  тыйым салу
a11y-handler-used = Қолжетерліліктің қолданылған талдаушысы
a11y-instantiator = Қолжетерлілік объектін жасаушысы
library-version-title = Жинақтар нұсқалары
copy-text-to-clipboard-label = Мәтінді алмасу буферіне көшіріп алу
copy-raw-data-to-clipboard-label = Өнделмеген мәліметтерді алмасу буферіне көшіріп алу
sandbox-title = Құмсалғыш
sandbox-sys-call-log-title = Тайдырылған жүйелік шақырулар
sandbox-sys-call-index = #
sandbox-sys-call-age = секунд бұрын
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Процесс түрі
sandbox-sys-call-number = Жүйелік шақыру
sandbox-sys-call-args = Аргументтер
safe-mode-title = Қауіпсіз режимін қолданып көру
restart-in-safe-mode-label = Сөндірілген кеңейтулермен қайта қосу…
clear-startup-cache-title = Іске қосылу кэшін тарартып көріңіз
clear-startup-cache-label = Іске қосылу кэшін тазарту…
startup-cache-dialog-title = Іске қосылу кэшін тазарту
startup-cache-dialog-body = Іске қосылу кэшін тазарту үшін { -brand-short-name } қайта іске қосыңыз. Бұл сіздің баптаулараңызы өзгертпейді, немесе сіз { -brand-short-name } ішіне қосқан кеңейтулерді өшірмейді.
restart-button-label = Қайта қосу

## Media titles

audio-backend = Аудио файлдарын ойнату бағдарламасы
max-audio-channels = Макс. арналар
sample-rate = Таңдамалы кадрлар жиілігі
roundtrip-latency = Айналма жолдың кідірісі (стандартты ауытқу)
media-title = Мультимедиа
media-output-devices-title = Шығыс құрылғылары
media-input-devices-title = Енгізу құрылғылары
media-device-name = Аты
media-device-group = Топ
media-device-vendor = Өндіруші
media-device-state = Күйі
media-device-preferred = Таңдамалы
media-device-format = Пішімі
media-device-channels = Арналар
media-device-rate = Жиілігі
media-device-latency = Кідірісі
media-capabilities-title = Медиа мүмкіндіктері
# List all the entries of the database.
media-capabilities-enumerate = Дерекқор жазбаларын шығару

##

intl-title = Интернационалдандыру және локализация
intl-app-title = Қолданба баптаулары
intl-locales-requested = Сұралған локальдер
intl-locales-available = Қолжетерлік локальдер
intl-locales-supported = Қолданба локальдері
intl-locales-default = Бастапқы локаль
intl-os-title = Операциялық жүйе
intl-os-prefs-system-locales = Жүйелік локальдер
intl-regional-prefs = Аймақтық баптаулар

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Қашықтан жөндеу (Chromium хаттамасы)
remote-debugging-accepting-connections = Кіріс байланыстарды қабылдау
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Соңғы { $days } күн үшін құлау хабарламалары
       *[other] Соңғы { $days } күн үшін құлау хабарламалары
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } минут бұрын
       *[other] { $minutes } минут бұрын
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } сағат бұрын
       *[other] { $hours } сағат бұрын
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } күн бұрын
       *[other] { $days } күн бұрын
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Барлық құлау хабарламалары (соның ішінде берілген уақыт аралығындағы әлі жіберілмеген { $reports } құлау)
       *[other] Барлық құлау хабарламалары (соның ішінде берілген уақыт аралығындағы әлі жіберілмеген { $reports } құлау)
    }
raw-data-copied = Өнделмеген мәліметтерді алмасу буферіне көшірілген
text-copied = Мәтінді алмасу буферіне көшірілген

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Графикалық драйверіңіз нұсқасымен блокталған.
blocked-gfx-card = Шешілмеген драйвер мәселелері нәтижесінде графикалық картаңызбен блокталған.
blocked-os-version = Операциялық жүйесіңіз нұсқасымен блокталған.
blocked-mismatched-version = Графикалық драйверіңіздің нұсқасы реестрде және DLL ішінде сәйкес болмауы салдарынан блокталған.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Графикалық драйверіңіз нұсқасымен блокталған. Драйверіңізді { $driverVersion } не жаңалау нұсқасына дейін жаңартыңыз.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType баптаулары
compositing = Композитинг
hardware-h264 = Құрылғылық H264 декодтау
main-thread-no-omtc = басты ағын, OMTC жоқ
yes = Иә
no = Жоқ
unknown = Белгісіз
virtual-monitor-disp = Виртуалды монитор экраны

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Табылған
missing = Жоқ
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Сипаттамасы
gpu-vendor-id = Vendor ID
gpu-device-id = Device ID
gpu-subsys-id = Ішкі жүйе ID-і
gpu-drivers = Драйверлер
gpu-ram = RAM жады
gpu-driver-vendor = Драйвер өндірушісі
gpu-driver-version = Драйвер нұсқасы
gpu-driver-date = Драйвер шыққан күні
gpu-active = Белсенді
webgl1-wsiinfo = WebGL 1 драйвер WSI ақпараты
webgl1-renderer = WebGL 1 драйвер Renderer
webgl1-version = WebGL 1 драйвер нұсқасы
webgl1-driver-extensions = WebGL 1 драйвер кеңейтулері
webgl1-extensions = WebGL 1 кеңейтулері
webgl2-wsiinfo = WebGL 2 драйвер WSI ақпараты
webgl2-renderer = WebGL 2 драйвер Renderer
webgl2-version = WebGL 2 драйвер нұсқасы
webgl2-driver-extensions = WebGL 2 драйвер кеңейтулері
webgl2-extensions = WebGL 2 кеңейтулері
blocklisted-bug = Белгілі осалдылықтар салдарынан блоктізімде
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = ақаулық { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Белгілі мәселелерге байланысты бұғатталған: <a data-l10n-name="bug-link">bug { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Блоктізіміде; қателік коды { $failureCode }
d3d11layers-crash-guard = D3D11 араластырушысы
d3d11video-crash-guard = D3D11 видео декодері
d3d9video-crash-guard = D3D9 видео декодері
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX видео декодері
reset-on-next-restart = Келесі іске қосылған кезде тастау
gpu-process-kill-button = GPU процесін тоқтату
gpu-device-reset = Құрылғыны қалпына келтіру
gpu-device-reset-button = Құрылғыны тастауды орындау
uses-tiling = Тайлингті қолданады
content-uses-tiling = Тайлинг қолданады (мазмұны)
off-main-thread-paint-enabled = Басты емес ағында элементтерді суреттеу іске қосылған
off-main-thread-paint-worker-count = Негізгі ағыннан тыс салатын воркер саны
target-frame-rate = Кадр/сек мақсат көрсеткіші
min-lib-versions = Күтілген минималды нұсқасы
loaded-lib-versions = Қолданыстағы нұсқасы
has-seccomp-bpf = Seccomp-BPF (Жүйелік шақыруларды сүзгілеу)
has-seccomp-tsync = Seccomp ағынының синхрондалуы
has-user-namespaces = Пайдаланушының аттар кеңістіктері
has-privileged-user-namespaces = Артықшылықты үрдістер үшін пайдаланушының аттар кеңістіктері
can-sandbox-content = Құраманың үрдісін құмсалғышта орындау
can-sandbox-media = Медиа плагиндерін құмсалғышта орындау
content-sandbox-level = Құрамасы бар үрдістер үшін шектеулер деңгейі
effective-content-sandbox-level = Құрамасы бар үрдістер үшін эффективті шектеулер деңгейі
sandbox-proc-type-content = құрамасы
sandbox-proc-type-file = файл құрамасы
sandbox-proc-type-media-plugin = медиа плагині
sandbox-proc-type-data-decoder = деректер декодері
startup-cache-title = Іске қосу кэші
startup-cache-disk-cache-path = Диск кэш жолы
startup-cache-ignore-disk-cache = Диск кэшін елемеу
startup-cache-found-disk-cache-on-init = Іске қосылу кезінде диск кэші табылды
startup-cache-wrote-to-disk-cache = Диск кэшіне жазылды
launcher-process-status-0 = Іске қосулы
launcher-process-status-1 = Ақаулығы салдарынан сөндірілген
launcher-process-status-2 = Мәжбүрлі сөндірілген
launcher-process-status-unknown = Қалып-күйі белгісіз
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Пайдаланушымен іске қосылған
multi-process-status-1 = Үнсіз келісім бойынша іске қосылған
multi-process-status-2 = Сөндірулі
multi-process-status-4 = Қолжетерлілік құралдарымен сөндірілген
multi-process-status-6 = Қолдауы жоқ мәтіндік енгізу салдарынан сөндірілген
multi-process-status-7 = Қосымшалармен сөндірілген
multi-process-status-8 = Мәжбүрлі түрде сөндірілген
multi-process-status-unknown = Қалып-күйі белгісіз
async-pan-zoom = Асинхронды панорамдау/масштабтау
apz-none = ешнәрсе
wheel-enabled = тышқан дөңгелегімен енгізу іске қосылған
touch-enabled = сенсорлық енгізу іске қосылған
drag-enabled = айналдыру жолағының ұстап тарту іске қосылған
keyboard-enabled = пернетақта іске қосылған
autoscroll-enabled = автоайналдыру іске қосылған
zooming-enabled = тегіс ыммен масштабтау іске қосылған

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = тышқан дөңгелегімен асинхронды енгізу қолдауы жоқ баптау салдарынан сөндірілген: { $preferenceKey }
touch-warning = сенсорлық асинхронды енгізу қолдауы жоқ баптау салдарынан сөндірілген: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Белсенді емес
policies-active = Белсенді
policies-error = Қате
