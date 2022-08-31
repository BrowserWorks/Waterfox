# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = Assistente chiavi OpenPGP

openpgp-key-assistant-rogue-warning = Evita di accettare una chiave contraffatta. Per assicurarti di aver ottenuto la chiave giusta dovresti verificarla. <a data-l10n-name="openpgp-link">Ulteriori informazioni…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Impossibile crittare

# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] Per crittare, devi ottenere e accettare una chiave utilizzabile per un destinatario. <a data-l10n-name="openpgp-link">Ulteriori informazioni…</a>
       *[other] Per crittare, devi ottenere e accettare chiavi utilizzabili per { $count } destinatari. <a data-l10n-name="openpgp-link">Ulteriori informazioni…</a>
    }

openpgp-key-assistant-info-alias = { -brand-short-name } normalmente richiede che la chiave pubblica del destinatario contenga un ID utente con un indirizzo email corrispondente. Questo può essere ignorato utilizzando le regole di OpenPGP per gli alias del destinatario. <a data-l10n-name="openpgp-link">Ulteriori informazioni…</a>

# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Hai già una chiave utilizzabile e accettata per un destinatario.
       *[other] Hai già chiavi utilizzabili e accettate per { $count } destinatari.
    }

openpgp-key-assistant-recipients-description-no-issues = Questo messaggio può essere crittato. Hai chiavi utilizzabili e accettate per tutti i destinatari.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } ha trovato la seguente chiave per { $recipient }.
       *[other] { -brand-short-name } ha trovato le seguenti chiavi per { $recipient }.
    }

openpgp-key-assistant-valid-description = Seleziona la chiave che vuoi accettare

# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] La seguente chiave non può essere utilizzata senza prima ottenere un aggiornamento della chiave.
       *[other] Le seguenti chiavi non possono essere utilizzate senza prima ottenere un aggiornamento delle chiavi.
    }

openpgp-key-assistant-no-key-available = Nessuna chiave disponibile.

openpgp-key-assistant-multiple-keys = Sono disponibili più chiavi.

# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] È disponibile una chiave, ma non è stata ancora accettata.
       *[other] Sono disponibili più chiavi, ma nessuna è stata ancora accettata.
    }

# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Una chiave accettata è scaduta il { $date }.

openpgp-key-assistant-keys-accepted-expired = Sono scadute più chiavi accettate.

# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Questa chiave era stata precedentemente accettata ma è scaduta il { $date }.

# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = La chiave è scaduta il { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Sono scadute più chiavi.

openpgp-key-assistant-key-fingerprint = Impronta digitale

openpgp-key-assistant-key-source =
    { $count ->
        [one] Origine
       *[other] Origini
    }

openpgp-key-assistant-key-collected-attachment = allegato email
openpgp-key-assistant-key-collected-autocrypt = Critta automaticamente intestazione
openpgp-key-assistant-key-collected-keyserver = keyserver
openpgp-key-assistant-key-collected-wkd = Directory Web Key

openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] È stata trovata una chiave, ma non è stata ancora accettata.
       *[other] Sono state trovate più chiavi, ma nessuna è stata ancora accettata.
    }

openpgp-key-assistant-key-rejected = Questa chiave è stata precedentemente rifiutata.
openpgp-key-assistant-key-accepted-other = Questa chiave è stata precedentemente accettata per un altro indirizzo email.

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Trova online le chiavi aggiuntive o aggiornate per { $recipient } o importale da un file.

## Discovery section

openpgp-key-assistant-discover-title = Ricerca online in corso.

# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Ricerca delle chiavi per { $recipient } in corso…

# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    È stato trovato un aggiornamento per una delle chiavi precedentemente accettate per { $recipient }.
    Ora può essere utilizzata in quanto non è più scaduta.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Trova chiavi pubbliche online…

openpgp-key-assistant-import-keys-button = Importa chiavi pubbliche da file…

openpgp-key-assistant-issue-resolve-button = Risolvi…

openpgp-key-assistant-view-key-button = Visualizza chiave…

openpgp-key-assistant-recipients-show-button = Mostra

openpgp-key-assistant-recipients-hide-button = Nascondi

openpgp-key-assistant-cancel-button = Annulla

openpgp-key-assistant-back-button = Indietro

openpgp-key-assistant-accept-button = Accetta

openpgp-key-assistant-close-button = Chiudi

openpgp-key-assistant-disable-button = Disattiva crittografia

openpgp-key-assistant-confirm-button = Invia crittato

# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = data di creazione: { $date }
