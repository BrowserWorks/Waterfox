# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Přihlašovací údaje

# "Google Play" and "App Store" are both branding and should not be translated

login-filter =
    .placeholder = Hledat přihlašovací údaje

create-login-button = Nové přihlašovací údaje

fxaccounts-sign-in-text = Synchronizujte svá hesla i do ostatních zařízení
fxaccounts-sign-in-sync-button = Přihlásit se k synchronizaci
fxaccounts-avatar-button =
    .title = Správa účtu

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Otevřít nabídku
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importovat z jiného prohlížeče…
about-logins-menu-menuitem-import-from-a-file = Importovat ze souboru
about-logins-menu-menuitem-export-logins = Exportovat přihlašovací údaje
about-logins-menu-menuitem-remove-all-logins = Smazat všechny přihlašovací údaje
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Možnosti
       *[other] Předvolby
    }
about-logins-menu-menuitem-help = Nápověda

## Login List

login-list =
    .aria-label = Nalezené přihlašovací údaje
login-list-count =
    { $count ->
        [0] žádné přihlašovací údaje
        [one] jedny přihlašovací údaje
        [2] dvoje přihlašovací údaje
        [3] troje přihlašovací údaje
        [4] čtvery přihlašovací údaje
        [few] { $count } přihlašovací údaje
       *[other] { $count } přihlašovacích údajů
    }
login-list-sort-label-text = Seřadit podle:
login-list-name-option = názvu (A-Z)
login-list-name-reverse-option = názvu (Z-A)
login-list-username-option = uživ. jména (A-Z)
login-list-username-reverse-option = uživ. jména (Z-A)
about-logins-login-list-alerts-option = upozornění
login-list-last-changed-option = naposledy změněno
login-list-last-used-option = naposledy použito
login-list-intro-title = Nenalezeny žádné přihlašovací údaje
login-list-intro-description =
    Tady se zobrazí přihlašovací údaje uložené { -brand-product-name.gender ->
        [masculine] ve { -brand-product-name(case: "loc") }
        [feminine] v { -brand-product-name(case: "loc") }
        [neuter] v { -brand-product-name(case: "loc") }
       *[other] v aplikaci { -brand-product-name }
    }.
about-logins-login-list-empty-search-title = Nenalezeny žádné přihlašovací údaje
about-logins-login-list-empty-search-description = Vašemu vyhledávání neodpovídají žádné přihlašovací údaje.
login-list-item-title-new-login = Nové přihlašovací údaje
login-list-item-subtitle-new-login = Zadejte své přihlašovací údaje
login-list-item-subtitle-missing-username = (žádné uživatelské jméno)
about-logins-list-item-breach-icon =
    .title = Na tomto serveru došlo k úniku dat
about-logins-list-item-vulnerable-password-icon =
    .title = Zranitelné heslo

about-logins-list-section-breach = Servery, kde došlo k úniku dat
about-logins-list-section-vulnerable = Zranitelná hesla
about-logins-list-section-nothing = Žádná upozornění
about-logins-list-section-today = Dnes
about-logins-list-section-yesterday = Včera
about-logins-list-section-week = Posledních 7 dní

## Introduction screen

about-logins-login-intro-heading-logged-out2 = Hledáte své uložené přihlašovací údaje? Zapněte si synchronizaci nebo je naimportujte.
about-logins-login-intro-heading-logged-in = Nenalezeny žádné synchronizované přihlašovací údaje.
login-intro-description =
    Pokud jste si přihlašovací údaje uložili do { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "gen") }
        [feminine] { -brand-product-name(case: "gen") }
        [neuter] { -brand-product-name(case: "gen") }
       *[other] aplikace { -brand-product-name }
    }, ale na jiném zařízení, můžete je zde získat takto:
login-intro-instructions-fxa = Vytvořte nebo se přihlaste k { -fxaccount-brand-name(case: "dat", capitalization: "lower") } na zařízení, kde máte přihlašovací údaje uložené.
login-intro-instructions-fxa-settings = Otevřete Nastavení > Synchronizace > Zapnout synchronizaci… a vyberte položku Přihlašovací údaje.
login-intro-instructions-fxa-help = Pro další pomoc navštivte <a data-l10n-name="help-link">nápovědu { -lockwise-brand-short-name(case: "gen") }</a>.
about-logins-intro-import = Pokud máte přihlašovací údaje uložené v jiném prohlížeči, můžete je <a data-l10n-name="import-link">naimportovat do { -lockwise-brand-short-name(case: "gen") }</a>
about-logins-intro-import2 = Pokud máte přihlašovací údaje uložené mimo { -brand-product-name(case: "acc") }, můžete je <a data-l10n-name="import-browser-link">naimportovat z jiného prohlížeče</a> nebo <a data-l10n-name="import-file-link">ze souboru</a>

