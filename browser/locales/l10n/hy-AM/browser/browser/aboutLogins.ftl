# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Մուտքագրումներ և գաղտնաբառեր

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Վերցրեք ձեր գաղտնաբառերը ամենուր
login-app-promo-subtitle = Ձեռք բերել անվճար{ -lockwise-brand-name } հավելվածը
login-app-promo-android =
    .alt = Ձեռք բերել Google Play-ից
login-app-promo-apple =
    .alt = Ներբեռնել App Store-ից
login-filter =
    .placeholder = Որոնել մուտքագրումներ
create-login-button = Ստեղծել նոր մուտքագրում
fxaccounts-sign-in-text = Ստացեք ձեր գաղտնաբառերը ձեր մյուս սարքերում
fxaccounts-sign-in-button = Մուտք գործել { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Կառավարել հաշիվը

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Բացել ցանկը
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Ներմուծել այլ դիտարկիչից...
about-logins-menu-menuitem-export-logins = Մուտքագրումների արտահանում…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Ընտրանքներ
       *[other] Նախապատվություններ
    }
about-logins-menu-menuitem-help = Օգնություն
menu-menuitem-android-app = { -lockwise-brand-short-name }-ը Android-ի համար
menu-menuitem-iphone-app = { -lockwise-brand-short-name }-ը iPhone-ի և iPad-ի համար

## Login List

login-list =
    .aria-label = Մուտքագրումների համապատասխանության որոնման հարցում
login-list-count =
    { $count ->
        [one] { $count } մուտքագրում
       *[other] { $count } մուտքագրումներ
    }
login-list-sort-label-text = Տեսակավարել ըստ՝
login-list-name-option = Անվան (Ա-Ֆ)
login-list-name-reverse-option = Անվան (Ա-Ֆ)
about-logins-login-list-alerts-option = Զգուշացումներ
login-list-last-changed-option = Վերջին փոփոխության
login-list-last-used-option = Վերջին օգտագործման
login-list-intro-title = Մուտքագրումներ չկան
login-list-intro-description = Երբ պահպանում եք գաղտնաբառը { -brand-product-name }-ում, այն կցուցադրվի այստեղ:
about-logins-login-list-empty-search-title = Մուտքեր չեն գտնվել
about-logins-login-list-empty-search-description = Որոնման հետ համընկնում չկա։
login-list-item-title-new-login = Նոր մուտքագրում
login-list-item-subtitle-new-login = Նշեք մուտքագրման տվյալները
login-list-item-subtitle-missing-username = (չկա օգտվողի անուն)
about-logins-list-item-breach-icon =
    .title = Խախտված կայք
about-logins-list-item-vulnerable-password-icon =
    .title = Խոցելի գաղտնաբառ

## Introduction screen

login-intro-heading = Փնտրո՞ւմ եք ձեր պահպանված մուտքագրումները: Տեղակայեք { -sync-brand-short-name }-ը:
about-logins-login-intro-heading-logged-in = Համաժամեցված մուտք չի գտնվել:
login-intro-description = Եթե պահպանել եք ձեր մուտքագրումները { -brand-product-name }-ում այլ սարքում, ահա թե ինչպես կարող եք ստանալ դրանք.
login-intro-instruction-fxa = Ստեղծեք կամ մուտք գործեք { -fxaccount-brand-name } այն սարքում, որտեղ ձեր մուտքագրումները պահպանված են
login-intro-instruction-fxa-settings = Համոզվեք, որ ընտրել եք ձեր Մուտքագրումների նշատուփը { -sync-brand-short-name }-ի կարգավորումներում:
about-logins-intro-instruction-help = Լրացուցիչ օգնության համար այցելեք <a data-l10n-name="help-link">{ -lockwise-brand-short-name } աջակցել</a>։
about-logins-intro-import = Եթե ձեր մուտքանունները այլ զննարկիչում են պահպանված, դուք կարող եք <a data-l10n-name="import-link">դրանք ներածել { -lockwise-brand-short-name }</a>-ում

## Login

login-item-new-login-title = Ստեղծել նոր մուտքագրում
login-item-edit-button = Խմբագրել
about-logins-login-item-remove-button = Հեռացնել
login-item-origin-label = Կայքի հասցեն
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Օգտվողի անուն
about-logins-login-item-username =
    .placeholder = (օգտանուն չկա)
login-item-copy-username-button-text = Պատճենել
login-item-copied-username-button-text = Պատճենված
login-item-password-label = Գաղտնաբառ
login-item-password-reveal-checkbox =
    .aria-label = Ցուցադրել գաղտնաբառը
