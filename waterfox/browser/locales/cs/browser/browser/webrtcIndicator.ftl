# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title =
    { -brand-short-name.case-status ->
        [with-cases] Ukazatel sdílení { -brand-short-name(case: "gen") }
       *[no-cases] Ukazatel sdílení aplikace { -brand-short-name }
    }
webrtc-indicator-window =
    .title =
        { -brand-short-name.case-status ->
            [with-cases] Ukazatel sdílení { -brand-short-name(case: "gen") }
           *[no-cases] Ukazatel sdílení aplikace { -brand-short-name }
        }

## Used as list items in sharing menu

webrtc-item-camera = kamera
webrtc-item-microphone = mikrofon
webrtc-item-audio-capture = audio panel
webrtc-item-application = aplikace
webrtc-item-screen = obrazovka
webrtc-item-window = okno
webrtc-item-browser = panel

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Neznámý původ

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Panely sdílených zařízení
    .accesskey = e

webrtc-sharing-window = Sdílíte okno jiné aplikace.
webrtc-sharing-browser-window =
    { -brand-short-name.case-status ->
        [with-cases] Sdílíte { -brand-short-name(case: "acc") }.
       *[no-cases] Sdílíte aplikaci { -brand-short-name }.
    }
webrtc-sharing-screen = Sdílíte celou vaši obrazovku.
webrtc-stop-sharing-button = Ukončit sdílení
webrtc-microphone-unmuted =
    .title = Vypnout mikrofon
webrtc-microphone-muted =
    .title = Zapnout mikrofon
webrtc-camera-unmuted =
    .title = Vypnout kameru
webrtc-camera-muted =
    .title = Zapnout kameru
webrtc-minimize =
    .title = Minimalizovat ukazatel

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Sdílíte svou kameru. Pro úpravu sdílení klepněte zde.
webrtc-microphone-system-menu =
    .label = Sdílíte svůj mikrofon. Pro úpravu sdílení klepněte zde.
webrtc-screen-system-menu =
    .label = Sdílíte okno nebo obrazovku. Pro úpravu sdílení klepněte zde.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Vaše kamera a mikrofon jsou sdíleny. Pro úpravu sdílení klepněte.
webrtc-indicator-sharing-camera =
    .tooltiptext = Vaše kamera je sdílena. Pro úpravu sdílení klepněte.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Váš mikrofon je sdílen. Pro úpravu sdílení klepněte.
webrtc-indicator-sharing-application =
    .tooltiptext = Vaše aplikace je sdílena. Pro úpravu sdílení klepněte.
webrtc-indicator-sharing-screen =
    .tooltiptext = Vaše obrazovka je sdílena. Pro úpravu sdílení klepněte.
webrtc-indicator-sharing-window =
    .tooltiptext = Vaše okno je sdíleno. Pro úpravu sdílení klepněte.
webrtc-indicator-sharing-browser =
    .tooltiptext = Panel je sdílen. Pro úpravu sdílení klepněte.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Ovládání sdílení
