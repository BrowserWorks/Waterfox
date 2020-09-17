# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Logins & adgangskoder

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Tag dine adgangskoder med overalt
login-app-promo-subtitle = Hent { -lockwise-brand-name }-app'en gratis
login-app-promo-android =
    .alt = Hent den fra  Google Play
login-app-promo-apple =
    .alt = Hent den i App Store

login-filter =
    .placeholder = Søg efter logins

create-login-button = Opret nyt login

fxaccounts-sign-in-text = Få dine adgangkoder på alle dine enheder
fxaccounts-sign-in-button = Log ind på { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Håndter konto

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Åbn menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importer fra en anden browser…
about-logins-menu-menuitem-import-from-a-file = Importer fra fil…
about-logins-menu-menuitem-export-logins = Eksporter logins…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Indstillinger
       *[other] Indstillinger
    }
about-logins-menu-menuitem-help = Hjælp
menu-menuitem-android-app = { -lockwise-brand-short-name } til Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } til iPhone og iPad

## Login List

login-list =
    .aria-label = Logins der matcher din søgning
login-list-count =
    { $count ->
        [one] { $count } login
       *[other] { $count } logins
    }
login-list-sort-label-text = Sorter efter:
login-list-name-option = Navn (A-Z)
login-list-name-reverse-option = Navn (Z-A)
about-logins-login-list-alerts-option = Advarsler
login-list-last-changed-option = Senest ændret
login-list-last-used-option = Senest brugt
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

## Introduction screen

login-intro-heading = Leder du efter dine gemte logins? Opsæt { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Leder du efter dine gemte logins? Opsæt { -sync-brand-short-name } eller importer dine logins.
about-logins-login-intro-heading-logged-in = Ingen synkroniserede logins fundet.
login-intro-description = Hvis du har gemt dine logins i { -brand-product-name } på en anden enhed, så skal du gøre sådan for at anvende dem her også:
login-intro-instruction-fxa = Opret eller log ind på din { -fxaccount-brand-name } på den enhed, hvor dine logins er gemt
login-intro-instruction-fxa-settings = Vær sikker på, at du har sat et flueben ud for Logins i { -sync-brand-short-name }-indstillingerne.
about-logins-intro-instruction-help = Besøg <a data-l10n-name="help-link">{ -lockwise-brand-short-name } denne side</a> for at få mere hjælp
about-logins-intro-import = Hvis dine logins er gemt i en anden browser, kan du <a data-l10n-name="import-link">importere dem til { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = Hvis dine logins er gemt et andet sted end { -brand-product-name }, så kan du <a data-l10n-name="import-browser-link">importere dem fra en anden browser</a> eller <a data-l10n-name="import-file-link">fra en fil</a>

## Login

login-item-new-login-title = Opret nyt login
login-item-edit-button = Rediger
about-logins-login-item-remove-button = Fjern
login-item-origin-label = Webstedets adresse
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
login-item-time-changed = Senest ændret: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Oprettet: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Senest brugt: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
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

## Master Password notification

master-password-notification-message = Indtast din hovedadgangskode for at se gemte logins og adgangskoder

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

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Vil du have dine logins på alle dine enheder med { -brand-product-name }? Gå til indstillingerne for { -sync-brand-short-name }, og sæt et flueben ud for Logins.
       *[other] Vil du have dine logins på alle dine enheder med { -brand-product-name }? Gå til indstillingerne for { -sync-brand-short-name }, og sæt et flueben ud for Logins.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Gå til { -sync-brand-short-name }-indstillinger
           *[other] Gå til { -sync-brand-short-name }-indstillinger
        }
    .accesskey = G
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Spørg mig ikke igen
    .accesskey = S

## Dialogs

confirmation-dialog-cancel-button = Annuller
confirmation-dialog-dismiss-button =
    .title = Annuller

about-logins-confirm-remove-dialog-title = Fjern dette login?
confirm-delete-dialog-message = Denne handling kan ikke fortrydes.
about-logins-confirm-remove-dialog-confirm-button = Fjern

about-logins-confirm-export-dialog-title = Eksporter logins og adgangskoder
about-logins-confirm-export-dialog-message = Dine adgangskoder bliver gemt som læsbar tekst (fx dåRligAdg@ngsk0de), så alle der kan åbne den eksportede fil kan se dine adgangskoder.
about-logins-confirm-export-dialog-confirm-button = Eksporter…

confirm-discard-changes-dialog-title = Annuller ikke-gemte ændringer?
confirm-discard-changes-dialog-message = Alle ikke-gemte ændringer vil gå tabt.
confirm-discard-changes-dialog-confirm-button = Annuller

## Breach Alert notification

about-logins-breach-alert-title = Websted med datalæk
breach-alert-text = Adgangskoder er blevet lækket eller stjålet fra dette websted, siden du senest opdaterede dine login-oplysninger. Skift din adgangskode for at beskytte din konto.
about-logins-breach-alert-date = Datalækket fandt sted { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Gå til { $hostname }
about-logins-breach-alert-learn-more-link = Læs mere

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
