# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Padalhan ng ”Do Not Track” signal ang mga website para sabihing hindi mo nais na ika'y subaybayan
do-not-track-learn-more = Matuto ng higit pa
do-not-track-option-default-content-blocking-known =
    .label = Payagan lang kung ang { -brand-short-name } ay naka-set na mag-block ng mga kilalang tracker.
do-not-track-option-always =
    .label = Palagi
pref-page-title =
    { PLATFORM() ->
        [windows] Options
       *[other] Mga Kagustuhan
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
            [windows] Hanapin sa Mga Pagpipilian
           *[other] Hanapin sa Mga Kagustuhan
        }
managed-notice = Ang iyong browser ay mina-manage ng iyong organisasyon.
pane-general-title = Pangkalahatan
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Home
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Paghanap
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Pribasiya at Seguridad
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = Mga { -brand-short-name } Experiment
category-experimental =
    .tooltiptext = Mga { -brand-short-name } Experiment
pane-experimental-subtitle = Mag-ingat sa Pagpatuloy
pane-experimental-search-results-header = Mga { -brand-short-name } Experiment: Mag-ingat sa Pagpatuloy
help-button-label = Suporta sa { -brand-short-name }
addons-button-label = Mga Extension at Tema
focus-search =
    .key = f
close-button =
    .aria-label = Sarado

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } ay dapat simulan ulit upang paganahin ang tampok na ito.
feature-disable-requires-restart = { -brand-short-name } ay dapat simulan ulit upang hindi paganahin ang tampok na ito.
should-restart-title = I-Restart { -brand-short-name }
should-restart-ok = I-restart na ngayon ang { -brand-short-name }
cancel-no-restart-button = Kanselahin
restart-later = I-restart Mamaya

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
extension-controlled-homepage-override = Ang extension, <img data-l10n-name="icon"/> { $name }, ay kumokontrol sa iyong home page.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Ang extension, <img data-l10n-name="icon"/> { $name }, ay kumokontrol sa iyong Bagong Tab page.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = An extension, <img data-l10n-name="icon"/> { $name }, is controlling this setting.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Ang extension, <img data-l10n-name="icon"/> { $name }, ay sinet ang iyong default search engine.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Ang extension, <img data-l10n-name="icon"/> { $name }, ay nangangailangan ng Container Tabs.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = An extension, <img data-l10n-name="icon"/> { $name }, is controlling this setting.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Ang extension, <img data-l10n-name="icon"/> { $name }, ay nagkokontrol kung pano nagcoconnect ang { -brand-short-name } sa internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Upang paganahin ang extension pumunta sa <img data-l10n-name = "addons-icon" /> Mga Add-on sa menu na <img data-l10n-name = "menu-icon" />.

## Preferences UI Search Results

search-results-header = Resulta ng Paghahanap
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Paumanhin! Walang mga resulta sa Mga Pagpipilian para sa “<span data-l10n-name="query"></span>”.
       *[other] Paumanhin! Walang mga resulta sa Mga Kagustuhan para sa “<span data-l10n-name="query"></span>”.
    }
search-results-help-link = Kailangan ng tulong? Bisitahin ang <a data-l10n-name="url">{ -brand-short-name } Support </a>

## General Section

startup-header = Startup
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Payagan ang { -brand-short-name } at Firefox na tumakbo nang sabay
use-firefox-sync = Tip: Gumagamit ito ng mga hiwalay na profile. Gumamit ng { -sync-brand-short-name } upang ibahagi ang data sa pagitan nila.
get-started-not-logged-in = Mag-sign in sa { -sync-brand-short-name }…
get-started-configured = Buksan ang mga preference ng { -sync-brand-short-name }
always-check-default =
    .label = Laging suriin kung { -brand-short-name } ang iyong default na browser
    .accesskey = y
is-default = { -brand-short-name } ay ang iyong kasalukuyang ginagamit na browser.
is-not-default = Hindi { -brand-short-name } ang iyong default na browser
set-as-my-default-browser =
    .label = Gawing Default…
    .accesskey = D
startup-restore-previous-session =
    .label = Ibalik ang Nakaraang Session
    .accesskey = S
startup-restore-warn-on-quit =
    .label = Balaan ka kapag isinara ang browser
disable-extension =
    .label = Huwag Paganahin and Extensyon
tabs-group-header = Tabs
ctrl-tab-recently-used-order =
    .label = Iniisa-isa ng Ctrl+Tab ang mga tab base sa pinakahuling ginamit
    .accesskey = T
