# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Wertu ngam hollude aslol
           *[other] Dobo ñaamo walla fooɗ ngam hollude aslol
        }

## Back

main-context-menu-back =
    .tooltiptext = Rutto hello wooto
    .aria-label = Rutto
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Yah yeeso hello wooto
    .aria-label = Yeeso
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Hesɗitin
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Dartin
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Danndu Hello e Innde…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Maantoro Ngoo Hello
    .accesskey = m
    .tooltiptext = Maantoro ngoo hello

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Maantoro Ngoo Hello
    .accesskey = m
    .tooltiptext = Maantoro ngoo hello ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Taƴto Ngol Maantorol
    .accesskey = m
    .tooltiptext = Taƴto ngol maantorol

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Taƴto Ngol Maantorol
    .accesskey = m
    .tooltiptext = Taƴto ngol maantorol ({ $shortcut })

main-context-menu-open-link =
    .label = Uddit Jokkol
    .accesskey = U

main-context-menu-open-link-new-tab =
    .label = Uddit Jokkol e Tabbere Hesere
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = Uddit Jokkol e Tabbere Mooftirde Hesere
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Uddit Jokkol e Henorde Hesere
    .accesskey = H

main-context-menu-open-link-new-private-window =
    .label = Uddit Jokkol e Henorde Suuriinde Hesere
    .accesskey = H

main-context-menu-bookmark-this-link =
    .label = Maantoro Ngol Jokkol
    .accesskey = J

main-context-menu-save-link =
    .label = Danndu Jokkol e Innde…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Danndu jokkol e { -pocket-brand-name }
    .accesskey = D

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Natto Ñiiɓirde Iimeel
    .accesskey = I

main-context-menu-copy-link =
    .label = Natto Nokkuure Jokkol
    .accesskey = u

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Tar
    .accesskey = T

main-context-menu-media-pause =
    .label = Sabbo
    .accesskey = S

##

main-context-menu-media-mute =
    .label = Muumɗin
    .accesskey = M

main-context-menu-media-unmute =
    .label = Ittu muumɗinal
    .accesskey = I

main-context-menu-media-play-speed =
    .label = Muumaa Taro
    .accesskey = u

main-context-menu-media-play-speed-slow =
    .label = Leewɗo (0.5×)
    .accesskey = L

main-context-menu-media-play-speed-normal =
    .label = Aadoraa
    .accesskey = A

main-context-menu-media-play-speed-fast =
    .label = Jaawɗo (1.25×)
    .accesskey = J

main-context-menu-media-play-speed-faster =
    .label = Ɓurɗo yaawde (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Kawjuɗo (2×)
    .accesskey = K

main-context-menu-media-loop =
    .label = Jirlol
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Hollir Ɗowirɗe
    .accesskey = Ɗ

main-context-menu-media-hide-controls =
    .label = Suuɗ Ɗowirɗe
    .accesskey = Ɗ

##

main-context-menu-media-video-fullscreen =
    .label = Njaajeendi Yaynirde
    .accesskey = N

main-context-menu-media-video-leave-fullscreen =
    .label = Yaltu Njaajeendi Yaynirde
    .accesskey = a

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Natal-nder-Natal
    .accesskey = u

main-context-menu-image-reload =
    .label = Loowtu Natal
    .accesskey = L

main-context-menu-image-view =
    .label = Hollu Natal
    .accesskey = N

main-context-menu-video-view =
    .label = Hollu Widewoo
    .accesskey = o

main-context-menu-image-copy =
    .label = Natto Natal
    .accesskey = o

main-context-menu-image-copy-location =
    .label = Natto Nokkuure Natal
    .accesskey = a

main-context-menu-video-copy-location =
    .label = Natto Nokkuure Widewoo
    .accesskey = a

main-context-menu-audio-copy-location =
    .label = Natto Nokkuure Ojoo
    .accesskey = a

main-context-menu-image-save-as =
    .label = Danndu Natal e innde…
    .accesskey = n

main-context-menu-image-email =
    .label = Neldu Natal e Iimeel…
    .accesskey = N

main-context-menu-image-set-as-background =
    .label = Waɗtu Ngal Cakkital Biro…
    .accesskey = W

main-context-menu-image-info =
    .label = Hollu Humpito Natal
    .accesskey = N

main-context-menu-image-desc =
    .label = Hiyto Cifol
    .accesskey = C

main-context-menu-video-save-as =
    .label = Danndu Widewoo e Innde…
    .accesskey = d

main-context-menu-audio-save-as =
    .label = Danndu Ojoo e Innde…
    .accesskey = O

main-context-menu-video-image-save-as =
    .label = Danndu Tummbitol e Innde…
    .accesskey = D

main-context-menu-video-email =
    .label = Neldu Widewoo e Iimeel…
    .accesskey = W

main-context-menu-audio-email =
    .label = Neldu Ojoo e Iimeel…
    .accesskey = o

main-context-menu-plugin-play =
    .label = Hurmin ndee seŋre
    .accesskey = r

main-context-menu-plugin-hide =
    .label = Suuɗ ndee seŋre
    .accesskey = S

main-context-menu-save-to-pocket =
    .label = Danndu hello e { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Neldu Hello to Kaɓirgol
    .accesskey = K

main-context-menu-view-background-image =
    .label = Hollu Natal Cakkital
    .accesskey = u

main-context-menu-generate-new-password =
    .label = Huutoro finnde yeñtinaande…
    .accesskey = G

main-context-menu-keyword =
    .label = Ɓeydi Helmere tesko e oo Njiilaw…
    .accesskey = H

main-context-menu-link-send-to-device =
    .label = Neldu Jokkol to Kaɓirgol
    .accesskey = K

main-context-menu-frame =
    .label = Ngol Kaarewol
    .accesskey = o

main-context-menu-frame-show-this =
    .label = Hollu Ngol Kaarewol Tan
    .accesskey = H

main-context-menu-frame-open-tab =
    .label = Uddit Kaarewol e Tabbere Hesere
    .accesskey = T

main-context-menu-frame-open-window =
    .label = Uddit Kaarewol e Henorde Hesere
    .accesskey = H

main-context-menu-frame-reload =
    .label = Loowtu Kaarewol
    .accesskey = L

main-context-menu-frame-bookmark =
    .label = Maantoro Ngol Kaarewol
    .accesskey = o

main-context-menu-frame-save-as =
    .label = Danndu Kaarewol e Innde…
    .accesskey = K

main-context-menu-frame-print =
    .label = Winndito Kaarewol…
    .accesskey = W

main-context-menu-frame-view-source =
    .label = Hollu Ɗaɗol Kaarewol
    .accesskey = H

main-context-menu-frame-view-info =
    .label = Hollu Humpito Kaarewol
    .accesskey = K

main-context-menu-view-selection-source =
    .label = Hollu Ɗaɗi Labannde
    .accesskey = e

main-context-menu-view-page-source =
    .label = Hollu Ɗaɗi Hello
    .accesskey = H

main-context-menu-view-page-info =
    .label = Hollu Humpito Hello
    .accesskey = H

main-context-menu-bidi-switch-text =
    .label = Waylu Tiindol Binndi
    .accesskey = a

main-context-menu-bidi-switch-page =
    .label = Waylu Tiindol Hello
    .accesskey = T

main-context-menu-inspect-element =
    .label = Ƴeewto Geɗel
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Yuurnito sifaaji keɓagol

main-context-menu-eme-learn-more =
    .label = Ɓeydu humpito baɗte DRM…
    .accesskey = D