login-item-copy-password-button-text = Պատճենել
login-item-copied-password-button-text = Պատճենված
login-item-save-changes-button = Պահպանել փոփոխությունները
login-item-save-new-button = Պահպանել
login-item-cancel-button = Չեղարկել
login-item-time-changed = Վերջին փոփոխությունը ՝ { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Ստեղծված. { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Վերջին անգամ օգտագործված ՝{ DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Ձեր մուտքագրումը խմբագրելու համար մուտքագրեք ձեր Windows մուտքի հավատարմագրերը: Սա օգնում է պաշտպանել ձեր հաշիվների անվտանգությունը:
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = խմբագրել պահպանված մուտքանունը
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Ձեր մուտքագրումը խմբագրելու համար մուտքագրեք ձեր Windows մուտքի հավատարմագրերը: Սա օգնում է պաշտպանել ձեր հաշիվների անվտանգությունը:
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = բացահայտել պահպանված գաղտնաբառը
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Ձեր մուտքագրումը պատճենելու համար մուտքագրեք ձեր Windows մուտքի հավատարմագրերը: Սա օգնում է պաշտպանել ձեր հաշիվների անվտանգությունը:
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = պատճենեք պահպանված գաղտնաբառը

## Master Password notification

master-password-notification-message = Խնդրում ենք մուտքագրել ձեր գլխավոր գաղտնաբառը ՝ պահպանված մուտքերը և գաղտնաբառերը դիտելու համար
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Ձեր մուտքագրումը արտահանելու համար մուտքագրեք ձեր Windows մուտքի հավատարմագրերը: Սա օգնում է պաշտպանել ձեր հաշիվների անվտանգությունը:
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = արտահանել պահպանված մուտքանունները և գաղտնաբառերը

## Primary Password notification

about-logins-primary-password-notification-message = Մուտքագրեք Հիմնական գաղտնաբառը՝ պահված մուտանունները և գաղտնաբառերը տեսնելու համար
master-password-reload-button =
    .label = Մուտք գործել
    .accesskey = L

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Ձեզ պետք են ձեր գաղտնաբառերը, որտեղ որ օգտագործում եք { -brand-product-name }-ը: Անցեք ձեր { -sync-brand-short-name }-ի ընտրանքներին և ընտրեք Մուտքագրումներ նշատուփը:
       *[other] Ձեզ պետք են ձեր գաղտնաբառերը, որտեղ որ օգտագործում եք { -brand-product-name }-ը: Անցեք ձեր { -sync-brand-short-name }-ի նախապատվություններ և ընտրեք Մուտքագրումներ նշատուփը:
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Այցելեք { -sync-brand-short-name }-ի ընտրանքները
           *[other] Այցելեք { -sync-brand-short-name }-ի նախապատվությունները
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Այլևս չհարցնել
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = Չեղարկել
confirmation-dialog-dismiss-button =
    .title = Չեղարկել
about-logins-confirm-remove-dialog-title = Հեռացնե՞լ այս մուտքանունը։
confirm-delete-dialog-message = Այս գործողությունը չի կարող ետարկվել:
about-logins-confirm-remove-dialog-confirm-button = Հեռացնել
about-logins-confirm-export-dialog-title = Արտահանել մուտքանունները և գաղտնաբառերը
about-logins-confirm-export-dialog-message = Ձեր գաղտնաբառերը կպահպանվեն որպես ընթեռնելի տեքստ (օր. ՝ BadP@ssw0rd), այնպես որ յուրաքանչյուրը, ով կարող է բացել արտահանվող ֆայլը, կարող է դիտել դրանք:
about-logins-confirm-export-dialog-confirm-button = Արտահանել...
confirm-discard-changes-dialog-title = Վերանայե՞լ չփրկված փոփոխությունները:
confirm-discard-changes-dialog-message = Բոլոր չպահպանված փոփոխությունները կկորչեն:
confirm-discard-changes-dialog-confirm-button = Մերժել

## Breach Alert notification

about-logins-breach-alert-title = Վեբ կայքի խախտում
breach-alert-text = Այս կայքի գաղտնաբառերը արտահոսք են կամ գողացել են այն բանից հետո, երբ վերջին անգամ թարմացրել եք ձեր մուտքի տվյալները: Փոխեք ձեր գաղտնաբառը ՝ ձեր հաշիվը պաշտպանելու համար:
about-logins-breach-alert-date = Այս խախտումը տեղի է ունեցել { DATETIME($date, day: "numeric", month: "long", year: "numeric") }-ին
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Անցնել { $hostname }-ին
about-logins-breach-alert-learn-more-link = Իմանալ ավելին

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Խոցելի գաղտնաբառ
about-logins-vulnerable-alert-text2 = Այս գաղտնաբառը օգտագործվել է մեկ այլ հաշվի վրա, որը, հավանաբար, տվյալների խախտման մեջ էր: Վկայագրերից օգտվելը ձեր բոլոր հաշիվները ռիսկի է ենթարկում: Փոխեք այս գաղտնաբառը:
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Անցնել { $hostname }-ին
about-logins-vulnerable-alert-learn-more-link = Իմանալ ավելին

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = { $loginTitle }-ի այդ անունով մուտքը արդեն գոյություն ունի։ <a data-l10n-name="duplicate-link">Գնա՞լ առկա մուտքագրումները։</a>
# This is a generic error message.
about-logins-error-message-default = Գաղտնաբառի պահման ժամանակ հայտնվեց սխալ։

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Մուտքագրումների ֆայլի արտահանում
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Արտահանել
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV փաստաթուղթ
       *[other] CSV ֆայլ
    }

## Login Import Dialog

