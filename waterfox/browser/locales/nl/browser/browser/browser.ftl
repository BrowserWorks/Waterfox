# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name }-privénavigatie
    .data-content-title-default = { $content-title } – { -brand-full-name }
    .data-content-title-private = { $content-title } – { -brand-full-name }-privénavigatie
# These are the default window titles on macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Do not use the brand name in these, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } – Privénavigatie
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } – Privénavigatie
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }
# The non-variable portion of this MUST match the translation of
# "PRIVATE_BROWSING_SHORTCUT_TITLE" in custom.properties
private-browsing-shortcut-text-2 = { -brand-shortcut-name }-privénavigatie

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
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Delen van uw vensters of scherm met de website beheren
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Berichtpaneel voor offlineopslag openen
urlbar-password-notification-anchor =
    .tooltiptext = Berichtpaneel voor opslaan van wachtwoord openen
urlbar-plugins-notification-anchor =
    .tooltiptext = Plug-in-gebruik beheren
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Delen van uw camera en/of microfoon met de website beheren
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Delen van uw andere luidsprekers met de website beheren
urlbar-autoplay-notification-anchor =
    .tooltiptext = Paneel voor automatisch afspelen openen
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Gegevens in permanente opslag bewaren
urlbar-addons-notification-anchor =
    .tooltiptext = Berichtpaneel voor add-on-installatie openen
urlbar-tip-help-icon =
    .title = Hulp verkrijgen
urlbar-search-tips-confirm = Oké, begrepen
urlbar-search-tips-confirm-short = Begrepen
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tip:
urlbar-result-menu-button =
    .title = Menu openen
urlbar-result-menu-button-feedback = Feedback
    .title = Menu openen
urlbar-result-menu-learn-more =
    .label = Meer info
    .accesskey = M
urlbar-result-menu-remove-from-history =
    .label = Verwijderen uit geschiedenis
    .accesskey = V
urlbar-result-menu-tip-get-help =
    .label = Hulp verkrijgen
    .accesskey = H

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Minder typen, meer vinden: direct zoeken bij { $engineName } vanaf uw adresbalk.
urlbar-search-tips-redirect-2 = Begin in de adresbalk met zoeken om suggesties van { $engineName } en uit uw browsergeschiedenis te zien.
# Make sure to match the name of the Search panel in settings.
urlbar-search-tips-persist = Zoeken is nu nog eenvoudiger geworden. Probeer uw zoekopdracht hier in de adresbalk specifieker te maken. Als u in plaats daarvan de URL wilt weergeven, ga dan naar Zoeken in de instellingen.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Selecteer deze snelkoppeling om sneller te vinden wat u nodig hebt.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Bladwijzers
urlbar-search-mode-tabs = Tabbladen
urlbar-search-mode-history = Geschiedenis
urlbar-search-mode-actions = Acties

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

page-action-manage-extension2 =
    .label = Extensie beheren…
    .accesskey = E
page-action-remove-extension2 =
    .label = Extensie verwijderen
    .accesskey = v

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
search-one-offs-actions =
    .tooltiptext = Acties ({ $restrict })

## QuickActions are shown in the urlbar as the user types a matching string
## The -cmd- strings are comma separated list of keywords that will match
## the action.

