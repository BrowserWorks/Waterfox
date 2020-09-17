# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Препоръчано разширение
cfr-doorhanger-feature-heading = Препоръчана възможност
cfr-doorhanger-pintab-heading = Опитайте: закачане на раздел

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Защо го виждам?

cfr-doorhanger-extension-cancel-button = Не сега
    .accesskey = н

cfr-doorhanger-extension-ok-button = Добавяне
    .accesskey = д
cfr-doorhanger-pintab-ok-button = Закачане на раздел
    .accesskey = з

cfr-doorhanger-extension-manage-settings-button = Управление на настройките за препоръки
    .accesskey = н

cfr-doorhanger-extension-never-show-recommendation = Не ми показвайте тази препоръка
    .accesskey = н

cfr-doorhanger-extension-learn-more-link = Научете повече

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = от { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Препоръка

cfr-doorhanger-extension-notification2 = Препоръка
    .tooltiptext = Препоръка за разширение
    .a11y-announcement = Налична е препоръка за разширение

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Препоръка
    .tooltiptext = Препоръка за възможност
    .a11y-announcement = Налична е препоръка за възможност

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } звезда
           *[other] { $total } звезди
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } потребител
       *[other] { $total } потребителя
    }

cfr-doorhanger-pintab-description = Получете лесен достъп до най-посещаваните от вас страници. Запазвайте отворените в раздел страници (дори след рестарт).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Щракнете с десен бутон</b> върху раздела, който искате да закачите.
cfr-doorhanger-pintab-step2 = Изберете <b>Закачане на раздела</b> от  менюто.
cfr-doorhanger-pintab-step3 = Ако страницата се обнови ще видите синя точка на закачения раздел.

cfr-doorhanger-pintab-animation-pause = Пауза
cfr-doorhanger-pintab-animation-resume = Продължаване


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Синхронизирайте отметките си навсякъде.
cfr-doorhanger-bookmark-fxa-body = Чудесно откритие! Сега не оставайте без тази отметка на мобилните си устройства. Започнете с { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Синхронизиране на отметките сега…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Бутон за затваряне
    .title = Затваряне

## Protections panel

cfr-protections-panel-header = Преглеждайте без да бъдете следени
cfr-protections-panel-body = Пазете вашите данни само ваши. { -brand-short-name } ви предпазва от много от най-разпространените проследявания, които следват вашите действия онлайн.
cfr-protections-panel-link-text = Научете повече

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Нова възможност:

cfr-whatsnew-button =
    .label = Какво е новото
    .tooltiptext = Новото в това издание

cfr-whatsnew-panel-header = Какво е новото

cfr-whatsnew-release-notes-link-text = Прочетете бележките към изданието

cfr-whatsnew-fx70-title = { -brand-short-name } вече се бори по-отдадено за вашата поверителност
cfr-whatsnew-fx70-body =
    Последното издание подобрява способността за защита от проследяване.
    Вече е по-лесно да създавате с нея сигурни пароли за всеки сайт.

cfr-whatsnew-tracking-protect-title = Защитете се от проследяване
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } блокира много социални мрежи и уебсайтове, 
    които ви проследяват онлайн.
cfr-whatsnew-tracking-protect-link-text = Вижте отчета

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Проследяващият е блокиран
       *[other] Проследяващите са блокирани
    }
