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
    .data-title-private = { -brand-full-name } (Private Browsing)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Private Browsing)
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
    .data-title-private = { -brand-full-name } - (Private Browsing)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Private Browsing)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Tingnan ang impormasyon ng site

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Buksan ang install message panel
urlbar-web-notification-anchor =
    .tooltiptext = Baguhin kung pwede ka na makakuha ng abiso galing sa site
urlbar-midi-notification-anchor =
    .tooltiptext = Buksan ang MIDI panel
urlbar-eme-notification-anchor =
    .tooltiptext = Pamahalaan ang paggamit ng DRM software
urlbar-web-authn-anchor =
    .tooltiptext = Buksan ang Web Authentication panel
urlbar-canvas-notification-anchor =
    .tooltiptext = Pamahalaan ang pahintulot sa pagkuha ng cavas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Pangasiwaan ang pag-bahagi ng iyong mikropono sa site
urlbar-default-notification-anchor =
    .tooltiptext = Buksan ang panel ng mensahe
urlbar-geolocation-notification-anchor =
    .tooltiptext = Buksan ang panel ng kahilingan ng lokasyon
urlbar-xr-notification-anchor =
    .tooltiptext = Buksan ang panel ng mga pahintulot para sa virtual reality
urlbar-storage-access-anchor =
    .tooltiptext = Buksan ang panel ng mga pahintulot para sa browsing activity
urlbar-translate-notification-anchor =
    .tooltiptext = Isalin ang pahina na ito
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Pangasiwaan ang pag-bahagi ng iyong windows o screen sa site
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Buksan ang offline storage message panel
urlbar-password-notification-anchor =
    .tooltiptext = Buksan ang save password message panel
urlbar-translated-notification-anchor =
    .tooltiptext = I-manage ang page translation
urlbar-plugins-notification-anchor =
    .tooltiptext = Pangasiwaan ang paggamit ng plug-in
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Pangasiwaan ang pag-bahagi ng iyong kodak at/o mikropono sa site
urlbar-autoplay-notification-anchor =
    .tooltiptext = Buksan ang panel ng autoplay
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Ilagay ang datos sa Persistent Storage
urlbar-addons-notification-anchor =
    .tooltiptext = Buksan ang add-on intallation message panel
urlbar-tip-help-icon =
    .title = Humingi ng tulong
urlbar-search-tips-confirm = OK, nakuha ko
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Payo:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Shortcut: Hanapin ang { $engineName } direkta mula sa iyong address bar.
urlbar-search-tips-redirect-2 = Simulan ang iyong paghahanap sa address bar para makakita ng mga mungkahi mula sa { $engineName } at sa iyong browsing history.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Mga Bookmark
urlbar-search-mode-tabs = Mga Tab
urlbar-search-mode-history = Kasaysayan

##

urlbar-geolocation-blocked =
    .tooltiptext = Na-block mo ang impormasyon ng lokasyon para sa website na ito.
urlbar-xr-blocked =
    .tooltiptext = Hinarangan mo ang virtual reality device na mag-access para sa website na ito.
urlbar-web-notifications-blocked =
    .tooltiptext = Na-block mo ang mga notification para sa website na ito.
urlbar-camera-blocked =
    .tooltiptext = Hinarangan mo ang iyong camera para sa website na ito.
urlbar-microphone-blocked =
    .tooltiptext = Na-block mo ang iyong mikropono para sa website na ito.
urlbar-screen-blocked =
    .tooltiptext = Na-block mo ang website na ito mula sa pagbabahagi ng iyong screen.
urlbar-persistent-storage-blocked =
    .tooltiptext = Na-block mo ang paulit-ulit na imbakan para sa website na ito.
urlbar-popup-blocked =
    .tooltiptext = Hinarangan mo ang mga pop-up sa website na ito.
urlbar-autoplay-media-blocked =
    .tooltiptext = Hinarangan mo ang pag autoplay ng media na may tunog sa website na ito.
urlbar-canvas-blocked =
    .tooltiptext = Na-block mo ang data extraction ng canvas para sa website na ito.
