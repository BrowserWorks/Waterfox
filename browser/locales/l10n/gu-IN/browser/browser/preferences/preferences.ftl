# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = વેબસાઇટ્સને "ટ્રેક ન કરો" સિગ્નલ મોકલો કે જેને તમે ટ્રૅક કરી ન શકો
do-not-track-learn-more = વધુ શીખો
do-not-track-option-default-content-blocking-known =
    .label = જ્યારે { -brand-short-name } જાણીતા ટ્રૅકર્સને અવરોધિત કરવા માટે સેટ કરવામાં આવે છે ત્યારે જ
do-not-track-option-always =
    .label = હંમેશા

pref-page-title =
    { PLATFORM() ->
        [windows] વિકલ્પો
       *[other] પસંદગીઓ
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
            [windows] વિકલ્પોમાં શોધો
           *[other] પસંદગીઓમાં શોધો
        }

pane-general-title = સામાન્ય
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = મુખ્ય
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = શોધ
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = ગોપનીયતા & સુરક્ષા
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }

help-button-label = { -brand-short-name } આધાર
addons-button-label = એક્સ્ટેન્શન્સ અને થીમ્સ

focus-search =
    .key = f

close-button =
    .aria-label = બંધ કરો

## Browser Restart Dialog

feature-enable-requires-restart = આ લક્ષણને સક્રિય કરવા માટે { -brand-short-name } ને પુન:શરૂ કરવુ જ જોઇએ.
feature-disable-requires-restart = આ લક્ષણને નિષ્ક્રિય કરવા માટે { -brand-short-name } ને પુન:શરૂ કરવુ જ જોઇએ.
should-restart-title = પુનઃશરૂ કરો { -brand-short-name }
should-restart-ok = હવે { -brand-short-name } પુનઃપ્રારંભ કરો
cancel-no-restart-button = રદ કરો
restart-later = પછી પુનઃશરૂ કરો

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
extension-controlled-homepage-override = એક એક્સ્ટેન્શન, <img data-l10n-name="icon"/> { $name }, તમારા મુખ્ય પેજને નિયંત્રિત કરી રહ્યું છે.

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = એક એક્સટેન્શન, <img data-l10n-name="icon"/> { $name }, તમારા નવા ટેબના પૃષ્ઠને નિયંત્રિત કરે છે.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = એક એક્સ્ટેંશન, <img data-l10n-name="icon"/> { $name }, આ સેટિંગને નિયંત્રિત કરી રહ્યું છે.

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = એક્સ્ટેંશન, <img data-l10n-name="icon"/> { $name }, એ તમારું મૂળભૂત શોધ એંજીન સેટ કર્યું છે.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = એક્સ્ટેંશન, <img data-l10n-name="icon"/> { $name }, કન્ટેઈનર ટેબ્સની જરૂર છે.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = એક્સ્ટેન્શન, <img data-l10n-name="icon"/>{ $name }, આ સેટિંગને નિયંત્રિત કરી રહ્યું છે.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = એક એક્સ્ટેન્શન, <img data-l10n-name="icon"/> { $name }, નિયંત્રિત કરી રહ્યું છે કે { -brand-short-name } કેવી રીતે ઇન્ટરનેટ સાથે જોડાય છે.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = <img data-l10n-name="menu-icon"/> મેનૂમાં એક્સટેંશન <img data-l10n-name="addons-icon"/> ઍડ-ઑન્સ પર જવા માટે સક્ષમ કરવા.

## Preferences UI Search Results

search-results-header = શોધ પરિણામ

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] માફ કરશો! “<span data-l10n-name="query"></span>” માટેનાં વિકલ્પોમાં કોઈ પરિણામો નથી.
       *[other] માફ કરશો! “<span data-l10n-name="query"></span>”માટે પસંદગીઓમાં કોઈ પરિણામો નથી.
    }

search-results-help-link = મદદ જોઈઅે છે? <a data-l10n-name="url">{ -brand-short-name } સમર્થન</a> ની મુલાકાત લો

## General Section

startup-header = શરૂઆત

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = પરવાનગી આપો { -brand-short-name } અને તે જ સમયે Firefox ને ચલાવવા માટે
use-firefox-sync = છૂપી સૂચના: આ અલગ પ્રોફાઇલ્સનો ઉપયોગ કરે છે. તેમની વચ્ચે ડેટા શેર કરવા માટે { -sync-brand-short-name } નો ઉપયોગ કરો.
get-started-not-logged-in = સાઇન ઇન કરો { -sync-brand-short-name }…
get-started-configured = ખોલો કરો { -sync-brand-short-name } પસંદગીઓ

always-check-default =
    .label = હંમેશાં તપાસો કે { -brand-short-name } તમારું મૂળભૂત બ્રાઉઝર છે
    .accesskey = y

