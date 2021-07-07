# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Trascina verso il basso per visualizzare la cronologia
           *[other] Tasto destro o trascina verso il basso per visualizzare la cronologia
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Torna indietro di una pagina ({ $shortcut })
    .aria-label = Indietro
    .accesskey = I

# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Indietro
    .accesskey = I

navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }

toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Vai avanti di una pagina ({ $shortcut })
    .aria-label = Avanti
    .accesskey = A

# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Avanti
    .accesskey = A

navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }

toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Ricarica
    .accesskey = R

# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Ricarica
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stop
    .accesskey = S

# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Stop
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name(capitalization: "uppercase") }
    .tooltiptext = { -fxaccount-brand-name(capitalization: "uppercase") }

## Save Page

main-context-menu-page-save =
    .label = Salva pagina con nome…
    .accesskey = g

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Aggiungi pagina ai segnalibri
    .accesskey = u
    .tooltiptext = Aggiungi ai segnalibri

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Aggiungi pagina ai segnalibri
    .accesskey = n

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Modifica segnalibro
    .accesskey = n

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Aggiungi pagina ai segnalibri
    .accesskey = n
    .tooltiptext = Aggiungi ai segnalibri ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Modifica segnalibro
    .accesskey = n
    .tooltiptext = Modifica questo segnalibro

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Modifica segnalibro
    .accesskey = n
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

main-context-menu-bookmark-link =
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


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copia indirizzo email
    .accesskey = e

main-context-menu-copy-link-simple =
    .label = Copia link
    .accesskey = a

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

main-context-menu-media-play-speed-2 =
    .label = Velocità
    .accesskey = V

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

main-context-menu-media-watch-pip =
    .label = Guarda in Picture-in-Picture
    .accesskey = u

main-context-menu-image-reload =
    .label = Ricarica immagine
    .accesskey = R

main-context-menu-image-view-new-tab =
    .label = Apri immagine in nuova scheda
    .accesskey = v

main-context-menu-video-view-new-tab =
    .label = Apri video in nuova scheda
    .accesskey = v

main-context-menu-image-copy =
    .label = Copia immagine
    .accesskey = a

main-context-menu-image-copy-link =
    .label = Copia link immagine
    .accesskey = m

main-context-menu-video-copy-link =
    .label = Copia link video
    .accesskey = o

main-context-menu-audio-copy-link =
    .label = Copia link audio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Salva immagine con nome…
    .accesskey = e

main-context-menu-image-email =
    .label = Invia immagine per email…
    .accesskey = n

main-context-menu-image-set-image-as-background =
    .label = Imposta immagine come sfondo del desktop…
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

main-context-menu-video-take-snapshot =
    .label = Acquisisci istantanea…
    .accesskey = s

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

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Utilizza credenziali salvate
    .accesskey = U

main-context-menu-use-saved-password =
    .label = Utilizza password salvata
    .accesskey = U

##

main-context-menu-suggest-strong-password =
    .label = Suggerisci password complessa…
    .accesskey = S

main-context-menu-manage-logins2 =
    .label = Gestisci credenziali
    .accesskey = G

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

main-context-menu-print-selection =
    .label = Stampa selezione
    .accesskey = m

main-context-menu-view-selection-source =
    .label = Visualizza sorgente selezione
    .accesskey = u

main-context-menu-take-screenshot =
    .label = Acquisisci schermata
    .accesskey = e

main-context-menu-take-frame-screenshot =
    .label = Acquisisci schermata
    .accesskey = e

main-context-menu-view-page-source =
    .label = Visualizza sorgente pagina
    .accesskey = u

main-context-menu-bidi-switch-text =
    .label = Cambia direzione testo
    .accesskey = d

main-context-menu-bidi-switch-page =
    .label = Cambia orientamento pagina
    .accesskey = g

main-context-menu-inspect =
    .label = Analizza
    .accesskey = l

main-context-menu-inspect-a11y-properties =
    .label = Analizza proprietà accessibilità

main-context-menu-eme-learn-more =
    .label = Ulteriori informazioni sul DRM…
    .accesskey = D

# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = Apri link in nuova scheda { $containerName }
    .accesskey = s
