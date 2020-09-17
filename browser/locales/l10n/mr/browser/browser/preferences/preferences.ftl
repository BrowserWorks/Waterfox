# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = आपल्याला ट्रॅक न करण्यासाठी वेबसाइट्सना "ट्रॅक करू नका" हा इशारा पाठवा
do-not-track-learn-more = अधिक जाणा
do-not-track-option-always =
    .label = नेहमी

pref-page-title =
    { PLATFORM() ->
        [windows] पर्याय
       *[other] प्राधान्यक्रम
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
            [windows] पर्यायांमध्ये शोधा
           *[other] प्राधान्यतांमध्ये शोधा
        }

managed-notice = आपला ब्राउझर आपल्या संस्थेद्वारे व्यवस्थापित केला जात आहे.

pane-general-title = सर्वसाधारण
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = मुखपृष्ठ
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = शोधा
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = गोपनीयता आणि सुरक्षा
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }

help-button-label = { -brand-short-name } मदत केंद्र
addons-button-label = विस्तार आणि थीम

focus-search =
    .key = f

close-button =
    .aria-label = बंद करा

## Browser Restart Dialog

feature-enable-requires-restart = हे गुणविशेष सुरू करण्याकरिता { -brand-short-name }ला पुन्हा सुरू करा.
feature-disable-requires-restart = हे गुणविशेष बंद करण्याकरिता { -brand-short-name }ला पुन्हा सुरू करा.
should-restart-title = { -brand-short-name }ला पुन्हा सुरू करा
should-restart-ok = { -brand-short-name } लगेच पुनर्रारंभित करा
cancel-no-restart-button = रद्द करा
restart-later = नंतर पुनःसुरु करा

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
extension-controlled-homepage-override = एक विस्तार, <img data-l10n-name="icon"/> { $name }, आपले मुख्य पृष्ठ नियंत्रित करत आहे.

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = एक विस्तारण, <img data-l10n-name="icon"/> { $name }, आपले नवीन टॅब पृष्ठ संचालित करत आहे.

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = एक एक्स्टेंशन, <img data-l10n-name="icon"/> { $name }, ने आपले शोध इंजिन सेट केले आहे.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = एक विस्तार, <img data-l10n-name="icon"/> { $name } ला, कंटेनर टॅबची आवश्यकता आहे.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = एक विस्तारण, <img data-l10n-name="icon"/> { $name }, { -brand-short-name } इंटरनेट ला जोडणी कसे करते ते संचालित करत आहे.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = एक्स्टेंशन कार्यान्वित करण्यासाठी <img data-l10n-name="menu-icon"/> मेनू मध्ये <img data-l10n-name="addons-icon"/> अॅड-ऑन वर जा.

## Preferences UI Search Results

search-results-header = शोध परिणाम

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] माफ करा! “<span data-l10n-name="query"></span>” च्या पर्यायासाठी कोणतेही परिणाम नाहीत.
       *[other] माफ करा! “<span data-l10n-name="query"></span>” च्या प्राधान्यतेसाठी कोणतेही परिणाम नाहीत.
    }

search-results-help-link = मदत हवी आहे? भेट द्या <a data-l10n-name="url">{ -brand-short-name } मदत</a>

## General Section

startup-header = प्रारंभीकरण

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } आणि Firefox एकाच वेळी चालविण्याची परवानगी द्यावी
use-firefox-sync = टीप: हे स्वतंत्र प्रोफाइल वापते. त्यांच्या दरम्यान डाटा शेअर करण्यासाठी { -sync-brand-short-name } वापरा.
get-started-not-logged-in = { -sync-brand-short-name } मध्ये साईन इन करा...
get-started-configured = { -sync-brand-short-name } प्राधान्यता उघडा

always-check-default =
    .label = नेहमी { -brand-short-name } पूर्वनिर्धारित ब्राउझर आहे याची खात्री करा
    .accesskey = y

is-default = { -brand-short-name } सध्या आपले पूर्वनिर्धारित ब्राउझर आहे
is-not-default = { -brand-short-name } सध्या आपले पूर्वनिर्धारित ब्राउझर नाही आहे

set-as-my-default-browser =
    .label = पूर्वनिर्धारित बनवा…
    .accesskey = D

startup-restore-previous-session =
    .label = मागील सत्र पूर्वस्थितीत आणा
    .accesskey = s

