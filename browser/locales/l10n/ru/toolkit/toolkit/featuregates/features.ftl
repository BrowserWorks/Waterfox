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
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Наша реализация глобального атрибута <a data-l10n-name="mdn-inputmode">inputmode</a> была обновлена в соответствии со <a data-l10n-name="whatwg">спецификацией WHATWG</a>, однако нам нужно произвести дополнительные изменения, такие как обеспечить его доступность для "contenteditable" содержимого. Дополнительная информация доступна в <a data-l10n-name="bugzilla">баге 1205133</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = Атрибут <a data-l10n-name="rel">rel</a> со значением <code>"preload"</code> в элементе <a data-l10n-name="link">&lt;link&gt;</a> предназначен для повышения производительности, позволяя вам загружать ресурсы на более ранних этапах жизненного цикла страницы, гарантируя, что они доступны раньше и с меньшей вероятностью блокируя рендеринг страниц. Для получения дополнительной информации прочитайте <a data-l10n-name="readmore">“Предзагрузка содержимого с помощью <code>rel="preload"</code>”</a> или прочитайте  <a data-l10n-name="bugzilla">баг 1583604</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Позволяет применять стили фокусировки к таким элементам, как кнопки и элементы управления формами, только тогда, когда на них переведён фокус с помощью клавиатуры (например, при перемещении между элементами), а не когда на них переведён фокус с помощью мыши или другого указательного устройства. Для получения дополнительной информации прочитайте <a data-l10n-name="bugzilla">баг 1617600</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = Глобальное событие <a data-l10n-name="mdn-beforeinput">beforeinput</a> запускается для элементов <a data-l10n-name="mdn-input">&lt;input&gt;</a> и <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a> или любого элемента, у которого включён атрибут <a data-l10n-name="mdn-contenteditable">contenteditable</a>, непосредственно перед изменением значения элемента. Это событие позволяет веб-приложениям переопределять поведение браузера по умолчанию для взаимодействия с пользователем, например, веб-приложения могут отменять пользовательский ввод данных только для определённых символов или могут изменять стиль вставляемого текста на утверждённые стили.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = Добавление конструктора к интерфейсу <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a>, а также ряд связанных с этим изменений позволяют напрямую создавать новые таблицы стилей без необходимости добавления листа в HTML. Это значительно упрощает создание таблиц стилей многократного использования с <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Для получения дополнительной информации прочитайте  <a data-l10n-name="bugzilla">баг 1520690</a>.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = Вся реализация Media Session API в { -brand-short-name } на данный момент является экспериментальной. Это API используется для настройки обработки уведомлений, связанных с мультимедиа, для управления событиями и данными, полезными для представления пользовательского интерфейса для управления воспроизведением мультимедиа, а также для получения метаданных мультимедиа-файла. Для получения дополнительной информации прочитайте <a data-l10n-name="bugzilla">баг 1112032</a>.

experimental-features-devtools-color-scheme-simulation =
    .label = Инструменты разработчика: Симуляция цветовой схемы
experimental-features-devtools-color-scheme-simulation-description = Добавляет опцию для симуляции различных цветовых схем, позволяющую тестировать медиазапросы <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a>. Использование этого медиазапроса позволяет вашей таблице стилей ответить на то, предпочитает ли пользователь светлый или тёмный интерфейс пользователя. Эта функция позволяет вам тестировать код без необходимости изменять настройки в вашем браузере (или операционной системе, если браузер следует общесистемной настройке цветовой схемы). Для получения дополнительной информации прочитайте <a data-l10n-name="bugzilla1">баг 1550804</a> и <a data-l10n-name="bugzilla2">баг 1137699</a>.

experimental-features-devtools-execution-context-selector =
    .label = Инструменты разработчика: Выбор контекста выполнения
experimental-features-devtools-execution-context-selector-description = Эта функция отображает кнопку в командной строке консоли, позволяющую изменить контекст, в котором будет выполняться введённое вами выражение. Для получения дополнительной информации прочитайте <a data-l10n-name="bugzilla1">баг 1605154</a> и <a data-l10n-name="bugzilla2">баг 1605153</a>.

experimental-features-devtools-compatibility-panel =
    .label = Инструменты разработчика: Панель совместимости
experimental-features-devtools-compatibility-panel-description = Боковая панель для Инспектора страниц, отображающая информацию о состоянии кросс-браузерной совместимости  вашего приложения. Для получения дополнительной информации прочитайте <a data-l10n-name="bugzilla">баг 1584464</a>.

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

experimental-features-print-preview-tab-modal =
    .label = Переработанный предварительный просмотр печати
experimental-features-print-preview-tab-modal-description = Активирует переработанный предварительный просмотр печати, а также добавляет предварительный просмотр печати на macOS. Потенциально, это может привести к ошибкам, и не включает в себя все настройки, связанные с печатью. Чтобы открыть все настройки, связанные с печатью, выберите «Печатать, используя системный диалог…» из панели «Печать».

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Куки: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Рассматривать куки из одинакового домена, но с отличающимися схемами (например, http://example.com и https://example.com) как кросс-сайтовые, а не относящиеся к одному сайту. Повышает безопасность, но потенциально может привести к нарушению работы.

# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Инструменты разработчика: Отладка Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Включает экспериментальную поддержку для Service Workers на Панели отладчика. Это функция может замедлять работу Инструментов разработчика и увеличить потребление памяти.

# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Графика: Smooth Pinch Zoom
experimental-features-graphics-desktop-zooming-description = Включение поддержки плавного масштабирования на сенсорных экранах и точных сенсорных панелях.
