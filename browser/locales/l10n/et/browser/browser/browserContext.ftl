# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Ajaloo kuvamiseks hoia all
           *[other] Ajaloo kuvamiseks tee paremklõps või hoia all
        }

## Back

main-context-menu-back =
    .tooltiptext = Tagasi üks leht
    .aria-label = Tagasi
    .accesskey = T

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Edasi üks leht
    .aria-label = Edasi
    .accesskey = E

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Laadi uuesti
    .accesskey = L

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Peata
    .accesskey = P

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Salvesta veebileht kui…
    .accesskey = a

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Lisa see veebileht järjehoidjatesse
    .accesskey = j
    .tooltiptext = Lisa see leht järjehoidjatesse

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Lisa see veebileht järjehoidjatesse
    .accesskey = j
    .tooltiptext = Lisa see leht järjehoidjatesse ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Muuda seda järjehoidjat
    .accesskey = j
    .tooltiptext = Muuda seda järjehoidjat

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Muuda seda järjehoidjat
    .accesskey = j
    .tooltiptext = Muuda seda järjehoidjat ({ $shortcut })

main-context-menu-open-link =
    .label = Ava link
    .accesskey = v

main-context-menu-open-link-new-tab =
    .label = Ava link uuel kaardil
    .accesskey = k

main-context-menu-open-link-container-tab =
    .label = Ava link uuel konteinerkaardil
    .accesskey = t

main-context-menu-open-link-new-window =
    .label = Ava link uues aknas
    .accesskey = l

main-context-menu-open-link-new-private-window =
    .label = Ava link uues privaatses aknas
    .accesskey = k

main-context-menu-bookmark-this-link =
    .label = Lisa see link järjehoidjatesse
    .accesskey = n

main-context-menu-save-link =
    .label = Salvesta link kui…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Salvesta link { -pocket-brand-name }isse
    .accesskey = l

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopeeri e-posti aadress
    .accesskey = i

main-context-menu-copy-link =
    .label = Kopeeri lingi aadress
    .accesskey = o

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Esita
    .accesskey = E

main-context-menu-media-pause =
    .label = Paus
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Summuta
    .accesskey = S

main-context-menu-media-unmute =
    .label = Võta summutamine maha
    .accesskey = m

main-context-menu-media-play-speed =
    .label = Esitamise kiirus
    .accesskey = k

main-context-menu-media-play-speed-slow =
    .label = Aegluubis (0.5×)
    .accesskey = g

main-context-menu-media-play-speed-normal =
    .label = Tavaline
    .accesskey = T

main-context-menu-media-play-speed-fast =
    .label = Kiirendatud (1.25×)
    .accesskey = i

main-context-menu-media-play-speed-faster =
    .label = Veel rohkem kiirendatud (1.5×)
    .accesskey = e

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Naeruväärselt kiire (2×)
    .accesskey = N

main-context-menu-media-loop =
    .label = Kordamine
    .accesskey = o

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Näita juhtnuppe
    .accesskey = N

main-context-menu-media-hide-controls =
    .label = Peida juhtnupud
    .accesskey = e

##

main-context-menu-media-video-fullscreen =
    .label = Lülitu täisekraanirežiimi
    .accesskey = t

main-context-menu-media-video-leave-fullscreen =
    .label = Välju täisekraanirežiimist
    .accesskey = t

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Pilt-pildis
    .accesskey = P

main-context-menu-image-reload =
    .label = Laadi pilt uuesti
    .accesskey = L

main-context-menu-image-view =
    .label = Vaata pilti
    .accesskey = t

main-context-menu-video-view =
    .label = Vaata videot
    .accesskey = i

main-context-menu-image-copy =
    .label = Kopeeri pilt
    .accesskey = e

main-context-menu-image-copy-location =
    .label = Kopeeri pildi aadress
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Kopeeri video aadress
    .accesskey = e

main-context-menu-audio-copy-location =
    .label = Kopeeri audio aadress
    .accesskey = p

main-context-menu-image-save-as =
    .label = Salvesta pilt kui…
    .accesskey = p

main-context-menu-image-email =
    .label = Saada pilt e-postiga…
    .accesskey = d

main-context-menu-image-set-as-background =
    .label = Määra taustapildiks…
    .accesskey = M

main-context-menu-image-info =
    .label = Vaata pildi teavet
    .accesskey = V

main-context-menu-image-desc =
    .label = Vaata kirjeldust
    .accesskey = k

main-context-menu-video-save-as =
    .label = Salvesta video kui…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Salvesta audio kui…
    .accesskey = a

main-context-menu-video-image-save-as =
    .label = Salvesta hetkvõte kui…
    .accesskey = a

main-context-menu-video-email =
    .label = Saada video e-postiga…
    .accesskey = i

main-context-menu-audio-email =
    .label = Saada audio e-postiga…
    .accesskey = u

main-context-menu-plugin-play =
    .label = Aktiveeri see plugin
    .accesskey = u

main-context-menu-plugin-hide =
    .label = Peida see plugin
    .accesskey = d

main-context-menu-save-to-pocket =
    .label = Salvesta leht { -pocket-brand-name }isse
    .accesskey = k

main-context-menu-send-to-device =
    .label = Saada leht seadmesse
    .accesskey = h

main-context-menu-view-background-image =
    .label = Vaata taustapilti
    .accesskey = s

main-context-menu-keyword =
    .label = Lisa võti sellele otsingule...
    .accesskey = v

main-context-menu-link-send-to-device =
    .label = Saada link seadmesse
    .accesskey = i

main-context-menu-frame =
    .label = See paneel
    .accesskey = p

main-context-menu-frame-show-this =
    .label = Näita ainult seda paneeli
    .accesskey = d

main-context-menu-frame-open-tab =
    .label = Ava paneel uuel kaardil
    .accesskey = u

main-context-menu-frame-open-window =
    .label = Ava paneel uues aknas
    .accesskey = p

main-context-menu-frame-reload =
    .label = Laadi paneeli sisu uuesti
    .accesskey = L

main-context-menu-frame-bookmark =
    .label = Lisa see paneel järjehoidjatesse
    .accesskey = e

main-context-menu-frame-save-as =
    .label = Salvesta paneel kui…
    .accesskey = v

main-context-menu-frame-print =
    .label = Prindi paneeli sisu…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = Vaata paneeli lähtekoodi
    .accesskey = n

main-context-menu-frame-view-info =
    .label = Vaata paneeli teavet
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Vaata valiku lähtekoodi
    .accesskey = e

main-context-menu-view-page-source =
    .label = Vaata veebilehe lähtekoodi
    .accesskey = t

main-context-menu-view-page-info =
    .label = Vaata veebilehe teavet
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Muuda teksti suunda
    .accesskey = d

main-context-menu-bidi-switch-page =
    .label = Muuda lehe suunda
    .accesskey = h

main-context-menu-inspect-element =
    .label = Inspekteeri elementi
    .accesskey = n

main-context-menu-inspect-a11y-properties =
    .label = Inspect Accessibility Properties

main-context-menu-eme-learn-more =
    .label = Rohkem teavet DRMi kohta…
    .accesskey = D

