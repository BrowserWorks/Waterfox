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
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Vienu tinklalapiu atgal ({ $shortcut })
    .aria-label = Atgal
    .accesskey = A
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Atgal
    .accesskey = A
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Vienu tinklalapiu pirmyn
    .aria-label = Pirmyn
    .accesskey = P
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Vienu tinklalapiu pirmyn ({ $shortcut })
    .aria-label = Pirmyn
    .accesskey = P
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Pirmyn
    .accesskey = P
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Įkelti iš naujo
    .accesskey = n
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Įkelti iš naujo
    .accesskey = n
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stabdyti
    .accesskey = S
# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Stabdyti
    .accesskey = S
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Firefox Account Button

toolbar-button-fxaccount =
    .label = „{ -fxaccount-brand-name }“ paskyra
    .tooltiptext = „{ -fxaccount-brand-name }“ paskyra

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
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Įtraukti į adresyną
    .accesskey = t
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Redaguoti adresyno įrašą
    .accesskey = t
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
main-context-menu-bookmark-link =
    .label = Įtraukti saitą į adresyną
    .accesskey = t
main-context-menu-save-link =
    .label = Įrašyti saistomą objektą kaip…
    .accesskey = Į
main-context-menu-save-link-to-pocket =
    .label = Įrašyti saitą į „{ -pocket-brand-name }“
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopijuoti el. pašto adresą
    .accesskey = t
main-context-menu-copy-link =
    .label = Kopijuoti saito adresą
    .accesskey = a
main-context-menu-copy-link-simple =
    .label = Kopijuoti saitą
    .accesskey = t

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
main-context-menu-media-play-speed-2 =
    .label = Greitis
    .accesskey = G
main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2×
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
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Žiūrėti per vaizdą-vaizde
    .accesskey = v
main-context-menu-image-reload =
    .label = Atsiųsti paveikslą iš naujo
    .accesskey = n
main-context-menu-image-view =
    .label = Rodyti paveikslą
    .accesskey = y
main-context-menu-video-view =
    .label = Rodyti vaizdo įrašą
    .accesskey = y
main-context-menu-image-view-new-tab =
    .label = Atverti paveikslą naujoje kortelėje
    .accesskey = p
main-context-menu-video-view-new-tab =
    .label = Atverti vaizdo įrašą naujoje kortelėje
    .accesskey = d
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
main-context-menu-image-copy-link =
    .label = Kopijuoti paveikslo saitą
    .accesskey = o
main-context-menu-video-copy-link =
    .label = Kopijuoti vaizdo saitą
    .accesskey = o
main-context-menu-audio-copy-link =
    .label = Kopijuoti garso saitą
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
main-context-menu-image-set-image-as-background =
    .label = Naudoti kaip darbastalio foną…
    .accesskey = N
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
main-context-menu-video-take-snapshot =
    .label = Padaryti vaizdo nuotrauką…
    .accesskey = n
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

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Naudoti įrašytą prisijungimą
    .accesskey = o
main-context-menu-use-saved-password =
    .label = Naudoti įrašytą slaptažodį
    .accesskey = o

##

main-context-menu-suggest-strong-password =
    .label = Pasiūlyti stiprų slaptažodį…
    .accesskey = s
main-context-menu-manage-logins2 =
    .label = Tvarkyti prisijungimus
    .accesskey = T
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
main-context-menu-print-selection =
    .label = Spausdinti pažymėtą sritį
    .accesskey = p
main-context-menu-view-selection-source =
    .label = Rodyti atrankos pirminį tekstą
    .accesskey = d
main-context-menu-take-screenshot =
    .label = Padaryti ekrano nuotrauką
    .accesskey = n
main-context-menu-take-frame-screenshot =
    .label = Padaryti ekrano nuotrauką
    .accesskey = o
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
main-context-menu-inspect =
    .label = Tirti
    .accesskey = T
main-context-menu-inspect-a11y-properties =
    .label = Tirti pritaikymo neįgaliesiems savybes
main-context-menu-eme-learn-more =
    .label = Sužinokite daugiau apie DRM…
    .accesskey = D
