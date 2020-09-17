# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-get-started = Başla

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } səyyahına xoş gəlmisiniz

onboarding-start-browsing-button-label = Səyahətə Başla

onboarding-cards-dismiss =
    .title = Rədd et
    .aria-label = Rədd et

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name }-u özünüzlə gəzdirin
onboarding-sync-welcome-content = Əlfəcin, tarixçə, parol və digər tənzimləmələrinizi bütün cihazlarınızda əldə edin.
onboarding-sync-welcome-learn-more-link = Firefox Hesabları haqqında ətraflı öyrənin

onboarding-sync-form-input =
    .placeholder = E-poçt

onboarding-sync-form-continue-button = Davam et
onboarding-sync-form-skip-login-button = Bu addımı keç

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = E-poçtunuzu daxil edin
onboarding-sync-form-sub-header = və { -sync-brand-name } ilə davam edin.


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section


## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Super, { -brand-short-name } quruldu

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = İndi də <icon></icon><b>{ $addon-name }</b> uzantısına baxaq.
return-to-amo-extension-button = Uzantını əlavə et
return-to-amo-get-started-button = { -brand-short-name } səyyahını işlətməyə başla
