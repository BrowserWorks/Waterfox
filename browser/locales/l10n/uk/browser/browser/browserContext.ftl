# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Потягніть вниз, щоб показати історію вкладки
           *[other] Натисніть праву клавішу чи потягніть вниз, щоб показати історію вкладки
        }

## Back

main-context-menu-back =
    .tooltiptext = Назад на одну сторінку
    .aria-label = Назад
    .accesskey = Н

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Вперед на одну сторінку
    .aria-label = Вперед
    .accesskey = В

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Оновити
    .accesskey = О

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Зупинити
    .accesskey = З

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Зберегти як…
    .accesskey = б

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Закласти цю сторінку
    .accesskey = к
    .tooltiptext = Закласти цю сторінку

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Закласти цю сторінку
    .accesskey = к
    .tooltiptext = Закласти цю сторінку ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Редагувати цю закладку
    .accesskey = к
    .tooltiptext = Редагувати цю закладку

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Редагувати цю закладку
    .accesskey = к
    .tooltiptext = Редагувати цю закладку ({ $shortcut })

main-context-menu-open-link =
    .label = Відкрити посилання
    .accesskey = В

main-context-menu-open-link-new-tab =
    .label = Відкрити посилання в новій вкладці
    .accesskey = л

main-context-menu-open-link-container-tab =
    .label = Відкрити посилання в новій вкладці контейнера
    .accesskey = к

main-context-menu-open-link-new-window =
    .label = Відкрити посилання в новому вікні
    .accesskey = к

main-context-menu-open-link-new-private-window =
    .label = Відкрити в приватному вікні
    .accesskey = и

main-context-menu-bookmark-this-link =
    .label = Закласти це посилання
    .accesskey = с

main-context-menu-save-link =
    .label = Зберегти посилання як…
    .accesskey = п

main-context-menu-save-link-to-pocket =
    .label = Зберегти посилання в { -pocket-brand-name }
    .accesskey = п

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Копіювати адресу е-пошти
    .accesskey = п

main-context-menu-copy-link =
    .label = Копіювати адресу посилання
    .accesskey = п

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Відтворити
    .accesskey = т

main-context-menu-media-pause =
    .label = Пауза
    .accesskey = а

##

main-context-menu-media-mute =
    .label = Вимкнути звук
    .accesskey = и

main-context-menu-media-unmute =
    .label = Увімкнути звук
    .accesskey = и

main-context-menu-media-play-speed =
    .label = Швидкість відтворення
    .accesskey = в

main-context-menu-media-play-speed-slow =
    .label = Повільно (0.5×)
    .accesskey = П

main-context-menu-media-play-speed-normal =
    .label = Нормально
    .accesskey = Н

main-context-menu-media-play-speed-fast =
    .label = Швидко (1.25×)
    .accesskey = к

main-context-menu-media-play-speed-faster =
    .label = Швидше (1.5×)
    .accesskey = е

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Надшвидко (2×)
    .accesskey = о

main-context-menu-media-loop =
    .label = Цикл
    .accesskey = л

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Показати керувальники
    .accesskey = к

main-context-menu-media-hide-controls =
    .label = Приховати керувальники
    .accesskey = к

##

main-context-menu-media-video-fullscreen =
    .label = Повний екран
    .accesskey = е

main-context-menu-media-video-leave-fullscreen =
    .label = Вийти з повноекранного режиму
    .accesskey = В

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Зображення в зображенні
    .accesskey = З

main-context-menu-image-reload =
    .label = Перезавантажити зображення
    .accesskey = з

main-context-menu-image-view =
    .label = Переглянути зображення
    .accesskey = г

main-context-menu-video-view =
    .label = Переглянути відео
    .accesskey = г

main-context-menu-image-copy =
    .label = Копіювати зображення
    .accesskey = з

main-context-menu-image-copy-location =
    .label = Копіювати адресу зображення
    .accesskey = р

main-context-menu-video-copy-location =
    .label = Копіювати адресу відео
    .accesskey = в

main-context-menu-audio-copy-location =
    .label = Копіювати адресу аудіо
    .accesskey = у

main-context-menu-image-save-as =
    .label = Зберегти зображення як…
    .accesskey = б

main-context-menu-image-email =
    .label = Переслати зображення…
    .accesskey = ж

main-context-menu-image-set-as-background =
    .label = Встановити як тло робочого столу…
    .accesskey = с

main-context-menu-image-info =
    .label = Інформація про зображення
    .accesskey = І

main-context-menu-image-desc =
    .label = Переглянути опис
    .accesskey = о

main-context-menu-video-save-as =
    .label = Зберегти відео як…
    .accesskey = в

main-context-menu-audio-save-as =
    .label = Зберегти аудіо як…
    .accesskey = а

main-context-menu-video-image-save-as =
    .label = Зберегти кадр як…
    .accesskey = я

main-context-menu-video-email =
    .label = Переслати відео…
    .accesskey = с

main-context-menu-audio-email =
    .label = Переслати аудіо…
    .accesskey = с

main-context-menu-plugin-play =
    .label = Активувати цей плагін
    .accesskey = А

main-context-menu-plugin-hide =
    .label = Приховати цей плагін
    .accesskey = П

main-context-menu-save-to-pocket =
    .label = Зберегти сторінку в { -pocket-brand-name }
    .accesskey = с

main-context-menu-send-to-device =
    .label = Відправити сторінку на пристрій
    .accesskey = с

main-context-menu-view-background-image =
    .label = Переглянути зображення тла
    .accesskey = т

main-context-menu-generate-new-password =
    .label = Використати згенерований пароль
    .accesskey = з

main-context-menu-keyword =
    .label = Створити скорочення для цього пошуку…
    .accesskey = д

main-context-menu-link-send-to-device =
    .label = Відправити посилання на пристрій
    .accesskey = л

main-context-menu-frame =
    .label = У цьому фреймі
    .accesskey = ь

main-context-menu-frame-show-this =
    .label = Показати тільки цей фрейм
    .accesskey = з

main-context-menu-frame-open-tab =
    .label = Відкрити фрейм в новій вкладці
    .accesskey = ц

main-context-menu-frame-open-window =
    .label = Відкрити фрейм в новому вікні
    .accesskey = ф

main-context-menu-frame-reload =
    .label = Оновити фрейм
    .accesskey = в

main-context-menu-frame-bookmark =
    .label = Закласти цей фрейм
    .accesskey = ф

main-context-menu-frame-save-as =
    .label = Зберегти фрейм як…
    .accesskey = ф

main-context-menu-frame-print =
    .label = Друкувати фрейм…
    .accesskey = ф

main-context-menu-frame-view-source =
    .label = Програмний код фрейма
    .accesskey = й

main-context-menu-frame-view-info =
    .label = Інформація про фрейм
    .accesskey = ф

main-context-menu-view-selection-source =
    .label = Програмний код вибірки
    .accesskey = к

main-context-menu-view-page-source =
    .label = Програмний код сторінки
    .accesskey = а

main-context-menu-view-page-info =
    .label = Інформація про сторінку
    .accesskey = І

main-context-menu-bidi-switch-text =
    .label = Перемкнути напрям тексту на сторінці
    .accesskey = к

main-context-menu-bidi-switch-page =
    .label = Перемкнути напрям тексту на сторінці
    .accesskey = м

main-context-menu-inspect-element =
    .label = Дослідити елемент
    .accesskey = Д

main-context-menu-inspect-a11y-properties =
    .label = Дослідити властивості доступності

main-context-menu-eme-learn-more =
    .label = Докладніше про DRM…
    .accesskey = Д

