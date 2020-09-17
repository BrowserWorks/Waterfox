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
    .data-title-private = { -brand-full-name } (निजी ब्राउज़िंग)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (निजी ब्राउज़िंग)
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
    .data-title-private = { -brand-full-name } - (निजी ब्राउज़िंग)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (निजी ब्राउज़िंग)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = साइट की जानकारी देखें

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = संस्थापित संदेश पटल खोलें
urlbar-web-notification-anchor =
    .tooltiptext = परिवर्तन करें ताकी आप साइटों से सूचनाएं प्राप्त कर सकते हैं
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI पैनल खोलें
urlbar-eme-notification-anchor =
    .tooltiptext = DRM सॉफ्टवेयर का उपयोग प्रबंधित करे
urlbar-web-authn-anchor =
    .tooltiptext = वेब प्रमाणीकरण पैनल को खोले
urlbar-canvas-notification-anchor =
    .tooltiptext = कैनवास निष्कर्षण अनुमति का प्रबंधन करें
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = साइट के साथ अपने माइक्रोफोन बांटने की व्यवस्था प्रबंधित करें
urlbar-default-notification-anchor =
    .tooltiptext = संदेश पटल खोलें
urlbar-geolocation-notification-anchor =
    .tooltiptext = स्थान अनुरोध पटल खोलें
urlbar-xr-notification-anchor =
    .tooltiptext = वर्चुअल रियलिटी अनुमति पैनल खोलें
urlbar-storage-access-anchor =
    .tooltiptext = ब्राउज़िंग गतिविधि अनुमति पैनल खोलें
urlbar-translate-notification-anchor =
    .tooltiptext = इस पृष्ठ का अनुवाद करें
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = साइट के साथ अपनी विंडोज या स्क्रीन साझा प्रबंधित करें
urlbar-indexed-db-notification-anchor =
    .tooltiptext = ऑफलाइन संग्रह संदेश पटल खोलें
urlbar-password-notification-anchor =
    .tooltiptext = सहेजा हुआ कुष्टशब्द संदेश पटल खोलें
urlbar-translated-notification-anchor =
    .tooltiptext = पृष्ठ अनुवाद प्रंबंधित करें
urlbar-plugins-notification-anchor =
    .tooltiptext = प्लग-इन उपयोग को प्रबंधित करें
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = साइट के साथ अपने कैमरे और/या माइक्रोफोन बांटने की व्यवस्था प्रबंधित करें
urlbar-autoplay-notification-anchor =
    .tooltiptext = ऑटोप्ले पैनल खोलें
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = स्थायी संग्रहण में आँकड़े संचित करें
urlbar-addons-notification-anchor =
    .tooltiptext = सहयुक्ति संस्थापन संदेश पटल खोलें
urlbar-tip-help-icon =
    .title = सहायता प्राप्त करें
urlbar-search-tips-confirm = ठीक है, समझ गया
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = सुझाव:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = कम टाइप करें, अधिक खोजें: सीधे अपने पता पट्टी { $engineName } खोजें.
urlbar-search-tips-redirect-2 = { $engineName } और अपने ब्राउज़िंग इतिहास से सुझाव देखने के लिए अपनी खोज पता पट्टी में प्रारंभ करें।

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = बुकमार्क
urlbar-search-mode-tabs = टैब
urlbar-search-mode-history = इतिहास

##

urlbar-geolocation-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए स्थान की सूचना अवरुद्ध किये है.
urlbar-xr-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए वर्चुअल रियलिटी डिवाइस एक्सेस को ब्लॉक कर दिया है।
urlbar-web-notifications-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए अधिसूचना अवरुद्ध किये है.
urlbar-camera-blocked =
    .tooltiptext = आप इस वेबसाइट के लिए अपने कैमरा को अवरूद्ध किये हैं.
urlbar-microphone-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए अपने माइक्रोफ़ोन को अवरूद्ध किया है.
urlbar-screen-blocked =
    .tooltiptext = आपने अपने स्क्रीन को साझा करने से इस वेबसाइट को अवरूद्ध किया हैं.
urlbar-persistent-storage-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए सतत संग्रहण को अवरुद्ध किया है.
urlbar-popup-blocked =
    .tooltiptext = आपने इस वेबसाइट पर पॉप-अप अवरुद्ध किए हैं.
