# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] ಇತಿಹಾಸವನ್ನು ತೋರಿಸಲು ಕೆಳಕ್ಕೆ ಎಳೆಯಿರಿ
           *[other] ಇತಿಹಾಸವನ್ನು ತೋರಿಸಲು ಮೌಸ್‌ನ ಬಲಗುಂಡಿಯನ್ನು ಒತ್ತಿ ಅಥವ ಕೆಳಕ್ಕೆ ಎಳೆಯಿರಿ
        }

## Back

main-context-menu-back =
    .tooltiptext = ಒಂದು ಪುಟ ಹಿಂದಕ್ಕೆ ಹೋಗು
    .aria-label = ಹಿಂದೆ
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = ಒಂದು ಪುಟ ಮುಂದಕ್ಕೆ ಹೋಗು
    .aria-label = ಮುಂದೆ
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = ಪುನಃ ಲೋಡ್ ಮಾಡು
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = ನಿಲ್ಲು
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = ಈ ಪುಟವನ್ನು ಹೀಗೆ ಉಳಿಸು...
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = ಈ ಪುಟವನ್ನು ಪುಟಗುರುತು ಮಾಡು
    .accesskey = m
    .tooltiptext = ಈ ಪುಟವನ್ನು ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡು

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = ಈ ಪುಟವನ್ನು ಪುಟಗುರುತು ಮಾಡು
    .accesskey = m
    .tooltiptext = ಈ ಪುಟವನ್ನು ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡು ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = ಈ ಬುಕ್‌ಮಾರ್ಕನ್ನು ಸಂಪಾದಿಸು
    .accesskey = m
    .tooltiptext = ಈ ಬುಕ್‌ಮಾರ್ಕನ್ನು ತಿದ್ದು

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = ಈ ಬುಕ್‌ಮಾರ್ಕನ್ನು ಸಂಪಾದಿಸು
    .accesskey = m
    .tooltiptext = ಈ ಬುಕ್‌ಮಾರ್ಕನ್ನು ತಿದ್ದು ({ $shortcut })

main-context-menu-open-link =
    .label = ಕೊಂಡಿಯನ್ನು ತೆರೆ
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = ಹೊಸ ಹಾಳೆಯಲ್ಲಿ ಕೊಂಡಿಯನ್ನು ತೆರೆ
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = ಕೊಂಡಿಯನ್ನು ಹೊಸ ಕಂಟೇನರ್ ಟ್ಯಾಬ್‌‍ನಲ್ಲಿ ತೆರೆಯಿರಿ‍
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = ಹೊಸ Window ಯಲ್ಲಿ ಕೊಂಡಿಯನ್ನು ತೆರೆ
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = ಹೊಸ Private ಕಿಟಕಿಯಲ್ಲಿ ಕೊಂಡಿಯನ್ನು ತೆರೆ
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = ಈ ಕೊಂಡಿಯನ್ನು ಪುಟಗುರುತು ಮಾಡು
    .accesskey = L

main-context-menu-save-link =
    .label = ಕೊಂಡಿಯನ್ನು ಹೀಗೆ ಉಳಿಸು...
    .accesskey = k

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = ಇಮೈಲ್ ವಿಳಾಸವನ್ನು ಕಾಪಿ ಮಾಡು
    .accesskey = E

main-context-menu-copy-link =
    .label = ತಾಣದ ವಿಳಾಸವನ್ನು (ಲಿಂಕ್ ಲೋಕೇಶನ್) ಪ್ರತಿ ಮಾಡು
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = ಚಾಲನೆ ಮಾಡು
    .accesskey = P

main-context-menu-media-pause =
    .label = ತಾತ್ಕಾಲಿಕವಾಗಿ ನಿಲ್ಲಿಸು
    .accesskey = P

##

main-context-menu-media-mute =
    .label = ಮೂಕವಾಗಿಸು
    .accesskey = M

main-context-menu-media-unmute =
    .label = ಮೂಕವಾಗಿಸಬೇಡ
    .accesskey = m

