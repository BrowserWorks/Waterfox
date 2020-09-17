# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Падајући мени показује историјат
           *[other] Десни клик или мени за приказ историјата
        }

## Back

main-context-menu-back =
    .tooltiptext = Назад за једну страну
    .aria-label = Назад
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Напред за једну страну
    .aria-label = Напред
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Поново учитај
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Заустави
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Сачувај страницу као…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Забележи ову страницу
    .accesskey = m
    .tooltiptext = Забележи ову страницу

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Забележи ову страницу
    .accesskey = m
    .tooltiptext = Забележи ову страницу ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Уреди ову забелешку
    .accesskey = m
    .tooltiptext = Уреди ову забелешку

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Уреди ову забелешку
    .accesskey = m
    .tooltiptext = Уреди ову забелешку ({ $shortcut })

main-context-menu-open-link =
    .label = Отвори везу
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Отвори у новом језичку
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = Отвори у новом контејнеру
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Отвори у новом прозору
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = Отвори нови приватан прозор
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = Забележи ову везу
    .accesskey = L

main-context-menu-save-link =
    .label = Сачувај везу као…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Сачувај везу са услугом { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Копирај адресу е-поште
    .accesskey = A

main-context-menu-copy-link =
    .label = Копирај одредиште везе
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Пусти
    .accesskey = P

main-context-menu-media-pause =
    .label = Пауза
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Искљ. звук
    .accesskey = M

main-context-menu-media-unmute =
    .label = Укљ. звук
    .accesskey = m

main-context-menu-media-play-speed =
    .label = Брзина пуштања
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = Споро (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Нормално
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Брзо (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = Брже (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Дупло брже (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = Понављај
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Прикажи контроле
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = Сакриј контроле
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = Користи цео екран
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = Обустави приказ преко целог екрана
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Слика у слици
    .accesskey = u

main-context-menu-image-reload =
    .label = Учитај поново слике
    .accesskey = R

main-context-menu-image-view =
    .label = Прикажи слику
    .accesskey = I

main-context-menu-video-view =
    .label = Преглед видеа
    .accesskey = i

main-context-menu-image-copy =
    .label = Копирај слику
    .accesskey = y

main-context-menu-image-copy-location =
    .label = Копирај одредиште слике
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Копирај одредиште видеа
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Копирај одредиште за аудио
    .accesskey = o

main-context-menu-image-save-as =
    .label = Сачувај слику као…
    .accesskey = v

main-context-menu-image-email =
    .label = Шаљи слику…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = Постави на радну површину…
    .accesskey = S

main-context-menu-image-info =
    .label = Преглед података о слици
    .accesskey = f

main-context-menu-image-desc =
    .label = Преглед описа
    .accesskey = D

main-context-menu-video-save-as =
    .label = Сачувај видео као…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Сачувај аудио као…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = Сачувај слику као…
    .accesskey = S

main-context-menu-video-email =
    .label = Шаљи видео…
    .accesskey = a

main-context-menu-audio-email =
    .label = Шаљи аудио…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Активирај овај прикључак
    .accesskey = c

main-context-menu-plugin-hide =
    .label = Сакриј овај прикључак
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = Сачувај страницу са услугом { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Пошаљи страницу на уређај
    .accesskey = n

main-context-menu-view-background-image =
    .label = Прикажи позадинску слику
    .accesskey = w

main-context-menu-generate-new-password =
    .label = Користи генерисану лозинку…
    .accesskey = G

main-context-menu-keyword =
    .label = Додај кључну реч за ову претрагу…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = Пошаљи везу на уређај
    .accesskey = n

main-context-menu-frame =
    .label = У овом оквиру
    .accesskey = h

main-context-menu-frame-show-this =
    .label = Прикажи само овај оквир
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = Отвори оквир у новом језичку
    .accesskey = T

main-context-menu-frame-open-window =
    .label = Отвори оквир у новом прозору
    .accesskey = W

main-context-menu-frame-reload =
    .label = Обнови оквир
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Забележи овај оквир
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Сачувај оквир као…
    .accesskey = F

main-context-menu-frame-print =
    .label = Штампај оквир…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = Преглед изворног кода оквира
    .accesskey = V

main-context-menu-frame-view-info =
    .label = Преглед података о оквиру
    .accesskey = I

main-context-menu-view-selection-source =
    .label = Преглед изворног кода изабраног дела
    .accesskey = e

main-context-menu-view-page-source =
    .label = Преглед изворног кода
    .accesskey = V

main-context-menu-view-page-info =
    .label = Преглед података о страници
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Промени усмерење текста
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = Промени усмерење странице
    .accesskey = D

main-context-menu-inspect-element =
    .label = Испитај елеменат
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Истражи својства приступачности

main-context-menu-eme-learn-more =
    .label = Сазнајте више о DRM…
    .accesskey = D
