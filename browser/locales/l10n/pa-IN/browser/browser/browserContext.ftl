# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] ਅਤੀਤ ਵੇਖਣ ਲਈ ਹੇਠਾਂ ਖਿੱਚੋ
           *[other] ਅਤੀਤ ਵੇਖਣ ਲਈ ਸੱਜਾ ਕਲਿੱਕ ਕਰੋ ਜਾਂ ਹੇਠਾਂ ਖਿੱਚੋ
        }

## Back

main-context-menu-back =
    .tooltiptext = ਇੱਕ ਪਿਛਲੇ ਸਫ਼ੇ 'ਤੇ ਜਾਓ
    .aria-label = ਪਿੱਛੇ
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = ਇੱਕ ਸਫ਼ੇ 'ਤੇ ਅੱਗੇ ਜਾਓ
    .aria-label = ਅੱਗੇ
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = ਮੁੜ ਲੋਡ ਕਰੋ
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = ਰੋਕੋ
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = …ਸਫ਼ੇ ਨੂੰ ਇੰਝ ਸੰਭਾਲੋ
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = ਇਹ ਸਫ਼ੇ ਨੂੰ ਬੁੱਕਮਾਰਕ ਕਰੋ
    .accesskey = m
    .tooltiptext = ਇਹ ਸਫ਼ੇ ਨੂੰ ਬੁੱਕਮਾਰਕ ਕਰੋ

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = ਇਹ ਸਫ਼ੇ ਨੂੰ ਬੁੱਕਮਾਰਕ ਕਰੋ
    .accesskey = m
    .tooltiptext = ਇਹ ਸਫ਼ੇ ਨੂੰ ਬੁੱਕਮਾਰਕ ਕਰੋ ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = ਇਹ ਬੁੱਕਮਾਰਕ ਨੂੰ ਸੋਧੋ
    .accesskey = m
    .tooltiptext = ਇਹ ਬੁੱਕਮਾਰਕ ਨੂੰ ਸੋਧੋ

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = ਇਹ ਬੁੱਕਮਾਰਕ ਨੂੰ ਸੋਧੋ
    .accesskey = m
    .tooltiptext = ਇਹ ਬੁੱਕਮਾਰਕ ਨੂੰ ਸੋਧੋ ({ $shortcut })

main-context-menu-open-link =
    .label = ਲਿੰਕ ਨੂੰ ਖੋਲ੍ਹੋ
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = ਨਵੀਂ ਟੈਬ ‘ਚ ਖੋਲ੍ਹੋ
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = ਲਿੰਕ ਨੂੰ ਨਵੀਂ ਕਨਟੇਨਰ ਟੈਬ ‘ਚ ਖੋਲ੍ਹੋ
    .accesskey = C

main-context-menu-open-link-new-window =
    .label = ਨਵੀਂ ਵਿੰਡੋ ‘ਚ ਖੋਲ੍ਹੋ
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = ਲਿੰਕ ਨੂੰ ਨਵੀਂ ਪ੍ਰਾਈਵੇਟ ਵਿੰਡੋ ‘ਚ ਖੋਲ੍ਹੋ
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = ਇਹ ਲਿੰਕ ਨੂੰ ਬੁੱਕਮਾਰਕ ਕਰੋ
    .accesskey = L

main-context-menu-save-link =
    .label = …ਲਿੰਕ ਨੂੰ ਇੰਝ ਸੰਭਾਲੋ
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = ਲਿੰਕ ਨੂੰ { -pocket-brand-name } ਵਿੱਚ ਸੰਭਾਲੋ
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = ਈਮੇਲ ਐਡਰੈੱਸ ਨੂੰ ਕਾਪੀ ਕਰੋ
    .accesskey = E

main-context-menu-copy-link =
    .label = ਲਿੰਕ ਟਿਕਾਣੇ ਨੂੰ ਕਾਪੀ ਕਰੋ
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = ਚਲਾਓ
    .accesskey = P

main-context-menu-media-pause =
    .label = ਵਿਰਾਮ
    .accesskey = P

##

main-context-menu-media-mute =
    .label = ਚੁੱਪ
    .accesskey = M

