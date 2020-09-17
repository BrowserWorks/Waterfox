# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Sit u zuɣer taɣeṛdayt d akessar akken ad twaliḍ azray
           *[other] Sit u zuɣeṛ taɣeṛdayt d akessar akken ad twaliḍ azray
        }

## Back

main-context-menu-back =
    .tooltiptext = Uɣal s yiwen n usebter
    .aria-label = Ɣer deffir
    .accesskey = D

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Aẓ ɣer zdat s yiwen usebter
    .aria-label = Ɣer zdat
    .accesskey = Z

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Smiren
    .accesskey = M

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Seḥbes
    .accesskey = Ḥ

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Sekles asebter di...
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Creḍ asebter-a
    .accesskey = c
    .tooltiptext = Creḍ asebter-a

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Creḍ asebter-a
    .accesskey = c
    .tooltiptext = Creḍ asebter-a ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Ẓreg tacreḍṭ n usebter-a
    .accesskey = c
    .tooltiptext = Ẓreg tacreḍṭ-a n usebter

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Ẓreg tacreḍṭ n usebter-a
    .accesskey = c
    .tooltiptext = Ẓreg tacreḍṭ-a n usebter ({ $shortcut })

main-context-menu-open-link =
    .label = Ldi aseɣwen
    .accesskey = L

main-context-menu-open-link-new-tab =
    .label = Ldi aseɣwen deg yiccer amaynut
    .accesskey = d

main-context-menu-open-link-container-tab =
    .label = Ldi aseɣwen deg yiccer amagbar amaynut
    .accesskey = L

main-context-menu-open-link-new-window =
    .label = Ldi aseɣwen deg usfaylu amaynut
    .accesskey = d

main-context-menu-open-link-new-private-window =
    .label = Ldi aseɣwen deg usfaylu uslig amaynut
    .accesskey = L

main-context-menu-bookmark-this-link =
    .label = Creḍ aseɣwen-a
    .accesskey = r

main-context-menu-save-link =
    .label = Sekles aseɣwen s yisem…
    .accesskey = S

