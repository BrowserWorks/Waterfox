# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Ćehńće dele, zo byšce historiju pokazał
           *[other] Klikńće z prawej tastu abo ćehńće dele, zo byšće historiju pokazał
        }

## Back

main-context-menu-back =
    .tooltiptext = Jednu stronu wróćo
    .aria-label = Wróćo
    .accesskey = W

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Jednu stronu doprědka
    .aria-label = Doprědka
    .accesskey = D

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Znowa
    .accesskey = Z

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stój
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Stronu składować jako…
    .accesskey = k

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Tutu stronu jako zapołožku składować
    .accesskey = z
    .tooltiptext = Tutu stronu jako zapołožku składować

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Tutu stronu jako zapołožku składować
    .accesskey = z
    .tooltiptext = Tutu stronu ({ $shortcut }) jako zapołožku składować

main-context-menu-bookmark-change =
    .aria-label = Tutu zapołožku wobdźěłać
    .accesskey = z
    .tooltiptext = Tutu zapołožku wobdźěłać

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Tutu zapołožku wobdźěłać
    .accesskey = z
    .tooltiptext = Tutu zapołožku ({ $shortcut }) wobdźěłać

main-context-menu-open-link =
    .label = Wotkaz wočinić
    .accesskey = o

main-context-menu-open-link-new-tab =
    .label = Wotkaz w nowym rajtarku wočinić
    .accesskey = r

main-context-menu-open-link-container-tab =
    .label = Wotkaz w nowym kontejnerowym rajtarku wočinić
    .accesskey = o

main-context-menu-open-link-new-window =
    .label = Wotkaz w nowym woknje wočinić
    .accesskey = k

main-context-menu-open-link-new-private-window =
    .label = Wotkaz w nowym priwatnym woknje wočinić
    .accesskey = o

main-context-menu-bookmark-this-link =
    .label = Tutón wotkaz jako zapołožku składować
    .accesskey = k

main-context-menu-save-link =
    .label = Wotkaz składować jako…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Wotkaz do { -pocket-brand-name } składować
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = E-mejlowu adresu kopěrować
    .accesskey = E

main-context-menu-copy-link =
    .label = Wotkazowu adresu kopěrować
    .accesskey = k

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Wothrać
    .accesskey = t

main-context-menu-media-pause =
    .label = Přestawka
    .accesskey = t

##

main-context-menu-media-mute =
    .label = Bjez zynka
    .accesskey = z

main-context-menu-media-unmute =
    .label = Ze zynkom
    .accesskey = Z

main-context-menu-media-play-speed =
    .label = Wothrawanska spěšnosć
    .accesskey = h

main-context-menu-media-play-speed-slow =
    .label = Pomału (0.5×)
    .accesskey = P

main-context-menu-media-play-speed-normal =
    .label = Normalny
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Spěšna (1.25×)
    .accesskey = S

main-context-menu-media-play-speed-faster =
    .label = Spěšniša (1.5×)
    .accesskey = n

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Jara wysoki (2×)
    .accesskey = J

main-context-menu-media-loop =
    .label = Awtomatisce wospjetować
    .accesskey = A

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Wodźenske elementy pokazać
    .accesskey = W

main-context-menu-media-hide-controls =
    .label = Wodźenske elementy schować
    .accesskey = W

##

main-context-menu-media-video-fullscreen =
    .label = Połna wobrazowka
    .accesskey = P

main-context-menu-media-video-leave-fullscreen =
    .label = Połnu wobrazowku wopušćić
    .accesskey = o

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Wobraz-we-wobrazu
    .accesskey = b

main-context-menu-image-reload =
    .label = Wobraz znowa začitać
    .accesskey = b

main-context-menu-image-view =
    .label = Wobraz pokazać
    .accesskey = r

main-context-menu-video-view =
    .label = Widejo pokazać
    .accesskey = d

main-context-menu-image-copy =
    .label = Wobraz kopěrować
    .accesskey = r

