# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Добро пожаловать в { -brand-short-name }
onboarding-start-browsing-button-label = Начать веб-сёрфинг
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

## Multistage onboarding strings (about:welcome pages)

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
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Waterfox начинается здесь
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Дизайнер мебели, фанатка Waterfox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Отключить анимации

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Оставьте { -brand-short-name } в Dock для быстрого доступа
       *[other] Закрепите { -brand-short-name } на панели задач для быстрого доступа
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Оставить в Dock
       *[other] Закрепить на панели задач
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Начать
mr1-onboarding-welcome-header = Добро пожаловать в { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Сделать { -brand-short-name } моим основным браузером
    .title = Устанавливает { -brand-short-name } в качестве браузера по умолчанию и закрепляет на панели задач
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Сделать { -brand-short-name } моим браузером по умолчанию
mr1-onboarding-set-default-secondary-button-label = Не сейчас
mr1-onboarding-sign-in-button-label = Войти

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Сделать { -brand-short-name } браузером по умолчанию
mr1-onboarding-default-subtitle = Поставьте на автопилот свою скорость, безопасность и приватность.
mr1-onboarding-default-primary-button-label = Сделать браузером по умолчанию

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Возьмите всё с собой
mr1-onboarding-import-subtitle = Импортируйте свои пароли, <br/>закладки и многое другое.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Импортировать из { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Импортировать из предыдущего браузера
mr1-onboarding-import-secondary-button-label = Не сейчас
mr2-onboarding-colorway-header = Жизнь в цвете
mr2-onboarding-colorway-subtitle = Яркие новые расцветки. Доступны в течение ограниченного времени.
mr2-onboarding-colorway-primary-button-label = Сохранить расцветку
mr2-onboarding-colorway-secondary-button-label = Не сейчас
mr2-onboarding-colorway-label-soft = Мягкая
mr2-onboarding-colorway-label-balanced = Сбалансированная
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Выразительная
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Автоматическая
# This string will be used for Default theme
mr2-onboarding-theme-label-default = По умолчанию
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
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Использовать эту расцветку.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Использовать эту расцветку.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Посмотреть расцветку { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-description =
    .aria-description = Посмотреть расцветку { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Посмотреть темы по умолчанию.
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = Посмотреть темы по умолчанию.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Спасибо, что выбрали нас
mr2-onboarding-thank-you-text = { -brand-short-name } 一 независимый браузер, поддерживаемый некоммерческой организацией. Вместе мы делаем Интернет более безопасным, здоровым и приватным.
mr2-onboarding-start-browsing-button-label = Начать веб-сёрфинг
