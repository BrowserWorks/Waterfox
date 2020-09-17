# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Websedłam signal “Njeslědowaś” pósłaś, až njocośo, až wóne was slěduju
do-not-track-learn-more = Dalšne informacije
do-not-track-option-default-content-blocking-known =
    .label = Janog gaž w { -brand-short-name } jo blokěrowanje znatych pśeslědowakow  nastajone
do-not-track-option-always =
    .label = Pśecej
pref-page-title =
    { PLATFORM() ->
        [windows] Nastajenja
       *[other] Nastajenja
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
            [windows] W nastajenjach pytaś
           *[other] W nastajenjach pytaś
        }
managed-notice = Waš wobglědowak se wót wašeje organizacije zastoj.
pane-general-title = Powšykne
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Startowy bok
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Pytaś
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Priwatnosć a wěstota
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = Eksperimenty { -brand-short-name }
category-experimental =
    .tooltiptext = Eksperimenty { -brand-short-name }
pane-experimental-subtitle = Z glědanim pókšacowaś
pane-experimental-search-results-header = Eksperimenty { -brand-short-name }: pókšacujśo z glědanim
pane-experimental-description = Gaž nastajenja rozšyrjoneje konfiguracije změnijośo, móžo to wugbaśe abo wěstotu { -brand-short-name } wobwliwowaś.
help-button-label = Pomoc { -brand-short-name }
addons-button-label = Rozšyrjenja a drastwy
focus-search =
    .key = f
close-button =
    .aria-label = Zacyniś

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } musy se znowego startowaś, aby se toś ta funkcija zmóžniła.
feature-disable-requires-restart = { -brand-short-name } musy se znowego startowaś, aby se toś ta funkcija znjemóžniła.
should-restart-title = { -brand-short-name } znowego startowaś
should-restart-ok = { -brand-short-name } něnto znowego startowaś
cancel-no-restart-button = Pśetergnuś
restart-later = Pózdźej znowego startowaś

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
extension-controlled-homepage-override = Rozšyrjenje <img data-l10n-name="icon"/> { $name } waš startowy bok wóźi.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Rozšyrjenje <img data-l10n-name="icon"/> { $name } waš bok nowego rejtarika wóźi.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Rozšyrjenje, <img data-l10n-name="icon"/> { $name }, toś to nastajenje kontrolěrujo.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Rozšyrjenje, <img data-l10n-name="icon"/> { $name }, toś to nastajenje wóźi.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Rozšyrjenje, <img data-l10n-name="icon"/> { $name }, jo wašu standardnu pytnicu nastajiło.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Rozšyrjenje, <img data-l10n-name="icon"/> { $name }, se kontejnerowe rejtariki pomina.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Rozšyrjenje, <img data-l10n-name="icon"/> { $name }, toś to nastajenje kontrolěrujo.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Rozšěrjenje <img data-l10n-name="icon"/> { $name } wóźi, kak { -brand-short-name } z internetom zwězujo.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Aby rozšěrjenje zmóžnił, pśejźćo k <img data-l10n-name="addons-icon"/> dodankam w <img data-l10n-name="menu-icon"/> meniju.

## Preferences UI Search Results

search-results-header = Pytańske wuslědki
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Bóžko žedne wuslědki njejsu w nastajenjach za “<span data-l10n-name="query"></span>”.
       *[other] Bóžko žedne wuslědki njejsu w nastajenjach za “<span data-l10n-name="query"></span>”.
    }
search-results-help-link = Trjebaśo pomoc? Woglědajśo k <a data-l10n-name="url">Pomoc za { -brand-short-name }</a>

## General Section

startup-header = Startowaś
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } a Firefox dowóliś, rownocasnje běžaś
use-firefox-sync = Tip: To wužywa separatne profile. Wužywajśo { -sync-brand-short-name }, aby daty mjazy nimi źělił.
get-started-not-logged-in = Se pla { -sync-brand-short-name } pśizjawiś…
get-started-configured = Nastajenja { -sync-brand-short-name } wócyniś
always-check-default =
    .label = Pśecej kontrolěrowaś, lěc { -brand-short-name } jo waš standardny wobglědowak
    .accesskey = c
is-default = { -brand-short-name } jo tuchylu waš standardny wobglědowak
is-not-default = { -brand-short-name } njejo waš standardny wobglědowak
set-as-my-default-browser =
    .label = K standardoju cyniś…
    .accesskey = s
startup-restore-previous-session =
    .label = Pjerwjejšne pósejźenje wótnowiś
    .accesskey = t
startup-restore-warn-on-quit =
    .label = Warnowaś, gaž se wobglědowak kóńcy
disable-extension =
    .label = Rozšyrjenje znjemóžniś
tabs-group-header = Rejtariki
ctrl-tab-recently-used-order =
    .label = Strg+Tab pśejźo rejtariki pó tuchylu póstajonem pórěźe
    .accesskey = T
open-new-link-as-tabs =
    .label = Wótkaze w rejtarikach město nowych woknow wócyniś
    .accesskey = r
warn-on-close-multiple-tabs =
    .label = Warnowaś, gaž někotare rejtariki se zacynjaju
    .accesskey = W
