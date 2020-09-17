# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] வரலாற்றைப் பார்க்க கீழாக இழு
           *[other] வரலாற்றைப் பார்க்க வலதாக சொடுக்கு (அ) அழுத்தி இழு
        }

## Back

main-context-menu-back =
    .tooltiptext = ஒரு பக்கம் பின்செல்
    .aria-label = பின்செல்
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = ஒரு பக்கம் முன்செல்
    .aria-label = முன்செல்
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = மீளேற்று
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = நிறுத்து
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = இவ்வாறு சேமி…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = இப்பக்கத்தைப் புத்தகக்குறியிடு
    .accesskey = m
    .tooltiptext = பக்கத்தைப் புத்தகக்குறியிடு

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = இப்பக்கத்தைப் புத்தகக்குறியிடு
    .accesskey = m
    .tooltiptext = பக்கத்தைப் புத்தகக்குறியிடு ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = புத்தகக்குறியைத் திருத்து
    .accesskey = m
    .tooltiptext = இப்புத்தகக்குறியைத் தொகு

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = புத்தகக்குறியைத் திருத்து
    .accesskey = m
    .tooltiptext = இப்புத்தகக்குறியைத் தொகு ({ $shortcut })

main-context-menu-open-link =
    .label = இணைப்பைத் திற
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = இணைப்பை புதிய கீற்றில் திற
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = புதிய கலன் கீற்றில் திற
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = புதிய சாளரத்தில் இணைப்பைத் திற
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = புதிய கமுக்க சாளரத்தில் திற
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = இந்த இணைப்பை புத்தகக்குறியிடு
    .accesskey = L

main-context-menu-save-link =
    .label = தொடுப்பை இவ்வாறு சேமி…
    .accesskey = k

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = மின்னஞ்சல் முகவரியை நகலெடு
    .accesskey = E

main-context-menu-copy-link =
    .label = தொடுப்பை நகலெடு
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = இயக்கு
    .accesskey = P

main-context-menu-media-pause =
    .label = இடைநிறுத்து
    .accesskey = P

##

main-context-menu-media-mute =
    .label = ஒலி நீக்கு
    .accesskey = M

main-context-menu-media-unmute =
    .label = ஒலிக்கச் செய்
    .accesskey = m

main-context-menu-media-play-speed =
    .label = இயக்கு வேகம்
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = மெது (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = இயல்பான
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = வேகம் (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = வேகமாக (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = கேலியான (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = சுழற்சி
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = கட்டுப்பாடுகளைக் காட்டு
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = கட்டுப்பாடுகளை மறை
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = முழுத்திரை
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = வெளியேறுக
    .accesskey = u

main-context-menu-image-reload =
    .label = படத்தை மீளேற்று
    .accesskey = R

main-context-menu-image-view =
    .label = படத்தைக் காட்டு
    .accesskey = I

main-context-menu-video-view =
    .label = வீடியோவை காட்டு
    .accesskey = i

main-context-menu-image-copy =
    .label = படத்தை நகலெடு
    .accesskey = y

main-context-menu-image-copy-location =
    .label = பட இடத்தை நகலெடு
    .accesskey = o

main-context-menu-video-copy-location =
    .label = காணொளி இடத்தை நகலெடு
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ஒலி இடத்தை நகலெடு
    .accesskey = o

main-context-menu-image-save-as =
    .label = படத்தை இப்படி சேமி…
    .accesskey = v

main-context-menu-image-email =
    .label = படத்தை மின்னஞ்சல் செய்...
    .accesskey = ப

main-context-menu-image-set-as-background =
    .label = பணிமேடையின் பின்னணியாக அமை…
    .accesskey = S

main-context-menu-image-info =
    .label = படத் தகவலைப் பார்
    .accesskey = f

main-context-menu-image-desc =
    .label = விளக்கத்தை பார்க்க
    .accesskey = வ

main-context-menu-video-save-as =
    .label = நிகழ்படத்தை இப்படி சேமி…
    .accesskey = ச

main-context-menu-audio-save-as =
    .label = ஒலியை இவ்வாறு சேமி…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = திரைக்காப்பாகச் சேமி...
    .accesskey = த

main-context-menu-video-email =
    .label = மின்னஞ்சல் காணொளி...
    .accesskey = a

main-context-menu-audio-email =
    .label = ஒலி மின்னஞ்சல்...
    .accesskey = ம

main-context-menu-plugin-play =
    .label = இந்த செருகுநிரலைச் செயல்படுத்தவும்
    .accesskey = c

main-context-menu-plugin-hide =
    .label = இந்த செருகுநிரலை மறைக்கவும்
    .accesskey = H

main-context-menu-send-to-device =
    .label = சாதனத்திற்கு அனுப்பு
    .accesskey = D

main-context-menu-view-background-image =
    .label = பின்னணி படத்தைக் காட்டு
    .accesskey = w

main-context-menu-keyword =
    .label = இந்த தேடுதலுக்கு ஒரு முக்கியச் சொல்லை சேர்க்கவும்…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = சாதனத்திற்கு அனுப்பு
    .accesskey = D

main-context-menu-frame =
    .label = இந்த சட்டம்
    .accesskey = h

main-context-menu-frame-show-this =
    .label = இந்த சட்டத்தை மட்டும் காட்டு
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = சட்டத்தை புதிய கீற்றில் திற
    .accesskey = T

main-context-menu-frame-open-window =
    .label = புதிய சாளரத்தில் சட்டத்தைத் திற
    .accesskey = W

main-context-menu-frame-reload =
    .label = சட்டத்தை மீளேற்று
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = இந்த சட்டத்தை புத்தகக்குறியிடு
    .accesskey = m

main-context-menu-frame-save-as =
    .label = சட்டத்தை இப்படி சேமி…
    .accesskey = F

main-context-menu-frame-print =
    .label = சட்டத்தை அச்சிடு…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = சட்ட மூலத்தை காட்டு
    .accesskey = V

main-context-menu-frame-view-info =
    .label = சட்ட தகவலை காட்டு
    .accesskey = I

main-context-menu-view-selection-source =
    .label = தேர்ந்தெடுத்தல் மூலத்தைக் காட்டு
    .accesskey = e

main-context-menu-view-page-source =
    .label = பக்கத்தின் மூலத்தைக் காட்டு
    .accesskey = V

main-context-menu-view-page-info =
    .label = பக்க தகவலை காட்டு
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = உரைத் திசையை மாற்று
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = பக்கத் திசையை மாற்று
    .accesskey = D

main-context-menu-inspect-element =
    .label = உறுப்பு ஆய்வுசெய்
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = அணுகல்தன்மை பண்புகளை ஆராய்க

main-context-menu-eme-learn-more =
    .label = DRM பற்றி மேலும் அறிய…
    .accesskey = D

