# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Palaikę nuspaustą pelės mygtuką, pamatysite kortelės žurnalą
           *[other] Spustelėję dešiniu pelės mygtuku arba palaikę nuspaustą kairįjį, pamatysite kortelės žurnalą
        }

## Back

main-context-menu-back =
    .tooltiptext = Vienu tinklalapiu atgal
    .aria-label = Atgal
    .accesskey = A
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Vienu tinklalapiu pirmyn
    .aria-label = Pirmyn
    .accesskey = P
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Įkelti iš naujo
    .accesskey = n
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stabdyti
    .accesskey = S
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Įrašyti kaip…
    .accesskey = p
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Įrašyti į adresyną
    .accesskey = y
    .tooltiptext = Įtraukti šį tinklalapį į adresyną
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Įrašyti į adresyną
    .accesskey = y
    .tooltiptext = Įtraukti šį tinklalapį į adresyną ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Taisyti adresyno įrašą
    .accesskey = y
    .tooltiptext = Taisyti šį adresyno įrašą
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Taisyti adresyno įrašą
    .accesskey = y
    .tooltiptext = Taisyti šį adresyno įrašą ({ $shortcut })
main-context-menu-open-link =
    .label = Atverti saitą
    .accesskey = A
main-context-menu-open-link-new-tab =
    .label = Atverti saitą naujoje kortelėje
    .accesskey = k
main-context-menu-open-link-container-tab =
    .label = Atverti saitą naujoje sudėtinėje kortelėje
    .accesskey = k
main-context-menu-open-link-new-window =
    .label = Atverti saitą naujame lange
    .accesskey = l
main-context-menu-open-link-new-private-window =
    .label = Atverti saitą naujame privačiojo naršymo lange
    .accesskey = p
main-context-menu-bookmark-this-link =
    .label = Įtraukti saitą į adresyną
    .accesskey = d
main-context-menu-save-link =
    .label = Įrašyti saistomą objektą kaip…
    .accesskey = Į
main-context-menu-save-link-to-pocket =
    .label = Įrašyti saitą į „{ -pocket-brand-name }“
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopijuoti el. pašto adresą
    .accesskey = e
main-context-menu-copy-link =
    .label = Kopijuoti saito adresą
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Groti
    .accesskey = G
main-context-menu-media-pause =
    .label = Pristabdyti
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Išjungti garsą
    .accesskey = r
main-context-menu-media-unmute =
    .label = Įjungti garsą
    .accesskey = r
main-context-menu-media-play-speed =
    .label = Atkūrimo greitis
    .accesskey = e
main-context-menu-media-play-speed-slow =
    .label = Lėtas (0.5×)
    .accesskey = L
main-context-menu-media-play-speed-normal =
    .label = Normalus
    .accesskey = N
main-context-menu-media-play-speed-fast =
    .label = Greitas (1.25×)
    .accesskey = G
main-context-menu-media-play-speed-faster =
    .label = Greitesnis (1.5×)
    .accesskey = r
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Pasiutęs (2×)
    .accesskey = P
main-context-menu-media-loop =
    .label = Kartoti
    .accesskey = K

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Rodyti mygtukus
    .accesskey = m
main-context-menu-media-hide-controls =
    .label = Nerodyti mygtukų
    .accesskey = m

##

main-context-menu-media-video-fullscreen =
    .label = Visame ekrane
    .accesskey = V
main-context-menu-media-video-leave-fullscreen =
    .label = Grįžti iš viso ekrano
    .accesskey = G
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Vaizdas-vaizde
    .accesskey = z
main-context-menu-image-reload =
    .label = Atsiųsti paveikslą iš naujo
    .accesskey = n
main-context-menu-image-view =
    .label = Rodyti paveikslą
    .accesskey = y
main-context-menu-video-view =
    .label = Rodyti vaizdo įrašą
    .accesskey = y
main-context-menu-image-copy =
    .label = Kopijuoti paveikslą
    .accesskey = p
main-context-menu-image-copy-location =
    .label = Kopijuoti paveikslo adresą
    .accesskey = o
