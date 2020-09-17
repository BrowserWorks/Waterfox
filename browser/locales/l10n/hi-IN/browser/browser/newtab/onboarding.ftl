# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = अधिक जानें
onboarding-button-label-get-started = आरंभ करें

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } में स्वागत है
onboarding-welcome-body = आपको ब्राउज़र मिल गया है। <br/> बाकी { -brand-product-name } के बारे में जानें।
onboarding-welcome-learn-more = लाभ के बारे में अधिक जानें।
onboarding-welcome-modal-get-body = आपको ब्राउज़र मिल गया है।<br/>अब { -brand-product-name } का अधिकतम लाभ उठाएँ।
onboarding-welcome-modal-supercharge-body = अपनी गोपनीयता सुरक्षा को बढ़ाएँ।
onboarding-welcome-modal-privacy-body = आपको ब्राउज़र मिल गया है। आइए अधिक गोपनीयता सुरक्षा जोड़ें।
onboarding-welcome-modal-family-learn-more = उत्पादों के { -brand-product-name } परिवार के बारे में जानें।
onboarding-welcome-form-header = यहां से शुरू करें

onboarding-join-form-body = प्रारंभ करने के लिए ईमेल का पता प्रविष्ट करें।
onboarding-join-form-email =
    .placeholder = ईमेल दर्ज करें
onboarding-join-form-email-error = वैध ईमेल की ज़रूरत
onboarding-join-form-legal = आगे बढ़ते हुए, आप <a data-l10n-name="terms"> सेवा की शर्तों </a> और <a data-l10n-name="privacy"> गोपनीयता सूचना </a> से सहमत होते हैं।
onboarding-join-form-continue = जारी रखें

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = पहले से ही एक खाता है?
# Text for link to submit the sign in form
onboarding-join-form-signin = साइन इन

onboarding-start-browsing-button-label = ब्राउज़िंग शुरू करें
onboarding-cards-dismiss =
    .title = निरस्त करें
    .aria-label = निरस्त करें

## Multistage 3-screen onboarding flow strings (about:welcome pages)

onboarding-multistage-welcome-primary-button-label = सेटअप प्रारंभ करें
onboarding-multistage-welcome-secondary-button-label = साइन इन
onboarding-multistage-welcome-secondary-button-text = खाता पहले से है?

onboarding-multistage-import-primary-button-label = आयात शुरू करें
onboarding-multistage-import-secondary-button-label = अभी नहीं

onboarding-multistage-theme-secondary-button-label = अभी नहीं

# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = स्वचालित

# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


## Welcome full page string

onboarding-fullpage-welcome-subheader = आइए आप जो कुछ भी कर सकते हैं, उसकी खोज शुरू करें।
onboarding-fullpage-form-email =
    .placeholder = आपका ईमेल पता…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = अपने साथ { -brand-product-name } चुने
onboarding-sync-welcome-content = अपने सभी उपकरणों पर अपना बुकमार्क, इतिहास, कूटशब्द और अन्य सेटिंग प्राप्त करें.
onboarding-sync-welcome-learn-more-link = Firefox खातों के बारे में अधिक जानें

onboarding-sync-form-input =
    .placeholder = ईमेल

onboarding-sync-form-continue-button = जारी रखें
onboarding-sync-form-skip-login-button = इस चरण को छोड़ दें

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = अपना ईमेल प्रविष्ट करें
onboarding-sync-form-sub-header = { -sync-brand-name } को जारी रखने के लिए


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = अपने उपकरणों में आपकी गोपनीयता का सम्मान करने वाले उपकरणों के परिवार के साथ काम करें।

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = हम जो कुछ भी करते हैं वह हमारे व्यक्तिगत डेटा वादा का सम्मान करता है: कम लें। उसे सुरक्षित रखें। कोई रहस्य नहीं।

onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = आप जहां भी { -brand-product-name } का उपयोग करते हैं वहां अपने बुकमार्क, पासवर्ड, इतिहास तथा अन्य चीज़ों को ले जाएं।

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = आपकी व्यक्तिगत जानकारी किसी ज्ञात डेटा उल्लंघन में होने पर सूचना प्राप्त करें।

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = पासवर्ड प्रबंधित करें जो संरक्षित और वहनीय हैं।


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = ट्रैकिंग से सुरक्षा
onboarding-tracking-protection-text2 = { -brand-short-name } वेबसाइटों को ऑनलाइन आपको ट्रैक करने से रोकने में मदद करता है, जिससे विज्ञापनों के लिए वेब पर आपका अनुसरण करना कठिन हो जाता है।
onboarding-tracking-protection-button2 = यह किस प्रकार काम करता है

onboarding-data-sync-title = अपनी सेटिंग्स अपने साथ ले जाएं
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = आप जहां भी { -brand-product-name } का उपयोग करते हैं वहां अपने बुकमार्क, पासवर्ड तथा अन्य चीज़ों को सिंक करें।
onboarding-data-sync-button2 = { -sync-brand-short-name } में साइन इन करें

onboarding-firefox-monitor-title = डेटा ब्रीच से अलर्ट रहें
onboarding-firefox-monitor-button = अलर्ट के लिए साइन अप करें

onboarding-browse-privately-title = निजी तौर पर ब्राउज़ करें
onboarding-browse-privately-text = निजी ब्राउजिंग आपके कंप्यूटर को इस्तेमाल करने वाले किसी व्यक्ति से गुप्त रखने के लिए आपकी खोज और ब्राउज़िंग इतिहास को साफ़ करता है।
onboarding-browse-privately-button = एक निजी विंडो खोलें

onboarding-firefox-send-title = अपने साझा फ़ाइलें निजी रखें
onboarding-firefox-send-text2 = एंड-टू-एंड एन्क्रिप्शन और स्वचालित रूप से समाप्त होने वाले लिंक के साथ साझा करने के लिए अपनी फ़ाइलों को{ -send-brand-name } पर अपलोड करें।
onboarding-firefox-send-button = { -send-brand-name } आज़माएं

onboarding-mobile-phone-title = अपने फ़ोन पर { -brand-product-name } प्राप्त करें
onboarding-mobile-phone-text = IOS या Android के लिए { -brand-product-name } डाउनलोड करें और अपने डेटा को उपकरणों में सिंक करें।
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = मोबाइल ब्राउज़र डाउनलोड करें

onboarding-send-tabs-title = तुरंत अपने आप को टैब्स भेजें
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = लिंक कॉपी किए या ब्राउज़र छोड़े बिना आसानी से अपने उपकरणों के बीच पृष्ठ साझा करें।
onboarding-send-tabs-button = Send Tabs का उपयोग करना शुरू करें

onboarding-pocket-anywhere-title = कहीं भी पढ़ें और सुनें
onboarding-pocket-anywhere-text2 = अपने पसंदीदा सामग्री को { -pocket-brand-name } ऐप के साथ ऑफ़लाइन सहेजें और जब भी यह आपके लिए सुविधाजनक हो, तो पढ़ें और देखें।
onboarding-pocket-anywhere-button = { -pocket-brand-name } आज़माएं

onboarding-lockwise-strong-passwords-title = मजबूत पासवर्ड बनाएं और संग्रहित करें
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } उसी वक्त मजबूत पासवर्ड बनाता है और उन सभी को एक जगह सहेजता है।
onboarding-lockwise-strong-passwords-button = अपने लॉगिन का प्रबंधन करें

onboarding-facebook-container-title = Facebook के साथ सीमाएँ निर्धारित करें
onboarding-facebook-container-text2 = { -facebook-container-brand-name } आपकी प्रोफ़ाइल को हर चीज से अलग रखता है, जिससे Facebook के लिए आपको विज्ञापनों के साथ लक्षित करना कठिन हो जाता है।
onboarding-facebook-container-button = एक्सटेंशन जोड़ें

onboarding-import-browser-settings-title = अपने बुकमार्क, पासवर्ड और अधिक आयात करें
onboarding-import-browser-settings-button = Chrome डेटा आयात करें

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = महान, { -brand-short-name }आपको  मिला है

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = अब आपके लिए <icon></icon><b>{ $addon-name } प्राप्त करते हैं।</b>
return-to-amo-extension-button = एक्सटेंशन जोड़ें
return-to-amo-get-started-button = { -brand-short-name } से शुरुवात करें