main-context-menu-image-copy-location =
    .label = Wobrazowu adresu kopěrować
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Widejowu adresu kopěrować
    .accesskey = i

main-context-menu-audio-copy-location =
    .label = Adresu awdiodataje kopěrować
    .accesskey = u

main-context-menu-image-save-as =
    .label = Wobraz składować jako…
    .accesskey = r

main-context-menu-image-email =
    .label = Wobraz e-mejlować…
    .accesskey = b

main-context-menu-image-set-as-background =
    .label = Jako desktopowy pozadk nastajić…
    .accesskey = J

main-context-menu-image-info =
    .label = Info wo wobrazu pokazać
    .accesskey = w

main-context-menu-image-desc =
    .label = Wopisanje pokazać
    .accesskey = o

main-context-menu-video-save-as =
    .label = Widejo składować jako…
    .accesskey = d

main-context-menu-audio-save-as =
    .label = Awdiodataju składować jako…
    .accesskey = A

main-context-menu-video-image-save-as =
    .label = Foto wobrazowki składować jako…
    .accesskey = F

main-context-menu-video-email =
    .label = Widejo e-mejlować…
    .accesskey = m

main-context-menu-audio-email =
    .label = Awdiodataju e-mejlować…
    .accesskey = i

main-context-menu-plugin-play =
    .label = Tutón tykač aktiwizować
    .accesskey = T

main-context-menu-plugin-hide =
    .label = Tutón tykač schować
    .accesskey = h

main-context-menu-save-to-pocket =
    .label = Stronu pola { -pocket-brand-name } składować
    .accesskey = k

main-context-menu-send-to-device =
    .label = Stronu na grat pósłać
    .accesskey = S

main-context-menu-view-background-image =
    .label = Pozadkowy wobraz pokazać
    .accesskey = P

main-context-menu-generate-new-password =
    .label = Spłodźene hesło wužiwać…
    .accesskey = S

main-context-menu-keyword =
    .label = Hesło za tute pytanje přidać…
    .accesskey = H

main-context-menu-link-send-to-device =
    .label = Wotkaz na grat pósłać
    .accesskey = W

main-context-menu-frame =
    .label = Tutón wobłuk
    .accesskey = T

main-context-menu-frame-show-this =
    .label = Jenož w tutym wobłuku pokazać
    .accesskey = J

main-context-menu-frame-open-tab =
    .label = Wobłuk w nowym rajtarku wočinić
    .accesskey = b

main-context-menu-frame-open-window =
    .label = Wobłuk w nowym woknje wočinić
    .accesskey = u

main-context-menu-frame-reload =
    .label = Wobłuk znowa začitać
    .accesskey = z

main-context-menu-frame-bookmark =
    .label = Tutón wobłuk jako zapołožku skladować
    .accesskey = b

main-context-menu-frame-save-as =
    .label = Wobłuk składować jako…
    .accesskey = b

main-context-menu-frame-print =
    .label = Wobłuk ćišćeć…
    .accesskey = i

main-context-menu-frame-view-source =
    .label = Žórłowy tekst wobłuka zwobraznić
    .accesskey = b

main-context-menu-frame-view-info =
    .label = Info wo wobłuku pokazać
    .accesskey = f

main-context-menu-view-selection-source =
    .label = Žórłowy tekst wuběra zwobraznić
    .accesskey = t

main-context-menu-view-page-source =
    .label = Žórłowy tekst strony pokazać
    .accesskey = t

main-context-menu-view-page-info =
    .label = Info wo stronje pokazać
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Směr teksta přepinyć
    .accesskey = k

main-context-menu-bidi-switch-page =
    .label = Směr strony přepinyć
    .accesskey = t

main-context-menu-inspect-element =
    .label = Element přepytować
    .accesskey = E

main-context-menu-inspect-a11y-properties =
    .label = Kajkosće bjezbarjernosće přepytować

main-context-menu-eme-learn-more =
    .label = Zhońće wjace wo DRM…
    .accesskey = D

