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
    .data-title-private = { -brand-full-name } (Palaqinem Wichin)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Palaqinem Wichin)
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
    .data-title-private = { -brand-full-name } - (Palaqinem Wichin)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Palaqinem Wichin)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Titz'et retamab'al ruxaq k'amaya'l

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Tijaq yakoj pa rupas tzijol
urlbar-web-notification-anchor =
    .tooltiptext = Tijalwachïx we yatikïr ye'ak'ül taq rutzijol re ruxaq k'amaya'l re'
urlbar-midi-notification-anchor =
    .tooltiptext = Tijaq MIDI pas
urlbar-eme-notification-anchor =
    .tooltiptext = Tinuk'samajïx rokisaxik DRM kema'
urlbar-web-authn-anchor =
    .tooltiptext = Tijaq ri Ajk'amaya'l Juxunem pas
urlbar-canvas-notification-anchor =
    .tooltiptext = Tinuk'samajïx ya'öl q'ij richin kik'otik ruchi'
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Tinuk'samajïx ri rukomonik q'axäy atzij rik'in ri ruxaq k'amaya'l
urlbar-default-notification-anchor =
    .tooltiptext = Jaqäl rupas tzijol
urlbar-geolocation-notification-anchor =
    .tooltiptext = Rupas ruk'utuxik rokem k'ojlem
urlbar-xr-notification-anchor =
    .tooltiptext = Tijaq ri rupas ya'oj ruq'ij ri achik'al k'ojlemal
urlbar-storage-access-anchor =
    .tooltiptext = Tijaq ri kipas kiya'oj q'ij taq rusamaj okem pa k'amaya'l
urlbar-translate-notification-anchor =
    .tooltiptext = Titzalq'omïx re ruxaq re'
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Tinuk'samajib'ëx ri kikomonik taq rutzub'al chuqa' ruwäch ruxaq k'amaya'l
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Tijaq rupas tzijol eyakon toq manäq k'amab'ey
urlbar-password-notification-anchor =
    .tooltiptext = Tijaq ewan tzij yakon pa rupas tzijol
urlbar-translated-notification-anchor =
    .tooltiptext = Tinuk'samajïx rutzalq'omaxik re ruxaq k'amaya'l
urlbar-plugins-notification-anchor =
    .tooltiptext = Tinuk'samajïx rokisaxik nak'ab'äl
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Tinuk'samajïx ri rukomonik elesäy awachib'äl chuqa' ri q'axäy atzij rik'in ri ruxaq k'amaya'l
urlbar-autoplay-notification-anchor =
    .tooltiptext = Tijaq ri rupas ruyonil tzijonem
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Keyak taq tzij pa Jutaqil Yakoj
urlbar-addons-notification-anchor =
    .tooltiptext = Tijaq tz'aqat pa rupas tzijol richin niyak
urlbar-tip-help-icon =
    .title = Tak'ulu' ato'ik
urlbar-search-tips-confirm = Ütz, Xq'ax pa nuwi'
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Pixa':

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Jub'a' katz'ib'an, k'ïy tawila': Tikanöx { $engineName } choj pa rochoch etalib'äl.
urlbar-search-tips-redirect-2 = Tatikirisaj kanoxïk pa ri rukajtz'ik ochochib'äl richin ye'atz'ët taq ruchilab'exik { $engineName } chuqa' runatab'al awokik'amaya'l.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Taq yaketal
urlbar-search-mode-tabs = Taq ruwi'
urlbar-search-mode-history = Natab'äl

##

urlbar-geolocation-blocked =
    .tooltiptext = Xq'at ri ruk'ojlem etamab'äl pa re ruxaq k'amaya'l re'.
urlbar-xr-blocked =
    .tooltiptext = Xaq'ät ri okem pa taq rokisaxel achik'al k'ojelemal pa re ruxaq k'amaya'l re'.
urlbar-web-notifications-blocked =
    .tooltiptext = Xeq'at ri taq rutzijol pa re ruxaq k'amaya'l re'.
