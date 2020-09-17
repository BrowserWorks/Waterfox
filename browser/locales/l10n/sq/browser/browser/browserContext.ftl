# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Tërhiqeni poshtë që të shfaqet historiku
           *[other] Djathtasklikojeni ose tërhiqeni poshtë që të shfaqet historiku
        }

## Back

main-context-menu-back =
    .tooltiptext = Shkoni mbrapsht një faqe
    .aria-label = Mbrapsht
    .accesskey = M

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Shkoni para një faqe
    .aria-label = Para
    .accesskey = P

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Ringarkoje
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Ndale
    .accesskey = N

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Ruajeni Faqen Si…
    .accesskey = S

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Faqeruaje Këtë Faqe
    .accesskey = F
    .tooltiptext = Faqeruani këtë faqe

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Faqeruaje Këtë Faqe
    .accesskey = F
    .tooltiptext = Faqeruani këtë faqe ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Përpunojeni Këtë Faqerojtës
    .accesskey = F
    .tooltiptext = Përpunoni këtë faqerojtës

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Përpunojeni Këtë Faqerojtës
    .accesskey = F
    .tooltiptext = Përpunoni këtë faqerojtës ({ $shortcut })

main-context-menu-open-link =
    .label = Hape Lidhjen
    .accesskey = H

main-context-menu-open-link-new-tab =
    .label = Hape Lidhjen në Skedë të Re
    .accesskey = S

main-context-menu-open-link-container-tab =
    .label = Hape Lidhjen në Skedë të Re Kontejneri
    .accesskey = K

main-context-menu-open-link-new-window =
    .label = Hape Lidhjen në Dritare të Re
    .accesskey = D

main-context-menu-open-link-new-private-window =
    .label = Hape Lidhjen në Dritare të Re Private
    .accesskey = V

main-context-menu-bookmark-this-link =
    .label = Faqeruaje Këtë Lidhje
    .accesskey = L

main-context-menu-save-link =
    .label = Ruajeni Lidhjen Si…
    .accesskey = R

