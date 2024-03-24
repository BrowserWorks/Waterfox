# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Trekk ned for å vise historikk
           *[other] Høgreklikk eller trekk ned for å vise historikk
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Gå tilbake ei side ({ $shortcut })
    .aria-label = Tilbake
    .accesskey = b
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Tilbake
    .accesskey = b
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Gå fram ei side ({ $shortcut })
    .aria-label = Fram
    .accesskey = F
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Fram
    .accesskey = F
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Oppdater
    .accesskey = r
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Oppdater
    .accesskey = r
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stopp
    .accesskey = S
# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Stopp
    .accesskey = S
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Lagre sida som…
    .accesskey = r

## Simple menu items

main-context-menu-bookmark-page =
    .aria-label = Bokmerk side…
    .accesskey = m
    .tooltiptext = Bokmerk side
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-edit-bookmark-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-page-mac =
    .label = Bokmerk side …
    .accesskey = m
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-page-mac,
# so should probably have the same access key if possible.
main-context-menu-edit-bookmark-mac =
    .label = Rediger bokmerke…
    .accesskey = m
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-page-with-shortcut =
    .aria-label = Bokmerk side…
    .accesskey = m
    .tooltiptext = Bokmerk side ({ $shortcut })
main-context-menu-edit-bookmark =
    .aria-label = Rediger bokmerke…
    .accesskey = m
    .tooltiptext = Rediger bokmerke
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-edit-bookmark-with-shortcut =
    .aria-label = Rediger bokmerke…
    .accesskey = m
    .tooltiptext = Rediger bokmerke ({ $shortcut })
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
main-context-menu-bookmark-link-2 =
    .label = Bokmerk lenke…
    .accesskey = B
main-context-menu-save-link =
    .label = Lagre lenke som…
    .accesskey = L
main-context-menu-save-link-to-pocket =
    .label = Lagre lenke til { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopier e-postadressa
    .accesskey = o
main-context-menu-copy-phone =
    .label = Kopier telefonnummer
    .accesskey = o
main-context-menu-copy-link-simple =
    .label = Kopier lenke
    .accesskey = l
# This command copies the link, removing additional
# query parameters used to track users across sites.
main-context-menu-strip-on-share-link =
    .label = Kopier lenke utan nettstadsporing
    .accesskey = o

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
main-context-menu-media-play-speed-2 =
    .label = Fart
    .accesskey = F
main-context-menu-media-play-speed-slow-2 =
    .label = 0,5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1,0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1,5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2,0×
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
main-context-menu-media-watch-pip =
    .label = Sjå med bilde-i-bilde
    .accesskey = S
main-context-menu-image-reload =
    .label = Oppdater bilde
    .accesskey = l
main-context-menu-image-view-new-tab =
    .label = Opne bilde i ny fane
    .accesskey = O
main-context-menu-video-view-new-tab =
    .label = Opne video i ny fane
    .accesskey = v
main-context-menu-image-copy =
    .label = Kopier bildet
    .accesskey = b
main-context-menu-image-copy-link =
    .label = Kopier bildelenke
    .accesskey = o
main-context-menu-video-copy-link =
    .label = Kopier videolenke
    .accesskey = o
main-context-menu-audio-copy-link =
    .label = Kopier lydlenke
    .accesskey = o
main-context-menu-image-save-as =
    .label = Lagre bildet som…
    .accesskey = b
main-context-menu-image-email =
    .label = Send bildet med e-post…
    .accesskey = i
main-context-menu-image-set-image-as-background =
    .label = Bruk bilde som skrivebordsbakgrunn…
    .accesskey = B
main-context-menu-image-copy-text =
    .label = Kopier tekst fra bilde
    .accesskey = t
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
main-context-menu-video-take-snapshot =
    .label = Ta augeblinksbilde
    .accesskey = a
main-context-menu-video-email =
    .label = Send videoen…
    .accesskey = n
main-context-menu-audio-email =
    .label = Send lydfila med e-post…
    .accesskey = n
main-context-menu-save-to-pocket =
    .label = Lagre sida til { -pocket-brand-name }
    .accesskey = k
main-context-menu-send-to-device =
    .label = Send sida til eining
    .accesskey = e

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Bruk lagra innlogging
    .accesskey = B
main-context-menu-use-saved-password =
    .label = Bruk lagra passord
    .accesskey = B

##

main-context-menu-use-relay-mask =
    .label = Bruk { -relay-brand-short-name } e-postalias
    .accesskey = B
main-context-menu-suggest-strong-password =
    .label = Foreslå sterkt passord…
    .accesskey = s
main-context-menu-manage-logins2 =
    .label = Handsam innloggingar…
    .accesskey = H
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
main-context-menu-frame-add-bookmark =
    .label = Bokmerk ramme…
    .accesskey = e
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
main-context-menu-print-selection-2 =
    .label = Skriv ut utval…
    .accesskey = r
main-context-menu-view-selection-source =
    .label = Vis kjeldekode for vald tekst
    .accesskey = k
main-context-menu-take-screenshot =
    .label = Ta skjermbilde
    .accesskey = T
main-context-menu-take-frame-screenshot =
    .label = Ta skjermbilde
    .accesskey = T
main-context-menu-view-page-source =
    .label = Vis kjeldekode
    .accesskey = k
main-context-menu-bidi-switch-text =
    .label = Byt tekstretning
    .accesskey = B
main-context-menu-bidi-switch-page =
    .label = Byt tekstretning på sida
    .accesskey = r
main-context-menu-inspect =
    .label = Undersøk
    .accesskey = U
main-context-menu-inspect-a11y-properties =
    .label = Inspiser tilgjengeinnstillingar
main-context-menu-eme-learn-more =
    .label = Les meir om DRM…
    .accesskey = D
# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = Opne lenke i ny { $containerName }-innhaldsfane
    .accesskey = p
main-context-menu-reveal-password =
    .label = Vis passord
    .accesskey = V
