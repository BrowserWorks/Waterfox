# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Trimite site-urilor web un semnal „Nu urmări” pentru a indica faptul că nu vrei să fii urmărit
do-not-track-learn-more = Află mai multe
do-not-track-option-default-content-blocking-known =
    .label = Numai când { -brand-short-name } este setat să blocheze elemente de urmărire cunoscute
do-not-track-option-always =
    .label = Întotdeauna
pref-page-title =
    { PLATFORM() ->
        [windows] Opțiuni
       *[other] Preferințe
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
            [windows] Caută în Opțiuni
           *[other] Caută în Preferințe
        }
managed-notice = Browserul este gestionat de organizația ta.
pane-general-title = General
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Pagină de start
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Căutare
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Confidențialitate și securitate
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = Experimente { -brand-short-name }
category-experimental =
    .tooltiptext = Experimente { -brand-short-name }
pane-experimental-subtitle = Procedează cu grijă
pane-experimental-search-results-header = Experimente { -brand-short-name }: Procedează cu grijă
pane-experimental-description = Modificarea preferințelor de configurare avansată poate avea impact asupra performanței sau securității { -brand-short-name }.
help-button-label = Asistență { -brand-short-name }
addons-button-label = Extensii și teme
focus-search =
    .key = f
close-button =
    .aria-label = Închide

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } trebuie să repornească pentru a activa această funcționalitate.
feature-disable-requires-restart = { -brand-short-name } trebuie să repornească pentru a dezactiva această funcționalitate.
should-restart-title = Repornire { -brand-short-name }
should-restart-ok = Repornește { -brand-short-name } acum
cancel-no-restart-button = Renunță
restart-later = Repornește mai târziu

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
extension-controlled-homepage-override = O extensie, <img data-l10n-name="icon"/> { $name }, îți controlează pagina de start.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = O extensie, <img data-l10n-name="icon"/> { $name }, controlează pagina ta de filă nouă.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Setarea este controlată de o extensie, <img data-l10n-name="icon"/> { $name }.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = O extensie, <img data-l10n-name="icon"/> { $name }, controlează această setare.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = O extensie, <img data-l10n-name="icon"/> { $name }, a schimbat motorul de căutare implicit.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = O extensie, <img data-l10n-name="icon"/> { $name }, necesită file container.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = O extensie, <img data-l10n-name="icon"/> { $name }, controlează această setare.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = O extensie, <img data-l10n-name="icon"/> { $name }, controlează modul în care { -brand-short-name } se conectează la internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Pentru a activa extensia, mergi la <img data-l10n-name="addons-icon"/>Suplimente din meniul <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Rezultatele căutării
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Ne pare rău! Nu există rezultate în Opțiuni pentru „<span data-l10n-name="query"></span>”.
       *[other] Ne pare rău! Nu există rezultate în Preferințe pentru „<span data-l10n-name="query"></span>”.
    }
search-results-help-link = Ai nevoie de ajutor? Intră pe <a data-l10n-name="url">pagina de asistență { -brand-short-name }</a>

## General Section

startup-header = Pornire
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Permite ca { -brand-short-name } și Firefox să ruleze în același timp
use-firefox-sync = Pont: Acesta folosește profiluri separate. Folosește { -sync-brand-short-name } pentru a partaja date între ele.
get-started-not-logged-in = Autentifică-te în { -sync-brand-short-name }…
get-started-configured = Deschide preferințele { -sync-brand-short-name }
always-check-default =
    .label = Verifică întotdeauna dacă { -brand-short-name } este browserul implicit
    .accesskey = y
is-default = { -brand-short-name } este în prezent browserul implicit
is-not-default = { -brand-short-name } nu este browserul implicit
set-as-my-default-browser =
    .label = Desemnează ca implicit…
    .accesskey = D
startup-restore-previous-session =
    .label = Restaurează sesiunea anterioară
    .accesskey = s
startup-restore-warn-on-quit =
    .label = Avertizează la închiderea browserului
disable-extension =
    .label = Dezactivează extensia
tabs-group-header = File
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab parcurge filele în ordinea celor mai recent folosite
    .accesskey = T
open-new-link-as-tabs =
    .label = Deschide linkuri în file în loc de ferestre noi
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = Avertizează la închiderea mai multor file
    .accesskey = m
