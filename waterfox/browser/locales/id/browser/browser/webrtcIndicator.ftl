# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - Indikator Berbagi
webrtc-indicator-window =
    .title = { -brand-short-name } - Indikator Berbagi

## Used as list items in sharing menu

webrtc-item-camera = kamera
webrtc-item-microphone = mikrofone
webrtc-item-audio-capture = tab audio
webrtc-item-application = aplikasi
webrtc-item-screen = layar
webrtc-item-window = jendela
webrtc-item-browser = tab

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Sumber tidak dikenal

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Berbagi tab & perangkat
    .accesskey = p

webrtc-sharing-window = Anda membagikan jendela aplikasi lain.
webrtc-sharing-browser-window = Anda membagikan { -brand-short-name }.
webrtc-sharing-screen = Anda membagikan seluruh layar Anda.
webrtc-stop-sharing-button = Berhenti Berbagi
webrtc-microphone-unmuted =
    .title = Nonaktifkan mikrofon
webrtc-microphone-muted =
    .title = Aktifkan mikrofon
webrtc-camera-unmuted =
    .title = Nonaktifkan kamera
webrtc-camera-muted =
    .title = Aktifkan kamera
webrtc-minimize =
    .title = Minimalkan indikator

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Anda sedang membagikan kamera Anda. Klik untuk mengendalikan berbagi.
webrtc-microphone-system-menu =
    .label = Anda sedang membagikan mikrofon Anda. Klik untuk mengendalikan berbagi.
webrtc-screen-system-menu =
    .label = Anda sedang membagikan jendela atau layar Anda. Klik untuk mengendalikan berbagi.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Kamera dan mikrofon Anda sedang dibagikan. Klik untuk mengendalikan berbagi.
webrtc-indicator-sharing-camera =
    .tooltiptext = Kamera Anda sedang dibagikan. Klik untuk mengendalikan berbagi.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Mikrofon Anda sedang dibagikan. Klik untuk mengendalikan berbagi.
webrtc-indicator-sharing-application =
    .tooltiptext = Sebuah aplikasi sedang dibagikan. Klik untuk mengendalikan berbagi.
webrtc-indicator-sharing-screen =
    .tooltiptext = Layar Anda sedang dibagikan. Klik untuk mengendalikan berbagi.
webrtc-indicator-sharing-window =
    .tooltiptext = Sebuah jendela sedang dibagikan. Klik untuk mengendalikan berbagi.
webrtc-indicator-sharing-browser =
    .tooltiptext = Sebuah tab sedang dibagikan. Klik untuk mengendalikan berbagi.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Kendalikan Berbagi
webrtc-indicator-menuitem-control-sharing-on =
    .label = Kendali Berbagi pada "{ $streamTitle }"

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Berbagi Kamera dengan "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label = Berbagi Kamera dengan { $tabCount } tab

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Berbagi Mikrofon dengan "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label = Berbagi Mikrofon dengan { $tabCount } tab

webrtc-indicator-menuitem-sharing-application-with =
    .label = Berbagi Sebuah Aplikasi dengan "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label = Berbagi Sebuah Aplikasi dengan { $tabCount } tab

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Berbagi Layar dengan "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label = Berbagi Layar dengan { $tabCount } tab

webrtc-indicator-menuitem-sharing-window-with =
    .label = Berbagi Sebuah Jendela dengan "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label = Berbagi Sebuah Jendela dengan { $tabCount } tab

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Berbagi Tab dengan "{ $streamTitle }"
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label = Berbagi Tab dengan { $tabCount } tab

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Izinkan { $origin } untuk mendengarkan suara tab ini?
webrtc-allow-share-camera = Izinkan { $origin } untuk menggunakan kamera Anda?
webrtc-allow-share-microphone = Izinkan { $origin } untuk menggunakan mikrofon Anda?
webrtc-allow-share-screen = Izinkan { $origin } untuk melihat layar Anda?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Izinkan { $origin } untuk menggunakan pengeras suara lainnya?
webrtc-allow-share-camera-and-microphone = Izinkan { $origin } untuk menggunakan kamera dan mikrofon Anda?
webrtc-allow-share-camera-and-audio-capture = Izinkan { $origin } untuk menggunakan kamera dan mendengarkan suara tab ini?
webrtc-allow-share-screen-and-microphone = Izinkan { $origin } untuk menggunakan mikrofon dan melihat layar Anda?
webrtc-allow-share-screen-and-audio-capture = Izinkan { $origin } untuk mendengarkan suara tab ini dan melihat layar Anda?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } untuk mendengarkan suara tab ini?
webrtc-allow-share-camera-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } ke kamera Anda?
webrtc-allow-share-microphone-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } ke mikrofon Anda?
webrtc-allow-share-screen-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } untuk melihat layar Anda?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } ke pengeras suara lain?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } ke kamera dan mikrofon Anda?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } ke kamera Anda dan mendengarkan audio dari tab ini?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } ke mikrofon Anda dan melihat layar Anda?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Izinkan { $origin } untuk memberi akses kepada { $thirdParty } untuk mendengarkan audio dari tab ini dan melihat layar Anda?

##

webrtc-share-screen-warning = Hanya bagikan layar dengan situs yang Anda percaya. Berbagi layar memungkinkan situs penipuan untuk menjelajah sebagai Anda dan mencuri data pribadi Anda.
webrtc-share-browser-warning = Hanya bagikan { -brand-short-name } dengan situs yang Anda percaya. Berbagi memungkinkan situs penipuan untuk menjelajah sebagai Anda dan mencuri data pribadi Anda.

webrtc-share-screen-learn-more = Pelajari Lebih Lanjut
webrtc-pick-window-or-screen = Pilih Jendela atau Layar
webrtc-share-entire-screen = Seluruh layar
webrtc-share-pipe-wire-portal = Gunakan pengaturan sistem operasi
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Layar { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application = { $appName } ({ $windowCount } jendela)

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Izinkan
    .accesskey = I
webrtc-action-block =
    .label = Blokir
    .accesskey = B
webrtc-action-always-block =
    .label = Selalu blokir
    .accesskey = S
webrtc-action-not-now =
    .label = Jangan sekarang
    .accesskey = J

##

webrtc-remember-allow-checkbox = Ingat pilihan ini
webrtc-mute-notifications-checkbox = Bisukan notifikasi situs web ketika sedang berbagi

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } tidak bisa mengizinkan akses permanen ke layar Anda.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } tidak dapat mengizinkan akses audio tab secara permanen tanpa menanyakan tab mana yang dibagi.
webrtc-reason-for-no-permanent-allow-insecure = Sambungan ke situs ini tidak aman. Untuk melindungi Anda, { -brand-short-name } hanya akan mengizinkan akses untuk sesi ini saja.
