# This Source Code Form is subject to the terms of the Waterfox Public
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

cfr-doorhanger-fission-body-approved = Ваша приватность имеет значение. { -brand-short-name } теперь изолирует веб-сайты друг от друга, помещая их в так называемые «песочницы», что усложняет кражу хакерами паролей, данных банковских карт и другой вашей личной информации.
cfr-doorhanger-fission-header = Изоляция сайта
cfr-doorhanger-fission-primary-button = OK, понятно
    .accesskey = я
cfr-doorhanger-fission-secondary-button = Подробнее
    .accesskey = н

## Full Video Support CFR message

cfr-doorhanger-video-support-body = В этой версии { -brand-short-name } видео на этом сайте может воспроизводиться некорректно. Для полноценной поддержки видео обновите { -brand-short-name }.
cfr-doorhanger-video-support-header = Для воспроизведения видео обновите { -brand-short-name }
cfr-doorhanger-video-support-primary-button = Обновить сейчас
    .accesskey = с

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Подробнее
    .title = Разверните, чтобы узнать больше об этой функции
spotlight-learn-more-expanded = Подробнее
    .title = Закрыть

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Похоже, что вы используете общедоступный Wi-Fi
spotlight-public-wifi-vpn-body = Чтобы скрыть свое местоположение и активность в Интернете, рассмотрите возможность использования виртуальной частной сети (VPN). Это поможет защитить вас при работе в Интернете в общественных местах, таких как аэропорты и кафе.
spotlight-public-wifi-vpn-primary-button = Сохраняйте приватность с { -mozilla-vpn-brand-name }
    .accesskey = п
spotlight-public-wifi-vpn-link = Не сейчас
    .accesskey = е

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Испытайте первыми нашу самую мощную 
    за всё время защиту приватности
spotlight-total-cookie-protection-body = Полная защита от кук не позволяет трекерам использовать куки, чтобы преследовать вас в сети.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } огораживает куки, ограничивая их только сайтом, на котором вы находитесь, чтобы трекеры не могли использовать их для слежки за вами. Благодаря раннему доступу вы помогаете оптимизировать эту функцию, чтобы мы продолжали создавать лучший Интернет для всех и каждого.
spotlight-total-cookie-protection-primary-button = Включить Полную защиту от кук
spotlight-total-cookie-protection-secondary-button = Не сейчас
cfr-total-cookie-protection-header = Благодаря вам, { -brand-short-name } стал более приватным и безопасным, чем когда-либо.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = Полная защита от кук — это наше самое надёжное средство защиты приватности, и теперь оно по умолчанию включено для пользователей { -brand-short-name } во всём мире. Мы не смогли бы сделать это без таких как вы — участников раннего доступа. Спасибо за помощь в создании лучшего и более приватного Интернета.

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