urlbar-camera-blocked =
    .tooltiptext = Xq'at ri elesäy ruwachib'al re ruxaq k'amaya'l re'.
urlbar-microphone-blocked =
    .tooltiptext = Xq'at ri q'asäy ach'ab'äl pa re ruxaq k'amaya'l re'.
urlbar-screen-blocked =
    .tooltiptext = Xq'at re ruxaq k'amaya'l re' pa komonïk ruwäch.
urlbar-persistent-storage-blocked =
    .tooltiptext = Xaq'ät ri jutaqil ruyakoj re ruxaq k'amaya'l re'.
urlbar-popup-blocked =
    .tooltiptext = Xq'at ri elesäy pop-ups richin re ruxaq k'amaya'l re'.
urlbar-autoplay-media-blocked =
    .tooltiptext = Xaq'ät ri ruyonil rutzijonem taq tob'äl k'o kik'oxom pa re ruxaq k'amaya'l re'.
urlbar-canvas-blocked =
    .tooltiptext = Xe'aq'ät ri kelesaxik kitzij taq peraj pa re ruxaq k'amaya'l re'.
urlbar-midi-blocked =
    .tooltiptext = Xaq'ät ri MIDI rokem re ruxaq k'amaya'l re'.
urlbar-install-blocked =
    .tooltiptext = Xaq'ät kiyakik taq rutz'aqat ajk'amaya'l ruxaq re'.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Tinuk' re jun yaketal ({ $shortcut }) re'
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Titz'aqatisäx re ruxaq k'amaya'l re' pa taq yaketal ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Titz'aqatisäx ri Kikajtz'ik Ochochib'äl
page-action-manage-extension =
    .label = Tinuk'samajïx K'amal…
page-action-remove-from-urlbar =
    .label = Tiyuj el chupam ri Kikajtz'ik Ochoch
page-action-remove-extension =
    .label = Tiyuj K'amal

## Auto-hide Context Menu

full-screen-autohide =
    .label = rewaxik ri cholsamajib'äl
    .accesskey = r
full-screen-exit =
    .label = Tel pa chijun ruwa kematz'ib'
    .accesskey = c

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Wakami tikanöx rik'in:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Kek'ëx ri taq rajowaxïk ri kanoxïk
search-one-offs-change-settings-compact-button =
    .tooltiptext = Tijal kinuk'ulem kanob'äl
search-one-offs-context-open-new-tab =
    .label = Tikanöx pa k'ak'a' ruwi'
    .accesskey = r
search-one-offs-context-set-as-default =
    .label = Tiya' achi'el ruk'amon wi pe chi kanob'äl
    .accesskey = r
search-one-offs-context-set-as-default-private =
    .label = Tiya' kan achi'el Okik'amaya'l ri K'o pa Ichinan taq Tzuwäch
    .accesskey = I
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
    .tooltiptext = Taq yaketal ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Taq ruwi' ({ $restrict })
search-one-offs-history =
    .tooltiptext = Natab'äl ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Tik'ut k'exob'äl toq niyak
    .accesskey = k
bookmark-panel-done-button =
    .label = Xk'is
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Man ütz ta okem
identity-connection-secure = Rujikomal okem
identity-connection-internal = Re re' ütz chi { -brand-short-name } ruxaq.
identity-connection-file = Re ruxaq k'amaya'l re' yakon pan akematz'ib'.
identity-extension-page = Re jun ruxaq k'amaya'l re' nisamajib'ëx pa jun k'amal.
identity-active-blocked = { -brand-short-name } xeruq'ät ri itzel taq ruperaj re ruxaq re'.
identity-custom-root = Xjikib'äx ri okem ruma ya'öl iqitzijib'äl, ri man retaman ta ruwäch ri Mozilla.
identity-passive-loaded = K'o man ütz ta taq ruch'akulal re ruxaq re' (achi'el ri taq wachib'äl).
identity-active-loaded = Xachüp ruchajixik re ruxaq re'.
identity-weak-encryption = Re ruxaq re' nrokisaj yamayïk chi suq'ch'ab'äl.
identity-insecure-login-forms = Kitikirib'al taq molojri'ïl etz'ib'an pa re ruxaq k'amaya'l re' rik'in jub'a' ye'itzelan.
identity-permissions =
    .value = Taq ya'oj q'ij
