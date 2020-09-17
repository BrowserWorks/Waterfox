# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Potegnite navzdol za prikaz zgodovine
           *[other] Desno kliknite ali potegnite navzdol za prikaz zgodovine
        }

## Back

main-context-menu-back =
    .tooltiptext = Pojdi na prejšnjo stran
    .aria-label = Nazaj
    .accesskey = z

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Pojdi na naslednjo stran
    .aria-label = Naprej
    .accesskey = r

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Ponovno naloži
    .accesskey = P

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Ustavi
    .accesskey = U

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Shrani stran kot …
    .accesskey = s

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Dodaj stran med zaznamke
    .accesskey = r
    .tooltiptext = Dodaj stran med zaznamke

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Dodaj stran med zaznamke
    .accesskey = r
    .tooltiptext = Dodaj stran med zaznamke ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Uredi ta zaznamek
    .accesskey = r
    .tooltiptext = Uredi zaznamek

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Uredi ta zaznamek
    .accesskey = r
    .tooltiptext = Uredi zaznamek ({ $shortcut })

main-context-menu-open-link =
    .label = Odpri povezavo
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Odpri povezavo v novem zavihku
    .accesskey = Z

main-context-menu-open-link-container-tab =
    .label = Odpri povezavo v novem zavihku vsebnika
    .accesskey = O

main-context-menu-open-link-new-window =
    .label = Odpri povezavo v novem oknu
    .accesskey = N

main-context-menu-open-link-new-private-window =
    .label = Odpri povezavo v novem zasebnem oknu
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = Dodaj povezavo med zaznamke
    .accesskey = M

main-context-menu-save-link =
    .label = Shrani povezavo kot …
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Shrani povezavo v { -pocket-brand-name }
    .accesskey = e

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopiraj e-poštni naslov
    .accesskey = E

main-context-menu-copy-link =
    .label = Kopiraj mesto povezave
    .accesskey = i

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Predvajaj
    .accesskey = v

main-context-menu-media-pause =
    .label = Premor
    .accesskey = o

##

main-context-menu-media-mute =
    .label = Nemo
    .accesskey = N

main-context-menu-media-unmute =
    .label = Glasno
    .accesskey = n

main-context-menu-media-play-speed =
    .label = Hitrost predvajanja
    .accesskey = r

main-context-menu-media-play-speed-slow =
    .label = Počasno (0,5 ×)
    .accesskey = P

main-context-menu-media-play-speed-normal =
    .label = Običajno
    .accesskey = O

main-context-menu-media-play-speed-fast =
    .label = Hitro (1,25 x)
    .accesskey = H

main-context-menu-media-play-speed-faster =
    .label = Hitreje (1,5 x)
    .accesskey = e

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Komično (2 x)
    .accesskey = K

main-context-menu-media-loop =
    .label = Zanka
    .accesskey = Z

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Prikaži gradnike
    .accesskey = g

main-context-menu-media-hide-controls =
    .label = Skrij gradnike
    .accesskey = g

##

main-context-menu-media-video-fullscreen =
    .label = Celoten zaslon
    .accesskey = C

main-context-menu-media-video-leave-fullscreen =
    .label = Izhod iz celozaslonskega načina
    .accesskey = j

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Slika v sliki
    .accesskey = v

main-context-menu-image-reload =
    .label = Ponovno naloži sliko
    .accesskey = P

main-context-menu-image-view =
    .label = Pokaži sliko
    .accesskey = I

main-context-menu-video-view =
    .label = Pokaži video
    .accesskey = I

main-context-menu-image-copy =
    .label = Kopiraj sliko
    .accesskey = a

main-context-menu-image-copy-location =
    .label = Kopiraj mesto slike
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Kopiraj mesto videa
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Kopiraj mesto zvoka
    .accesskey = o

main-context-menu-image-save-as =
    .label = Shrani sliko kot …
    .accesskey = s

main-context-menu-image-email =
    .label = Pošlji sliko po e-pošti …
    .accesskey = o

main-context-menu-image-set-as-background =
    .label = Nastavi za sliko ozadja namizja
    .accesskey = S

main-context-menu-image-info =
    .label = Podatki o sliki
    .accesskey = o

main-context-menu-image-desc =
    .label = Pokaži opis
    .accesskey = S

main-context-menu-video-save-as =
    .label = Shrani video kot …
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Shrani zvok kot …
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = Shrani sličico videa kot …
    .accesskey = S

main-context-menu-video-email =
    .label = Pošlji video po e-pošti …
    .accesskey = o

main-context-menu-audio-email =
    .label = Pošlji zvok po e-pošti …
    .accesskey = o

main-context-menu-plugin-play =
    .label = Omogoči vtičnik
    .accesskey = m

main-context-menu-plugin-hide =
    .label = Skrij vtičnik
    .accesskey = S

main-context-menu-save-to-pocket =
    .label = Shrani stran v { -pocket-brand-name }
    .accesskey = s

main-context-menu-send-to-device =
    .label = Pošlji stran na napravo
    .accesskey = N

main-context-menu-view-background-image =
    .label = Pokaži sliko ozadja
    .accesskey = o

main-context-menu-generate-new-password =
    .label = Uporabi ustvarjeno geslo …
    .accesskey = g

main-context-menu-keyword =
    .label = Dodaj ključno besedo k iskanju …
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = Pošlji povezavo na napravo
    .accesskey = N

main-context-menu-frame =
    .label = Ta okvir
    .accesskey = a

main-context-menu-frame-show-this =
    .label = Pokaži le ta okvir
    .accesskey = L

main-context-menu-frame-open-tab =
    .label = Odpri okvir v novem zavihku
    .accesskey = Z

main-context-menu-frame-open-window =
    .label = Odpri okvir v novem oknu
    .accesskey = V

main-context-menu-frame-reload =
    .label = Ponovno naloži okvir
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Dodaj okvir med zaznamke
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Shrani okvir kot …
    .accesskey = T

main-context-menu-frame-print =
    .label = Natisni okvir …
    .accesskey = N

main-context-menu-frame-view-source =
    .label = Pokaži izvorno kodo okvirja
    .accesskey = V

main-context-menu-frame-view-info =
    .label = Pokaži podatke o okvirju
    .accesskey = I

main-context-menu-view-selection-source =
    .label = Pokaži izvorno kodo izbora
    .accesskey = r

main-context-menu-view-page-source =
    .label = Pokaži izvorno kodo strani
    .accesskey = V

main-context-menu-view-page-info =
    .label = Pokaži podatke o strani
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Spremeni smer besedila
    .accesskey = b

main-context-menu-bidi-switch-page =
    .label = Spremeni smer strani
    .accesskey = s

main-context-menu-inspect-element =
    .label = Preglej element
    .accesskey = j

main-context-menu-inspect-a11y-properties =
    .label = Preglej lastnosti dostopnosti

main-context-menu-eme-learn-more =
    .label = Več o DRM …
    .accesskey = D

