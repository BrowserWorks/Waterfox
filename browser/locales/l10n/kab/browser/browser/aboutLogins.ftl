# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Inekcam & wawalen uffiren

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Awi awalen-ik/um uffiren anda teddiḍ
login-app-promo-subtitle = Zdem asnas n baṭel { -lockwise-brand-name }
login-app-promo-android =
    .alt = Yella di Google Play
login-app-promo-apple =
    .alt = Sader si App Store

login-filter =
    .placeholder = Nadi inekcam

create-login-button = Rnu anekcum amaynut

fxaccounts-sign-in-text = Kcem ɣer wawalen-ik uffiren ɣef yibenkan-nniḍen
fxaccounts-sign-in-button = Qqen ɣer { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Sefrek amiḍan

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Ldi umuɣ
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Kter seg iminig nniḍen…
about-logins-menu-menuitem-import-from-a-file = Kter seg ufaylu…
about-logins-menu-menuitem-export-logins = Sifeḍ inekcam…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] iɣewwaṛen
       *[other] Ismenyifen
    }
about-logins-menu-menuitem-help = Tallalt
menu-menuitem-android-app = { -lockwise-brand-short-name } i Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } i iPhone akked iPad

## Login List

login-list =
    .aria-label = Inekcam mmenṭaḍen d unadi
login-list-count =
    { $count ->
        [one] { $count } anekcum
       *[other] { $count } inekcam
    }
login-list-sort-label-text = Smizzwer s:
login-list-name-option = Isem (A-Z)
login-list-name-reverse-option = Isem (Z-A)
about-logins-login-list-alerts-option = Ilɣa
login-list-last-changed-option = Asnifel aneggaru
login-list-last-used-option = Aseqdec anneggaru
login-list-intro-title = Ulac inekcam yettwafen
login-list-intro-description = Ticki teskelseḍ awal uffir deg { -brand-product-name }, ad d-iban dagi.
about-logins-login-list-empty-search-title = Ulac inekcam yettwafen
about-logins-login-list-empty-search-description = Ula d yiwen n ugmuḍ ur yemmenṭaḍ d unadi-ik.
login-list-item-title-new-login = Anekcum amaynut
login-list-item-subtitle-new-login = Sekcem inekcumen-ik n tuqqna
login-list-item-subtitle-missing-username = (ulas isem n useqdac)
about-logins-list-item-breach-icon =
    .title = Asmel i tḥuza trewla n yisefka
about-logins-list-item-vulnerable-password-icon =
    .title = Awal uffir ur iǧhid ara

## Introduction screen

login-intro-heading = Tettnadiḍ inekcam-ik yettwaskelsen? Swel { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Tettnadiḍ inekcam-ik/im yettwaskelsen? Swel { -sync-brand-short-name } neɣ kter-iten-id.
about-logins-login-intro-heading-logged-in = Ulac inekcam yemtawin i yettwafen.
login-intro-description = Ma teskelseḍ inekcam-ik deg { -brand-product-name } ɣef ddeqs n yibenkan, a-t-an amek ara tkecmeḍ ɣur-sen.
login-intro-instruction-fxa = Rnu neɣ qqen ɣer { -fxaccount-brand-name } inek ɣef yibenk anida ttwaskelsen yinekcam-ik.
login-intro-instruction-fxa-settings = Ḍmed d akken trecmeḍ inekcam-ik deg yiɣewwaṛen n { -sync-brand-short-name }.
about-logins-intro-instruction-help = Rzu ɣer <a data-l10n-name="help-link"> tallelt n { -lockwise-brand-short-name }</a> i wugar n yisallen.
about-logins-intro-import = Ma yella tuqqna-inek tettwasekles deg yiminig-nniḍen, tzemreḍ <a data-l10n-name="import-link"> ad ten-id-ktereḍ seg { -lockwise-brand-short-name }

about-logins-intro-import2 = Ma yella inekcam-ik/im ttwaskelsen beṛṛa n { -brand-product-name }, tzemreḍ <a data-l10n-name="import-browser-link"> ad ten-id-tketreḍ seg yiminig-nniḍen</a> neɣ <a data-l10n-name="import-file-link">seg ufaylu</a>

## Login

login-item-new-login-title = Rnu anekcum amaynut
login-item-edit-button = Ẓreg
about-logins-login-item-remove-button = Kkes
login-item-origin-label = Tansa n usmel web
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Isem n useqdac
about-logins-login-item-username =
    .placeholder = (ulas isem n useqdac)
login-item-copy-username-button-text = Nɣel
login-item-copied-username-button-text = Inɣel!
login-item-password-label = Awal uffir
login-item-password-reveal-checkbox =
    .aria-label = Sken awal uffir
login-item-copy-password-button-text = Nɣel
login-item-copied-password-button-text = Inɣel!
login-item-save-changes-button = Sekles asnifel
login-item-save-new-button = Sekles
login-item-cancel-button = Sefsex
login-item-time-changed = Abeddel aneggaru: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Timerna: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Aseqdec aneggaru: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Akken ad tbeddleḍ anekcam-inek, sekcem inekcam-inek n tuqqna n Windows. Ayagi ad yeḍmen aḥraz n tɣellist n yimiḍanen-inek.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = ẓreg isem n useqdac yettwaskelsen

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Akken ad twaliḍ awal-inek uffir, sekcem inekcam-inek n tuqqna n Windows. Ayagi ad yeḍmen aḥraz n tɣellist n yimiḍanen-inek.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = beggen-d awal-inek uffir yettwaskelsen

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Akken ad d-tneɣleḍ awal-inek uffir, sekcem inekcam-inek n tuqqna n Windows. Ayagi ad iεiwen deg ummesten n tɣellist n yimiḍanen-inek.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = Nɣel awal-inek uffir yettwaskelsen

## Master Password notification

master-password-notification-message = Ma ulac aɣilif, sekcem awal uffir agejdan akken ad twaliḍ inekcam d wawalen uffiren yettwaskelsen

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Akken ad tketreḍ inekcam-inek/inem, sekcem anekcum-inek/inem n tuqqna n Windows. Ayagi ad yeḍmen aḥraz n tɣellist n yimiḍanen-inek.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = Akter n yinekcam d wawalen uffiren yettwasekles

## Primary Password notification

about-logins-primary-password-notification-message = Ma ulac aɣilif, sekcem awal uffir agejdan akken ad twaliḍ inekcam d wawalen uffiren yettwaskelsen
master-password-reload-button =
    .label = Kcem
    .accesskey = K

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Tebɣiḍ ad tkecmeḍ ɣer yinekcam-ik sekra wanida i tesseqdaceḍ { -brand-product-name } ? Ddu ɣer yiɣewwaṛen n { -sync-brand-short-name } sakin ṛcem taxxamt inekcam.
       *[other] Tebɣiḍ ad tkecmeḍ ɣer yinekcam-ik sekra wanida i tesseqdaceḍ { -brand-product-name } ? Ddu ɣer yiɣewwaṛen n { -sync-brand-short-name } sakin ṛcem taxxamt inekcam.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Rzu ɣer yiɣewwaṛen n  { -sync-brand-short-name }
           *[other] Rzu ɣer yismenyifen n  { -sync-brand-short-name }
        }
    .accesskey = C
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Ur yi-d-ssutur ara tikkelt-nniḍen
    .accesskey = U

