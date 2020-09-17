# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = மேலும் அறிய
onboarding-button-label-get-started = தொடங்கு

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } என்பதற்கு வரவேற்கிறோம்
onboarding-welcome-learn-more = நன்மைகள் பற்றி மேலும் அறிக.

onboarding-join-form-body = தொடங்குவதற்கு உங்கள் மின்னஞ்சல் முகவரியை உள்ளிடவும்.
onboarding-join-form-email =
    .placeholder = மின்னஞ்சலை உள்ளிடவும்
onboarding-join-form-email-error = செல்லுபடியாகும் மின்னஞ்சல் தேவை
onboarding-join-form-continue = தொடர்க

onboarding-start-browsing-button-label = உலவத் தொடங்குங்கள்

onboarding-cards-dismiss =
    .title = வெளியேற்று
    .aria-label = வெளியேற்று

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name } உடன் எடுத்துச் செல்லுங்கள்
onboarding-sync-welcome-content = உங்கள் அனைத்துச் சாதனங்களிலும் உள்ள உங்களின் புத்தகக்குறிகள், வரலாறு, கடவுச்சொற்கள் மற்றும் பிற அமைப்புகளைப் பெறுங்கள்.
onboarding-sync-welcome-learn-more-link = பயர்பாக்சு கணக்கைப் பற்றி மேலும் தெரிந்து கொள்ளவும்

onboarding-sync-form-input =
    .placeholder = மின்னஞ்சல்

onboarding-sync-form-continue-button = தொடர்க
onboarding-sync-form-skip-login-button = இந்த படிநிலையைத் தவிர்

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = உங்களின் மின்னஞ்சலை உள்ளிடுக
onboarding-sync-form-sub-header = { -sync-brand-name } ஒத்திசையைத் தொடர.


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = கண்காணிப்பிலிருந்து பாதுகாப்பு
onboarding-tracking-protection-button2 = இது எப்படி செயல்படுகிறது

onboarding-data-sync-title = உங்கள் அமைப்புகளை உங்களுடன் வைத்திருங்கள்
onboarding-data-sync-button2 = { -sync-brand-short-name } ல் உள்நுழைக

onboarding-firefox-monitor-title = தரவு மீறல்களுக்கு எச்சரிக்கையாக இருங்கள்
onboarding-firefox-monitor-button = எச்சரிக்கைக்கு பதிவுபெறுக

onboarding-browse-privately-title = கமுக்க முறையில் உலாவுக
onboarding-browse-privately-button = கமுக்க சாளரத்தைத் திற

onboarding-firefox-send-title = உங்கள் பகிரப்பட்ட கோப்புகளைத் கமுக்கமாக வைத்திருங்கள்
onboarding-firefox-send-button = { -send-brand-name }ஐ முயற்சிக்க

# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = மொபைல் உலாவியைப் பதிவிறக்குக

onboarding-send-tabs-button = தாவல் அனுப்புதலைப் பயன்படுத்தத் தொடங்குங்கள்

onboarding-pocket-anywhere-title = எங்கும் படியுங்கள் கேளுங்கள்

onboarding-facebook-container-button = நீட்டிப்பைச் சேர்க்க


## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = அருமை, உங்களுக்கு { -brand-short-name } கிடைத்திருக்கிறது.

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = இப்போது நீங்கள் <icon></icon><b>{ $addon-name }.</b> மேற்சேர்க்கையைப் பெறலாம்.
return-to-amo-extension-button = நீட்டிப்பினைச் சேர்
return-to-amo-get-started-button = { -brand-short-name } உடன் தொடங்குங்கள்
