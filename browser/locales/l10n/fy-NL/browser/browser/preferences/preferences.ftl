# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Websites in ‘Net folgje’-sinjaal stjoere om litte te witten dat jo net folge wurde wolle
do-not-track-learn-more = Mear ynfo
do-not-track-option-default-content-blocking-known =
    .label = Allinnich wannear't { -brand-short-name } ynsteld is om bekende trackers te blokkearjen
do-not-track-option-always =
    .label = Altyd
pref-page-title =
    { PLATFORM() ->
        [windows] Opsjes
       *[other] Opsjes
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Fyn yn Opsjes
           *[other] Fyn yn Foarkarren
        }
managed-notice = Jo browser wurdt troch jo organisaasje beheard.
pane-general-title = Algemien
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Startside
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Sykje
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Privacy & Befeiliging
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = { -brand-short-name }-eksperiminten
category-experimental =
    .tooltiptext = { -brand-short-name }-eksperiminten
pane-experimental-subtitle = Gean foarsichtich troch
pane-experimental-search-results-header = { -brand-short-name }-eksperiminten: foarsichtichheid advisearre
pane-experimental-description = It wizigjen fan avansearre konfiguraasjefoarkarren kin de prestaasjes of feilichheid fan { -brand-short-name } beynfloedzje.
help-button-label = { -brand-short-name }-stipe
addons-button-label = Utwreidingen & Tema’s
focus-search =
    .key = f
close-button =
    .aria-label = Slute

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } moat opnij starte om dizze funksje yn te skeakeljen.
feature-disable-requires-restart = { -brand-short-name } moat opnij starte om dizze funksje út te skeakeljen.
should-restart-title = { -brand-short-name } opnij starte
should-restart-ok = { -brand-short-name } no opnij starte
cancel-no-restart-button = Annulearje
restart-later = Letter opnij starte

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = In útwreiding, <img data-l10n-name="icon"/> { $name }, beheart jo startside.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = In útwreiding, <img data-l10n-name="icon"/> { $name }, beheart jo Nij-ljepblêd-side.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = In útwreiding, <img data-l10n-name="icon"/> { $name }, hat behear oer dizze ynstelling.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = In útwreiding, <img data-l10n-name="icon"/> { $name }, hat behear oer dizze ynstelling.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = In útwreiding, <img data-l10n-name="icon"/> { $name }, hat jo standertsykmasine ynsteld.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = In útwreiding, <img data-l10n-name="icon"/> { $name }, fereasket kontenerljepblêden.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = In útwreiding, <img data-l10n-name="icon"/> { $name }, hat behear oer dizze ynstelling.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = De útwreiding <img data-l10n-name="icon"/> { $name } bepaalt hoe't { -brand-short-name } ferbining makket mei it ynternet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Gean nei <img data-l10n-name="addons-icon"/> Add-ons yn it menu <img data-l10n-name="menu-icon"/> om de útwreiding yn te skeakeljen.

## Preferences UI Search Results

search-results-header = Sykresultaten
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Sorry! Der binne gjin resultaten yn Opsjes foar ‘<span data-l10n-name="query"></span>’.
       *[other] Sorry! Der binne gjin resultaten yn Foarkarren foar ‘<span data-l10n-name="query"></span>’.
    }
search-results-help-link = Help nedich? Besykje <a data-l10n-name="url">{ -brand-short-name }-stipe</a>

## General Section

startup-header = Opstarte
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Tagelyk útfieren fan { -brand-short-name } en Firefox tastean
use-firefox-sync = Tip: Dit brûkt ferskillende profilen. Brûk { -sync-brand-short-name } om gegevens dêrtusken te dielen.
get-started-not-logged-in = Oanmelde by { -sync-brand-short-name } …
get-started-configured = { -sync-brand-short-name }-foarkarren iepenje
always-check-default =
    .label = Altyd kontrolearje oft { -brand-short-name } de standertbrowser is
    .accesskey = k
is-default = { -brand-short-name } is op dit stuit jo standertbrowser
is-not-default = { -brand-short-name } is net jo standertbrowser
set-as-my-default-browser =
    .label = Standert meitsje…
    .accesskey = S
startup-restore-previous-session =
    .label = Foargeande sesje werom bringe
    .accesskey = F
startup-restore-warn-on-quit =
    .label = Warskôgje by it ôfsluten fan de browser
disable-extension =
    .label = Utwreiding útskeakelje
tabs-group-header = Ljepblêden
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab rint troch ljepblêden yn koartlyn brûkte folchoarder
    .accesskey = T
open-new-link-as-tabs =
    .label = Keppelingen iepenje yn ljepblêden yn stee fan nije finsters
    .accesskey = f
warn-on-close-multiple-tabs =
    .label = My warskôgje by it sluten fan mear ljepblêden
    .accesskey = M
