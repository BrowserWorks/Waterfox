# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Рекомендуемое расширение
cfr-doorhanger-feature-heading = Рекомендуемая функция

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Почему я это вижу

cfr-doorhanger-extension-cancel-button = Не сейчас
    .accesskey = е

cfr-doorhanger-extension-ok-button = Добавить
    .accesskey = а

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

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Синхронизируйте свои закладки, где бы вы ни находились.
cfr-doorhanger-bookmark-fxa-body = Отличная находка! Не оставайтесь без этой закладки на своих мобильных устройствах. Создайте { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Синхронизировать закладки сейчас…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Кнопка закрытия
    .title = Закрыть

## Protections panel

cfr-protections-panel-header = Работайте в Интернете без слежки
cfr-protections-panel-body = Храните свои данные при себе. { -brand-short-name } защищает вас от большинства наиболее известных трекеров, которые следят за вами в Интернете.
cfr-protections-panel-link-text = Подробнее

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Новая функция:

cfr-whatsnew-button =
    .label = Что нового
    .tooltiptext = Что нового

cfr-whatsnew-release-notes-link-text = Прочитать примечания к выпуску

## Enhanced Tracking Protection Milestones

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
cfr-doorhanger-milestone-close-button = Закрыть
    .accesskey = к

## DOH Message

cfr-doorhanger-doh-body = Ваша приватность имеет значение. Теперь, если это возможно, { -brand-short-name } безопасно перенаправляет ваши DNS-запросы в партнёрскую службу, чтобы защитить вас во время Интернет-сёрфинга.
cfr-doorhanger-doh-header = Более безопасный, зашифрованный поиск адресов сайтов в DNS
cfr-doorhanger-doh-primary-button-2 = Хорошо
    .accesskey = ш
cfr-doorhanger-doh-secondary-button = Отключить
    .accesskey = ю

## Fission Experiment Message

## Full Video Support CFR message

cfr-doorhanger-video-support-body = В этой версии { -brand-short-name } видео на этом сайте может воспроизводиться некорректно. Для полноценной поддержки видео обновите { -brand-short-name }.
cfr-doorhanger-video-support-header = Для воспроизведения видео обновите { -brand-short-name }
cfr-doorhanger-video-support-primary-button = Обновить сейчас
    .accesskey = с

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Похоже, что вы используете общедоступный Wi-Fi
spotlight-public-wifi-vpn-body = Чтобы скрыть свое местоположение и активность в Интернете, рассмотрите возможность использования виртуальной частной сети (VPN). Это поможет защитить вас при работе в Интернете в общественных местах, таких как аэропорты и кафе.
spotlight-public-wifi-vpn-primary-button = Сохраняйте приватность с { -mozilla-vpn-brand-name }
    .accesskey = п
spotlight-public-wifi-vpn-link = Не сейчас
    .accesskey = е

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

spotlight-better-internet-header = Лучший Интернет начинается с вас
spotlight-better-internet-body = Когда вы используете { -brand-short-name }, вы выбираете открытый и доступный Интернет, лучший для каждого.
spotlight-peace-mind-header = Мы заботимся о вас
spotlight-peace-mind-body = В среднем каждый месяц { -brand-short-name } блокирует у каждого пользователя более 3000 трекеров. Ничего, а особенно такие проблемы приватности, как трекеры, не должно стоять между вами и хорошим Интернетом.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Добавить в Dock
       *[other] Закрепить на панели задач
    }
spotlight-pin-secondary-button = Не сейчас

## MR2022 Background Update Windows native toast notification strings.
##
## These strings will be displayed by the Windows operating system in
## a native toast, like:
##
## <b>multi-line title</b>
## multi-line text
## <img>
## [ primary button ] [ secondary button ]
##
## The button labels are fitted into narrow fixed-width buttons by
## Windows and therefore must be as narrow as possible.

mr2022-background-update-toast-title = Новый { -brand-short-name }. Более приватный. Меньше трекеров. Никаких компромиссов.
mr2022-background-update-toast-text = Попробуйте новейшую версию { -brand-short-name } прямо сейчас с нашей самой надежной защитой от отслеживания.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = Открыть { -brand-shorter-name } сейчас

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = Напомнить позже

## Waterfox View CFR

firefoxview-cfr-primarybutton = Попробовать его
    .accesskey = б
firefoxview-cfr-secondarybutton = Не сейчас
    .accesskey = е
firefoxview-cfr-header-v2 = Быстро вернитесь к месту, где остановились
firefoxview-cfr-body-v2 = Верните недавно закрытые вкладки, а также легко переключайтесь между устройствами с помощью { -firefoxview-brand-name }.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = Поздоровайтесь с { -firefoxview-brand-name }

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = Хотите вкладку открытую на своем телефоне? Возьмите её. Нужен сайт, который вы только что посетили? Пуф, и он вернулся через { -firefoxview-brand-name }.
firefoxview-spotlight-promo-primarybutton = Посмотреть, как это работает
firefoxview-spotlight-promo-secondarybutton = Пропустить

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = Выберите расцветку
    .accesskey = ы

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = Раскрасьте свой браузер исключительными оттенками { -brand-short-name }, вдохновлёнными голосами, изменившими культуру.
colorways-cfr-header-28days = Срок действия расцветок независимых голосов истекает 16 января
colorways-cfr-header-14days = Срок действия расцветок независимых голосов истекает через две недели
colorways-cfr-header-7days = Срок действия расцветок независимых голосов истекает на этой неделе
colorways-cfr-header-today = Сегодня истекает срок действия расцветок независимых голосов

## Cookie Banner Handling CFR

cfr-cbh-header = Разрешить { -brand-short-name } отклонять уведомления о куках?
cfr-cbh-body = { -brand-short-name } может автоматически отклонять множество запросов уведомлений о куках.
cfr-cbh-confirm-button = Отклонять уведомления о куках
    .accesskey = к
cfr-cbh-dismiss-button = Не сейчас
    .accesskey = е

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = Мы заботимся о вас
july-jam-body = Каждый месяц { -brand-short-name } блокирует в среднем более 3000 трекеров для каждого пользователя, предоставляя вам безопасный и быстрый доступ к хорошему Интернету.
july-jam-set-default-primary = Открывать мои ссылки с помощью { -brand-short-name }
fox-doodle-pin-headline = С возвращением

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = Небольшое напоминание о том, что вы всегда можете держать под рукой свой любимый независимый браузер.
fox-doodle-pin-primary = Открывать мои ссылки с помощью { -brand-short-name }
fox-doodle-pin-secondary = Не сейчас

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>Ваши PDF-файлы теперь открываются в { -brand-short-name }.</strong> Редактируйте или подписывайте формы прямо в браузере. Чтобы изменить это, откройте настройки и в поле поиска наберите PDF.
set-default-pdf-handler-primary = Понятно

## FxA sync CFR

fxa-sync-cfr-header = Собираетесь перейти на новое устройство?
fxa-sync-cfr-body = Убедитесь, что ваши последние закладки, пароли и вкладки всегда будут с вами, когда вы открываете новый браузер { -brand-product-name }.
fxa-sync-cfr-primary = Подробнее
    .accesskey = б
fxa-sync-cfr-secondary = Напомнить позже
    .accesskey = ж

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = Используете старое устройство?
device-migration-fxa-spotlight-body = Сделайте резервную копию своих данных, чтобы не потерять важную информацию, такую как закладки и пароли, особенно при переходе на новое устройство.
device-migration-fxa-spotlight-primary-button = Как сделать резервную копию моих данных
device-migration-fxa-spotlight-link = Напомнить позже
