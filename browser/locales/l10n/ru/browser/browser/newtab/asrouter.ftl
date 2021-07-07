# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Рекомендуемое расширение
cfr-doorhanger-feature-heading = Рекомендуемая функция
cfr-doorhanger-pintab-heading = Попробуйте: Закрепление вкладок

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Почему я это вижу
cfr-doorhanger-extension-cancel-button = Не сейчас
    .accesskey = е
cfr-doorhanger-extension-ok-button = Добавить
    .accesskey = а
cfr-doorhanger-pintab-ok-button = Закрепить эту вкладку
    .accesskey = З
cfr-doorhanger-extension-manage-settings-button = Управление настройками рекомендаций
    .accesskey = п
cfr-doorhanger-extension-never-show-recommendation = Не показывать мне эту рекомендацию
    .accesskey = е
cfr-doorhanger-extension-learn-more-link = Подробнее
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = от { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Рекомендация
cfr-doorhanger-extension-notification2 = Рекомендация
    .tooltiptext = Рекомендация расширения
    .a11y-announcement = Доступна рекомендация расширения
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Рекомендация
    .tooltiptext = Рекомендация функции
    .a11y-announcement = Доступна рекомендация функции

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } звезда
            [few] { $total } звезды
           *[many] { $total } звёзд
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } пользователь
        [few] { $total } пользователя
       *[many] { $total } пользователей
    }
cfr-doorhanger-pintab-description = Получите лёгкий доступ к наиболее часто используемым вами сайтам. Оставляйте сайты открытыми (даже после перезапуска браузера).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Щёлкните правой кнопкой мыши</b> по вкладке, которую вы хотите закрепить.
cfr-doorhanger-pintab-step2 = Выберите <b>Закрепить вкладку</b> в меню.
cfr-doorhanger-pintab-step3 = Если на сайте произошло обновление, вы увидите синюю точку на закрепленной вкладке.
cfr-doorhanger-pintab-animation-pause = Приостановить
cfr-doorhanger-pintab-animation-resume = Возобновить

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Синхронизируйте свои закладки, где бы вы ни находились.
cfr-doorhanger-bookmark-fxa-body = Отличная находка! Не оставайтесь без этой закладки на своих мобильных устройствах. Создайте { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Синхронизировать закладки сейчас…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Кнопка закрытия
    .title = Закрыть

## Protections panel

cfr-protections-panel-header = Сёрфите по Интернету без слежки
cfr-protections-panel-body = Храните свои данные при себе. { -brand-short-name } защитит вас от многих наиболее известных трекеров, которые следят за вашим поведением в Интернете.
cfr-protections-panel-link-text = Подробнее

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Новая функция:
cfr-whatsnew-button =
    .label = Что нового
    .tooltiptext = Что нового
cfr-whatsnew-panel-header = Что нового
cfr-whatsnew-release-notes-link-text = Прочитать примечания к выпуску
cfr-whatsnew-fx70-title = { -brand-short-name } теперь ещё сильнее борется за вашу приватность
cfr-whatsnew-fx70-body = Последняя версия вносит улучшения в защиту от отслеживания и делает создание надёжных паролей для каждого сайта ещё более простым.
cfr-whatsnew-tracking-protect-title = Защитите себя от трекеров
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } блокирует многие социальные и межсайтовые трекеры, которые
    отслеживают вас в Интернете.
cfr-whatsnew-tracking-protect-link-text = Посмотреть мой отчёт
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Трекер заблокирован
        [few] Трекера заблокировано
       *[many] Трекеров заблокировано
    }
