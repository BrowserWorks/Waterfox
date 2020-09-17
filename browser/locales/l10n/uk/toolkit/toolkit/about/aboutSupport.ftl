# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Інформація для вирішення проблем
page-subtitle =
    Ця сторінка містить технічну інформацію, що може стати у нагоді під час вирішення проблем.
    Якщо ж вам потрібні відповіді на загальні питання щодо
    { -brand-short-name } — відвідайте наш <a data-l10n-name="support-link">сайт підтримки</a>.
crashes-title = Звіти про збої
crashes-id = ID звіту
crashes-send-date = Надіслано
crashes-all-reports = Всі звіти про збої
crashes-no-config = Ця програма не була налаштована показувати звіти про збої.
extensions-title = Розширення
extensions-name = Назва
extensions-enabled = Увімкнено
extensions-version = Версія
extensions-id = ID
support-addons-title = Додатки
support-addons-name = Назва
support-addons-type = Тип
support-addons-enabled = Увімкнено
support-addons-version = Версія
support-addons-id = ID
security-software-title = Програмне забезпечення для захисту
security-software-type = Тип
security-software-name = Назва
security-software-antivirus = Антивірус
security-software-antispyware = Захист від шпигунства
security-software-firewall = Мережевий екран
features-title = Можливості { -brand-short-name }
features-name = Назва
features-version = Версія
features-id = ID
processes-title = Віддалені процеси
processes-type = Тип
processes-count = Кількість
app-basics-title = Інформація про програму
app-basics-name = Назва
app-basics-version = Версія
app-basics-build-id = ID збірки
app-basics-distribution-id = ID дистрибутиву
app-basics-update-channel = Канал оновлення
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] Тека оновлення
       *[other] Каталог оновлення
    }
app-basics-update-history = Історія оновлень
app-basics-show-update-history = Показати історію оновлень
# Represents the path to the binary used to start the application.
app-basics-binary = Бінарний файл програми
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Тека профілю
       *[other] Тека профілю
    }
app-basics-enabled-plugins = Увімкнені плагіни
app-basics-build-config = Конфігурація збірки
app-basics-user-agent = User Agent
app-basics-os = ОС
app-basics-memory-use = Використання пам’яті
app-basics-performance = Швидкодія
app-basics-service-workers = Зареєстровані Service Workers
app-basics-profiles = Профілі
app-basics-launcher-process-status = Процес запуску
app-basics-multi-process-support = Багатопроцесні вікна
app-basics-remote-processes-count = Віддалені процеси
app-basics-enterprise-policies = Корпоративні правила
app-basics-location-service-key-google = Ключ служби Google Location
app-basics-safebrowsing-key-google = Ключ Google Safebrowsing
app-basics-key-mozilla = Ключ Служби визначення розташування від Mozilla
app-basics-safe-mode = Безпечний режим
show-dir-label =
    { PLATFORM() ->
        [macos] Показати у Finder
        [windows] Відкрити теку
       *[other] Відкрити каталог
    }
environment-variables-title = Змінні середовища
environment-variables-name = Назва
environment-variables-value = Значення
experimental-features-title = Експериментальні можливості
experimental-features-name = Назва
experimental-features-value = Значення
modified-key-prefs-title = Важливі змінені налаштування
modified-prefs-name = Назва
modified-prefs-value = Значення
user-js-title = Вподобання user.js
user-js-description = Ваша папка профілю містить <a data-l10n-name="user-js-link">файл user.js file</a> з вподобаннями, котрі не були створені програмою { -brand-short-name }.
locked-key-prefs-title = Важливі заблоковані налаштування
locked-prefs-name = Назва
locked-prefs-value = Значення
graphics-title = Графіка
graphics-features-title = Можливості
graphics-diagnostics-title = Діагностика
graphics-failure-log-title = Журнал збоїв
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = Журнал рішень
graphics-crash-guards-title = Можливості, вимкнені захистом від збоїв
graphics-workarounds-title = Способи обходу
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = Віконний протокол
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = Середовище робочого столу
place-database-title = База даних Places
place-database-integrity = Цілісність
place-database-verify-integrity = Перевірити цілісність
a11y-title = Доступність
a11y-activated = Активовано
a11y-force-disabled = Блокувати можливості доступності
a11y-handler-used = Використовується обробник доступності
a11y-instantiator = Виконуваний файл доступності
library-version-title = Версії бібліотек
copy-text-to-clipboard-label = Копіювати текст у буфер
copy-raw-data-to-clipboard-label = Копіювати необроблені дані в буфер
sandbox-title = Пісочниця
sandbox-sys-call-log-title = Відхилені системні виклики
sandbox-sys-call-index = #
sandbox-sys-call-age = Секунд тому
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = Тип процесу
sandbox-sys-call-number = Системний виклик
sandbox-sys-call-args = Аргументи
safe-mode-title = Спробувати безпечний режим
restart-in-safe-mode-label = Перезапустити з вимкненими додатками…
clear-startup-cache-title = Спробуйте очистити кеш запуску
clear-startup-cache-label = Очистити кеш запуску…
startup-cache-dialog-title = Очистити кеш запуску
startup-cache-dialog-body = Перезапустіть { -brand-short-name } для очищення кешу запуску. Ця дія не змінить ваших налаштувань та не вилучить розширень, які ви встановили в { -brand-short-name }.
restart-button-label = Перезапустити

