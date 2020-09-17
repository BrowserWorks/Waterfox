# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Thumelela iiwebhsayithi umqondiso othi "Musa ukuTreka" obonisa ukuba akufuni kutrekwa
do-not-track-learn-more = Funda ngakumbi
do-not-track-option-always =
    .label = Qho

pref-page-title =
    { PLATFORM() ->
        [windows] Ekunokukhethwa kuko
       *[other] Izikhethwa
    }

pane-general-title = Jikelele
category-general =
    .tooltiptext = { pane-general-title }

pane-search-title = Khangela
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = UbuNgasese noKhuseleko
category-privacy =
    .tooltiptext = { pane-privacy-title }

help-button-label = INkxaso ye{ -brand-short-name }

focus-search =
    .key = f

close-button =
    .aria-label = Vala

## Browser Restart Dialog

feature-enable-requires-restart = I-{ -brand-short-name } kufuneka iqalise ngokutsha ukuyenza isebenze ifitsha.
feature-disable-requires-restart = I-{ -brand-short-name } kufuneka iqalise ngokutsha ukuyenza ingasebenzi le fitsha.
should-restart-title = Qalisa kwakhona { -brand-short-name }
should-restart-ok = Phinda uqale i{ -brand-short-name } ngoku
restart-later = Qalisa ngokutsha Kamva

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension


## Preferences UI Search Results

search-results-header = IZiphumo zoKhangelo

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Uxolo! Azikho iziphumo kuKhetho lwe- “<span data-l10n-name="query"></span>”.
       *[other] Uxolo! Azikho iziphumo kwiiPrifrensi ze-“<span data-l10n-name="query"></span>”.
    }

## General Section

startup-header = Qalisa

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Vumela i-{ -brand-short-name } kunye ne-Firefox ukuba zisebenze ngaxeshanye
use-firefox-sync = Ingcebiso: Le isebenzisa iiprofayile eyahlukeneyo. Sebenzisa ungqamaniso ukwabelana ngenkcukacha phakathi kwazo.
get-started-not-logged-in = Sayina ungene kwi-{ -sync-brand-short-name }…
get-started-configured = Vula iipriferensi ze-{ -sync-brand-short-name }

always-check-default =
    .label = Khangela qho ukuba i-{ -brand-short-name } iyibhrawuza yakho esisiseko
    .accesskey = o

is-default = I-{ -brand-short-name } kungokunje iyibhrawuza yakho esisiseko
is-not-default = I-{ -brand-short-name } ayiyobhrawuza yakho esisiseko

tabs-group-header = Izilungelelanisi zemigca

ctrl-tab-recently-used-order =
    .label = Imijikelo yeCtrl+Tab kwiithebhu kulungelelwano olusandul' ukusetyenziswa
    .accesskey = T

warn-on-close-multiple-tabs =
    .label = Ndikulumkise xa ndivala iithebhu ezininzi
    .accesskey = e

warn-on-open-many-tabs =
    .label = Ndikulumkise xa uvula iithebhu ezininzi ezingacothisa i-{ -brand-short-name }
    .accesskey = c

switch-links-to-new-tabs =
    .label = Xa uvula ikhonkco kwilinki entsha, tshintshela kuyo ngokukhawuleza
    .accesskey = a

show-tabs-in-taskbar =
    .label = Bonisa umbono wangaphambili wethebhu kwithaskhbha ye-Windows
    .accesskey = B

browser-containers-enabled =
    .label = Vumela iiThebhu zeKhonteyina
    .accesskey = u

browser-containers-learn-more = Funda ngakumbi

browser-containers-settings =
    .label = Iisetingi…
    .accesskey = s

containers-disable-alert-title = Ufuna ukuvala Zonke iiThebhu zeeKhonteyina?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Ukuba uyazivala iiThebhu zeKhonteyina ngoku, i-{ $tabCount } ithebhu yekhonteyina iya kuvalwa. Uqinisekile ukuba ufuna ukuzivala iiThebhu zeKhonteyina?
       *[other] Ukuba uyazivala iiThebhu zeKhonteyina ngoku, ii-{ $tabCount } iithebhu zekhonteyina ziya kuvalwa. Uqinisekile ukuba ufuna ukuzivala iiThebhu zeKhonteyina?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Vala iThebu yeKhonteyina i-{ $tabCount }
       *[other] Vala iiThebhu zeKhonteyina ii-{ $tabCount }.
    }
