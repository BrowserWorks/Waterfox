# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Ketaq ri taq ruxaq ajk'amaya'l jun “Mani Tojqäx” raqän kumal chi man nojowäx ta chi tikanöx
do-not-track-learn-more = Tetamäx ch'aqa' chik
do-not-track-option-default-content-blocking-known =
    .label = Xa xe toq { -brand-short-name } b'anon runuk'ulem richin yeruq'ät ojqanela' etaman kiwäch
do-not-track-option-always =
    .label = Junelïk
pref-page-title =
    { PLATFORM() ->
        [windows] Taq cha'oj
       *[other] Taq ajowab'äl
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
            [windows] Tikanöx pa Taq Cha'oj
           *[other] Tikanöx pa Taq Ajowab'äl
        }
managed-notice = Ri awokik'amaya'l ninuk'samajiïx ruma ri amoloj.
pane-general-title = Chijun
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Tikirib'äl
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Tikanöx
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Ichinanem & Jikomal
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = { -brand-short-name } taq Tojtob'äl
category-experimental =
    .tooltiptext = { -brand-short-name } taq Tojtob'äl
pane-experimental-subtitle = Tachajij awi' chi Rub'anik
pane-experimental-search-results-header = { -brand-short-name } Taq tojtob'äl: Eqal Tab'ana'
pane-experimental-description = Kejal ri q'axinäq taq rajowab'al nuk'ulem, nitikïr nutz'ila' rub'eyal nisamäj o ri rujikomal { -brand-short-name }.
help-button-label = Ruto'ik { -brand-short-name } Temeb'äl
addons-button-label = Taq k'amal & taq Wachinel
focus-search =
    .key = f
close-button =
    .aria-label = Titz'apïx

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } k'o chi nitikirisäx chik richin nitzijtäj re jun rub'anikil re'.
feature-disable-requires-restart = { -brand-short-name } k'o chi nitikirisäx chik richin nichup re rub'anikil re'.
should-restart-title = Titikirisäx chik { -brand-short-name }
should-restart-ok = Titikirisäx chik { -brand-short-name } wakami
cancel-no-restart-button = Tiq'at
restart-later = Titikirisäx pa jun Mej

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
extension-controlled-homepage-override = Jun k'amal, <img data-l10n-name="icon"/> { $name }, ruchajin ri ruxaq atikirisab'al.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Jun k'amal, <img data-l10n-name="icon"/> { $name }, ruchajin ri ruxaq K'ak'a' Ruwi'.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Jun k'amal, <img data-l10n-name="icon"/> { $name }, nuchajij re runuk'ulem re'.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Jun k'amal, <img data-l10n-name="icon"/> { $name }, nuchajij re runuk'ulem re'.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Jun k'amal, <img data-l10n-name="icon"/> { $name }, xujäl ri kanob'äl ruk'amon pe.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Jun k'amal, <img data-l10n-name="icon"/> { $name }, nik'atzin K'ayöl Tabs chi re.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Jun k'amal, <img data-l10n-name="icon"/> { $name }, nuchajij re runuk'ulem re'.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Jun k'amal, <img data-l10n-name="icon"/> { $name }, nuchajij rub'eyal { -brand-short-name } nok pa k'amaya'l.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Richin nitzij ri k'amal jät pa <img data-l10n-name="addons-icon"/> taq Chokoy pa ri <img data-l10n-name="menu-icon"/> k'utsamaj.

## Preferences UI Search Results

search-results-header = Taq ruq'i'oj kanoxïk
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] ¡Kojakuyu'! Majun achike xqïl pa Taq Cha'oj richin ri “<span data-l10n-name="query"></span>”.
       *[other] ¡Kojakuyu'! Majun achike xqïl pa Taq Ajowab'äl richin ri “<span data-l10n-name="query"></span>”.
    }
search-results-help-link = ¿La nawajo' ato'ik? Tatz'eta' <a data-l10n-name="url">{ -brand-short-name } To'ïk</a>

## General Section

startup-header = Tikirisab'äl
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Tiya' q'ij chi ri { -brand-short-name } chuqa' Firefox ketzije' junam
use-firefox-sync = Pixa': Re re' nrokisaj jachon taq ruwäch b'i'aj. Tawokisaj { -sync-brand-short-name } richin nakomonij na'oj chi kikojol.
get-started-not-logged-in = Tatz'ib'aj ab'i' pa { -sync-brand-short-name }…
get-started-configured = Tijaq { -sync-brand-short-name } taq rajowab'al
always-check-default =
    .label = Junelïk tinik'öx we { -brand-short-name } ja ri' ri awokik'amaya'l
    .accesskey = e
is-default = { -brand-short-name } ja awokik'amaya'l kan k'o wi
is-not-default = { -brand-short-name } man ja ta ri awokik'amaya'l kan k'o wi
set-as-my-default-browser =
    .label = Tib'an chi K'o wi…
    .accesskey = K
startup-restore-previous-session =
    .label = Titzolin ri jun kan molojri'ïl
    .accesskey = m
startup-restore-warn-on-quit =
    .label = Tiya' rutzijol toq yatel pa okik'amaya'l
disable-extension =
    .label = Tichup ri K'amal
tabs-group-header = Taq ruwi'
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab mejaj pa taq ruwi' pa k'ak'a' kokisaxik kicholajem
    .accesskey = T
open-new-link-as-tabs =
    .label = Kejaq taq ximonel pa taq ruwi' pa ruk'exel kik'in k'ak'a' taq tzuwäch
    .accesskey = z
warn-on-close-multiple-tabs =
    .label = Taya' pe rutzijol we xketz'apitäj jalajöj taq ruwi'
    .accesskey = j
warn-on-open-many-tabs =
    .label = Taya' pe rutzijol we { -brand-short-name } yalan eqal xtisamäj toq xkerujäq k'ïy taq ruwi'
    .accesskey = e
switch-links-to-new-tabs =
    .label = Toq najäq jun ximonel pa jun k'ak'a' ruwi', tijalwachïx rik'in re' pan aninäq
    .accesskey = o