warn-on-open-many-tabs =
    .label = My warskôgje as it iepenjen fan mear ljepblêden { -brand-short-name } fertrage kin
    .accesskey = w
switch-links-to-new-tabs =
    .label = As ik in keppeling iepenje yn in nij ljepblêd, der daliks nei ta gean
    .accesskey = d
show-tabs-in-taskbar =
    .label = Ljepblêdfoarbylden yn de Windows-taakbalke toane
    .accesskey = W
browser-containers-enabled =
    .label = Kontenerljepblêden ynskeakelje
    .accesskey = n
browser-containers-learn-more = Mear ynfo
browser-containers-settings =
    .label = Ynstellingen…
    .accesskey = i
containers-disable-alert-title = Alle kontenerljepblêden slute?
containers-disable-alert-desc =
    { $tabCount ->
        [one] As jo kontenerljepblêden no útskeakelje, sil { $tabCount } kontenerljepblêd sluten wurde. Binne jo wis dat jo kontenerljepblêden útskeakelje wolle?
       *[other] As jo kontenerljepblêden no útskeakelje, sille { $tabCount } kontenerljepblêden sluten wurde. Binne jo wis dat jo kontenerljepblêden útskeakelje wolle?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } kontenerljepblêd slute
       *[other] { $tabCount } kontenerljepblêden slute
    }
containers-disable-alert-cancel-button = Ynskeakele litte
containers-remove-alert-title = Dizze kontener fuortsmite?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] As jo dizze kontener no fuortsmite, sil { $count } kontenerljepblêd sluten wurde. Binne jo wis dat jo dizze kontener fuortsmite wolle?
       *[other] As jo dizze kontener no fuortsmite, sille { $count } kontenerljepblêden sluten wurde. Binne jo wis dat jo dizze kontener fuortsmite wolle?
    }
containers-remove-ok-button = Dizze kontener fuortsmite
containers-remove-cancel-button = Dizze kontener net fuortsmite

## General Section - Language & Appearance

language-and-appearance-header = Taal en úterlik
fonts-and-colors-header = Lettertypen & kleuren
default-font = Standertlettertype
    .accesskey = S
default-font-size = Grutte
    .accesskey = G
advanced-fonts =
    .label = Avansearre…
    .accesskey = v
colors-settings =
    .label = Kleuren…
    .accesskey = K
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Standert zoom
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Allinnich tekst ynzoome
    .accesskey = t
language-header = Taal
choose-language-description = Talen kieze dêr't websites yn werjûn wurde moatte.
choose-button =
    .label = Kieze…
    .accesskey = i
choose-browser-language-description = Kies de talen dy't brûkt wurde foar it werjaan fan menu’s, berjochten en notifikaasjes fan { -brand-short-name }.
manage-browser-languages-button =
    .label = Alternativen ynstelle…
    .accesskey = A
confirm-browser-language-change-description = Start { -brand-short-name } opnij om dizze wizigingen ta te passen.
confirm-browser-language-change-button = Tapasse en opnij starte
translate-web-pages =
    .label = Webynhâld oersette
    .accesskey = W
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Oersettingen troch <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Utsûnderingen…
    .accesskey = s
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = De ynstellingen foar ‘{ $localeName }’ fan jo bestjoeringssysteem brûke om data, tiden, getallen en mjittingen op te meitsjen.
check-user-spelling =
    .label = Kontrolearje jo stavering as jo type
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Bestannen en Tapassingen
download-header = Downloads
download-save-to =
    .label = Bestannen bewarje yn
    .accesskey = e
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Kieze…
           *[other] Blêdzje…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] z
           *[other] d
        }
download-always-ask-where =
    .label = My altyd freegje wêr't bestannen bewarre wurde moatte
    .accesskey = b
applications-header = Applikaasjes
applications-description = Kieze hoe't { -brand-short-name } omgiet mei de bestannen dy't jo fan it web downloade of de tapassingen dy't jo wylst it sneupen brûke.
applications-filter =
    .placeholder = Bestânstypen of tapassingen sykje
applications-type-column =
    .label = Ynhâldstype
    .accesskey = t
applications-action-column =
    .label = Aksje
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension }-bestân
applications-action-save =
    .label = Bewarje bestân
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Brûk { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Brûk { $app-name } (standert)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Standerttapassing yn macOS brûke
            [windows] Standerttapassing yn Windows brûke
           *[other] Standert systeemtapassing brûke
        }
applications-use-other =
    .label = Brûk oare…
applications-select-helper = Helptapassing selektearje
applications-manage-app =
    .label = Applikaasjedetails…
applications-always-ask =
    .label = Altyd freegje