identity-permissions-reload-hint = Rik'in jub'a' k'o chi yatok chik pa ruxaq richin yesamäj ri taq k'exoj.
identity-permissions-empty = Majun chi ya'oj q'ij ya'on chawe' pa re ruxaq k'amaya'l re'.
identity-clear-site-data =
    .label = Keyuj ri Kaxlanwäy chuqa' Kitzij Ruxaq K'amaya'l…
identity-connection-not-secure-security-view = Man ütz ta ri awokem pa re ruxaq k'amaya'l re'.
identity-connection-verified = Ütz ri awokem pa re ruxaq k'amaya'l re'.
identity-ev-owner-label = Iqitzijib'äl talun richin:
identity-description-custom-root = Ri Mozilla man retaman ta ruwäch ri ruya'öl iqitzijib'äl Mozilla. Rik'in jub'a' xtz'aqatisäx pa jun samajel q'inoj o ruma jun nuk'samajel. <label data-l10n-name="link">Tetamäx ch'aqa' chik</label>
identity-remove-cert-exception =
    .label = Tiyuj Man Relik Ta
    .accesskey = y
identity-description-insecure = Man ichinan ta ri owokem pa re ruxaq k'amaya'l re'. Ronojel ri etamab'äl xke'atäq el, ch'aqa' chik tikirel xkekitz'ët (achi'el ewan taq tzij, taq rutzijol, ch'utit'im pwäq, ch'aqa' chik).
identity-description-insecure-login-forms = Ri retamab'al rutikirisanïk molojri'ïl xtatz'ib'aj pa re ruxaq k'amaya'l re' man chajin ta, ruma ri' rik'in jub'a' nitziläx.
identity-description-weak-cipher-intro = Ri awokem pa re ruxaq k'amaya'l re' nrokisaj lawalïk skript ruma ri man ichinan ta.
identity-description-weak-cipher-risk = Chaq'a' chik chi winaqi' yetikïr nikitz'ët ri awetamab'al o nikijalwachij ri rub'eyal nisamäj re ruxaq k'amaya'l re'.
identity-description-active-blocked = { -brand-short-name } xeruq'ät ri itzel taq ruperaj re ruxaq re'. <label data-l10n-name="link">Tetamäx ch'aqa' chik</label>
identity-description-passive-loaded = Man awichinan ta ri awokem pa k'amaya'l ruma ri' ronojel ri taq etamab'äl xke'akomonij rik'in re ruxaq k'amaya'l re' tikirel nikitz'ët juley chik winaqi'.
identity-description-passive-loaded-insecure = Re ruxaq k'amaya'l re' k'o itzel taq na'oj chupam (achi'el taq wachib'äl). <label data-l10n-name="link">Tetamäx ch'aqa' chik</label>
identity-description-passive-loaded-mixed = Stape' { -brand-short-name } xuq'ät jub'a' na'oj, junelïk k'o na'oj pa ri ruxaq ri man ütz ta (achi'el ri taq wachib'äl). <label data-l10n-name="link">Tetamäx ch'aqa' chik</label>
identity-description-active-loaded = Re ruxaq k'amaya'l re' k'o itzel taq na'oj chupam (achi'el taq skript) man awichinan ta ri awokem we yatok chupam.
identity-description-active-loaded-insecure = Ri taq etamab'äl xke'akomonij rik'in re ruxaq k'amaya'l re', tikirel nikitz'ët juley chik winaqi' (achi'el ewan taq tzij, taq rutzijol, t'im pwäq, ch'aqa' chik).
identity-learn-more =
    .value = Tetamäx Ch'aqa' Chik
identity-disable-mixed-content-blocking =
    .label = Wakami yan tz'apäl ri chajinïk
    .accesskey = t
