# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Websydłam signal “Njeslědować” pósłać, zo nochceće, zo wone was slěduja
do-not-track-learn-more = Dalše informacije
do-not-track-option-default-content-blocking-known =
    .label = Jenož hdyž w { -brand-short-name } je blokowanje znatych přesćěhowakow  nastajene
do-not-track-option-always =
    .label = Přeco
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
            [windows] W nastajenjach pytać
           *[other] W nastajenjach pytać
        }
managed-notice = Waš wobhladowka so wot wašeje organizacije rjaduje.
pane-general-title = Powšitkowny
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Startowa strona
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Pytać
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
pane-experimental-subtitle = Pokročujće z kedźbliwosću
pane-experimental-search-results-header = Eksperimenty { -brand-short-name }: pokročujće z kedźbliwosću
pane-experimental-description = Hdyž nastajenja rozšěrjeneje konfiguracije změniće, móže to wukon abo wěstotu { -brand-short-name } wobwliwować.
help-button-label = Pomoc { -brand-short-name }
addons-button-label = Rozšěrjenja a drasty
focus-search =
    .key = f
close-button =
    .aria-label = Začinić

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } dyrbi so znowa startować, zo by tutu funkciju zmóžnił.
feature-disable-requires-restart = { -brand-short-name } dyrbi so znowa startować, zo by tutu funkciju znjemóžnił.
should-restart-title = { -brand-short-name } znowa startować
should-restart-ok = { -brand-short-name } nětko znowa startować
cancel-no-restart-button = Přetorhnyć
restart-later = Pozdźišo znowa startować

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
extension-controlled-homepage-override = Rozšěrjenje <img data-l10n-name="icon"/> { $name } wašu startowu stronu wodźi.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Rozšěrjenje <img data-l10n-name="icon"/> { $name } wašu stronu noweho rajtarka wodźi.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Rozšěrjenje, <img data-l10n-name="icon"/> { $name }, tute nastajenje kontroluje.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Rozšěrjenje, <img data-l10n-name="icon"/> { $name }, tute nastajenje wodźi.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Rozšěrjenje, <img data-l10n-name="icon"/> { $name }, je wašu standardnu pytawu nastajiło.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Rozšěrjenje, <img data-l10n-name="icon"/> { $name }, sej kontejnerowe rajtarki wužaduje.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Rozšěrjenje, <img data-l10n-name="icon"/> { $name }, tute nastajenje kontroluje.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Rozšěrjenje <img data-l10n-name="icon"/> { $name } wodźi, kak { -brand-short-name } z internetom zwjazuje.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Zo byšće rozšěrjenje zmóžnił, přeńdźće k <img data-l10n-name="addons-icon"/> přidatkam w <img data-l10n-name="menu-icon"/> meniju.

## Preferences UI Search Results

search-results-header = Pytanske wuslědki
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Bohužel žane wuslědki w nastajenjach za “<span data-l10n-name="query"></span>” njejsu.
       *[other] Bohužel žane wuslědki w nastajenjach za “<span data-l10n-name="query"></span>” njejsu.
    }
search-results-help-link = Trjebaće pomoc? Wopytajće <a data-l10n-name="url">Pomoc za { -brand-short-name }</a>

## General Section

startup-header = Startować
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } a Firefox dowolić, w samsnym času běžeć
use-firefox-sync = Pokiw: To separatne profile wužiwa. Wužiwajće { -sync-brand-short-name }, zo byšće daty mjez nimi dźělił.
get-started-not-logged-in = So pola { -sync-brand-short-name } přizjewić…
get-started-configured = Nastajenja { -sync-brand-short-name } wočinić
always-check-default =
    .label = Přeco kontrolować, hač { -brand-short-name } je waš standardny wobhladowak
    .accesskey = c
is-default = { -brand-short-name } je tuchwilu waš standardny wobhladowak
is-not-default = { -brand-short-name } tuchwilu waš standardny wobhladowak njeje
set-as-my-default-browser =
    .label = K standardej činić…
    .accesskey = t
startup-restore-previous-session =
    .label = Předchadne posedźenje wobnowić
    .accesskey = b
startup-restore-warn-on-quit =
    .label = Warnować, hdyž so wobhladowak kónči
disable-extension =
    .label = Rozšěrjenje znjemóžnić
tabs-group-header = Rajtarki
ctrl-tab-recently-used-order =
    .label = Strg+Tab přeběži rajtarki po tuchwilu postajenym porjedźe
    .accesskey = T
open-new-link-as-tabs =
    .label = Wotkazy w rajtarkach město nowych woknow wočinić
    .accesskey = r
warn-on-close-multiple-tabs =
    .label = Warnować, hdyž so wjacore rajtarki začinjeja
    .accesskey = W
warn-on-open-many-tabs =
    .label = Warnować, hdyž móhło wočinjenje wjacorych rajtarkow { -brand-short-name } spomalić
    .accesskey = o
