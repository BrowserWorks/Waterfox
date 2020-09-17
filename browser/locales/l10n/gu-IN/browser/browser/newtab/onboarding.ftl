# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = વધુ શીખો
onboarding-button-label-get-started = શરૂ કરો

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } માં તમારું સ્વાગત છે
onboarding-welcome-body = તમને બ્રાઉઝર મળ્યો છે.<br/> બાકીના { -brand-product-name } મળો.
onboarding-welcome-learn-more = ફાયદાઓ વિશે વધુ જાણો.

onboarding-join-form-body = શરુ કરવા માટે તમારું ઇમેઇલ સરનામું દાખલ કરો
onboarding-join-form-email =
    .placeholder = ઇમેઇલ દાખલ કરો
onboarding-join-form-email-error = માન્ય ઇમેઇલ આવશ્યક છે
onboarding-join-form-continue = ચાલુ રાખો

onboarding-start-browsing-button-label = બ્રાઉઝિંગ શરુ કરો

onboarding-cards-dismiss =
    .title = રદ કરો
    .aria-label = રદ કરો

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = તમારી સાથે { -brand-product-name } લો
onboarding-sync-welcome-content = તમારા બધા ઉપકરણો પર તમારા બુકમાર્ક્સ, ઇતિહાસ, પાસવર્ડ્સ અને અન્ય સેટિંગ્સ મેળવો.
onboarding-sync-welcome-learn-more-link = Fireofox ખાતા વિશે વધુ શીખો

onboarding-sync-form-input =
    .placeholder = ઇમેઇલ

onboarding-sync-form-continue-button = ચાલુ રાખો
onboarding-sync-form-skip-login-button = આ પગલું છોડી દો

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = તમારા ઇમેઇલ દાખલ કરો
onboarding-sync-form-sub-header = { -sync-brand-name } ચાલુ રાખવા માટે


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-button2 = તે કેવી રીતે કામ કરે છે

onboarding-data-sync-button2 = { -sync-brand-short-name } સાઇન ઇન કરો

onboarding-browse-privately-title = ખાનગી રૂપે બ્રાઉઝ કરો
onboarding-browse-privately-button = ખાનગી વિન્ડો ખોલો

onboarding-firefox-send-title = તમારી શેર કરેલી ફાઇલોને ખાનગી રાખો
onboarding-firefox-send-button = { -send-brand-name } વાપરો

onboarding-mobile-phone-title = તમારા ફોન પર { -brand-product-name } મેળવો
onboarding-mobile-phone-text = IOS અથવા Android માટે { -brand-product-name } ડાઉનલોડ કરો અને તમારા ડેટાને સમગ્ર ઉપકરણો પર સમન્વયિત કરો.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = મોબાઇલ બ્રાઉઝર ડાઉનલોડ કરો

onboarding-pocket-anywhere-text2 = { -pocket-brand-name } એપ્લિકેશન સાથે તમારી પસંદની સામગ્રીને ઓફલાઇન સાચવો અને તમારી અનુકૂળતા પ્રમાણે વાંચો, સાંભળો અને જુઓ.
onboarding-pocket-anywhere-button = { -pocket-brand-name } વાપરો


## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = સરસ, તમને { -brand-short-name } મળી ગયું

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = હવે ચાલો તમને મળીએ <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = એક્સ્ટેંશન ઉમેરો
return-to-amo-get-started-button = { -brand-short-name } સાથે પ્રારંભ કરો