identity-enable-mixed-content-blocking =
    .label = Titzij ri chajinïk
    .accesskey = T
identity-more-info-link-text =
    .label = Ch'aqa' chik rutzijol

## Window controls

browser-window-minimize-button =
    .tooltiptext = Ch'utinarisaxïk
browser-window-maximize-button =
    .tooltiptext = Tinimirisäx
browser-window-restore-down-button =
    .tooltiptext = Tichojmirisäx Ikim
browser-window-close-button =
    .tooltiptext = Titz'apïx

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Rutaluxik elesäy wachib'äl
    .accesskey = e
popup-select-microphone =
    .value = Q'asäy ch'ab'äl richin rutaluxik:
    .accesskey = Q
popup-all-windows-shared = Xkekomonïx konojel ri tz'etel taq tzuwäch e k'o pa ri ruwäch.
popup-screen-sharing-not-now =
    .label = Wakami Mani
    .accesskey = W
popup-screen-sharing-never =
    .label = Majub'ey Tiya' Q'ij
    .accesskey = M
popup-silence-notifications-checkbox = Kechup taq rutzijol { -brand-short-name } toq nikomonïx
popup-silence-notifications-checkbox-warning = Man xkeruk'üt ta pe taq tzijol ri { -brand-short-name } toq nikomonin.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Nikomonin ri { -brand-short-name }. Juley chik winaqi' yetikïr nikitz'ët toq niq'ax pa jun k'ak'a' ruwi'.
sharing-warning-screen = Nakomonij ri tz'aqät ruwa. chik winaqi' yetikïr nikitz'ët toq niq'ax pa jun k'ak'a' ruwi'.
sharing-warning-proceed-to-tab =
    .label = Tib'e pa Ruwi'
sharing-warning-disable-for-session =
    .label = Tichup ri komon ruwäch chajinïk pa re molojri'ïl re'

## DevTools F12 popup

enable-devtools-popup-description = Richin nokisäx ri F12 chojokem, nab'ey tajaqa' ri DevTools rik'in ri rucha'osamaj Web B'anonel.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Tikanöx o titz'ib'äx ochochib'äl
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Tikanöx o titz'ib'äx ochochib'äl
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Tikanöx pa Web
    .aria-label = Tikanöx rik'in { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Ketz'ib'äx tzij yekanöx
    .aria-label = Tikanöx { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Ketz'ib'äx tzij yekanöx
    .aria-label = Kekanöx taq yaketal
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Ketz'ib'äx tzij yekanöx
    .aria-label = Tikanöx natab'äl
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Ketz'ib'äx tzij yekanöx
    .aria-label = Kekanöx ruwi'
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Tikanöx rik'in { $name }  o titz'ib'äx ochochib'äl
urlbar-remote-control-notification-anchor =
    .tooltiptext = Ri Okik'amaya'l k'o pa ruq'a' ri näj chajinïk
urlbar-permissions-granted =
    .tooltiptext = Xaya' ruwi' ya'oj q'ij chi re re ajk'amaya'l ruxaq re'.
urlbar-switch-to-tab =
    .value = Rujalik ri ruwi':
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = K'amal:
urlbar-go-button =
    .tooltiptext = Tib'e pa JAY richin ri rucholob'al taq ochochib'äl
urlbar-page-action-button =
    .tooltiptext = Taq rub'anoj ruxaq
urlbar-pocket-button =
    .tooltiptext = Tiyak pa { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> wakami at k'o pa chijun ruwa kematz'ib'
fullscreen-warning-no-domain = Wakami re wuj re' k'o pa chijun ruwa kematz'ib'
fullscreen-exit-button = Tel pa chijun ruwa kematz'ib' (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Tel pa chijun ruwa kematz'ib' (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> chajin ruma ri retal ch'oy. Tapitz'a' Esc richin nachajij chik el.
pointerlock-warning-no-domain = Re ruxaq wuj re' chajin ruma ri retal ch'oy. Tapitz'a' Esc richin nachajij chik el.
