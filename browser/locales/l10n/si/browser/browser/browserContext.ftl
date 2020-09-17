# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] පෙරදෑ පෙන්වීමට පහළට අදින්න
           *[other] පෙරදෑ පෙන්වීමට පහළට අදින්න හෝ දකුණත් ක්ලික් කරන්න
        }

## Back

main-context-menu-back =
    .tooltiptext = පිටුවක් පසුපසට
    .aria-label = ආපසු
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = පිටුවක් ඉදිරියට
    .aria-label = ඉදිරියට
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = යළි පූර්ණය
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = නවතන්න
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = පිටුව සුරකින්න...
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = මෙම පිටුව සලකුණු කරගන්න
    .accesskey = m
    .tooltiptext = පිටු සලකුණු කරන්න

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = මෙම පිටුව සලකුණු කරගන්න
    .accesskey = m
    .tooltiptext = පිටු සලකුණු කරන්න ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = මෙම පිටු සලකුණ සකසන්න
    .accesskey = m
    .tooltiptext = මෙම පිටු සලකුණ සකසන්න

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = මෙම පිටු සලකුණ සකසන්න
    .accesskey = m
    .tooltiptext = මෙම පිටු සලකුණ සකසන්න ({ $shortcut })

main-context-menu-open-link =
    .label = ඈඳුම විවෘත කරන්න
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = සබැඳුම අලුත් ටැබයක විවෘත කරන්න
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = සබැඳුම නව බහාලුම් ටැබයක විවෘත කරන්න
    .accesskey = C

main-context-menu-open-link-new-window =
    .label = අළුත් කවුළුවක විවෘත කරන්න
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = නව පුද්ගලික කවුළුවක විවෘත කරන්න
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = මෙම පුරුක පිටු සලකුණු කරන්න
    .accesskey = L

main-context-menu-save-link =
    .label = සබැඳුම සුරකින අයුර...
    .accesskey = k

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = විද්‍යුත් තැපැල් ලිපිනය පිටපත් කරන්න
    .accesskey = E

main-context-menu-copy-link =
    .label = පුරුකේ ස්ථානය පිටපත් කරන්න
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = වාදනය
    .accesskey = P

main-context-menu-media-pause =
    .label = විරාමය
    .accesskey = P

##

main-context-menu-media-mute =
    .label = නිහඬ කරන්න
    .accesskey = M

main-context-menu-media-unmute =
    .label = නිහඬ නොකරන්න
    .accesskey = m

main-context-menu-media-play-speed =
    .label = වාදන වේගය
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = සෙමින් (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = සාමාන්‍ය
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = වේගවත් (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = වඩා වේගවත් (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Ludicrous (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = ලූපය
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = පාලන දර්ශනය
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = පාලන සඟවන්න
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = සමුපූර්ණ තිරය
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = පූර්ණ තිරයෙන් පිටවන්න
    .accesskey = u

main-context-menu-image-reload =
    .label = පිතුර යළි පූරණය
    .accesskey = R

main-context-menu-image-view =
    .label = රූපය පෙන්වන්න
    .accesskey = I

main-context-menu-video-view =
    .label = දෘශ්‍ය දර්ශනය
    .accesskey = i

main-context-menu-image-copy =
    .label = රූපය පිටපත් කරන්න
    .accesskey = y

main-context-menu-image-copy-location =
    .label = රූපයෙ ස්ථානය පිටපත් කරන්න
    .accesskey = o

main-context-menu-video-copy-location =
    .label = දෘශ්‍ය පිහිටුම පිටපත් කරන්න
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ශ්‍රව්‍ය පිහිටුම පිටපත් කරන්න
    .accesskey = o

main-context-menu-image-save-as =
    .label = රූපය සුරකින අයුර...
    .accesskey = v

main-context-menu-image-email =
    .label = රූපය ඊමේල් කරන්න...
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = තිරයේ පසුබිමසේ සකසන්න...
    .accesskey = S

main-context-menu-image-info =
    .label = රූපයේ තොරතුරු පෙන්වන්න
    .accesskey = f

main-context-menu-image-desc =
    .label = විස්තරය පෙන්වන්න
    .accesskey = D

main-context-menu-video-save-as =
    .label = දෘශ්‍ය සුරකින අයුර…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = ශ්‍රව්‍ය සුරකින අයුර…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = ඡායාරූපය සුරකින්නේ මෙලෙස…
    .accesskey = S

main-context-menu-video-email =
    .label = වීඩියෝ ඊමේල් කරන්න...
    .accesskey = a

main-context-menu-audio-email =
    .label = ශ්‍රව්‍ය තැපැල්...
    .accesskey = a

main-context-menu-plugin-play =
    .label = මෙම ප්ලගිනය සකරිය කරන්න
    .accesskey = c

main-context-menu-plugin-hide =
    .label = මෙම ප්ලගිනය සඟවන්න
    .accesskey = H

main-context-menu-send-to-device =
    .label = පිටුව උපාංගයට යවන්න
    .accesskey = D

main-context-menu-view-background-image =
    .label = පසුබිමේ රූපය පෙන්වන්න
    .accesskey = w

main-context-menu-keyword =
    .label = මෙම සෙවුම සඳහා සෙවුම් වදනක් එක් කරන්න...
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = ඈදුම උපාංගයට යවන්න
    .accesskey = D

main-context-menu-frame =
    .label = මෙම රාමුව
    .accesskey = h

main-context-menu-frame-show-this =
    .label = මෙම රාමුව පමණක් පෙන්වන්න
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = රාමුව නව ටැබයක් තුළ විවෘත කරන්න
    .accesskey = T

main-context-menu-frame-open-window =
    .label = රාමුව නව කවුළුවක් තුළ විවෘත කරන්න
    .accesskey = W

main-context-menu-frame-reload =
    .label = රාමුව ප්‍රතිපූරණය
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = මෙම රාමුව පිටු සලකුණුගත කරන්න
    .accesskey = m

main-context-menu-frame-save-as =
    .label = රාමුව සුරකින අයුර...
    .accesskey = F

main-context-menu-frame-print =
    .label = රාමුව මුද්‍රණය…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = රාමු මූලය පෙන්වන්න
    .accesskey = V

main-context-menu-frame-view-info =
    .label = රාමු තොරතුරු පෙන්වන්න
    .accesskey = I

main-context-menu-view-selection-source =
    .label = තේරිම් මූලය ‌පෙන්වන්න
    .accesskey = e

main-context-menu-view-page-source =
    .label = පිටුවේ මූලය ‌පෙන්වන්න
    .accesskey = V

main-context-menu-view-page-info =
    .label = පිටුවේ තොරතුරු පෙන්වන්න
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = පෙළ දිශාව හරවන්න
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = පිටු දිශාව හරවන්න
    .accesskey = D

main-context-menu-inspect-element =
    .label = මෙම අංගය පරීක්ෂා කරන්න
    .accesskey = Q

main-context-menu-eme-learn-more =
    .label = DRM පිළිබඳ වැඩිදුර දැනගන්න...
    .accesskey = D

