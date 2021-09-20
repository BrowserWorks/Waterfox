# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Waterfox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Privénavigatie)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privénavigatie)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Waterfox"
# "private" - "Mozilla Firefox — (Private Browsing)"
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
    .data-title-private = { -brand-full-name } - (Privénavigatie)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privénavigatie)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Website-informatie weergeven

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Berichtpaneel voor installatie openen
urlbar-web-notification-anchor =
    .tooltiptext = Wijzigen of u notificaties van de website kunt ontvangen
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI-paneel openen
urlbar-eme-notification-anchor =
    .tooltiptext = Gebruik van DRM-software beheren
urlbar-web-authn-anchor =
    .tooltiptext = Paneel Webauthenticatie openen
urlbar-canvas-notification-anchor =
    .tooltiptext = Canvas-extractietoestemming beheren
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Delen van uw microfoon met de website beheren
urlbar-default-notification-anchor =
    .tooltiptext = Berichtpaneel openen
urlbar-geolocation-notification-anchor =
    .tooltiptext = Paneel voor locatieaanvraag openen
urlbar-xr-notification-anchor =
    .tooltiptext = Machtigingsvenster voor virtual reality openen
urlbar-storage-access-anchor =
    .tooltiptext = Toestemmingspaneel voor surfactiviteit openen
urlbar-translate-notification-anchor =
    .tooltiptext = Deze pagina vertalen
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Delen van uw vensters of scherm met de website beheren
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Berichtpaneel voor offlineopslag openen
urlbar-password-notification-anchor =
    .tooltiptext = Berichtpaneel voor opslaan van wachtwoord openen
urlbar-translated-notification-anchor =
    .tooltiptext = Paginavertaling beheren
urlbar-plugins-notification-anchor =
    .tooltiptext = Plug-in-gebruik beheren
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Delen van uw camera en/of microfoon met de website beheren
urlbar-autoplay-notification-anchor =
    .tooltiptext = Paneel voor automatisch afspelen openen
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Gegevens in permanente opslag bewaren
urlbar-addons-notification-anchor =
    .tooltiptext = Berichtpaneel voor add-on-installatie openen
urlbar-tip-help-icon =
    .title = Hulp verkrijgen
urlbar-search-tips-confirm = Oké, begrepen
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tip:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Minder typen, meer vinden: direct zoeken bij { $engineName } vanaf uw adresbalk.
urlbar-search-tips-redirect-2 = Begin in de adresbalk met zoeken om suggesties van { $engineName } en uit uw browsergeschiedenis te zien.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Selecteer deze snelkoppeling om sneller te vinden wat u nodig hebt.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Bladwijzers
urlbar-search-mode-tabs = Tabbladen
urlbar-search-mode-history = Geschiedenis

##

urlbar-geolocation-blocked =
    .tooltiptext = U hebt locatiegegevens voor deze website geblokkeerd.
urlbar-xr-blocked =
    .tooltiptext = U hebt toegang tot virtual-reality-apparaten voor deze website geblokkeerd.
urlbar-web-notifications-blocked =
    .tooltiptext = U hebt notificaties voor deze website geblokkeerd.
urlbar-camera-blocked =
    .tooltiptext = U hebt uw camera voor deze website geblokkeerd.
urlbar-microphone-blocked =
    .tooltiptext = U hebt uw microfoon voor deze website geblokkeerd.
urlbar-screen-blocked =
    .tooltiptext = U hebt het delen van uw scherm voor deze website geblokkeerd.
urlbar-persistent-storage-blocked =
    .tooltiptext = U hebt permanente opslag voor deze website geblokkeerd.
urlbar-popup-blocked =
    .tooltiptext = U hebt pop-ups voor deze website geblokkeerd.
urlbar-autoplay-media-blocked =
    .tooltiptext = U hebt het automatisch afspelen van media met geluid voor deze website geblokkeerd.
urlbar-canvas-blocked =
    .tooltiptext = U hebt canvas-gegevensextractie voor deze website geblokkeerd.
urlbar-midi-blocked =
    .tooltiptext = U hebt MIDI-toegang voor deze website geblokkeerd.
