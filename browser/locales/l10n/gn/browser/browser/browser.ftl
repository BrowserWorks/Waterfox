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
    .data-title-private = { -brand-full-name } (Kundaha ñemi)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Kundaha ñemi)
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
    .data-title-private = { -brand-full-name } - (Kundaha ñemi)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Kundaha ñemi)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Ehecha marandu ko tenda pegua

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Eike ñe’ẽmondo ñemohenda ra’ãngarupápe
urlbar-web-notification-anchor =
    .tooltiptext = Emoambue eipotárõ oñemog̃uahẽ ndéve ñemomarandu ko ñandutirenda omondóva.
urlbar-midi-notification-anchor =
    .tooltiptext = Eike ta’ãngarupa MIDI pe
urlbar-eme-notification-anchor =
    .tooltiptext = Eñangareko DRM software jepuru rehe
urlbar-web-authn-anchor =
    .tooltiptext = Eike pe ñanduti mboajeha rupápe
urlbar-canvas-notification-anchor =
    .tooltiptext = Ñangareko Moñeĩ Oñeguehohẽ hag̃ua Canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Eipuruhína neñe’atãha ko tenda ndive
urlbar-default-notification-anchor =
    .tooltiptext = Eike ñe’ẽmondo rupápe
urlbar-geolocation-notification-anchor =
    .tooltiptext = Tendaite jerurepy rupa ijurujáva
urlbar-xr-notification-anchor =
    .tooltiptext = Embojuruja ñemoneĩ rupa añetegua ñanduti rehegua
urlbar-storage-access-anchor =
    .tooltiptext = Embojuruja kundaha rembiapo ñemoneĩ rupa
urlbar-translate-notification-anchor =
    .tooltiptext = Emoñe’ẽasa ko kuatiarogue
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Eñangareko moherakuã nerovetã térã mba’erechaha ko tenda ndive
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Eguereko ñangarekoha rekaha. Eikutu Esc eguereko jey hag̃ua pe ñangarekoha.
urlbar-password-notification-anchor =
    .tooltiptext = Eike ñe’ẽmondo rupa ñe’ẽñemi ñongatuhápe
urlbar-translated-notification-anchor =
    .tooltiptext = Eñangareko kuatiarogue ñe’ẽasa rehe
urlbar-plugins-notification-anchor =
    .tooltiptext = Mba’ejoajurã jepuru ñangareko
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Eñangareko moherakuã nerovetã térã mba’erechaha ko tenda ndive
urlbar-autoplay-notification-anchor =
    .tooltiptext = Embojuruja ñemboheta ijeheguíva ra’angarupa
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Mba’ekuaarã mboheta ñembyaty hi’arekuaávape
urlbar-addons-notification-anchor =
    .tooltiptext = Eike ñe’ẽmondo moĩmbaha ñemohenda ra’ãngarupápe
urlbar-tip-help-icon =
    .title = Eipota pytyvõ
urlbar-search-tips-confirm = Oĩma, aikumbýma
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Ñemoñe’ẽ:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Ehai sa’ive, ejuhuve: Eheka { $engineName } kundaharape rendaite guive.
urlbar-search-tips-redirect-2 = Eñepyrũ eheka kundaharape rendápe ehecha hag̃ua { $engineName } ñe’ẽporã ha ikundaha rembiasakue.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Techaukahakuéra
urlbar-search-mode-tabs = Tendaykekuéra
urlbar-search-mode-history = Tembiasakue

##

urlbar-geolocation-blocked =
    .tooltiptext = Ejokóma marandu ejuhukuaa hag̃ua ko ñanduti renda.
urlbar-xr-blocked =
    .tooltiptext = Ejokóma mba’e’okápe jeike añetegua ñanduti ko tendápe g̃uarã.
urlbar-web-notifications-blocked =
    .tooltiptext = Ejokóma ñemomarandu ko ñanduti rendápe g̃uarã.
urlbar-camera-blocked =
    .tooltiptext = Ejokóma ne ta’ãngamýi ko ñanduti rendápe g̃uarã.
urlbar-microphone-blocked =
    .tooltiptext = Ejokóma ne ñe’ẽatãha ko ñanduti rendápe g̃uarã.
urlbar-screen-blocked =
    .tooltiptext = Ejokóma ko ñanduti renda emoherakuã hag̃ua ne mba’erechaha.
urlbar-persistent-storage-blocked =
    .tooltiptext = Ejokóma mba’ekuaarã ñembyaty hi’aréva ko ñanduti renda pegua.
urlbar-popup-blocked =
    .tooltiptext = Ejokoukákuri ovetã apysẽva ko ñandutirendápe g̃uarã.
urlbar-autoplay-media-blocked =
    .tooltiptext = Ejokóma ñemboheta ijeheguíva mba’epu rehegua ko ñanduti rendápe g̃uarã.
