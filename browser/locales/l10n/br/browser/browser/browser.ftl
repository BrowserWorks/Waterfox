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
    .data-title-private = { -brand-full-name } (Merdeiñ prevez)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Merdeiñ prevez)
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
    .data-title-private = { -brand-full-name } - (Merdeiñ prevez)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Merdeiñ prevez)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Gwelout titouroù al lec'hienn

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Digeriñ penel ar gemennadenn staliadur
urlbar-web-notification-anchor =
    .tooltiptext = Ardeiñ penaos e c'hallit degemer rebuzadurioù digant al lec'hienn
urlbar-midi-notification-anchor =
    .tooltiptext = Digeriñ ar penel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Ardeiñ an arver meziantoù DRM
urlbar-web-authn-anchor =
    .tooltiptext = Digeriñ ar banell dilesa web
urlbar-canvas-notification-anchor =
    .tooltiptext = Merañ aotreoù eztennañ ar steuñv
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Ardeiñ rannadur ho klevell gant al lec'hienn
urlbar-default-notification-anchor =
    .tooltiptext = Digeriñ penel ar c'hemennadennoù
urlbar-geolocation-notification-anchor =
    .tooltiptext = Digeriñ penel ar goulenn lec'hiadur
urlbar-xr-notification-anchor =
    .tooltiptext = Digeriñ penel aotreoù ar gwirvoud galloudel
urlbar-storage-access-anchor =
    .tooltiptext = Digeriñ penel aotreoù an oberiantiz merdeiñ
urlbar-translate-notification-anchor =
    .tooltiptext = Treiñ ar bajenn-mañ
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Ardeiñ rannadur ho prenestr pe ho skramm gant al lec'hienn
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Digeriñ penel kemennadenn ar c'hadaviñ ezlinenn
urlbar-password-notification-anchor =
    .tooltiptext = Digeriñ penel kemennadenn enrollañ ar ger-tremen
urlbar-translated-notification-anchor =
    .tooltiptext = Ardeiñ troidigezh ar bajenn
urlbar-plugins-notification-anchor =
    .tooltiptext = Ardeiñ arver an enlugellad
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Ardeiñ rannadur ho kamera ha/pe ho klevell gant al lec'hienn
urlbar-autoplay-notification-anchor =
    .tooltiptext = Digeriñ panell al lenn emgefreek
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Kadavin roadennoù er c'hadaviñ diastal
urlbar-addons-notification-anchor =
    .tooltiptext = Digeriñ penel kemennadenn staliadur an askouezh
urlbar-tip-help-icon =
    .title = Kaout skoazell
urlbar-search-tips-confirm = Mat eo, komprenet am eus
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tun:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Skrivit nebeutoc'h, kavit muioc'h: Klaskit war { $engineName } adalek ho parrenn chomlec'h.
urlbar-search-tips-redirect-2 = Krogit ho klask er varrenn-chomlec'h evit gwelout alioù klask { $engineName } hag ho roll istor merdeiñ.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Sinedoù
urlbar-search-mode-tabs = Ivinelloù
urlbar-search-mode-history = Roll istor

##

urlbar-geolocation-blocked =
    .tooltiptext = Stanket ho peus an titouroù lec'hiadur evit al lec'hienn-mañ.
urlbar-xr-blocked =
    .tooltiptext = Stanket ho peus an haeziñ gwirvoud galloudel evit al lec'hienn-mañ.
urlbar-web-notifications-blocked =
    .tooltiptext = Stanket ho peus ar rebuzadurioù evit al lec'hienn-mañ.
urlbar-camera-blocked =
    .tooltiptext = Stanket ho peus ho kamera evit al lec'hienn-mañ.
urlbar-microphone-blocked =
    .tooltiptext = Stanket ho peus ho klevell evit al lec'hienn-mañ.
urlbar-screen-blocked =
    .tooltiptext = Difennet ho peus al lec'hienn-mañ da rannañ ho skramm.
urlbar-persistent-storage-blocked =
    .tooltiptext = Stanket ho peus ar c'hadaviñ diastal evit al lec'hienn-mañ.
urlbar-popup-blocked =
    .tooltiptext = Stanket hoc'h eus an diflugelloù evit al lec'hienn-mañ.
urlbar-autoplay-media-blocked =
    .tooltiptext = Stanket ho peus al lenn emgefreek media gant ar son evit al lec'hienn-mañ.
urlbar-canvas-blocked =
    .tooltiptext = Stanket ho peus eztennadur ar roadennoù ar steuenn.
urlbar-midi-blocked =
    .tooltiptext = Stanket ho peus an haeziñ MIDI evit al lec'hienn-mañ.
