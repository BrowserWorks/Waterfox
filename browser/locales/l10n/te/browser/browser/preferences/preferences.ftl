# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = నా జాడ అనుసరించవద్దని ఆశిస్తున్నానని వెబ్‌సైట్లకు తెలిసేలా “ట్రాక్ చెయ్యవద్దు” అనే సూచనను పంపించు
do-not-track-learn-more = ఇంకా తెలుసుకోండి
do-not-track-option-default-content-blocking-known =
    .label = తెలిసిన ట్రాకర్లను నిరోధించేలా { -brand-short-name } అమర్చివున్నప్పుడు మాత్రమే
do-not-track-option-always =
    .label = ఎల్లప్పుడూ
pref-page-title =
    { PLATFORM() ->
        [windows] ఎంపికలు
       *[other] అభిరుచులు
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
            [windows] ఎంపికలలో వెతకండి
           *[other] ప్రాధాన్యతలు తెరువు
        }
managed-notice = మీ విహారిణి మీ సంస్థ ద్వారా నిర్వహించబడుతోంది.
pane-general-title = సాధారణం
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = ముంగిలి
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = వెతకడం
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = అంతరంగికత & భద్రత
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = { -brand-short-name } ప్రయోగాలు
category-experimental =
    .tooltiptext = { -brand-short-name } ప్రయోగాలు
pane-experimental-subtitle = జాగ్రత్తతో ముందుకెళ్ళండి
pane-experimental-search-results-header = { -brand-short-name } ప్రయోగాలు: జాగ్రత్తతో ముందుకెళ్ళండి
help-button-label = { -brand-short-name } తోడ్పాటు
addons-button-label = పొడగింతలు & అలంకారాలు
focus-search =
    .key = f
close-button =
    .aria-label = మూసివేయి

## Browser Restart Dialog

feature-enable-requires-restart = ఈ విశేషణం చేతనం చేయుటకు { -brand-short-name } ను తప్పక పునఃప్రారంభించాలి.
feature-disable-requires-restart = ఈ విశేషణం అచేతనం చేయుటకు { -brand-short-name } ను తప్పక పునఃప్రారంభించాలి.
should-restart-title = { -brand-short-name } పునఃప్రారంభించు
should-restart-ok = ఇప్పుడు { -brand-short-name } ను పునఃప్రారంభించు
cancel-no-restart-button = రద్దుచేయి
restart-later = తరువాత పునఃప్రారంభించు

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
extension-controlled-homepage-override = మీ ముంగిలి పేజీని <img data-l10n-name="icon"/> { $name } అను పొడగింత నియంత్రిస్తుంది.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = మీ కొత్తట్యాబు పేజీని <img data-l10n-name="icon"/> { $name } అను పొడగింత నియంత్రిస్తుంది.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = ఒక పొడగింత, <img data-l10n-name="icon"/> { $name }, మీ అప్రమేయ సెర్చింజనుని అమర్చింది.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = ఒక పొడగింతకి, <img data-l10n-name="icon"/> { $name }, కంటెయినర్ ట్యాబులు కావాలి.

## Preferences UI Search Results

search-results-header = వెతుకుడు ఫలితాలు
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] క్షమించండి! “<span data-l10n-name="query"></span>” కోసం ఎంపికలలో ఫలితాలేమీ లేవు.
       *[other] క్షమించండి! “<span data-l10n-name="query"></span>” కోసం అభిరుచులలో ఫలితాలేమీ లేవు.
    }
search-results-help-link = సహాయం కావాలా? <a data-l10n-name="url">{ -brand-short-name } తోడ్పాటు</a>కి వెళ్ళండి

## General Section

startup-header = మొదలవడం
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name }, Firefoxలను ఒకేసారి నడవడానికి అనుమతించు
use-firefox-sync = చిట్కా: ఇది వేర్వేరు ప్రొఫైళ్ళను వాడుతుంది. వాటి మధ్యలో డేటాను పంచుకోడానికి { -sync-brand-short-name }ను వాడండి.
get-started-not-logged-in = { -sync-brand-short-name } లోనికి ప్రవేశించండి…
get-started-configured = { -sync-brand-short-name } అభిరుచులను తెరువు
always-check-default =
    .label = { -brand-short-name } మీ అప్రమేయ విహారిణియేనా అని ఎల్లప్పుడూ పరిశీలించు
    .accesskey = w
is-default = { -brand-short-name } ప్రస్తుతం మీ అప్రమేయ విహారిణి
is-not-default = { -brand-short-name } ప్రస్తుతం మీ అప్రమేయ విహారిణి కాదు
set-as-my-default-browser =
    .label = అప్రమేయం చేయి…
    .accesskey = D
