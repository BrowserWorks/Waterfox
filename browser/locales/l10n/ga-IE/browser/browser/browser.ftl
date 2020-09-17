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
    .data-title-private = { -brand-full-name } (Brabhsáil Phríobháideach)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Brabhsáil Phríobháideach)
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
    .data-title-private = { -brand-full-name } - (Brabhsáil Phríobháideach)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Brabhsáil Phríobháideach)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Eolas faoin suíomh

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Oscail painéal teachtaireachtaí na suiteála
urlbar-web-notification-anchor =
    .tooltiptext = Athraigh pé acu an bhfaighidh nó nach bhfaighidh tú fógraí ón suíomh
urlbar-midi-notification-anchor =
    .tooltiptext = Oscail an painéal MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Bainistigh bogearraí DRM
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Bainistigh comhroinnt do mhicreafóin leis an suíomh
urlbar-default-notification-anchor =
    .tooltiptext = Oscail painéal na dteachtaireachtaí
urlbar-geolocation-notification-anchor =
    .tooltiptext = Oscail painéal an iarratais suímh
urlbar-translate-notification-anchor =
    .tooltiptext = Aistrigh an leathanach seo
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Bainistigh comhroinnt fuinneog nó scáileáin leis an suíomh
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Oscail painéal teachtaireachtaí an stórais as líne
urlbar-password-notification-anchor =
    .tooltiptext = Oscail painéal teachtaireachtaí sábháil focal faire
urlbar-translated-notification-anchor =
    .tooltiptext = Bainistigh aistriúchán an leathanaigh
urlbar-plugins-notification-anchor =
    .tooltiptext = Bainistigh úsáid na bhforlíontán
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Bainistigh comhroinnt do cheamara agus/nó do mhicreafón leis an suíomh
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Sábháil sonraí sa Stóras Seasmhach
urlbar-addons-notification-anchor =
    .tooltiptext = Oscail an painéal um theachtaireachtaí suiteála breiseáin
urlbar-tip-help-icon =
    .title = Faigh cabhair
urlbar-search-tips-confirm = Maith go leor, tuigim

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Chuir tú cosc ar an suíomh seo an áit ina bhfuil tú a fheiceáil.
urlbar-web-notifications-blocked =
    .tooltiptext = Chuir tú cosc ar fhógraí ón suíomh seo.
urlbar-camera-blocked =
    .tooltiptext = Chuir tú cosc ar do cheamara ar an suíomh seo.
urlbar-microphone-blocked =
    .tooltiptext = Chuir tú cosc ar do mhicreafón ar an suíomh seo.
urlbar-screen-blocked =
    .tooltiptext = Chuir tú cosc ar an suíomh seo do scáileán a chomhroinnt.
urlbar-persistent-storage-blocked =
    .tooltiptext = Chuir tú cosc ar stóras seasmhach ar an suíomh seo.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Cuir an leabharmharc seo in eagar ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Cruthaigh leabharmharc don leathanach seo ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension =
    .label = Bainistigh an Breiseán…

## Auto-hide Context Menu

full-screen-autohide =
    .label = Folaigh Barraí Uirlisí
    .accesskey = h
full-screen-exit =
    .label = Fág Mód Lánscáileáin
    .accesskey = L

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = An uair seo, cuardaigh le:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Socruithe Cuardaigh
search-one-offs-change-settings-compact-button =
    .tooltiptext = Athraigh na socruithe cuardaigh
search-one-offs-context-open-new-tab =
    .label = Cuardaigh i gCluaisín Nua
    .accesskey = r
search-one-offs-context-set-as-default =
    .label = Socraigh mar Inneall Cuardaigh Réamhshocraithe
    .accesskey = d

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-done-button =
    .label = Déanta

## Identity Panel

identity-connection-internal = Is leathanach slán { -brand-short-name } é seo.
identity-connection-file = Stóráiltear an leathanach seo ar do ríomhaire.
identity-extension-page = Lódáiltear an leathanach seo ó eisínteacht.
identity-active-blocked = Chuir { -brand-short-name } bac ar chodanna den leathanach seo nach bhfuil slán.
identity-passive-loaded = Tá codanna den leathanach seo neamhshlán (léithéidí íomhánna).
identity-active-loaded = Tá cosaint díchumasaithe agat ar an leathanach seo.
identity-weak-encryption = Úsáideann an leathanach seo criptiú lag.
identity-insecure-login-forms = D'fhéadfadh sonraí logáil isteach bheith i mbaol ar an leathanach seo.
identity-permissions =
    .value = Ceadanna
