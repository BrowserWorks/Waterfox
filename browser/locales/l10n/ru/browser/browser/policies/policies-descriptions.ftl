# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = Устанавливает политики, по которым WebExtensions могут получать доступ через chrome.storage.managed.
policy-AllowedDomainsForApps = Определяет домены, которым разрешен доступ к Google Workspace.
policy-AppAutoUpdate = Включает или отключает автообновление приложения.
policy-AppUpdateURL = Устанавливает собственный URL обновления приложения.
policy-Authentication = Настраивает интегрированную авторизацию для поддерживающих это веб-сайтов.
policy-AutoLaunchProtocolsFromOrigins = Определяет список внешних протоколов, которые могут быть вызваны из указанных источников без запроса пользователя.
policy-BackgroundAppUpdate2 = Включает или отключает фоновое обновление.
policy-BlockAboutAddons = Блокирует доступ к менеджеру дополнений (about:addons).
policy-BlockAboutConfig = Блокирует доступ к странице about:config.
policy-BlockAboutProfiles = Блокирует доступ к странице about:profiles.
policy-BlockAboutSupport = Блокирует доступ к странице about:support.
policy-Bookmarks = Создаёт закладки в панели закладок, меню закладок, или в отдельной папке внутри них.
policy-CaptivePortal = Включает или отключает поддержку перехватывающего портала.
policy-CertificatesDescription = Добавляет сертификаты или использует встроенные сертификаты.
policy-Cookies = Разрешает или запрещает веб-сайтам устанавливать куки.
policy-DisabledCiphers = Отключает шифры.
policy-DefaultDownloadDirectory = Устанавливает каталог для загрузок по умолчанию.
policy-DisableAppUpdate = Запрещает обновление браузера.
policy-DisableBuiltinPDFViewer = Отключает PDF.js, встроенный просмотрщик PDF в { -brand-short-name }.
policy-DisableDefaultBrowserAgent = Не позволяет агенту браузера по умолчанию предпринимать какие-либо действия. Применимо только к Windows; на других платформах агента нет.
policy-DisableDeveloperTools = Блокирует доступ к инструментам разработчика.
policy-DisableFeedbackCommands = Отключает команды отправки отзывов в меню Справка («Отправить отзыв...» и «Сообщить о поддельном сайте...»).
policy-DisableFirefoxAccounts = Отключает службы, основанные на { -fxaccount-brand-name(case: "prepositional") }, включая Синхронизацию.
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Отключает функцию Firefox Screenshots.
policy-DisableFirefoxStudies = Запрещает { -brand-short-name } выполнять исследования.
policy-DisableForgetButton = Закрывает доступ к кнопке «Забыть».
policy-DisableFormHistory = Отключает запоминание истории поиска и данных форм.
policy-DisableMasterPasswordCreation = Не позволяет установить мастер-пароль, если установлена в true.
policy-DisablePrimaryPasswordCreation = Не позволяет установить мастер-пароль, если установлена в true.
policy-DisablePasswordReveal = Не позволяет просматривать пароли у сохранённых логинов.
policy-DisablePocket = Отключает сохранение страниц в Pocket.
policy-DisablePrivateBrowsing = Отключает приватный просмотр.
policy-DisableProfileImport = Отключает команду меню для импорта данных из другого браузера.
policy-DisableProfileRefresh = Отключает кнопку Обновить { -brand-short-name } на странице about:support.
policy-DisableSafeMode = Отключает функцию для перезапуска в безопасном режиме. Примечание: Клавишу Shift для входа в безопасный режим можно отключить только в Windows с помощью групповой политики.
policy-DisableSecurityBypass = Не даёт пользователю игнорировать определенные предупреждения системы безопасности.
policy-DisableSetAsDesktopBackground = Отключает команду меню «Сделать фоновым рисунком рабочего стола…» для изображений.
policy-DisableSystemAddonUpdate = Запрещает браузеру устанавливать и обновлять системные дополнения.
policy-DisableTelemetry = Отключает телеметрию.
policy-DisplayBookmarksToolbar = Отображает панель закладок по умолчанию.
policy-DisplayMenuBar = Отображает панель меню по умолчанию.
policy-DNSOverHTTPS = Настраивает DNS через HTTPS.
policy-DontCheckDefaultBrowser = Отключает проверку браузера по умолчанию при запуске.
policy-DownloadDirectory = Устанавливает и фиксирует каталог для загрузок.
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = Включает или отключает Блокировку содержимого и, по желанию, блокирует изменение этой функции.
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = Включает или отключает Encrypted Media Extensions и, по желанию, блокирует изменение этой функции.
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = Устанавливает, удаляет или блокирует установку/удаление расширений. Параметр «Установка» использует URL-адреса или пути в качестве параметров. Параметры «Удаление» и «Блокировка» принимают идентификаторы расширений.
policy-ExtensionSettings = Управляет всеми аспектами установки расширений.
policy-ExtensionUpdate = Включает или отключает автоматические обновления расширений.
policy-FirefoxHome = Настраивает домашнюю страницу Firefox.
policy-FlashPlugin = Разрешает или запрещает использование плагина Flash.
policy-Handlers = Настраивает обработчики приложений по умолчанию.
policy-HardwareAcceleration = Отключает аппаратное ускорение, если установлена в false.
# “lock” means that the user won’t be able to change this setting
policy-Homepage = Устанавливает домашнюю страницу и, по желанию, блокирует её смену.
policy-InstallAddonsPermission = Разрешает некоторым веб-сайтам устанавливать дополнения.
policy-LegacyProfiles = Отключает функцию для принудительного создания отдельного профиля для каждой установки

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = Использовать устаревшее поведение атрибута SameSite куки по умолчанию.
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = Переключиться на устаревшее поведение SameSite для кук на выбранных сайтах.