warn-on-open-many-tabs =
    .label = Te avertizează când deschiderea mai multor file ar putea încetini { -brand-short-name }
    .accesskey = d
switch-links-to-new-tabs =
    .label = La deschiderea unui link într-o filă nouă, comută imediat pe fila respectivă
    .accesskey = C
show-tabs-in-taskbar =
    .label = Afișează previzualizări ale filelor în bara de sarcini din Windows
    .accesskey = k
browser-containers-enabled =
    .label = Activează filele container
    .accesskey = n
browser-containers-learn-more = Află mai multe
browser-containers-settings =
    .label = Setări…
    .accesskey = t
containers-disable-alert-title = Închizi toate filele container?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Dacă dezactivezi filele container acum, { $tabCount } filă container se va închide. Sigur vrei să dezactivezi filele container?
        [few] Dacă dezactivezi filele container acum, { $tabCount } file container se vor închide. Sigur vrei să dezactivezi filele container?
       *[other] Dacă dezactivezi filele container acum, { $tabCount } de file container se vor închide. Sigur vrei să dezactivezi filele container?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Închide { $tabCount } filă container
        [few] Închide { $tabCount } file container
       *[other] Închide { $tabCount } de file container
    }
containers-disable-alert-cancel-button = Păstrează activat
containers-remove-alert-title = Elimini acest container?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Dacă elimini acest container acum, { $count } filă container va fi închisă. Sigur vrei să elimini acest container?
        [few] Dacă elimini acest container acum, { $count } file container vor fi închise. Sigur vrei să elimini acest container?
       *[other] Dacă elimini acest container acum, { $count } de file container vor fi închise. Sigur vrei să elimini acest container?
    }
containers-remove-ok-button = Elimină acest container
containers-remove-cancel-button = Nu elimina acest container

## General Section - Language & Appearance

language-and-appearance-header = Limbă și aspect
fonts-and-colors-header = Fonturi și culori
default-font = Font implicit
    .accesskey = D
default-font-size = Dimensiune
    .accesskey = S
advanced-fonts =
    .label = Avansat…
    .accesskey = A
colors-settings =
    .label = Culori…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Zoom implicit
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Zoom doar pe text
    .accesskey = t
language-header = Limbă
choose-language-description = Alege limba în care preferi să vezi paginile
choose-button =
    .label = Alege…
    .accesskey = o
choose-browser-language-description = Alege limbile folosite pentru afișarea meniurilor, mesajelor și notificărilor de la { -brand-short-name }.
manage-browser-languages-button =
    .label = Setează alternative...
    .accesskey = l
confirm-browser-language-change-description = Repornește { -brand-short-name } pentru a aplica aceste modificări
confirm-browser-language-change-button = Aplică și repornește
translate-web-pages =
    .label = Tradu conținutul web
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traduceri de <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Excepții…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Folosește setările sistemului de operare în „{ $localeName }” pentru formatul datelor, orelor, numerelor și unități de măsură.
check-user-spelling =
    .label = Verifică ortografia pe măsură ce tastez
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Fișiere și aplicații
download-header = Descărcări
download-save-to =
    .label = Salvează fișierele în
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Alege…
           *[other] Răsfoiește…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }
download-always-ask-where =
    .label = Întreabă întotdeauna unde să salvez fișierele
    .accesskey = n
applications-header = Aplicații
applications-description = Alege felul în care { -brand-short-name } gestionează fișierele pe care le descarci de pe web sau aplicațiile pe care le folosești în timp ce navighezi.
applications-filter =
    .placeholder = Caută tipuri de fișiere sau aplicații
applications-type-column =
    .label = Tip de conținut
    .accesskey = T
applications-action-column =
    .label = Acțiune
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = Fișier { $extension }
applications-action-save =
    .label = Salvează fișierul
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Folosește { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Folosește { $app-name } (implicit)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Folosește aplicația implicită din macOS
            [windows] Folosește aplicația implicită din Windows
           *[other] Folosește aplicația implicită a sistemului
        }
applications-use-other =
    .label = Folosește altceva…
applications-select-helper = Selectează aplicația ajutătoare
applications-manage-app =
    .label = Detalii privind aplicația…
applications-always-ask =
    .label = Întreabă întotdeauna