startup-restore-previous-session =
    .label = మునుపటి సెషన్ను పునరుద్ధరించు
    .accesskey = s
startup-restore-warn-on-quit =
    .label = విహారిణిని మూసివేస్తున్నప్పుడు నన్ను హెచ్చరించు
disable-extension =
    .label = పొడగింతను అచేతనించు
tabs-group-header = ట్యాబులు
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab ట్యాబులను వరుసగా కాకుండా వాటిని ఇటీవల వాడిన క్రమంలో చుట్టుతిప్పుతుంది
    .accesskey = T
open-new-link-as-tabs =
    .label = లంకెలను కొత్త విండోలలో కాక ట్యాబులలో తెరువు
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = పలు ట్యాబులను మూసివేస్తున్నప్పుడు మిమ్మల్ని హెచ్చరించు
    .accesskey = m
warn-on-open-many-tabs =
    .label = ఎక్కువ ట్యాబులను తెరిచినప్పుడు { -brand-short-name }‌ నెమ్మదిస్తూంటే నన్ను హెచ్చరించు
    .accesskey = d
switch-links-to-new-tabs =
    .label = నేను కొత్త ట్యాబులో లంకెను తెరిచినప్పుడు, వెంటనే దానికి మారు
    .accesskey = h
show-tabs-in-taskbar =
    .label = ట్యాబు మునుజూపులను విండోస్ టాస్క్‌బారులో చూపించు
    .accesskey = k
browser-containers-enabled =
    .label = కంటైనర్ ట్యాబులను చేతనం చేయి
    .accesskey = n
browser-containers-learn-more = ఇంకా తెలుసుకోండి
browser-containers-settings =
    .label = అమరికలు…
    .accesskey = i
containers-disable-alert-title = అన్ని కంటైనర్ ట్యాబులు మూసివేయాలా?
containers-disable-alert-desc =
    { $tabCount ->
        [one] మీరు ఇప్పుడు కంటెయినర్ ట్యాబులను అచేతనం చేస్తే, { $tabCount } కంటెయినర్ ట్యాబు మూసివేయబడుతుంది. మీరు నిజంగానే కంటెయినర్ ట్యాబులను అచేతనం చేయాలనుకుంటున్నారా?
       *[other] మీరు ఇప్పుడు కంటెయినర్ ట్యాబులను అచేతనం చేస్తే, { $tabCount } కంటెయినర్ ట్యాబులు మూసివేయబడతాయి. మీరు నిజంగానే కంటెయినర్ ట్యాబులను అచేతనం చేయాలనుకుంటున్నారా?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } కంటైనర్ ట్యాబు మూసివేయి
       *[other] { $tabCount } కంటైనర్ ట్యాబులను మూసివేయి
    }
containers-disable-alert-cancel-button = చేతనంగా ఉంచు
containers-remove-alert-title = ఈ కంటెయినరును తీసీవేయాలా?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] మీరు ఇప్పుడు ఈ కంటైనర్ని తీసివేస్తే, { $count } కంటైనర్ టాబు మూసివేయబడుతుంది. మీరు ఈ కంటైనర్ తొలగించాలని నిశ్చయించుకున్నారా?
       *[other] మీరు ఇప్పుడు ఈ కంటైనర్ని తీసివేస్తే, { $count } కంటైనర్ టాబ్లు మూసివేయబడతాయి. మీరు ఈ కంటైనర్ని తొలగించాలని నిశ్చయించుకున్నారా?
    }
containers-remove-ok-button = ఈ కంటెయినరును తొలగించండి
containers-remove-cancel-button = ఈ కంటెయినరును తొలగించ వద్దు

## General Section - Language & Appearance

language-and-appearance-header = భాష, రూపురేఖలు
fonts-and-colors-header = ఫాంట్స్ & రంగులు
default-font = అప్రమేయ ఫాంటు
    .accesskey = D
default-font-size = పరిమాణం
    .accesskey = S
advanced-fonts =
    .label = ఉన్నతం…
    .accesskey = A
colors-settings =
    .label = రంగులు…
    .accesskey = C
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = పాఠ్యాన్ని మాత్రమే జూమ్‌ చేయి
    .accesskey = t
language-header = భాష
choose-language-description = పేజీలను చూపించడానికి మీ ప్రాధాన్య భాషను ఎంచుకోండి
choose-button =
    .label = ఎంచుకోండి…
    .accesskey = o
manage-browser-languages-button =
    .label = ప్రత్యామ్నాయాలను అమర్చు…
    .accesskey = l
confirm-browser-language-change-description = ఈ మార్పులను ఆపాదించడానికి { -brand-short-name }‌ని పునఃప్రారంభించండి
confirm-browser-language-change-button = ఆపాదించి పునఃప్రారంభించు
translate-web-pages =
    .label = వెబ్ కాంటెంట్ అనువదించు
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = అనువాదాల సౌజన్యం <img data-l10n-name="logo"/>
translate-exceptions =
    .label = మినహాయింపులు…
    .accesskey = x