urlbar-canvas-blocked =
    .tooltiptext = Ejokoukákuri kuaapy canvas rehegua ñeguenohẽ ko ñandutirendápe g̃uarã.
urlbar-midi-blocked =
    .tooltiptext = Ejokóma MIDI pe jeike ko ñanduti rendápe g̃uarã.
urlbar-install-blocked =
    .tooltiptext = Ejokóma tembipuru’i ñemohenda ko ñandutípe g̃uarã.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Ko techaukaha mbosako’i ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Kuatiarogue ({ $shortcut }) mbojoapy

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Embojuaju kundaharape rendáre
page-action-manage-extension =
    .label = Moĩmbaháre Ñangareko…
page-action-remove-from-urlbar =
    .label = Emboguete kundaharape rendágui
page-action-remove-extension =
    .label = Emboguete jepysokue

## Auto-hide Context Menu

full-screen-autohide =
    .label = Tembipuru renda moñemi
    .accesskey = H
full-screen-exit =
    .label = Mba’erechaha tuichavéva rekógui ñesẽ
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Ko’ág̃a, eheka hendive:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Jeheka mba’epytyvõrã moambue
search-one-offs-change-settings-compact-button =
    .tooltiptext = Jeheka mba’epytyvõrã moambue
search-one-offs-context-open-new-tab =
    .label = Tendayke pyahúpe jeheka
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Emopyenda ijypykuévaramo ha jehekaha mongu’eha
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Emoĩ jehekaha mongu’eha ijypykuévaramo ovetã ñemíme
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Techaukahakuéra ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Tendaykekuéra ({ $restrict })
search-one-offs-history =
    .tooltiptext = Tebiasakue ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Ehechauka mbosako’iha eñongatúvo
    .accesskey = S
bookmark-panel-done-button =
    .label = Mohu’ã
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Jeikekatu’ỹ
identity-connection-secure = Jeikekatu
identity-connection-internal = Kóva { -brand-short-name } jeroviáva; kuatiarogue.
identity-connection-file = Ko kuatiarogue oñeñongatu mohendahápe.
identity-extension-page = Ko kuatiarogue oñemyanyhẽ jepysokue guive.
identity-active-blocked = { -brand-short-name } ojokóma ko kuatiarogue pehẽ ijerovia’ỹha.
identity-custom-root = Jeike ohechapyréva mboajepyre me’ẽha Mozilla omoneĩ’ỹva.
identity-passive-loaded = Ko kuatiarogue pehẽ heta hendápe nda’ijeroviapái (mba’era’ãngáramo).
identity-active-loaded = Ndereguerekói pa’ũ ko kuatiaroguépe g̃uarã.
identity-weak-encryption = Ko kuatiarogue oipuru ñangarekoha ikangýva.
identity-insecure-login-forms = Ojehaiva’ekue jeike hag̃ua ko kuatiaroguépe oñemondakuaa.
identity-permissions =
    .value = Moneĩ
identity-permissions-reload-hint = Ikatu hína kuatiarogue emyanyhẽjey umi moambuepyre oñemboheko hag̃ua.
identity-permissions-empty = Nome’ẽi ko tenda ñemoneĩ ha’etéva.
identity-clear-site-data =
    .label = Emopotĩ kookie ha mba’ekuaarã tendágui…
identity-connection-not-secure-security-view = Nde jeike nahekorosãi ko tendápe.
identity-connection-verified = Eikehína tekorosãme ko tendápe.
identity-ev-owner-label = Mboajepyre osẽmava:
identity-description-custom-root = Mozilla nomoneĩri ko mboajepyre me’ẽhápe. Ikatu oñembojuaju apopyvusu oku’éva térã ñangarekoha rupive. <label data-l10n-name="link">Kuaave</label>
identity-remove-cert-exception =
    .label = Emongue oĩ’ỹva
    .accesskey = R