applications-type-pdf = Portable Document Format (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
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
    .label = { $plugin-name } brûke (yn { -brand-short-name })
applications-open-inapp =
    .label = Iepenje yn { -brand-short-name }

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

drm-content-header = Digital Rights Management (DRM)-ynhâld
play-drm-content =
    .label = DRM-kontrolearre ynhâld ôfspylje
    .accesskey = D
play-drm-content-learn-more = Mear ynfo
update-application-title = { -brand-short-name }-fernijingen
update-application-description = Hâld { -brand-short-name } by de tiid foar de bêste prestaasjes, stabiliteit en feilichheid.
update-application-version = Ferzje { $version } <a data-l10n-name="learn-more">Wat is der nij</a>
update-history =
    .label = Fernijingsskiednis toane…
    .accesskey = s
update-application-allow-description = { -brand-short-name } mei
update-application-auto =
    .label = Fernijingen automatysk ynstallearje (oanrekommandearre)
    .accesskey = A
update-application-check-choose =
    .label = Kontrolearje op fernijingen, mar jo kieze litte oft jo dizze ynstallearje wolle
    .accesskey = K
update-application-manual =
    .label = Nea kontrolearje op fernijingen (net oanrekommandearre)
    .accesskey = N
update-application-warning-cross-user-setting = Dizze ynstelling is fan tapassing op alle Windows-accounts en { -brand-short-name }-profilen dy't dizze ynstallaasje fan { -brand-short-name } brûke.
update-application-use-service =
    .label = Brûk in eftergrûntsjinst om fernijingen te ynstallearjen
    .accesskey = a
update-setting-write-failure-title = Flater by bewarjen fernijingsfoarkarren
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } hat in flater oantroffen en hat dizze wiziging net bewarre. Merk op dat foar it ynstellen fan dizze fernijingsfoarkar skriuwrjochten foar ûndersteand bestân nedich binne. Jo of jo systeembehearder kin dizze flater oplosse troch de groep ‘Gebruikers’ folsleine tagong ta dit bestân te jaan.
    
    Koe net skriuwe nei bestân: { $path }
update-in-progress-title = Fernijing wurdt útfierd
update-in-progress-message = Wolle jo dat { -brand-short-name } trochgiet mei dizze fernijing?
update-in-progress-ok-button = &Ferwerpe
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Trochgean

## General Section - Performance

performance-title = Prestaasjes
performance-use-recommended-settings-checkbox =
    .label = Oanrekommandearre prestaasjeynstellingen brûke
    .accesskey = D
performance-use-recommended-settings-desc = Dizze ynstellingen binne ôfstimd op de hardware en it bestjoeringssysteem fan jo kompjûter.
performance-settings-learn-more = Mear ynfo
performance-allow-hw-accel =
    .label = Brûk hardware-acceleratie as it beskikber is
    .accesskey = B
performance-limit-content-process-option = Limyt fan ynhâldsprosessen
    .accesskey = L
performance-limit-content-process-enabled-desc = Ekstra ynhâldsprosessen kinne de prestaasjes by it gebrûk fan mear ljepblêden ferbetterje, mar sille ek mear ûnthâld brûke.
performance-limit-content-process-blocked-desc = Oanpassen fan it oantal ynhâldsprosessen is allinnich mooglik mei multiproses-{ -brand-short-name }. <a data-l10n-name="learn-more">Ynformaasje oer it kontrolearjen of multiproses ynskeakele is</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (standert)

## General Section - Browsing

browsing-title = Navigearje
browsing-use-autoscroll =
    .label = Automatysk skowe brûke
    .accesskey = m
browsing-use-smooth-scrolling =
    .label = Floeiend skowe brûke
    .accesskey = l
browsing-use-onscreen-keyboard =
    .label = In skermtoetseboerd toane wannear nedich
    .accesskey = k
browsing-use-cursor-navigation =
    .label = Hieltyd de pylktoetsen brûke om te navigearjen yn siden
    .accesskey = p
browsing-search-on-start-typing =
    .label = Nei tekst sykje as ik begjin mei typen
    .accesskey = N
browsing-picture-in-picture-toggle-enabled =
    .label = Picture-in-picture-fideobestjoering ynskeakelje
    .accesskey = P
browsing-picture-in-picture-learn-more = Mear ynfo
browsing-cfr-recommendations =
    .label = Utwreidingen oanrekommandearje wylst jo sneupe
    .accesskey = a
browsing-cfr-features =
    .label = Funksjes oanrekommandearje wylst jo sneupe
    .accesskey = F
browsing-cfr-recommendations-learn-more = Mear ynfo

## General Section - Proxy

network-settings-title = Netwurkynstellingen
network-proxy-connection-description = Konfigurearje hoe { -brand-short-name } ferbining makket mei it ynternet.
network-proxy-connection-learn-more = Mear ynfo
network-proxy-connection-settings =
    .label = Ynstellingen…
    .accesskey = Y

