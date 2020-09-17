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
    .data-title-private = { -brand-full-name } (Privat browsing)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privat browsing)
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
    .data-title-private = { -brand-full-name } - (Privat browsing)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privat browsing)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Vis information om websted

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Åbn panelet for beskeder om installering
urlbar-web-notification-anchor =
    .tooltiptext = Vælg om du vil modtage beskeder fra webstedet
urlbar-midi-notification-anchor =
    .tooltiptext = Åbn MIDI-panel
urlbar-eme-notification-anchor =
    .tooltiptext = Administrer brug af DRM-software
urlbar-web-authn-anchor =
    .tooltiptext = Åbn panelet web-godkendelse
urlbar-canvas-notification-anchor =
    .tooltiptext = Håndter tilladelser for canvas-ekstraktion
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Administrer deling af din mikrofon med webstedet
urlbar-default-notification-anchor =
    .tooltiptext = Åbn panelet for beskeder
urlbar-geolocation-notification-anchor =
    .tooltiptext = Åbn panelet for positions-forespørgsler
urlbar-xr-notification-anchor =
    .tooltiptext = Åbn panelet tilladelser for virtual reality
urlbar-storage-access-anchor =
    .tooltiptext = Åbn panelet tilladelser for browsing-aktivitet
urlbar-translate-notification-anchor =
    .tooltiptext = Oversæt siden
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Administrer deling af dine vinduer eller skærm med webstedet
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Åbn panelet for beskeder om app-offline-lager
urlbar-password-notification-anchor =
    .tooltiptext = Åbn panelet for beskeder om at gemme adgangskoder
urlbar-translated-notification-anchor =
    .tooltiptext = Administrer side-oversættelser
urlbar-plugins-notification-anchor =
    .tooltiptext = Administrer brug af plugins
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Administrer deling af dit kamera og/eller mikrofon med webstedet
urlbar-autoplay-notification-anchor =
    .tooltiptext = Åbn panelet for automatisk afspilning
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Gem data i vedvarende lager
urlbar-addons-notification-anchor =
    .tooltiptext = Åbn panelet for beskeder om installering af tilføjelser
urlbar-tip-help-icon =
    .title = Få hjælp
urlbar-search-tips-confirm = Okay, forstået
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tip:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Tast mindre, find mere: Søg med { $engineName } direkte i adressefeltet.
urlbar-search-tips-redirect-2 = Start din søgning i adressefeltet for at få forslag fra { $engineName } og din browserhistorik.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Bogmærker
urlbar-search-mode-tabs = Faneblade
urlbar-search-mode-history = Historik

##

urlbar-geolocation-blocked =
    .tooltiptext = Du har blokeret dette websteds mulighed for at se din position.
urlbar-xr-blocked =
    .tooltiptext = Du har blokeret dette websteds adgang til virtual reality-enheder
urlbar-web-notifications-blocked =
    .tooltiptext = Du har blokeret beskeder fra dette websted.
urlbar-camera-blocked =
    .tooltiptext = Du har blokeret dit kamera for dette websted.
urlbar-microphone-blocked =
    .tooltiptext = Du har blokeret din mikrofon for dette websted.
urlbar-screen-blocked =
    .tooltiptext = Du har blokeret skærmdeling for dette websted.
urlbar-persistent-storage-blocked =
    .tooltiptext = Du har blokeret vedvarende lager for dette websted.
urlbar-popup-blocked =
    .tooltiptext = Du har blokeret pop op-vinduer for dette websted.
urlbar-autoplay-media-blocked =
    .tooltiptext = Du har blokeret automatisk afspilning af mediefiler med lyd for dette websted.
urlbar-canvas-blocked =
    .tooltiptext = Du har blokeret kanvas-ekstraktion for dette websted.
urlbar-midi-blocked =
    .tooltiptext = Du har blokeret MIDI-adgang for dette websted.
urlbar-install-blocked =
    .tooltiptext = Du har blokeret installering af tilføjelser for dette websted.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Rediger dette bogmærke ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Bogmærk denne side ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Føj til adressefeltet
page-action-manage-extension =
    .label = Håndter udvidelse…
page-action-remove-from-urlbar =
    .label = Fjern fra adressefeltet
page-action-remove-extension =
    .label = Fjern udvidelse

## Auto-hide Context Menu

full-screen-autohide =
    .label = Skjul værktøjslinjer
    .accesskey = S
full-screen-exit =
    .label = Afslut fuld skærm
    .accesskey = A

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Søg denne gang med:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Skift søgeindstillinger
search-one-offs-change-settings-compact-button =
    .tooltiptext = Skift søgeindstillinger
search-one-offs-context-open-new-tab =
    .label = Søg i nyt faneblad
    .accesskey = f
search-one-offs-context-set-as-default =
    .label = Sæt som standard-søgetjeneste
    .accesskey = s
search-one-offs-context-set-as-default-private =
    .label = Sæt som standard-søgetjeneste i private vinduer
    .accesskey = p
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
    .tooltiptext = Bogmærker ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Faneblade ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historik ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Vis editor, når der gemmes
    .accesskey = V
bookmark-panel-done-button =
    .label = Færdig
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Forbindelsen er usikker
identity-connection-secure = Forbindelsen er sikker
identity-connection-internal = Dette er en sikker { -brand-short-name }-side.
identity-connection-file = Denne side er gemt på din computer.
identity-extension-page = Denne side er indlæst fra en udvidelse.
identity-active-blocked = { -brand-short-name } har blokeret usikre dele af denne side.
identity-custom-root = Forbindelsen blev bekræftet af en certifikatudsteder, som Mozilla ikke kender.
identity-passive-loaded = Dele af denne side (såsom billeder) er ikke sikre.
identity-active-loaded = Du har slået beskyttelse fra på denne side.
identity-weak-encryption = Denne side bruger svag kryptering.
identity-insecure-login-forms = Logins foretaget på denne side kan blive kompromitteret.
identity-permissions =
    .value = Tilladelser