# Opens the about:addons page in the home / recommendations section
quickactions-addons = Add-ons bekijken
quickactions-cmd-addons2 = add-ons
# Opens the bookmarks library window
quickactions-bookmarks2 = Bladwijzers beheren
quickactions-cmd-bookmarks = bladwijzers
# Opens a SUMO article explaining how to clear history
quickactions-clearhistory = Geschiedenis wissen
quickactions-cmd-clearhistory = geschiedenis wissen
# Opens about:downloads page
quickactions-downloads2 = Downloads bekijken
quickactions-cmd-downloads = downloads
# Opens about:addons page in the extensions section
quickactions-extensions = Extensies beheren
quickactions-cmd-extensions = extensies
# Opens the devtools web inspector
quickactions-inspector2 = Ontwikkelaarshulpmiddelen openen
quickactions-cmd-inspector = inspector, devtools
# Opens about:logins
quickactions-logins2 = Wachtwoorden beheren
quickactions-cmd-logins = aanmeldingen, wachtwoorden
# Opens about:addons page in the plugins section
quickactions-plugins = Plug-ins beheren
quickactions-cmd-plugins = plug-ins
# Opens the print dialog
quickactions-print2 = Pagina afdrukken
quickactions-cmd-print = afdrukken
# Opens a new private browsing window
quickactions-private2 = Privévenster openen
quickactions-cmd-private = privénavigatie
# Opens a SUMO article explaining how to refresh
quickactions-refresh = { -brand-short-name } opfrissen
quickactions-cmd-refresh = vernieuwen
# Restarts the browser
quickactions-restart = { -brand-short-name } herstarten
quickactions-cmd-restart = herstarten
# Opens the screenshot tool
quickactions-screenshot3 = Een schermafbeelding maken
quickactions-cmd-screenshot = schermafbeelding
# Opens about:preferences
quickactions-settings2 = Instellingen beheren
quickactions-cmd-settings = instellingen, voorkeuren, opties
# Opens about:addons page in the themes section
quickactions-themes = Thema’s beheren
quickactions-cmd-themes = thema’s
# Opens a SUMO article explaining how to update the browser
quickactions-update = { -brand-short-name } bijwerken
quickactions-cmd-update = bijwerken
# Opens the view-source UI with current pages source
quickactions-viewsource2 = Paginabron bekijken
quickactions-cmd-viewsource = bron bekijken, bron
# Tooltip text for the help button shown in the result.
quickactions-learn-more =
    .title = Meer info over Snelle acties

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
identity-custom-root = Verbinding geverifieerd door een certificaatuitgever die niet door BrowserWorks wordt herkend.
identity-passive-loaded = Onderdelen van deze pagina zijn niet beveiligd (zoals afbeeldingen).
identity-active-loaded = U hebt bescherming op deze pagina uitgeschakeld.
identity-weak-encryption = Deze pagina gebruikt zwakke versleuteling.
identity-insecure-login-forms = Ingevoerde aanmeldingen op deze pagina zouden kunnen worden onderschept.
identity-https-only-connection-upgraded = (geüpgraded naar HTTPS)
identity-https-only-label = Alleen-HTTPS-modus
identity-https-only-label2 = Deze website automatisch naar een beveiligde verbinding upgraden
identity-https-only-dropdown-on =
    .label = Aan
identity-https-only-dropdown-off =
    .label = Uit
identity-https-only-dropdown-off-temporarily =
    .label = Tijdelijk uit
identity-https-only-info-turn-on2 = Schakel Alleen-HTTPS voor deze website in als u wilt dat { -brand-short-name } indien mogelijk de verbinding upgradet.
identity-https-only-info-turn-off2 = Als de website niet lijkt te werken, dan kunt u proberen de Alleen-HTTPS-modus voor deze website uit te schakelen en de pagina te vernieuwen met het onveilige HTTP.
identity-https-only-info-turn-on3 = Schakel upgrades naar HTTPS voor deze website in als u wilt dat { -brand-short-name } indien mogelijk de verbinding upgradet.
identity-https-only-info-turn-off3 = Als de website niet lijkt te werken, dan kunt u proberen de HTTPS-upgrade voor deze website uit te schakelen en de pagina te vernieuwen met het onveilige HTTP.
identity-https-only-info-no-upgrade = Kan HTTP-verbinding niet upgraden.
identity-permissions-storage-access-header = Cross-sitecookies
identity-permissions-storage-access-hint = Deze partijen kunnen tijdens uw bezoek aan deze website cross-sitecookies en websitegegevens gebruiken.
identity-permissions-storage-access-learn-more = Meer info
identity-permissions-reload-hint = Mogelijk dient u de pagina te vernieuwen om wijzigingen van kracht te laten worden.
identity-clear-site-data =
    .label = Cookies en websitegegevens wissen…
