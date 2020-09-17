# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-learn-more = Meer inligting
do-not-track-option-always =
    .label = Altyd

pref-page-title =
    { PLATFORM() ->
        [windows] Opsies
       *[other] Voorkeure
    }

pane-general-title = Algemeen
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = Tuis

pane-search-title = Soek
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = Privaatheid en sekuriteit
category-privacy =
    .tooltiptext = { pane-privacy-title }

help-button-label = { -brand-short-name }-ondersteuning

focus-search =
    .key = f

close-button =
    .aria-label = Sluit

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } moet herbegin om dié funksie te aktiveer.
feature-disable-requires-restart = { -brand-short-name } moet herbegin om dié funksie te deaktiveer.
should-restart-title = Herbegin { -brand-short-name }
should-restart-ok = Herbegin { -brand-short-name } nou
cancel-no-restart-button = Kanselleer
restart-later = Herbegin later

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

search-results-header = Soekresultate

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Jammer! Daar is geen resultate in Opsies vir “<span data-l10n-name="query"></span>”.
       *[other] Jammer! Daar is geen resultate in Voorkeure vir “<span data-l10n-name="query"></span>”.
    }

## General Section

startup-header = Begin

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Laat { -brand-short-name } en Firefox toe om gelyktydig te loop
use-firefox-sync = Wenk: Dit gebruik aparte profiele. Gebruik { -sync-brand-short-name } om data tussen hulle te deel.
get-started-not-logged-in = Meld aan by { -sync-brand-short-name }…
get-started-configured = Open { -sync-brand-short-name }-voorkeure

always-check-default =
    .label = Kontroleer altyd of { -brand-short-name } die verstekblaaier is
    .accesskey = K

is-default = { -brand-short-name } is tans die verstekblaaier
is-not-default = { -brand-short-name } is nie die verstekblaaier nie

set-as-my-default-browser =
    .label = Maak verstek...
    .accesskey = D

startup-restore-previous-session =
    .label = Herstel vorige sessie
    .accesskey = S

tabs-group-header = Oortjies

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab besoek oortjies in die volgorde wat hulle onlangs gebruik is
    .accesskey = T

open-new-link-as-tabs =
    .label = Maak skakels oop in oortjies in plaas van nuwe vensters
    .accesskey = W

warn-on-close-multiple-tabs =
    .label = Waarsku wanneer meer as een oortjie gesluit word
    .accesskey = m

warn-on-open-many-tabs =
    .label = Waarsku wanneer klomp oop oortjies dalk { -brand-short-name } kan stadig maak
    .accesskey = W

switch-links-to-new-tabs =
    .label = Wanneer 'n skakel in 'n nuwe oortjie open, skakel dadelik daarheen oor
    .accesskey = a

show-tabs-in-taskbar =
    .label = Wys oortjievoorskoue in die Windows-taakbalk
    .accesskey = k

browser-containers-enabled =
    .label = Aktiveer konteksoortjies
    .accesskey = v

browser-containers-learn-more = Meer inligting

browser-containers-settings =
    .label = Opstelling…
    .accesskey = t

containers-disable-alert-title = Sluit alle konteksoortjies?
containers-disable-alert-desc =
    { $tabCount ->
        [one] As konteksoortjies nou gedeaktiveer word, sal { $tabCount } konteksoortjie gesluit word. Wil u definitief konteksoortjies deaktiveer?
       *[other] As konteksoortjies nou gedeaktiveer word, sal { $tabCount } konteksoortjies gesluit word. Wil u definitief konteksoortjies deaktiveer?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Sluit { $tabCount } konteksoortjie
       *[other] Sluit { $tabCount } konteksoortjies
    }
containers-disable-alert-cancel-button = Hou geaktiveer

containers-remove-alert-title = Verwyder dié konteks?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] As dié konteks nou verwyder word, sal { $count } konteksoortjie gesluit word. Wil u definitief dié konteks verwyder?
       *[other] As dié konteks nou verwyder word, sal { $count } konteksoortjies gesluit word. Wil u definitief dié konteks verwyder?
    }

containers-remove-ok-button = Verwyder dié konteks
containers-remove-cancel-button = Moenie dié konteks verwyder nie


## General Section - Language & Appearance

language-and-appearance-header = Taal en Voorkoms

fonts-and-colors-header = Fonte en kleure

default-font = Verstekfont
    .accesskey = V
