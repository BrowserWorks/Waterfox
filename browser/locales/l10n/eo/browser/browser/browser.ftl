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
    .data-title-private = { -brand-full-name } (Privata retumo)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privata retumo)
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
    .data-title-private = { -brand-full-name } - (Privata retumo)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privata retumo)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Vidi informon de la retejo

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Malfermi panelon de mesaĝoj de instalo
urlbar-web-notification-anchor =
    .tooltiptext = Decidi ĉu vi povas ricevi sciigojn el la retejo
urlbar-midi-notification-anchor =
    .tooltiptext = Malfermi panelon MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Administri uzon de DRM programaro
urlbar-web-authn-anchor =
    .tooltiptext = Malfermi panelon de Teksaĵa aŭtentikigo
urlbar-canvas-notification-anchor =
    .tooltiptext = Administri permeson por eltiri la kanvason
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Administri dividon de via mikrofono kun la retejo
urlbar-default-notification-anchor =
    .tooltiptext = Malfermi panelon de mesaĝoj
urlbar-geolocation-notification-anchor =
    .tooltiptext = Malfermi panelon de peto de pozicio
urlbar-xr-notification-anchor =
    .tooltiptext = Malfermi panelon de permesoj por virtuala realo
urlbar-storage-access-anchor =
    .tooltiptext = Malfermi panelon de permesoj de retumo
urlbar-translate-notification-anchor =
    .tooltiptext = Traduki tiun ĉi paĝon
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Administri dividon de viaj fenestroj aŭ ekrano kun la retejo
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Malfermi panelon de konservejo por malkonektitaĵoj
urlbar-password-notification-anchor =
    .tooltiptext = Malfermi panelon de konservo de pasvortoj
urlbar-translated-notification-anchor =
    .tooltiptext = Administri tradukadon de paĝo
urlbar-plugins-notification-anchor =
    .tooltiptext = Administri uzon de kromprogramoj
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Administri dividon de via filmilo kaj/aŭ mikrofonon kun la retejo
urlbar-autoplay-notification-anchor =
    .tooltiptext = Malfermi panelon de aŭtomata ludado
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Konservi datumojn en daŭra konservejo
urlbar-addons-notification-anchor =
    .tooltiptext = Malfermi panelon de mesaĝoj de instalo de aldonaĵo
urlbar-tip-help-icon =
    .title = Helpo
urlbar-search-tips-confirm = En ordo, mi komprenis
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Konsileto:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Tajpu malpli, trovi pli: serĉi per { $engineName } rekte el via adresa strio.
urlbar-search-tips-redirect-2 = Komencu vian serĉon en la adresa strio por vidi sugestojn el { $engineName } kaj el via retuma historio.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Legosignoj
urlbar-search-mode-tabs = Langetoj
urlbar-search-mode-history = Historio

##

urlbar-geolocation-blocked =
    .tooltiptext = Vi blokis informon pri via pozicio por tiu ĉi retejo.
urlbar-xr-blocked =
    .tooltiptext = Vi blokis la aliron al aparatoj de virtuala realo por tiu ĉi retejo.
urlbar-web-notifications-blocked =
    .tooltiptext = Vi blokis sciigojn por tiu ĉi retejo.
urlbar-camera-blocked =
    .tooltiptext = Vi blokis vian filmilon por tiu ĉi retejo.
urlbar-microphone-blocked =
    .tooltiptext = Vi blokis vian mikrofonon por tiu ĉi retejo.
urlbar-screen-blocked =
    .tooltiptext = Vi blokis dividon de la ekrano por tiu retejo.
urlbar-persistent-storage-blocked =
    .tooltiptext = Vi blokis la daŭran konservejon por ĉi tiu retejo.
urlbar-popup-blocked =
    .tooltiptext = Vi blokis ŝprucfenestrojn por tiu ĉi retejo.
urlbar-autoplay-media-blocked =
    .tooltiptext = Vi blokis aŭtomatan ludadon de sono por tiu ĉi retejo.
urlbar-canvas-blocked =
    .tooltiptext = Vi blokis la eltiron de datumoj el kanvaso por tiu ĉi retejo.
urlbar-midi-blocked =
    .tooltiptext = Vi blokis la aliron MIDI por tiu ĉi retejo.