is-default = { -brand-short-name } હાલમાં તમારું મૂળભૂત બ્રાઉઝર છે
is-not-default = { -brand-short-name } તમારું મૂળભૂત બ્રાઉઝર નથી

set-as-my-default-browser =
    .label = ડિફૉલ્ટ બનાવો…
    .accesskey = D

startup-restore-previous-session =
    .label = પહેલાનાં સત્રને પુન:સંગ્રહો
    .accesskey = s

startup-restore-warn-on-quit =
    .label = બ્રાઉઝર છોડતી વખતે તમને ચેતવણી આપે છે.

disable-extension =
    .label = એક્સ્ટેંશન અક્ષમ કરો

tabs-group-header = ટૅબ્સ

ctrl-tab-recently-used-order =
    .label = તાજેતરમાં ઉપયોગમાં લેવાયેલી ક્રમમાં ટેબ દ્વારા Ctrl+Tab ચક્ર
    .accesskey = T

open-new-link-as-tabs =
    .label = નવા વિન્ડોઝને બદલે ટૅબ્સ તરીકે લિંક્સ ખોલો
    .accesskey = w

warn-on-close-multiple-tabs =
    .label = તમને બહુવિધ ટેબ્સ બંધ કરતી વખતે ચેતવશે
    .accesskey = m

warn-on-open-many-tabs =
    .label = તમને ચેતવે છે જ્યારે ઘણી ટેબ્સ ખોલવાનું ધીમું થઈ જાય અને { -brand-short-name }
    .accesskey = d

switch-links-to-new-tabs =
    .label = જ્યારે તમે કોઈ નવી ટેબમાં લિંક ખોલો છો, ત્યારે તેને તરત જ સ્વિચ કરો
    .accesskey = h

show-tabs-in-taskbar =
    .label = વિન્ડોઝ કાર્યપટ્ટીમાં ટૅબ પૂર્વદર્શનનો બતાવો
    .accesskey = k

browser-containers-enabled =
    .label = કન્ટેઈનર ટેબ્સ સક્ષમ કરો
    .accesskey = n

browser-containers-learn-more = વધુ શીખો

browser-containers-settings =
    .label = સેટીંગ…
    .accesskey = i

containers-disable-alert-title = બધા કન્ટેઈનર ટૅબ્સ બંધ કરીએ?
containers-disable-alert-desc =
    { $tabCount ->
        [one] જો તમે હવે કન્ટેઈનર ટૅબ્સ અક્ષમ કરો છો, તો { $tabCount } કન્ટેનર ટેબ બંધ કરવામાં આવશે. શું તમે ખરેખર કન્ટેઈનર ટેબ્સને અક્ષમ કરવા માંગો છો?
       *[other] જો તમે હવે કન્ટેઈનર ટૅબને અક્ષમ કરો છો, તો { $tabCount } કન્ટેનર ટેબ્સ બંધ થઈ જશે. શું તમે ખરેખર કન્ટેઈનર ટેબ્સને અક્ષમ કરવા માંગો છો?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } કન્ટેઈનર ટૅબને બંધ કરો
       *[other] { $tabCount } કન્ટેનર ટૅબ્સને બંધ કરો
    }
containers-disable-alert-cancel-button = સક્ષમ રાખો

containers-remove-alert-title = આ કન્ટેઈનર દૂર કરીએ?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] જો તમે આ કન્ટેઈનરને હમણા દૂર કરો છો, તો { $count } કન્ટેનર ટેબ બંધ થઈ જશે. શું તમે ખરેખર આ કન્ટેઈનરને દૂર કરવા માંગો છો?
       *[other] જો તમે આ કન્ટેઈનરને દૂર કરો છો, તો { $count } કન્ટેનર ટેબ્સ બંધ થઈ જશે. શું તમે ખરેખર આ કન્ટેઈનરને દૂર કરવા માંગો છો?
    }

containers-remove-ok-button = આ કન્ટેઈનર દૂર કરો
containers-remove-cancel-button = આ કન્ટેઈનરને દૂર કરશો નહીં


## General Section - Language & Appearance

language-and-appearance-header = ભાષા અને દેખાવ

fonts-and-colors-header = ફોન્ટ & રંગો

default-font = મૂળભૂત ફોન્ટ
    .accesskey = D
default-font-size = માપ
    .accesskey = S

advanced-fonts =
    .label = અદ્યતન...
    .accesskey = A

colors-settings =
    .label = રંગો...
    .accesskey = C

language-header = ભાષા

choose-language-description = પાનાંઓ દર્શાવવા માટે તમારી પ્રાધાન્યવાળી ભાષા પસંદ કરો

choose-button =
    .label = પસંદ કરો...
    .accesskey = o

