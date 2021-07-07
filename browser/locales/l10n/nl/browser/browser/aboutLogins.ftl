# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Aanmeldingen & Wachtwoorden

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Neem uw wachtwoorden overal mee naartoe
login-app-promo-subtitle = Download de gratis { -lockwise-brand-name }-app
login-app-promo-android =
    .alt = Downloaden op Google Play
login-app-promo-apple =
    .alt = Downloaden in de App Store
login-filter =
    .placeholder = Aanmeldingen zoeken
create-login-button = Nieuwe aanmelding maken
fxaccounts-sign-in-text = Breng uw wachtwoorden naar uw andere apparaten
fxaccounts-sign-in-button = Aanmelden bij { -sync-brand-short-name }
fxaccounts-sign-in-sync-button = Aanmelden om te synchroniseren
fxaccounts-avatar-button =
    .title = Account beheren

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Menu openen
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importeren vanuit een andere browser…
about-logins-menu-menuitem-import-from-a-file = Uit een bestand importeren…
about-logins-menu-menuitem-export-logins = Aanmeldingen exporteren…
about-logins-menu-menuitem-remove-all-logins = Alle aanmeldingen verwijderen…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opties
       *[other] Voorkeuren
    }
about-logins-menu-menuitem-help = Help
menu-menuitem-android-app = { -lockwise-brand-short-name } voor Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } voor iPhone en iPad

## Login List

login-list =
    .aria-label = Aanmeldingen die overeenkomen met de zoekterm
login-list-count =
    { $count ->
        [one] { $count } aanmelding
       *[other] { $count } aanmeldingen
    }
login-list-sort-label-text = Sorteren op:
login-list-name-option = Naam (A-Z)
login-list-name-reverse-option = Naam (Z-A)
about-logins-login-list-alerts-option = Waarschuwingen
login-list-last-changed-option = Laatst gewijzigd
login-list-last-used-option = Laatst gebruikt
login-list-intro-title = Geen aanmeldingen gevonden
login-list-intro-description = Wanneer u een wachtwoord opslaat in { -brand-product-name }, wordt dit hier weergegeven.
about-logins-login-list-empty-search-title = Geen aanmeldingen gevonden
about-logins-login-list-empty-search-description = Uw zoekopdracht heeft geen resultaten opgeleverd.
login-list-item-title-new-login = Nieuwe aanmelding
login-list-item-subtitle-new-login = Voer uw aanmeldgegevens in
login-list-item-subtitle-missing-username = (geen gebruikersnaam)
about-logins-list-item-breach-icon =
    .title = Website met datalek
about-logins-list-item-vulnerable-password-icon =
    .title = Kwetsbaar wachtwoord

## Introduction screen