applications-type-pdf = Format de document portabil (PDF)
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
    .label = Folosește { $plugin-name } (în { -brand-short-name })
applications-open-inapp =
    .label = Deschide în { -brand-short-name }

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

drm-content-header = Conținut Digital Rights Management (DRM)
play-drm-content =
    .label = Redă conținut controlat prin DRM
    .accesskey = p
play-drm-content-learn-more = Află mai multe
update-application-title = Actualizări { -brand-short-name }
update-application-description = Menține { -brand-short-name } actualizat pentru cea mai bună performanță, stabilitate și securitate.
update-application-version = Versiunea { $version } <a data-l10n-name="learn-more">Ce este nou</a>
update-history =
    .label = Afișează istoricul actualizărilor…
    .accesskey = p
update-application-allow-description = Permite ca { -brand-short-name }
update-application-auto =
    .label = Să instaleze automat actualizări (recomandat)
    .accesskey = A
update-application-check-choose =
    .label = Să caute actualizări, dar să te lase să decizi dacă le instalezi
    .accesskey = C
update-application-manual =
    .label = Să nu caute niciodată actualizări (nerecomandat)
    .accesskey = N
update-application-warning-cross-user-setting = Această setare se va aplica pentru toate conturile Windows și profilurile { -brand-short-name } care folosesc această instalare de { -brand-short-name }.
update-application-use-service =
    .label = Folosește un serviciu în fundal pentru a instala actualizări
    .accesskey = b
update-setting-write-failure-title = Eroare la salvarea preferințelor de actualizare
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } a întâmpinat o eroare și nu a salvat această modificare. Reține că setarea acestei preferințe de actualizare necesită permisiunea de a scrie în fișierul de mai jos. Poți rezolva eroarea tu sau administratorul sistemului acordând grupului de utilizatori control deplin asupra acestui fișier.
    
    Nu s-a putut scrie în fișierul: { $path }
update-in-progress-title = Actualizare în curs
update-in-progress-message = Vrei ca { -brand-short-name } să continue cu această actualizare?
update-in-progress-ok-button = Înlătură
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuă

## General Section - Performance

performance-title = Performanță
performance-use-recommended-settings-checkbox =
    .label = Folosește setările recomandate de performanță
    .accesskey = U
performance-use-recommended-settings-desc = Aceste setări sunt adaptate pentru hardware-ul și sistemul de operare al calculatorului.
performance-settings-learn-more = Află mai multe
performance-allow-hw-accel =
    .label = Folosește accelerarea hardware atunci când este disponibilă
    .accesskey = h
performance-limit-content-process-option = Limita proceselor pentru conținut
    .accesskey = L
performance-limit-content-process-enabled-desc = Procesele adiționale pentru conținut pot îmbunătăți performanța atunci când se folosesc mai multe file, însă va consuma și mai multă memorie.
performance-limit-content-process-blocked-desc = Modificarea numărului de procese pentru conținut este posibilă doar cu funcția de multiprocese din { -brand-short-name }. <a data-l10n-name="learn-more">Află cum să verifici dacă funcția de multiprocese este activată</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (implicită)

## General Section - Browsing

browsing-title = Navigare
browsing-use-autoscroll =
    .label = Folosește derularea automată
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Folosește derularea lină
    .accesskey = i
browsing-use-onscreen-keyboard =
    .label = Afișează o tastatură tactilă când este necesar
    .accesskey = k
browsing-use-cursor-navigation =
    .label = Folosește întotdeauna săgețile pentru a naviga în pagini
    .accesskey = F
browsing-search-on-start-typing =
    .label = Caută textul când încep să tastez
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Activează comenzile video picture-in-picture
    .accesskey = E
browsing-picture-in-picture-learn-more = Află mai multe
browsing-cfr-recommendations =
    .label = Recomandă extensii pe măsură ce navighezi
    .accesskey = R
browsing-cfr-features =
    .label = Funcționalități recomandate în timpul navigării
    .accesskey = f
browsing-cfr-recommendations-learn-more = Află mai multe

## General Section - Proxy

network-settings-title = Setări de rețea
network-proxy-connection-description = Configurează modul în care { -brand-short-name } se conectează la internet.
network-proxy-connection-learn-more = Află mai multe
network-proxy-connection-settings =
    .label = Setări…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = Ferestre și file noi
