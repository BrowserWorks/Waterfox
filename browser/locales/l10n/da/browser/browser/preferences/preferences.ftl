# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Send websteder signalet 'Spor mig ikke' ('Do not track') for at fortælle, at du ikke vil spores
do-not-track-learn-more = Læs mere
do-not-track-option-default-content-blocking-known =
    .label = Kun når { -brand-short-name } er indstillet til at blokere kendte sporings-teknologier
do-not-track-option-always =
    .label = Altid
settings-page-title = Indstillinger
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
    .placeholder = Find i indstillinger
managed-notice = Din browser bliver forvaltet af din organisation.
category-list =
    .aria-label = Kategorier
pane-general-title = Generelt
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Hjem
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Søgning
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Privatliv & sikkerhed
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title3 = Synkronisering
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = { -brand-short-name }-eksperimenter
category-experimental =
    .tooltiptext = { -brand-short-name }-eksperimenter
pane-experimental-subtitle = Fortsæt på eget ansvar
pane-experimental-search-results-header = { -brand-short-name }-eksperimenter: Fortsæt på eget ansvar
pane-experimental-description2 = Ændring af avancerede indstillinger for opsætning kan påvirke ydelse eller sikkerhed for { -brand-short-name }.
pane-experimental-reset =
    .label = Gendan standarder
    .accesskey = G
help-button-label = Hjælp til { -brand-short-name }
addons-button-label = Udvidelser og temaer
focus-search =
    .key = f
close-button =
    .aria-label = Luk

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } skal genstarte for at aktivere denne funktionalitet. Vil du genstarte nu?
feature-disable-requires-restart = { -brand-short-name } skal genstarte for at deaktivere denne funktionalitet. Vil du genstarte nu?
should-restart-title = Genstart { -brand-short-name }
should-restart-ok = Genstart { -brand-short-name } nu
cancel-no-restart-button = Annuller
restart-later = Genstart senere

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
extension-controlled-password-saving = En udvidelse, <img data-l10n-name="icon"/>{ $name }, kontrollerer denne indstilling.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Udvidelsen <img data-l10n-name="icon"/> { $name } kontrollerer denne indstilling.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Udvidelsen <img data-l10n-name="icon"/> { $name } kræver, at kontekst-faneblade er slået til.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Udvidelsen <img data-l10n-name="icon"/> { $name } kontrollerer denne indstilling.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Udvidelsen <img data-l10n-name="icon"/> { $name } kontrollerer, hvordan { -brand-short-name } opretter forbindelse til internettet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Klik på Tilføjelser <img data-l10n-name="addons-icon"/> i menuen <img data-l10n-name="menu-icon"/> for at aktivere udvidelsen.

## Preferences UI Search Results

search-results-header = Søgeresultater
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Beklager, der er ingen resultater for "<span data-l10n-name="query"></span>" i indstillingerne.
search-results-help-link = Har du brug for hjælp? Besøg <a data-l10n-name="url">Hjælp til { -brand-short-name }</a>

## General Section

startup-header = Opstart
always-check-default =
    .label = Undersøg altid om { -brand-short-name } er min standardbrowser
    .accesskey = U
is-default = { -brand-short-name } er sat som din standardbrowser
is-not-default = { -brand-short-name } er ikke din standardbrowser
set-as-my-default-browser =
    .label = Sæt som standard…
    .accesskey = D
startup-restore-previous-session =
    .label = Gendan forrige session
    .accesskey = G
startup-restore-windows-and-tabs =
    .label = Åbn tidligere vinduer og faneblade
    .accesskey = t
startup-restore-warn-on-quit =
    .label = Advar mig, når jeg lukker browseren
disable-extension =
    .label = Deaktiver udvidelse
tabs-group-header = Faneblade
ctrl-tab-recently-used-order =
    .label = Ctrl+Tabulator-tasten skifter mellem de senest anvendte faneblade
    .accesskey = T
open-new-link-as-tabs =
    .label = Åbn links i faneblade fremfor i nye vinduer
    .accesskey = f
warn-on-close-multiple-tabs =
    .label = Advar mig, når jeg lukker flere faneblade
    .accesskey = l
confirm-on-close-multiple-tabs =
    .label = Bekræft, når jeg lukker flere faneblade
    .accesskey = B
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (String) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Bekræft, inden jeg afslutter med { $quitKey }
    .accesskey = a
warn-on-open-many-tabs =
    .label = Advar mig, hvis jeg åbner flere faneblade, som kan gøre { -brand-short-name } langsommere
    .accesskey = å
