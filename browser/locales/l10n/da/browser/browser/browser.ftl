# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - Waterfox
# private - "Waterfox Waterfox (Private Browsing)"
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
# "default" - Waterfox
# "private" - "Waterfox Waterfox — (Private Browsing)"
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
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Håndter deling af andre højttalere med webstedet
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
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Vælg denne genvej for hurtigere at finde det, du leder efter.

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

page-action-manage-extension =
    .label = Håndter udvidelse…
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

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Søg denne gang med:
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
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Tilføj "{ $engineName }"
    .tooltiptext = Tilføj søgetjenesten "{ $engineName }"
    .aria-label = Tilføj søgetjenesten "{ $engineName }"
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Tilføj søgetjeneste

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

bookmarks-add-bookmark = Tilføj bogmærke
bookmarks-edit-bookmark = Rediger bogmærke
bookmark-panel-cancel =
    .label = Afbryd
    .accesskey = A
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Fjern bogmærke
           *[other] Fjern { $count } bogmærker
        }
    .accesskey = F
bookmark-panel-show-editor-checkbox =
    .label = Vis editor, når der gemmes
    .accesskey = V
bookmark-panel-save-button =
    .label = Gem
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Websteds-information for { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Forbindelses-sikkerhed for { $host }
identity-connection-not-secure = Forbindelsen er usikker
identity-connection-secure = Forbindelsen er sikker
identity-connection-failure = Forbindelsesfejl
identity-connection-internal = Dette er en sikker { -brand-short-name }-side.
identity-connection-file = Denne side er gemt på din computer.
identity-extension-page = Denne side er indlæst fra en udvidelse.
identity-active-blocked = { -brand-short-name } har blokeret usikre dele af denne side.
identity-custom-root = Forbindelsen blev bekræftet af en certifikatudsteder, som Waterfox ikke kender.
identity-passive-loaded = Dele af denne side (såsom billeder) er ikke sikre.
identity-active-loaded = Du har slået beskyttelse fra på denne side.
identity-weak-encryption = Denne side bruger svag kryptering.
identity-insecure-login-forms = Logins foretaget på denne side kan blive kompromitteret.
identity-https-only-connection-upgraded = (opgraderet til HTTPS)
identity-https-only-label = Tilstanden Kun-HTTPS
identity-https-only-dropdown-on =
    .label = Til
identity-https-only-dropdown-off =
    .label = Fra
identity-https-only-dropdown-off-temporarily =
    .label = Midlertidigt fra
identity-https-only-info-turn-on2 = Slå tilstanden kun-HTTPS til for dette websted, hvis du vil have { -brand-short-name } til at opgradere forbindelsen, når det er muligt.
identity-https-only-info-turn-off2 = Hvis denne side ikke fungerer korrekt, kan du prøve at slå tilstanden kun-HTTPS fra for dette websted for at genindlæse den ved hjælp af usikker HTTP.
identity-https-only-info-no-upgrade = Kunne ikke opgradere forbindelsen fra HTTP.
identity-permissions-storage-access-header = Cookies på tværs af websteder
identity-permissions-storage-access-hint = Disse parter kan anvende webstedsdata og cookies på tværs af websteder, mens du besøger dette websted.
identity-permissions-storage-access-learn-more = Læs mere
identity-permissions-reload-hint = Du skal muligvis genindlæse siden, før at ændringerne slår igennem.
identity-clear-site-data =
    .label = Ryd cookies og webstedsdata…
identity-connection-not-secure-security-view = Din forbindelse til webstedet er ikke sikker.
identity-connection-verified = Din forbindelse til dette websted er sikker.
identity-ev-owner-label = Certifikatet er udstedt til:
identity-description-custom-root = Waterfox kender ikke udstederen af dette certifikat. Det kan være tilføjet af dit styresystem eller en administrator. <label data-l10n-name="link">Læs mere</label>
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

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = AFSPILLER
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = LYD SLÅET FRA
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = AUTOPLAY BLOKERET
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = BILLEDE-I-BILLEDE

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] SLÅ LYD FRA I FANEBLAD
        [one] SLÅ LYD FRA I FANEBLAD
       *[other] SLÅ LYD FRA I { $count } FANEBLADE
    }
