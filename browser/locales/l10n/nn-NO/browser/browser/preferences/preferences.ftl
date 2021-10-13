# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Send nettsider eit «Ikkje spor»-signal om at du ikkje vil bli spora
do-not-track-learn-more = Les meir
do-not-track-option-default-content-blocking-known =
    .label = Berre når { -brand-short-name } er innstilt for å blokkere kjende sporarar
do-not-track-option-always =
    .label = Alltid
settings-page-title = Innstillingar
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = Søk i innstillingar
managed-notice = Nettlessaren din vert administrert av organisasjonen din.
category-list =
    .aria-label = Kategoriar
pane-general-title = Generelt
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Start
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Søk
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Personvern og sikkerheit
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title3 = Synkronisering
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = { -brand-short-name }-eksperiment
category-experimental =
    .tooltiptext = { -brand-short-name }-eksperiment
pane-experimental-subtitle = Gå varsamt til verks
pane-experimental-search-results-header = { -brand-short-name }-eksperiment: Fortset med varsemd
pane-experimental-description2 = Endrar du avanserte konfigurasjonsinnstillingar kan det påverke yting eller sikkerheit i { -brand-short-name }.
pane-experimental-reset =
    .label = Gjenopprett standard
    .accesskey = G
help-button-label = Brukarstøtte for { -brand-short-name }
addons-button-label = Utvidingar og tema
focus-search =
    .key = f
close-button =
    .aria-label = Lat att

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } må starte på nytt for å slå på denne funksjonen.
feature-disable-requires-restart = { -brand-short-name } må starte på nytt for å slå på denne funksjonen.
should-restart-title = Start { -brand-short-name } på nytt
should-restart-ok = Start { -brand-short-name } på nytt no
cancel-no-restart-button = Avbryt
restart-later = Start på nytt seinare

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Ei utviding, <img data-l10n-name="icon"/> { $name }, styrer denne innstillinga.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Eit tillegg, <img data-l10n-name="icon"/> { $name }, kontrollerer denne innstillinga.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Ei utviding, <img data-l10n-name="icon"/> { $name }, krev innhaldsfaner.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Eit tillegg, <img data-l10n-name="icon"/> { $name }, styrer denne innstillinga.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Ei utviding, <img data-l10n-name="icon"/> { $name }, styrer korleis { -brand-short-name } koplar seg til internett.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = For å aktivere utvidinga, gå til <img data-l10n-name="addons-icon"/> Utviding i menyen <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Søkjeresultat
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Orsak! Det er ingen resultat i innstillingar for «<span data-l10n-name="query"></span>».
search-results-help-link = Treng du hjelp? Gå til <a data-l10n-name="url">{ -brand-short-name } brukarstøtte</a>

## General Section

startup-header = Startside
always-check-default =
    .label = Kontroller alltid om { -brand-short-name } er standard-nettlesar
    .accesskey = a
is-default = { -brand-short-name } er standard-nettlesar
is-not-default = { -brand-short-name } er ikkje standard nettlesar
set-as-my-default-browser =
    .label = Bruk som standard…
    .accesskey = S
startup-restore-previous-session =
    .label = Bygg oppatt siste programøkt
    .accesskey = B
startup-restore-windows-and-tabs =
    .label = Opne tidlegare vindauge og faner
    .accesskey = p
startup-restore-warn-on-quit =
    .label = Åtvar meg når eg avsluttar nettlesaren
disable-extension =
    .label = Slå av utviding
tabs-group-header = Faner
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab vekslar mellom faner i nyleg brukt-rekkjefølgje
    .accesskey = T
open-new-link-as-tabs =
    .label = Opne lenker i faner i staden for nye vindauge
    .accesskey = l
warn-on-close-multiple-tabs =
    .label = Åtvar meg når eg vil late att fleire faner
    .accesskey = Å
confirm-on-close-multiple-tabs =
    .label = Stadfest før attlating av fleire faner
    .accesskey = S
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (String) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Stadfest før avslutting med { $quitKey }
    .accesskey = S
warn-on-open-many-tabs =
    .label = Åtvar meg når opning av mange faner samstundes kan gjere { -brand-short-name } treg
    .accesskey = a
switch-to-new-tabs =
    .label = Når du opner ei lenke, eit bilde eller media i ei ny fane, byt til fana med ein gong
    .accesskey = d
show-tabs-in-taskbar =
    .label = Vis førehandsvising av faner i Windows-oppgåvelinja
    .accesskey = s