switch-links-to-new-tabs =
    .label = Hnydom k rajtarkej  přeńć, w kotrymž so wotkaz wočinja
    .accesskey = H
show-tabs-in-taskbar =
    .label = Rajtarkowe přehlady we Windowsowej nadawkowej lajsće pokazać
    .accesskey = R
browser-containers-enabled =
    .label = Kontejnerowe rajtarki zmóžnić
    .accesskey = m
browser-containers-learn-more = Dalše informacije
browser-containers-settings =
    .label = Nastajenja…
    .accesskey = s
containers-disable-alert-title = Wšě kontejnerowe rajtarki začinić?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Jeli kontejnerowe rajtarki nětko znjemóžnjeće, so { $tabCount } kontejnerowy rajtark začini. Chceće kontejnerowe rajtarki woprawdźe znjemóžnić?
        [two] Jeli kontejnerowe rajtarki nětko znjemóžnjeće, so { $tabCount } kontejnerowej rajtarkaj začinitej. Chceće kontejnerowe rajtarki woprawdźe znjemóžnić?
        [few] Jeli kontejnerowe rajtarki nětko znjemóžnjeće, so { $tabCount } kontejnerowe rajtarki začinja. Chceće kontejnerowe rajtarki woprawdźe znjemóžnić?
       *[other] Jeli kontejnerowe rajtarki nětko znjemóžnjeće, so { $tabCount } kontejnerowych rajtarkow začini. Chceće kontejnerowe rajtarki woprawdźe znjemóžnić?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } kontejnerowy rajtark začinić
        [two] { $tabCount } kontejnerowej rajtarkaj začinić
        [few] { $tabCount } kontejnerowe rajtarki začinić
       *[other] { $tabCount } kontejnerowych rajtarkow začinić
    }
containers-disable-alert-cancel-button = Zmóžnjene wostajić
containers-remove-alert-title = Tutón kontejner wotstronić?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Jeli tutón kontejner nětko wotstroniće, so { $count } kontejnerowy rajtark začini. Chceće tutón kontejner woprawdźe wotstronić?
        [two] Jeli tutón kontejner nětko wotstroniće, so { $count } kontejnerowej rajtarkaj začinitej. Chceće tutón kontejner woprawdźe wotstronić?
        [few] Jeli tutón kontejner nětko wotstroniće, so { $count } kontejnerowe rajtarki začinja. Chceće tutón kontejner woprawdźe wotstronić?
       *[other] Jeli tutón kontejner nětko wotstroniće, so { $count } kontejnerowych rajtarkow začini. Chceće tutón kontejner woprawdźe wotstronić?
    }
containers-remove-ok-button = Tutón kontejner wotstronić
containers-remove-cancel-button = Tutón kontejner njewotstronić

## General Section - Language & Appearance

language-and-appearance-header = Rěč a zwonkowne
fonts-and-colors-header = Pisma a barby
default-font = Standardne pismo
    .accesskey = S
default-font-size = Wulkosć
    .accesskey = l
advanced-fonts =
    .label = Rozšěrjeny…
    .accesskey = o
colors-settings =
    .label = Barby…
    .accesskey = B
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Skalowanje
preferences-default-zoom = Standardne skalowanje
    .accesskey = S
preferences-default-zoom-value =
    .label = { $percentage } %
preferences-zoom-text-only =
    .label = Jenož tekst skalować
    .accesskey = t
language-header = Rěč
choose-language-description = Wubjerće swoju preferowanu rěč za zwobraznjenje stronow
choose-button =
    .label = Wubrać…
    .accesskey = u
choose-browser-language-description = Wubjerće rěče, kotrež so wužiwaja, zo bychu menije, powěsće a zdźělenki z { -brand-short-name } pokazali.
manage-browser-languages-button =
    .label = Alternatiwy nastajić…
    .accesskey = l
confirm-browser-language-change-description = Startujće { -brand-short-name } znowa, zo byšće tute změny nałožił
confirm-browser-language-change-button = Nałožić a znowa startować
translate-web-pages =
    .label = Webwobsah přełožować
    .accesskey = W
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Přełožki wot <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Wuwzaća…
    .accesskey = u
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Nastajenja wašeho dźěłoweho systema za „{ $localeName }“ wužiwać, zo bychu so datumy, časy, ličby a měry formatowali.
check-user-spelling =
    .label = Při pisanju prawopis kontrolować
    .accesskey = P

## General Section - Files and Applications

files-and-applications-title = Dataje a nałoženja
download-header = Sćehnjenja
download-save-to =
    .label = Dataje składować do
    .accesskey = k
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Wubrać…
           *[other] Přepytać…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] u
           *[other] e
        }
download-always-ask-where =
    .label = Přeco so prašeć, hdźež dataje maja so składować
    .accesskey = c
