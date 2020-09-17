# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] इतिहास दिखाने के लिए पुल डाउन करें
           *[other] इतिहास दिखाने के लिए दाहिना क्लिक करें या पुल डाउन करें
        }

## Back

main-context-menu-back =
    .tooltiptext = एक पृष्ठ पीछे जाएँ
    .aria-label = पीछे
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = एक पृष्ठ आगे जाएँ
    .aria-label = आगे
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = फिर लोड करें
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = रूकें
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = पृष्ठ ऐसे सहेजें…
    .accesskey = पी

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = यह पृष्ठ बुकमार्कित करें
    .accesskey = m
    .tooltiptext = यह पृष्ठ बुकमार्कित करें

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = यह पृष्ठ बुकमार्कित करें
    .accesskey = m
    .tooltiptext = यह पृष्ठ बुकमार्कित करें ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = यह बुकमार्क संपादित करें
    .accesskey = m
    .tooltiptext = यह बुकमार्क संपादित करें

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = यह बुकमार्क संपादित करें
    .accesskey = m
    .tooltiptext = यह बुकमार्क संपादित करें ({ $shortcut })

main-context-menu-open-link =
    .label = कड़ी खोलें
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = नए टैब में कड़ी खोलें
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = नए पात्र टैब में कडी खोलें
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = नए विंडो में कड़ी खोलें
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = नए निजी विंडो में कड़ी खोलें
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = यह कड़ी बुकमार्कित करें
    .accesskey = L

main-context-menu-save-link =
    .label = कड़ी ऐसे सहेजें…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = { -pocket-brand-name } में लिंक को सहेजें
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = ईमेल पता की नकल लें
    .accesskey = E

main-context-menu-copy-link =
    .label = कड़ी स्थान की नक़ल लें
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = बजाएँ
    .accesskey = P

main-context-menu-media-pause =
    .label = ठहरें
    .accesskey = P

##

main-context-menu-media-mute =
    .label = मौन
    .accesskey = M

main-context-menu-media-unmute =
    .label = मौन समाप्त करें
    .accesskey = m

main-context-menu-media-play-speed =
    .label = खेल गति
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = धीमा (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = सामान्य
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = तेज (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = तेजी (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = बेतरतीब गति (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = लूप
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = नियंत्रण दिखाएँ
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = नियंत्रण छिपाएँ
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = पूर्ण स्क्रीन
    .accesskey = प

main-context-menu-media-video-leave-fullscreen =
    .label = पूर्ण स्क्रीन से निकलें
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = चित्र-में-चित्र
    .accesskey = u

main-context-menu-image-reload =
    .label = छवि फिर लोड करें
    .accesskey = R

main-context-menu-image-view =
    .label = छवि देखें
    .accesskey = I

main-context-menu-video-view =
    .label = वीडियो देखें
    .accesskey = i

main-context-menu-image-copy =
    .label = छवि की नकल लें
    .accesskey = y

main-context-menu-image-copy-location =
    .label = छवि स्थान की नक़ल लें
    .accesskey = o

main-context-menu-video-copy-location =
    .label = वीडियो स्थान की नकल लें
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ऑडियो स्थान की नकल लें
    .accesskey = o

main-context-menu-image-save-as =
    .label = छवि ऐसे सहेजें…
    .accesskey = v

main-context-menu-image-email =
    .label = छवि ईमेल करें…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = बतौर डेस्कटॉप पृष्ठभूमि सेट करें…
    .accesskey = S

main-context-menu-image-info =
    .label = छवि सूचना देखें
    .accesskey = f

main-context-menu-image-desc =
    .label = विवरण देखें
    .accesskey = D

main-context-menu-video-save-as =
    .label = ऐसे वीडियो सहेजें…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = ऐसे ऑडियो सहेजें…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = चित्र ऐसे सहेजें…
    .accesskey = S

main-context-menu-video-email =
    .label = वीडियो ईमेल करें…
    .accesskey = a

main-context-menu-audio-email =
    .label = ऑडियो ईमेल करें …
    .accesskey = a

main-context-menu-plugin-play =
    .label = इस प्लगिन सक्रिय करें
    .accesskey = c

main-context-menu-plugin-hide =
    .label = इस प्लगइन को छिपाएँ
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = { -pocket-brand-name } में पृष्ठ को सहेजें
    .accesskey = k

main-context-menu-send-to-device =
    .label = पृष्ठ को उपकरण में भेजें
    .accesskey = D

main-context-menu-view-background-image =
    .label = पृष्ठभूमि छवि देखें
    .accesskey = w

main-context-menu-generate-new-password =
    .label = जनित पासवर्ड का उपयोग करें…
    .accesskey = G

main-context-menu-keyword =
    .label = इस खोज के लिए बीजशब्द जोड़ें…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = लिंक को उपकरण में भेजें
    .accesskey = D

main-context-menu-frame =
    .label = यह फ्रेम
    .accesskey = h

main-context-menu-frame-show-this =
    .label = सिर्फ यह फ्रेम दिखाएँ
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = नए टैब में फ्रेम खोलें
    .accesskey = T

main-context-menu-frame-open-window =
    .label = नए विंडो में फ्रेम खोलें
    .accesskey = W

main-context-menu-frame-reload =
    .label = ढाँचा फिर लोड करें
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = यह फ्रेम बुकमार्कित करें
    .accesskey = m

main-context-menu-frame-save-as =
    .label = फ्रेम ऐसे सहेजें…
    .accesskey = F

main-context-menu-frame-print =
    .label = फ्रेम छापें…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = ढांचा स्रोत देखें
    .accesskey = V

main-context-menu-frame-view-info =
    .label = ढांचा सूचना देखें
    .accesskey = I

main-context-menu-view-selection-source =
    .label = चयनित स्रोत देखें
    .accesskey = ई

main-context-menu-view-page-source =
    .label = पृष्ठ स्रोत देखें
    .accesskey = प

main-context-menu-view-page-info =
    .label = पृष्ठ सूचना देखें
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = पाठ दिशा बदलें
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = पृष्ठ दिशा बदलें
    .accesskey = D

main-context-menu-inspect-element =
    .label = इंस्पेक्ट एलिमेंट
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = अभिगम्यता गुणों का निरीक्षण करें

main-context-menu-eme-learn-more =
    .label = DRM के बारे में और जानें...
    .accesskey = D

