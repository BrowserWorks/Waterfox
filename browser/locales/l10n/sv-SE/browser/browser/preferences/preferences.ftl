# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Skicka webbplatser en “Spåra inte”-signal att du inte vill bli spårad
do-not-track-learn-more = Läs mer
do-not-track-option-default-content-blocking-known =
    .label = Endast när { -brand-short-name } är inställt för att blockera kända spårare
do-not-track-option-always =
    .label = Alltid
settings-page-title = Inställningar
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
    .placeholder = Hitta i inställningar
managed-notice = Din webbläsare hanteras av din organisation.
category-list =
    .aria-label = Kategorier
pane-general-title = Allmänt
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Startsida
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Sök
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Sekretess & säkerhet
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title3 = Synkronisering
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = { -brand-short-name } Experiment
category-experimental =
    .tooltiptext = { -brand-short-name } Experiment
pane-experimental-subtitle = Fortsätt med försiktighet
pane-experimental-search-results-header = { -brand-short-name } Experiment: Fortsätt med försiktighet
pane-experimental-description2 = Att ändra avancerade konfigurationsinställningar kan påverka prestanda eller säkerhet för { -brand-short-name }.
pane-experimental-reset =
    .label = Återställ standard
    .accesskey = t
help-button-label = Support { -brand-short-name }
addons-button-label = Tillägg & teman
focus-search =
    .key = f
close-button =
    .aria-label = Stäng

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } måste starta om för att aktivera den här funktionen.
feature-disable-requires-restart = { -brand-short-name } måste starta om för att inaktivera den här funktionen.
should-restart-title = Starta om { -brand-short-name }
should-restart-ok = Starta om { -brand-short-name } nu
cancel-no-restart-button = Avbryt
restart-later = Starta om senare

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
extension-controlled-password-saving = Ett tillägg, <img data-l10n-name="icon"/> { $name }, styr denna inställning.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Ett tillägg, <img data-l10n-name="icon"/> { $name }, kontrollerar den här inställningen.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Ett tillägg, <img data-l10n-name="icon"/> { $name }, kräver innehållsflikar.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Ett tillägg, <img data-l10n-name="icon"/> { $name }, styr denna inställning.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Ett tillägg, <img data-l10n-name="icon"/> { $name }, styr hur { -brand-short-name } ansluter till internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = För att aktivera tillägget gå till <img data-l10n-name="addons-icon"/> Tillägg i menyn <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Sökresultat
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Förlåt! Det finns inga resultat i Inställningar för "<span data-l10n-name="query"></span>"
search-results-help-link = Behöver du hjälp? Besök <a data-l10n-name="url">{ -brand-short-name } support</a>

## General Section

startup-header = Vid start
always-check-default =
    .label = Kontrollera alltid om { -brand-short-name } är din standardwebbläsare
    .accesskey = a
is-default = { -brand-short-name } är din standardwebbläsare
is-not-default = { -brand-short-name } är inte din standardwebbläsare
set-as-my-default-browser =
    .label = Ange som standard…
    .accesskey = s
startup-restore-previous-session =
    .label = Återställ föregående session
    .accesskey = s
startup-restore-windows-and-tabs =
    .label = Öppna föregående fönster och flikar
    .accesskey = f
startup-restore-warn-on-quit =
    .label = Varna när du avslutar webbläsaren
disable-extension =
    .label = Inaktivera tillägg
tabs-group-header = Flikar
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab växlar mellan flikarna i nyligen använd ordning
    .accesskey = T
open-new-link-as-tabs =
    .label = Öppna länkar i flikar istället för nya fönster
    .accesskey = f
warn-on-close-multiple-tabs =
    .label = Varna när jag stänger flera flikar
    .accesskey = f
confirm-on-close-multiple-tabs =
    .label = Bekräfta innan du stänger flera flikar
    .accesskey = k
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (String) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Bekräfta innan du avslutar med { $quitKey }
    .accesskey = a
warn-on-open-many-tabs =
    .label = Varna när du öppnar flera flikar kan göra { -brand-short-name } långsam
    .accesskey = n
switch-to-new-tabs =
    .label = När du öppnar en länk, bild eller media i en ny flik, byt till den omedelbart
    .accesskey = N
show-tabs-in-taskbar =
    .label = Förhandsgranska flikar i Windows aktivitetsfält
    .accesskey = F
