# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Отстраняване на неизправности
page-subtitle = Тази страница съдържа техническа информация, която може да ви е от полза, когато се опитвате да решите проблем. Ако търсите отговори на често задавани въпроси за { -brand-short-name }, проверете в нашата <a data-l10n-name="support-link">страница за поддръжка</a>.

crashes-title = Доклади за сривове
crashes-id = Идентификатор на доклад
crashes-send-date = Изпратен
crashes-all-reports = Всички доклади за сривове
crashes-no-config = Приложението не е настроено да показва доклади за сривове.
extensions-title = Разширения
extensions-name = Наименование
extensions-enabled = Включено
extensions-version = Версия
extensions-id = ID
support-addons-name = Наименование
support-addons-version = Версия
support-addons-id = ID
security-software-title = Приложение по сигурността
security-software-type = Вид
security-software-name = Име
security-software-antivirus = Борба с вируси
security-software-antispyware = Борба с шпионски приложения
security-software-firewall = Огнена стена
features-title = Възможности на { -brand-short-name }
features-name = Наименование
features-version = Версия
features-id = ID
processes-title = Отдалечени процеси
processes-type = Вид
processes-count = Брой
app-basics-title = Основни за приложението
app-basics-name = Наименование
app-basics-version = Версия
app-basics-build-id = Идентификатор на компилиране
app-basics-update-channel = Канал за обновяване
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Папка за обновявания
       *[other] Папка за обновявания
    }
app-basics-update-history = История на обновяванията
app-basics-show-update-history = История на обновяванията
# Represents the path to the binary used to start the application.
app-basics-binary = Двоичен файл на приловението
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Директория на профила
       *[other] Папка на профила
    }
app-basics-enabled-plugins = Включени приставки
app-basics-build-config = Настройки на компилацията
app-basics-user-agent = Потребителски агент
app-basics-os = ОС
app-basics-memory-use = Използване на паметта
app-basics-performance = Производителност
app-basics-service-workers = Регистрирани Service Workers
app-basics-profiles = Профили
app-basics-multi-process-support = Многопроцесни прозорци
app-basics-remote-processes-count = Отдалечени процеси
app-basics-enterprise-policies = Ведомствени ограничения
app-basics-key-mozilla = Mozilla Location Service Key
app-basics-safe-mode = Надежден режим
show-dir-label =
    { PLATFORM() ->
        [macos] Показване във Finder
        [windows] Отваряне на папката
       *[other] Отваряне на папката
    }
modified-key-prefs-title = Важни променени настройки
modified-prefs-name = Наименование
modified-prefs-value = Стойност
user-js-title = Настройки от user.js
user-js-description = Папката с вашия профил съдържа файла <a data-l10n-name="user-js-link">user.js</a>, в който има потребителски, не създадени от { -brand-short-name } настройки.
locked-key-prefs-title = Важни заключени настройки
locked-prefs-name = Наименование
locked-prefs-value = Стойност
graphics-title = Изчертаване
graphics-features-title = Възможности
graphics-diagnostics-title = Диагностика
graphics-failure-log-title = Журнал на грешките
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Журнал на решенията
graphics-crash-guards-title = Изключени възможности на защитата от сривове
graphics-workarounds-title = Заобикаляния
place-database-title = База от данни на Places
place-database-integrity = Цялост
place-database-verify-integrity = Проверка на целостта
a11y-title = Достъпност
a11y-activated = Включено
a11y-force-disabled = Предотвратяване на достъпност
a11y-handler-used = Използвано устройство
a11y-instantiator = Изпълним файл
library-version-title = Версии на библиотеки
copy-text-to-clipboard-label = Копиране на текста в системния буфер
copy-raw-data-to-clipboard-label = Копиране необработени данни в системния буфер
sandbox-title = Виртуална среда
sandbox-sys-call-log-title = Отхвърлени системни извиквания
sandbox-sys-call-index = №
sandbox-sys-call-age = Време
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Вид процес
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = Аргументи
safe-mode-title = Пробвайте надеждния режим
restart-in-safe-mode-label = Рестартиране с изключени добавки…

## Media titles

audio-backend = Аудио хардуер
max-audio-channels = Максимален брой канали
sample-rate = Предпочитана честота на дискретизацията

media-title = Медия
media-output-devices-title = Изходни устройства
media-input-devices-title = Входни устройства
media-device-name = Наименование
media-device-group = Група
media-device-vendor = Производител
media-device-state = Състояние
media-device-preferred = Предпочитано
media-device-format = Формат
media-device-channels = Канали
media-device-rate = Честота
media-device-latency = Закъснение

##

intl-title = Интернационализиране и локализация
intl-app-title = Настройки на приложението
intl-locales-requested = Искани локали
intl-locales-available = Налични локали
intl-locales-supported = Локали на приложението
intl-locales-default = Локал по подразбиране
intl-os-title = Настройки на операционната система
intl-os-prefs-system-locales = Системен локал
intl-regional-prefs = Местни настройки

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Отдалечено отстраняване на грешки (Chromium Protocol)
remote-debugging-accepting-connections = Приемане на връзки
remote-debugging-url = Адрес

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Доклади за сривовете през последния { $days } ден
       *[other] Доклади за сривовете през последните { $days } дена
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] преди { $minutes } минута
       *[other] преди { $minutes } минути
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] преди { $hours } час
       *[other] преди { $hours } часа
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] преди { $days } ден
       *[other] преди { $days } дена
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Всички доклади за сривове (включително { $reports } изчакващ срив в дадения времеви диапазон)
       *[other] Всички доклади за сривове (включително { $reports } изчакващи срива в дадения времеви диапазон)
    }