warn-on-open-many-tabs =
    .label = Warnowaś, gaby wócynjanje někotarych rejtarikow mógło { -brand-short-name } spomałšyś
    .accesskey = k
switch-links-to-new-tabs =
    .label = Ned k rejtarikoju  pśejś, w kótaremž se wótkaz wócynja
    .accesskey = N
show-tabs-in-taskbar =
    .label = Rejtarikowe pśeglědy we Windowsowej nadawkowej rědce pokazaś
    .accesskey = R
browser-containers-enabled =
    .label = Kontejnerowe rejtariki zmóžniś
    .accesskey = m
browser-containers-learn-more = Dalšne informacije
browser-containers-settings =
    .label = Nastajenja…
    .accesskey = s
containers-disable-alert-title = Wše kontejnerowe rejtariki zacyniś?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Jolic znjemóžnjaśo něnto kontejnerowe rejtariki, se { $tabCount } kontejnerowy rejtarik zacynijo. Cośo kontejnerowe rejtariki napšawdu znjemóžniś?
        [two] Jolic znjemóžnjaśo něnto kontejnerowe rejtariki, se { $tabCount } kontejnerowej rejtarika zacynijotej. Cośo kontejnerowe rejtariki napšawdu znjemóžniś?
        [few] Jolic znjemóžnjaśo něnto kontejnerowe rejtariki, se { $tabCount } kontejnerowe rejtariki zacyniju. Cośo kontejnerowe rejtariki napšawdu znjemóžniś?
       *[other] Jolic znjemóžnjaśo něnto kontejnerowe rejtariki, se { $tabCount } kontejnerowych rejtarikow zacynijo. Cośo kontejnerowe rejtariki napšawdu znjemóžniś?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } kontejnerowy rejtarik zacyniś
        [two] { $tabCount } kontejnerowej rejtarika zacyniś
        [few] { $tabCount } kontejnerowe rejtariki zacyniś
       *[other] { $tabCount } kontejnerowych rejtarikow zacyniś
    }
containers-disable-alert-cancel-button = Zmóžnjone wóstajiś
containers-remove-alert-title = Toś ten kontejner wótwónoźeś?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Jolic wotwónoźijośo toś ten kontejner něnto, se { $count } kontejnerowy rejtarik zacynijo. Cosó toś ten kontejner napšawdu wótwónoźeś?
        [two] Jolic něnto wotwónoźijośo toś ten kontejner, se { $count } kontejnerowej rejtarika zacynijotej. Cosó toś ten kontejner napšawdu wótwónoźeś?
        [few] Jolic něnto wotwónoźijośo toś ten kontejner, se { $count } kontejnerowe rejtariki zacyniju. Cosó toś ten kontejner napšawdu wótwónoźeś?
       *[other] Jolic něnto wotwónoźijośo toś ten kontejner, se { $count } kontejnerowych rejtarikow zacynijo. Cosó toś ten kontejner napšawdu wótwónoźeś?
    }
containers-remove-ok-button = Toś ten kontejner wótwónoźeś
containers-remove-cancel-button = Toś ten kontejner njewótwónoźeś

## General Section - Language & Appearance

language-and-appearance-header = Rěc a wuglěd
fonts-and-colors-header = Pisma a barwy
default-font = Standardne pismo
    .accesskey = S
default-font-size = Wjelikosć
    .accesskey = l
advanced-fonts =
    .label = Rozšyrjony…
    .accesskey = o
colors-settings =
    .label = Barwy…
    .accesskey = B
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Skalěrowanje
preferences-default-zoom = Standardne skalěrowanje
    .accesskey = S
preferences-default-zoom-value =
    .label = { $percentage } %
preferences-zoom-text-only =
    .label = Jano tekst skalěrowaś
    .accesskey = t
language-header = Rěc
choose-language-description = Wubjeŕśo swóju preferěrowanu rěc za zwobraznjenje bokow
choose-button =
    .label = Wubraś…
    .accesskey = u
choose-browser-language-description = Wubjeŕśo rěcy, kótarež se wužywaju, aby menije, powěsći a powěźeńki z { -brand-short-name } pokazali.
manage-browser-languages-button =
    .label = Alternatiwy nastajiś…
    .accesskey = l
confirm-browser-language-change-description = Startujśo { -brand-short-name } znowego, aby toś te změny nałožył
confirm-browser-language-change-button = Nałožyś a znowego startowaś
translate-web-pages =
    .label = Webwopśimjeśe pśełožowaś
    .accesskey = W
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Pśełožki wót <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Wuwześa…
    .accesskey = W
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Nastajenja wašogo źěłowego systema za „{ $localeName }“ wužywaś, aby se datumy, case, licby a měry formatěrowali.
check-user-spelling =
    .label = Pśi pisanju pšawopis kontrolěrowaś
    .accesskey = P

## General Section - Files and Applications

files-and-applications-title = Dataje a nałoženja
download-header = Ześěgnjenja
download-save-to =
    .label = Dataje składowaś do
    .accesskey = D
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Wubraś…
           *[other] Pśepytaś…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] u
           *[other] e
        }
download-always-ask-where =
    .label = Pśecej se pšašaś, źož dataje maju se składowaś
    .accesskey = P