show-tabs-in-taskbar =
    .label = Kek'ut pe ch'utin taq ruwi' pa ri rukajtz'ik rusamaj Windows
    .accesskey = w
browser-containers-enabled =
    .label = Ketzij Ajk'wayöl taq ruwi'
    .accesskey = t
browser-containers-learn-more = Tetamäx ch'aqa' chik
browser-containers-settings =
    .label = Taq nuk'ulem…
    .accesskey = l
containers-disable-alert-title = ¿La yetz'apïx konojel ri kik'ojlib'al taq ruwi'?
containers-disable-alert-desc =
    { $tabCount ->
        [one] We ye'achüp ri ruk'ojlib'al taq ruwi' wakami, { $tabCount } ruk'ojlib'al ruwi' xtitz'apïx. ¿La kan nawajo' ye'achüp ruk'ojlib'al taq ruwi'?
       *[other] We ye'achüp ri kik'ojlib'al taq ruwi' wakami, { $tabCount } kik'ojlib'al taq ruwi' xketz'apïx. ¿La kan nawajo' ye'achüp ri ruk'ojlib'al taq ruwi'?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Titz'apïx { $tabCount } ruk'ojlib'al ruwi'
       *[other] Ketz'apïx { $tabCount } ruk'ojlib'al taq ruwi'
    }
containers-disable-alert-cancel-button = Junelïk titzije'
containers-remove-alert-title = ¿La niyuj el re k'wayöl re'?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] We nayüj el re Ruk'wayöl re' wakami, { $count } ruk'wayöl ruwi' xtitz'apïx. ¿La kan nawajo' ye'ayüj re k'wayöl re'?
       *[other] We nayüj re ruk'wayöl re' wakami, { $count } k'wayöl taq ruwi' xketz'apitäj. ¿La kan nawajo' ye'ayüj re k'wyöl re'?
    }
containers-remove-ok-button = Tiyuj el re k'wayöl re'
containers-remove-cancel-button = Man tiyuj el re k'wayöl re'

## General Section - Language & Appearance

language-and-appearance-header = Ch'ab'äl chuqa' Rutzub'al
fonts-and-colors-header = Kiwäch taq tz'ib' chuqa' taq b'onil
default-font = Ruwäch tzij kan k'o wi
    .accesskey = k
default-font-size = Nimilem
    .accesskey = N
advanced-fonts =
    .label = Taq Q'axinäq…
    .accesskey = Q
colors-settings =
    .label = Taq b'onil…
    .accesskey = T
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Sum
preferences-default-zoom = Sum k'o wi
    .accesskey = S
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Sum xa xe pa ri tz'ib'
    .accesskey = t
language-header = Ch'ab'äl
choose-language-description = Ticha' ri ch'ab'äl nawajo' richin yek'ut pe ri taq ruxaq k'amaya'l
choose-button =
    .label = Ticha'…
    .accesskey = c
choose-browser-language-description = Kecha' ri taq ch'ab'äl e'okisan richin yek'ut taq molsamajib'äl, taq rutzijol taqoj, taq rutzijol { -brand-short-name }.
manage-browser-languages-button =
    .label = Keya' taq Cha'oj
    .accesskey = h
confirm-browser-language-change-description = Titikirisäx chik { -brand-short-name } richin ye'okisäx ri taq k'exoj
confirm-browser-language-change-button = Tisamajïx chuqa' Titikirisäx chik
translate-web-pages =
    .label = Titzalq'omïx rupam ajk'amaya'l
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Tzalq'oman ruma <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Taq man relik ta…
    .accesskey = e
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Tawokisaj ri runuk'ulem aq'inoj richin “{ $localeName }” richin nib'an kik'ojlem q'ijul, ramaj, ajilab'äl chuqa' etab'äl.
check-user-spelling =
    .label = Tinik'öx ri nutz'ib'anik toq yitz'ib'an
    .accesskey = n

## General Section - Files and Applications

files-and-applications-title = Taq Yakb'äl chuqa' taq Chokoy
download-header = Taq qasanïk
download-save-to =
    .label = Keyak yakb'äl pa
    .accesskey = y
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Ticha'…
           *[other] Tinik'öx…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] T
           *[other] n
        }
download-always-ask-where =
    .label = Jantape' tik'utüx pe akuchi' yeyak wi kan ri taq yakb'äl
    .accesskey = J
applications-header = Taq chokoy
applications-description = Tacha' achi'el rub'eyal { -brand-short-name } yerusamajij ri taq yakb'äl ye'aqasaj pan ajk'amaya'l o ri taq chokoy ye'awokisaj toq atokinäq pa k'amaya'l.
applications-filter =
    .placeholder = Kekanöx ruwäch chi yakb'äl o taq chokoy
applications-type-column =
    .label = Ruwäch Rupam
    .accesskey = R