check-user-spelling =
    .label = మీరు టైపు చేసినప్పుడు స్పెల్లింగ్ ను పరిశీలించు
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = దస్త్రాలు & అనువర్తనాలు
download-header = దింపుకోళ్ళు
download-save-to =
    .label = ఫైళ్ళను ఇక్కడ భద్రపరచు
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] ఎంచుకోండి…
           *[other] విహరించు…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }
download-always-ask-where =
    .label = ఫైళ్ళను ఎక్కడ భద్రపరచాలో ప్రతీసారీ అడుగు
    .accesskey = A
applications-header = అనువర్తనాలు
applications-filter =
    .placeholder = ఫైలు రకాన్ని లేదా అనువర్తనాలను వెతకండి
applications-type-column =
    .label = విషయాంశ రకం
    .accesskey = T
applications-action-column =
    .label = చర్య
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } ఫైలు
applications-action-save =
    .label = ఫైల్‌ను భద్రపరచు
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name }ను వాడు
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name }ను వాడు (అప్రమేయం)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] macOS అప్రమేయ అనువర్తనాన్ని వాడు
            [windows] విండోస్ అప్రమేయ అనువర్తనాన్ని వాడు
           *[other] వ్యవస్థలో అప్రమేయ అనువర్తనాన్ని వాడు
        }
applications-use-other =
    .label = వేరే వాటిని వాడు…
applications-select-helper = సహాయక అనువర్తనాన్ని ఎన్నుకోండి
applications-manage-app =
    .label = అనువర్తన వివరాలు…
applications-always-ask =
    .label = ఎల్లప్పుడు అడుగు
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
    .label = { $plugin-name } వాడు ({ -brand-short-name }లో)
applications-open-inapp =
    .label = { -brand-short-name }‌లో తెరువు

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

drm-content-header = డిజిటల్ హక్కుల నిర్వహణ (DRM) విషయం
play-drm-content =
    .label = DRM-నియంత్రిత విషయాన్ని ఆడించు
    .accesskey = P
play-drm-content-learn-more = ఇంకా తెలుసుకోండి
update-application-title = { -brand-short-name } తాజాకరణలు
update-application-description = ఉత్తమ పనితీరు, స్థిరత్వం, భద్రతల కొరకు { -brand-short-name } తాజాగా ఉంచుకోండి.
update-application-version = సంచిక { $version } <a data-l10n-name="learn-more">కొత్తవి ఏమిటి</a>
update-history =
    .label = తాజాకరణ చరిత్రను చూపించు…
    .accesskey = p
update-application-allow-description = వీటికి { -brand-short-name }ని అనుమతించు
update-application-auto =
    .label = నవీకరణలను స్వయంచాలితంగా స్థాపించు (సిఫార్సు చేయబడినది)
    .accesskey = A
update-application-check-choose =
    .label = తాజాకరణల కోసం చూస్తుంది కానీ స్థాపించుకోవాలో వద్దో మిమ్నల్ని ఎంచుకోనిస్తుంది
    .accesskey = C
update-application-manual =
    .label = తాజాకరణల కోసం ఎప్పుడూ చూడవద్దు (సిఫారసు చేయము)
    .accesskey = N
update-application-use-service =
    .label = తాజాకరణలను స్థాపించడానికి బ్యాక్‌గ్రౌండ్ సేవను వాడు
    .accesskey = b
update-in-progress-title = తాజాకరణ జరుగుతోంది
update-in-progress-message = { -brand-short-name } ఈ తాజాకరణతో కొనసాగాలని అనుకుంటున్నారా?
update-in-progress-ok-button = విస్మరించు (&D)
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = కొనసాగించు (&C)

## General Section - Performance

performance-title = పనితనం
performance-use-recommended-settings-checkbox =
    .label = సిఫారసు చేయబడిన పనితనపు అమరికలను వాడండి
    .accesskey = U
performance-use-recommended-settings-desc = ఈ అమరికలు మీ కంప్యూటర్ హార్డువేర్, ఆపరేటింగ్ వ్యవస్థకు అనుగుణంగా ఉంటాయి.
performance-settings-learn-more = ఇంకా తెలుసుకోండి
performance-allow-hw-accel =
    .label = అందుబాటులో ఉన్నప్పుడు హార్డువేర్ యాక్సెలరేషన్ ఉపయోగించు
    .accesskey = r
performance-limit-content-process-option = కంటెంట్ ప్రాసెస్ పరిమితి
    .accesskey = L
