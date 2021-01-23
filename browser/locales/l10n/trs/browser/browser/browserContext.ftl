# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Ganukuo' da' gini'io' riña gaché nu'
           *[other] Ga'ui' klik ne' huo' nej duguche' ga'ān da' ni'io' riña gaché nut
        }

## Back

main-context-menu-back =
    .tooltiptext = Naniko' 'ngo pagina
    .aria-label = Ne' rukuu
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Gachin' a'ngo pagina
    .aria-label = Ne'ñaan
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Nàgi'iaj naka
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Duniikin'
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Na'nïnj sà' Pâjina Gù'na…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Sa raj sun nichrà' doj pagina na
    .accesskey = m
    .tooltiptext = Sa raj sun nichrà' doj pagina na

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Sa raj sun nichrà' doj pagina na
    .accesskey = m
    .tooltiptext = Sa raj sun nichrà' doj pagina na ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Nagi'io' sa arajsun nichrò' doj
    .accesskey = m
    .tooltiptext = Nagi'io' sa arajsun nichrò' doj

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Nagi'io' sa arajsun nichrò' doj
    .accesskey = m
    .tooltiptext = Nagi'io' sa arajsun nichrò' doj ({ $shortcut })

main-context-menu-open-link =
    .label = Na'nïn Link
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Ga'nïn' riña a'ngô rakïj ñaj nakàa
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = Na'nïn' riña a'ngô rakïj ñaj nakàa
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Ga'nïn' riña a'ngô rakïj ñaj nakàa
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = Ga'nïn' riña a'ngô rakïj ñaj huìi
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = Na'ni' enlace na riñ markador
    .accesskey = L

main-context-menu-save-link =
    .label = Na'ninj so' enlase...
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Na'nïnj sà' link riña { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Guxun' dirección korreo da' nachrun' a'ngô hiuj u
    .accesskey = E

main-context-menu-copy-link =
    .label = Guxun ña nù link da' nachrunt ané
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Duguchro'
    .accesskey = P

main-context-menu-media-pause =
    .label = Duyichin' akuan'
    .accesskey = D

##

main-context-menu-media-mute =
    .label = Dín gahuin
    .accesskey = M

main-context-menu-media-unmute =
    .label = Naduyingo´nanee
    .accesskey = m

main-context-menu-media-play-speed =
    .label = Daj hio gachra ma
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = Nà'naj (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Da'nga' gaj
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Hìo (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = Hìo doj (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Hìo ta'u (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = A'ngo ñu
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Gini'iaj nej kontrol
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = Gachri huì' kontrol
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = Nagi'iaj gachrò' riña aga' sikà' ràa
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = Nagi'iaj lij riña aga' sikà' ràa
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Picture-in-Picture
    .accesskey = u

main-context-menu-image-reload =
    .label = Nagi'aj da'nga'a
    .accesskey = R

main-context-menu-image-view =
    .label = Ni'iaj ñadu'ua
    .accesskey = I

main-context-menu-video-view =
    .label = Ni'io' bideo
    .accesskey = I

main-context-menu-image-copy =
    .label = Guxun ña du'ua ma
    .accesskey = y

main-context-menu-image-copy-location =
    .label = Nana'uì' ñan du'ua
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Guxun ña nù si link video na
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Guxun ña nù si link nanè na
    .accesskey = o

main-context-menu-image-save-as =
    .label = Na'nïnj sà' ña du'ua Gù'na…
    .accesskey = v

main-context-menu-image-email =
    .label = Ga'ni' ña du'ua...
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = Gagrun' ma riña pantayâ si ago'...
    .accesskey = S

main-context-menu-image-info =
    .label = Ni'io' si nuguan' ñadu'ua
    .accesskey = f

main-context-menu-image-desc =
    .label = Ni'io' nuhuin si taj ma
    .accesskey = D

main-context-menu-video-save-as =
    .label = Na'ninj sa' sa siki'...
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Na'ninj sa' nanèe 'ngà...
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = Na'nïnj so' ña du'ua pantayâ 'ngà...
    .accesskey = S

main-context-menu-video-email =
    .label = Ga'ni' video...
    .accesskey = a

main-context-menu-audio-email =
    .label = Ga'ni' nanèe 'ngà korreo…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Dugi'iaj sun' plugin na
    .accesskey = c

main-context-menu-plugin-hide =
    .label = Gachri huì' plugin
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = Nannj sà' pâjina riña { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Ga'nïnj pâgina gan'anj aga'
    .accesskey = a

main-context-menu-view-background-image =
    .label = Ni'io' ñadu'ua Fôndo
    .accesskey = w

main-context-menu-keyword =
    .label = Gachun' 'ngo nugua' yitïnj guenda sa nana'ui' na...
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = Ga'nïnj enlâse riña Aga'
    .accesskey = A

main-context-menu-frame =
    .label = Marko na
    .accesskey = h

main-context-menu-frame-show-this =
    .label = Ma ñuna nadigun'
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = Na'nïn' riña a'ngô rakïj ñaj nakàa
    .accesskey = T

main-context-menu-frame-open-window =
    .label = Ga'nïn' riña a'ngô rakïj ñaj nakàa
    .accesskey = W

main-context-menu-frame-reload =
    .label = Nachra ñu marko
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Sa raj sun nichrà' doj pagina na
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Na'nïnj sà' Pâjina Gù'na…
    .accesskey = F

main-context-menu-frame-print =
    .label = Nari ñadu'ua mârko
    .accesskey = P

main-context-menu-frame-view-source =
    .label = Ni'io' si kodigo fuente marko na
    .accesskey = V

main-context-menu-frame-view-info =
    .label = Ni'io' si nuguan' ma
    .accesskey = I

main-context-menu-view-selection-source =
    .label = Ni'io' si kodigo fuente ma
    .accesskey = e

main-context-menu-view-page-source =
    .label = Gini'iaj Da'nga' Ñaan
    .accesskey = V

main-context-menu-view-page-info =
    .label = Ni'io' si nuguan' pagina
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Naduno' daj ginū dukuán na
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = Naduno' daj ginū pagina na
    .accesskey = D

main-context-menu-inspect-element =
    .label = Natsi' elemento
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Natsi' nej sa a'nïn gatu'

main-context-menu-eme-learn-more =
    .label = Gahuin chrūn doj rayi'ì DRM…
    .accesskey = D

