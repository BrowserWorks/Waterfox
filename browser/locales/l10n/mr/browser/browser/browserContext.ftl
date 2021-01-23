# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] इतिहास दाखवण्याकरिता खाली ओढा
           *[other] इतिहास दाखवण्यासाठी उजवी-क्लिक द्या किंवा खाली ओढा
        }

## Back

main-context-menu-back =
    .tooltiptext = ऐक पृष्ठ मागे जा
    .aria-label = मागे
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = ऐक पृष्ठ पुढे जा
    .aria-label = पुढे
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = पुन्हा लोड करा
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = थांबा
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = पृष्ठ असे साठवा…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = या पृष्ठाला वाचणखूण लावा
    .accesskey = m
    .tooltiptext = या पृष्ठाला वाचनखूण लावा

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = या पृष्ठाला वाचणखूण लावा
    .accesskey = m
    .tooltiptext = या पृष्ठाला वाचनखूण लावा ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = ही वाचनखूण संपादीत करा
    .accesskey = m
    .tooltiptext = ही वाचनखूण संपादीत करा

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = ही वाचनखूण संपादीत करा
    .accesskey = m
    .tooltiptext = ही वाचनखूण ({ $shortcut }) संपादीत करा

main-context-menu-open-link =
    .label = दुवा उघडा
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = दुवा नवीन टॅबमध्ये उघडा
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = दुवा नवीन कंटेनर टॅब मध्ये उघडा
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = दुव्याला नवीन पटलात उघडा
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = नवीन खाजगी पटलात दुवा उघडा
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = ह्या दुव्याला वाचनखूण लावा
    .accesskey = L

main-context-menu-save-link =
    .label = दुवा असे साठवा…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = दुवा { -pocket-brand-name } मध्ये जतन करा
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = ईमेल पत्त्याची प्रत बनवा
    .accesskey = E

main-context-menu-copy-link =
    .label = दुवा ठिकाणाचे प्रत बनवा
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = चालवा
    .accesskey = P

main-context-menu-media-pause =
    .label = थांबवा
    .accesskey = P

##

main-context-menu-media-mute =
    .label = मंद करा
    .accesskey = M

main-context-menu-media-unmute =
    .label = मंद अशक्य करा
    .accesskey = m

main-context-menu-media-play-speed =
    .label = चालवायची गती
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = (0.5×) ने हळू करा
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = सामान्य
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = (1.25×)ने जलद करा
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = (1.5×)ने जलद करा
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = अतिशय जलद (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = लूप
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = कंट्रोल्स दाखवा
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = कंट्रोल्स लपवा
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = पडदाभर
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = पडदाभरपासून बाहेर पडा
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = पिक्चर-इन-पिक्चर
    .accesskey = u

main-context-menu-image-reload =
    .label = प्रतिमा पुन्हा लोड करा
    .accesskey = R

main-context-menu-image-view =
    .label = प्रतिमा पहा
    .accesskey = I

main-context-menu-video-view =
    .label = व्हिडीओ दृष्य
    .accesskey = i

main-context-menu-image-copy =
    .label = प्रतिमेची प्रत बनवा
    .accesskey = y

main-context-menu-image-copy-location =
    .label = प्रतिमा ठिकाणाची प्रत बनवा
    .accesskey = o

main-context-menu-video-copy-location =
    .label = व्हिडीओ ठिकाणाचे प्रत बनवा
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ऑडिओ ठिकाणाचे प्रत बनवा
    .accesskey = o

main-context-menu-image-save-as =
    .label = चित्र असे साठवा…
    .accesskey = v

main-context-menu-image-email =
    .label = प्रतिमा ईमेल करा…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = डेस्कटॉप पार्श्वभूमी म्हणून सेट करा…
    .accesskey = S

main-context-menu-image-info =
    .label = प्रतिमा माहितीचे दृष्य
    .accesskey = f

main-context-menu-image-desc =
    .label = दृश्य वर्णन
    .accesskey = D

main-context-menu-video-save-as =
    .label = व्हिडीओ असे साठवा…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = ऑडिओ असे साठवा…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = स्नॅपशॉटला असे साठवा…
    .accesskey = S

main-context-menu-video-email =
    .label = व्हिडिओ ईमेल करा…
    .accesskey = a

main-context-menu-audio-email =
    .label = ऑडिओ ईमेल करा…
    .accesskey = a

main-context-menu-plugin-play =
    .label = ह्या प्लगइनला सुरू करा
    .accesskey = c

main-context-menu-plugin-hide =
    .label = ह्या प्लगइनला लपवा
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = पृष्ठ { -pocket-brand-name } मध्ये जतन करा
    .accesskey = k

main-context-menu-send-to-device =
    .label = पृष्ठ उपकरणाला पाठवा
    .accesskey = D

main-context-menu-view-background-image =
    .label = पार्श्वभूमीतील चित्राचे दृष्य
    .accesskey = w

main-context-menu-keyword =
    .label = ह्या शोधकरिता एक मुख्य शब्द समाविष्ट करा…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = दुवा उपकरणाला पाठवा
    .accesskey = D

main-context-menu-frame =
    .label = ही चौकट
    .accesskey = h

main-context-menu-frame-show-this =
    .label = फक्त ही चौकट दाखवा
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = नवीन टॅबमध्ये चौकट उघडा
    .accesskey = T

main-context-menu-frame-open-window =
    .label = चौकटाला नवीन पटलात उघडा
    .accesskey = W

main-context-menu-frame-reload =
    .label = चौकट पुन्हा लोड करा
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = या चौकटाला वाचनखूण लावा
    .accesskey = m

main-context-menu-frame-save-as =
    .label = पटल असे साठवा…
    .accesskey = F

main-context-menu-frame-print =
    .label = पटलाची छपाई करा…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = चौकटीचे स्त्रोत पहा
    .accesskey = V

main-context-menu-frame-view-info =
    .label = चौकट माहिती पहा
    .accesskey = I

main-context-menu-view-selection-source =
    .label = निवडलेल्या भागाचा स्त्रोत पहा
    .accesskey = e

main-context-menu-view-page-source =
    .label = पृष्ठाचे स्रोत पहा
    .accesskey = V

main-context-menu-view-page-info =
    .label = पृष्ठ माहिती पहा
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = मजकुराची दिशा बदला
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = पृष्ठ दिशा बदला
    .accesskey = D

main-context-menu-inspect-element =
    .label = एलिमेंटची चौकशी करा
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = सुलभता गुणधर्मांची पाहणी करा

main-context-menu-eme-learn-more =
    .label = DRM बद्दल अधिक जाणून घ्या…
    .accesskey = D