## Home Section

home-new-windows-tabs-header = Nije finsters en ljepblêden
home-new-windows-tabs-description2 = Kies wat jo sjogge as jo jo startside, nije finsters en nije ljepblêden iepenje.

## Home Section - Home Page Customization

home-homepage-mode-label = Startside en nije finsters
home-newtabs-mode-label = Nije ljepblêden
home-restore-defaults =
    .label = Standert werstelle
    .accesskey = w
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox-startside (Standert)
home-mode-choice-custom =
    .label = Oanpaste URL's
home-mode-choice-blank =
    .label = Lege side
home-homepage-custom-url =
    .placeholder = Plak in URL…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Aktuele side brûke
           *[other] Aktuele siden brûke
        }
    .accesskey = k
choose-bookmark =
    .label = Blêdwizer brûke…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Ynhâld fan Firefox-startside
home-prefs-content-description = Kies hokker ynhâld jo op jo Firefox-startside werjaan wolle.
home-prefs-search-header =
    .label = Sykje op it web
home-prefs-topsites-header =
    .label = Topwebsites
home-prefs-topsites-description = De troch jo meast besochte websites

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Oanrekommandearre troch { $provider }
home-prefs-recommended-by-description-update = Utsûnderlike ynhâld fan it hiele ynternet, gearstald troch { $provider }

##

home-prefs-recommended-by-learn-more = Hoe it wurket
home-prefs-recommended-by-option-sponsored-stories =
    .label = Sponsore ferhalen
home-prefs-highlights-header =
    .label = Hichtepunten
home-prefs-highlights-description = In seleksje fan websites dy't jo bewarre of besocht hawwe
home-prefs-highlights-option-visited-pages =
    .label = Besochte siden
home-prefs-highlights-options-bookmarks =
    .label = Blêdwizers
home-prefs-highlights-option-most-recent-download =
    .label = Meast resinte download
home-prefs-highlights-option-saved-to-pocket =
    .label = Siden bewarre nei { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Koarte ynformaasje
home-prefs-snippets-description = Fernijingen fan { -vendor-short-name } en { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } rige
           *[other] { $num } rigen
        }

## Search Section

search-bar-header = Sykbalke
search-bar-hidden =
    .label = Brûk de adresbalke foar sykjen en navigearjen
search-bar-shown =
    .label = Sykbalke yn arkbalke tafoegje
search-engine-default-header = Standertsykmasine
search-engine-default-desc-2 = Dit is jo standertsykmasine yn de adresbalke en de sykbalke. Jo kinne dizze op elk momint wizigje.
search-engine-default-private-desc-2 = Kies in oare standertsykmasine dy't jo yn priveefinsters brûke wolle
search-separate-default-engine =
    .label = Dizze sykmasine yn priveefinsters brûke
    .accesskey = s
search-suggestions-header = Sykfoarstellen
search-suggestions-desc = Kies hoe't sykfoarstellen fan sykmasinen werjûn wurde.
search-suggestions-option =
    .label = Sykfoarstellen jaan
    .accesskey = S
search-show-suggestions-url-bar-option =
    .label = Sykfoarstellen yn adresbalkeresultaten toane
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Syksuggestjes boppe browserskiednis toane yn adresbalkeresultaten
search-show-suggestions-private-windows =
    .label = Syksuggestjes werjaan yn priveefinsters
suggestions-addressbar-settings-generic = Foarkarren foar oare adresbalksuggestjes wizigje
search-suggestions-cant-show = Sykfoarstellen wurde net yn lokaasjebalkresultaten toand, omdat jo { -brand-short-name } konfigurearre hawwe om nea skiednis te ûnthâlden.
search-one-click-header = Ien-klik-sykmasinen
search-one-click-desc = Kies de alternative sykmasinen dy't ûnder de adresbalke en sykbalke ferskine as jo in kaaiwurd begjinne yn te fieren.
search-choose-engine-column =
    .label = Sykmasine
search-choose-keyword-column =
    .label = Kaaiwurd
search-restore-default =
    .label = Standertsykmasinen weromsette
    .accesskey = S
search-remove-engine =
    .label = Fuortsmite
    .accesskey = F
search-add-engine =
    .label = Tafoegje
    .accesskey = T
search-find-more-link = Mear sykmasinen fine
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Dûbel kaaiwurd
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Jo hawwe in kaaiwurd keazen dat op dit stuit yn gebrûk is troch ‘{ $name }’. Selektearje asjebleaft in oar.
search-keyword-warning-bookmark = Jo hawwe in kaaiwurd keazen dat op dit stuit yn gebrûk is troch in blêdwizer. Selektearje asjebleaft in oar.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Tebek nei Opsjes
           *[other] Tebek nei Foarkarren
        }