identity-description-insecure = Nde jeike ko tendápe naiñemíri. Marandu remondóva ikatu ohecha ambue tapicha (ñe’ẽñemíramo, ñe’ẽmondo, kuatia’atã ñemurã ha ambue).
identity-description-insecure-login-forms = Pe marandu tembiapo ñepyrũ pegua emoingéva ko kuatiaroguépe nahekorosãi ha ikatu noĩporãmbái.
identity-description-weak-cipher-intro = Nde jeike ko ñanduti rendápe oipuru ñangarekoha ikangýva ha naiñemíri.
identity-description-weak-cipher-risk = Ambue tapichakuéra ikatu ohecha nemarandu térã omoambue ñanduti kuatiarogue reko.
identity-description-active-blocked = { -brand-short-name } ojokóma ko kuatiarogue pehẽ ijerovia’ỹha. <label data-l10n-name="link">Kuaave</label>
identity-description-passive-loaded = Nde jeike naiñemíri ha nemarandu remoingéva ko tendápe ikatu ohecha ambue tapicha.
identity-description-passive-loaded-insecure = Ñanduti renda oguereko hetepy ndaijeroviapáiva (mba’era’ãngáramo). <label data-l10n-name="link">Kuaave</label>
identity-description-passive-loaded-mixed = { -brand-short-name } ojokóramo jepe heta retepy, oĩ gueteri tetepy kuatiaroguépe ndaijegueroviapáiva (mba’era’ãngáramo). <label data-l10n-name="link">Kuaave</label>
identity-description-active-loaded = Ko ñanduti renda oguereko hetepy ndaijeroviapáiva (guiõramo) ha nde jeike pype naiñemíri.
identity-description-active-loaded-insecure = Marandu remondóva ko kuatiaroguépe ikatu ohecha ambue tapicha (ñe’ẽñemíramo, ñe’ẽmondo, kuatia’atã ñemurã ha ambue).
identity-learn-more =
    .value = Kuaave
identity-disable-mixed-content-blocking =
    .label = Emonge ñemo’ã sapy’aite
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Ñemo’ã myandy
    .accesskey = E
identity-more-info-link-text =
    .label = Maranduve

## Window controls

browser-window-minimize-button =
    .tooltiptext = Momichĩ
browser-window-maximize-button =
    .tooltiptext = Mbotuicha
browser-window-restore-down-button =
    .tooltiptext = Embojevyjey Yvýgotyo
browser-window-close-button =
    .tooltiptext = Mboty

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Ta’angamýi hetápe guarãva:
    .accesskey = C
popup-select-microphone =
    .value = Ñe’ẽatãha hetápe g̃uarãva:
    .accesskey = M
popup-all-windows-shared = Oñemosarambíta opaite ovetã ojehecháva mba’erechahápe.
popup-screen-sharing-not-now =
    .label = Ani ko’ág̃a
    .accesskey = w
popup-screen-sharing-never =
    .label = Ani emoneĩ araka’eve
    .accesskey = N
popup-silence-notifications-checkbox = Embogue momarandu’i { -brand-short-name } emoherakuã aja
popup-silence-notifications-checkbox-warning = { -brand-short-name } ndohechaukamo’ãi momarandu’i oñemoherakuã aja.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Emoherakuãhína { -brand-short-name }. Ambue tapicha ikatu ohecha ohasávo ovetã pyahúpe.
sharing-warning-screen = Emoherakuã mba’erechaha tuichavéva. Ambue tapicha ikatu ohecha ohasávo ovetã pyahúpe.
sharing-warning-proceed-to-tab =
    .label = Eho tendayképe
sharing-warning-disable-for-session =
    .label = Eipe’a ñemo’ã ko tendápe g̃uarã

## DevTools F12 popup

enable-devtools-popup-description = Eipurútarõ mbopya’eha F12 embojurujaraẽ DevTools ñanduti Mboguatahára poravorãme.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Ñe’ẽreka ýrõ kundaharape
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Ñe’ẽreka ýrõ kundaharape
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Eheka ñandutípe
    .aria-label = Eheka { $name } ndive
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Emoinge ñe’ẽ ehekaséva
    .aria-label = Eheka { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Emoinge ñe’ẽ ehekaséva
    .aria-label = Eheka techaukahápe
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Emoinge ñe’ẽ ehekaséva
    .aria-label = Eheka tembiasakuépe
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Emoinge ñe’ẽ ehekaséva
    .aria-label = Eheka tendayképe
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Eheka { $name } ndive térã emoinge kundaharape
urlbar-remote-control-notification-anchor =
    .tooltiptext = Kundahára oĩ ñangarekoha okayguáva poguýpe
urlbar-permissions-granted =
    .tooltiptext = Oñeme’ẽ ko ñanduti rendápe ñemoneĩ jo’a.
urlbar-switch-to-tab =
    .value = Tendayképe jeguerova:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Jepysokue:
urlbar-go-button =
    .tooltiptext = Kundaharape renda URL-pe jeho
urlbar-page-action-button =
    .tooltiptext = Kuatiarogue rembiapo
urlbar-pocket-button =
    .tooltiptext = Eñongatu { -pocket-brand-name }-pe

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ha’e mba’erechaha henyhẽva ko’ág̃a
fullscreen-warning-no-domain = Ko kuatia oĩ hína ko’ág̃a mba’erechaha tuichavévape
fullscreen-exit-button = Esẽ mba’erechaha tuichavévagui (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Esẽ mba’erechaha tuichavévagui (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> eñangarekópa nde hekaha rehe. Eikutu Esc eguerujey hag̃ua hekaha.
pointerlock-warning-no-domain = Ko kuatia oñangareko nde hekaha rehe. Eikutu Esc eguerujey hag̃ua hekaha.