default-font-size = Grootte
    .accesskey = G

advanced-fonts =
    .label = Gevorderd…
    .accesskey = G

colors-settings =
    .label = Kleure…
    .accesskey = K

# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoem

preferences-default-zoom = Verstek zoem
    .accesskey = z

preferences-default-zoom-value =
    .label = { $percentage }%

language-header = Taal

choose-language-description = Kies u voorkeurtaal waarin bladsye vertoon moet word

choose-button =
    .label = Kies…
    .accesskey = K

manage-browser-languages-button =
    .label = Stel alternatiewe...
    .accesskey = l

translate-web-pages =
    .label = Vertaal webinhoud
    .accesskey = V

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Vertalings deur <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Uitsonderings…
    .accesskey = i

check-user-spelling =
    .label = Kontroleer spelling terwyl ek tik
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Lêers en Toepassings

download-header = Aflaaie

download-save-to =
    .label = Stoor lêers na
    .accesskey = o

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Kies…
           *[other] Blaai…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] a
        }

download-always-ask-where =
    .label = Vra altyd waar om lêers te stoor
    .accesskey = V

applications-header = Toepassings

applications-filter =
    .placeholder = Deursoek lêertipes of toepassings

applications-type-column =
    .label = Inhoudsoort
    .accesskey = s

applications-action-column =
    .label = Aksie
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension }-lêer
applications-action-save =
    .label = Stoor lêer

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Gebruik { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Gebruik { $app-name } (verstek)

applications-use-other =
    .label = Gebruik ander…
applications-select-helper = Kies helper-toepassing

applications-manage-app =
    .label = Toepassingdetail…
applications-always-ask =
    .label = Vra altyd
applications-type-pdf = Portable Document Format (PDF)

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
    .label = Gebruik { $plugin-name } (in { -brand-short-name })

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

play-drm-content-learn-more = Meer inligting

update-application-title = { -brand-short-name }-bywerkings

update-application-version = Weergawe { $version } <a data-l10n-name="learn-more">Wat’s nuut?</a>

update-application-use-service =
    .label = Gebruik 'n agtergronddiens om bywerkings te installeer
    .accesskey = a

## General Section - Performance

performance-title = Werkverrigting

performance-use-recommended-settings-checkbox =
    .label = Gebruik aanbevole instellings vir werkverrigting
    .accesskey = u

performance-use-recommended-settings-desc = Hierdie instellings is aangepas vir u rekenaar se hardeware en bedryfstelsel.

performance-settings-learn-more = Meer inligting

performance-allow-hw-accel =
    .label = Gebruik hardewareversnelling indien beskikbaar
    .accesskey = r

performance-limit-content-process-option = Perk op inhoudprosesse
    .accesskey = P

performance-limit-content-process-enabled-desc = Meer inhoudprosesse kan werkverrigting verbeter met klomp oortjies, maar sal ook meer geheue gebruik.

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (verstek)

## General Section - Browsing

browsing-title = Blaai

browsing-use-autoscroll =
    .label = Gebruik outorol
    .accesskey = o

browsing-use-smooth-scrolling =
    .label = Gebruik gladde rol
    .accesskey = G

browsing-use-onscreen-keyboard =
    .label = Wys 'n skermsleutelbord indien nodig
    .accesskey = k

browsing-use-cursor-navigation =
    .label = Gebruik altyd die por-sleutels om binne bladsye te navigeer
    .accesskey = p

browsing-search-on-start-typing =
    .label = Soek vir teks wanneer ek begin tik
    .accesskey = s

browsing-picture-in-picture-toggle-enabled =
    .label = Aktiveer beeld-in-beeld videokontroles
    .accesskey = E

browsing-picture-in-picture-learn-more = Meer inligting

browsing-cfr-recommendations-learn-more = Meer inligting

## General Section - Proxy

network-proxy-connection-settings =
    .label = Opstelling…
    .accesskey = p

## Home Section

home-new-windows-tabs-header = Nuwe Vensters en Oortjies

## Home Section - Home Page Customization

home-homepage-mode-label = Tuisblad en nuwe vensters

home-newtabs-mode-label = Nuwe oortjies

home-mode-choice-blank =
    .label = Leë bladsy

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Gebruik huidige bladsy
           *[other] Gebruik huidige bladsye
        }
    .accesskey = G

choose-bookmark =
    .label = Gebruik boekmerk…
    .accesskey = b