performance-limit-content-process-enabled-desc = బహుళ ట్యాబ్లను ఉపయోగిస్తున్నప్పుడు అదనపు కంటెంట్ ప్రాసెస్లు పనితీరును మెరుగుపరుస్తాయి, అయితే మరింత మెమరీని కూడా ఉపయోగిస్తాయి.
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (అప్రమేయం)

## General Section - Browsing

browsing-title = విహారణ
browsing-use-autoscroll =
    .label = స్వయంచాలక స్క్రోలింగ్ వాడు
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = సాఫీ స్క్రోలింగ్ వాడు
    .accesskey = m
browsing-use-onscreen-keyboard =
    .label = అవసరమైనప్పుడు స్పర్శా కీ బోర్డు చూపించు
    .accesskey = k
browsing-use-cursor-navigation =
    .label = పేజీల మధ్య సంచరణకు ఎల్లప్పుడు కర్సరు కీలను ఉపయోగించండి
    .accesskey = c
browsing-search-on-start-typing =
    .label = మీరు టైపుచేయడం ప్రారంభించినప్పటి నుంచి పాఠ్యము‍ కొరకు శోధించు
    .accesskey = x
browsing-picture-in-picture-learn-more = ఇంకా తెలుసుకోండి
browsing-cfr-recommendations-learn-more = ఇంకా తెలుసుకోండి

## General Section - Proxy

network-settings-title = నెట్‌వర్క్ అమరికలు
network-proxy-connection-description = { -brand-short-name } అంతర్జాలానికి ఎలా అనుసంధామవ్వాలో స్వరూపించండి.
network-proxy-connection-learn-more = ఇంకా తెలుసుకోండి
network-proxy-connection-settings =
    .label = అమరికలు…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = కొత్త కిటికీలు, ట్యాబులు
home-new-windows-tabs-description2 = మీ ముంగిలి పేజీని, కొత్త కిటికీలను, కొత్త ట్యాబులను తెరచినప్పుడు ఏం కనబడాలో ఎంచుకోండి.

## Home Section - Home Page Customization

home-homepage-mode-label = ముంగిలి పేజీ, కొత్త కిటికీలు
home-newtabs-mode-label = కొత్త ట్యాబు
home-restore-defaults =
    .label = అప్రమేయాలను పునరుద్ధరించు
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox ముంగిలి (అప్రమేయం)
home-mode-choice-custom =
    .label = అభిమత URLలు…
home-mode-choice-blank =
    .label = ఖాళీ పేజీ
home-homepage-custom-url =
    .placeholder = URL ను అతికించండి ...
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] ప్రస్తుత పేజీని వాడు
           *[other] ప్రస్తుత పేజీలను వాడు
        }
    .accesskey = C
choose-bookmark =
    .label = ఇష్టాంశాన్ని వాడు…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Firefox ముంగిలి విషయం
home-prefs-content-description = మీ Firefox ముంగిలి తెరలో మీకు కావలసిన విషయాల్ని ఎంచుకోండి.
home-prefs-search-header =
    .label = జాల వెతుకులాట
home-prefs-topsites-header =
    .label = మేటి సైట్లు
home-prefs-topsites-description = మీరు తరచూ చూసే సైట్లు

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = { $provider }చే సిఫార్సు చేయబడినది

##

home-prefs-recommended-by-learn-more = ఇది ఎలా పనిచేస్తుంది
home-prefs-recommended-by-option-sponsored-stories =
    .label = ప్రాయోజిక కథనాలు
home-prefs-highlights-header =
    .label = విశేషాలు
home-prefs-highlights-description = మీరు భద్రపరచిన లేదా సందర్శించిన సైట్ల నుండి ఎంపికచేసినవి
home-prefs-highlights-option-visited-pages =
    .label = చూసిన పేజీలు
home-prefs-highlights-options-bookmarks =
    .label = ఇష్టాంశాలు
home-prefs-highlights-option-most-recent-download =
    .label = ఇటీవలి దింపుకోలు
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name }లో భద్రపరచిన పేజీలు
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = సంగతులు
home-prefs-snippets-description = { -vendor-short-name }, { -brand-product-name } నుండి విశేషాలు
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } వరుస
           *[other] { $num } వరుసలు
        }

## Search Section

search-bar-header = శోధన పట్టి
search-bar-hidden =
    .label = వెదకడానికీ పేజీలకు వెళ్ళడానికీ చిరునామా పట్టీనే వాడు
search-bar-shown =
    .label = పనిముట్లపట్టీలో వెతుకుడు పెట్టెను చూపించు
search-engine-default-header = అప్రమేయ శోధన యంత్రం
search-separate-default-engine =
    .label = అంతరంగిక కిటికీలలో ఈ శోధన యంత్రాన్ని వాడు
    .accesskey = U