urlbar-install-blocked =
    .tooltiptext = Stanket ho peus ar staliadurioù askouezhioù war al lec'hienn-mañ.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Embann ar sined-mañ ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Lakaat ur sined war ar bajenn-mañ ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Ouzhpennañ d'ar varenn chomlec'h
page-action-manage-extension =
    .label = Merañ an askouezh...
page-action-remove-from-urlbar =
    .label = Lemel kuit diouzh ar varrenn chomlec'h
page-action-remove-extension =
    .label = Dilemel an askouezh

## Auto-hide Context Menu

full-screen-autohide =
    .label = Kuzhat ar varrenn ostilhoù
    .accesskey = h
full-screen-exit =
    .label = Kuitaat ar mod skramm a-bezh
    .accesskey = K

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Ar wech-mañ, klaskit gant:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Kemmañ an arventennoù klask
search-one-offs-change-settings-compact-button =
    .tooltiptext = Kemmañ an arventennoù klask
search-one-offs-context-open-new-tab =
    .label = Klask en ivinell nevez
    .accesskey = n
search-one-offs-context-set-as-default =
    .label = Lakaat evel keflusker enklask dre ziouer
    .accesskey = k
search-one-offs-context-set-as-default-private =
    .label = Lakaat da lusker enklask dre ziouer evit ar prenestroù prevez
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
    .tooltiptext = Sinedoù ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Ivinelloù ({ $restrict })
search-one-offs-history =
    .tooltiptext = Roll istor ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Diskouez an embanner pa enroll
    .accesskey = S
bookmark-panel-done-button =
    .label = Graet
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 30em

## Identity Panel

identity-connection-not-secure = N'eo ket diarvar ar c'hennask
identity-connection-secure = Kennask suraet
identity-connection-internal = Ur bajenn { -brand-short-name } diarvar eo.
identity-connection-file = War hoc'h urzhiataer eo kadavet ar bajenn-mañ.
identity-extension-page = Diwar un askouezh eo karget ar bajenn-mañ.
identity-active-blocked = Stanket eo bet gant { -brand-short-name } lodennoù arvarus er bajennad.
identity-custom-root = Gwiriet eo bet ar c'hennask hag ur pourchaser testenioù n'eo ket adanavezet gant Mozilla.
identity-passive-loaded = Arvarus eo lodennoù eus ar bajennad (skeudennoù, da skouer).
identity-active-loaded = Diweredekaet ho peus ar gwarez war ar bajenn-mañ.
identity-weak-encryption = Enrinegañ gwan a vez arveret gant ar bajenn-mañ.
identity-insecure-login-forms = Treuzvarc'het e c'hall bezañ an titouroù kennaskañ enanket er bajenn-mañ.
identity-permissions =
    .value = Aotreoù
identity-permissions-reload-hint = Ret eo deoc'h adkargañ ar bajenn evit arloañ ar c'hemmoù.
identity-permissions-empty = N'ho peus roet aotre arbennik ebet d'al lec'hienn-mañ.
identity-clear-site-data =
    .label = Skarzhañ an toupinoù ha roadennoù lec'hienn…
identity-connection-not-secure-security-view = N'oc'h ket kennasket d'al lec'hienn-mañ en un doare sur.
identity-connection-verified = Kennasket oc'h d'al lec'hienn-mañ en un doare sur.
identity-ev-owner-label = Testeni roet da:
identity-description-custom-root = Ne adanavez ket Mozilla pourchaser an testeni-mañ. Marteze eo bet ouzhpennet gant ho reizhiad korvoiñ pe gant un ardoer. <label data-l10n-name="link">Gouzout hiroc'h</label>
identity-remove-cert-exception =
    .label = Lemel an nemedenn kuit
    .accesskey = L
