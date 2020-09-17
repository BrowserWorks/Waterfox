# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Titouroù kennaskañ

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Kemerit ho kerioù-tremen e pep lec'h
login-app-promo-subtitle = Tapit an arload { -lockwise-brand-name } digoust
login-app-promo-android =
    .alt = Tapit anezhañ war Google Play
login-app-promo-apple =
    .alt = Pellgargit anezhañ war an App Store
login-filter =
    .placeholder = Klask titouroù kennaskañ
create-login-button = Krouiñ un titour nevez
fxaccounts-sign-in-text = Adkavit ho kerioù-tremen war ho trevnadoù all
fxaccounts-sign-in-button = Kennaskit da { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Merañ ar gont

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Digeriñ al lañser
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Enporzhiañ eus ur merdeer all...
about-logins-menu-menuitem-import-from-a-file = Enporzhiañ adalek ur restr…
about-logins-menu-menuitem-export-logins = Ezporzhiañ an titouroù kennaskañ…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Dibarzhioù
       *[other] Gwellvezioù
    }
about-logins-menu-menuitem-help = Skoazell
menu-menuitem-android-app = { -lockwise-brand-short-name } evit Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } evit iPhone hag iPad

## Login List

login-list =
    .aria-label = Titouroù kennaskañ a glot gant ar c'hlask
login-list-count =
    { $count ->
        [one] { $count } titour kennaskañ
        [two] { $count } ditour kennaskañ
        [few] { $count } zitour kennaskañ
        [many] { $count } a ditouroù kennaskañ
       *[other] { $count } titour kennaskañ
    }
login-list-sort-label-text = Rummañ dre:
login-list-name-option = Anv (A-Z)
login-list-name-reverse-option = Anv (Z-A)
about-logins-login-list-alerts-option = Kemennoù diwall
login-list-last-changed-option = Kemmet da ziwezhañ
login-list-last-used-option = Arveret da ziwezhañ
login-list-intro-title = Titour kennaskañ ebet kavet
login-list-intro-description = Pa enrollit ur ger-tremen e { -brand-product-name } e vo diskouezet amañ
about-logins-login-list-empty-search-title = Titour kennaskañ ebet kavet
about-logins-login-list-empty-search-description = N'eus disoc'h ebet a glot gant ho c'hlask
login-list-item-title-new-login = Titour kennaskañ nevez
login-list-item-subtitle-new-login = Enankit ho titouroù kennaskañ
login-list-item-subtitle-missing-username = (anv arveriad ebet)
about-logins-list-item-breach-icon =
    .title = Lec'hienn frailhet
about-logins-list-item-vulnerable-password-icon =
    .title = Ger-tremen bresk

## Introduction screen