choose-browser-language-description = { -brand-short-name } માંથી મેનુઓ, સંદેશાઓ અને સૂચનાઓ પ્રદર્શિત કરવા માટે ઉપયોગમાં લેવાતા ભાષાઓને પસંદ કરો.
manage-browser-languages-button =
    .label = વિકલ્પો સેટ કરો ...
    .accesskey = I
confirm-browser-language-change-description = આ ફેરફારોને લાગુ કરવા માટે { -brand-short-name } પુનઃપ્રારંભ કરો
confirm-browser-language-change-button = લાગુ કરો અને પુનઃપ્રારંભ કરો

translate-web-pages =
    .label = વેબ સમાવિષ્ટ અનુવાદ કરો
    .accesskey = T

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = નાં વડે અનુવાદ <img data-l10n-name="logo"/>

translate-exceptions =
    .label = અપવાદ…
    .accesskey = x

check-user-spelling =
    .label = તમે લખો તે મુજબ તમારી જોડણી તપાસો
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = ફાઇલો અને એપ્લિકેશન્સ

download-header = ડાઉનલોડ

download-save-to =
    .label = ફાઈલોને આમાં સંગ્રહો
    .accesskey = v

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] પસંદ કરો...
           *[other] બ્રાઉઝ કરો...
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }

download-always-ask-where =
    .label = હંમેશાં તમને પૂછે છે કે ફાઇલો ક્યાં સાચવવી
    .accesskey = A

applications-header = એપ્લિકેશન્સ

applications-description = કેવી રીતે { -brand-short-name } પસંદ કરો; વેબ પરથી તમે ડાઉનલોડ કરેલી ફાઇલો અથવા બ્રાઉઝિંગ કરતી વખતે ઉપયોગમાં લેવાતી એપ્લિકેશનોનું સંચાલન કરે છે.

applications-filter =
    .placeholder = ફાઇલ પ્રકારો અથવા એપ્લિકેશન્સ શોધો

applications-type-column =
    .label = સામગ્રી પ્રકાર
    .accesskey = T

applications-action-column =
    .label = ક્રિયા
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } ફાઈલ
applications-action-save =
    .label = ફાઈલ સંગ્રહો

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } વાપરો

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } વાપરો (મૂળભૂત)

applications-use-other =
    .label = અન્ય વાપરો…
applications-select-helper = મદદગાર કાર્યક્રમ પસંદ કરો

applications-manage-app =
    .label = કાર્યક્રમ વિગતો…
applications-always-ask =
    .label = હંમેશા પૂછો
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
    .label = { $plugin-name } વાપરો ({ -brand-short-name } માં)

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

drm-content-header = ડિજિટલ અધિકાર સંચાલન (DRM) કન્ટેન્ટ

play-drm-content =
    .label = DRM-નિયંત્રિત સામગ્રીને ચાલુ કરો
    .accesskey = P

play-drm-content-learn-more = વધુ શીખો

update-application-title = { -brand-short-name } સુધારો

update-application-description = શ્રેષ્ઠ પ્રદર્શન, સ્થિરતા અને સુરક્ષા માટે { -brand-short-name } અધતન રાખો.

update-application-version = આવૃત્તિ { $version } <a data-l10n-name="learn-more">નવું શું છે</a>

update-history =
    .label = અપડેટ ઇતિહાસ બતાવો…
    .accesskey = P

update-application-allow-description = મંજૂરી આપો { -brand-short-name } માટે

update-application-auto =
    .label = આપમેળે સુધારા ઇન્સ્ટોલ કરો (ભલામણ કરેલ)
    .accesskey = A

update-application-check-choose =
    .label = સુધારાઓ માટે ચકાસો પરંતુ તમે તેમને સ્થાપિત કરવા માટે પસંદ કરી દો
    .accesskey = C

update-application-manual =
    .label = અપડેટ્સ માટે ક્યારેય તપાસ કરશો નહીં (આગ્રહણીય નથી)
    .accesskey = N

update-application-use-service =
    .label = સુધારાઓ સ્થાપિત કરવા માટે પાશ્વભાગ સેવા વાપરો
    .accesskey = b

## General Section - Performance

performance-title = કામગીરી

performance-use-recommended-settings-checkbox =
    .label = આગ્રહણીય પ્રદર્શન સેટિંગ્સનો ઉપયોગ કરો
    .accesskey = U

performance-use-recommended-settings-desc = આ સેટિંગ્સ તમારા કમ્પ્યુટરનાં હાર્ડવેર અને ઑપરેટિંગ સિસ્ટમ અનુસાર બનાવાય છે.

performance-settings-learn-more = વધુ શીખો

performance-allow-hw-accel =
    .label = હાર્ડવેર વેગને વાપરો જ્યારે ઉપલબ્ધ હોય
    .accesskey = r