cfr-whatsnew-tracking-blocked-subtitle = С { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Посмотреть отчёт
cfr-whatsnew-lockwise-backup-title = Сделайте резервную копию паролей
cfr-whatsnew-lockwise-backup-body = Теперь можно генерировать надежные пароли и получать к ним доступ в любом месте.
cfr-whatsnew-lockwise-backup-link-text = Включить резервные копии
cfr-whatsnew-lockwise-take-title = Возьмите свои пароли с собой
cfr-whatsnew-lockwise-take-body = Приложение { -lockwise-brand-short-name } предоставляет вам безопасный доступ к резервным копиям паролей из любой точки мира.
cfr-whatsnew-lockwise-take-link-text = Загрузить приложение

## Search Bar

cfr-whatsnew-searchbar-title = С новой строкой адреса можно печатать меньше и находить больше
cfr-whatsnew-searchbar-body-topsites = Теперь щёлкните по адресной строке и она расширится списком ваших популярных сайтов.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Значок увеличительного стекла

## Picture-in-Picture

cfr-whatsnew-pip-header = Смотрите видео во время веб-сёрфинга
cfr-whatsnew-pip-body = Функция «Картинка в картинке» помещает видео в плавающее окно, чтобы вы могли смотреть его, работая в других вкладках.
cfr-whatsnew-pip-cta = Подробнее

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Меньше раздражающих всплывающих окон
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } теперь запрещает веб-сайтам автоматически просить показывать всплывающие окна.
cfr-whatsnew-permission-prompt-cta = Подробнее

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Сборщик цифровых отпечатков заблокирован
        [few] Сборщика цифровых отпечатков заблокировано
       *[many] Сборщиков цифровых отпечатков заблокировано
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } блокирует множество сборщиков цифровых отпечатков, которые тайно собирают информацию о вашем устройстве и действиях для создания вашего рекламного профиля.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Сборщики цифровых отпечатков
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } может блокировать сборщики цифровых отпечатков, которые тайно собирают информацию о вашем устройстве и действиях для создания вашего рекламного профиля.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Перенесите эту закладку на свой телефон
cfr-doorhanger-sync-bookmarks-body = Получайте доступ к закладкам, паролям, истории и другой информации на всех устройствах, где бы вы ни вошли в { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Включить { -sync-brand-short-name(case: "accusative") }…
    .accesskey = ю

## Login Sync

cfr-doorhanger-sync-logins-header = Никогда больше не забывайте пароли
cfr-doorhanger-sync-logins-body = Надёжно храните и синхронизируйте свои пароли со всеми вашими устройствами.
cfr-doorhanger-sync-logins-ok-button = Включить { -sync-brand-short-name(case: "accusative") }
    .accesskey = В

## Send Tab

cfr-doorhanger-send-tab-header = Читайте на ходу
cfr-doorhanger-send-tab-recipe-header = Возьмите этот рецепт на кухню
cfr-doorhanger-send-tab-body = Отправка вкладок позволяет вам легко поделиться этой ссылкой со своим телефоном или везде, где бы вы ни вошли в { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Испытайте отправку вкладки
    .accesskey = ы

## Firefox Send

cfr-doorhanger-firefox-send-header = Безопасно поделитесь этим PDF-документом
cfr-doorhanger-firefox-send-body = Защитите свои важные документы от посторонних глаз благодаря сквозному шифрованию и ссылке, которая исчезнет, когда это потребуется.
cfr-doorhanger-firefox-send-ok-button = Попробуйте { -send-brand-name }
    .accesskey = й

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Посмотреть защиту
    .accesskey = м
cfr-doorhanger-socialtracking-close-button = Закрыть
    .accesskey = к
cfr-doorhanger-socialtracking-dont-show-again = Больше не показывать мне подобные сообщения
    .accesskey = ш
cfr-doorhanger-socialtracking-heading = { -brand-short-name } не позволил социальной сети отслеживать вас здесь
cfr-doorhanger-socialtracking-description = Ваша приватность имеет значение. { -brand-short-name } теперь блокирует трекеры социальных сетей, ограничивая количество собираемых ими данных о вашей деятельности в Интернете.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } заблокировал сборщик цифровых отпечатков на этой странице
cfr-doorhanger-fingerprinters-description = Ваша приватность имеет значение. { -brand-short-name } теперь блокирует сборщики цифровых отпечатков, которые собирают уникальную информацию, используемую для идентификации устройства и слежения за вами.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } заблокировал криптомайнер на этой странице
cfr-doorhanger-cryptominers-description = Ваша приватность имеет значение. { -brand-short-name } теперь блокирует криптомайнеры, которые используют вычислительные мощности вашей системы для добычи цифровых валют.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } заблокировал более <b>{ $blockedCount }</b> трекера с { $date }!
        [few] { -brand-short-name } заблокировал более <b>{ $blockedCount }</b> трекеров с { $date }!
       *[many] { -brand-short-name } заблокировал более <b>{ $blockedCount }</b> трекеров с { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] С { DATETIME($date, month: "long", year: "numeric") }! { -brand-short-name } заблокировал более <b>{ $blockedCount }</b> трекера
        [few] С { DATETIME($date, month: "long", year: "numeric") }! { -brand-short-name } заблокировал более <b>{ $blockedCount }</b> трекеров
       *[many] С { DATETIME($date, month: "long", year: "numeric") }! { -brand-short-name } заблокировал более <b>{ $blockedCount }</b> трекеров
    }