## Home Section - Firefox Home Content Customization

home-prefs-search-header =
    .label = Web soektog
home-prefs-topsites-header =
    .label = Topwerwe
home-prefs-topsites-description = Die webwerwe wat u die meeste besoek

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = Aanbeveel deur { $provider }
##

home-prefs-recommended-by-learn-more = Hoe dit werk
home-prefs-recommended-by-option-sponsored-stories =
    .label = Geborgde Verhale

home-prefs-highlights-option-visited-pages =
    .label = Besoeke Bladsye
home-prefs-highlights-options-bookmarks =
    .label = Boekmerke

## Search Section

search-engine-default-header = Versteksoekenjin

search-suggestions-header = Soekvoorstelle

search-suggestions-option =
    .label = Verskaf soekvoorstelle
    .accesskey = s

search-suggestions-cant-show = Soekvoorstelle sal nie in die liggingbalk gewys word nie omdat { -brand-short-name } opgestel is om nooit geskiedenis te onthou nie.

search-one-click-header = Enkelklik-soekenjins

search-choose-engine-column =
    .label = Soekenjin
search-choose-keyword-column =
    .label = Sleutelwoord

search-restore-default =
    .label = Stel versteksoekenjins terug
    .accesskey = v

search-remove-engine =
    .label = Verwyder
    .accesskey = V

search-find-more-link = Vind meer soekenjins

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Dupliseer sleutelwoord
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = U het 'n sleutelwoord gekies wat tans deur "{ $name }" gebruik word. Kies 'n ander een.
search-keyword-warning-bookmark = U het 'n sleutelwoord gekies wat tans deur 'n boekmerk gebruik word. Kies 'n ander een.

## Containers Section

containers-header = Konteksoortjies
containers-add-button =
    .label = Voeg nuwe konteks by
    .accesskey = V

containers-preferences-button =
    .label = Voorkeure
containers-remove-button =
    .label = Verwyder

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Neem die Web saam
sync-signedout-description = Sinkroniseer boekmerke, geskiedenis, oortjies, wagwoorde, byvoegings en voorkeure oor alle toestelle.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Laai Firefox af vir <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> of <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> om met 'n selfoon te sinkroniseer.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Verander profielprent

sync-manage-account = Bestuur rekening
    .accesskey = o

sync-signedin-unverified = { $email } is nie geverifieer nie.
sync-signedin-login-failure = Meld aan om { $email } te herkoppel.

sync-remove-account =
    .label = Verwyder Rekening
    .accesskey = R

sync-sign-in =
    .label = Meld aan
    .accesskey = M

## Sync section - enabling or disabling sync.


## The list of things currently syncing.

sync-currently-syncing-bookmarks = Boekmerke
sync-currently-syncing-history = Geskiedenis
sync-currently-syncing-tabs = Oop oortjies
sync-currently-syncing-logins-passwords = Aanmeldings en wagwoorde
sync-currently-syncing-addresses = Adresse
sync-currently-syncing-creditcards = Kredietkaarte
sync-currently-syncing-addons = Byvoegings

sync-change-options =
    .label = Verander...
    .accesskey = C

## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = Boekmerke
    .accesskey = m

sync-engine-history =
    .label = Geskiedenis
    .accesskey = G

## The device name controls.

sync-device-name-header = Toestelnaam

sync-device-name-change =
    .label = Verander toestelnaam…
    .accesskey = V

sync-device-name-cancel =
    .label = Kanselleer
    .accesskey = n

sync-device-name-save =
    .label = Stoor
    .accesskey = t

## Privacy Section

privacy-header = Blaaier Privaatheid

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Aanmeldings en Wagwoorde
    .searchkeywords = { -lockwise-brand-short-name }

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Vra om aanmeldings en wagwoorde vir webwerwe te stoor
    .accesskey = r
forms-exceptions =
    .label = Uitsonderings…
    .accesskey = U
forms-generate-passwords =
    .label = Genereer en stel voor sterk wagwoorde
    .accesskey = u
forms-breach-alerts-learn-more-link = Meer inligting

forms-saved-logins =
    .label = Gestoorde aanmeldings…
    .accesskey = l
forms-master-pw-use =
    .label = Gebruik 'n meesterwagwoord
    .accesskey = G
forms-master-pw-change =
    .label = Wysig meesterwagwoord…
    .accesskey = m

