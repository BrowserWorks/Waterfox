# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = तपाईँ आफु ट्रयाक हुन चाहन्न भन्नको लागि वेबसाइटहरूलाई “Do Not Track” सङ्केत पठाउनुहोस्
do-not-track-learn-more = अझै जान्नुहोस्
do-not-track-option-always =
    .label = सधैँ

pref-page-title =
    { PLATFORM() ->
        [windows] विकल्पहरू
       *[other] प्राथमिकताहरू
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
            [windows] विकल्पहरू मा फेला पार्नुहोस्
           *[other] प्राथमिकताहरू मा फेला पार्नुहोस्
        }

pane-general-title = सामान्य
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = गृहपृष्ठ
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = खोज
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = गोपनीयता & सुरक्षा
category-privacy =
    .tooltiptext = { pane-privacy-title }

help-button-label = { -brand-short-name } समर्थन

focus-search =
    .key = f

close-button =
    .aria-label = बन्द गर्नुहोस्

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } यो विशेषता चलाउन पुनःसुरु गर्नु पर्ने हुन्छ ।
feature-disable-requires-restart = { -brand-short-name } यो विशेषता हटाउन पुनःसुरु गर्नु पर्ने हुन्छ।
should-restart-title = { -brand-short-name } पुनःसुरु गर्नुहोस्
should-restart-ok = { -brand-short-name } तत्काल पुनःसुरु गर्नुहोस्
cancel-no-restart-button = रद्द गर्नुहोस्
restart-later = केहि समयपछि पुनःसुरु गर्नुहोस्

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
extension-controlled-homepage-override = यो एक्सटेन्सन, <img data-l10n-name="icon"/> { $name }, ले तपाईंको गृहपृष्ठ नियन्त्रण गरिरहेको छ।

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = यो एक्सटेन्सन, <img data-l10n-name="icon"/> { $name }, ले तपाईंको नयाँ ट्याब पेज नियन्त्रण गरिरहेको छ।

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = यो एक्सटेन्सन, <img data-l10n-name="icon"/> { $name } , लाई कन्टेनर ट्याबहरू चाहिन्छ ।

## Preferences UI Search Results

search-results-header = खोजी परिणामहरू

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] माफ गर्नुहोस्! त्यहाँ “<span data-l10n-name="query"></span>” को लागि विकल्पहरूमा नतिजा छैन ।
       *[other] माफ गर्नुहोस्! त्यहाँ “<span data-l10n-name="query"></span>” को लागि प्राथमिकताहरूमा नतिजा छैन ।
    }

search-results-help-link = सहयोग चाहियो? <a data-l10n-name="url">{ -brand-short-name } सहयोग</a> भ्रमण गर्नुहोस्

## General Section

startup-header = सुरुवात

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } र Firefox एकै समयमा चलाउन अनुमति दिनुहोस्
use-firefox-sync = सुझाव: यसले अलग प्रोफाइल प्रयोग गर्दछ। तिनीहरू बीच डाटा साझेदारी गर्न { -sync-brand-short-name } प्रयोग गर्नुहोस्।
get-started-not-logged-in = { -sync-brand-short-name }मा साइन इन गर्नुहोस्…
get-started-configured = { -sync-brand-short-name } को प्राथमिकताहरू खोल्नुहोस्

always-check-default =
    .label = सधैं { -brand-short-name } आफ्नो पूर्वनिर्धारित ब्राउजर हो भन्ने बारे जाँच गर्नुहोस्
    .accesskey = y

is-default = तपाईँको हालको निर्धारित ब्राउजर { -brand-short-name }
is-not-default = तपाईँको हालको निर्धारित ब्राउजर { -brand-short-name }

set-as-my-default-browser =
    .label = पूर्वनिर्धारित बनाउनुहोस…
    .accesskey = D

disable-extension =
    .label = एक्सटेन्सन अक्षम गर्नुहोस्

tabs-group-header = ट्याबहरू

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab ले हालसालै प्रयोग गरिएका ट्याबहरूमा चक्र लगाउँछ
    .accesskey = T

