# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = ఇంకా తెలుసుకోండి
onboarding-button-label-get-started = మొదలుపెట్టండి

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name }కు స్వాగతం
onboarding-welcome-body = మీరు విహారిణిని తెచ్చుకున్నారు.<br/>మిగతా { -brand-product-name }‌ను కలుసుకోండి.
onboarding-welcome-learn-more = ప్రయోజనాల గురించి మరింత తెలుసుకోండి.
onboarding-welcome-modal-get-body = మీరు విహారిణిని తెచ్చుకున్నారు.<br/>ఇప్పుడు { -brand-product-name }‌ నుండి మరింత పొందండి.
onboarding-welcome-modal-privacy-body = మీరు విహారిణిని తెచ్చుకున్నారు. ఇక మరికొంత గోప్యతా సంరక్షణను చేరుద్దాం.
onboarding-welcome-modal-family-learn-more = { -brand-product-name } ఉత్పత్తుల కుటుంబం గురించి ఇంకా తెలుసుకోండి.
onboarding-welcome-form-header = ఇక్కడ మొదలుపెట్టండి

onboarding-join-form-body = మొదలుపెట్టడానికి మీ ఈమెయిలు చిరునామా ఇవ్వండి.
onboarding-join-form-email =
    .placeholder = ఇమెయిల్‌ని నమోదు చేయండి
onboarding-join-form-email-error = సరైన ఈమెయిలు తప్పనిసరి
onboarding-join-form-continue = కొనసాగించు

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = ఇప్పటికే ఖాతా ఉందా?
# Text for link to submit the sign in form
onboarding-join-form-signin = ప్రవేశించండి

onboarding-start-browsing-button-label = విహరించడం మొదలుపెట్టండి
onboarding-cards-dismiss =
    .title = విస్మరించు
    .aria-label = విస్మరించు

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = <span data-l10n-name="zap">{ -brand-short-name }</span>కి స్వాగతం
onboarding-multistage-welcome-primary-button-label = అమర్పు మొదలుపెట్టు
onboarding-multistage-welcome-secondary-button-label = ప్రవేశించు
onboarding-multistage-welcome-secondary-button-text = ఖాతా ఉందా?

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = మీ సంకేతపదాలను, ఇష్టాంశాలను <br/>, ఇంకా <span data-l10n-name="zap">మరెన్నిటినో</span> దిగుమతి చేసుకోండి
onboarding-multistage-import-subtitle = మరో విహారిణి నుండి వస్తున్నారా? కావలసిన వాటన్నింటినీ { -brand-short-name }‌కి తెచ్చుకోవడం చాలా తేలిక.
onboarding-multistage-import-primary-button-label = దిగుమతిని మొదలుపెట్టు
onboarding-multistage-import-secondary-button-label = ఇప్పుడు కాదు

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = మొదలుపెట్టండి: { $total } తెరలలో { $current }

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = ఒక <span data-l10n-name="zap">రూపం</span> ఎంచుకోండి
onboarding-multistage-theme-subtitle = ఒక అలంకారంతో { -brand-short-name }‌ని వ్యక్తిగతీకరించుకోండి.
onboarding-multistage-theme-primary-button-label = అలంకారాన్ని భద్రపరుచు
onboarding-multistage-theme-secondary-button-label = ఇప్పుడు కాదు

# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = స్వయంచాలకం

# System refers to the operating system
onboarding-multistage-theme-description-automatic = వ్యవస్థ అలంకారం వాడు

onboarding-multistage-theme-label-light = తెల్లని
onboarding-multistage-theme-label-dark = నల్లని
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


## Welcome full page string

onboarding-fullpage-form-email =
    .placeholder = మీ ఈమెయిలు చిరునామా…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name }ను మీతో తీసుకెళ్ళండి
onboarding-sync-welcome-content = మీ ఇష్టాంశాలను, చరిత్రను, సంకేతపదాలను, ఇతర అమరికలను మీ పరికరాలన్నింటిలో పొందండి.
onboarding-sync-welcome-learn-more-link = Firefox ఖాతాల గురించి మరింత తెలుసుకోండి

onboarding-sync-form-input =
    .placeholder = ఈమెయిలు

onboarding-sync-form-continue-button = కొనసాగు
onboarding-sync-form-skip-login-button = ఈ అంచెను దాటవేయి

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = మీ ఈమెయిలును ఇవ్వండి
onboarding-sync-form-sub-header = { -sync-brand-name }కి కొనసాగడానికి


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-sync-title = { -sync-brand-short-name }

onboarding-benefit-monitor-title = { -monitor-brand-short-name }

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = ట్రాకింగు నుండి సంరక్షణ
onboarding-tracking-protection-button2 = ఇది ఎలా పనిచేస్తుంది

onboarding-data-sync-title = మీ అమరికలను మీతో తీసుకెళ్ళండి
onboarding-data-sync-button2 = { -sync-brand-short-name } లోనికి ప్రవేశించండి

onboarding-browse-privately-title = అంతరంగికంగా విహరించండి
onboarding-browse-privately-button = ఒక అంతరంగిక కిటికీ తెరవండి

onboarding-firefox-send-title = మీరు పంచుకున్న ఫైళ్ళను అంతరంగికంగా ఉంచుకోండి
onboarding-firefox-send-button = { -send-brand-name }‌ని ప్రయత్నించండి

onboarding-mobile-phone-title = { -brand-product-name }‌ను మీ ఫోనులో పొందండి
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = మొబైలు విహారిణిని దించుకోండి

onboarding-send-tabs-title = తక్షణమే మీకు ట్యాబులను పంపించుకోండి

onboarding-pocket-anywhere-title = ఎక్కడైనా చదవండి, వినండి
onboarding-pocket-anywhere-button = { -pocket-brand-name }‌ని ప్రయత్నించండి

onboarding-lockwise-strong-passwords-title = బలమైన సంకేతపదాలను సృష్టించుకోండి, భద్రపరుచుకోండి
onboarding-lockwise-strong-passwords-button = మీ ప్రవేశాలను నిర్వహించుకోండి

onboarding-facebook-container-title = ఫేస్‌బుక్‌కి హద్దులు గీయండి
onboarding-facebook-container-button = పొడగింతను చేర్చు

onboarding-import-browser-settings-title = మీ ఇష్టాంశాలు, సంకేతపదాలు, ఇంకా మరెన్నిటినో దిగుమతి చేసుకోండి
onboarding-import-browser-settings-button = క్రోమ్ డేటాను దిగుమతి చేయి

onboarding-personal-data-promise-button = మా వాగ్దానాన్ని చదవండి

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = అద్భుతం, మీరు { -brand-short-name }‌ను తెచ్చుకున్నారు

return-to-amo-extension-button = పొడగింతను చేర్చు
return-to-amo-get-started-button = { -brand-short-name }తో మెదలుపెట్టండి