containers-disable-alert-cancel-button = Zigcina zivuliwe

containers-remove-alert-title = Ufuna ukuSusa le Khonteyina?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Ukuba ususa le Khonteyina ngoku, ithebhu yekhonteyina i-{ $count } iya kuvalwa. Uqinisekile ukuba ufuna ukuyisusa le Khonteyina?
       *[other] Ukuba uyayisusa le khonteyina ngoku, iithebhu zekhonteyina ze-{ $count } ziya kuvalwa. Uqinisekie ukuba ufuna ukuyisusa le Khonteyina?
    }

containers-remove-ok-button = Yisuse le Khonteyina
containers-remove-cancel-button = Musa ukuyisusa le Khonteyina


## General Section - Language & Appearance

fonts-and-colors-header = Iifonti neMibala

default-font = Ifonti esisiseko
    .accesskey = I
default-font-size = Isayizi
    .accesskey = I

advanced-fonts =
    .label = Kwangaphambili…
    .accesskey = K

colors-settings =
    .label = Imibala…
    .accesskey = I

choose-language-description = Khetha ulwimi oluthandayo lokubonisa amaphepha

choose-button =
    .label = Khetha…
    .accesskey = e

translate-web-pages =
    .label = Guqulela isiqulatho sewebhu
    .accesskey = G

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Iinguqulelo ngu <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Izinxaxhi…
    .accesskey = n

check-user-spelling =
    .label = Khangela upelo lwakho njengoko uchwetheza
    .accesskey = u

## General Section - Files and Applications

download-header = Okukhutshelwayo

download-save-to =
    .label = Gcina iifayile kwi
    .accesskey = c

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Khetha…
           *[other] Bhrwuza…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] a
           *[other] w
        }

download-always-ask-where =
    .label = Ndikubuze qho ngendawo emazigcinwe kuyo iifayile
    .accesskey = N

applications-header = Ii-aplikheyishini

applications-filter =
    .placeholder = Khetha uhlobo lweefayile okanye ii-aplikheyishini

applications-type-column =
    .label = Udidi lomxholo
    .accesskey = l

applications-action-column =
    .label = Inyathelo
    .accesskey = I

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = Ifayile ye-{ $extension }
applications-action-save =
    .label = Gcina Ifayile

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Sebenzisa i-{ $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Sebenzisa { $app-name } (okwesiseko)

applications-use-other =
    .label = Sebenzisa enye…
applications-select-helper = Lungiselela ukukhetha Inkqubo Yoncedo

applications-manage-app =
    .label = IiNkcukacha zeAplikheshini…
applications-always-ask =
    .label = Soloko ucela
applications-type-pdf = Ifomathi yoxwebhu oluphathekayo (PDF)

# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Sebenzisa i-{ $plugin-name } (kwi-{ -brand-short-name })

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

##

play-drm-content-learn-more = Funda okungakumbi

update-application-title = I-{ -brand-short-name } iZihlaziyi

update-application-version = Uhlobo { $version } <a data-l10n-name="learn-more">Yintoni entsha</a>

update-history =
    .label = Bonisa iMbali yoHlaziyo…
    .accesskey = l

update-application-allow-description = Vumela i-{ -brand-short-name } ukuba

update-application-check-choose =
    .label = Khangela uhlaziyo, kodwa ikuvumela ukuba ukhethe ukuba ungazifaka na
    .accesskey = K

update-application-manual =
    .label = Ungaze ukhangele uhlaziyo (akunconyelwa)
    .accesskey = U

update-application-use-service =
    .label = Sebenzisa inkonzo yokungasemva ukufakela uhlaziyo
    .accesskey = y

## General Section - Performance

performance-title = Ukusebenza

performance-use-recommended-settings-checkbox =
    .label = Sebenzisa iisetingi ezinconyelwayo zokusebenza
    .accesskey = S

performance-use-recommended-settings-desc = Ezi setingi zilungiselelwe ihadwe nenkqubo yokusebenza yekhompyutha yakho.

performance-settings-learn-more = Funda okungakumbi

performance-allow-hw-accel =
    .label = Sebenzisa ukhawuleziso lwehadiwe xa lufumaneka
    .accesskey = d

performance-limit-content-process-option = Inkqubo yesiqulatho nomlinganiselo
    .accesskey = l

performance-limit-content-process-enabled-desc = Iinkqubo ezongezelelekileyo zesiqulatho zinokuphucula ukusebenza xa usebenzisa iithebhu ezininzi, kodwa iya kusebenzisa imemori engakumbi.
performance-limit-content-process-blocked-desc = Ukuphucula inani leenkqubo zeziqulatho kunokwenzeka kuphela ngeenkqubo ezininzi ze-{ -brand-short-name }. <a data-l10n-name="learn-more">Funda indlela yokuhlola ukuba zivuliwe iinkqubo ezininzi</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = Idifolti{ $num } (idifolthi)

## General Section - Browsing

browsing-title = Ukubhrawuza

browsing-use-autoscroll =
    .label = Sebenzisa ukusikrola ngokuzenzekelayo
    .accesskey = u

browsing-use-smooth-scrolling =
    .label = Sebenzisa ukuhambahamba kokubhaliweyo okugudileyo
    .accesskey = g

browsing-use-onscreen-keyboard =
    .label = Bonisa ukuphatha nekhibhodi xa kuyimfuneko
    .accesskey = k

browsing-use-cursor-navigation =
    .label = Sebenzisa qho amaqhosha ekheza ukufunisela kumakhasi
    .accesskey = a

browsing-search-on-start-typing =
    .label = Khangela iteksti xa uqalisa ukuchwetheza
    .accesskey = t

## General Section - Proxy

network-proxy-connection-settings =
    .label = Isetingi…
    .accesskey = e

## Home Section


## Home Section - Home Page Customization

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Sebenzisa iPhepha laNgoku
           *[other] Sebenzisa amaPhepha aNgoku
        }
    .accesskey = S