startup-restore-warn-on-quit =
    .label = ब्राउझर सोडताना चेतावनी द्या

disable-extension =
    .label = वाढीव कार्यक्रम निष्क्रिय करा

tabs-group-header = टॅब्ज

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab वापरलेल्या क्रमामध्ये टॅब्स बदली करते
    .accesskey = T

open-new-link-as-tabs =
    .label = नवीन पटल ऐवजी टॅबमध्ये दुवे उघडा
    .accesskey = w

warn-on-close-multiple-tabs =
    .label = एकापेक्षा जास्त टॅब बंद करतेवेळी मला सावध करा
    .accesskey = m

warn-on-open-many-tabs =
    .label = एकापेक्षा जास्त टॅब उघडताना मला सावध करा कारण त्यामुळे { -brand-short-name } हळु होऊ शकते
    .accesskey = d

switch-links-to-new-tabs =
    .label = नवीन टॅबमध्ये लिंक उघडल्यावर, लगेच त्याकडे जा
    .accesskey = h

show-tabs-in-taskbar =
    .label = पटलाच्या कार्यपट्टीत टॅब पूर्वावलोकन दाखवा
    .accesskey = k

browser-containers-enabled =
    .label = कंटेनर टॅब्स सक्रीय करा
    .accesskey = n

browser-containers-learn-more = अधिक जाणा

browser-containers-settings =
    .label = सेटिंग्ज…
    .accesskey = i

containers-disable-alert-title = सगळे कंटेनर टॅब बंद करायचे आहेत का?
containers-disable-alert-desc =
    { $tabCount ->
        [one] जर आपण आता कंटेनर टॅब्स निष्क्रिय केलेत, तर { $tabCount } कंटेनर टॅब बंद होईल. आपल्याला खरंच कंटेनर टॅब्स निष्क्रिय करायचेत का?
       *[other] जर आपण आता कंटेनर टॅब्स निष्क्रिय केलेत, तर { $tabCount } कंटेनर टॅब्स बंद होतील. आपल्याला खरंच कंटेनर टॅब्स निष्क्रिय करायचेत का?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } कंटेनर टॅब बंद करा
       *[other] { $tabCount } कंटेनर टॅब्स बंद करा
    }
containers-disable-alert-cancel-button = सक्रिय ठेवा

containers-remove-alert-title = हा कंटेनर काढून टाकायचा का?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] जर आपण हा कंटेनर काढून टाकलात, तर { $count } कंटेनर टॅब बंद होइल. आपल्याला हा कंटेनर काढायचा आहे याबद्दल खात्री आहे का?
       *[other] जर आपण हा कंटेनर काढून टाकलात, तर { $count } कंटेनर टॅब बंद होतील. आपल्याला हा कंटेनर काढायचा आहे याबद्दल खात्री आहे का?
    }

containers-remove-ok-button = हा कंटेनर काढून टाका
containers-remove-cancel-button = हा कंटेनर काढू नका


## General Section - Language & Appearance

language-and-appearance-header = भाषा आणि स्वरुप

fonts-and-colors-header = टंक आणि रंग

default-font = पूर्वनिर्धारित फॉन्ट
    .accesskey = D
default-font-size = आकार
    .accesskey = S

advanced-fonts =
    .label = प्रगत…
    .accesskey = A

colors-settings =
    .label = रंग…
    .accesskey = C

language-header = भाषा

choose-language-description = पृष्ठ दाखवण्याकरिता सूचविलेली भाषा निवडा

choose-button =
    .label = निवडा…
    .accesskey = o

choose-browser-language-description = { -brand-short-name } चा मेनू, संदेश, आणि सुचना दर्शवणारी भाषा ठरवा.
manage-browser-languages-button =
    .label = पर्याय सेट करा...
    .accesskey = l
confirm-browser-language-change-description = हे बदल लागू करण्यासाठी { -brand-short-name } पुन्हा सुरु करा
confirm-browser-language-change-button = लागू करून पुन्हा सुरु करा

translate-web-pages =
    .label = वेब अंतर्भुत माहिती भाषांतरीत करा
    .accesskey = T

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = तर्फे भाषांतरीत <img data-l10n-name="logo"/>

translate-exceptions =
    .label = अपवाद…
    .accesskey = x