browser-containers-enabled =
    .label = Aktiver innhaldsfaner
    .accesskey = k
browser-containers-learn-more = Les meir
browser-containers-settings =
    .label = Innstillingar…
    .accesskey = I
containers-disable-alert-title = Late att alle innhaldsfaner?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Dersom du deaktiverer innhaldsfaner no, vil { $tabCount } innhaldsfane bli stengt. Er du sikker på at du vil deaktivere innhaldsfaner?
       *[other] Dersom du deaktiverer innhaldsfaner no, vil { $tabCount } innhaldsfaner bli stengt. Er du sikker på at du vil deaktivere innhaldsfaner?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Lat att { $tabCount } innhaldsfane
       *[other] Lat att { $tabCount } innhaldsfaner
    }
containers-disable-alert-cancel-button = Behald aktivert
containers-remove-alert-title = Fjerne denne behaldaren?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Om du fjernar denne behaldaren no, vil { $count } behaldarfane latast att. Er du sikker på at du vil fjerne denne behaldaren?
       *[other] Om du fjernar denne behaldaren no, vil { $count } behaldarfaner latast att. Er du sikker på at du vil fjerne denne behaldaren?
    }
containers-remove-ok-button = Fjern denne behaldaren
containers-remove-cancel-button = Ikkje fjern denne behaldaren

## General Section - Language & Appearance

language-and-appearance-header = Språk og utsjånad
fonts-and-colors-header = Skrifttypar og fargar
default-font = Standardskrift
    .accesskey = t
default-font-size = Storleik
    .accesskey = S
advanced-fonts =
    .label = Avansert…
    .accesskey = A
colors-settings =
    .label = Fargar…
    .accesskey = F
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Skalering
preferences-default-zoom = Standardskalering
    .accesskey = s
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Forstørr berre tekst
    .accesskey = o
language-header = Språk
choose-language-description = Vel føretrekte språk på nettsider
choose-button =
    .label = Vel…
    .accesskey = V
choose-browser-language-description = Vel språka som som skal brukast til å vise menyar, meldingar og varsel frå { -brand-short-name }.
manage-browser-languages-button =
    .label = Vel alternativ…
    .accesskey = l
confirm-browser-language-change-description = Start om { -brand-short-name } for å bruke disse endringene
confirm-browser-language-change-button = Bruk og start på nytt
translate-web-pages =
    .label = Omset webinnhald
    .accesskey = O
fx-translate-web-pages = { -translations-brand-name }
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Omsettingar av <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Unntak…
    .accesskey = n
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Bruk operativsystem-innstillingane for «{ $localeName }» for å formatere datoar, klokkeslett, tal og målingar.
check-user-spelling =
    .label = Kontroller stavinga mi når eg tastar
    .accesskey = K

## General Section - Files and Applications

files-and-applications-title = Filer og program
download-header = Nedlastingar
download-save-to =
    .label = Lagre filer i
    .accesskey = L
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Vel…
           *[other] Bla gjennom…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] o
        }
download-always-ask-where =
    .label = Spør alltid om kvar eg vil lagre filer
    .accesskey = a
applications-header = Program
applications-description = Vel korleis { -brand-short-name } handterer filer du hentar frå nettet eller programma du brukar når du surfar.
applications-filter =
    .placeholder = Søk filtypar eller program
applications-type-column =
    .label = Innhaldstype
    .accesskey = I
applications-action-column =
    .label = Handling
    .accesskey = H
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension }-fil
applications-action-save =
    .label = Lagre fila
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Bruk { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Bruk { $app-name } (standard)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Bruk macOS-standardprogrammet
            [windows] Bruk Windows-standardprogrammet
           *[other] Bruk standardprogrammet til systemet
        }
applications-use-other =
    .label = Bruk anna…
applications-select-helper = Vel hjelpeprogram
applications-manage-app =
    .label = Programinformasjon…
