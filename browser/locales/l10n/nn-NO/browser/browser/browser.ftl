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
    .aria-label = Vis sideinfo

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Opne meldingspanel for installasjon
urlbar-web-notification-anchor =
    .tooltiptext = Vel om du kan ta imot varsel frå nettstaden
urlbar-midi-notification-anchor =
    .tooltiptext = Opne MIDI-panel
urlbar-eme-notification-anchor =
    .tooltiptext = Handter bruken av DRM-programvare
urlbar-web-authn-anchor =
    .tooltiptext = Opne webautentiseringspanelet
urlbar-canvas-notification-anchor =
    .tooltiptext = Handter rettar for canvas-utdraging
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Handter deling av mikrofon med denne nettstaden
urlbar-default-notification-anchor =
    .tooltiptext = Opne meldingspanel
urlbar-geolocation-notification-anchor =
    .tooltiptext = Opne panel for plasseringsførespurnad
urlbar-xr-notification-anchor =
    .tooltiptext = Opne autoriseringspanelet for virtuell røyndom
urlbar-storage-access-anchor =
    .tooltiptext = Opne løyvepanelet for nettlesaraktivitet
urlbar-translate-notification-anchor =
    .tooltiptext = Omset denne sida
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Handter deling av vindauge eller skjerm med nettstaden
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Opne meldingspanel for fråkopla data
urlbar-password-notification-anchor =
    .tooltiptext = Opne meldingspanel for lagring av passord
urlbar-translated-notification-anchor =
    .tooltiptext = Handter sideomsetting
urlbar-plugins-notification-anchor =
    .tooltiptext = Administrer bruk av programtillegg
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Handter deling av kamera og/eller mikrofon på denne nettstaden
urlbar-autoplay-notification-anchor =
    .tooltiptext = Opne automatisk avspeling-panelet
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Lagre data i vedvarande lagring
urlbar-addons-notification-anchor =
    .tooltiptext = Opne meldingspanel for tileggsinstallasjon
urlbar-tip-help-icon =
    .title = Få hjelp
urlbar-search-tips-confirm = Ok, eg forstår
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tips:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Tast mindre, finn meir: Søk med { $engineName } rett frå adresselinja.
urlbar-search-tips-redirect-2 = Start søket ditt i adressefeltet for å sjå forslag frå { $engineName } og nettleserhistorikken din.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Bokmerke
urlbar-search-mode-tabs = Faner
urlbar-search-mode-history = Historikk

##

urlbar-geolocation-blocked =
    .tooltiptext = Du har blokkert plasseringsinformasjon for denne nettstaden.
urlbar-xr-blocked =
    .tooltiptext = Du har blokkert tilgang for virtuell røyndomseining for denne nettstaden.
urlbar-web-notifications-blocked =
    .tooltiptext = Du har blokkert meldingar for denne nettstaden.
urlbar-camera-blocked =
    .tooltiptext = Du har blokkert kameraet for denne nettstaden.
urlbar-microphone-blocked =
    .tooltiptext = Du har blokkert mikrofonen for denne nettstaden.
urlbar-screen-blocked =
    .tooltiptext = Du har blokkert denne nettstaden frå å dele skjermen din.
urlbar-persistent-storage-blocked =
    .tooltiptext = Du har blokkert vedvarande lagring for denne nettsida.
urlbar-popup-blocked =
    .tooltiptext = Du har blokkert sprettoppvindauge for denne nettstaden.
urlbar-autoplay-media-blocked =
    .tooltiptext = Du har blokkert automatisk avspeling av media med lyd på denne nettsida.
urlbar-canvas-blocked =
    .tooltiptext = Du har blokkert canvas-datauthenting for denne nettstaden.
urlbar-midi-blocked =
    .tooltiptext = Du har blokkert MIDI-tilgang for denne nettsida.
urlbar-install-blocked =
    .tooltiptext = Du har blokkert installasjon av utvidingar for denne nettstaden.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Rediger dette bokmerket ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Bokmerk denne sida ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Legg til i adresselinja
page-action-manage-extension =
    .label = Handter utviding…
page-action-remove-from-urlbar =
    .label = Fjern fra adresselinja
page-action-remove-extension =
    .label = Fjern utviding

## Auto-hide Context Menu

full-screen-autohide =
    .label = Gøym verktøylinjer
    .accesskey = G
full-screen-exit =
    .label = Avslutt fullskjermmodus
    .accesskey = v

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Søk ein gong med:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Endre søkjeinnstillingar
search-one-offs-change-settings-compact-button =
    .tooltiptext = Endre søkjeinnstillingar
search-one-offs-context-open-new-tab =
    .label = Søk i ny fane
    .accesskey = ø
search-one-offs-context-set-as-default =
    .label = Bruk som standard søkjemotor
    .accesskey = B
search-one-offs-context-set-as-default-private =
    .label = Vel som standard søkjemotor for private vindauge
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
    .tooltiptext = Bokmerke ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Faner ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historikk ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Vis redigerar ved lagring
    .accesskey = V
bookmark-panel-done-button =
    .label = Ferdig
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Tilkoplinga er ikkje sikker
identity-connection-secure = Tilkoplinga er sikker
identity-connection-internal = Dette er ei sikker { -brand-short-name }-side.
identity-connection-file = Denne sida er lagra på datamaskina di.
identity-extension-page = Denne sida er lasta frå ei utviding.
identity-active-blocked = { -brand-short-name } har blokkert delar av denne sida som ikkje er sikre.
identity-custom-root = Tilkoplinga vart stadfesta av ein sertifikatutskrivar som Mozilla ikkje kjenner.
identity-passive-loaded = Delar av denne sida er ikkje trygg (til dømes bilde).
identity-active-loaded = Du har slått av vern på denne sida.
identity-weak-encryption = Denne sida brukar ei svak kryptering.
identity-insecure-login-forms = Innloggingsinfo skrive inn på denne sida kan lesast av tredjepart.
identity-permissions =
    .value = Løyve