urlbar-install-blocked =
    .tooltiptext = Vi blokis la instalon de aldonaĵoj por tiu ĉi retejo.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Redakti tiun ĉi legosignon ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Aldoni legosignon por tiu ĉi paĝo ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Aldoni al adresa strio
page-action-manage-extension =
    .label = Administri etendaĵon…
page-action-remove-from-urlbar =
    .label = Forigi el adresa strio
page-action-remove-extension =
    .label = Forigi etendaĵon

## Auto-hide Context Menu

full-screen-autohide =
    .label = Kaŝi ilarojn
    .accesskey = K
full-screen-exit =
    .label = Eliri el plenekrana reĝimo
    .accesskey = P

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Ĉi foje serĉi per:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Ŝanĝi agordojn de serĉo
search-one-offs-change-settings-compact-button =
    .tooltiptext = Ŝanĝi agordojn de serĉo
search-one-offs-context-open-new-tab =
    .label = Serĉi en nova langeto
    .accesskey = l
search-one-offs-context-set-as-default =
    .label = Igi serĉilon norma
    .accesskey = n
search-one-offs-context-set-as-default-private =
    .label = Igi ĝin la norma serĉilo en privataj fenestroj
    .accesskey = n
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
    .tooltiptext = Legosignoj ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Folioj ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historio ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Montri redaktilon dum konservo
    .accesskey = M
bookmark-panel-done-button =
    .label = Preta
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 24em

## Identity Panel

identity-connection-not-secure = Nesekura konekto
identity-connection-secure = Sekura konekto
identity-connection-internal = Tiu ĉi estas sekura paĝo de { -brand-short-name }.
identity-connection-file = Tiu ĉi paĝo estas konservita en via komputilo.
identity-extension-page = Tiu ĉi paĝo estas ŝargata de etendaĵo.
identity-active-blocked = { -brand-short-name } blokis partojn de tiu ĉi paĝo, kiuj ne estas sekuraj.
identity-custom-root = Konekto kontrolita de eldoninto de atestilo, kiu ne estas rekonita de Mozilla.
identity-passive-loaded = Partoj de tiu ĉi paĝo ne estas sekuraj (bildoj, ekzemple).
identity-active-loaded = Mi malaktivigis protekton en tiu ĉi paĝo.
identity-weak-encryption = Tiu ĉi paĝo uzas malfortan ĉifradon.
identity-insecure-login-forms = Akreditiloj uzitaj en tiu ĉi paĝo povus esti riskitaj.
identity-permissions =
    .value = Permesoj
identity-permissions-reload-hint = Vi eble bezonos reŝargi la paĝon por ke la ŝanĝoj estu aplikitaj.
identity-permissions-empty = Vi ne donis iun ajn specialan permeson al tiu ĉi retejo.
identity-clear-site-data =
    .label = Viŝi kuketojn kaj retejajn datumojn…
identity-connection-not-secure-security-view = Vi ne estas sekure konektita al tiu ĉi retejo.
identity-connection-verified = Vi estas sekure konektita al tiu ĉi retejo.
identity-ev-owner-label = Atestilo eldonita por:
identity-description-custom-root = Mozilla ne rekonas tiun ĉi eldoninton de atestiloj. Ĝi eble estis aldonita de via mastruma sistemo aŭ de administranto. <label data-l10n-name="link">Pli da informo</label>
identity-remove-cert-exception =
    .label = Forigi escepton
    .accesskey = F