## Login

login-item-new-login-title = Nové přihlašovací údaje
login-item-edit-button = Upravit
about-logins-login-item-remove-button = Odstranit
login-item-origin-label = Adresa serveru
login-item-tooltip-message = Zkontrolujte, že toto pole přesně odpovídá adrese serveru, kde se přihlašujete.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Uživatelské jméno
about-logins-login-item-username =
    .placeholder = (žádné uživatelské jméno)
login-item-copy-username-button-text = Kopírovat
login-item-copied-username-button-text = Zkopírováno!
login-item-password-label = Heslo
login-item-password-reveal-checkbox =
    .aria-label = Zobrazit heslo
login-item-copy-password-button-text = Kopírovat
login-item-copied-password-button-text = Zkopírováno!
login-item-save-changes-button = Uložit změny
login-item-save-new-button = Uložit
login-item-cancel-button = Zrušit
login-item-time-changed = Naposledy změněno { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Vytvořeno { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Naposledy použito { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Pro úpravu přihlašovacích údajů prosím zadejte své přihlašovací údaje k systému Windows. Toto opatření pomáhá v zabezpečení vašich účtů.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = upravit uložené přihlašovací údaje

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Pro zobrazení hesla prosím zadejte své přihlašovací údaje k systému Windows. Toto opatření pomáhá v zabezpečení vašich účtů.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = zobrazit uložené heslo

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Pro zkopírování hesla prosím zadejte své přihlašovací údaje k systému Windows. Toto opatření pomáhá v zabezpečení vašich účtů.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = zkopírovat uložené heslo

## Master Password notification

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Pro export přihlašovacích údajů prosím zadejte své přihlašovací údaje k systému Windows. Toto opatření pomáhá v zabezpečení vašich účtů.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportovat uložené přihlašovací údaje a hesla

## Primary Password notification

about-logins-primary-password-notification-message = Pro zobrazení uložených přihlašovacích údajů prosím zadejte své hlavní heslo
master-password-reload-button =
    .label = Přihlásit se
    .accesskey = P

## Password Sync notification

## Dialogs

confirmation-dialog-cancel-button = Zrušit
confirmation-dialog-dismiss-button =
    .title = Zrušit

about-logins-confirm-remove-dialog-title = Odstranit tyto přihlašovací údaje?
confirm-delete-dialog-message = Tuto akci nelze vzít zpět.
about-logins-confirm-remove-dialog-confirm-button = Odstranit

about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Odstranit
        [one] Odstranit
        [few] Odstranit vše
       *[other] Odstranit vše
    }

about-logins-confirm-remove-all-dialog-checkbox-label = Ano, odstranit tyto přihlašovací údaje

about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Odstranit jedny přihlašovací údaje
        [few] Odstranit { $count } přihlašovací údaje
       *[other] Odstranit { $count } přihlašovacích údajů
    }
about-logins-confirm-remove-all-dialog-message =
    Tímto odstraníte všechny přihlašovací údaje uložené { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    } a také všechna zde zobrazovaná hlášení o únicích. Tuto akci nelze vzít zpět.

about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Odstranit jedny přihlašovací údaje ze všech zařízení
        [few] Odstranit { $count } přihlašovací údaje ze všech zařízení
       *[other] Odstranit { $count } přihlašovacích údajů ze všech zařízení
    }
about-logins-confirm-remove-all-sync-dialog-message =
    Tímto odstraníte všechny přihlašovací údaje uložené { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    } na všech zařízeních synchronizovaných pomocí vašeho { -fxaccount-brand-name(case: "gen", capitalization: "lower") } a také všechna zde zobrazovaná hlášení o únicích. Tuto akci nelze vzít zpět.

about-logins-confirm-export-dialog-title = Export přihlašovacích údajů
about-logins-confirm-export-dialog-message = Vaše hesla budou uložena v čitelné podobě (např. Šp4tnéH3sl0) a kdokoliv otevře exportovaný soubor, bude si je moci přečíst.
about-logins-confirm-export-dialog-confirm-button = Exportovat…

about-logins-alert-import-title = Import byl dokončen
about-logins-alert-import-message = Zobrazit podrobné shrnutí importu

confirm-discard-changes-dialog-title = Zahodit neuložené změny?
confirm-discard-changes-dialog-message = Všechny neuložené změny budou ztraceny.
confirm-discard-changes-dialog-confirm-button = Zahodit