forms-master-pw-fips-title = U is tans in FIPS-modus. FIPS vereis 'n nieleë meesterwagwoord.

forms-master-pw-fips-desc = Kon nie wagwoord verander nie

## OS Authentication dialog


## Privacy Section - History

history-header = Geskiedenis

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } sal
    .accesskey = s

history-remember-option-all =
    .label = geskiedenis onthou
history-remember-option-never =
    .label = nooit geskiedenis onthou nie
history-remember-option-custom =
    .label = eie instellings vir geskiedenis gebruik

history-dontremember-description = { -brand-short-name } gebruik dieselfde instellings as private blaaiery en sal nie enige geskiedenis onthou wanneer u die web besoek nie.

history-private-browsing-permanent =
    .label = Gebruik altyd privaatblaai-modus
    .accesskey = p

history-remember-search-option =
    .label = Onthou soek- en vormgeskiedenis
    .accesskey = v

history-clear-on-close-option =
    .label = Wis geskiedenis wanneer { -brand-short-name } toemaak
    .accesskey = r

history-clear-on-close-settings =
    .label = Opstelling…
    .accesskey = t

## Privacy Section - Site Data

sitedata-header = Koekies en webwerf-data

sitedata-learn-more = Meer inligting

## Privacy Section - Address Bar

addressbar-locbar-history-option =
    .label = Blaaigeskiedenis
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = Boekmerke
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = Oop oortjies
    .accesskey = O

addressbar-suggestions-settings = &Verander voorkeure vir voorstelle vanaf soekenjins

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Gevorderde beskerming van spoorsnyers

content-blocking-learn-more = Meer inligting

## These strings are used to define the different levels of
## Enhanced Tracking Protection.


##

content-blocking-all-cookies = Alle koekies
content-blocking-cryptominers = Kriptomyners
content-blocking-fingerprinters = Vingerafdrukkers

content-blocking-tracking-protection-option-all-windows =
    .label = In alle vensters
    .accesskey = A
content-blocking-tracking-protection-change-block-list = Verander bloklys

content-blocking-cookies-label =
    .label = Koekies
    .accesskey = K

content-blocking-expand-section =
    .tooltiptext = Meer inligting

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Kriptomyners
    .accesskey = K

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Vingerafdrukkers
    .accesskey = V

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Bestuur Uitsonderings...
    .accesskey = U

## Privacy Section - Permissions

permissions-header = Toestemmings

permissions-location = Ligging

permissions-xr = Virtuele Realiteit

permissions-microphone = Mikrofoon
permissions-microphone-settings =
    .label = Instellings…
    .accesskey = I

permissions-notification = Kennisgewings

permissions-block-popups =
    .label = Blokkeer opspringers
    .accesskey = B

permissions-block-popups-exceptions =
    .label = Uitsonderings…
    .accesskey = U

permissions-addon-exceptions =
    .label = Uitsonderings…
    .accesskey = U

## Privacy Section - Data Collection

collection-health-report-link = Meer inligting

collection-backlogged-crash-reports-link = Meer inligting

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Sekuriteit

security-enable-safe-browsing =
    .label = Blokkeer gevaarlike en bedrieglike inhoud
    .accesskey = B

security-block-downloads =
    .label = Blokkeer gevaarlike aflaaie
    .accesskey = g

security-block-uncommon-software =
    .label = Waarsku oor ongewensde en ongewone sagteware
    .accesskey = d

## Privacy Section - Certificates

certs-header = Sertifikate

certs-select-auto-option =
    .label = Kies outomaties een
    .accesskey = K

certs-select-ask-option =
    .label = Vra elke keer
    .accesskey = V

certs-enable-ocsp =
    .label = Bevestig huidige geldigheid van sertifikate deur OCSP-bedieners te vra
    .accesskey = B

space-alert-learn-more-button =
    .label = Meer inligting
    .accesskey = M

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Open opsies
           *[other] Open voorkeure
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }

space-alert-under-5gb-ok-button =
    .label = Reg so
    .accesskey = R

space-alert-under-5gb-message = { -brand-short-name } se hardeskyfplek raak op. Webwerwe vertoon dalk nie reg nie. Besoek gerus “Meer inligting” vir optimale skyfgebruik en 'n beter blaai-ervaring.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = Werkskerm
downloads-folder-name = Aflaaie
choose-download-folder-title = Kies aflaaivouer:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Stoor lêers in { $service-name }