applications-action-column =
    .label = B'anoj
    .accesskey = B
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } yakb'äl
applications-action-save =
    .label = Tiyak Yakb'äl
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Tokisäx { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Tokisäx { $app-name } (ruk'amon wi pe)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Tokisäx ri ruchokoy macOS k'o wi
            [windows] Tokisäx ri ruchokoy Windows k'o wi
           *[other] Tokisäx ri ruchokoy q'inoj k'o wi
        }
applications-use-other =
    .label = Tokisäx jun chik…
applications-select-helper = Tacha' To'onel Chokoy
applications-manage-app =
    .label = Taq kib'anikil chokoy…
applications-always-ask =
    .label = Junelïk tik'utüx pe
applications-type-pdf = K'wayel Rub'anikil Wuj (K'RW)
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
    .label = Tokisäx { $plugin-name } (pa { -brand-short-name })
applications-open-inapp =
    .label = Tijaq pa { -brand-short-name }

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

drm-content-header = Kematz'ib'il ch'ojib'äl Runuk'samajixik (DRM) Rupam
play-drm-content =
    .label = Titzij DRM-chajin rupam
    .accesskey = T
play-drm-content-learn-more = Tetamäx ch'aqa' chik
update-application-title = { -brand-short-name } Taq k'exoj ruwäch
update-application-description = Junelïk tik'ex ri { -brand-short-name } richin ütz nisamäj, jikïl, chuqa' jikon.
update-application-version = Ruwäch { $version } <a data-l10n-name="learn-more">Achike natzijoj</a>
update-history =
    .label = Tik'ut pe ri runatab'al K'exoj ruwäch…
    .accesskey = K
update-application-allow-description = Tiya' q'ij { -brand-short-name } chi re
update-application-auto =
    .label = Ruyonil keyak taq k'exoj (echilab'en)
    .accesskey = R
update-application-check-choose =
    .label = Kenik'öx taq k'exoj ruwäch, xa xe chi tiya' q'ij chwe richin nincha' we yenyäk
    .accesskey = K
update-application-manual =
    .label = Majub'ey kekanöx taq k'exoj ruwäch (we man echilab'en ta)
    .accesskey = M
update-application-warning-cross-user-setting = Re runuk'ulem re' xtisamajïx pa ronojel taq rub'i' kitaqoya'l Windows chuqa' ri taq ruwäch rub'i' { -brand-short-name } rik'in rokisaxik re ruyakoj { -brand-short-name }.
update-application-use-service =
    .label = Tokisäx jun samaj pa ruka'n b'ey richin yeyak ri taq k'exoj ruwäch
    .accesskey = r
update-setting-write-failure-title = Xsach toq xyak ri Ruk'exoj taq ajowab'äl
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } xrïl jun sachoj ruma ri' toq man xuyäk ta re jaloj re'. Tatz'eta' chi re runuk'ulem re rajowab'al jaloj re' nrajo' chi niya' q'ij richin nitz'ib'äx pa ri yakb'äl. Rik'in jub'a' rat o jun runuk'samajel q'inoj yixtikïr nisöl re sachoj, rik'in ruchajixik chijun ri yakb'äl ruma ri molaj okisanela'. 
    
    Man tikirel ta xtz'ib'äx chupam ri yakb'äl: { $path }
update-in-progress-title = Nitajin Nik'ex
update-in-progress-message = ¿La nawajo' chi ri { -brand-short-name } nuk'isib'ej ri k'exoj?
update-in-progress-ok-button = &Tich'aqïx
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Titikïr chik el

## General Section - Performance

performance-title = Rub'eyal nisamäj
performance-use-recommended-settings-checkbox =
    .label = Tokisäx runuk'ulem rub'eyal nisamäj chilab'en pe
    .accesskey = T
performance-use-recommended-settings-desc = Re taq nuk'ulem re' nikik'äm ki' kik'in ri ch'akulakem chuqa' rik'in ri samajel ruq'inoj akematz'ib'.
performance-settings-learn-more = Tetamäx ch'aqa' chik
performance-allow-hw-accel =
    .label = Tokisäx rupararexik ch'akulakem toq xtiwachin pe
    .accesskey = a
performance-limit-content-process-option = ruchi' rutajinik rupam
    .accesskey = r
performance-limit-content-process-enabled-desc = Ri taq ruxenab'al rutz'aqat rupam yetikïr nikutzilaj rub'eyal nisamäj toq nrokisaj k'ïy taq ruwi', xa chuqa' xtrokisaj k'ïy rutzatzq'ob'al.
performance-limit-content-process-blocked-desc = Ri rujalwachinik rajilab'al rutajinik rupam xa okel rik'in ri k'ïy tajinïk { -brand-short-name }. <a data-l10n-name="learn-more">Tawetamaj nanik'oj we tzijïl ri k'ïy tajinïk</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (ruk'amon wi pe)

## General Section - Browsing

browsing-title = Okik'amaya'l
browsing-use-autoscroll =
    .label = Tokisäx ruyonil rusiloxik
    .accesskey = r
browsing-use-smooth-scrolling =
    .label = Tokisäx jeb'ël q'axanïk
    .accesskey = e
browsing-use-onscreen-keyboard =
    .label = Tik'ut pe ri na'onel pitzb'äl toq xtik'atzin
    .accesskey = p
browsing-use-cursor-navigation =
    .label = Junelïk ke'awokisaj ri taq rupitz'b'al retal ch'oy richin yatok pa taq ruxaq k'amaya'l
    .accesskey = c
browsing-search-on-start-typing =
    .label = Tikanöx taq rucholajem tzij toq tajin yatz'ib'an
    .accesskey = t
browsing-picture-in-picture-toggle-enabled =
    .label = Titzij kichajixik silowäch picture-in-picture
    .accesskey = t
browsing-picture-in-picture-learn-more = Tetamäx ch'aqa' chik
browsing-cfr-recommendations =
    .label = Kechilab'ëx taq k'amal toq nib'an okem pa k'amaya'l
    .accesskey = K
browsing-cfr-features =
    .label = Ke'achilab'ej taq b'anikil toq atokinäq pa k'amaya'l
    .accesskey = b
browsing-cfr-recommendations-learn-more = Tetamäx Ch'aqa' chik

## General Section - Proxy

network-settings-title = Runuk'ulem Okem
network-proxy-connection-description = Tib'an runuk'ulem rub'eyal { -brand-short-name } nok pa k'amaya'l.
network-proxy-connection-learn-more = Tetamäx ch'aqa' chik
network-proxy-connection-settings =
    .label = Taq nuk'ulem…
    .accesskey = n

## Home Section

home-new-windows-tabs-header = K'ak'a' taq Tzuwäch chuqa' taq Ruwi'
home-new-windows-tabs-description2 = Tacha' ri natz'ët toq ye'ajäq ri tikirib'äl ruxaq, k'ak'a' taq tzuwäch chuqa' k'ak'a' taq ruwi'.

## Home Section - Home Page Customization

