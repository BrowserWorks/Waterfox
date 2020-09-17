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
    .data-title-private = { -brand-full-name } (Private blaaiery)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Private blaaiery)
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
    .data-title-private = { -brand-full-name } - (Private blaaiery)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Private blaaiery)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Wys werfinligting

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Open paneel met installasieboodskappe
urlbar-web-notification-anchor =
    .tooltiptext = Verander of boodskappe van dié werf ontvang kan word
urlbar-eme-notification-anchor =
    .tooltiptext = Bestuur die gebruik van DRM-sagteware
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Bestuur die deel van die mikrofoon met die werf
urlbar-default-notification-anchor =
    .tooltiptext = Open boodskappaneel
urlbar-geolocation-notification-anchor =
    .tooltiptext = Open liggingversoek-paneel
urlbar-translate-notification-anchor =
    .tooltiptext = Vertaal dié bladsy
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Bestuur die deel van vensters of die skerm met die werf
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Open paneel met boodskappe oor stoorplek vanlyn
urlbar-password-notification-anchor =
    .tooltiptext = Open paneel vir die stoor van wagwoorde
urlbar-translated-notification-anchor =
    .tooltiptext = Bestuur bladsyvertaling
urlbar-plugins-notification-anchor =
    .tooltiptext = Bestuur gebruik van inproppe
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Bestuur die deel van die kamera en/of mikrofoon met die werf
urlbar-addons-notification-anchor =
    .tooltiptext = Open paneel met boodskappe oor byvoeginginstallasie

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = U het ligginginligting geblok vir dié webwerf.
urlbar-web-notifications-blocked =
    .tooltiptext = U het kennisgewings geblok vir dié webwerf.
urlbar-camera-blocked =
    .tooltiptext = U het die kamera geblok vir dié webwerf.
urlbar-microphone-blocked =
    .tooltiptext = U het die mikrofoon geblok vir dié webwerf.
urlbar-screen-blocked =
    .tooltiptext = U het dié webwerf geblok om die skerm te deel.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Redigeer hierdie boekmerk ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Boekmerk hierdie bladsy ({ $shortcut })

## Page Action Context Menu


## Auto-hide Context Menu

full-screen-autohide =
    .label = Verskuil nutsbalke
    .accesskey = V
full-screen-exit =
    .label = Sluit volskermmodus af
    .accesskey = v

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Verander soekinstellings
search-one-offs-change-settings-compact-button =
    .tooltiptext = Verander soekinstellings
search-one-offs-context-open-new-tab =
    .label = Soek in nuwe oortjie
    .accesskey = t
search-one-offs-context-set-as-default =
    .label = Stel as verstek-soekenjin
    .accesskey = v

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-done-button =
    .label = Klaar

## Identity Panel

identity-connection-internal = Hierdie is 'n beveiligde { -brand-short-name }-bladsy.
identity-connection-file = Dié blad word op u rekenaar gestoor.
identity-extension-page = Dié bladsy is uit 'n uitbreiding gelaai.
identity-active-blocked = { -brand-short-name } het dele van dié blad geblok wat nie beveilig is nie.
identity-passive-loaded = Dele van dié blad is nie beveilig nie (soos prente).
identity-active-loaded = U het beskerming vir dié blad gedeaktiveer.
identity-weak-encryption = Dié bladsy gebruik swak enkripsie.
identity-insecure-login-forms = Aanmeldinligting ingetik op dié bladsy kan gekompromitteer word.
identity-permissions-reload-hint = Dit is dalk nodig om die bladsy te herlaai voor veranderinge toegepas word.
identity-permissions-empty = U het geen spesiale toestemming aan dié werf gegee nie.
identity-remove-cert-exception =
    .label = Verwyder uitsondering
    .accesskey = r
identity-description-insecure = U verbinding aan dié werf is nie privaat nie. Inligting wat ingedien word kan deur ander gesien word (bv. wagwoorde, boodskappe, kredietkaartnommers, ens.)
identity-description-insecure-login-forms = Die aanmeldinligting wat u op hierdie bladsy intik, is nie beveilig nie en kan gekompromitteer word.
identity-description-weak-cipher-intro = U verbinding aan dié werf gebruik swak enkripsie en is nie privaat nie.
identity-description-weak-cipher-risk = Ander mense kan u inligting sien of die webwerf se gedrag verander.
identity-description-active-blocked = { -brand-short-name } het dele van dié blad geblok wat nie beveilig is nie. <label data-l10n-name="link">Meer inligting</label>
identity-description-passive-loaded = U verbinding is nie privaat nie en inligting wat met die werf gedeel word kan deur ander gesien word.
identity-description-passive-loaded-insecure = Dié webwerf bevat inhoud wat nie beveilig is nie (soos prente). <label data-l10n-name="link">Meer inligting</label>
identity-description-passive-loaded-mixed = Alhoewel { -brand-short-name } sommige inhoud geblok het, is daar steeds inhoud op die bladsy wat nie beveilig is nie (soos prente). <label data-l10n-name="link">Meer inligting</label>
identity-description-active-loaded = Dié webwerf bevat inhoud wat nie beveilig is nie (soos skripte) en u verbinding daaraan is nie privaat nie.
identity-description-active-loaded-insecure = Inligting wat gedeel word met die werf kan deur ander gesien word (bv. wagwoorde, boodskappe, kredietkaartnommers, ens.).
identity-learn-more =
    .value = Meer inligting
identity-disable-mixed-content-blocking =
    .label = Deaktiveer beskerming tydelik
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Aktiveer beskerming
    .accesskey = A
identity-more-info-link-text =
    .label = Meer inligting

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimeer
browser-window-close-button =
    .tooltiptext = Sluit

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera om te deel:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofoon om te deel:
    .accesskey = M
popup-all-windows-shared = Alle sigbare vensters op die skerm sal gedeel word.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Soek of tik adres in
urlbar-placeholder =
    .placeholder = Soek of tik adres in
urlbar-switch-to-tab =
    .value = Verwissel na oortjie:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Uitbreiding:
urlbar-go-button =
    .tooltiptext = Gaan na die adres in die adresbalk

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> beslaan nou die volle skerm
fullscreen-warning-no-domain = Dié dokument beslaan nou die volle skerm
fullscreen-exit-button = Verlaat volskerm (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Verlaat volskerm (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> beheer tans die wyser. Druk Esc om beheer terug te kry.
pointerlock-warning-no-domain = Dié dokument beheer tans die wyser. Druk Esc om beheer terug te kry.