search-suggestions-header = వెతుకుడు సలహాలు
search-suggestions-option =
    .label = వెతుకుడు సలహాలను చూపించు
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = వెతుకుడు సూచనలను చిరునామా పట్టీ ఫలితాలలో చూపించు
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = చిరునామా పట్టీ ఫలితాలలో విహరణ చరిత్ర కంటే ముుందు వెతుకుడు సూచనలను చూపించు
search-suggestions-cant-show = స్థాన పట్టీ ఫలితాలలో వెతుకుడు సలహాలను చూపించలేము ఎందుకంటే { -brand-short-name } మీ చరిత్రను ఎప్పుడూ గుర్తుంచుకోకుండా అమర్చుకున్నారు.
search-one-click-header = ఒక్క-నొక్కు శోధన యంత్రాలు
search-choose-engine-column =
    .label = శోధన యంత్రం
search-choose-keyword-column =
    .label = కీపదం
search-restore-default =
    .label = అప్రమేయ శోధన యంత్రాలను పునరుద్ధరించు
    .accesskey = D
search-remove-engine =
    .label = తీసివేయి
    .accesskey = R
search-add-engine =
    .label = చేర్చు
    .accesskey = A
search-find-more-link = మరిన్ని శోధన యంత్రాలను కనుగొనండి
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = నకిలీ కీ పదము
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = మీరు ఎంచుకున్న కీపదము ప్రస్తుతం  "{ $name }" చేత ఉపయోగించబడుతోంది. దయచేసి వేరొక దానిని ఎంచుకొనము.
search-keyword-warning-bookmark = మీరు ఎంచుకున్న కీపదము ప్రస్తుతం ఒక ఇష్టాంశముచేత ఉపయోగించబడుతోంది.దయచేసి వేరొక దానిని ఎంచుకొనుము.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] తిరిగి ఎంపికలకు
           *[other] తిరిగి అభిరుచులకు
        }
containers-header = కంటైనర్ ట్యాబులు
containers-add-button =
    .label = కొత్త కంటెయినరు చేర్చు
    .accesskey = A
containers-preferences-button =
    .label = అభిరుచులు
containers-remove-button =
    .label = తొలగించు

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = మీ జాలాన్ని మీతో తీసుకువెళ్ళండి
sync-signedout-description = మీ ఇష్టాంశాలను, చరిత్రను, ట్యాబులను, సంకేతపదాలను, పొడగింతలను, అభిరుచులను మీ పరికరాలన్నింటిలోనూ సింక్రనైజ్ చెయ్యండి.
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = మీ మొబైలు పరికరంతో సింక్రనించడానికి Firefoxని <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> లేదా <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> లో దించుకోండి.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = ప్రొఫైల్ చిత్రం మార్చు
sync-manage-account = ఖాతా నిర్వహణ
    .accesskey = o
sync-signedin-unverified = { $email } నిర్థారించబడలేదు.
sync-signedin-login-failure = మళ్ళీ అనుసంధానించడానికి సైన్ ఇన్ అవ్వండి { $email }
sync-resend-verification =
    .label = ధృవీకరణను మళ్ళీ పంపు
    .accesskey = d
sync-remove-account =
    .label = ఖాతాను తొలగించు
    .accesskey = R
sync-sign-in =
    .label = ప్రవేశించండి
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = సింక్రనించడం: చేతనం
prefs-syncing-off = సింక్రనించడం: అచేతనం
prefs-sync-now =
    .labelnotsyncing = ఇప్పుడే సింక్రనించు
    .accesskeynotsyncing = N
    .labelsyncing = సింక్రనిస్తోంది…

## The list of things currently syncing.

sync-currently-syncing-bookmarks = ఇష్టాంశాలు
sync-currently-syncing-history = చరిత్ర
sync-currently-syncing-tabs = తెరిచివున్న ట్యాబులు
sync-currently-syncing-logins-passwords = ప్రవేశాలు, సంకేతపదాలు
sync-currently-syncing-addresses = చిరునామాలు
sync-currently-syncing-creditcards = క్రెడిట్ కార్డులు
sync-currently-syncing-addons = పొడిగింతలు
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] ఎంపికలు
       *[other] అభిరుచులు
    }
sync-change-options =
    .label = మార్చు…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = ఇష్టాంశాలు
    .accesskey = m
sync-engine-history =
    .label = చరిత్ర
    .accesskey = r
sync-engine-tabs =
    .label = తెరిచివున్న ట్యాబులు
    .tooltiptext = సింకైన అన్ని పరికరాల్లో తెరిచివున్న వాటి జాబితా
    .accesskey = T
