# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Trage în jos pentru afișarea istoricului
           *[other] Dă clic dreapta sau trage în jos pentru afișarea istoricului
        }

## Back

main-context-menu-back =
    .tooltiptext = Înapoi cu o pagină
    .aria-label = Înapoi
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Înainte cu o pagină
    .aria-label = Înainte
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Reîncarcă
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Oprește
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Salvează pagina ca…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Marchează pagina
    .accesskey = m
    .tooltiptext = Marchează pagina

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Marchează pagina
    .accesskey = m
    .tooltiptext = Marchează pagina ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Editează acest marcaj
    .accesskey = m
    .tooltiptext = Editează acest marcaj

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Editează acest marcaj
    .accesskey = m
    .tooltiptext = Editează acest marcaj ({ $shortcut })

main-context-menu-open-link =
    .label = Deschide linkul
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Deschide linkul într-o filă nouă
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = Deschide linkul într-o filă container nouă
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Deschide linkul într-o fereastră nouă
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = Deschide linkul într-o fereastră privată nouă
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = Marchează linkul
    .accesskey = L

main-context-menu-save-link =
    .label = Salvează linkul ca…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Salvează linkul în { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copiază adresa de e-mail
    .accesskey = E

main-context-menu-copy-link =
    .label = Copiază locația linkului
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Redă
    .accesskey = P

main-context-menu-media-pause =
    .label = Pauză
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Dezactivează sunetul
    .accesskey = M

main-context-menu-media-unmute =
    .label = Activează sunetul
    .accesskey = m

main-context-menu-media-play-speed =
    .label = Viteză de redare
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = Lent (0,5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Rapid (1,25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = Mai repede (1,5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Ridicol (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = Redă în buclă
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Afișează comenzile
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = Ascunde comenzile
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = Ecran complet
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = Ieși din modul de ecran complet
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Picture-in-Picture
    .accesskey = u

main-context-menu-image-reload =
    .label = Reîncarcă imaginea
    .accesskey = R

main-context-menu-image-view =
    .label = Vezi imaginea
    .accesskey = I

main-context-menu-video-view =
    .label = Vezi videoclipul
    .accesskey = I

main-context-menu-image-copy =
    .label = Copiază imaginea
    .accesskey = y

main-context-menu-image-copy-location =
    .label = Copiază locația imaginii
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Copiază locația videoclipului
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Copiază locația secvenței vocale
    .accesskey = o

main-context-menu-image-save-as =
    .label = Salvează imaginea ca…
    .accesskey = v

main-context-menu-image-email =
    .label = Trimite imaginea prin e-mail…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = Setează ca fundal pentru desktop…
    .accesskey = S

main-context-menu-image-info =
    .label = Vezi informații privind imaginea
    .accesskey = f

main-context-menu-image-desc =
    .label = Vezi descrierea
    .accesskey = D

main-context-menu-video-save-as =
    .label = Salvează videoclipul ca…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Salvează materialul audio ca…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = Salvează instantaneul ca…
    .accesskey = S

main-context-menu-video-email =
    .label = Trimite videoclipul prin e-mail…
    .accesskey = a

main-context-menu-audio-email =
    .label = Trimite secvența audio prin e-mail…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Activează pluginul
    .accesskey = c

main-context-menu-plugin-hide =
    .label = Ascunde pluginul
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = Salvează pagina în { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Trimite pagina unui dispozitiv
    .accesskey = n

main-context-menu-view-background-image =
    .label = Vezi imaginea de fundal
    .accesskey = w

main-context-menu-generate-new-password =
    .label = Folosește parola generată…
    .accesskey = G

main-context-menu-keyword =
    .label = Adaugă un cuvânt-cheie pentru această căutare…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = Trimite linkul către un dispozitiv
    .accesskey = n

main-context-menu-frame =
    .label = Acest cadru
    .accesskey = h

main-context-menu-frame-show-this =
    .label = Afișează doar acest cadru
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = Deschide cadrul într-o filă nouă
    .accesskey = T

main-context-menu-frame-open-window =
    .label = Deschide cadrul într-o fereastră nouă
    .accesskey = W

main-context-menu-frame-reload =
    .label = Reîncarcă cadrul
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Marchează cadrul
    .accesskey = M

main-context-menu-frame-save-as =
    .label = Salvează cadrul ca…
    .accesskey = F

main-context-menu-frame-print =
    .label = Tipărește cadrul…
    .accesskey = p

main-context-menu-frame-view-source =
    .label = Vezi sursa cadrului
    .accesskey = V

main-context-menu-frame-view-info =
    .label = Vezi informații despre cadru
    .accesskey = I

main-context-menu-view-selection-source =
    .label = Vezi sursa selecției
    .accesskey = e

main-context-menu-view-page-source =
    .label = Vezi sursa paginii
    .accesskey = V

main-context-menu-view-page-info =
    .label = Afișează informații despre pagină
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Schimbă direcția textului
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = Schimbă direcția paginii
    .accesskey = D

main-context-menu-inspect-element =
    .label = Inspectează elementul
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Inspectează proprietățile de accesibilitate

main-context-menu-eme-learn-more =
    .label = Află mai multe despre DRM…
    .accesskey = D