identity-permissions-reload-hint = Ní mór duit an leathanach a athlódáil chun na hathruithe a chur i bhfeidhm.
identity-permissions-empty = Níor thug tú aon chead speisialta don suíomh seo.
identity-clear-site-data =
    .label = Glan na Fianáin agus Sonraí Suímh...
identity-remove-cert-exception =
    .label = Bain an Eisceacht
    .accesskey = B
identity-description-insecure = Níl do cheangal leis an suíomh seo príobháideach. D'fhéadfadh daoine eile an t-eolas a aighníonn tú a fheiscint (leithéidí focail faire, teachtaireachtaí, cártaí creidmheasa, etc.)
identity-description-insecure-login-forms = Níl an fhaisnéis chuntais a chuireann tú isteach ar an leathanach seo seolta thar ceangal slán, agus seans go mbeadh bradaí in ann teacht air.
identity-description-weak-cipher-intro = Úsáideann do cheangal leis an suíomh seo criptiúchán lag nach bhfuil príobháideach.
identity-description-weak-cipher-risk = Is féidir le daoine eile do chuid sonraí a fheiceáil agus iompar an tsuímh a athrú.
identity-description-active-blocked = Chuir { -brand-short-name } bac ar chodanna den leathanach seo nach bhfuil slán. <label data-l10n-name="link">Tuilleadh Eolais</label>
identity-description-passive-loaded = Níl do cheangal príobháideach, leis seo d'fhéadfadh daoine eile aon eolas a roinneann tú ar an suíomh a fheiscint.
identity-description-passive-loaded-insecure = Tá ábhar neamhshlán ar an suíomh seo (leithéidí íomhánna). <label data-l10n-name="link">Tuilleadh Eolais</label>
identity-description-passive-loaded-mixed = Cé gur chuir { -brand-short-name } bac ar roinnt ábhar, tá ábhar neamhshlán ar an leathanach seo go fóill (leithéidí íomhánna). <label data-l10n-name="link">Tuilleadh Eolais</label>
identity-description-active-loaded = Tá ábhar neamhshlán ar an suíomh seo (leithéidí scripteanna) agus níl do cheangal leis príobháideach.
identity-description-active-loaded-insecure = D'fhéadfadh daoine eile an t-eolas a roinneann tú ar an suíomh seo a fheiscint (leithéidí focail faire, teachtaireachtaí, cártaí creidmheasa, etc.)
identity-learn-more =
    .value = Tuilleadh Eolais
identity-disable-mixed-content-blocking =
    .label = Díchumasaigh cosaint don am i láthair
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Cumasaigh cosaint
    .accesskey = C
identity-more-info-link-text =
    .label = Tuilleadh Eolais

## Window controls

browser-window-minimize-button =
    .tooltiptext = Íoslaghdaigh
browser-window-close-button =
    .tooltiptext = Dún

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Ceamara le comhroinnt:
    .accesskey = C
popup-select-microphone =
    .value = Micreafón le comhroinnt:
    .accesskey = M
popup-all-windows-shared = Comhroinnfear gach fuinneog infheicthe ar do scáileáin.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Cuardaigh nó cuir seoladh isteach
urlbar-placeholder =
    .placeholder = Cuardaigh nó cuir seoladh isteach
urlbar-remote-control-notification-anchor =
    .tooltiptext = Tá an brabhsálaí faoi chianrialú
urlbar-switch-to-tab =
    .value = Téigh go cluaisín:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Eisínteacht:
urlbar-go-button =
    .tooltiptext = Téigh go dtí an seoladh atá sa Bharra Suímh
urlbar-page-action-button =
    .tooltiptext = Gníomhartha leathanaigh
urlbar-pocket-button =
    .tooltiptext = Sábháil i b{ -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = Tá <span data-l10n-name="domain">{ $domain }</span> ar lánscáileán anois
fullscreen-warning-no-domain = Tá an cháipéis seo ar lánscáileán anois
fullscreen-exit-button = Fág Mód Lánscáileáin (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Fág Mód Lánscáileáin (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = Tá <span data-l10n-name="domain">{ $domain }</span> i gceannas ar do chúrsóir faoi láthair. Brúigh Esc chun dul i gceannas air arís.
pointerlock-warning-no-domain = Tá an cháipéis seo i gceannas ar do chúrsóir faoi láthair. Brúigh Esc chun dul i gceannas air arís.