main-context-menu-save-link-to-pocket =
    .label = Ruajeni Lidhjen te { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopjo Adresë Email
    .accesskey = E

main-context-menu-copy-link =
    .label = Kopjo Vendndodhje Lidhjeje
    .accesskey = K

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Luaje
    .accesskey = L

main-context-menu-media-pause =
    .label = Ndale
    .accesskey = l

##

main-context-menu-media-mute =
    .label = Pa Zë
    .accesskey = z

main-context-menu-media-unmute =
    .label = Me Zë
    .accesskey = z

main-context-menu-media-play-speed =
    .label = Shpejtësi Loje
    .accesskey = e

main-context-menu-media-play-speed-slow =
    .label = Ngadalë (0.5×)
    .accesskey = a

main-context-menu-media-play-speed-normal =
    .label = Normale
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Shpejt (1.25×)
    .accesskey = S

main-context-menu-media-play-speed-faster =
    .label = Më shpejt (1.5×)
    .accesskey = ë

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Marramendëse (2×)
    .accesskey = M

main-context-menu-media-loop =
    .label = Loop
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Shfaqi Kontrollet
    .accesskey = K

main-context-menu-media-hide-controls =
    .label = Fshihi Kontrollet
    .accesskey = K

##

main-context-menu-media-video-fullscreen =
    .label = Sa Krejt Ekrani
    .accesskey = E

main-context-menu-media-video-leave-fullscreen =
    .label = Dilni nga Sa Krejt Ekrani
    .accesskey = D

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Picture-in-Picture
    .accesskey = u

main-context-menu-image-reload =
    .label = Ringarkoje Figurën
    .accesskey = R

main-context-menu-image-view =
    .label = Shiheni Figurën
    .accesskey = I

main-context-menu-video-view =
    .label = Shiheni Videon
    .accesskey = S

main-context-menu-image-copy =
    .label = Kopjo Figurën
    .accesskey = K

main-context-menu-image-copy-location =
    .label = Kopjo Vendndodhje Figure
    .accesskey = P

main-context-menu-video-copy-location =
    .label = Kopjo Vendndodhje Videoje
    .accesskey = k

main-context-menu-audio-copy-location =
    .label = Kopjo Vendndodhje Audioje
    .accesskey = k

main-context-menu-image-save-as =
    .label = Ruajeni Figurën Si…
    .accesskey = u

main-context-menu-image-email =
    .label = Dërgoni Figurë me Email…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = Vëreni Si Sfond Desktopi…
    .accesskey = S

main-context-menu-image-info =
    .label = Shfaq të Dhëna Figure
    .accesskey = D

main-context-menu-image-desc =
    .label = Shihni Përshkrimin
    .accesskey = k

main-context-menu-video-save-as =
    .label = Ruajeni Videon Si…
    .accesskey = u

main-context-menu-audio-save-as =
    .label = Ruajeni Audion Si…
    .accesskey = u

main-context-menu-video-image-save-as =
    .label = Ruajeni Foton Si…
    .accesskey = R

main-context-menu-video-email =
    .label = Dërgoni Video me Email…
    .accesskey = v

main-context-menu-audio-email =
    .label = Dërgoni Audio me Email…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Aktivizoje këtë shtojcë
    .accesskey = A

main-context-menu-plugin-hide =
    .label = Fshihe këtë shtojcë
    .accesskey = F

main-context-menu-save-to-pocket =
    .label = Ruaje Faqen te { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Dërgoje Faqen te Pajisje
    .accesskey = P

main-context-menu-view-background-image =
    .label = Shihni Figurë Sfondi
    .accesskey = i

main-context-menu-generate-new-password =
    .label = Përdorni Fjalëkalimin e Prodhuar…
    .accesskey = o

main-context-menu-keyword =
    .label = Shtoni një Fjalëkyç për këtë Kërkim…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = Dërgoje Lidhjen te Pajisja
    .accesskey = P

main-context-menu-frame =
    .label = Këtë Kuadër
    .accesskey = K

main-context-menu-frame-show-this =
    .label = Shfaq Vetëm Këtë Kuadër
    .accesskey = T

main-context-menu-frame-open-tab =
    .label = Hape Kuadrin në Skedë të Re
    .accesskey = S

main-context-menu-frame-open-window =
    .label = Hape Kuadrin në Dritare të Re
    .accesskey = D

main-context-menu-frame-reload =
    .label = Ringarkoje Kuadrin
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Faqeruaje Këtë Kuadër
    .accesskey = K

main-context-menu-frame-save-as =
    .label = Ruajeni Kuadrin Si…
    .accesskey = i

main-context-menu-frame-print =
    .label = Shtypni Kuadrin…
    .accesskey = K

main-context-menu-frame-view-source =
    .label = Shihni Burim Kuadri
    .accesskey = B

main-context-menu-frame-view-info =
    .label = Shihni të Dhëna Kuadri
    .accesskey = I

main-context-menu-view-selection-source =
    .label = Shihni Burim Përzgjedhjeje
    .accesskey = e

main-context-menu-view-page-source =
    .label = Shihni Burim Faqeje
    .accesskey = u

main-context-menu-view-page-info =
    .label = Shihni të Dhëna Faqeje
    .accesskey = D

main-context-menu-bidi-switch-text =
    .label = Këmbe Drejtim Teksti
    .accesskey = T

main-context-menu-bidi-switch-page =
    .label = Këmbe Drejtim Faqeje
    .accesskey = F

main-context-menu-inspect-element =
    .label = Shqyrtoje Elementin
    .accesskey = E

main-context-menu-inspect-a11y-properties =
    .label = Mbikëqyrni Veti Përdorshmërie

main-context-menu-eme-learn-more =
    .label = Mësoni më tepër rreth DRM-s…
    .accesskey = D
