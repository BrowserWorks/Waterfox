# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } – Megosztásjelző
webrtc-indicator-window =
    .title = { -brand-short-name } – Megosztásjelző

## Used as list items in sharing menu

webrtc-item-camera = kamera
webrtc-item-microphone = mikrofon
webrtc-item-audio-capture = lap hangja
webrtc-item-application = alkalmazás
webrtc-item-screen = képernyő
webrtc-item-window = ablak
webrtc-item-browser = lap

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Ismeretlen eredet

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Eszközöket megosztó lapok
    .accesskey = E

webrtc-sharing-window = Egy másik alkalmazásablakot oszt meg.
webrtc-sharing-browser-window = Megosztja a { -brand-short-name(case: "accusative") }.
webrtc-sharing-screen = A teljes képernyőt megosztja.
webrtc-stop-sharing-button = Megosztás leállítása
webrtc-microphone-unmuted =
    .title = Mikrofon kikapcsolása
webrtc-microphone-muted =
    .title = Mikrofon bekapcsolása
webrtc-camera-unmuted =
    .title = Kamera kikapcsolása
webrtc-camera-muted =
    .title = Kamera bekapcsolása
webrtc-minimize =
    .title = A jelző minimalizálása

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Megosztja a kameráját. Kattintson a megosztási beállításokhoz.
webrtc-microphone-system-menu =
    .label = Megosztja a mikrofonját. Kattintson a megosztási beállításokhoz.
webrtc-screen-system-menu =
    .label = Megosztja a képernyőjét vagy egy ablakot. Kattintson a megosztási beállításokhoz.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Kamerája és mikrofonja meg van osztva. Kattintson a megosztási beállításokhoz.
webrtc-indicator-sharing-camera =
    .tooltiptext = Kamerája meg van osztva. Kattintson a megosztási beállításokhoz.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Mikrofonja meg van osztva. Kattintson a megosztási beállításokhoz.
webrtc-indicator-sharing-application =
    .tooltiptext = Egy alkalmazás meg van osztva. Kattintson a megosztási beállításokhoz.
webrtc-indicator-sharing-screen =
    .tooltiptext = Képernyője meg van osztva. Kattintson a megosztási beállításokhoz.
webrtc-indicator-sharing-window =
    .tooltiptext = Egy ablak meg van osztva. Kattintson a megosztási beállításokhoz.
webrtc-indicator-sharing-browser =
    .tooltiptext = Egy lap meg van osztva. Kattintson a megosztási beállításokhoz.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Megosztás beállítása
webrtc-indicator-menuitem-control-sharing-on =
    .label = Megosztás beállítása ezen: „{ $streamTitle }”

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Kamera megosztása vele: „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Kamera megosztása { $tabCount } lappal
           *[other] Kamera megosztása { $tabCount } lappal
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Mikrofon megosztása vele: „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Mikrofon megosztása { $tabCount } lappal
           *[other] Mikrofon megosztása { $tabCount } lappal
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Alkalmazás megosztása vele: „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Alkalmazás megosztása { $tabCount } lappal
           *[other] Alkalmazás megosztása { $tabCount } lappal
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Képernyő megosztása vele: „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Képernyő megosztása { $tabCount } lappal
           *[other] Képernyő megosztása { $tabCount } lappal
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Ablak megosztása vele: „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Ablak megosztása { $tabCount } lappal
           *[other] Ablak megosztása { $tabCount } lappal
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Lap megosztása vele: „{ $streamTitle }”
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Lap megosztása { $tabCount } lappal
           *[other] Lap megosztása { $tabCount } lappal
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Engedélyezi, hogy a(z) { $origin } hallja a lap hangját?
webrtc-allow-share-camera = Engedélyezi, hogy a(z) { $origin } használja a kameráját?
webrtc-allow-share-microphone = Engedélyezi, hogy a(z) { $origin } használja a mikrofonját?
webrtc-allow-share-screen = Engedélyezi, hogy a(z) { $origin } lássa a képernyőjét?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Engedélyezi, hogy a(z) { $origin } más hangeszközöket használjon?
webrtc-allow-share-camera-and-microphone = Engedélyezi, hogy a(z) { $origin } használja a kameráját és mikrofonját?
webrtc-allow-share-camera-and-audio-capture = Engedélyezi, hogy a(z) { $origin } használja a kameráját, és hallgassa a lap hangját?
webrtc-allow-share-screen-and-microphone = Engedélyezi, hogy a(z) { $origin } használja a mikrofonját, és lássa a képernyőjét?
webrtc-allow-share-screen-and-audio-capture = Engedélyezi, hogy a(z) { $origin } hallja a lap hangját, és lássa a képernyőjét?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy hallgassa a lap hangját?
webrtc-allow-share-camera-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy hozzáférjen a kamerájához?
webrtc-allow-share-microphone-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy hozzáférjen a mikrofonjához?
webrtc-allow-share-screen-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy lássa a képernyőjét?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy hozzáférjen más hangeszközökhöz?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy hozzáférjen a kamerájához és mikrofonjához?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy hozzáférjen a kamerájához és a lap hangjához?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy hozzáférjen a kamerájához és lássa a képernyőjét?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Engedélyezi, hogy a { $origin } megengedje a(z) { $thirdParty } oldalnak, hogy hallgassa a lap hangját és lássa a képernyőjét?

##

webrtc-share-screen-warning = Csak azokkal az oldalakkal ossza meg a képernyőit, melyekben megbízik. A megosztás lehetővé teszi a megtévesztő oldalaknak, hogy az ön nevében böngésszenek, és ellopják a személyes adatait.
webrtc-share-browser-warning = Csak azokkal az oldalakkal ossza meg a { -brand-short-name }ot, melyekben megbízik. A megosztás lehetővé teszi a megtévesztő oldalaknak, hogy az ön nevében böngésszenek, és ellopják a személyes adatait.

webrtc-share-screen-learn-more = További tudnivalók
webrtc-pick-window-or-screen = Válasszon ablakot vagy képernyőt
webrtc-share-entire-screen = Teljes képernyő
webrtc-share-pipe-wire-portal = Az operációs rendszer beállításainak használata
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = { $monitorIndex }. képernyő
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } ablak)
       *[other] { $appName } ({ $windowCount } ablak)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Engedélyezés
    .accesskey = E
webrtc-action-block =
    .label = Tiltás
    .accesskey = T
webrtc-action-always-block =
    .label = Tiltás mindig
    .accesskey = i
webrtc-action-not-now =
    .label = Most nem
    .accesskey = N

##

webrtc-remember-allow-checkbox = A döntés megjegyzése
webrtc-mute-notifications-checkbox = Webhely értesítéseinek elnémítása megosztás közben

webrtc-reason-for-no-permanent-allow-screen = A { -brand-short-name } nem teszi lehetővé a képernyőhöz történő állandó hozzáférést.
webrtc-reason-for-no-permanent-allow-audio = A { -brand-short-name } nem teszi lehetővé a lap hangjához történő állandó hozzáférést, a megosztandó lap megkérdezése nélkül.
webrtc-reason-for-no-permanent-allow-insecure = A kapcsolat az oldal felé nem biztonságos. A biztonsága érdekében, a { -brand-short-name } csak ebben a munkamenetben engedi elérni az oldalt.