## Breach Alert notification

about-logins-breach-alert-title = Únik z webových stránek
breach-alert-text = U tohoto serveru došlo od vaší poslední změny přihlašovacích údajů k úniku dat. V zájmu ochrany vašeho účtu doporučujeme změnit si heslo.
about-logins-breach-alert-date = K tomuto úniku došlo { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Přejít na { $hostname }
about-logins-breach-alert-learn-more-link = Zjistit více

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Zranitelné heslo
about-logins-vulnerable-alert-text2 = Toto heslo jste použili u jiného účtu, který byl pravděpodobně součástí úniku dat. Opakované používání hesel ohrožuje všechny vaše účty. Změňte prosím toto heslo.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Přejít na { $hostname }
about-logins-vulnerable-alert-learn-more-link = Zjistit více

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Přihlašovací údaje pro { $loginTitle } se stejným uživatelským jménem už existují. <a data-l10n-name="duplicate-link">Chcete zobrazit stávající údaje?</a>

# This is a generic error message.
about-logins-error-message-default = Při ukládání hesla nastala chyba.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportovat hesla do souboru
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Exportovat
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Soubor CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Import souboru s přihlašovacími údaji
about-logins-import-file-picker-import-button = Importovat
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Soubor CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Dokument TSV
       *[other] Soubor TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Import byl dokončen
about-logins-import-dialog-items-added = <span>Nově přidané přihlašovací údaje:</span> <span data-l10n-name="count">{ $count }</span>

about-logins-import-dialog-items-modified = <span>Aktualizované přihlašovací údaje:</span> <span data-l10n-name="count">{ $count }</span>

about-logins-import-dialog-items-no-change = <span>Duplicitní přihlašovací údaje:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(neimportováno)</span>
about-logins-import-dialog-items-error = <span>Chyby:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(neimportováno)</span>
about-logins-import-dialog-done = Hotovo

about-logins-import-dialog-error-title = Chyba při importu
about-logins-import-dialog-error-conflicting-values-title = Více konfliktních hodnot pro jedno přihlášení
about-logins-import-dialog-error-conflicting-values-description = Například: více uživatelských jmen, hesel, adres atd. pro jedno přihlášení.
about-logins-import-dialog-error-file-format-title = Problém s formátem souboru
about-logins-import-dialog-error-file-format-description = V souboru chybí záhlaví sloupců, nebo je nesprávné. Zkontrolujte, že soubor obsahuje sloupce s uživatelským jménem, heslem a URL adresou.
about-logins-import-dialog-error-file-permission-title = Soubor nelze načíst
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } nemá oprávnění číst soubor. Zkuste změnit oprávnění souboru.
about-logins-import-dialog-error-unable-to-read-title = Soubor nelze načíst
about-logins-import-dialog-error-unable-to-read-description = Ujistěte se, že jste vybrali soubor typu CSV nebo TSV.
about-logins-import-dialog-error-no-logins-imported = Nebyly naimportovány žádné přihlašovací údaje
about-logins-import-dialog-error-learn-more = Zjistit více
about-logins-import-dialog-error-try-import-again = Zkusit importovat znovu…
about-logins-import-dialog-error-cancel = Zrušit

about-logins-import-report-title = Souhrn
about-logins-import-report-description =
    Přihlašovací údaje importované do { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }.

#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Řádek č. { $number }
about-logins-import-report-row-description-no-change = Duplicitní: Přesná shoda se stávajícími údaji
about-logins-import-report-row-description-modified = Přihlašovací údaje aktualizovány
about-logins-import-report-row-description-added = Přidány nové přihlašovací údaje
about-logins-import-report-row-description-error = Chyba: chybějící pole

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Chyba: více hodnot pro pole { $field }
about-logins-import-report-row-description-error-missing-field = Chyba: chybějící pole { $field }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added = <div data-l10n-name="details">Nově přidané přihlašovací údaje:</div> <div data-l10n-name="count">{ $count }</div>
about-logins-import-report-modified = <div data-l10n-name="details">Aktualizované přihlašovací údaje:</div> <div data-l10n-name="count">{ $count }</div>
about-logins-import-report-no-change = <div data-l10n-name="details">Duplicitní přihlašovací údaje:</div> <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="not-imported">(neimportováno)</div>
about-logins-import-report-error = <div data-l10n-name="details">Chyby:</div> <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="not-imported">(neimportováno)</div>

## Logins import report page

about-logins-import-report-page-title = Importované přihlašovací údaje
