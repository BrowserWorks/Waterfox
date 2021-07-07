# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Klik og hold nede for at vise historik
           *[other] Højreklik eller klik og hold nede for at vise historik
        }

## Back

main-context-menu-back =
    .tooltiptext = Gå en side tilbage
    .aria-label = Tilbage
    .accesskey = T
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Gå en side tilbage ({ $shortcut })
    .aria-label = Tilbage
    .accesskey = T
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Tilbage
    .accesskey = T
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Gå en side fremad
    .aria-label = Fremad
    .accesskey = F
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Gå en side fremad ({ $shortcut })
    .aria-label = Fremad
    .accesskey = F
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Fremad
    .accesskey = F
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Genindlæs
    .accesskey = G
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Genindlæs
    .accesskey = G
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

## Firefox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Gem side som…
    .accesskey = m
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Bogmærk denne side
    .accesskey = m
    .tooltiptext = Bogmærk denne side
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Bogmærk side
    .accesskey = d
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Rediger bogmærke
    .accesskey = d
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Bogmærk denne side
    .accesskey = m
    .tooltiptext = Bogmærk denne side ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Rediger bogmærke
    .accesskey = m
    .tooltiptext = Rediger dette bogmærke
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Rediger bogmærke
    .accesskey = m
    .tooltiptext = Rediger dette bogmærke ({ $shortcut })
main-context-menu-open-link =
    .label = Åbn link
    .accesskey = Å
main-context-menu-open-link-new-tab =
    .label = Åbn link i nyt faneblad
    .accesskey = f
main-context-menu-open-link-container-tab =
    .label = Åbn link i nyt kontekst-faneblad
    .accesskey = k
main-context-menu-open-link-new-window =
    .label = Åbn link i nyt vindue
    .accesskey = v
main-context-menu-open-link-new-private-window =
    .label = Åbn link i nyt privat vindue
    .accesskey = p
main-context-menu-bookmark-this-link =
    .label = Bogmærk dette link
    .accesskey = B
main-context-menu-bookmark-link =
    .label = Gem bogmærke for linket
    .accesskey = b
main-context-menu-save-link =
    .label = Gem link som…
    .accesskey = G
