# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (निजी ब्राउजिङ्ग)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (निजी ब्राउजिङ्ग)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (निजी ब्राउजिङ्ग)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (निजी ब्राउजिङ्ग)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = साइट जानकारी हेर्नुहोस्

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = स्थापना सन्देश प्यानल खोल्नुहोस्
urlbar-web-notification-anchor =
    .tooltiptext = तपाईँ साइटबाट सूचनाहरू प्राप्त गर्न सक्नुहुन्छ कि सक्नुहुन्न छान्नुहोस्
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI प्यानल खोल्नुहोस्
urlbar-eme-notification-anchor =
    .tooltiptext = DRM सफ्टवेयर प्रयोग प्रबन्ध मिलाउनुहोस्
urlbar-canvas-notification-anchor =
    .tooltiptext = क्यानभस निकासको अनुमति म्यानेज गर्नुहोस्
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = यो साइटले माइक्रोफोन कसरी प्रयोग गर्छ भन्ने ब्यस्थापन गर्नुहोस्
urlbar-default-notification-anchor =
    .tooltiptext = सन्देश प्यानल खोल
urlbar-geolocation-notification-anchor =
    .tooltiptext = स्थान अनुरोध प्यानल खोल
urlbar-translate-notification-anchor =
    .tooltiptext = यो पृष्ठ अनुवाद गर्नुहोस्
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = आफ्नो साइटमा सञ्झ्याल वा स्क्रिन साझेदारीको प्रबन्ध मिलाउनुहोस्
urlbar-indexed-db-notification-anchor =
    .tooltiptext = अफलाइन सङ्ग्रह सन्देश प्यानल खोल्नुहोस्
urlbar-password-notification-anchor =
    .tooltiptext = गोप्यशब्द सङ्ग्रह सन्देश प्यानल खोल्नुहोस्
urlbar-translated-notification-anchor =
    .tooltiptext = पृष्ठ अनुवाद प्रबन्ध मिलाउनुहोस्
urlbar-plugins-notification-anchor =
    .tooltiptext = प्रयोगमा रहेका प्लगइनहरू व्यवस्थापन गर्नुहोस्
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = यो साइटको तपाईँको क्यामेरा र/अथवा माइक्रो फोन प्रयोग अधिकार ब्यवस्थापन गर्नुहोस्
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = डाटालाई लगातार भण्डारणमा राख्नुहोस्
urlbar-addons-notification-anchor =
    .tooltiptext = एडअन स्थापना सन्देश प्यानल खोल्नुहोस्

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटको लागि स्थान जानकारी अवरुद्ध गर्नु भएको छ।
urlbar-web-notifications-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटको लागि सूचनाहरू अवरुद्ध गर्नु भएको छ।
urlbar-camera-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटको लागि आफ्नो क्यामेरा अवरुद्ध गर्नु भएको छ
urlbar-microphone-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटको लागि आफ्नो माइक्रोफोन अवरुद्ध गर्नु भएको छ
urlbar-screen-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटलाई आफ्नो स्क्रिन साझा गर्न अवरुद्ध गर्नु भएको छ।
urlbar-persistent-storage-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटको लागि लगातार भण्डारण अवरुद्ध गर्नु भएको छ।
urlbar-popup-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटको लागि पपअप अवरुद्ध गर्नु भएको छ|
urlbar-canvas-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटको लागि क्यानभस डाटाको निकास अवरुद्ध गर्नु भएको छ।
urlbar-midi-blocked =
    .tooltiptext = तपाईँले यो वेबसाइटको लागि MIDI अवरुद्ध गर्नु भएको छ।
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = यस ({ $shortcut }) पुस्तकचिनोलाई सम्पादन गर्नुहोस्
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = यस पृष्ठ ({ $shortcut }) मा पुस्तकचिनो लगाउनुहोस्

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = ठेगानापट्टिमा थप्नुहोस्
page-action-manage-extension =
    .label = एक्स्टेनसन व्यवस्थित गर्नुहोस्
page-action-remove-from-urlbar =
    .label = ठेगानापट्टिबाट हटाउनुहोस्

## Auto-hide Context Menu

full-screen-autohide =
    .label = टुलबारहरू लुकाउनुहोस्
    .accesskey = H
full-screen-exit =
    .label = पूरा पर्दा बन्द गर्नुहोस्
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = खोज सेटिङ परिवर्तन गर्नुहोस्
search-one-offs-change-settings-compact-button =
    .tooltiptext = खोज सेटिङ परिवर्तन गर्नुहोस्
search-one-offs-context-open-new-tab =
    .label = नयाँ ट्याबमा खोज्नुहोस्
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = पूर्वनिर्धारित खोजी इन्जिन बनाउनुहोस्
    .accesskey = D

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-done-button =
    .label = सम्पन्न भयो

## Identity Panel