urlbar-midi-blocked =
    .tooltiptext = Na-block mo ang access sa MIDI para sa website na ito.
urlbar-install-blocked =
    .tooltiptext = Hinarang mo ang pagkabit ng mga add-on sa website na ito.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Baguhin itong bookmark ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = i-Bookmark ang pahinang ito ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Idagdag sa Address Bar
page-action-manage-extension =
    .label = Manage Extension…
page-action-remove-from-urlbar =
    .label = Tanggalin sa Address Bar
page-action-remove-extension =
    .label = Tanggalin ang Extension

## Auto-hide Context Menu

full-screen-autohide =
    .label = Itago ang mga Toolbar
    .accesskey = H
full-screen-exit =
    .label = Lumabas sa Full Screen Mode
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Ngayon naman, maghanap gamit ang:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Baguhin ang mga Search Setting
search-one-offs-change-settings-compact-button =
    .tooltiptext = Baguhin ang mga search setting
search-one-offs-context-open-new-tab =
    .label = Hanapin sa Bagong Tab
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = I-set sa Default Search Engine
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Itakda bilang Default Search Engine sa mga Private Window
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
    .tooltiptext = Mga Bookmark ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Mga Tab ({ $restrict })
search-one-offs-history =
    .tooltiptext = Kasaysayan ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Ipakita ang editor kapag nagse-save
    .accesskey = S
bookmark-panel-done-button =
    .label = Tapos na
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Hindi ligtas ang koneksyon
identity-connection-secure = Ligtas na koneksyon
identity-connection-internal = Ito ay secure na { -brand-short-name } na pahina.
identity-connection-file = Ang pahinang ito ay naka-imbak sa iyong computer.
identity-extension-page = Ang pahinang ito ay nai-load mula sa isang extension.
identity-active-blocked = { -brand-short-name } Na-block ang mga bahagi ng pahinang ito na hindi ligtas.
identity-custom-root = Ang connection ay na-verify ng isang certificate issuer na hindi kinikilala ng Mozilla.
identity-passive-loaded = Ang mga bahagi ng pahinang ito ay hindi ligtas (tulad ng mga larawan).
identity-active-loaded = Hindi mo pinagana ang proteksyon sa pahinang ito.
identity-weak-encryption = Ang pahinang ito ay gumagamit ng mahina na pag-encrypt.
identity-insecure-login-forms = Ang mga pag-login na ipinasok sa pahinang ito ay maaaring makompromiso.
identity-permissions =
    .value = Mga Pahintulot
identity-permissions-reload-hint = Maaaring kailangan mong i-reload ang pahina para mag-aplay ang mga pagbabago.
identity-permissions-empty = Hindi mo ipinagkaloob ang site na ito anumang espesyal na pahintulot.
identity-clear-site-data =
    .label = Burahin ang mga Cookie at Site Data…
identity-connection-not-secure-security-view = Ikaw ay hindi ligtas na nakakonekta sa site na ito.
identity-connection-verified = Ikaw ay ligtas na nakakonekta sa site na ito.
identity-ev-owner-label = Inisyu ang certificate kay:
identity-description-custom-root = Hindi kilala ng Mozilla ang certificate issuer na ito. Maaari itong nadagdag sa iyong operating system o ng isang administrator. <label data-l10n-name="link">Matuto ng higit pa</label>
identity-remove-cert-exception =
    .label = Tanggalin ang Exception
    .accesskey = R
