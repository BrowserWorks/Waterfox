# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Fræðast meira
onboarding-button-label-get-started = Hefjast handa

## Welcome modal dialog strings

onboarding-welcome-header = Vertu velkomin í { -brand-short-name }
onboarding-welcome-body = Þú ert kominn með vafrann. <br/> Hittu restina af { -brand-product-name }.
onboarding-welcome-learn-more = Fræðast meira um ávinningana.

onboarding-join-form-body = Sláðu inn tölvupóstfang þitt hér til að hefjast handa.
onboarding-join-form-email =
    .placeholder = Sláðu inn tölvupóstfang
onboarding-join-form-email-error = Nauðsynlegt að setja inn tölvupóstfang sem er gilt
onboarding-join-form-continue = Halda áfram

onboarding-start-browsing-button-label = Fara að vafra

onboarding-cards-dismiss =
    .title = Hafna
    .aria-label = Hafna

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

## Waterfox Sync modal dialog strings.

onboarding-sync-welcome-header = Taktu { -brand-product-name } með þér
onboarding-sync-welcome-content = Fáðu bókamerki, sögu, lykilorð og aðrar stillingar á öllum tækjunum þínum.
onboarding-sync-welcome-learn-more-link = Frekari upplýsingar um Waterfox reikninga

onboarding-sync-form-input =
    .placeholder = Netfang

onboarding-sync-form-continue-button = Áfram
onboarding-sync-form-skip-login-button = Sleppa þessu skrefi

## This is part of the line "Enter your email to continue to Waterfox Sync"

onboarding-sync-form-header = Sláðu inn netfangið þitt
onboarding-sync-form-sub-header = fara áfram á { -sync-brand-name }


## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Afgreiddu verkefni með tólum sem virða friðhelgi einkalífsins á öllum þínum tækjum.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Vörn gegn því að fylgst sé með þér
onboarding-tracking-protection-button2 = Hvernig þetta virkar

onboarding-data-sync-title = Taktu stillingarnar þínar með þér
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Samstilla bókamerkin og lykilorðin þín, hvar sem þú notar { -brand-product-name }.
onboarding-data-sync-button2 = Skrá sig inn í { -sync-brand-short-name }

onboarding-firefox-monitor-title = Vertu á verði gegn gagnalekum
onboarding-firefox-monitor-button = Skráðu þig fyrir tilkynningum

onboarding-browse-privately-title = Huliðsvöfrun
onboarding-browse-privately-button = Opna huliðsglugga

onboarding-firefox-send-title = Haltu skránum sem þú deilir öruggum
onboarding-firefox-send-button = Prófa { -send-brand-name }

onboarding-mobile-phone-title = Náðu í { -brand-product-name } fyrir símann þinn
onboarding-mobile-phone-text = Hlaða niður { -brand-product-name } fyrir iOS eða Android og samstilltu gögnin þín milli allra tækja þinna.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Sækja snjalltækja vafra

onboarding-send-tabs-title = Sendu sjálfri/sjálfum þér flipa
onboarding-send-tabs-button = Byrjaðu að nota Senda flipa

onboarding-pocket-anywhere-title = Lesa og hlusta á hvar sem er
onboarding-pocket-anywhere-text2 = Vistaðu uppáhalds efnið þitt á tæki þínu með { -pocket-brand-name } appinu og lestu, hlustaðu og horfðu á hvenær sem það hentar þér.
onboarding-pocket-anywhere-button = Prófaðu { -pocket-brand-name }

onboarding-facebook-container-title = Settu mörk á Facebook
onboarding-facebook-container-button = Bæta við viðbót


## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Frábært, þú ert með { -brand-short-name }

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Nú skaltu fá <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Bæta viðbót
return-to-amo-get-started-button = Hefjast handa með { -brand-short-name }
