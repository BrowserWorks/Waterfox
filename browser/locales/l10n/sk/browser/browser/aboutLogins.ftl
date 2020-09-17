# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Prihlasovacie údaje

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Vezmite si svoje heslá so sebou
login-app-promo-subtitle = Prevezmite si bezplatnú aplikáciu { -lockwise-brand-name }
login-app-promo-android =
    .alt = Prevziať z Obchodu Play
login-app-promo-apple =
    .alt = Prevziať z App Store

login-filter =
    .placeholder = Hľadať

create-login-button = Nové prihlasovacie údaje

fxaccounts-sign-in-text = Synchronizujte svoje heslá aj do ostatných zariadení
fxaccounts-sign-in-button = Prihlásiť sa do služby { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Správa účtu

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Otvoriť ponuku
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importovať z iného prehliadača…
about-logins-menu-menuitem-import-from-a-file = Importovať zo súboru…
about-logins-menu-menuitem-export-logins = Exportovať prihlasovacie údaje…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Možnosti
       *[other] Možnosti
    }
about-logins-menu-menuitem-help = Pomocník
menu-menuitem-android-app = { -lockwise-brand-short-name } pre Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } pre iPhone a iPad

## Login List

login-list =
    .aria-label = Nájdené prihlasovacie údaje
login-list-count =
    { $count ->
        [one] { $count } prihlasovací údaj
        [few] { $count } prihlasovacie údaje
       *[other] { $count } prihlasovacích údajov
    }
login-list-sort-label-text = Zoradiť podľa:
login-list-name-option = názvu (A-Z)
login-list-name-reverse-option = názvu (Z-A)
about-logins-login-list-alerts-option = Upozornenia
login-list-last-changed-option = poslednej úpravy
login-list-last-used-option = posledného použitia
login-list-intro-title = Nenašli sa žiadne prihlasovacie údaje
login-list-intro-description = Tu sa zobrazia prihlasovacie údaje uložené v aplikácii { -brand-product-name }.
about-logins-login-list-empty-search-title = Nenašli sa žiadne prihlasovacie údaje
about-logins-login-list-empty-search-description = Vášmu vyhľadávaniu nezodpovedajú žiadne výsledky.
login-list-item-title-new-login = Nové prihlasovacie údaje
login-list-item-subtitle-new-login = Zadajte svoje prihlasovacie údaje
login-list-item-subtitle-missing-username = (žiadne používateľské meno)
about-logins-list-item-breach-icon =
    .title = Únik dát
about-logins-list-item-vulnerable-password-icon =
    .title = Zraniteľné heslo

## Introduction screen