switch-to-new-tabs =
    .label = Skift fokus til det nye faneblad, når jeg åbner et link, billede eller medie i det
    .accesskey = S
show-tabs-in-taskbar =
    .label = Vis forhåndsvisning for faneblade på Windows Proceslinje
    .accesskey = W
browser-containers-enabled =
    .label = Aktiver kontekst-faneblade
    .accesskey = A
browser-containers-learn-more = Læs mere
browser-containers-settings =
    .label = Indstillinger…
    .accesskey = n
containers-disable-alert-title = Luk alle kontekst-faneblade?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Hvis du deaktiverer kontekst-faneblade vil { $tabCount } kontekst-faneblad blive lukket. Er du sikker på, at du vil deaktivere kontekst-faneblade?
       *[other] Hvis du deaktiverer kontekst-faneblade vil { $tabCount } kontekst-faneblade blive lukket. Er du sikker på, at du vil deaktivere kontekst-faneblade?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Luk { $tabCount } kontekst-faneblad
       *[other] Luk { $tabCount } kontekst-faneblade
    }
containers-disable-alert-cancel-button = Deaktiver ikke
containers-remove-alert-title = Fjern denne kontekst?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] { $count } kontekst-faneblad vil blive lukket, hvis du sletter denne kontekst. Er du sikker på, at du vil fjerne denne kontekst?
       *[other] { $count } kontekst-faneblade vil blive lukket, hvis du sletter denne kontekst. Er du sikker på, at du vil fjerne denne kontekst?
    }
containers-remove-ok-button = Fjern denne kontekst
containers-remove-cancel-button = Fjern ikke denne kontekst

## General Section - Language & Appearance

language-and-appearance-header = Sprog og udseende
fonts-and-colors-header = Skrifttyper & farver
default-font = Standardskrifttype:
    .accesskey = k
default-font-size = Størrelse:
    .accesskey = t
advanced-fonts =
    .label = Avanceret…
    .accesskey = v
colors-settings =
    .label = Farver…
    .accesskey = F
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Standard-zoom
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Zoom kun tekst
    .accesskey = t
language-header = Sprog
choose-language-description = Vælg dit foretrukne sprog at få vist sider i
choose-button =
    .label = Vælg…
    .accesskey = æ
choose-browser-language-description = Vælg det sprog, der skal bruges i brugerfladen i { -brand-short-name }
manage-browser-languages-button =
    .label = Vælg alternativer…
    .accesskey = l
confirm-browser-language-change-description = Genstart { -brand-short-name } for at anvende ændringerne
confirm-browser-language-change-button = Genstart
translate-web-pages =
    .label = Oversæt webindhold
    .accesskey = O
fx-translate-web-pages = { -translations-brand-name }
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Oversættelser af <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Undtagelser…
    .accesskey = n
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Brug dit operativsystems indstillinger for "{ $localeName }" til at formatere datoer, klokkeslæt, tal og måleenheder.
check-user-spelling =
    .label = Kontroller min stavning mens jeg taster
    .accesskey = K

## General Section - Files and Applications

files-and-applications-title = Filer og programmer
download-header = Filhentning
download-save-to =
    .label = Gem filer i:
    .accesskey = m
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Vælg…
           *[other] Gennemse…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] æ
           *[other] e
        }
download-always-ask-where =
    .label = Spørg mig altid, hvor filer skal gemmes
    .accesskey = a
applications-header = Programmer
applications-description = Vælg, hvordan { -brand-short-name } håndterer hentede filer og eksterne programmer.
applications-filter =
    .placeholder = Søg efter filtyper eller programmer
applications-type-column =
    .label = Indholdstype
    .accesskey = I
applications-action-column =
    .label = Handling
    .accesskey = H
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } fil
applications-action-save =
    .label = Gem filen
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Brug { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Brug { $app-name } (standard)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Brug standard-applikationen i macOS
            [windows] Brug standard-applikationen i  Windows
           *[other] Brug systemets standard-applikation
        }
applications-use-other =
    .label = Vælg en anden…
applications-select-helper = Vælg hjælpeprogram
applications-manage-app =
    .label = Programdetaljer…
applications-always-ask =
    .label = Spørg altid
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
    .label = Brug { $plugin-name } (i { -brand-short-name })
applications-open-inapp =
    .label = Åbn i { -brand-short-name }

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

drm-content-header = Indhold beskyttet af digital rettigheds-styring (DRM)
play-drm-content =
    .label = Afspil DRM-kontrolleret indhold
    .accesskey = A
