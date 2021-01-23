# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Tegnair smatgà per vesair la cronologia
           *[other] Cliccar cun la tasta dretga da la mieur u tegnair smatgà per vesair la cronologia
        }

## Back

main-context-menu-back =
    .tooltiptext = Ina pagina enavos
    .aria-label = Enavos
    .accesskey = E

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Ina pagina enavant
    .aria-label = Enavant
    .accesskey = n

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Chargiar danovamain
    .accesskey = r

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stop
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Memorisar la pagina sut…
    .accesskey = u

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Agiuntar in segnapagina per la pagina
    .accesskey = t
    .tooltiptext = Agiuntar in segnapagina

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Agiuntar in segnapagina per la pagina
    .accesskey = t
    .tooltiptext = Agiuntar in segnapagina ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Modifitgar quest segnapagina
    .accesskey = t
    .tooltiptext = Modifitgar quest segnapagina

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Modifitgar quest segnapagina
    .accesskey = t
    .tooltiptext = Modifitgar quest segnapagina ({ $shortcut })

main-context-menu-open-link =
    .label = Avrir la colliaziun
    .accesskey = A

main-context-menu-open-link-new-tab =
    .label = Avrir la colliaziun en in nov tab
    .accesskey = t

main-context-menu-open-link-container-tab =
    .label = Avrir la colliaziun en in nov tab da container
    .accesskey = C

main-context-menu-open-link-new-window =
    .label = Avrir la colliaziun en ina nova fanestra
    .accesskey = f

main-context-menu-open-link-new-private-window =
    .label = Avrir la colliaziun en ina nova fanestra privata
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = Agiuntar in segnapagina per la colliaziun
    .accesskey = l

main-context-menu-save-link =
    .label = Memorisar la destinaziun sut…
    .accesskey = z

main-context-menu-save-link-to-pocket =
    .label = Memorisar la colliaziun en { -pocket-brand-name }
    .accesskey = c

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copiar l'adressa dad e-mail
    .accesskey = e

main-context-menu-copy-link =
    .label = Copiar l'adressa da la colliaziun
    .accesskey = C

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Far ir
    .accesskey = F

main-context-menu-media-pause =
    .label = Pausa
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Senza tun
    .accesskey = S

main-context-menu-media-unmute =
    .label = Cun tun
    .accesskey = C

main-context-menu-media-play-speed =
    .label = Sveltezza da reproducziun
    .accesskey = v

main-context-menu-media-play-speed-slow =
    .label = Plaun (0.5×)
    .accesskey = P

main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Svelt (1.25×)
    .accesskey = S

main-context-menu-media-play-speed-faster =
    .label = Pli svelt (1.5×)
    .accesskey = l

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Stravagà (2×)
    .accesskey = t

main-context-menu-media-loop =
    .label = Repeter
    .accesskey = R

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Mussar las controllas
    .accesskey = c

main-context-menu-media-hide-controls =
    .label = Zuppentar las controllas
    .accesskey = c

##

main-context-menu-media-video-fullscreen =
    .label = Maletg entir
    .accesskey = M

main-context-menu-media-video-leave-fullscreen =
    .label = Bandunar il modus da maletg entir
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = maletg-en-maletg
    .accesskey = g

main-context-menu-image-reload =
    .label = Rechargiar la grafica
    .accesskey = R

main-context-menu-image-view =
    .label = Mussar la grafica
    .accesskey = i

main-context-menu-video-view =
    .label = Mussar il video
    .accesskey = i

main-context-menu-image-copy =
    .label = Copiar la grafica
    .accesskey = C

main-context-menu-image-copy-location =
    .label = Copiar l'adressa da la grafica
    .accesskey = d

main-context-menu-video-copy-location =
    .label = Copiar l'adressa dal video
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Copiar l'adressa da l'audio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Memorisar la grafica sut…
    .accesskey = g

main-context-menu-image-email =
    .label = Trametter la grafica per e-mail…
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = Definir sco culissa…
    .accesskey = a

main-context-menu-image-info =
    .label = Mussar infurmaziuns davart la grafica
    .accesskey = g

main-context-menu-image-desc =
    .label = Mussar la descripziun
    .accesskey = D

main-context-menu-video-save-as =
    .label = Memorisar il video sut…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Memorisar l'audio sut…
    .accesskey = M

main-context-menu-video-image-save-as =
    .label = Memorisar il maletg sco…
    .accesskey = s

main-context-menu-video-email =
    .label = Trametter il video per e-mail…
    .accesskey = a

main-context-menu-audio-email =
    .label = Trametter l'audio per e-mail…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Activar quest plug-in
    .accesskey = c

main-context-menu-plugin-hide =
    .label = Zuppentar quest plug-in
    .accesskey = p

main-context-menu-save-to-pocket =
    .label = Memorisar la pagina en { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Trametter la pagina ad in apparat
    .accesskey = a

main-context-menu-view-background-image =
    .label = Mussar la grafica dal fund davos
    .accesskey = M

main-context-menu-generate-new-password =
    .label = Utilisar in pled-clav generà…
    .accesskey = U

main-context-menu-keyword =
    .label = Agiuntar in pled magic per questa tschertga…
    .accesskey = s

main-context-menu-link-send-to-device =
    .label = Trametter la colliaziun ad in apparat
    .accesskey = a

main-context-menu-frame =
    .label = Frame actual
    .accesskey = F

main-context-menu-frame-show-this =
    .label = Mussar mo quest frame
    .accesskey = M

main-context-menu-frame-open-tab =
    .label = Avrir il frame en in nov tab
    .accesskey = t

main-context-menu-frame-open-window =
    .label = Avrir il frame en ina nova fanestra
    .accesskey = f

main-context-menu-frame-reload =
    .label = Chargiar danovamain il frame
    .accesskey = r

main-context-menu-frame-bookmark =
    .label = Agiuntar in segnapagina per il frame
    .accesskey = A

main-context-menu-frame-save-as =
    .label = Memorisar il frame sut…
    .accesskey = u

main-context-menu-frame-print =
    .label = Stampar il frame…
    .accesskey = S

main-context-menu-frame-view-source =
    .label = Mussar il code da funtauna dal frame
    .accesskey = f

main-context-menu-frame-view-info =
    .label = Mussar infurmaziuns davart il frame
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Mussar il code da funtauna da la selecziun
    .accesskey = A

main-context-menu-view-page-source =
    .label = Mussar il code da funtauna da la pagina
    .accesskey = a

main-context-menu-view-page-info =
    .label = Mussar infurmaziuns davart la pagina
    .accesskey = M

main-context-menu-bidi-switch-text =
    .label = Midar la direcziun dal text
    .accesskey = M

main-context-menu-bidi-switch-page =
    .label = Midar la direcziun da la pagina
    .accesskey = M

main-context-menu-inspect-element =
    .label = Inspectar l'element
    .accesskey = I

main-context-menu-inspect-a11y-properties =
    .label = Inspectar las caracteristicas da l'accessiblitad

main-context-menu-eme-learn-more =
    .label = Dapli infurmaziuns davart DRM…
    .accesskey = D