open-new-link-as-tabs =
    .label = Buksan ang mga link sa mga tab sa halip na mga bagong window
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = Balaan ka kapag magsasara ng maraming tab
    .accesskey = m
warn-on-open-many-tabs =
    .label = Balaan ka kapag ang pagbukas ng maraming mga tab ay maaaring makapagpabagal sa { -brand-short-name }
    .accesskey = d
switch-links-to-new-tabs =
    .label = Kapag binuksan mo ang link sa bagong tab, lumipat kaagad doon
    .accesskey = h
show-tabs-in-taskbar =
    .label = Ipakita ang paunang-tingin na tab sa Windows taskbar
    .accesskey = k
browser-containers-enabled =
    .label = Paganahin ang mga Container Tab
    .accesskey = n
browser-containers-learn-more = Matuto ng higit pa
browser-containers-settings =
    .label = Mga setting…
    .accesskey = i
containers-disable-alert-title = Isara Lahat ng Mga Container Tab?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Kapag dinisable mo ngayon ang Container Tabs, may { $tabCount } container tab na isasara. Sigurado ka bang gusto mo i-disable ang Container Tabs?
       *[other] Kapag dinisable mo ngayon ang Container Tabs, may { $tabCount } container tab na isasara. Sigurado ka bang gusto mo i-disable ang Container Tabs?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Isara ang { $tabCount } Container Tab
       *[other] Isara ang { $tabCount } Container Tab
    }
containers-disable-alert-cancel-button = Patuloy na pinagana
containers-remove-alert-title = Alisin ang Lalagyan na Ito?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Kapag tinanggal mo ngayon ang Container na ito, may { $count } container tab na isasara. Sigurado ka bang gusto mong tanggalin ang Container na ito?
       *[other] Kapag tinanggal mo ngayon ang Container na ito, may { $count } container tab na isasara. Sigurado ka bang gusto mong tanggalin ang Container na ito?
    }
containers-remove-ok-button = Alisin ang Container na Ito
containers-remove-cancel-button = Huwag alisin ang Container na ito

## General Section - Language & Appearance

language-and-appearance-header = Wika at Hitsura
fonts-and-colors-header = Mga Font at Kulay
default-font = Default na font
    .accesskey = D
default-font-size = Laki
    .accesskey = S
advanced-fonts =
    .label = Advanced…
    .accesskey = A
colors-settings =
    .label = Mga Kulay…
    .accesskey = M
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Default zoom
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = I-zoom ang text lamang
    .accesskey = z
language-header = Wika
choose-language-description = Pumili ng iyong gustong wika para sa pagpapakita ng mga pahina
choose-button =
    .label = Mamili…
    .accesskey = M
choose-browser-language-description = Choose the languages used to display menus, messages, and notifications from { -brand-short-name }.
manage-browser-languages-button =
    .label = Itakda ang Alternatibo ...
    .accesskey = I
confirm-browser-language-change-description = I-restart ang { -brand-short-name } para mailapat ang mga pagbabagong ito
confirm-browser-language-change-button = Ilapat at mag-restart
translate-web-pages =
    .label = Isalin ang nilalaman ng web
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Mga pagsasalin sa pamamagitan ng <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Mga exception...
    .accesskey = x
check-user-spelling =
    .label = Suriin ang pagkakabaybay habang nagta-type
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Mga File at Application
download-header = Mga Download
download-save-to =
    .label = I-save ang mga file sa
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Pumili...
           *[other] Browse…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }
download-always-ask-where =
    .label = Lagi kang tanungin kung saan magse-save ng mga file
    .accesskey = A
applications-header = Mga Application
applications-description = Piliin kung ano ang gagawin ng { -brand-short-name } sa mga file na iyong na-download mula sa web o mga application na iyong ginagamit habang nagba-browse.
applications-filter =
    .placeholder = Maghanap ng mga uri ng file o mga application
applications-type-column =
    .label = Uri ng Nilalaman
    .accesskey = T
