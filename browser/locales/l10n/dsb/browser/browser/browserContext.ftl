# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Śěgniśo dołoj, aby historiju pokazał
           *[other] Klikniśo z pšawej tastu abo śěgniśo dołoj, aby historiju pokazał
        }

## Back

main-context-menu-back =
    .tooltiptext = Jaden bok slědk
    .aria-label = Slědk
    .accesskey = S

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Jaden bok doprědka
    .aria-label = Doprědka
    .accesskey = D

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Znowego
    .accesskey = Z

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stoj
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Bok składowaś ako…
    .accesskey = s

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Toś ten bok ako cytańske znamje składowaś
    .accesskey = c
    .tooltiptext = Toś ten bok ako cytańske znamje składowaś

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Toś ten bok ako cytańske znamje składowaś
    .accesskey = c
    .tooltiptext = Toś ten bok ({ $shortcut }) ako cytańske znamje składowaś

main-context-menu-bookmark-change =
    .aria-label = Toś to cytańske znamje wobźěłaś
    .accesskey = c
    .tooltiptext = Toś to cytańske znamje wobźěłaś

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Toś to cytańske znamje wobźěłaś
    .accesskey = c
    .tooltiptext = Toś to cytańske znamje ({ $shortcut }) wobźěłaś

main-context-menu-open-link =
    .label = Wótkaz wócyniś
    .accesskey = c

main-context-menu-open-link-new-tab =
    .label = Wótkaz w nowem rejtariku wócyniś
    .accesskey = r

main-context-menu-open-link-container-tab =
    .label = Wótkaz w nowem kontejnerowem rejtariku wócyniś
    .accesskey = t

main-context-menu-open-link-new-window =
    .label = Wótkaz w nowem woknje wócyniś
    .accesskey = n

main-context-menu-open-link-new-private-window =
    .label = Wótkaz w nowem priwatnem woknje wócyniś
    .accesskey = r

main-context-menu-bookmark-this-link =
    .label = Toś ten wótkaz ako cytańske znamje składowaś
    .accesskey = k

main-context-menu-save-link =
    .label = Wótkaz składowaś ako…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = Wótkaz do { -pocket-brand-name } składowaś
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = E-mailowu adresu kopěrowaś
    .accesskey = E

main-context-menu-copy-link =
    .label = Wótkazowu adresu kopěrowaś
    .accesskey = k

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Wótgraś
    .accesskey = t

main-context-menu-media-pause =
    .label = Pawza
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Bźez zuka
    .accesskey = B

main-context-menu-media-unmute =
    .label = Ze zukom
    .accesskey = z

main-context-menu-media-play-speed =
    .label = Wótgrawańska malsnošć
    .accesskey = m

main-context-menu-media-play-speed-slow =
    .label = Pómałem (0.5×)
    .accesskey = P

main-context-menu-media-play-speed-normal =
    .label = Normalny
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Malsna (1.25×)
    .accesskey = M