urlbar-install-blocked =
    .tooltiptext = U hebt installatie van add-ons voor deze website geblokkeerd.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Deze bladwijzer bewerken ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Bladwijzer voor deze pagina maken ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Toevoegen aan adresbalk
page-action-manage-extension =
    .label = Extensie beheren…
page-action-remove-from-urlbar =
    .label = Verwijderen van adresbalk
page-action-remove-extension =
    .label = Extensie verwijderen

## Auto-hide Context Menu

full-screen-autohide =
    .label = Werkbalken verbergen
    .accesskey = W
full-screen-exit =
    .label = Volledigschermmodus verlaten
    .accesskey = d

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Deze keer zoeken met:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Zoekinstellingen wijzigen
search-one-offs-change-settings-compact-button =
    .tooltiptext = Zoekinstellingen wijzigen
search-one-offs-context-open-new-tab =
    .label = Zoeken in Nieuw tabblad
    .accesskey = t
search-one-offs-context-set-as-default =
    .label = Instellen als standaardzoekmachine
    .accesskey = s
search-one-offs-context-set-as-default-private =
    .label = Als standaardzoekmachine voor privévensters instellen
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
    .label = “{ $engineName }” toevoegen
    .tooltiptext = Zoekmachine “{ $engineName }” toevoegen
    .aria-label = Zoekmachine “{ $engineName }” toevoegen
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Zoekmachine toevoegen

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Bladwijzers ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Tabbladen ({ $restrict })
search-one-offs-history =
    .tooltiptext = Geschiedenis ({ $restrict })

## Bookmark Panel

bookmarks-add-bookmark = Bladwijzer toevoegen
bookmarks-edit-bookmark = Bladwijzer bewerken
bookmark-panel-cancel =
    .label = Annuleren
    .accesskey = A
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Bladwijzer verwijderen
           *[other] Bladwijzers verwijderen ({ $count })
        }
    .accesskey = v
bookmark-panel-show-editor-checkbox =
    .label = Editor tonen bij opslaan
    .accesskey = E
bookmark-panel-done-button =
    .label = Gereed