applications-header = Nałoženja
applications-description = Wubjerće, kak { -brand-short-name } ma z datajemi wobchadźeć, kotrež z interneta sćahujeće abo z nałoženjemi, kotrež při přehladowanju wužiwaće.
applications-filter =
    .placeholder = Datajowe typy abo nałoženja přepytać
applications-type-column =
    .label = Wobsahowy typ
    .accesskey = W
applications-action-column =
    .label = Akcija
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = Dataja { $extension }
applications-action-save =
    .label = Dataju składować
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } wužiwać
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } wužiwać (standard)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Standardne nałoženje macOS wužiwać
            [windows] Standardne nałoženje Windows wužiwać
           *[other] Standardne nałoženje systema wužiwać
        }
applications-use-other =
    .label = Druhu wužiwać…
applications-select-helper = Pomocne nałoženje wubrać
applications-manage-app =
    .label = Podrobnosće nałoženja…
applications-always-ask =
    .label = Přeco so prašeć
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
    .label = { $plugin-name } wužiwać (w { -brand-short-name })
applications-open-inapp =
    .label = W { -brand-short-name } wočinić

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

drm-content-header = Wobsah Digital Right Management (DRM)
play-drm-content =
    .label = Wobsah wodźeny přez DRM wothrać
    .accesskey = h
play-drm-content-learn-more = Dalše informacije
update-application-title = Aktualizacije { -brand-short-name }
update-application-description = Dźeržće { -brand-short-name } aktualny, za najlěpši wukon, stabilnosć a wěstotu.
update-application-version = Wersija { $version } <a data-l10n-name="learn-more">Nowe funkcije a změny</a>
update-history =
    .label = Aktualizacisku historiju pokazać…
    .accesskey = h
update-application-allow-description = { -brand-short-name } dowolić,
update-application-auto =
    .label = Aktualizacije awtomatisce instalować (doporučene)
    .accesskey = A
update-application-check-choose =
    .label = Za aktualizacijemi pytać, ale prjedy so prašeć, hač maja so instalować
    .accesskey = Z
update-application-manual =
    .label = Ženje za aktualizacijemi njepytać (njeporuča so)
    .accesskey = e
update-application-warning-cross-user-setting = Tute nastajenje so na wšě konta Windows a profile { -brand-short-name } nałožuje, kotrež tutu instalaciju { -brand-short-name } wužiwaja.
update-application-use-service =
    .label = Pozadkowu słužbu za instalowanje aktualizacijow wužiwać
    .accesskey = P
update-setting-write-failure-title = Zmylk při składowanju aktualizowanskich nastajenjow
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } je na zmylk storčił a njeje tutu změnu składował. Dźiwajće na to, zo sej tute aktualizowanske nastajenje pisanske prawo za slědowacu dataju wužaduje. Wy abo systemowy administrator móžetej zmylk porjedźić, hdyž wužiwarskej skupinje połnu kontrolu nad tutej dataju datej.
    
    Njeda so do dataje pisać: { $path }
update-in-progress-title = Aktualizacija běži
update-in-progress-message = Chceće, zo { -brand-short-name } z tutej aktualizaciju pokročuje?
update-in-progress-ok-button = &Zaćisnyć
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Dale

## General Section - Performance

performance-title = Wukon
performance-use-recommended-settings-checkbox =
    .label = Doporučene wukonowe nastajenja wužiwać
    .accesskey = D
performance-use-recommended-settings-desc = Tute nastajenja su na hardwaru a dźěłowy system wašeho ličaka přiměrjene.
performance-settings-learn-more = Dalše informacije
performance-allow-hw-accel =
    .label = Hardwarowe pospěšenje wužiwać, jeli k dispoziciji
    .accesskey = H
performance-limit-content-process-option = Mjeza wobsahoweho procesa
    .accesskey = M
performance-limit-content-process-enabled-desc = Wjace wobsahowych procesow móže wukon polěpšować, hdyž so wjacore rajtarki wužiwaja, budźe wšak tež wjace składa přetrjebować.
performance-limit-content-process-blocked-desc = Ličba wobsahowych procesow da so jenož z wjaceprocesowym { -brand-short-name } změnić. <a data-l10n-name="learn-more">Zhońće, kak móžeće kontrolować, hač wjaceprocesowa funkcija je zmóžnjena</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (standard)

## General Section - Browsing

browsing-title = Přehladowanje
browsing-use-autoscroll =
    .label = Awtomatiske přesuwanje wužiwać
    .accesskey = A
browsing-use-smooth-scrolling =
    .label = Łahodne přesuwanje wužiwać
    .accesskey = h
browsing-use-onscreen-keyboard =
    .label = Dótknjensku tastaturu pokazać, jeli trěbne
    .accesskey = k
browsing-use-cursor-navigation =
    .label = Přeco kursorowe tasty za pohibowanje na stronach wužiwać
    .accesskey = k
browsing-search-on-start-typing =
    .label = Při pisanju tekst pytać
    .accesskey = P
browsing-picture-in-picture-toggle-enabled =
    .label = Wodźenske elementy wideja wobraz-we-wobrazu zmóžnić
    .accesskey = W
browsing-picture-in-picture-learn-more = Dalše informacije
browsing-cfr-recommendations =
    .label = Rozšěrjenja doporučić, hdyž přehladujeće
    .accesskey = R
browsing-cfr-features =
    .label = Doporučće funkcije, mjeztym zo přehladujeće
    .accesskey = f
browsing-cfr-recommendations-learn-more = Dalše informacije

## General Section - Proxy

network-settings-title = Syćowe nastajenja
network-proxy-connection-description = Konfigurować, kak { -brand-short-name } z internetom zwjazuje.
network-proxy-connection-learn-more = Dalše informacije
network-proxy-connection-settings =
    .label = Nastajenja…
    .accesskey = N

## Home Section

home-new-windows-tabs-header = Nowe wokna a rajtarki
home-new-windows-tabs-description2 = Wubjerće, štož chceće widźeć, hdyž swoju startowu stronu, nowe wokna a nowe rajtarki wočinjeće.

## Home Section - Home Page Customization

home-homepage-mode-label = Startowa strona a nowe wokna
home-newtabs-mode-label = Nowe rajtarki
home-restore-defaults =
    .label = Standard wobnowić
    .accesskey = S
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Startowa strona Firefox (standard)
home-mode-choice-custom =
    .label = Swójske URL…
home-mode-choice-blank =
    .label = Prózdna strona
home-homepage-custom-url =
    .placeholder = URL zasadźić…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Aktualnu stronu wužiwać
           *[other] Aktualne strony wužiwać
        }
    .accesskey = A
choose-bookmark =
    .label = Zapołožku wužiwać…
    .accesskey = Z

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Wobsah startoweje strony Firefox
home-prefs-content-description = Wubjerće, kotry wobsah chceće na swojej startowej wobrazowce Firefox měć.
home-prefs-search-header =
    .label = Webpytanje
home-prefs-topsites-header =
    .label = Najhusćišo wopytane sydła
home-prefs-topsites-description = Sydła, kotrež najhusćišo wopytujeće

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Wot { $provider } doporučeny
home-prefs-recommended-by-description-update = Wurjadny wobsah z cyłeho weba, wubrany wot { $provider }

##

home-prefs-recommended-by-learn-more = Kak funguje
home-prefs-recommended-by-option-sponsored-stories =
    .label = Sponsorowane stawizny
home-prefs-highlights-header =
    .label = Wjerški
home-prefs-highlights-description = Wuběr websydłow, kotrež sće składował abo wopytał
home-prefs-highlights-option-visited-pages =
    .label = Wopytane strony
home-prefs-highlights-options-bookmarks =
    .label = Zapołožki
home-prefs-highlights-option-most-recent-download =
    .label = Najnowše sćehnjenje
home-prefs-highlights-option-saved-to-pocket =
    .label = Strony składowane do { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Šlipki
home-prefs-snippets-description = Aktualizacije wot { -vendor-short-name } a { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } linka
            [two] { $num } lince
            [few] { $num } linki
           *[other] { $num } linkow
        }

## Search Section

search-bar-header = Pytanske polo
search-bar-hidden =
    .label = Wužiwajće adresowe polo za pytanje a nawigaciju
search-bar-shown =
    .label = Symbolowej lajsće pytanske polo přidać
search-engine-default-header = Standardna pytawa
search-engine-default-desc-2 = To je waša standardna pytawa w adresowej lajsće a pytanskej lajsće. Móžeće je kóždy raz přepinać.
search-engine-default-private-desc-2 = Wubjerće druhu standardnu pytawu jenož za priwatny modus
search-separate-default-engine =
    .label = Tutu pytawu w priwatnych woknach wužiwać
    .accesskey = T
search-suggestions-header = Pytanske namjety
search-suggestions-desc = Wubjerće, kak so namjety z pytawow jewja.
search-suggestions-option =
    .label = Pytanske namjety podać
    .accesskey = P
search-show-suggestions-url-bar-option =
    .label = Pytanske namjety we wuslědkach adresoweho pola pokazać
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Pytanske namjety před přehladowanskej historiju we wuslědkach adresoweho pola pokazać
search-show-suggestions-private-windows =
    .label = Pytanske namjety w priwatnych woknach pokazać
suggestions-addressbar-settings-generic = Nastajenja za druhe namjety adresoweho pola změnić
search-suggestions-cant-show = Pytanske namjety njebudu so we wuslědkach adresoweho pola pokazać, dokelž sće { -brand-short-name } tak konfigurował, zo sej ženje historiju njespomjatkuje.
search-one-click-header = Pytawy z jednym kliknjenjom
search-one-click-desc = Wubjerće alternatiwne pytawy, kotrež so pod adresowym polom a pytanskim polom jewja, hdyž klučowe słowo zapodawaće.
search-choose-engine-column =
    .label = Pytawa