check-user-spelling =
    .label = टाइप करतेवेळी शुध्दलेखन तपासत रहा
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = फाईल आणि ॲप्लिकेशन

download-header = डाउनलोड्ज

download-save-to =
    .label = फाइल्स येथे साठवा
    .accesskey = v

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] निवडा…
           *[other] चाळा…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }

download-always-ask-where =
    .label = फाइल कुठे साठवायची ते नेहमी मला विचारा
    .accesskey = A

applications-header = ॲप्लिकेशन

applications-description = आपण ब्राऊझिंग करताना वापरलेले ऍप्लिकेशन्स किंवा वेब वरून डाउनलोड केलेल्या फाईल्स { -brand-short-name } कसे हाताळते ते निवडा

applications-filter =
    .placeholder = फाईल प्रकार किंवा ॲप्लिकेशन शोधा

applications-type-column =
    .label = अंतर्भुत माहिती प्रकार
    .accesskey = T

applications-action-column =
    .label = कृती
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } फाइल
applications-action-save =
    .label = फाइल संचयन

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } वापरा

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } वापरा (पूर्वनिर्धारित)

applications-use-other =
    .label = इतर वापरा…
applications-select-helper = मदतनीस कार्यक्रम निवडा

applications-manage-app =
    .label = अनुप्रयोग तपशील…
applications-always-ask =
    .label = नेहमी विचारा
applications-type-pdf = पोर्टेबल डॉक्युमेंट फॉरमॅट (PDF)

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
    .label = { $plugin-name } वापरा ({ -brand-short-name } अंतर्गत)

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

drm-content-header = डिजिटल हक्क व्यवस्थापन (डीआरएम) मजकूर

play-drm-content =
    .label = डीआरएम-नियंत्रित मजकूर चालवा
    .accesskey = P

play-drm-content-learn-more = अधिक जाणा

update-application-title = { -brand-short-name } सुधारणा

update-application-description = सर्वोत्तम कामगिरी, स्थिरता आणि सुरक्षिततेसाठी { -brand-short-name } अद्ययावत ठेवा.

update-application-version = आवृत्ती{ $version } <a data-l10n-name="learn-more">काय नवीन आहे</a>

update-history =
    .label = अद्ययावत इतिहास दाखवा…
    .accesskey = p

update-application-allow-description = { -brand-short-name } ला परवानगी द्या

update-application-auto =
    .label = स्वयं अद्ययावत करा (शिफारस)
    .accesskey = A

update-application-check-choose =
    .label = सुधारणांकरिता तपासणी करा, परंतु प्रतिष्ठापन करायचे की नाही ते मला ठरवू द्या
    .accesskey = C

update-application-manual =
    .label = सुधारणांकरिता कधीच तपासणी करू नका (शिफारसीय नाही)
    .accesskey = N

update-application-use-service =
    .label = सुधारणा इंस्टॉल करण्यासाठी पार्श्वभूमी सर्व्हिस्चा वापर करा
    .accesskey = b

update-setting-write-failure-title = अद्यतन प्राधान्ये जतन करताना त्रुटी

update-in-progress-title = अद्यतन प्रगतीपथावर

update-in-progress-ok-button = रद्द करा
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = पुढे चला

## General Section - Performance

performance-title = कार्यक्षमता

performance-use-recommended-settings-checkbox =
    .label = शिफारस केलेले कार्यक्षमता सेटिंग वापरा
    .accesskey = U

performance-use-recommended-settings-desc = हे सेटिंग आपल्या संगणकाच्या हार्डवेअर आणि ऑपरेटिंग प्रणाली साठी अनुरूप होतील अशा प्रकारे बनवले आहेत.

performance-settings-learn-more = अधिक जाणा

performance-allow-hw-accel =
    .label = उपलब्ध असल्यावर हार्डवेअर ॲक्सिलरेशनचा वापर करा
    .accesskey = r

performance-limit-content-process-option = मजकूर प्रक्रिया मर्यादा
    .accesskey = l

performance-limit-content-process-enabled-desc = अनेक टॅब वापरल्यास, अतिरिक्त मजकूर प्रक्रिया कार्यक्षमता वाढवू  शकतात, पण त्या अधिक मेमरी देखील वापरातील.
performance-limit-content-process-blocked-desc = मजकूर प्रक्रियांची गणना बदलणे फक्त मल्टिप्रोसेस { -brand-short-name } सोबत शक्य आहे. <a data-l10n-name="learn-more">मल्टिप्रोसेस कार्यान्वित आहेत की नाही कसे तपासायचे ते जाणा</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (पूर्वनिर्धारित)

