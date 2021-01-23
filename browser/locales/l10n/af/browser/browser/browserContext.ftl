# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Trek af om geskiedenis te wys
           *[other] Klik regs of trek af om geskiedenis te wys
        }

## Back

main-context-menu-back =
    .tooltiptext = Gaan een bladsy terug
    .aria-label = Terug
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Gaan een bladsy vorentoe
    .aria-label = Vorentoe
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Herlaai
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stop
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Stoor bladsy as…
    .accesskey = b

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Boekmerk hierdie bladsy
    .accesskey = m
    .tooltiptext = Boekmerk hierdie bladsy

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Boekmerk hierdie bladsy
    .accesskey = m
    .tooltiptext = Boekmerk hierdie bladsy ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Redigeer hierdie boekmerk
    .accesskey = m
    .tooltiptext = Redigeer hierdie boekmerk

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Redigeer hierdie boekmerk
    .accesskey = m
    .tooltiptext = Redigeer hierdie boekmerk ({ $shortcut })

main-context-menu-open-link =
    .label = Open skakel
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Open skakel in nuwe oortjie
    .accesskey = o

main-context-menu-open-link-container-tab =
    .label = Open skakel in nuwe konteksoortjie
    .accesskey = t

main-context-menu-open-link-new-window =
    .label = Open skakel in nuwe venster
    .accesskey = v

main-context-menu-open-link-new-private-window =
    .label = Open skakel in nuwe private venster
    .accesskey = p

main-context-menu-bookmark-this-link =
    .label = Boekmerk hierdie skakel
    .accesskey = s

main-context-menu-save-link =
    .label = Stoor skakel as…
    .accesskey = e

main-context-menu-save-link-to-pocket =
    .label = Stoor skakel in { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopieer e-posadres
    .accesskey = e

main-context-menu-copy-link =
    .label = Kopieer skakelligging
    .accesskey = K

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Speel
    .accesskey = S

main-context-menu-media-pause =
    .label = Laat wag
    .accesskey = L

##

main-context-menu-media-mute =
    .label = Dower
    .accesskey = D

main-context-menu-media-unmute =
    .label = Ontdower
    .accesskey = d

main-context-menu-media-play-speed =
    .label = Speelspoed
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = Stadig (0,5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Normaal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Vinnig (1,25×)
    .accesskey = V

main-context-menu-media-play-speed-faster =
    .label = Vinniger (1,5×)
    .accesskey = n

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Blitsvinnig (2×)
    .accesskey = B

main-context-menu-media-loop =
    .label = Speel in lus
    .accesskey = l

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Wys kontroles
    .accesskey = W

main-context-menu-media-hide-controls =
    .label = Versteek kontroles
    .accesskey = V

##

main-context-menu-media-video-fullscreen =
    .label = Volskerm
    .accesskey = V

main-context-menu-media-video-leave-fullscreen =
    .label = Verlaat volskerm
    .accesskey = o

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Beeld-in-Beeld
    .accesskey = u

main-context-menu-image-reload =
    .label = Herlaai prent
    .accesskey = H

main-context-menu-image-view =
    .label = Bekyk prent
    .accesskey = p

main-context-menu-video-view =
    .label = Bekyk video
    .accesskey = i

main-context-menu-image-copy =
    .label = Kopieer prent
    .accesskey = K

main-context-menu-image-copy-location =
    .label = Kopieer prentligging
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Kopieer videoligging
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Kopieer klankligging
    .accesskey = o

main-context-menu-image-save-as =
    .label = Stoor prent as…
    .accesskey = o

main-context-menu-image-email =
    .label = E-pos prent…
    .accesskey = t

main-context-menu-image-set-as-background =
    .label = As werkskermagtergrond…
    .accesskey = A

main-context-menu-image-info =
    .label = Bekyk prentinfo
    .accesskey = f

main-context-menu-image-desc =
    .label = Bekyk beskrywing
    .accesskey = b

main-context-menu-video-save-as =
    .label = Stoor video as…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Stoor klank as…
    .accesskey = o

main-context-menu-video-image-save-as =
    .label = Stoor kiekie as…
    .accesskey = S

main-context-menu-video-email =
    .label = E-pos video…
    .accesskey = o

main-context-menu-audio-email =
    .label = E-pos klank…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Aktiveer dié inprop
    .accesskey = k

main-context-menu-plugin-hide =
    .label = Versteek dié inprop
    .accesskey = V

main-context-menu-save-to-pocket =
    .label = Stoor bladsy in { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Stuur bladsy na toestel
    .accesskey = r

main-context-menu-view-background-image =
    .label = Bekyk agtergrondprent
    .accesskey = k

main-context-menu-keyword =
    .label = Voeg 'n sleutelwoord vir dié soektog by…
    .accesskey = s

main-context-menu-link-send-to-device =
    .label = Stuur skakel na toestel
    .accesskey = r

main-context-menu-frame =
    .label = Hierdie raam
    .accesskey = i

main-context-menu-frame-show-this =
    .label = Vertoon net hierdie raam
    .accesskey = r

main-context-menu-frame-open-tab =
    .label = Open raam in nuwe oortjie
    .accesskey = o

main-context-menu-frame-open-window =
    .label = Open raam in nuwe venster
    .accesskey = v

main-context-menu-frame-reload =
    .label = Herlaai raam
    .accesskey = H

main-context-menu-frame-bookmark =
    .label = Boekmerk hierdie raam
    .accesskey = r

main-context-menu-frame-save-as =
    .label = Stoor raam as…
    .accesskey = r

main-context-menu-frame-print =
    .label = Druk raam…
    .accesskey = D

main-context-menu-frame-view-source =
    .label = Bekyk bron van raam
    .accesskey = B

main-context-menu-frame-view-info =
    .label = Bekyk raaminfo
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Bekyk bron van gemerkte deel
    .accesskey = e

main-context-menu-view-page-source =
    .label = Bekyk bron van bladsy
    .accesskey = B

main-context-menu-view-page-info =
    .label = Bekyk bladsyinfo
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Wissel teksrigting
    .accesskey = i

main-context-menu-bidi-switch-page =
    .label = Verwissel bladsyrigting
    .accesskey = r

main-context-menu-inspect-element =
    .label = Inspekteer element
    .accesskey = n

main-context-menu-inspect-a11y-properties =
    .label = Inspekteer toeganklikheidseienskappe

main-context-menu-eme-learn-more =
    .label = Meer inligting oor DRM…
    .accesskey = D