applications-action-column =
    .label = Aksyon
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } file
applications-action-save =
    .label = I-save ang File
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Gamitin ang { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Gamitin ang { $app-name } (default)
applications-use-other =
    .label = Gumamit ng iba...
applications-select-helper = Piliin ang Helper na Applikasyon
applications-manage-app =
    .label = Mga Detalye ng Applikasyon…
applications-always-ask =
    .label = Palaging itanong
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
    .label = Gamitin ang { $plugin-name } (sa { -brand-short-name })
applications-open-inapp =
    .label = Buksan sa { -brand-short-name }

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

drm-content-header = Digital Rights Management (DRM) Content
play-drm-content =
    .label = Magpaandar ng DRM-controlled content
    .accesskey = P
play-drm-content-learn-more = Alamin
update-application-title = Mga update ng { -brand-short-name }
update-application-description = Panatilihing updated ang { -brand-short-name } para sa pinakamahusay na pagtakbo, katatagan, at seguridad.
update-application-version = Bersyon { $version } <a data-l10n-name="learn-more">Ano ang bago?</a>
update-history =
    .label = Ipakita ang Kasaysayan ng Pag-update...
    .accesskey = p
update-application-allow-description = Payagan ang { -brand-short-name } na
update-application-auto =
    .label = Kusang magkabit ng mga update (inirerekomenda)
    .accesskey = A
update-application-check-choose =
    .label = Suriin kung may mga update, subalit hayaan ka kung ikakabit ang mga ito
    .accesskey = C
update-application-manual =
    .label = Huwag kailanman mag-check kung may mga update (hindi rekomendado)
    .accesskey = N
update-application-warning-cross-user-setting = Ang setting na ito ay gagamitin sa lahat ng mga Windows account at { -brand-short-name } profile na gumagamit ng installation na ito ng { -brand-short-name }.
update-application-use-service =
    .label = Gumamit ng background service upang ikabit ang mga update
    .accesskey = b
update-setting-write-failure-title = Nagkaroon ng problema sa pag-save ng Update preferences.
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    Nagkaroon ng problema ang { -brand-short-name } at hindi nagawang i-save ang pagbabagong ito. Tandaan na ang pagbago sa update preference na ito ay nangangailangan ng pahintulot para mabago ang file sa baba. Maaaring maayos mo o ng isang system administrator ang problema sa pamamagitan ng pagbigay ng kumpletong access sa Users group sa file na ito.
    
    Hindi makasulat sa file: { $path }
update-in-progress-title = Kasalukuyang Nag-a-update
update-in-progress-message = Gusto mo bang ipagpatuloy ng { -brand-short-name } ang update na ito?
update-in-progress-ok-button = Isangtabi
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Magpatuloy

## General Section - Performance

performance-title = Performance
performance-use-recommended-settings-checkbox =
    .label = Gamitin ang inirerekomendang mga performance setting
    .accesskey = U
performance-use-recommended-settings-desc = Ang mga setting na ito ay pinasadya sa hardware at operating system ng iyong computer.
performance-settings-learn-more = Karagdagang kalaaman
performance-allow-hw-accel =
    .label = Gumamit ng hardware acceleration kapag maaari
    .accesskey = r
performance-limit-content-process-option = Nasa limitasyon na ang pag proseso ng content
    .accesskey = L
performance-limit-content-process-enabled-desc = Ang karagdagang mga content process ay maaaring magpaganda ng performance kapag marami ang mga tab, ngunit gagamit din ito ng mas maraming memory.
performance-limit-content-process-blocked-desc = Ang pagbabago sa bilang ng mga proseso ng nilalaman ay posible lamang sa multiprocess { -brand-short-name }. <a data-l10n-name="learn-more">Alamin kung paano i-check kung ang multiprocess ay pinagana</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (default)

## General Section - Browsing

browsing-title = Pag-browse
browsing-use-autoscroll =
    .label = Gumamit ng autoscrolling
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Gumamit ng smooth scrolling
    .accesskey = m
browsing-use-onscreen-keyboard =
    .label = Ipakita ang touch keyboard kung kinakailangan
    .accesskey = k
browsing-use-cursor-navigation =
    .label = Palaging gamitin ang mga cursor key para lumibot sa mga pahina
    .accesskey = k
browsing-search-on-start-typing =
    .label = Maghanap ng text kapag nag-umpisang mag-type
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = I-enable ang picture-in-picture video control
    .accesskey = E
browsing-picture-in-picture-learn-more = Alamin
browsing-cfr-recommendations =
    .label = Magrekomenda ng mga extension habang ika'y nagba-browse
    .accesskey = R
browsing-cfr-features =
    .label = Magrekomenda ng mga feature habang nagba-browse
    .accesskey = f
browsing-cfr-recommendations-learn-more = Alamin pa

## General Section - Proxy

network-settings-title = Mga Network Setting
network-proxy-connection-description = I-configure kung pano kumokonekta ang { -brand-short-name } sa internet.
network-proxy-connection-learn-more = Matuto ng higit pa
network-proxy-connection-settings =
    .label = Mga Setting…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = Bagong mga Window at Tab
home-new-windows-tabs-description2 = Pumili ng kung ano ang gustong makita kapag binubuksan ang iyong homepage, mga bagong window, at mga bagong tab.

## Home Section - Home Page Customization

home-homepage-mode-label = Homepage at mga bagong window
home-newtabs-mode-label = Mga bagong tab
home-restore-defaults =
    .label = Ibalik sa dating ayos
    .accesskey = I
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox Home (Default)
home-mode-choice-custom =
    .label = Custom URLs...
home-mode-choice-blank =
    .label = Blangkong Pahina
home-homepage-custom-url =
    .placeholder = I-paste ang URL...
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Gamitin ang Kasalukuyang Pahina
           *[other] Gamitin ang kasalukuyang mga pahina
        }
    .accesskey = G
