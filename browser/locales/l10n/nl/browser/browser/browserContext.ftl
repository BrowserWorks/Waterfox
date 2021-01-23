# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Houd ingedrukt om geschiedenis te tonen
           *[other] Klik met rechts of houd ingedrukt om geschiedenis te tonen
        }

## Back

main-context-menu-back =
    .tooltiptext = Een pagina terug gaan
    .aria-label = Terug
    .accesskey = T

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Een pagina vooruit gaan
    .aria-label = Vooruit
    .accesskey = V

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Vernieuwen
    .accesskey = r

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stoppen
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Pagina opslaan als…
    .accesskey = p

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Bladwijzer voor deze pagina maken
    .accesskey = m
    .tooltiptext = Bladwijzer voor deze pagina maken

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Bladwijzer voor deze pagina maken
    .accesskey = m
    .tooltiptext = Bladwijzer voor deze pagina maken ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Deze bladwijzer bewerken
    .accesskey = m
    .tooltiptext = Deze bladwijzer bewerken

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Deze bladwijzer bewerken
    .accesskey = m
    .tooltiptext = Deze bladwijzer bewerken ({ $shortcut })

main-context-menu-open-link =
    .label = Koppeling openen
    .accesskey = o

main-context-menu-open-link-new-tab =
    .label = Koppeling openen in nieuw tabblad
    .accesskey = t

main-context-menu-open-link-container-tab =
    .label = Koppeling openen in nieuw containertabblad
    .accesskey = c

main-context-menu-open-link-new-window =
    .label = Koppeling openen in nieuw venster
    .accesskey = v

main-context-menu-open-link-new-private-window =
    .label = Koppeling openen in nieuw privévenster
    .accesskey = r

main-context-menu-bookmark-this-link =
    .label = Bladwijzer voor deze koppeling maken
    .accesskey = m

main-context-menu-save-link =
    .label = Koppeling opslaan als…
    .accesskey = l

main-context-menu-save-link-to-pocket =
    .label = Koppeling opslaan naar { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = E-mailadres kopiëren
    .accesskey = m

main-context-menu-copy-link =
    .label = Koppelingslocatie kopiëren
    .accesskey = p

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Afspelen
    .accesskey = A

main-context-menu-media-pause =
    .label = Pauzeren
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Dempen
    .accesskey = D

main-context-menu-media-unmute =
    .label = Dempen opheffen
    .accesskey = D

main-context-menu-media-play-speed =
    .label = Afspeelsnelheid
    .accesskey = f

main-context-menu-media-play-speed-slow =
    .label = Langzaam (0,5×)
    .accesskey = L

main-context-menu-media-play-speed-normal =
    .label = Normaal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Snel (1,25×)
    .accesskey = S

main-context-menu-media-play-speed-faster =
    .label = Sneller (1,5×)
    .accesskey = r

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Belachelijk (2×)
    .accesskey = B

main-context-menu-media-loop =
    .label = Herhalen
    .accesskey = H

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Bedieningsknoppen tonen
    .accesskey = B

main-context-menu-media-hide-controls =
    .label = Bedieningsknoppen verbergen
    .accesskey = B

##

main-context-menu-media-video-fullscreen =
    .label = Volledig scherm
    .accesskey = V

main-context-menu-media-video-leave-fullscreen =
    .label = Volledig scherm verlaten
    .accesskey = v

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Picture-in-Picture
    .accesskey = u

main-context-menu-image-reload =
    .label = Afbeelding vernieuwen
    .accesskey = r

main-context-menu-image-view =
    .label = Afbeelding bekijken
    .accesskey = f

main-context-menu-video-view =
    .label = Video bekijken
    .accesskey = i

main-context-menu-image-copy =
    .label = Afbeelding kopiëren
    .accesskey = k

main-context-menu-image-copy-location =
    .label = Afbeeldingslocatie kopiëren
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Videolocatie kopiëren
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Audiolocatie kopiëren
    .accesskey = o

main-context-menu-image-save-as =
    .label = Afbeelding opslaan als…
    .accesskey = n

main-context-menu-image-email =
    .label = Afbeelding e-mailen…
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = Als bureaubladachtergrond instellen…
    .accesskey = c

main-context-menu-image-info =
    .label = Afbeeldingsinfo bekijken
    .accesskey = i

main-context-menu-image-desc =
    .label = Beschrijving bekijken
    .accesskey = B

main-context-menu-video-save-as =
    .label = Video opslaan als…
    .accesskey = n

main-context-menu-audio-save-as =
    .label = Audio opslaan als…
    .accesskey = n

main-context-menu-video-image-save-as =
    .label = Momentopname opslaan als…
    .accesskey = M

main-context-menu-video-email =
    .label = Video e-mailen…
    .accesskey = l

main-context-menu-audio-email =
    .label = Audio e-mailen…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Deze plug-in activeren
    .accesskey = c

main-context-menu-plugin-hide =
    .label = Deze plug-in verbergen
    .accesskey = v

main-context-menu-save-to-pocket =
    .label = Pagina opslaan naar { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Pagina naar apparaat verzenden
    .accesskey = d

main-context-menu-view-background-image =
    .label = Achtergrondafbeelding bekijken
    .accesskey = h

main-context-menu-generate-new-password =
    .label = Aangemaakte wachtwoord gebruiken…
    .accesskey = g

main-context-menu-keyword =
    .label = Sleutelwoord voor deze zoekopdracht toevoegen…
    .accesskey = S

main-context-menu-link-send-to-device =
    .label = Koppeling naar apparaat verzenden
    .accesskey = d

main-context-menu-frame =
    .label = Dit deelvenster
    .accesskey = D

main-context-menu-frame-show-this =
    .label = Alleen dit deelvenster tonen
    .accesskey = d

main-context-menu-frame-open-tab =
    .label = Deelvenster openen in nieuw tabblad
    .accesskey = t

main-context-menu-frame-open-window =
    .label = Deelvenster openen in nieuw venster
    .accesskey = v

main-context-menu-frame-reload =
    .label = Deelvenster vernieuwen
    .accesskey = n

main-context-menu-frame-bookmark =
    .label = Bladwijzer voor dit deelvenster maken
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Deelvenster opslaan als…
    .accesskey = r

main-context-menu-frame-print =
    .label = Deelvenster afdrukken…
    .accesskey = a

main-context-menu-frame-view-source =
    .label = Deelvensterbron bekijken
    .accesskey = b

main-context-menu-frame-view-info =
    .label = Deelvensterinfo bekijken
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Bron van selectie bekijken
    .accesskey = B

main-context-menu-view-page-source =
    .label = Paginabron bekijken
    .accesskey = b

main-context-menu-view-page-info =
    .label = Pagina-info bekijken
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Tekstrichting omkeren
    .accesskey = t

main-context-menu-bidi-switch-page =
    .label = Paginarichting omkeren
    .accesskey = a

main-context-menu-inspect-element =
    .label = Element inspecteren
    .accesskey = E

main-context-menu-inspect-a11y-properties =
    .label = Toegankelijkheidseigenschappen inspecteren

main-context-menu-eme-learn-more =
    .label = Meer info over DRM…
    .accesskey = D