## Media titles

audio-backend = Обробка аудіо
max-audio-channels = Максимальне число каналів
sample-rate = Основна частота
roundtrip-latency = Затримка в обох напрямках (стандартне відхилення)
media-title = Медіа
media-output-devices-title = Пристрої відтворення
media-input-devices-title = Пристрої введення
media-device-name = Назва
media-device-group = Група
media-device-vendor = Постачальник
media-device-state = Стан
media-device-preferred = Основний
media-device-format = Формат
media-device-channels = Канали
media-device-rate = Частота
media-device-latency = Затримка
media-capabilities-title = Медіа-можливості
# List all the entries of the database.
media-capabilities-enumerate = Перерахувати базу даних

##

intl-title = Інтернаціоналізація та локалізація
intl-app-title = Налаштування програми
intl-locales-requested = Запитані локалі
intl-locales-available = Доступні локалі
intl-locales-supported = Локалі програми
intl-locales-default = Типова локаль
intl-os-title = Операційна система
intl-os-prefs-system-locales = Системні локалі
intl-regional-prefs = Регіональні налаштування

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = Віддалене зневадження (Протокол Chromium)
remote-debugging-accepting-connections = Вхідні з'єднання
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] Звіти за минулий { $days } день
        [few] Звіти за минулі { $days } дні
       *[many] Звіти за минулі { $days } днів
    }
# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } хвилину тому
        [few] { $minutes } хвилини тому
       *[many] { $minutes } хвилин тому
    }
# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } годину тому
        [few] { $hours } години тому
       *[many] { $hours } годин тому
    }
# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } день тому
        [few] { $days } дні тому
       *[many] { $days } днів тому
    }
# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] Всі звіти про збої (за вказаний проміжок часу, включно з { $reports }, що очікує надсилання)
        [few] Всі звіти про збої (за вказаний проміжок часу, включно з { $reports }, що очікує надсилання)
       *[many] Всі звіти про збої (за вказаний проміжок часу, включно з { $reports }, що очікують надсилання)
    }
