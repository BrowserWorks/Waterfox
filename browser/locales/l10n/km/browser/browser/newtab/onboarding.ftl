# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = ស្វែងយល់​បន្ថែម
onboarding-button-label-get-started = ត្រូវ​បាន​ចាប់​ផ្ដើម​

## Welcome modal dialog strings

onboarding-welcome-header = សូម​ស្វាគមន៍​មក​កាន់ { -brand-short-name }

onboarding-start-browsing-button-label = ចាប់​ផ្ដើម​រុករក
onboarding-cards-dismiss =
    .title = បោះបង់ចោល
    .aria-label = បោះបង់ចោល

## Multistage 3-screen onboarding flow strings (about:welcome pages)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

## Welcome full page string


## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = យក { -brand-product-name } ជាមួយអ្នក
onboarding-sync-welcome-content = ទទួលយកចំណាំ ប្រវត្តិ ពាក្យសម្ងាត់និងការកំណត់ផ្សេងទៀតរបស់អ្នកលើឧបករណ៍ទាំងអស់របស់អ្នក។
onboarding-sync-welcome-learn-more-link = ស្វែងយល់បន្ថែមអំពីគណនី Firefox

onboarding-sync-form-input =
    .placeholder = អ៊ីមែល

onboarding-sync-form-continue-button = បន្ត
onboarding-sync-form-skip-login-button = រំលងជំហាននេះ

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = បញ្ចូល​អ៊ីមែល​របស់​អ្នក
onboarding-sync-form-sub-header = ដើម្បីបន្តទៅ { -sync-brand-name }


## These are individual benefit messages shown with an image, title and
## description.


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = អស្ចារ្យ​មែន អ្នកទទួលបាន { -brand-short-name }

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = ឥឡូវនេះ សូមទាញយក<icon></icon><b>{ $addon-name } របស់អ្នក។</b>
return-to-amo-extension-button = បញ្ចូលផ្នែកបន្ថែម
return-to-amo-get-started-button = ចាប់ផ្ដើមជាមួយ { -brand-short-name }
