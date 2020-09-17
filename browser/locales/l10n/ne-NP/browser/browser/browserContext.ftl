# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] इतिहास हेर्न तल तान्नुहोस
           *[other] इतिहास हेर्न बाँया क्लिक गर्नुहोस् अथवा तल तान्नुहोस
        }

## Back

main-context-menu-back =
    .tooltiptext = एक पृष्ठ पछाडि जानुहोस्
    .aria-label = पछाडि जाने
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = एक पृष्ठ अगाडि जानुहोस्
    .aria-label = अगाडि
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = पुनः लोड गर्नुहोस्
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = रोक्नुहोस्
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = यस रूपमा पृष्ठ सङ्ग्रह गर्नुहोस्...
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = यस पृष्ठमा पुस्तकचिनो लगाउनुहोस्
    .accesskey = m
    .tooltiptext = यस पृष्ठ मा पुस्तकचिनो लगाउनुहोस्

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = यस पृष्ठमा पुस्तकचिनो लगाउनुहोस्
    .accesskey = m
    .tooltiptext = यस पृष्ठ ({ $shortcut }) मा पुस्तकचिनो लगाउनुहोस्

main-context-menu-bookmark-change =
    .aria-label = यो पुस्तकचिनोलाई सम्पादन गर्नुहोस्
    .accesskey = m
    .tooltiptext = यस पुस्तकचिनोलाई सम्पादन गर्नुहोस्

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = यो पुस्तकचिनोलाई सम्पादन गर्नुहोस्
    .accesskey = m
    .tooltiptext = यस ({ $shortcut }) पुस्तकचिनोलाई सम्पादन गर्नुहोस्

main-context-menu-open-link =
    .label = लिङ्क खोल्नुहोस्
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = लिङ्कलाई नयाँ ट्याबमा खोल्नुहोस्
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = लिङ्कलाई नयाँ कन्टेनर ट्याबमा खोल्नुहोस्
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = लिङ्कलाई नयाँ सञ्झ्यालमा खोल्नुहोस्
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = लिङ्कलाई नयाँ निजी सञ्झ्यालमा खोल्नुहोस्
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = यो लिङ्कमा पुस्तकचिनो लगाउनुहोस्
    .accesskey = L

main-context-menu-save-link =
    .label = यस रूपमा लिङ्क सङ्ग्रह गर्नुहोस्...
    .accesskey = k

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = इमेल ठेगाना प्रतिलिपि गर्नुहोस्
    .accesskey = E

main-context-menu-copy-link =
    .label = लिङ्कको स्थान प्रतिलिपि गर्नुहोस्
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = प्ले
    .accesskey = P

main-context-menu-media-pause =
    .label = रोक्नुहोस्
    .accesskey = P

##

main-context-menu-media-mute =
    .label = आवाज बन्द गर्नुहोस्
    .accesskey = M

main-context-menu-media-unmute =
    .label = आवाज आउने बनाउनुहोस्
    .accesskey = m