## General Section - Browsing

browsing-title = ब्राउजिंग

browsing-use-autoscroll =
    .label = स्वस्क्रोलिंगचा वापर करा
    .accesskey = a

browsing-use-smooth-scrolling =
    .label = सौम्यपणे सरकवण्याचा वापर करा
    .accesskey = m

browsing-use-onscreen-keyboard =
    .label = जेव्हा आवश्यक असेल तेव्हा टच कीबोर्ड दाखवा
    .accesskey = k

browsing-use-cursor-navigation =
    .label = पृष्ठाच्या आत संचार करण्याकरता नेहमी कर्सर कळचा वापर करा
    .accesskey = c

browsing-search-on-start-typing =
    .label = लिहीण्यास सुरूवात केल्यावर मजकुर शोधा
    .accesskey = x

browsing-picture-in-picture-learn-more = अधिक जाणा

browsing-cfr-recommendations =
    .label = आपण ब्राउझ करता तेव्हा विस्तारांची शिफारस करा
    .accesskey = R
browsing-cfr-features =
    .label = आपण ब्राउझ करता तेव्हा वैशिष्ट्यांची शिफारस करा
    .accesskey = f

browsing-cfr-recommendations-learn-more = अधिक जाणा

## General Section - Proxy

network-settings-title = नेटवर्क सेटिंग

network-proxy-connection-description = { -brand-short-name } इंटरनेटशी जोडणी कशी करतो ते संरचीत करा.

network-proxy-connection-learn-more = अधिक जाणा

network-proxy-connection-settings =
    .label = सेटिंग्ज…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = नवीन पटल आणि टॅब

home-new-windows-tabs-description2 = आपले मुखपृष्ठ, नवीन पटल, आणि नवीन टॅब उघडल्यावर जे आपण बघता ते निवडा.

## Home Section - Home Page Customization

home-homepage-mode-label = मुखपृष्ठ आणि नवीन पटल

home-newtabs-mode-label = नवीन टॅब

home-restore-defaults =
    .label = पूर्वनिर्धारित स्थितित आणा
    .accesskey = R

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox मुखपृष्ठ (पूर्वनिर्धारित)

home-mode-choice-custom =
    .label = सानुकूलीत URLs...

home-mode-choice-blank =
    .label = रिक्त पृष्ठ

home-homepage-custom-url =
    .placeholder = URL चिटकवा

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] सध्याच्या पृष्ठाचे वापर करा
           *[other] सध्याच्या पृष्ठांचा वापर करा
        }
    .accesskey = C

choose-bookmark =
    .label = वाचनखूणाचा वापर करा…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = फायरफॉक्स होम वरील मजकूर
home-prefs-content-description = आपल्या फायरफॉक्सचा मुख्यपृष्ठवर आपल्याला कोणती माहिती पाहिजे ते निवडा.

home-prefs-search-header =
    .label = वेब शोध
home-prefs-topsites-header =
    .label = शीर्ष साइट्स
home-prefs-topsites-description = आपण सर्वाधिक भेट देता त्या साइट

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = { $provider } तर्फे शिफारस
##

home-prefs-recommended-by-learn-more = हे कसे कार्य करते
home-prefs-recommended-by-option-sponsored-stories =
    .label = प्रायोजित कथा

home-prefs-highlights-header =
    .label = ठळक
home-prefs-highlights-description = आपण जतन केलेल्या किंवा भेट दिलेल्या साइट्सचा एक निवडक साठा
home-prefs-highlights-option-visited-pages =
    .label = भेट दिलेली पृष्ठे
home-prefs-highlights-options-bookmarks =
    .label = वाचनखुणा
home-prefs-highlights-option-most-recent-download =
    .label = अलीकडचे डाउनलोड
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name } मध्ये जतन केलेले पृष्ठ

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = कात्रणे
home-prefs-snippets-description = { -vendor-short-name } आणि { -brand-product-name } कडून अद्यतने
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } ओळ
           *[other] { $num } ओळी
        }

## Search Section

search-bar-header = शोध पट्टी
search-bar-hidden =
    .label = शोध आणि नेव्हिगेशनसाठी पत्ता पट्टी वापरा