identity-description-insecure = Ang iyong koneksyon sa site na ito ay hindi pribado. Ang impormasyon na iyong isinumite ay maaaring matingnan ng iba (tulad ng mga password, mensahe, credit card, atbp.).
identity-description-insecure-login-forms = Ang impormasyon sa pag-login na ipinasok mo sa pahinang ito ay hindi ligtas at maaaring makompromiso.
identity-description-weak-cipher-intro = Ang iyong koneksyon sa website na ito ay gumagamit ng mahina na pag-encrypt at hindi pribado.
identity-description-weak-cipher-risk = Maaaring tingnan ng iba pang mga tao ang iyong impormasyon o baguhin ang pag-uugali ng website.
identity-description-active-blocked = { -brand-short-name } Na-block ang mga bahagi ng pahinang ito na hindi ligtas. <label data-l10n-name="link">Matuto ng higit pa</label>
identity-description-passive-loaded = Ang iyong koneksyon ay hindi pribado at ang impormasyon na iyong ibinabahagi sa site ay maaaring makita ng iba.
identity-description-passive-loaded-insecure = Ang website na ito ay naglalaman ng nilalaman na hindi ligtas (tulad ng mga larawan). <label data-l10n-name="link">Matuto ng higit pa</label>
identity-description-passive-loaded-mixed = Kahit na { -brand-short-name } Na-block ng ilang nilalaman, may nilalaman pa rin sa pahina na hindi ligtas (tulad ng mga larawan). <label data-l10n-name="link">Matuto ng higit pa</label>
identity-description-active-loaded = Ang website na ito ay naglalaman ng nilalaman na hindi ligtas (tulad ng mga script) at ang iyong koneksyon dito ay hindi pribado.
identity-description-active-loaded-insecure = Ang impormasyon na ibinabahagi mo sa site na ito ay maaaring makita ng iba (tulad ng mga password, mensahe, credit card, atbp.).
identity-learn-more =
    .value = Matuto ng higit pa
identity-disable-mixed-content-blocking =
    .label = Huwag paganahin ang proteksyon sa ngayon
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Paganahin ang proteksyon
    .accesskey = E
identity-more-info-link-text =
    .label = Karagdagang Impormasyon

## Window controls

browser-window-minimize-button =
    .tooltiptext = i-Minimize
browser-window-maximize-button =
    .tooltiptext = Palakihin
browser-window-restore-down-button =
    .tooltiptext = Restore Down
browser-window-close-button =
    .tooltiptext = Isara

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Camera na ibabahagi:
    .accesskey = C
popup-select-microphone =
    .value = Mga mikropono na pwedeng ibahagi:
    .accesskey = M
popup-all-windows-shared = Lahat ng nakikitang window sa iyong screen ay ibabahagi.
popup-screen-sharing-not-now =
    .label = Hindi Ngayon
    .accesskey = H
popup-screen-sharing-never =
    .label = Huwag Payagan
    .accesskey = H

## WebRTC window or screen share tab switch warning

sharing-warning-proceed-to-tab =
    .label = Magpatuloy sa Tab

## DevTools F12 popup

enable-devtools-popup-description = Para gamitin ang F1 2 shortcut, unang buksan ang DevTools sa Web Developer menu.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Hanapin o ilagay ang address
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Hanapin o ilagay ang address
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Hanapin sa Web
    .aria-label = Maghanap gamit ang { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Ipasok ang mga search term
    .aria-label = Hanapin { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Ipasok ang mga search term
    .aria-label = Hanapin sa mga bookmark
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Ipasok ang mga search term
    .aria-label = Hanapin sa kasaysayan
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Ipasok ang mga search term
    .aria-label = Hanapin sa mga tab
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Maghanap gamit ang { $name } o ipasok ang address
urlbar-remote-control-notification-anchor =
    .tooltiptext = Browser ay kasalukuyang nire-remote kontrol
urlbar-permissions-granted =
    .tooltiptext = Ipinagkaloob mo sa website na ito ang mga karagdagang pahintulot.
urlbar-switch-to-tab =
    .value = Lumipat sa tab:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extension:
urlbar-go-button =
    .tooltiptext = Pumunta sa lokasyon na nasa Location Bar
urlbar-page-action-button =
    .tooltiptext = Page actions
urlbar-pocket-button =
    .tooltiptext = I-save sa { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = Ang <span data-l10n-name="domain">{ $domain }</span> ay naka-full screen na ngayon
fullscreen-warning-no-domain = Ang dokument na ito ay naka full screen
fullscreen-exit-button = Umalis sa Full Screen (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Umalis sa Full Screen (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ay may kontrol sa iyong pointer. Pindutin ang ESC para mabawi ang kontrol.
pointerlock-warning-no-domain = Ang dokumentong ito ay may kontrol sa iyong pointer. Pindutin ang Esc para manumbalik ang kontrol.
