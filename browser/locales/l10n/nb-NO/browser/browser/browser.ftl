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
    .data-title-private = { -brand-full-name } (Privat nettlesing)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privat nettlesing)
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
    .data-title-private = { -brand-full-name } - (Privat nettlesing)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privat nettlesing)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Vis nettstedsinformasjon

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Åpne meldingspanel for installasjon
urlbar-web-notification-anchor =
    .tooltiptext = Velg om du kan motta varsler fra nettstedet
urlbar-midi-notification-anchor =
    .tooltiptext = Åpne MIDI-panelet
urlbar-eme-notification-anchor =
    .tooltiptext = Behandle bruk av DRM-programmer
urlbar-web-authn-anchor =
    .tooltiptext = Åpne webautentiseringspanelet
urlbar-canvas-notification-anchor =
    .tooltiptext = Håndter rettigheter for uttrekking av canvas-data
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Behandle deling av mikrofon med dette nettstedet
urlbar-default-notification-anchor =
    .tooltiptext = Åpne meldingspanel
urlbar-geolocation-notification-anchor =
    .tooltiptext = Åpne panel for stedsforespørsel
urlbar-xr-notification-anchor =
    .tooltiptext = Åpne autoriseringspanelet for virtuell virkelighet
urlbar-storage-access-anchor =
    .tooltiptext = Åpne autoriseringspanelet for nettleseraktivitet
urlbar-translate-notification-anchor =
    .tooltiptext = Oversett denne siden
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Behandle deling av vinduer eller skjerm med nettstedet
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Åpne meldingspanel for frakoblet data
urlbar-password-notification-anchor =
    .tooltiptext = Åpne meldingspanel for lagring av passord
urlbar-translated-notification-anchor =
    .tooltiptext = Behandle sideoversettelser
urlbar-plugins-notification-anchor =
    .tooltiptext = Administrer bruk av programtillegg
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Behandle deling av kamera og/eller mikrofon på dette nettstedet
urlbar-autoplay-notification-anchor =
    .tooltiptext = Åpne automatisk avspilling-panelet
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Lagre data i vedvarende lagring
urlbar-addons-notification-anchor =
    .tooltiptext = Åpne meldingspanel for utvidelsesinstallasjon
urlbar-tip-help-icon =
    .title = Få hjelp
urlbar-search-tips-confirm = Ok, jeg forstår
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tips:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Skriv mindre, finn mer: Søk med { $engineName } direkte fra adresselinjen din.
urlbar-search-tips-redirect-2 = Start ditt søk i adressefeltet for å se forslag fra { $engineName } og din nettleserhistorikk.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Bokmerker
urlbar-search-mode-tabs = Faner
urlbar-search-mode-history = Historikk

##

urlbar-geolocation-blocked =
    .tooltiptext = Du har blokkert plasseringsinformasjon for dette nettstedet.
urlbar-xr-blocked =
    .tooltiptext = Du har blokkert tilgang for virtuell virkelighetsenhet for dette nettstedet.
urlbar-web-notifications-blocked =
    .tooltiptext = Du har blokkert varsler for dette nettstedet.
urlbar-camera-blocked =
    .tooltiptext = Du har blokkert kameraet for dette nettstedet.
urlbar-microphone-blocked =
    .tooltiptext = Du har blokkert mikrofonen for dette nettstedet.
urlbar-screen-blocked =
    .tooltiptext = Du har blokkert dette nettstedet fra å dele din skjerm.
urlbar-persistent-storage-blocked =
    .tooltiptext = Du har blokkert vedvarende lagring for denne nettsiden.
urlbar-popup-blocked =
    .tooltiptext = Du har blokkert sprettoppvinduer for dette nettstedet.
urlbar-autoplay-media-blocked =
    .tooltiptext = Du har blokkert automatisk avspilling av medier med lyd på dette nettstedet.
