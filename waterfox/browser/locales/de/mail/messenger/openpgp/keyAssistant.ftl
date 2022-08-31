# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = OpenPGP-Schlüsselassistent

openpgp-key-assistant-rogue-warning = Vermeiden Sie das Akzeptieren von gefälschten Schlüsseln. Um das Akzeptieren eines richtigen Schlüssels sicherzustellen, sollten Sie diesen verifizieren. <a data-l10n-name="openpgp-link">Weitere Informationen…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Verschlüsselung nicht möglich

# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] Um verschlüsseln zu können, müssen Sie über einen verwendbaren Schlüssel für einen Empfänger verfügen und diesen akzeptieren. <a data-l10n-name="openpgp-link">Weitere Informationen…</a>
        *[other] Um verschlüsseln zu können, müssen Sie über verwendbare Schlüssel für { $count } Empfänger verfügen und diese akzeptieren. <a data-l10n-name="openpgp-link">Weitere Informationen…</a>
    }

openpgp-key-assistant-info-alias = { -brand-short-name } erfordert standardmäßig die Übereinstimmung einer Benutzerkennung des öffentlichen Schlüssels des Empfängers mit einer E-Mail-Adresse. Dies kann mittels einer OpenPGP-Alias-Regel überschrieben werden. <a data-l10n-name="openpgp-link">Weitere Informationen…</a>

# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Sie besitzen bereits einen verwendbaren und akzeptierten Schlüssel für einen Empfänger.
        *[other] Sie besitzen bereits verwendbare und akzeptierte Schlüssel für { $count } Empfänger.
    }

openpgp-key-assistant-recipients-description-no-issues = Diese Nachricht kann verschlüsselt werden. Sie besitzen verwendbare und akzeptierte Schlüssel für alle Empfänger.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } fand den folgenden Schlüssel für { $recipient }.
        *[other] { -brand-short-name } fand die folgenden Schlüssel für { $recipient }.
    }

openpgp-key-assistant-valid-description = Wählen Sie den zu akzeptierenden Schlüssel.

# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] Der folgende Schlüssel kann nicht verwendet werden, da er eine Aktualisierung benötigt.
        *[other] Die folgenden Schlüssel können nicht verwendent werden, da sie Aktualisierungen benötigen.
    }

openpgp-key-assistant-no-key-available = Kein Schlüssel verfügbar

openpgp-key-assistant-multiple-keys = Mehrere Schlüssel verfügbar

# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] Es ist ein Schlüssel verfügbar, aber er wurde noch nicht akzeptiert.
        *[other] Es sind mehrere Schlüssel verfügbar, aber keiner von ihnen wurde bislang akzeptiert.
    }

# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Ein akzeptierter Schlüssel lief am { $date } ab.

openpgp-key-assistant-keys-accepted-expired = Mehrere Schlüssel sind abgelaufen.

# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Dieser Schlüssel wurde akzeptiert, aber lief am { $date } ab.

# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one =
    Der Schlüssel lief am { $date } ab.
openpgp-key-assistant-key-unaccepted-expired-many =
    Mehrere Schlüssel sind abgelaufen.

openpgp-key-assistant-key-fingerprint = Fingerabdruck

openpgp-key-assistant-key-source =
  { $count ->
      [one] Quelle
      *[other] Quellen
  }

openpgp-key-assistant-key-collected-attachment = E-Mail-Anhang
openpgp-key-assistant-key-collected-autocrypt = Autocrypt-Kopfzeile
openpgp-key-assistant-key-collected-keyserver = Schlüsselserver
openpgp-key-assistant-key-collected-wkd = Web-Key-Verzeichnis

openpgp-key-assistant-keys-has-collected =
  { $count ->
      [one] Es wurde ein Schlüssel gefunden, der aber noch nicht akzeptiert wurde.
      *[other] Es wurden mehrere Schlüssel gefunden, von denen aber noch keiner akzeptiert wurde.
  }

openpgp-key-assistant-key-rejected = Dieser Schlüssel wurde bereits zurückgewiesen.
openpgp-key-assistant-key-accepted-other = Dieser Schlüssel wurde bereits für eine andere E-Mail-Adresse akzeptiert.

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info =
  Weitere oder aktualisierte Schlüssel für { $recipient } finden oder aus einer Datei importieren

## Discovery section

openpgp-key-assistant-discover-title = Online-Suche wird durchgeführt.

# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Schlüssel für { $recipient } werden gesucht…

# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Es wurde eine Aktualisierung für einen der vorher akzeptieren Schlüssel für { $recipient } gefunden.
    Er kann jetzt benutzt werden, da er nicht mehr abgelaufen ist.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Öffentliche Schlüssel online finden…

openpgp-key-assistant-import-keys-button = Öffentliche Schlüssel aus Datei importieren…

openpgp-key-assistant-issue-resolve-button = Beheben…

openpgp-key-assistant-view-key-button = Schlüssel anzeigen…

openpgp-key-assistant-recipients-show-button = Anzeigen

openpgp-key-assistant-recipients-hide-button = Ausblenden

openpgp-key-assistant-cancel-button = Abbrechen

openpgp-key-assistant-back-button = Zurück

openpgp-key-assistant-accept-button = Annehmen

openpgp-key-assistant-close-button = Schließen

openpgp-key-assistant-disable-button = Verschlüsselung deaktivieren

openpgp-key-assistant-confirm-button = Verschlüsselt senden

# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = erstellt am { $date }
