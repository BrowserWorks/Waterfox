# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Dlhším stlačením zobrazíte históriu
           *[other] Kliknutím pravým tlačidlom alebo dlhším stlačením zobrazíte históriu
        }

## Back

main-context-menu-back =
    .tooltiptext = Späť o jednu stránku
    .aria-label = Naspäť
    .accesskey = N
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Dopredu o jednu stránku
    .aria-label = Dopredu
    .accesskey = D
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Obnoviť
    .accesskey = O
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Zastaviť
    .accesskey = s
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Uložiť stránku ako…
    .accesskey = U
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Pridať stránku medzi záložky
    .accesskey = m
    .tooltiptext = Pridá stránku medzi záložky
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Pridať stránku medzi záložky
    .accesskey = m
    .tooltiptext = Pridá stránku medzi záložky ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Upraviť túto záložku
    .accesskey = m
    .tooltiptext = Umožní upraviť túto záložku
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Upraviť túto záložku
    .accesskey = m
    .tooltiptext = Umožní upraviť túto záložku ({ $shortcut })
main-context-menu-open-link =
    .label = Otvoriť odkaz
    .accesskey = d
main-context-menu-open-link-new-tab =
    .label = Otvoriť odkaz na novej karte
    .accesskey = O
main-context-menu-open-link-container-tab =
    .label = Otvoriť odkaz na novej kontajnerovej karte
    .accesskey = z
main-context-menu-open-link-new-window =
    .label = Otvoriť odkaz v novom okne
    .accesskey = t
main-context-menu-open-link-new-private-window =
    .label = Otvoriť odkaz v novom súkromnom okne
    .accesskey = s
main-context-menu-bookmark-this-link =
    .label = Pridať tento odkaz medzi záložky
    .accesskey = i
main-context-menu-save-link =
    .label = Uložiť cieľ odkazu ako…
    .accesskey = d
main-context-menu-save-link-to-pocket =
    .label = Uložiť odkaz do { -pocket-brand-name }u
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopírovať e-mailovú adresu
    .accesskey = e
main-context-menu-copy-link =
    .label = Kopírovať adresu odkazu
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Prehrať
    .accesskey = P
main-context-menu-media-pause =
    .label = Pozastaviť
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Stlmiť
    .accesskey = m
main-context-menu-media-unmute =
    .label = Zapnúť zvuk
    .accesskey = m
main-context-menu-media-play-speed =
    .label = Rýchlosť prehrávania
    .accesskey = c
main-context-menu-media-play-speed-slow =
    .label = Pomalá (0.5×)
    .accesskey = o
main-context-menu-media-play-speed-normal =
    .label = Normálna
    .accesskey = N
main-context-menu-media-play-speed-fast =
    .label = Rýchla (1.25×)
    .accesskey = a
main-context-menu-media-play-speed-faster =
    .label = Rýchlejšia (1.5×)
    .accesskey = h
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Absurdná (2 ×)
    .accesskey = b
main-context-menu-media-loop =
    .label = Slučka
    .accesskey = S

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Zobraziť ovládače
    .accesskey = d
main-context-menu-media-hide-controls =
    .label = Skryť ovládače
    .accesskey = d

##

main-context-menu-media-video-fullscreen =
    .label = Na celú obrazovku
    .accesskey = c
main-context-menu-media-video-leave-fullscreen =
    .label = Ukončiť režim celej obrazovky
    .accesskey = U
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Obraz v obraze
    .accesskey = v
main-context-menu-image-reload =
    .label = Znova načítať obrázok
    .accesskey = t
main-context-menu-image-view =
    .label = Zobraziť obrázok
    .accesskey = b
main-context-menu-video-view =
    .label = Zobraziť video
    .accesskey = b
main-context-menu-image-copy =
    .label = Kopírovať obrázok
    .accesskey = v
main-context-menu-image-copy-location =
    .label = Kopírovať adresu obrázka
    .accesskey = e