home-homepage-mode-label = Tikirib'äl ruxaq chuqa' k'ak'a' taq tzuwäch
home-newtabs-mode-label = K'ak'a' taq ruwi'
home-restore-defaults =
    .label = Ketzolij ri E K'o wi
    .accesskey = K
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox Tikirib'äl (K'o wi)
home-mode-choice-custom =
    .label = Ichinan URLs...
home-mode-choice-blank =
    .label = Kowöl Ruxaq
home-homepage-custom-url =
    .placeholder = Titz'ajb'äx jun URL...
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Tokisäx ri ruxaq k'amaya'l k'o wakami
           *[other] Ke'okisäx ri taq ruxaq k'amaya'l e k'o wakami
        }
    .accesskey = w
choose-bookmark =
    .label = Tokisäx yaketal…
    .accesskey = y

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Etamab'äl pa ri Rutikirib'al Firefox
home-prefs-content-description = Tacha' achike etamab'äl nawajo' pa ri Rutikirib'al Firefox ruwäch.
home-prefs-search-header =
    .label = Ajk'amaya'l Kanoxïk
home-prefs-topsites-header =
    .label = Jeb'ël Taq Ruxaq
home-prefs-topsites-description = Taq ruxaq yalan ye'atz'ët

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Chilab'en ruma { $provider }
home-prefs-recommended-by-description-update = Man relik ta chi rupam chijun ri ajk'amaya'l, to'on ruma { $provider }

##

home-prefs-recommended-by-learn-more = Achike rub'eyal nisamäj
home-prefs-recommended-by-option-sponsored-stories =
    .label = To'on taq B'anob'äl
home-prefs-highlights-header =
    .label = Ya'on kiq'ij
home-prefs-highlights-description = Jun rucha'onem ruxaq, ri xayäk o xatz'ët
home-prefs-highlights-option-visited-pages =
    .label = Taq Ruxaq Etz'eton
home-prefs-highlights-options-bookmarks =
    .label = Taq yaketal
home-prefs-highlights-option-most-recent-download =
    .label = K'a B'a' Keqasäx
home-prefs-highlights-option-saved-to-pocket =
    .label = Taq Ruxaq Eyakon pa { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Taq pir
home-prefs-snippets-description = Kik'exoj { -vendor-short-name } chuqa' { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } cholaj
           *[other] { $num } taq cholaj
        }

## Search Section

search-bar-header = Rukajtz'ik Kanoxïk
search-bar-hidden =
    .label = Tokisax ri kikajtz'ik ochochib'äl richin nikanöx chuqa' ri okem pa k'amaya'l
search-bar-shown =
    .label = Titz'aqatisäx ri rukajtz'ik kanoxïk pa molsamajib'äl
search-engine-default-header = K'o wi chi Kanob'äl
search-engine-default-desc-2 = Re re' jun rokik'amaya'l kanoxïk ri k'o pa kikajtz'ik ochochib'äl chuqa' pa ri rukajtz'ik kanoxïk. Yatikïr najäl pa xab'achike ramaj.
search-engine-default-private-desc-2 = Ticha achi'el ri rokik'amaya'l kanoxïk k'o kichin Ichinan taq Tzuwäch
search-separate-default-engine =
    .label = Tokisäx re kanob'äl re pan Ichinan Tzuwäch
    .accesskey = o
search-suggestions-header = Kichilab'exik Kanoxïk
search-suggestions-desc = Tacha' achike rub'eyal yetz'et ri taq kichilab'exik ri yekanöx.
search-suggestions-option =
    .label = Tiya' pe taq chilab'en  richin nikanöx
    .accesskey = n
search-show-suggestions-url-bar-option =
    .label = Kek'ut pe taq ruchilab'enik kanoxïk chi kikojol ri kiq'iq'oj kikajtz'ik taq ochochib'äl
    .accesskey = q
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Kek'ut pe taq chilab'enïk nab'ey chuwäch ri natab'äl pa ri xe'ilitäj pa ri kikajtz'ik taq ochochib'äl
search-show-suggestions-private-windows =
    .label = Kek'ut pe taq kichilab'exik kanoxik pa Ichinan taq Tzuwäch
suggestions-addressbar-settings-generic = Kek'ex ri taq kajowab'al ch'aqa' chik taq kichilab'enik kikajtz'ik ochochib'äl
search-suggestions-cant-show = Man xkeq'alajin ta pe ri taq chilab'exïk richin nikanöx pa rukajtz'ik ochochib'äl ruma chi anuk'un ri { -brand-short-name } richin majub'ey tunataj ri anatab'al.
search-one-click-header = Samajel taq kanob'äl rik'in jupitz'oj
search-one-click-desc = Ke'acha' chi kikojol ri kik'u'x taq kanob'äl yeq'alajin pe chuxe' ri kikajtz'ik taq ochochib'äl chuqa' ri rukajtz'ik kanoxïk toq natz'ib'aj qa jun ruxe'el tzij.
search-choose-engine-column =
    .label = Kanob'äl
search-choose-keyword-column =
    .label = Ruk'u'x tzij
search-restore-default =
    .label = Ketzolïx ri kisamajel kanob'äl ruk'amon wi pe
    .accesskey = r
search-remove-engine =
    .label = Tiyuj
    .accesskey = y
search-add-engine =
    .label = Titz'aqatisäx
    .accesskey = t
search-find-more-link = Kekanöx ch'aqa' chik kik'u'x taq kanob'äl
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Kamulun ewan tzij
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Xacha' jun ewan tzij ri tajin nokisäx ruma “{ $name }”. Tacha' jun chik.
search-keyword-warning-bookmark = Xacha' jun ewan tzij okisan ruma jun yaketal. Tacha' jun chik.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Titzolin pa taq Cha'oj
           *[other] Titzolin pa taq Ajowab'äl
        }
containers-header = Ajk'wayöl taq ruwi'
containers-add-button =
    .label = Titz'aqatisäx k'ak'a' k'wayöl
    .accesskey = t
containers-new-tab-check =
    .label = Ticha jun ruk'wayöl ri k'ak'a' ruwi'
    .accesskey = T