sync-engine-logins-passwords =
    .label = ప్రవేశాలు, సంకేతపదాలు
    .tooltiptext = మీరు భద్రపరచిన వాడుకరి పేర్లు, సంకేతపదాలు
    .accesskey = L
sync-engine-addresses =
    .label = చిరునామాలు
    .tooltiptext = మీరు భద్రపరచుకొన్న తపాలా చిరునామా (డెస్క్‌టాప్ మాత్రమే)
    .accesskey = e
sync-engine-creditcards =
    .label = క్రెడిట్ కార్డులు
    .tooltiptext = పేర్లూ, నెంబర్లూ, కాల పరిమితి తేదీలు (డెస్క్‌టాపులో మాత్రమే)
    .accesskey = C
sync-engine-addons =
    .label = పొడగింతలు
    .tooltiptext = డెస్కుటాప్ Firefox కోసం పొడగింతలు, అలంకారాలు
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] ఎంపికలు
           *[other] అభిరుచులు
        }
    .tooltiptext = మీరు మార్చుకున్న సాధారణ, అంతరంగికత, భద్రతా అమరికలు
    .accesskey = s

## The device name controls.

sync-device-name-header = పరికరం పేరు
sync-device-name-change =
    .label = పరికరం పేరు మార్చు…
    .accesskey = h
sync-device-name-cancel =
    .label = రద్దుచేయి
    .accesskey = n
sync-device-name-save =
    .label = భద్రపరచు
    .accesskey = v
sync-connect-another-device = మరొక పరికరాన్ని అనుసంధానించు

## Privacy Section

privacy-header = విహరిణి గోప్యత

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = ప్రవేశాలు & సంకేతపదాలు
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = సైట్ల ప్రవేశాలూ, సంకేతపదాలు భద్రపరచుకోడానికి అడుగు
    .accesskey = r
forms-exceptions =
    .label = మినహాయింపులు…
    .accesskey = x
forms-breach-alerts-learn-more-link = ఇంకా తెలుసుకోండి
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = ప్రవేశాలను, సంకేతపదాలను స్వయంచాలకంగా పూరించు
    .accesskey = i
forms-saved-logins =
    .label = భద్రపరచిన ప్రవేశాలు…
    .accesskey = L
forms-master-pw-use =
    .label = ప్రధాన సంకేతపదాన్ని వాడు
    .accesskey = U
forms-primary-pw-use =
    .label = ప్రధాన సంకేతపదాన్ని వాడు
    .accesskey = U
forms-primary-pw-learn-more-link = ఇంకా తెలుసుకోండి
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = ప్రధాన సంకేతపదాన్ని మార్చు…
    .accesskey = M
forms-master-pw-fips-title = మీరు ప్రస్తుతం FIPS రీతిలో ఉన్నారు. FIPS కు ఒక ఖాళీ-కాని ముఖ్య సంకేతపదం అవసరము.
forms-primary-pw-change =
    .label = ప్రధాన సంకేతపదాన్ని మార్చు…
    .accesskey = P
forms-master-pw-fips-desc = సంకేతపదం మార్పు విఫలమైంది

## OS Authentication dialog

master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = చరిత్ర
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
    .label = చరిత్రను గుర్తుపెట్టుకుంటుంది
history-remember-option-never =
    .label = ఎప్పుడూ చరిత్రను గుర్తుపెట్టుకోదు
history-remember-option-custom =
    .label = చరిత్ర కోసం అభిమత అమరికలు వాడుతుంది
history-remember-description = { -brand-short-name } మీ విహరణ, దింపుకోళ్ళ, ఫారాల, వెతుకులాటల చరిత్రను గుర్తుపెట్టుకుంటుంది.
history-dontremember-description = { -brand-short-name } గోప్య వీక్షణం అమరికలనే వాడుతుంది మరియు మీ వీక్షణ చరిత్రని గుర్తుంచుకోదు.
history-private-browsing-permanent =
    .label = ఎల్లప్పుడూ ఆంతరంగిక విహారణ రీతిని వాడు
    .accesskey = p
history-remember-browser-option =
    .label = విహరణ, దింపుకోలు చరిత్రను గుర్తుపెట్టుకో
    .accesskey = b
history-remember-search-option =
    .label = నా శోధన, ఫారాల చరిత్రని గుర్తుపెట్టుకో
    .accesskey = f
history-clear-on-close-option =
    .label = { -brand-short-name }‌ను మూసివేసినపుడు చరిత్రని తుడిచివేయి
    .accesskey = r
history-clear-on-close-settings =
    .label = అమరికలు…
    .accesskey = t
history-clear-button =
    .label = చరిత్రను తుడిచివేయి…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = కుకీలు, సైటు డేటా
