# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } — wskaźnik udostępniania
webrtc-indicator-window =
    .title = { -brand-short-name } — wskaźnik udostępniania

## Used as list items in sharing menu

webrtc-item-camera = kamera
webrtc-item-microphone = mikrofon
webrtc-item-audio-capture = dźwięk karty
webrtc-item-application = aplikacja
webrtc-item-screen = ekran
webrtc-item-window = okno
webrtc-item-browser = karta

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Nieznane źródło

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Karty udostępniające zasoby
    .accesskey = K

webrtc-sharing-window = Inne okno aplikacji jest udostępniane.
webrtc-sharing-browser-window = { -brand-short-name } jest udostępniany.
webrtc-sharing-screen = Cały ekran jest udostępniany.
webrtc-stop-sharing-button = Zatrzymaj udostępnianie
webrtc-microphone-unmuted =
    .title = Wyłącz mikrofon
webrtc-microphone-muted =
    .title = Włącz mikrofon
webrtc-camera-unmuted =
    .title = Wyłącz kamerę
webrtc-camera-muted =
    .title = Włącz kamerę
webrtc-minimize =
    .title = Minimalizuj wskaźnik

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Obraz z kamery jest udostępniany. Kliknij, aby zarządzać udostępnianiem.
webrtc-microphone-system-menu =
    .label = Dźwięk z mikrofonu jest udostępniany. Kliknij, aby zarządzać udostępnianiem.
webrtc-screen-system-menu =
    .label = Okno lub ekran jest udostępniany. Kliknij, aby zarządzać udostępnianiem.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Obraz z kamery i dźwięk z mikrofonu są udostępniane. Kliknij, by zarządzać udostępnianiem.
webrtc-indicator-sharing-camera =
    .tooltiptext = Obraz z kamery jest udostępniany. Kliknij, by zarządzać udostępnianiem.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Dźwięk z mikrofonu jest udostępniany. Kliknij, by zarządzać udostępnianiem.
webrtc-indicator-sharing-application =
    .tooltiptext = Aplikacja jest udostępniana. Kliknij, by zarządzać udostępnianiem.
webrtc-indicator-sharing-screen =
    .tooltiptext = Obraz ekranu jest udostępniany. Kliknij, by zarządzać udostępnianiem.
webrtc-indicator-sharing-window =
    .tooltiptext = Obraz okna jest udostępniany. Kliknij, by zarządzać udostępnianiem.
webrtc-indicator-sharing-browser =
    .tooltiptext = Obraz karty jest udostępniany. Kliknij, by zarządzać udostępnianiem.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Preferencje udostępniania…