applications-header = Nałoženja
applications-description = Wubjeŕśo, kak { -brand-short-name } ma z datajami wobchadaś, kótarež z interneta ześěgujośo abo z nałoženjami, kótarež pśi pśeglědowanju wužywaśo.
applications-filter =
    .placeholder = Datajowe typy abo nałoženja pśepytaś
applications-type-column =
    .label = Wopśimjeśowy typ
    .accesskey = W
applications-action-column =
    .label = Akcija
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = Dataja { $extension }
applications-action-save =
    .label = Dataju składowaś
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } wužywaś
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } wužywaś (standard)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Standardne nałoženje macOS wužywaś
            [windows] Standardne nałoženje Windows wužywaś
           *[other] Standardne nałoženje systema wužyiwaś
        }
applications-use-other =
    .label = Druge wužywaś…
applications-select-helper = Pomocne nałoženje wubraś
applications-manage-app =
    .label = Drobnostki nałoženja…
applications-always-ask =
    .label = Pśecej se pšašaś
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
    .label = { $plugin-name } wužywaś (w { -brand-short-name })
applications-open-inapp =
    .label = W { -brand-short-name } wócyniś

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

drm-content-header = Wopśimjeśe Digital Right Management (DRM)
play-drm-content =
    .label = Wopśimjeśe wóźony pśez DRM wótgraś
    .accesskey = m
play-drm-content-learn-more = Dalšne informacije
update-application-title = Aktualizacije { -brand-short-name }
update-application-description = Źaržćo { -brand-short-name } aktualny, za nejlěpše wugbaśe, stabilnosć a wěstotu.
update-application-version = Wersija { $version } <a data-l10n-name="learn-more">Nowe funkcije a změny</a>
update-history =
    .label = Aktualizacisku historiju pokazaś…
    .accesskey = h
update-application-allow-description = { -brand-short-name } dowóliś,
update-application-auto =
    .label = Aktualizacije awtomatiski instalěrowaś (dopórucone)
    .accesskey = A
update-application-check-choose =
    .label = Za aktualizacijami pytaś, ale do togo se pšašaś, lěc maju se instalěrowaś
    .accesskey = Z
update-application-manual =
    .label = Nigda za aktualizacijami njepytaś (njepśiraźijo se)
    .accesskey = i
update-application-warning-cross-user-setting = Toś to nastajenje se na wšykne konta Windows a profile { -brand-short-name } nałožujo, kótarež toś tu instalaciju { -brand-short-name } wužywaju.
update-application-use-service =
    .label = Slězynowu słužbu za instalěrowanje aktualizacijow wužywaś
    .accesskey = S
update-setting-write-failure-title = Zmólka pśi składowanju aktualizěrowańskich nastajenjow
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } jo starcył na zmólku a njejo toś tu změnu składł. Źiwajśo na to, až se toś to aktualizěrowańske nastajenje pisańske pšawo za slědujucu dataju pomina. Wy abo systemowy administrator móžotej zmólku pórěźiś, gaž wužywaŕskej kupce połnu kontrolu nad toś teju dataju dajotej.
    
    Njedajo se do dataje pisaś: { $path }
update-in-progress-title = Aktualizacija běžy
update-in-progress-message = Cośo, až { -brand-short-name } z toś teju aktualizaciju pókšacujo?
update-in-progress-ok-button = &Zachyśiś
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Dalej

## General Section - Performance

performance-title = Wugbaśe
performance-use-recommended-settings-checkbox =
    .label = Dopórucone wugbaśowe nastajenja wužywaś
    .accesskey = D
performance-use-recommended-settings-desc = Toś te nastajenja su na hardwaru a źěłowy system wašogo licadła pśiměrjone.
performance-settings-learn-more = Dalšne informacije
performance-allow-hw-accel =
    .label = Hardwarowe póspěšenje wužywaś, jolic k dispoziciji
    .accesskey = H
performance-limit-content-process-option = Limit wopśimjeśowego procesa
    .accesskey = L
performance-limit-content-process-enabled-desc = Wěcej wopśimjeśowych procesow móžo wugbaśe pólěpšowaś, gaž se někotare rejtariki wužywaju, buźo pak teke wěcej składa pśetrjebowaś.
performance-limit-content-process-blocked-desc = Licba wopśimjeśowych procesow dajo se jano z wěcejprocesowym { -brand-short-name } změniś. <a data-l10n-name="learn-more">Zgóńśo, kak móžośo kontrolěrowaś, lěc wěcejprocesowa funkcija jo zmóžnjona</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (standard)

## General Section - Browsing

browsing-title = Pśeglědowanje
browsing-use-autoscroll =
    .label = Awtomatiske pśesuwanje wužywaś
    .accesskey = A
browsing-use-smooth-scrolling =
    .label = Pólažke pśesuwanje wužywaś
    .accesskey = l
browsing-use-onscreen-keyboard =
    .label = Dotykańsku tastaturu pokazaś, jolic trěbne
    .accesskey = k
browsing-use-cursor-navigation =
    .label = Pśecej kursorowe tasty za pógibowanje na bokach wužywaś
    .accesskey = k
browsing-search-on-start-typing =
    .label = Pśi pisanju tekst pytaś
    .accesskey = P