sitedata-total-size-calculating = సైటు దత్తాంశం, కాషెల పరిమాణాన్ని లెక్కిస్తున్నాం…
sitedata-learn-more = మరింత తెలుసుకోండి
sitedata-delete-on-close =
    .label = { -brand-short-name }‌ను మూసివేసినపుడు కుకీలను, సైటు డేటాను తొలగించు
    .accesskey = c
sitedata-allow-cookies-option =
    .label = కుకీలను, సైటు డేటాను అంగీకరించు
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = కుకీలను, సైటు డేటాను నిరోధించు
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = నిరోధించిన రకం
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = క్రాస్-సైట్ ట్రాకర్లు
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = క్రాస్-సైటు, సామాజిక మాధ్యమాల ట్రాకర్లు
sitedata-option-block-unvisited =
    .label = చూడని వెబ్‌సైట్ల కుకీలు
sitedata-option-block-all-third-party =
    .label = మూడవ-పక్ష కుకీలన్నీ (కొన్ని వెబ్‌సైట్లు పనిచేయకపోవచ్చు)
sitedata-option-block-all =
    .label = కుకీలన్నీ (వెబ్‌సైట్లు పనిచేయకపోడానికి కారణమవుతుంది)
sitedata-clear =
    .label = డేటాను తుడిచివేయి…
    .accesskey = l
sitedata-settings =
    .label = డేటాని నిర్వహించండి…
    .accesskey = M
sitedata-cookies-permissions =
    .label = అనుమతులను నిర్వహించండి…
    .accesskey = P
sitedata-cookies-exceptions =
    .label = మినహాయింపులను నిర్వహించండి…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = చిరునామా పట్టీ
addressbar-suggest = చిరునామా పట్టీ వాడుతునప్పుడు, వీటి నుండి సూచించు
addressbar-locbar-history-option =
    .label = విహరణ చరిత్ర
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = ఇష్టాంశాలు
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = తెరిచివున్న ట్యాబులు
    .accesskey = O
addressbar-locbar-topsites-option =
    .label = మేటి సైట్లు
    .accesskey = T
addressbar-suggestions-settings = సెర్చింజను సూచనల అభిరుచులను మార్చండి

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = మెరుగైన ట్రాకింగ్ సంరక్షణ
content-blocking-learn-more = ఇంకా తెలుసుకోండి

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = ప్రామాణికం
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = కఠినం
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = అభిమతం
    .accesskey = C

##

content-blocking-private-windows = అంతరంగిక కిటికీలలో ట్రాకింగ్ విషయం
content-blocking-cross-site-tracking-cookies = క్రాస్ -సైట్ ట్రాకింగ్ కుకీలు
content-blocking-social-media-trackers = సామాజిక మాధ్యమాల ట్రాకర్లు
content-blocking-all-cookies = అన్ని కుకీలు
content-blocking-unvisited-cookies = చూడని సైట్ల నుండి కుకీలు
content-blocking-all-third-party-cookies = మూడవ-పక్ష కుకీలన్నీ
content-blocking-cryptominers = క్రిప్టోమైనర్లు
content-blocking-fingerprinters = ఫింగర్‌ప్రింటర్లు
content-blocking-warning-title = గమనిక!
content-blocking-warning-learn-how = ఎలానో తెలుసుకోండి
content-blocking-reload-tabs-button =
    .label = ట్యాబులన్నింటినీ మళ్లీ లోడుచేయి
    .accesskey = R
content-blocking-tracking-content-label =
    .label = ట్రాకింగ్ విషయం
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = అన్ని కిటికీల లోనూ
    .accesskey = A
content-blocking-option-private =
    .label = అంతరంగిక కిటికీలలో మాత్రమే
    .accesskey = p
content-blocking-tracking-protection-change-block-list = నిరోధపు జాబితాను మార్చు
content-blocking-cookies-label =
    .label = కుకీలు
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = మరింత సమాచారం
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = క్రిప్టోమైనర్లు
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = ఫింగర్‌ప్రింటర్లు
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = మినహాయింపులను నిర్వహించండి…
    .accesskey = x

## Privacy Section - Permissions

permissions-header = అనుమతులు
permissions-location = స్థానము
permissions-location-settings =
    .label = అమరికలు…
    .accesskey = I
permissions-xr-settings =
    .label = అమరికలు…
    .accesskey = t
permissions-camera = కెమేరా
permissions-camera-settings =
    .label = అమరికలు…
    .accesskey = c
permissions-microphone = మైక్రోఫోను
permissions-microphone-settings =
    .label = అమరికలు…
    .accesskey = m
permissions-notification = గమనింపులు
permissions-notification-settings =
    .label = అమరికలు…
    .accesskey = n
permissions-notification-link = ఇంకా తెలుసుకోండి
permissions-notification-pause =
    .label = { -brand-short-name } పునఃప్రారంభమయ్యే వరకూ గమనింపులను నిలిపివేయి
    .accesskey = n