main-context-menu-save-link-to-pocket =
    .label = Sekles aseɣwen ɣer { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Nɣel tansa imayl
    .accesskey = t

main-context-menu-copy-link =
    .label = Nɣel tansa n useɣwen
    .accesskey = N

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Urar
    .accesskey = U

main-context-menu-media-pause =
    .label = Asteɛfu
    .accesskey = A

##

main-context-menu-media-mute =
    .label = Tasusmi
    .accesskey = S

main-context-menu-media-unmute =
    .label = Kkes tasusmi
    .accesskey = m

main-context-menu-media-play-speed =
    .label = Arured n tɣuri
    .accesskey = r

main-context-menu-media-play-speed-slow =
    .label = S ttawil (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Amagnu
    .accesskey = m

main-context-menu-media-play-speed-fast =
    .label = S tɣawla (1.25×)
    .accesskey = z

main-context-menu-media-play-speed-faster =
    .label = Ittɣawal aṭas (1.5×)
    .accesskey = r

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Arured (×2)
    .accesskey = u

main-context-menu-media-loop =
    .label = Loop
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Sken isenqaden
    .accesskey = k

main-context-menu-media-hide-controls =
    .label = Ffer isenqaden
    .accesskey = F

##

main-context-menu-media-video-fullscreen =
    .label = Agdil ačaran
    .accesskey = A

main-context-menu-media-video-leave-fullscreen =
    .label = Ffeɣ seg uskar n ugdil ačuran
    .accesskey = F

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Tugna-deg-tugna
    .accesskey = u

main-context-menu-image-reload =
    .label = Smiren tugna
    .accesskey = S

main-context-menu-image-view =
    .label = Sken tugna
    .accesskey = k

main-context-menu-video-view =
    .label = Sken tavidyut
    .accesskey = m

main-context-menu-image-copy =
    .label = Nɣel tugna
    .accesskey = n

main-context-menu-image-copy-location =
    .label = Nɣel tansa n tugna
    .accesskey = N

main-context-menu-video-copy-location =
    .label = Nɣel tansa n tvidyut
    .accesskey = N

main-context-menu-audio-copy-location =
    .label = Nɣel tansa n umeslaw
    .accesskey = N

main-context-menu-image-save-as =
    .label = Sekles tugna s yisem…
    .accesskey = u

main-context-menu-image-email =
    .label = Azen tugna s yimayl…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = Fren tugna n ugilal...
    .accesskey = F

main-context-menu-image-info =
    .label = Talɣut ɣef tugna
    .accesskey = l

main-context-menu-image-desc =
    .label = Aglam n tugna
    .accesskey = t

main-context-menu-video-save-as =
    .label = Sekles tavidyut s yisem…
    .accesskey = l

main-context-menu-audio-save-as =
    .label = Sekles ameslaw s yisem…
    .accesskey = m

main-context-menu-video-image-save-as =
    .label = Sekles anɣel n ugdil s yisem…
    .accesskey = S

main-context-menu-video-email =
    .label = Azen tavidyut s yimayl…
    .accesskey = a

main-context-menu-audio-email =
    .label = Azen ameslaw s yimayl…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Rmed azegrir-a
    .accesskey = z

main-context-menu-plugin-hide =
    .label = Ffer Azegrir-a
    .accesskey = F

main-context-menu-save-to-pocket =
    .label = Sekles asebter ɣer { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Azen asebter ɣer yibenk
    .accesskey = b

main-context-menu-view-background-image =
    .label = Sken tugna n ugilal
    .accesskey = S

main-context-menu-generate-new-password =
    .label = Seqdec awal uffir yettwasirewen…
    .accesskey = S

main-context-menu-keyword =
    .label = Rnu awal tasarut i unadi-a…
    .accesskey = w

main-context-menu-link-send-to-device =
    .label = Azen aseɣwen ɣer yibenk
    .accesskey = b

main-context-menu-frame =
    .label = Akatar-a
    .accesskey = k

main-context-menu-frame-show-this =
    .label = Sken akatar-a kan
    .accesskey = k

main-context-menu-frame-open-tab =
    .label = Ldi akatar deg yiccer amaynut
    .accesskey = L

main-context-menu-frame-open-window =
    .label = Ldi akatar deg usfaylu amaynut
    .accesskey = L

main-context-menu-frame-reload =
    .label = Smiren akatar
    .accesskey = S

main-context-menu-frame-bookmark =
    .label = Creḍ akatar-a
    .accesskey = c

main-context-menu-frame-save-as =
    .label = Sekles akatar s yisem...
    .accesskey = S

main-context-menu-frame-print =
    .label = Siggez akatar...
    .accesskey = g

main-context-menu-frame-view-source =
    .label = Tangalt aɣbalu n ukatar
    .accesskey = g

main-context-menu-frame-view-info =
    .label = Wali talɣut n ukatar-a
    .accesskey = l

main-context-menu-view-selection-source =
    .label = Wali tangalt taɣbalut n tefrant
    .accesskey = e

main-context-menu-view-page-source =
    .label = Tangalt taɣbalut n usebter
    .accesskey = T

main-context-menu-view-page-info =
    .label = Wali talɣut n usebter
    .accesskey = l

main-context-menu-bidi-switch-text =
    .label = Beddel taɣda n uḍris
    .accesskey = n

main-context-menu-bidi-switch-page =
    .label = Beddel tanila n usebter
    .accesskey = n

main-context-menu-inspect-element =
    .label = Sweḍ aferdis
    .accesskey = S

main-context-menu-inspect-a11y-properties =
    .label = Sweḍ timeẓliyin n tnekcumt

main-context-menu-eme-learn-more =
    .label = Issin ugar ɣef DRM…
    .accesskey = D