webrtc-indicator-menuitem-control-sharing-on =
    .label = Ovládání sdílení na „{ $streamTitle }“

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Sdílet kameru s „{ $streamTitle }“
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Sdílení kamery s { $tabCount } panelem
            [few] Sdílení kamery s { $tabCount } panely
           *[other] Sdílení kamery s { $tabCount } panely
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Sdílet mikrofon s „{ $streamTitle }“
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Sdílení mikrofonu s { $tabCount } panelem
            [few] Sdílení mikrofonu s { $tabCount } panely
           *[other] Sdílení mikrofonu s { $tabCount } panely
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Sdílet aplikaci s „{ $streamTitle }“
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Sdílet aplikaci s { $tabCount } panelem
            [few] Sdílet aplikaci s { $tabCount } panely
           *[other] Sdílet aplikaci s { $tabCount } panely
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Sdílet obrazovku s „{ $streamTitle }“
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Sdílení obrazovky s { $tabCount } panelem
            [few] Sdílení obrazovky s { $tabCount } panely
           *[other] Sdílení obrazovky s { $tabCount } panely
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Sdílet okno s „{ $streamTitle }“
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Sdílení okna s { $tabCount } panelem
            [few] Sdílení okna s { $tabCount } panely
           *[other] Sdílení okna s { $tabCount } panely
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Sdílet panel s „{ $streamTitle }“
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Sdílení panelu s { $tabCount } panelem
            [few] Sdílení panelu s { $tabCount } panely
           *[other] Sdílení panelu s { $tabCount } panely
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Chcete serveru { $origin } povolit poslouchat zvuky z tohoto panelu?
webrtc-allow-share-camera = Chcete serveru { $origin } povolit používat vaši kameru?
webrtc-allow-share-microphone = Chcete serveru { $origin } povolit používat váš mikrofon?
webrtc-allow-share-screen = Chcete serveru { $origin } povolit vidět vaši obrazovku?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Chcete serveru { $origin } povolit používat další zařízení pro výstup zvuku?
webrtc-allow-share-camera-and-microphone = Chcete serveru { $origin } povolit používat vaší webkameru a mikrofon?
webrtc-allow-share-camera-and-audio-capture = Chcete serveru { $origin } povolit používat vaší webkameru a poslouchat zvuky z tohoto panelu?
webrtc-allow-share-screen-and-microphone = Chcete serveru { $origin } povolit používat váš mikrofon a vidět vaši obrazovku?
webrtc-allow-share-screen-and-audio-capture = Chcete serveru { $origin } povolit poslouchat zvuky z tohoto panelu a vidět vaši obrazovku?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } poslouchat zvuky z tohoto panelu?
webrtc-allow-share-camera-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } používat vaši webkameru?
webrtc-allow-share-microphone-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } používat váš mikrofon?
webrtc-allow-share-screen-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } vidět vaši obrazovku?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } používat další zařízení pro výstup zvuku?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } používat vaší webkameru a mikrofon?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } používat vaší webkameru a poslouchat zvuky z tohoto panelu?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } používat váš mikrofon a vidět vaši obrazovku?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Chcete serveru { $origin } povolit, aby umožnil { $thirdParty } poslouchat zvuky z tohoto panelu a vidět vaši obrazovku?

##

webrtc-share-screen-warning = Obrazovku sdílejte pouze se servery, kterým věříte. Sdílení může umožnit klamavým stránkám sledovat vaše prohlížení a ukrást vaše osobní data.
webrtc-share-browser-warning =
    { -brand-short-name.case-status ->
        [with-cases] { -brand-short-name(case: "acc") } sdílejte pouze se servery, kterým věříte. Sdílení může umožnit klamavým stránkám sledovat vaše prohlížení a ukrást vaše osobní data.
       *[no-cases] Aplikaci { -brand-short-name } sdílejte pouze se servery, kterým věříte. Sdílení může umožnit klamavým stránkám sledovat vaše prohlížení a ukrást vaše osobní data.
    }

webrtc-share-screen-learn-more = Zjistit více
webrtc-pick-window-or-screen = Vyberte okno nebo obrazovku
webrtc-share-entire-screen = Celou obrazovku
webrtc-share-pipe-wire-portal = Použít nastavení operačního systému
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Obrazovka { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } okno)
        [few] { $appName } ({ $windowCount } okna)
       *[other] { $appName } ({ $windowCount } oken)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Povolit
    .accesskey = P
webrtc-action-block =
    .label = Blokovat
    .accesskey = B
webrtc-action-always-block =
    .label = Vždy blokovat
    .accesskey = V
webrtc-action-not-now =
    .label = Teď ne
    .accesskey = n

##

webrtc-remember-allow-checkbox = Zapamatovat si toto rozhodnutí
webrtc-mute-notifications-checkbox = Ztlumit oznámení ze serverů během sdílení

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } nemůže povolit trvalý přístup k vaší obrazovce.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } nemůže povolit trvalý přístup ke zvuku z vašich panelů bez dotazu, který panel sdílet.
webrtc-reason-for-no-permanent-allow-insecure = Vaše připojení k tomuto serveru není zabezpečené. Abychom vás ochránili, { -brand-short-name } povolí přístup pouze pro tuto relaci.