permissions-autoplay = స్వీయారంభం
permissions-autoplay-settings =
    .label = అమరికలు…
    .accesskey = t
permissions-block-popups =
    .label = పాప్-అప్ విండోలను నిరోధించు
    .accesskey = B
permissions-block-popups-exceptions =
    .label = మినహాయింపులు…
    .accesskey = E
permissions-addon-install-warning =
    .label = జాలగూడులు పొడిగింతలను స్థాపించుటకు ప్రయత్నించినపుడు నిన్ను హెచ్చరించును
    .accesskey = W
permissions-addon-exceptions =
    .label = మినహాయింపులు…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = ప్రాప్యత సేవలు నా విహారిణిని చూడకుండా నివారించు
    .accesskey = a
permissions-a11y-privacy-link = ఇంకా తెలుసుకోండి

## Privacy Section - Data Collection

collection-header = { -brand-short-name } డేటా సేకరణ, వాడుక
collection-privacy-notice = గోప్యతా విధానం
collection-health-report-telemetry-disabled-link = ఇంకా తెలుసుకోండి
collection-health-report =
    .label = సాంకేతిక, ఇంటరాక్షన్ డేటాను { -vendor-short-name }‌కి పంపించుటకు { -brand-short-name }‌ని అనుమతించు
    .accesskey = r
collection-health-report-link = ఇంకా తెలుసుకోండి
collection-studies-link = { -brand-short-name } అథ్యయనాలను చూడండి
addon-recommendations-link = ఇంకా తెలుసుకోండి
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = ఈ బిల్డ్ కాన్ఫిగరేషన్ కోసం డేటా రిపోర్టింగ్ నిలిపివేయబడింది
collection-backlogged-crash-reports =
    .label = మిగిలిపోయిన క్రాష్ నివేదికలకు నా తరపున పంపించడానికి { -brand-short-name }‌ని అనుమతించు
    .accesskey = c
collection-backlogged-crash-reports-link = ఇంకా తెలుసుకోండి

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = భద్రత
security-browsing-protection = మోసపూరిత జాల విషయం, ప్రమాదకరమైన సాఫ్ట్‌వేరు నుండి రక్షణ
security-enable-safe-browsing =
    .label = ప్రమాదకరమైన, మోసపూరిత కంటెంటును నిరోధించు
    .accesskey = B
security-enable-safe-browsing-link = ఇంకా తెలుసుకోండి
security-block-downloads =
    .label = ప్రమాదకరమైన దింపుకోళ్ళను నిరోధించు
    .accesskey = D
security-block-uncommon-software =
    .label = అవాంఛిత, అసాధారణ సాఫ్ట్‌వేర్ల గురించి నన్ను హెచ్చరించు
    .accesskey = C

## Privacy Section - Certificates

certs-header = ధృవీకరణ పత్రాలు
certs-personal-label = మీ వ్యక్తిగత ధృవీకరణపత్రాన్ని సర్వర్ అభ్యర్థించినప్పుడు
certs-select-auto-option =
    .label = స్వయంచాలకంగా ఒక దానిని ఎంపికచేయి
    .accesskey = S
certs-select-ask-option =
    .label = ప్రతిసారీ మిమ్మల్ని అడుగును
    .accesskey = A
certs-enable-ocsp =
    .label = ధృవీకరణపత్రాల ప్రస్తుత ప్రమాణతను నిర్థారించుటకు OCSP రెస్పాండర్ సేవికలను ప్రశ్నిస్తుంది
    .accesskey = Q
certs-view =
    .label = ధృవీకరణ పత్రాలను చూడండి…
    .accesskey = C
certs-devices =
    .label = రక్షణ పరికరాలు…
    .accesskey = D
space-alert-learn-more-button =
    .label = ఇంకా తెలుసుకోండి
    .accesskey = L
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] ఎంపికలను తెరువు
           *[other] అభిరుచులను తెరువు
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }
space-alert-under-5gb-ok-button =
    .label = సరే, అర్థమయ్యింది
    .accesskey = K

## Privacy Section - HTTPS-Only

httpsonly-header = HTTPS-మాత్రమే రీతి
httpsonly-learn-more = ఇంకా తెలుసుకోండి
httpsonly-radio-disabled =
    .label = HTTPS-మాత్రమే రీతిని చేతనం చేయవద్దు

## The following strings are used in the Download section of settings

desktop-folder-name = డెస్కుటాప్
downloads-folder-name = దింపుకోళ్ళు
choose-download-folder-title = దింపుకోళ్ళ సంచయాన్ని తెరువు:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = దస్త్రాలను { $service-name }‌లో భద్రపరుచు