main-context-menu-media-play-speed =
    .label = ಚಾಲನೆಯ ವೇಗ
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = ನಿಧಾನ (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = ಸಾಮಾನ್ಯ
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = ವೇಗ (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = ವೇಗವಾಗಿ (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = ಅತ್ಯಂತ ವೇಗ (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = ಲೂಪ್
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = ನಿಯಂತ್ರಣಗಳನ್ನು ತೋರಿಸು
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = ನಿಯಂತ್ರಣಗಳನ್ನು ಅಡಗಿಸು
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = ಪೂರ್ಣ ಪರದೆ
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = ಪೂರ್ಣತೆರೆಯಿಂದ ನಿರ್ಗಮಿಸು
    .accesskey = u

main-context-menu-image-reload =
    .label = ಚಿತ್ರವನ್ನು ಮರಳಿ ಲೋಡ್ ಮಾಡು
    .accesskey = R

main-context-menu-image-view =
    .label = ಚಿತ್ರವನ್ನು ನೋಡು
    .accesskey = I

main-context-menu-video-view =
    .label = ವೀಡಿಯೋ ಅನ್ನು ನೋಡಿ
    .accesskey = i

main-context-menu-image-copy =
    .label = ಚಿತ್ರವನ್ನು ಕಾಪಿ ಮಾಡು
    .accesskey = y

main-context-menu-image-copy-location =
    .label = ಚಿತ್ರದ ತಾಣವನ್ನು ಕಾಪಿ ಮಾಡು
    .accesskey = o

main-context-menu-video-copy-location =
    .label = ವೀಡಿಯೋ ತಾಣವನ್ನು ಕಾಪಿ ಮಾಡು
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ಆಡಿಯೋ ತಾಣವನ್ನು ಕಾಪಿ ಮಾಡು
    .accesskey = o

main-context-menu-image-save-as =
    .label = ಚಿತ್ರವನ್ನು ಹೀಗೆ ಉಳಿಸು...
    .accesskey = v

main-context-menu-image-email =
    .label = ಚಿತ್ರವನ್ನು ಇಮೈಲ್ ಮಾಡಿ…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = ಗಣಕತೆರೆಯ ಹಿನ್ನಲೆಯಾಗಿ ಹೊಂದಿಸು...
    .accesskey = S

main-context-menu-image-info =
    .label = ಚಿತ್ರದ ಮಾಹಿತಿಯನ್ನು ನೋಡು
    .accesskey = f

main-context-menu-image-desc =
    .label = ವಿವರಣೆಯನ್ನು ನೋಡಿ (D)
    .accesskey = D

main-context-menu-video-save-as =
    .label = ವೀಡಿಯೋ ಅನ್ನು ಹೀಗೆ Save …
    .accesskey = v

main-context-menu-audio-save-as =
    .label = ಆಡಿಯೋ ಅನ್ನು ಹೀಗೆ ಉಳಿಸು…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = ಸ್ನ್ಯಾಪ್‌ಶಾಟ್ ಅನ್ನು ಹೀಗೆ ಉಳಿಸು…
    .accesskey = S

main-context-menu-video-email =
    .label = ವೀಡಿಯೊವನ್ನು ಇಮೈಲ್ ಮಾಡಿ…
    .accesskey = a

main-context-menu-audio-email =
    .label = Email ಆಡಿಯೊ…
    .accesskey = a

main-context-menu-plugin-play =
    .label = ಈ ಪ್ಲಗ್ಇನ್ ಅನ್ನು ಸಕ್ರಿಯಗೊಳಿಸು
    .accesskey = c

main-context-menu-plugin-hide =
    .label = ಈ ಪ್ಲಗ್ಇನ್ ಅನ್ನು ಅಡಗಿಸು
    .accesskey = H

main-context-menu-send-to-device =
    .label = ಪುಟವನ್ನು ಸಾಧನಕ್ಕೆ ಕಳುಹಿಸು
    .accesskey = D

main-context-menu-view-background-image =
    .label = ಹಿನ್ನಲೆಯ ಚಿತ್ರವನ್ನು ನೋಡು
    .accesskey = w

main-context-menu-keyword =
    .label = ಈ ಹುಡುಕಾಟಕ್ಕೆ ಒಂದು ಮುಖ್ಯಪದವನ್ನು ಸೇರಿಸು...
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = ಕೊಂಡಿಯನ್ನು ಸಾಧನಕ್ಕೆ ಕಳುಹಿಸು
    .accesskey = D

main-context-menu-frame =
    .label = ಈ ಚೌಕಟ್ಟು
    .accesskey = h

main-context-menu-frame-show-this =
    .label = ಕೇವಲ ಈ ಚೌಕಟ್ಟನ್ನು ಮಾತ್ರ ತೋರಿಸು
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = ಚೌಕಟ್ಟನ್ನು ಹೊಸ ಹಾಳೆಯಲ್ಲಿ ತೆರೆ
    .accesskey = T

main-context-menu-frame-open-window =
    .label = ಚೌಕಟ್ಟನ್ನು ಹೊಸ Window ಯಲ್ಲಿ ತೆರೆಯಿರಿ
    .accesskey = W

main-context-menu-frame-reload =
    .label = ಚೌಕಟ್ಟನ್ನು ಮತ್ತೊಮ್ಮೆ ಲೋಡ್‍ ಮಾಡು
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = ಈ ಚೌಕಟ್ಟನ್ನು ಪುಟಗುರುತು ಮಾಡು
    .accesskey = m

main-context-menu-frame-save-as =
    .label = ಚೌಕಟ್ಟನ್ನು ಹೀಗೆ ಉಳಿಸು...
    .accesskey = F

main-context-menu-frame-print =
    .label = ಚೌಕಟ್ಟನ್ನು ಮುದ್ರಿಸು…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = ಚೌಕಟ್ಟಿನ ಮೂಲವನ್ನು ನೋಡು
    .accesskey = V

main-context-menu-frame-view-info =
    .label = ಚೌಕಟ್ಟಿನ ಮಾಹಿತಿಯನ್ನು ನೋಡು
    .accesskey = I

main-context-menu-view-selection-source =
    .label = ಆಯ್ಕೆಯ ಮೂಲವನ್ನು ನೋಡು
    .accesskey = e

main-context-menu-view-page-source =
    .label = ಪುಟದ ಮೂಲವನ್ನು ನೋಡು
    .accesskey = V

main-context-menu-view-page-info =
    .label = ಪುಟದ ಮಾಹಿತಿಯನ್ನು ನೋಡು
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = ಪಠ್ಯದ ದಿಕ್ಕನ್ನು ಬದಲಾಯಿಸು
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = ಪುಟದ ದಿಕ್ಕನ್ನು ಬದಲಾಯಿಸು
    .accesskey = D

main-context-menu-inspect-element =
    .label = ಪರೀಕ್ಷಕ ಘಟಕ
    .accesskey = Q

main-context-menu-eme-learn-more =
    .label = ಹೆಚ್ಚು ಕಲಿಯಿರಿ DRM ಬಗ್ಗೆ…
    .accesskey = D

