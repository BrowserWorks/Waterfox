# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Přizjewjenja a hesła

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Wzmiće swoje hesła wšudźe sobu
login-app-promo-subtitle = Wobstarajće sej darmotne nałoženje { -lockwise-brand-name }
login-app-promo-android =
    .alt = Wobstarajće sej jo wot Google Play
login-app-promo-apple =
    .alt = Sćehńće wot App Store

login-filter =
    .placeholder = Přizjewjenja pytać

create-login-button = Nowe přizjewjenje załožić

fxaccounts-sign-in-text = Přinjesće swoje hesła do wašich druhich gratow
fxaccounts-sign-in-button = So pola { -sync-brand-short-name } přizjewić
fxaccounts-avatar-button =
    .title = Konto rjadować

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Meni wočinić
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Z druheho wobhladowaka importować…
about-logins-menu-menuitem-import-from-a-file = Z dataje importować…
about-logins-menu-menuitem-export-logins = Přizjewjenja eksportować…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Nastajenja
       *[other] Nastajenja
    }
about-logins-menu-menuitem-help = Pomoc
menu-menuitem-android-app = { -lockwise-brand-short-name } za Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } za iPhone a iPad

## Login List

login-list =
    .aria-label = Přizjewjenja, kotrež pytanskemu naprašowanju wotpowěduja
login-list-count =
    { $count ->
        [one] { $count } přizjewjenje
        [two] { $count } přizjewjeni
        [few] { $count } přizjewjenja
       *[other] { $count } přizjewjenjow
    }
login-list-sort-label-text = Sortěrować po:
login-list-name-option = Mjenje (A-Z)
login-list-name-reverse-option = Mjeno (Z - A)
about-logins-login-list-alerts-option = Warnowanja
login-list-last-changed-option = Poslednjej změnje
login-list-last-used-option = Poslednim wužiću
login-list-intro-title = Žane přizjewjenja namakane
login-list-intro-description = Hdyž hesło w { -brand-product-name } składujeće, wono so tu pokaza.
about-logins-login-list-empty-search-title = Žane přizjewjenja namakane
about-logins-login-list-empty-search-description = Njejsu žane wuslědki, kotrež wašemu pytanju wotpowěduja.
login-list-item-title-new-login = Nowe přizjewjenje
login-list-item-subtitle-new-login = Zapodajće swoje přizjewjenske daty
login-list-item-subtitle-missing-username = (žane wužiwarske mjeno)
about-logins-list-item-breach-icon =
    .title = Zranjene websydło
about-logins-list-item-vulnerable-password-icon =
    .title = Zranite hesło

## Introduction screen

