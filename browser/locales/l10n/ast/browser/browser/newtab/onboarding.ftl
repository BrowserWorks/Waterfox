# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-get-started = Entamar

## Welcome modal dialog strings

onboarding-welcome-header = Afáyate en { -brand-short-name }

onboarding-start-browsing-button-label = Entama a navegar

onboarding-cards-dismiss =
    .title = Escartar
    .aria-label = Escartar

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string

## Firefox Sync modal dialog strings.

onboarding-sync-form-input =
    .placeholder = Corréu

onboarding-sync-form-continue-button = Siguir
onboarding-sync-form-skip-login-button = Saltar esti pasu

## This is part of the line "Enter your email to continue to Firefox Sync"


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-button2 = Cómo funciona


## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Mui bien, tienes { -brand-short-name }

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Agora, instala la estensión <icon></icon><b>{ $addon-name }</b>.
return-to-amo-extension-button = Amiesta la estensión
return-to-amo-get-started-button = Primeros pasos col { -brand-short-name }