open-new-link-as-tabs =
    .label = नयाँ सञ्झ्यालको साटोमा नयाँ ट्याबमा लिङ्क खोल्नुहोस्
    .accesskey = w

warn-on-close-multiple-tabs =
    .label = धेरै ट्याबहरू बन्द गर्न खोज्दा तपाईँलाई चेतावनी दिनुहोस्
    .accesskey = m

warn-on-open-many-tabs =
    .label = धेरै ट्याबहरू खोल्दा { -brand-short-name } ढिलो हुन सक्छ भने तपाईँलाई चेतावनी दिनुहोस्
    .accesskey = d

switch-links-to-new-tabs =
    .label = जब तपाईँ नयाँ ट्याबमा लिङ्क खोल्नुहुन्छ, तुरुन्तै स्विच गर्नुहोस्
    .accesskey = h

show-tabs-in-taskbar =
    .label = सञ्झ्याल कार्यपट्टीमा ट्याबको पूर्वावलोकनहरू देखाउनुहोस्
    .accesskey = k

browser-containers-enabled =
    .label = कन्टेनर ट्याबहरू सक्षम गर्नुहोस्
    .accesskey = n

browser-containers-learn-more = अझ जान्नुहोस्

browser-containers-settings =
    .label = सेटिङहरू…
    .accesskey = i

containers-disable-alert-title = सबै कन्टेनर ट्याबहरू बन्द गर्न चाहनुहुन्छ?
containers-disable-alert-desc =
    { $tabCount ->
        [one] यदि तपाईँले अहिले कन्टेनर ट्याबहरू अक्षम गर्नुभयो भने { $tabCount } कन्टेनर ट्याब बन्द हुने छ। के तपाईँ कन्टेनर ट्याबहरू अक्षम गर्न चाहनुहुन्छ?
       *[other] यदि तपाईँले अहिले कन्टेनर ट्याबहरू अक्षम गर्नुभयो भने { $tabCount } ट्याबहरू बन्द हुने छन्। के तपाईँ कन्टेनर ट्याबहरू अक्षम गर्न चाहनुहुन्छ?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } कन्टेनर ट्याब बन्द गर्नुहोस्
       *[other] { $tabCount } कन्टेनर ट्याबहरू बन्द गर्नुहोस्
    }
containers-disable-alert-cancel-button = सक्षम राख्नुहोस्

containers-remove-alert-title = यो कन्टेनर हटाउने हो ?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] यदि तपाईँ अहिले यो कन्टेनर हटाउनुहुन्छ भने, { $count } कन्टेनर ट्याब बन्द हुनेछ । के तपाईँ यो कन्टेनर हटाउन निश्चित हुनुहुन्छ ?
       *[other] यदि तपाईँ अहिले यो कन्टेनर हटाउनुहुन्छ भने, { $count } कन्टेनर ट्याबहरू बन्द हुनेछन् । के तपाईँ यो कन्टेनर हटाउन निश्चित हुनुहुन्छ ?
    }

containers-remove-ok-button = यो कन्टेनर हटाउनुहोस्
containers-remove-cancel-button = यो कन्टेनर नहटाउनुहोस्


## General Section - Language & Appearance

language-and-appearance-header = भाषा र रूप

fonts-and-colors-header = फन्टहरू र रङहरू

default-font = पूर्वनिर्धारित फन्ट
    .accesskey = D
default-font-size = आकार
    .accesskey = S

advanced-fonts =
    .label = अग्रसर
    .accesskey = A

colors-settings =
    .label = रङहरू...
    .accesskey = C

language-header = भाषा

choose-language-description = देखिने पृष्ठहरूका लागि तपाईँको छनौटको भाषा छान्नुहोस्

choose-button =
    .label = छान्नुहोस् ...
    .accesskey = o

translate-web-pages =
    .label = वेब सामग्री अनुवाद गर्नुहोस्
    .accesskey = T

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = अनुवादकर्ता <img data-l10n-name="logo"/>

translate-exceptions =
    .label = अपवादहरू....
    .accesskey = x

check-user-spelling =
    .label = टाइप गर्दा गर्दै हिज्जे जाँच गर्नुहोस्
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = फाइलहरू र अनुप्रयोगहरू