login-intro-heading = Op zoek naar uw opgeslagen aanmeldingen? Stel { -sync-brand-short-name } in.
about-logins-login-intro-heading-logged-out = Op zoek naar uw opgeslagen aanmeldingen? Stel { -sync-brand-short-name } in of importeer ze.
about-logins-login-intro-heading-logged-out2 = Op zoek naar uw opgeslagen aanmeldingen? Schakel synchronisatie in of importeer ze.
about-logins-login-intro-heading-logged-in = Geen gesynchroniseerde aanmeldingen gevonden.
login-intro-description = Als u uw aanmeldgegevens bij { -brand-product-name } op een ander apparaat hebt opgeslagen, kunt u ze zo ophalen:
login-intro-instruction-fxa = Maak op het apparaat waarop uw aanmeldgegevens staan een { -fxaccount-brand-name } of meld u aan
login-intro-instruction-fxa-settings = Zorg ervoor dat u het veld Aanmeldingen in de instellingen van { -sync-brand-short-name } hebt aangevinkt
about-logins-intro-instruction-help = Bezoek <a data-l10n-name="help-link">Ondersteuning voor { -lockwise-brand-short-name }</a> voor meer hulp
login-intro-instructions-fxa = Maak op het apparaat waarop uw aanmeldgegevens staan een { -fxaccount-brand-name } of meld u aan.
login-intro-instructions-fxa-settings = Ga naar Instellingen > Sync > Synchronisatie inschakelen… Plaats een vinkje bij Aanmeldingen en wachtwoorden.
login-intro-instructions-fxa-help = Bezoek <a data-l10n-name="help-link">Ondersteuning voor { -lockwise-brand-short-name }</a> voor meer hulp.
about-logins-intro-import = Als uw aanmeldingen in een andere browser worden opgeslagen, kunt u <a data-l10n-name="import-link">ze importeren in { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Als uw aanmeldingen buiten { -brand-product-name } zijn opgeslagen, dan kunt u ze importeren <a data-l10n-name="import-browser-link">vanuit een andere browser</a> of <a data-l10n-name = "import-file-link">vanuit een bestand</a>

## Login

login-item-new-login-title = Nieuwe aanmelding maken
login-item-edit-button = Bewerken
about-logins-login-item-remove-button = Verwijderen
login-item-origin-label = Websiteadres
login-item-tooltip-message = Zorg ervoor dat dit precies overeenkomt met het adres van de website waar u zich aanmeldt.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Gebruikersnaam
about-logins-login-item-username =
    .placeholder = (geen gebruikersnaam)
login-item-copy-username-button-text = Kopiëren
login-item-copied-username-button-text = Gekopieerd!
login-item-password-label = Wachtwoord
login-item-password-reveal-checkbox =
    .aria-label = Wachtwoord tonen
login-item-copy-password-button-text = Kopiëren
login-item-copied-password-button-text = Gekopieerd!
login-item-save-changes-button = Wijzigingen opslaan
login-item-save-new-button = Opslaan
login-item-cancel-button = Annuleren
login-item-time-changed = Laatst gewijzigd: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Gemaakt: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Laatst gebruikt: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Voer uw aanmeldgegevens voor Windows in om uw aanmelding te bewerken. Hierdoor wordt de beveiliging van uw accounts beschermd.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = bewerk de opgeslagen aanmelding
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Voer uw aanmeldgegevens voor Windows in om uw wachtwoord te bekijken. Hierdoor wordt de beveiliging van uw accounts beschermd.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = toon het opgeslagen wachtwoord
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Voer uw aanmeldgegevens voor Windows in om uw wachtwoord te kopiëren. Hierdoor wordt de beveiliging van uw accounts beschermd.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = kopieer het opgeslagen wachtwoord

## Master Password notification

master-password-notification-message = Voer uw hoofdwachtwoord in om opgeslagen aanmeldingen en wachtwoorden te bekijken
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Voer uw aanmeldgegevens voor Windows in om uw aanmelding te exporteren. Hierdoor wordt de beveiliging van uw accounts beschermd.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = opgeslagen aanmeldingen en wachtwoorden te exporteren

## Primary Password notification

about-logins-primary-password-notification-message = Voer uw hoofdwachtwoord in om opgeslagen aanmeldingen en wachtwoorden te bekijken
master-password-reload-button =
    .label = Aanmelden
    .accesskey = A

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Wilt u uw aanmeldingen overal waar u { -brand-product-name } gebruikt? Ga naar de opties van { -sync-brand-short-name } en vink het veld Aanmeldingen aan.
       *[other] Wilt u uw aanmeldingen overal waar u { -brand-product-name } gebruikt? Ga naar de voorkeuren van { -sync-brand-short-name } en vink het veld Aanmeldingen aan.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] { -sync-brand-short-name }-opties bekijken
           *[other] { -sync-brand-short-name }-voorkeuren bekijken
        }
    .accesskey = b
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Dit niet meer vragen
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = Annuleren
confirmation-dialog-dismiss-button =
    .title = Annuleren