applications-always-ask =
    .label = Spør alltid
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Bruk { $plugin-name } (i { -brand-short-name })
applications-open-inapp =
    .label = Opne i { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Digital Rights Management (DRM) innhald
play-drm-content =
    .label = Spel DRM-kontrollert innhald
    .accesskey = S
play-drm-content-learn-more = Les meir
update-application-title = { -brand-short-name }-oppdateringar
update-application-description = Hald { -brand-short-name } oppdatert for beste yting, stabilitet og sikkerheit.
update-application-version = Versjon { $version } <a data-l10n-name="learn-more">Kva er nytt</a>
update-history =
    .label = Vis oppdateringshistorikk…
    .accesskey = p
update-application-allow-description = Tillat { -brand-short-name } å
update-application-auto =
    .label = Installer oppdateringar automatisk (tilrådd)
    .accesskey = a
update-application-check-choose =
    .label = Sjå etter oppdateringar, men la meg velje om eg vil installere dei
    .accesskey = S
update-application-manual =
    .label = Sjå aldri etter oppdateringar (ikkje tilrådd)
    .accesskey = a
update-application-background-enabled =
    .label = Når { -brand-short-name } ikkje køyrer
    .accesskey = N
update-application-warning-cross-user-setting = Denne innstillinga gjeld for alle Windows-kontoar og { -brand-short-name }-profilar som brukar denne installasjonen av { -brand-short-name }.
update-application-use-service =
    .label = Bruk ei bakgrunnsteneste for å installere oppdateringar
    .accesskey = B
update-setting-write-failure-title2 = Klarte ikkje å lagre oppdateringsinnstillingar
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } oppdaga ein feil og lagra ikkje denne endringa. Merk, for å kunne lagre endringa av denne oppdateringsinnstillinga, vert det krevd løyve til å skrive til fila nedanfor. Du eller ein systemadministrator kan kanskje rette feilen ved å gi gruppa Brukarar full tilgang til denne fila.
    
    Kunne ikke skrive til filen: { $path }
update-in-progress-title = Oppdatering i framdrift
update-in-progress-message = Vil du at { -brand-short-name } skal fortsetje med denne oppdateringa?
update-in-progress-ok-button = &Avvis
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortset

## General Section - Performance

performance-title = Yting
performance-use-recommended-settings-checkbox =
    .label = Bruk tilrådde innstillingar for yting
    .accesskey = B
performance-use-recommended-settings-desc = Desse innstillingane er skreddarsydde for maskinvare og operativsystem i datamaskina di.
performance-settings-learn-more = Les meir
performance-allow-hw-accel =
    .label = Bruk maskinvareakselerasjon når tilgjengeleg
    .accesskey = m
performance-limit-content-process-option = Grense for innhaldsprosessar
    .accesskey = G
performance-limit-content-process-enabled-desc = Ytterlegere innhaldsprosessar kan forbetre ytinga når du brukar fleire faner, men vil også bruke meir minne.
performance-limit-content-process-blocked-desc = Endring av talet på innhaldsprosessar kan berre gjerast med multiprosess { -brand-short-name }. <a data-l10n-name="learn-more">Lær deg korleis du kontrollerer om multiprosess er slått på</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (standard)

## General Section - Browsing

browsing-title = Nettlesing
browsing-use-autoscroll =
    .label = Bruk automatisk rulling
    .accesskey = B
browsing-use-smooth-scrolling =
    .label = Bruk jamn rulling
    .accesskey = u
browsing-use-onscreen-keyboard =
    .label = Vis eit tøtsj-tastatur når nødvendig
    .accesskey = t
browsing-use-cursor-navigation =
    .label = Bruk alltid piltastane for å navigere innanfor nettsider
    .accesskey = A
browsing-search-on-start-typing =
    .label = Søk etter tekst når eg byrjar å skrive
    .accesskey = k
browsing-picture-in-picture-toggle-enabled =
    .label = Slå på videokontrollar for bilde-i-bilde
    .accesskey = e
browsing-picture-in-picture-learn-more = Les meir
browsing-media-control =
    .label = Kontroller media via tastatur, hovudsett eller virtuelt grensesnitt
    .accesskey = o
browsing-media-control-learn-more = Les meir
browsing-cfr-recommendations =
    .label = Tilrå utvidingar når du surfar
    .accesskey = T
browsing-cfr-features =
    .label = Tilrå funksjonar medan du surfar
    .accesskey = T
browsing-cfr-recommendations-learn-more = Les meir

## General Section - Proxy

network-settings-title = Nettverksinnstillingar
network-proxy-connection-description = Konfigurer korleis { -brand-short-name } koplar seg til internett.
network-proxy-connection-learn-more = Les meir
network-proxy-connection-settings =
    .label = Innstillingar…
    .accesskey = I

## Home Section

home-new-windows-tabs-header = Nye vindauge og faner
home-new-windows-tabs-description2 = Vel kva du vil sjå når du opnar startsida, nye vindauge og nye faner.

## Home Section - Home Page Customization