containers-preferences-button =
    .label = Taq ajowab'äl
containers-remove-button =
    .label = Tiyuj

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Tak'waj awik'in ri Ajk'amaya'l
sync-signedout-description = Ke'axima' ri taq ayaketal, natab'äl, taq ruwi', taq ewan tzij, taq tz'aqat chuqa' taq ajowab'äl chi kikojol konojel ri taq awokisaxel.
sync-signedout-account-signin2 =
    .label = Tatz'ib'aj ab'i' pa { -sync-brand-short-name }…
    .accesskey = p
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Taqasaj Firefox richin <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> chuqa' <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> richin naxïm rik'in ri awoyonib'al okisaxel.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Tijal ruwachib'al ruwäch b'i'aj
sync-sign-out =
    .label = Titz'apïx Molojri'ïl…
    .accesskey = p
sync-manage-account = Tinuk'samajïx rub'i' taqoya'l
    .accesskey = y
sync-signedin-unverified = { $email } man jikib'an ta.
sync-signedin-login-failure = Tatikirisaj molojri'ïl richin yatok chik { $email }
sync-resend-verification =
    .label = Titaq chik Jikib'anïk
    .accesskey = q
sync-remove-account =
    .label = Tiyuj Rub'i' Taqoya'l
    .accesskey = y
sync-sign-in =
    .label = Titikirisäx molojri'ïl
    .accesskey = t

## Sync section - enabling or disabling sync.

prefs-syncing-on = Nixim: TZIJÏL
prefs-syncing-off = Nixim: CHUPÜL
prefs-sync-setup =
    .label = Tib'an runuk'ulem { -sync-brand-short-name }...
    .accesskey = n
prefs-sync-offer-setup-label = Ke'axima' ri taq ayaketal, natab'äl, taq ruwi', taq ewan tzij, taq tz'aqat chuqa' taq ajowab'äl chi kikojol konojel ri taq awokisaxel.
prefs-sync-now =
    .labelnotsyncing = Tixim Wakami
    .accesskeynotsyncing = W
    .labelsyncing = Nixim…

## The list of things currently syncing.

sync-currently-syncing-heading = Wakami ye'axïm re taq ch'akulal:
sync-currently-syncing-bookmarks = Taq yaketal
sync-currently-syncing-history = Natab'äl
sync-currently-syncing-tabs = Kejaq ruwi'
sync-currently-syncing-logins-passwords = Kitikirisaxik molojri'ïl chuqa' ewan taq tzij
sync-currently-syncing-addresses = Taq ochochib'äl
sync-currently-syncing-creditcards = Taq ch'utit'im pwäq
sync-currently-syncing-addons = Taq tz'aqat
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Taq cha'oj
       *[other] Taq ajowab'äl
    }
sync-change-options =
    .label = Tijal…
    .accesskey = j

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Tacha' Achike Naxïm
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Keyak Jaloj
    .buttonaccesskeyaccept = K
    .buttonlabelextra2 = Nichup…
    .buttonaccesskeyextra2 = c
sync-engine-bookmarks =
    .label = Taq yaketal
    .accesskey = e
sync-engine-history =
    .label = K'ulwachinel
    .accesskey = e
sync-engine-tabs =
    .label = Kejaq ruwi'
    .tooltiptext = Jun rucholb'al ri achike jaqäl pa konojel ri taq okisab'äl eximon
    .accesskey = r
sync-engine-logins-passwords =
    .label = Kitikirisaxik molojri'ïl chuqa' ewan taq tzij
    .tooltiptext = Rub'i' winäq chuqa' ewan taq rutzij eruyakon
    .accesskey = L
sync-engine-addresses =
    .label = Taq ochochib'äl
    .tooltiptext = Kochochib'al b'ow e'ayakon (xa xe kematz'ib')
    .accesskey = i
sync-engine-creditcards =
    .label = Taq Ch'utit'im pwäq
    .tooltiptext = Taq b'i'aj, taq ajilab'äl chuqa' nik'is kiq'ijul taq q'ijul (xa xe ajk'ematz'ib')
    .accesskey = C
sync-engine-addons =
    .label = Taq tz'aqat
    .tooltiptext = Taq k'amal chuqa' taq wachinïk richin Firefox ajk'ematz'ib'
    .accesskey = t
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Taq cha'oj
           *[other] Taq ajowab'äl
        }
    .tooltiptext = Chijun Runuk'ulem, Ichinanem chuqa' Jikomal e'ajalon
    .accesskey = a

## The device name controls.

sync-device-name-header = Rub'i' ri okisaxel
sync-device-name-change =
    .label = Tijal rub'i' okisaxel…
    .accesskey = j
sync-device-name-cancel =
    .label = Tiq'at
    .accesskey = q
sync-device-name-save =
    .label = Tiyak
    .accesskey = a
sync-connect-another-device = Tokisäx jun chik okisaxel

## Privacy Section

privacy-header = Richinanem Okik'amaya'l

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Kitikirisaxik Molojri'ïl chuqa' Ewan taq Tzij
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Tik'utüx chi rij ri kiyakik kitikirib'al taq molojri'ïl chuqa' ri ewan taq kitzij taq ruxaq ajk'amaya'l
    .accesskey = r
forms-exceptions =
    .label = Taq man relik ta…
    .accesskey = e
forms-generate-passwords =
    .label = Nuchilab'ej chuqa' yerunük' nïm ewan taq tzij
    .accesskey = c
forms-breach-alerts =
    .label = Kek'ut pe rutzijol taq k'ayewal chi kij ewan taq tzij kichin tz'ilan ajk'amaya'l ruxaq.
    .accesskey = n
forms-breach-alerts-learn-more-link = Tetamäx ch'aqa' chik
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Ruyonil ketz'aqatisäx ri tikirib'äl molojri'ïl chuqa' ewan taq tzij
    .accesskey = i
forms-saved-logins =
    .label = Yakon kitikirib'al molojri'ïl…
    .accesskey = k
forms-master-pw-use =
    .label = Tokisäx ri nimaläj ewan tzij
    .accesskey = T