choose-bookmark =
    .label = Gumamit ng Bookmark...
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Makikita sa Home ng Firefox
home-prefs-content-description = Piliin kung anong nilalaman ang gusto mo sa iyong screen ng Home ng Firefox.
home-prefs-search-header =
    .label = Paghahanap sa Web
home-prefs-topsites-header =
    .label = Mga Pangunahing Site
home-prefs-topsites-description = Ang mga site na iyong pinupuntahan

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Inirekomenda ni { $provider }

##

home-prefs-recommended-by-learn-more = Paano ito gumagana
home-prefs-recommended-by-option-sponsored-stories =
    .label = Mga Na-sponsor na Kwento
home-prefs-highlights-header =
    .label = Mga highlight
home-prefs-highlights-description = Ang isang seleksyon ng mga site na iyong nai-save o binisita
home-prefs-highlights-option-visited-pages =
    .label = Mga pahinang binisita
home-prefs-highlights-options-bookmarks =
    .label = Mga bookmark
home-prefs-highlights-option-most-recent-download =
    .label = Mga Download Kamakailan
home-prefs-highlights-option-saved-to-pocket =
    .label = Mga Pahinang Naka-save sa { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Mga snippet
home-prefs-snippets-description = Mga Update mula sa { -vendor-short-name } at { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } hilera
           *[other] { $num } mga hilera
        }

## Search Section

search-bar-header = Search Bar
search-bar-hidden =
    .label = Gamitin ang address bar para sa paghahanap at pag-navigate
search-bar-shown =
    .label = Idagdag ang search bar sa toolbar
search-engine-default-header = Default na Search Engine
search-engine-default-private-desc-2 = Pumili ng ibang default na search engine para lang sa mga Private Window
search-separate-default-engine =
    .label = Gamitin ang search engine na ito sa mga Private Window
    .accesskey = U
search-suggestions-header = Mga Mungkahi sa Paghanap
search-suggestions-desc = Piliin kung paano lumalabas ang mga mungkahi na galing sa mga search engine.
search-suggestions-option =
    .label = Magbigay ng mga mungkahi sa paghahanap
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = Ipakita ang mga mungkahi sa paghahanap sa mga resulta sa address bar
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Unahing ipakita ang mga mungkahi sa paghahanap bago ang kasaysayan ng pag-browse sa mga resulta sa address bar
search-show-suggestions-private-windows =
    .label = Magpakita ng mga mungkahi sa paghahanap sa mga Private Window
search-suggestions-cant-show = Ang mga mungkahi sa paghahanap ay hindi ipapakita sa location bar dahil na-configure mo ang { -brand-short-name } na hindi kailanman tatandaan ang kasaysayan.
search-one-click-header = Mga One-Click Search Engine
search-one-click-desc = Piliin ang mga alternatibong search engine na lalabas sa ibaba ng address bar at search bar kapag nagsimula kang magpasok ng isang keyword.
search-choose-engine-column =
    .label = Search Engine
search-choose-keyword-column =
    .label = Keyword
search-restore-default =
    .label = Ibalik ang Mga Default na Mga Search Engine
    .accesskey = d
search-remove-engine =
    .label = Alisin
    .accesskey = r
search-add-engine =
    .label = Magdagdag
    .accesskey = A
search-find-more-link = Maghanap ng mga karagdagang search engine
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Nadobleng Keyword
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Ginagamit ng “{ $name }” ang pinili mong keyword. Pumili nalang ng iba.
search-keyword-warning-bookmark = Ginagamit na ng isang bookmark ang keyword na pinili mo. Pumili ng iba pa.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Bumalik sa mga Pagpipilian
           *[other] Bumalik sa mga Kagustuhan
        }
