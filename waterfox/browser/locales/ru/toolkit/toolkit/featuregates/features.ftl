# This Source Code Form is subject to the terms of the Waterfox Public
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
experimental-features-media-jxl =
    .label = Медиа: JPEG XL
experimental-features-media-jxl-description = При включении этой функции, { -brand-short-name } начнёт поддерживать формат JPEG XL (JXL). Это улучшенный формат файлов изображений, который поддерживает сжатие без потерь обычных файлов JPEG. Дополнительная информация доступна в <a data-l10n-name="bugzilla">баге 1539075</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Добавление конструктора к интерфейсу <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, а также ряд связанных с этим изменений позволяют напрямую создавать новые таблицы стилей без необходимости добавления листа в HTML. Это значительно упрощает создание таблиц стилей многократного использования с <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Для получения дополнительной информации прочитайте  <a data-l10n-name="bugzilla">баг 1520690</a>.
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
experimental-features-abouthome-startup-cache-description = Кэширование начальной страницы about:home, по умолчанию загружающейся при запуске. Целью кэширования является повышение скорости запуска.
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
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Активирует проект Warp, повышающий производительность JavaScript и снижающий потребление памяти.
# Search during IME
experimental-features-ime-search =
    .label = Адресная строка: показывать результаты при составлении IME
experimental-features-ime-search-description = IME (Input Method Editor - Редактор методов ввода) - это инструмент, позволяющий вводить сложные символы, например, используемые в письменности языков Восточной Азии или Индии, с помощью стандартной клавиатуры. Включение этого эксперимента позволит держать панель адресной строки открытой, показывая результаты поиска и предложения при использовании IME для ввода текста. Обратите внимание, что IME может отображать панель, закрывающую результаты адресной строки, поэтому данная настройка предлагается только для IME не использующего этот тип панели.
# Text recognition for images
experimental-features-text-recognition =
    .label = Распознавание текста
experimental-features-text-recognition-description = Включает функцию распознавания текста на изображениях.
experimental-features-accessibility-cache =
    .label = Кэш поддержки доступности
experimental-features-accessibility-cache-description = Кэширует всю информацию о поддержке доступности из всех документов в основном процессе { -brand-short-name }. Это повышает производительность программ чтения с экрана и других приложений, использующих API поддержки доступности.
