# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Vedä alaspäin nähdäksesi sivuhistorian
           *[other] Napsauta hiiren toisella painikkeella tai vedä alaspäin nähdäksesi sivuhistorian
        }

## Back

main-context-menu-back =
    .tooltiptext = Siirry sivu taaksepäin
    .aria-label = Edellinen
    .accesskey = E

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Siirry sivu eteenpäin
    .aria-label = Seuraava
    .accesskey = e

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Päivitä
    .accesskey = P

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Pysäytä
    .accesskey = P

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Tallenna sivu nimellä…
    .accesskey = s

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Lisää sivu kirjanmerkkeihin
    .accesskey = k
    .tooltiptext = Lisää kirjanmerkki

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Lisää sivu kirjanmerkkeihin
    .accesskey = k
    .tooltiptext = Lisää kirjanmerkki ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Muokkaa kirjanmerkkiä
    .accesskey = k
    .tooltiptext = Muokkaa kirjanmerkkiä

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Muokkaa kirjanmerkkiä
    .accesskey = k
    .tooltiptext = Muokkaa kirjanmerkkiä ({ $shortcut })

main-context-menu-open-link =
    .label = Avaa
    .accesskey = A

main-context-menu-open-link-new-tab =
    .label = Avaa uuteen välilehteen
    .accesskey = v

main-context-menu-open-link-container-tab =
    .label = Avaa uuteen eristettyyn välilehteen
    .accesskey = u

main-context-menu-open-link-new-window =
    .label = Avaa uuteen ikkunaan
    .accesskey = i

main-context-menu-open-link-new-private-window =
    .label = Avaa uuteen yksityiseen ikkunaan
    .accesskey = y

main-context-menu-bookmark-this-link =
    .label = Lisää kohde kirjanmerkkeihin
    .accesskey = A

main-context-menu-save-link =
    .label = Tallenna kohde levylle…
    .accesskey = T

main-context-menu-save-link-to-pocket =
    .label = Tallenna linkki { -pocket-brand-name }-palveluun
    .accesskey = k

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopioi sähköpostiosoite
    .accesskey = s

main-context-menu-copy-link =
    .label = Kopioi linkin osoite
    .accesskey = K

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Toista
    .accesskey = o

main-context-menu-media-pause =
    .label = Pysäytä
    .accesskey = y

##

main-context-menu-media-mute =
    .label = Mykistä ääni
    .accesskey = M

main-context-menu-media-unmute =
    .label = Palauta ääni
    .accesskey = ä

main-context-menu-media-play-speed =
    .label = Toistonopeus
    .accesskey = u

main-context-menu-media-play-speed-slow =
    .label = Hidas (0,5×)
    .accesskey = H

main-context-menu-media-play-speed-normal =
    .label = Normaali
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Nopea (1,25×)
    .accesskey = o

main-context-menu-media-play-speed-faster =
    .label = Nopeampi (1,5×)
    .accesskey = p

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Älytön (2×)
    .accesskey = Ä

main-context-menu-media-loop =
    .label = Jatkuva toisto
    .accesskey = J

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Näytä säätimet
    .accesskey = s

main-context-menu-media-hide-controls =
    .label = Piilota säätimet
    .accesskey = s

##

main-context-menu-media-video-fullscreen =
    .label = Kokoruutu
    .accesskey = K

main-context-menu-media-video-leave-fullscreen =
    .label = Poistu kokoruututilasta
    .accesskey = P

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Kuva kuvassa
    .accesskey = K

main-context-menu-image-reload =
    .label = Lataa kuva
    .accesskey = L

main-context-menu-image-view =
    .label = Näytä kuva
    .accesskey = N

main-context-menu-video-view =
    .label = Näytä video
    .accesskey = N

main-context-menu-image-copy =
    .label = Kopioi kuva
    .accesskey = u

main-context-menu-image-copy-location =
    .label = Kopioi kuvan osoite
    .accesskey = p