##

policy-LocalFileLinks = Разрешает определённым веб-сайтам ссылаться на локальные файлы.
policy-ManagedBookmarks = Настраивает список закладок, управляемых администратором и недоступных для изменения пользователем.
policy-MasterPassword = Требовать или не давать использовать мастер-пароль.
policy-ManualAppUpdateOnly = Разрешать только обновления вручную и не уведомлять пользователя об обновлениях.
policy-PrimaryPassword = Требовать или не давать использовать мастер-пароль.
policy-NetworkPrediction = Включает или отключает прогнозирование сети (предварительная выборка DNS).
policy-NewTabPage = Включает или отключает страницу новой вкладки.
policy-NoDefaultBookmarks = Отключает создание закладок по умолчанию, идущих вместе с { -brand-short-name }, и Умных Закладок (Часто посещаемые, Последние метки). Примечание: эта политика действует только в том случае, если она используется до первого запуска профиля.
policy-OfferToSaveLogins = Разрешает { -brand-short-name } предлагать запоминать сохранённые логины и пароли. Принимаются значения как true, так и false.
policy-OfferToSaveLoginsDefault = Устанавливает значение по умолчанию, чтобы разрешить { -brand-short-name } предлагать запоминать сохранённые логины и пароли. Принимаются значения как true, так и false.
policy-OverrideFirstRunPage = Переопределяет первую страницу после запуска. Установите эту политику в пустую, если хотите отключить первую страницу после запуска.
policy-OverridePostUpdatePage = Переопределяет страницу «Что нового», открывающуюся после обновления. Установите эту политику в пустую, если хотите отключить страницу, открывающуюся после обновления.
policy-PasswordManagerEnabled = Включает сохранение паролей в менеджере паролей.
# PDF.js and PDF should not be translated
policy-PDFjs = Отключает или настраивает PDF.js, встроенный просмотрщик PDF в { -brand-short-name }.
policy-Permissions2 = Настраивает разрешения для камеры, микрофона, местоположения, уведомлений и автовоспроизведения.
policy-PictureInPicture = Включает или отключает функцию «Картинка в картинке».
policy-PopupBlocking = Разрешает некоторым веб-сайтам открывать всплывающие окна по умолчанию.
policy-Preferences = Устанавливает и фиксирует значение набора настроек.
policy-PromptForDownloadLocation = Спрашивает, куда сохранять файлы при загрузке.
policy-Proxy = Настраивает параметры прокси.
policy-RequestedLocales = Настраивает список запрашиваемых языков для приложения в порядке предпочтения.
policy-SanitizeOnShutdown2 = Удаляет данные веб-сёрфинга при закрытии браузера.
policy-SearchBar = Устанавливает расположение панели поиска по умолчанию. Пользователю всё же разрешено его настраивать.
policy-SearchEngines = Настраивает параметры поисковой системы. Эта политика доступна только в версии длительной поддержки (ESR).
policy-SearchSuggestEnabled = Включает или отключает поисковые предложения.
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = Устанавливает модули PKCS #11.
policy-ShowHomeButton = Включает кнопку «Домой» на панели инструментов.
policy-SSLVersionMax = Устанавливает максимальную версию SSL.
policy-SSLVersionMin = Устанавливает минимальную версию SSL.
policy-SupportMenu = Добавляет настраиваемый пункт меню поддержки в меню справки.
policy-UserMessaging = Позволяет не показывать определённые сообщения пользователю.
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = Блокирует посещение веб-сайтов. Для получения дополнительной информации о формате обратитесь к документации.