play-drm-content-learn-more = Læs mere
update-application-title = { -brand-short-name }-opdateringer
update-application-description = Hold { -brand-short-name } opdateret for at få den bedste ydelse, stabilitet og sikkerhed.
update-application-version = Version { $version }. <a data-l10n-name="learn-more">Nyheder</a>
update-history =
    .label = Vis opdateringshistorik…
    .accesskey = V
update-application-allow-description = { -brand-short-name } skal
update-application-auto =
    .label = installere opdateringer automatisk (anbefalet)
    .accesskey = A
update-application-check-choose =
    .label = søge efter opdateringer, men lad mig vælge, om de skal installeres
    .accesskey = S
update-application-manual =
    .label = aldrig søge efter opdateringer (frarådes)
    .accesskey = N
update-application-background-enabled =
    .label = Når { -brand-short-name } ikke kører
    .accesskey = N
update-application-warning-cross-user-setting = Denne indstilling vil gælde alle Windows-konti og { -brand-short-name }-profiler, der anvender denne { -brand-short-name }-installation.
update-application-use-service =
    .label = bruge en baggrundsservice til at installere opdateringer
    .accesskey = b
update-setting-write-failure-title2 = Fejl under lagring af indstillinger for opdatering
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } stødte på en fejl og gemte ikke denne ændring. Bemærk at det kræver tilladelse til at skrive til filen nedenfor, hvis du vil ændre indstillinger for opdatering. Du eller en systemadministrator kan måske løse problemet ved at give gruppen Users fuld kontrol over denne fil.
    
    Kunne ikke skrive til filen: { $path }
update-in-progress-title = Opdatering…
update-in-progress-message = Skal { -brand-short-name } fortsætte med denne opdatering?
update-in-progress-ok-button = &Annuller
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortsæt

## General Section - Performance

performance-title = Ydelse
performance-use-recommended-settings-checkbox =
    .label = Brug de anbefalede indstillinger for ydelse
    .accesskey = a
performance-use-recommended-settings-desc = Disse indstillinger er skræddersyede til din computers hardware og operativsystem
performance-settings-learn-more = Læs mere
performance-allow-hw-accel =
    .label = Brug hardware-acceleration hvor muligt
    .accesskey = g
performance-limit-content-process-option = Begrænsning af indholds-processer
    .accesskey = i
performance-limit-content-process-enabled-desc = Når du har mange faneblade åbne samtidig, kan brugen af flere indholdsprocesser forbedre ydelsen, men de vil til gengæld bruge mere hukommelse.
performance-limit-content-process-blocked-desc = Det er kun muligt at ændre antallet af indholdsprocesser, når du bruger { -brand-short-name } med multiproces slået til. <a data-l10n-name="learn-more">Læs, hvordan du undersøger, om multiproces er slået til</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (standard)

## General Section - Browsing

browsing-title = Browsing
browsing-use-autoscroll =
    .label = Anvend autoscrolling
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Anvend blød scrolling
    .accesskey = b
browsing-use-onscreen-keyboard =
    .label = Vis et berørings-tastatur, når det er nødvendigt
    .accesskey = t
browsing-use-cursor-navigation =
    .label = Brug altid markør og tastatur til at navigere på sider
    .accesskey = m
browsing-search-on-start-typing =
    .label = Begynd søgning mens jeg taster
    .accesskey = s
browsing-picture-in-picture-toggle-enabled =
    .label = Vis kontrol-knapper for billed-i-billed
    .accesskey = v
browsing-picture-in-picture-learn-more = Læs mere
browsing-media-control =
    .label = Kontrollér medeindhold med tastatur, headset eller virtuel interface
    .accesskey = v
browsing-media-control-learn-more = Læs mere
browsing-cfr-recommendations =
    .label = Anbefal udvidelser mens jeg browser
    .accesskey = u
browsing-cfr-features =
    .label = Anbefal funktioner mens jeg browser
    .accesskey = f
browsing-cfr-recommendations-learn-more = Læs mere

## General Section - Proxy

network-settings-title = Forbindelsesindstillinger
network-proxy-connection-description = Indstil hvordan { -brand-short-name } skal oprette forbindelse til internettet.
network-proxy-connection-learn-more = Læs mere
network-proxy-connection-settings =
    .label = Indstillinger…
    .accesskey = I

## Home Section

home-new-windows-tabs-header = Nye vinduer og faneblade
home-new-windows-tabs-description2 = Vælg hvad du vil se, når du åbner din startside, nye vinduer og nye faneblade

