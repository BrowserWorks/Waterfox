# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: «Masonry-раскладка»
experimental-features-css-masonry-description = Включает поддержку экспериментальной «Masonry-раскладки» в CSS. Прочтите <a data-l10n-name="explainer">объяснения</a> для получения высокоуровневого описания функции. Оставляйте свои отзывы и комментарии в <a data-l10n-name="w3c-issue">этой issue на GitHub</a> или в <a data-l10n-name="bug">этом баг-репорте</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Этот новый API предоставляет низкоуровневую поддержку совершения вычислений и отображения графики с помощью <a data-l10n-name="wikipedia">графических процессоров (GPU)</a> компьютера пользователя. <a data-l10n-name="spec">Спецификация</a> всё ещё находится в разработке. Дополнительную информацию можно узнать в  <a data-l10n-name="bugzilla">баге 1602129</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Если эта функция включена, { -brand-short-name } будет поддерживать формат AV1 Image File (AVIF). Это формат файлов неподвижных изображений, который использует возможности алгоритмов сжатия видео AV1, чтобы уменьшить размер файла. Дополнительная информация доступна в <a data-l10n-name="bugzilla">баге 1443863</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = Медиа: JPEG XL
experimental-features-media-jxl-description = При включении этой функции, { -brand-short-name } начнёт поддерживать формат JPEG XL (JXL). Это улучшенный формат файлов изображений, который поддерживает сжатие без потерь обычных файлов JPEG. Дополнительная информация доступна в <a data-l10n-name="bugzilla">баге 1539075</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Наша реализация глобального атрибута <a data-l10n-name="mdn-inputmode">inputmode</a> была обновлена в соответствии со <a data-l10n-name="whatwg">спецификацией WHATWG</a>, однако нам нужно произвести дополнительные изменения, такие как обеспечить его доступность для "contenteditable" содержимого. Дополнительная информация доступна в <a data-l10n-name="bugzilla">баге 1205133</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Добавление конструктора к интерфейсу <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, а также ряд связанных с этим изменений позволяют напрямую создавать новые таблицы стилей без необходимости добавления листа в HTML. Это значительно упрощает создание таблиц стилей многократного использования с <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Для получения дополнительной информации прочитайте  <a data-l10n-name="bugzilla">баг 1520690</a>.
experimental-features-devtools-color-scheme-simulation =
    .label = Инструменты разработчика: Симуляция цветовой схемы
experimental-features-devtools-color-scheme-simulation-description = Добавляет опцию для симуляции различных цветовых схем, позволяющую тестировать медиазапросы <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a>. Использование этого медиазапроса позволяет вашей таблице стилей ответить на то, предпочитает ли пользователь светлый или тёмный интерфейс пользователя. Эта функция позволяет вам тестировать код без необходимости изменять настройки в вашем браузере (или операционной системе, если браузер следует общесистемной настройке цветовой схемы). Для получения дополнительной информации прочитайте <a data-l10n-name="bugzilla1">баг 1550804</a> и <a data-l10n-name="bugzilla2">баг 1137699</a>.
experimental-features-devtools-execution-context-selector =
    .label = Инструменты разработчика: Выбор контекста выполнения
experimental-features-devtools-execution-context-selector-description = Эта функция отображает кнопку в командной строке консоли, позволяющую изменить контекст, в котором будет выполняться введённое вами выражение. Для получения дополнительной информации прочитайте <a data-l10n-name="bugzilla1">баг 1605154</a> и <a data-l10n-name="bugzilla2">баг 1605153</a>.
experimental-features-devtools-compatibility-panel =
    .label = Инструменты разработчика: Панель совместимости
experimental-features-devtools-compatibility-panel-description = Боковая панель для Инспектора страниц, отображающая информацию о состоянии кроссбраузерной совместимости вашего приложения. Для получения дополнительной информации прочитайте <a data-l10n-name="bugzilla">баг 1584464</a>.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Куки: SameSite = Lax по умолчанию
experimental-features-cookie-samesite-lax-by-default2-description = Рассматривать куки по умолчанию как «SameSite = Lax», если не указан атрибут «SameSite». Чтобы работать в режиме текущего статус-кво неограниченного использования, разработчики должны будут в явном виде указывать «SameSite = None».
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Куки: SameSite = None требует атрибута «secure»
experimental-features-cookie-samesite-none-requires-secure2-description = Куки с атрибутом «SameSite = None» требуют атрибута «secure». Для работы этой функции необходимо включить «Куки: SameSite = Lax по умолчанию».
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = Кэш запуска about:home
experimental-features-abouthome-startup-cache-description = Кэш для изначального документа about:home, который загружается по умолчанию при запуске. Целью кеша является повышение скорости запуска.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Куки: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Рассматривать куки из одинакового домена, но с отличающимися схемами (например, http://example.com и https://example.com) как межсайтовые, а не относящиеся к одному сайту. Повышает безопасность, но потенциально может привести к нарушению работы.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Инструменты разработчика: Отладка Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Добавляет экспериментальную поддержку Service Workers'ов на Панель отладчика. Это функция может замедлять работу Инструментов разработчика и увеличить потребление памяти.
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Переключатель глобального отключения звука WebRTC
experimental-features-webrtc-global-mute-toggles-description = Добавляет элементы управления к глобальному индикатору доступа WebRTC, который позволяет пользователям глобально отключать доступ к их микрофону и камере.
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Блокировка Win32k
experimental-features-win32k-lockdown-description = Запрещает использование API Win32k во вкладках браузера. Повышает безопасность, однако в данный момент это может работать нестабильно или с ошибками (только в Windows).
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Активирует проект Warp, повышающий производительность JavaScript и снижающий потребление памяти.
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission (изоляция сайта)
experimental-features-fission-description = Fission (изоляция сайта) — это экспериментальная функция в { -brand-short-name }, обеспечивающая дополнительный уровень защиты от ошибок системы безопасности. Изолируя каждый сайт в отдельный процесс, Fission затрудняет доступ вредоносных веб-сайтов к информации с других посещаемых вами страниц. Это серьезное архитектурное изменение в { -brand-short-name }, и мы будем благодарны вас за тестирование и сообщения о любых проблемах, с которыми вы можете столкнуться. Для получения дополнительных сведений прочтите <a data-l10n-name="wiki">вики</a>.
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = Поддержка нескольких окон «Картинка в картинке»
experimental-features-multi-pip-description = Экспериментальная поддержка, позволяющая одновременно открывать несколько окон «Картинка в картинке».
experimental-features-http3 =
    .label = Протокол HTTP/3
experimental-features-http3-description = Экспериментальная поддержка протокола HTTP/3.
# Search during IME
experimental-features-ime-search =
    .label = Адресная строка: показывать результаты при составлении IME
experimental-features-ime-search-description = IME (Input Method Editor - Редактор методов ввода) - это инструмент, позволяющий вводить сложные символы, например, используемые в письменности языков Восточной Азии или Индии, с помощью стандартной клавиатуры. Включение этого эксперимента позволит держать панель адресной строки открытой, показывая результаты поиска и предложения при использовании IME для ввода текста. Обратите внимание, что IME может отображать панель, закрывающую результаты адресной строки, поэтому данная настройка предлагается только для IME не использующего этот тип панели.