identity-connection-not-secure-security-view = U hebt een onbeveiligde verbinding met deze website.
identity-connection-verified = U hebt een beveiligde verbinding met deze website.
identity-ev-owner-label = Certificaat uitgegeven aan:
identity-description-custom-root2 = BrowserWorks herkent deze certificaatuitgever niet. Hij is mogelijk vanuit uw besturingssysteem of door een beheerder toegevoegd.
identity-remove-cert-exception =
    .label = Uitzondering verwijderen
    .accesskey = w
identity-description-insecure = Uw verbinding met deze website is niet privé. Gegevens die u verzendt zouden door anderen kunnen worden bekeken (zoals wachtwoorden, berichten, creditcardgegevens, etc.).
identity-description-insecure-login-forms = De aanmeldingsgegevens die u op deze pagina invoert, zijn niet veilig en zouden kunnen worden onderschept.
identity-description-weak-cipher-intro = Uw verbinding met deze website gebruikt zwakke versleuteling en is niet privé.
identity-description-weak-cipher-risk = Andere personen kunnen uw gegevens bekijken of het gedrag van de website aanpassen.
identity-description-active-blocked2 = { -brand-short-name } heeft onderdelen van deze pagina die niet zijn beveiligd geblokkeerd.
identity-description-passive-loaded = Uw verbinding is niet privé en gegevens die u met de website deelt zouden door anderen kunnen worden bekeken.
identity-description-passive-loaded-insecure2 = Deze website bevat inhoud die niet is beveiligd (zoals afbeeldingen).
identity-description-passive-loaded-mixed2 = Hoewel { -brand-short-name } bepaalde inhoud heeft geblokkeerd, is er nog steeds inhoud op de pagina die niet is beveiligd (zoals afbeeldingen).
identity-description-active-loaded = Deze website bevat inhoud die niet is beveiligd (zoals scripts) en uw verbinding ermee is niet privé.
identity-description-active-loaded-insecure = Gegevens die u met deze website deelt, zouden door anderen kunnen worden bekeken (zoals wachtwoorden, berichten, creditcardgegevens, etc.).
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
popup-select-window-or-screen =
    .label = Venster of scherm:
    .accesskey = V
popup-all-windows-shared = Alle zichtbare vensters op uw scherm worden gedeeld.

## WebRTC window or screen share tab switch warning

sharing-warning-window = U deelt { -brand-short-name }. Anderen kunnen zien wanneer u naar een nieuw tabblad wisselt.
sharing-warning-screen = U deelt uw volledige scherm. Anderen kunnen zien wanneer u naar een nieuw tabblad wisselt.
sharing-warning-proceed-to-tab =
    .label = Doorgaan naar tabblad
sharing-warning-disable-for-session =
    .label = Deelbescherming voor deze sessie uitschakelen

## DevTools F12 popup

enable-devtools-popup-description2 = Open eerst DevTools in het menu Extra van de browser om de sneltoets F12 te gebruiken.

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Voer zoekterm of adres in
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
# This placeholder is used when searching quick actions.
urlbar-placeholder-search-mode-other-actions =
    .placeholder = Voer zoektermen in
    .aria-label = Zoekacties
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
# Allows the user to visit a URL that was previously copied to the clipboard.
urlbar-result-action-visit-from-your-clipboard = Bezoeken vanaf uw klembord
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
urlbar-result-action-search-actions = Zoekacties

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use sentence case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = { $engine }-suggesties
# A label shown above Quick Actions in the urlbar results.
urlbar-group-quickactions =
    .label = Snelle acties

## Reader View toolbar buttons

# This should match menu-view-enter-readerview in menubar.ftl
reader-view-enter-button =
    .aria-label = Lezerweergave openen
# This should match menu-view-close-readerview in menubar.ftl
reader-view-close-button =
    .aria-label = Lezerweergave sluiten