browser-containers-enabled =
    .label = Aktivera innehållsflikar
    .accesskey = k
browser-containers-learn-more = Lär dig mer
browser-containers-settings =
    .label = Inställningar…
    .accesskey = s
containers-disable-alert-title = Stäng alla innehållsflikar?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Om du inaktiverar innehållsflikar nu, { $tabCount } innehållsflik kommer att stängas. Är du säker på att du vill inaktivera innehållsflikar?
       *[other] Om du inaktiverar innehållsflikar nu, { $tabCount } innehållsflikar kommer att stängas. Är du säker på att du vill inaktivera innehållsflikar?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Stäng { $tabCount } innehållsflik
       *[other] Stäng { $tabCount } innehållsflikar
    }
containers-disable-alert-cancel-button = Behåll aktiverad
containers-remove-alert-title = Ta bort denna behållare?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Om du tar bort denna behållaren nu, kommer { $count } innehållsflik att stängas. Är du säker på att du vill ta bort denna behållare?
       *[other] Om du tar bort denna behållare nu, kommer #s innehållsflikar att stängas. Är du säker på att du vill ta bort denna behållare?
    }
containers-remove-ok-button = Ta bort denna behållare
containers-remove-cancel-button = Ta inte bort denna behållare

## General Section - Language & Appearance

language-and-appearance-header = Språk och utseende
fonts-and-colors-header = Teckensnitt och färger
default-font = Standardteckensnitt
    .accesskey = t
default-font-size = Storlek
    .accesskey = S
advanced-fonts =
    .label = Avancerat…
    .accesskey = A
colors-settings =
    .label = Färger…
    .accesskey = F
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Standardzoom
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Zooma endast text
    .accesskey = t
language-header = Språk
choose-language-description = Välj språk som webbsidor ska visas i
choose-button =
    .label = Välj…
    .accesskey = V
choose-browser-language-description = Välj språk som används för att visa menyer, meddelanden och avisering från { -brand-short-name }.
manage-browser-languages-button =
    .label = Ange alternativ…
    .accesskey = A
confirm-browser-language-change-description = Starta om { -brand-short-name } för att tillämpa ändringarna
confirm-browser-language-change-button = Tillämpa och starta om
translate-web-pages =
    .label = Översätt webbinnehåll
    .accesskey = Ö
fx-translate-web-pages = { -translations-brand-name }
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Översättningar av <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Undantag…
    .accesskey = U
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Använd dina operativsysteminställningar för “{ $localeName }” för att formatera datum, tider, siffror och mätningar.
check-user-spelling =
    .label = Kontrollera stavning medan du skriver
    .accesskey = k

## General Section - Files and Applications

files-and-applications-title = Filer och program
download-header = Filhämtningar
download-save-to =
    .label = Spara filer till
    .accesskey = a
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Välj…
           *[other] Bläddra…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] V
           *[other] B
        }
download-always-ask-where =
    .label = Fråga alltid var jag vill spara filerna
    .accesskey = A
applications-header = Program
applications-description = Välj hur { -brand-short-name } hanterar filer du hämtar från webben eller de program du använder när du surfar.
applications-filter =
    .placeholder = Sök filtyper eller program
applications-type-column =
    .label = Typ av innehåll
    .accesskey = T
applications-action-column =
    .label = Åtgärd
    .accesskey = Å
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension }-fil
applications-action-save =
    .label = Spara fil
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Använd { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Använd { $app-name } (standard)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Använd macOS standardapplikation
            [windows] Använd Windows standardapplikation
           *[other] Använd systemets standardapplikation
        }
applications-use-other =
    .label = Välj program…
applications-select-helper = Välj hjälpprogram
applications-manage-app =
    .label = Programdetaljer…
applications-always-ask =
    .label = Fråga alltid
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
    .label = Använd { $plugin-name } (i { -brand-short-name })
applications-open-inapp =
    .label = Öppna i { -brand-short-name }

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

drm-content-header = Digital Rights Management (DRM) innehåll
play-drm-content =
    .label = Spela DRM-kontrollerat innehåll
    .accesskey = S
play-drm-content-learn-more = Lär dig mer
update-application-title = Uppdateringar för { -brand-short-name }
update-application-description = Håll { -brand-short-name } uppdaterad för bästa prestanda, stabilitet och säkerhet.
update-application-version = Version { $version } <a data-l10n-name="learn-more">Vad är nytt</a>
update-history =
    .label = Visa uppdateringshistorik…
    .accesskey = p