download-header = डाउनलोडहरू

download-save-to =
    .label = फाइलहरू यहाँ सङ्ग्रह गर्नुहोस्
    .accesskey = v

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] चयन...
           *[other] ब्राउज...
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }

download-always-ask-where =
    .label = सधैँ फाइल कहाँ संग्रह गर्ने हो तपाईँलाई सोध्नुहोस्
    .accesskey = A

applications-header = अनुप्रयोगहरू

applications-description = कसरी { -brand-short-name } ले तपाईँले डाउनलोड गर्नुभएको फाइलहरु र तपाईँले ब्राउज गर्दा प्रयोग गर्ने अनुप्रयोगहरु ह्यान्डल गर्दछ चयन गर्नुहोस् ।

applications-filter =
    .placeholder = फाइलको प्रकार वा अनुप्रयोगहरु खोज्नुहोस्

applications-type-column =
    .label = सामग्री र तारिका
    .accesskey = T

applications-action-column =
    .label = कार्य
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } फाइल
applications-action-save =
    .label = फाइल सङ्ग्रह गर्नुहोस्

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = प्रयोग गर्नुस { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = प्रयोग { $app-name } (तत्काल)

applications-use-other =
    .label = अरु प्रयोग गर्नुहोस्…
applications-select-helper = मद्दतकर्ता अनुप्रयोग छनोट गर्नुहोस्

applications-manage-app =
    .label = एप्लिकेसन विवरणहरू
applications-always-ask =
    .label = सधै सोध्नुहोस्
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
    .label = { $plugin-name } ({ -brand-short-name } मा) प्रयोग गर्नुहोस्

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

drm-content-header = डिजिटल अधिकार व्यवस्थापन (DRM) सामग्री

play-drm-content =
    .label = DRM-नियन्त्रित सामग्री प्ले गर्नुहोस्
    .accesskey = P

play-drm-content-learn-more = अझै जान्नुहोस्

update-application-title = { -brand-short-name } अद्यावधिकहरू

update-application-description = राम्रो कार्यसम्पादन, स्थायित्व र सुरक्षाको लागि { -brand-short-name } लाई अद्यावधिक राख्नुहोस् ।

update-application-version = संस्करण { $version } <a data-l10n-name="learn-more">नयाँ के छ</a>

update-history =
    .label = अद्यावधिक इतिहास देखाउनुहोस्…
    .accesskey = p

update-application-allow-description = को लागि { -brand-short-name } लाई अनुमति दिनुहोस्

update-application-auto =
    .label = अद्यावधिकहरू स्वचालित रूपमा स्थापना गर्नुहोस् (सिफारिस गरिएको)
    .accesskey = A

update-application-check-choose =
    .label = अद्यावधिकहरूको लागि जाँच गर्नुहोस् तर तिनीहरूलाई स्थापना गर्न तपाईँलाई छान्न दिनुहोस्
    .accesskey = C

update-application-manual =
    .label = अद्यावधिकहरूको लागि कहिल्यै जाँच नगर्नुहोस् (सिफारिस नगरिएको)
    .accesskey = N

update-application-use-service =
    .label = अपडेटहरू स्थापना गर्नका लागि पृष्ठभूमि सेवाको प्रयोग गर्नुहोस्
    .accesskey = b

## General Section - Performance

performance-title = कार्यसम्पादन

performance-use-recommended-settings-checkbox =
    .label = सिफारिस गरिएको कार्यसम्पादन सेटिङ्गहरू प्रयोग गर्नुहोस्
    .accesskey = U

performance-use-recommended-settings-desc = यी सेटिङ्गहरू तपाईँको कम्प्युटरको हार्डवेयर र अपरेटिङ सिस्टम अनुरूप छन् ।

performance-settings-learn-more = अझै जान्नुहोस्

performance-allow-hw-accel =
    .label = उपलब्ध भएमा हार्डवेयर प्रवेग प्रयोग गर्नुहोस्
    .accesskey = r

performance-limit-content-process-option = सामग्री प्रक्रिया सीमा
    .accesskey = L

performance-limit-content-process-enabled-desc = थप सामग्री प्रक्रियाहरूले धेरै ट्याबहरू प्रयोग गर्दा कार्यसम्पादनमा सुधार ल्याऊँछ तर धेरै मेमोरी पनि प्रयोग गर्छ ।
performance-limit-content-process-blocked-desc = सामग्री प्रक्रियाहरूको संख्या परिमार्जन बहुप्रक्रिया { -brand-short-name } सँग मात्र सम्भव छ । <a data-l10n-name="learn-more">बहुप्रक्रिया सक्षम छ कि छैन भनेर कसरि जाँच गर्ने हो जान्नुहोस्</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (पूर्वनिर्धारित)

## General Section - Browsing

browsing-title = ब्राउजिङ्ग

browsing-use-autoscroll =
    .label = अटोस्क्रोलिङ्ग प्रयोग गर्नुहोस्
    .accesskey = a

browsing-use-smooth-scrolling =
    .label = सरर र स्क्रोल प्रयोग गर्नुहोस्
    .accesskey = m

browsing-use-onscreen-keyboard =
    .label = आवश्यकता अनुसार टच किबोर्ड देखाउनु होस्।
    .accesskey = k

browsing-use-cursor-navigation =
    .label = पृष्ठहरू सफर गर्दा जहिले पनि कर्सर किहरू प्रयोग गर्नुहोस्
    .accesskey = c

browsing-search-on-start-typing =
    .label = टाइप गर्न सुरु गरेपछि पाठ खोजी गर्नुहोस्
    .accesskey = x

## General Section - Proxy

network-proxy-connection-learn-more = अझै जान्नुहोस्

network-proxy-connection-settings =
    .label = सेटिङ्हरू…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = नयाँ संझ्याल तथा ट्याबहरू

## Home Section - Home Page Customization

home-homepage-mode-label = गृहपृष्ठ तथा नयाँ संझ्यालहरु

home-newtabs-mode-label = नयाँ ट्याबहरु

home-restore-defaults =
    .label = पूर्वानिर्धारित अवस्थामा ल्याउनुहोस्
    .accesskey = R

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox गृहपृष्ठ (पूर्वनिर्धारित)

home-mode-choice-custom =
    .label = अनुकूल URLहरू

home-mode-choice-blank =
    .label = खाली पृष्ठ

home-homepage-custom-url =
    .placeholder = URL पेस्ट गर्नुहोस्

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] अहिलेको पृष्ठ प्रयोग गर्नुहोस्
           *[other] अहिलेको पृष्ठहरू प्रयोग गर्नुहोस्
        }
    .accesskey = C