cfr-doorhanger-milestone-ok-button = Посмотреть всё
    .accesskey = о

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Легко создавайте надёжные пароли
cfr-whatsnew-lockwise-body = Придумать уникальные, безопасные пароли для каждого аккаунта — непростая задача. При создании пароля, нажмите на поле ввода пароля, чтобы использовать безопасный, сгенерированный пароль от { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Значок { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Получайте оповещения об уязвимых паролях
cfr-whatsnew-passwords-body = Хакеры знают, что люди повторно используют одни и те же пароли. Если вы использовали одинаковый пароль на нескольких веб-сайтах, и на одном из них произошла утечка данных, вы получите предупреждение от { -lockwise-brand-short-name }, чтобы вы смогли сменить пароль на остальных сайтах.
cfr-whatsnew-passwords-icon-alt = Значок «Ключ уязвимого пароля»

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = «Картинка в картинке» в полноэкранном режиме
cfr-whatsnew-pip-fullscreen-body = Теперь, когда вы выносите видео в плавающее окно, вы можете дважды щёлкнуть по этому окну и перейти в полноэкранный режим.
cfr-whatsnew-pip-fullscreen-icon-alt = Значок «Картинка в картинке»

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Закрыть
    .accesskey = к

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Быстрый обзор состояния защиты
cfr-whatsnew-protections-body = Панель состояния защиты содержит сводные отчеты об утечках данных и управлении паролями. Теперь вы можете отслеживать, со сколькими утечками данных вы разобрались, и видеть, были ли какие-либо из ваших сохранённых паролей затронуты утечками данных.
cfr-whatsnew-protections-cta-link = Посмотреть панель состояния защиты
cfr-whatsnew-protections-icon-alt = Значок щита

## Better PDF message

cfr-whatsnew-better-pdf-header = Улучшена работа с PDF
cfr-whatsnew-better-pdf-body = Документы PDF теперь можно открывать прямо в { -brand-short-name }, что ускоряет доступ к ним во время работы.

## DOH Message

cfr-doorhanger-doh-body = Ваша приватность имеет значение. Теперь, если это возможно, { -brand-short-name } безопасно перенаправляет ваши DNS-запросы в партнёрскую службу, чтобы защитить вас во время Интернет-сёрфинга.
cfr-doorhanger-doh-header = Более безопасный, зашифрованный поиск адресов сайтов в DNS
cfr-doorhanger-doh-primary-button-2 = Хорошо
    .accesskey = ш
cfr-doorhanger-doh-secondary-button = Отключить
    .accesskey = ю

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Ваша приватность имеет значение. { -brand-short-name } теперь изолирует веб-сайты друг от друга, помещая их в так называемые «песочницы», так что теперь хакерам станет труднее украсть пароли, данные банковских карт и другую важную для вас информацию.
cfr-doorhanger-fission-header = Изоляция сайта
cfr-doorhanger-fission-primary-button = OK, понятно
    .accesskey = я
cfr-doorhanger-fission-secondary-button = Подробнее
    .accesskey = н

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Автоматическая защита от различных трекеров.
cfr-whatsnew-clear-cookies-body = Некоторые трекеры перенаправляют вас на другие сайты, которые тайно устанавливают куки. { -brand-short-name } теперь автоматически удаляет эти куки, чтобы за вами не следили.
cfr-whatsnew-clear-cookies-image-alt = Иллюстрация заблокированной куки

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Больше средств управления медиа
cfr-whatsnew-media-keys-body = Начинайте и останавливайте воспроизведение аудио или видео при помощи вашей клавиатуры или наушников, делая удобным контроль воспроизведения из другой вкладки, программы, или даже экрана блокировки компьютера. Кроме того, вы можете переключаться между треками, используя клавиши вперед и назад.
cfr-whatsnew-media-keys-button = Узнайте как

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Быстрые клавиши для поиска в адресной строке
cfr-whatsnew-search-shortcuts-body = Теперь при наборе названия поисковой системы или определенного сайта в адресной строке, под ней, в поисковых предложениях, появится синий ярлык. Выберите этот ярлык, чтобы совершить поиск прямо из адресной строки.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Защита от вредоносных суперкук
cfr-whatsnew-supercookies-body = Веб-сайты могут тайно устанавливать «суперкуки» в вашем браузере, которые могут отслеживать вас в Интернете, даже если вы удалите все куки. { -brand-short-name } теперь обеспечивает надёжную защиту против суперкук, так что их нельзя будет использовать для межсайтового отслеживания.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Улучшенные закладки
cfr-whatsnew-bookmarking-body = Стало проще следить за своими любимыми сайтами. { -brand-short-name } теперь запоминает место, куда вы предпочитаете сохранять закладки, показывает панель закладок по умолчанию в новых вкладках, а также позволяет легко получить доступ к остальным закладкам через папку на панели инструментов.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Комплексная защита от межсайтового отслеживания куками
cfr-whatsnew-cross-site-tracking-body = Теперь вы можете включить улучшенную защиту от отслеживающих кук. { -brand-short-name } может изолировать ваши действия и данные для сайта, на котором вы сейчас находитесь, поэтому данные, хранящиеся в браузере, не будут передаваться между веб-сайтами.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = В этой версии { -brand-short-name } видео на этом сайте может воспроизводиться некорректно. Для полноценной поддержки видео обновите { -brand-short-name }.
cfr-doorhanger-video-support-header = Для воспроизведения видео обновите { -brand-short-name }
cfr-doorhanger-video-support-primary-button = Обновить сейчас
    .accesskey = с