home-homepage-mode-label = Startside og nye vindauge
home-newtabs-mode-label = Nye faner
home-restore-defaults =
    .label = Bruk standardinnstillingar
    .accesskey = r
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Waterfox startside (standard)
home-mode-choice-custom =
    .label = Tilpassa nettadresser…
home-mode-choice-blank =
    .label = Tom side
home-homepage-custom-url =
    .placeholder = Lim inn ein URL…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Bruk open nettside
           *[other] Bruk opne nettsider
        }
    .accesskey = B
choose-bookmark =
    .label = Bruk bokmerke…
    .accesskey = u

## Home Section - Waterfox Home Content Customization

home-prefs-content-header = Innhald på: Waterfox-startside
home-prefs-content-description = Vel kva for innhald du vil ha på Waterfox-startsida di.
home-prefs-search-header =
    .label = Nettsøk
home-prefs-topsites-header =
    .label = Mest besøkte
home-prefs-topsites-description = Sidene du besøkjer mest
home-prefs-topsites-by-option-sponsored =
    .label = Sponsa toppsider
home-prefs-shortcuts-header =
    .label = Snarvegar
home-prefs-shortcuts-description = Nettstadar du lagrar eller besøkjer
home-prefs-shortcuts-by-option-sponsored =
    .label = Sponsa snarvegar

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Tilrådd av { $provider }
home-prefs-recommended-by-description-update = Eineståande innhald frå heile nettet sett saman av { $provider }
home-prefs-recommended-by-description-new = Eksepsjonelt innhald sett saman av { $provider }, ein del av { -brand-product-name }-familien

##

home-prefs-recommended-by-learn-more = Korleis det fungerar
home-prefs-recommended-by-option-sponsored-stories =
    .label = Sponsa historiar
home-prefs-highlights-header =
    .label = Høgdepunkt
home-prefs-highlights-description = Eit utval av nettsider som du har lagra eller besøkt
home-prefs-highlights-option-visited-pages =
    .label = Besøkte sider
home-prefs-highlights-options-bookmarks =
    .label = Bokmerke
home-prefs-highlights-option-most-recent-download =
    .label = Siste nedlasting
home-prefs-highlights-option-saved-to-pocket =
    .label = Sider lagra til { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Nyleg aktivitet
home-prefs-recent-activity-description = Eit utval av nylige nettstadar og innhald
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Snuttar
home-prefs-snippets-description = Oppdateringar frå { -vendor-short-name } og { -brand-product-name }
home-prefs-snippets-description-new = Tips og nyheiter frå { -vendor-short-name } og { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } rekkje
           *[other] { $num } rekkjer
        }

## Search Section

search-bar-header = Søkjelinje
search-bar-hidden =
    .label = Bruk adresselinja for søk og navigering
search-bar-shown =
    .label = Legg til søkjelinje i verktøylinja
search-engine-default-header = Standard søkjemotor
search-engine-default-desc-2 = Dette er standardsøkjemotoren din i adresselinja og søkelinja. Du kan byte når som helst.
search-engine-default-private-desc-2 = Vel ein annan standardsøkjemotor berre for private vindauge
search-separate-default-engine =
    .label = Bruk denne søkjemotoren i private vindauge
    .accesskey = u
search-suggestions-header = Søkjeforslag
search-suggestions-desc = Vel korleis forslag frå søkjemotoren skal visast.
search-suggestions-option =
    .label = Tilby søkjeforslag
    .accesskey = T
search-show-suggestions-url-bar-option =
    .label = Vis søkjeforslag i adresselinja
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Vis søkjeforslag før nettlesarhistorikk i adressefeltresultata
search-show-suggestions-private-windows =
    .label = Vis søkjeforslag i private vindauge
suggestions-addressbar-settings-generic2 = Endre innstillingar for andre adresselinjeforslag
search-suggestions-cant-show = Søkjeforslag vil ikkje visast i adresselinjeresultata fordi du har konfigurert { -brand-short-name } til å aldri hugse historikk.
search-one-click-header2 = Søkesnarvegar
search-one-click-desc = Vel alternative søkjemotorar som vert viste under adresselinja og søkelinja når du byrjar å skrive inn eit søkjeord.
search-choose-engine-column =
    .label = Søkjemotor
search-choose-keyword-column =
    .label = Nøkkelord
search-restore-default =
    .label = Bygg oppatt standard søkjemotorar
    .accesskey = G
search-remove-engine =
    .label = Fjern
    .accesskey = F
search-add-engine =
    .label = Legg til
    .accesskey = L