urlbar-autoplay-media-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए धवनी के साथ ऑटोप्ले मीडिया को अवरुद्ध कर दिया है.
urlbar-canvas-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए कैनवास डेटा निष्कर्षण को अवरोधित किया है.
urlbar-midi-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए MIDI उपयोग अवरुद्ध कर दिया है.
urlbar-install-blocked =
    .tooltiptext = आपने इस वेबसाइट के लिए ऐड-ऑन संस्थापन को अवरूद्ध कर दिया है।
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = यह बुकमार्क संपादित करें ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = यह पृष्ठ बुकमार्कित करें ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = पतापट्टी में जोड़े
page-action-manage-extension =
    .label = एक्सटेंशन प्रबंधित करें …
page-action-remove-from-urlbar =
    .label = पतापट्टी से हटायें
page-action-remove-extension =
    .label = एक्सटेंशन हटाएं

## Auto-hide Context Menu

full-screen-autohide =
    .label = औज़ारपट्टी छिपाएँ
    .accesskey = H
full-screen-exit =
    .label = पूर्ण स्क्रीन मोड से बाहर निकलें
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = इस बार, इसके साथ खोजें:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = खोज सेटिंग बदलाव
search-one-offs-change-settings-compact-button =
    .tooltiptext = खोज सेटिंग बदले
search-one-offs-context-open-new-tab =
    .label = नया टैब में खोजें
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = डिफ़ॉल्ट ख़ोज इंजिन की तरह स्थापित करें
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = निजी विंडो के लिए तयशुदा खोज इंजन के रूप में सेट करें
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = बुकमार्क ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = टैब ({ $restrict })
search-one-offs-history =
    .tooltiptext = इतिहास ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = सहेजते समय संपादक दिखाएं
    .accesskey = S
bookmark-panel-done-button =
    .label = संपन्न
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = संपर्क सुरक्षित नहीं है
identity-connection-secure = संपर्क सुरक्षित है
identity-connection-internal = यह एक सुरक्षित { -brand-short-name } पेज हैं.
identity-connection-file = यह पेज आपके कंप्यूटर में सहेजा जाता हैं.
identity-extension-page = यह पृष्ठ एक्सटेंशन से लोड किया गया है.
identity-active-blocked = { -brand-short-name } इस पृष्ठ के कुछ हिस्सों को अवरुद्ध कर दिया है जो सुरक्षित नहीं हैं.
identity-custom-root = कनेक्शन को उस प्रमाणपत्र जारीकर्ता द्वारा सत्यापित है जिसे Mozilla द्वारा मान्यता प्राप्त नहीं है।
identity-passive-loaded = इस पेज का भाग सुरक्षित नहीं हैं(जैसा की छवि).
identity-active-loaded = आपने इस पेज पर सुरक्षा निष्क्रिय कर दिए हैं.
identity-weak-encryption = यह पेज कमजोर गोपन का उपयोग करता हैं.
identity-insecure-login-forms = इस पृष्ठ पर अंतरित लॉग-इन्स से समझौता किया जा सकता है.
identity-permissions =
    .value = अनुमतियां
identity-permissions-reload-hint = बदलाव को लागु करने के लिए आपको पृष्ठ को फिर से लोड करने की आवश्यकता हैं.
identity-permissions-empty = आपने इस साइट को कोई विशेष अनुमति नहीं दी है.‌‌‌
identity-clear-site-data =
    .label = कूकीज़ तथा साइट डेटा हटायें…
identity-connection-not-secure-security-view = आप इस साइट से सुरक्षित रूप से नहीं जुड़े हैं।
identity-connection-verified = आप इस साइट से सुरक्षित रूप से जुड़े हैं।
identity-ev-owner-label = इसे प्रमाणपत्र जारी किया गया:
identity-description-custom-root = Mozilla इस प्रमाणपत्र जारीकर्ता को नहीं पहचानता है। यह आपके ऑपरेटिंग सिस्टम से या किसी ऐडमिनिस्ट्रेटर द्वारा जोड़ा जा सकता है। <label data-l10n-name="link">अधिक जानें</label>
identity-remove-cert-exception =
    .label = अपवाद मिटाएँ
    .accesskey = R
identity-description-insecure = इस साइट पे आपका कनेक्शन निजी नहीं हैं. सुचना जो आप जमा करते हैं दुसरो के द्वारा देखा जा सकता (जैसे पासवर्ड,संदेश, क्रेडिट कार्ड, इत्यादि.).
identity-description-insecure-login-forms = आपके द्वारा इस पृष्ट में दी गयी जानकारी सुरक्षित नहीं है तथा उसका गलत इस्तेमाल किया जा सकता है
identity-description-weak-cipher-intro = इस वेबसाइट से आपका कनेक्शन कमज़ोर गोपन का उपयोग करता है और निजी नहीं है.
identity-description-weak-cipher-risk = अन्य लोग आपकी जानकारी को देख सकते हैं या वेबसाइट के व्यवहार को बदल सकते हैं.
identity-description-active-blocked = { -brand-short-name } इस पृष्ठ के कुछ हिस्सों को अवरुद्ध कर दिया है जो सुरक्षित नहीं हैं. <label data-l10n-name="link">अधिक सीखे</label>
identity-description-passive-loaded = आपका कनेक्शन निजी नही हैं और सुचना जो आप इस साइट के साथ साझा करते है दुसरो के द्वारा देखा जा सकता.
identity-description-passive-loaded-insecure = यह वेबसाइट वह सामग्री शामिल करता है जो सुरक्षित नहीं हैं(जैसा की छवि). <label data-l10n-name="link">अधिक सीखे</label>
identity-description-passive-loaded-mixed = हालांकि { -brand-short-name } ने कुछ सामग्री को रोक दिया है, इस पृष्ठ पर कुछ ऐसी सामग्री है जो असुरक्षित है (जैसे कि छवियाँ). <label data-l10n-name="link">अधिक सीखे</label>
identity-description-active-loaded = यह वेबसाइट उस सामग्री को सम्मिलित करता है जो सुरक्षित नही हैं(जैसा की स्क्रिप्ट) और कनेक्शन भी निजी नही हैं.
identity-description-active-loaded-insecure = सुचना जो आप इस साइट के साथ साझा करते हैं दुसरो के द्वारा देखा जा सकता (जैसे पासवर्ड,संदेश, क्रेडिट कार्ड, इत्यादि.).
identity-learn-more =
    .value = अधिक सीखे
identity-disable-mixed-content-blocking =
    .label = अब सुरक्षा निष्क्रिय करें
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = सुरक्षा सक्रिय करें
    .accesskey = स
identity-more-info-link-text =
    .label = अधिक सूचना

## Window controls

browser-window-minimize-button =
    .tooltiptext = न्यूनतम करें
browser-window-maximize-button =
    .tooltiptext = बड़ा करें
browser-window-restore-down-button =
    .tooltiptext = पूर्ववत करें
browser-window-close-button =
    .tooltiptext = बंद करें

## WebRTC Pop-up notifications

popup-select-camera =
    .value = साझा करने के लिए कैमरा:
    .accesskey = C
popup-select-microphone =
    .value = साझा करने के लिए माइक्रोफोन:
    .accesskey = M
popup-all-windows-shared = आपके स्क्रीन पर सभी दृश्य विंडो साझा किए जाएँगे.
popup-screen-sharing-not-now =
    .label = अभी नहीं
    .accesskey = w
popup-screen-sharing-never =
    .label = कभी अनुमति न दें
    .accesskey = N
popup-silence-notifications-checkbox = साझा करते समय { -brand-short-name } से अधिसूचना अक्षम करें
popup-silence-notifications-checkbox-warning = साझा करते समय { -brand-short-name } आपके नोटिफिकेशन को प्रदर्शित नहीं करेगा।

## WebRTC window or screen share tab switch warning

sharing-warning-window = आप { -brand-short-name } को साझा कर रहे हैं। नए टैब पर जाने पर अन्य व्यक्ति इसे देख सकता है।
sharing-warning-screen = आप पूरी स्क्रीन साझा कर रहे हैं। नए टैब पर जाने पर अन्य व्यक्ति इसे देख सकता है।
sharing-warning-disable-for-session =
    .label = इस सत्र के लिए साझाकरण सुरक्षा अक्षम करें

## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = खोजें या पता दर्ज करें
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = खोजें या पता दर्ज करें
urlbar-remote-control-notification-anchor =
    .tooltiptext = ब्राउज़र रिमोट कंट्रोल के तहत है
urlbar-switch-to-tab =
    .value = टैब में जाएँ:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = विस्तारक:
urlbar-go-button =
    .tooltiptext = स्थान पट्टी पर पता में जाएँ
urlbar-page-action-button =
    .tooltiptext = पृष्ठ क्रियाएँ
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name } में सहेजें

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> अब पूर्ण स्क्रीन है
fullscreen-warning-no-domain = यह दस्तावेज़ अब पूर्ण स्क्रीन पर है
fullscreen-exit-button = पूर्ण स्क्रीन से निकलें (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = पूर्ण स्क्रीन से निकलें (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> अपने सूचक पर नियंत्रण हैं. नियंत्रण फिर से वापस लेने के लिए Esc बटन दबाएँ.
pointerlock-warning-no-domain = इस दस्तेवाज को आपके सूचक पर नियंत्रण हैं. नियंत्रण फिर से वापस लेने के लिए Esc बटन दबाएँ.
