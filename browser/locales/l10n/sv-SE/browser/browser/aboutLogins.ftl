# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Inloggningar & lösenord

# "Google Play" and "App Store" are both branding and should not be translated

login-filter =
    .placeholder = Sök inloggningar

create-login-button = Skapa ny inloggning

fxaccounts-sign-in-text = Få dina lösenord på dina andra enheter
fxaccounts-sign-in-sync-button = Logga in för att synkronisera
fxaccounts-avatar-button =
    .title = Hantera konto

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Öppna meny
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importera från en annan webbläsare…
about-logins-menu-menuitem-import-from-a-file = Importera från en fil…
about-logins-menu-menuitem-export-logins = Exportera inloggningar...
about-logins-menu-menuitem-remove-all-logins = Ta bort alla inloggningar…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Inställningar
       *[other] Inställningar
    }
about-logins-menu-menuitem-help = Hjälp

## Login List

login-list =
    .aria-label = Inloggningar som matchar sökfrågan
login-list-count =
    { $count ->
        [one] { $count } inloggning
       *[other] { $count } inloggningar
    }
login-list-sort-label-text = Sortera efter:
login-list-name-option = Namn (A-Ö)
login-list-name-reverse-option = Namn (Ö-A)
login-list-username-option = Användarnamn (A-Ö)
login-list-username-reverse-option = Användarnamn (Ö-A)
about-logins-login-list-alerts-option = Varningar
login-list-last-changed-option = Senast ändrad
login-list-last-used-option = Senast använd
login-list-intro-title = Inga inloggningar hittades
login-list-intro-description = När du sparar ett lösenord i { -brand-product-name }, kommer det att visas här.
about-logins-login-list-empty-search-title = Inga inloggningar hittades
about-logins-login-list-empty-search-description = Det finns inga resultat som matchar din sökning.
login-list-item-title-new-login = Ny inloggning
login-list-item-subtitle-new-login = Ange dina inloggningsuppgifter
login-list-item-subtitle-missing-username = (inget användarnamn)
about-logins-list-item-breach-icon =
    .title = Webbplats med dataintrång
about-logins-list-item-vulnerable-password-icon =
    .title = Sårbart lösenord

about-logins-list-section-breach = Webbplatser med dataintrång
about-logins-list-section-vulnerable = Sårbara lösenord
about-logins-list-section-nothing = Ingen varning
about-logins-list-section-today = Idag
about-logins-list-section-yesterday = Igår
about-logins-list-section-week = Senaste 7 dagarna

## Introduction screen

about-logins-login-intro-heading-logged-out2 = Letar du efter dina sparade inloggningar? Aktivera synkronisering eller importera dem.
about-logins-login-intro-heading-logged-in = Inga synkroniserade inloggningar hittades.
login-intro-description = Om du sparat dina inloggningar i { -brand-product-name } på en annan enhet, så här får du dem hit:
login-intro-instructions-fxa = Skapa eller logga in på ditt { -fxaccount-brand-name } på enheten där dina inloggningar sparas.
login-intro-instructions-fxa-settings = Gå till Inställningar > Synkronisering > Aktivera synkronisering… Markera kryssrutan Inloggningar och lösenord.
login-intro-instructions-fxa-help = Besök <a data-l10n-name="help-link">{ -lockwise-brand-short-name } support</a> för mer hjälp.
about-logins-intro-import = Om dina inloggningar finns sparade i en annan webbläsare kan du <a data-l10n-name="import-link">importera dem till { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Om dina inloggningar sparas utanför { -brand-product-name } kan du  <a data-l10n-name="import-browser-link">importera dem från en annan webbläsare</a> eller <a data-l10n-name="import-file-link">från en fil</a>

## Login

login-item-new-login-title = Skapa ny inloggning
login-item-edit-button = Redigera
about-logins-login-item-remove-button = Ta bort
login-item-origin-label = Webbadress
login-item-tooltip-message = Se till att detta matchar den exakta adressen till webbplatsen där du loggar in.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Användarnamn
about-logins-login-item-username =
    .placeholder = (Inget användarnamn)
login-item-copy-username-button-text = Kopiera
login-item-copied-username-button-text = Kopierad!
login-item-password-label = Lösenord
login-item-password-reveal-checkbox =
    .aria-label = Visa lösenord
login-item-copy-password-button-text = Kopiera
login-item-copied-password-button-text = Kopierad!
login-item-save-changes-button = Spara ändringar
login-item-save-new-button = Spara
login-item-cancel-button = Avbryt
login-item-time-changed = Senast ändrad: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Skapad: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Senast använt: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Om du vill redigera din inloggning anger du dina inloggningsuppgifter för Windows. Detta skyddar dina kontons säkerhet.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = redigera den sparade inloggningen

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Ange dina inloggningsuppgifter för Windows för att se ditt lösenord. Detta skyddar dina kontons säkerhet.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = visa det sparade lösenordet

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Om du vill kopiera ditt lösenord anger du dina inloggningsuppgifter för Windows. Detta skyddar dina kontons säkerhet.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = kopiera det sparade lösenordet

## Master Password notification

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = För att exportera dina inloggningar anger du dina inloggningsuppgifter för Windows. Detta skyddar dina kontons säkerhet.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exportera sparade inloggningar och lösenord

## Primary Password notification

about-logins-primary-password-notification-message = Ange ditt huvudlösenord för att se sparade inloggningar och lösenord
master-password-reload-button =
    .label = Logga in
    .accesskey = L

## Password Sync notification

## Dialogs

confirmation-dialog-cancel-button = Avbryt
confirmation-dialog-dismiss-button =
    .title = Avbryt

about-logins-confirm-remove-dialog-title = Ta bort denna inloggning?
confirm-delete-dialog-message = Den här åtgärden kan inte ångras.
about-logins-confirm-remove-dialog-confirm-button = Ta bort

about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Ta bort
        [one] Ta bort
       *[other] Ta bort alla
    }