browsing-picture-in-picture-toggle-enabled =
    .label = Wóźeńske elementy wideo wobraz-we-wobrazu zmóžniś
    .accesskey = W
browsing-picture-in-picture-learn-more = Dalšne informacije
browsing-cfr-recommendations =
    .label = Rozšyrjenja dopórucyś, gaž pśeglědujośo
    .accesskey = R
browsing-cfr-features =
    .label = Dopórucćo funkcije, mjaztym až pśeglědujośo
    .accesskey = f
browsing-cfr-recommendations-learn-more = Dalšne informacije

## General Section - Proxy

network-settings-title = Seśowe nastajenja
network-proxy-connection-description = Konfigurěrowaś, kak { -brand-short-name } z internetom zwězujo.
network-proxy-connection-learn-more = Dalšne informacije
network-proxy-connection-settings =
    .label = Nastajenja…
    .accesskey = N

## Home Section

home-new-windows-tabs-header = Nowe wokna a rejtariki
home-new-windows-tabs-description2 = Wubjeŕśo, což cośo wiźeś, gaž swój startowy bok, nowe wokna a nowe rejtariki wócynjaśo.

## Home Section - Home Page Customization

home-homepage-mode-label = Startowy bok a nowe wokna
home-newtabs-mode-label = Nowe rejtariki
home-restore-defaults =
    .label = Standard wótnowiś
    .accesskey = S
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Startowy bok Firefox (standard)
home-mode-choice-custom =
    .label = Swójske URL…
home-mode-choice-blank =
    .label = Prozny bok
home-homepage-custom-url =
    .placeholder = URL zasajźiś…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Aktualny bok wužywaś
           *[other] Aktualne boki wužywaś
        }
    .accesskey = A
choose-bookmark =
    .label = Cytańske znamje wužywaś…
    .accesskey = C

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Wopśimjeśe startowego boka Firefox
home-prefs-content-description = Wubjeŕśo, kótare wopśimjeśe cośo na swójej startowej wobrazowce Firefox měś.
home-prefs-search-header =
    .label = Webpytanje
home-prefs-topsites-header =
    .label = Nejcesćej woglědane sedła
home-prefs-topsites-description = Sedła, ku kótarymž se nejcesćej woglědujośo

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Wót { $provider } dopórucony
home-prefs-recommended-by-description-update = Wurědne wopśimjeśe z cełego weba, wubrane wót { $provider }

##

home-prefs-recommended-by-learn-more = Kak funkcioněrujo
home-prefs-recommended-by-option-sponsored-stories =
    .label = Sponsorowane tšojenja pokazaś
home-prefs-highlights-header =
    .label = Wjerški
home-prefs-highlights-description = Wuběrk websedłow, kótarež sćo składował abo se woglědał
home-prefs-highlights-option-visited-pages =
    .label = Woglědane boki
home-prefs-highlights-options-bookmarks =
    .label = Cytańske znamjenja
home-prefs-highlights-option-most-recent-download =
    .label = Nejnowše ześěgnjenje
home-prefs-highlights-option-saved-to-pocket =
    .label = Boki skłaźone do { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Kuski
home-prefs-snippets-description = Aktualizacije wót { -vendor-short-name } a { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } smužka
            [two] { $num } smužce
            [few] { $num }smužki
           *[other] { $num } smužkow
        }

## Search Section

search-bar-header = Pytańske pólo
search-bar-hidden =
    .label = Wužywajśo adresowe pólo za pytanje a nawigaciju
search-bar-shown =
    .label = Symbolowej rědce pytańske pólo pśidaś
search-engine-default-header = Standardna pytnica
search-engine-default-desc-2 = To jo waša standardna pytnica w adresowej rědce a pytańskej rědce. Móžośo je kuždy raz pśešaltowaś.
search-engine-default-private-desc-2 = Wubjeŕśo drugu standardnu pytnicu jano za priwatny modus
search-separate-default-engine =
    .label = Toś tu pytnicu w priwatnych woknach wužywaś
    .accesskey = T
search-suggestions-header = Pytańske naraźenja
search-suggestions-desc = Wubjeŕśo, kak se naraźenja z pytnicow pokazuju.
search-suggestions-option =
    .label = Pytańske naraźenja pódaś
    .accesskey = P
search-show-suggestions-url-bar-option =
    .label = Pytańske naraźenja we wuslědkach adresowego póla pokazaś
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Pytańske naraźenja pśed pśeglědowańskeju historiju we wuslědkach adresowego póla pokazaś
search-show-suggestions-private-windows =
    .label = Pytańske naraźenja w priwatnych woknach pokazaś
suggestions-addressbar-settings-generic = Nastajenja za druge naraźenja adresowego póla změniś
search-suggestions-cant-show = Pytańske naraźenja njebudu se we wuslědkach adresowego póla pokazaś, dokulaž sćo { -brand-short-name } tak konfigurěrował, až njespomnjejo se nigda historiju.
search-one-click-header = Pytnice z jadnym kliknjenim
search-one-click-desc = Wubjeŕśo alternatiwne pytnice, kótarež se pód adresowym pólom a pytańskim pólom pokazuju, gaž klucowe słowo zapódawaśo.
search-choose-engine-column =
    .label = Pytnica
search-choose-keyword-column =
    .label = Klucowe słowo
