# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = ანგარიშები და პაროლები

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = თან წაიყოლეთ თქვენი პაროლები ყველგან
login-app-promo-subtitle = გადმოწერეთ უფასო აპლიკაცია { -lockwise-brand-name }
login-app-promo-android =
    .alt = იხილეთ Google Play-ზე
login-app-promo-apple =
    .alt = ჩამოტვირთეთ App Store-დან

login-filter =
    .placeholder = ანგარიშების ძიება

create-login-button = ანგარიშის ახალი მონაცემები

fxaccounts-sign-in-text = გადმოიტანეთ პაროლები სხვა მოწყობილობებიდან
fxaccounts-sign-in-button = { -sync-brand-short-name } – შესვლა
fxaccounts-avatar-button =
    .title = ანგარიშების მართვა

## The ⋯ menu that is in the top corner of the page

menu =
    .title = მენიუს გახსნა
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = გადმოტანა სხვა ბრაუზერიდან…
about-logins-menu-menuitem-import-from-a-file = ფაილიდან გადმოტანა…
about-logins-menu-menuitem-export-logins = მონაცემების გატანა…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] პარამეტრები
       *[other] პარამეტრები
    }
about-logins-menu-menuitem-help = დახმარება
menu-menuitem-android-app = { -lockwise-brand-short-name } Android-ისთვის
menu-menuitem-iphone-app = { -lockwise-brand-short-name } iPhone-ისა და iPad-ისთვის

## Login List

login-list =
    .aria-label = მოძიებული ანგარიშების მონაცემები
login-list-count =
    { $count ->
        [one] { $count } ანგარიშის მონაცემი
       *[other] { $count } ანგარიშის მონაცემი
    }
login-list-sort-label-text = დალაგება:
login-list-name-option = ანბანური
login-list-name-reverse-option = ანბანური (Z-A)
about-logins-login-list-alerts-option = ცნობები
login-list-last-changed-option = ბოლოს ჩასწორებული
login-list-last-used-option = ბოლოს გამოყენებული
login-list-intro-title = მონაცემები ვერ მოიძებნა
login-list-intro-description = როცა პაროლს შეინახავს { -brand-product-name }, გამოჩნდება აქ.
about-logins-login-list-empty-search-title = მონაცემები ვერ მოიძებნა
about-logins-login-list-empty-search-description = ძიების შესაბამისი შედეგები ვერ მოიძებნა.
login-list-item-title-new-login = ანგარიშის ახალი მონაცემები
login-list-item-subtitle-new-login = შეიყვანეთ თქვენი მონაცემები
login-list-item-subtitle-missing-username = (მომხმარებლის სახელის გარეშე)
about-logins-list-item-breach-icon =
    .title = იერიშმიტანილი საიტი
about-logins-list-item-vulnerable-password-icon =
    .title = დაუცველი პაროლი

## Introduction screen

login-intro-heading = ანგარიშის შენახულ მონაცემებს ეძებთ? გამართეთ { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = თქვენი ანგარიშების შენახულ მონაცემებს ეძებთ? გამართეთ { -sync-brand-short-name } ან გადმოიტანეთ.
about-logins-login-intro-heading-logged-in = დასინქრონებული ანგარიშები ვერ მოიძებნა.
login-intro-description = თუ თქვენს მონაცემებს { -brand-product-name } სხვა მოწყობილობაზე ინახავს, ნახეთ როგორ უნდა გადმოიტანოთ აქ:
login-intro-instruction-fxa = შედით ან შექმენით { -fxaccount-brand-name } იმ მოწყობილობიდან, რომელზეც თქვენი ანგარიშები ინახება
login-intro-instruction-fxa-settings = დარწმუნდით, რომ მონიშნული გაქვთ ანგარიშების უჯრა { -sync-brand-short-name(case: "gen") } პარამეტრებში
about-logins-intro-instruction-help = იხილეთ <a data-l10n-name="help-link">{ -lockwise-brand-short-name }-მხარდაჭერის</a> გვერდი, დახმარების მისაღებად
about-logins-intro-import = თუ თქვენი ანგარიშების მონაცემებ, სხვა ბრაუზერში ინახება, შეგიძლიათ <a data-l10n-name="import-link">გადმოიტანოთ { -lockwise-brand-short-name }-ში</a>

about-logins-intro-import2 = თუ თქვენი ანგარიში მონაცემებს { -brand-product-name } არ ინახავდა, შეგიძლიათ <a data-l10n-name="import-browser-link">გადმოიტანოთ სხვა ბრაუზერიდან</a> ან <a data-l10n-name="import-file-link">პირდაპირ ფაილიდან</a>

## Login

login-item-new-login-title = ანგარიშის ახალი მონაცემები
login-item-edit-button = ჩასწორება
about-logins-login-item-remove-button = მოცილება
login-item-origin-label = საიტის მისამართი
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = მომხმარებლის სახელი
about-logins-login-item-username =
    .placeholder = (მომხმარებლის სახელის გარეშე)
login-item-copy-username-button-text = ასლი
login-item-copied-username-button-text = ასლი აღებულია!
login-item-password-label = პაროლი
login-item-password-reveal-checkbox =
    .aria-label = პაროლის ჩვენება
login-item-copy-password-button-text = ასლი
login-item-copied-password-button-text = ასლი აღებულია!
login-item-save-changes-button = ცვლილებების შენახვა
login-item-save-new-button = შენახვა
login-item-cancel-button = გაუქმება
login-item-time-changed = ბოლო ცვლილება: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = შექმნილი: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = ბოლო გამოყენება: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = მონაცემების ჩასასწორებლად, დაამოწმეთ Windows-ანგარიში. ეს დაგეხმარებათ დაიცვათ თქვენი ანგარიშების უსაფრთხოება.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = შენახული მონაცემის ჩასწორებას

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = პაროლის სანახავად, დაამოწმეთ Windows-ანგარიში. ეს დაგეხმარებათ დაიცვათ თქვენი ანგარიშების უსაფრთხოება.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = შენახულ პაროლთან წვდომას

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = პაროლის ასლის ასაღებად, დაამოწმეთ Windows-ანგარიში. ეს დაგეხმარებათ დაიცვათ თქვენი ანგარიშების უსაფრთხოება.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = შენახული პაროლის ასლის აღებას

## Master Password notification

master-password-notification-message = გთხოვთ, შეიყვანოთ თქვენი მთავარი პაროლი, შენახული ანგარიშებისა და პაროლების სანახავად

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = მონაცემების გასატანად, დაამოწმეთ Windows-ანგარიში. ეს დაგეხმარებათ დაიცვათ თქვენი ანგარიშების უსაფრთხოება.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = ანგარიშების მონაცემებისა და პაროლების გატანა

## Primary Password notification

about-logins-primary-password-notification-message = გთხოვთ, შეიყვანოთ თქვენი მთავარი პაროლი, შენახული ანგარიშებისა და პაროლების სანახავად
master-password-reload-button =
    .label = შესვლა
    .accesskey = ლ

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] გსურთ თქვენი ანგარიშები თან იქონიოთ ყველგან, სადაც { -brand-product-name } გიყენიათ? გადადით { -sync-brand-short-name(case: "gen") } პარამეტრებში და მონიშნეთ ანგარიშების უჯრა.
       *[other] გსურთ თქვენი ანგარიშები თან იქონიოთ ყველგან, სადაც { -brand-product-name } გიყენიათ? გადადით { -sync-brand-short-name(case: "gen") } პარამეტრებში და მონიშნეთ ანგარიშების უჯრა.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] იხილეთ { -sync-brand-short-name(case: "gen") } პარამეტრები
           *[other] იხილეთ { -sync-brand-short-name(case: "gen") } პარამეტრები
        }
    .accesskey = ი
