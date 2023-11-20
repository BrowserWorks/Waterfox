# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Logins & adgangskoder

about-logins-login-filter =
    .placeholder = Søg efter logins
    .key = F

create-new-login-button =
    .title = Opret nyt login

fxaccounts-sign-in-text = Få dine adgangkoder på alle dine enheder
fxaccounts-sign-in-sync-button = Log ind for at synkronisere
fxaccounts-avatar-button =
    .title = Håndter konto

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Åbn menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importer fra en anden browser…
about-logins-menu-menuitem-import-from-a-file = Importer fra fil…
about-logins-menu-menuitem-export-logins = Eksporter logins…
about-logins-menu-menuitem-remove-all-logins = Fjern alle logins…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Indstillinger
       *[other] Indstillinger
    }
about-logins-menu-menuitem-help = Hjælp

## Login List

login-list =
    .aria-label = Logins der matcher din søgning
# Variables
#   $count (number) - Number of logins
login-list-count =
    { $count ->
        [one] { $count } login
       *[other] { $count } logins
    }
# Variables
#   $count (number) - Number of filtered logins
#   $total (number) - Total number of logins
login-list-filtered-count =
    { $total ->
        [one] { $count } af { $total } login
       *[other] { $count } af { $total } logins
    }
login-list-sort-label-text = Sorter efter:
login-list-name-option = Navn (A-Z)
login-list-name-reverse-option = Navn (Z-A)
login-list-username-option = Brugernavn (A-Å)
login-list-username-reverse-option = Brugernavn (Å-A)
about-logins-login-list-alerts-option = Advarsler
login-list-last-changed-option = Senest ændret
login-list-last-used-option = Senest anvendt
login-list-intro-title = Ingen logins fundet
login-list-intro-description = Når du gemmer et login i { -brand-product-name } vil det blive vist hér.
about-logins-login-list-empty-search-title = Ingen logins fundet
about-logins-login-list-empty-search-description = Din søgning gav ingen resultater
login-list-item-title-new-login = Nyt login
login-list-item-subtitle-new-login = Indtast login-oplysninger
login-list-item-subtitle-missing-username = (intet brugernavn)
about-logins-list-item-breach-icon =
    .title = Websted med datalæk
about-logins-list-item-vulnerable-password-icon =
    .title = Usikker adgangskode
about-logins-list-section-breach = Websteder med datalæk
about-logins-list-section-vulnerable = Usikre adgangskoder
about-logins-list-section-nothing = Ingen advarsel
about-logins-list-section-today = I dag
about-logins-list-section-yesterday = I går
about-logins-list-section-week = Seneste 7 dage

## Introduction screen

about-logins-login-intro-heading-logged-out2 = Leder du efter dine gemte logins? Slå synkronisering til eller importer dem.
about-logins-login-intro-heading-logged-in = Ingen synkroniserede logins fundet.
login-intro-description = Hvis du har gemt dine logins i { -brand-product-name } på en anden enhed, så skal du gøre sådan for at anvende dem her også:
login-intro-instructions-fxa = Opret eller log ind på din { -fxaccount-brand-name } på den enhed, hvor dine logins er gemt.
login-intro-instructions-fxa-settings = Gå til Indstillinger > Sync > Slå synkronisering til… Sæt flueben ud for Logins og adgangskoder.
login-intro-instructions-fxa-passwords-help = Besøg vores <a data-l10n-name="passwords-help-link">support-websted</a> for at få mere hjælp.
about-logins-intro-browser-only-import = Hvis dine logins er gemt i en anden browser, så kan du <a data-l10n-name="import-link">importere dem til { -brand-product-name }</a>
about-logins-intro-import2 = Hvis dine logins er gemt et andet sted end { -brand-product-name }, så kan du <a data-l10n-name="import-browser-link">importere dem fra en anden browser</a> eller <a data-l10n-name="import-file-link">fra en fil</a>

## Login

login-item-new-login-title = Opret nyt login
login-item-edit-button = Rediger
about-logins-login-item-remove-button = Fjern
login-item-origin-label = Webstedets adresse
login-item-tooltip-message = Kontrollér at dette er adressen på det websted, hvor du logger ind.
login-item-origin =
    .placeholder = https://www.eksempel.dk
