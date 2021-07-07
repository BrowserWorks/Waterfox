# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Persönlichen OpenPGP-Schlüssel für { $identity } hinzufügen

key-wizard-button =
    .buttonlabelaccept = Weiter
    .buttonlabelhelp = Zurück

key-wizard-warning = <b>Falls Sie bereits einen persönlichen Schlüssel für diese E-Mail-Adresse besitzen</b>, sollten Sie diesen importieren. Ansonsten haben Sie keinen Zugriff auf Ihre alten verschlüsselten Nachrichten noch werden Sie die Nachrichten von Personen lesen können, welche noch Ihren alten Schlüssel verwenden.

key-wizard-learn-more = Weitere Informationen

radio-create-key =
    .label = Neuen OpenPGP-Schlüssel erzeugen
    .accesskey = N

radio-import-key =
    .label = Bestehenden OpenPGP-Schlüssel importieren
    .accesskey = m

radio-gnupg-key =
    .label = Externen Schlüssel mittels GnuPG benutzen (z.B. von einer Smartcard)
    .accesskey = E

## Generate key section

openpgp-generate-key-title = OpenPGP-Schlüssel erzeugen

openpgp-generate-key-info = <b>Das Erzeugen eines Schlüssels kann mehrere Minuten dauern.</b> Beenden Sie die Anwendung nicht, während der Schlüssel erzeugt wird. Aktives Surfen im Internet oder intensive Lese- und Schreibvorgänge setzen den 'Zufallsgenerator' wieder auf Normalniveau zurück und beschleunigen den Vorgang. Sie werden benachrichtigt, wenn die Schlüsselerzeugung abgeschlossen ist.

openpgp-keygen-expiry-title = Ablaufdatum

openpgp-keygen-expiry-description = Legen Sie das Ablaufdatum Ihres neu erzeugten Schlüssels fest. Sie können das Datum später weiter in die Zukunft verschieben, falls nötig.

radio-keygen-expiry =
    .label = Schlüssel läuft ab in
    .accesskey = a

radio-keygen-no-expiry =
    .label = Schlüssel läuft nicht ab
    .accesskey = n

openpgp-keygen-days-label =
    .label = Tagen
openpgp-keygen-months-label =
    .label = Monaten
openpgp-keygen-years-label =
    .label = Jahren

openpgp-keygen-advanced-title = Erweiterte Einstellungen

openpgp-keygen-advanced-description = Erweiterte Einstellungen für Ihren OpenPGP-Schlüssel festlegen

openpgp-keygen-keytype =
    .value = Schlüsseltyp:
    .accesskey = t

openpgp-keygen-keysize =
    .value = Schlüsselgröße:
    .accesskey = g

openpgp-keygen-type-rsa =
    .label = RSA

openpgp-keygen-type-ecc =
    .label = ECC (Elliptische Kurve)

openpgp-keygen-button = Schlüssel erzeugen

openpgp-keygen-progress-title = Ihr neuer OpenPGP-Schlüssel wird erzeugt…

openpgp-keygen-import-progress-title = Ihre OpenPGP-Schlüssel werden importiert…

openpgp-import-success = OpenPGP-Schlüssel wurden erfolgreich importiert

openpgp-import-success-title = Importvorgang abschließen

openpgp-import-success-description = Um Ihre importierten OpenPGP-Schlüssel für E-Mail-Verschlüsselung zu verwenden, schließen Sie diesen Dialog, öffnen Sie die Konten-Einstellungen und wählen Sie den Schlüssel aus.

openpgp-keygen-confirm =
    .label = Bestätigen

openpgp-keygen-dismiss =
    .label = Abbrechen

openpgp-keygen-cancel =
    .label = Vorgang abbrechen…

openpgp-keygen-import-complete =
    .label = Schließen
    .accesskey = c

openpgp-keygen-missing-username = Für das ausgewählte Konto ist kein Name festgelegt. Bitte geben Sie in den Konten-Einstellungen einen Wert in das Feld "Ihr Name" ein.
openpgp-keygen-long-expiry = Es kann kein Schlüssel mit mehr als 100 Jahren Gültigkeit erzeugt werden.
openpgp-keygen-short-expiry = Der Schlüssel muss mindestens einen Tag gültig sein.