containers-header = Kontenerljepblêden
containers-add-button =
    .label = Nije kontener tafoegje
    .accesskey = A
containers-new-tab-check =
    .label = Selektearje in kontener foar elk nij ljepblêd
    .accesskey = S
containers-preferences-button =
    .label = Foarkarren
containers-remove-button =
    .label = Fuortsmite

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Nim jo web mei jo mei
sync-signedout-description = Syngronisearje jo blêdwizers, skiednis, ljepblêden, wachtwurden, add-ons en foarkarren op al jo apparaten.
sync-signedout-account-signin2 =
    .label = Oanmelde by { -sync-brand-short-name }…
    .accesskey = O
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Download Firefox foar <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> of <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> om mei jo mobile apparaat te syngronisearjen.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Profylôfbylding wizigje
sync-sign-out =
    .label = Ofmelde…
    .accesskey = O
sync-manage-account = Account beheare
    .accesskey = h
sync-signedin-unverified = { $email } is net ferifiearre.
sync-signedin-login-failure = Meld jo oan om wer te ferbinen { $email }
sync-resend-verification =
    .label = Ferifikaasje opnij ferstjoere
    .accesskey = f
sync-remove-account =
    .label = Account fuortsmite
    .accesskey = A
sync-sign-in =
    .label = Oanmelde
    .accesskey = m

## Sync section - enabling or disabling sync.

prefs-syncing-on = Syngronisaasje: OAN
prefs-syncing-off = Syngronisaasje: ÚT
prefs-sync-setup =
    .label = { -sync-brand-short-name } ynstelle…
    .accesskey = y
prefs-sync-offer-setup-label = Syngronisearje jo blêdwizers, skiednis, ljepblêden, wachtwurden, add-ons en foarkarren op al jo apparaten.
prefs-sync-now =
    .labelnotsyncing = No syngronisearje
    .accesskeynotsyncing = N
    .labelsyncing = Syngronisearret…

## The list of things currently syncing.

sync-currently-syncing-heading = Jo syngronisearje op it stuit dizze items:
sync-currently-syncing-bookmarks = Blêdwizers
sync-currently-syncing-history = Skiednis
sync-currently-syncing-tabs = Iepen ljepblêden
sync-currently-syncing-logins-passwords = Oanmeldingen en wachtwurden
sync-currently-syncing-addresses = Adressen
sync-currently-syncing-creditcards = Creditcards
sync-currently-syncing-addons = Add-ons
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Foarkarren
       *[other] Foarkarren
    }
sync-change-options =
    .label = Wizigje…
    .accesskey = W

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Kies wat jo syngronisearje wolle
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Wizigingen bewarje
    .buttonaccesskeyaccept = W
    .buttonlabelextra2 = Ferbrekke…
    .buttonaccesskeyextra2 = F
sync-engine-bookmarks =
    .label = Blêdwizers
    .accesskey = w
sync-engine-history =
    .label = Skiednis
    .accesskey = n
sync-engine-tabs =
    .label = Iepen ljepblêden
    .tooltiptext = In list fan wat op alle syngronisearre apparaten iepene is
    .accesskey = b
sync-engine-logins-passwords =
    .label = Oanmeldingen en wachtwurden
    .tooltiptext = Oanmeldingen en wachtwurden dy't jo bewarre hawwe
    .accesskey = a
sync-engine-addresses =
    .label = Adressen
    .tooltiptext = Bewarre adressen (allinnich desktop)
    .accesskey = e
sync-engine-creditcards =
    .label = Creditcards
    .tooltiptext = Nammen, nûmers en ferrindatums (allinnich desktop)
    .accesskey = C
sync-engine-addons =
    .label = Add-ons
    .tooltiptext = Utwreidingen en tema's foar Firefox foar desktop
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Opsjes
           *[other] Foarkarren
        }
    .tooltiptext = Algemiene, privacy- en feilichheidsynstellingen dy't jo wizige hawwe
    .accesskey = F

## The device name controls.

sync-device-name-header = Apparaatnamme
sync-device-name-change =
    .label = Apparaatnamme wizigje…
    .accesskey = p
sync-device-name-cancel =
    .label = Annulearje
    .accesskey = e
sync-device-name-save =
    .label = Bewarje
    .accesskey = B
sync-connect-another-device = In oar apparaat ferbine

## Privacy Section

privacy-header = Browserprivacy

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Oanmeldingen & Wachtwurden
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Freegje om oanmeldingen en wachtwurden foar websites te ûnthâlden
    .accesskey = F
forms-exceptions =
    .label = Utsûnderingen…
    .accesskey = s
forms-generate-passwords =
    .label = Sterke wachtwurden foarstelle en generearje
    .accesskey = w