main-context-menu-video-copy-location =
    .label = Kopijuoti vaizdo adresą
    .accesskey = o
main-context-menu-audio-copy-location =
    .label = Kopijuoti garso adresą
    .accesskey = o
main-context-menu-image-save-as =
    .label = Įrašyti paveikslą kaip…
    .accesskey = r
main-context-menu-image-email =
    .label = Išsiųsti paveikslą el. paštu…
    .accesskey = s
main-context-menu-image-set-as-background =
    .label = Naudoti kaip darbastalio foną…
    .accesskey = d
main-context-menu-image-info =
    .label = Rodyti paveikslo savybes
    .accesskey = s
main-context-menu-image-desc =
    .label = Rodyti aprašą
    .accesskey = o
main-context-menu-video-save-as =
    .label = Įrašyti vaizdą kaip…
    .accesskey = r
main-context-menu-audio-save-as =
    .label = Įrašyti garsą kaip…
    .accesskey = r
main-context-menu-video-image-save-as =
    .label = Įrašyti kadrą kaip…
    .accesskey = k
main-context-menu-video-email =
    .label = Išsiųsti vaizdo įrašą el. paštu…
    .accesskey = s
main-context-menu-audio-email =
    .label = Išsiųsti garso įrašą el. paštu…
    .accesskey = s
main-context-menu-plugin-play =
    .label = Aktyvinti šį papildinį
    .accesskey = A
main-context-menu-plugin-hide =
    .label = Slėpti šį papildinį
    .accesskey = S
main-context-menu-save-to-pocket =
    .label = Įrašyti tinklalapį į „{ -pocket-brand-name }“
    .accesskey = k
main-context-menu-send-to-device =
    .label = Siųsti tinklalapį į įrenginį
    .accesskey = r
main-context-menu-view-background-image =
    .label = Rodyti fono piešinį
    .accesskey = f
main-context-menu-generate-new-password =
    .label = Naudoti sugeneruotą slaptažodį
    .accesskey = g
main-context-menu-keyword =
    .label = Įdėti šios paieškos reikšminį žodį…
    .accesskey = p
main-context-menu-link-send-to-device =
    .label = Siųsti saitą į įrenginį
    .accesskey = r
main-context-menu-frame =
    .label = Kadras
    .accesskey = K
main-context-menu-frame-show-this =
    .label = Rodyti tik šį kadrą
    .accesskey = t
main-context-menu-frame-open-tab =
    .label = Atverti kadrą naujoje kortelėje
    .accesskey = k
main-context-menu-frame-open-window =
    .label = Atverti kadrą naujame lange
    .accesskey = l
main-context-menu-frame-reload =
    .label = Atsiųsti kadrą iš naujo
    .accesskey = n
main-context-menu-frame-bookmark =
    .label = Įtraukti kadrą į adresyną
    .accesskey = d
main-context-menu-frame-save-as =
    .label = Įrašyti kadrą kaip…
    .accesskey = r
main-context-menu-frame-print =
    .label = Spausdinti kadrą…
    .accesskey = S
main-context-menu-frame-view-source =
    .label = Kadro pirminis tekstas
    .accesskey = m
main-context-menu-frame-view-info =
    .label = Informacija apie kadrą
    .accesskey = I
main-context-menu-view-selection-source =
    .label = Rodyti atrankos pirminį tekstą
    .accesskey = d
main-context-menu-view-page-source =
    .label = Pirminis tekstas
    .accesskey = e
main-context-menu-view-page-info =
    .label = Informacija apie tinklalapį
    .accesskey = I
main-context-menu-bidi-switch-text =
    .label = Pakeisti teksto kryptį
    .accesskey = k
main-context-menu-bidi-switch-page =
    .label = Pakeisti puslapio kryptį
    .accesskey = a
main-context-menu-inspect-element =
    .label = Tirti elementą
    .accesskey = T
main-context-menu-inspect-a11y-properties =
    .label = Tirti pritaikymo neįgaliesiems savybes
main-context-menu-eme-learn-more =
    .label = Sužinokite daugiau apie DRM…
    .accesskey = D