bookmark-panel-save-button =
    .label = Opslaan
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Website-informatie voor { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Verbindingsbeveiliging voor { $host }
identity-connection-not-secure = Verbinding niet beveiligd
identity-connection-secure = Verbinding beveiligd
identity-connection-failure = Verbindingsfout
identity-connection-internal = Dit is een beveiligde { -brand-short-name }-pagina.
identity-connection-file = Deze pagina is op uw computer opgeslagen.
identity-extension-page = Deze pagina is geladen vanuit een extensie.
identity-active-blocked = { -brand-short-name } heeft onderdelen van deze pagina die niet zijn beveiligd geblokkeerd.
identity-custom-root = Verbinding geverifieerd door een certificaatuitgever die niet door Mozilla wordt herkend.
identity-passive-loaded = Onderdelen van deze pagina zijn niet beveiligd (zoals afbeeldingen).
identity-active-loaded = U hebt bescherming op deze pagina uitgeschakeld.
identity-weak-encryption = Deze pagina gebruikt zwakke versleuteling.
identity-insecure-login-forms = Ingevoerde aanmeldingen op deze pagina zouden kunnen worden onderschept.
identity-permissions =
    .value = Toestemmingen
identity-https-only-connection-upgraded = (geüpgraded naar HTTPS)
identity-https-only-label = Alleen-HTTPS-modus
identity-https-only-dropdown-on =
    .label = Aan
identity-https-only-dropdown-off =
    .label = Uit
identity-https-only-dropdown-off-temporarily =
    .label = Tijdelijk uit
identity-https-only-info-turn-on2 = Schakel Alleen-HTTPS voor deze website in als u wilt dat { -brand-short-name } indien mogelijk de verbinding upgradet.
identity-https-only-info-turn-off2 = Als de website niet lijkt te werken, dan kunt u proberen de Alleen-HTTPS-modus voor deze website uit te schakelen en de pagina te vernieuwen met het onveilige HTTP.
identity-https-only-info-no-upgrade = Kan HTTP-verbinding niet upgraden.
identity-permissions-storage-access-header = Cross-sitecookies
identity-permissions-storage-access-hint = Deze partijen kunnen tijdens uw bezoek aan deze website cross-sitecookies en websitegegevens gebruiken.
identity-permissions-storage-access-learn-more = Meer info
identity-permissions-reload-hint = Mogelijk dient u de pagina te vernieuwen om wijzigingen van kracht te laten worden.
identity-permissions-empty = U hebt deze website geen speciale toestemmingen gegeven.
identity-clear-site-data =
    .label = Cookies en websitegegevens wissen…
identity-connection-not-secure-security-view = U hebt een onbeveiligde verbinding met deze website.
identity-connection-verified = U hebt een beveiligde verbinding met deze website.
identity-ev-owner-label = Certificaat uitgegeven aan:
identity-description-custom-root = Mozilla herkent deze certificaatuitgever niet. Hij is mogelijk vanuit uw besturingssysteem of door een beheerder toegevoegd. <label data-l10n-name="link">Meer info</label>
identity-remove-cert-exception =
    .label = Uitzondering verwijderen
    .accesskey = w
identity-description-insecure = Uw verbinding met deze website is niet privé. Gegevens die u verzendt zouden door anderen kunnen worden bekeken (zoals wachtwoorden, berichten, creditcardgegevens, etc.).
identity-description-insecure-login-forms = De aanmeldingsgegevens die u op deze pagina invoert, zijn niet veilig en zouden kunnen worden onderschept.
identity-description-weak-cipher-intro = Uw verbinding met deze website gebruikt zwakke versleuteling en is niet privé.
identity-description-weak-cipher-risk = Andere personen kunnen uw gegevens bekijken of het gedrag van de website aanpassen.
identity-description-active-blocked = { -brand-short-name } heeft onderdelen van deze pagina die niet beveiligd zijn geblokkeerd. <label data-l10n-name="link">Meer info</label>
identity-description-passive-loaded = Uw verbinding is niet privé en gegevens die u met de website deelt zouden door anderen kunnen worden bekeken.
identity-description-passive-loaded-insecure = Deze website bevat inhoud die niet beveiligd is (zoals afbeeldingen). <label data-l10n-name="link">Meer info</label>
identity-description-passive-loaded-mixed = Hoewel { -brand-short-name } bepaalde inhoud heeft geblokkeerd, staat er nog steeds inhoud op de pagina die niet beveiligd is (zoals afbeeldingen). <label data-l10n-name="link">Meer info</label>
identity-description-active-loaded = Deze website bevat inhoud die niet is beveiligd (zoals scripts) en uw verbinding ermee is niet privé.
identity-description-active-loaded-insecure = Gegevens die u met deze website deelt, zouden door anderen kunnen worden bekeken (zoals wachtwoorden, berichten, creditcardgegevens, etc.).
identity-learn-more =
    .value = Meer info
identity-disable-mixed-content-blocking =
    .label = Bescherming voor nu uitschakelen
    .accesskey = B
identity-enable-mixed-content-blocking =
    .label = Bescherming inschakelen
    .accesskey = a
identity-more-info-link-text =
    .label = Meer informatie

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimaliseren
browser-window-maximize-button =
    .tooltiptext = Maximaliseren
browser-window-restore-down-button =
    .tooltiptext = Omlaag herstellen
browser-window-close-button =
    .tooltiptext = Sluiten

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = AFSPELEN
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = GEDEMPT
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = AUTOMATISCH AFSPELEN GEBLOKKEERD
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = PICTURE-IN-PICTURE

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] TABBLAD DEMPEN
        [one] TABBLAD DEMPEN
       *[other] { $count } TABBLADEN DEMPEN
    }
browser-tab-unmute =
    { $count ->
        [1] TABBLAD DEMPEN OPHEFFEN
        [one] TABBLAD DEMPEN OPHEFFEN
       *[other] { $count } TABBLADEN DEMPEN OPHEFFEN
    }