## Dialogs

confirmation-dialog-cancel-button = Sefsex
confirmation-dialog-dismiss-button =
    .title = Sefsex

about-logins-confirm-remove-dialog-title = Kkes anekcam-agi?
confirm-delete-dialog-message = Ulac tuɣalin ɣer deffir.
about-logins-confirm-remove-dialog-confirm-button = Kkes

about-logins-confirm-export-dialog-title = Sifeḍ inekcam d wawalen uffiren
about-logins-confirm-export-dialog-message = Awalen-inek uffiren ad ttwaskelsen am uḍris ara d-ibanen i tɣuri (d amedya, BadP@ssw0rd) akken yal amdan ara yeldin afaylu i yettusifḍen ad yizmir ad t-iwali.
about-logins-confirm-export-dialog-confirm-button = Kter…

confirm-discard-changes-dialog-title = Sefsex isenfal-agi?
confirm-discard-changes-dialog-message = Akk isnifal ur nettwakles ara ad ttwaksen.
confirm-discard-changes-dialog-confirm-button = Kkes

## Breach Alert notification

about-logins-breach-alert-title = Tarewla n yismal web
breach-alert-text = Awalen uffiren n usmel-a ffɣen neɣ ttwakren deffir n ubeddel aneggaru n telɣut-ik n tuqqna. Beddel awal-ik uffir akken ad yettwamesten umiḍan-ik.
about-logins-breach-alert-date = Tarewla-agi n yisefka teḍra-d deg { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Ddu ɣer { $hostname }
about-logins-breach-alert-learn-more-link = Issin ugar

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Awal uffir ur iǧhid ara
about-logins-vulnerable-alert-text2 = Awal-agi uffir yettwaseqdec deg umiḍan-nniḍen ayagi yezmer ad d-yeglu s trewla n yisefka. Aɛiwed n useqdec n yinekcamen n tuqqna ad yerr akk imiḍanen-inek deg wugur. Beddel awal-agi uffir.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Ddu ɣer { $hostname }
about-logins-vulnerable-alert-learn-more-link = Issin ugar

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Anekcum i { $loginTitle } s yisem-a yella yakan.<a data-l10n-name="duplicate-link"> Ddu ɣer unekcum yellan?</a>

# This is a generic error message.
about-logins-error-message-default = Teḍra-d tuccḍa deg uɛraḍ n usekles n wawal-a uffir.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Afaylu n usifeḍ n yinekcam
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Kter
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Isemli CSV
       *[other] Afaylu CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Afaylu n ukter n yinekcam
about-logins-import-file-picker-import-button = Kter
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Asemli CSV
       *[other] Afaylu CSV
    }