about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Ja, ta bort den här inloggningen
        [one] Ja, ta bort den här inloggningen
       *[other] Ja, ta bort dessa inloggningar
    }

about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Ta bort { $count } inloggning?
       *[other] Ta bort alla { $count } inloggningar?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Detta tar bort inloggningen som du har sparat i { -brand-short-name } och eventuella intrångsvarningar som visas här. Du kan inte ångra den här åtgärden.
        [one] Detta tar bort inloggningen som du har sparat i { -brand-short-name } och eventuella intrångsvarningar som visas här. Du kan inte ångra den här åtgärden.
       *[other] Detta tar bort inloggningar som du har sparat i { -brand-short-name } och eventuella intrångsvarningar som visas här. Du kan inte ångra den här åtgärden.
    }

about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Ta bort { $count } inloggning från alla enheter?
       *[other] Ta bort alla { $count } inloggningar från alla enheter?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Detta tar bort inloggningen som du har sparat i { -brand-short-name } på alla enheter som synkroniserats med ditt { -fxaccount-brand-name }. Detta tar också bort varningar om intrång som visas här. Du kan inte ångra den här åtgärden.
        [one] Detta tar bort inloggningen som du har sparat i { -brand-short-name } på alla enheter som synkroniserats med ditt { -fxaccount-brand-name }. Detta tar också bort varningar om intrång som visas här. Du kan inte ångra den här åtgärden.
       *[other] Detta tar bort alla inloggningar som du har sparat i { -brand-short-name } på alla enheter som synkroniserats med ditt { -fxaccount-brand-name }. Detta tar också bort varningar om intrång som visas här. Du kan inte ångra den här åtgärden.
    }

about-logins-confirm-export-dialog-title = Exportera inloggningar och lösenord
about-logins-confirm-export-dialog-message = Dina lösenord sparas som läsbar text (t.ex. BadP@ssw0rd) så att alla som kan öppna den exporterade filen kan se dem.
about-logins-confirm-export-dialog-confirm-button = Exportera…

about-logins-alert-import-title = Import slutförd
about-logins-alert-import-message = Visa detaljerad importöversikt

confirm-discard-changes-dialog-title = Ignorera dessa förändringar?
confirm-discard-changes-dialog-message = Alla ändringar som inte är sparade kommer att gå förlorade.
confirm-discard-changes-dialog-confirm-button = Ignorera

## Breach Alert notification

