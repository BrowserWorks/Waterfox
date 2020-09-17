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
    .data-title-private = { -brand-full-name } (खाजगी ब्राउझिंग)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (खाजगी ब्राउझिंग)
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
    .data-title-private = { -brand-full-name } - (खाजगी ब्राउझिंग)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (खाजगी ब्राउझिंग)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = संकेतस्थळाची माहिती पहा

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = प्रतिष्ठापन संदेश फलक उघडा
urlbar-web-notification-anchor =
    .tooltiptext = साईटने आपल्याला सूचना दर्शवाव्या किंवा कसे यासाठी योग्य बदल करा
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI पटल उघडा
urlbar-eme-notification-anchor =
    .tooltiptext = DRM सॉफ्टवेअर वापराचे व्यवस्थापन करा
urlbar-web-authn-anchor =
    .tooltiptext = वेब अनुज्ञापन फलक उघडा
urlbar-canvas-notification-anchor =
    .tooltiptext = कॅनव्हस एक्सट्रॅकशन च्या परवानग्या व्यवस्थापित करा
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = साइटवर आपला मायक्रोफोन शेअर करण्याचे व्यवस्थापन करा
urlbar-default-notification-anchor =
    .tooltiptext = संदेश फलक उघडा
urlbar-geolocation-notification-anchor =
    .tooltiptext = स्थळ विनंती फलक उघडा
urlbar-translate-notification-anchor =
    .tooltiptext = पृष्ठाचे भाषांतर करा
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = साइटवर आपली विंडो किंवा स्क्रीन शेअर करण्याचे व्यवस्थापन करा
urlbar-indexed-db-notification-anchor =
    .tooltiptext = ऑफलाईन साठ्याचा संदेश फलक उघडा
urlbar-password-notification-anchor =
    .tooltiptext = साठवलेल्या पासवर्डसचा संदेश फलक उघडा
urlbar-translated-notification-anchor =
    .tooltiptext = पृष्ठाच्या अनुवादाचे व्यवस्थापन करा
urlbar-plugins-notification-anchor =
    .tooltiptext = प्लग-इनचा वापर व्यवस्थापित करा
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = साइटवर आपला कॅमेरा आणि /किंवा मायक्रोफोन शेअर करण्याचे व्यवस्थापन करा
urlbar-autoplay-notification-anchor =
    .tooltiptext = स्वयंप्ले पॅनल उघडा
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = पर्सिस्टन्ट स्टोरेजमध्ये माहिती साठवा
urlbar-addons-notification-anchor =
    .tooltiptext = अॅड-ऑन प्रतिष्ठापन संदेश फलक उघडा
urlbar-tip-help-icon =
    .title = मदत मिळवा

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = टाईप कमी करा आणि जास्त शोधा: थेट आपल्या पत्ता पट्टी वरून { $engineName } शोधा.

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = आपण ह्या वेबसाईटसाठी स्थळाची माहिती अवरोधित केली आहे.
urlbar-web-notifications-blocked =
    .tooltiptext = आपण ह्या वेबसाइटसाठी सूचना अवरोधित केल्या आहे.
urlbar-camera-blocked =
    .tooltiptext = आपण ह्या वेबसाईटसाठी आपला कॅमेरा अवरोधित केला आहे.
urlbar-microphone-blocked =
    .tooltiptext = आपण ह्या वेबसाईटसाठी आपला मायक्रोफोन अवरोधित केला आहे.
urlbar-screen-blocked =
    .tooltiptext = ह्या वेबसाईटला आपण आपली स्क्रीन शेअर करण्यापासून अवरोधित केले आहे.
urlbar-persistent-storage-blocked =
    .tooltiptext = आपण दीर्घस्थायी स्टोरेज ह्या वेबसाईटसाठी अवरोधित केला आहे.
urlbar-popup-blocked =
    .tooltiptext = ह्या संकेतस्थळासाठी आपण पॉप-अप अडवले आहेत.
urlbar-canvas-blocked =
    .tooltiptext = आपण ह्या वेबसाइटसाठी कॅनव्हास डेटा उतारा अवरोधित केला आहे.
urlbar-midi-blocked =
    .tooltiptext = या संकेतस्थळासाठी MIDI वापर अवरोधित केला आहे.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = ही वाचनखूण ({ $shortcut }) संपादीत करा
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = या पृष्ठाला वाचनखूण लावा ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = पत्ता पट्टी मध्ये जोडा
page-action-manage-extension =
    .label = एक्सटेन्शन व्यवस्थापित करा…
page-action-remove-from-urlbar =
    .label = पत्ता पट्टीमधून काढा

## Auto-hide Context Menu

full-screen-autohide =
    .label = साधनपट्टी लपवा
    .accesskey = H
full-screen-exit =
    .label = पडदाभर मोडपासून बाहेर पडा
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = यावेळी, यासह शोधा:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = शोध सेटिंग बदला
search-one-offs-change-settings-compact-button =
    .tooltiptext = शोध सेटिंगस बदला
search-one-offs-context-open-new-tab =
    .label = नवीन टॅबमध्ये शोधा
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = पूर्वनिर्धारित शोध इंजिन म्हणून ठरवा
    .accesskey = D

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = जतन करतांना संपादक दर्शवा
    .accesskey = S
bookmark-panel-done-button =
    .label = झाले
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = असुरक्षित जोडणी
identity-connection-secure = जोडणी सुरक्षित
identity-connection-internal = हे सुरक्षित { -brand-short-name } पृष्ठ आहे.
identity-connection-file = हे पृष्ठ आपल्या संगणकावर संचयीत केले गेले आहे.
identity-extension-page = हे पृष्ठ एका विस्तारापासून लोड केलेले आहे.
identity-active-blocked = { -brand-short-name } ने ह्या पृष्ठावरील काही असुरक्षित भाग अडवले आहेत.
identity-passive-loaded = या पृष्ठावरील काही भाग (उदा. प्रतिमा) सुरक्षित नाहीत.
identity-active-loaded = आपण ह्या पृष्ठावरील सुरक्षा बंद केली आहे.
identity-weak-encryption = हे पृष्ठ कमकुवत एनक्रिप्शन वापरते.
identity-insecure-login-forms = आपण ह्या पृष्ठावर दिलेल्या लॉग इन माहितीबरोबर तडजोड होऊ शकते.
identity-permissions =
    .value = परवानग्या
identity-permissions-reload-hint = आपल्याला बदल लागू करण्यासाठी पृष्ठ पुन्हा लोड करावे लागू शकते.
identity-permissions-empty = आपण ह्या साईटला काही विशेष परवानग्या दिलेल्या नाहीत.
identity-clear-site-data =
    .label = कुकीज आणि साईट माहिती पुसा…
identity-connection-not-secure-security-view = आपण या साइटशी सुरक्षितपणे कनेक्ट केलेले नाही.
identity-connection-verified = आपण या साइटशी सुरक्षितपणे कनेक्ट केले आहे.
identity-ev-owner-label = यांना प्रमाणपत्र दिले:
identity-remove-cert-exception =
    .label = अपवाद काढा
    .accesskey = R
identity-description-insecure = ह्या साईटवरची आपली जोडणी खाजगी नाही. आपण जी माहिती जमा करता आहात (जसे कि पासवर्ड, संदेश, क्रेडीट कार्ड इत्यादी) ते इतर लोक पाहू शकतात.
identity-description-insecure-login-forms = ह्या पृष्ठावर आपण दिलेली लॉग इन माहिती सुरक्षित नसून त्याबरोबर तडजोड होऊ शकते.
identity-description-weak-cipher-intro = ह्या वेबसाइट बरोबरची आपली जोडणी कमकुवत एनक्रिप्शन वापरत असून ती खाजगी नाही.
identity-description-weak-cipher-risk = इतर लोक आपली माहिती पाहू शकतात किंवा वेबसाईटचे वर्तन बदलू शकतात.
identity-description-active-blocked = { -brand-short-name } ने ह्या पृष्ठावरील काही असुरक्षित भाग अडवले आहेत. <label data-l10n-name="link">अधिक जाणा</label>
identity-description-passive-loaded = ह्या साईटवरची आपली जोडणी खाजगी नाही. आपण जी माहिती जमा करता आहात ते इतर लोक पाहू शकतात.
identity-description-passive-loaded-insecure = या वेबसाईटवरील काही भाग (उदा. प्रतिमा) सुरक्षित नाही. <label data-l10n-name="link">अधिक जाणा</label>
identity-description-passive-loaded-mixed = { -brand-short-name }ने काही भाग अडवले असले, तरी ह्या पृष्ठावर काही असुरक्षित आशय आहेत (उदा. प्रतिमा). <label data-l10n-name="link">अधिक जाणा</label>
identity-description-active-loaded = या वेबसाईटवरील काही भाग (उदा. स्क्रिप्ट्स) सुरक्षित नाही आणि आपली जोडणी खाजगी नाही आहे.
identity-description-active-loaded-insecure = आपण जी माहिती जमा करता आहात (जसे कि पासवर्ड, संदेश, क्रेडीट कार्ड माहिती, इत्यादी) ते इतर लोक पाहू शकतात.
identity-learn-more =
    .value = अधिक जाणा
identity-disable-mixed-content-blocking =
    .label = सद्या सुरक्षा निष्क्रिय करा
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = सुरक्षा सक्रीय करा
    .accesskey = E
identity-more-info-link-text =
    .label = अधिक माहिती

## Window controls

browser-window-minimize-button =
    .tooltiptext = छोटे करा
browser-window-close-button =
    .tooltiptext = बंद करा

## WebRTC Pop-up notifications

popup-select-camera =
    .value = शेअर करण्याजोगी कॅमेरा:
    .accesskey = C
popup-select-microphone =
    .value = शेअर करण्याजोगी माइक्रोफोन:
    .accesskey = M
popup-all-windows-shared = पडद्यावरील सर्व दृष्यास्पद पटलांना शेअर केले जाईल.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = शोधा किंवा पत्ता द्या
urlbar-placeholder =
    .placeholder = शोधा किंवा पत्ता द्या
urlbar-remote-control-notification-anchor =
    .tooltiptext = ब्राउझर दूरस्थ नियंत्रणामध्ये आहे
urlbar-switch-to-tab =
    .value = टॅबचा वापर करा:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = एक्सटेंशन:
urlbar-go-button =
    .tooltiptext = स्थान पट्टीतील पत्त्यावर जा
urlbar-page-action-button =
    .tooltiptext = पृष्ठाच्या कृती
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name } मध्ये जतन करा

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> आता पूर्ण स्क्रीन आहे
fullscreen-warning-no-domain = हे दस्तऐवज आता पूर्ण स्क्रीन झाले आहे
fullscreen-exit-button = पूर्ण स्क्रीनमधून बाहेर पडा (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = पूर्ण स्क्रीनमधून बाहेर पडा (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> कडे आपल्या पॉईंटरचे नियंत्रण आहे. नियंत्रण परत घेण्यासाठी Esc दाबा.
pointerlock-warning-no-domain = ह्या दस्तऐवजाकडे आपल्या पॉईंटरचे नियंत्रण आहे. नियंत्रण परत घेण्यासाठी Esc दाबा.