raw-data-copied = Необработените данни са копирани в системния буфер
text-copied = Текстът е копиран в системния буфер

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Блокирано за конкретната версия на вашия графичен драйвер.
blocked-gfx-card = Вашата графична карта е блокирана поради неразрешени проблеми с драйвера.
blocked-os-version = Блокирано за конкретната версия на вашата операционна система.
blocked-mismatched-version = Блокирано поради несъответствие във версията на графичен драйвер между системния регистър и DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Вашият графичен драйвер е блокиран. Опитайте да обновите драйвера си до версия { $driverVersion } или по-нова.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Параметри на ClearType

compositing = Сглобяване
hardware-h264 = Хардуерно декодиране на H264
main-thread-no-omtc = главна нишка, без OMTC
yes = Да
no = Не
virtual-monitor-disp = Виртуален монитор

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Наличен
missing = Липсващ

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Описание
gpu-vendor-id = ID на производител
gpu-device-id = ID на устройство
gpu-subsys-id = ID на подсистема
gpu-drivers = Драйвери
gpu-ram = RAM
gpu-driver-vendor = Производител на драйвера
gpu-driver-version = Версия на драйвера
gpu-driver-date = Дата на драйвера
gpu-active = Включен
webgl1-wsiinfo = Информация за WSI на драйвера за WebGL 1
webgl1-renderer = Рендер на драйвера за WebGL 1
webgl1-version = Версия на драйвера за WebGL 1
webgl1-driver-extensions = Разширения на драйвера за WebGL 1
webgl1-extensions = Разширения на WebGL 1
webgl2-wsiinfo = Информация за WSI на драйвера за WebGL 2
webgl2-renderer = Рендер на драйвера за WebGL 2
webgl2-version = Версия на драйвера за WebGL 2
webgl2-driver-extensions = Разширения на драйвера за WebGL 2
webgl2-extensions = Разширения на WebGL 2
blocklisted-bug = В списъка на блокирането поради известни проблеми

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = дефект { $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = В списъка на блокираните: код на грешка { $failureCode }

d3d11layers-crash-guard = Сглобяване с D3D11
d3d11video-crash-guard = Видео декодер на D3D11
d3d9video-crash-guard = Видео декодер на D3D9
glcontext-crash-guard = OpenGL

reset-on-next-restart = Анулиране при следващото рестартиране
gpu-process-kill-button = Прекъсване на процес на GPU
gpu-device-reset = Нулиране на устройството
gpu-device-reset-button = Нулиране на устройството
uses-tiling = Използване на повтарящо се изображение
content-uses-tiling = Използване на повтарящо се изображение (за съдържанието)
off-main-thread-paint-enabled = Изчертаване в отделна нишка включено
off-main-thread-paint-worker-count = Брой сервизни нишки, изчертаващи в отделна нишка
target-frame-rate = Целева честота на кадрите

min-lib-versions = Очаквана минимална версия
loaded-lib-versions = Използвана версия

has-seccomp-bpf = Seccomp-BPF (филтриране на системни извиквания)
has-seccomp-tsync = Синхронизиране на нишката на Seccomp
has-user-namespaces = Потребителски пространства от имена
has-privileged-user-namespaces = Потребителски пространства от имена за привилегировани процеси
can-sandbox-content = Изолиране на процес за съдържанието във виртуална среда
can-sandbox-media = Отделяне на медийна приставка във виртуална среда
content-sandbox-level = Степен на изолация на процес за съдържание
effective-content-sandbox-level = Ефективна степен на изолация на процес за съдържание
sandbox-proc-type-content = съдържание
sandbox-proc-type-file = съдържание на файл
sandbox-proc-type-media-plugin = приставка за медия

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = включени от потребителя
multi-process-status-1 = включени по подразбиране
multi-process-status-2 = изключени
multi-process-status-4 = изключени от инструменти по достъпността
multi-process-status-6 = изключени поради неподдържан текстов вход
multi-process-status-7 = изключени от добавки
multi-process-status-8 = принудително изключени
multi-process-status-unknown = неизвестно състояние

async-pan-zoom = Асинхронно преместване / мащабиране
apz-none = няма
wheel-enabled = използване на колелцето на мишката
touch-enabled = използване на интерфейса с докосвания
drag-enabled = използване на лентата за плъзгане
keyboard-enabled = клавиатура влкючена
autoscroll-enabled = автоматично прелистване включено

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = асинхронното използване на колелцето на мишката е изключено заради неподдържана настройка: { $preferenceKey }
touch-warning = асинхронното използване на интерфейс с докосвания е изключено заради неподдържана настройка: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Изключени
policies-active = Включено
policies-error = Грешка
