# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Tiru malsupren por montri la historion
           *[other] Alklaku per la dekstra butono aŭ tiru malsupren por montri la historion
        }

## Back

main-context-menu-back =
    .tooltiptext = Unu paĝo malantaŭen
    .aria-label = Malantaŭen
    .accesskey = M

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Unu paĝo antaŭen
    .aria-label = Antaŭen
    .accesskey = A

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Reŝargi
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Halti
    .accesskey = H

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Konservi paĝon kiel…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Aldoni legosignon por tiu ĉi paĝo
    .accesskey = l
    .tooltiptext = Aldoni legosignon por tiu ĉi paĝo

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Aldoni legosignon por tiu ĉi paĝo
    .accesskey = l
    .tooltiptext = Aldoni legosignon por tiu ĉi paĝo ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Redakti tiun ĉi legosignon
    .accesskey = l
    .tooltiptext = Redakti tiun ĉi legosignon

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Redakti tiun ĉi legosignon
    .accesskey = l
    .tooltiptext = Redakti tiun ĉi legosignon ({ $shortcut })

main-context-menu-open-link =
    .label = Malfermi ligilon
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Malfermi ligilon en nova langeto
    .accesskey = l

main-context-menu-open-link-container-tab =
    .label = Malfermi ligilon en nova inga langeto
    .accesskey = e

main-context-menu-open-link-new-window =
    .label = Malfermi ligilon en nova fenestro
    .accesskey = F

main-context-menu-open-link-new-private-window =
    .label = Malfermi ligilon en nova privata fenestro
    .accesskey = p

main-context-menu-bookmark-this-link =
    .label = Aldoni legosignon por tiu ĉi ligilo
    .accesskey = l

main-context-menu-save-link =
    .label = Konservi ligitan dosieron kiel…
    .accesskey = K

main-context-menu-save-link-to-pocket =
    .label = Konservi ligilon en { -pocket-brand-name }
    .accesskey = l

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopii retpoŝtan adreson
    .accesskey = a

main-context-menu-copy-link =
    .label = Kopii adreson de ligilo
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Ludi
    .accesskey = L

main-context-menu-media-pause =
    .label = Paŭzigi
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Silentigi
    .accesskey = S

main-context-menu-media-unmute =
    .label = Malsilentigi
    .accesskey = M

main-context-menu-media-play-speed =
    .label = Ludrapido
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = Malrapide (0.5×)
    .accesskey = M

main-context-menu-media-play-speed-normal =
    .label = Normale
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Rapide (1.25×)
    .accesskey = R

main-context-menu-media-play-speed-faster =
    .label = Pli rapide (1.5×)
    .accesskey = P

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Rapidege (2×)
    .accesskey = g

main-context-menu-media-loop =
    .label = Ripeti
    .accesskey = R

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Montri regilojn
    .accesskey = M

main-context-menu-media-hide-controls =
    .label = Kaŝi regilojn
    .accesskey = K

##

main-context-menu-media-video-fullscreen =
    .label = Plenekrane
    .accesskey = P

main-context-menu-media-video-leave-fullscreen =
    .label = Eliri el plenekrana reĝimo
    .accesskey = e

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Bildo en bildo
    .accesskey = b

main-context-menu-image-reload =
    .label = Reŝargi bildon
    .accesskey = R

main-context-menu-image-view =
    .label = Vidi bildon
    .accesskey = b

main-context-menu-video-view =
    .label = Spekti videon
    .accesskey = v

main-context-menu-image-copy =
    .label = Kopii bildon
    .accesskey = b

main-context-menu-image-copy-location =
    .label = Kopii adreson de bildo
    .accesskey = a

main-context-menu-video-copy-location =
    .label = Kopii adreson de filmeto
    .accesskey = a

main-context-menu-audio-copy-location =
    .label = Kopii adreson de sono
    .accesskey = a

main-context-menu-image-save-as =
    .label = Konservi bildon kiel…
    .accesskey = K

main-context-menu-image-email =
    .label = Sendi bildon retpoŝte…
    .accesskey = b

main-context-menu-image-set-as-background =
    .label = Difini kiel labortablan fonan bildon…
    .accesskey = D

main-context-menu-image-info =
    .label = Vidi bildan informon
    .accesskey = i

main-context-menu-image-desc =
    .label = Vidi priskribon
    .accesskey = p

main-context-menu-video-save-as =
    .label = Konservi videon kiel…
    .accesskey = K

main-context-menu-audio-save-as =
    .label = Konservi sonon kiel…
    .accesskey = K

main-context-menu-video-image-save-as =
    .label = Konservi filmetan bildon kiel…
    .accesskey = K

main-context-menu-video-email =
    .label = Sendi filmeton retpoŝte…
    .accesskey = S

main-context-menu-audio-email =
    .label = Sendi sonon retpoŝte…
    .accesskey = S

main-context-menu-plugin-play =
    .label = Aktivigi tiun ĉi kromprogramon
    .accesskey = A

main-context-menu-plugin-hide =
    .label = Kaŝi tiun ĉi kromprogramon
    .accesskey = K

main-context-menu-save-to-pocket =
    .label = Konservi paĝon en { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Sendi paĝon al aparato
    .accesskey = a

main-context-menu-view-background-image =
    .label = Vidi fonan bildon
    .accesskey = b

main-context-menu-generate-new-password =
    .label = Uzi aŭtomate kreitan pasvorton…
    .accesskey = U

main-context-menu-keyword =
    .label = Aldoni kategorian vorton por tiu ĉi serĉado…
    .accesskey = v

main-context-menu-link-send-to-device =
    .label = Sendi ligilon al aparato
    .accesskey = a

main-context-menu-frame =
    .label = Tiu ĉi kadro
    .accesskey = i

main-context-menu-frame-show-this =
    .label = Montri nur tiun ĉi kadron
    .accesskey = T

main-context-menu-frame-open-tab =
    .label = Malfermi kadron en nova langeto
    .accesskey = l

main-context-menu-frame-open-window =
    .label = Malfermi kadron en nova fenestro
    .accesskey = F

main-context-menu-frame-reload =
    .label = Reŝargi kadron
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Aldoni legosignon por tiu ĉi kadro
    .accesskey = l

main-context-menu-frame-save-as =
    .label = Konservi kadron kiel…
    .accesskey = K

main-context-menu-frame-print =
    .label = Presi kadron…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = Vidi fonton de kadro
    .accesskey = f

main-context-menu-frame-view-info =
    .label = Vidi informon de kadro
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Vidi fonton de selekto
    .accesskey = e

main-context-menu-view-page-source =
    .label = Vidi fonton de paĝo
    .accesskey = f

main-context-menu-view-page-info =
    .label = Vidi informon de paĝo
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Ŝanĝi tekstodirekton
    .accesskey = a

main-context-menu-bidi-switch-page =
    .label = Ŝanĝi paĝodirekton
    .accesskey = D

main-context-menu-inspect-element =
    .label = Inspekti elementon
    .accesskey = n

main-context-menu-inspect-a11y-properties =
    .label = Inspekti alireblecajn atributojn

main-context-menu-eme-learn-more =
    .label = Pli da informo pri DRM…
    .accesskey = i

