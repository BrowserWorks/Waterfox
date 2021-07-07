# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Подробнее
onboarding-button-label-get-started = Начало работы

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Добро пожаловать в { -brand-short-name }
onboarding-welcome-body = Теперь у вас есть браузер.<br/>Познакомьтесь с { -brand-product-name } поближе.
onboarding-welcome-learn-more = Узнать больше о преимуществах.
onboarding-welcome-modal-get-body = Теперь у вас есть браузер.<br/>Получите максимальную отдачу от { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = «Перезарядите» вашу защиту приватности.
onboarding-welcome-modal-privacy-body = У вас уже есть браузер. Теперь давайте добавим ещё больше защиты приватности.
onboarding-welcome-modal-family-learn-more = Узнайте больше о семействе продуктов { -brand-product-name }.
onboarding-welcome-form-header = Начните здесь
onboarding-join-form-body = Введите ваш адрес эл. почты, чтобы начать.
onboarding-join-form-email =
    .placeholder = Введите адрес эл. почты
onboarding-join-form-email-error = Введите действующий адрес эл. почты
onboarding-join-form-legal = Продолжая, вы соглашаетесь с <a data-l10n-name="terms">условиями предоставления услуг</a> и <a data-l10n-name="privacy">уведомлением о конфиденциальности</a>.
onboarding-join-form-continue = Продолжить
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Уже есть аккаунт?
# Text for link to submit the sign in form
onboarding-join-form-signin = Войти
onboarding-start-browsing-button-label = Начать веб-сёрфинг
onboarding-cards-dismiss =
    .title = Скрыть
    .aria-label = Скрыть

## Welcome full page string

onboarding-fullpage-welcome-subheader = Давайте узнаем, что вы можете сделать.
onboarding-fullpage-form-email =
    .placeholder = Ваш адрес эл. почты…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Возьмите { -brand-product-name } с собой
onboarding-sync-welcome-content = Получите доступ к вашим закладкам, истории, паролям и другим параметрам на всех ваших устройствах.
onboarding-sync-welcome-learn-more-link = Узнайте больше об Аккаунтах Firefox
onboarding-sync-form-input =
    .placeholder = Эл. почта
onboarding-sync-form-continue-button = Продолжить
onboarding-sync-form-skip-login-button = Пропустить этот шаг

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Введите ваш адрес электронной почты
onboarding-sync-form-sub-header = чтобы продолжить использовать { -sync-brand-name(case: "accusative") }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Делайте свои дела с помощью семейства инструментов, которое уважает вашу приватность на всех ваших устройствах.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Во всём, что мы делаем, мы следуем нашему Обещанию по Личным Данным: Собирать меньше. Держать в безопасности. Никаких секретов.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Возьмите ваши закладки, пароли, историю и многое другое с собой, где бы вы ни использовали { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Получайте уведомления, когда ваша личная информация появляется в известных утечках данных.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Управляйте своими паролями, которые хранятся под защитой и переносимы.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Защита от отслеживания
onboarding-tracking-protection-text2 = { -brand-short-name } помогает остановить отслеживание ваших действий в Интернете, что затрудняет отслеживание вас рекламой в Интернете.
onboarding-tracking-protection-button2 = Как это работает
onboarding-data-sync-title = Возьмите свои настройки с собой
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Синхронизируйте ваши закладки, пароли и многое другое, где бы вы ни использовали { -brand-product-name }.
onboarding-data-sync-button2 = Войти в { -sync-brand-short-name(case: "accusative") }
onboarding-firefox-monitor-title = Подпишитесь на уведомления об утечках данных
onboarding-firefox-monitor-text2 = { -monitor-brand-name } следит, не был ли ваш адрес электронной почты затронут известными утечками данных, и если да, то сразу уведомляет вас об этом.
onboarding-firefox-monitor-button = Подписаться на уведомления
onboarding-browse-privately-title = Сёрфите приватно
onboarding-browse-privately-text = Приватный просмотр удаляет вашу историю поиска и просмотров страниц, чтобы держать её в тайне от других людей, которые используют этот компьютер.
onboarding-browse-privately-button = Открыть приватное окно
onboarding-firefox-send-title = Приватно обменивайтесь файлами
onboarding-firefox-send-text2 = Загружайте свои файлы с помощью { -send-brand-name }, чтобы делиться ими со сквозным шифрованием и ограниченным сроком действия ссылки на загрузку.
onboarding-firefox-send-button = Попробовать { -send-brand-name }
onboarding-mobile-phone-title = Загрузите { -brand-product-name } на ваш телефон
onboarding-mobile-phone-text = Загрузите { -brand-product-name } для iOS или Android и синхронизируйте данные между всеми своими устройствами.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Загрузить мобильный браузер
onboarding-send-tabs-title = Мгновенно отправляйте вкладки самому себе
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Легко обменивайтесь страницами между вашими устройствами, не копируя ссылки или выходя из браузера.
onboarding-send-tabs-button = Начать использовать отправку вкладок
onboarding-pocket-anywhere-title = Читайте и слушайте, где бы вы не находились
onboarding-pocket-anywhere-text2 = Сохраняйте ваши любимые статьи с помощью { -pocket-brand-name } и читайте, слушайте или просматривайте их даже без Интернета в любое удобное для вас время.
onboarding-pocket-anywhere-button = Попробовать { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Создавайте и храните надежные пароли
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } мгновенно создает надежные пароли и хранит их в одном месте.
onboarding-lockwise-strong-passwords-button = Управляйте своими логинами
onboarding-facebook-container-title = Установите границы для Фейсбука
onboarding-facebook-container-text2 = { -facebook-container-brand-name } отделяет ваш профиль от всего остального, затрудняя Фейсбуку отслеживание вас для показа целевой рекламы.
onboarding-facebook-container-button = Установить расширение
onboarding-import-browser-settings-title = Импортируйте свои закладки, пароли и многое другое
onboarding-import-browser-settings-text = Быстрое погружение — легко переносите сайты и настройки из Chrome.
onboarding-import-browser-settings-button = Импортируйте данные из Chrome
onboarding-personal-data-promise-title = Приватный по природе
onboarding-personal-data-promise-text = { -brand-product-name } относится с уважением к вашим данным, используя их по минимуму, защищая их, и напрямую сообщая о том, как мы их используем.
onboarding-personal-data-promise-button = Прочитать наше обещание

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Отлично, вы установили { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Теперь давайте установим <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Добавить расширение
return-to-amo-get-started-button = Начните работу с { -brand-short-name }
onboarding-not-now-button-label = Не сейчас

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Отлично, вы установили { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Теперь давайте установим <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Добавить расширение

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Добро пожаловать в <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Быстрый, безопасный и приватный браузер, поддерживаемый некоммерческой организацией.
onboarding-multistage-welcome-primary-button-label = Начать настройку
onboarding-multistage-welcome-secondary-button-label = Войти
onboarding-multistage-welcome-secondary-button-text = Уже есть аккаунт?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Сделайте { -brand-short-name } вашим <span data-l10n-name="zap">браузером по умолчанию</span>
onboarding-multistage-set-default-subtitle = Скорость, безопасность и конфиденциальность на всех веб-страницах.
onboarding-multistage-set-default-primary-button-label = Установить по умолчанию
onboarding-multistage-set-default-secondary-button-label = Не сейчас
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Для начала поместите <span data-l10n-name="zap">{ -brand-short-name }</span> на расстояние одного щелчка
onboarding-multistage-pin-default-subtitle = Быстрый, безопасный и приватный просмотр страниц при каждом выходе в Интернет.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Выберите { -brand-short-name } в пункте «Веб-браузер», когда откроются настройки
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Это действие закрепит { -brand-short-name } на панели задач и откроет настройки
onboarding-multistage-pin-default-primary-button-label = Сделать { -brand-short-name } моим основным браузером
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Импортируйте свои пароли, закладки и <span data-l10n-name="zap">многое другое</span>
onboarding-multistage-import-subtitle = Переходите с другого браузера? Вы легко можете перенести всё в { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Начать импорт
onboarding-multistage-import-secondary-button-label = Не сейчас
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = На этом устройстве были найдены следующие сайты. { -brand-short-name } не будет сохранять или синхронизировать данные из другого браузера, если только вы не решите их импортировать.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Начало работы: экран { $current } из { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Выберите <span data-l10n-name="zap">внешний вид</span>
onboarding-multistage-theme-subtitle = Измените внешний вид { -brand-short-name } с помощью темы.
onboarding-multistage-theme-primary-button-label2 = Готово
onboarding-multistage-theme-secondary-button-label = Не сейчас
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Автоматическая
onboarding-multistage-theme-label-light = Светлая
onboarding-multistage-theme-label-dark = Тёмная
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Использует тему вашей операционной
        системы для кнопок, меню и окон.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Использует тему вашей операционной
        системы для кнопок, меню и окон.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Использует светлую тему для кнопок,
        меню и окон.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Использует светлую тему для кнопок,
        меню и окон.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Использует тёмную тему для кнопок,
        меню и окон.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Использует тёмную тему для кнопок,
        меню и окон.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Использует красочный внешний вид для кнопок,
        меню и окон.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Использует красочный внешний вид для кнопок,
        меню и окон.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Firefox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Firefox начинается здесь
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Дизайнер мебели, фанатка Firefox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Отключить анимации

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Оставьте { -brand-short-name } в Dock для быстрого доступа
       *[other] Закрепите { -brand-short-name } на панели задач для быстрого доступа
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Оставить в Dock
       *[other] Закрепить на панели задач
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Начать
mr1-onboarding-welcome-header = Добро пожаловать в { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Сделать { -brand-short-name } моим основным браузером
    .title = Устанавливает { -brand-short-name } в качестве браузера по умолчанию и закрепляет на панели задач
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Сделать { -brand-short-name } моим браузером по умолчанию
mr1-onboarding-set-default-secondary-button-label = Не сейчас
mr1-onboarding-sign-in-button-label = Войти

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = Сделать { -brand-short-name } браузером по умолчанию
mr1-onboarding-default-subtitle = Поставьте на автопилот свою скорость, безопасность и приватность.
mr1-onboarding-default-primary-button-label = Сделать браузером по умолчанию

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Возьмите всё с собой
mr1-onboarding-import-subtitle = Импортируйте свои пароли, <br/>закладки и многое другое.
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Импортировать из { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Импортировать из предыдущего браузера
mr1-onboarding-import-secondary-button-label = Не сейчас
mr1-onboarding-theme-header = Сделайте его своим
mr1-onboarding-theme-subtitle = Измените внешний вид { -brand-short-name } с помощью темы.
mr1-onboarding-theme-primary-button-label = Сохранить тему
mr1-onboarding-theme-secondary-button-label = Не сейчас
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Системная тема
mr1-onboarding-theme-label-light = Светлая
mr1-onboarding-theme-label-dark = Тёмная
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Следовать теме операционной системы
        для кнопок, меню и окон.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Следовать теме операционной системы
        для кнопок, меню и окон.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Использовать светлую тему для кнопок,
        меню и окон.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Использовать светлую тему для кнопок,
        меню и окон.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Использовать тёмную тему для кнопок,
        меню и окон.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Использовать тёмную тему для кнопок,
        меню и окон.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Использовать динамическую, красочную тему для кнопок,
        меню и окон.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Использовать динамическую, красочную тему для кнопок,
        меню и окон.
