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
    .data-title-private = { -brand-full-name } (Pori Preifat)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Pori Preifat)
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
    .data-title-private = { -brand-full-name } - (Pori Preifat)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Pori Preifat)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Gweld manylion y wefan

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Agor panel y neges gosod
urlbar-web-notification-anchor =
    .tooltiptext = Newid p'un ai rydych yn derbyn hysbysiadau o'r wefan
urlbar-midi-notification-anchor =
    .tooltiptext = Agor panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Rheoli'r defnydd o feddalwedd DRM
urlbar-web-authn-anchor =
    .tooltiptext = Agor panel Dilysu Gwe
urlbar-canvas-notification-anchor =
    .tooltiptext = Rheoli caniatâd tynnu canfas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Rheoli rhannu eich meicroffon gyda'r wefan
urlbar-default-notification-anchor =
    .tooltiptext = Agor y panel negesu
urlbar-geolocation-notification-anchor =
    .tooltiptext = Agor panel cais y lleoliad
urlbar-xr-notification-anchor =
    .tooltiptext = Agor panel caniatâd rhithrealaeth
urlbar-storage-access-anchor =
    .tooltiptext = Agor panel caniatâd gweithgaredd pori
urlbar-translate-notification-anchor =
    .tooltiptext = Cyfieithu'r dudalen hon
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Rheoli rhannu eich ffenestri neu sgrin gyda'r wefan
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Agor y panel neges storio all-lein
urlbar-password-notification-anchor =
    .tooltiptext = Agor panel neges y cyfrinair cadw
urlbar-translated-notification-anchor =
    .tooltiptext = Rheoli cyfieithu tudalennau
urlbar-plugins-notification-anchor =
    .tooltiptext = Rheoli defnydd ategion
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Rheoli rhannu eich camera a/neu feicroffon gyda'r wefan
urlbar-autoplay-notification-anchor =
    .tooltiptext = Agor panel awtochwarae
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Cadw data mewn Storfa Barhaus
urlbar-addons-notification-anchor =
    .tooltiptext = Agor panel neges gosod yr ychwanegyn
urlbar-tip-help-icon =
    .title = Derbyn cymorth
urlbar-search-tips-confirm = Iawn, rwy'n deall
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Awgrym:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Teipio llai, canfod mwy: Chwiliwch gyda { $engineName } yn syth o'ch bar cyfeiriad.
urlbar-search-tips-redirect-2 = Cychwynnwch eich chwilio yma i weld awgrymiadau gan { $engineName } a'ch hanes pori.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Nodau tudalen
urlbar-search-mode-tabs = Tabiau
urlbar-search-mode-history = Hanes

##

urlbar-geolocation-blocked =
    .tooltiptext = Rydych wedi rhwystro'r manylion lleoliad ar gyfer y wefan hon.
urlbar-xr-blocked =
    .tooltiptext = Rydych wedi rhwystro mynediad dyfais rhithrealaeth ar gyfer y wefan hon.
urlbar-web-notifications-blocked =
    .tooltiptext = Rydych wedi rhwystro hysbysiadau ar gyfer y wefan hon.
urlbar-camera-blocked =
    .tooltiptext = Rydych wedi diffodd eich camera ar gyfer y wefan hon.
urlbar-microphone-blocked =
    .tooltiptext = Rydych wedi diffodd eich meicroffon ar gyfer y wefan hon.
urlbar-screen-blocked =
    .tooltiptext = Rydych wedi rhwystro'r wefan rhag rhannu eich sgrin.
urlbar-persistent-storage-blocked =
    .tooltiptext = Rydych wedi rhwystro storio data parhaus ar gyfer y wefan hon.
urlbar-popup-blocked =
    .tooltiptext = Rydych wedi rhwystro llamlenni ar gyfer y wefan hon.
urlbar-autoplay-media-blocked =
    .tooltiptext = Rydych wedi rhwystro cyfrwng awtochwarae gyda seiniau ar gyfer y wefan hon.
urlbar-canvas-blocked =
    .tooltiptext = Rydych wedi rhwystro tynnu data canvas o'r wefan hon.
urlbar-midi-blocked =
    .tooltiptext = Rydych wedi rhwystro mynediad MIDI ar gyfer y wefan hon.
urlbar-install-blocked =
    .tooltiptext = Rydych wedi rhwystro gosod ychwanegion ar gyfer y wefan hon.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Golygu'r nod tudalen ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Gosod nod tudalen i'r dudalen ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Ychwanegu i'r Llyfr Cyfeiriadau
