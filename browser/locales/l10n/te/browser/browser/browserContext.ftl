# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] చరిత్రను చూడడానికి కిందకు లాగండి
           *[other] చరిత్రను చూడడానికి కుడి-క్లిక్ నొక్కండి లేదా కిందికి లాగండి
        }

## Back

main-context-menu-back =
    .tooltiptext = ఒక పేజీ వెనుకకు వెళ్ళండి
    .aria-label = వెనుకకు
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = ఒక పేజీ ముందుకు వెళ్ళండి
    .aria-label = ముందుకు
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = మళ్ళీ లోడుచేయి
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = ఆపివేయి
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = పేజీని ఇలా భద్రపరచు…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = ఈ పేజీని ఇష్టాంశముచేయి
    .accesskey = m
    .tooltiptext = ఈ పేజీను ఇష్టాంశముచేయుము

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = ఈ పేజీని ఇష్టాంశముచేయి
    .accesskey = m
    .tooltiptext = ఈ పేజీను ఇష్టాంశముచేయుము ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = ఈ ఇష్టాంశాన్ని సరిదిద్దు
    .accesskey = m
    .tooltiptext = ఈ ఇష్టాంశమును సవరించు

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = ఈ ఇష్టాంశాన్ని సరిదిద్దు
    .accesskey = m
    .tooltiptext = ఈ ఇష్టాంశమును సవరించు ({ $shortcut })

main-context-menu-open-link =
    .label = లింకును తెరువు
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = లింకుని కొత్త ట్యాబులో తెరువు
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = లింకును కొత్త కంటైనర్ ట్యాబులో తెరువు
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = లింకుని కొత్త విండోలో తెరువు
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = లింకుని కొత్త అంతరంగిక విండోలో తెరువు
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = ఈ లింకును ఇష్టాంశము చేయి
    .accesskey = L

main-context-menu-save-link =
    .label = లింకుని ఇలా భద్రపరచు…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = లంకెను { -pocket-brand-name }కు భద్రపరుచు
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = ఈమెయిలు చిరునామాను కాపీచేయి
    .accesskey = E

main-context-menu-copy-link =
    .label = లింకు స్థానాన్ని కాపీచేయి
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = ఆడించు
    .accesskey = P

main-context-menu-media-pause =
    .label = కొద్దిసేపు ఆపు
    .accesskey = P

##

main-context-menu-media-mute =
    .label = ధ్వని లేకుండా చేయి
    .accesskey = M

main-context-menu-media-unmute =
    .label = ధ్వనిని ప్రవేశపెట్టు
    .accesskey = m

main-context-menu-media-play-speed =
    .label = నడిపే వేగం
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = నిదానం (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = సాధారణం
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = వేగం (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = మరింత వేగం (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = హాస్యాస్పదం (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = లూప్
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = నియంత్రికలను చూపించు
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = నియంత్రికలు దాచు
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = నిండు తెర
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = నిండు తెరను వదలివెళ్ళు
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = బొమ్మలో-బొమ్మ
    .accesskey = u

main-context-menu-image-reload =
    .label = బొమ్మని మళ్ళీ లోడుచేయి
    .accesskey = R

main-context-menu-image-view =
    .label = బొమ్మని చూడండి
    .accesskey = I

main-context-menu-video-view =
    .label = వీడియోను చూడండి
    .accesskey = I

main-context-menu-image-copy =
    .label = బొమ్మని కాపీచేయి
    .accesskey = y

main-context-menu-image-copy-location =
    .label = బొమ్మ స్థానాన్ని కాపీచేయి
    .accesskey = o

main-context-menu-video-copy-location =
    .label = వీడియో స్థానాన్ని కాపీచేయి
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ధ్వని స్థానాన్ని కాపీచేయి
    .accesskey = o

main-context-menu-image-save-as =
    .label = బొమ్మని ఇలా భద్రపరచు…
    .accesskey = v

main-context-menu-image-email =
    .label = బొమ్మను ఈమెయిలు చేయి…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = డెస్క్‌టాపు వెనుతలంగా అమర్చు…
    .accesskey = S

main-context-menu-image-info =
    .label = బొమ్మ సమాచారాన్ని చూడండి
    .accesskey = f

main-context-menu-image-desc =
    .label = వివరణను చూడండి
    .accesskey = D

main-context-menu-video-save-as =
    .label = వీడియోను వేరే పేరుతో భద్రపరచు…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = ఆడియోను వేరే పేరుతో భద్రపరచు…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = స్నాప్‌షాట్ ఇలా భద్రపరుచు…
    .accesskey = S

main-context-menu-video-email =
    .label = వీడియోను ఈమెయిలు చేయి…
    .accesskey = a

main-context-menu-audio-email =
    .label = ఆడియోను ఈమెయిలు చేయి…
    .accesskey = a

main-context-menu-plugin-play =
    .label = ఈ ప్లగిన్ను చేతనించు
    .accesskey = c

main-context-menu-plugin-hide =
    .label = ఈ ప్లగిన్ను దాచు
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = { -pocket-brand-name }‌లో భద్రపరుచు
    .accesskey = k

main-context-menu-send-to-device =
    .label = పేజీని పరికరానికి పంపు
    .accesskey = D

main-context-menu-view-background-image =
    .label = వెనుతలపు బొమ్మని చూడండి
    .accesskey = w

main-context-menu-generate-new-password =
    .label = సృష్టించిన సంకేతపదాన్ని వాడు…
    .accesskey = G

main-context-menu-keyword =
    .label = ఈ శోధనకు కీలక పదాన్ని చేర్చండి…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = లంకెను పరికరానికి పంపు
    .accesskey = D

main-context-menu-frame =
    .label = ఈ ఫ్రేమ్
    .accesskey = h

main-context-menu-frame-show-this =
    .label = ఈ ఫ్రేమును మాత్రమే చూపించు
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = ఫ్రేముని కొత్త ట్యాబులో తెరువు
    .accesskey = T

main-context-menu-frame-open-window =
    .label = ఫ్రేముని కొత్త విండోలో తెరువు
    .accesskey = W

main-context-menu-frame-reload =
    .label = ఫ్రేమును మళ్ళీ లోడుచేయి
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = ఈ ఫ్రేమును ఇష్టాంశంగా చేయి
    .accesskey = m

main-context-menu-frame-save-as =
    .label = ఫ్రేముని ఇలా భద్రపరచు…
    .accesskey = F

main-context-menu-frame-print =
    .label = ఫ్రేమును ముద్రించు…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = ఫ్రేమ్ మూలాన్ని చూడండి
    .accesskey = V

main-context-menu-frame-view-info =
    .label = ఫ్రేము సమాచారాన్ని చూడండి
    .accesskey = I

main-context-menu-view-selection-source =
    .label = ఎంపిక మూలాన్ని చూడండి
    .accesskey = e

main-context-menu-view-page-source =
    .label = పేజీ మూలాన్ని చూడండి
    .accesskey = V

main-context-menu-view-page-info =
    .label = పేజీ సమాచారాన్ని చూడండి
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = పాఠ్య దిశను మార్చు
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = పేజీ దిశను మార్చు
    .accesskey = D

main-context-menu-inspect-element =
    .label = మూలకం విచారణచేయి
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = ప్రాప్యత లక్షణాలను పరిశీలించండి

main-context-menu-eme-learn-more =
    .label = DRM గురించి ఇంకా తెలుసుకోండి…
    .accesskey = D
