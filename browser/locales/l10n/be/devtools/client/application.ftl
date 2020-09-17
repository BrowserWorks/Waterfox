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
serviceworker-list-header = Service Workers
# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = Адкрыць <a>about:debugging</a> для Service Workers з іншых даменаў
# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Скасаваць рэгістрацыю
# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = Адладка
    .title = Можна адладжваць толькі запушчаныя service workers
# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = Адладзіць
    .title = Service worker-ы можна адладжваць толькі калі множны e10s выключаны
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = Запусціць
    .title = Service worker-ы можна запускаць толькі калі множны e10s выключаны
# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = Даследаваць
# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = Запусціць
# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = Абноўлена <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>
# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = Крыніца
# Text displayed next to the current status of the service worker.
serviceworker-worker-status = Стан

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = Выконваецца
# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = Спынены
# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = Каб інспектаваць Service Worker тут, яго трэба зарэгістраваць. <a>Даведацца больш</a>
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = Калі гэта старонка павінна мець service worker, вы можаце паспрабаваць наступнае
# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = Праверыць наяўнасць памылак у Кансолі. <a>Адкрыць Кансоль</a>
# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Прайсці праз рэгістрацыю вашага Service Worker і праверыць выключэнні. <a>Адкрыць Адладчык</a>
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = Інспектаваць Service Workers з іншых даменаў. <a>Адкрыць about:debugging</a>
# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Service workers не знойдзены
# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = Даведацца больш
# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = Калі гэтая старонка мусіць мець service worker, Вы можаце адшукаць памылкі ў <a>Кансолі</a> ці праверыць рэгістрацыю Вашага service worker у <span>Адладчыку</span>.
# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = Праглядзець service workers з іншых даменаў
# Header for the Manifest page when we have an actual manifest
manifest-view-header = Маніфест праграмы
# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = Маніфест для даследавання не знойдзены.
# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = Маніфест web-праграмы не знойдзены
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = Даведайцеся, як дадаць маніфест
# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = Памылкі і папярэджанні
# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = Ідэнтычнасць
# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = Прэзентацыя
# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = Значкі
# Text displayed while we are loading the manifest file
manifest-loading = Зацягванне маніфеста…
# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = Маніфест зацягнуты.
# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = Пры зацягванні маніфеста ўзнікла памылка:
# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Памылка прылад распрацоўшчыка Firefox
# Text displayed when the page has no manifest available
manifest-non-existing = Маніфест для даследавання не знойдзены.
# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = Маніфест убудаваны ў URL дадзеных.
# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = Прызначэнне: <code>{ $purpose }</code>
# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = Значок
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = Значок з памерамі: { $sizes }
# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = Неўказаны памер значка
# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Маніфест
    .alt = Значок маніфеста
    .title = Маніфест
# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Workers
    .alt = Значок Service Workers
    .title = Service Workers
# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = Значок папярэджання
    .title = Папярэджанне
# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = Значок памылкі
    .title = Памылка