choose-bookmark =
    .label = Sebenzisa iBhukhmakhi…
    .accesskey = B

## Home Section - Firefox Home Content Customization


## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

##


## Search Section

search-engine-default-header = Injini yesiseko yokukhangela

search-suggestions-option =
    .label = Nika khangela iingcebiso
    .accesskey = k

search-suggestions-cant-show = Amacebiso okukhangela akayi kuboniswa kwiziphumo zebha yendawo ngenxa yokuba uyile i-{ -brand-short-name } ukuba ingaze iyikhumbule imbali.

search-one-click-header = IiNjini zokuKhangela Ezicofwa Kanye

search-choose-engine-column =
    .label = Iinjini zokukhangela
search-choose-keyword-column =
    .label = Igama eliphambili

search-restore-default =
    .label = Buyisela Iinjini zokukhangela zesiseko
    .accesskey = I

search-remove-engine =
    .label = Susa
    .accesskey = S

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Phindaphinda igama eliphambili
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Ukhethe igama eliphambili elisetyenziswa kungokunje yi"{ $name }". Nceda ukhethe elinye.
search-keyword-warning-bookmark = Ukhethe igama eliphambili elisetyenziswa kungokunje yibhukhmakhi. Nceda ukhethe elinye.

## Containers Section

containers-header = Iithebhu Zekhonteyina
containers-add-button =
    .label = Yongeza iKhonteyina eNtsha
    .accesskey = Y

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Phatha iWebhu Yakho Apho Ukhoyo
sync-signedout-description = Ngqamanisa iibhukmakhi zakho, iimbali, iithebhu, iiphaswedi, ezongezelelwayo, kunye neepreferensi kuzo zonke izixhobo zakho.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Dawnlowuda iFirefox ye<img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">I-Android</a>okanye<img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a>ukuze ungqamanise nezixhobo zakho zemobhayili.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Tshintsha umfanekiso weprofayili

sync-signedin-unverified = { $email } akuqinisekiswanga.
sync-signedin-login-failure = Sicela ungene ukuze uphinde uqhagamshele { $email }

sync-sign-in =
    .label = Sayina uNgene
    .accesskey = g

## Sync section - enabling or disabling sync.


## The list of things currently syncing.


## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = Izalathisi eziphawulayo
    .accesskey = e

sync-engine-history =
    .label = Imbali
    .accesskey = l

## The device name controls.

sync-device-name-header = Igama lesixhobo

sync-device-name-change =
    .label = Tshintsha iGama leSixhobo...
    .accesskey = s

sync-device-name-cancel =
    .label = Rhoxisa
    .accesskey = o

sync-device-name-save =
    .label = Gcina
    .accesskey = i

## Privacy Section


## Privacy Section - Forms


## Privacy Section - Logins and Passwords

forms-exceptions =
    .label = Izinxaxhi…
    .accesskey = x

forms-saved-logins =
    .label = Ezigciniweyo Logini…
    .accesskey = L