search-choose-keyword-column =
    .label = Klučowe słowo
search-restore-default =
    .label = Standardne pytawy wobnowić
    .accesskey = S
search-remove-engine =
    .label = Wotstronić
    .accesskey = o
search-add-engine =
    .label = Přidać
    .accesskey = P
search-find-more-link = Dalše pytawy pytać
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Klučowe słowo podwojić
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Sće klučowe słowo wubrał, kotrež so runje wot "{ $name }" wužiwa. Prošu wubjerće druhe.
search-keyword-warning-bookmark = Sće klučowe słowo wubrał, kotrež so runje wot zapołožkow wužiwa. Prošu wubjerće druhe.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Wróćo k nastajenjam
           *[other] Wróćo k nastajenjam
        }
containers-header = Kontejnerowe rajtarki
containers-add-button =
    .label = Nowy kontejner přidać
    .accesskey = k
containers-new-tab-check =
    .label = Kontejner za kóždy nowy rajtark wubrać
    .accesskey = K
containers-preferences-button =
    .label = Nastajenja
containers-remove-button =
    .label = Wotstronić

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Wzmiće swój web sobu
sync-signedout-description = Synchronizujće swoje zapołožki, historiju, rajtarki, hesła, přidatki a nastajenja mjez wšěmi wašimi gratami.
sync-signedout-account-signin2 =
    .label = So pola { -sync-brand-short-name } přizjewić…
    .accesskey = S
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Firefox za <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> abo <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> sćahnyć, zo byšće ze swojim mobilnym gratom synchronizował.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Profilowy wobraz změnić
sync-sign-out =
    .label = Wotzjewić…
    .accesskey = t
sync-manage-account = Konto rjadować
    .accesskey = o
sync-signedin-unverified = { $email } njeje so přepruwował.
sync-signedin-login-failure = Prošu zregistrujće so, zo byšće znowa zwjazał { $email }
sync-resend-verification =
    .label = Wobkrućenje znowa pósłać
    .accesskey = s
sync-remove-account =
    .label = Konto wotstronić
    .accesskey = s
sync-sign-in =
    .label = Přizjewić
    .accesskey = z

## Sync section - enabling or disabling sync.

prefs-syncing-on = Synchronizacija: ZAPINJENY
prefs-syncing-off = Synchronizacija: WUPINJENY
prefs-sync-setup =
    .label = { -sync-brand-short-name } konfigurować
    .accesskey = k
prefs-sync-offer-setup-label = Synchronizujće swoje zapołožki, historiju, rajtarki, hesła, přidatki a nastajenja mjez wšěmi wašimi gratami.
prefs-sync-now =
    .labelnotsyncing = Nětko synchronizować
    .accesskeynotsyncing = N
    .labelsyncing = Synchronizuje so…

## The list of things currently syncing.

sync-currently-syncing-heading = Synchronizujeće tuchwilu slědowace zapiski:
sync-currently-syncing-bookmarks = Zapołožki
sync-currently-syncing-history = Historija
sync-currently-syncing-tabs = Wočinjene rajtarki
sync-currently-syncing-logins-passwords = Přizjewjenja a hesła
sync-currently-syncing-addresses = Adresy
sync-currently-syncing-creditcards = Kreditne karty
sync-currently-syncing-addons = Přidatki
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Nastajenja
       *[other] Nastajenja
    }
sync-change-options =
    .label = Změnić…
    .accesskey = Z

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Wubjerće, štož ma so synchronizować
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Změny składować
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Dźělić
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = Zapołožki
    .accesskey = Z
sync-engine-history =
    .label = Historiju
    .accesskey = t
sync-engine-tabs =
    .label = Wotewrjene rajtarki
    .tooltiptext = Lisćina ze wšěm, štož je wočinjene na wšěch synchronizowanych gratach
    .accesskey = r
sync-engine-logins-passwords =
    .label = Přizjewjenja a hesła
    .tooltiptext = Wužiwarske mjena a hesła, kotrež sće składował
    .accesskey = P
sync-engine-addresses =
    .label = Adresy
    .tooltiptext = Póstowe adresy, kotrež sće składował (jenož desktop)
    .accesskey = e
sync-engine-creditcards =
    .label = Kreditne karty
    .tooltiptext = Mjena, ličby a datumy spadnjenja (jenož desktop)
    .accesskey = K
sync-engine-addons =
    .label = Přidatki
    .tooltiptext = Rozšěrjenja a drasty za desktopowy Firefox
    .accesskey = P
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Nastajenja
           *[other] Nastajenja
        }
    .tooltiptext = Powšitkowne nastajenja, nastajenja priwatnosće a wěstoty, kotrež sće změnił
    .accesskey = N

## The device name controls.

sync-device-name-header = Mjeno grata
sync-device-name-change =
    .label = Mjeno grata změnić…
    .accesskey = z
sync-device-name-cancel =
    .label = Přetorhnyć
    .accesskey = t
sync-device-name-save =
    .label = Składować
    .accesskey = k
sync-connect-another-device = Z druhim gratom zwjazać

## Privacy Section

privacy-header = Priwatnosć wobhladowaka

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Přizjewjenja a hesła
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Prašeć so, hač so maja přizjewjenja a hesła składować
    .accesskey = r
forms-exceptions =
    .label = Wuwzaća…
    .accesskey = u
forms-generate-passwords =
    .label = Mócne hesła wutworić a namjetować
    .accesskey = h
forms-breach-alerts =
    .label = Warnowanja za hesła přez datowu dźěru potrjechenych websydłow
    .accesskey = z
forms-breach-alerts-learn-more-link = Dalše informacije
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Přizjewjenja a hesła awtomatisce zapisać
    .accesskey = z
forms-saved-logins =
    .label = Składowane přizjewjenja…
    .accesskey = S
forms-master-pw-use =
    .label = Hłowne hesło wužiwać
    .accesskey = o
forms-primary-pw-use =
    .label = Hłowne hesło wužiwać
    .accesskey = H
forms-primary-pw-learn-more-link = Dalše informacije
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Hłowne hesło změnić…
    .accesskey = m
forms-master-pw-fips-title = Sće tuchwilu we FIPS-modusu. FIPS sej hłowne hesło žada.
forms-primary-pw-change =
    .label = Hłowne hesło změnić…
    .accesskey = z
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Sće tuchwilu we FIPS-modusu. FIPS sej hłowne hesło žada.
forms-master-pw-fips-desc = Změnjenje hesła njeje so poradźiło

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Zapodajće swoje přizjewjenske daty Windows, zo byšće hłowne hesło wutworił. To wěstotu wašich kontow škita.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = hłowne hesło wutworić
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Zapodajće swoje přizjewjenske daty Windows, zo byšće hłowne hesło wutworił. To wěstotu wašich kontow škita.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Hłowne hesło wutworić
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
history-remember-label = { -brand-short-name } budźe
    .accesskey = b
history-remember-option-all =
    .label = Sej historiju spomjatkować
history-remember-option-never =
    .label = Sej historiju ženje njespomjatkować
history-remember-option-custom =
    .label = Swójske nastajenja za historiju wužiwać
history-remember-description = { -brand-short-name } budźe sej wašu přehladowansku, sćehnjensku, formularnu a pytansku historiju spomjatkować.
history-dontremember-description = { -brand-short-name } budźe samsne nastajenja kaž w priwatnym modusu wužiwać a njebuźde sej historiju spomjatkować, hdyž Web přehladujeće.
history-private-browsing-permanent =
    .label = Přeco priwatny modus wužiwać
    .accesskey = P
history-remember-browser-option =
    .label = Sej přehladowansku a sćehnjensku historiju spomjatkować
    .accesskey = m
history-remember-search-option =
    .label = Pytansku a formularnu historiju sej spomjatkować
    .accesskey = f
history-clear-on-close-option =
    .label = Historiju wuprózdnić, hdyž so { -brand-short-name } začinja
    .accesskey = H
history-clear-on-close-settings =
    .label = Nastajenja…
    .accesskey = N
history-clear-button =
    .label = Historiju zhašeć…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Placki a sydłowe daty
sitedata-total-size-calculating = Wulkosć sydłowych datow a pufrowaka so wuličuje…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Waše składowane placki, sydłowe daty a pufrowak so tuchwilu { $value } { $unit } tačeloweho ruma wužiwaja.
sitedata-learn-more = Dalše informacije
sitedata-delete-on-close =
    .label = Placki a sydłowe daty zhašeć, hdyž so { -brand-short-name } začinja
    .accesskey = s
sitedata-delete-on-close-private-browsing = W stajnym priwatnym modusu so placki a sydłowe daty přeco zhašeja, hdyž so { -brand-short-name } začinja.
sitedata-allow-cookies-option =
    .label = Placki a sydłowe daty akceptować
    .accesskey = P
sitedata-disallow-cookies-option =
    .label = Placki a sydłowe daty blokować
    .accesskey = b
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Zablokowany typ
    .accesskey = Z
sitedata-option-block-cross-site-trackers =
    .label = Přesćěhowaki mjez sydłami
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Přesćěhowaki mjez sydłami a socialnych medijow
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Přesćěhowaki wjacorych sydłow a přesćěhowaki socialnych medijow a izolowanje zbytnych plackow
sitedata-option-block-unvisited =
    .label = Placki z njewopytanych websydłow
sitedata-option-block-all-third-party =
    .label = Wšě placki třećich (móže zawinować, zo websydła hižo njefunguja)
sitedata-option-block-all =
    .label = Wšě placki (móže zawinować, zo websydła hižo njefunguja)
sitedata-clear =
    .label = Daty zhašeć…
    .accesskey = z
sitedata-settings =
    .label = Daty zrjadować…
    .accesskey = D
sitedata-cookies-permissions =
    .label = Prawa rjadować…
    .accesskey = P
sitedata-cookies-exceptions =
    .label = Wuwzaća rjadować…
    .accesskey = W

## Privacy Section - Address Bar

addressbar-header = Adresowe polo
addressbar-suggest = Při wužiwanju adresoweho pola ma so namjetować
addressbar-locbar-history-option =
    .label = Přehladowanska historija
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = Zapołožki
    .accesskey = Z
addressbar-locbar-openpage-option =
    .label = Wočinjene rajtarki
    .accesskey = o
addressbar-locbar-topsites-option =
    .label = Najhusćišo wopytane sydła
    .accesskey = N
addressbar-suggestions-settings = Nastajenja za namjety pytawy změnić

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Polěpšeny slědowanski škit
content-blocking-section-top-level-description = Přesćěhowaki wam online slěduja, zo bychu informacije wo wašich přehladowanskich zwučenosćach a zajimach hromadźili. { -brand-short-name } wjele z tutych přesćěhowakow a druhe złóstne skripty blokuje.
content-blocking-learn-more = Dalše informacije

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

content-blocking-etp-standard-desc = Wuwaženy za škit a wukon. Strony so normalnje začitaja.
content-blocking-etp-strict-desc = Mócniši škit, ale móže zawinować, zo někotre sydła abo wobsah hižo njefunguja.
content-blocking-etp-custom-desc = Wubjerće, kotre přesćěhowaki a skripty maja so blokować.
content-blocking-private-windows = Slědowacy škit w priwatnych woknach
content-blocking-cross-site-tracking-cookies = Slědowace placki mjez sydłami
content-blocking-cross-site-tracking-cookies-plus-isolate = Wjacore sydła slědowace placki a izolowanje zbytnych plackow
content-blocking-social-media-trackers = Přesćěhowaki socialnych medijow
content-blocking-all-cookies = Wšě placki
content-blocking-unvisited-cookies = Placki z njewopytanych sydłow
content-blocking-all-windows-tracking-content = Slědowacy wobsah we wšěch woknach
content-blocking-all-third-party-cookies = Wšě placki třećich
content-blocking-cryptominers = Kryptokopanje
content-blocking-fingerprinters = Porstowe wotćišće
content-blocking-warning-title = Kedźbu!
content-blocking-and-isolating-etp-warning-description = Blokowanje přesćěhowakow a izolowanje placko móhłoj funkcionalnosć někotrych websydłow wobwliwować. Začitajće stronu z přesćěhowakami znowa, zo byšće wšón wobsah začitał.
content-blocking-warning-learn-how = Zhońće kak
content-blocking-reload-description = Dyrbiće swoje rajtarki znowa začitać, zo byšće tute změny nałožił.
content-blocking-reload-tabs-button =
    .label = Wšě rajtarki znowa začitać
    .accesskey = W
content-blocking-tracking-content-label =
    .label = Slědowacy wobsah
    .accesskey = S
content-blocking-tracking-protection-option-all-windows =
    .label = We wšěch woknach
    .accesskey = W
content-blocking-option-private =
    .label = Jenož w priwatnych woknach
    .accesskey = J
content-blocking-tracking-protection-change-block-list = Blokowansku lisćinu změnić
content-blocking-cookies-label =
    .label = Placki
    .accesskey = P
content-blocking-expand-section =
    .tooltiptext = Dalše informacije
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Kryptokopanje
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Porstowe wotćišće
    .accesskey = P

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Wuwzaća rjadować…
    .accesskey = u

## Privacy Section - Permissions

permissions-header = Prawa
permissions-location = Městno
permissions-location-settings =
    .label = Nastajenja…
    .accesskey = t
permissions-xr = Wirtualna realita
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
permissions-notification = Zdźělenja
permissions-notification-settings =
    .label = Nastajenja…
    .accesskey = n
permissions-notification-link = Dalše informacije
permissions-notification-pause =
    .label = Zdźělenja zastajić, doniž so { -brand-short-name } znowa njestartuje
    .accesskey = z
permissions-autoplay = Awtomatiske wothraće
permissions-autoplay-settings =
    .label = Nastajenja…
    .accesskey = N
permissions-block-popups =
    .label = Wuskakowace wokno blokować
    .accesskey = k
permissions-block-popups-exceptions =
    .label = Wuwzaća…
    .accesskey = W
permissions-addon-install-warning =
    .label = Warnować, hdyž sydła pospytuja přidatki instalować
    .accesskey = W
permissions-addon-exceptions =
    .label = Wuwzaća…
    .accesskey = W
permissions-a11y-privacy-checkbox =
    .label = Słužby bjezbarjernosće při přistupu k wašemu wobhladowakej haćić
    .accesskey = b
permissions-a11y-privacy-link = Dalše informacije