identity-connection-internal = यो सुरक्षित { -brand-short-name } पृष्ठ हो।
identity-connection-file = यो पृष्ठ तपाईँको कम्प्युटरमा भण्डारण छ।
identity-extension-page = यो पृष्ठ एक्स्टेनसन बाट लोड गरिएको हो।
identity-active-blocked = { -brand-short-name } यस पृष्ठका असुरक्षित भागहरू अवरुद्ध गरिएको छ।
identity-passive-loaded = यो पृष्ठको भागहरू सुरक्षित छैनन् (जस्तै चित्रहरू)।
identity-active-loaded = तपाईँले यो पृष्ठमा संरक्षण अक्षम गर्नुभएको छ।
identity-weak-encryption = यो पेजले कमजोर इन्क्रिप्सन प्रयोग गर्छ।
identity-insecure-login-forms = यस पृष्ठमा प्रविष्ट लगिन जानकारी सुरक्षित छैन र सम्झौता हुन सक्छ।
identity-permissions-reload-hint = परिवर्तनहरू लागू हुन पेज पुनः लोड गर्नुहोस्
identity-permissions-empty = तपाईँले यस साइटलाई कुनै विशेष अनुमति दिनुभएको छैन।
identity-remove-cert-exception =
    .label = एक्सेप्सन हटाउनुहोस्
    .accesskey = R
identity-description-insecure = तपाईँको जडान सुरक्षित छैन। तपाईँले यो साइटमा दिएको जानकारी (जस्तै गोप्यशब्दहरू, सन्देशहरू, क्रेडिट कार्डहरू, अादि) अरूले पनि देख्न सक्छन्।
identity-description-insecure-login-forms = तपाईँ यो पृष्ठमा प्रविष्ट लगिन जानकारी सुरक्षित छैन र सम्झौता हुन सक्छ।
identity-description-weak-cipher-intro = यो वेवसाइटसँगको तपाईँको जडान कमजोर इन्क्रिप्सन प्रयोग गर्छ र जडान सुरक्षित छैन।
identity-description-weak-cipher-risk = अरू मानिसहरूले तपाईँको जानकारी हेर्नसक्छन् र वेबसाइटको व्यवहार परिवर्तन गर्न सक्छन्।
identity-description-active-blocked = { -brand-short-name } यस पृष्ठका असुरक्षित भागहरू अवरुद्ध गरिएको छ। <label data-l10n-name="link">थप जान्नुहोस्</label>
identity-description-passive-loaded = तपाईँको जडान सुरक्षित छैन र तपाईँले आदान प्रदान गर्ने जानकारी अरुले पनि हेर्न सक्छन्।
identity-description-passive-loaded-insecure = यो वेबसाइटमा सामग्री सुरक्षित छैन (जस्तै तस्विरहरू)। <label data-l10n-name="link">थप जान्नुहोस्</label>
identity-description-passive-loaded-mixed = { -brand-short-name } मा रहेका केही सामग्रीहरू रोकिएको भए पनि त्यहाँ असुरक्षित सामग्री (जस्तै तस्विरहरू) छन्। <label data-l10n-name="link">थप जान्नुहोस्</label>
identity-description-active-loaded = यो वेबसाइटमा सुरक्षित सामग्री छैन (जस्तै स्क्रिप्टहरू) र तपाईँको जडान निजी पनि छैन।
identity-description-active-loaded-insecure = तपाईँले यो साइटमा दिएको जानकारी (जस्तै गोप्यशब्दहरू, सन्देशहरू, क्रेडिट कार्डहरू, अादि) अरूले पनि देख्न सक्छन्।
identity-learn-more =
    .value = थप जान्नुहोस्
identity-disable-mixed-content-blocking =
    .label = सुरक्षा खारेज गर्नुहोस्
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = सुरक्षा सक्षम
    .accesskey = E
identity-more-info-link-text =
    .label = थप जानकारी

## Window controls

browser-window-minimize-button =
    .tooltiptext = सानो गर्नुहोस्
browser-window-close-button =
    .tooltiptext = बन्द गर्नुहोस्

## WebRTC Pop-up notifications

popup-select-camera =
    .value = क्यामेरलाई बाँड्ने:
    .accesskey = C
popup-select-microphone =
    .value = साझेदारी गर्नुपर्ने माइक्रोफोन:
    .accesskey = M
popup-all-windows-shared = तपाईँको स्क्रिन मा सबै देखिने सञ्झ्यालहरू साझेदारी गरिनेछ।

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = खोज वा ठेगाना राखनुहोस्।
urlbar-placeholder =
    .placeholder = खोज वा ठेगाना राखनुहोस्।
urlbar-remote-control-notification-anchor =
    .tooltiptext = ब्राउजर रिमोट कंट्रोल अन्तर्गत छ
urlbar-switch-to-tab =
    .value = यस ट्याबमा स्विच गर्नुहोस्:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = एक्सटेन्सन:
urlbar-go-button =
    .tooltiptext = लोकेसन बारमा भएको स्थानमा जानुहोस्
urlbar-page-action-button =
    .tooltiptext = पृष्ठ कार्यहरु

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> पुरा स्क्रिन अहिले भयो
fullscreen-warning-no-domain = तपाईँको खाता पुरा पर्दाको भएको छ
fullscreen-exit-button = पुरा पर्दाबाट निस्कनुहोस् (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = पुरा स्क्रिनबाट निस्कनुहोस (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> तपाईँको सूचक नियन्त्रण बाहिर छ। नियन्त्रण आफ्नो नियन्त्रणमा ल्याउन Esc थिच्नुहोस्।
pointerlock-warning-no-domain = तपाईँको पोइन्टर यो डकुमेन्टको नियन्त्रणमा छ। नियन्त्रण फिर्ता लिन Esc थिच्नुहोस्।