performance-limit-content-process-option = સામગ્રી પ્રક્રિયા મર્યાદા
    .accesskey = L

performance-limit-content-process-enabled-desc = બહુવિધ ટૅબ્સનો ઉપયોગ કરતી વખતે વધારાની સામગ્રી પ્રક્રિયાઓ પ્રભાવ સુધારી શકે છે, પરંતુ તે વધુ મેમરીનો પણ ઉપયોગ કરશે.
performance-limit-content-process-blocked-desc = મલ્ટિપ્રોસેસ સાથે સામગ્રી પ્રોસેસની સંખ્યામાં ફેરફાર કરવો શક્ય છે { -brand-short-name }. <a data-l10n-name="learn-more">મલ્ટિપ્રોસેસ સક્રિય કરે છે કે નહીં તે કેવી રીતે તપાસવું તે જાણો</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (મૂળભૂત)

## General Section - Browsing

browsing-title = બ્રાઉઝીંગ

browsing-use-autoscroll =
    .label = આપોઆપ સરકાવવાનું વાપરો
    .accesskey = a

browsing-use-smooth-scrolling =
    .label = લીસી રીતે સરકાવવાનું વાપરો
    .accesskey = m

browsing-use-onscreen-keyboard =
    .label = જ્યારે જરૂરી હોય ત્યારે ટચ કીબોર્ડ બતાવો
    .accesskey = k

browsing-use-cursor-navigation =
    .label = પાનાંઓમાં શોધખોળ કરવા માટે હંમેશા કર્સર કીઓ વાપરો
    .accesskey = c

browsing-search-on-start-typing =
    .label = જ્યારે તમે ટાઇપ કરવાનું શરૂ કરો ત્યારે ટેક્સ્ટ માટે શોધો
    .accesskey = x

browsing-cfr-recommendations =
    .label = તમે બ્રાઉઝ કરો ત્યારે એક્સ્ટેન્શન્સની ભલામણ કરો
    .accesskey = R

browsing-cfr-recommendations-learn-more = વધુ શીખો

## General Section - Proxy

network-settings-title = નેટવર્ક સેટિંગ્સ

network-proxy-connection-description = કેવી રીતે { -brand-short-name } ઇન્ટરનેટ સાથે જોડાય છે તે ગોઠવો.

network-proxy-connection-learn-more = વધુ શીખો

network-proxy-connection-settings =
    .label = સેટીંગ...
    .accesskey = e

## Home Section

home-new-windows-tabs-header = નવી વિન્ડો અને ટૅબ્સ

home-new-windows-tabs-description2 = જ્યારે તમે તમારું હોમપેજ, નવી વિંડોઝ અને નવી ટેબ્સ ખોલો છો ત્યારે તમે શું જુઓ છો તે પસંદ કરો.

## Home Section - Home Page Customization

home-homepage-mode-label = મુખ્ય પૃષ્ઠ અને નવી વિંડોઝ

home-newtabs-mode-label = નવી ટૅબ્સ

home-restore-defaults =
    .label = મૂળભૂતને પુન:સંગ્રહો
    .accesskey = R

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox મુખ્ય (મૂળભૂત)

home-mode-choice-custom =
    .label = પોતાના URLs...

home-mode-choice-blank =
    .label = ખાલી પાનું

home-homepage-custom-url =
    .placeholder = એક URL પેસ્ટ કરો...

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] વર્તમાન પાનું વાપરો
           *[other] વર્તમાન પાનાંઓ વાપરો
        }
    .accesskey = C

choose-bookmark =
    .label = બુકમાર્ક વાપરો…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Firefox મુખ્ય સામગ્રી
home-prefs-content-description = તમારી Firefox મુખ્ય સ્ક્રીન પર કઈ સામગ્રી તમે ઇચ્છો તે પસંદ કરો.

home-prefs-search-header =
    .label = વેબ શોધ
home-prefs-topsites-header =
    .label = ટોચની સાઇટ્સ
home-prefs-topsites-description = તમે સૌથી વધુ મુલાકાત લો છો તે સાઇટ્સ

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = { $provider } દ્વારા ભલામણ
##

home-prefs-recommended-by-learn-more = તે કેવી રીતે કામ કરે છે
home-prefs-recommended-by-option-sponsored-stories =
    .label = પ્રાયોજિત વાર્તાઓ

home-prefs-highlights-header =
    .label = વીતી ગયેલું
home-prefs-highlights-description = સાઇટ્સની પસંદગી કે જે તમે સાચવી અથવા મુલાકાત લીધી છે
home-prefs-highlights-option-visited-pages =
    .label = મુલાકાત લીધેલા પૃષ્ઠો
home-prefs-highlights-options-bookmarks =
    .label = બુકમાર્ક્સ