containers-header = Mga Container Tab
containers-add-button =
    .label = Magdagdag ng Bagong Container
    .accesskey = A
containers-new-tab-check =
    .label = Pumili ng container para sa bawat bagong tab
    .accesskey = S
containers-preferences-button =
    .label = Mga Kagustuhan
containers-remove-button =
    .label = Alisin

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Dalhin Mo Ang Web Kahit Saan
sync-signedout-description = I-synchronize ang iyong mga bookmark, kasaysayan, tab, password, add-on, at kagustuhan sa lahat ng iyong mga device.
sync-signedout-account-signin2 =
    .label = Mag-sign in sa { -sync-brand-short-name }…
    .accesskey = i
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = I-download ang Firefox para sa<img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> o <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> upang i-sync sa iyong mobile device.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Baguhin ang larawan ng profile
sync-sign-out =
    .label = Mag-sign out...
    .accesskey = g
sync-manage-account = Pamahalaan ang account
    .accesskey = o
sync-signedin-unverified = { $email } ay hindi napatunayan.
sync-signedin-login-failure = Mangyaring mag-sign in upang makipagkonek muli { $email }
sync-resend-verification =
    .label = Ipadala muli ang Beripikasyon
    .accesskey = d
sync-remove-account =
    .label = Alisin ang Account
    .accesskey = A
sync-sign-in =
    .label = Mag sign in
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = Syncing: ON
prefs-syncing-off = Syncing: OFF
prefs-sync-setup =
    .label = Mag-set up ng { -sync-brand-short-name }...
    .accesskey = S
prefs-sync-offer-setup-label = I-synchronize ang iyong mga bookmark, kasaysayan, tab, password, add-on, at mga kagustuhan sa lahat ng iyong mga device.
prefs-sync-now =
    .labelnotsyncing = Mag-Sync Na
    .accesskeynotsyncing = N
    .labelsyncing = Nagsi-sync...

## The list of things currently syncing.

sync-currently-syncing-heading = Kasalukuyan kang nagsi-sync ng mga sumusunod:
sync-currently-syncing-bookmarks = Mga Bookmark
sync-currently-syncing-history = Kasaysayan
sync-currently-syncing-tabs = Mga nakabukas na tab
sync-currently-syncing-logins-passwords = Mga Login at Password
sync-currently-syncing-addresses = Mga tirahan
sync-currently-syncing-creditcards = Mga Credit Card
sync-currently-syncing-addons = Mga Add-on
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Mga Pagpipilian
       *[other] Mga Kagustuhan
    }
sync-change-options =
    .label = Baguhin…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Piliin Kung Alin Ang Isi-Sync
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = I-Save ang mga Pagbabago
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Mag-disconnect...
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = Mga Bookmark
    .accesskey = m
sync-engine-history =
    .label = Kasaysayan
    .accesskey = r
sync-engine-tabs =
    .label = Mga nakabukas na tab
    .tooltiptext = Listahan ng kung ano ang nakabukas sa mga naka-sync na device
    .accesskey = B
sync-engine-logins-passwords =
    .label = Mga Login at Password
    .tooltiptext = Mga username at password na naka-save
    .accesskey = L
sync-engine-addresses =
    .label = Mga tirahan
    .tooltiptext = Mga nai-save mo na mga postal address (sa desktop lang)
    .accesskey = e
sync-engine-creditcards =
    .label = Mga credit card
    .tooltiptext = Mga credit card
    .accesskey = c
sync-engine-addons =
    .label = Mga Add-on
    .tooltiptext = Mga extension at tema para sa Firefox desktop
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Mga Pagpipilian
           *[other] Mga Kagustuhan
        }
    .tooltiptext = Mga setting na pangkalahatan, pang-pribasiya, at pang-seguridad na iyong binago
    .accesskey = P

## The device name controls.

sync-device-name-header = Pangalan ng Device
sync-device-name-change =
    .label = Palitan ang Pangalan ng Device...
    .accesskey = h
sync-device-name-cancel =
    .label = Kanselahin
    .accesskey = n
sync-device-name-save =
    .label = I-save
    .accesskey = v
sync-connect-another-device = Magkonekta ng Isa Pang Device

## Privacy Section

