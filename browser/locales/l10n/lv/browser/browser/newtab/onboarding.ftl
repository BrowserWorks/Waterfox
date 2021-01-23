# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-get-started = Ar ko sākt

## Welcome modal dialog strings

onboarding-welcome-header = Laipni lūgti { -brand-short-name };

onboarding-start-browsing-button-label = Sākt pārlūkošanu

onboarding-cards-dismiss =
    .title = Noraidīt
    .aria-label = Noraidīt

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

## Waterfox Sync modal dialog strings.

onboarding-sync-welcome-header = Paņemiet { -brand-product-name } sev līdz
onboarding-sync-welcome-content = Izmantojiet grāmatzīmes, vēsturi, saglabātās paroles un citus iestatījumus visās savās ierīcēs.
onboarding-sync-welcome-learn-more-link = Uzzini vairāk par Waterfox kontiem

onboarding-sync-form-input =
    .placeholder = Epasts

onboarding-sync-form-continue-button = Turpināt
onboarding-sync-form-skip-login-button = Izlaist šo soli

## This is part of the line "Enter your email to continue to Waterfox Sync"

onboarding-sync-form-header = Ievadiet savu epastu
onboarding-sync-form-sub-header = lai turpinātu { -sync-brand-name }.


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section


## Message strings belonging to the Return to AMO flow