update-application-allow-description = Tillåt { -brand-short-name } att
update-application-auto =
    .label = Installera uppdateringar automatiskt (rekommenderas)
    .accesskey = a
update-application-check-choose =
    .label = Sök efter uppdateringar, men låt mig välja om jag vill installera dem
    .accesskey = S
update-application-manual =
    .label = Sök aldrig efter uppdateringar (rekommenderas inte)
    .accesskey = a
update-application-background-enabled =
    .label = När { -brand-short-name } inte körs
    .accesskey = N
update-application-warning-cross-user-setting = Den här inställningen gäller alla Windows-konton och { -brand-short-name } profiler som använder den här installationen av { -brand-short-name }.
update-application-use-service =
    .label = Använd en bakgrundstjänst för att installera uppdateringar
    .accesskey = b
update-setting-write-failure-title2 = Det gick inte att spara uppdateringsinställningar
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } stötte på ett fel och sparade inte den här ändringen. Observera att ändring av denna uppdateringsinställning kräver behörighet att skriva till filen nedan. Du eller en systemadministratör kanske kan lösa felet genom att ge användargruppen full kontroll till den här filen.
    
    Det gick inte att skriva till filen: { $path }
update-in-progress-title = Uppdatering pågår
update-in-progress-message = Vill du att { -brand-short-name } ska fortsätta med denna uppdatering?
update-in-progress-ok-button = &Ignorera
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortsätt

## General Section - Performance

performance-title = Prestanda
performance-use-recommended-settings-checkbox =
    .label = Använd rekommenderade prestandainställningar
    .accesskey = A
performance-use-recommended-settings-desc = Dessa inställningar är anpassade till din dators hårdvara och operativsystem.
performance-settings-learn-more = Läs mer
performance-allow-hw-accel =
    .label = Använd om möjligt hårdvaruacceleration
    .accesskey = ä
performance-limit-content-process-option = Gräns för innehållsprocesser
    .accesskey = G
performance-limit-content-process-enabled-desc = Ytterligare innehållsprocesser kan förbättra prestanda när du använder flera flikar, men kommer också att använda mer minne.
performance-limit-content-process-blocked-desc = Ändring av antalet innehållsprocesser är endast möjligt med multiprocess { -brand-short-name }. <a data-l10n-name="learn-more">Lär dig hur du kontrollerar om multiprocess är aktiverat</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (standard)

## General Section - Browsing

browsing-title = Webbläsning
browsing-use-autoscroll =
    .label = Använd autorullning
    .accesskey = n
browsing-use-smooth-scrolling =
    .label = Använd mjuk rullning
    .accesskey = m
browsing-use-onscreen-keyboard =
    .label = Visa ett pektangentbord vid behov
    .accesskey = t
browsing-use-cursor-navigation =
    .label = Använd alltid piltangenterna för att navigera i sidor
    .accesskey = A
browsing-search-on-start-typing =
    .label = Sök efter text när jag börjar skriva
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Aktivera videokontroller för bild-i-bild
    .accesskey = A
browsing-picture-in-picture-learn-more = Läs mer
browsing-media-control =
    .label = Styr media via tangentbord, headset eller virtuellt gränssnitt
    .accesskey = v
browsing-media-control-learn-more = Läs mer
browsing-cfr-recommendations =
    .label = Rekommendera tillägg när du surfar
    .accesskey = R
browsing-cfr-features =
    .label = Rekommendera funktioner medan du surfar
    .accesskey = f
browsing-cfr-recommendations-learn-more = Läs mer

## General Section - Proxy

network-settings-title = Nätverksinställningar
network-proxy-connection-description = Konfigurera hur { -brand-short-name } ansluter till internet.
network-proxy-connection-learn-more = Läs mer
network-proxy-connection-settings =
    .label = Inställningar…
    .accesskey = n

## Home Section

home-new-windows-tabs-header = Nya fönster och flikar
home-new-windows-tabs-description2 = Välj vad du ser när du öppnar din startsida, ett nytt fönster eller en ny flik.

## Home Section - Home Page Customization