browser-tab-unblock =
    { $count ->
        [1] TABBLAD AFSPELEN
        [one] TABBLAD AFSPELEN
       *[other] { $count } TABBLADEN AFSPELEN
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Bladwijzers importeren…
    .tooltiptext = Bladwijzers uit een andere browser naar { -brand-short-name } importeren.
bookmarks-toolbar-empty-message = Plaats voor snelle toegang uw bladwijzers hier op de bladwijzerwerkbalk. <a data-l10n-name="manage-bookmarks">Bladwijzers beheren…</a>

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Te delen camera:
    .accesskey = C
popup-select-microphone =
    .value = Te delen microfoon:
    .accesskey = M
popup-select-camera-device =
    .value = Camera:
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = Camera
popup-select-microphone-device =
    .value = Microfoon:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Microfoon
popup-select-speaker-icon =
    .tooltiptext = Luidsprekers
popup-all-windows-shared = Alle zichtbare vensters op uw scherm worden gedeeld.
popup-screen-sharing-not-now =
    .label = Niet nu
    .accesskey = i
popup-screen-sharing-never =
    .label = Nooit toestaan
    .accesskey = N
popup-silence-notifications-checkbox = Notificaties van { -brand-short-name } uitschakelen tijdens delen
popup-silence-notifications-checkbox-warning = { -brand-short-name } toont geen meldingen terwijl u deelt.
popup-screen-sharing-block =
    .label = Blokkeren
    .accesskey = B
popup-screen-sharing-always-block =
    .label = Altijd blokkeren
    .accesskey = t
popup-mute-notifications-checkbox = Websitemeldingen dempen tijdens delen

## WebRTC window or screen share tab switch warning

sharing-warning-window = U deelt { -brand-short-name }. Anderen kunnen zien wanneer u naar een nieuw tabblad wisselt.
sharing-warning-screen = U deelt uw volledige scherm. Anderen kunnen zien wanneer u naar een nieuw tabblad wisselt.
sharing-warning-proceed-to-tab =
    .label = Doorgaan naar tabblad
sharing-warning-disable-for-session =
    .label = Deelbescherming voor deze sessie uitschakelen

## DevTools F12 popup

enable-devtools-popup-description = Open eerst DevTools in het menu Webontwikkelaar om de sneltoets F12 te gebruiken.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Voer zoekterm of adres in
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Voer zoekterm of adres in
urlbar-remote-control-notification-anchor =
    .tooltiptext = Browser wordt op afstand bestuurd
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Zoeken op het web
    .aria-label = Zoeken met { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Voer zoektermen in
    .aria-label = Zoeken op { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Voer zoektermen in
    .aria-label = Zoeken in bladwijzers
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Voer zoektermen in
    .aria-label = Zoeken in geschiedenis
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Voer zoektermen in
    .aria-label = Zoeken in tabbladen
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Voer zoekterm voor { $name } of adres in
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Browser wordt op afstand beheerd (reden: { $component })
urlbar-permissions-granted =
    .tooltiptext = U hebt deze website aanvullende toestemmingen gegeven.
urlbar-switch-to-tab =
    .value = Wisselen naar tabblad:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensie:
urlbar-go-button =
    .tooltiptext = Naar het adres in de locatiebalk gaan
urlbar-page-action-button =
    .tooltiptext = Pagina-acties
urlbar-pocket-button =
    .tooltiptext = Opslaan naar { -pocket-brand-name }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Zoeken met { $engine } in een privévenster
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Zoeken in een privévenster
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Zoeken met { $engine }
urlbar-result-action-sponsored = Gesponsord
urlbar-result-action-switch-tab = Wisselen naar tabblad
urlbar-result-action-visit = Bezoeken
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Druk op Tab om te zoeken met { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Druk op Tab om te zoeken met { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Met { $engine } rechtstreeks vanuit de adresbalk zoeken
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = { $engine } rechtstreeks vanuit de adresbalk doorzoeken
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Kopiëren
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Bladwijzers doorzoeken
urlbar-result-action-search-history = Geschiedenis doorzoeken
urlbar-result-action-search-tabs = Tabbladen doorzoeken

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> gebruikt nu het volledige scherm
fullscreen-warning-no-domain = Dit document gebruikt nu het volledige scherm
fullscreen-exit-button = Volledig scherm verlaten (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Volledig scherm verlaten (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> heeft de controle over uw aanwijzer. Druk op Esc om de controle weer over te nemen.
pointerlock-warning-no-domain = Dit document heeft de controle over uw aanwijzer. Druk op Esc om de controle weer over te nemen.

## Subframe crash notification

crashed-subframe-message = <strong>Een deel van deze pagina is gecrasht.</strong> Dien een rapport in om { -brand-product-name } te informeren over dit probleem en het sneller opgelost te krijgen.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Een deel van deze pagina is gecrasht. Dien een rapport in om { -brand-product-name } te informeren over dit probleem en het sneller opgelost te krijgen.
crashed-subframe-learnmore-link =
    .value = Meer info
crashed-subframe-submit =
    .label = Rapport verzenden
    .accesskey = z

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Bladwijzers beheren
bookmarks-recent-bookmarks-panel-subheader = Recente bladwijzers
bookmarks-toolbar-chevron =
    .tooltiptext = Meer bladwijzers tonen
bookmarks-sidebar-content =
    .aria-label = Bladwijzers
bookmarks-menu-button =
    .label = Bladwijzermenu
bookmarks-other-bookmarks-menu =
    .label = Andere bladwijzers
bookmarks-mobile-bookmarks-menu =
    .label = Mobiel-bladwijzers
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Bladwijzerzijbalk verbergen
           *[other] Bladwijzerzijbalk weergeven
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Bladwijzerwerkbalk verbergen
           *[other] Bladwijzerwerkbalk weergeven
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Bladwijzerwerkbalk verbergen
           *[other] Bladwijzerwerkbalk tonen
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Bladwijzermenu verwijderen van werkbalk
           *[other] Bladwijzermenu toevoegen aan werkbalk
        }
bookmarks-search =
    .label = Bladwijzers doorzoeken
bookmarks-tools =
    .label = Bladwijzerhulpmiddelen
bookmarks-bookmark-edit-panel =
    .label = Deze bladwijzer bewerken
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Bladwijzerwerkbalk
    .accesskey = B
    .aria-label = Bladwijzers
bookmarks-toolbar-menu =
    .label = Bladwijzerwerkbalk
bookmarks-toolbar-placeholder =
    .title = Bladwijzerwerkbalkitems
bookmarks-toolbar-placeholder-button =
    .label = Bladwijzerwerkbalkitems
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = Bladwijzer voor huidige tabblad maken

## Library Panel items

library-bookmarks-menu =
    .label = Bladwijzers
library-recent-activity-title =
    .value = Recente activiteit

## Pocket toolbar button

save-to-pocket-button =
    .label = Opslaan naar { -pocket-brand-name }
    .tooltiptext = Opslaan naar { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Tekstcodering repareren
    .tooltiptext = De juiste tekstcodering raden vanuit de pagina-inhoud

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Add-ons en thema’s
    .tooltiptext = Uw add-ons en thema’s beheren ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Instellingen
    .tooltiptext =
        { PLATFORM() ->
            [macos] Instellingen openen ({ $shortcut })
           *[other] Instellingen openen
        }

## More items

more-menu-go-offline =
    .label = Offline werken
    .accesskey = f

## EME notification panel

eme-notifications-drm-content-playing = Sommige audio- of videobestanden op deze pagina gebruiken DRM-software die { -brand-short-name } kan beperken in wat u ermee wilt doen.
eme-notifications-drm-content-playing-manage = Instellingen beheren
eme-notifications-drm-content-playing-manage-accesskey = b
eme-notifications-drm-content-playing-dismiss = Sluiten
eme-notifications-drm-content-playing-dismiss-accesskey = S

## Password save/update panel

panel-save-update-username = Gebruikersnaam
panel-save-update-password = Wachtwoord

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = { $name } verwijderen?
addon-removal-abuse-report-checkbox = Deze extensie rapporteren aan { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Account beheren
remote-tabs-sync-now = Nu synchroniseren