main-context-menu-save-link-to-pocket =
    .label = Gem link til { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopier mailadresse
    .accesskey = K
main-context-menu-copy-link =
    .label = Kopier linkadresse
    .accesskey = K
main-context-menu-copy-link-simple =
    .label = Kopier link
    .accesskey = K

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Afspil
    .accesskey = A
main-context-menu-media-pause =
    .label = Pause
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Slå lyd fra
    .accesskey = S
main-context-menu-media-unmute =
    .label = Slå lyd til
    .accesskey = S
main-context-menu-media-play-speed =
    .label = Afspilningshastighed
    .accesskey = h
main-context-menu-media-play-speed-slow =
    .label = Langsom (0.5×)
    .accesskey = L
main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N
main-context-menu-media-play-speed-fast =
    .label = Hurtig (1.25×)
    .accesskey = H
main-context-menu-media-play-speed-faster =
    .label = Hurtigere (1.5×)
    .accesskey = e
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Latterlig (2×)
    .accesskey = t
main-context-menu-media-play-speed-2 =
    .label = Hastighed
    .accesskey = H
main-context-menu-media-play-speed-slow-2 =
    .label = 0,5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1,0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1,25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1,5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2,0×
main-context-menu-media-loop =
    .label = Gentag
    .accesskey = G

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Vis knapper
    .accesskey = n
main-context-menu-media-hide-controls =
    .label = Skjul knapper
    .accesskey = n

##

main-context-menu-media-video-fullscreen =
    .label = Fuld skærm
    .accesskey = F
main-context-menu-media-video-leave-fullscreen =
    .label = Afslut fuld skærm
    .accesskey = u
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Billede-i-billede
    .accesskey = e
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Se billede-i-billede
    .accesskey = e
main-context-menu-image-reload =
    .label = Genindlæs billede
    .accesskey = G
main-context-menu-image-view =
    .label = Vis billede
    .accesskey = V
main-context-menu-video-view =
    .label = Vis video
    .accesskey = V
main-context-menu-image-view-new-tab =
    .label = Åbn billede i nyt faneblad
    .accesskey = b
main-context-menu-video-view-new-tab =
    .label = Åbn video i nyt faneblad
    .accesskey = b
main-context-menu-image-copy =
    .label = Kopier billede
    .accesskey = o
main-context-menu-image-copy-location =
    .label = Kopier billedadresse
    .accesskey = K
main-context-menu-video-copy-location =
    .label = Kopier videoadresse
    .accesskey = K
main-context-menu-audio-copy-location =
    .label = Kopier lydadresse
    .accesskey = K
main-context-menu-image-copy-link =
    .label = Kopier link til billede
    .accesskey = K
main-context-menu-video-copy-link =
    .label = Kopier link til video
    .accesskey = K
main-context-menu-audio-copy-link =
    .label = Kopier link til lydklip
    .accesskey = K
main-context-menu-image-save-as =
    .label = Gem billede som…
    .accesskey = G
main-context-menu-image-email =
    .label = Send billede…
    .accesskey = S
main-context-menu-image-set-as-background =
    .label = Brug som skrivebordsbaggrund…
    .accesskey = B
main-context-menu-image-info =
    .label = Vis billededoplysninger
    .accesskey = i
main-context-menu-image-set-image-as-background =
    .label = Brug billede som skrivebordsbaggrund…
    .accesskey = b
main-context-menu-image-desc =
    .label = Vis beskrivelse
    .accesskey = b
main-context-menu-video-save-as =
    .label = Gem video som…
    .accesskey = G
main-context-menu-audio-save-as =
    .label = Gem lyd som…
    .accesskey = G
main-context-menu-video-image-save-as =
    .label = Gem snapshot som…
    .accesskey = S
main-context-menu-video-take-snapshot =
    .label = Tag snapshot…
    .accesskey = T
main-context-menu-video-email =
    .label = Send video…
    .accesskey = d
main-context-menu-audio-email =
    .label = Send lyd…
    .accesskey = S
main-context-menu-plugin-play =
    .label = Aktiver dette plugin
    .accesskey = A
main-context-menu-plugin-hide =
    .label = Skjul dette plugin
    .accesskey = p
main-context-menu-save-to-pocket =
    .label = Gem side til { -pocket-brand-name }
    .accesskey = o
main-context-menu-send-to-device =
    .label = Send side til enhed
    .accesskey = h
main-context-menu-view-background-image =
    .label = Vis baggrundsbillede
    .accesskey = V
main-context-menu-generate-new-password =
    .label = Brug genereret afgangskode…
    .accesskey = g

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Brug gemt login
    .accesskey = B
main-context-menu-use-saved-password =
    .label = Brug gemt adgangskode
    .accesskey = B

##

main-context-menu-suggest-strong-password =
    .label = Foreslå sikker adgangskode…
    .accesskey = r
main-context-menu-manage-logins =
    .label = Håndter logins…
    .accesskey = H
main-context-menu-manage-logins2 =
    .label = Håndter logins
    .accesskey = H
main-context-menu-keyword =
    .label = Tilføj en genvej til denne søgning…
    .accesskey = s
main-context-menu-link-send-to-device =
    .label = Send link til enhed
    .accesskey = h
main-context-menu-frame =
    .label = Denne ramme
    .accesskey = r
main-context-menu-frame-show-this =
    .label = Vis kun denne ramme
    .accesskey = d
main-context-menu-frame-open-tab =
    .label = Åbn ramme i nyt faneblad
    .accesskey = f
main-context-menu-frame-open-window =
    .label = Åbn ramme i nyt vindue
    .accesskey = v
main-context-menu-frame-reload =
    .label = Genindlæs ramme
    .accesskey = G
main-context-menu-frame-bookmark =
    .label = Bogmærk denne ramme
    .accesskey = B
main-context-menu-frame-save-as =
    .label = Gem ramme som…
    .accesskey = G
main-context-menu-frame-print =
    .label = Udskriv ramme…
    .accesskey = U
main-context-menu-frame-view-source =
    .label = Vis rammens kildekode
    .accesskey = k
main-context-menu-frame-view-info =
    .label = Vis rammeoplysninger
    .accesskey = o
main-context-menu-print-selection =
    .label = Udskriv markering
    .accesskey = U
main-context-menu-view-selection-source =
    .label = Vis markeringens kildekode
    .accesskey = V
main-context-menu-take-screenshot =
    .label = Tag skærmbillede
    .accesskey = T
main-context-menu-view-page-source =
    .label = Vis sidens kildekode
    .accesskey = k
main-context-menu-view-page-info =
    .label = Vis sideoplysninger
    .accesskey = o
main-context-menu-bidi-switch-text =
    .label = Skift tekstretning
    .accesskey = t
main-context-menu-bidi-switch-page =
    .label = Skift sideretning
    .accesskey = g
main-context-menu-inspect-element =
    .label = Inspicer element
    .accesskey = n
main-context-menu-inspect =
    .label = Inspicer
    .accesskey = n
main-context-menu-inspect-a11y-properties =
    .label = Inspicer tilgængeligheds-egenskaber
main-context-menu-eme-learn-more =
    .label = Læs mere om DRM…
    .accesskey = æ