openpgp-keygen-ongoing = Schlüsselerzeugung wird bereits durchgeführt

openpgp-keygen-error-core = OpenPGP-Basisdienste konnten nicht initialisiert werden

openpgp-keygen-error-failed = Erzeugung von OpenPGP-Schlüssel schlug unerwartet fehl

#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = OpenPGP-Schlüssel erfolgreich erzeugt, aber Erstellen des Widerrufs für Schlüssel { $key } schlug fehl

openpgp-keygen-abort-title = Schlüsselerzeugung abbrechen?
openpgp-keygen-abort = Derzeit wird die Erzeugung eines OpenPGP-Schlüssels durchgeführt, soll diese wirklich abgebrochen werden?

#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Öffentlichen und geheimen Schlüssel für { $identity } erzeugen?

## Import Key section

openpgp-import-key-title = Bestehenden persönlichen OpenPGP-Schlüssel importieren

openpgp-import-key-legend = Vorher erzeugte Sicherheitskopie auswählen

openpgp-import-key-description = Sie können persönliche Schlüssel importieren, welche mit anderer OpenPGP-Software erzeugt wurden.

openpgp-import-key-info = Andere Software kann den persönlichen Schlüssel anders bezeichnen, z.B. "Ihr eigener Schlüssel", "geheimer Schlüssel", "privater Schlüssel" oder "Schlüsselpaar".

#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount = { $count ->
    [one]   Thunderbird erkannte einen importierbaren Schlüssel.
   *[other] Thunderbird erkannte { $count } importierbare Schlüssel.
}

openpgp-import-key-list-description = Bestätigen Sie, welche Schlüssel Ihre persönlichen sind. Nur von Ihnen selbst erzeugte Schlüssel und die Sie als Schlüsselinhaber ausgeben sollten als persönliche Schlüssel verwendet werden. Sie können diese Eigenschaft später in den Schlüsseleigenschaften ändern.

openpgp-import-key-list-caption = Als persönlich gekennzeichnete Schlüssel werden im Abschnitt Ende-zu-Ende-Verschlüsselung aufgeführt. Die anderen Schlüssel sind in der Schlüsselverwaltung verfügbar.

openpgp-passphrase-prompt-title = Passwort benötigt

#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Bitte Passwort eingeben, um den folgenden Schlüssel zu entsperren: { $key }

openpgp-import-key-button =
    .label = Datei für den Import auswählen…
    .accesskey = D

import-key-file = OpenPGP-Schlüsseldatei importieren

import-key-personal-checkbox =
    .label = Diesen Schlüssel als persönlichen Schlüssel verwenden

gnupg-file = GnuPG-Dateien

import-error-file-size = <b>Fehler:</b> Dateien größer als 5MB werden nicht unterstützt.

#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Fehler:</b> Datei konnte nicht importiert werden. { $error }

#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Fehler:</b> Fehler beim Schlüsselimport. { $error }

openpgp-import-identity-label = Identität

openpgp-import-fingerprint-label = Fingerabdruck

openpgp-import-created-label = Erstellt am

openpgp-import-bits-label = Bit

openpgp-import-key-props =
    .label = Schlüsseleigenschaften
    .accesskey = e

## External Key section

openpgp-external-key-title = Externer GnuPG-Schlüssel

openpgp-external-key-description = Richten Sie einen externen GnuPG-Schlüssel ein, indem Sie die Schlüssel-ID eingeben.

openpgp-external-key-info = Zusätzlich müssen Sie den entsprechenden öffentlichen Schlüssel in der Schlüsselverwaltung importieren und akzeptieren.

openpgp-external-key-warning = <b>Es wird nur die Konfiguration eines externen GnuPG-Schlüssels unterstützt.</b> Ihr vorheriger Eintrag wird ersetzt.

openpgp-save-external-button = Schlüssel-ID speichern

openpgp-external-key-label = ID des geheimen Schlüssels:

openpgp-external-key-input =
    .placeholder = 123456789341298340
