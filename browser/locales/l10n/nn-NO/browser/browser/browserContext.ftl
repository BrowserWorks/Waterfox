# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Trekk ned for å vise historikk
           *[other] Høgreklikk eller trekk ned for å vise historikk
        }

## Back

main-context-menu-back =
    .tooltiptext = Gå tilbake ei side
    .aria-label = Tilbake
    .accesskey = b

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Gå fram ei side
    .aria-label = Fram
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Oppdater
    .accesskey = r

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stopp
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Lagre sida som…
    .accesskey = r

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Bokmerk denne sida
    .accesskey = m
    .tooltiptext = Bokmerk denne sida

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Bokmerk denne sida
    .accesskey = m
    .tooltiptext = Bokmerk denne sida ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Rediger dette bokmerket
    .accesskey = m
    .tooltiptext = Rediger dette bokmerket

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Rediger dette bokmerket
    .accesskey = m
    .tooltiptext = Rediger dette bokmerket ({ $shortcut })

main-context-menu-open-link =
    .label = Opne lenke
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Opne lenke i ny fane
    .accesskey = n

main-context-menu-open-link-container-tab =
    .label = Opne lenke i ny innhaldsfane
    .accesskey = a

main-context-menu-open-link-new-window =
    .label = Opne lenke i nytt vindauge
    .accesskey = O

main-context-menu-open-link-new-private-window =
    .label = Opne lenke i nytt privat vindauge
    .accesskey = p

main-context-menu-bookmark-this-link =
    .label = Bokmerk denne lenka
    .accesskey = B

main-context-menu-save-link =
    .label = Lagre lenke som…
    .accesskey = L

main-context-menu-save-link-to-pocket =
    .label = Lagre lenke til { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopier e-postadressa
    .accesskey = o

main-context-menu-copy-link =
    .label = Kopier lenkeadresse
    .accesskey = K

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Spel av
    .accesskey = a

main-context-menu-media-pause =
    .label = Pause
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Slå av lyd
    .accesskey = S

main-context-menu-media-unmute =
    .label = Slå på lyd
    .accesskey = S

main-context-menu-media-play-speed =
    .label = Avspelingsfart
    .accesskey = A

main-context-menu-media-play-speed-slow =
    .label = Sakte (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Fort (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = Fortare (1.5×)
    .accesskey = o

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Latterleg høg (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = Repeter
    .accesskey = R

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Vis kontrollar
    .accesskey = V

main-context-menu-media-hide-controls =
    .label = Gøym kontrollar
    .accesskey = ø

##

main-context-menu-media-video-fullscreen =
    .label = Fullskjerm
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = Avslutt fullskjerm
    .accesskey = v

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Bilde-i-bilde
    .accesskey = B

main-context-menu-image-reload =
    .label = Oppdater bilde
    .accesskey = l

main-context-menu-image-view =
    .label = Vis bildet
    .accesskey = V

main-context-menu-video-view =
    .label = Vis video
    .accesskey = s

main-context-menu-image-copy =
    .label = Kopier bildet
    .accesskey = b

main-context-menu-image-copy-location =
    .label = Kopier bildeadressa
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Kopier videoadressa
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Kopier lydadressa
    .accesskey = o

main-context-menu-image-save-as =
    .label = Lagre bildet som…
    .accesskey = b

main-context-menu-image-email =
    .label = Send bildet med e-post…
    .accesskey = i

main-context-menu-image-set-as-background =
    .label = Bruk som skrivebordbakgrunn…
    .accesskey = m

main-context-menu-image-info =
    .label = Vis bildeinfo
    .accesskey = b

main-context-menu-image-desc =
    .label = Vis skildring
    .accesskey = k

main-context-menu-video-save-as =
    .label = Lagre videoen som…
    .accesskey = a

main-context-menu-audio-save-as =
    .label = Lagre lyden som…
    .accesskey = a

main-context-menu-video-image-save-as =
    .label = Lagre snapshot som…
    .accesskey = L

main-context-menu-video-email =
    .label = Send videoen…
    .accesskey = n

main-context-menu-audio-email =
    .label = Send lydfila med e-post…
    .accesskey = n

main-context-menu-plugin-play =
    .label = Slå på dette programtillegget
    .accesskey = a

main-context-menu-plugin-hide =
    .label = Gøym dette programtillegget
    .accesskey = G

main-context-menu-save-to-pocket =
    .label = Lagre sida til { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Send sida til eining
    .accesskey = e

main-context-menu-view-background-image =
    .label = Vis bakgrunnsbildet
    .accesskey = b

main-context-menu-generate-new-password =
    .label = Bruk eit generert passord…
    .accesskey = B

main-context-menu-keyword =
    .label = Lag nøkkelord for dette søket…
    .accesskey = L

main-context-menu-link-send-to-device =
    .label = Send lenke til eining
    .accesskey = e

main-context-menu-frame =
    .label = Denne ramma
    .accesskey = D

main-context-menu-frame-show-this =
    .label = Vis berre denne ramma
    .accesskey = b

main-context-menu-frame-open-tab =
    .label = Opne ramme i ny fane
    .accesskey = r

main-context-menu-frame-open-window =
    .label = Opne ramme i nytt vindauge
    .accesskey = v

main-context-menu-frame-reload =
    .label = Oppdater ramme
    .accesskey = O

main-context-menu-frame-bookmark =
    .label = Bokmerk denne ramma
    .accesskey = B

main-context-menu-frame-save-as =
    .label = Lagre ramma som…
    .accesskey = a

main-context-menu-frame-print =
    .label = Skriv ut ramma…
    .accesskey = k

main-context-menu-frame-view-source =
    .label = Vis kjeldekode for ramma
    .accesskey = k

main-context-menu-frame-view-info =
    .label = Vis rammeinfo
    .accesskey = V

main-context-menu-view-selection-source =
    .label = Vis kjeldekode for vald tekst
    .accesskey = k

main-context-menu-view-page-source =
    .label = Vis kjeldekode
    .accesskey = k

main-context-menu-view-page-info =
    .label = Vis sideinfo
    .accesskey = V

main-context-menu-bidi-switch-text =
    .label = Byt tekstretning
    .accesskey = B

main-context-menu-bidi-switch-page =
    .label = Byt tekstretning på sida
    .accesskey = r

main-context-menu-inspect-element =
    .label = Inspiser element
    .accesskey = I

main-context-menu-inspect-a11y-properties =
    .label = Inspiser tilgjengeinnstillingar

main-context-menu-eme-learn-more =
    .label = Les meir om DRM…
    .accesskey = D