login-intro-heading = Hľadáte svoje uložené prihlasovacie údaje? Nastavte si { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Hľadáte svoje uložené prihlasovacie údaje? Nastavte si { -sync-brand-short-name } alebo si ich importujte.
about-logins-login-intro-heading-logged-in = Neboli nájdené žiadne synchronizované prihlasovacie údaje.
login-intro-description = Ak ste si uložili prihlasovacie údaje do aplikácie { -brand-product-name } na inom zariadení, môžete ich získať takto:
login-intro-instruction-fxa = Vytvorte si { -fxaccount-brand-name } alebo sa doň prihláste na zariadení, kde máte prihlasovacie údaje uložené
login-intro-instruction-fxa-settings = Uistite sa, že máte v nastaveniach služby { -sync-brand-short-name } na danom zariadení zaškrtnutú možnosť synchronizácie prihlasovacích údajov
about-logins-intro-instruction-help = Ak potrebujete ďalšiu pomoc, navštívte <a data-l10n-name="help-link">pomocníka { -lockwise-brand-short-name }</a>
about-logins-intro-import = Ak máte prihlasovacie údaje uložené v inom prehliadači, môžete ich <a data-l10n-name="import-link">do { -lockwise-brand-short-name } importovať</a>

about-logins-intro-import2 = Ak máte prihlasovacie údaje uložené mimo aplikácie { -brand-product-name }, môžete ich <a data-l10n-name="import-browser-link">importovať z iného prehliadača</a> alebo <a data-l10n-name="import-file-link">zo súboru</a>

## Login

login-item-new-login-title = Nové prihlasovacie údaje
login-item-edit-button = Upraviť
about-logins-login-item-remove-button = Odstrániť
login-item-origin-label = Adresa webovej stránky
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Používateľské meno
about-logins-login-item-username =
    .placeholder = (žiadne používateľské meno)
login-item-copy-username-button-text = Kopírovať
login-item-copied-username-button-text = Skopírované!
login-item-password-label = Heslo
login-item-password-reveal-checkbox =
    .aria-label = Zobraziť heslo
login-item-copy-password-button-text = Kopírovať
login-item-copied-password-button-text = Skopírované!
login-item-save-changes-button = Uložiť zmeny
login-item-save-new-button = Uložiť
login-item-cancel-button = Zrušiť
login-item-time-changed = Posledná úprava: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Dátum vytvorenia: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Naposledy použité: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Ak chcete zobraziť svoje prihlasovacie údaje, zadajte svoje prihlasovacie údaje k systému Windows. Toto opatrenie nám pomáha v zabezpečení vášho účtu.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = upraviť uložené prihlasovacie údaje

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Ak chcete zobraziť svoje heslo, zadajte svoje prihlasovacie údaje k systému Windows. Toto opatrenie nám pomáha v zabezpečení vášho účtu.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = zobraziť uložené heslo

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Ak chcete skopírovať svoje heslo, zadajte svoje prihlasovacie údaje k systému Windows. Toto opatrenie nám pomáha v zabezpečení vášho účtu.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = skopírovať uložené heslo

## Master Password notification

master-password-notification-message = Ak chcete zobraziť uložené prihlasovacie údaje, zadajte svoje hlavné heslo

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Ak chcete exportovať svoje prihlasovacie údaje, zadajte svoje prihlasovacie údaje k systému Windows. Toto opatrenie nám pomáha v zabezpečení vášho účtu.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportovať uložené prihlasovacie údaje

## Primary Password notification

about-logins-primary-password-notification-message = Ak chcete zobraziť uložené prihlasovacie údaje, zadajte svoje hlavné heslo
master-password-reload-button =
    .label = Prihlásiť sa
    .accesskey = P

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Chcete mať svoje heslá všade so sebou? Otvorte nastavenia služby { -sync-brand-short-name } a zaškrtnite možnosť synchronizácie prihlasovacích údajov.
       *[other] Chcete mať svoje heslá všade so sebou? Otvorte nastavenia služby { -sync-brand-short-name } a zaškrtnite možnosť synchronizácie prihlasovacích údajov.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Navštívte možnosti aplikácie { -sync-brand-short-name }
           *[other] Navštívte možnosti aplikácie { -sync-brand-short-name }
        }
    .accesskey = m
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Nabudúce sa už nepýtať
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Zrušiť
confirmation-dialog-dismiss-button =
    .title = Zrušiť

about-logins-confirm-remove-dialog-title = Chcete odstrániť tento prihlasovací údaj?
confirm-delete-dialog-message = Túto akciu nie je možné vrátiť späť.
about-logins-confirm-remove-dialog-confirm-button = Odstrániť

about-logins-confirm-export-dialog-title = Exportovať prihlasovacie údaje
about-logins-confirm-export-dialog-message = Vaše heslá budú uložené v čitateľnom formáte (napr. h3slo) takže ktokoľvek, kto bude môcť otvoriť tento súbor, bude môcť zistiť vaše heslá.
about-logins-confirm-export-dialog-confirm-button = Exportovať…

confirm-discard-changes-dialog-title = Chcete zahodiť neuložené zmeny?
confirm-discard-changes-dialog-message = Všetky neuložené zmeny budú stratené.
confirm-discard-changes-dialog-confirm-button = Zahodiť

## Breach Alert notification

about-logins-breach-alert-title = Únik z webovej stránky
breach-alert-text = Na tejto stránke prišlo od vašej poslednej zmeny prihlasovacích údajov k úniku dát. Za účelom ochrany vášho účtu vám odporúčame zmeniť si heslo.
about-logins-breach-alert-date = K tomuto úniku došlo { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Prejsť na { $hostname }
about-logins-breach-alert-learn-more-link = Ďalšie informácie

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Zraniteľné heslo
about-logins-vulnerable-alert-text2 = Toto heslo bolo použité na inom účte, ktorý bol pravdepodobne súčasťou úniku dát. Opakované používanie hesiel ohrozuje všetky vaše účty. Zmeňte toto heslo.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Prejsť na { $hostname }
about-logins-vulnerable-alert-learn-more-link = Ďalšie informácie

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Prihlasovacie údaje pre { $loginTitle } s rovnakým používateľským menom už existujú. <a data-l10n-name="duplicate-link">Prejsť na existujúce prihlasovacie údaje.</a>

# This is a generic error message.
about-logins-error-message-default = Pri pokuse o uloženie tohto hesla nastala chyba.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportovať súbor s prihlasovacími údajmi
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Exportovať
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Súbor CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importovať súbor s prihlasovacími údajmi
about-logins-import-file-picker-import-button = Importovať
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Súbor CSV
    }