identity-description-insecure = Via konekto al tiu ĉi retejo ne estas privata. La datumoj, kiujn vi sendas (ekzemple pasvortojn, mesaĝojn, kreditkartojn, ktp.), povus esti viditaj de aliaj.
identity-description-insecure-login-forms = La akreditiloj, kiujn vi tajpas en tiu ĉi paĝo, ne estas sekuraj kaj povus esti minacataj.
identity-description-weak-cipher-intro = Via konekto al tiu ĉi retejo uzas malfortan ĉifradon kaj ne estas privata.
identity-description-weak-cipher-risk = Aliaj personoj povus vidi viajn datumojn aŭ modifi la konduton de la retejo.
identity-description-active-blocked = { -brand-short-name } blokis partojn de tiu paĝo, kiuj ne estas sekuraj. <label data-l10n-name="link">Pli da informo</label>
identity-description-passive-loaded = Via konekto ne estas privata kaj la datumoj, kiujn vi dividas kun la retejo, povus esti viditaj de aliaj.
identity-description-passive-loaded-insecure = Tiu ĉi retejo enhavas nesekurajn elementojn (bildoj, ekzemple). <label data-l10n-name="link">Pli da informo</label>
identity-description-passive-loaded-mixed = Kvankam { -brand-short-name } blokis iom de la enhavo, ankoraŭ estas nesekuraj elementoj en la paĝo (bildoj, ekzemple). <label data-l10n-name="link">Pli da informo</label>
identity-description-active-loaded = Tiu ĉi retejo enhavas nesekurajn elementojn (skriptojn, ekzemple) kaj via konekto al ĝi ne estas privata.
identity-description-active-loaded-insecure = Datumoj, kiujn vi dividas kun tiu ĉi retejo, povus esti viditaj de aliaj (ekzemple pasvortoj, mesaĝoj, kreditkartoj, ktp.
identity-learn-more =
    .value = Pli da informo
identity-disable-mixed-content-blocking =
    .label = Momente malaktivigi la protekton
    .accesskey = M
identity-enable-mixed-content-blocking =
    .label = Aktivigi protekton
    .accesskey = A
identity-more-info-link-text =
    .label = Pli da informo

## Window controls

browser-window-minimize-button =
    .tooltiptext = Malplejgrandigi
browser-window-maximize-button =
    .tooltiptext = Plejgrandigi
browser-window-restore-down-button =
    .tooltiptext = Remeti antaŭan grandon
browser-window-close-button =
    .tooltiptext = Fermi

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Dividota filmilo:
    .accesskey = f
popup-select-microphone =
    .value = Dividota mikrofono:
    .accesskey = m
popup-all-windows-shared = Ĉiuj videblaj fenestroj en via ekrano estos dividitaj.
popup-screen-sharing-not-now =
    .label = Ne nun
    .accesskey = N
popup-screen-sharing-never =
    .label = Neniam permesi
    .accesskey = N
popup-silence-notifications-checkbox = Malaktivigi sciigojn de { -brand-short-name } dum divido
popup-silence-notifications-checkbox-warning = { -brand-short-name } ne montros sciigojn dum vi dividas.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Vi dividas { -brand-short-name }. Aliaj personoj povas vidi kiam vi iras al alia langeto.
sharing-warning-screen = Vi dividis vian tutan ekranon. Aliaj personoj povas vidi kiam vi iras al alia langeto.
sharing-warning-proceed-to-tab =
    .label = Daŭrigi al langeto
sharing-warning-disable-for-session =
    .label = Malaktivigi la protekton de divido por tiu ĉi seanco

## DevTools F12 popup

enable-devtools-popup-description = Por uzi la ŝparvojon F12, unue malfermu la ilojn por programistoj el la menuo Teksaĵa programisto.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Serĉu ion aŭ tajpu adreson
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Serĉu ion aŭ tajpu adreson
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Serĉi en la teksaĵo
    .aria-label = Serĉi per { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Tajpu serĉan tekston
    .aria-label = Serĉi { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Tajpu serĉan tekston
    .aria-label = Serĉi legosignojn
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Tajpu serĉan tekston
    .aria-label = Serĉi historion
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Tajpu serĉan tekston
    .aria-label = Serĉi langetojn
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Serĉi per { $name } aŭ tajpi adreson
urlbar-remote-control-notification-anchor =
    .tooltiptext = La retumilo estas sub fora regado
urlbar-permissions-granted =
    .tooltiptext = Vi aldonis permesojn al tiu ĉi retejo.
urlbar-switch-to-tab =
    .value = Iri al langeto:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Etendaĵo:
urlbar-go-button =
    .tooltiptext = Iri al la adreso en la retadresa strio
urlbar-page-action-button =
    .tooltiptext = Retpaĝaj agoj
urlbar-pocket-button =
    .tooltiptext = Konservi en { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> videblas nun plenekrane
fullscreen-warning-no-domain = Tiu ĉi dokumento videbas nun plenekrane
fullscreen-exit-button = Eliri el plenekrana reĝimo (Esk)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Eliri el plenekrana reĝimo (esk)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> regas vian musmontrilon. Premu Esk por repreni la regadon.
pointerlock-warning-no-domain = Tiu ĉi dokumento regas vian musmontrilon. Premu Esk por repreni la regadon.