## Home Section - Home Page Customization

home-homepage-mode-label = Startside og nye vinduer
home-newtabs-mode-label = Nye faneblade
home-restore-defaults =
    .label = Gendan standarder
    .accesskey = G
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Waterfox-startside (standard)
home-mode-choice-custom =
    .label = Tilpassede URL'er…
home-mode-choice-blank =
    .label = Tom side
home-homepage-custom-url =
    .placeholder = Indsæt en URL…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Anvend nuværende side
           *[other] Anvend nuværende sider
        }
    .accesskey = n
choose-bookmark =
    .label = Anvend bogmærke…
    .accesskey = b

## Home Section - Waterfox Home Content Customization

home-prefs-content-header = Indhold på Waterfox' startside
home-prefs-content-description = Vælg det indhold, du vil have vist på din startside i Waterfox.
home-prefs-search-header =
    .label = Søgning på internettet
home-prefs-topsites-header =
    .label = Mest besøgte websider
home-prefs-topsites-description = Mest besøgte websider
home-prefs-topsites-by-option-sponsored =
    .label = Sponsorerede websteder
home-prefs-shortcuts-header =
    .label = Genveje
home-prefs-shortcuts-description = Gemte eller besøgte websteder
home-prefs-shortcuts-by-option-sponsored =
    .label = Sponsorerede genveje

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Anbefalet af { $provider }
home-prefs-recommended-by-description-update = Spændende indhold fra nettet, udvalgt af { $provider }
home-prefs-recommended-by-description-new = Interessant indhold udvalgt af { $provider }, en del af { -brand-product-name }-familien

##

home-prefs-recommended-by-learn-more = Sådan virker det
home-prefs-recommended-by-option-sponsored-stories =
    .label = Sponsorerede historier
home-prefs-highlights-header =
    .label = Fremhævede
home-prefs-highlights-description = Et afsnit med sider, du har gemt eller besøgt
home-prefs-highlights-option-visited-pages =
    .label = Besøgte sider
home-prefs-highlights-options-bookmarks =
    .label = Bogmærker
home-prefs-highlights-option-most-recent-download =
    .label = Seneste filhentninger
home-prefs-highlights-option-saved-to-pocket =
    .label = Sider gemt til { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Seneste aktivitet
home-prefs-recent-activity-description = Et udvalg af seneste websteder og indhold
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Notitser
home-prefs-snippets-description = Nyheder fra { -vendor-short-name } og { -brand-product-name }
home-prefs-snippets-description-new = Tips og nyheder fra { -vendor-short-name } og { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } række
           *[other] { $num } rækker
        }

## Search Section

search-bar-header = Søgefelt
search-bar-hidden =
    .label = Brug adressefeltet til søgning og navigation
search-bar-shown =
    .label = Tilføj søgefeltet til værktøjslinjen
search-engine-default-header = Standard-søgetjeneste
search-engine-default-desc-2 = Dette er din standard-søgetjeneste i adressefeltet og søgefeltet. Du kan altid skifte den ud med en anden.
search-engine-default-private-desc-2 = Vælg en anden søgetjeneste til brug i private vinduer.
search-separate-default-engine =
    .label = Brug denne søgetjeneste i private vinduer.
    .accesskey = B
search-suggestions-header = Søgeforslag
search-suggestions-desc = Vælg hvordan søgeforslag fra søgetjenester skal vises.
search-suggestions-option =
    .label = Vis søgeforslag
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = Vis søgeforslag i adressefeltet
    .accesskey = a
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Vis søgeforslag før resultater fra min browserhistorik i adressefeltet
search-show-suggestions-private-windows =
    .label = Vis søgeforslag i private vinduer
suggestions-addressbar-settings-generic2 = Skift indstillinger for andre forslag i adressefeltet
search-suggestions-cant-show = Søgeforslag vil ikke blive vist i adressefeltet, fordi du har sat { -brand-short-name } op til aldrig at gemme historik.
search-one-click-header2 = Søge-genveje
search-one-click-desc = Vælg de alternative søgetjenester, der vises under adressefeltet og søgefeltet, når du begynder at indtaste en søgeterm.
search-choose-engine-column =
    .label = Søgetjeneste
search-choose-keyword-column =
    .label = Genvej
search-restore-default =
    .label = Gendan standard-søgetjenester
    .accesskey = g
search-remove-engine =
    .label = Fjern
    .accesskey = f
search-add-engine =
    .label = Tilføj
    .accesskey = T