search-bar-shown =
    .label = साधनपट्टीत शोध पट्टी जोडा

search-engine-default-header = पूर्वनिर्धारित शोध इंजिन

search-suggestions-header = शोध सूचना

search-suggestions-option =
    .label = शोध सूचना पुरवा
    .accesskey = s

search-show-suggestions-url-bar-option =
    .label = पत्ता पट्टी परिणामांत शोध सूचना दाखवा
    .accesskey = l

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = पत्ता पट्टीच्या परिणामांमध्ये ब्राऊझिंग इतिहासाच्या आधी शोध सूचना दाखवा

search-suggestions-cant-show = आपल्या शोध सूचना लोकेशन बारवर दिसणार नाही कारण आपण इतिहास लक्षात न ठेवण्यासाठी { -brand-short-name } हे संयोजित केले आहे

search-one-click-header = एक-क्लिक शोध इंजिन

search-one-click-desc = जेव्हा आपण मूळशब्द प्रविष्ट करण्यास सुरू करता तेव्हा पत्ता पट्टी आणि शोध पट्टीच्या खाली दिसणारे पर्यायी शोध इंजिन्स निवडा.

search-choose-engine-column =
    .label = शोध इंजिन्स
search-choose-keyword-column =
    .label = मुख्यशब्द

search-restore-default =
    .label = पूर्वनिर्धारित शोध इंजिन पुर्वस्थित करा
    .accesskey = D

search-remove-engine =
    .label = काढून टाका
    .accesskey = R

search-find-more-link = आणखी शोध इंजिन शोधा

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = समान मुख्यशब्द
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = आपण सध्या "{ $name }" द्वारे वापरण्यात आलेला कीवर्ड निवडला आहे. कृपया अन्य निवडा.
search-keyword-warning-bookmark = आपण सध्या वाचनखूणाद्वारे वापरण्यात आलेला कीवर्ड निवडला आहे. कृपया अन्य निवडा.

## Containers Section

containers-header = कंटेनर टॅब्स
containers-add-button =
    .label = नवीन कंटेनर जोडा
    .accesskey = A

containers-preferences-button =
    .label = प्राधान्यक्रम
containers-remove-button =
    .label = काढून टाका

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = आपला वेब आपल्याबरोबर घेऊन चला
sync-signedout-description = आपल्या सर्व साधणांकरीता आपल्या वाचनखूणा, इतिहास, टॅब, पासवर्ड, ॲड-ऑन्स्, आणि प्राधान्ये समक्रमित करा.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = साठी डाउनलोड करा <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> किंवा <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> आपल्या उपकरणाबरोबर समक्रमण करण्यासाठी

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = प्रोफाइल प्रतिमा बदला

sync-sign-out =
    .label = साइन आउट करा…
    .accesskey = g

sync-manage-account = खाते व्यवस्थापित करा
    .accesskey = o

sync-signedin-unverified = { $email } चाचणी झाली नाही.
sync-signedin-login-failure = पुन्हा जोडणीकरिता कृपया साइन करा { $email }

sync-resend-verification =
    .label = पडताळणी पुन्हा पाठवा
    .accesskey = d

sync-remove-account =
    .label = खाते काढा
    .accesskey = R

sync-sign-in =
    .label = साइन इन
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-sync-now =
    .labelnotsyncing = आत्ता सिंक करा
    .accesskeynotsyncing = N
    .labelsyncing = सिंक करत आहे

## The list of things currently syncing.

sync-currently-syncing-bookmarks = वाचनखूणा
sync-currently-syncing-history = इतिहास
sync-currently-syncing-tabs = खुले टॅब
sync-currently-syncing-logins-passwords = लॉगिन आणि पासवर्ड
sync-currently-syncing-addresses = पत्ते
sync-currently-syncing-creditcards = क्रेडिट कार्ड
sync-currently-syncing-addons = ॲड-ऑन
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] पर्याय
       *[other] प्राधान्यक्रम
    }

sync-change-options =
    .label = बदला…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = वाचनखुणा
    .accesskey = m

sync-engine-history =
    .label = इतिहास
    .accesskey = r

sync-engine-tabs =
    .label = टॅब्स उघडा
    .tooltiptext = ताळमेळ केलेल्या उपकरणांमध्ये काय उघडलेले आहे याची यादी
    .accesskey = T