choose-bookmark =
    .label = पुस्तकचिनो प्रयोग गर्नुहोस्...
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Firefox गृह सामग्री
home-prefs-content-description = तपाईंको Firefox गृह पृष्ठमा तपाईँ कुन सामग्री राख्न चाहनुहुन्छ छान्नुहोस् ।

home-prefs-search-header =
    .label = वेब खोजि
home-prefs-topsites-header =
    .label = शीर्ष साइटहरू
home-prefs-topsites-description = तपाईंले धेरै भ्रमण गर्नुभएका साइटहरू

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = { $provider } द्वारा सिफारिस गरिएको
##


home-prefs-recommended-by-option-sponsored-stories =
    .label = प्रायोजित गरिएको कथाहरू

home-prefs-highlights-header =
    .label = विशेषताहरू
home-prefs-highlights-description = तपाईंले सुरक्षित गर्नुभएको वा भ्रमण गर्नुभएको साइटहरू
home-prefs-highlights-option-visited-pages =
    .label = भ्रमण गरिएका पृष्ठहरू
home-prefs-highlights-options-bookmarks =
    .label = पुस्तकचिनोहरू
home-prefs-highlights-option-most-recent-download =
    .label = सबैभन्दा नयाँ डाउनलोड
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name } मा सङ्ग्रह गरिएका पृष्ठहरू

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = स्निप्पेटस्
home-prefs-snippets-description = { -vendor-short-name } र { -brand-product-name } का अद्यावधिकहरू
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } पक्ति
           *[other] { $num } पक्ति
        }