forms-master-pw-use =
    .label = Sebenzisa iphaswedi eyimasta
    .accesskey = S
forms-master-pw-change =
    .label = Guqula iPhaswedi eyiMasta…
    .accesskey = P

forms-master-pw-fips-title = Kungokunje ukwimo ye-FIPS. I-FIPS ifuna iPhaswedi yeMasta engekho ze.

forms-master-pw-fips-desc = Ukuguqulwa Kwegama Lokugqithisa Akuphumelelanga

## OS Authentication dialog

## Privacy Section - History

history-header = Imbali

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = I-{ -brand-short-name } iya
    .accesskey = i

history-remember-option-all =
    .label = Khumbula imbali
history-remember-option-never =
    .label = Ungaze ukhumbule imbali
history-remember-option-custom =
    .label = Sebenzisa iisethingi zesiqhelo kwimbali

history-dontremember-description = i-{ -brand-short-name } iya kusebenzisa iisethingi ezifanayo njengokubhrawuza kwangasese kwaye ayiyi kukhumbula nayiphi na imbali njengokuba ubhrawuza iwebhu.

history-private-browsing-permanent =
    .label = Soloko usebenzisa imo yokubhrawuza yangasese
    .accesskey = o

history-remember-search-option =
    .label = Khumbula imbali yokukhangela neyefom
    .accesskey = a

history-clear-on-close-option =
    .label = Susa imbali xa i-{ -brand-short-name } ivala
    .accesskey = S

history-clear-on-close-settings =
    .label = Imimiselo…
    .accesskey = m

## Privacy Section - Site Data

sitedata-learn-more = Funda okungakumbi

## Privacy Section - Address Bar

addressbar-locbar-bookmarks-option =
    .label = Iibhukhmakhi
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Vula iithebhu
    .accesskey = V

addressbar-suggestions-settings = Tshintsha iipreferensi zamacebiso enjini yokukhangela

## Privacy Section - Content Blocking


## These strings are used to define the different levels of
## Enhanced Tracking Protection.


##

## Privacy Section - Tracking


## Privacy Section - Permissions

permissions-header = Iimvume

permissions-block-popups =
    .label = Thintela iifestile ezizivelelayo
    .accesskey = T

permissions-block-popups-exceptions =
    .label = Izinxaxhi…
    .accesskey = I

permissions-addon-exceptions =
    .label = Izinxaxhi…
    .accesskey = I

## Privacy Section - Data Collection

collection-health-report-link = Funda okungakumbi

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Ukuxelwa kwedatha kuyekisiwe ngenxa yolu lwakheko

collection-backlogged-crash-reports-link = Funda okungakumbi

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Ukhuseleko

security-enable-safe-browsing =
    .label = Bloka isiqulatho esiyingozi nesiqhathayo
    .accesskey = B

security-block-downloads =
    .label = Bloka ukudawnlowuda okuyingozi
    .accesskey = u

security-block-uncommon-software =
    .label = Ndilkuumkise ngesoftwe engafunwayo nengaqhelekanga
    .accesskey = a

## Privacy Section - Certificates

certs-header = Izatifikethi

certs-personal-label = Xa iseva icela isatifikethi sakho

certs-select-auto-option =
    .label = Khetha esinye ngokuzenzekela
    .accesskey = S

certs-select-ask-option =
    .label = Iyakubuza ngawo onke amaxesha
    .accesskey = A

certs-enable-ocsp =
    .label = Buza iiseva zomphenduli ze-OCSP ukuqinisekisa ukugqibelela kwangoku kwezatifikethi
    .accesskey = B

space-alert-learn-more-button =
    .label = Funda Okungakumbi
    .accesskey = F

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Vula Ukhetho
           *[other] Vula iiPriferensi
        }
    .accesskey =
        { PLATFORM() ->
            [windows] V
           *[other] V
        }

space-alert-under-5gb-ok-button =
    .label = Kulungile. Ndiyifumene
    .accesskey = l

space-alert-under-5gb-message = I-{ -brand-short-name } iphelelwa yindawo kwidiski. Iziqulatho zewebhsayithi zinokungabonisi kakuhle. Tyelela ethi “Funda Okungakumbi” ukuze u-optimayize ukusebenzisa kwakho idiski ukuze ubhrawze kakuhle.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = Idesktophu
downloads-folder-name = Okukhutshelweyo
choose-download-folder-title = Khetha iFolda yokuKhutshelwayo:

