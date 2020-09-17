# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Ukubhrawuza kwangasese)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Ukubhrawuza kwangasese)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (Ukubhrawuza kwangasese)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Ukubhrawuza kwangasese)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Jonga inkcazelo yesayithi

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Vula iphanele yomyalezo wokufakela
urlbar-web-notification-anchor =
    .tooltiptext = Tshintsha enoba ungafumana isaziso kule sayithi
urlbar-eme-notification-anchor =
    .tooltiptext = Lawula ukusetyenziswa kwesoftwe ye-DRM
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Lawula ukwabelana ngemayikhrofowuni yakho nesayithi
urlbar-default-notification-anchor =
    .tooltiptext = Iphanele yomyalezo ovulekileyo
urlbar-geolocation-notification-anchor =
    .tooltiptext = Iphanele yesicelo yendawo evulekileyo
urlbar-translate-notification-anchor =
    .tooltiptext = Guqulela eli khasi
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Lawula ukwabelana kwakho ngeefestile okanye iskrini nesayithi
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Vula iphanele yomyalezo wokugcina ngaphandle kwe-intanethi
urlbar-password-notification-anchor =
    .tooltiptext = Vula iphanele yokulondoloza umyalezo wephasiwedi
urlbar-translated-notification-anchor =
    .tooltiptext = Lawula ukuguqulelwa kwekhasi
urlbar-plugins-notification-anchor =
    .tooltiptext = Lawula ukusetyenziswa kwezinto eziplagwayo
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Lawula ukwabelana ngekhamera yakho kunye/okanye imayikhrofowuni yakho nesayithi
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Gcina idatha kuGcino oluQhubekayo
urlbar-addons-notification-anchor =
    .tooltiptext = Vula iphanele yokongezelela umyalezo wokufakela

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Uyibhlokile inkcazelo yendawo kule webhusayithi.
urlbar-web-notifications-blocked =
    .tooltiptext = Uzibhlokile izaziso kule webhusayithi.
urlbar-camera-blocked =
    .tooltiptext = Uyibhlokile ikhamera yakho kule webhusayithi.
urlbar-microphone-blocked =
    .tooltiptext = Uyibhlokile imayikhrofoni yakho kule webhusayithi.
urlbar-screen-blocked =
    .tooltiptext = Uyibhlokile le webhusayithi ekwabelaneni ngesikrini sakho.
urlbar-persistent-storage-blocked =
    .tooltiptext = Ulubhlokile ugcino oluqhubekayo lwedatha kule webhusayithi.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Hlela le bhukhmakhi ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Faka ibhukhmakhi kweli khasi ({ $shortcut })

## Page Action Context Menu


## Auto-hide Context Menu

full-screen-autohide =
    .label = Fihla iiThulbha
    .accesskey = F
full-screen-exit =
    .label = Phuma kwimo yesikrini esizeleyo
    .accesskey = e

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Tshintsha iisethingi zokukhangela
search-one-offs-change-settings-compact-button =
    .tooltiptext = Tshintsha iisethingi zokukhangela
search-one-offs-context-open-new-tab =
    .label = Khangela KweNtsha Nethebhu
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Seta Ibe Ziinjini Ezisisiseko Zokukhangela
    .accesskey = Z

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-done-button =
    .label = Kugqityiwe

## Identity Panel

identity-connection-internal = Le yi-{ -brand-short-name } ekhuselekileyo indawo yolawulo.
identity-connection-file = Eli phepha liyagcinwa kwikhompyutha yakho.
identity-extension-page = Eli phepha lilowudwe kwisongezelelo.
identity-active-blocked = I-{ -brand-short-name } ibhloke iinxalenye zeli phepha ezingakhuselekanga.
identity-passive-loaded = Iinxalenye zeli phepha azikhuselekangae (njengemifanekiso).
identity-active-loaded = Ulucimile ukhuseleko kweli phepha.
identity-weak-encryption = Eli phepha lisebenzisa ukukhowuda okubuthathaka.
identity-insecure-login-forms = Iiogini ezifakwe kweli phepha zinokuba sengozini.
identity-permissions-reload-hint = Kusenokufuneka uphinde ulifake eli phepha ukuze utshintsho lubonakale.
identity-permissions-empty = Akunikanga le sayithi nayiphi na imvume ekhethekileyo.
identity-remove-cert-exception =
    .label = Susa Ezikhethekileyo
    .accesskey = S
identity-description-insecure = Uqhagamshelo lwakho kule sayithi alukho bucala. Inkcazelo oyifakayo inokubonwa ngabanye (njengeephaswedi, imiyalezo, iikhredit khadi, njl. njl.).
identity-description-insecure-login-forms = Inkcazelo yelogini oyifakayo kweli phepha ayikhuselekanga yaye ingalahleka.
identity-description-weak-cipher-intro = Uqhagamshelo kule webhsayithi lusebenzisa ukukhowuda okubuthathaka yaye alukho bucala.
identity-description-weak-cipher-risk = Abanye abantu banokujonga inkcazelo yakho okanye batshintshe indlela esebenza ngayo iwebhsayithi.
identity-description-active-blocked = I-{ -brand-short-name } ibhloke iinxalenye zeli phepha ezingakhuselekanga. <label data-l10n-name="link">Funda Ngakumbi</label>
identity-description-passive-loaded = Uqhagamshelo lwakho alukho bucala yaye inkcazelo owabelana ngayo nale sayithi inokubonwa ngabanye.
identity-description-passive-loaded-insecure = Le webhsayithi ineziqulatho ezingakhuselekanga (njengemifanekiso). <label data-l10n-name="link">Funda Ngakumbi</label>
identity-description-passive-loaded-mixed = Nangona i-{ -brand-short-name } ibhloke esinye isiqulatho, kusekho isiqulatho kwiphepha elingakhuselekanga (njengemifanekiso). <label data-l10n-name="link">Funda Ngakumbi</label>
identity-description-active-loaded = Le webhsayithi inesiqulatho esingakhuselekanga (njengezikripti) yaye uqhagamshelo lwakho kuyo alukho bucala.
identity-description-active-loaded-insecure = Inkcazelo owabelana ngayo nale sayithi inokujongwa ngabanye (njengeephaswedi, imiyalezo, iikhredit khadi, njl. njl.).
identity-learn-more =
    .value = Funda Ngakumbi
identity-disable-mixed-content-blocking =
    .label = Kunye nokhuseleko lusayekiwe
    .accesskey = K
identity-enable-mixed-content-blocking =
    .label = Vumela ukhuseleko
    .accesskey = V
identity-more-info-link-text =
    .label = Inkcazelo engaphezulu

## Window controls

browser-window-minimize-button =
    .tooltiptext = Nciphisa
browser-window-close-button =
    .tooltiptext = Vala

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Ikhamera yokubolekisana:
    .accesskey = I
popup-select-microphone =
    .value = Imayikhrofowuni yokubolekisana:
    .accesskey = I
popup-all-windows-shared = Zonke iiwindowu ezikwiskrini sakho ziya kwabiwa.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Khangela okanye ngenisa idilesi
urlbar-placeholder =
    .placeholder = Khangela okanye ngenisa idilesi
urlbar-remote-control-notification-anchor =
    .tooltiptext = Ibhrawza iphantsi kolawulo lwerimoti
urlbar-switch-to-tab =
    .value = Tshintshela kwithebhu:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Izolulo
urlbar-go-button =
    .tooltiptext = Yiya kwidilesi kwibha yendawo
urlbar-page-action-button =
    .tooltiptext = Okwenzeka kumakhasi

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ngoku siskrini esipheleleyo
fullscreen-warning-no-domain = Olu xwebhu ngoku lusiskrini esipheleleyo
fullscreen-exit-button = Phuma KwiSkrini Esipheleleyo (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Phuma KwiSkrini Esipheleleyo (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ilawula ipoyinta yakho. Cofa uEsc ukuze uphinde uthathe ulawulo.
pointerlock-warning-no-domain = Olu xwebhu lulawula ipoyinta yakho. Cofa uEsc ukuze uphinde uthathe ulawulo.