search-restore-default =
    .label = Standardne pytnice wótnowiś
    .accesskey = S
search-remove-engine =
    .label = Wótpóraś
    .accesskey = W
search-add-engine =
    .label = Pśidaś
    .accesskey = P
search-find-more-link = Dalšne pytnice pytaś
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Klucowe słowo duplicěrowaś
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Sćo klucowe słowo wubrał, kótarež wužywa se rowno wót "{ $name }". Pšosym wubjeŕśo druge.
search-keyword-warning-bookmark = Sćo klucowe słowo wubrał, kótarež wužiwa se rowno wót cytańskich znemjenjow. Pšosym wubjeŕśo druge.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Slědk k nastajenjam
           *[other] Slědk k nastajenjam
        }
containers-header = Kontejnerowe rejtariki
containers-add-button =
    .label = Nowy kontejner pśidaś
    .accesskey = k
containers-new-tab-check =
    .label = Kontejner za kuždy nowy rejtarik wubraś
    .accesskey = K
containers-preferences-button =
    .label = Nastajenja
containers-remove-button =
    .label = Wótwónoźeś

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Wzejśo swój web sobu
sync-signedout-description = Synchronizěrujśo swóje cytańske znamjenja, historiju, rejtariki, gronidła, dodanki a nastajenja mjazy wšymi wašymi rědami.
sync-signedout-account-signin2 =
    .label = Se pla { -sync-brand-short-name } pśizjawiś…
    .accesskey = l
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Firefox za <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> abo <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> ześěgnuś, aby ze swójim mobilnym rědom synchronizěrował.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Profilowy wobraz změniś
sync-sign-out =
    .label = Wótzjawiś…
    .accesskey = t
sync-manage-account = Konto zastojaś
    .accesskey = o
sync-signedin-unverified = { $email } njejo se pśeglědał.
sync-signedin-login-failure = Pšosym zregistrěrujśo se, aby znowego zwězał { $email }
sync-resend-verification =
    .label = Wobkšuśenje znowego pósłaś
    .accesskey = z
sync-remove-account =
    .label = Konto wótpóraś
    .accesskey = p
sync-sign-in =
    .label = Pśizjawiś
    .accesskey = z

## Sync section - enabling or disabling sync.

prefs-syncing-on = Synchronizacija: ZAŠALTOWANA
prefs-syncing-off = Synchronizacija: WUŠALTOWANA
prefs-sync-setup =
    .label = { -sync-brand-short-name } konfigurěrowaś
    .accesskey = k
prefs-sync-offer-setup-label = Synchronizěrujśo swóje cytańske znamjenja, historiju, rejtariki, gronidła, dodanki a nastajenja mjazy wšymi wašymi rědami.
prefs-sync-now =
    .labelnotsyncing = Něnto synchronizěrowaś
    .accesskeynotsyncing = N
    .labelsyncing = Synchronizěrujo se…

## The list of things currently syncing.

sync-currently-syncing-heading = Synchronizěrujośo tuchylu slědujuce zapiski:
sync-currently-syncing-bookmarks = Cytańske znamjenja
sync-currently-syncing-history = Historija
sync-currently-syncing-tabs = Wócynjone rejtariki
sync-currently-syncing-logins-passwords = Pśizjawjenja a gronidła
sync-currently-syncing-addresses = Adrese
sync-currently-syncing-creditcards = Kreditowe kórty
sync-currently-syncing-addons = Dodanki
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Nastajenja
       *[other] Nastajenja
    }
sync-change-options =
    .label = Změniś…
    .accesskey = Z

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Wubjeŕśo, což ma se synchronizěrowaś
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Změny składowaś
    .buttonaccesskeyaccept = s
    .buttonlabelextra2 = Źěliś
    .buttonaccesskeyextra2 = l
sync-engine-bookmarks =
    .label = Cytańske znamjenja
    .accesskey = C
sync-engine-history =
    .label = Historiju
    .accesskey = H
sync-engine-tabs =
    .label = Wócynjone rejtariki
    .tooltiptext = Lisćina ze wšym, což jo wócynjone na wšych synchronizěrowanych rědach
    .accesskey = r
sync-engine-logins-passwords =
    .label = Pśizjawjenja a gronidła
    .tooltiptext = Wužywaŕske mjenja a gronidła, kótarež sćo składł
    .accesskey = P
sync-engine-addresses =
    .label = Adrese
    .tooltiptext = Postowe adrese, kótarež sćo składł (jano desktop)
    .accesskey = e
sync-engine-creditcards =
    .label = Kreditowe kórty
    .tooltiptext = Mjenja, licby a datumy pśepadnjenja (jano desktop)
    .accesskey = K
sync-engine-addons =
    .label = Dodanki
    .tooltiptext = Rozšyrjenja a drastwy za desktopowy Firefox
    .accesskey = D
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Nastajenja
           *[other] Nastajenja
        }
    .tooltiptext = Powšykne nastajenja, nastajenja priwatnosći a wěstoty, kótarež sćo změnił
    .accesskey = N

## The device name controls.

sync-device-name-header = Mě rěda
sync-device-name-change =
    .label = Mě rěda změniś…
    .accesskey = z