## Picture-in-Picture urlbar button
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

picture-in-picture-urlbar-button-open =
    .tooltiptext = Picture-in-picture openen ({ $shortcut })
picture-in-picture-urlbar-button-close =
    .tooltiptext = Picture-in-picture sluiten ({ $shortcut })
picture-in-picture-panel-header = Picture-in-Picture
picture-in-picture-panel-headline = Deze website raadt Picture-in-Picture niet aan
picture-in-picture-panel-body = Video’s worden mogelijk niet getoond zoals de ontwikkelaar het bedoeld heeft, terwijl Picture-in-Picture is ingeschakeld.
picture-in-picture-enable-toggle =
    .label = Toch inschakelen

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

## Variables:
##   $isVisible (boolean): if the specific element (e.g. bookmarks sidebar,
##                         bookmarks toolbar, etc.) is visible or not.

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

##

bookmarks-search =
    .label = Bladwijzers doorzoeken
bookmarks-tools =
    .label = Bladwijzerhulpmiddelen
bookmarks-subview-edit-bookmark =
    .label = Deze bladwijzer bewerken…
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
bookmarks-subview-bookmark-tab =
    .label = Bladwijzer voor huidige tabblad maken…

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
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Instellingen
    .tooltiptext =
        { PLATFORM() ->
            [macos] Instellingen openen ({ $shortcut })
           *[other] Instellingen openen
        }
toolbar-overflow-customize-button =
    .label = Werkbalk aanpassen…
    .accesskey = a
toolbar-button-email-link =
    .label = Koppeling e-mailen
    .tooltiptext = Een koppeling naar deze pagina e-mailen
toolbar-button-logins =
    .label = Wachtwoorden
    .tooltiptext = Uw opgeslagen wachtwoorden bekijken en beheren
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Pagina opslaan
    .tooltiptext = Deze pagina opslaan ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Bestand openen
    .tooltiptext = Een bestand openen ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Gesynchroniseerde tabbladen
    .tooltiptext = Tabbladen van andere apparaten tonen
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Nieuw privévenster
    .tooltiptext = Een nieuw privénavigatievenster openen ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Sommige audio- of videobestanden op deze pagina gebruiken DRM-software die { -brand-short-name } kan beperken in wat u ermee wilt doen.
eme-notifications-drm-content-playing-manage = Instellingen beheren
eme-notifications-drm-content-playing-manage-accesskey = b
eme-notifications-drm-content-playing-dismiss = Sluiten
eme-notifications-drm-content-playing-dismiss-accesskey = S

## Password save/update panel

panel-save-update-username = Gebruikersnaam
panel-save-update-password = Wachtwoord

##

# "More" item in macOS share menu
menu-share-more =
    .label = Meer…
ui-tour-info-panel-close =
    .tooltiptext = Sluiten

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Pop-ups van { $uriHost } toestaan
    .accesskey = P
popups-infobar-block =
    .label = Pop-ups van { $uriHost } blokkeren
    .accesskey = P

##

popups-infobar-dont-show-message =
    .label = Dit bericht niet tonen wanneer pop-ups worden geblokkeerd
    .accesskey = n
edit-popup-settings =
    .label = Pop-upinstellingen beheren…
    .accesskey = b
picture-in-picture-hide-toggle =
    .label = Picture-in-picture-knop verbergen
    .accesskey = v

## Since the default position for PiP controls does not change for RTL layout,
## right-to-left languages should use "Left" and "Right" as in the English strings,

picture-in-picture-move-toggle-right =
    .label = Picture-in-picture-schakelaar naar de rechterzijde verplaatsen
    .accesskey = z
picture-in-picture-move-toggle-left =
    .label = Picture-in-picture-schakelaar naar de linkerzijde verplaatsen
    .accesskey = j

##


# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navigatie
navbar-downloads =
    .label = Downloads
navbar-overflow =
    .tooltiptext = Meer hulpmiddelen…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Afdrukken
    .tooltiptext = Deze pagina afdrukken… ({ $shortcut })