identity-permissions-reload-hint = Du skal muligvis genindlæse siden, før at ændringerne slår igennem.
identity-permissions-empty = Du har ikke tildelt dette websted nogen særlige tilladelser.
identity-clear-site-data =
    .label = Ryd cookies og webstedsdata…
identity-connection-not-secure-security-view = Din forbindelse til webstedet er ikke sikker.
identity-connection-verified = Din forbindelse til dette websted er sikker.
identity-ev-owner-label = Certifikatet er udstedt til:
identity-description-custom-root = Mozilla kender ikke udstederen af dette certifikat. Det kan være tilføjet af dit styresystem eller en administrator. <label data-l10n-name="link">Læs mere</label>
identity-remove-cert-exception =
    .label = Fjern undtagelser
    .accesskey = F
identity-description-insecure = Din forbindelse til dette websted er ikke privat. Andre kan se de informationer, du indsender (fx adgangskoder, beskeder og oplysninger om betalingskort)
identity-description-insecure-login-forms = Login-information, du indtaster på denne side, er ikke sikker og kan være kompromitteret.
identity-description-weak-cipher-intro = Din forbindelse til dette websted anvender svag kryptering og er ikke privat.
identity-description-weak-cipher-risk = Andre kan se dine informationer eller ændre webstedets opførsel.
identity-description-active-blocked = { -brand-short-name } har blokeret usikre dele af denne side. <label data-l10n-name="link">Læs mere</label>
identity-description-passive-loaded = Din forbindelse er ikke privat og de informationer, du deler, kan ses af andre.
identity-description-passive-loaded-insecure = Noget af dette websteds indhold (fx billeder) er usikkert. <label data-l10n-name="link">Læs mere</label>
identity-description-passive-loaded-mixed = Selvom { -brand-short-name } har blokeret noget af indholdet, så findes der stadig usikkert indhold på siden (fx billeder). <label data-l10n-name="link">Læs mere</label>
identity-description-active-loaded = Dette websted indeholder usikkert indhold (fx scripts), og din forbindelse til det er ikke privat.
identity-description-active-loaded-insecure = Information, du deler med dette websted (fx adgangskoder, beskeder og oplysninger om betalingskort) kan ses af andre.
identity-learn-more =
    .value = Læs mere
identity-disable-mixed-content-blocking =
    .label = Deaktiver beskyttelse indtil videre
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Aktiver beskyttelse
    .accesskey = A
identity-more-info-link-text =
    .label = Mere information

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimer
browser-window-maximize-button =
    .tooltiptext = Maksimer
browser-window-restore-down-button =
    .tooltiptext = Gendan fra maksimeret
browser-window-close-button =
    .tooltiptext = Luk

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera til deling:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon til deling:
    .accesskey = M
popup-all-windows-shared = Alle synlige vinduer på din skærm vil blive delt.
popup-screen-sharing-not-now =
    .label = Ikke nu
    .accesskey = n
popup-screen-sharing-never =
    .label = Tillad aldrig
    .accesskey = a
popup-silence-notifications-checkbox = Deaktiver beskeder fra { -brand-short-name } ved deling
popup-silence-notifications-checkbox-warning = { -brand-short-name } vil ikke vise beskeder, når du deler

## WebRTC window or screen share tab switch warning

sharing-warning-window = Du deler { -brand-short-name }. Andre kan se, når du skifter til et nyt faneblad.
sharing-warning-screen = Du deler hele din skærm. Andre kan se, når du skifter til et nyt faneblad.
sharing-warning-proceed-to-tab =
    .label = Fortsæt til faneblad
sharing-warning-disable-for-session =
    .label = Deaktiver delings-beskyttelse for denne session

## DevTools F12 popup

enable-devtools-popup-description = For at bruge F12 som genvej skal du først åbne udviklerværktøj fra menuen Webudvikler.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Søg eller indtast en adresse
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Søg eller indtast en adresse
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Søg på nettet
    .aria-label = Søg på nettet med { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Indtast søgestreng
    .aria-label = Søg på { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Indtast søgestreng
    .aria-label = Søg efter bogmærker
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Indtast søgestreng
    .aria-label = Søg i historik
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Indtast søgestreng
    .aria-label = Søg i faneblade
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Søg med { $name } eller indtast en adresse
urlbar-remote-control-notification-anchor =
    .tooltiptext = Browseren fjernstyres
urlbar-permissions-granted =
    .tooltiptext = Du har givet dette websted yderligere tilladelser.
urlbar-switch-to-tab =
    .value = Skift til faneblad:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Udvidelse:
urlbar-go-button =
    .tooltiptext = Gå til adressen i adressefeltet
urlbar-page-action-button =
    .tooltiptext = Sidehandlinger
urlbar-pocket-button =
    .tooltiptext = Gem til { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> vises nu i fuld skærm
fullscreen-warning-no-domain = Dokumentet vises nu i fuld skærm
fullscreen-exit-button = Afslut fuld skærm (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Afslut fuld skærm (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> kontrollerer din markør. Tryk Esc for at overtage kontrollen igen.
pointerlock-warning-no-domain = Dette dokument kontrollerer din markør. Tryk Esc for at overtage kontrollen igen.