main-context-menu-video-copy-location =
    .label = Kopioi videon osoite
    .accesskey = p

main-context-menu-audio-copy-location =
    .label = Kopioi äänitteen sijainti
    .accesskey = p

main-context-menu-image-save-as =
    .label = Tallenna kuva nimellä…
    .accesskey = e

main-context-menu-image-email =
    .label = Lähetä kuva…
    .accesskey = L

main-context-menu-image-set-as-background =
    .label = Aseta työpöydän taustakuvaksi…
    .accesskey = A

main-context-menu-image-info =
    .label = Näytä kuvan tiedot
    .accesskey = d

main-context-menu-image-desc =
    .label = Näytä kuvaus
    .accesskey = u

main-context-menu-video-save-as =
    .label = Tallenna video nimellä…
    .accesskey = e

main-context-menu-audio-save-as =
    .label = Tallenna äänite nimellä…
    .accesskey = e

main-context-menu-video-image-save-as =
    .label = Tallenna ruutukaappaus nimellä…
    .accesskey = T

main-context-menu-video-email =
    .label = Lähetä video…
    .accesskey = L

main-context-menu-audio-email =
    .label = Lähetä äänite…
    .accesskey = L

main-context-menu-plugin-play =
    .label = Käynnistä liitännäinen
    .accesskey = K

main-context-menu-plugin-hide =
    .label = Piilota liitännäinen
    .accesskey = o

main-context-menu-save-to-pocket =
    .label = Tallenna sivu { -pocket-brand-name }-palveluun
    .accesskey = c

main-context-menu-send-to-device =
    .label = Lähetä sivu laitteeseen
    .accesskey = L

main-context-menu-view-background-image =
    .label = Näytä taustakuva
    .accesskey = a

main-context-menu-generate-new-password =
    .label = Käytä luotua salasanaa…
    .accesskey = K

main-context-menu-keyword =
    .label = Lisää pikakomento tälle haulle…
    .accesskey = L

main-context-menu-link-send-to-device =
    .label = Lähetä linkki laitteeseen
    .accesskey = L

main-context-menu-frame =
    .label = Tämä kehys
    .accesskey = ä

main-context-menu-frame-show-this =
    .label = Näytä vain tämä kehys
    .accesskey = N

main-context-menu-frame-open-tab =
    .label = Avaa kehys uuteen välilehteen
    .accesskey = v

main-context-menu-frame-open-window =
    .label = Avaa kehys uuteen ikkunaan
    .accesskey = A

main-context-menu-frame-reload =
    .label = Päivitä kehys
    .accesskey = ä

main-context-menu-frame-bookmark =
    .label = Lisää kehyssivu kirjanmerkkeihin
    .accesskey = A

main-context-menu-frame-save-as =
    .label = Tallenna kehys nimellä…
    .accesskey = T

main-context-menu-frame-print =
    .label = Tulosta kehys…
    .accesskey = u

main-context-menu-frame-view-source =
    .label = Näytä kehyksen lähdekoodi
    .accesskey = ä

main-context-menu-frame-view-info =
    .label = Näytä kehyksen tiedot
    .accesskey = o

main-context-menu-view-selection-source =
    .label = Näytä valinnan lähdekoodi
    .accesskey = n

main-context-menu-view-page-source =
    .label = Näytä sivun lähdekoodi
    .accesskey = k

main-context-menu-view-page-info =
    .label = Näytä sivun tiedot
    .accesskey = o

main-context-menu-bidi-switch-text =
    .label = Vaihda tekstin suuntaa
    .accesskey = a

main-context-menu-bidi-switch-page =
    .label = Vaihda sivun suuntaa
    .accesskey = V

main-context-menu-inspect-element =
    .label = Inspect Element
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Inspect Accessibility Properties

main-context-menu-eme-learn-more =
    .label = Lue lisää DRM-suojauksesta…
    .accesskey = D