cfr-whatsnew-tracking-blocked-subtitle = От { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Преглед на отчета

cfr-whatsnew-lockwise-backup-title = Архивирайте паролите си
cfr-whatsnew-lockwise-backup-body = Сега генерирайте защитени пароли, до които можете да имате достъп от всички устройства, където сте вписани.
cfr-whatsnew-lockwise-backup-link-text = Включете записването на резервни копия

cfr-whatsnew-lockwise-take-title = Вземете паролите си със себе си
cfr-whatsnew-lockwise-take-body = Мобилното приложение { -lockwise-brand-short-name } ви позволява сигурен достъп до вашите архивирани пароли навсякъде.
cfr-whatsnew-lockwise-take-link-text = Вземете приложението

## Search Bar

cfr-whatsnew-searchbar-title = Въвеждайте по-малко, улеснете се с адресната лента
cfr-whatsnew-searchbar-body-topsites = Сега просто изберете адресната лента и полето ще се разшири с препратки към вашите предпочитани сайтове.
cfr-whatsnew-searchbar-icon-alt-text = Увеличаваща лупа

## Picture-in-Picture

cfr-whatsnew-pip-header = Гледайте видеоклипове, докато разглеждате
cfr-whatsnew-pip-body = „Картина в картината“ изкарва видео в плаващ прозорец, докато работите в други раздели.
cfr-whatsnew-pip-cta = Научете повече

## Permission Prompt

cfr-whatsnew-permission-prompt-header = По-малко досадни изскачащи прозорци
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } вече блокира сайтовете да ви питат за изскачащи съобщения.
cfr-whatsnew-permission-prompt-cta = Научете повече

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Спряно снемане на цифров отпечатък
       *[other] Спряно снемане на цифров отпечатък
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } блокира много скриптове събиращи цифрови отпечатъци, които тайно събират информация за вашето устройство и действия за създаване на рекламен профил от вас.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Снемане на цифров отпечатък
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } спира скриптове, снемащи цифров отпечаък, които тайно събират информация за вашето устройство и действия за създаване ваш рекламен профил.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Вземете тази отметка на телефона си
cfr-doorhanger-sync-bookmarks-body = Вземете своите отметки, пароли, история и всичко друго навсякъде, където сте вписани в/във { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Включване на { -sync-brand-short-name }
    .accesskey = В

## Login Sync

cfr-doorhanger-sync-logins-header = Никога не забравяйте отново парола
cfr-doorhanger-sync-logins-body = Съхранявайте сигурно и синхронизирайте паролите си на всичките си устройства.
cfr-doorhanger-sync-logins-ok-button = Включване на { -sync-brand-short-name }
    .accesskey = В

## Send Tab

cfr-doorhanger-send-tab-header = Прочетете това в движение
cfr-doorhanger-send-tab-recipe-header = Вземете тази рецепта в кухнята
cfr-doorhanger-send-tab-ok-button = Опитайте Send Tab
    .accesskey = п

## Firefox Send

cfr-doorhanger-firefox-send-header = Споделете този PDF безопасно
cfr-doorhanger-firefox-send-body = Пазете чувствителните си документи от любопитни очи с шифроване от край до край и препратка, която изчезва, когато сте готови.
cfr-doorhanger-firefox-send-ok-button = Изпробвайте { -send-brand-name }
    .accesskey = И

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Вижте защитите
    .accesskey = В
cfr-doorhanger-socialtracking-close-button = Затваряне
    .accesskey = з
cfr-doorhanger-socialtracking-dont-show-again = Да не се показват подобни съобщения отново
    .accesskey = д
cfr-doorhanger-socialtracking-heading = { -brand-short-name } спря социална мрежа да ви следи тук
cfr-doorhanger-socialtracking-description = Поверителността ви е от значение. { -brand-short-name } вече спира проследяванията от разпространените социални мрежи, ограничавайки събираните данни за действията ви в мрежата.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } блокира скрипт събиращ цифров отпечатък на тази страница
cfr-doorhanger-cryptominers-heading = { -brand-short-name } блокира скрипт добиващ виртуални пари на тази страница
cfr-doorhanger-cryptominers-description = Вашата поверителност е от значение. { -brand-short-name } вече блокира скриптове, които използват изчислителната мощност на системата ви за извличане на криптовалути.

## Enhanced Tracking Protection Milestones

cfr-doorhanger-milestone-ok-button = Показване на всички
    .accesskey = С

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Лесно създавайте сигурни пароли
cfr-whatsnew-lockwise-icon-alt = Пиктограма на { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Получавайте сигнали за уязвими пароли

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-icon-alt = Икона за картина в картината

## Protections Dashboard message

cfr-whatsnew-protections-icon-alt = Пиктограма на щит

## Better PDF message


## DOH Message

## What's new: Cookies message