home-new-windows-tabs-description2 = Alege ce vezi când deschizi pagina de start, ferestre noi și file noi.

## Home Section - Home Page Customization

home-homepage-mode-label = Pagină de start și ferestre noi
home-newtabs-mode-label = File noi
home-restore-defaults =
    .label = Restaurează valorile implicite
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Pagină de start Firefox (Implicit)
home-mode-choice-custom =
    .label = URL-uri personalizate…
home-mode-choice-blank =
    .label = Pagină goală
home-homepage-custom-url =
    .placeholder = Lipește un URL…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Folosește pagina actuală
           *[other] Folosește paginile actuale
        }
    .accesskey = c
choose-bookmark =
    .label = Folosește un marcaj…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Conținutul paginii de start Firefox
home-prefs-content-description = Alege ce conținut vrei pe ecranul de start Firefox.
home-prefs-search-header =
    .label = Căutare web
home-prefs-topsites-header =
    .label = Site-uri de top
home-prefs-topsites-description = Site-urile pe care le vizitezi cel mai des

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Recomandat de { $provider }
home-prefs-recommended-by-description-update = Conținut excepțional de pe web, îngrijit de { $provider }

##

home-prefs-recommended-by-learn-more = Cum funcționează
home-prefs-recommended-by-option-sponsored-stories =
    .label = Articole sponsorizate
home-prefs-highlights-header =
    .label = Evidențieri
home-prefs-highlights-description = O selecție a site-urilor pe care le-ai salvat sau vizitat
home-prefs-highlights-option-visited-pages =
    .label = Pagini vizitate
home-prefs-highlights-options-bookmarks =
    .label = Marcaje
home-prefs-highlights-option-most-recent-download =
    .label = Cele mai recente descărcări
home-prefs-highlights-option-saved-to-pocket =
    .label = Pagini salvate în { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Fragmente
home-prefs-snippets-description = Știri de la { -vendor-short-name } și { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } rând
            [few] { $num } rânduri
           *[other] { $num } de rânduri
        }

## Search Section

search-bar-header = Bară de căutare
search-bar-hidden =
    .label = Folosește bara de adresă pentru căutare și navigare
search-bar-shown =
    .label = Adaugă bara de căutare în bara de unelte
search-engine-default-header = Motor de căutare implicit
search-engine-default-desc-2 = Acesta este motorul tău de căutare implicit din bara de adresă și bara de căutare. Îl poți comuta oricând.
search-engine-default-private-desc-2 = Alege un alt motor de căutare implicit numai pentru ferestrele private
search-separate-default-engine =
    .label = Folosește acest motor de căutare în ferestrele private
    .accesskey = U
search-suggestions-header = Sugestii de căutare
search-suggestions-desc = Alege felul în care apar sugestiile motoarelor de căutare.
search-suggestions-option =
    .label = Furnizează sugestii de căutare
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = Afișează sugestiile de căutare în rezultatele din bara de adresă
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Afișează sugestiile de căutare înaintea istoricului de navigare în rezultatele din bara de adresă
search-show-suggestions-private-windows =
    .label = Afișează sugestii de căutare în ferestrele private
suggestions-addressbar-settings-generic = Schimbă preferințele pentru alte sugestii în bara de adrese
search-suggestions-cant-show = Sugestiile de căutare nu vor fi afișate în rezultatele din bara de adrese deoarece ai configurat { -brand-short-name } ca să nu țină minte niciodată istoricul.
search-one-click-header = Motoare de căutare la un clic distanță
search-one-click-desc = Alege motoarele de căutare alternative care apar sub bara de adresă și bara de căutare atunci când începi să introduci un cuvânt cheie.
search-choose-engine-column =
    .label = Motor de căutare
search-choose-keyword-column =
    .label = Cuvânt cheie
search-restore-default =
    .label = Restaurează motoarele de căutare implicite
    .accesskey = D
search-remove-engine =
    .label = Elimină
    .accesskey = R
search-find-more-link = Caută mai multe motoare de căutare
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Cuvânt cheie duplicat
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Ai ales un cuvânt cheie care este folosit actualmente de „{ $name }”. Te rugăm să selectezi altul.
search-keyword-warning-bookmark = Ai ales un cuvânt cheie care este folosit de un marcaj. Te rugăm să selectezi altul.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Înapoi la Opțiuni
           *[other] Înapoi la Preferințe
        }