sync-engine-logins-passwords =
    .label = लॉगिन आणि पासवर्ड
    .tooltiptext = आपण जतन केलेली वापरकर्ता नावे आणि पासवर्ड
    .accesskey = L

sync-engine-addresses =
    .label = पत्ते
    .tooltiptext = आपण साठवलेले पोस्टाचे पत्ते (फक्त डेस्कटॉप साठी)
    .accesskey = e

sync-engine-creditcards =
    .label = क्रेडिट कार्ड्स
    .tooltiptext = नावे, नंबर आणि कालबाह्यता तारखा (केवळ डेस्कटॉप)
    .accesskey = C

sync-engine-addons =
    .label = ॲड-ऑन्स्
    .tooltiptext = Firefox डेस्कटॉप साठी थीम आणि एक्स्टेंशन
    .accesskey = A

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] पर्याय
           *[other] पसंती
        }
    .tooltiptext = आपण बदललेले साधारण, सुरक्षा आणि गोपनीयता सेटिंग
    .accesskey = s

## The device name controls.

sync-device-name-header = साधनाचे नाव:

sync-device-name-change =
    .label = साधनाचे नाव बदला…
    .accesskey = h

sync-device-name-cancel =
    .label = रद्द करा
    .accesskey = n

sync-device-name-save =
    .label = जतन करा
    .accesskey = v

sync-connect-another-device = अन्य उपकरण जोडा

## Privacy Section

privacy-header = ब्राऊजर गोपनीयता

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = लॉगिन आणि पासवर्ड
    .searchkeywords = { -lockwise-brand-short-name }

forms-ask-to-save-logins =
    .label = संकेतस्थळासाठी लॉगिन आणि पासवर्ड साठवण्यासाठी विचारा
    .accesskey = r
forms-exceptions =
    .label = अपवाद…
    .accesskey = x
forms-generate-passwords =
    .label = सशक्त पासवर्ड सुचवून तयार करा
    .accesskey = u
forms-breach-alerts-learn-more-link = अधिक जाणा

forms-saved-logins =
    .label = साठवलेले लॉगइन्स…
    .accesskey = L
forms-master-pw-use =
    .label = मास्टर पासवर्डचा वापर करा
    .accesskey = U
forms-master-pw-change =
    .label = मास्टर पासवर्ड बदलवा…
    .accesskey = M

forms-master-pw-fips-title = आपण सध्या एफआयपीएस् (FIPS) स्थितीमध्ये आहात. एफआयपीएस् (FIPS) साठी रिकामे मुख्य पासवर्ड चालणार नाही.

forms-master-pw-fips-desc = पासवर्ड बदल अयशस्वी

## OS Authentication dialog


## Privacy Section - History

history-header = इतिहास

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } करेल
    .accesskey = w

history-remember-option-all =
    .label = इतिहास लक्षात ठेवा
history-remember-option-never =
    .label = इतिहास कधीच लक्षात ठेवु नका
history-remember-option-custom =
    .label = इतिहासा करीता मनपसंत संयोजना वापरा

history-remember-description = { -brand-short-name } आपले ब्राउझिंग, डाउनलोड, फॉर्म आणि शोध इतिहास लक्षात ठेवेल.
history-dontremember-description = { -brand-short-name } समान संयोजना खाजगी ब्राउझिंग म्हणून वापरतो, व वेब चाळतेवेळी कुठलाही इतिहास लक्षात ठेवत नाही.

history-private-browsing-permanent =
    .label = नेहमी व्यक्तिगत ब्राउजिंग मोडचा वापर करा
    .accesskey = p

history-remember-browser-option =
    .label = ब्राऊजिंग व डाऊनलोड इतिहास लक्षात ठेवा
    .accesskey = b

history-remember-search-option =
    .label = शोध व फॉर्म इतिहास लक्षात ठेवा
    .accesskey = f

history-clear-on-close-option =
    .label = { -brand-short-name } बंद झाल्यावर इतिहास नष्ट करा
    .accesskey = r

history-clear-on-close-settings =
    .label = सेटिंग्ज…
    .accesskey = t

history-clear-button =
    .label = इतिहास पुसा...
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = कुकीज आणि साईट डेटा