home-prefs-highlights-option-most-recent-download =
    .label = સૌથી તાજેતરની ડાઉનલોડ
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name } પર સાચવેલ પૃષ્ઠો

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = જાણકારી આપનારા ઉતારા ક કાપલીઓ
home-prefs-snippets-description = { -vendor-short-name } અને { -brand-product-name } તરફથી અપડેટ્સ
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } પંક્તિ
           *[other] { $num } પંક્તિઓ
        }

## Search Section

search-bar-header = શોધ બાર
search-bar-hidden =
    .label = શોધ અને સંશોધક માટે સરનામાં બારનો ઉપયોગ કરો
search-bar-shown =
    .label = ટૂલબારમાં શોધ બાર ઉમેરો

search-engine-default-header = મૂળભૂત શોધ એંજીન

search-suggestions-option =
    .label = શોધ સૂચનો પૂરા પાડો
    .accesskey = s

search-show-suggestions-url-bar-option =
    .label = સરનામાં બાર પરિણામોમાં શોધ સૂચનો બતાવો
    .accesskey = I

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = સરનામાં બાર પરિણામોમાં બ્રાઉઝિંગ ઇતિહાસની આગળ શોધ સૂચનો બતાવો

search-suggestions-cant-show = શોધ સૂચનો સ્થાન બાર પરિણામોમાં બતાવવામાં આવશે નહીં કારણ કે તમે { -brand-short-name } ઇતિહાસ ક્યારેય યાદ નથી

search-one-click-header = શોધ એન્જિન્સ વન-ક્લિક કરો

search-one-click-desc = વૈકલ્પિક શોધ એંજીન્સ પસંદ કરો જે સરનામાં બાર અને શોધ બાર નીચે દેખાય છે જ્યારે તમે કોઈ કીવર્ડ દાખલ કરવાનું શરૂ કરો છો.

search-choose-engine-column =
    .label = શોધ એન્જિન
search-choose-keyword-column =
    .label = મુખ્ય શબ્દ

search-restore-default =
    .label = મૂળભૂત શોધ એંજીન તરીકે પુનઃસંગ્રહો
    .accesskey = d

search-remove-engine =
    .label = દૂર કરો
    .accesskey = r

search-find-more-link = વધુ શોધ યંત્ર શોધો

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = નકલી મુખ્ય શબ્દ
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = તમે પસંદ કરેલ મુખ્ય શબ્દ વર્તમાનમાં "{ $name }" દ્વારા વપરાશમાં છે. મહેરબાની કરીને અન્ય પસંદ કરો.
search-keyword-warning-bookmark = તમે પસંદ કરેલ મુખ્ય શબ્દ વર્તમાનમાં બુકમાર્ક દ્વારા વપરાશમાં છે. મહેરબાની કરીને અન્ય પસંદ કરો.

## Containers Section

containers-header = કન્ટેઈનર ટેબ્સ
containers-add-button =
    .label = નવું કન્ટેઈનર ઉમેરો
    .accesskey = A

containers-preferences-button =
    .label = પસંદગીઓ
containers-remove-button =
    .label = દૂર કરો

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = તમારું વેબ તમારી સાથે રાખો
sync-signedout-description = તમારા બધા ઉપકરણો પર તમારા બુકમાર્ક્સ, ઇતિહાસ, ટૅબ્સ, પાસવર્ડ્સ, ઍડ-ઑન્સ અને પસંદગીઓને સમન્વયિત કરો.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = ડાઉનલોડ કરો Firefox માટે <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> અથવા <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> તમારા મોબાઇલ ઉપકરણ સાથે સમન્વયિત કરવા માટે.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = પ્રોફાઇલ ચિત્ર બદલો

sync-manage-account = ખાતાને સંચાલિત કરો
    .accesskey = o

sync-signedin-unverified = { $email } ચકાસેલ નથી.
sync-signedin-login-failure = મહેરબાની કરીને ફરી જોડાણ માટે પ્રવેશો { $email }

sync-resend-verification =
    .label = ચકાસણી ફરી મોકલો
    .accesskey = d

sync-remove-account =
    .label = એકાઉન્ટ કાઢો
    .accesskey = R

sync-sign-in =
    .label = સાઇન ઇન કરો
    .accesskey = g

## Sync section - enabling or disabling sync.


## The list of things currently syncing.


## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = બુકમાર્ક્સ
    .accesskey = m

sync-engine-history =
    .label = ઇતિહાસ
    .accesskey = r

sync-engine-tabs =
    .label = ટૅબ્સ ખોલો
    .tooltiptext = બધા સમન્વયિત ઉપકરણો પર શું ખુલ્લું છે તેની સૂચિ
    .accesskey = T

sync-engine-addresses =
    .label = સરનામાઓ
    .tooltiptext = તમે સાચવેલા પોસ્ટલ સરનામા (ફક્ત ડેસ્કટૉપ)
    .accesskey = e