containers-header = File container
containers-add-button =
    .label = Adaugă un container nou
    .accesskey = A
containers-new-tab-check =
    .label = Selectează un container pentru fiecare filă nouă
    .accesskey = S
containers-preferences-button =
    .label = Preferințe
containers-remove-button =
    .label = Elimină

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Ia webul cu tine
sync-signedout-description = Sincronizează marcajele, istoricul, filele, parolele, suplimentele și preferințele pe toate dispozitivele.
sync-signedout-account-signin2 =
    .label = Autentifică-te în { -sync-brand-short-name }…
    .accesskey = i
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Descarcă Firefox pentru <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> sau <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> ca să sincronizezi datele cu dispozitivul mobil.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Schimbă fotografia de profil
sync-sign-out =
    .label = Deconectează-te…
    .accesskey = g
sync-manage-account = Gestionează contul
    .accesskey = o
sync-signedin-unverified = { $email } nu este verificat.
sync-signedin-login-failure = Te rugăm să te autentifici pentru reconectare { $email }
sync-resend-verification =
    .label = Retrimite verificarea
    .accesskey = d
sync-remove-account =
    .label = Elimină contul
    .accesskey = R
sync-sign-in =
    .label = Autentificare
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sincronizare: ACTIVATĂ
prefs-syncing-off = Sincronizare: DEZACTIVATĂ
prefs-sync-setup =
    .label = Configurare { -sync-brand-short-name }…
    .accesskey = S
prefs-sync-offer-setup-label = Sincronizează-ți marcajele, istoricul, filele, parolele, suplimentele și preferințele pe toate dispozitivele.
prefs-sync-now =
    .labelnotsyncing = Sincronizează acum
    .accesskeynotsyncing = N
    .labelsyncing = Se sincronizează…

## The list of things currently syncing.

sync-currently-syncing-heading = În prezent, sincronizezi aceste elemente:
sync-currently-syncing-bookmarks = Marcaje
sync-currently-syncing-history = Istoric
sync-currently-syncing-tabs = File deschise
sync-currently-syncing-logins-passwords = Date de autentificare și parole
sync-currently-syncing-addresses = Adrese
sync-currently-syncing-creditcards = Carduri de credit
sync-currently-syncing-addons = Suplimente
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Opțiuni
       *[other] Preferințe
    }
sync-change-options =
    .label = Modifică…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Alege ce să se sincronizeze
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Salvează modificările
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Deconectează-te…
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = Marcaje
    .accesskey = M
sync-engine-history =
    .label = Istoric
    .accesskey = r
sync-engine-tabs =
    .label = File deschise
    .tooltiptext = O listă cu ce este deschis pe toate dispozitivele sincronizate
    .accesskey = T
sync-engine-logins-passwords =
    .label = Date de autentificare și parole
    .tooltiptext = Denumiri de utilizator și parole salvate
    .accesskey = L
sync-engine-addresses =
    .label = Adrese
    .tooltiptext = Adrese poștale salvate (doar desktop)
    .accesskey = e
sync-engine-creditcards =
    .label = Carduri de credit
    .tooltiptext = Nume, numere și date de expirare (doar desktop)
    .accesskey = c
sync-engine-addons =
    .label = Suplimente
    .tooltiptext = Extensii și teme pentru Firefox desktop
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Opțiuni
           *[other] Preferințe
        }
    .tooltiptext = Setările generale, de confidențialitate și securitate pe care le-ai schimbat
    .accesskey = s

## The device name controls.

sync-device-name-header = Numele dispozitivului
sync-device-name-change =
    .label = Schimbă numele dispozitivului
    .accesskey = h
sync-device-name-cancel =
    .label = Renunță
    .accesskey = n
sync-device-name-save =
    .label = Salvează
    .accesskey = v
sync-connect-another-device = Conectează alt dispozitiv

## Privacy Section

privacy-header = Confidențialitate în browser

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Autentificări și parole
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Solicită salvarea autentificărilor și parolelor pentru site-urile web
    .accesskey = r
forms-exceptions =
    .label = Excepții…
    .accesskey = x
forms-generate-passwords =
    .label = Sugerează și generează parole puternice
    .accesskey = u
