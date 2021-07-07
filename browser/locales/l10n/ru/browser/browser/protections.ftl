# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } заблокировал { $count } трекер за последнюю неделю
        [few] { -brand-short-name } заблокировал { $count } трекера за последнюю неделю
       *[many] { -brand-short-name } заблокировал { $count } трекеров за последнюю неделю
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> трекер заблокирован с { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] <b>{ $count }</b> трекера заблокировано с { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[many] <b>{ $count }</b> трекеров заблокировано с { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } продолжает блокировать трекеры во время работы в режиме Приватного просмотра, но не ведет запись того, что было заблокировано.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Трекеры, заблокированные { -brand-short-name } на этой неделе.
protection-report-webpage-title = Панель состояния защиты
protection-report-page-content-title = Панель состояния защиты
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } может незаметно защищать вашу приватность во время пребывания в Интернете. Это персонализированная сводка состояния защиты, включая средства контроля вашей безопасности в Интернете.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } незаметно защищает вашу приватность во время пребывания в Интернете. Это персонализированная сводка состояния защиты, включая средства контроля вашей безопасности в Интернете.
protection-report-settings-link = Управление настройками защиты и приватности
etp-card-title-always = Улучшенная защита от отслеживания: всегда включена
etp-card-title-custom-not-blocking = Улучшенная защита от отслеживания: ОТКЛЮЧЕНА
etp-card-content-description = { -brand-short-name } автоматически блокирует тайную слежку компаний за вами в Интернете.
protection-report-etp-card-content-custom-not-blocking = Все защиты в настоящее время отключены. Выберите, какие трекеры нужно блокировать, управляя настройками защиты { -brand-short-name }.
protection-report-manage-protections = Управление настройками
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Сегодня
# This string is used to describe the graph for screenreader users.
graph-legend-description = График содержит общее число трекеров каждого типа, заблокированных на этой неделе.
social-tab-title = Трекеры социальных сетей
social-tab-contant = Социальные сети размещают трекеры на других веб-сайтах, чтобы следить за тем, что вы делаете, видите и смотрите в Интернете. Это позволяет их владельцам узнавать о вас больше, чем вы указываете в своих профилях в социальных сетях. <a data-l10n-name="learn-more-link">Подробнее</a>
cookie-tab-title = Межсайтовые отслеживающие куки
cookie-tab-content = Такие куки ходят за вами с сайта на сайт для сбора информации о том, что вы делаете в Интернете. Они устанавливаются такими сторонними организациями, как рекламодатели и аналитические компании. Блокировка межсайтовых отслеживающих куков снижает количество рекламы, отслеживающей вас. <a data-l10n-name="learn-more-link">Подробнее</a>
tracker-tab-title = Отслеживающее содержимое
tracker-tab-description = Веб-сайты могут загружать внешнюю рекламу, видео и другой контент с отслеживающим кодом. Блокировка отслеживающего содержимого может помочь сайтам загружаться быстрее, но некоторые кнопки, формы и поля для входа могут не работать. <a data-l10n-name="learn-more-link">Подробнее</a>
fingerprinter-tab-title = Сборщики цифровых отпечатков
fingerprinter-tab-content = Сборщики цифровых отпечатков используют параметры вашего браузера и компьютера, чтобы создать ваш профиль. Используя этот цифровой отпечаток, они могут отслеживать вас на различных веб-сайтах. <a data-l10n-name="learn-more-link">Подробнее</a>
cryptominer-tab-title = Криптомайнеры
cryptominer-tab-content = Криптомайнеры используют вычислительные мощности вашей системы для добычи цифровых валют. Такие скрипты разряжают вашу батарею, замедляют работу компьютера и могут увеличить ваш счёт за электроэнергию. <a data-l10n-name="learn-more-link">Подробнее</a>
protections-close-button2 =
    .aria-label = Закрыть
    .title = Закрыть
mobile-app-title = Блокируйте рекламные трекеры сразу на нескольких устройствах
mobile-app-card-content = Используйте мобильный браузер со встроенной защитой от рекламных трекеров.
mobile-app-links = Браузер { -brand-product-name } для <a data-l10n-name="android-mobile-inline-link">Android</a> и <a data-l10n-name="ios-mobile-inline-link">iOS</a>
lockwise-title = Никогда больше не забывайте свои пароли
lockwise-title-logged-in2 = Управление паролями
lockwise-header-content = { -lockwise-brand-name } надёжно хранит пароли в вашем браузере.
lockwise-header-content-logged-in = Надёжно храните и синхронизируйте свои пароли со всеми вашими устройствами.
protection-report-save-passwords-button = Сохранить пароли
    .title = Сохранить пароли в { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Управление паролями
    .title = Управление паролями в { -lockwise-brand-short-name }
lockwise-mobile-app-title = Возьмите свои пароли с собой
lockwise-no-logins-card-content = Используйте пароли, сохранённые в { -brand-short-name }, на любом устройстве.
lockwise-app-links = { -lockwise-brand-name } для <a data-l10n-name="lockwise-android-inline-link">Android</a> и <a data-l10n-name="lockwise-ios-inline-link">iOS</a>
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [1] Возможно, произошла утечка одного пароля.
        [one] Возможно, произошла утечка { $count } пароля.
        [few] Возможно, произошла утечка { $count } паролей.
       *[many] Возможно, произошла утечка { $count } паролей.
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] { $count } пароль хранится в безопасности.
        [few] { $count } пароля хранятся в безопасности.
       *[many] { $count } паролей хранятся в безопасности.
    }