sync-device-name-cancel =
    .label = Pśetergnuś
    .accesskey = t
sync-device-name-save =
    .label = Składowaś
    .accesskey = d
sync-connect-another-device = Z drugim rědom zwězaś

## Privacy Section

privacy-header = Priwatnosć wobglědowaka

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Pśizjawjenja a gronidła
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Pšašaś se, lěc se maju pśizjawjenja a gronidła składowaś
    .accesskey = a
forms-exceptions =
    .label = Wuwześa…
    .accesskey = u
forms-generate-passwords =
    .label = Mócne gronidła napóraś a naraźiś
    .accesskey = r
forms-breach-alerts =
    .label = Warnowanja za gronidła zranjonych websedłow
    .accesskey = z
forms-breach-alerts-learn-more-link = Dalšne informacije
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Pśizjawjenja a gronidła awtomatiski zapisaś
    .accesskey = i
forms-saved-logins =
    .label = Skłaźone pśizjawjenja…
    .accesskey = S
forms-master-pw-use =
    .label = Głowne gronidło wužywaś
    .accesskey = G
forms-primary-pw-use =
    .label = Głowne gronidło wužywaś
    .accesskey = G
forms-primary-pw-learn-more-link = Dalšne informacije
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Głowne gronidło změniś…
    .accesskey = m
forms-master-pw-fips-title = Sćo tuchylu we FIPS-modusu. FIPS pomina se głowne gronidło.
forms-primary-pw-change =
    .label = Głowne gronidło změniś…
    .accesskey = z
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Sćo tuchylu we FIPS-modusu. FIPS pomina se głowne gronidło.
forms-master-pw-fips-desc = Změnjanje gronidła njejo se raźiło

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Zapódajśo swóje pśizjawjeńske daty Windows, aby głowne gronidło napórał. To wěstotu wašych kontow šćita.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = głowne gronidło napóraś
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Zapódajśo swóje pśizjawjeńske daty Windows, aby głowne gronidło napórał. To wěstotu wašych kontow šćita.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = głowne gronidło napóraś
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Historija
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } buźo
    .accesskey = b
history-remember-option-all =
    .label = Se historiju spomnjeś
history-remember-option-never =
    .label = Se historiju nigda njespomnjeś
history-remember-option-custom =
    .label = Swójske nastajenja za historiju wužywaś
history-remember-description = { -brand-short-name } buźo se wašu pśeglědowańsku, ześěgnjeńsku, formularnu a pytańsku historiju spomnjeś.
history-dontremember-description = { -brand-short-name } buźo te samske nastajenja ako w priwatnem modusu wužywaś a njebuźo se historiju markowaś, gaž Web pśeglědujośo.
history-private-browsing-permanent =
    .label = Pśecej priwatny modus wužywaś
    .accesskey = p
history-remember-browser-option =
    .label = Se pśeglědowańsku a ześěgnjeńsku historiju spomnjeś
    .accesskey = m
history-remember-search-option =
    .label = Pytańsku a formularnu historiju se spomnjeś
    .accesskey = f
history-clear-on-close-option =
    .label = Historiju wuprozniś, gaž { -brand-short-name } se zacynja
    .accesskey = H
history-clear-on-close-settings =
    .label = Nastajenja…
    .accesskey = N
history-clear-button =
    .label = Historiju lašowaś…
    .accesskey = i

## Privacy Section - Site Data

sitedata-header = Cookieje a sedłowe daty
sitedata-total-size-calculating = Wjelikosć sedłowych datow a purfowaka se wulicijo…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Waše skłaźone cookieje, sedłowe daty a pufrowak se tuchylu { $value } { $unit } platowego ruma wužywaju.
sitedata-learn-more = Dalšne informacije
sitedata-delete-on-close =
    .label = Cookieje a sedłowe daty wulašowaś, gaž se { -brand-short-name } zacynja
    .accesskey = s
sitedata-delete-on-close-private-browsing = W stawnem priwatnem modusu se cookieje a sedłowe daty pśecej wulašuju, gaž se { -brand-short-name } zacynja.
sitedata-allow-cookies-option =
    .label = Cookieje a sedłowe daty akceptěrowaś
    .accesskey = C
sitedata-disallow-cookies-option =
    .label = Cookieje a sedłowe daty blokěrowaś
    .accesskey = b
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Blokěrowany typ
    .accesskey = t
sitedata-option-block-cross-site-trackers =
    .label = Pśeslědowaki mjazy sedłami
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Pśeslědowaki mjazy sedłami a socialnych medijow
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Pśeslědowaki někotarych sedłow a pśeslědowaki socialnych medijow a izolěrowanje zbytnych cookiejow
sitedata-option-block-unvisited =
    .label = Cookieje z njewoglědanych websedłow
sitedata-option-block-all-third-party =
    .label = Wšykne cookieje tśeśich (móžo zawinowaś, až websedła wěcej njefunkcioněruju)
sitedata-option-block-all =
    .label = Wšykne cookieje (móžo zawinowaś, až websedła wěcej njefunkcioněruju)
sitedata-clear =
    .label = Daty lašowaś…
    .accesskey = l
sitedata-settings =
    .label = Daty zastojaś…
    .accesskey = D
sitedata-cookies-permissions =
    .label = Pšawa zastojaś
    .accesskey = P