login-item-username-label = Brugernavn
about-logins-login-item-username =
    .placeholder = (intet brugernavn)
login-item-copy-username-button-text = Kopier
login-item-copied-username-button-text = Kopieret!
login-item-password-label = Adgangskode
login-item-password-reveal-checkbox =
    .aria-label = Vis adgangskode
login-item-copy-password-button-text = Kopier
login-item-copied-password-button-text = Kopieret!
login-item-save-changes-button = Gem ændringer
login-item-save-new-button = Gem
login-item-cancel-button = Annuller

## The date is displayed in a timeline showing the password evolution.
## A label is displayed under the date to describe the type of change.
## (e.g. updated, created, etc.)

# Variables
#   $datetime (date) - Event date
login-item-timeline-point-date = { DATETIME($datetime, day: "numeric", month: "short", year: "numeric") }
login-item-timeline-action-created = Oprettet
login-item-timeline-action-updated = Opdateret
login-item-timeline-action-used = Anvendt

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Indtast dine login-informationer til Windows for at redigere dine logins. Dette hjælper med at beskytte dine kontis sikkerhed.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = redigere det gemte login

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Indtast dine login-informationer til Windows for at se din adgangskode. Dette hjælper med at beskytte dine kontis sikkerhed.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = vise den gemte adgangskode

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Indtast dine login-informationer til Windows for at kopiere din adgangskode. Dette hjælper med at beskytte dine kontis sikkerhed.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = kopiere den gemte adgangskode

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Indtast dine login-informationer til Windows for at eksportere dine logins. Dette hjælper med at beskytte dine kontis sikkerhed.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = eksportere gemte logins og adgangskoder

## Primary Password notification

about-logins-primary-password-notification-message = Indtast din hovedadgangskode for at se gemte logins og adgangskoder
master-password-reload-button =
    .label = Log ind
    .accesskey = L

## Dialogs

confirmation-dialog-cancel-button = Annuller
confirmation-dialog-dismiss-button =
    .title = Annuller

about-logins-confirm-remove-dialog-title = Fjern dette login?
confirm-delete-dialog-message = Denne handling kan ikke fortrydes.
about-logins-confirm-remove-dialog-confirm-button = Fjern

## Variables
##   $count (number) - Number of items

about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Fjern
        [one] Fjern
       *[other] Fjern alle
    }

about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Ja, fjern dette login
       *[other] Ja, fjern disse logins
    }

about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Fjern { $count } login?
       *[other] Fjern { $count } logins?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Dette fjerner login'et, du har gemt til { -brand-short-name } samt alle advarsler om datalæk, der vises her. Du kan ikke fortryde denne handling.
        [one] Dette fjerner login'et, du har gemt til { -brand-short-name } samt alle advarsler om datalæk, der vises her. Du kan ikke fortryde denne handling.
       *[other] Dette fjerner logins, du har gemt til { -brand-short-name } samt alle advarsler om datalæk, der vises her. Du kan ikke fortryde denne handling.
    }

about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Fjern { $count } login fra alle enheder?
       *[other] Fjern { $count } logins fra alle enheder?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Denne handling fjerner det login, du har gemt til { -brand-short-name } på alle enheder, der er synkroniseret med din { -fxaccount-brand-name }. Advarsler om datalæk, der optræder her, vil også blive fjernet. Du kan ikke fortryde denne handling.
        [one] Denne handling fjerner det login, du har gemt til { -brand-short-name } på alle enheder, der er synkroniseret med din { -fxaccount-brand-name }. Advarsler om datalæk, der optræder her, vil også blive fjernet. Du kan ikke fortryde denne handling.
       *[other] Denne handling fjerner de logins, du har gemt til { -brand-short-name } på alle enheder, der er synkroniseret med din { -fxaccount-brand-name }. Advarsler om datalæk, der optræder her, vil også blive fjernet. Du kan ikke fortryde denne handling.
    }

##

about-logins-confirm-export-dialog-title = Eksporter logins og adgangskoder
about-logins-confirm-export-dialog-message = Dine adgangskoder bliver gemt som læsbar tekst (fx dåRligAdg@ngsk0de), så alle der kan åbne den eksportede fil kan se dine adgangskoder.
about-logins-confirm-export-dialog-confirm-button = Eksporter…