about-logins-breach-alert-title = Webbplatsintrång
breach-alert-text = Lösenord har läckt eller stulits från den här webbplatsen sedan du senast uppdaterade dina inloggningsuppgifter. Ändra ditt lösenord för att skydda ditt konto.
about-logins-breach-alert-date = Detta intrång inträffade den { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Gå till { $hostname }
about-logins-breach-alert-learn-more-link = Läs mer

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Sårbart lösenord
about-logins-vulnerable-alert-text2 = Det här lösenordet har använts på ett annat konto som troligtvis var inblandat i ett dataintrång. Återanvända uppgifter riskerar alla dina konton. Ändra det här lösenordet.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Gå till { $hostname }
about-logins-vulnerable-alert-learn-more-link = Läs mer

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = En post för { $loginTitle } med det användarnamnet finns redan. <a data-l10n-name="duplicate-link">Gå till befintlig post?</a>

# This is a generic error message.
about-logins-error-message-default = Ett fel uppstod vid försök att spara lösenordet.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exportera inloggningsfil
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Exportera
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokument
       *[other] CSV-fil
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importera inloggningsfil
about-logins-import-file-picker-import-button = Importera
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokument
       *[other] CSV-fil
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV-dokument
       *[other] TSV-fil
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Import slutförd
about-logins-import-dialog-items-added =
    { $count ->
        [one] <span data-l10n-name="count">{ $count }</span><span>ny inloggning tillagd</span>
       *[other] <span data-l10n-name="count">{ $count }</span><span>nya inloggningar tillagda</span>
    }

about-logins-import-dialog-items-modified =
    { $count ->
        [one] <span data-l10n-name="count">{ $count }</span><span>befintlig inloggning uppdaterad</span>
       *[other] <span data-l10n-name="count">{ $count }</span><span>befintliga inloggningar uppdaterade</span>
    }

about-logins-import-dialog-items-no-change =
    { $count ->
        [one] <span data-l10n-name="count">{ $count }</span><span>duplicerad inloggning hittades</span><span data-l10n-name="meta">(ej importerad)</span>
       *[other] <span data-l10n-name="count">{ $count }</span><span>duplicerad inloggningar hittades</span><span data-l10n-name="meta">(ej importerade)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [one] <span data-l10n-name="count">{ $count }</span><span>fel</span><span data-l10n-name="meta">(ej importerad)</span>
       *[other] <span data-l10n-name="count">{ $count }</span><span>fel</span><span data-l10n-name="meta">(ej importerade)</span>
    }
about-logins-import-dialog-done = Klar

about-logins-import-dialog-error-title = Importfel
about-logins-import-dialog-error-conflicting-values-title = Flera motstridiga värden för en inloggning
about-logins-import-dialog-error-conflicting-values-description = Till exempel: flera användarnamn, lösenord, webbadresser etc. för en inloggning.
about-logins-import-dialog-error-file-format-title = Problem med filformat
about-logins-import-dialog-error-file-format-description = Felaktiga eller saknade kolumnrubriker. Se till att filen innehåller kolumner för användarnamn, lösenord och URL.
about-logins-import-dialog-error-file-permission-title = Det gick inte att läsa filen
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } har inte behörighet att läsa filen. Försök att ändra filrättigheter.
about-logins-import-dialog-error-unable-to-read-title = Det går inte att tolka filen
about-logins-import-dialog-error-unable-to-read-description = Se till att du har valt en CSV- eller TSV-fil.
about-logins-import-dialog-error-no-logins-imported = Inga inloggningar har importerats
about-logins-import-dialog-error-learn-more = Läs mer
about-logins-import-dialog-error-try-import-again = Försök importera igen…
about-logins-import-dialog-error-cancel = Avbryt

about-logins-import-report-title = Importera sammanfattning
about-logins-import-report-description = Inloggningar och lösenord importerade till { -brand-short-name }.

#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Rad { $number }
about-logins-import-report-row-description-no-change = Dubblett: Exakt matchning av befintlig inloggning
about-logins-import-report-row-description-modified = Befintlig inloggning uppdaterad
about-logins-import-report-row-description-added = Ny inloggning tillagd
about-logins-import-report-row-description-error = Fel: Fält saknas

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Fel: Flera värden för { $field }
about-logins-import-report-row-description-error-missing-field = Fel: { $field } saknas

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">ny inloggning har lagts till</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nya inloggningar har lagts till</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">befintlig inloggning uppdaterad</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">befintliga inloggningar uppdaterade</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">dubbel inloggning</div> <div data-l10n-name="not-imported">(not imported)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">dubbla inloggningar</div> <div data-l10n-name="not-imported">(not imported)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Fel</div> <div data-l10n-name="not-imported">(inte importerad)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Fel</div> <div data-l10n-name="not-imported">(inte importerad)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Importera sammanfattningsrapport