forms-breach-alerts =
    .label = Afișează alerte despre parole pentru site-urile web a căror securitate a fost încălcată
    .accesskey = b
forms-breach-alerts-learn-more-link = Află mai multe
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Completează automat autentificări și parole
    .accesskey = i
forms-saved-logins =
    .label = Date de autentificare salvate…
    .accesskey = L
forms-master-pw-use =
    .label = Folosește o parolă generală
    .accesskey = U
forms-primary-pw-use =
    .label = Folosește o parolă primară
    .accesskey = U
forms-primary-pw-learn-more-link = Află mai multe
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Schimbă parola generală…
    .accesskey = m
forms-master-pw-fips-title = Acum te afli în modul FIPS. FIPS nu permite inexistența unei parole generale.
forms-primary-pw-change =
    .label = Schimbă parola primară…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Denumită anterior parolă generală
forms-primary-pw-fips-title = Acum ești în modul FIPS. FIPS nu permite inexistența unei parole primare.
forms-master-pw-fips-desc = Schimbarea parolei a eșuat

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pentru a crea o parolă generală, introdu-ți datele de autentificare pentru Windows. Ajută la protejarea securității conturilor tale.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = creează o parolă generală
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pentru a crea o parolă primară, introdu-ți datele de autentificare pentru Windows. Ajută la protejarea securității conturilor tale.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = creează o parolă primară
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Istoric
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = w
history-remember-option-all =
    .label = Va ține minte istoricul
history-remember-option-never =
    .label = Nu va ține minte istoricul niciodată
history-remember-option-custom =
    .label = Va folosi setări personalizate pentru istoric
history-remember-description = { -brand-short-name } va ține minte istoricul navigării, descărcărilor, formularelor și căutărilor.
history-dontremember-description = { -brand-short-name } va folosi aceleași setări ca navigarea privată și nu va ține minte istoricul în timp ce navighezi pe web.
history-private-browsing-permanent =
    .label = Folosește mereu modul de navigare privată
    .accesskey = m
history-remember-browser-option =
    .label = Ține minte istoricul navigării și al descărcărilor
    .accesskey = b
history-remember-search-option =
    .label = Ține minte istoricul formularelor și al căutărilor
    .accesskey = f
history-clear-on-close-option =
    .label = Șterge istoricul atunci când { -brand-short-name } este închis
    .accesskey = C
history-clear-on-close-settings =
    .label = Setări…
    .accesskey = t
history-clear-button =
    .label = Șterge istoricul…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookie-uri și date ale site-urilor
sitedata-total-size-calculating = Se calculează datele site-urilor și mărimea cache-ului…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Cookie-urile stocate, datele site-urilor și cache-ul folosesc în prezent { $value } { $unit } din spațiul de pe disc.
sitedata-learn-more = Află mai multe
sitedata-delete-on-close =
    .label = Șterge cookie-urile și datele site-urilor la închiderea { -brand-short-name }
    .accesskey = c
