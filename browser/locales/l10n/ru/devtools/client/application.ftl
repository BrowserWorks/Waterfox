# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.


### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

# Header for the list of Service Workers displayed in the application panel for the current page.
serviceworker-list-header = Service Worker'ы
# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Откройте <a>about:debugging</a> для отображения Service Worker'ов с других доменов
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Отменить регистрацию
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Отладить
    .title = Только запущенные service workers могут быть отлажены
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Отладить
    .title = Вы можете отлаживать service workers только при отключённой multi e10s
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Запустить
    .title = Вы можете запускать service workers только при отключённой multi e10s
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Исследовать
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Запустить
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Обновлён <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Источник
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Состояние

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Выполняется
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Остановлен
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Вам нужно зарегистрировать Service Worker, чтобы исследовать его здесь. <a>Подробнее</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Если на текущей странице должен быть service worker, то попробуйте следующее
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Поищите ошибки в Консоли. <a>Открыть Консоль</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Пройдите по шагам процедуру регистрации cвоего Service Worker и поищите исключения. <a>Открыть Отладчик</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Исследуйте Service Worker'ы с других доменов. <a>Открыть about:debugging</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Service worker'ов не найдено
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Подробнее
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Если на текущей странице должен быть service worker, вы можете поискать ошибки в <a>Консоли</a> или проверить регистрацию вашего service worker в <span>Отладчике</span>.
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Просмотр service worker'ов с других доменов
# Header for the Manifest page when we have an actual manifest
manifest-view-header = Манифест приложения
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Вам необходимо добавить манифест веб-приложения, чтобы исследовать его здесь. <a>Подробнее</a>
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Манифест веб-приложения не обнаружен
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Узнайте, как добавить манифест
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Ошибки и предупреждения
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Идентификатор
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Презентация
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Значки
# Text displayed while we are loading the manifest file
manifest-loading = Загрузка манифеста…
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Манифест загружен.
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = При загрузка манифеста произошла ошибка:
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Ошибка инструментов разработчика Firefox
# Text displayed when the page has no manifest available
manifest-non-existing = Не найден манифест для отладки.
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Манифест встроен в Data URL.
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Назначение: <code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Значок
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Значок с размером: { $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Неуказанный размер значка
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Манифест
    .alt = Значок манифеста
    .title = Манифест
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Worker'ы
    .alt = Значок Service Worker'ов
    .title = Service Worker'ы
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Значок предупреждения
    .title = Предупреждение
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Значок ошибки
    .title = Ошибка