## Search Section

search-bar-header = खोजीपट्टि
search-bar-hidden =
    .label = खोजी र नेभिगेसनका लागि ठेगाना पट्टी प्रयोग गर्नुहोस्
search-bar-shown =
    .label = उपकरणपट्टिमा खोजिपट्टि थप्नुहोस्

search-engine-default-header = पूर्वनिर्धारित खोजी इन्जिन

search-suggestions-option =
    .label = खोज सुझावहरू प्रदान गर्ने
    .accesskey = s

search-show-suggestions-url-bar-option =
    .label = ठेगानापट्टिको नतिजाहरूमा खोज सुझावहरू देखाउनुहोस्
    .accesskey = I

search-suggestions-cant-show = खोज इतिहास कहिले पनि लोकेसन बारमा देखिदैन किनभने { -brand-short-name } लाई कहिले पनि इतिहास नसम्झनेमा सेट गर्नुभएको छ ।

search-one-click-header = एक-क्लिक खोज इन्जिनहरू

search-one-click-desc = बैकल्पिक खोज इन्जिनहरू चयन गर्नुहोस् जुन तपाईँले खोजशब्दहरू प्रविष्ट गर्न थालेपछि ठेगानापट्टि र खोजीपट्टि को तलपट्टि देखा पर्दछ ।

search-choose-engine-column =
    .label = खोजी इन्जिन
search-choose-keyword-column =
    .label = शब्दकुञ्जी

search-restore-default =
    .label = पूर्वानिर्धारीत खोज इन्जिन पुनर्स्थापना गर्नुहोस्
    .accesskey = D

search-remove-engine =
    .label = हटाउनुहोस्
    .accesskey = R

search-find-more-link = थप खोज इन्जिनहरू फेला पार्नुहोस्

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = नक्कली शब्दकुञ्जी
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = तपाईँले चयन गर्नु भएको खोज शब्द हाल "{ $name }" ले प्रयोग गरिरहेको छ। कृपया अर्को चयन गर्नुहोस्।
search-keyword-warning-bookmark = तपाईँले चयन गर्नु भएको खोजशब्द हाल पुस्तकचिनोले प्रयोग गरिरहेको छ। कृपया अर्को चयन गर्नुहोस्।

## Containers Section

containers-header = कन्टेनर ट्याबहरू
containers-add-button =
    .label = नयाँ कन्टेनर थप्नुहोस्
    .accesskey = A

containers-preferences-button =
    .label = प्राथमिकताहरू
containers-remove-button =
    .label = हटाउनुहोस्

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = तपाईँको वेब अाफुसँगै लैजानुहोस्
sync-signedout-description = सबै यन्त्रहरूमा आफ्नो पुस्तकचिनो, इतिहास, ट्याबहरू, गोप्यशब्दहरू, एडअनहरू, र प्राथमिकताहरू समक्रमण गर्नुहोस्।

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = निम्नको लागि Firefox डाउनलोड गर्नुहोस् <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> वा <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> ‌मोबाइल यन्त्रमा समक्रमण गर्नको लागि।

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = प्रोफाइल तस्वीर परिवर्तन गर्नुहोस्

sync-manage-account = खाता व्यवस्थापन गर्नुहोस्
    .accesskey = o

sync-signedin-unverified = { $email } प्रमाणित गरिएको छैन।
sync-signedin-login-failure = कृपया पुनः जडान गर्न साइन-इन गर्नुहोस् { $email }

sync-sign-in =
    .label = साइन इन गर्नुहोस्
    .accesskey = g

## Sync section - enabling or disabling sync.


## The list of things currently syncing.


## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = पुस्तकचिनोहरू
    .accesskey = m

sync-engine-history =
    .label = इतिहास
    .accesskey = r

## The device name controls.

sync-device-name-header = यन्त्रको नामः

sync-device-name-change =
    .label = उपकरणको नाम परिवर्तन गर्नुहोस्…
    .accesskey = h

sync-device-name-cancel =
    .label = रद्द गर्नुहोस्
    .accesskey = n