page-action-manage-extension =
    .label = Rheoli Estyniad…
page-action-remove-from-urlbar =
    .label = Tynnu o'r Bar Cyfeiriadau
page-action-remove-extension =
    .label = Tynnu Estyniad

## Auto-hide Context Menu

full-screen-autohide =
    .label = Cuddio Barrau Offer
    .accesskey = u
full-screen-exit =
    .label = Gadael Modd Sgrin Lawn
    .accesskey = L

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Y tro hwn, chwilio gyda:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Gosodiadau Chwilio
search-one-offs-change-settings-compact-button =
    .tooltiptext = Newid y gosodiadau chwilio
search-one-offs-context-open-new-tab =
    .label = Chwilio mewn Tab Newydd
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Gosod fel y Peiriant Chwilio Rhagosodedig
    .accesskey = R
search-one-offs-context-set-as-default-private =
    .label = Gosod fel y Peiriant Chwilio Rhagosodedig ar gyfer Windows Preifat
    .accesskey = G
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
    .tooltiptext = Nodau tudalen ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Tabiau ({ $restrict })
search-one-offs-history =
    .tooltiptext = Hanes ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Dangos y golygydd wrth gadw
    .accesskey = D
bookmark-panel-done-button =
    .label = Gorffen
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Cysylltiad yn anniogel
identity-connection-secure = Cysylltiad yn ddiogel
identity-connection-internal = Mae hon yn dudalen { -brand-short-name } diogel.
identity-connection-file = Mae'r dudalen hon wedi ei chadw ar eich cyfrifiadur.
identity-extension-page = Mae'r dudalen wedi ei llwytho o estyniad.
identity-active-blocked = Mae { -brand-short-name } wedi rhwystro rhannau o'r dudalen nad ydynt yn ddiogel.
identity-custom-root = Dilyswyd y cysylltiad gan gyhoeddwr tystysgrif nad yw'n cael ei gydnabod gan Mozilla.
identity-passive-loaded = Nid yw rhannau o'r dudalen hon yn ddiogel (megis delweddau).
identity-active-loaded = Rydych wedi analluogi diogelwch ar y dudalen hon.
identity-weak-encryption = Mae'r dudalen hon yn defnyddio amgryptiad gwan.
identity-insecure-login-forms = Gall mewngofnodion sy'n cael eu cyflwyno ar y dudalen hon gael eu cyfaddawdu.
identity-permissions =
    .value = Caniatâd
identity-permissions-reload-hint = Efallai y bydd angen ail lwytho'r dudalen i newidiadau ddod ar waith.
identity-permissions-empty = Nid ydych wedi rhoi i'r wefan hon unrhyw ganiatâd arbennig.
identity-clear-site-data =
    .label = Clirio Data Cwcis a Gwefan…
identity-connection-not-secure-security-view = Nid ydych wedi'ch cysylltu'n ddiogel â'r wefan hon.
identity-connection-verified = Rydych wedi eich cysylltu'n ddiogel â'r wefan hon.
identity-ev-owner-label = Tystysgrif wedi'i ryddhau i:
identity-description-custom-root = Nid yw Mozilla yn cydnabod y cyhoeddwr tystysgrif hwn. Efallai ei fod wedi'i ychwanegu o'ch system weithredu neu gan weinyddwr. <label data-l10n-name="link">Dysgu Rhagor</label>
identity-remove-cert-exception =
    .label = Tynnu Eithriad
    .accesskey = E
identity-description-insecure = Nid yw eich cysylltiad â'r dudalen hon yn breifat. Gall gwybodaeth fyddwch yn ei gyflwyno cael ei weld gan eraill (megis cyfrineiriau, negeseuon, cardiau credyd, ac ati.).
identity-description-insecure-login-forms = Nid yw'r manylion mewngofnodi rydych wedi ei roi i'r dudalen yn ddiogel a gall fod wedi ei danseilio.
identity-description-weak-cipher-intro = Mae eich cysylltiad i'r wefan hon yn defnyddio amgryptiad gwan ac nid yw'n breifat.
identity-description-weak-cipher-risk = Gall bobl eraill weld eich manylion neu newid ymddygiad y wefan.
identity-description-active-blocked = Mae { -brand-short-name } wedi rhwystro rhannau o'r dudalen nad ydynt yn ddiogel. <label data-l10n-name="link">Dysgu Rhagor</label>
identity-description-passive-loaded = Nid yw eich cysylltiad yn breifat ac mae'n bosib i wybodaeth rydych yn ei rannu gael ei weld gan eraill.
identity-description-passive-loaded-insecure = Mae'r wefan yn cynnwys deunydd nad yw'n ddiogel (megis delweddau). <label data-l10n-name="link">Dysgu Rhagor</label>
identity-description-passive-loaded-mixed = Er bod { -brand-short-name } wedi rhwystro peth cynnwys, mae cynnwys dal ar y dudalen nad yw'n ddiogel (megis delweddau). <label data-l10n-name="link">Dysgu Rhagor</label>
identity-description-active-loaded = Mae'r wefan yn cynnwys yn deunydd nad yw'n ddiogel (megis sgriptiau) ac nid yw eich cysylltiad â nhw'n breifat.
identity-description-active-loaded-insecure = Gall gwybodaeth fyddwch yn ei gyflwyno cael ei weld gan eraill (megis cyfrineiriau, negeseuon, cardiau credyd, ac ati.).
identity-learn-more =
    .value = Dysgu Rhagor
