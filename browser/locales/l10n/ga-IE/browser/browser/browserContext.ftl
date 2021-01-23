# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Tarraing anuas chun an stair a thaispeáint
           *[other] Deaschliceáil nó tarraing anuas chun an stair a thaispeáint
        }

## Back

main-context-menu-back =
    .tooltiptext = Leathanach amháin siar
    .aria-label = Siar
    .accesskey = s

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Leathanach amháin ar aghaidh
    .aria-label = Ar Aghaidh
    .accesskey = A

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Athlódáil
    .accesskey = A

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stad
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Sábháil an Leathanach Mar…
    .accesskey = R

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Cruthaigh Leabharmharc don Leathanach Seo
    .accesskey = m
    .tooltiptext = Cruthaigh Leabharmharc don Leathanach Seo

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Cruthaigh Leabharmharc don Leathanach Seo
    .accesskey = m
    .tooltiptext = Cruthaigh leabharmharc don leathanach seo ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Cuir an Leabharmharc Seo in Eagar
    .accesskey = m
    .tooltiptext = Cuir an leabharmharc seo in eagar

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Cuir an Leabharmharc Seo in Eagar
    .accesskey = m
    .tooltiptext = Cuir an leabharmharc seo in eagar ({ $shortcut })

main-context-menu-open-link =
    .label = Oscail an Nasc
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Oscail an Nasc i gCluaisín Nua
    .accesskey = C

main-context-menu-open-link-container-tab =
    .label = Oscail an Nasc i gCluaisín Coimeádáin Nua
    .accesskey = g

main-context-menu-open-link-new-window =
    .label = Oscail an Nasc i bhFuinneog Nua
    .accesskey = F

main-context-menu-open-link-new-private-window =
    .label = Oscail an Nasc i bhFuinneog Nua Phríobháideach
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = Cruthaigh Leabharmharc don Nasc Seo
    .accesskey = L

main-context-menu-save-link =
    .label = Sábháil an Nasc Mar…
    .accesskey = N