sync-device-name-save =
    .label = सङ्ग्रह गर्नुहोस्
    .accesskey = v

## Privacy Section

privacy-header = ब्राउजर गोपनीयता

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

forms-exceptions =
    .label = अपवादहरू...
    .accesskey = x

forms-saved-logins =
    .label = सङ्ग्रह गरेको लग-इनहरू…
    .accesskey = L
forms-master-pw-use =
    .label = मुल गोप्यशब्द प्रयोग गर्नुहोस्
    .accesskey = U
forms-master-pw-change =
    .label = मुल गोप्यशब्द परिवर्तन गर्नुहोस्...
    .accesskey = M

forms-master-pw-fips-title = तपाईँ अहिले FIPS ढाँचामा हुनुहुन्छ। FIPSलाई खाली नभएको मुल गोप्यशब्द चाहिन्छ।

forms-master-pw-fips-desc = गोप्यशब्द परिवर्तन असफल

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
history-remember-label = { -brand-short-name } ले
    .accesskey = w

history-remember-option-all =
    .label = इतिहास सम्झिनुहोस्
history-remember-option-never =
    .label = इतिहास कहिल्यै नसम्झिनुहोस्
history-remember-option-custom =
    .label = इतिहासको लागि परिस्कृत ढाँचाहरू प्रयोग गर्नुहोस्

history-dontremember-description = { -brand-short-name } ले तपाईँको निजी ब्राउजिङ्गको सेटिङ्हरू प्रयोग गर्छ र तपाईँ को कुनै पनि ब्राउजिङ्गको कुनै पनि इतिहास सुरक्षित गर्दैन

history-private-browsing-permanent =
    .label = सधैं निजी ब्राउजिङ्ग ढाँचा प्रयोग गर्नुहोस्
    .accesskey = p

history-remember-search-option =
    .label = खोज र फारम इतिहास सम्झनुहोस्
    .accesskey = f

history-clear-on-close-option =
    .label = { -brand-short-name } बन्द हुँदा इतिहास मेटाउनुहोस्
    .accesskey = r

history-clear-on-close-settings =
    .label = ढाँचाहरू...
    .accesskey = t

## Privacy Section - Site Data

sitedata-learn-more = अझ जान्नुहोस्

sitedata-clear =
    .label = डेटा खालीगर्नुहोस्…
    .accesskey = l

## Privacy Section - Address Bar

addressbar-header = ठेगानापट्टि

addressbar-suggest = ठेगानापट्टि प्रयोग गर्दा, सुझाव दिनुहोस्

addressbar-locbar-history-option =
    .label = ब्राउजिङ्ग इतिहास
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = पुस्तकचिनोहरू
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = ट्याबहरू खोल्नुहोस्
    .accesskey = O

addressbar-suggestions-settings = खोज इन्जिन सुझावहरूका लागि प्राथमिकताहरू परिवर्तन गर्नुहोस्

## Privacy Section - Content Blocking


## These strings are used to define the different levels of
## Enhanced Tracking Protection.


##

## Privacy Section - Tracking


## Privacy Section - Permissions

permissions-header = अनुमतिहरू

permissions-location = स्थान
permissions-location-settings =
    .label = सेटिङ्गहरू…
    .accesskey = t

permissions-camera = क्यामरा
permissions-camera-settings =
    .label = सेटिङ्गहरू…
    .accesskey = t

permissions-microphone = माइक्रोफोन
permissions-microphone-settings =
    .label = सेटिङ्गहरू…
    .accesskey = t

permissions-notification = सूचनाहरू
permissions-notification-settings =
    .label = सेटिङ्गहरू…
    .accesskey = t
permissions-notification-link = अझै जान्नुहोस्

permissions-notification-pause =
    .label = { -brand-short-name } पुनःसुरु नभएसम्म सूचनाहरू रोक्नुहोस्
    .accesskey = n

permissions-block-popups =
    .label = पप-अप सञ्झ्यालहरूलाई अवरुद्द गर्नुहोस्
    .accesskey = B

permissions-block-popups-exceptions =
    .label = अपवादहरू…
    .accesskey = E