## Privacy Section - Data Collection

collection-header = Hromadźenje a wužiwanje datow { -brand-short-name }
collection-description = Chcemy was z wuběrami wobstarać a jenož to zběrać, štož dyrbimy poskićić, zo bychmy { -brand-short-name } za kóždeho polěpšili. Prosymy přeco wo dowolnosć, prjedy hač wosobinske daty dóstanjemy.
collection-privacy-notice = Zdźělenka priwatnosće
collection-health-report-telemetry-disabled = Sće { -vendor-short-name } dowolnosć zebrał, techniske a interakciske daty hromadźić. Wšě dotal zhromadźene daty so w běhu 30 dnjow zhašeja.
collection-health-report-telemetry-disabled-link = Dalše informacije
collection-health-report =
    .label = { -brand-short-name } zmóžnić, techniske a interakciske daty na { -vendor-short-name } pósłać
    .accesskey = t
collection-health-report-link = Dalše informacije
collection-studies =
    .label = { -brand-short-name } dowolić, studije instalować a přewjesć
collection-studies-link = Studije { -brand-short-name } pokazać
addon-recommendations =
    .label = { -brand-short-name } dowolić, personalizowane poručenja za rozšěrjenja dać
addon-recommendations-link = Dalše informacije
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datowe rozprawjenje je znjemóžnjene za tutu programowu konfiguraciju
collection-backlogged-crash-reports =
    .label = { -brand-short-name } dowolić, njewobdźěłane spadowe rozprawy we wašim mjenje pósłać
    .accesskey = r
collection-backlogged-crash-reports-link = Dalše informacije

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Wěstota
security-browsing-protection = Škit před wobšudnym wobsahom a strašnej softwaru
security-enable-safe-browsing =
    .label = Strašny a wobšudny wobsah blokować
    .accesskey = S
security-enable-safe-browsing-link = Dalše informacije
security-block-downloads =
    .label = Strašne sćehnjenja blokować
    .accesskey = s
security-block-uncommon-software =
    .label = Před njewitanej a njewšědnej softwaru warnować
    .accesskey = w

## Privacy Section - Certificates

certs-header = Certifikaty
certs-personal-label = Hdyž sej serwer waš wosobinski certifikat žada
certs-select-auto-option =
    .label = Awtomatisce wubrać
    .accesskey = s
certs-select-ask-option =
    .label = Kóždy raz so prašeć
    .accesskey = K
certs-enable-ocsp =
    .label = Pola wotmołwnych serwerow OCSP so naprašować, zo by aktualnu płaćiwosć certifikatow wobkrućiło
    .accesskey = P
certs-view =
    .label = Certifikaty pokazać…
    .accesskey = C
certs-devices =
    .label = Wěstotne graty…
    .accesskey = t
space-alert-learn-more-button =
    .label = Dalše informacije
    .accesskey = D
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Nastajenja wočinić
           *[other] Nastajenja wočinić
        }
    .accesskey =
        { PLATFORM() ->
            [windows] N
           *[other] N
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } hižo dosć składowanskeho ruma nima. Wobsah websydła so snano korektnje njezwobrazni. Móžeće składowane daty w Nastajenja > Priwatnosć a wěstota > Placki a sydłowe daty zhašeć.
       *[other] { -brand-short-name } hižo dosć składowanskeho ruma nima. Wobsah websydła so snano korektnje njezwobrazni. Móžeće składowane daty w Nastajenja > Priwatnosć a wěstota > Placki a sydłowe daty zhašeć.
    }
space-alert-under-5gb-ok-button =
    .label = W porjadku, sym zrozumił
    .accesskey = r
space-alert-under-5gb-message = { -brand-short-name } hižo dosć składowanskeho ruma nima. Wobsah websydła so snano korektnje njezwobrazni. Móžeće na “Dalše informacije” kliknyć, zo byšće swój składowe wužiće za lěpše přehladowanske dožiwjenje opiměrował.

## Privacy Section - HTTPS-Only

httpsonly-header = Modus jenož HTTPS
httpsonly-description = HTTPS wěsty, zaklučowany zwisk mjez { -brand-short-name } a websydłami skići, kotrež wopytujeće. Najwjace websydłow HTTPS podpěruje, a jeli modus Jenož-HTTPS je zmóžnjeny, { -brand-short-name } budźe wšě zwiski na HTTPS aktualizować.
httpsonly-learn-more = Dalše informacije
httpsonly-radio-enabled =
    .label = Modus Jenož-HTTPS we wšěch woknach zmóžnić
httpsonly-radio-enabled-pbm =
    .label = Modus Jenož-HTTPS jenož w priwatnych woknach zmóžnić
httpsonly-radio-disabled =
    .label = Modus Jenož-HTTPS njezmóžnić

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Sćehnjenja
choose-download-folder-title = Rjadowak sćehnjenjow wubrać:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Dataje do { $service-name } składować