main-context-menu-save-link-to-pocket =
    .label = Sábháil an Nasc i { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Cóipeáil an Seoladh Ríomhphoist
    .accesskey = e

main-context-menu-copy-link =
    .label = Cóipeáil Suíomh an Naisc
    .accesskey = p

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Seinn
    .accesskey = S

main-context-menu-media-pause =
    .label = Cuir ar Sos
    .accesskey = S

##

main-context-menu-media-mute =
    .label = Gan Fuaim
    .accesskey = m

main-context-menu-media-unmute =
    .label = Le Fuaim
    .accesskey = m

main-context-menu-media-play-speed =
    .label = Luas Seinnte
    .accesskey = L

main-context-menu-media-play-speed-slow =
    .label = Mall (0.5×)
    .accesskey = M

main-context-menu-media-play-speed-normal =
    .label = Gnáthluas
    .accesskey = n

main-context-menu-media-play-speed-fast =
    .label = Tapa (1.25×)
    .accesskey = T

main-context-menu-media-play-speed-faster =
    .label = Níos Tapúla (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Luas Áiféiseach (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = Lúb
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Taispeáin Rialtáin
    .accesskey = R

main-context-menu-media-hide-controls =
    .label = Folaigh Rialtáin
    .accesskey = R

##

main-context-menu-media-video-fullscreen =
    .label = Lánscáileán
    .accesskey = i

main-context-menu-media-video-leave-fullscreen =
    .label = Scoir ón Lánscáileán
    .accesskey = n

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Pictiúr i bPictiúr
    .accesskey = P

main-context-menu-image-reload =
    .label = Athlódáil an Íomhá
    .accesskey = A

main-context-menu-image-view =
    .label = Taispeáin an Íomhá Amháin
    .accesskey = T

main-context-menu-video-view =
    .label = Féach ar Fhíseán
    .accesskey = F

main-context-menu-image-copy =
    .label = Cóipeáil an Íomhá
    .accesskey = p

main-context-menu-image-copy-location =
    .label = Cóipeáil Suíomh na hÍomhá
    .accesskey = ó

main-context-menu-video-copy-location =
    .label = Cóipeáil Suíomh an Fhíseáin
    .accesskey = ó

main-context-menu-audio-copy-location =
    .label = Cóipeáil Suíomh na Fuaime
    .accesskey = ó

main-context-menu-image-save-as =
    .label = Sábháil an Íomhá Mar…
    .accesskey = M

main-context-menu-image-email =
    .label = Seol an Íomhá trí Ríomhphost…
    .accesskey = m

main-context-menu-image-set-as-background =
    .label = Socraigh Mar Chúlra na Deisce…
    .accesskey = S

main-context-menu-image-info =
    .label = Taispeáin Eolas Faoin Íomhá
    .accesskey = F

main-context-menu-image-desc =
    .label = Taispeáin Cur Síos
    .accesskey = C

main-context-menu-video-save-as =
    .label = Sábháil an Físeán Mar…
    .accesskey = F

main-context-menu-audio-save-as =
    .label = Sábháil an Fhuaim Mar…
    .accesskey = b

main-context-menu-video-image-save-as =
    .label = Sábháil Grianghraf Mar…
    .accesskey = S

main-context-menu-video-email =
    .label = Seol an Físeán trí Ríomhphost…
    .accesskey = a

main-context-menu-audio-email =
    .label = Seol an Fhuaim trí Ríomhphost…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Cuir an forlíontán seo i ngníomh
    .accesskey = C

main-context-menu-plugin-hide =
    .label = Folaigh an forlíontán seo
    .accesskey = h

main-context-menu-save-to-pocket =
    .label = Sábháil an Leathanach i { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Seol an Leathanach chuig Gléas
    .accesskey = G

main-context-menu-view-background-image =
    .label = Taispeáin Íomhá sa Chúlra
    .accesskey = C

main-context-menu-generate-new-password =
    .label = Úsáid Focal Faire Ginte…
    .accesskey = G

main-context-menu-keyword =
    .label = Cuir lorgfhocal leis an gcuardach seo…
    .accesskey = l

main-context-menu-link-send-to-device =
    .label = Seol an Nasc chuig Gléas
    .accesskey = G

main-context-menu-frame =
    .label = An Fráma Seo
    .accesskey = r

main-context-menu-frame-show-this =
    .label = Ná Taispeáin ach an Fráma Seo
    .accesskey = s

main-context-menu-frame-open-tab =
    .label = Oscail an Fráma i gCluaisín Nua
    .accesskey = C

main-context-menu-frame-open-window =
    .label = Oscail an Fráma i bhFuinneog Nua
    .accesskey = F

main-context-menu-frame-reload =
    .label = Athlódáil an Fráma
    .accesskey = r

main-context-menu-frame-bookmark =
    .label = Cruthaigh Leabharmharc don Fhráma Seo
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Sábháil an Fráma Mar…
    .accesskey = F

main-context-menu-frame-print =
    .label = Priontáil an Fráma…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = Taispeáin Foinse an Fhráma
    .accesskey = T

main-context-menu-frame-view-info =
    .label = Taispeáin Eolas Fráma
    .accesskey = E

main-context-menu-view-selection-source =
    .label = Taispeáin Foinse Roghnaithe
    .accesskey = e

main-context-menu-view-page-source =
    .label = Taispeáin Foinse an Leathanaigh
    .accesskey = F

main-context-menu-view-page-info =
    .label = Taispeáin Sonraí an Leathanaigh
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Athraigh Treo an Téacs
    .accesskey = T

main-context-menu-bidi-switch-page =
    .label = Athraigh Treo an Leathanaigh
    .accesskey = L

main-context-menu-inspect-element =
    .label = Scrúdaigh Eilimint
    .accesskey = S

main-context-menu-inspect-a11y-properties =
    .label = Scrúdaigh Airíonna Inrochtaineachta

main-context-menu-eme-learn-more =
    .label = Tuilleadh eolais faoi DRM...
    .accesskey = D