sitedata-cookies-exceptions =
    .label = Wuwześa zastojaś…
    .accesskey = u

## Privacy Section - Address Bar

addressbar-header = Adresowe pólo
addressbar-suggest = Pśi wužywanju adresowego póla ma se naraźiś
addressbar-locbar-history-option =
    .label = Pśeglědowańska historija
    .accesskey = g
addressbar-locbar-bookmarks-option =
    .label = Cytańske znamjenja
    .accesskey = C
addressbar-locbar-openpage-option =
    .label = Wócynjone rejtariki
    .accesskey = r
addressbar-locbar-topsites-option =
    .label = Nejcesćej woglědane sedła
    .accesskey = N
addressbar-suggestions-settings = Nastajenja za naraźenja pytnice změniś

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Pólěpšony slědowański šćit
content-blocking-section-top-level-description = Pśeslědowaki wam online slěduju, aby informacije wó wašych pśeglědowańskich zwuconosćach a zajmach gromaźili. { -brand-short-name } wjele z toś tych pśeslědowakow a druge złosne skripty blokěrujo.
content-blocking-learn-more = Dalšne informacije

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Striktny
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Swójski
    .accesskey = S

##

content-blocking-etp-standard-desc = Wuwažony za šćit a wugbaśe. Boki se normalnje zacytaju.
content-blocking-etp-strict-desc = Mócnjejšy šćit, ale móžo zawinowaś, až někotare sedła abo wopśimjeśe wěcej njefunkcioněruju.
content-blocking-etp-custom-desc = Wubjeŕśo, kótare pśeslědowaki a skripty maju se blokěrowaś.
content-blocking-private-windows = Slědujuce wopśimjeśe w priwatnych woknach
content-blocking-cross-site-tracking-cookies = Slědujuce cookieje mjazy sedłami
content-blocking-cross-site-tracking-cookies-plus-isolate = Někotare sedła slědujuce cookieje a izolěrowanje zbytnych cookiejow
content-blocking-social-media-trackers = Pśeslědowaki socialnych medijow
content-blocking-all-cookies = Wšykne cookieje
content-blocking-unvisited-cookies = Cookieje z njewoglědanych sedłow
content-blocking-all-windows-tracking-content = Slědujuce wopśimjeśe we wšych woknach
content-blocking-all-third-party-cookies = Wšykne cookieje tśeśich
content-blocking-cryptominers = Kryptokopanje
content-blocking-fingerprinters = Palcowe wótśišće
content-blocking-warning-title = Glědajśo!
content-blocking-and-isolating-etp-warning-description = Blokěrowanje pśeslědowakow a izolěrowanje plackow mógłej funkcionalnosć někotarych websedłow wobwliwowaś. Zacytajśo bok z pśeslědowakami znowego, aby wšykno wopśimjeśe zacytał.
content-blocking-warning-learn-how = Zgóńśo kak
content-blocking-reload-description = Musyśo swóje rejtariki znowego zacytaś, aby toś te změny nałožył.
content-blocking-reload-tabs-button =
    .label = Wšykne rejtariki znowego zacytaś
    .accesskey = W
content-blocking-tracking-content-label =
    .label = Slědujuce wopśimjeśe
    .accesskey = S
content-blocking-tracking-protection-option-all-windows =
    .label = We wšych woknach
    .accesskey = W
content-blocking-option-private =
    .label = Jano w priwatnych woknach
    .accesskey = J
content-blocking-tracking-protection-change-block-list = Blokěrowańsku lisćinu změniś
content-blocking-cookies-label =
    .label = Cookieje
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Dalšne informacije
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Kryptokopanje
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Palcowe wótśišće
    .accesskey = P

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Wuwześa zastojaś…
    .accesskey = u

## Privacy Section - Permissions

permissions-header = Pšawa
permissions-location = Městno
permissions-location-settings =
    .label = Nastajenja…
    .accesskey = t
permissions-xr = Wirtuelna realita
permissions-xr-settings =
    .label = Nastajenja…
    .accesskey = N
permissions-camera = Kamera
permissions-camera-settings =
    .label = Nastajenja…
    .accesskey = t
permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Nastajenja…
    .accesskey = t
permissions-notification = Powěźeńki
permissions-notification-settings =
    .label = Nastajenja…
    .accesskey = t
permissions-notification-link = Dalšne informacije
permissions-notification-pause =
    .label = Z powěźeńkami pśestaś, daniž se { -brand-short-name } znowego njestartujo
    .accesskey = z
permissions-autoplay = Awtomatiske wótgraśe
permissions-autoplay-settings =
    .label = Nastajenja…
    .accesskey = N
permissions-block-popups =
    .label = Wuskokujuce wokno blokěrowaś
    .accesskey = k
permissions-block-popups-exceptions =
    .label = Wuwześa…
    .accesskey = W
permissions-addon-install-warning =
    .label = Warnowaś, gaž sedła wopytuju dodanki instalěrowaś
    .accesskey = W
permissions-addon-exceptions =
    .label = Wuwześa…
    .accesskey = W
permissions-a11y-privacy-checkbox =
    .label = Słužbam bźezbariernosći pśistup k wašomu wobglědowakoju zawoboraś
    .accesskey = b