identity-disable-mixed-content-blocking =
    .label = Analluogi diogelu dros dro
    .accesskey = A
identity-enable-mixed-content-blocking =
    .label = Galluogi diogelu
    .accesskey = G
identity-more-info-link-text =
    .label = Rhagor o Wybodaeth

## Window controls

browser-window-minimize-button =
    .tooltiptext = Lleihau
browser-window-maximize-button =
    .tooltiptext = Mwyhau
browser-window-restore-down-button =
    .tooltiptext = Adfer i Lawr
browser-window-close-button =
    .tooltiptext = Cau

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Camera i'w rannu:
    .accesskey = C
popup-select-microphone =
    .value = Meicroffon i'w rannu:
    .accesskey = M
popup-all-windows-shared = Bydd pob ffenestr gweladwy ar eich sgrin yn cael eu rhannu.
popup-screen-sharing-not-now =
    .label = Nid Nawr
    .accesskey = N
popup-screen-sharing-never =
    .label = Byth Caniatáu
    .accesskey = B
popup-silence-notifications-checkbox = Analluogi hysbysiadau gan { -brand-short-name } wrth rannu
popup-silence-notifications-checkbox-warning = Ni fydd { -brand-short-name } yn dangos hysbysiadau tra'ch bod chi'n rhannu.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Rydych yn rhannu { -brand-short-name }. Gall pobl eraill weld pan fyddwch chi'n newid i dab newydd.
sharing-warning-screen = Rydych chi'n rhannu'ch sgrin gyfan. Gall pobl eraill weld pan fyddwch chi'n newid i dab newydd.
sharing-warning-proceed-to-tab =
    .label = Ymlaen i Dab
sharing-warning-disable-for-session =
    .label = Analluogi diogelwch rhannu ar gyfer y sesiwn hon

## DevTools F12 popup

enable-devtools-popup-description = I ddefnyddio llwybr byr F12 agorwch DevTools yn gyntaf trwy'r ddewislen Datblygwr Gwe.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Chwilio neu gyfeiriad gwe
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Chwilio neu gyfeiriad gwe
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Chwilio'r We
    .aria-label = Chwilio gyda { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Rhowch dermau chwilio
    .aria-label = Chwilio { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Rhowch dermau chwilio
    .aria-label = Chwilio'r nodau tudalen
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Rhowch dermau chwilio
    .aria-label = Chwilio'ch hanes
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Rhowch dermau chwilio
    .aria-label = Chwilio'r tabiau
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Chwilio gyda { $name } neu rhoi'r cyfeiriad
urlbar-remote-control-notification-anchor =
    .tooltiptext = Mae'r porwr o dan reolaeth bell
urlbar-permissions-granted =
    .tooltiptext = Rydych wedi rhoi caniatâd ychwanegol i'r wefan hon.
urlbar-switch-to-tab =
    .value = Newid i dab:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Estyniad:
urlbar-go-button =
    .tooltiptext = Mynd i'r cyfeiriad yn y Bar Lleoliad
urlbar-page-action-button =
    .tooltiptext = Gweithredoedd tudalen
urlbar-pocket-button =
    .tooltiptext = Cadw i { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> nawr yn sgrin lawn
fullscreen-warning-no-domain = Mae'r ddogfen nawr yn sgrin lawn
fullscreen-exit-button = Gadael y Sgrin Lawn (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Gadael y Sgrin Lawn (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> reolaeth o'ch pwyntydd. Pwyswch Esc i adennill rheolaeth.
pointerlock-warning-no-domain = Mae gan y ddogfen hon reolaeth o'ch pwyntydd. Pwyswch Esc i adennill rheolaeth.