privacy-header = Browser Privacy

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Mga Login at mga Password
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Magtanong kung dapat mag-save ng mga login at password sa mga website
    .accesskey = r
forms-exceptions =
    .label = Mga exception...
    .accesskey = x
forms-generate-passwords =
    .label = Magmungkahi at gumawa ng malakas na password
    .accesskey = u
forms-breach-alerts =
    .label = Magpakita ng mga alerto tungkol sa mga password sa mga breached website
    .accesskey = b
forms-breach-alerts-learn-more-link = Alamin
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = I-autofill ang mga login at password
    .accesskey = i
forms-saved-logins =
    .label = Mga na-save na Login…
    .accesskey = L
forms-master-pw-use =
    .label = Gumamit ng master password
    .accesskey = U
forms-primary-pw-use =
    .label = Gumamit ng Primary Password
    .accesskey = U
forms-primary-pw-learn-more-link = Alamin
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Palitan ang Master Password...
    .accesskey = M
forms-master-pw-fips-title = Kasalukuyang nasa FIPS mode ka.  Nangangailangan ang FIPS ng isang may laman na Master Password.
forms-primary-pw-change =
    .label = Palitan ang Primary Password…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Kilala dati bilang Master Password
forms-primary-pw-fips-title = Kasalukuyan kang naka-FIPS mode. Kinakailangan ng FIPS ng isang hindi blangkong Primary Password.
forms-master-pw-fips-desc = Nabigo ang Pagpalit ng Password

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Para makagawa ng Master Password, ilagay ang iyong Windows login credential. Makatutulong ito sa pagprotekta ng seguridad ng iyong mga account.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = lumikha ng Master Password
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Para makagawa ng Primary Password, ilagay ang iyong Windows login credential. Makatutulong ito sa pagprotekta ng seguridad ng iyong mga account.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = bumuo ng Primary Password
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Kasaysayan
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = Gagawin ng { -brand-short-name } na
    .accesskey = w
history-remember-option-all =
    .label = Tandaan ang kasaysayan
history-remember-option-never =
    .label = Huwag kailanman tandaan ang kasaysayan
history-remember-option-custom =
    .label = Gumamit ng mga custom setting para sa kasaysayan
history-remember-description = Tatandaan ng { -brand-short-name } ang iyong browsing, download, form at search history.
history-dontremember-description = Gagamitin ng { -brand-short-name } ang kaparehong mga setting sa private browsing, at hindi nito tatandaan ang iyong kasaysayan ng pag-browse sa Web.
history-private-browsing-permanent =
    .label = Laging gumamit ng private browsing mode
    .accesskey = p
history-remember-browser-option =
    .label = Tandaan ang kasaysayan ng pag-browse at pag-download
    .accesskey = b
history-remember-search-option =
    .label = Tandaan ang kasaysayan ng mga paghahanap at mga form
    .accesskey = f
history-clear-on-close-option =
    .label = Limasin ang kasaysayan kapag nagsara ang { -brand-short-name }
    .accesskey = r
history-clear-on-close-settings =
    .label = Mga Setting…
    .accesskey = t
history-clear-button =
    .label = Burahin ang Kasaysayan...
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Mga Cookie at Site Data
sitedata-total-size-calculating = Kinakalkula ang site data at cache size...
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Ang iyong mga nakaimbak na cookie, site data, at cache ay kasalukuyang gumagamit ng { $value } { $unit } ng disk space.
sitedata-learn-more = Alamin
sitedata-delete-on-close =
    .label = Burahin ang mga cookie at site data kapag isinara ang { -brand-short-name }
    .accesskey = c