permissions-a11y-privacy-link = Dalšne informacije

## Privacy Section - Data Collection

collection-header = Gromaźenje a wužywanje datow { -brand-short-name }
collection-description = Comy was z wuběrkami wobstaraś a janož to zběraś, což musymy póbitowaś, aby my { -brand-short-name } za kuždego pólěpšili. Pšosymy pśecej wó dowólnosć, nježli až wósobinske daty dostanjomy.
collection-privacy-notice = Powěźeńka priwatnosći
collection-health-report-telemetry-disabled = Sćo zajmjeł { -vendor-short-name } dowólnosć, techniske a interakciske daty gromaźiś. Wšykne dotychměst zgromaźone daty se w běgu 30 dnjow wulašuju.
collection-health-report-telemetry-disabled-link = Dalšne informacije
collection-health-report =
    .label = { -brand-short-name } zmóžniś, techniske a interakciske daty na { -vendor-short-name } pósłaś
    .accesskey = t
collection-health-report-link = Dalšne informacije
collection-studies =
    .label = { -brand-short-name } dowóliś, studije instalěrowaś a pśewjasć
collection-studies-link = Studije { -brand-short-name } pokazaś
addon-recommendations =
    .label = { -brand-short-name } dowóliś, personalizěrowane pśiraźenja za rozšyrjenja daś
addon-recommendations-link = Dalšne informacije
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datowe rozpšawjenje jo znjemóžnjone za toś tu programowu konfiguraciju
collection-backlogged-crash-reports =
    .label = { -brand-short-name } dowóliś, njewobźěłane wowaleńske rozpšawy we wašom mjenju pósłaś
    .accesskey = r
collection-backlogged-crash-reports-link = Dalšne informacije

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Wěstota
security-browsing-protection = Šćit pśed wobšudnym wopśimjeśim a tšašneju softwaru
security-enable-safe-browsing =
    .label = Tšašne a wobšudnikojske wopśimjeśe blokěrowaś
    .accesskey = T
security-enable-safe-browsing-link = Dalšne informacije
security-block-downloads =
    .label = Tšašne ześěgnjenja blokěrowaś
    .accesskey = z
security-block-uncommon-software =
    .label = Pśed njewitaneju a njewšedneju softwaru warnowaś
    .accesskey = w

## Privacy Section - Certificates

certs-header = Certifikaty
certs-personal-label = Gaž serwer pomina wósobinski certifikat
certs-select-auto-option =
    .label = Awtomatiski wubraś
    .accesskey = s
certs-select-ask-option =
    .label = Kuždy raz se pšašaś
    .accesskey = K
certs-enable-ocsp =
    .label = Pla wótegronowych serwerow OCSP se napšašowaś, aby aktualnu płaśiwosć certifikatow wobkšuśiło
    .accesskey = P
certs-view =
    .label = Certifikaty pokazaś…
    .accesskey = C
certs-devices =
    .label = Wěstotne rědy…
    .accesskey = t
space-alert-learn-more-button =
    .label = Dalšne informacije
    .accesskey = D
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Nastajenja wócyniś
           *[other] Nastajenja wócyniś
        }
    .accesskey =
        { PLATFORM() ->
            [windows] N
           *[other] N
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } njama wěcej dosć składowańskego ruma. Wopśimjeśe websedła se snaź korektnje njezwobraznijo. Móžośo skłaźone daty w Nastajenja > Priwatnosć a wěstota > Cookieje a sedłowe daty lašowaś.
       *[other] { -brand-short-name } njama wěcej dosć składowańskego ruma. Wopśimjeśe websedła se snaź korektnje njezwobraznijo. Móžośo skłaźone daty w Nastajenja > Priwatnosć a wěstota > Cookieje a sedłowe daty lašowaś.
    }
space-alert-under-5gb-ok-button =
    .label = W pórěźe, som zrozměł
    .accesskey = z
space-alert-under-5gb-message = { -brand-short-name } njama wěcej dosć składowańskego ruma. Wopśimjeśe websedła se snaź korektnje njezwobraznijo. Móžośo na “Dalšne informacije” kliknuś, aby swój składowe wužyśe za lěpše pśeglědowańske dožywjenje opiměrował.

## Privacy Section - HTTPS-Only

httpsonly-header = Modus Jano-HTTPS
httpsonly-description = HTTPS wěsty, skoděrowany zwisk mjazy { -brand-short-name } a websedłami bitujo, ku kótarymž se woglědujośo. Nejwěcej websedłow HTTPS pódpěra, a jolic modus Jano-HTTPS jo zmóžnjony, { -brand-short-name } buźo wše zwiski na HTTPS aktualizěrowaś.
httpsonly-learn-more = Dalšne informacije
httpsonly-radio-enabled =
    .label = Modus Jano-HTTPS we wšych woknach zmóžniś
httpsonly-radio-enabled-pbm =
    .label = Modus Jano-HTTPS jano w priwatnych woknach zmóžniś
httpsonly-radio-disabled =
    .label = Modus Jano-HTTPS njezmóžniś

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Ześěgnjenja
choose-download-folder-title = Zarědnik ześěgnjenjow wubraś:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Dataje do { $service-name } składowaś