home-homepage-mode-label = Startsida och nya fönster
home-newtabs-mode-label = Nya flikar
home-restore-defaults =
    .label = Återställ standard
    .accesskey = t
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Waterfox startsida (standard)
home-mode-choice-custom =
    .label = Anpassade webbadresser...
home-mode-choice-blank =
    .label = Tom sida
home-homepage-custom-url =
    .placeholder = Klistra in en webbadress…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Använd aktuell sida
           *[other] Använd aktuella sidor
        }
    .accesskey = u
choose-bookmark =
    .label = Använd bokmärke…
    .accesskey = d

## Home Section - Waterfox Home Content Customization

home-prefs-content-header = Innehåll Waterfox-startsida
home-prefs-content-description = Välj vilket innehåll du vill ha på din startsida i Waterfox.
home-prefs-search-header =
    .label = Webbsök
home-prefs-topsites-header =
    .label = Mest besökta
home-prefs-topsites-description = Sidorna du besöker mest
home-prefs-topsites-by-option-sponsored =
    .label = Sponsrade toppwebbplatser
home-prefs-shortcuts-header =
    .label = Genvägar
home-prefs-shortcuts-description = Webbplatser du sparar eller besöker
home-prefs-shortcuts-by-option-sponsored =
    .label = Sponsrade genvägar

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Rekommenderas av { $provider }
home-prefs-recommended-by-description-update = Exceptionellt innehåll från hela internet, sammanställt av { $provider }
home-prefs-recommended-by-description-new = Särskilt innehåll valt av { $provider }, en del av familjen { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Hur fungerar det
home-prefs-recommended-by-option-sponsored-stories =
    .label = Sponsrade berättelser
home-prefs-highlights-header =
    .label = Höjdpunkter
home-prefs-highlights-description = Ett urval av sidor du har sparat eller besökt
home-prefs-highlights-option-visited-pages =
    .label = Besökta sidor
home-prefs-highlights-options-bookmarks =
    .label = Bokmärken
home-prefs-highlights-option-most-recent-download =
    .label = Senaste nedladdning
home-prefs-highlights-option-saved-to-pocket =
    .label = Sidor sparade till { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Senaste aktivitet
home-prefs-recent-activity-description = Ett urval av senaste webbplatser och innehåll
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Kort information
home-prefs-snippets-description = Uppdateringar från { -vendor-short-name } och { -brand-product-name }
home-prefs-snippets-description-new = Tips och nyheter från { -vendor-short-name } och { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } rad
           *[other] { $num } rader
        }

## Search Section

search-bar-header = Sökfält
search-bar-hidden =
    .label = Använd adressfältet för sökning och navigering
search-bar-shown =
    .label = Lägg till sökfältet i verktygsfältet
search-engine-default-header = Standard sökmotor
search-engine-default-desc-2 = Detta är din standardsökmotor i adressfältet och sökfältet. Du kan byta när som helst.
search-engine-default-private-desc-2 = Välj en annan standardsökmotor endast för privata fönster
search-separate-default-engine =
    .label = Använd den här sökmotorn i privata fönster
    .accesskey = A
search-suggestions-header = Sökförslag
search-suggestions-desc = Välj hur förslag från sökmotorer ska visas.
search-suggestions-option =
    .label = Ge sökförslag
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = Visa sökförslag i adressfältets resultat
    .accesskey = f
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Visa sökförslag före surfhistoriken i adressfältets resultat
search-show-suggestions-private-windows =
    .label = Visa sökförslag i privata fönster
suggestions-addressbar-settings-generic2 = Ändra inställningar för andra förslag i adressfältet
search-suggestions-cant-show = Sökförslag kommer inte att visas i adressfältet eftersom du har konfigurerat { -brand-short-name } att aldrig spara historik.
search-one-click-header2 = Sökgenvägar
search-one-click-desc = Välj alternativa sökmotorer som visas under adressfältet och sökfältet när du börjar skriva in ett nyckelord.
search-choose-engine-column =
    .label = Sökmotor
search-choose-keyword-column =
    .label = Nyckelord
search-restore-default =
    .label = Återställ standard sökmotorer
    .accesskey = D
search-remove-engine =
    .label = Ta bort
    .accesskey = T
search-add-engine =
    .label = Lägg till
    .accesskey = L
search-find-more-link = Hitta fler sökmotorer
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Duplicera nyckelord
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Du har valt ett nyckelord som redan används av “{ $name }”. Var god välj ett annat.
search-keyword-warning-bookmark = Du har valt ett nyckelord som redan används av ett bokmärke. Var god välj ett annat.

## Containers Section

containers-back-button2 =
    .aria-label = Tillbaka till inställningar
containers-header = Innehållsflikar
containers-add-button =
    .label = Lägg till ny behållare
    .accesskey = L
containers-new-tab-check =
    .label = Välj en behållare för varje ny flik
    .accesskey = V
containers-settings-button =
    .label = Inställningar
containers-remove-button =
    .label = Ta bort

## Waterfox Account - Signed out. Note that "Sync" and "Waterfox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Ta med dig webben
sync-signedout-description2 = Synkronisera dina bokmärken, historik, flikar, lösenord, tillägg och inställningar på alla dina enheter.
sync-signedout-account-signin3 =
    .label = Logga in för att synkronisera…
    .accesskey = L
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Hämta Waterfox för <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> eller <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> för att synkronisera med din mobila enhet.

## Waterfox Account - Signed in

sync-profile-picture =
    .tooltiptext = Ändra profilbild
sync-sign-out =
    .label = Logga ut…
    .accesskey = g
sync-manage-account = Hantera konto
    .accesskey = o
sync-signedin-unverified = { $email } är inte verifierat.
sync-signedin-login-failure = Logga in för att återansluta { $email }
sync-resend-verification =
    .label = Skicka verifiering igen
    .accesskey = g
sync-remove-account =
    .label = Ta bort konto
    .accesskey = T
sync-sign-in =
    .label = Logga in
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = Synkronisering: PÅ
prefs-syncing-off = Synkronisering: AV
prefs-sync-turn-on-syncing =
    .label = Aktivera synkronisering…
    .accesskey = A
prefs-sync-offer-setup-label2 = Synkronisera dina bokmärken, historik, flikar, lösenord, tillägg och inställningar på alla dina enheter.
prefs-sync-now =
    .labelnotsyncing = Synkronisera nu
    .accesskeynotsyncing = n
    .labelsyncing = Synkroniserar…

## The list of things currently syncing.

sync-currently-syncing-heading = Du synkroniserar för närvarande dessa objekt:
sync-currently-syncing-bookmarks = Bokmärken
sync-currently-syncing-history = Historik
sync-currently-syncing-tabs = Öppna flikar
sync-currently-syncing-logins-passwords = Inloggningar och lösenord
sync-currently-syncing-addresses = Adresser
sync-currently-syncing-creditcards = Kreditkort
sync-currently-syncing-addons = Tillägg
sync-currently-syncing-settings = Inställningar
sync-change-options =
    .label = Ändra…
    .accesskey = n

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Välj vad som ska synkas
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Spara ändringar
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Koppla ner…
    .buttonaccesskeyextra2 = K
sync-engine-bookmarks =
    .label = Bokmärken
    .accesskey = B
sync-engine-history =
    .label = Historik
    .accesskey = o
sync-engine-tabs =
    .label = Öppna flikar
    .tooltiptext = En lista över vad som är öppet på alla synkroniserade enheter
    .accesskey = f
sync-engine-logins-passwords =
    .label = Inloggningar och lösenord
    .tooltiptext = Användarnamn och lösenord du har sparat
    .accesskey = n
sync-engine-addresses =
    .label = Adresser
    .tooltiptext = Postadresser du har sparat (endast skrivbord)
    .accesskey = e
sync-engine-creditcards =
    .label = Kreditkort
    .tooltiptext = Namn, nummer och utgångsdatum (endast skrivbord)
    .accesskey = K
sync-engine-addons =
    .label = Tillägg
    .tooltiptext = Tillägg och teman för Waterfox skrivbord
    .accesskey = T
sync-engine-settings =
    .label = Inställningar
    .tooltiptext = Allmänna, sekretess- och säkerhetsinställningar som du har ändrat
    .accesskey = s

## The device name controls.

sync-device-name-header = Enhetens namn
sync-device-name-change =
    .label = Ändra enhetsnamn…
    .accesskey = n
sync-device-name-cancel =
    .label = Avbryt
    .accesskey = v
sync-device-name-save =
    .label = Spara
    .accesskey = S
sync-connect-another-device = Anslut en annan enhet

## Privacy Section

privacy-header = Webbläsarintegritet

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Inloggningar & lösenord
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Fråga för att spara inloggningar och lösenord för webbplatser
    .accesskey = F
forms-exceptions =
    .label = Undantag…
    .accesskey = d
forms-generate-passwords =
    .label = Föreslå och skapa starka lösenord
    .accesskey = r
forms-breach-alerts =
    .label = Visa varningar om lösenord för webbplatser med intrång
    .accesskey = V
forms-breach-alerts-learn-more-link = Läs mer
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Autofyll inloggningar och lösenord
    .accesskey = A
forms-saved-logins =
    .label = Sparade inloggningar…
    .accesskey = l
forms-primary-pw-use =
    .label = Använd ett huvudlösenord
    .accesskey = A
forms-primary-pw-learn-more-link = Läs mer
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Byt huvudlösenord…
    .accesskey = B
forms-primary-pw-change =
    .label = Ändra huvudlösenord…
    .accesskey = h
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Du är för närvarande i FIPS-läge. FIPS kräver ett huvudlösenord.
forms-master-pw-fips-desc = Ändring av lösenordet misslyckades
forms-windows-sso =
    .label = Tillåt Windows enkel inloggning för Microsoft-, arbets- och skolkonton.
forms-windows-sso-learn-more-link = Läs mer
forms-windows-sso-desc = Hantera konton i dina enhetsinställningar

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = För att skapa ett huvudlösenord anger du dina inloggningsuppgifter för Windows. Detta skyddar dina kontons säkerhet.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = skapa ett huvudlösenord
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
history-remember-label = { -brand-short-name } kommer att
    .accesskey = m
history-remember-option-all =
    .label = Spara historik
history-remember-option-never =
    .label = Inte spara någon historik
history-remember-option-custom =
    .label = Använda anpassade inställningar för historik
history-remember-description = { -brand-short-name } kommer att spara information om besökta webbsidor, filhämtningar, formulär- och sökhistorik.
history-dontremember-description = { -brand-short-name } kommer att använda samma inställningar som för privat surfning och kommer inte att spara någon historik när du surfar.
history-private-browsing-permanent =
    .label = Använd alltid läget privat surfning
    .accesskey = A
history-remember-browser-option =
    .label = Kom ihåg surf- och nedladdningshistorik
    .accesskey = m
history-remember-search-option =
    .label = Spara sök- och formulärhistorik
    .accesskey = ö
history-clear-on-close-option =
    .label = Rensa historiken när { -brand-short-name } avslutas
    .accesskey = R
history-clear-on-close-settings =
    .label = Inställningar…
    .accesskey = n
history-clear-button =
    .label = Rensa historik…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Kakor och webbplatsdata
sitedata-total-size-calculating = Beräkning av webbplatsdata och cachestorlek…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Dina lagrade kakor, webbplatsdata och cache använder för tillfället { $value } { $unit } diskutrymme.
sitedata-learn-more = Läs mer
sitedata-delete-on-close =
    .label = Ta bort kakor och webbplatsdata när { -brand-short-name } stängs
    .accesskey = k
sitedata-delete-on-close-private-browsing = I permanent privat surfläge raderas alltid kakor och webbplatsdata när { -brand-short-name } är stängd.
sitedata-allow-cookies-option =
    .label = Tillåt kakor och webbplatsdata
    .accesskey = T
sitedata-disallow-cookies-option =
    .label = Blockera kakor och webbplatsdata
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Typ blockerad
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Globala spårare
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Globala och sociala medie-spårare
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Globala spårningskakor — inkluderar kakor på sociala medier
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Globala kakor — inkluderar kakor på sociala medier
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Globala spårare på webbplatsen och sociala medier och isolera kvarvarande kakor
sitedata-option-block-unvisited =
    .label = Kakor från obesökta webbplatser
sitedata-option-block-all-third-party =
    .label = Alla tredjepartskakor (kan orsaka fel på webbplatser)
sitedata-option-block-all =
    .label = Alla kakor (kommer att orsaka fel på webbplatser)
sitedata-clear =
    .label = Rensa data…
    .accesskey = R
sitedata-settings =
    .label = Hantera data…
    .accesskey = H
sitedata-cookies-exceptions =
    .label = Hantera undantag…
    .accesskey = u

## Privacy Section - Address Bar

addressbar-header = Adressfält
addressbar-suggest = När du använder adressfältet, föreslå
addressbar-locbar-history-option =
    .label = Webbläsarhistorik
    .accesskey = W
addressbar-locbar-bookmarks-option =
    .label = Bokmärken
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Öppna flikar
    .accesskey = Ö
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Genvägar
    .accesskey = G
addressbar-locbar-topsites-option =
    .label = Mest besökta
    .accesskey = T
addressbar-locbar-engines-option =
    .label = Sökmotorer
    .accesskey = m
addressbar-suggestions-settings = Ändra inställningar för förslag från sökmotorn

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Förbättrat spårningsskydd
content-blocking-section-top-level-description = Spårare följer dig runt online för att samla in information om dina surfvanor och intressen. { -brand-short-name } blockerar många av dessa spårare och andra skadliga skript.
content-blocking-learn-more = Läs mer
content-blocking-fpi-incompatibility-warning = Du använder First Party Isolation (FPI), som åsidosätter vissa av { -brand-short-name }:s kakinställningar.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Strikt
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Anpassad
    .accesskey = A

##

content-blocking-etp-standard-desc = Balanserad för skydd och prestanda. Sidor laddas normalt.
content-blocking-etp-strict-desc = Starkare skydd, men kan leda till att vissa webbplatser eller innehåll inte fungerar.
content-blocking-etp-custom-desc = Välj vilka spårare och skript som ska blockeras.
content-blocking-etp-blocking-desc = { -brand-short-name } blockerar följande:
content-blocking-private-windows = Spårningsinnehåll i privat fönster
content-blocking-cross-site-cookies-in-all-windows = Globala kakor i alla fönster (inkluderar spårningskakor)
content-blocking-cross-site-tracking-cookies = Globala spårningskakor
content-blocking-all-cross-site-cookies-private-windows = Globala kakor i privata fönster
content-blocking-cross-site-tracking-cookies-plus-isolate = Globala spårningskakor och isolera kvarvarande kakor
content-blocking-social-media-trackers = Sociala media-spårare
content-blocking-all-cookies = Alla kakor
content-blocking-unvisited-cookies = Kakor från obesökta webbplatser
content-blocking-all-windows-tracking-content = Spårningsinnehåll i alla fönster
content-blocking-all-third-party-cookies = Alla kakor från tredje part
content-blocking-cryptominers = Kryptogrävare
content-blocking-fingerprinters = Fingeravtrycksspårare
content-blocking-warning-title = Se upp!
content-blocking-and-isolating-etp-warning-description = Blockering av spårare och isolering av kakor kan påverka funktionaliteten på vissa webbplatser. Ladda om en sida med spårare för att ladda allt innehåll.
content-blocking-and-isolating-etp-warning-description-2 = Denna inställning kan göra att vissa webbplatser inte visar innehåll eller fungerar korrekt. Om en webbplats verkar trasig kanske du vill inaktivera spårningsskydd för den webbplatsen för att ladda allt innehåll.
content-blocking-warning-learn-how = Lär dig hur
content-blocking-reload-description = Du måste ladda om dina flikar för att kunna tillämpa ändringarna.
content-blocking-reload-tabs-button =
    .label = Ladda om alla flikar
    .accesskey = L
content-blocking-tracking-content-label =
    .label = Spårningsinnehåll
    .accesskey = i
content-blocking-tracking-protection-option-all-windows =
    .label = I alla fönster
    .accesskey = a
content-blocking-option-private =
    .label = Endast i privata fönster
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Ändra blockeringslista
content-blocking-cookies-label =
    .label = Kakor
    .accesskey = K
content-blocking-expand-section =
    .tooltiptext = Mer information
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Kryptogrävare
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Fingeravtrycksspårare
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Hantera undantag…
    .accesskey = n

## Privacy Section - Permissions

permissions-header = Rättigheter
permissions-location = Plats
permissions-location-settings =
    .label = Inställningar…
    .accesskey = t
permissions-xr = Virtuell verklighet
permissions-xr-settings =
    .label = Inställningar…
    .accesskey = t
permissions-camera = Kamera
permissions-camera-settings =
    .label = Inställningar…
    .accesskey = t
permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Inställningar…
    .accesskey = t
permissions-notification = Aviseringar
permissions-notification-settings =
    .label = Inställningar…
    .accesskey = t
permissions-notification-link = Läs mer
permissions-notification-pause =
    .label = Pausa aviseringar tills { -brand-short-name } startar om
    .accesskey = v
permissions-autoplay = Automatisk uppspelning
permissions-autoplay-settings =
    .label = Inställningar…
    .accesskey = n
permissions-block-popups =
    .label = Blockera popup-fönster
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Undantag…
    .accesskey = U
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Undantag…
    .accesskey = U
    .searchkeywords = popup-fönster
permissions-addon-install-warning =
    .label = Varna när webbplatser försöker installera tillägg
    .accesskey = V
permissions-addon-exceptions =
    .label = Undantag…
    .accesskey = U

## Privacy Section - Data Collection

collection-header = Datainsamling och användning för { -brand-short-name }
collection-description = Vi strävar alltid efter att ge dig val och samlar endast in vad vi behöver för tillhandahålla och förbättra { -brand-short-name } för alla. Vi ber alltid om tillåtelse innan vi tar emot personliga uppgifter.
collection-privacy-notice = Sekretesspolicy
collection-health-report-telemetry-disabled = Du tillåter inte längre { -vendor-short-name } att fånga in teknisk data och interaktionsdata. All tidigare data kommer att raderas inom 30 dagar.
collection-health-report-telemetry-disabled-link = Läs mer
collection-health-report =
    .label = Tillåt { -brand-short-name } att automatiskt skicka teknisk och interaktionsdata till { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Läs mer
collection-studies =
    .label = Tillåt { -brand-short-name } att installera och köra studier
collection-studies-link = Visa { -brand-short-name }-studier
addon-recommendations =
    .label = Tillåt { -brand-short-name } att göra personliga utökningsrekommendationer
addon-recommendations-link = Läs mer
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datarapportering är inaktiverad för den här byggkonfigurationen
collection-backlogged-crash-reports-with-link = Tillåt { -brand-short-name } att skicka eftersläpande felrapporter för din räkning <a data-l10n-name="crash-reports-link">Läs mer</a>
    .accesskey = f

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Säkerhet
security-browsing-protection = Skydd mot vilseledande och skadlig programvara
security-enable-safe-browsing =
    .label = Blockera farligt och vilseledande innehåll
    .accesskey = B
security-enable-safe-browsing-link = Läs mer
security-block-downloads =
    .label = Blockera farliga hämtningar
    .accesskey = f
security-block-uncommon-software =
    .label = Varna mig om oönskad och ovanlig mjukvara
    .accesskey = m

## Privacy Section - Certificates

certs-header = Certifikat
certs-enable-ocsp =
    .label = Fråga OCSP responder-servrar för att bekräfta certifikatens aktuella giltighet
    .accesskey = F
certs-view =
    .label = Visa certifikat…
    .accesskey = c
certs-devices =
    .label = Säkerhetsenheter…
    .accesskey = e
space-alert-over-5gb-settings-button =
    .label = Öppna inställningar
    .accesskey = n
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } håller på att få slut på diskutrymme.</strong> Webbplatsens innehåll kanske inte visas korrekt. Du kan rensa lagrad data i Inställningar>Sekretess & säkerhet>Kakor och webbplatsdata.
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } håller på att få slut på diskutrymme.</strong> Webbplatsens innehåll kanske inte visas korrekt. Besök "Läs mer" för att optimera din diskanvändning för bättre surfupplevelse.

## Privacy Section - HTTPS-Only

httpsonly-header = Endast HTTPS-läge
httpsonly-description = HTTPS ger en säker, krypterad anslutning mellan { -brand-short-name } och de webbplatser du besöker. De flesta webbplatser stöder HTTPS och om endast HTTPS-läget är aktiverat kommer { -brand-short-name } att uppgradera alla anslutningar till HTTPS.
httpsonly-learn-more = Läs mer
httpsonly-radio-enabled =
    .label = Aktivera endast HTTPS-läge i alla fönster
httpsonly-radio-enabled-pbm =
    .label = Aktivera endast HTTPS-läge i privata fönster
httpsonly-radio-disabled =
    .label = Aktivera inte endast HTTPS-läge

## The following strings are used in the Download section of settings

desktop-folder-name = Skrivbord
downloads-folder-name = Filhämtningar
choose-download-folder-title = Välj mapp för hämtade filer:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Spara filer till { $service-name }