search-find-more-link = Find flere søgetjenester
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Genvej findes allerede
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Du har valgt en genvej som allerede bruges af "{ $name }". Vælg venligst en anden.
search-keyword-warning-bookmark = Du har valgt en genvej som bruges af et bogmærke. Vælg venligst en anden.

## Containers Section

containers-back-button2 =
    .aria-label = Tilbage til indstillinger
containers-header = Kontekst-faneblade
containers-add-button =
    .label = Tilføj ny kontekst
    .accesskey = T
containers-new-tab-check =
    .label = Vælg en kontekst for hvert nyt faneblad
    .accesskey = V
containers-settings-button =
    .label = Indstillinger
containers-remove-button =
    .label = Fjern

## Waterfox Account - Signed out. Note that "Sync" and "Waterfox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Tag dit net med dig
sync-signedout-description2 = Synkroniser din historik, dine bogmærker, faneblade, adgangskoder, tilføjelser og indstillinger på tværs af dine enheder.
sync-signedout-account-signin3 =
    .label = Log ind for at synkronisere…
    .accesskey = L
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Hent Waterfox til <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> eller <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> for at synkronisere med din mobil-enhed

## Waterfox Account - Signed in

sync-profile-picture =
    .tooltiptext = Skift profilbillede
sync-sign-out =
    .label = Log ud…
    .accesskey = u
sync-manage-account = Håndter konto
    .accesskey = H
sync-signedin-unverified = { $email } er ikke blevet bekræftet.
sync-signedin-login-failure = Log ind for at synkronisere { $email }
sync-resend-verification =
    .label = Send verifikation igen
    .accesskey = d
sync-remove-account =
    .label = Fjern konto
    .accesskey = F
sync-sign-in =
    .label = Log ind
    .accesskey = L

## Sync section - enabling or disabling sync.

prefs-syncing-on = Synkronisering: TIL
prefs-syncing-off = Synkronisering: FRA
prefs-sync-turn-on-syncing =
    .label = Slå synkronisering til…
    .accesskey = S
prefs-sync-offer-setup-label2 = Synkroniser din historik, dine bogmærker, faneblade, adgangskoder, tilføjelser og indstillinger på tværs af dine enheder.
prefs-sync-now =
    .labelnotsyncing = Synkroniser nu
    .accesskeynotsyncing = n
    .labelsyncing = Synkroniserer…

## The list of things currently syncing.

sync-currently-syncing-heading = Du synkroniserer i øjeblikket:
sync-currently-syncing-bookmarks = Bogmærker
sync-currently-syncing-history = Historik
sync-currently-syncing-tabs = Åbne faneblade
sync-currently-syncing-logins-passwords = Logins og adgangskoder
sync-currently-syncing-addresses = Adresser
sync-currently-syncing-creditcards = Betalingskort
sync-currently-syncing-addons = Tilføjelser
sync-currently-syncing-settings = Indstillinger
sync-change-options =
    .label = Skift…
    .accesskey = S

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Vælg hvad der skal synkroniseres
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Gem ændringer
    .buttonaccesskeyaccept = G
    .buttonlabelextra2 = Afbryd…
    .buttonaccesskeyextra2 = A
sync-engine-bookmarks =
    .label = Bogmærker
    .accesskey = B
sync-engine-history =
    .label = Historik
    .accesskey = H
sync-engine-tabs =
    .label = Åbne faneblade
    .tooltiptext = En liste over åbne faneblade på alle synkroniserede enheder
    .accesskey = f
sync-engine-logins-passwords =
    .label = Logins og adgangskoder
    .tooltiptext = Gemte brugernavne og adgangskoder
    .accesskey = L
sync-engine-addresses =
    .label = Adresser
    .tooltiptext = Gemte postadresser (kun til computer)
    .accesskey = A
sync-engine-creditcards =
    .label = Betalingskort
    .tooltiptext = Navne, numre og udløbsdatoer (kun til computer)
    .accesskey = e
sync-engine-addons =
    .label = Tilføjelser
    .tooltiptext = Tilføjelser og temaer til Waterfox til computer
    .accesskey = T
sync-engine-settings =
    .label = Indstillinger
    .tooltiptext = Generelle indstillinger, samt indstillinger for privatliv og sikkerhed, som du har ændret
    .accesskey = I

## The device name controls.

sync-device-name-header = Enhedens navn
sync-device-name-change =
    .label = Skift navn for enheden…
    .accesskey = k
sync-device-name-cancel =
    .label = Annuller
    .accesskey = n