about-logins-alert-import-title = Import fuldført
about-logins-alert-import-message = Se detaljeret oversigt over import

confirm-discard-changes-dialog-title = Kasser ikke-gemte ændringer?
confirm-discard-changes-dialog-message = Alle ikke-gemte ændringer vil gå tabt.
confirm-discard-changes-dialog-confirm-button = Kasser

## Breach Alert notification

about-logins-breach-alert-title = Websted med datalæk
breach-alert-text = Adgangskoder er blevet lækket eller stjålet fra dette websted, siden du senest opdaterede dine login-oplysninger. Skift din adgangskode for at beskytte din konto.
about-logins-breach-alert-date = Datalækket fandt sted { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Gå til { $hostname }

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Usikker adgangskode
about-logins-vulnerable-alert-text2 = Adgangskoden er blevet brugt til en anden konto, der sandynligvis har været med i en datalæk. Det kan bringe dine konti i fare at genbruge brugernavne og adgangskoder. Skift denne adgangskode.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Gå til { $hostname }
about-logins-vulnerable-alert-learn-more-link = Læs mere

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Der findes allerede et login for { $loginTitle } med samme brugernavn. <a data-l10n-name="duplicate-link">Gå til eksisterende login?</a>

# This is a generic error message.
about-logins-error-message-default = Der opstod en fejl med at gemme adgangskoden.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Eksporter fil med logins
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Eksporter
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokument
       *[other] CSV-fil
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importer fil med logins
about-logins-import-file-picker-import-button = Importer
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-fil
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

about-logins-import-dialog-title = Import fuldført
about-logins-import-dialog-items-added =
    { $count ->
       *[other] <span>Nye logins tilføjet:</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-modified =
    { $count ->
       *[other] <span>Eksisterende logins opdateret:</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-no-change =
    { $count ->
       *[other] <span>Dublet-logins fundet:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(ikke importeret)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
       *[other] <span>Fejl:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(ikke importeret)</span>
    }
about-logins-import-dialog-done = Færdig

about-logins-import-dialog-error-title = Fejl ved import
about-logins-import-dialog-error-conflicting-values-title = Flere modstridende værdier for samme login
about-logins-import-dialog-error-conflicting-values-description = For eksempel: Flere brugernavne, adgangskoder URL'er osv. for det samme login.
about-logins-import-dialog-error-file-format-title = Problem med filformat
about-logins-import-dialog-error-file-format-description = Ukorrekte eller manglende kolonne-overskrifter. Kontrollér at filen indeholder kolonner til brugernavn, adgangskode og URL.
about-logins-import-dialog-error-file-permission-title = Kunne ikke læse fil
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } har ikke tilladelse til at læse filen. Prøv at ændre tilladelser for filen.
about-logins-import-dialog-error-unable-to-read-title = Kunne ikke tolke filen
about-logins-import-dialog-error-unable-to-read-description = Kontrollér at det er en CSV- eller TSV-fil.
about-logins-import-dialog-error-no-logins-imported = Ingen logins er blevet importeret
about-logins-import-dialog-error-learn-more = Læs mere
about-logins-import-dialog-error-try-import-again = Prøv at importere igen…
about-logins-import-dialog-error-cancel = Annuller

about-logins-import-report-title = Oversigt over import
about-logins-import-report-description = Logins og adgangskoder importeret til { -brand-short-name }.

#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Række { $number }
about-logins-import-report-row-description-no-change = Dublet: Login eksisterer allerede
about-logins-import-report-row-description-modified = Eksisterende login opdateret
about-logins-import-report-row-description-added = Nyt login tilføjet
about-logins-import-report-row-description-error = Fejl: Manglende felt

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Fejl: Flere værdier for { $field }
about-logins-import-report-row-description-error-missing-field = Fejl: Manglende { $field }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nyt login tilføjet</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nye logins tilføjet</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">eksisterende login opdateret</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">eksisterende logins opdateret</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">dublet-login</div> <div data-l10n-name="not-imported">(ikke importeret)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">dublet-logins</div> <div data-l10n-name="not-imported">(ikke importeret)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">fejl</div> <div data-l10n-name="not-imported">(ikke importeret)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">fejl</div> <div data-l10n-name="not-imported">(ikke importeret)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Oversigt over import
