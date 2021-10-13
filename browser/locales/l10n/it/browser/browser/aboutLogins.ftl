# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Credenziali e password

# "Google Play" and "App Store" are both branding and should not be translated

login-filter =
    .placeholder = Cerca nelle credenziali

create-login-button = Inserisci nuove credenziali

fxaccounts-sign-in-text = Ritrova le tue password su tutti i tuoi dispositivi
fxaccounts-sign-in-sync-button = Accedi per sincronizzare
fxaccounts-avatar-button =
    .title = Gestisci account

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Apri menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importa da un altro browser…
about-logins-menu-menuitem-import-from-a-file = Importa da file…
about-logins-menu-menuitem-export-logins = Esporta credenziali…
about-logins-menu-menuitem-remove-all-logins = Rimuovi tutte le credenziali…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Opzioni
       *[other] Preferenze
    }
about-logins-menu-menuitem-help = Supporto

## Login List

login-list =
    .aria-label = Credenziali corrispondenti ai criteri di ricerca
login-list-count = { $count } credenziali
login-list-sort-label-text = Ordina per:
login-list-name-option = Nome (A-Z)
login-list-name-reverse-option = Nome (Z-A)
login-list-username-option = Nome utente (A-Z)
login-list-username-reverse-option = Nome utente (Z-A)
about-logins-login-list-alerts-option = Avvisi
login-list-last-changed-option = Ultima modifica
login-list-last-used-option = Ultimo utilizzo
login-list-intro-title = Credenziali non trovate
login-list-intro-description = Le password salvate in { -brand-product-name } verranno visualizzate qui.
about-logins-login-list-empty-search-title = Credenziali non trovate
about-logins-login-list-empty-search-description = Non ci sono risultati corrispondenti ai criteri di ricerca inseriti.
login-list-item-title-new-login = Nuove credenziali
login-list-item-subtitle-new-login = Inserisci le credenziali di accesso
login-list-item-subtitle-missing-username = (nessun nome utente)
about-logins-list-item-breach-icon =
    .title = Sito web coinvolto in violazioni di dati
about-logins-list-item-vulnerable-password-icon =
  .title = Password vulnerabile

about-logins-list-section-breach = Siti con violazioni
about-logins-list-section-vulnerable = Password vulnerabili
about-logins-list-section-nothing = Nessun avviso
about-logins-list-section-today = Oggi
about-logins-list-section-yesterday = Ieri
about-logins-list-section-week = Ultimi 7 giorni

## Introduction screen

