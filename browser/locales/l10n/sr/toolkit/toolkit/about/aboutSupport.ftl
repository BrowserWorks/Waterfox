# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Подаци о решавању проблема
page-subtitle =
    Ова страница садржи техничке податке који могу бити корисни када
    покушавате да решите неки проблем. Ако вам требају одговори на често постављана питања
    о програму { -brand-short-name }, прегледајте наш <a data-l10n-name="support-link">веб сајт за подршку</a>.

crashes-title = Извештаји о рушењу
crashes-id = ID извештаја
crashes-send-date = Поднесено
crashes-all-reports = Сви извештаји о рушењу
crashes-no-config = Ова апликација није подешена да приказује извештаје о рушењу.
extensions-title = Екстензије
extensions-name = Назив
extensions-enabled = Укључен
extensions-version = Издање
extensions-id = ID
support-addons-title = Додаци
support-addons-name = Назив
support-addons-type = Тип
support-addons-enabled = Омогућено
support-addons-version = Издање
support-addons-id = ID
security-software-title = Безбедносни софтвер
security-software-type = Тип
security-software-name = Име
security-software-antivirus = Антивирус
security-software-antispyware = Антиспајвер
security-software-firewall = Заштитни зид
features-title = { -brand-short-name } могућности
features-name = Назив
features-version = Издање
features-id = ID
processes-title = Удаљени процеси
processes-type = Тип
processes-count = Број
app-basics-title = Основе апликације
app-basics-name = Назив
app-basics-version = Издање
app-basics-build-id = ID издања
app-basics-distribution-id = ID дистрибуције
app-basics-update-channel = Канал за ажурирање
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Директоријум за ажурирања
       *[other] Фасцикла за ажурирања
    }
app-basics-update-history = Историја ажурирања
app-basics-show-update-history = Прикажи историјат ажурирања
# Represents the path to the binary used to start the application.
app-basics-binary = Бинарна апликација
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Фасцикла профила
       *[other] Фасцикла профила
    }
app-basics-enabled-plugins = Активирани прикључци
app-basics-build-config = Конфигурација изградње
app-basics-user-agent = Корисник
app-basics-os = ОС
app-basics-memory-use = Меморија
app-basics-performance = Перформансе
app-basics-service-workers = Регистровани Service Workers
app-basics-profiles = Профили
app-basics-launcher-process-status = Покретачки процес
app-basics-multi-process-support = Вишепроцесорски прозори
app-basics-remote-processes-count = Удаљени процеси
app-basics-enterprise-policies = Полисе предузећа
app-basics-location-service-key-google = Google кључ за услуге локације
app-basics-safebrowsing-key-google = Google кључ за безбедно прегледање
app-basics-key-mozilla = Кључ Mozilla сервиса за локацију
app-basics-safe-mode = Безбедни режим
show-dir-label =
    { PLATFORM() ->
        [macos] Прикажи у Finder-у
        [windows] Отвори фасциклу
       *[other] Отвори фасциклу
    }
experimental-features-title = Експерименталне функције
experimental-features-name = Назив
experimental-features-value = Вредност
modified-key-prefs-title = Важне измењене поставке
modified-prefs-name = Назив
modified-prefs-value = Вредност
user-js-title = user.js подешавања
user-js-description = Ваша Фасцикла профила садржи  <a data-l10n-name="user-js-link">user.js датотеку</a>, која садржи подешавања која нису направљена од стране { -brand-short-name }.
locked-key-prefs-title = Увези закључана подешавања
locked-prefs-name = Име
locked-prefs-value = Вредност
graphics-title = Графика
graphics-features-title = Могућности
graphics-diagnostics-title = Дијагностика
graphics-failure-log-title = Дневник неуспеха
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Дневник одлука
graphics-crash-guards-title = Онемогућене могућности чувара рушења
graphics-workarounds-title = Алтернативна решења
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Протокол прозора
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Радно окружење
place-database-title = База података локација
place-database-integrity = Интегритет
place-database-verify-integrity = Потврди интегритет
a11y-title = Приступачност
a11y-activated = Активирана
a11y-force-disabled = Спречи приступачност
a11y-handler-used = Приступни управљач искоришћен
a11y-instantiator = Приступачност инстантиатору
library-version-title = Издања библиотека
copy-text-to-clipboard-label = Копирај текст у бележницу
copy-raw-data-to-clipboard-label = Копирај податке у бележницу
sandbox-title = Sandbox
sandbox-sys-call-log-title = Одбијени системски позиви
sandbox-sys-call-index = #
sandbox-sys-call-age = Пре неколико секунди
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Тип процеса
sandbox-sys-call-number = Системски позив
sandbox-sys-call-args = Аргументи
safe-mode-title = Покушај безбедни режим
restart-in-safe-mode-label = Рестартуј са онемогућеним додацима…

clear-startup-cache-title = Покушајте да избришете предмеморију покретања
clear-startup-cache-label = Избриши предмеморију покретања…
startup-cache-dialog-title = Избриши предмеморију покретања
startup-cache-dialog-body = Поново покрените { -brand-short-name } да бисте избрисали предмеморију покретања. Ово неће променити подешавања или уклонити проширења која сте додали у { -brand-short-name }.
restart-button-label = Поново покрени

## Media titles

audio-backend = Audio Backend
max-audio-channels = Највише канала
sample-rate = Жељена стопа семпла
roundtrip-latency = Латенција у повратном правцу (стандардна девијација)
media-title = Медиј
media-output-devices-title = Излазни уређаји
media-input-devices-title = Улазни уређаји
media-device-name = Име
media-device-group = Група
media-device-vendor = Произвођач
media-device-state = Стање
media-device-preferred = Жељено
media-device-format = Формат
media-device-channels = Канали
media-device-rate = Стопа
media-device-latency = Латентност
media-capabilities-title = Могућности медија
# List all the entries of the database.
media-capabilities-enumerate = Попис уноса базе података

##

intl-title = Интернационализација & Локализација
intl-app-title = Поставке апликације
intl-locales-requested = Захтевани локали
intl-locales-available = Доступни локали
intl-locales-supported = Локали апликације
intl-locales-default = Подразумевани локал
intl-os-title = Оперативни систем
intl-os-prefs-system-locales = Локали система
intl-regional-prefs = Регионалне поставке

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Удаљено уклањање грешака (Chromium Protocol)
remote-debugging-accepting-connections = Прихватање веза
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Извештаји о рушењу у последњем { $days } дану
        [few] Извештаји о рушењу у последња { $days } дана
       *[other] Извештаји о рушењу у последњих { $days } дана
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] Пре { $minutes } минут
        [few] Пре { $minutes } минута
       *[other] Пре { $minutes } минута
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] Пре { $hours } сат
        [few] Пре { $hours } сата
       *[other] Пре { $hours } сати
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] Пре { $days } дан
        [few] Пре { $days } дана
       *[other] Пре { $days } дана
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Сви извештаји о рушењу(укључујући { $reports } који чека да буде послат)
        [few] Сви извештаји о рушењу(укључујући { $reports } који чекају да буду послати)
       *[other] Сви извештаји о рушењу(укључујући { $reports } који чекају да буду послати)
    }

raw-data-copied = Подаци копирани у бележницу
text-copied = Текст копиран у бележницу

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Блокирано је за издање графичког драјвера који користите.
blocked-gfx-card = Блокирано на графичкој картици због нерешених проблема са драјвером.
blocked-os-version = Блокирано за издање оперативног система који користите.
blocked-mismatched-version = Блокирана верзија драјвера графике јер је дошло до неслагања између регистра и DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Блокирано за верзију драјвера графике коју имате. Покушајте да ажурирате управљачки програм на верзију { $driverVersion } или новију.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType параметри