navbar-home =
    .label = Startpagina
    .tooltiptext = { -brand-short-name }-startpagina
navbar-library =
    .label = Bibliotheek
    .tooltiptext = Geschiedenis, opgeslagen bladwijzers en meer bekijken
navbar-search =
    .title = Zoeken
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Browsertabbladen
tabs-toolbar-new-tab =
    .label = Nieuw tabblad
tabs-toolbar-list-all-tabs =
    .label = Alle tabbladtitels tonen
    .tooltiptext = Alle tabbladtitels tonen

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Eerdere tabbladen openen?</strong> U kunt uw vorige sessie herstellen vanuit het toepassingsmenu van { -brand-short-name } <img data-l10n-name="icon"/>, onder Geschiedenis.
restore-session-startup-suggestion-button = Tonen hoe

## BrowserWorks data reporting notification (Telemetry, Waterfox Health Report, etc)

data-reporting-notification-message = { -brand-short-name } verzendt automatisch een aantal gegevens naar { -vendor-short-name }, zodat we uw ervaring kunnen verbeteren.
data-reporting-notification-button =
    .label = Kiezen wat ik deel
    .accesskey = K
# Label for the indicator shown in the private browsing window titlebar.
private-browsing-indicator-label = Privénavigatie

## Unified extensions (toolbar) button

unified-extensions-button =
    .label = Extensies
    .tooltiptext = Extensies

## Unified extensions button when permission(s) are needed.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-permissions-needed =
    .label = Extensies
    .tooltiptext =
        Extensies
        Machtigingen benodigd

## Unified extensions button when some extensions are quarantined.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-quarantined =
    .label = Extensies
    .tooltiptext =
        Extensies
        Sommige extensies zijn niet toegestaan

## Autorefresh blocker

refresh-blocked-refresh-label = { -brand-short-name } heeft voorkomen dat deze pagina automatisch werd herladen.
refresh-blocked-redirect-label = { -brand-short-name } heeft voorkomen dat deze pagina automatisch werd doorgestuurd naar een andere pagina.
refresh-blocked-allow =
    .label = Toestaan
    .accesskey = T

## Waterfox Relay integration

firefox-relay-offer-why-to-use-relay = Onze veilige, gebruiksvriendelijke maskers beschermen uw identiteit en voorkomen spam door uw e-mailadres te verbergen.
# Variables:
#  $useremail (String): user email that will receive messages
firefox-relay-offer-what-relay-provides = Alle e-mailberichten die naar uw e-mailmaskers worden verzonden, worden doorgestuurd naar <strong>{ $useremail }</strong> (tenzij u besluit ze te blokkeren).
firefox-relay-offer-legal-notice = Door op ‘E-mailmasker gebruiken’ te klikken, gaat u akkoord met de <label data-l10n-name="tos-url">Servicevoorwaarden</label> en <label data-l10n-name="privacy-url">Privacyverklaring</label>.

## Add-on Pop-up Notifications

popup-notification-addon-install-unsigned =
    .value = (Niet geverifieerd)
popup-notification-xpinstall-prompt-learn-more = Meer info over het veilig installeren van add-ons

## Pop-up warning

# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-message =
    { $popupCount ->
        [one] { -brand-short-name } heeft voorkomen dat deze website een pop-upvenster opende.
       *[other] { -brand-short-name } heeft voorkomen dat deze website { $popupCount } pop-upvensters opende.
    }
# The singular form is left out for English, since the number of blocked pop-ups is always greater than 1.
# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-exceeded-message = { -brand-short-name } heeft voorkomen dat deze website meer dan { $popupCount } pop-upvensters opende.
popup-warning-button =
    .label =
        { PLATFORM() ->
            [windows] Opties
           *[other] Voorkeuren
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] V
        }
# Variables:
#   $popupURI (String): the URI for the pop-up window
popup-show-popup-menuitem =
    .label = “{ $popupURI }” tonen