search-find-more-link = Finn fleire søkjemotorar
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Kopiere stikkord
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Du har valt eit nøkkelord som allereie er i bruk av «{ $name }». Vel eit anna nøkkelord.
search-keyword-warning-bookmark = Du har valt eit nøkkelord som allereie vert brukt av eit bokmerke. Vel eit anna nøkkelord.

## Containers Section

containers-back-button2 =
    .aria-label = Tilbake til innstillingar
containers-header = Innhaldsfaner
containers-add-button =
    .label = Legg til ny behaldar
    .accesskey = L
containers-new-tab-check =
    .label = Vel ein behaldar for kvar ny fane
    .accesskey = V
containers-settings-button =
    .label = Innstillingar
containers-remove-button =
    .label = Fjern

## Waterfox Account - Signed out. Note that "Sync" and "Waterfox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Ta med deg nettet
sync-signedout-description2 = Synkroniser bokmerke, historikk, faner, passord, utvidingar og innstillingar på tvers av alle einingane dine.
sync-signedout-account-signin3 =
    .label = Logg in for å synkronisere…
    .accesskey = L
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Last ned Waterfox for <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> eller  <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> for å synkronisere med mobileininga di.

## Waterfox Account - Signed in

sync-profile-picture =
    .tooltiptext = Endre profilbilde
sync-sign-out =
    .label = Logg ut…
    .accesskey = g
sync-manage-account = Handter kontoen
    .accesskey = k
sync-signedin-unverified = { $email } er ikkje stadfesta.
sync-signedin-login-failure = Logg inn for å kople til på nytt { $email }
sync-resend-verification =
    .label = Send stadfesting på nytt
    .accesskey = S
sync-remove-account =
    .label = Fjern konto
    .accesskey = k
sync-sign-in =
    .label = Logg inn
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = Synkronisering: PÅ
prefs-syncing-off = Synkronisering: AV
prefs-sync-turn-on-syncing =
    .label = Slå på synkronisering…
    .accesskey = S
prefs-sync-offer-setup-label2 = Synkroniser bokmerke, historikk, faner, passord, utvidingar og innstillingar på tvers av alle einingane dine.
prefs-sync-now =
    .labelnotsyncing = Synkroniser no
    .accesskeynotsyncing = n
    .labelsyncing = Synkroniserer…

## The list of things currently syncing.

sync-currently-syncing-heading = Du synkroniserer for tida desse elementa:
sync-currently-syncing-bookmarks = Bokmerke
sync-currently-syncing-history = Historikk
sync-currently-syncing-tabs = Opne faner
sync-currently-syncing-logins-passwords = Innloggingar og passord
sync-currently-syncing-addresses = Adresser
sync-currently-syncing-creditcards = Kredittkort
sync-currently-syncing-addons = Tillegg
sync-currently-syncing-settings = Innstillingar
sync-change-options =
    .label = Endre…
    .accesskey = E

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Vel kva som skal synkroniserast
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Lagre endringar
    .buttonaccesskeyaccept = L
    .buttonlabelextra2 = Kople frå
    .buttonaccesskeyextra2 = K
sync-engine-bookmarks =
    .label = Bokmerke
    .accesskey = B
sync-engine-history =
    .label = Historikk
    .accesskey = H
sync-engine-tabs =
    .label = Opne faner
    .tooltiptext = Ei liste over kva som er ope på alle synkroniserte einingar
    .accesskey = f
sync-engine-logins-passwords =
    .label = Innloggingar og passord
    .tooltiptext = Brukarnamn og passord som du har lagra
    .accesskey = l
sync-engine-addresses =
    .label = Adresser
    .tooltiptext = Postadresser du har lagra (berre skrivebord)
    .accesskey = e
sync-engine-creditcards =
    .label = Kredittkort
    .tooltiptext = Namn, nummer og forfallsdato (berre skrivebord)
    .accesskey = K
sync-engine-addons =
    .label = Tillegg
    .tooltiptext = Tillegg og tema for Waterfox desktop
    .accesskey = T
sync-engine-settings =
    .label = Innstillingar
    .tooltiptext = Generelle, personvern- og sikkerheitsinnstillingar du har endra
    .accesskey = n

## The device name controls.

sync-device-name-header = Namn på eininga
sync-device-name-change =
    .label = Endre namn på eininga…
    .accesskey = E
sync-device-name-cancel =
    .label = Avbryt
    .accesskey = A
sync-device-name-save =
    .label = Lagre
    .accesskey = L
sync-connect-another-device = Kople til ei anna eining

## Privacy Section