sitedata-delete-on-close-private-browsing = Sa permanent private browsing mode, palaging buburahin ang mga cookie at site data kapag sinarado ang { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Tumanggap ng mga cookie at site data
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Harangin ang mga cookie at site data
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Uri ng content na hinaharang
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Mga cross-site tracker
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Mga cross-site at social media tracker
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Mga cross-site at social media tracker, at ihiwalay ang mga natitirang cookie
sitedata-option-block-unvisited =
    .label = Mga cookie na galing sa mga hindi pa nabisitang website
sitedata-option-block-all-third-party =
    .label = Lahat ng third-party na mga cookie (maaaring maging sanhi upang masira ang mga website)
sitedata-option-block-all =
    .label = Lahat ng mga cookie (maaaring makasira ng mga website)
sitedata-clear =
    .label = Burahin ang mga Data...
    .accesskey = I
sitedata-settings =
    .label = I-manage ang mga Data...
    .accesskey = M
sitedata-cookies-permissions =
    .label = I-Manage ang mga Permission...
    .accesskey = P

## Privacy Section - Address Bar

addressbar-header = Address Bar
addressbar-suggest = Kapag ginagamit ang address bar, magmungkahi ng
addressbar-locbar-history-option =
    .label = Kasaysayan ng pag-browse
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Mga bookmark
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Mga nakabukas na tab
    .accesskey = O
addressbar-locbar-topsites-option =
    .label = Pangunahing mga site.
    .accesskey = P
addressbar-suggestions-settings = Baguhin ang mga kagustuhan para sa mga mungkahi ng search engine

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Enhanced Tracking Protection
content-blocking-section-top-level-description = Sinusundan ka ng mga tracker online para mangolekta ng impormasyon tungkol sa iyong mga kaugalian at interes sa pag-browse. Hinaharang ng { -brand-short-name } ang karamihan sa mga tracker na ito at iba pang mga delikadong script.
content-blocking-learn-more = Alamin pa

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Strikto
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Pasadya
    .accesskey = C

##

content-blocking-etp-standard-desc = Balansado para sa proteksyon at performance. Normal na maglo-load ang mga pahina.
content-blocking-etp-strict-desc = Mas malakas na proteksyon, pero maaaring ikasira ng ilang mga site o content.
content-blocking-etp-custom-desc = Piliin kung aling mga tracker at scripts ang dapat harangin.
content-blocking-private-windows = Tracking content sa mga Private Window
content-blocking-cross-site-tracking-cookies = Mga cross-site tracking cookie
content-blocking-social-media-trackers = Mga social media tracker
content-blocking-all-cookies = Lahat ng mga cookie
content-blocking-unvisited-cookies = Mga cookie mula sa mga hindi binibisitang site
content-blocking-all-windows-tracking-content = Tracking content sa lahat ng mga window
content-blocking-all-third-party-cookies = Lahat ng mga third-party na mga cookie
content-blocking-cryptominers = Mga Cryptominer
content-blocking-fingerprinters = Mga Fingerprinter
content-blocking-warning-title = Mag-ingat!
content-blocking-warning-learn-how = Alamin kung paano
content-blocking-reload-description = Kailangan mong i-reload ang iyong mga tab upang makita ang mga pagbabago.
content-blocking-reload-tabs-button =
    .label = I-reload ang lahat ng mga tab
    .accesskey = R
content-blocking-tracking-content-label =
    .label = Tracking content
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = Sa lahat ng windows
    .accesskey = A
content-blocking-option-private =
    .label = Sa pribadong mga window lamang
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Baguhin ang listahan ng naka-block
content-blocking-cookies-label =
    .label = Mga Cookie
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Karagdagang impormasyon
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Mga Cryptominer
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Mga Fingerprinter
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = I-manage ang mga Exception...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Mga pahintulot
permissions-location = Lokasyon
permissions-location-settings =
    .label = Mga Setting…
    .accesskey = t
permissions-xr = Virtual Reality
permissions-xr-settings =
    .label = Mga Setting…
    .accesskey = t
permissions-camera = Kamera
permissions-camera-settings =
    .label = Mga Setting…
    .accesskey = t
permissions-microphone = Mikropono
permissions-microphone-settings =
    .label = Mga Setting…
    .accesskey = t
permissions-notification = Mga Abiso
permissions-notification-settings =
    .label = Mga Setting…
    .accesskey = t
permissions-notification-link = Alamin
permissions-notification-pause =
    .label = I-pause ang mga notification hanggang sa i-restart ang { -brand-short-name }
    .accesskey = n
permissions-autoplay = Autoplay
permissions-autoplay-settings =
    .label = Mga Setting...
    .accesskey = t
permissions-block-popups =
    .label = Harangin ang mga pop-up windows
    .accesskey = H
permissions-block-popups-exceptions =
    .label = Mga Exception...
    .accesskey = E
permissions-addon-install-warning =
    .label = Balaan ka kapag sinusubukan ng mga website na magkabit ng mga add-on
    .accesskey = W
permissions-addon-exceptions =
    .label = Mga exception...
    .accesskey = e
permissions-a11y-privacy-checkbox =
    .label = Pigilan ang mga serbisyo sa pag-access sa pag-access sa iyong browser
    .accesskey = a
permissions-a11y-privacy-link = Matuto ng higit pa

## Privacy Section - Data Collection

collection-header = Pagkolekta at Paggamit ng { -brand-short-name } sa Data
collection-description = Nagsusumikap kaming mabigyan ka ng mga pagpipilian at kolektahin lamang kung ano ang kailangan namin upang mapaganda ang { -brand-short-name } para sa lahat. Lagi kaming humihingi ng pahintulot bago tumanggap ng personal na impormasyon.
collection-privacy-notice = Abisong Pribasiya
collection-health-report-telemetry-disabled = Hindi mo na pinahihintulutan ang { -vendor-short-name } na kumuha ng technical at interaction data. Lahat ng nakalipas na data ay buburahin sa loob ng 30 araw.
collection-health-report-telemetry-disabled-link = Matuto ng higit pa
collection-health-report =
    .label = Payagan ang { -brand-short-name } na magpadala ng data ng teknikal at pakikipag-ugnayan sa { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Alamin
collection-studies =
    .label = Payagan ang { -brand-short-name } na mag-install at mag-run ng studies
collection-studies-link = Tingnan ang mga pag-aaral sa { -brand-short-name }
addon-recommendations =
    .label = Payagan ang { -brand-short-name } na mag-mungkahi ng mga personalized extension.
addon-recommendations-link = Alamin pa
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Naka-disable ang pag-uulat ng data para sa build configuration na ito
collection-backlogged-crash-reports =
    .label = Payagan ang { -brand-short-name } na magpadala ng mga naka-backlog na crash report sa ngalan mo
    .accesskey = c
collection-backlogged-crash-reports-link = Alamin

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Seguridad
security-browsing-protection = Mapanlinlang na Content at Proteksyon mula sa Delikadong Software
security-enable-safe-browsing =
    .label = Harangin ang delikado at mapanlinlang na content
    .accesskey = B
security-enable-safe-browsing-link = Matuto ng higit pa
security-block-downloads =
    .label = Harangin ang mga delikadong download
    .accesskey = D
security-block-uncommon-software =
    .label = Balaan ka tungkol sa mga di-kanais-nais at di-karaniwang software
    .accesskey = c

## Privacy Section - Certificates

certs-header = Mga sertipiko
certs-personal-label = Kapag hiniling ng isang server ang iyong personal na sertipiko
certs-select-auto-option =
    .label = Pumili agad ng isa
    .accesskey = S
certs-select-ask-option =
    .label = Tanungin ka palagi
    .accesskey = A
certs-enable-ocsp =
    .label = Tanungin ang mga OCSP responder server upang kumpirmahin ang kasalukuyang bisa ng mga sertipiko
    .accesskey = Q
certs-view =
    .label = Tingnan ang mga Sertipiko…
    .accesskey = C
certs-devices =
    .label = Mga Security Device...
    .accesskey = D
space-alert-learn-more-button =
    .label = Alamin
    .accesskey = L
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Buksan ang Pagpipilian
           *[other] Buksan ang mga Kagustuhan
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] Nauubusan na ng disk space ang { -brand-short-name }. Maaaring hindi mag-display nang maayos ang laman ng website. Pwede kang magbura ng nakaimbak na data sa Mga Pagpipilian > Pribasiya at Seguridad > Mga Cookie at Site Data.
       *[other] Nauubusan na ng disk space ang { -brand-short-name }. Maaaring hindi mag-display nang maayos ang laman ng website. Pwede kang magbura ng nakaimbak na data sa Mga Kagustuhan > Pribasiya at Seguridad > Mga Cookie at Site Data.
    }
space-alert-under-5gb-ok-button =
    .label = OK, Nakuha ko
    .accesskey = K
space-alert-under-5gb-message = Nauubusan na ng disk space ang { -brand-short-name }. Maaaring hindi maipakita nang wasto ang mga nilalaman ng website. Puntahan ang "Alamin" para maisaayos ang iyong disk usage para sa mas magandang karanasan sa pagba-browse.

## Privacy Section - HTTPS-Only

httpsonly-header = HTTPS-Only Mode
httpsonly-learn-more = Alamin
httpsonly-radio-enabled =
    .label = I-enable ang HTTPS-Only Mode sa lahat ng mga window
httpsonly-radio-enabled-pbm =
    .label = I-enable ang HTTPS-Only Mode sa mga private window lamang
httpsonly-radio-disabled =
    .label = Huwag i-enable ang HTTPS-Only Mode

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Mga Download
choose-download-folder-title = Pumili ng Download Folder:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Mag-save ng mga file sa { $service-name }