forms-breach-alerts =
    .label = Warskôgingen oer wachtwurden foar troffen websites toane
    .accesskey = f
forms-breach-alerts-learn-more-link = Mear ynfo
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Oanmeldingen en wachtwurden automatysk ynfolje
    .accesskey = O
forms-saved-logins =
    .label = Bewarre oanmeldingen…
    .accesskey = m
forms-master-pw-use =
    .label = In haadwachtwurd brûke
    .accesskey = I
forms-primary-pw-use =
    .label = In haadwachtwurd brûke
    .accesskey = h
forms-primary-pw-learn-more-link = Mear ynfo
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Haadwachtwurd wizigje
    .accesskey = a
forms-master-pw-fips-title = Jo binne no yn FIPS-modus. FIPS fereasket dat it haadwachtwurd net leech is.
forms-primary-pw-change =
    .label = Haadwachtwurd wizigje…
    .accesskey = H
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = ""
forms-primary-pw-fips-title = Jo binne no yn FIPS-modus. FIPS fereasket dat it haadwachtwurd net leech is.
forms-master-pw-fips-desc = Wachtwurdwiziging mislearre.

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Fier jo oanmeldgegevens foar Windows yn om in haadwachtwurd yn te stellen. Hjirtroch wurdt de befeiliging fan jo accounts beskerme.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = haadwachtwurd oanmeitsje
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Fier jo oanmeldgegevens foar Windows yn om in haadwachtwurd yn te stellen. Hjirtroch wurdt de befeiliging fan jo accounts beskerme.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = in haadwachtwurd oanmeitsje
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Skiednis
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } sil
    .accesskey = s
history-remember-option-all =
    .label = Skiednis ûnthâlde
history-remember-option-never =
    .label = Nea skiednis ûnthâlde
history-remember-option-custom =
    .label = Oanpaste ynstellingen brûke foar skiednis
history-remember-description = { -brand-short-name } sil jo browser-, download-, formulier- en sykskiednis ûnthâlde.
history-dontremember-description = { -brand-short-name } sil deselde ynstellingen brûke as privee sneupe en sil gjin skiednis ûnthâlde as jo sneupe oer it ynternet.
history-private-browsing-permanent =
    .label = Altyd de priveenavigaasje brûke
    .accesskey = P
history-remember-browser-option =
    .label = Navigaasje- en downloadskiednis ûnthâlde
    .accesskey = N
history-remember-search-option =
    .label = Syk- en formulierskiednis ûnthâlde
    .accesskey = S
history-clear-on-close-option =
    .label = Skiednis wiskje as { -brand-short-name } slút
    .accesskey = w
history-clear-on-close-settings =
    .label = Ynstellingen…
    .accesskey = Y
history-clear-button =
    .label = Skiednis wiskje…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookies en websitegegevens
sitedata-total-size-calculating = Grutte fan websitegegevens en buffer berekkenje…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Jo bewarre cookies, websitegegevens en buffer brûke op dit stuit { $value } { $unit } oan skiifromte.
sitedata-learn-more = Mear ynfo
sitedata-delete-on-close =
    .label = Cookies en websitegegevens fuortsmite sa gau as { -brand-short-name } sluten wurdt
    .accesskey = C
sitedata-delete-on-close-private-browsing = Yn permaninte priveenavigaasjemodus wurde cookies en websitegegevens altyd wiske sa gau as { -brand-short-name } sluten wurdt.
sitedata-allow-cookies-option =
    .label = Cookies en websitegegevens akseptearje
    .accesskey = a
sitedata-disallow-cookies-option =
    .label = Cookies en websitegegevens blokkearje
    .accesskey = b
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Blokkearre type
    .accesskey = t
sitedata-option-block-cross-site-trackers =
    .label = Cross-site-trackers
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Cross-site- en sosjale-mediatrackers
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Cross-site- en sosjale-mediatrackers, en de restearjende cookies isolearje
sitedata-option-block-unvisited =
    .label = Cookies fan net-besochte websites
sitedata-option-block-all-third-party =
    .label = Alle cookies fan tredden (kin derfoar soargje dat websites net goed wurkje)
sitedata-option-block-all =
    .label = Alle cookies (sil derfoar soargje dat websites net goed wurkje)
sitedata-clear =
    .label = Gegevens wiskje…
    .accesskey = e
sitedata-settings =
    .label = Gegevens beheare…
    .accesskey = G
sitedata-cookies-permissions =
    .label = Tastimmingen beheare…
    .accesskey = T
sitedata-cookies-exceptions =
    .label = Utsûnderingen beheare…
    .accesskey = s

## Privacy Section - Address Bar

addressbar-header = Adresbalke
addressbar-suggest = By gebrûk fan de adresbalke, suggestjes werjaan út
addressbar-locbar-history-option =
    .label = Navigaasjeskiednis
    .accesskey = N