sync-device-name-save =
    .label = Gem
    .accesskey = G
sync-connect-another-device = Opret forbindelse til en ny enhed

## Privacy Section

privacy-header = Beskyttelse af privatliv

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Logins og adgangskoder
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Spørg om at gemme logins og adgangskoder til websteder
    .accesskey = l
forms-exceptions =
    .label = Undtagelser…
    .accesskey = U
forms-generate-passwords =
    .label = Hjælp med at lave stærke adgangskoder
    .accesskey = s
forms-breach-alerts =
    .label = Vis advarsler om adgangskoder for hackede websteder
    .accesskey = a
forms-breach-alerts-learn-more-link = Læs mere
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Autofyld logins og adgangskoder
    .accesskey = i
forms-saved-logins =
    .label = Gemte logins…
    .accesskey = G
forms-primary-pw-use =
    .label = Benyt en hovedadgangskode
    .accesskey = B
forms-primary-pw-learn-more-link = Læs mere
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Skift hovedadgangskode…
    .accesskey = h
forms-primary-pw-change =
    .label = Skift hovedadgangskode…
    .accesskey = h
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Du er i øjeblikket i FIPS-tilstand. FIPS kræver, at du bruger en hovedadgangskode.
forms-master-pw-fips-desc = Ændring af adgangskode mislykkedes
forms-windows-sso =
    .label = Tillad Windows enkeltlogon for Microsoft-, arbejds- og skole-konti
forms-windows-sso-learn-more-link = Læs mere
forms-windows-sso-desc = Håndter konti i dine enhedsindstillinger

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = For at oprette en hovedadgangskode skal du indtaste dine login-oplysninger til Windows. Dette hjælper dig med at holde dine konti sikre.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = oprette en hovedadgangskode
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Historik
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = { -brand-short-name } vil:
    .accesskey = i
history-remember-option-all =
    .label = Gemme historik
history-remember-option-never =
    .label = Aldrig gemme historik
history-remember-option-custom =
    .label = Bruge tilpassede indstillinger for historik
history-remember-description = { -brand-short-name } vil huske din historik, dine filhentninger samt søgninger og data, du har indtastet i formularer.
history-dontremember-description = { -brand-short-name } vil bruge de samme indstillinger som privat browsing, og vil ikke gemme nogen historik, mens du surfer på nettet.
history-private-browsing-permanent =
    .label = Brug altid privat browsing-tilstand
    .accesskey = P
history-remember-browser-option =
    .label = Husk min browser- og filhentningshistorik
    .accesskey = b
history-remember-search-option =
    .label = Husk formular- og søgehistorik
    .accesskey = f
history-clear-on-close-option =
    .label = Ryd historik når { -brand-short-name } lukkes
    .accesskey = R
history-clear-on-close-settings =
    .label = Indstillinger…
    .accesskey = I
history-clear-button =
    .label = Ryd historik…
    .accesskey = h

## Privacy Section - Site Data

sitedata-header = Cookies og websteds-data
sitedata-total-size-calculating = Udregner størrelse på cache og websteds-data…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Dine gemte cookies, websteds-data og cache bruger lige nu { $value } { $unit } diskplads.
sitedata-learn-more = Læs mere
sitedata-delete-on-close =
    .label = Slet cookies og websteds-data, når { -brand-short-name } lukkes
    .accesskey = l
sitedata-delete-on-close-private-browsing = I permanent privat browsing-tilstand bliver cookies og webstedsdata altid slettet, når { -brand-short-name } afsluttes.
sitedata-allow-cookies-option =
    .label = Accepter cookies og websteds-data
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Bloker cookies og websteds-data
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Type blokeret
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Sporings-teknologier på tværs af websteder
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Sporings-teknologier på tværs af websteder og sociale medier
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Sporings-cokies på tværs af websteder — herunder cookies fra sociale medier
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Cookies på tværs af websteder — herunder cookies fra sociale medier
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Sporings-teknologier på tværs af websteder og sociale medier, isolering af resterende cookies.
sitedata-option-block-unvisited =
    .label = Cookies fra ikke-besøgte websteder
sitedata-option-block-all-third-party =
    .label = Alle tredjeparts-cookies (kan forhindre websteder i at fungere)
sitedata-option-block-all =
    .label = Alle cookies (vil forhindre websteder i at fungere)
sitedata-clear =
    .label = Ryd data…
    .accesskey = R
sitedata-settings =
    .label = Håndter data…
    .accesskey = H
sitedata-cookies-exceptions =
    .label = Håndter undtagelser…
    .accesskey = u