webrtc-indicator-menuitem-control-sharing-on =
    .label = Preferencje udostępniania karcie „{ $streamTitle }”

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Udostępnianie obrazu z kamery karcie „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Udostępnianie obrazu z kamery jednej karcie
            [few] Udostępnianie obrazu z kamery { $tabCount } kartom
           *[many] Udostępnianie obrazu z kamery { $tabCount } kartom
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Udostępnianie dźwięku z mikrofonu karcie „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Udostępnianie dźwięku z mikrofonu jednej karcie
            [few] Udostępnianie dźwięku z mikrofonu { $tabCount } kartom
           *[many] Udostępnianie dźwięku z mikrofonu { $tabCount } kartom
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Udostępnianie aplikacji karcie „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Udostępnianie aplikacji jednej karcie
            [few] Udostępnianie aplikacji { $tabCount } kartom
           *[many] Udostępnianie aplikacji { $tabCount } kartom
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Udostępnianie obrazu ekranu karcie „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Udostępnianie obrazu ekranu jednej karcie
            [few] Udostępnianie obrazu ekranu { $tabCount } kartom
           *[many] Udostępnianie obrazu ekranu { $tabCount } kartom
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Udostępnianie obrazu okna karcie „{ $streamTitle }”
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Udostępnianie obrazu okna jednej karcie
            [few] Udostępnianie obrazu okna { $tabCount } kartom
           *[many] Udostępnianie obrazu okna { $tabCount } kartom
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Udostępnianie obrazu karty karcie „{ $streamTitle }”
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Udostępnianie obrazu karty jednej karcie
            [few] Udostępnianie obrazu karty { $tabCount } kartom
           *[many] Udostępnianie obrazu karty { $tabCount } kartom
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Czy udostępnić dźwięk tej karty witrynie „{ $origin }”?
webrtc-allow-share-camera = Czy udostępnić obraz z kamery witrynie „{ $origin }”?
webrtc-allow-share-microphone = Czy udostępnić dźwięk z mikrofonu witrynie „{ $origin }”?
webrtc-allow-share-screen = Czy udostępnić obraz ekranu witrynie „{ $origin }”?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Czy zezwolić witrynie „{ $origin }” na używanie innych głośników?
webrtc-allow-share-camera-and-microphone = Czy udostępnić obraz z kamery i dźwięk z mikrofonu witrynie „{ $origin }”?
webrtc-allow-share-camera-and-audio-capture = Czy udostępnić obraz z kamery i dźwięk tej karty witrynie „{ $origin }”?
webrtc-allow-share-screen-and-microphone = Czy udostępnić dźwięk z mikrofonu i obraz ekranu witrynie „{ $origin }”?
webrtc-allow-share-screen-and-audio-capture = Czy udostępnić dźwięk tej karty i obraz ekranu witrynie „{ $origin }”?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie dźwięku tej karty witrynie „{ $thirdParty }”?
webrtc-allow-share-camera-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie obrazu z kamery witrynie „{ $thirdParty }”?
webrtc-allow-share-microphone-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie dźwięku z mikrofonu witrynie „{ $thirdParty }”?
webrtc-allow-share-screen-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie obrazu ekranu witrynie „{ $thirdParty }”?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie innych głośników witrynie „{ $thirdParty }”?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie obrazu z kamery i dźwięku z mikrofonu witrynie „{ $thirdParty }”?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie obrazu z kamery i dźwięku tej karty witrynie „{ $thirdParty }”?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie dźwięku z mikrofonu i obrazu ekranu witrynie „{ $thirdParty }”?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Czy zezwolić witrynie „{ $origin }” na udostępnienie dźwięku tej karty i obrazu ekranu witrynie „{ $thirdParty }”?

##

webrtc-share-screen-warning = Ekran udostępniaj wyłącznie stronom, którym ufasz. Udostępnianie umożliwia podejrzanym stronom przeglądanie sieci jako Ty i kradzież prywatnych danych.
webrtc-share-browser-warning = Program { -brand-short-name } udostępniaj wyłącznie stronom, którym ufasz. Udostępnianie umożliwia podejrzanym stronom przeglądanie sieci jako Ty i kradzież prywatnych danych.

webrtc-share-screen-learn-more = Więcej informacji
webrtc-pick-window-or-screen = wybierz okno lub ekran
webrtc-share-entire-screen = cały ekran
webrtc-share-pipe-wire-portal = Użyj ustawień systemu operacyjnego
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Ekran { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] Aplikacja „{ $appName }” (jedno okno)
        [few] Aplikacja „{ $appName }” ({ $windowCount } okna)
       *[many] Aplikacja „{ $appName }” ({ $windowCount } okien)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Udostępnij
    .accesskey = U
webrtc-action-block =
    .label = Blokuj
    .accesskey = B
webrtc-action-always-block =
    .label = Zawsze blokuj
    .accesskey = Z
webrtc-action-not-now =
    .label = Nie teraz
    .accesskey = N

##

webrtc-remember-allow-checkbox = Pamiętaj tę decyzję
webrtc-mute-notifications-checkbox = Nie wyświetlaj powiadomień ze stron podczas udostępniania

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } nie mógł zezwolić na trwały dostęp do obrazu ekranu.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } nie mógł zezwolić na trwały dostęp do dźwięku karty bez pytania o to, której karty dźwięk udostępniać.
webrtc-reason-for-no-permanent-allow-insecure = Połączenie z tą stroną nie jest zabezpieczone. W celu ochrony użytkownika, { -brand-short-name } zezwoli na dostęp jedynie do czasu zamknięcia programu.