raw-data-copied = Необроблені дані скопійовано в буфер
text-copied = Текст скопійовано в буфер

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Заблоковано для вашої версії графічного драйвера.
blocked-gfx-card = Заблоковано для вашої відеоплати через нерозв’язані проблеми з драйвером.
blocked-os-version = Заблоковано для вашої версії операційної системи.
blocked-mismatched-version = Заблоковано через невідповідність версії вашого графічного драйвера в реєстрі та DLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = Заблоковано для вашого графічного драйвера. Спробуйте оновити графічний драйвер до версії { $driverVersion } чи новішої.
# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Параметри ClearType
compositing = Композиція
hardware-h264 = Апаратне декодування H264
main-thread-no-omtc = головний потік, не OMTC
yes = Так
no = Ні
unknown = Невідомо
virtual-monitor-disp = Відображення віртуального монітора

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = Знайдено
missing = Відсутнє
gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = Опис
gpu-vendor-id = ID виробника
gpu-device-id = ID пристрою
gpu-subsys-id = ID підсистеми
gpu-drivers = Драйвери
gpu-ram = RAM
gpu-driver-vendor = Постачальник драйвера
gpu-driver-version = Версія драйвера
gpu-driver-date = Дата драйвера
gpu-active = Активний
webgl1-wsiinfo = WebGL 1 - Інформація WSI драйвера
webgl1-renderer = WebGL 1 - Візуалізатор драйвера
webgl1-version = WebGL 1 - Версія драйвера
webgl1-driver-extensions = WebGL 1 - Розширення драйвера
webgl1-extensions = WebGL 1 - Розширення
webgl2-wsiinfo = WebGL 2 - Інформація WSI драйвера
webgl2-renderer = Засіб візуалізації WebGL2
webgl2-version = WebGL 2 - Версія драйвера
webgl2-driver-extensions = WebGL 2 - Розширення драйвера
webgl2-extensions = WebGL 2 - Розширення
blocklisted-bug = Заблоковано через відомі проблеми
# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = вада { $bugNumber }
# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = Заблоковано, у зв'язку з відомими проблемами: <a data-l10n-name="bug-link">звіт { $bugNumber }</a>
# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = Заблоковано; код помилки { $failureCode }
d3d11layers-crash-guard = Композитор D3D11
d3d11video-crash-guard = Відео декодер D3D11
d3d9video-crash-guard = Відео декодер D3D9
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = Відео декодер WMF VPX
reset-on-next-restart = Скинути при наступному перезавантаженні
gpu-process-kill-button = Завершити GPU процес
gpu-device-reset = Скидання пристрою
gpu-device-reset-button = Виконати скидання пристрою
uses-tiling = Використовує тайлинг
content-uses-tiling = Використовує тайлінг (вміст)
off-main-thread-paint-enabled = Вимальовування поза основним потоком увімкнено
off-main-thread-paint-worker-count = Число воркерів вимальовування поза основним потоком
target-frame-rate = Цільова частота кадрів
min-lib-versions = Очікувана мінімальна версія
loaded-lib-versions = Поточна версія
has-seccomp-bpf = Seccomp-BPF (Фільтрування системних викликів)
has-seccomp-tsync = Синхронізація потоку Seccomp
has-user-namespaces = Користувацькі простори імен
has-privileged-user-namespaces = Користувацькі простори імен для привілейованих процесів
can-sandbox-content = Пісочниця для процесу вмісту
can-sandbox-media = Пісочниця для плагіна медіа
content-sandbox-level = Рівень пісочниці процесів вмісту
effective-content-sandbox-level = Ефективний рівень ізоляції процесу вмісту
sandbox-proc-type-content = вміст
sandbox-proc-type-file = вміст файлу
sandbox-proc-type-media-plugin = медіаплагін
sandbox-proc-type-data-decoder = декодер даних
startup-cache-title = Кеш запуску
startup-cache-disk-cache-path = Шлях дискового кешу
startup-cache-ignore-disk-cache = Ігнорувати дисковий кеш
startup-cache-found-disk-cache-on-init = Знайдено дисковий кеш в Init
startup-cache-wrote-to-disk-cache = Записано в дисковий кеш
launcher-process-status-0 = Увімкнено
launcher-process-status-1 = Вимкнено через збій
launcher-process-status-2 = Примусово вимкнено
launcher-process-status-unknown = Невідомий стан
# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = Увімкнено користувачем
multi-process-status-1 = Типово увімкнено
multi-process-status-2 = Вимкнено
multi-process-status-4 = Вимкнено інструментами доступності
multi-process-status-6 = Вимкнено через непідтримуване введення тексту
multi-process-status-7 = Вимкнено додатками
multi-process-status-8 = Примусово вимкнені
multi-process-status-unknown = Невідомий стан
async-pan-zoom = Асинхронне панорамування/зум
apz-none = немає
wheel-enabled = введення коліщатком увімкнено
touch-enabled = сенсорне введення увімкнено
drag-enabled = перетягування смуги прокручування увімкнено
keyboard-enabled = клавіатура увімкнена
autoscroll-enabled = авто-прокручування увімкнено
zooming-enabled = smooth pinch-zoom увімкнено

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = асинхронне введення коліщатком вимкнене, через непідтримуваний параметр: { $preferenceKey }
touch-warning = асинхронне сенсорне введення вимкнене, через непідтримуваний параметр: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = Неактивно
policies-active = Активно
policies-error = Помилка