login-intro-heading = Klask a rit ho titouroù kennaskañ? Arventennit { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-out = Klask a rit ho titouroù kennaskañ enroller? Arventennit { -sync-brand-short-name } pe enporzhit anezho.
about-logins-login-intro-heading-logged-in = N'eus bet kavet titour kennaskañ ebet.
login-intro-description = M'ho peus enrollet ho titouroù kennaskañ { -brand-product-name } war un trevnad all, setu penaos kaout anezho amañ:
login-intro-instruction-fxa = Krouit pe kennaskit d'ho { -fxaccount-brand-name } war an trevnad lec'h m'eo enrollet ho titouroù kennaskañ
login-intro-instruction-fxa-settings = Gwiriekait ho peus diuzet ar boestoù kevaskañ Kennaskañ e arventennoù { -sync-brand-short-name }
about-logins-intro-instruction-help = Kit war <a data-l10n-name="help-link">skoazell { -lockwise-brand-short-name }</a> evit kaout sikour
about-logins-intro-import = Mard eo enrollet ho titouroù kennaskañ en ur merdeer all e c'hallit <a data-l10n-name="import-link">enporzhiañ anezho e { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Mard eo enrollet ho titouroù kennaskañ e diavaez { -brand-product-name } e c'hallit a data-l10n-name="import-browser-link">enporzhiañ anezho adalek ur merdeer all</a> pe <a data-l10n-name="import-file-link">adalek ur restr</a>

## Login

login-item-new-login-title = Krouiñ un titour kennaskañ nevez
login-item-edit-button = Embann
about-logins-login-item-remove-button = Dilemel
login-item-origin-label = Chomlec'h al lec'hienn
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Anv arveriad
about-logins-login-item-username =
    .placeholder = (anv arveriad ebet)
login-item-copy-username-button-text = Eilañ
login-item-copied-username-button-text = Eilet!
login-item-password-label = Ger-tremen
login-item-password-reveal-checkbox =
    .aria-label = Diskouez ar ger-tremen
login-item-copy-password-button-text = Eilañ
login-item-copied-password-button-text = Eilet!
login-item-save-changes-button = Enrollañ ar c'hemmoù
login-item-save-new-button = Enrollañ
login-item-cancel-button = Nullañ
login-item-time-changed = Kemmet da ziwezhañ: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Krouet: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Implijet da ziwezhañ: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Evit kemmañ ho titouroù kennaskañ, enankit reoù ho kont Windows. Skoazellañ a ra gwarez ho kontoù.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = cheñch an anaouder enrollet
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Evit gwelout ho ker-tremen, enankit ho titouroù kennaskañ Windows. Skoazellañ a ra da wareziñ ho kontoù.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = diskouez ar ger-tremen enrollet
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Evit eilañ ho ker-tremen, enankit ho titouroù kennaskañ Windows. Skoazellañ a ra da wareziñ ho kontoù.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = eilañ ar ger-tremen enrollet

## Master Password notification

master-password-notification-message = Enankit ho ker-tremen mestr evit gwelout an titouroù kennaskañ enrollet
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Evit ezporzhiañ ho titouroù kennaskañ, enankit ho titouroù Windows. Sikour a ra da wareziñ diogelroez ho kontoù.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = ezporzhiañ an titouroù kennaskañ enrollet

## Primary Password notification

about-logins-primary-password-notification-message = Enankit ho ker-tremen pennañ evit gwelout an titouroù kennaskañ enrollet
master-password-reload-button =
    .label = Kennaskañ
    .accesskey = K

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Fellout a ra deoc'h kaout ho titouroù kennaskañ e pep lec'h ma arverit { -brand-product-name }? Kit e-barzh dibarzhioù { -sync-brand-short-name } ha diuzit ar voest kevaskañ Titouroù kennaskañ.
       *[other] Fellout a ra deoc'h kaout ho titouroù kennaskañ e pep lec'h ma arverit { -brand-product-name }? Kit e-barzh gwellvezioù { -sync-brand-short-name } ha diuzit ar voest kevaskañ Titouroù kennaskañ.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Dibarzhioù { -sync-brand-short-name }
           *[other] Gwellvezioù { -sync-brand-short-name }
        }
    .accesskey = o
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Na c'houlennit en-dro
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Nullañ
confirmation-dialog-dismiss-button =
    .title = Nullañ
about-logins-confirm-remove-dialog-title = Dilemel an titour kennaskañ-mañ?
confirm-delete-dialog-message = N'haller ket dizober kement-se.
about-logins-confirm-remove-dialog-confirm-button = Dilemel
about-logins-confirm-export-dialog-title = Ezporzhiañ an titouroù kennaskañ
about-logins-confirm-export-dialog-message = Enrollet e vo ar gerioù-tremen dindan ur stumm lennus (sk: g3rTremenF4ll) neuze e c'hallo bezañ lennet gant an holl a c'hall digeriñ ar restr ezporzhiet.
about-logins-confirm-export-dialog-confirm-button = Ezporzhiañ…
confirm-discard-changes-dialog-title = Dilezel ar c'hemmoù n'int ket bet enrollet?
confirm-discard-changes-dialog-message = An holl c'hemmoù n'int ket bet enrollet a vo kollet.
confirm-discard-changes-dialog-confirm-button = Dilezel

## Breach Alert notification

about-logins-breach-alert-title = Fuadur el lec'hienn
breach-alert-text = Gerioù-tremen a zo bet diskuilhet pe laeret abaoe ar wech ziwezhañ m'ho peus hizivaet ho titouroù kennaskañ. Cheñchit ho ker-tremen evit gwareziñ ho kont.
about-logins-breach-alert-date = C'hoarvezet eo bet ar fuadur d'ar { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Mont da { $hostname }
about-logins-breach-alert-learn-more-link = Gouzout hiroc'h

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Ger-tremen bresk
about-logins-vulnerable-alert-text2 = Ar ger-tremen-mañ a zo bet implijet en ur gont-all ha marteze eo bet lakaet en arvar abalamour d'ur fuadur roadennoù. Implijout en-dro an titouroù-se a lak holl kontoù ac'hanoc'h en arvar. Cheñchit ar ger-tremen-mañ.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Mont da { $hostname }
about-logins-vulnerable-alert-learn-more-link = Gouzout hiroc'h

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Un enankad evit { $loginTitle } gant an anv arveriad-mañ a zo dioutañ endeo. <a data-l10n-name="duplicate-link">Mont d'an enankad?</a>
# This is a generic error message.
about-logins-error-message-default = Degouezhet ez eus bet ur fazi en ur glask enrollañ ar ger-tremen-mañ

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Ezporzhiañ ar restr titouroù kennaskañ
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Ezporzhiañ
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Teul CSV
       *[other] Restr CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Enporzhiañ restr an titouroù kennaskañ
about-logins-import-file-picker-import-button = Enporzhiañ
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Restr CSV
       *[other] Restr CSV
    }