identity-permissions-reload-hint = Du må kanskje laste sida på nytt for at endringane skal gjelde.
identity-permissions-empty = Du har ikkje gjeve denne nettstaden spesielle løyve.
identity-clear-site-data =
    .label = Slett infokapslar og nettstaddata…
identity-connection-not-secure-security-view = Du er ikkje sikkert kopla til denne nettstaden.
identity-connection-verified = Du er sikkert kopla til denne nettstaden.
identity-ev-owner-label = Sertifikat skrive ut til:
identity-description-custom-root = Mozilla kjenner ikkje att utskrivaren av dette sertifikatet. Det kan ha blitt lagt til av operativsystemet ditt, eller av ein administrator. <label data-l10n-name="link">Les meir</label>
identity-remove-cert-exception =
    .label = Fjern unntak
    .accesskey = F
identity-description-insecure = Tilkoplinga til denne nettstaden er ikkje privat. Informasjon du sender kan lesast av andre (som t.d. passord, meldingar, kredittkort osv.).
identity-description-insecure-login-forms = Innloggingsinformasjonen du skreiv inn på denne sida er ikkje trygg og kan difor verte kompromittert.
identity-description-weak-cipher-intro = Sambandet til denne nettsida brukar ei svak kryptering og er ikkje privat.
identity-description-weak-cipher-risk = Andre personar kan sjå informasjon eller endre måten nettsida oppfører seg på.
identity-description-active-blocked = { -brand-short-name } har blokkert delar av denne sida som ikkje er trygg. <label data-l10n-name="link">Les meir</label>
identity-description-passive-loaded = Sambandet til denne nettstaden er ikkje privat og informasjon du deler med denne sida kan sjåast av andre.
identity-description-passive-loaded-insecure = Denne nettsida har innhald som ikkje er trygt (t.d. bilde). <label data-l10n-name="link">Les meir</label>
identity-description-passive-loaded-mixed = Sjølv om { -brand-short-name } har blokkert noko innhald, finst det framleis innhald på sida som ikkje er trygt (slik som bilde). <label data-l10n-name="link">Les meir</label>
identity-description-active-loaded = Denne nettstaden har innhald som ikkje er overført sikkert (slik som skript) og tilkoplinga di er difor ikkje privat.
identity-description-active-loaded-insecure = Informasjonen du deler med denne nettstaden kan sjåast av andre (t.d. passords, meldingar, kredittkort osb.).
identity-learn-more =
    .value = Les meir
identity-disable-mixed-content-blocking =
    .label = Slå av vern
    .accesskey = a
identity-enable-mixed-content-blocking =
    .label = Slå på vern
    .accesskey = S
identity-more-info-link-text =
    .label = Meir informasjon

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimer
browser-window-maximize-button =
    .tooltiptext = Maksimer
browser-window-restore-down-button =
    .tooltiptext = Gjenopprett ned
browser-window-close-button =
    .tooltiptext = Lat att

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera som vert delt:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon som vert delt:
    .accesskey = M
popup-all-windows-shared = Alle synlege vindauge på skjermen vil bli delte.
popup-screen-sharing-not-now =
    .label = Ikkje no
    .accesskey = n
popup-screen-sharing-never =
    .label = Tillat aldri
    .accesskey = a
popup-silence-notifications-checkbox = Deaktiver varsel frå { -brand-short-name } medan du deler
popup-silence-notifications-checkbox-warning = { -brand-short-name } vil ikkje vise varsel medan du deler.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Du deler { -brand-short-name }. Andre personar kan sjå når du byter til ei ny fane.
sharing-warning-screen = Du deler heile skjermen. Andre personar kan sjå når du byter til ei ny fane.
sharing-warning-proceed-to-tab =
    .label = Fortset til fana
sharing-warning-disable-for-session =
    .label = Slå av delingsvern for denne økta

## DevTools F12 popup

enable-devtools-popup-description = For å bruke F12-snarvegen, må du først opne DevTools via menyen for Nettsideutvikling

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Søk eller skriv inn ei adresse
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Søk eller skriv inn ei adresse
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
    .aria-label = Søk i bokmerke
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
    .tooltiptext = Nettlesaren er under fjernstyring
urlbar-permissions-granted =
    .tooltiptext = Du har gjeve denne nettstaden ytterlegare løyve.
urlbar-switch-to-tab =
    .value = Byt til fane:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Utviding:
urlbar-go-button =
    .tooltiptext = Gå til adressa i adresselinja
urlbar-page-action-button =
    .tooltiptext = Sidehandlingar
urlbar-pocket-button =
    .tooltiptext = Lagre til { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> er no i fullskjerm
fullscreen-warning-no-domain = Dette dokumentet er no i fullskjerm
fullscreen-exit-button = Avslutt fullskjerm (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Avslutt fullskjerm (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> har kontroll over peikaren din. Trykk Esc for å ta tilbake kontrollen.
pointerlock-warning-no-domain = Dette dokumentet har kontroll over musepeikaren. Trykk på Esc for å ta tilbake kontrollen.
