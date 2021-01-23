# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Tel piny me nyuto gin mukato
           *[other] Dii tung lacuc nyo tel piny me nyuto gin mukato
        }

## Back

main-context-menu-back =
    .tooltiptext = Dok cen pot buk acel
    .aria-label = Cen
    .accesskey = C

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Cit anyim pot buk acel
    .aria-label = Anyim
    .accesskey = A

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Nwo cano
    .accesskey = N

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Juk
    .accesskey = J

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Gwok pot buk calo…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Ket alama buk i pot buk man
    .accesskey = k
    .tooltiptext = Ket alama buk i pot buk man

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Ket alama buk i pot buk man
    .accesskey = k
    .tooltiptext = Ket alama buk i pot buk man ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Yub alama buk man
    .accesskey = k
    .tooltiptext = Yub alama buk man

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Yub alama buk man
    .accesskey = k
    .tooltiptext = Yub alama buk man ({ $shortcut })

main-context-menu-open-link =
    .label = Yab Kakube
    .accesskey = Y

main-context-menu-open-link-new-tab =
    .label = Yab kakube i dirica matidi manyen
    .accesskey = d

main-context-menu-open-link-container-tab =
    .label = Yab kakube i dirica matidi manyen me mako jami
    .accesskey = a

main-context-menu-open-link-new-window =
    .label = Yab kakube i dirica manyen
    .accesskey = r

main-context-menu-open-link-new-private-window =
    .label = Yab kakube i dirica manyen me mung
    .accesskey = m

main-context-menu-bookmark-this-link =
    .label = Ket alama buk i kakube man
    .accesskey = k

main-context-menu-save-link =
    .label = Gwok kakube calo…
    .accesskey = e

main-context-menu-save-link-to-pocket =
    .label = Gwok Kakube i { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Lok kanonge me email
    .accesskey = k

main-context-menu-copy-link =
    .label = Lok kabedo me kakube
    .accesskey = e

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Tuki
    .accesskey = T

main-context-menu-media-pause =
    .label = Cung
    .accesskey = C

##

main-context-menu-media-mute =
    .label = Nek dwone
    .accesskey = N

main-context-menu-media-unmute =
    .label = Yab dwone
    .accesskey = d

main-context-menu-media-play-speed =
    .label = Dwiro me Tuko
    .accesskey = T

main-context-menu-media-play-speed-slow =
    .label = Mot (0.5×)
    .accesskey = M

main-context-menu-media-play-speed-fast =
    .label = Oyot (1.25×)
    .accesskey = O

main-context-menu-media-play-speed-faster =
    .label = Oyot adada (1.5×)
    .accesskey = O

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Dwiro ne dong gwa (2×)
    .accesskey = D

main-context-menu-media-loop =
    .label = Lworre
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Nyut kit me tic kwede
    .accesskey = k

main-context-menu-media-hide-controls =
    .label = Kan kit me tic kwede
    .accesskey = k

##

main-context-menu-media-video-fullscreen =
    .label = Wang komputa ma opong
    .accesskey = W

main-context-menu-media-video-leave-fullscreen =
    .label = Kat woko ki i wang komputa ma opong
    .accesskey = w

main-context-menu-image-reload =
    .label = Nwo cano cal
    .accesskey = N

main-context-menu-image-view =
    .label = Nen Cal
    .accesskey = C

main-context-menu-video-view =
    .label = Nen Vidio
    .accesskey = e

main-context-menu-image-copy =
    .label = Lok cal
    .accesskey = k

main-context-menu-image-copy-location =
    .label = Lok kabedo me cal
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Lok kabedo me vidio
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Lok kabedo me dwon
    .accesskey = o

main-context-menu-image-save-as =
    .label = Gwok cal calo…
    .accesskey = k

main-context-menu-image-email =
    .label = Cwal cal…
    .accesskey = l

main-context-menu-image-set-as-background =
    .label = Ket calo cal me nge wang kompiuta…
    .accesskey = K

main-context-menu-image-info =
    .label = Nen ngec me cal
    .accesskey = e

main-context-menu-image-desc =
    .label = Nen lok kome
    .accesskey = k

main-context-menu-video-save-as =
    .label = Gwok vidio calo…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Gwok dwon calo…
    .accesskey = o

main-context-menu-video-image-save-as =
    .label = Gwok cal calo…
    .accesskey = G

main-context-menu-video-email =
    .label = Cwal vidio…
    .accesskey = l

main-context-menu-audio-email =
    .label = Cwal dwon…
    .accesskey = l

main-context-menu-plugin-play =
    .label = Cak larwak man
    .accesskey = a

main-context-menu-plugin-hide =
    .label = Kan larwak man
    .accesskey = K

main-context-menu-save-to-pocket =
    .label = Gwok Potbuk i { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Cwal Potbuk i Nyonyo
    .accesskey = o

main-context-menu-view-background-image =
    .label = Nen cal me ngeye
    .accesskey = n

main-context-menu-keyword =
    .label = Med lok mapire tek pi yeny man…
    .accesskey = l

main-context-menu-link-send-to-device =
    .label = Cwal kakube i Nyonyo
    .accesskey = o

main-context-menu-frame =
    .label = Pem man
    .accesskey = a

main-context-menu-frame-show-this =
    .label = Nyut pem man keken
    .accesskey = N

main-context-menu-frame-open-tab =
    .label = Yab pem i dirica matidi manyen
    .accesskey = d

main-context-menu-frame-open-window =
    .label = Yab pem i dirica manyen
    .accesskey = d

main-context-menu-frame-reload =
    .label = Nwo cano pem
    .accesskey = N

main-context-menu-frame-bookmark =
    .label = Ket alama buk i pem man
    .accesskey = a

main-context-menu-frame-save-as =
    .label = Gwok pem calo…
    .accesskey = p

main-context-menu-frame-print =
    .label = Go pem…
    .accesskey = G

main-context-menu-frame-view-source =
    .label = Nen kama pem nonge iye
    .accesskey = N

main-context-menu-frame-view-info =
    .label = Nen ngec me pem
    .accesskey = n

main-context-menu-view-selection-source =
    .label = Nen yer me kama nonge iye
    .accesskey = e

main-context-menu-view-page-source =
    .label = Nen kama pot buk nonge iye
    .accesskey = N

main-context-menu-view-page-info =
    .label = Nen ngec me pot buk
    .accesskey = n

main-context-menu-bidi-switch-text =
    .label = Lok tung coc
    .accesskey = o

main-context-menu-bidi-switch-page =
    .label = Lok tung pot buk
    .accesskey = u

main-context-menu-inspect-element =
    .label = Ngiyo gin ma i but
    .accesskey = Q

main-context-menu-eme-learn-more =
    .label = Nong ngec mapol ikom DRM…
    .accesskey = D