sitedata-delete-on-close-private-browsing = În modul de navigare privată permanentă, cookie-urile și datele site-urilor vor fi întotdeauna șterse la închiderea { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Acceptă cookie-uri și datele site-urilor
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Blochează cookie-urile și datele site-urilor
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tipul conținutului blocat
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Elemente de urmărire între site-uri
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Elemente de urmărire de pe rețele de socializare și inter-site-uri
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Elemente de urmărire între site-uri și de rețele sociale și izolează restul cookie-urilor
sitedata-option-block-unvisited =
    .label = Cookie-uri de pe site-uri web nevizitate
sitedata-option-block-all-third-party =
    .label = Toate cookie-urile de la terți (poate împiedica funcționarea site-urilor web)
sitedata-option-block-all =
    .label = Toate cookie-urile (va împiedica funcționarea site-urilor web)
sitedata-clear =
    .label = Șterge datele…
    .accesskey = l
sitedata-settings =
    .label = Gestionează datele…
    .accesskey = M
sitedata-cookies-permissions =
    .label = Gestionează permisiunile...
    .accesskey = P
sitedata-cookies-exceptions =
    .label = Gestionează excepțiile…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Bară de adresă
addressbar-suggest = Când se folosește bara de adresă, sugerează:
addressbar-locbar-history-option =
    .label = Istoric de navigare
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Marcaje
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = File deschise
    .accesskey = O
addressbar-locbar-topsites-option =
    .label = Site-uri de top
    .accesskey = T
addressbar-suggestions-settings = Schimbă preferințele pentru sugestiile motoarelor de căutare…

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Protecție îmbunătățită împotriva urmăririi
content-blocking-section-top-level-description = Elementele de urmărire te urmăresc online pentru a colecta informații despre obiceiurile și interesele tale de navigare. { -brand-short-name } blochează multe dintre aceste elementele de urmărire și alte scripturi rău-intenționate.
content-blocking-learn-more = Află mai multe

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Strictă
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Personalizată
    .accesskey = C

##

content-blocking-etp-standard-desc = Echilibrat pentru protecție și performanță. Paginile se vor încărca normal.
content-blocking-etp-strict-desc = O protecție mai puternică, dar poate provoca funcționarea necorespunzătoare a site-urilor sau a conținutului.
content-blocking-etp-custom-desc = Alege ce elemente de urmărire și scripturi să blochezi.
content-blocking-private-windows = Conținut de urmărire în ferestre private
content-blocking-cross-site-tracking-cookies = Cookie-uri de urmărire între site-uri
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookie-uri de urmărire între site-uri și izolează restul cookie-urilor
content-blocking-social-media-trackers = Elemente de urmărire de pe rețele de socializare
content-blocking-all-cookies = Toate cookie-urile
content-blocking-unvisited-cookies = Cookie-uri de la site-uri nevizitate
content-blocking-all-windows-tracking-content = Conținut de urmărire în toate ferestrele
content-blocking-all-third-party-cookies = Toate cookie-urile de la terți
content-blocking-cryptominers = Criptomineri
content-blocking-fingerprinters = Generatoare de amprente digitale
content-blocking-warning-title = Atenție!
content-blocking-and-isolating-etp-warning-description = Blocarea elementelor de urmărire și izolarea cookie-urilor pot afecta funcționalitatea unor site-uri. Reîmprospătează pagina cu elementele de urmărire ca să încarci tot conținutul.
content-blocking-warning-learn-how = Află cum
content-blocking-reload-description = Va trebui să reîncarci filele pentru aplicarea acestor modificări.
content-blocking-reload-tabs-button =
    .label = Reîncarcă toate filele
    .accesskey = R
content-blocking-tracking-content-label =
    .label = Conținut de urmărire
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = În toate ferestrele
    .accesskey = A
content-blocking-option-private =
    .label = Doar în ferestrele private
    .accesskey = P
content-blocking-tracking-protection-change-block-list = Modifică lista de blocare
content-blocking-cookies-label =
    .label = Cookie-uri
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Mai multe informații
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Criptomineri
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Generatoare de amprente digitale
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Gestionează excepțiile...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Permisiuni
permissions-location = Locație
permissions-location-settings =
    .label = Setări…
    .accesskey = l
permissions-xr = Realitate virtuală
permissions-xr-settings =
    .label = Setări…
    .accesskey = t
permissions-camera = Cameră
permissions-camera-settings =
    .label = Setări…
    .accesskey = t
permissions-microphone = Microfon
permissions-microphone-settings =
    .label = Setări…
    .accesskey = m
permissions-notification = Notificări
permissions-notification-settings =
    .label = Setări…
    .accesskey = n
permissions-notification-link = Află mai multe
permissions-notification-pause =
    .label = Pune pe pauză notificările până la repornirea lui { -brand-short-name }
    .accesskey = n
permissions-autoplay = Redare automată
permissions-autoplay-settings =
    .label = Setări…
    .accesskey = t
permissions-block-popups =
    .label = Blochează ferestrele pop-up
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Excepții…
    .accesskey = E
permissions-addon-install-warning =
    .label = Avertizează atunci când site-urile web încearcă să instaleze suplimente
    .accesskey = w
permissions-addon-exceptions =
    .label = Excepții…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = Împiedică serviciile de accesibilitate să îți acceseze browserul
    .accesskey = a
permissions-a11y-privacy-link = Află mai multe

## Privacy Section - Data Collection

collection-header = Colectarea și utilizarea de date din { -brand-short-name }
collection-description = Ne străduim să îți oferim posibilitatea de a face alegeri și colectăm doar ceea ce avem nevoie ca să furnizăm și să îmbunătățim { -brand-short-name } pentru toată lumea. Întotdeauna solicităm permisiunea înainte de a primi informații cu caracter personal.
collection-privacy-notice = Notificare privind confidențialitatea
collection-health-report-telemetry-disabled = Nu mai permiți { -vendor-short-name } să îți capteze datele tehnice și de interacționare. Toate datele anterioare vor fi șterse în 30 de zile.
collection-health-report-telemetry-disabled-link = Află mai multe
collection-health-report =
    .label = Permite ca { -brand-short-name } să trimită informații tehnice și interactive către { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Află mai multe
collection-studies =
    .label = Permite ca { -brand-short-name } să instaleze și să realizeze studii
collection-studies-link = Vezi studiile { -brand-short-name }
addon-recommendations =
    .label = Permite ca { -brand-short-name } să facă recomandări de extensii personalizate
addon-recommendations-link = Află mai multe
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Raportarea datelor este dezactivată în configurația folosită
collection-backlogged-crash-reports =
    .label = Permite ca { -brand-short-name } să trimită în numele tău rapoarte de defecțiuni înregistrate în jurnal
    .accesskey = c
collection-backlogged-crash-reports-link = Află mai multe

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Securitate
security-browsing-protection = Protecție împotriva conținutului înșelător și a programelor periculoase
security-enable-safe-browsing =
    .label = Blochează conținutul periculos și înșelător
    .accesskey = B
security-enable-safe-browsing-link = Află mai multe
security-block-downloads =
    .label = Blochează descărcările periculoase
    .accesskey = d
security-block-uncommon-software =
    .label = Avertizează despre programe nedorite sau neobișnuite
    .accesskey = c

## Privacy Section - Certificates

certs-header = Certificate
certs-personal-label = Când un server îți cere certificatul personal
certs-select-auto-option =
    .label = Selectează automat unul
    .accesskey = S
certs-select-ask-option =
    .label = Întreabă de fiecare dată
    .accesskey = A
certs-enable-ocsp =
    .label = Interoghează serverele de răspuns OCSP pentru confirmarea valabilității actuale a certificatelor
    .accesskey = h
certs-view =
    .label = Vezi certificatele…
    .accesskey = c
certs-devices =
    .label = Dispozitive de securitate…
    .accesskey = D
space-alert-learn-more-button =
    .label = Află mai multe
    .accesskey = l
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Deschide opțiunile
           *[other] Deschide preferințele
        }
    .accesskey =
        { PLATFORM() ->
            [windows] o
           *[other] O
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } rămâne fără spațiu pe disc. Este posibil ca conținutul site-ului web să nu fie afișat corespunzător. Poți șterge datele stocate în Opțiuni > Avansat > Cookie-uri și date ale site-urilor.
       *[other] { -brand-short-name } rămâne fără spațiu pe disc. Este posibil ca conținutul site-ului web să nu fie afișat corespunzător. Poți șterge datele stocate în Preferințe > Avansat > Cookie-uri și date ale site-urilor.
    }
space-alert-under-5gb-ok-button =
    .label = OK, am înțeles
    .accesskey = K
space-alert-under-5gb-message = { -brand-short-name } rămâne fără spațiu pe disc. Este posibil ca conținutul site-ului web să nu fie afișat corespunzător. Vizitează „Află mai multe” pentru a optimiza utilizarea discului în vederea unei mai bune experiențe de navigare.

## Privacy Section - HTTPS-Only

httpsonly-header = Mod doar HTTPS
httpsonly-description = HTTPS oferă o conexiune criptată și securizată între { -brand-short-name } și site-urile web pe care intri. Cele mai multe site-uri au suport pentru HTTPS și, dacă este activat modul doar HTTPS, atunci { -brand-short-name } va folosi HTTPS pentru toate conexiunile.
httpsonly-learn-more = Află mai multe
httpsonly-radio-enabled =
    .label = Activează modul doar HTTPS în toate ferestrele
httpsonly-radio-enabled-pbm =
    .label = Activează modul doar HTTPS numai în ferestrele private
httpsonly-radio-disabled =
    .label = Nu activa modul doar HTTPS

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Descărcări
choose-download-folder-title = Alege dosarul de descărcare:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Salvează fișierele în { $service-name }
