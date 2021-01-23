# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Tarixni koʻrish uchun pastga suring
           *[other] Tarixni ko‘rish uchun o‘ng tugmani bosing yoking pastga suring
        }

## Back

main-context-menu-back =
    .tooltiptext = Bir sahifa orqaga qaytish
    .aria-label = Orqaga
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Bir sahifa oldinga oʻtish
    .aria-label = Oldinga
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Qayta yuklash
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = To‘xtatish
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Sahifani saqlash…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Sahifani xatcho‘plarga qo‘shish
    .accesskey = m
    .tooltiptext = Sahifani xatcho‘pga qo‘shish

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Sahifani xatcho‘plarga qo‘shish
    .accesskey = m
    .tooltiptext = Sahifani xatcho‘pga qo‘shish ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Ushbu xatcho‘pni o‘zgartirish
    .accesskey = m
    .tooltiptext = Ushbu xatcho‘pni tahrirlash

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Ushbu xatcho‘pni o‘zgartirish
    .accesskey = m
    .tooltiptext = Ushbu xatcho‘pni tahrirlash ({ $shortcut })

main-context-menu-open-link =
    .label = Havolani ochish
    .accesskey = o

main-context-menu-open-link-new-tab =
    .label = Havolani yangi varaqda ochish
    .accesskey = i

main-context-menu-open-link-container-tab =
    .label = Havolani yangi konteyner oynasida ochish
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Havolani yangi oynada ochish
    .accesskey = o

main-context-menu-open-link-new-private-window =
    .label = Havolani yangi maxfiy oynada ochish
    .accesskey = m

main-context-menu-bookmark-this-link =
    .label = Havolani xatcho‘plarga qo‘shish
    .accesskey = H

main-context-menu-save-link =
    .label = Havolani saqlash…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Havolani { -pocket-brand-name } xizmatiga saqlash
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Email manzilidan nusxa olish
    .accesskey = E

main-context-menu-copy-link =
    .label = Havoladan nusxa olish
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Ijro etish
    .accesskey = I

main-context-menu-media-pause =
    .label = Pauza
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Tovushni oʻchirish
    .accesskey = o

main-context-menu-media-unmute =
    .label = Tovushni yoqish
    .accesskey = y

main-context-menu-media-play-speed =
    .label = Ijro etish tezligi
    .accesskey = I

main-context-menu-media-play-speed-slow =
    .label = Sekin (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Meʼyorda
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Tez (1.25×)
    .accesskey = T

main-context-menu-media-play-speed-faster =
    .label = Tezroq (1.5×)
    .accesskey = T

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Kulguli tezlik (2×)
    .accesskey = K

main-context-menu-media-loop =
    .label = Takrorlash
    .accesskey = T

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Boshqaruvlarni koʻrsatish
    .accesskey = B

main-context-menu-media-hide-controls =
    .label = Boshqaruvlarni yashirish
    .accesskey = B

##

main-context-menu-media-video-fullscreen =
    .label = Butun ekran
    .accesskey = B

main-context-menu-media-video-leave-fullscreen =
    .label = Butun ekrandan chiqish
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Rasm ichida rasm
    .accesskey = u

main-context-menu-image-reload =
    .label = Rasmni qayta yuklash
    .accesskey = R

main-context-menu-image-view =
    .label = Rasmni ko‘rish
    .accesskey = i

main-context-menu-video-view =
    .label = Videoni koʻrish
    .accesskey = i

main-context-menu-image-copy =
    .label = Rasmdan nusxa olish
    .accesskey = u

main-context-menu-image-copy-location =
    .label = Rasm manzilidan nusxa olish
    .accesskey = z

main-context-menu-video-copy-location =
    .label = Video manzildan nusxa olish
    .accesskey = l

main-context-menu-audio-copy-location =
    .label = Audio manzildan nusxa olish
    .accesskey = o

main-context-menu-image-save-as =
    .label = Rasmni saqlash…
    .accesskey = q

main-context-menu-image-email =
    .label = Rasmni emaildan joʻnatish…
    .accesskey = m

main-context-menu-image-set-as-background =
    .label = Ish stoli orqa foni sifatida o‘rnatish
    .accesskey = s

main-context-menu-image-info =
    .label = Rasm maʼlumotini koʻrish
    .accesskey = t

main-context-menu-image-desc =
    .label = Taʼrifini koʻrish
    .accesskey = T

main-context-menu-video-save-as =
    .label = Videoni saqlash…
    .accesskey = V

main-context-menu-audio-save-as =
    .label = Audioni saqlash…
    .accesskey = o

main-context-menu-video-image-save-as =
    .label = Olingan rasmni saqlash
    .accesskey = s

main-context-menu-video-email =
    .label = Videoni emaildan joʻnatish
    .accesskey = o

main-context-menu-audio-email =
    .label = Audioni emaildan joʻnatish…
    .accesskey = A

main-context-menu-plugin-play =
    .label = Bu plaginni faollashtirish
    .accesskey = f

main-context-menu-plugin-hide =
    .label = Bu plaginni yashirish
    .accesskey = y

main-context-menu-save-to-pocket =
    .label = Sahifani { -pocket-brand-name } xizmatiga saqlash
    .accesskey = k

main-context-menu-send-to-device =
    .label = Sahifani qurilmaga joʻnatish
    .accesskey = q

main-context-menu-view-background-image =
    .label = Orqa fon rasmini koʻrish
    .accesskey = r

main-context-menu-generate-new-password =
    .label = Yaratilgan paroldan foydalanish
    .accesskey = Y

main-context-menu-keyword =
    .label = Ushbu qidiruv uchun kalit soʻzni qoʻshish…
    .accesskey = k

main-context-menu-link-send-to-device =
    .label = Havolani qurilmaga uzatish
    .accesskey = q

main-context-menu-frame =
    .label = Bu freym
    .accesskey = B

main-context-menu-frame-show-this =
    .label = Faqat shu freymni koʻrsatish
    .accesskey = s

main-context-menu-frame-open-tab =
    .label = Freymni yangi varaqda ochish
    .accesskey = i

main-context-menu-frame-open-window =
    .label = Freymni yangi oynada ochish
    .accesskey = o

main-context-menu-frame-reload =
    .label = Freymni qayta yuklash
    .accesskey = q

main-context-menu-frame-bookmark =
    .label = Freymni xatchoʻplarga qoʻshish
    .accesskey = h

main-context-menu-frame-save-as =
    .label = Freym sifatida saqlash
    .accesskey = F

main-context-menu-frame-print =
    .label = Freymni chop qilish…
    .accesskey = c

main-context-menu-frame-view-source =
    .label = Freym manbasi
    .accesskey = k

main-context-menu-frame-view-info =
    .label = Freym haqida maʼlumot
    .accesskey = s

main-context-menu-view-selection-source =
    .label = Tanlangan fragment manba kodi
    .accesskey = e

main-context-menu-view-page-source =
    .label = Sahifa manba kodi
    .accesskey = k

main-context-menu-view-page-info =
    .label = Sahifa haqida maʼlumot
    .accesskey = l

main-context-menu-bidi-switch-text =
    .label = Matn yoʻnalishini almashtirish
    .accesskey = a

main-context-menu-bidi-switch-page =
    .label = Sahifa yoʻnalishini almashtirish
    .accesskey = y

main-context-menu-inspect-element =
    .label = Elementni kuzatish
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Qulaylik xossalarini kuzatish

main-context-menu-eme-learn-more =
    .label = DRM haqida batafsil…
    .accesskey = D