lockwise-how-it-works-link = Как это работает
turn-on-sync = Включить { -sync-brand-short-name(case: "accusative") }…
    .title = Перейти в настройки синхронизации
monitor-title = Следите за утечками данных
monitor-link = Как это работает
monitor-header-content-no-account = Попробуйте { -monitor-brand-name }, чтобы узнать, не стали ли вы жертвой известной утечки данных, и получать уведомления о новых утечках.
monitor-header-content-signed-in = { -monitor-brand-name } предупредит вас, если ваша информация будет затронута новой утечкой данных.
monitor-sign-up-link = Подпишитесь на уведомления об утечках
    .title = Подпишитесь на уведомления об утечках от { -monitor-brand-name }
auto-scan = Автоматически просканировано сегодня
monitor-emails-tooltip =
    .title = Посмотреть отслеживаемые адреса электронной почты на { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Просмотреть известные утечки данных на { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Просмотреть раскрытые пароли на { -monitor-brand-short-name }
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Адрес электронной почты отслеживается
        [few] Адреса электронной почты отслеживаются
       *[many] Адресов электронной почты отслеживаются
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Известная утечка данных раскрыла вашу информацию
        [few] Известных утечки данных раскрыли вашу информацию
       *[many] Известных утечек данных раскрыли вашу информацию
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Известная утечка отмеченная как решённая
        [few] Известные утечки отмеченные как решённые
       *[many] Известных утечек отмеченных как решённые
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Раскрытый пароль во всех утечках
        [few] Раскрытых пароля во всех утечках
       *[many] Раскрытых паролей во всех утечках
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Раскрытый пароль в нерешённых утечках
        [few] Раскрытых пароля в нерешённых утечках
       *[many] Раскрытых паролей в нерешённых утечках
    }
monitor-no-breaches-title = Хорошие новости!
monitor-no-breaches-description = Ваши адреса не замечены ни в одной утечке. Если это изменится, мы дадим вам знать.
monitor-view-report-link = Посмотреть отчёт
    .title = Разобраться с утечками с помощью { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Разберитесь с вашими утечками
monitor-breaches-unresolved-description = Изучив информацию об утечке и предприняв меры по защите вашей информации, вы можете отметить утечки как решённые.
monitor-manage-breaches-link = Управление утечками
    .title = Управление утечками с помощью { -monitor-brand-short-name }
monitor-breaches-resolved-title = Отлично! Вы разобрались со всеми известными утечками.
monitor-breaches-resolved-description = Если ваш адрес электронной почты появится в каких-либо новых утечках, мы сообщим вам об этом.
# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] Вы разобрались с { $numBreachesResolved } из { $numBreaches } утечки
        [few] Вы разобрались с { $numBreachesResolved } из { $numBreaches } утечек
       *[many] Вы разобрались с { $numBreachesResolved } из { $numBreaches } утечек
    }
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% завершено
monitor-partial-breaches-motivation-title-start = Отличное начало!
monitor-partial-breaches-motivation-title-middle = Так держать!
monitor-partial-breaches-motivation-title-end = Почти готово! Так держать.
monitor-partial-breaches-motivation-description = Разберитесь с остальными вашими утечками на { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Разобраться с утечками
    .title = Разобраться с утечками с помощью { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Трекеры социальных сетей
    .aria-label =
        { $count ->
            [one] { $count } трекер социальных сетей ({ $percentage }%)
            [few] { $count } трекера социальных сетей ({ $percentage }%)
           *[many] { $count } трекеров социальных сетей ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Межсайтовые отслеживающие куки
    .aria-label =
        { $count ->
            [one] { $count } межсайтовая отслеживающая кука ({ $percentage }%)
            [few] { $count } межсайтовых отслеживающих куки ({ $percentage }%)
           *[many] { $count } межсайтовых отслеживающих куков ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Отслеживающее содержимое
    .aria-label =
        { $count ->
            [one] { $count } отслеживающее содержимое ({ $percentage }%)
            [few] { $count } отслеживающих содержимых ({ $percentage }%)
           *[many] { $count } отслеживающих содержимых ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Сборщики цифровых отпечатков
    .aria-label =
        { $count ->
            [one] { $count } сборщик цифровых отпечатков ({ $percentage }%)
            [few] { $count } сборщика цифровых отпечатков ({ $percentage }%)
           *[many] { $count } сборщиков цифровых отпечатков ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Криптомайнеры
    .aria-label =
        { $count ->
            [one] { $count } криптомайнер ({ $percentage }%)
            [few] { $count } криптомайнера ({ $percentage }%)
           *[many] { $count } криптомайнеров ({ $percentage }%)
        }