identity-description-insecure = N'eo ket prevez ho kennask war al lec'hienn-mañ. Gallout a ra an titouroù kinniget ganeoc'h bezañ gwelet gant tud all (gerioù-tremen, kemennadennoù, kartennoù gred en o zouez).
identity-description-insecure-login-forms = N'eo ket diogel an titouroù kennaskañ enanket ganeoc'h er bajennad-mañ ha gallout a reont bezañ en arvar.
identity-description-weak-cipher-intro = Enrinegañ gwan a vez arveret gant ho kennask d'al lec'hienn-mañ ha n'eo ket prevez.
identity-description-weak-cipher-risk = Gallout a ra tud all sellet ouzh ho titouroù pe kemmañ emzalc'h al lec'hienn.
identity-description-active-blocked = Stanket eo bet gant { -brand-short-name } lodennoù arvarus er bajennad. <label data-l10n-name="link">Gouzout hiroc'h</label>
identity-description-passive-loaded = N'eo ket prevez ho kennask ha galloud a ra an titouroù rannet gant al lec'hienn bezañ gwelet gant tud all.
identity-description-passive-loaded-insecure = Endalc'hadoù el lec'hienn-mañ a zo arvarus (skeudennoù, da skouer). <label data-l10n-name="link">Gouzout hiroc'h</label>
identity-description-passive-loaded-mixed = Daoust m'eo bet stanked endalc'hadoù gant { -brand-short-name } e chom endalc'hadoù arvarus er bajennad (skeudennoù, da skouer). <label data-l10n-name="link">Gouzout hiroc'h</label>
identity-description-active-loaded = Endalc'hadoù arvarus a zo el lec'hienn (skriptoù, da skouer) ha n'eo ket prevez ho kennask.
identity-description-active-loaded-insecure = Gallout a ra an titouroù rannet gant al lec'hienn bezañ gwelet gant tud all (evel gerioù-tremen, kemennadennoù, kartennoù gred, hag all.).
identity-learn-more =
    .value = Gouzout hiroc'h
identity-disable-mixed-content-blocking =
    .label = Diweredekaat ar gwarez evit poent
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Gweredekaat ar gwarez
    .accesskey = G
identity-more-info-link-text =
    .label = Muioc'h a stlennoù

## Window controls

browser-window-minimize-button =
    .tooltiptext = Bihanaat
browser-window-maximize-button =
    .tooltiptext = Brasaat
browser-window-restore-down-button =
    .tooltiptext = Assav
browser-window-close-button =
    .tooltiptext = Serriñ

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Webkam da rannañ :
    .accesskey = W
popup-select-microphone =
    .value = Klevell da rannañ :
    .accesskey = K
popup-all-windows-shared = Rannet e vo an holl brenestroù gwelus war ho skramm.
popup-screen-sharing-not-now =
    .label = Diwezhatoc'h
    .accesskey = D
popup-screen-sharing-never =
    .label = Na aotren biken
    .accesskey = N
popup-silence-notifications-checkbox = Diweredekaat ar rebuziñ eus { -brand-short-name } e-pad ar rannadenn
popup-silence-notifications-checkbox-warning = { -brand-short-name } na ziskouezo ket a rebuzadurioù p'emaoc'h o rannañ.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Emaoc'h o rannañ { -brand-short-name }. Gallout a ra tud all gwelet pa 'z it war un ivinell nevez.
sharing-warning-screen = Emaoc'h o rannañ ho skramm a-bezh. Gallout a ra tud all gwelet pa 'z it war un ivinell nevez.
sharing-warning-proceed-to-tab =
    .label = Kenderc'hel betek an ivinell
sharing-warning-disable-for-session =
    .label = Diweredekaat ar gwarez rannañ evit an estez-mañ

## DevTools F12 popup

enable-devtools-popup-description = Evit ober gant ar verradenn F12, digorit DevTools dre al lañser diorroen web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Bizskrivit un termen da glask pe ur chomlec'h
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Bizskrivit un termen da glask pe ur chomlec'h
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Klask er web
    .aria-label = Klask gant { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Enankit gerioù da glask
    .aria-label = Klask { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Enankit gerioù da glask
    .aria-label = Klask er sinedoù
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Enankit gerioù da glask
    .aria-label = Klask er roll istor
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Enankit gerioù da glask
    .aria-label = Klask en ivinelloù
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Klaskit gant: { $name } pe enankit ur chomlec'h
urlbar-remote-control-notification-anchor =
    .tooltiptext = Reoliet a-bell eo ar merdeer
urlbar-permissions-granted =
    .tooltiptext = Roet ho peus aotreoù ouzhpenn d'al lec'hienn-mañ.
urlbar-switch-to-tab =
    .value = Mont d'an ivinell :
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Askouezh:
urlbar-go-button =
    .tooltiptext = Mont d'ar chomlec'h er varrenn lec'hiañ
urlbar-page-action-button =
    .tooltiptext = Gweredoù ar bajenn
urlbar-pocket-button =
    .tooltiptext = Enrollañ etrezek { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> a zo e skramm a-bezh
fullscreen-warning-no-domain = War ar skramm a-bezh emañ an teul-mañ bremañ
fullscreen-exit-button = Kuitaat ar mod skramm a-bezh (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Kuitaat ar mod skramm a-bezh (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> a c'hall reoliñ ho logodenn. Pouezit war Achap evit bezañ mestr outi en-dro.
pointerlock-warning-no-domain = Meret eo ho logodenn gant an teul-mañ. Pouezit war Achap evit bezañ mestr outi en-dro.