sync-engine-creditcards =
    .label = ક્રડિટ કાર્ડ્ઝ
    .tooltiptext = નામ, નંબર અને સમાપ્તિની તારીખ (ફક્ત ડેસ્કટૉપ)
    .accesskey = C

sync-engine-addons =
    .label = ઍડ-ઓન
    .tooltiptext = Firefox ડેસ્કટૉપ માટે વિસ્તરક અને થીમ્સ
    .accesskey = A

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] વિકલ્પો
           *[other] પસંદગીઓ
        }
    .tooltiptext = સામાન્ય, ગોપનીયતા અને સુરક્ષા સેટિંગ્સ જે તમે બદલ્યાં છે
    .accesskey = s

## The device name controls.

sync-device-name-header = ઉપકરણનું નામ

sync-device-name-change =
    .label = ઉપકરણ નામ બદલો…
    .accesskey = h

sync-device-name-cancel =
    .label = રદ કરો
    .accesskey = n

sync-device-name-save =
    .label = સંગ્રહો
    .accesskey = v

sync-connect-another-device = બીજા ઉપકરણ સાથે જોડાણ કરો

## Privacy Section

privacy-header = બ્રાઉઝર ગોપનીયતા

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = લૉગ-ઇન્સ અને પાસવર્ડ્સ
    .searchkeywords = { -lockwise-brand-short-name }

forms-ask-to-save-logins =
    .label = વેબસાઇટ્સ માટે લૉગિન અને પાસવર્ડ્સ સાચવવા માટે પૂછો
    .accesskey = r
forms-exceptions =
    .label = અપવાદો...
    .accesskey = x

forms-saved-logins =
    .label = સાચવેલા લૉગિન્સ…
    .accesskey = L
forms-master-pw-use =
    .label = મુખ્ય પાસવર્ડ વાપરો
    .accesskey = U
forms-master-pw-change =
    .label = મુખ્ય પાસવર્ડ બદલો...
    .accesskey = M

forms-master-pw-fips-title = તમે હાલમાં FIPS સ્થિતિમાં છો. FIPS માટે ખાલી-નહિં એવો મુખ્ય પાસવર્ડ જરૂરી છે.

forms-master-pw-fips-desc = પાસવર્ડ બદલવાનું નિષ્ફળ

## OS Authentication dialog


## Privacy Section - History

history-header = ઇતિહાસ

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } કરશે
    .accesskey = w

history-remember-option-all =
    .label = ઇતિહાસ યાદ રાખો
history-remember-option-never =
    .label = ક્યારેય ઇતિહાસ યાદ રાખશો નહિં
history-remember-option-custom =
    .label = ઇતિહાસ માટે વૈવિધ્યપૂર્ણ સેટીંગ વાપરો

history-remember-description = { -brand-short-name } તમારી બ્રાઉઝિંગ, ડાઉનલોડ, ફોર્મ અને શોધ ઇતિહાસ યાદ રાખશે.
history-dontremember-description = { -brand-short-name } ખાનગી બ્રાઉઝીંગની જેમ જ સેટીંગ વાપરશે, અને તમે જેમ વેબ બ્રાઉઝ કરો તેમ ઇતિહાસ યાદ રાખશે નહિં.

history-private-browsing-permanent =
    .label = હંમેશા ખાનગી બ્રાઉઝીંગ સ્થિતિ વાપરો
    .accesskey = p

history-remember-browser-option =
    .label = બ્રાઉઝીંગ અને ડાઉનલોડ ઇતિહાસને યાદ રાખો
    .accesskey = b

history-remember-search-option =
    .label = શોધ અને ફોર્મ ઇતિહાસ યાદ રાખો
    .accesskey = f

history-clear-on-close-option =
    .label = જ્યારે { -brand-short-name } બંધ થાય ત્યારે ઇતિહાસ સાફ કરો
    .accesskey = r

history-clear-on-close-settings =
    .label = સેટીંગ…
    .accesskey = t

history-clear-button =
    .label = ઇતિહાસ સાફ કરો…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = કૂકીઝ અને સાઈટ ડેટા

sitedata-total-size-calculating = સાઇટ ડેટા અને કેશ કદની ગણતરી કરી રહ્યું છે…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = તમારી સંગ્રહિત કૂકીઝ, સાઇટ ડેટા અને કેશ હાલમાં { $value } { $unit } જગ્યા નો ઉપયોગ કરી રહ્યાં છે.

sitedata-learn-more = વધુ શીખો

sitedata-delete-on-close =
    .label = { -brand-short-name } બંધ હોય ત્યારે કૂકીઝ અને સાઇટ માહિતી કાઢી નાખો
    .accesskey = c