urlbar-canvas-blocked =
    .tooltiptext = Du har blokkert uttrekking av canvas-data for dette nettstedet.
urlbar-midi-blocked =
    .tooltiptext = Du har blokkert MIDI-tilgang for dette nettstedet.
urlbar-install-blocked =
    .tooltiptext = Du har blokkert installasjon av utvidelser for dette nettstedet.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Rediger dette bokmerket ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Bokmerk denne siden ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Legg til i adresselinjen
page-action-manage-extension =
    .label = Behandle utvidelser…
page-action-remove-from-urlbar =
    .label = Fjern fra adresselinjen
page-action-remove-extension =
    .label = Fjern utvidelse

## Auto-hide Context Menu

full-screen-autohide =
    .label = Skjul verktøylinjer
    .accesskey = S
full-screen-exit =
    .label = Avslutt fullskjermmodus
    .accesskey = v

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Søk denne gangen med:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Endre søkeinnstillinger
search-one-offs-change-settings-compact-button =
    .tooltiptext = Endre søkeinnstillinger
search-one-offs-context-open-new-tab =
    .label = Søk i ny fane
    .accesskey = f
search-one-offs-context-set-as-default =
    .label = Bruk som standard søkemotor
    .accesskey = B
search-one-offs-context-set-as-default-private =
    .label = Angi som standard søkemotor for private vindu
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
    .tooltiptext = Bokmerker ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Faner ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historikk ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Vis redigerer ved lagring
    .accesskey = s
bookmark-panel-done-button =
    .label = Ferdig
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Tilkoblingen er ikke sikker
identity-connection-secure = Tilkoblingen er sikker
identity-connection-internal = Dette er en sikker { -brand-short-name }-side.
identity-connection-file = Denne siden lagres på datamaskinen din.
identity-extension-page = Denne siden er lastet fra en utvidelse.
identity-active-blocked = { -brand-short-name } blokkerte deler av denne siden som ikke er sikre.
identity-custom-root = Tilkobling verifisert av en sertifikatutsteder som ikke kjennes igjen av Mozilla.
identity-passive-loaded = Deler av denne siden er ikke sikker (f.eks. bilder).
identity-active-loaded = Du har slått av beskyttelse på denne siden.
identity-weak-encryption = Denne siden bruker svak kryptering.
identity-insecure-login-forms = Innloggingsinfo skrevet inn på denne kan leses av en tredjepart.
identity-permissions =
    .value = Tillatelser
identity-permissions-reload-hint = Du må kanskje laste siden på nytt for at endringene skal gjelde.
identity-permissions-empty = Du har ikke gitt dette nettstedet noen spesialtillatelser.
identity-clear-site-data =
    .label = Slett infokapsler og nettstedsdata…
identity-connection-not-secure-security-view = Du er ikke sikkert koblet til dette nettstedet.
identity-connection-verified = Du er sikkert koblet til dette nettstedet.
identity-ev-owner-label = Sertifikat utstedt til:
identity-description-custom-root = Mozilla kjenner ikke igjen denne sertifikatutstederen. Den kan ha blitt lagt til av ditt operativsystem eller av en administrator. <label data-l10n-name="link">Les mer</label>
identity-remove-cert-exception =
    .label = Fjern unntak
    .accesskey = F
