# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Taqirirej richin niq'alajin pe ri natab'äl
           *[other] Tapitz'a' ruka'n ruwi' ri ch'oy, taqirirej pa xulan richin natz'ët ri natab'äl
        }

## Back

main-context-menu-back =
    .tooltiptext = Titzolïx jun ruxaq
    .aria-label = Chi rij
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Jun chik ruxaq
    .aria-label = Jun chik
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Tisamajïx chik
    .accesskey = s

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Tiq'at
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Tiyak Ruxaq Achi'el…
    .accesskey = R

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Titz'aqatisäx re ruxaq re' pa taq yaketal
    .accesskey = m
    .tooltiptext = Titz'aqatisäx re ruxaq k'amaya'l re' pa taq yaketal

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Titz'aqatisäx re ruxaq re' pa taq yaketal
    .accesskey = m
    .tooltiptext = Titz'aqatisäx re ruxaq k'amaya'l re' pa taq yaketal ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Tinuk' re yaketal re'
    .accesskey = m
    .tooltiptext = Tinuk' re jun yaketal re'

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Tinuk' re yaketal re'
    .accesskey = m
    .tooltiptext = Tinuk' re jun yaketal ({ $shortcut }) re'

main-context-menu-open-link =
    .label = Tijaq ximon tzij
    .accesskey = T

main-context-menu-open-link-new-tab =
    .label = Tijaq Ximonel pa K'ak'a' Ruwi'
    .accesskey = R

main-context-menu-open-link-container-tab =
    .label = Tijaq ximonel pa k'ak'a' ajk'wayöl ruwi'
    .accesskey = w

main-context-menu-open-link-new-window =
    .label = Tijaq ximonel tzij pa jun k'ak'a' Tzuwäch
    .accesskey = T

main-context-menu-open-link-new-private-window =
    .label = Tijaq ximon tzij pa jun k'ak'a' ichinan kajtz'ïk
    .accesskey = i

main-context-menu-bookmark-this-link =
    .label = Titzaqatisäx re jun ximonel re' pa taq yaketal
    .accesskey = x

main-context-menu-save-link =
    .label = Tiyak Ximonel Achi'el…
    .accesskey = o