about-logins-confirm-remove-dialog-title = Deze aanmelding verwijderen?
confirm-delete-dialog-message = Deze actie kan niet ongedaan worden gemaakt.
about-logins-confirm-remove-dialog-confirm-button = Verwijderen
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Verwijderen
        [one] Verwijderen
       *[other] Alle verwijderen
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Ja, deze aanmelding verwijderen
        [one] Ja, deze aanmelding verwijderen
       *[other] Ja, deze aanmeldingen verwijderen
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] { $count } aanmelding verwijderen?
       *[other] Alle { $count } aanmeldingen verwijderen?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Dit verwijdert de aanmelding die u in { -brand-short-name } hebt opgeslagen en alle waarschuwingen voor datalekken die hier verschijnen. U kunt deze actie niet ongedaan maken.
        [one] Dit verwijdert de aanmelding die u in { -brand-short-name } hebt opgeslagen en alle waarschuwingen voor datalekken die hier verschijnen. U kunt deze actie niet ongedaan maken.
       *[other] Dit verwijdert de aanmeldingen die u in { -brand-short-name } hebt opgeslagen en alle waarschuwingen voor datalekken die hier verschijnen. U kunt deze actie niet ongedaan maken.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] { $count } aanmelding van alle apparaten verwijderen?
       *[other] Alle { $count } aanmeldingen van alle apparaten verwijderen?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Dit verwijdert de aanmelding die u in { -brand-short-name } hebt opgeslagen van alle apparaten die met uw { -fxaccount-brand-name } zijn gesynchroniseerd. Dit verwijdert ook alle waarschuwingen voor datalekken die hier verschijnen. U kunt deze actie niet ongedaan maken.
        [one] Dit verwijdert de aanmelding die u in { -brand-short-name } hebt opgeslagen van alle apparaten die met uw { -fxaccount-brand-name } zijn gesynchroniseerd. Dit verwijdert ook alle waarschuwingen voor datalekken die hier verschijnen. U kunt deze actie niet ongedaan maken.
       *[other] Dit verwijdert de aanmeldingen die u in { -brand-short-name } hebt opgeslagen van alle apparaten die met uw { -fxaccount-brand-name } zijn gesynchroniseerd. Dit verwijdert ook alle waarschuwingen voor datalekken die hier verschijnen. U kunt deze actie niet ongedaan maken.
    }
about-logins-confirm-export-dialog-title = Aanmeldingen en wachtwoorden exporteren
about-logins-confirm-export-dialog-message = Uw wachtwoorden worden opgeslagen als leesbare tekst (bijvoorbeeld BadP@ssw0rd), dus iedereen die het geëxporteerde bestand kan openen, kan ze bekijken.
about-logins-confirm-export-dialog-confirm-button = Exporteren…
about-logins-alert-import-title = Importeren voltooid
about-logins-alert-import-message = Gedetailleerde importsamenvatting bekijken
confirm-discard-changes-dialog-title = Deze wijzigingen verwerpen?
confirm-discard-changes-dialog-message = Alle niet-opgeslagen wijzigingen gaan verloren.
confirm-discard-changes-dialog-confirm-button = Verwerpen

## Breach Alert notification