identity-description-insecure = Tilkoblingen til dette nettstedet er ikke privat. Informasjon du sender kan leses av andre (som f.eks. passord, meldinger, kredittkort, osv.).
identity-description-insecure-login-forms = Innloggingsinformasjonen du skriver inn på denne siden er ikke trygg, og kan kompromitteres.
identity-description-weak-cipher-intro = Tilkoblingen til dette nettstedet bruker svak kryptering, og er ikke privat.
identity-description-weak-cipher-risk = Andre personer kan se informasjonen eller endre nettstedets oppførsel.
identity-description-active-blocked = { -brand-short-name } har blokkert deler av denne siden som ikke er sikker. <label data-l10n-name="link">Les mer</label>
identity-description-passive-loaded = Tilkoblingen er ikke privat, og informasjon du sender til nettstedet kan vises av andre.
identity-description-passive-loaded-insecure = Dette nettstedet inneholder informasjon som ikke er overført sikkert (f.eks. bilder). <label data-l10n-name="link">Les mer</label>
identity-description-passive-loaded-mixed = Selv om { -brand-short-name } har blokkert noe innhold, er det fortsatt innhold på denne siden som ikke er sikker (f.eks. bilder). <label data-l10n-name="link">Les mer</label>
identity-description-active-loaded = Dette nettstedet inneholder innhold som ikke er overført sikkert (som f.eks. skript), og tilkoblingen til nettstedet er derfor ikke privat.
identity-description-active-loaded-insecure = Informasjon du sender til dette nettstedet kan vises av andre (som passord, meldinger, kredittkort, osv.).
identity-learn-more =
    .value = Les mer
identity-disable-mixed-content-blocking =
    .label = Slå av beskyttelse
    .accesskey = a
identity-enable-mixed-content-blocking =
    .label = Slå på beskyttelse
    .accesskey = S
identity-more-info-link-text =
    .label = Mer informasjon

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimer
browser-window-maximize-button =
    .tooltiptext = Maksimer
browser-window-restore-down-button =
    .tooltiptext = Gjenopprett ned
browser-window-close-button =
    .tooltiptext = Lukk

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera som deles:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon som deles:
    .accesskey = M
popup-all-windows-shared = Alle synlige vinduer på skjermen vil deles.
popup-screen-sharing-not-now =
    .label = Ikke nå
    .accesskey = n
popup-screen-sharing-never =
    .label = Tillat aldri
    .accesskey = a
popup-silence-notifications-checkbox = Deaktiver varsler fra { -brand-short-name } mens du deler
popup-silence-notifications-checkbox-warning = { -brand-short-name } vil ikke vise varsler mens du deler.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Du deler { -brand-short-name }. Andre personer kan se når du bytter til en ny fane.
sharing-warning-screen = Du deler hele skjermen. Andre personer kan se når du bytter til en ny fane.
sharing-warning-proceed-to-tab =
    .label = Fortsett til fanen
sharing-warning-disable-for-session =
    .label = Slå av delingsbeskyttelse for denne økten

## DevTools F12 popup

enable-devtools-popup-description = For å bruke F12-snarveien, må du først åpne DevTools via menyen for Nettsideutvikling

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Søk eller skriv inn adresse
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Søk eller skriv inn adresse
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Søk på nettet
    .aria-label = Søk med { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Skriv inn søketekst
    .aria-label = Søk { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Skriv inn søketekst
    .aria-label = Søk i bokmerker
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Skriv inn søketekst
    .aria-label = Søk i historikk
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Skriv inn søketekst
    .aria-label = Søk i faner
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Søk med { $name } eller skriv inn adresse
urlbar-remote-control-notification-anchor =
    .tooltiptext = Nettleseren er under fjernstyring
urlbar-permissions-granted =
    .tooltiptext = Du har gitt dette nettstedet noen spesialtillatelser.
urlbar-switch-to-tab =
    .value = Bytt til fane:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Utvidelse:
urlbar-go-button =
    .tooltiptext = Gå til adressen i adresselinjen
urlbar-page-action-button =
    .tooltiptext = Sidehandlinger
urlbar-pocket-button =
    .tooltiptext = Lagre til { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> er nå i fullskjerm
fullscreen-warning-no-domain = Dette dokumentet er nå i fullskjerm
fullscreen-exit-button = Avslutt fullskjerm (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Avslutt fullskjerm (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> har kontroll over musepekeren din. Trykk Esc for å ta tilbake kontrollen.
pointerlock-warning-no-domain = Dette dokumentet har kontroll over musepekeren din. Trykk på Esc for å ta tilbake kontrollen.