about-logins-enable-password-sync-dont-ask-again-button =
    .label = მომავალში შეკითხვის გარეშე
    .accesskey = გ

## Dialogs

confirmation-dialog-cancel-button = გაუქმება
confirmation-dialog-dismiss-button =
    .title = გაუქმება

about-logins-confirm-remove-dialog-title = მოცილდეს ეს მონაცემები?
confirm-delete-dialog-message = ეს ქმედება შეუქცევადია.
about-logins-confirm-remove-dialog-confirm-button = მოცილება

about-logins-confirm-export-dialog-title = მონაცემებისა და პაროლების გატანა
about-logins-confirm-export-dialog-message = თქვენი პაროლები შეინახება წასაკითხ ტექსტად (მაგ. BadP@ssw0rd) ასე რომ, ნებისმიერს შეეძლება მათი ნახვა, თუ გატანილ ფაილს გახსნის.
about-logins-confirm-export-dialog-confirm-button = გატანა…

confirm-discard-changes-dialog-title = გაუქმდეს შეუნახავი ცვლილებები?
confirm-discard-changes-dialog-message = ყველა შეუნახავი ცვლილება დაიკარგება.
confirm-discard-changes-dialog-confirm-button = გაუქმება

## Breach Alert notification

about-logins-breach-alert-title = იერიშმიტანილი საიტი
breach-alert-text = პაროლების მონაცემები გაიტაცეს ან გაჟონა ამ საიტიდან მას შემდეგ, რაც ბოლოს განაახლეთ თქვენი ანგარიშის ინფორმაცია. ანგარიშის უსაფრთხოებისთვის, შეცვალეთ თქვენი პაროლი.
about-logins-breach-alert-date = მიტაცების თარიღი { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = გადასვლა საიტზე { $hostname }
about-logins-breach-alert-learn-more-link = იხილეთ ვრცლად

## Vulnerable Password notification

about-logins-vulnerable-alert-title = დაუცველი პაროლი
about-logins-vulnerable-alert-text2 = ეს პაროლი გამოყენებული იყო სხვა ანგარიშზე, რომელიც მიტაცებულ მონაცემებშია მოხვედრილი. იმავე პაროლის სხვაგან გამოყენება, საფრთხის ქვეშ აყენებს ყველა თქვენს ანგარიშს. შეცვალეთ აღნიშნული პაროლი.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = გადასვლა საიტზე { $hostname }
about-logins-vulnerable-alert-learn-more-link = იხილეთ ვრცლად

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = ჩანაწერი ანგარიშისთვის { $loginTitle } ამ მომხმარებლის სახელით უკვე არსებობს. <a data-l10n-name="duplicate-link">გსურთ გასავლა ამ ჩანაწერზე?</a>

# This is a generic error message.
about-logins-error-message-default = შეცდომა, ამ პაროლის შენახვისას.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = მონაცემების ფაილის გატანა
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = გატანა
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-დოკუმენტი
       *[other] CSV-ფაილი
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = მონაცემების ფაილის გადმოტანა
about-logins-import-file-picker-import-button = გადმოტანა
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-დოკუმენტი
       *[other] CSV-ფაილი
    }
