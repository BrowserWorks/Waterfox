# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Povuci dolje za prikaz povijesti
           *[other] Za prikaz povijesti pritisni desnu tipku miša ili povuci prema dolje
        }

## Back

main-context-menu-back =
    .tooltiptext = Idi jednu stranicu natrag
    .aria-label = Natrag
    .accesskey = N

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Idi jednu stranicu naprijed
    .aria-label = Naprijed
    .accesskey = a

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Učitaj ponovo
    .accesskey = U

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Zaustavi
    .accesskey = s

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Spremi stranicu kao …
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Zabilježi ovu stranicu
    .accesskey = Z
    .tooltiptext = Zabilježi ovu stranicu

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Zabilježi ovu stranicu
    .accesskey = Z
    .tooltiptext = Zabilježi ovu stranicu ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Uredi ovu zabilješku
    .accesskey = Z
    .tooltiptext = Uredi ovu zabilješku

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Uredi ovu zabilješku
    .accesskey = Z
    .tooltiptext = Uredi ovu zabilješku ({ $shortcut })

main-context-menu-open-link =
    .label = Otvori poveznicu
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Otvori poveznicu u novoj kartici
    .accesskey = t

main-context-menu-open-link-container-tab =
    .label = Otvori poveznicu u kontejnerskoj kartici
    .accesskey = k

main-context-menu-open-link-new-window =
    .label = Otvori poveznicu u novom prozoru
    .accesskey = n

main-context-menu-open-link-new-private-window =
    .label = Otvori poveznicu u novom privatnom prozoru
    .accesskey = p

main-context-menu-bookmark-this-link =
    .label = Zabilježi ovu poveznicu
    .accesskey = l

main-context-menu-save-link =
    .label = Spremi poveznicu kao …
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Spremi poveznicu u { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopiraj adresu e-pošte
    .accesskey = e

main-context-menu-copy-link =
    .label = Kopiraj lokaciju poveznice
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Pokreni
    .accesskey = P

main-context-menu-media-pause =
    .label = Pauziraj
    .accesskey = z

##

main-context-menu-media-mute =
    .label = Utišaj
    .accesskey = U

main-context-menu-media-unmute =
    .label = Odtišaj
    .accesskey = O

main-context-menu-media-play-speed =
    .label = Brzina reprodukcije
    .accesskey = r

main-context-menu-media-play-speed-slow =
    .label = Spora (0,5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Normalna
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Brza (1,25×)
    .accesskey = B

main-context-menu-media-play-speed-faster =
    .label = Brža (1,5×)
    .accesskey = r

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Suludo brza (2×)
    .accesskey = u

main-context-menu-media-loop =
    .label = Ponavljaj
    .accesskey = P

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Prikaži kontrole
    .accesskey = k

main-context-menu-media-hide-controls =
    .label = Sakrij kontrole
    .accesskey = k

##

main-context-menu-media-video-fullscreen =
    .label = Cjeloekranski prikaz
    .accesskey = o

main-context-menu-media-video-leave-fullscreen =
    .label = Izađi iz cjeloekranskog prikaza
    .accesskey = c

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Slika u slici
    .accesskey = u

main-context-menu-image-reload =
    .label = Ponovo učitaj sliku
    .accesskey = u

main-context-menu-image-view =
    .label = Pogledaj sliku
    .accesskey = i

main-context-menu-video-view =
    .label = Pogledaj video
    .accesskey = i

main-context-menu-image-copy =
    .label = Kopiraj sliku
    .accesskey = s

main-context-menu-image-copy-location =
    .label = Kopiraj lokaciju slike
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Kopiraj lokaciju videa
    .accesskey = v

main-context-menu-audio-copy-location =
    .label = Kopiraj lokaciju zvuka
    .accesskey = z

main-context-menu-image-save-as =
    .label = Spremi sliku kao …
    .accesskey = p

main-context-menu-image-email =
    .label = Pošalji sliku e-poštom…
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = Postavi kao pozadinu radne površine …
    .accesskey = s

main-context-menu-image-info =
    .label = Prikaži informacije o slici
    .accesskey = f

main-context-menu-image-desc =
    .label = Prikaži opis
    .accesskey = o

main-context-menu-video-save-as =
    .label = Spremi video kao …
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Spremi zvuk kao …
    .accesskey = z

main-context-menu-video-image-save-as =
    .label = Spremi snimku kao …
    .accesskey = S

main-context-menu-video-email =
    .label = Pošalji video e-poštom…
    .accesskey = a

main-context-menu-audio-email =
    .label = Pošalji zvuk e-poštom…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Aktiviraj ovaj priključak
    .accesskey = k

main-context-menu-plugin-hide =
    .label = Sakrij ovaj priključak
    .accesskey = S

main-context-menu-save-to-pocket =
    .label = Spremi stranicu u { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Pošalji stranicu na uređaj
    .accesskey = u

main-context-menu-view-background-image =
    .label = Pogledaj pozadinsku sliku
    .accesskey = P

main-context-menu-generate-new-password =
    .label = Koristi generiranu lozinku…
    .accesskey = g

main-context-menu-keyword =
    .label = Dodaj ključnu riječ za ovu pretragu …
    .accesskey = k

main-context-menu-link-send-to-device =
    .label = Pošalji poveznicu na uređaj
    .accesskey = u

main-context-menu-frame =
    .label = Ovaj okvir
    .accesskey = O

main-context-menu-frame-show-this =
    .label = Prikaži samo ovaj okvir
    .accesskey = s

main-context-menu-frame-open-tab =
    .label = Otvori okvir u novoj kartici
    .accesskey = t

main-context-menu-frame-open-window =
    .label = Otvori okvir u novom prozoru
    .accesskey = p

main-context-menu-frame-reload =
    .label = Ponovo učitaj okvir
    .accesskey = r

main-context-menu-frame-bookmark =
    .label = Zabilježi ovaj okvir
    .accesskey = o

main-context-menu-frame-save-as =
    .label = Spremi okvir kao …
    .accesskey = o

main-context-menu-frame-print =
    .label = Ispiši okvir…
    .accesskey = o

main-context-menu-frame-view-source =
    .label = Prikaži izvorni kod okvira
    .accesskey = v

main-context-menu-frame-view-info =
    .label = Prikaži informacije o okviru
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Prikaži izvorni kod odabranog
    .accesskey = e

main-context-menu-view-page-source =
    .label = Prikaži izvorni kod stranice
    .accesskey = v

main-context-menu-view-page-info =
    .label = Prikaži informacije o stranici
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Promijeni smjer teksta
    .accesskey = t

main-context-menu-bidi-switch-page =
    .label = Promijeni smjer stranice
    .accesskey = s

main-context-menu-inspect-element =
    .label = Ispitaj element
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Ispitaj svojstva pristupačnosti

main-context-menu-eme-learn-more =
    .label = Saznaj više o upravljanju digitalnim pravima …
    .accesskey = D