## Privacy Section - Address Bar

addressbar-header = Adressefelt
addressbar-suggest = Når jeg bruger adressefeltet ønsker jeg forslag fra
addressbar-locbar-history-option =
    .label = Historik
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Bogmærker
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Åbne faneblade
    .accesskey = f
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Genveje
    .accesskey = G
addressbar-locbar-topsites-option =
    .label = Mest besøgte websider
    .accesskey = M
addressbar-locbar-engines-option =
    .label = Søgetjenester
    .accesskey = S
addressbar-suggestions-settings = Skift indstillinger for søgeforslag

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Udvidet beskyttelse mod sporing
content-blocking-section-top-level-description = Sporings-teknologier følger dig rundt på nettet for at indsamle information om dine vaner og interesser. { -brand-short-name } blokerer mange af disse sporings-teknologier og andre ondsindede scripts.
content-blocking-learn-more = Læs mere
content-blocking-fpi-incompatibility-warning = Du bruger First Party Isolation (FPI), som tilsidesætter nogle af indstillingerne for cookies i { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Striks
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Tilpasset
    .accesskey = T

##

content-blocking-etp-standard-desc = Balanceret mellem beskyttelse og ydelse. Sider indlæses som normalt.
content-blocking-etp-strict-desc = Bedre beskyttelse, men kan forhindre nogle websteder i at fungere.
content-blocking-etp-custom-desc = Vælg selv, hvilke sporings-teknologier og scripts der skal blokeres.
content-blocking-etp-blocking-desc = { -brand-short-name } blokerer følgende:
content-blocking-private-windows = Sporings-indhold i private vinduer.
content-blocking-cross-site-cookies-in-all-windows = Cookies på tværs af websteder i alle vinduer (herunder sporingscookies)
content-blocking-cross-site-tracking-cookies = Sporings-cookies på tværs af websteder
content-blocking-all-cross-site-cookies-private-windows = Cookies på tværs af websteder i private vinduer
content-blocking-cross-site-tracking-cookies-plus-isolate = Sporings-cookies på tværs af websteder, isolering af resterende cookies.
content-blocking-social-media-trackers = Sporing via sociale medier
content-blocking-all-cookies = Alle cookies
content-blocking-unvisited-cookies = Cookies fra ikke-besøgte websteder
content-blocking-all-windows-tracking-content = Sporings-indhold i alle vinduer
content-blocking-all-third-party-cookies = Alle tredjeparts-cookies
content-blocking-cryptominers = Cryptominers
content-blocking-fingerprinters = Fingerprinters
content-blocking-warning-title = Vigtigt!
content-blocking-and-isolating-etp-warning-description = Nogle websteders funktionalitet kan blive påvirket, når du blokerer sporings-teknologier og isolerer cookies. Genindlæs side med sporings-teknologier for at indlæse alt indhold.
content-blocking-and-isolating-etp-warning-description-2 = Denne indstilling kan medføre, at nogle websteder ikke viser indhold eller ikke fungerer som de skal. Hvis et websted ikke ser ud til at fungere korrekt, så prøv at slå beskyttelse mod sporing fra for webstedet for at indlæse alt indhold.
content-blocking-warning-learn-how = Læs hvordan
content-blocking-reload-description = Du skal genindlæse dine faneblade, før ændringerne slår igennem.
content-blocking-reload-tabs-button =
    .label = Genindlæs alle faneblade
    .accesskey = G
content-blocking-tracking-content-label =
    .label = Sporings-indhold
    .accesskey = i
content-blocking-tracking-protection-option-all-windows =
    .label = I alle vinduer
    .accesskey = a
content-blocking-option-private =
    .label = Kun i private vinduer
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Skift blokeringsliste
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Mere information
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Cryptominers
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Fingerprinters
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Håndter undtagelser…
    .accesskey = u

## Privacy Section - Permissions

permissions-header = Tilladelser
permissions-location = Position
permissions-location-settings =
    .label = Indstillinger…
    .accesskey = I
permissions-xr = Virtual reality
permissions-xr-settings =
    .label = Indstillinger…
    .accesskey = I
permissions-camera = Kamera
permissions-camera-settings =
    .label = Indstillinger…
    .accesskey = I
permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Indstillinger…
    .accesskey = I
permissions-notification = Beskeder
permissions-notification-settings =
    .label = Indstillinger…
    .accesskey = I
permissions-notification-link = Læs mere
permissions-notification-pause =
    .label = Sæt beskeder på pause, indtil { -brand-short-name } starter igen
    .accesskey = b
permissions-autoplay = Automatisk afspilning
permissions-autoplay-settings =
    .label = Indstillinger…
    .accesskey = I
permissions-block-popups =
    .label = Bloker pop op-vinduer
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Undtagelser…
    .accesskey = U
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Undtagelser
    .accesskey = U
    .searchkeywords = Pop op-vinduer
permissions-addon-install-warning =
    .label = Advar mig når websteder forsøger at installere tilføjelser
    .accesskey = A
permissions-addon-exceptions =
    .label = Undtagelser…
    .accesskey = t

## Privacy Section - Data Collection

collection-header = Indsamling og brug af data i { -brand-short-name }
collection-description = Vi stræber efter at give dig mulighed for selv at vælge og indsamler kun, hvad vi har brug for til at forbedre { -brand-short-name } for alle. Vi spørger altid om din tilladelse, før vi modtager personlig information.
collection-privacy-notice = Privatlivspolitik
collection-health-report-telemetry-disabled = Du tillader ikke længere, at { -vendor-short-name } indsamler teknisk data og data om brug. Alle tidligere data vil blive slettet indenfor 30 dage.
collection-health-report-telemetry-disabled-link = Læs mere
collection-health-report =
    .label = Tillad at { -brand-short-name } indsender tekniske data og data om brug til { -vendor-short-name }
    .accesskey = d
collection-health-report-link = Læs mere
collection-studies =
    .label = Tillad at { -brand-short-name } installerer og afvikler undersøgelser
collection-studies-link = Vis { -brand-short-name }-undersøgelser
addon-recommendations =
    .label = Tillad at { -brand-short-name } anbefaler udvidelser specielt udvalgt til dig
addon-recommendations-link = Læs mere
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Data-rapportering er deaktiveret for denne build-konfiguration
collection-backlogged-crash-reports-with-link = Tillad at { -brand-short-name } sender ophobede fejlrapporter på dine vegne <a data-l10n-name="crash-reports-link">Læs mere</a>
    .accesskey = o

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Sikkerhed
security-browsing-protection = Beskyttelse mod vildledende indhold og farlig software
security-enable-safe-browsing =
    .label = Bloker farlige og vildledende websteder
    .accesskey = B
security-enable-safe-browsing-link = Læs mere
security-block-downloads =
    .label = Bloker hentning af farlige filer
    .accesskey = o
security-block-uncommon-software =
    .label = Advar mig om uønsket og usædvanlig software
    .accesskey = d

## Privacy Section - Certificates

certs-header = Certifikater
certs-enable-ocsp =
    .label = Send forespørgsel til OCSP responder-servere for at bekræfte certifikaters aktuelle gyldighed
    .accesskey = O
certs-view =
    .label = Vis certificater…
    .accesskey = c
certs-devices =
    .label = Sikkerhedsmoduler…
    .accesskey = S
space-alert-over-5gb-settings-button =
    .label = Åbn indstillinger
    .accesskey = b
space-alert-over-5gb-message2 =
    <strong>{ -brand-short-name } er ved at løbe tør for diskplads</strong> 
    Indhold på websteder vises måske ikke korrekt. Du kan slette gemte data i Indstillinger > Privatliv & sikkerhed > Cookies og websteds-data
space-alert-under-5gb-message2 =
    <strong>{ -brand-short-name } er ved at løbe tør for diskplads</strong> 
    Indhold på websteder vises måske ikke korrekt. Klik på "Læs mere" for at optimere dit diskforbrug og få en bedre browsing-oplevelse.

## Privacy Section - HTTPS-Only

httpsonly-header = Tilstanden Kun-HTTPS
httpsonly-description = HTTPS sørger for en sikker, krypteret forbindelse mellem { -brand-short-name } og de websteder, du besøger. De fleste websteder understøtter HTTPS, og hvis kun-HTTPS er slået til, så opgraderer { -brand-short-name } alle forbindelser til HTTPS.
httpsonly-learn-more = Læs mere
httpsonly-radio-enabled =
    .label = Slå kun-HTTPS til for alle vinduer
httpsonly-radio-enabled-pbm =
    .label = Slå udelukkende kun-HTTPS til for private vinduer
httpsonly-radio-disabled =
    .label = Slå ikke kun-HTTPS til

## The following strings are used in the Download section of settings

desktop-folder-name = Skrivebord
downloads-folder-name = Hentede filer
choose-download-folder-title = Gem filer i
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Gem filer i { $service-name }