browser-tab-unmute =
    { $count ->
        [1] SLÅ LYD TIL I FANEBLAD
        [one] SLÅ LYD TIL I FANEBLAD
       *[other] SLÅ LYD TIL I { $count } FANEBLADE
    }
browser-tab-unblock =
    { $count ->
        [1] AFSPIL FANEBLAD
        [one] AFSPIL FANEBLAD
       *[other] AFSPIL { $count } FANEBLADE
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = importer bogmærker…
    .tooltiptext = importer bogmærker fra en anden browser til { -brand-short-name }.
bookmarks-toolbar-empty-message = Få hurtig adgang til dine bogmærker ved at placere dem her på bogmærkelinjen. <a data-l10n-name="manage-bookmarks">Håndter bogmærker…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Kamera:
    .accesskey = K
popup-select-camera-icon =
    .tooltiptext = Kamera
popup-select-microphone-device =
    .value = Mikrofon:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Mikrofon
popup-select-speaker-icon =
    .tooltiptext = Højttalere
popup-all-windows-shared = Alle synlige vinduer på din skærm vil blive delt.
popup-screen-sharing-block =
    .label = Bloker
    .accesskey = B
popup-screen-sharing-always-block =
    .label = Bloker altid
    .accesskey = a
popup-mute-notifications-checkbox = Slå websteds-beskeder fra ved deling

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
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Browseren er underlagt fjernstyring (Årsag: { $component })
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

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Søg med { $engine } i et privat vindue
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Søg i et privat vindue
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Søg med { $engine }
urlbar-result-action-sponsored = Sponsoreret
urlbar-result-action-switch-tab = Skift til faneblad
urlbar-result-action-visit = Besøg
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Tryk på Tab for at søge med { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Tryk på Tab for at søge på { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Søg med { $engine } direkte fra adressefeltet
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Søg med { $engine } direkte fra adressefeltet
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Kopiér
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Søg i bogmærker
urlbar-result-action-search-history = Søg i historik
urlbar-result-action-search-tabs = Søg i faneblade

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Forslag fra { $engine }

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

## Subframe crash notification

crashed-subframe-message = <strong>En del af denne side gik ned</strong>. Indsend en rapport for at fortælle { -brand-product-name } om dette problem, så det hurtigere kan blive løst.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Dele af denne side gik ned. Indsend en rapport for at fortælle { -brand-product-name } om dette problem, så det hurtigere kan blive løst.
crashed-subframe-learnmore-link =
    .value = Læs mere
crashed-subframe-submit =
    .label = Indsend rapport
    .accesskey = I

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Håndter bogmærker
bookmarks-recent-bookmarks-panel-subheader = Seneste bogmærker
bookmarks-toolbar-chevron =
    .tooltiptext = Vis flere bogmærker
bookmarks-sidebar-content =
    .aria-label = Bogmærker
bookmarks-menu-button =
    .label = Bogmærke-menuen
bookmarks-other-bookmarks-menu =
    .label = Andre bogmærker
bookmarks-mobile-bookmarks-menu =
    .label = Mobil-bogmærker
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Skjul bogmærker i sidepanel
           *[other] Vis bogmærker i sidepanel
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Skjul bogmærkelinjen
           *[other] Vis bogmærkelinjen
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Skjul bogmærkelinjen
           *[other] Vis bogmærkelinjen
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Fjern bogmærke-menuen fra værktøjslinjen
           *[other] Føj bogmærke-menuen til værktøjslinjen
        }
bookmarks-search =
    .label = Søg i bogmærker
bookmarks-tools =
    .label = Bogmærke-værktøjer
bookmarks-bookmark-edit-panel =
    .label = Rediger bogmærke
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Bogmærkelinje
    .accesskey = B
    .aria-label = Bogmærker
bookmarks-toolbar-menu =
    .label = Bogmærkelinje
bookmarks-toolbar-placeholder =
    .title = Bogmærkelinje-elementer
bookmarks-toolbar-placeholder-button =
    .label = Bogmærkelinje-elementer
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = Bogmærk dette faneblad

## Library Panel items

library-bookmarks-menu =
    .label = Bogmærker
library-recent-activity-title =
    .value = Seneste aktivitet

## Pocket toolbar button

save-to-pocket-button =
    .label = Gem til { -pocket-brand-name }
    .tooltiptext = Gem til { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Reparer tegnkodning
    .tooltiptext = Fastlæg den korrekte tekstkodning ud fra meddelelsens indhold

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Tilføjelser og temaer
    .tooltiptext = Håndter dine tilføjelser og temaer ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Indstillinger
    .tooltiptext =
        { PLATFORM() ->
            [macos] Åbn indstillinger ({ $shortcut })
           *[other] Åbn indstillinger
        }

## More items

more-menu-go-offline =
    .label = Arbejd offline
    .accesskey = o
toolbar-overflow-customize-button =
    .label = Tilpas værktøjslinje…
    .accesskey = T
toolbar-button-email-link =
    .label = Send link
    .tooltiptext = Send link til siden i en mail…
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Gem side
    .tooltiptext = Gem denne side ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Åbn fil
    .tooltiptext = Åbn en fil ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Synkroniserede faneblade
    .tooltiptext = Vis faneblade fra dine andre enheder
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Nyt privat vindue
    .tooltiptext = Åbn et nyt vindue til privat browsing ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Noget lyd- eller videoindhold på dette websted bruger DRM-software, hvilken kan begrænse hvad { -brand-short-name } kan lade dig gøre med det.
eme-notifications-drm-content-playing-manage = Håndter indstillinger
eme-notifications-drm-content-playing-manage-accesskey = H
eme-notifications-drm-content-playing-dismiss = Afvis
eme-notifications-drm-content-playing-dismiss-accesskey = A

## Password save/update panel

panel-save-update-username = Brugernavn
panel-save-update-password = Adgangskode

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Fjern { $name }?
addon-removal-abuse-report-checkbox = Rapporter denne udvidelse til { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Håndter konto
remote-tabs-sync-now = Synkroniser nu

##

# "More" item in macOS share menu
menu-share-more =
    .label = Mere…
ui-tour-info-panel-close =
    .tooltiptext = Luk

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Tillad pop op-vinduer for { $uriHost }
    .accesskey = T
popups-infobar-block =
    .label = Bloker pop op-vinduer for { $uriHost }
    .accesskey = T

##

popups-infobar-dont-show-message =
    .label = Vis ikke denne besked når pop op-vinduer bliver blokeret
    .accesskey = V
edit-popup-settings =
    .label = Håndter pop op-indstillinger
    .accesskey = H
picture-in-picture-hide-toggle =
    .label = Skjul kontakt for billed-i-billed
    .accesskey = S

# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navigation
navbar-downloads =
    .label = Filhentning
navbar-overflow =
    .tooltiptext = Flere værktøjer…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Udskriv
    .tooltiptext = Udskriv denne side… ({ $shortcut })
navbar-print-tab-modal-disabled =
    .label = Udskriv
    .tooltiptext = Udskriv denne side
navbar-home =
    .label = Hjem
    .tooltiptext = Startside for { -brand-short-name }
navbar-library =
    .label = Arkiv
    .tooltiptext = Se historik, gemte bogmærker og andet
navbar-search =
    .title = Søgefelt
navbar-accessibility-indicator =
    .tooltiptext = Tilgængelighedsfunktioner er aktiveret
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Faneblade
tabs-toolbar-new-tab =
    .label = Nyt faneblad
tabs-toolbar-list-all-tabs =
    .label = List alle faneblade
    .tooltiptext = List alle faneblade

## Infobar shown at startup to suggest session-restore

restore-session-startup-suggestion-button = Vis mig hvordan