about-logins-breach-alert-title = Websitedatalek
breach-alert-text = Wachtwoorden uit deze website zijn gelekt of gestolen sinds u voor het laatst uw aanmeldgegevens hebt bijgewerkt. Wijzig uw wachtwoord om uw account te beschermen.
about-logins-breach-alert-date = Dit lek is voorgevallen op { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Naar { $hostname }
about-logins-breach-alert-learn-more-link = Meer info

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Kwetsbaar wachtwoord
about-logins-vulnerable-alert-text2 = Dit wachtwoord is gebruikt op een andere account, die waarschijnlijk door een datalek is getroffen. Het hergebruiken van aanmeldgegevens brengt al uw accounts in gevaar. Wijzig dit wachtwoord.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Naar { $hostname }
about-logins-vulnerable-alert-learn-more-link = Meer info

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Er bestaat al een vermelding voor { $loginTitle } met die gebruikersnaam. <a data-l10n-name="duplicate-link">Naar bestaande vermelding gaan?</a>
# This is a generic error message.
about-logins-error-message-default = Er is een fout opgetreden tijdens het opslaan van dit wachtwoord.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Bestand met aanmeldingen exporteren
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Exporteren
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-document
       *[other] CSV-bestand
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Bestand met aanmeldingen importeren
about-logins-import-file-picker-import-button = Importeren
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-document
       *[other] CSV-bestand
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV-document
       *[other] TSV-bestand
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Importeren voltooid
about-logins-import-dialog-items-added =
    { $count ->
        [one] <span>Nieuwe aanmelding toegevoegd:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Nieuwe aanmeldingen toegevoegd:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
        [one] <span>Bestaande aanmelding bijgewerkt:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Bestaande aanmeldingen bijgewerkt:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
        [one] <span>Dubbele aanmelding gevonden:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(niet geïmporteerd)</span>
       *[other] <span>Dubbele aanmeldingen gevonden:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(niet geïmporteerd)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [one] <span>Fout:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(niet geïmporteerd)</span>
       *[other] <span>Fouten:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(niet geïmporteerd)</span>
    }
about-logins-import-dialog-done = Gereed
about-logins-import-dialog-error-title = Importeerfout
about-logins-import-dialog-error-conflicting-values-title = Meerdere tegenstrijdige waarden voor één aanmelding
about-logins-import-dialog-error-conflicting-values-description = Bijvoorbeeld: meerdere gebruikersnamen, wachtwoorden, URL’s enz. voor één aanmelding.
about-logins-import-dialog-error-file-format-title = Probleem met bestandsindeling
about-logins-import-dialog-error-file-format-description = Onjuiste of ontbrekende kolomheaders. Zorg ervoor dat het bestand kolommen voor gebruikersnaam, wachtwoord en URL bevat.
about-logins-import-dialog-error-file-permission-title = Kan bestand niet lezen
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } heeft geen toestemming om het bestand te lezen. Probeer de bestandsrechten te wijzigen.
about-logins-import-dialog-error-unable-to-read-title = Kan bestand niet ontleden
about-logins-import-dialog-error-unable-to-read-description = Controleer of u een CSV- of TSV-bestand hebt geselecteerd.
about-logins-import-dialog-error-no-logins-imported = Er zijn geen aanmeldingen geïmporteerd
about-logins-import-dialog-error-learn-more = Meer info
about-logins-import-dialog-error-try-again = Opnieuw proberen…
about-logins-import-dialog-error-try-import-again = Probeer nogmaals te importeren...
about-logins-import-dialog-error-cancel = Annuleren
about-logins-import-report-title = Importsamenvatting
about-logins-import-report-description = Aanmeldingen en wachtwoorden geïmporteerd in { -brand-short-name }.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Rij { $number }
about-logins-import-report-row-description-no-change = Duplicaat: exacte overeenkomst met bestaande aanmelding
about-logins-import-report-row-description-modified = Bestaande aanmelding bijgewerkt
about-logins-import-report-row-description-added = Nieuwe aanmelding toegevoegd
about-logins-import-report-row-description-error = Fout: veld ontbreekt

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Fout: meerdere waarden voor { $field }
about-logins-import-report-row-description-error-missing-field = Fout: { $field } ontbreekt

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nieuwe aanmelding toegevoegd</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nieuwe aanmeldingen toegevoegd</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">bestaande aanmelding bijgewerkt</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">bestaande aanmeldingen bijgewerkt</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">dubbele aanmelding</div> <div data-l10n-name="not-imported">(niet geïmporteerd)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">dubbele aanmeldingen</div> <div data-l10n-name="not-imported">(niet geïmporteerd)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">fout</div><div data-l10n-name="not-imported">(niet geïmporteerd)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">fouten</div><div data-l10n-name="not-imported">(niet geïmporteerd)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Samenvattend rapport importeren
