# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Trascina verso il basso per visualizzare la cronologia
           *[other] Tasto destro o trascina verso il basso per visualizzare la cronologia
        }

## Back

main-context-menu-back =
    .tooltiptext = Torna indietro di una pagina
    .aria-label = Indietro
    .accesskey = I

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Vai avanti di una pagina
    .aria-label = Avanti
    .accesskey = A

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Ricarica
    .accesskey = R

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
    .label = Salva pagina con nome…
    .accesskey = g

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Aggiungi pagina ai segnalibri
    .accesskey = u
    .tooltiptext = Aggiungi ai segnalibri

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Aggiungi pagina ai segnalibri
    .accesskey = u
    .tooltiptext = Aggiungi ai segnalibri ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Modifica segnalibro
    .accesskey = u
    .tooltiptext = Modifica questo segnalibro

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Modifica segnalibro
    .accesskey = u
    .tooltiptext = Modifica questo segnalibro ({ $shortcut })

main-context-menu-open-link =
    .label = Apri link
    .accesskey = A

main-context-menu-open-link-new-tab =
    .label = Apri link in nuova scheda
    .accesskey = s

main-context-menu-open-link-container-tab =
    .label = Apri link in nuova scheda contenitore
    .accesskey = h

main-context-menu-open-link-new-window =
    .label = Apri link in nuova finestra
    .accesskey = f

main-context-menu-open-link-new-private-window =
    .label = Apri link in nuova finestra anonima
    .accesskey = k

main-context-menu-bookmark-this-link =
    .label = Aggiungi link ai segnalibri…
    .accesskey = b

main-context-menu-save-link =
    .label = Salva destinazione con nome…
    .accesskey = d

main-context-menu-save-link-to-pocket =
    .label = Salva link in { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copia indirizzo email
    .accesskey = e

main-context-menu-copy-link =
    .label = Copia indirizzo
    .accesskey = z

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Riproduci
    .accesskey = R

main-context-menu-media-pause =
    .label = Pausa
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Disattiva audio
    .accesskey = D

main-context-menu-media-unmute =
    .label = Attiva audio
    .accesskey = A

main-context-menu-media-play-speed =
    .label = Velocità di riproduzione
    .accesskey = z

main-context-menu-media-play-speed-slow =
    .label = Rallentata (0.5×)
    .accesskey = R

main-context-menu-media-play-speed-normal =
    .label = Normale
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Veloce (1.25×)
    .accesskey = V

main-context-menu-media-play-speed-faster =
    .label = Più veloce (1.5×)
    .accesskey = P

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Smodata (2×)
    .accesskey = S

main-context-menu-media-loop =
    .label = Ripeti
    .accesskey = R

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Mostra controlli
    .accesskey = c

main-context-menu-media-hide-controls =
    .label = Nascondi controlli
    .accesskey = c

##

main-context-menu-media-video-fullscreen =
    .label = Schermo intero
    .accesskey = m

main-context-menu-media-video-leave-fullscreen =
    .label = Esci da schermo intero
    .accesskey = h

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Picture-in-Picture
    .accesskey = u

main-context-menu-image-reload =
    .label = Ricarica immagine
    .accesskey = R

main-context-menu-image-view =
    .label = Visualizza immagine
    .accesskey = V

main-context-menu-video-view =
    .label = Visualizza video
    .accesskey = V

main-context-menu-image-copy =
    .label = Copia immagine
    .accesskey = a

main-context-menu-image-copy-location =
    .label = Copia indirizzo immagine
    .accesskey = m

main-context-menu-video-copy-location =
    .label = Copia indirizzo video
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Copia indirizzo audio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Salva immagine con nome…
    .accesskey = e

main-context-menu-image-email =
    .label = Invia immagine per email…
    .accesskey = n

main-context-menu-image-set-as-background =
    .label = Imposta come sfondo del desktop…
    .accesskey = p

main-context-menu-image-info =
    .label = Visualizza informazioni immagine
    .accesskey = u

main-context-menu-image-desc =
    .label = Visualizza descrizione
    .accesskey = d

main-context-menu-video-save-as =
    .label = Salva video come…
    .accesskey = S

main-context-menu-audio-save-as =
    .label = Salva audio come…
    .accesskey = S

main-context-menu-video-image-save-as =
    .label = Salva fotogramma come…
    .accesskey = f

main-context-menu-video-email =
    .label = Invia video per email…
    .accesskey = n

main-context-menu-audio-email =
    .label = Invia audio per email…
    .accesskey = n

main-context-menu-plugin-play =
    .label = Attiva questo plugin
    .accesskey = l

main-context-menu-plugin-hide =
    .label = Nascondi questo plugin
    .accesskey = N

main-context-menu-save-to-pocket =
    .label = Salva pagina in { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Invia pagina a dispositivo
    .accesskey = I

main-context-menu-view-background-image =
    .label = Visualizza immagine di sfondo
    .accesskey = V

main-context-menu-generate-new-password =
    .label = Utilizza password generata…
    .accesskey = w

main-context-menu-keyword =
    .label = Aggiungi una parola chiave per questa ricerca…
    .accesskey = p

main-context-menu-link-send-to-device =
    .label = Invia link a dispositivo
    .accesskey = I

main-context-menu-frame =
    .label = Questo riquadro
    .accesskey = Q

main-context-menu-frame-show-this =
    .label = Visualizza solo questo riquadro
    .accesskey = V

main-context-menu-frame-open-tab =
    .label = Apri riquadro in nuova scheda
    .accesskey = c

main-context-menu-frame-open-window =
    .label = Apri riquadro in nuova finestra
    .accesskey = A

main-context-menu-frame-reload =
    .label = Ricarica riquadro
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Aggiungi riquadro ai segnalibri…
    .accesskey = e

main-context-menu-frame-save-as =
    .label = Salva riquadro con nome…
    .accesskey = S

main-context-menu-frame-print =
    .label = Stampa riquadro…
    .accesskey = u

main-context-menu-frame-view-source =
    .label = Visualizza sorgente riquadro
    .accesskey = o

main-context-menu-frame-view-info =
    .label = Visualizza informazioni riquadro
    .accesskey = n

main-context-menu-view-selection-source =
    .label = Visualizza sorgente selezione
    .accesskey = u

main-context-menu-view-page-source =
    .label = Visualizza sorgente pagina
    .accesskey = u

main-context-menu-view-page-info =
    .label = Visualizza informazioni pagina
    .accesskey = f

main-context-menu-bidi-switch-text =
    .label = Cambia direzione testo
    .accesskey = d

main-context-menu-bidi-switch-page =
    .label = Cambia orientamento pagina
    .accesskey = g

main-context-menu-inspect-element =
    .label = Analizza elemento
    .accesskey = l

main-context-menu-inspect-a11y-properties =
    .label = Analizza proprietà accessibilità

main-context-menu-eme-learn-more =
    .label = Ulteriori informazioni sul DRM…
    .accesskey = D