main-context-menu-media-unmute =
    .label = ਸੁਣਾਓ
    .accesskey = m

main-context-menu-media-play-speed =
    .label = ਚੱਲਣ ਦੀ ਗਤੀ
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = ਹੌਲੀ (0.5×)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = ਸਧਾਰਨ
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = ਤੇਜ਼ (1.25×)
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = ਹੋਰ ਤੇਜ਼ (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = ਨ੍ਹੇਰੀ ਵਾਂਗ (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = ਲੂਪ
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = ਕੰਟਰੋਲ ਵੇਖੋ
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = ਕੰਟਰੋਲ ਨੂੰ ਓਹਲੇ ਕਰੋ
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = ਪੂਰੀ ਸਕਰੀਨ
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = ਪੂਰੀ ਸਕਰੀਨ ਬੰਦ ਕਰੋ
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = ਤਸਵੀਰ-‘ਚ-ਤਸਵੀਰ
    .accesskey = u

main-context-menu-image-reload =
    .label = ਚਿੱਤਰ ਨੂੰ ਮੁੜ-ਲੋਡ ਕਰੋ
    .accesskey = R

main-context-menu-image-view =
    .label = ਇੱਕਲੇ ਚਿੱਤਰ ਨੂੰ ਵੇਖੋ
    .accesskey = I

main-context-menu-video-view =
    .label = ਵੀਡੀਓ ਨੂੰ ਵੇਖੋ
    .accesskey = I

main-context-menu-image-copy =
    .label = ਚਿੱਤਰ ਨੂੰ ਕਾਪੀ ਕਰੋ
    .accesskey = y

main-context-menu-image-copy-location =
    .label = ਚਿੱਤਰ ਟਿਕਾਣਾ ਨੂੰ ਕਾਪੀ ਕਰੋ
    .accesskey = o

main-context-menu-video-copy-location =
    .label = ਵੀਡੀਓ ਟਿਕਾਣੇ ਨੂੰ ਕਾਪੀ ਕਰੋ
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = ਆਡੀਓ ਟਿਕਾਣੇ ਨੂੰ ਕਾਪੀ ਕਰੋ
    .accesskey = o

main-context-menu-image-save-as =
    .label = …ਚਿੱਤਰ ਨੂੰ ਇੰਝ ਸੰਭਾਲੋ
    .accesskey = v

main-context-menu-image-email =
    .label = …ਚਿੱਤਰ ਨੂੰ ਈਮੇਲ ਕਰੋ
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = …ਡੈਸਕਟਾਪ ਬੈਕਗਰਾਊਡ ਵਾਂਗ ਸੈੱਟ ਕਰੋ
    .accesskey = S

main-context-menu-image-info =
    .label = ਚਿੱਤਰ ਦੀ ਜਾਣਕਾਰੀ ਨੂੰ ਵੇਖੋ
    .accesskey = f

main-context-menu-image-desc =
    .label = ਵੇਰਵਿਆਂ ਨੂੰ ਵੇਖੋ
    .accesskey = D

main-context-menu-video-save-as =
    .label = …ਵੀਡੀਓ ਨੂੰ ਇੰਝ ਸੰਭਾਲੋ
    .accesskey = v

main-context-menu-audio-save-as =
    .label = …ਆਡੀਓ ਨੂੰ ਇੰਝ ਸੰਭਾਲੋ
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = …ਸਨੈਪਸ਼ਾਟ ਨੂੰ ਇੰਝ ਨੂੰ ਸੰਭਾਲੋ
    .accesskey = S

main-context-menu-video-email =
    .label = …ਵੀਡੀਓ ਨੂੰ ਈਮੇਲ ਕਰੋ
    .accesskey = a

main-context-menu-audio-email =
    .label = …ਆਡੀਓ ਨੂੰ ਈਮੇਲ ਕਰੋ
    .accesskey = a

main-context-menu-plugin-play =
    .label = ਇਹ ਪਲੱਗਇਨ ਨੂੰ ਸਰਗਰਮ ਕਰੋ
    .accesskey = c

main-context-menu-plugin-hide =
    .label = ਇਹ ਪਲੱਗਇਨ ਨੂੰ ਓਹਲੇ
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = ਸਫ਼ੇ ਨੂੰ { -pocket-brand-name } ‘ਚ ਸੰਭਾਲੋ
    .accesskey = k

main-context-menu-send-to-device =
    .label = ਸਫ਼ੇ ਨੂੰ ਡਿਵਾਈਸ ‘ਤੇ ਭੇਜੋ
    .accesskey = D

main-context-menu-view-background-image =
    .label = ਬੈਕਗਰਾਊਂਡ ਚਿੱਤਰ ਨੂੰ ਵੇਖੋ
    .accesskey = w

main-context-menu-generate-new-password =
    .label = …ਤਿਆਰ ਕੀਤਾ ਪਾਸਵਰਡ ਵਰਤੋਂ
    .accesskey = G

main-context-menu-keyword =
    .label = ਇਸ ਖੋਜ ਲਈ ਸ਼ਬਦ ਦਿਓ…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = ਲਿੰਕ ਨੂੰ ਡਿਵਾਈਸ ਉੱਤੇ ਭੇਜੋ
    .accesskey = D

main-context-menu-frame =
    .label = ਇਹ ਫਰੇਮ
    .accesskey = h

main-context-menu-frame-show-this =
    .label = ਇਹ ਫਰੇਮ ਹੀ ਵੇਖੋ
    .accesskey = w

main-context-menu-frame-open-tab =
    .label = ਫਰੇਮ ਨੂੰ ਨਵੀਂ ਟੈਬ ‘ਚ ਖੋਲ੍ਹੋ
    .accesskey = T

main-context-menu-frame-open-window =
    .label = ਫਰੇਮ ਨੂੰ ਨਵੀਂ ਵਿੰਡੋ ‘ਚ ਖੋਲ੍ਹੋ
    .accesskey = W

main-context-menu-frame-reload =
    .label = ਫਰੇਮ ਨੂੰ ਮੁੜ ਲੋਡ ਕਰੋ
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = ਇਹ ਫਰੇਮ ਨੂੰ ਬੁੱਕਮਾਰਕ ਕਰੋ
    .accesskey = m

main-context-menu-frame-save-as =
    .label = …ਫਰੇਮ ਨੂੰ ਇੰਝ ਸੰਭਾਲੋ
    .accesskey = F

main-context-menu-frame-print =
    .label = …ਫਰੇਮ ਨੂੰ ਪਰਿੰਟ ਕਰੋ
    .accesskey = P

main-context-menu-frame-view-source =
    .label = ਫਰੇਮ ਦੇ ਸਰੋਤ ਨੂੰ ਵੇਖੋ
    .accesskey = V

main-context-menu-frame-view-info =
    .label = ਫਰੇਮ ਦੀ ਜਾਣਕਾਰੀ ਨੂੰ ਵੇਖੋ
    .accesskey = i

main-context-menu-view-selection-source =
    .label = ਚੋਣ ਦਾ ਸਰੋਤ ਵੇਖੋ
    .accesskey = e

main-context-menu-view-page-source =
    .label = ਸਫ਼ੇ ਦੇ ਸਰੋਤ ਨੂੰ ਵੇਖੋ
    .accesskey = V

main-context-menu-view-page-info =
    .label = ਸਫ਼ੇ ਦੀ ਜਾਣਕਾਰੀ ਨੂੰ ਵੇਖੋ
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = ਲਿਖਤ ਦੀ ਦਿਸ਼ਾ ਬਦਲੋ
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = ਸਫ਼ੇ ਦੀ ਦਿਸ਼ਾ ਬਦਲੋ
    .accesskey = g

main-context-menu-inspect-element =
    .label = ਐਲੀਮੈਂਟ ਜਾਂਚ
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = ਅਸੈੱਸਬਿਲਟੀ ਵਿਸ਼ੇਸ਼ਤਾ ਦੀ ਜਾਂਚ ਕਰੋ

main-context-menu-eme-learn-more =
    .label = …DRM ਬਾਰੇ ਹੋਰ ਜਾਣੋ
    .accesskey = D

