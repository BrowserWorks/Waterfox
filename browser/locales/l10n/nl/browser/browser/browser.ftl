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
    .data-title-private = { -brand-full-name } (Privénavigatie)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privénavigatie)
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

# This string prompts the user to use the list of one-click search engines in
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

bookmark-panel-show-editor-checkbox =
    .label = Editor tonen bij opslaan
    .accesskey = E
bookmark-panel-done-button =
    .label = Gereed
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Verbinding niet beveiligd
identity-connection-secure = Verbinding beveiligd
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

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Te delen camera:
    .accesskey = C
popup-select-microphone =
    .value = Te delen microfoon:
    .accesskey = M
popup-all-windows-shared = Alle zichtbare vensters op uw scherm worden gedeeld.
popup-screen-sharing-not-now =
    .label = Niet nu
    .accesskey = i
popup-screen-sharing-never =
    .label = Nooit toestaan
    .accesskey = N
popup-silence-notifications-checkbox = Notificaties van { -brand-short-name } uitschakelen tijdens delen
popup-silence-notifications-checkbox-warning = { -brand-short-name } toont geen meldingen terwijl u deelt.

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
urlbar-remote-control-notification-anchor =
    .tooltiptext = Browser wordt op afstand bestuurd
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