forms-primary-pw-use =
    .label = Tokisäx jun Nab'ey Ewan Tzij
    .accesskey = k
forms-primary-pw-learn-more-link = Tetamäx ch'aqa' chik
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Tijal Ajtij Ewan Tzij…
    .accesskey = A
forms-master-pw-fips-title = Wakami at k'o pa rub'eyal FIPS. FIPS nrajo' jun nimaläj ewan tzij, ri man kowöl ta.
forms-primary-pw-change =
    .label = Tijal Nab'ey Ewan Tzij…
    .accesskey = N
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Etaman ruwa achi'el Ajtij Ewan Tzij
forms-primary-pw-fips-title = Wakami at k'o pa rub'eyal FIPS. FIPS nrajo' jun Nab'ey Ewan Tzij ri man kowöl ta.
forms-master-pw-fips-desc = Xsach toq Nijal ri Ewan Tzij

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Richin natz'ük jun ajtij ewan atzij, tatz'ib'aj ri ruwujil rutikirisaxik molojri'ïl richin Windows. Re re' nuto' richin nuchajij rujikomal ri rub'i' ataqoya'l.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = Titz'uk jun Nimaläj Ewan Tzij
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Richin natz'ük jun Nab'ey Ewan Tzij, tatz'ib'aj ri ruwujil rutikirisaxik molojri'ïl richin Windows. Re re' nuto' richin nuchajij rujikomal ri rub'i' ataqoya'l.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Titz'uk jun Nab'ey Ewan Tzij
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Natab'äl
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } xtipo'
    .accesskey = x
history-remember-option-all =
    .label = Tinatäx ri natab'äl
history-remember-option-never =
    .label = Mani ninatäx ri natab'äl
history-remember-option-custom =
    .label = Tokisäx jun ichinan runuk'ulem re natab'äl
history-remember-description = { -brand-short-name } Xtunataj awokem pa k'amaya'l, qasanïk, nojwuj chuqa' runatab'al kanoxïk.
history-dontremember-description = { -brand-short-name } xtrokisaj ri junam runuk'ulem achi'el pa ichinan okem pa k'amaya'l, chuqa' man xkerunataj ta ri taq rutzij natab'äl toq tajin nok pa ajk'amaya'l.
history-private-browsing-permanent =
    .label = Junelïk tokisäx pa rub'eyal ichinan okem pa k'amaya'l
    .accesskey = i
history-remember-browser-option =
    .label = Tinatäx ri runatab'al okem pa k'amaya'l chuqa' ri qasanïk
    .accesskey = k
history-remember-search-option =
    .label = Tinatäx ri runatab'al kanob'äl chuqa' taq nojwuj
    .accesskey = n
history-clear-on-close-option =
    .label = Tijoxq'ïx ri natab'äll toq nitz'apïx { -brand-short-name }
    .accesskey = j
history-clear-on-close-settings =
    .label = Taq nuk'ulem…
    .accesskey = n
history-clear-button =
    .label = Tiyuj el ri Natab'äl…
    .accesskey = t

## Privacy Section - Site Data

sitedata-header = Taq Kuki chuqa' Rutzij Ruxaq
sitedata-total-size-calculating = Tajin nipaj kinimilem taq rutzij chuqa' rujumejyak ruxaq k'amaya'l…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Ri yakon taq kaxlanwey, rutzij ruxaq chuqa' ri rutzatzq'or taq jumejyak nikokisaj { $value } { $unit } chi re ri rupam nimayakb'äl.
sitedata-learn-more = Tetamäx ch'aqa' chik
sitedata-delete-on-close =
    .label = Keyuj taq kuki chuqa' taq rutzij ruxaq toq nitz'apïx { -brand-short-name }
    .accesskey = k
sitedata-delete-on-close-private-browsing = Pa rub'eyal junelïk ichinan okem, ri taq kuki chuqa' ri taq rutzij ruxaq k'amaya'l jantape' xkeyuj { -brand-short-name } toq nitz'apïx.
sitedata-allow-cookies-option =
    .label = Kek'ulutäj taq rukaxlanway chuqa' taq rutzij k'amaya'l
    .accesskey = K
sitedata-disallow-cookies-option =
    .label = Keq'at taq rukaxlanwäy chuqa' Rutzij K'amaya'l
    .accesskey = K
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Q'aton ruwäch
    .accesskey = r
sitedata-option-block-cross-site-trackers =
    .label = Kojqanela' xoch'in taq ruxaq
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Kojqanela' taq ruxaq chuqa' aj winäq k'amab'ey
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Kojqanela' xoch'in taq ruxaq chuqa' winaqil taq k'amab'ey, chuqa' kijech'unik ri ch'aqa' chik taq kuki
sitedata-option-block-unvisited =
    .label = Taq kuki man etz'eton ta ajkamaya'l taq ruxaq
