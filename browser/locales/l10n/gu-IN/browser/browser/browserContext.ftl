# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] ઇતિહાસ બતાવવા માટે નીચે ખેંચો
           *[other] ઇતિહાસ બતાવવા માટે જમણું ક્લિક કરો અથવા નીચે ખેંચો
        }

## Back

main-context-menu-back =
    .tooltiptext = એક પાનું પાછળ જાવ
    .aria-label = પાછળ
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = એક પાનું આગળ જાવ
    .aria-label = આગળ
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = પુનઃલાવો
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = અટકાવો
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = આ રીતે પૃષ્ઠ સાચવો ...
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = આ પાનું બુકમાર્ક કરો...
    .accesskey = m
    .tooltiptext = આ પાનાં ને બુકમાર્ક કરો

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = આ પાનું બુકમાર્ક કરો...
    .accesskey = m
    .tooltiptext = આ પાનાં ({ $shortcut }) ને બુકમાર્ક કરો

main-context-menu-bookmark-change =
    .aria-label = આ બુકમાર્કમાં ફેરફાર કરો
    .accesskey = m
    .tooltiptext = આ બુકમાર્ક માં ફેરફાર કરો

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = આ બુકમાર્કમાં ફેરફાર કરો
    .accesskey = m
    .tooltiptext = આ બુકમાર્ક ({ $shortcut }) માં ફેરફાર કરો

main-context-menu-open-link =
    .label = કડીને ખોલો
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = નવી ટૅબમાં કડી ખોલો
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = ન્યૂ કન્ટેઈનર ટૅબમાં કડી ખોલો
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = નવી વિન્ડોમાં કડી ખોલો
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = કડીને નવી ખાનગી વિન્ડોમાં ખોલો
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = આ કડી બુકમાર્ક કરો...
    .accesskey = L

main-context-menu-save-link =
    .label = કડી આ રીતે સંગ્રહો...
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = { -pocket-brand-name } પર લિંક સાચવો
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = ઈમેલ સરનામાની નકલ કરો
    .accesskey = E

main-context-menu-copy-link =
    .label = કડી સ્થાનની નકલ કરો
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = વગાડો
    .accesskey = P

main-context-menu-media-pause =
    .label = અટકાવો
    .accesskey = P

##

main-context-menu-media-mute =
    .label = મૂંગુ કરો
    .accesskey = M

main-context-menu-media-unmute =
    .label = મૂંગાપણું દૂર કરો
    .accesskey = m

main-context-menu-media-play-speed =
    .label = વગાડવાની ગતિ
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = ધીમો (0.5 ×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = સામાન્ય
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = ઝડપી (1.25 ×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = ઝડપી (1.5 ×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = હાસ્યાસ્પદ (2 ×)
    .accesskey = L

main-context-menu-media-loop =
    .label = ગાળો
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = નિયંત્રણો બતાવો
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = નિયંત્રણો છુપાવો
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = સંપૂર્ણ સ્ક્રીન
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = પૂર્ણ સ્ક્રીનમાંથી બહાર નીકળો
    .accesskey = u

main-context-menu-image-reload =
    .label = ઈમેજ પુનઃલાવો
    .accesskey = R

main-context-menu-image-view =
    .label = ચિત્ર જુઓ
    .accesskey = I

main-context-menu-video-view =
    .label = વીડિયો જુઓ
    .accesskey = i

main-context-menu-image-copy =
    .label = ચિત્રની નકલ કરો
    .accesskey = y

main-context-menu-image-copy-location =
    .label = ચિત્ર સ્થાનની નકલ કરો
    .accesskey = o

main-context-menu-video-copy-location =
    .label = વીડિયો સ્થાનની નકલ કરો
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ઓડિયો સ્થાનની નકલ કરો
    .accesskey = o

main-context-menu-image-save-as =
    .label = ચિત્ર આ રીતે સંગ્રહો...
    .accesskey = v

main-context-menu-image-email =
    .label = ઇમેલ ઇમેજ…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = ડેસ્કટોપ પાશ્વ ભાગ તરીકે સુયોજિત કરો...
    .accesskey = S

main-context-menu-image-info =
    .label = ઇમેજ જાણકારીને દર્શાવો
    .accesskey = f

main-context-menu-image-desc =
    .label = વર્ણનને જુઓ
    .accesskey = D

main-context-menu-video-save-as =
    .label = વીડિયો આ રીતે સંગ્રહો…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = ઓડિયો આ રીતે સંગ્રહો…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = ચિત્ર આ પ્રમાણે સંગ્રહો…
    .accesskey = S

main-context-menu-video-email =
    .label = ઇમેલ વીડિયો…
    .accesskey = a

main-context-menu-audio-email =
    .label = ઇમેલ ઓડિયો…
    .accesskey = a

main-context-menu-plugin-play =
    .label = આ પ્લગઇન સક્રિય કરો
    .accesskey = c

main-context-menu-plugin-hide =
    .label = આ પ્લગઇન છુપાવો
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = પૃષ્ઠને { -pocket-brand-name } પર સાચવો
    .accesskey = k

main-context-menu-send-to-device =
    .label = ઉપકરણ પર પૃષ્ઠ મોકલો
    .accesskey = D

main-context-menu-view-background-image =
    .label = પાશ્વ ભાગ ચિત્ર જુઓ
    .accesskey = w

main-context-menu-keyword =
    .label = આ શોધ માટે મુખ્ય શબ્દ એડ-ઓન...
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = ઉપકરણ પર લિંક મોકલો
    .accesskey = D

main-context-menu-frame =
    .label = આ ચોકઠું
    .accesskey = h

main-context-menu-frame-show-this =
    .label = માત્ર આ ચોકઠું જ બતાવો
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = નવી ટૅબમાં ચોકઠું ખોલો
    .accesskey = T

main-context-menu-frame-open-window =
    .label = નવી વિન્ડોમાં ચોકઠું ખોલો
    .accesskey = W

main-context-menu-frame-reload =
    .label = ચોકઠું પુનઃલાવો
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = આ ચોકઠું બુકમાર્ક કરો...
    .accesskey = m

main-context-menu-frame-save-as =
    .label = ચોકઠું આ રીતે સંગ્રહો...
    .accesskey = F

main-context-menu-frame-print =
    .label = ચોકઠું છાપો...
    .accesskey = P

main-context-menu-frame-view-source =
    .label = ચોકઠાં સ્રોત જુઓ
    .accesskey = V

main-context-menu-frame-view-info =
    .label = ચોકઠાં જાણકારી જુઓ
    .accesskey = I

main-context-menu-view-selection-source =
    .label = પસંદગી સ્રોત જુઓ
    .accesskey = e

main-context-menu-view-page-source =
    .label = પાનાં સ્રોત જુઓ
    .accesskey = V

main-context-menu-view-page-info =
    .label = પાનાં જાણકારી જુઓ
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = લખાણ દિશા બદલો
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = પાનાં દિશા બદલો
    .accesskey = D

main-context-menu-inspect-element =
    .label = ઘટકની તપાસ કરો
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = ઍક્સેસિબિલિટી ગુણધર્મોનું નિરીક્ષણ કરો

main-context-menu-eme-learn-more =
    .label = DRM વિશે વધુ શીખો…
    .accesskey = D