login-intro-heading = Pytaće swoje składowane přizjewjenja? Konfigurujće { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Pytaće swoje składowane přizjewjenja? Konfigurujće { -sync-brand-short-name } abo importujće je.
about-logins-login-intro-heading-logged-in = Žane synchronizowane přizjewjenja namakane.
login-intro-description = Jeli sće swoje přizjewjenja { -brand-product-name } na druhim graće składował, tak móžeće je sem přinjesć:
login-intro-instruction-fxa = Załožće abo přizjewće so pola swojeho { -fxaccount-brand-name } na graće, hdźež waše přizjewjenja su składowane
login-intro-instruction-fxa-settings = Přeswědčće so, zo sće kontrolny kašćik přizjewjenjow w nastajenjach { -sync-brand-short-name } wubrał
about-logins-intro-instruction-help = Wopytajće <a data-l10n-name="help-link">pomoc { -lockwise-brand-short-name }</a> za wjace pomocy
about-logins-intro-import = Jeli waše přizjewjenja su składowane w druhim wobhladowaku, móžeće <a data-l10n-name="import-link">je do { -lockwise-brand-short-name } importować</a>

about-logins-intro-import2 = Jeli waše přizjewjenja so zwonka { -brand-product-name } składuja, móžeće <a data-l10n-name="import-browser-link">je z druheho wobhladowaka importować</a>, abo <a data-l10n-name="import-file-link">z dataje</a>

## Login

login-item-new-login-title = Nowe přizjewjenje załožić
login-item-edit-button = Wobdźěłać
about-logins-login-item-remove-button = Wotstronić
login-item-origin-label = Adresa websydła
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Wužiwarske mjeno
about-logins-login-item-username =
    .placeholder = (žane wužiwarske mjeno)
login-item-copy-username-button-text = Kopěrować
login-item-copied-username-button-text = Kopěrowane!
login-item-password-label = Hesło
login-item-password-reveal-checkbox =
    .aria-label = Hesło pokazać
login-item-copy-password-button-text = Kopěrować
login-item-copied-password-button-text = Kopěrowane!
login-item-save-changes-button = Změny składować
login-item-save-new-button = Składować
login-item-cancel-button = Přetorhnyć
login-item-time-changed = Poslednja změna: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Wutworjeny: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Poslednje wužiće: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Zapodajće swoje přizjewjenske daty Windows, zo byšće swoje přizjewjenje wobdźěłował. To wěstotu wašich kontow škita.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = składowane přizjewjenje wobdźěłać

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Zapodajće swoje přizjewjenske daty Windows, zo byšće sej swoje hesło wobhladał. To wěstotu wašich kontow škita.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = składowane hesło pokazać

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Zapodajće swoje přizjewjenske daty Windows, zo byšće swoje hesło kopěrował. To wěstotu wašich kontow škita.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = składowane hesło kopěrować

## Master Password notification

master-password-notification-message = Prošu zapodajće swoje hłowne hesło, zo byšće sej składowane přizjewjenja a hesła wobhladał

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Zapodajće swoje přizjewjenske daty Windows, zo byšće swoje přizjewjenja eksportował. To wěstotu wašich kontow škita.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = Składowane přizjewjenja a hesła eksportować

## Primary Password notification

about-logins-primary-password-notification-message = Prošu zapodajće swoje hłowne hesło, zo byšće sej składowane přizjewjenja a hesła wobhladał
master-password-reload-button =
    .label = Přizjewić
    .accesskey = P

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Chceće swoje přizjewjenja wšudźe wužiwać, hdźež { -brand-product-name } wužiwaće? Dźiće k swojim nastajenjam { -sync-brand-short-name } a wubjerće kontrolny kašćik přizjewjenjow.
       *[other] Chceće swoje přizjewjenja wšudźe wužiwać, hdźež { -brand-product-name } wužiwaće? Dźiće k swojim nastajenjam { -sync-brand-short-name } a wubjerće kontrolny kašćik přizjewjenjow.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Nastajenja { -sync-brand-short-name } wopytać
           *[other] Nastajenja { -sync-brand-short-name } wopytać
        }
    .accesskey = N
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Hižo so njeprašeć
    .accesskey = H

## Dialogs

confirmation-dialog-cancel-button = Přetorhnyć
confirmation-dialog-dismiss-button =
    .title = Přetorhnyć

about-logins-confirm-remove-dialog-title = Tute přizjewjenje wotstronić?
confirm-delete-dialog-message = Tuta akcija njeda so cofnyć.
about-logins-confirm-remove-dialog-confirm-button = Wotstronić

about-logins-confirm-export-dialog-title = Přizjewjenja a hesła eksportować
about-logins-confirm-export-dialog-message = Waše hesła budu so jako čitajomny tekst składować (na př. BadP@ass0rd), tohodla móže kóždy, kotryž móže eksportowanu dataju wočinić, je widźeć.
about-logins-confirm-export-dialog-confirm-button = Eksportować…

confirm-discard-changes-dialog-title = Njeskładowane změny zaćisnyć?
confirm-discard-changes-dialog-message = Wšě njeskładowane změny so zhubja.
confirm-discard-changes-dialog-confirm-button = Zaćisnyć

## Breach Alert notification

about-logins-breach-alert-title = Datowa dźěra websydła
breach-alert-text = Hesła su so z tutoho websydła roznjesli abo kradnyli, wot toho, zo sće swoje přizjewjenske daty posledni raz zaktualizował. Změńće swoje hesło, zo byšće swoje konto škitał.
about-logins-breach-alert-date = Tuta datowa dźěra je { DATETIME($date, day: "numeric", month: "long", year: "numeric") } nastała
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = K { $hostname }
about-logins-breach-alert-learn-more-link = Dalše informacije

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Zranite hesło
about-logins-vulnerable-alert-text2 = Tute hesło je so přez druhe konto wužiło, kotrež je najskerje w datowej dźěrje było. Přez wospjetowane wužiwanje přizjewjenskich datow so wšě waše konta riziku wustajeja. Změńće tute hesło.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = K { $hostname }
about-logins-vulnerable-alert-learn-more-link = Dalše informacije

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Zapisk za { $loginTitle } z tym wužiwarskim mjenom hižo eksistuje. <a data-l10n-name="duplicate-link">K eksistowacemu zapiskej?</a>

# This is a generic error message.
about-logins-error-message-default = Při pospyće tute hesło składować, je zmylk nastał.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Dataju přizjewjenjow eksportować
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Eksportować
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokument
       *[other] CSV-dataja
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Dataju přizjewjenjow importować
about-logins-import-file-picker-import-button = Importować
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokument
       *[other] CSV-dataja
    }