sitedata-allow-cookies-option =
    .label = કૂકીઝ અને સાઇટ ડેટાને સ્વીકારો
    .accesskey = A

sitedata-disallow-cookies-option =
    .label = કૂકીઝ અને સાઇટ ડેટાને અવરોધિત કરો
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = પ્રકાર અવરોધિત
    .accesskey = T

sitedata-option-block-unvisited =
    .label = નાજોયેલી વેબસાઈટની કૂકીઝ
sitedata-option-block-all-third-party =
    .label = બધી તૃતીય-પક્ષ કૂકીઝ (વેબસાઇટ્સ ને રોકી શકે છે)
sitedata-option-block-all =
    .label = બધી કૂકીઝ (વેબસાઇટ્સને ને રોકી નાખશે)

sitedata-clear =
    .label = માહિતી સાફ કરો…
    .accesskey = l

sitedata-settings =
    .label = ડેટા સંચાલન કરો…
    .accesskey = M

sitedata-cookies-permissions =
    .label = પરવાનગીઓ મેનેજ કરો...
    .accesskey = P

## Privacy Section - Address Bar

addressbar-header = સરનામા પટ્ટી

addressbar-suggest = સરનામાં બારનો ઉપયોગ કરતી વખતે, સૂચન કરો

addressbar-locbar-history-option =
    .label = બ્રાઉઝિંગ ઇતિહાસ
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = બુકમાર્કો
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = ટૅબ્સ ખોલો
    .accesskey = O

addressbar-suggestions-settings = શોધ એન્જિન સૂચનો માટે પસંદગીઓ બદલો

## Privacy Section - Content Blocking

content-blocking-learn-more = વધુ શીખો

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = પ્રમાણભૂત
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = સખત
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = વૈવિધ્યપૂર્ણ
    .accesskey = C

##

content-blocking-all-cookies = બધી કૂકીઝ
content-blocking-all-third-party-cookies = બધા તૃતીય પક્ષ કૂકીઝ

content-blocking-warning-title = હેડ્સ અપ!

content-blocking-reload-tabs-button =
    .label = બધા ટૅબ્સ ફરીથી લોડ કરો
    .accesskey = R

content-blocking-tracking-protection-option-all-windows =
    .label = બધા વિન્ડોઝમા માં
    .accesskey = A
content-blocking-option-private =
    .label = ફક્ત ખાનગી વિન્ડોઝમા
    .accesskey = P
content-blocking-tracking-protection-change-block-list = અવરોધ સૂચિ બદલો

content-blocking-cookies-label =
    .label = કૂકીઝ
    .accesskey = C

content-blocking-expand-section =
    .tooltiptext = વધુ માહિતી

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
    .label = અપવાદોને મેનેજ કરો ...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = પરવાનગીઓ

permissions-location = સ્થાન
permissions-location-settings =
    .label = સેટિંગ્સ…
    .accesskey = t

permissions-camera = કેમેરા
permissions-camera-settings =
    .label = સેટીંગ…
    .accesskey = t

permissions-microphone = માઇક્રોફોન
permissions-microphone-settings =
    .label = સેટીંગ…
    .accesskey = t

permissions-notification = સૂચનાઓ
permissions-notification-settings =
    .label = સેટિંગ્સ…
    .accesskey = t
permissions-notification-link = વધુ શીખો

permissions-notification-pause =
    .label = { -brand-short-name } પુનઃપ્રારંભે ત્યા સુધી સૂચનાઓ થોભાવો
    .accesskey = n

permissions-block-popups =
    .label = પોપ-અપ વિન્ડો અટકાવો
    .accesskey = B

permissions-block-popups-exceptions =
    .label = અપવાદો...
    .accesskey = E

permissions-addon-install-warning =
    .label = તમને ચેતવે છે જ્યારે વેબસાઇટ્સ ઍડ-ઑન્સ ઇન્સ્ટોલ કરવાનો પ્રયાસ કરે છે
    .accesskey = W

permissions-addon-exceptions =
    .label = અપવાદો...
    .accesskey = E

permissions-a11y-privacy-checkbox =
    .label = ઍક્સેસિબિલિટી સેવાઓને તમારા બ્રાઉઝરને ઍક્સેસ કરવાથી અટકાવો
    .accesskey = a

permissions-a11y-privacy-link = વધુ શીખો

## Privacy Section - Data Collection

collection-header = { -brand-short-name } ડેટા સંગ્રહ અને ઉપયોગ

collection-description = અમે તમને પસંદગીઓ સાથે પ્રદાન કરવાનો પ્રયત્ન કરીએ છીએ અને દરેક માટે શું પ્રદાન અને સુધારવાની જરૂર છે તે જ { -brand-short-name } એકત્રિત કરીએ છીએ. અમે હંમેશા વ્યક્તિગત માહિતી મેળવવા પહેલાં પરવાનગી પૂછીશુ.
collection-privacy-notice = ગોપનીયતા સૂચના