main-context-menu-save-link-to-pocket =
    .label = Tiyak Ximonel pa { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Tiwachib'ëx rochochib'al taqoya'l
    .accesskey = t

main-context-menu-copy-link =
    .label = Tiwachib'ëx Ruk'ojlib'al Ximonel
    .accesskey = i

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Titzij
    .accesskey = T

main-context-menu-media-pause =
    .label = Rupab'axik
    .accesskey = R

##

main-context-menu-media-mute =
    .label = Timemür
    .accesskey = T

main-context-menu-media-unmute =
    .label = Tak'axäx
    .accesskey = a

main-context-menu-media-play-speed =
    .label = Chanin Rutzijik
    .accesskey = t

main-context-menu-media-play-speed-slow =
    .label = Eqal (0.5×)
    .accesskey = E

main-context-menu-media-play-speed-normal =
    .label = Relik
    .accesskey = R

main-context-menu-media-play-speed-fast =
    .label = Aninäq (1.25×)
    .accesskey = A

main-context-menu-media-play-speed-faster =
    .label = Yalan aninäq (1.5×)
    .accesskey = n

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Ya'öl tze'n (2×)
    .accesskey = Y

main-context-menu-media-loop =
    .label = Tzolinel
    .accesskey = T

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Kek'ut pe chajinela'
    .accesskey = c

main-context-menu-media-hide-controls =
    .label = Ke'ewäx taq K'wayöl
    .accesskey = e

##

main-context-menu-media-video-fullscreen =
    .label = Chijun ruwa kematz'ib'
    .accesskey = C

main-context-menu-media-video-leave-fullscreen =
    .label = Tel pa chijun ruwa kematz'ib'
    .accesskey = c

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Picture-in-Picture
    .accesskey = u

main-context-menu-image-reload =
    .label = Rukamulokem wachib'äl
    .accesskey = R

main-context-menu-image-view =
    .label = Titz'et Wachib'äl
    .accesskey = W

main-context-menu-video-view =
    .label = Titz'et silowachib'äl
    .accesskey = t

main-context-menu-image-copy =
    .label = Tiwachib'ëx Wachib'äl
    .accesskey = w

main-context-menu-image-copy-location =
    .label = Tiwachib'ëx Rub'ey Wachib'äl
    .accesskey = w

main-context-menu-video-copy-location =
    .label = Ruwachib'exik rub'ey silowachib'äl
    .accesskey = w

main-context-menu-audio-copy-location =
    .label = Ruwachib'exik rub'ey q'ojom
    .accesskey = w

main-context-menu-image-save-as =
    .label = Tiyak Wachib'äl Achi'el…
    .accesskey = y

main-context-menu-image-email =
    .label = Titaq Wachib'äl…
    .accesskey = i

main-context-menu-image-set-as-background =
    .label = Ticha' achi'el richin rupam ch'atal…
    .accesskey = T

main-context-menu-image-info =
    .label = Titz'et na'oj chi rij ri wachib'äl
    .accesskey = o

main-context-menu-image-desc =
    .label = Titz'et ri Rutzijoxkil
    .accesskey = R

main-context-menu-video-save-as =
    .label = Tiyak silowachib'äl achi'el…
    .accesskey = s

main-context-menu-audio-save-as =
    .label = Ruyakik q'ojom achi'el…
    .accesskey = R

main-context-menu-video-image-save-as =
    .label = Ruyakik ruwachib'al rutzub'al achi'el…
    .accesskey = R

main-context-menu-video-email =
    .label = Rutaqik Silowachib'äl…
    .accesskey = i

main-context-menu-audio-email =
    .label = Titaq k'oxomal…
    .accesskey = t

main-context-menu-plugin-play =
    .label = Titzij re nak'ab'äl re'
    .accesskey = t

main-context-menu-plugin-hide =
    .label = Tewäx re nak'ab'äl re'
    .accesskey = e

main-context-menu-save-to-pocket =
    .label = Tiyak Ruxaq pa { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Titaq ruxaq pa Okisaxel
    .accesskey = O

main-context-menu-view-background-image =
    .label = Titz'et wachib'äl chupam
    .accesskey = c

main-context-menu-generate-new-password =
    .label = Tokisäx Tz'ukun Ewan Tzij…
    .accesskey = z

main-context-menu-keyword =
    .label = Titz'aqatisäx jun ewan tzij richin re Rukanoxik re'…
    .accesskey = e

main-context-menu-link-send-to-device =
    .label = Titaq Ximojri'ïl pa Okisaxel
    .accesskey = O

main-context-menu-frame =
    .label = Re ruchi' re'
    .accesskey = c

main-context-menu-frame-show-this =
    .label = Tik'ut pe xa xe re ruchi' re'
    .accesskey = T

main-context-menu-frame-open-tab =
    .label = Tijaq ruchi' pa jun k'ak'a' ruwi'
    .accesskey = w

main-context-menu-frame-open-window =
    .label = Tijaq ri ruchi' pa jun k'ak'a' tzuwäch
    .accesskey = t

main-context-menu-frame-reload =
    .label = Rukamulokem ruchi'
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Titz'aqatisäx re ruchi' kajtz'ik re' pa taq etal
    .accesskey = e

main-context-menu-frame-save-as =
    .label = Ruyakik Ruchi' Achi'el…
    .accesskey = R

main-context-menu-frame-print =
    .label = Titz'ajb'äx ruchi'…
    .accesskey = T

main-context-menu-frame-view-source =
    .label = Rutz'etik runuk' tz'ib' ri ruchi'
    .accesskey = R

main-context-menu-frame-view-info =
    .label = Rutz'etik na'oj chi rij re ruchi'
    .accesskey = n

main-context-menu-view-selection-source =
    .label = Rutz'etik runuk tz'ib' cha'on
    .accesskey = e

main-context-menu-view-page-source =
    .label = Rutz'etik runuk tz'ib' re ruxaq re'
    .accesskey = R

main-context-menu-view-page-info =
    .label = Rutz'etik na'oj chi rij re ruxaq re'
    .accesskey = n

main-context-menu-bidi-switch-text =
    .label = Tijal Rub'eyal ri Tz'ib'
    .accesskey = j

main-context-menu-bidi-switch-page =
    .label = Rujalik rub'eyal re ruxaq re'
    .accesskey = r

main-context-menu-inspect-element =
    .label = Rutz'etik atuxtäq
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Kenik'öx ri taq Richinil Okel

main-context-menu-eme-learn-more =
    .label = Tetamäx ch'aqa' chik chi rij ri DRM…
    .accesskey = D
