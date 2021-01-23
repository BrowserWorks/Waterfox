# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = ការចូល និង​ពាក្យ​សម្ងាត់

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = នាំ​យក​ពាក្យ​សម្ងាត់​របស់​អ្នក​គ្រប់​ទីកន្លែង
login-app-promo-subtitle = ទាញយក​កម្មវិធី { -lockwise-brand-name } ឥត​គិតថ្លៃ
login-app-promo-android =
    .alt = ទាញយក​កម្មវិធី​នៅ​លើ Google Play
login-app-promo-apple =
    .alt = ទាញយក​នៅ​លើ App Store

login-filter =
    .placeholder = ស្វែងរក​ការចូល

create-login-button = បង្កើត​ការចូល​ថ្មី

fxaccounts-sign-in-text = ទាញយក​ពាក្យ​សម្ងាត់​របស់​អ្នក​នៅ​លើ​ឧបករណ៍​ផ្សេងៗ​របស់​អ្នក
fxaccounts-sign-in-button = ចូល​ទៅ { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = គ្រប់គ្រង​គណនី

## The ⋯ menu that is in the top corner of the page

menu =
    .title = បើក​ម៉ឺនុយ
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] ជម្រើស
       *[other] ចំណូលចិត្ត
    }
about-logins-menu-menuitem-help = ជំនួយ
menu-menuitem-android-app = { -lockwise-brand-short-name } សម្រាប់ Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } សម្រាប់ iPhone និង iPad

## Login List

login-list =
    .aria-label = ការចូល​ត្រូវ​គ្នា​ជាមួយ​សំណួរ​ស្វែងរក
login-list-count =
    { $count ->
       *[other] ការចូល​ចំនួន { $count }
    }
login-list-sort-label-text = តម្រៀបតាម៖
login-list-name-option = ឈ្មោះ (A-Z)
login-list-name-reverse-option = ឈ្មោះ (Z-A)
login-list-last-changed-option = បាន​កែប្រែ​ចុងក្រោយ
login-list-last-used-option = បាន​ប្រើប្រាស់​ចុងក្រោយ
login-list-intro-title = រក​មិន​ឃើញ​ការចូល​ទេ
login-list-intro-description = នៅពេល​អ្នក​រក្សាទុក​ពាក្យ​សម្ងាត់​នៅ​ក្នុង { -brand-product-name } វា​នឹង​បង្ហាញ​នៅ​ត្រង់​នេះ។
about-logins-login-list-empty-search-title = រក​មិន​ឃើញ​ការ​ចូល
about-logins-login-list-empty-search-description = មិនមានលទ្ធផលត្រូវនឹងការស្វែងរករបស់អ្នកទេ។
login-list-item-title-new-login = ការចូល​ថ្មី
login-list-item-subtitle-new-login = បញ្ចូល​ព័ត៌មាន​លម្អិត​ការចូល​របស់​អ្នក
login-list-item-subtitle-missing-username = (គ្មាន​ឈ្មោះ​អ្នក​ប្រើប្រាស់)
about-logins-list-item-breach-icon =
    .title = គេហទំព័រ​ដែល​បាន​បំពាន

## Introduction screen

login-intro-heading = កំពុង​រក​មើល​ការចូល​ដែល​បាន​រក្សាទុក​របស់​អ្នក​មែន​ទេ? រៀបចំ { -sync-brand-short-name } ។

about-logins-login-intro-heading-logged-in = រកមិនឃើញការចូលដែល​បាន​ធ្វើសមកាលកម្ម។
login-intro-description = ប្រសិនបើ​អ្នក​បាន​រក្សាទុក​ការចូល​របស់​អ្នក​ទៅ { -brand-product-name } នៅ​លើ​ឧបករណ៍​ផ្សេង នេះជា​របៀប​​ចូល​​មើល​ការចូល​ទាំងនោះ​នៅ​ត្រង់នេះ៖
login-intro-instruction-fxa = បង្កើត ឬ​ចូល​ទៅ { -fxaccount-brand-name } របស់​អ្នក​នៅ​លើ​ឧបករណ៍ ត្រង់​កន្លែង​ដែល​បាន​រក្សាទុក​ការចូល​របស់​អ្នក
login-intro-instruction-fxa-settings = ប្រាកដ​ថា អ្នក​បាន​ជ្រើសរើស​​ប្រអប់​ធីក​ការចូល​នៅ​ក្នុង​ការកំណត់ { -sync-brand-short-name }
about-logins-intro-instruction-help = ចូល​មើល <a data-l10n-name="help-link"> { -lockwise-brand-short-name } គាំទ្រ </a> សម្រាប់ជំនួយបន្ថែម