main-context-menu-video-copy-location =
    .label = Kopírovať adresu videa
    .accesskey = e
main-context-menu-audio-copy-location =
    .label = Kopírovať adresu zvuku
    .accesskey = e
main-context-menu-image-save-as =
    .label = Uložiť obrázok ako…
    .accesskey = U
main-context-menu-image-email =
    .label = Odoslať obrázok…
    .accesskey = r
main-context-menu-image-set-as-background =
    .label = Nastaviť ako pozadie pracovnej plochy…
    .accesskey = N
main-context-menu-image-info =
    .label = Zobraziť informácie o obrázku
    .accesskey = f
main-context-menu-image-desc =
    .label = Zobraziť popis
    .accesskey = s
main-context-menu-video-save-as =
    .label = Uložiť video ako…
    .accesskey = U
main-context-menu-audio-save-as =
    .label = Uložiť zvuk ako…
    .accesskey = U
main-context-menu-video-image-save-as =
    .label = Uložiť snímku ako…
    .accesskey = s
main-context-menu-video-email =
    .label = Odoslať video…
    .accesskey = v
main-context-menu-audio-email =
    .label = Odoslať zvuk…
    .accesskey = v
main-context-menu-plugin-play =
    .label = Aktivovať tento zásuvný modul
    .accesskey = A
main-context-menu-plugin-hide =
    .label = Skryť tento zásuvný modul
    .accesskey = m
main-context-menu-save-to-pocket =
    .label = Uložiť stránku do { -pocket-brand-name }u
    .accesskey = k
main-context-menu-send-to-device =
    .label = Odoslať stránku do zariadenia
    .accesskey = a
main-context-menu-view-background-image =
    .label = Zobraziť obrázok pozadia
    .accesskey = b
main-context-menu-generate-new-password =
    .label = Používať vygenerované heslo…
    .accesskey = g
main-context-menu-keyword =
    .label = Pridať kľúčové slovo pre toto vyhľadávanie…
    .accesskey = d
main-context-menu-link-send-to-device =
    .label = Odoslať odkaz do zariadenia
    .accesskey = a
main-context-menu-frame =
    .label = Tento rámec
    .accesskey = T
main-context-menu-frame-show-this =
    .label = Zobraziť len tento rámec
    .accesskey = l
main-context-menu-frame-open-tab =
    .label = Otvoriť rámec na novej karte
    .accesskey = k
main-context-menu-frame-open-window =
    .label = Otvoriť rámec v novom okne
    .accesskey = n
main-context-menu-frame-reload =
    .label = Obnoviť rámec
    .accesskey = b
main-context-menu-frame-bookmark =
    .label = Vytvoriť záložku pre tento rámec
    .accesskey = V
main-context-menu-frame-save-as =
    .label = Uložiť rámec ako…
    .accesskey = m
main-context-menu-frame-print =
    .label = Vytlačiť rámec…
    .accesskey = c
main-context-menu-frame-view-source =
    .label = Zobraziť zdrojový kód rámca
    .accesskey = r
main-context-menu-frame-view-info =
    .label = Zobraziť informácie o rámci
    .accesskey = i
main-context-menu-view-selection-source =
    .label = Zobraziť zdrojový kód výberu
    .accesskey = r
main-context-menu-view-page-source =
    .label = Zobraziť zdrojový kód stránky
    .accesskey = k
main-context-menu-view-page-info =
    .label = Zobraziť informácie o stránke
    .accesskey = i
main-context-menu-bidi-switch-text =
    .label = Zmeniť smer textu
    .accesskey = m
main-context-menu-bidi-switch-page =
    .label = Zmeniť smer stránky
    .accesskey = m
main-context-menu-inspect-element =
    .label = Preskúmať prvok
    .accesskey = m
main-context-menu-inspect-a11y-properties =
    .label = Preskúmať vlastnosti zjednodušenia ovládania
main-context-menu-eme-learn-more =
    .label = Ďalšie informácie o DRM…
    .accesskey = D
