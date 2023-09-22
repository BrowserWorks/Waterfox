# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - Indikator for deling
webrtc-indicator-window =
    .title = { -brand-short-name } - Indikator for deling

## Used as list items in sharing menu

webrtc-item-camera = kamera
webrtc-item-microphone = mikrofon
webrtc-item-audio-capture = lyd fra faneblad
webrtc-item-application = program
webrtc-item-screen = skærm
webrtc-item-window = vindue
webrtc-item-browser = faneblad

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Ukendt oprindelse

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Faneblade der deler enheder
    .accesskey = n

webrtc-sharing-window = Du deler et andet applikations-vindue.
webrtc-sharing-browser-window = Du deler { -brand-short-name }.
webrtc-sharing-screen = Du deler hele din skærm.
webrtc-stop-sharing-button = Stop deling
webrtc-microphone-unmuted =
    .title = Slå mikrofonen fra
webrtc-microphone-muted =
    .title = Slå mikrofonen til
webrtc-camera-unmuted =
    .title = Slå kameraet fra
webrtc-camera-muted =
    .title = Slå kameraet til
webrtc-minimize =
    .title = Minimer indikator

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Du deler dit kamera. Klik for at håndtere deling.
webrtc-microphone-system-menu =
    .label = Du deler din mikrofon. Klik for at håndtere deling.
webrtc-screen-system-menu =
    .label = Du deler et vindue eller en skærm. Klik for at håndtere deling.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Dit kamera og din mikrofon bliver delt. Klik for at kontrollere deling.
webrtc-indicator-sharing-camera =
    .tooltiptext = Dit kamera bliver delt. Klik for at kontrollere deling.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Din mikrofon bliver delt. Klik for at kontrollere deling.
webrtc-indicator-sharing-application =
    .tooltiptext = En applikation bliver delt. Klik for at kontrollere deling.
webrtc-indicator-sharing-screen =
    .tooltiptext = Din skærm bliver delt. Klik for at kontrollere deling.
webrtc-indicator-sharing-window =
    .tooltiptext = Et vindue bliver delt. Klik for at kontrollere deling.
webrtc-indicator-sharing-browser =
    .tooltiptext = Et faneblad bliver delt. Klik for at kontrollere deling.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Kontroller deling
webrtc-indicator-menuitem-control-sharing-on =
    .label = Kontroller deling med "{ $streamTitle }"

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Deler kamera med "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Deler kamera med { $tabCount } faneblad
           *[other] Deler kamera med { $tabCount } faneblade
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Deler mikrofon med "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Deler mikrofon med { $tabCount } faneblad
           *[other] Deler mikrofon med { $tabCount } faneblade
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Deler en applikation med "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Deler en applikation med { $tabCount } faneblad
           *[other] Deler applikationer med { $tabCount } faneblade
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Deler skærm med "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Deler skærm med { $tabCount } faneblad
           *[other] Deler skærm med { $tabCount } faneblade
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Deler et vindue med "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Deler et vindue med { $tabCount } faneblad
           *[other] Deler vinduer med { $tabCount } faneblade
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Deler et faneblad med "{ $streamTitle }"
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Deler et faneblad med { $tabCount } faneblad
           *[other] Deler faneblade med { $tabCount } faneblade
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Tillad { $origin } at lytte til lyden i dette faneblad?
webrtc-allow-share-camera = Tillad { $origin } at bruge dit kamera?
webrtc-allow-share-microphone = Tillad { $origin } at bruge din mikrofon?
webrtc-allow-share-screen = Tillad { $origin } at se din skærm?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Tillad { $origin } at bruge andre højtalere?
webrtc-allow-share-camera-and-microphone = Tillad { $origin } at bruge dit kamera og din mikrofon?
webrtc-allow-share-camera-and-audio-capture = Tillad { $origin } at bruge dit kamera og lytte til lyd i dette faneblad?
webrtc-allow-share-screen-and-microphone = Tillad { $origin } at bruge din mikrofon og se din skærm?
webrtc-allow-share-screen-and-audio-capture = Tillad { $origin } at lytte til lyd i dette faneblad og se din skærm?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Tillad { $origin } at give { $thirdParty } tilladelse til at lytte til lyden i dette faneblad?
webrtc-allow-share-camera-unsafe-delegation = Tillad { $origin } at give { $thirdParty } adgang til dit kamera?
webrtc-allow-share-microphone-unsafe-delegation = Tillad { $origin } at give { $thirdParty } adgang til din mikrofon?
webrtc-allow-share-screen-unsafe-delegation = Tillad { $origin } at give { $thirdParty } tilladelse til at se din skærm?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Tillad { $origin } at give { $thirdParty } adgang til andre højtalere?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Tillad { $origin } at give { $thirdParty } adgang til dit kamera og din mikrofon?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Tillad { $origin } at give { $thirdParty } adgang til dit kamera og til at lytte til lyden i dette faneblad?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Tillad { $origin } at give { $thirdParty } adgang til din mikrofon og til at se din skærm?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Tillad { $origin } at give { $thirdParty } tilladelse til at lytte til lyden i dette faneblad og til at se din skærm?

##

webrtc-share-screen-warning = Del kun din skærm med websteder, du stoler på. Deling kan gøre det muligt for vildledende websteder at stjæle dine private data og foregive at være dig på internettet.
webrtc-share-browser-warning = Del kun { -brand-short-name } med websteder, du stoler på. Deling kan gøre det muligt for vildledende websteder at stjæle dine private data og foregive at være dig på internettet.

webrtc-share-screen-learn-more = Læs mere
webrtc-pick-window-or-screen = Vælg vindue eller skærm
webrtc-share-entire-screen = Hele skærmen
webrtc-share-pipe-wire-portal = Brug operativsystemets indstillinger
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Skærm { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } vindue)
       *[other] { $appName } ({ $windowCount } vinduer)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Tillad
    .accesskey = T
webrtc-action-block =
    .label = Bloker
    .accesskey = B
webrtc-action-always-block =
    .label = Bloker altid
    .accesskey = a
webrtc-action-not-now =
    .label = Ikke nu
    .accesskey = N

##

webrtc-remember-allow-checkbox = Husk dette valg
webrtc-mute-notifications-checkbox = Slå websteds-beskeder fra ved deling

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } kan ikke tillade permanent adgang til din skærm.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } kan ikke tillade permanent adgang til dit faneblads lyd uden først at spørge, hvilket faneblad der skal deles.
webrtc-reason-for-no-permanent-allow-insecure = Din forbindelse til dette websted er ikke sikker. For at beskytte dig vil { -brand-short-name } kun tillade adgang for denne session.