## Login

login-item-new-login-title = បង្កើត​ការចូល​ថ្មី
login-item-edit-button = កែសម្រួល
about-logins-login-item-remove-button = លុប​ចេញ
login-item-origin-label = អាសយដ្ឋាន​គេហទំព័រ
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = ឈ្មោះ​អ្នក​ប្រើប្រាស់
about-logins-login-item-username =
    .placeholder = (គ្មាន​ឈ្មោះ​អ្នក​ប្រើប្រាស់)
login-item-copy-username-button-text = ចម្លង
login-item-copied-username-button-text = បាន​ចម្លង!
login-item-password-label = ពាក្យ​សម្ងាត់
login-item-password-reveal-checkbox =
    .aria-label = បង្ហាញ​ពាក្យសម្ងាត់
login-item-copy-password-button-text = ចម្លង
login-item-copied-password-button-text = បាន​ចម្លង!
login-item-save-changes-button = រក្សាទុក​ការផ្លាស់ប្ដូរ
login-item-save-new-button = រក្សាទុក
login-item-cancel-button = បោះបង់
login-item-time-changed = បាន​កែប្រែ​ចុងក្រោយ៖ { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = បាន​បង្កើត៖ { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = បាន​ប្រើប្រាស់​ចុងក្រោយ៖ { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog


## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.


## Master Password notification

master-password-notification-message = សូម​បញ្ចូល​ពាក្យសម្ងាត់​មេ​របស់​អ្នក ដើម្បី​មើល​ការចូល និង​ពាក្យ​សម្ងាត់​ដែល​បាន​រក្សាទុក

## Primary Password notification

master-password-reload-button =
    .label = ចូល
    .accesskey = ច

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] ចង់បាន​ការចូល​របស់​អ្នក​នៅ​គ្រប់កន្លែង​ដែល​អ្នក​ប្រើប្រាស់ { -brand-product-name } ដែរ​ឬ​ទេ? ចូល​ទៅ​កាន់​ជម្រើស { -sync-brand-short-name } រួច​ជ្រើសរើស​ប្រអប់​ធីក​ការចូល។
       *[other] ចង់បាន​ការចូល​របស់​អ្នក​នៅ​គ្រប់កន្លែង​ដែល​អ្នក​ប្រើប្រាស់ { -brand-product-name } ដែរ​ឬ​ទេ? ចូល​ទៅ​កាន់​​ចំណូលចិត្ត { -sync-brand-short-name } រួច​ជ្រើសរើស​ប្រអប់​ធីក​ការចូល។
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] ចូល​ទៅ​កាន់​ជម្រើស { -sync-brand-short-name }
           *[other] ចូល​ទៅ​កាន់​ចំណូលចិត្ត { -sync-brand-short-name }
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = កុំ​សួរ​ខ្ញុំ​ម្ដងទៀត
    .accesskey = ក

## Dialogs

confirmation-dialog-cancel-button = បោះបង់
confirmation-dialog-dismiss-button =
    .title = បោះបង់

confirm-delete-dialog-message = សកម្មភាព​នេះ​មិន​អាច​ត្រឡប់​វិញ​បាន​ទេ។

confirm-discard-changes-dialog-title = បោះបង់​ការផ្លាស់ប្ដូរ​ដែល​មិន​បាន​រក្សាទុក?
confirm-discard-changes-dialog-message = ការផ្លាស់ប្ដូរ​ដែល​មិន​បាន​រក្សាទុក​ទាំងអស់​នឹង​បាត់។
confirm-discard-changes-dialog-confirm-button = បោះបង់

## Breach Alert notification

breach-alert-text = ពាក្យ​សម្ងាត់​ត្រូវបាន​បែកធ្លាយ ឬ​លួច​ពី​គេហទំព័រ​នេះ ចាប់តាំង​ពី​អ្នក​បាន​ធ្វើបច្ចុប្បន្នភាព​​ព័ត៌មាន​លម្អិត​ការចូល​របស់​អ្នក​ចុងក្រោយ។ សូម​ប្ដូរ​ពាក្យ​សម្ងាត់​របស់​អ្នក ដើម្បី​ការពារ​គណនី​របស់​អ្នក។

## Vulnerable Password notification


## Error Messages


## Login Export Dialog

## Login Import Dialog