sitedata-total-size-calculating = कॅश आणि साईट माहितीच्या आकाराची गणना करत आहे...

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = आपण साठवलेल्या कुकीज, साईट माहिती आणि कॅश सध्या { $value } { $unit } इतकी जागा डिस्कवर व्याप्त करत आहेत

sitedata-learn-more = अधिक जाणा

sitedata-allow-cookies-option =
    .label = कुकीज आणि साईट डेटा स्वीकारा
    .accesskey = A

sitedata-disallow-cookies-option =
    .label = कुकीज आणि साइट डेटा अवरोधित करा
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = प्रकार अवरोधित
    .accesskey = T

sitedata-clear =
    .label = माहिती पुसा...
    .accesskey = l

sitedata-settings =
    .label = डेटा व्यवस्थापित करा...
    .accesskey = M

sitedata-cookies-permissions =
    .label = परवानग्या व्यवस्थापित करा ...
    .accesskey = P

## Privacy Section - Address Bar

addressbar-header = पत्ता पट्टी

addressbar-suggest = पत्ता पट्टी वापरतेवेळी, सूचवा

addressbar-locbar-history-option =
    .label = ब्राउझिंग इतिहास
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = वाचनखूण
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = टॅब्स उघडा
    .accesskey = O

addressbar-suggestions-settings = शोध इंजिनसाठी सूचना प्राधान्यता बदला

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = वर्धित ट्रॅकिंग संरक्षण

content-blocking-learn-more = अधिक जाणून घ्या

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = मानक
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = कठोर
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = पसंतीचे
    .accesskey = C

##

content-blocking-etp-custom-desc = कोणती ट्रॅकर्स आणि स्क्रिप्ट अवरोधित करायची ते निवडा.

content-blocking-cross-site-tracking-cookies = क्रॉस-साईट ट्रॅकिंग कुकी
content-blocking-social-media-trackers = सोशल मीडिया ट्रॅकर
content-blocking-all-cookies = सर्व कुकीज
content-blocking-unvisited-cookies = भेट न दिलेल्या साइटवरील कुकीज
content-blocking-all-windows-tracking-content = सर्व विंडोमधील सामग्री ट्रॅक करणे
content-blocking-all-third-party-cookies = सर्व तृतीय-पक्ष कुकीज
content-blocking-cryptominers = क्रिप्टोमाइनर
content-blocking-fingerprinters = फिंगरप्रिंटर

content-blocking-warning-title = सावधान!

content-blocking-warning-learn-how = कसे ते जाणा

content-blocking-reload-description = हे बदल लागू करण्यासाठी आपले टॅब रीलोड करावे लागतील.
content-blocking-reload-tabs-button =
    .label = सर्व टॅब्ज पुन्हा लोड करा
    .accesskey = R

content-blocking-tracking-content-label =
    .label = ट्रॅकिंग मजकूर
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = सर्व पटलामध्ये
    .accesskey = A
content-blocking-option-private =
    .label = फक्त खाजगी पटलामध्ये
    .accesskey = P
content-blocking-tracking-protection-change-block-list = अवरोधित सूचीमध्ये बदल करा

content-blocking-cookies-label =
    .label = कुकीज
    .accesskey = C

content-blocking-expand-section =
    .tooltiptext = अधिक माहिती

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = क्रिप्टोमाइनर
    .accesskey = y

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = फिंगरप्रिंटर
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = अपवाद व्यवस्थापित करा...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = परवानग्या

permissions-location = स्थान
permissions-location-settings =
    .label = सेटिंग…
    .accesskey = t

permissions-camera = कॅमेरा
permissions-camera-settings =
    .label = सेटिंग…
    .accesskey = t

permissions-microphone = मायक्रोफोन
permissions-microphone-settings =
    .label = सेटिंग…
    .accesskey = t

permissions-notification = सूचना
permissions-notification-settings =
    .label = सेटिंग…
    .accesskey = t
permissions-notification-link = अधिक जाणा

permissions-notification-pause =
    .label = सूचना { -brand-short-name } पुन्हा सुरु होईपर्यंत स्थगित करा
    .accesskey = n

permissions-autoplay = ऑटोप्ले

permissions-autoplay-settings =
    .label = सेटिंग…
    .accesskey = t

permissions-block-popups =
    .label = पॉपअप पटल अडवा
    .accesskey = B

permissions-block-popups-exceptions =
    .label = अपवाद…
    .accesskey = E