collection-health-report =
    .label = { -brand-short-name } ને મંજૂરી આપો { -vendor-short-name } ને ટેક્નિકલ અને ક્રિયાપ્રતિક્રિયા ડેટા મોકલવા માટે.
    .accesskey = r
collection-health-report-link = વધુ શીખો

collection-studies =
    .label = { -brand-short-name } અભ્યાસને ઇન્સ્ટોલ અને ચલાવવાની મંજૂરી આપો
collection-studies-link = { -brand-short-name } અભ્યાસો જુઓ

addon-recommendations =
    .label = વ્યક્તિગત કરેલી એક્સ્ટેંશન ભલામણોને બનાવવા માટે { -brand-short-name } ને મંજૂરી આપો
addon-recommendations-link = વધુ શીખો

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = આ તૈચાર કરેલ રૂપરેખાંકન માટે ડેટા અહેવાલ અક્ષમ કરેલું છે

collection-backlogged-crash-reports =
    .label = તમારા વતી { -brand-short-name } ને બૅકલોગ ક્રેશ રિપોર્ટ્સ મોકલવાની મંજૂરી આપો
    .accesskey = c
collection-backlogged-crash-reports-link = વધુ શીખો

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = સુરક્ષા

security-browsing-protection = ભ્રામક સામગ્રી અને ડેન્જરસ સોફ્ટવેર પ્રોટેક્શન

security-enable-safe-browsing =
    .label = ખતરનાક અને ભ્રામક સામગ્રીને અવરોધિત કરો
    .accesskey = B
security-enable-safe-browsing-link = વધુ શીખો

security-block-downloads =
    .label = ખતરનાક ડાઉનલોડ્સ ને અવરોધિત કરો
    .accesskey = D

security-block-uncommon-software =
    .label = અનિચ્છનીય અને અસામાન્ય સૉફ્ટવેર વિશે તમને ચેતવે છે
    .accesskey = C

## Privacy Section - Certificates

certs-header = પ્રમાણપત્રો

certs-personal-label = સર્વર તમારી વ્યક્તિગત પ્રમાણપત્રની વિનંતી કરે ત્યારે

certs-select-auto-option =
    .label = એક આપોઆપ પસંદ કરો
    .accesskey = S

certs-select-ask-option =
    .label = દર વખતે તમને પૂછો
    .accesskey = A

certs-enable-ocsp =
    .label = પ્રમાણપત્રની હાલની યોગ્યતાની ખાતરી કરવા માટે ક્વેરી OCSP જવાબ સર્વરો
    .accesskey = Q

certs-view =
    .label = પ્રમાણપત્રો જુઓ…
    .accesskey = C

certs-devices =
    .label = સુરક્ષા ઉપકરણો…
    .accesskey = D

space-alert-learn-more-button =
    .label = વધુ શીખો
    .accesskey = L

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] વિકલ્પો ખોલો
           *[other] પસંદગીઓને ખોલો
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }

space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } ડિસ્ક જગ્યામાંથી બહાર ચાલી રહ્યું છે. વેબસાઈટની વિષયવસ્તુ કદાચ યોગ્ય રીતે દર્શાશે નહીં. તમે સંગ્રહિત સાઇટ ડેટાને સાફ કરી શકો છો વિકલ્પો > ગોપનીયતા અને સુરક્ષા > કૂકીઝ અને સાઈટ ડેટા.
       *[other] { -brand-short-name } ડિસ્ક જગ્યામાંથી બહાર ચાલી રહ્યું છે. વેબસાઈટની વિષયવસ્તુ કદાચ યોગ્ય રીતે દર્શાશે નહીં. તમે સંગ્રહિત સાઇટ ડેટાને સાફ કરી શકો છો પસંદગીઓ > ગોપનીયતા અને સુરક્ષા > કૂકીઝ અને સાઈટ ડેટા.
    }

space-alert-under-5gb-ok-button =
    .label = OK, સમજાઇ ગયું
    .accesskey = K

space-alert-under-5gb-message = { -brand-short-name } ડિસ્ક જગ્યામાંથી બહાર ચાલી રહ્યું છે. વેબસાઈટ વિષયવસ્તુ કદાચ યોગ્ય રીતે દર્શાશે નહીં. સારી બ્રાઉઝિંગ અનુભવ માટે તમારા ડિસ્કનો ઉપયોગ ઑપ્ટિમાઇઝ કરવા "વધુ જાણો" ની મુલાકાત લો.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = ડેસ્કટોપ
downloads-folder-name = ડાઉનલોડ
choose-download-folder-title = ડાઉનલોડ ફોલ્ડર પસંદ કરો:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = { $service-name } પર ફાઇલો સાચવો