addressbar-locbar-bookmarks-option =
    .label = Blêdwizers
    .accesskey = d
addressbar-locbar-openpage-option =
    .label = Iepen ljepblêden
    .accesskey = I
addressbar-locbar-topsites-option =
    .label = Topwebsites
    .accesskey = T
addressbar-suggestions-settings = Foarkarren foar sykmasinesuggestjes wizigje

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Ferbettere beskerming tsjin folgjen
content-blocking-section-top-level-description = Trackers folgje jo online om gegevens oer jo sneupgedrach en ynteresses te sammeljen. { -brand-short-name } blokkearret in protte fan dizze trackers en oare kweawollende skripts.
content-blocking-learn-more = Mear ynfo

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standert
    .accesskey = S
enhanced-tracking-protection-setting-strict =
    .label = Strang
    .accesskey = t
enhanced-tracking-protection-setting-custom =
    .label = Oanpast
    .accesskey = O

##

content-blocking-etp-standard-desc = Balansearre foar beskerming en prestaasjes. Siden lade normaal.
content-blocking-etp-strict-desc = Sterkere beskerming, mar kin der foar soargje dat guon websites of ynhâld net wurkje.
content-blocking-etp-custom-desc = Kies hokker trackers en scripts jo blokkearje wolle.
content-blocking-private-windows = Folchynhâld yn priveefinsters
content-blocking-cross-site-tracking-cookies = Cross-site-trackingcookies
content-blocking-cross-site-tracking-cookies-plus-isolate = Cross-site-trackingcookies, en de restearjende cookies isolearje
content-blocking-social-media-trackers = Sosjale-mediatrackers
content-blocking-all-cookies = Alle cookies
content-blocking-unvisited-cookies = Cookies fan net-besochte websites
content-blocking-all-windows-tracking-content = Folchynhâld yn alle finsters
content-blocking-all-third-party-cookies = Alle cookies fan tredden
content-blocking-cryptominers = Cryptominers
content-blocking-fingerprinters = Fingerprinters
content-blocking-warning-title = Let op!
content-blocking-and-isolating-etp-warning-description = It blokkearjen fan trackers en isolearjen fan cookies kin de funksjonaliteit fan guon websites beynfloedzje. Laad in side mei trackers opnij om alle ynhâld te laden.
content-blocking-warning-learn-how = Mear ynfo
content-blocking-reload-description = Jo moatte jo ljepblêden fernije om dizze wizigingen ta te passen.
content-blocking-reload-tabs-button =
    .label = Alle ljepblêden fernije
    .accesskey = A
content-blocking-tracking-content-label =
    .label = Folchynhâld
    .accesskey = F
content-blocking-tracking-protection-option-all-windows =
    .label = Yn alle finsters
    .accesskey = a
content-blocking-option-private =
    .label = Allinnich yn priveefinsters
    .accesskey = r
content-blocking-tracking-protection-change-block-list = Blokkearlist wizigje
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Mear ynformaasje
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
    .label = Utsûndering beheare…
    .accesskey = U

## Privacy Section - Permissions

permissions-header = Tastimmingen
permissions-location = Lokaasje
permissions-location-settings =
    .label = Ynstellingen…
    .accesskey = t
permissions-xr = Virtual Reality
permissions-xr-settings =
    .label = Ynstellingen…
    .accesskey = t
permissions-camera = Kamera
permissions-camera-settings =
    .label = Ynstellingen…
    .accesskey = t
permissions-microphone = Mikrofoan
permissions-microphone-settings =
    .label = Ynstellingen…
    .accesskey = t
permissions-notification = Notifikaasjes
permissions-notification-settings =
    .label = Ynstellingen…
    .accesskey = t
permissions-notification-link = Mear ynfo
permissions-notification-pause =
    .label = Notifikaasjes pauzearje oant { -brand-short-name } opnij start wurdt
    .accesskey = N
permissions-autoplay = Automatysk ôfspylje
permissions-autoplay-settings =
    .label = Ynstellingen…
    .accesskey = Y
permissions-block-popups =
    .label = Pop-upfinsters blokkearje
    .accesskey = P
permissions-block-popups-exceptions =
    .label = Utsûnderingen…
    .accesskey = U
permissions-addon-install-warning =
    .label = My warskôgje as websites probearje add-ons te ynstallearjen
    .accesskey = M
permissions-addon-exceptions =
    .label = Utsûnderingen…
    .accesskey = U
permissions-a11y-privacy-checkbox =
    .label = Tagong ta jo browser troch tagonklikheidstsjinsten opkeare
    .accesskey = a
permissions-a11y-privacy-link = Mear ynfo

## Privacy Section - Data Collection