sitedata-option-block-all-third-party =
    .label = Konojel ri taq kikuki aj rox winäq (yetikïr yetz'ilon pan ajk'amaya'l ruxaq)
sitedata-option-block-all =
    .label = Konojel ri taq kuki (xketz'ilon pa ri ajk'amaya'l ruxaq)
sitedata-clear =
    .label = Tijosq'ïx Tzij…
    .accesskey = j
sitedata-settings =
    .label = Kenuk'samajïx Tzij…
    .accesskey = K
sitedata-cookies-permissions =
    .label = Kenuk'samajïx taq Ya'oj Q'ij...
    .accesskey = Y
sitedata-cookies-exceptions =
    .label = Kenuk'samajïx taq Man Relik Ta...
    .accesskey = R

## Privacy Section - Address Bar

addressbar-header = Kikajtz'ik Ochochib'äl
addressbar-suggest = Jampe' toq nawokisaj ri rukajtz'ik ochochib'äl, tichilab'ëx
addressbar-locbar-history-option =
    .label = Runatab'al okem pa k'amaya'l
    .accesskey = n
addressbar-locbar-bookmarks-option =
    .label = Taq yaketal
    .accesskey = e
addressbar-locbar-openpage-option =
    .label = Kejaq ruwi'
    .accesskey = K
addressbar-locbar-topsites-option =
    .label = Jeb'ël taq ruxaq
    .accesskey = J
addressbar-suggestions-settings = Kek'ex ri taq kajowab'al ri taq kichilab'enik kisamajinel taq kanob'äl

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Utzirisan Chajinïk chuwäch Ojqanem
content-blocking-section-top-level-description = Ri ojqanela' yatkojqaj pa k'amab'ey richin nikimöl ri awetamab'al chi rij ri ye'ab'än chuqa' ri niqa chawäch nakanoj. { -brand-short-name } ke'aq'ata' k'ïy chi ke ri taq ojqanela' ri' chuqa' ch'aqa' chik tz'ilanel taq skrip.
content-blocking-learn-more = Tetamäx Ch'aqa' Chik

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Pa rub'eyal
    .accesskey = b
enhanced-tracking-protection-setting-strict =
    .label = Nimaläj
    .accesskey = l
enhanced-tracking-protection-setting-custom =
    .label = Ichinan
    .accesskey = I

##

content-blocking-etp-standard-desc = Silan richin chajinem chuqa' rub'eyal nisamäj. Achi'el jutaqil xkesamäj ri taq ruxaq.
content-blocking-etp-strict-desc = Nïm chajinem, xa xe chi nub'än chi jujun taq ruxaq o rupam man yesamäj ta.
content-blocking-etp-custom-desc = Ke'acha' achike taq ojqanela' chuqa' kiskrip taq komando nawajo' ye'aq'ät
content-blocking-private-windows = Kichajinik taq rupam pan Ichinan taq Tzuwäch
content-blocking-cross-site-tracking-cookies = kikuki kojqanik xoch'in taq ruxaq
content-blocking-cross-site-tracking-cookies-plus-isolate = Taq kikuki kojqanem xoch'in taq ruxaq chuqa' kijech'unik ri ch'aqa' chik taq kuki
content-blocking-social-media-trackers = Kojqanela' aj winäq k'amab'ey
content-blocking-all-cookies = Ronojel taq kuki
content-blocking-unvisited-cookies = Taq kikuki ruxaq k'amaya'l man e tz'eton ta
content-blocking-all-windows-tracking-content = Rojqaxik rupam pa ronojel tzuwäch
content-blocking-all-third-party-cookies = Ronojel kikuki aj rox winäq
content-blocking-cryptominers = Cryptominers
content-blocking-fingerprinters = Fingerprinters
content-blocking-warning-title = ¡Tak'axäx!
content-blocking-and-isolating-etp-warning-description = Rik'in yeq'at taq ojqanela' chuqa' yejech'üx ri taq kuki rik'in jub'a' nutz'ila' rub'eyal yesamäj jujun taq ruxaq. Tasamajij chik jun ruxaq rik'in ojqanela' richin nasamajib'ej ronojel ri rupam.
content-blocking-warning-learn-how = Tetamäx achike rub'eyal
content-blocking-reload-description = K'o chi ye'asamajib'ej chik ri taq ruwi' richin ye'awokisaj re taq jaloj re'.
content-blocking-reload-tabs-button =
    .label = Kesamajib'ëx Chik Konojel Ri Taq Ruwi'
    .accesskey = K
content-blocking-tracking-content-label =
    .label = Rupam ojqanem
    .accesskey = o
content-blocking-tracking-protection-option-all-windows =
    .label = Pa ronojel tzuwäch
    .accesskey = t
content-blocking-option-private =
    .label = Xa xe pa taq Ichinan tzuwäch
    .accesskey = I
content-blocking-tracking-protection-change-block-list = Tijaq rucholajem q'atoj
content-blocking-cookies-label =
    .label = Taq kuki
    .accesskey = k
content-blocking-expand-section =
    .tooltiptext = Ch'aqa' chik rutzijol
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
    .label = Kenuk'samajïx taq Man Relik Ta...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Taq ya'oj q'ij
permissions-location = K'ojlib'äl
permissions-location-settings =
    .label = Taq nuk'ulem…
    .accesskey = K
permissions-xr = Achik'al K'ojlemal
permissions-xr-settings =
    .label = Taq nuk'ulem…
    .accesskey = k
permissions-camera = Elesäy wachib'äl
permissions-camera-settings =
    .label = Taq nuk'ulem…
    .accesskey = m
permissions-microphone = Q'asäy ch'ab'äl
permissions-microphone-settings =
    .label = Taq nuk'ulem…
    .accesskey = m
permissions-notification = Taq rutzijol
permissions-notification-settings =
    .label = Taq nuk'ulem…
    .accesskey = k
permissions-notification-link = Tetamäx ch'aqa' chik
permissions-notification-pause =
    .label = Keq'at ri taq rutzijol k'a toq ri { -brand-short-name } nitikïr chik
    .accesskey = r
permissions-autoplay = Ruyon titzijtäj
permissions-autoplay-settings =
    .label = Taq nuk'ulem…
    .accesskey = l
permissions-block-popups =
    .label = Keq'at elenel taq tzuwäch
    .accesskey = K
permissions-block-popups-exceptions =
    .label = Taq man relik ta…
    .accesskey = r
permissions-addon-install-warning =
    .label = Taya' rutzijol jampe' toq ri ruxaq ajk'amaya'l nrajo' yeruyäk taq tz'aqat
    .accesskey = T
permissions-addon-exceptions =
    .label = Taq man relik ta…
    .accesskey = r
permissions-a11y-privacy-checkbox =
    .label = Tichajïx chi ri okem taq samaj ke'ok pan awokik'amaya'l
    .accesskey = a
permissions-a11y-privacy-link = Tetamäx ch'aqa' chik

## Privacy Section - Data Collection

collection-header = { -brand-short-name } Kimolik chuqa' Kokisaxik taq Tzij
collection-description = Niqatïj qaq'ij richin yeqasüj taq cha'oj chawe chuqa' yeqamöl xa xe ri niqajo' niqaq'axaj chawe chuqa' ri niqutzilaj { -brand-short-name } kichin konojel. Junelïk naqak'utuj qij chuwäch niqak'ül ri awetamab'al.
collection-privacy-notice = Ichinan Na'oj
collection-health-report-telemetry-disabled = Man nuya' ta chik q'ij chi ri { -vendor-short-name } yeruchäp samajel chuqa' k'exonel taq tzij. Konojel ri taq tzij xkeyujtäj pa 30 q'ij.
collection-health-report-telemetry-disabled-link = Tetamäx ch'aqa' chik
collection-health-report =
    .label = Tiya' q'ij chi re { -brand-short-name } richin nitaq etamatel taq tzij chuqa' jutzijonem chi re ri { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Tetamäx ch'aqa' chik
collection-studies =
    .label = Tiya' q'ij chi re ri { -brand-short-name } niyakon chuqa' nusamajij tijonïk
collection-studies-link = Ketz'et taq rutijonik { -brand-short-name }
addon-recommendations =
    .label = Tiya' q'ij chi re { -brand-short-name } ichinan tichilab'en chi kij taq k'amal
addon-recommendations-link = Tetamäx ch'aqa' chik
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Chupül ri kitzijol taq tzij richin nib'an kinuk'ulem re taq alk'walaxinem re'
collection-backlogged-crash-reports =
    .label = Tiya' q'ij chi re { -brand-short-name } nutäq e'oyob'en kitzijol sachoj pan ab'i'
    .accesskey = c
collection-backlogged-crash-reports-link = Tetamäx ch'aqa' chik

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Jikomal
security-browsing-protection = Q'olonel Rupam chuqa' Itzel Ruchajixik Kema'
security-enable-safe-browsing =
    .label = Keq'at k'ayew chuqa' q'olonel rupam
    .accesskey = K
security-enable-safe-browsing-link = Tetamäx ch'aqa' chik
security-block-downloads =
    .label = Keq'at k'ayew taq qasanïk
    .accesskey = k
security-block-uncommon-software =
    .label = Taya' pe rutzijol pa ruwi' ri itzel chuqa' man relik ta taq kema'
    .accesskey = n

## Privacy Section - Certificates

certs-header = Taq ruwujil b'i'aj
certs-personal-label = Toq jun ruk'u'x samaj nuk'utuj pe ri ruwujil ab'i'
certs-select-auto-option =
    .label = Pa ruyonil ticha' jun
    .accesskey = c
certs-select-ask-option =
    .label = Junelïk tik'utüx pe
    .accesskey = J
certs-enable-ocsp =
    .label = Rutzolixik rutzij ri OCSP peyon tzij, ri ruk'u'x taq samaj nikijikib'a' ri kutzil ri taq ruwujil rub'i'
    .accesskey = p
certs-view =
    .label = Titz'et taq Ruwujil b'i'aj…
    .accesskey = R
certs-devices =
    .label = Taq Rokisab'al Jikomal…
    .accesskey = R
space-alert-learn-more-button =
    .label = Tetamäx Ch'aqa' Chik
    .accesskey = T
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Kejaq taq cha'oj
           *[other] Kejaq taq ajowab'äl
        }
    .accesskey =
        { PLATFORM() ->
            [windows] K
           *[other] K
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } majun chik rupam nikanaj kan pa rujolom. Rik'in jub'a' man ütz ta yek'ut pe ri rupam Ajk'amaya'l ruxaq. Yatikïr ye'ayüj el ri taq tzij eyakon pa Taq Cha'oj > Ichinanem & Jikomal > Taq Kaxlanwey chuqa' Rutzij Ruxaq K'amaya'l.
       *[other] { -brand-short-name } majun chik rupam nikanaj kan pa rujolom. Rik'in jub'a' man ütz ta yek'ut pe ri rupam Ajk'amaya'l ruxaq. Yatikïr ye'ayüj el ri taq tzij eyakon pa Taq Ajowab'äl > Ichinanem & Jikomal > Taq Kaxlanwey chuqa' Rutzij Ruxaq K'amaya'l.
    }