compositing = Састављање
hardware-h264 = Hardware H264 декодирање
main-thread-no-omtc = главна нит, без OMTC
yes = да
no = не
unknown = Непознато
virtual-monitor-disp = Приказ виртуелног монитора

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Пронађено
missing = Недостаје

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Опис
gpu-vendor-id = ID продавца
gpu-device-id = ID уређаја
gpu-subsys-id = Subsys ID
gpu-drivers = Драјвери
gpu-ram = RAM
gpu-driver-vendor = Произвођач driver-а
gpu-driver-version = Верзија драјвера
gpu-driver-date = Датум драјвера
gpu-active = Активан
webgl1-wsiinfo = WebGL 1 WSI информације драјвера
webgl1-renderer = WebGL 1 Driver Renderer
webgl1-version = WebGL 1 верзија драјвера
webgl1-driver-extensions = WebGL 1 екстензија драјвера
webgl1-extensions = WebGL 1 екстензије
webgl2-wsiinfo = WebGL 2 WSI информације драјвера
webgl2-renderer = WebGL2 Renderer
webgl2-version = WebGL 2 верзија драјвера
webgl2-driver-extensions = WebGL 2 екстензија драјвера
webgl2-extensions = WebGL 2 екстензије
blocklisted-bug = На црној листи због познатих проблема

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = грешка { $bugNumber }

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Блокирано због познатих проблема: <a data-l10n-name="bug-link">bug { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = На црној листи; код грешке { $failureCode }

d3d11layers-crash-guard = D3D11 композитор
d3d11video-crash-guard = D3D11 видео декодер
d3d9video-crash-guard = D3D9 видео декодер
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX видео декодер

reset-on-next-restart = Ресетуј при следећем покретању
gpu-process-kill-button = Угаси GPU процес
gpu-device-reset = Поновно покретање уређаја
gpu-device-reset-button = Покрени ресетовање уређаја
uses-tiling = Користи плочице
content-uses-tiling = Користи плочице (садржај)
off-main-thread-paint-enabled = Нит за сликање омогућена
off-main-thread-paint-worker-count = Thread Painting Worker бројач
target-frame-rate = Циљана брзина освежавања тј. Framerate

min-lib-versions = Очекивано минимално издање
loaded-lib-versions = Издање у употреби

has-seccomp-bpf = Seccomp-BPF (Системско филтрирање позива)
has-seccomp-tsync = Seccomp синхронизација нити
has-user-namespaces = Именски простор корисника
has-privileged-user-namespaces = Именски простор корисника за привилеговане процесе
can-sandbox-content = Sandboxing процеса садржаја
can-sandbox-media = Sandboxing медија прикључак
content-sandbox-level = Ниво Sandbox процеса садржаја
effective-content-sandbox-level = Ефективни ниво Sandbox процеса садржаја
sandbox-proc-type-content = садржај
sandbox-proc-type-file = садржај дадотеке
sandbox-proc-type-media-plugin = медија прикључак
sandbox-proc-type-data-decoder = декодер података

startup-cache-title = Кеш покретања
startup-cache-disk-cache-path = Путања до дисковног кеша
startup-cache-ignore-disk-cache = Игноришите дисковни кеш
startup-cache-found-disk-cache-on-init = Дисковни кеш пронађен током иницијализације
startup-cache-wrote-to-disk-cache = Записано у дисковни кеш

launcher-process-status-0 = Омогућено
launcher-process-status-1 = Онемогућено због грешке
launcher-process-status-2 = Онемогућен силом
launcher-process-status-unknown = Непознат статус

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Омогућио корисник
multi-process-status-1 = Омогућено подразумевано
multi-process-status-2 = Онемогућено
multi-process-status-4 = Онемогућено од стране алата приступачности
multi-process-status-6 = Онемогућено од стране неподржаног уноса текста
multi-process-status-7 = Онемогућено од стране додатака
multi-process-status-8 = Присилно онемогућено
multi-process-status-unknown = Непознат статус

async-pan-zoom = Асинхроно кретање/увеличавање
apz-none = нема
wheel-enabled = унос точкића омогућен
touch-enabled = унос додира омогућен
drag-enabled = превлачење клизача омогућено
keyboard-enabled = тастатура омогућена
autoscroll-enabled = аутоматско скроловање омогућено
zooming-enabled = smooth pinch-zoom омогућен

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = асинхрони унос точкића је онеспособљен због неподржаног параметра: { $preferenceKey }
touch-warning = асинхрони унос додира је онеспособљен због неподржаног параметра: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Неактивно
policies-active = Активно
policies-error = Грешка
