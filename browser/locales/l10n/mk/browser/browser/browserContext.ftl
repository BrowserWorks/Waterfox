# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Повлечете надолу за да се прикаже историјата
           *[other] Десен клик или повлечете надолу за да се прикаже историјата
        }

## Back

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Сними страница како…
    .accesskey = к

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-open-link =
    .label = Отвори ја врската
    .accesskey = О

main-context-menu-open-link-new-tab =
    .label = Отвори во ново јазиче
    .accesskey = ј

main-context-menu-open-link-container-tab =
    .label = Отвори во ново контејнерско јазиче
    .accesskey = о

main-context-menu-open-link-new-window =
    .label = Отвори во нов прозорец
    .accesskey = п

main-context-menu-open-link-new-private-window =
    .label = Отвори нов приватен прозорец
    .accesskey = п

main-context-menu-bookmark-this-link =
    .label = Обележи ја оваа врска
    .accesskey = б

main-context-menu-save-link =
    .label = Сними ја врската како…
    .accesskey = С

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Копирај ја адресата за е-пошта
    .accesskey = е

main-context-menu-copy-link =
    .label = Копирај ја локацијата на врската
    .accesskey = К

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Пушти
    .accesskey = П

main-context-menu-media-pause =
    .label = Паузирај
    .accesskey = П

##

main-context-menu-media-mute =
    .label = Занеми
    .accesskey = м

main-context-menu-media-unmute =
    .label = Пушти звук
    .accesskey = m

main-context-menu-media-play-speed =
    .label = Брзина на репродуцирање
    .accesskey = б

main-context-menu-media-play-speed-slow =
    .label = Бавна (0.5×)
    .accesskey = Б

main-context-menu-media-play-speed-normal =
    .label = Нормална
    .accesskey = Н

main-context-menu-media-play-speed-fast =
    .label = Брза (1.25×)
    .accesskey = Б

main-context-menu-media-play-speed-faster =
    .label = Побрза (1.5×)
    .accesskey = п

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Смешна (2×)
    .accesskey = С

main-context-menu-media-loop =
    .label = Повторувај
    .accesskey = П

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Покажи ги копчињата
    .accesskey = к

main-context-menu-media-hide-controls =
    .label = Скриј ги копчињата
    .accesskey = к

##

main-context-menu-media-video-fullscreen =
    .label = На цел екран
    .accesskey = ц

main-context-menu-media-video-leave-fullscreen =
    .label = Исклучи цел екран
    .accesskey = у

main-context-menu-image-reload =
    .label = Превчитај ја сликата
    .accesskey = р

main-context-menu-image-view =
    .label = Прикажи ја сликата
    .accesskey = ж

main-context-menu-video-view =
    .label = Прикажи го видеото
    .accesskey = и

main-context-menu-image-copy =
    .label = Копирај ја сликата
    .accesskey = и

main-context-menu-image-copy-location =
    .label = Копирај ја локацијата на сликата
    .accesskey = о

main-context-menu-video-copy-location =
    .label = Копирај ја локацијата на звукот
    .accesskey = о

main-context-menu-audio-copy-location =
    .label = Копирај ја локацијата на аудиото
    .accesskey = о

main-context-menu-image-save-as =
    .label = Сними ја сликата како…
    .accesskey = м

main-context-menu-image-email =
    .label = Испрати слика…
    .accesskey = а

main-context-menu-image-set-as-background =
    .label = Постави како позадина на работната површина…
    .accesskey = с

main-context-menu-image-info =
    .label = Прикажи информации за сликата
    .accesskey = с

main-context-menu-image-desc =
    .label = Види опис
    .accesskey = В

main-context-menu-video-save-as =
    .label = Сними го видеото како…
    .accesskey = н

main-context-menu-audio-save-as =
    .label = Сними го аудиото како…
    .accesskey = н

main-context-menu-video-image-save-as =
    .label = Сними ја сликата како...
    .accesskey = С

main-context-menu-video-email =
    .label = Испрати видео…
    .accesskey = а

main-context-menu-audio-email =
    .label = Испрати аудио…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Активирај го овој приклучок
    .accesskey = к

main-context-menu-plugin-hide =
    .label = Скриј го овој приклучок
    .accesskey = ф

main-context-menu-send-to-device =
    .label = Испрати страница на уред
    .accesskey = и

main-context-menu-view-background-image =
    .label = Прикажи ја позадинската слика
    .accesskey = ж

main-context-menu-keyword =
    .label = Додај клучен збор за ова пребарување…
    .accesskey = к

main-context-menu-link-send-to-device =
    .label = Испрати врска до уред
    .accesskey = и

main-context-menu-frame =
    .label = Оваа рамка
    .accesskey = м

main-context-menu-frame-show-this =
    .label = Покажи ја само оваа рамка
    .accesskey = к

main-context-menu-frame-open-tab =
    .label = Отвори ја рамката во ново јазиче
    .accesskey = ј

main-context-menu-frame-open-window =
    .label = Отвори ја рамката во нов прозорец
    .accesskey = п

main-context-menu-frame-reload =
    .label = Превчитај ја рамката
    .accesskey = ч

main-context-menu-frame-bookmark =
    .label = Обележи ја оваа рамка
    .accesskey = б

main-context-menu-frame-save-as =
    .label = Сними ја рамката како…
    .accesskey = р

main-context-menu-frame-print =
    .label = Печати рамка…
    .accesskey = П

main-context-menu-frame-view-source =
    .label = Прикажи код на рамка
    .accesskey = д

main-context-menu-frame-view-info =
    .label = Прикажи ги информациите за рамката
    .accesskey = и

main-context-menu-view-selection-source =
    .label = Прикажи код на избран дел
    .accesskey = П

main-context-menu-view-page-source =
    .label = Прикажи код на страница
    .accesskey = д

main-context-menu-view-page-info =
    .label = Прикажи ги информациите за страницата
    .accesskey = и

main-context-menu-bidi-switch-text =
    .label = Промени ја насоката на текстот
    .accesskey = р

main-context-menu-bidi-switch-page =
    .label = Промени ја насоката на страницата
    .accesskey = о

main-context-menu-inspect-element =
    .label = Истражи го елементот
    .accesskey = е

main-context-menu-eme-learn-more =
    .label = Дознајте повеќе за DRM…
    .accesskey = Д