space-alert-under-5gb-ok-button =
    .label = ÜTZ, Wetaman chik
    .accesskey = T
space-alert-under-5gb-message = { -brand-short-name } tajin majun rupam nikanaj kan pa rujolom. Rik'in jub'a' man ütz ta nik'ut pe ri rupam ruxaq k'amaya'l. Tab'etz'eta' “Tetamäx ch'aqa' chik” richin nutziläx toq nokisäx rujolom richin tik'asäs nawokisaj awetamab'al rik'in ri okem pa k'amaya'l.

## Privacy Section - HTTPS-Only

httpsonly-header = HTTPS-Only B'anikil
httpsonly-description = Ri HTTPS nuya' jun jikïl chuqa' ewäl rusik'ixik okem chi kikojol ri { -brand-short-name } chuqa' ri ajk'amaya'l taq ruxaq ye'atz'ët. B'ama konojel ri ajk'amaya'l taq ruxaq yekik'ül ri HTTPS, chuqa' we tzijïl ri HTTPS-Only b'anikil, ri { -brand-short-name } xkeruk'ëx konojel ri taq okem pa HTTPS.
httpsonly-learn-more = Tetamäx ch'aqa' chik
httpsonly-radio-enabled =
    .label = Titzij HTTPS-Only B'anikil chi jun taq tzuwäch
httpsonly-radio-enabled-pbm =
    .label = Titzij HTTPS-Only B'anikil xa xe pa jun ichinan taq tzuwäch
httpsonly-radio-disabled =
    .label = Man titzij HTTPS-Only B'anikil

## The following strings are used in the Download section of settings

desktop-folder-name = Kematz'ib'ab'äl
downloads-folder-name = Taq qasanïk
choose-download-folder-title = Ticha' yakwuj, ri xkeruyäk taq qasanïk:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Keyak taq yakb'äl pa { $service-name }
