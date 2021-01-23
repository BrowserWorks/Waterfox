# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Pavelciet uz leju, lai redzētu vēsturi
           *[other] Uzklikšķiniet ar labo taustiņu un pavelciet uz leju, lai redzētu vēsturi
        }

## Back

main-context-menu-back =
    .tooltiptext = Paiet vienu lapu atpakaļ
    .aria-label = Atpakaļ
    .accesskey = A

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Paiet vienu lapu uz priekšu
    .aria-label = Uz priekšu
    .accesskey = P

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Pārlādēt
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Apturēt
    .accesskey = T

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Saglabāt lapu kā…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Saglabāt šo lapu grāmatzīmēs
    .accesskey = m
    .tooltiptext = Saglabāt šo lapu grāmatzīmēs

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Saglabāt šo lapu grāmatzīmēs
    .accesskey = m
    .tooltiptext = Saglabāt šo lapu grāmatzīmēs ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Rediģēt šo grāmatzīmi
    .accesskey = m
    .tooltiptext = Rediģēt šo grāmatzīmi

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Rediģēt šo grāmatzīmi
    .accesskey = m
    .tooltiptext = Rediģēt šo grāmatzīmi ({ $shortcut })

main-context-menu-open-link =
    .label = Atvērt saiti
    .accesskey = A

main-context-menu-open-link-new-tab =
    .label = Atvērt saiti jaunā cilnē
    .accesskey = c

main-context-menu-open-link-container-tab =
    .label = Atvētt saiti jaunā konteinera cilnē
    .accesskey = c

main-context-menu-open-link-new-window =
    .label = Atvērt saiti jaunā logā
    .accesskey = l

main-context-menu-open-link-new-private-window =
    .label = Atvērt saiti jaunā privātajā logā
    .accesskey = p

main-context-menu-bookmark-this-link =
    .label = Saglabāt šo saiti grāmatzīmēs
    .accesskey = S

main-context-menu-save-link =
    .label = Saglabāt saiti kā…
    .accesskey = k

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopēt epasta adresi
    .accesskey = e

main-context-menu-copy-link =
    .label = Kopēt saiti
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Atskaņot
    .accesskey = s

main-context-menu-media-pause =
    .label = Apturēt
    .accesskey = t

##

main-context-menu-media-mute =
    .label = Apklusināt
    .accesskey = A

main-context-menu-media-unmute =
    .label = Atjaunot
    .accesskey = a

main-context-menu-media-play-speed =
    .label = Atskaņošanas ātrums
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = Lēni (0.5 ×)
    .accesskey = L

main-context-menu-media-play-speed-normal =
    .label = Normāls
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Ātri (1.25×)
    .accesskey = T

main-context-menu-media-play-speed-faster =
    .label = Ātrāk (1.5×)
    .accesskey = t

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Super ātri (2×)
    .accesskey = S

main-context-menu-media-loop =
    .label = Ciklot
    .accesskey = C

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Rādīt kontroles
    .accesskey = k

main-context-menu-media-hide-controls =
    .label = Slēpt kontroles
    .accesskey = k

##

main-context-menu-media-video-fullscreen =
    .label = Pa visu ekrānu
    .accesskey = v

main-context-menu-media-video-leave-fullscreen =
    .label = Iziet no pilnekrāna
    .accesskey = n

main-context-menu-image-reload =
    .label = Pārlādēt attēlu
    .accesskey = r

main-context-menu-image-view =
    .label = Skatīt attēlu
    .accesskey = t

main-context-menu-video-view =
    .label = Skatīt video
    .accesskey = i

main-context-menu-image-copy =
    .label = Kopēt attēlu
    .accesskey = p

main-context-menu-image-copy-location =
    .label = Kopēt attēla adresi
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Kopēt video adresi
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Kopēt audio adresi
    .accesskey = o

main-context-menu-image-save-as =
    .label = Saglabāt attēlu kā…
    .accesskey = b

main-context-menu-image-email =
    .label = Nosūtīt attēlu…
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = Uzlikt kā darbvirsmas fonu…
    .accesskey = U

main-context-menu-image-info =
    .label = Skatīt attēla informāciju
    .accesskey = f

main-context-menu-image-desc =
    .label = Skatīt attēla aprakstu
    .accesskey = p

main-context-menu-video-save-as =
    .label = Saglabāt video kā…
    .accesskey = g

main-context-menu-audio-save-as =
    .label = Saglabāt audio kā…
    .accesskey = g

main-context-menu-video-image-save-as =
    .label = Saglabāt momentuzņēmumu kā…
    .accesskey = S

main-context-menu-video-email =
    .label = Nosūtīt video…
    .accesskey = v

main-context-menu-audio-email =
    .label = Nosūtīt audio…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Aktivēt šo spraudni
    .accesskey = a

main-context-menu-plugin-hide =
    .label = Paslēpt šo spraudni
    .accesskey = p

main-context-menu-send-to-device =
    .label = Sūtīt lapu uz ierīci
    .accesskey = I

main-context-menu-view-background-image =
    .label = Skatīt fona attēlu
    .accesskey = f

main-context-menu-keyword =
    .label = Pievienot meklējuma atslēgas vārdu…
    .accesskey = k

main-context-menu-link-send-to-device =
    .label = Sūtīt saiti uz ierīci
    .accesskey = I

main-context-menu-frame =
    .label = Šis ietvars
    .accesskey = a

main-context-menu-frame-show-this =
    .label = Rādīt tikai šo ietvaru
    .accesskey = t

main-context-menu-frame-open-tab =
    .label = Atvērt ietvaru jaunā cilnē
    .accesskey = c

main-context-menu-frame-open-window =
    .label = Atvērt ietvaru jaunā logā
    .accesskey = l

main-context-menu-frame-reload =
    .label = Pārlādēt ietvaru
    .accesskey = r

main-context-menu-frame-bookmark =
    .label = Pievienot šo ietvaru grāmatzīmēm
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Saglabāt ietvaru kā…
    .accesskey = t

main-context-menu-frame-print =
    .label = Drukāt ietvaru…
    .accesskey = D

main-context-menu-frame-view-source =
    .label = Skatīt ietvara pirmkodu
    .accesskey = S

main-context-menu-frame-view-info =
    .label = Skatīt informāciju par ietvaru
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Skatīt iezīmētā pirmkodu
    .accesskey = e

main-context-menu-view-page-source =
    .label = Skatīt lapas pirmkodu
    .accesskey = S

main-context-menu-view-page-info =
    .label = Skatīt informāciju par lapu
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Nomainīt teksta virzienu
    .accesskey = m

main-context-menu-bidi-switch-page =
    .label = Nomainīt lapas virzienu
    .accesskey = p

main-context-menu-inspect-element =
    .label = Izmeklēt
    .accesskey = I

main-context-menu-inspect-a11y-properties =
    .label = Izmeklēt pieejamības iestatījumus

main-context-menu-eme-learn-more =
    .label = Uzziniet vairāk par DRM…
    .accesskey = D