privacy-header = Nettlesarpersonvern

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Innloggingar og passord
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Spør om å lagre innloggingar og passord for nettsider
    .accesskey = i
forms-exceptions =
    .label = Unntak…
    .accesskey = n
forms-generate-passwords =
    .label = Foreslå og generer sterke passord
    .accesskey = o
forms-breach-alerts =
    .label = Vis varsel om passord for datalekkasjar på nettstadar
    .accesskey = p
forms-breach-alerts-learn-more-link = Les meir
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Autoutfyll innloggingar og passord
    .accesskey = i
forms-saved-logins =
    .label = Lagre innloggingar…
    .accesskey = L
forms-primary-pw-use =
    .label = Bruk eit hovudpassord
    .accesskey = B
forms-primary-pw-learn-more-link = Les meir
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Endre hovudpassord…
    .accesskey = d
forms-primary-pw-change =
    .label = Endre hovudpassord…
    .accesskey = E
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = ""
forms-primary-pw-fips-title = Du er for tida i FIPS-modus. FIPS krev eit hovudpassord.
forms-master-pw-fips-desc = Mislykka passordendring
forms-windows-sso =
    .label = Tillat Windows enkel innlogging for Microsoft-, arbeids- og skulekontoar.
forms-windows-sso-learn-more-link = Les meir
forms-windows-sso-desc = Handter konton i einingsinnstillingane dine

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Skriv inn innloggingsinformasjonen din for Windows for å lage eit hovudpassord. Dette vil gjere kontoen din tryggare.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = lag eit hovudpassord
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Historikk
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = { -brand-short-name } vil
    .accesskey = v
history-remember-option-all =
    .label = Hugse historikk
history-remember-option-never =
    .label = Aldri hugse historikk
history-remember-option-custom =
    .label = Bruke eigne innstillingar for historikk
history-remember-description = { -brand-short-name } vil lagre informasjon om besøkte nettsider, skjema- og søkjehistorikk.
history-dontremember-description = { -brand-short-name } vil bruke dei same innstillingane som privat nettlesing og vil ikkje hugse historikk medan du brukar nettet.
history-private-browsing-permanent =
    .label = Alltid bruke privat nettlesing-modus
    .accesskey = A
history-remember-browser-option =
    .label = Hugs nettlesing- og nedlastingshistorikk
    .accesskey = H
history-remember-search-option =
    .label = Hugse søkje- og skjemahistorikk
    .accesskey = ø
history-clear-on-close-option =
    .label = Slette historikk når { -brand-short-name } avsluttar
    .accesskey = S
history-clear-on-close-settings =
    .label = Innstillingar…
    .accesskey = I
history-clear-button =
    .label = Tøm historikk…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Infokapslar og sidedata
sitedata-total-size-calculating = Reknar ut storleik på nettstad-data og snøgglager…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Dei lagra infokapslane dine, nettstaddata og hurtiglager brukar for tida { $value } { $unit } diskplass.
sitedata-learn-more = Les meir
sitedata-delete-on-close =
    .label = Slett infokapslar og nettstaddata når { -brand-short-name } stenger
    .accesskey = S
sitedata-delete-on-close-private-browsing = I permanent privat nettlesingsmodus vil infokapslar og nettstaddata alltid bli sletta når { -brand-short-name } er avslutta.
sitedata-allow-cookies-option =
    .label = Tillat infokapslar og nettsidedata
    .accesskey = a
sitedata-disallow-cookies-option =
    .label = Blokker infokapslar og nettsidedata
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Type blokkert
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Sporing på tvers av nettstadar
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Sporing på tvers av nettstadar og sosiale media-sporarar
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Sporingsinfokapslar på tvers av nettstadar — inkluderer informasjonskapslar for sosiale medium
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Infokapslar på tvers av nettstadar — inkluderer informasjonskapslar for sosiale medium
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Sporarar på tvers av nettstadar og sosiale medium, og isolering av attståande infokapslar
sitedata-option-block-unvisited =
    .label = Infokapslar frå ubesøkte nettsider
sitedata-option-block-all-third-party =
    .label = Alle tredjeparts infokapslar (kan føre til feil på nettsider)
sitedata-option-block-all =
    .label = Alle infokapslar (vil føre til feil på nettsider)
sitedata-clear =
    .label = Tøm data…
    .accesskey = T
sitedata-settings =
    .label = Handter data…
    .accesskey = H
sitedata-cookies-exceptions =
    .label = Handter unntak…
    .accesskey = H

## Privacy Section - Address Bar