main-context-menu-media-play-speed-faster =
    .label = Malsnjej (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Wjelgin wusoko (2×)
    .accesskey = W

main-context-menu-media-loop =
    .label = Awtomatiski wóspjetowaś
    .accesskey = A

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Wóźeńske elementy pokazaś
    .accesskey = W

main-context-menu-media-hide-controls =
    .label = Wóźeńske elementy schowaś
    .accesskey = w

##

main-context-menu-media-video-fullscreen =
    .label = Połna wobrazowka
    .accesskey = P

main-context-menu-media-video-leave-fullscreen =
    .label = Połnu wobrazowku spušćiś
    .accesskey = o

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Wobraz-we-wobrazu
    .accesskey = b

main-context-menu-image-reload =
    .label = Wobraz znowego zacytaś
    .accesskey = b

main-context-menu-image-view =
    .label = Wobraz pokazaś
    .accesskey = r

main-context-menu-video-view =
    .label = Wideo pokazaś
    .accesskey = d

main-context-menu-image-copy =
    .label = Wobraz kopěrowaś
    .accesskey = r

main-context-menu-image-copy-location =
    .label = Wobrazowu adresu kopěrowaś
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Wideowu adresu kopěrowaś
    .accesskey = i

main-context-menu-audio-copy-location =
    .label = Adresu awdiodataje kopěrowaś
    .accesskey = u

main-context-menu-image-save-as =
    .label = Wobraz składowaś ako…
    .accesskey = r

main-context-menu-image-email =
    .label = Wobraz e-mailowaś…
    .accesskey = b

main-context-menu-image-set-as-background =
    .label = Ako desktopowu slězynu nastajiś…
    .accesskey = A

main-context-menu-image-info =
    .label = Info wó wobrazu pokazaś
    .accesskey = w

main-context-menu-image-desc =
    .label = Wopisanje pokazaś
    .accesskey = o

main-context-menu-video-save-as =
    .label = Wideo składować ako…
    .accesskey = d

main-context-menu-audio-save-as =
    .label = Awdiodataju składowaś ako…
    .accesskey = A

main-context-menu-video-image-save-as =
    .label = Foto wobrazowki składowaś ako…
    .accesskey = F

main-context-menu-video-email =
    .label = Wideo e-mailowaś…
    .accesskey = m

main-context-menu-audio-email =
    .label = Awdiodataju e-mailowaś…
    .accesskey = i

main-context-menu-plugin-play =
    .label = Toś ten tykac aktiwěrowaś
    .accesskey = t

main-context-menu-plugin-hide =
    .label = Toś ten tykac schowaś
    .accesskey = h

main-context-menu-save-to-pocket =
    .label = Bok do { -pocket-brand-name } składowaś
    .accesskey = k

main-context-menu-send-to-device =
    .label = Bok na rěd pósłaś
    .accesskey = B

main-context-menu-view-background-image =
    .label = Slězynowy wobraz pokazaś
    .accesskey = p

main-context-menu-generate-new-password =
    .label = Napórane gronidło wužywaś
    .accesskey = N

main-context-menu-keyword =
    .label = Gronidło za toś to pytanje pśidaś…
    .accesskey = G

main-context-menu-link-send-to-device =
    .label = Wótkaz na rěd pósłaś
    .accesskey = W

main-context-menu-frame =
    .label = Toś ten wobłuk
    .accesskey = T

main-context-menu-frame-show-this =
    .label = Jano w toś tom wobłuku pokazaś
    .accesskey = J

main-context-menu-frame-open-tab =
    .label = Wobłuk w nowem rejtariku wócyniś
    .accesskey = b

main-context-menu-frame-open-window =
    .label = Wobłuk w nowem woknje wócyniś
    .accesskey = c

main-context-menu-frame-reload =
    .label = Wobłuk znowego zacytaś
    .accesskey = z

main-context-menu-frame-bookmark =
    .label = Toś ten wobłuk ako cytańske znamje skladowaś
    .accesskey = b

main-context-menu-frame-save-as =
    .label = Wobłuk składowaś ako…
    .accesskey = b

main-context-menu-frame-print =
    .label = Wobłuk śišćaś…
    .accesskey = i

main-context-menu-frame-view-source =
    .label = Žrědłowy tekst wobłuka zwobrazniś
    .accesskey = b

main-context-menu-frame-view-info =
    .label = Info wó wobłuku pokazaś
    .accesskey = f

main-context-menu-view-selection-source =
    .label = Žrědłowy tekst wuběrka zwobrazniś
    .accesskey = t

main-context-menu-view-page-source =
    .label = Žrědłowy tekst boka pokazaś
    .accesskey = t

main-context-menu-view-page-info =
    .label = Info wó boku pokazaś
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Směr teksta pśešaltowaś
    .accesskey = t

main-context-menu-bidi-switch-page =
    .label = Směr boka pśešaltowaś
    .accesskey = b

main-context-menu-inspect-element =
    .label = Element pśepytowaś
    .accesskey = E

main-context-menu-inspect-a11y-properties =
    .label = Kakosći bźezbariernosći pśepytowaś

main-context-menu-eme-learn-more =
    .label = Zgóńśo wěcej wó DRM…
    .accesskey = D