about-logins-login-intro-heading-logged-out2 = Stai cercando le credenziali che hai salvato? Attiva la sincronizzazione o importale.
about-logins-login-intro-heading-logged-in = Credenziali sincronizzate non trovate.
login-intro-description = Se le credenziali sono salvate in { -brand-product-name } su un altro dispositivo, ecco come renderle disponibili qui:
login-intro-instructions-fxa = Accedi o crea un { -fxaccount-brand-name } sul dispositivo dove sono salvate le credenziali.
login-intro-instructions-fxa-settings = Apri Impostazioni > Sincronizzazione > Attiva sincronizzazione… e seleziona la casella Credenziali e password.
login-intro-instructions-fxa-help = Visita il <a data-l10n-name="help-link">supporto per { -lockwise-brand-short-name }</a> per ulteriori informazioni.
about-logins-intro-import = Se le credenziali sono salvate in un altro browser, è possibile <a data-l10n-name="import-link">importarle in { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = Se le credenziali sono salvate al di fuori di { -brand-product-name }, è possibile <a data-l10n-name="import-browser-link">importarle da un altro browser</a> o <a data-l10n-name="import-file-link">da un file</a>

## Login

login-item-new-login-title = Inserisci nuove credenziali
login-item-edit-button = Modifica
about-logins-login-item-remove-button = Rimuovi
login-item-origin-label = Indirizzo web
login-item-tooltip-message = Assicurarsi che corrisponda esattamente all’indirizzo del sito web a cui si accede.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nome utente
about-logins-login-item-username =
    .placeholder = (nessun nome utente)
login-item-copy-username-button-text = Copia
login-item-copied-username-button-text = Copiato.
login-item-password-label = Password
login-item-password-reveal-checkbox =
  .aria-label = Mostra password
login-item-copy-password-button-text = Copia
login-item-copied-password-button-text = Copiata.
login-item-save-changes-button = Salva modifiche
login-item-save-new-button = Salva
login-item-cancel-button = Annulla
login-item-time-changed = Ultima modifica: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Data creazione: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Ultimo utilizzo: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Per modificare queste credenziali, inserire le credenziali di accesso a Windows. Questo aiuta a garantire la sicurezza dei tuoi account.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = modificare le credenziali salvate

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Per visualizzare la password, inserire le credenziali di accesso a Windows. Questo aiuta a garantire la sicurezza dei tuoi account.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = mostrare la password salvata

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Per copiare la password, inserire le credenziali di accesso a Windows. Questo aiuta a garantire la sicurezza dei tuoi account.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copiare la password salvata

## Master Password notification

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Per esportare le credenziali salvate, inserire le credenziali di accesso a Windows. Questo aiuta a garantire la sicurezza dei tuoi account.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = esportare credenziali e password salvate

## Primary Password notification

about-logins-primary-password-notification-message = Inserire la password principale per visualizzare le credenziali e le password salvate
master-password-reload-button =
    .label = Accedi
    .accesskey = A

## Password Sync notification

## Dialogs

confirmation-dialog-cancel-button = Annulla
confirmation-dialog-dismiss-button =
    .title = Annulla

about-logins-confirm-remove-dialog-title = Rimuovere queste credenziali?
confirm-delete-dialog-message = Questa operazione non può essere annullata.
about-logins-confirm-remove-dialog-confirm-button = Rimuovi

about-logins-confirm-remove-all-dialog-confirm-button-label =
  { $count ->
     [1] Rimuovi
    *[other] Rimuovi tutte
  }

about-logins-confirm-remove-all-dialog-checkbox-label = Sì, rimuovi queste credenziali

about-logins-confirm-remove-all-dialog-title =
  { $count ->
     [one] Rimuovere queste credenziali?
    *[other] Rimuovere { $count } credenziali?
  }

about-logins-confirm-remove-all-dialog-message = Questa operazione rimuoverà le credenziali salvate in { -brand-short-name } e i relativi avvisi sulle violazioni. Non sarà possibile annullare questa operazione.

about-logins-confirm-remove-all-sync-dialog-title =
  { $count ->
     [one] Rimuovere queste credenziali da tutti i dispositivi?
    *[other] Rimuovere { $count } credenziali da tutti i dispositivi?
  }

about-logins-confirm-remove-all-sync-dialog-message = Questa operazione rimuoverà le credenziali salvate in { -brand-short-name } su tutti i dispositivi sincronizzati con l’{ -fxaccount-brand-name }. Anche i relativi avvisi sulle violazioni verranno rimossi. Non sarà possibile annullare questa operazione.

about-logins-confirm-export-dialog-title = Esportazione credenziali e password
about-logins-confirm-export-dialog-message = Le password verranno salvate come testo leggibile (ad esempio “Password123”). Chiunque abbia accesso al file esportato potrà vederle.
about-logins-confirm-export-dialog-confirm-button = Esporta…

about-logins-alert-import-title = Importazione completata
about-logins-alert-import-message = Visualizza riepilogo dettagliato dell’importazione

confirm-discard-changes-dialog-title = Ignorare le modifiche non salvate?
confirm-discard-changes-dialog-message = Tutte le modifiche non salvate andranno perse.
confirm-discard-changes-dialog-confirm-button = Ignora

## Breach Alert notification

about-logins-breach-alert-title = Violazione sito web
breach-alert-text = Dall’ultima volta in cui hai aggiornato queste credenziali, le password di questo sito web sono state rubate o diffuse pubblicamente. Modifica la tua password per proteggere questo account.
about-logins-breach-alert-date = Questa violazione si è verificata il giorno { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Apri { $hostname }
about-logins-breach-alert-learn-more-link = Ulteriori informazioni

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Password vulnerabile
about-logins-vulnerable-alert-text2 = Questa password è stata utilizzata in un altro account potenzialmente coinvolto in una violazione di dati. Il riutilizzo delle credenziali mette in pericolo tutti i tuoi account. Si consiglia di cambiare questa password.

# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Apri { $hostname }
about-logins-vulnerable-alert-learn-more-link = Ulteriori informazioni

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = È già presente un elemento per { $loginTitle } con lo stesso nome utente. <a data-l10n-name="duplicate-link">Passare all’elemento esistente?</a>

# This is a generic error message.
about-logins-error-message-default = Si è verificato un errore durante il salvataggio della password.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Esportazione credenziali
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = credenziali.csv
about-logins-export-file-picker-export-button = Esporta
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
  { PLATFORM() ->
      [macos] Documento CSV
     *[other] File CSV
  }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importazione credenziali da file
about-logins-import-file-picker-import-button = Importa
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
  { PLATFORM() ->
      [macos] Documento CSV
     *[other] File CSV
  }

# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
  { PLATFORM() ->
      [macos] Documento TSV
     *[other] File TSV
  }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Importazione completata
about-logins-import-dialog-items-added = <span>Nuove credenziali aggiunte:</span> <span data-l10n-name="count">{ $count }</span>

about-logins-import-dialog-items-modified = <span>Credenziali esistenti aggiornate:</span> <span data-l10n-name="count">{ $count }</span>

about-logins-import-dialog-items-no-change = <span>Credenziali duplicate:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(non importate)</span>
about-logins-import-dialog-items-error = <span>Errori:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(non importate)</span>
about-logins-import-dialog-done = Fatto

about-logins-import-dialog-error-title = Errore in fase di importazione
about-logins-import-dialog-error-conflicting-values-title = Valori multipli in conflitto per una credenziale
about-logins-import-dialog-error-conflicting-values-description = Ad esempio: diversi nome utente, password, URL ecc. per una credenziale.
about-logins-import-dialog-error-file-format-title = Errore nel formato del file
about-logins-import-dialog-error-file-format-description = Intestazioni di colonna errate o assenti. Assicurarsi che il file includa colonne per nome utente, password e URL.
about-logins-import-dialog-error-file-permission-title = Impossibile leggere il file
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } non è in grado di leggere il file. Provare a modificare i permessi del file.
about-logins-import-dialog-error-unable-to-read-title = Impossibile elaborare il file
about-logins-import-dialog-error-unable-to-read-description = Assicurarsi di aver selezionato un file CSV o TSV.
about-logins-import-dialog-error-no-logins-imported = Non è stata importata alcuna credenziale
about-logins-import-dialog-error-learn-more = Ulteriori informazioni
about-logins-import-dialog-error-try-import-again = Riprova importazione…
about-logins-import-dialog-error-cancel = Annulla

about-logins-import-report-title = Riepilogo importazione
about-logins-import-report-description = Credenziali e password importate in { -brand-short-name }.

#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Riga { $number }
about-logins-import-report-row-description-no-change = Duplicata (corrisponde esattamente a una credenziale esistente)
about-logins-import-report-row-description-modified = Credenziale esistente aggiornata
about-logins-import-report-row-description-added = Nuova credenziale aggiunta
about-logins-import-report-row-description-error = Errore: campo mancante

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Errore: valori multipli per il campo “{ $field }”
about-logins-import-report-row-description-error-missing-field = Errore: campo “{ $field }” mancante

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
  { $count ->
       [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nuova credenziale aggiunta</div>
      *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nuove credenziali aggiunte</div>
  }
about-logins-import-report-modified =
  { $count ->
       [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">credenziale esistente aggiornata</div>
      *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">credenziali esistenti aggiornate</div>
  }
about-logins-import-report-no-change =
  { $count ->
       [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">credenziale duplicata</div> <div data-l10n-name="not-imported">(non importata)</div>
      *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">credenziali duplicate</div> <div data-l10n-name="not-imported">(non importate)</div>
  }
about-logins-import-report-error =
  { $count ->
       [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">errore</div> <div data-l10n-name="not-imported">(credenziale non importata)</div>
      *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">errori</div> <div data-l10n-name="not-imported">(credenziali non importate)</div>
  }

## Logins import report page

about-logins-import-report-page-title = Riepilogo importazione