addressbar-header = Adresselinje
addressbar-suggest = Når du brukar adresselinja, føreslå
addressbar-locbar-history-option =
    .label = Nettlesarhistorikk
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = Bokmerke
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Opne faner
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Snarvegar
    .accesskey = S
addressbar-locbar-topsites-option =
    .label = Mest besøkte nettstadar
    .accesskey = M
addressbar-locbar-engines-option =
    .label = Søkjemotorar
    .accesskey = k
addressbar-suggestions-settings = Endre innstillingar for søkjeforslag

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Utvida sporingsvern
content-blocking-section-top-level-description = Sporarar følgjer deg rundt på nettet for å samle informasjon om surfevanane og interessene dine. { -brand-short-name } blokkerer mange av desse sporarane og andre vondsinna skript.
content-blocking-learn-more = Les meir
content-blocking-fpi-incompatibility-warning = Du brukar First Party Isolation (FPI), som set til side nokre av infokapsel-innstillingane til { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = S
enhanced-tracking-protection-setting-strict =
    .label = Streng
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Tilpassa
    .accesskey = T

##

content-blocking-etp-standard-desc = Balansert for vern og yting. Sider vil laste normalt.
content-blocking-etp-strict-desc = Sterkare vern, men kan føre til at nokre nettstadar eller innhald ikkje vil fungere.
content-blocking-etp-custom-desc = Vel kva for sporarar og skript som skal blokkerast.
content-blocking-etp-blocking-desc = { -brand-short-name } blokkerer følgjande:
content-blocking-private-windows = Sporingsinnhald i private vindauge
content-blocking-cross-site-cookies-in-all-windows = Infokapslar på tvers av nettstadar i alle vindauge (inkluderer infokapslar for sporing)
content-blocking-cross-site-tracking-cookies = Sporingsinfokapslar på tvers av nettstadar
content-blocking-all-cross-site-cookies-private-windows = Infokapslar på tvers av nettstadar i private vindauge
content-blocking-cross-site-tracking-cookies-plus-isolate = Sporingsinfokapsler på tvers av nettstadar, isolering av attståande infokapslar
content-blocking-social-media-trackers = Sporing via sosiale medium
content-blocking-all-cookies = Alle infokapslar
content-blocking-unvisited-cookies = Infokapslar frå ikkje-besøkte nettsider
content-blocking-all-windows-tracking-content = Sporingsinnhald i alle vindauge
content-blocking-all-third-party-cookies = Alle tredjeparts infokapslar
content-blocking-cryptominers = Kryptoutvinnarar
content-blocking-fingerprinters = Fingerprinters
content-blocking-warning-title = Viktig!
content-blocking-and-isolating-etp-warning-description = Blokkering av sporarar og isolering av infokapslar kan påverke funksjonaliteten på nokre nettstadar. Last nettsida inn på nytt med sporarar for å laste alt innhald.
content-blocking-and-isolating-etp-warning-description-2 = Denne innstillinga kan føre til at enkelte nettstadar ikkje viser innhald eller fungerer rett. Dersom ein nettstad verkar øydelagd, kan det vere lurt å slå av sporingsvernet for nettsaden for å få laste inn alt innhaldet.
content-blocking-warning-learn-how = Les korleis
content-blocking-reload-description = Du må oppdatere fanene dine for å kunne bruke desse endringane.
content-blocking-reload-tabs-button =
    .label = Oppdater alle faner
    .accesskey = O
content-blocking-tracking-content-label =
    .label = Sporingsinnhald
    .accesskey = S
content-blocking-tracking-protection-option-all-windows =
    .label = I alle vindauge
    .accesskey = I
content-blocking-option-private =
    .label = Berre i private vindauge
    .accesskey = B
content-blocking-tracking-protection-change-block-list = Endre blokkeringsliste
content-blocking-cookies-label =
    .label = Infokapslar
    .accesskey = k
content-blocking-expand-section =
    .tooltiptext = Meir informasjon
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Kryptoutvinnarar
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Nettlesaravtrykk
    .accesskey = N

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Handter unntak…
    .accesskey = H

## Privacy Section - Permissions

permissions-header = Løyve
permissions-location = Plassering
permissions-location-settings =
    .label = Innstillingar…
    .accesskey = t
permissions-xr = Virtuell røyndom
permissions-xr-settings =
    .label = Innstillingear…
    .accesskey = s
permissions-camera = Kamera
permissions-camera-settings =
    .label = Innstillingar…
    .accesskey = t
permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Innstillingar…
    .accesskey = t
permissions-notification = Varsel
permissions-notification-settings =
    .label = Innstillingar…
    .accesskey = t
permissions-notification-link = Les meir
permissions-notification-pause =
    .label = Set varsel på pause til { -brand-short-name } startar på nytt
    .accesskey = n
permissions-autoplay = Automatisk avspeling
permissions-autoplay-settings =
    .label = Innstillingar
    .accesskey = n
permissions-block-popups =
    .label = Blokker sprettoppvindauge
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Unntak…
    .accesskey = U
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Unntak…
    .accesskey = U
    .searchkeywords = sprettoppvindauge
permissions-addon-install-warning =
    .label = Åtvar meg når netsider vil installere tillegg
    .accesskey = Å
permissions-addon-exceptions =
    .label = Unntak…
    .accesskey = U

## Privacy Section - Data Collection

collection-header = Datainnsamling og bruk for { -brand-short-name }
collection-description = Vi prøver alltid å gje deg val og samlar inn berre det vi treng for å levere og forbetre { -brand-short-name } for alle. Vi ber alltid om løyve før vi får personopplysningar.
collection-privacy-notice = Personvernpraksis
collection-health-report-telemetry-disabled = Du tillèt ikkje lenger { -vendor-short-name } å samle inn teknisk- og interaksjonsdata. Alle tidlegare data vil bli sletta innan 30 dagar.
collection-health-report-telemetry-disabled-link = Les meir
collection-health-report =
    .label = Tillat { -brand-short-name } å sende tekniske data og data for bruk til { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Les meir
collection-studies =
    .label = Tillat { -brand-short-name } å installere og køyre studium
collection-studies-link = Vis { -brand-short-name }-studium
addon-recommendations =
    .label = Tillat { -brand-short-name } å kome med tilpassa utvidingstilrådingar
addon-recommendations-link = Les meir
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datarapportering er deaktivert for denne byggekonfigurasjonen
collection-backlogged-crash-reports-with-link = Tillat { -brand-short-name } å sende etterslepne krasjrapportar på dine vegne <a data-l10n-name="crash-reports-link">Les meir</a>
    .accesskey = T

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Sikkerheit
security-browsing-protection = Vern mot villeiande innhald og skadeleg programvare
security-enable-safe-browsing =
    .label = Blokker farleg og villeiande innhald
    .accesskey = B
security-enable-safe-browsing-link = Les meir
security-block-downloads =
    .label = Blokker farlege nedlastingar
    .accesskey = f
security-block-uncommon-software =
    .label = Åtvar meg mot uønskte eller uvanlege program
    .accesskey = t

## Privacy Section - Certificates

certs-header = Sertifikat
certs-enable-ocsp =
    .label = Spør OCSP-tenarar om å stadfeste gyldigheita til sertifikat
    .accesskey = O
certs-view =
    .label = Vis sertifikat…
    .accesskey = s
certs-devices =
    .label = Tryggingseiningar…
    .accesskey = T
space-alert-over-5gb-settings-button =
    .label = Opne Innstillingar
    .accesskey = p
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } er i ferd med å gå tom for plass på disken.</strong> Det kan hende at innhaldet på nettstaden ikkje vert vist skikkeleg. Du kan tøme lagra data i Innstillingar > Personvern og sikkerheit > Infokapslar og nettstaddata.
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } er i ferd med å gå tom for plass på disken.</strong> Det kan hende at innhaldet på nettsida ikkje vert vist skikkeleg. Gå til «Les meir» for å optimalisere diskbruken din for ei betre nettoppleving.

## Privacy Section - HTTPS-Only

httpsonly-header = Berre HTTPS-modus
httpsonly-description = HTTPS gir eit trygt, kryptert samband mellom { -brand-short-name } og nettstadane du besøkjer. Dei fleste nettstadar støttar HTTPS, og dersom berre HTTPS-modus er slått på, vil { -brand-short-name } oppgradere alle tilkoplingar til HTTPS.
httpsonly-learn-more = Les meir
httpsonly-radio-enabled =
    .label = Slå på berre HTTPS-modus i alle vindauge
httpsonly-radio-enabled-pbm =
    .label = Slå på berre HTTPS-modus kun i private vindauge
httpsonly-radio-disabled =
    .label = Ikkje slå på berre HTTPS-modus

## The following strings are used in the Download section of settings

desktop-folder-name = Skrivebord
downloads-folder-name = Nedlastingar
choose-download-folder-title = Vel nedlastingsmappe:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Lagre filer til { $service-name }