permissions-addon-install-warning =
    .label = वेबसाइटहरूले एड-अनहरू स्थापना गर्न खोज्दा तपाईँलाई चेतावनी दिनुहोस्
    .accesskey = W

permissions-addon-exceptions =
    .label = अपवादहरू...
    .accesskey = E

permissions-a11y-privacy-checkbox =
    .label = पहुँच सेवाहरूलाई तपाईँको ब्राउजरमा पहुँच लिन बाट रोक्नुहोस्
    .accesskey = a

permissions-a11y-privacy-link = अझै जान्नुहोस्

## Privacy Section - Data Collection

collection-header = { -brand-short-name } डाटा सङ्कलन र प्रयोग

collection-description = हामी तपाईँलाई छनौटहरू प्रदान गर्न प्रयास गर्दछौँ र { -brand-short-name } सबैको लागि प्रदान र सुधार गर्न हामीलाई आवश्यक कुराहरू मात्र सङ्कलन गर्दर्छौँ । व्यक्तिगत जानकारी प्राप्त गर्नुअघि हामि अनुमतिको लागि सधैँ अनुरोध गर्दछौँ ।
collection-privacy-notice = गोपनीयता नीति

collection-health-report =
    .label = { -vendor-short-name } लाई प्राविधिक र अन्तरक्रिया डाटा पठाउन { -brand-short-name } लाई अनुमति दिनुहोस्
    .accesskey = r
collection-health-report-link = अझ जान्नुहोस्

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = यस निर्माण कन्फिगरेसनको लागि डाटा रिपोर्टिङ अक्षम गरिएको छ

collection-backlogged-crash-reports-link = अझ जान्नुहोस्

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = सुरक्षा

security-browsing-protection = भ्रामक सामग्री र खतरनाक सफ्टवेयर सुरक्षा

security-enable-safe-browsing =
    .label = खतरनाक र भ्रामक सामग्री अबरुद्द गर्नुहोस
    .accesskey = B
security-enable-safe-browsing-link = अझै जान्नुहोस्

security-block-downloads =
    .label = खतरनाक डाउनलोडहरू अवरुद्ध गर्नुहोस्
    .accesskey = d

security-block-uncommon-software =
    .label = अवाञ्छित र असामान्य सफ्टवेयरको बारेमा तपाईँलाई चेतावनी दिनुहोस्
    .accesskey = C

## Privacy Section - Certificates

certs-header = प्रमाणपत्रहरू

certs-personal-label = जब एक सर्भर तपाईँको व्यक्तिगत प्रमाणपत्रको लागि अनुरोध गर्छ

certs-select-auto-option =
    .label = स्वचालित रूपमा एउटा छान्नुहोस्
    .accesskey = S

certs-select-ask-option =
    .label = तपाईँलाई हरेक पटक सोध्नुहोस्
    .accesskey = A

certs-enable-ocsp =
    .label = प्रमाणपत्रको वर्तमान वैधानिकता बारे जान्न OSCP को प्रतिक्रिया दिने सर्भरहरूलाई सोध्नुहोस्
    .accesskey = Q

certs-view =
    .label = प्रमाणपत्रहरू हेर्नुहोस्…
    .accesskey = C

certs-devices =
    .label = सुरक्षा उपकरणहरू…
    .accesskey = D

space-alert-learn-more-button =
    .label = अझै जान्नुहोस्
    .accesskey = L

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] विकल्पहरू खोल्नुहोस्
           *[other] प्राथमिकताहरू खोल्नुहोस्
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }

space-alert-under-5gb-ok-button =
    .label = ठीक छ, थाहा पाएँ
    .accesskey = K

space-alert-under-5gb-message = { -brand-short-name } लाई डिस्क स्पेसको कमि भईरहेको छ । वेबसाइट सामग्रीहरू ठीक नदेखिन सक्छन् । अझै राम्रो ब्राउजिङ्ग अनुभवको लागि डिस्क उपयोग अनुकूलन गर्न “अझै जान्नुहोस्” मा जानुहोस् ।

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = डेस्कटप
downloads-folder-name = Downloads
choose-download-folder-title = डाउनलोड फोल्डर रोज्नुहोस्:

