# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = अधिक जाणा
onboarding-button-label-get-started = सुरु करा

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } मध्ये आपले स्वागत आहे
onboarding-welcome-body = आपल्याला आपले ब्राऊझर मिळाले.<br/> उर्वरित { -brand-product-name } ला भेटा.
onboarding-welcome-learn-more = होणाऱ्या लाभाबद्दल अधिक जाणून घ्या.

onboarding-welcome-form-header = इथून सुरुवात करा

onboarding-join-form-body = सुरू करण्यासाठी आपला ईमेल प्रविष्ट करा.
onboarding-join-form-email =
    .placeholder = ईमेल प्रविष्ट करा
onboarding-join-form-email-error = वैध ईमेल आवश्यक
onboarding-join-form-continue = पुढे चला

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = आधीपासूनच एक खाते आहे?
# Text for link to submit the sign in form
onboarding-join-form-signin = साइन इन करा

onboarding-start-browsing-button-label = ब्राउजिंग सुरु करा

onboarding-cards-dismiss =
    .title = रद्द करा
    .aria-label = रद्द करा

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

onboarding-fullpage-form-email =
    .placeholder = आपला ईमेल पत्ता…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name } सोबत न्या
onboarding-sync-welcome-content = आपले बुकमार्क्स, इतिहास, पासवर्ड आणि इतर सेटिंग आपल्या सर्व उपकरणांवर मिळवा.
onboarding-sync-welcome-learn-more-link = Firefox खात्यांविषयी अधिक जाणून घ्या

onboarding-sync-form-input =
    .placeholder = ईमेल

onboarding-sync-form-continue-button = पुढे चला
onboarding-sync-form-skip-login-button = ही पायरी वगळा

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = ईमेल प्रविष्ट करा
onboarding-sync-form-sub-header = { -sync-brand-name } वर सुरू ठेवण्यासाठी


## These are individual benefit messages shown with an image, title and
## description.


onboarding-benefit-sync-title = { -sync-brand-short-name }

onboarding-benefit-monitor-title = { -monitor-brand-short-name }

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = ट्रॅकिंग पासून संरक्षण
onboarding-tracking-protection-button2 = कसं काम करत

onboarding-data-sync-title = आपण केलेल्या सेटिंग आपल्यासोबत जतन करा
onboarding-data-sync-button2 = { -sync-brand-short-name } मध्ये साइन इन करा

onboarding-firefox-monitor-title = डेटा ब्रीच पासून सावध रहा
onboarding-firefox-monitor-button = अलर्टसाठी साइन अप करा

onboarding-browse-privately-title = खाजगीरित्या ब्राउझ करा
onboarding-browse-privately-button = खाजगी विंडो उघडा

onboarding-firefox-send-title = आपल्या सामायिक केलेल्या फाईल खाजगी ठेवा
onboarding-firefox-send-button = वापरा { -send-brand-name }

onboarding-mobile-phone-title = आपल्या फोनवर { -brand-product-name } मिळवा
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = मोबाईल ब्राऊझर डाऊनलोड करा

onboarding-send-tabs-title = स्वतःला टॅब त्वरित पाठवा
onboarding-send-tabs-button = टॅब पाठवा वापरणे प्रारंभ करा

onboarding-pocket-anywhere-title = वाचा आणि ऐका कुठेपण
onboarding-pocket-anywhere-button = वापरा { -pocket-brand-name }

onboarding-facebook-container-title = फेसबुक सह सीमा निश्चित करा
onboarding-facebook-container-button = एक्सटेंशन जोडा


## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = छान, आपल्याकडे { -brand-short-name } आहे

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = आता आपण <icon></icon><b>{ $addon-name }</b> घेऊया.
return-to-amo-extension-button = विस्तार जोडा
return-to-amo-get-started-button = { -brand-short-name } सह प्रारंभ करा