collection-header = Gegevenssamling en gebrûk fan { -brand-short-name }
collection-description = Wy stribje dernei jo kar te bieden en allinnich te sammeljen wat wy nedich hawwe om { -brand-short-name } foar elkenien beskikber te meitsjen en te ferbetterjen. Wy freegje altyd tastimming eardat wy persoanlike gegevens ûntfange.
collection-privacy-notice = Privacyferklearring
collection-health-report-telemetry-disabled = Jo steane { -vendor-short-name } net langer ta technyske en ynteraksjegegevens fêst te lizzen. Alle eardere gegevens wurde binnen 30 dagen fuortsmiten.
collection-health-report-telemetry-disabled-link = Mear ynfo
collection-health-report =
    .label = Tastean dat { -brand-short-name } technyske en brûksgegevens ferstjoert nei { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Mear ynfo
collection-studies =
    .label = { -brand-short-name } tastean om ûndersiken te ynstallearjen en út te fieren
collection-studies-link = { -brand-short-name }-ûndersiken werjaan
addon-recommendations =
    .label = { -brand-short-name } tastean om personalisearre útrweidingsrekommandaasjes te dwaan
addon-recommendations-link = Mear ynfo
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Gegevensrapporten binne foar dizze build-konfiguraasje útskeakele
collection-backlogged-crash-reports =
    .label = { -brand-short-name } tastean om út jo namme jo efterstallige ûngelokrapporten te ferstjoeren
    .accesskey = r
collection-backlogged-crash-reports-link = Mear ynfo

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Befeiliging
security-browsing-protection = Beskerming tsjin misliedende ynhâld en gefaarlike programma's
security-enable-safe-browsing =
    .label = Gefaarlike en misliedende ynhâld blokkearje
    .accesskey = G
security-enable-safe-browsing-link = Mear ynfo
security-block-downloads =
    .label = Gefaarlijke downloads blokkearje
    .accesskey = f
security-block-uncommon-software =
    .label = My warskôgje foar net-winske en ûngebrûklike software
    .accesskey = w

## Privacy Section - Certificates

certs-header = Sertifikaten
certs-personal-label = Wannear in server om jo persoanlike sertifikaat freget
certs-select-auto-option =
    .label = Automatysk ien selektearje
    .accesskey = A
certs-select-ask-option =
    .label = My elke kear freegje
    .accesskey = M
certs-enable-ocsp =
    .label = Freegje OCSP-responderservers om de aktuele faliditeit fan sertifikaten te befêstigjen
    .accesskey = F
certs-view =
    .label = Sertifikaten besjen…
    .accesskey = S
certs-devices =
    .label = Feilichheidsapparaten…
    .accesskey = F
space-alert-learn-more-button =
    .label = Mear ynfo
    .accesskey = M
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Opsjes iepenje
           *[other] Foarkarren iepenje
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] F
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } hat hast gjin skiifromte mear. Ynhâld fan websites wurdt mooglik net goed werjûn. Jo kinne bewarre gegevens wiskje yn Opsjes > Privacy & Befeiliging > Cookies en websitegegevens.
       *[other] { -brand-short-name } hat hast gjin skiifromte mear. Ynhâld fan websites wurdt mooglik net goed werjûn. Jo kinne bewarre gegevens wiskje yn Foarkarren > Privacy & Befeiliging > Cookies en websitegegevens.
    }
space-alert-under-5gb-ok-button =
    .label = Ok, begrepen
    .accesskey = k
space-alert-under-5gb-message = { -brand-short-name } hat hast gjin skiifromte mear. Ynhâld fan websites wurdt mooglik net goed werjûn. Besykje ‘Mear ynfo’ om jo skiifgebrûk te optimalisearjen foar bettere prestaasjes.

## Privacy Section - HTTPS-Only

httpsonly-header = Allinnich-HTTPS-modus
httpsonly-description = HTTPS biedt in feilige, fersifere ferbining tusken { -brand-short-name } en de troch jo besochte websites. De measte websites stypje HTTPS en as de Allinnich-HTTPS-modus ynskeakele is, sil { -brand-short-name } alle ferbiningen fernije nei HTTPS.
httpsonly-learn-more = Mear ynfo
httpsonly-radio-enabled =
    .label = Allinnich-HTTPS-modus yn alle finsters ynskeakelje
httpsonly-radio-enabled-pbm =
    .label = Allinnich-HTTPS-modus yn alle priveefinsters ynskeakelje
httpsonly-radio-disabled =
    .label = Allinnich-HTTPS-modus net ynskeakelje

## The following strings are used in the Download section of settings

desktop-folder-name = Búroblêd
downloads-folder-name = Myn downloads
choose-download-folder-title = Downloadmap kieze:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Bestannen bewarje nei { $service-name }