permissions-addon-install-warning =
    .label = साईट्स ॲड-ऑन्स् इंस्टॉल करण्याचा प्रयत्न करताना मला सावध करा
    .accesskey = W

permissions-addon-exceptions =
    .label = अपवाद…
    .accesskey = E

permissions-a11y-privacy-checkbox =
    .label = सुलभता सेवांना आपल्या ब्राउझरमध्ये प्रवेश करण्यापासून प्रतिबंधित करा
    .accesskey = a

permissions-a11y-privacy-link = अधिक जाणा

## Privacy Section - Data Collection

collection-header = { -brand-short-name } माहिती संग्रह आणि वापर

collection-description = आम्ही आपल्याला पर्याय उपलब्ध करण्यासाठी प्रयत्न करतो आणि सर्वांसाठी { -brand-short-name } उपलब्ध होण्यासाठी आणि सुधारण्यासाठी गरजेपुरतेच गोळा करतो. वैयक्तिक माहिती घेण्याआधी आम्ही नेहमी परवानगी विचारतो.
collection-privacy-notice = गोपनीयता सूचना

collection-health-report =
    .label = { -vendor-short-name } ला तांत्रिक व परस्परसंवाद माहिती पाठविण्यासाठी { -brand-short-name } ला परवानगी द्या
    .accesskey = r
collection-health-report-link = अधिक जाणा

collection-studies =
    .label = { -brand-short-name } ला studies प्रस्थापित करून चालवण्याची परवानगी द्या
collection-studies-link = { -brand-short-name } studies पहा

addon-recommendations =
    .label = वैयक्तिकृत विस्ताराच्या शिफारसी करण्यासाठी { -brand-short-name } ला अनुमती द्या
addon-recommendations-link = अधिक जाणा

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = माहिती अहवाल देणे या बांधणी संरचनेमध्ये निष्क्रिय केलेले आहे

collection-backlogged-crash-reports =
    .label = आपल्यावतीने { -brand-short-name } ला बॅकलॉग क्रॅश अहवाल पाठवण्याची परवानगी दया
    .accesskey = c
collection-backlogged-crash-reports-link = अधिक जाणा

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = सुरक्षा

security-browsing-protection = भ्रामक मजकूर आणि धोकादायक सॉफ्टवेअर संरक्षण

security-enable-safe-browsing =
    .label = धोकादायक आणि भ्रामक सामग्री अवरोधित करा
    .accesskey = B
security-enable-safe-browsing-link = अधिक जाणा

security-block-downloads =
    .label = धोकादायक डाउनलोड अवरोधित करा
    .accesskey = d

security-block-uncommon-software =
    .label = नको असलेल्या आणि असामान्य सॉफ्टवेअर बद्दल मला सुचना द्या
    .accesskey = c

## Privacy Section - Certificates

certs-header = प्रमाणपत्र

certs-personal-label = जेव्हा सर्व्हर वैयक्तिक प्रमाणपत्रा करीता विनंती करतो

certs-select-auto-option =
    .label = आपोआप निवडा
    .accesskey = S

certs-select-ask-option =
    .label = मला प्रत्येक वेळी विचारा
    .accesskey = A

certs-enable-ocsp =
    .label = क्वेरी OCSP रेसपाँडर सध्याच्या प्रमाणपत्रांची वैधताची खात्री करते
    .accesskey = Q

certs-view =
    .label = प्रमाणपत्रे बघा
    .accesskey = C

certs-devices =
    .label = सुरक्षा साधने
    .accesskey = D

space-alert-learn-more-button =
    .label = अधिक जाणा
    .accesskey = L

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] पर्याय उघडा
           *[other] प्राधान्यता उघडा
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }

space-alert-under-5gb-ok-button =
    .label = ठीक आहे, समजले
    .accesskey = K

space-alert-under-5gb-message = { -brand-short-name } ला डिस्क वरील जागा कमी पडत आहे. वेबसाईट चा मजकूर कदाचित व्यवस्थित दिसणार नाही. सुधारित ब्राऊझिंग अनुभवासाठी डिस्क चा वापर सुधारण्यासाठी "आणखी जाणा" वर भेट द्या.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = डेस्कटॉप
downloads-folder-name = डाउनलोड
choose-download-folder-title = डाउनलोड संचयिका(फोल्डर) निवडा:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = फाईल { $service-name } इथे साठवा