main-context-menu-media-play-speed =
    .label = बजाउने गति
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = बिस्तार (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = सामान्य
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = छिटो (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = झनै छिटो (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = अति छिटो (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = लूप
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = नियन्त्रकहरू देखाउ
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = नियन्त्रकहरू लुकाउनुहोस्
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = पूरा पर्दा
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = पूरा पर्दा बन्द गर्नुहोस्
    .accesskey = u

main-context-menu-image-reload =
    .label = तस्विर पुनःलोड गर्नुहोस्
    .accesskey = R

main-context-menu-image-view =
    .label = तस्विर हेर्नुहोस्
    .accesskey = I

main-context-menu-video-view =
    .label = भिडियो हेर्नुहोस्
    .accesskey = i

main-context-menu-image-copy =
    .label = तस्विर प्रतिलिपि गर्नुहोस्
    .accesskey = y

main-context-menu-image-copy-location =
    .label = तस्बिरको स्थान प्रतिलिपि गर्नुहोस्
    .accesskey = o

main-context-menu-video-copy-location =
    .label = भिडियोको स्थान प्रतिलिपि गर्नुहोस्
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ध्वनिको स्थान प्रतिलिपि गर्नुहोस्
    .accesskey = o

main-context-menu-image-save-as =
    .label = यस रूपमा तस्विर सङ्ग्रह गर्नुहोस्…
    .accesskey = v

main-context-menu-image-email =
    .label = तस्विरलाई इमेल गर्नुहोस्
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = डेस्कटप पृष्ठभूमिको रूपमा बसाउनुहोस्…
    .accesskey = S

main-context-menu-image-info =
    .label = तस्विर सम्बन्धि जानकारी हेर्नुहोस्
    .accesskey = f

main-context-menu-image-desc =
    .label = विवरणहरू हेर्नुहोस्
    .accesskey = D

main-context-menu-video-save-as =
    .label = भिडियो अरू रूपमा सङ्ग्रह गर्नुहोस्…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = अडियोलाई यस रूपमा सङ्ग्रह गर्नुहोस्...
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = यस रूपमा स्न्यापसट सङ्ग्रह गर्नुहोस्...
    .accesskey = S

main-context-menu-video-email =
    .label = भिडियो इमेल गर्नुहोस्…
    .accesskey = a

main-context-menu-audio-email =
    .label = इमेल अडियो…
    .accesskey = a

main-context-menu-plugin-play =
    .label = यस प्लगिनलाई सक्षम पार्नुहोस्
    .accesskey = c

main-context-menu-plugin-hide =
    .label = यस प्लगिनलाई लुकाउनुहोस्
    .accesskey = H

main-context-menu-send-to-device =
    .label = पृष्ठलाई यन्त्रमा पठाउनुहोस्
    .accesskey = D

main-context-menu-view-background-image =
    .label = पृष्ठभूमिको तस्विर हेर्नुहोस्
    .accesskey = w

main-context-menu-keyword =
    .label = यस खोज‌का लागि एउटा खोजशब्द थप्नुहोस्…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = लिङ्कलाई यन्त्रमा पठाउनुहोस्
    .accesskey = D

main-context-menu-frame =
    .label = यो फ्रेम
    .accesskey = h

main-context-menu-frame-show-this =
    .label = यो फ्रेम मात्र देखाउनुहोस्
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = फ्रेमलाई नयाँ ट्याबमा खोल्नुहोस्
    .accesskey = T

main-context-menu-frame-open-window =
    .label = फ्रेमलाई नयाँ सञ्झ्यालमा खोल्नुहोस्
    .accesskey = W

main-context-menu-frame-reload =
    .label = फ्रेम पुनःलोड गर्नुहोस्
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = यो फ्रेमलाई पुस्तकचिनो हाल्नुहोस्
    .accesskey = m

main-context-menu-frame-save-as =
    .label = यसरूपमा फ्रेम सङ्ग्रह गर्नुहोस्…
    .accesskey = F

main-context-menu-frame-print =
    .label = फ्रेम प्रिन्ट गर्नुहोस्
    .accesskey = P

main-context-menu-frame-view-source =
    .label = फ्रेम श्रोत हेर्नुहोस्
    .accesskey = V

main-context-menu-frame-view-info =
    .label = फ्रेम जानकारी हेर्नुहोस्
    .accesskey = I

main-context-menu-view-selection-source =
    .label = छनोट श्रोत हेर्नुहोस्
    .accesskey = e

main-context-menu-view-page-source =
    .label = पृष्ठ श्रोत हेर्नुहोस्
    .accesskey = V

main-context-menu-view-page-info =
    .label = पृष्ठ सम्बन्धि जानकारी हेर्नुहोस्
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = अक्षरको दिशा बदल्नुहोस्
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = पृष्ठको दिशा बदल्नुहोस्
    .accesskey = D

main-context-menu-inspect-element =
    .label = इन्सपेक्ट इलेमेन्ट
    .accesskey = Q

main-context-menu-eme-learn-more =
    .label = DRM बारे थप जान्नुहोस्
    .accesskey = D

