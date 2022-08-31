# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Sicherheit OpenPGP-Nachricht
openpgp-one-recipient-status-status =
    .label = Status
openpgp-one-recipient-status-key-id =
    .label = Schlüssel-ID
openpgp-one-recipient-status-created-date =
    .label = Erstellt am
openpgp-one-recipient-status-expires-date =
    .label = Läuft ab am
openpgp-one-recipient-status-open-details =
    .label = Details öffnen und Akzeptanz bearbeiten…
openpgp-one-recipient-status-discover =
    .label = Neuen oder aktualisierten Schlüssel suchen

openpgp-one-recipient-status-instruction1 = Um eine mit Ende-zu-Ende Verschlüsselung geschützte Nachricht an einen Empfänger zu senden, müssen Sie dessen öffentlichen Schlüssel erhalten und als akzeptiert setzen.
openpgp-one-recipient-status-instruction2 = Um den öffentlichen Schlüssel zu erhalten, importieren Sie diesen aus einer Nachricht, welche der Empfänger an Sie gesendet hat. Oder Sie finden den öffentlichen Schlüssel des Empfängers in einem Verzeichnis.

openpgp-key-own = Akzeptiert (persönlicher Schlüssel)
openpgp-key-secret-not-personal = Nicht verwendbar
openpgp-key-verified = Akzeptiert (verifiziert)
openpgp-key-unverified = Akzeptiert (nicht verifiziert)
openpgp-key-undecided = Nicht akzeptiert (nicht entschieden)
openpgp-key-rejected = Nicht akzeptiert (abgelehnt)
openpgp-key-expired = Abgelaufen

openpgp-intro = Verfügbare öffentliche Schlüssel für { $key }

openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = Fingerabdruck: { $fpr }

openpgp-pubkey-import-intro =
    { $num ->
      [one] Die Datei enthält den unten aufgeführten öffentlichen Schlüssel:
      *[other] Die Datei enthält {$num} unten aufgeführte öffentliche Schlüssel:
    }

openpgp-pubkey-import-accept =
    { $num ->
      [one] Soll dieser Schlüssel für das Verifizieren digitaler Unterschriften und das Verschlüsseln von Nachrichten für alle genannten E-Mail-Adressen akzeptiert werden?
      *[other] Sollen diese Schlüssel für das Verifizieren digitaler Unterschriften und das Verschlüsseln von Nachrichten für alle genannten E-Mail-Adressen akzeptiert werden?
    }

pubkey-import-button =
    .buttonlabelaccept = Importieren
    .buttonaccesskeyaccept = m
