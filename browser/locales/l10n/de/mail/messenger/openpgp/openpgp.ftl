# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

e2e-intro-description = Um Nachrichten zu verschlüsseln oder digital zu unterschreiben, muss eine der Verschlüsselungstechnologien OpenPGP oder S/MIME eingerichtet werden.

e2e-intro-description-more = Wählen Sie Ihren persönlichen Schlüssel für die Verwendung von OpenPGP oder Ihr persönliches Zertifikat für S/MIME. Für einen persönlichen Schlüssel oder ein persönliches Zertifikat verfügen Sie über den entsprechenden geheimen Schlüssel.

openpgp-key-user-id-label = Konto / Benutzerkennung
openpgp-keygen-title-label =
    .title = OpenGPG-Schlüssel erzeugen
openpgp-cancel-key =
    .label = Abbrechen
    .tooltiptext = Schlüsselerzeugung abbrechen
openpgp-key-gen-expiry-title =
    .label = Ablaufdatum
openpgp-key-gen-expire-label = Schlüssel wird ungültig in
openpgp-key-gen-days-label =
    .label = Tagen
openpgp-key-gen-months-label =
    .label = Monaten
openpgp-key-gen-years-label =
    .label = Jahren
openpgp-key-gen-no-expiry-label =
    .label = Schlüssel wird nie ungültig
openpgp-key-gen-key-size-label = Schlüssellänge
openpgp-key-gen-console-label = Schlüsselerzeugung
openpgp-key-gen-key-type-label = Schlüsselart
openpgp-key-gen-key-type-rsa =
    .label = RSA
openpgp-key-gen-key-type-ecc =
    .label = ECC (Elliptische Kurve)
openpgp-generate-key =
    .label = Schlüssel erzeugen
    .tooltiptext = Erzeugt ein OpenGPG-konformes Schlüsselpaar zum Verschlüsseln und/oder Unterschreiben
openpgp-advanced-prefs-button-label =
    .label = Erweitert…
openpgp-keygen-desc = <a data-l10n-name="openpgp-keygen-desc-link">HINWEIS: Das Erzeugen eines Schlüssels kann mehrere Minuten dauern.</a> Beenden Sie die Anwendung nicht, während der Schlüssel erzeugt wird. Aktives Surfen im Internet oder intensive Lese- und Schreibvorgänge setzen den 'Zufallsgenerator' wieder auf Normalniveau zurück und beschleunigen den Vorgang. Sie werden benachrichtigt, wenn die Schlüsselerzeugung abgeschlossen ist.

openpgp-key-expiry-label =
    .label = Läuft ab

openpgp-key-id-label =
    .label = Schlüssel-ID

openpgp-cannot-change-expiry = Dies ist ein Schlüssel mit einer komplexen Struktur, das Ändern des Ablaufdatums wird nicht unterstützt.

openpgp-key-man-title =
    .title = OpenPGP-Schlüssel verwalten
openpgp-key-man-generate =
    .label = Neues Schlüsselpaar
    .accesskey = N
openpgp-key-man-gen-revoke =
  .label = Widerrufszertifikat
  .accesskey = W
openpgp-key-man-ctx-gen-revoke-label =
    .label = Widerrufzertifikat erzeugen und speichern

openpgp-key-man-file-menu =
    .label = Datei
    .accesskey = D
openpgp-key-man-edit-menu =
    .label = Bearbeiten
    .accesskey = B
openpgp-key-man-view-menu =
    .label = Ansicht
    .accesskey = A
openpgp-key-man-generate-menu =
    .label = Erzeugen
    .accesskey = E
openpgp-key-man-keyserver-menu =
    .label = Schlüsselserver
    .accesskey = S

openpgp-key-man-import-public-from-file =
    .label = Öffentliche(n) Schlüssel aus Datei importieren
    .accesskey = D
openpgp-key-man-import-secret-from-file =
    .label = Geheime(n) Schlüssel aus Datei importieren
openpgp-key-man-import-sig-from-file =
    .label = Widerrufszertifikat(e) aus Datei importieren
openpgp-key-man-import-from-clipbrd =
    .label = Schlüssel aus Zwischenablage importieren
    .accesskey = Z
openpgp-key-man-import-from-url =
    .label = Schlüssel von Adresse importieren
    .accesskey = d
openpgp-key-man-export-to-file =
    .label = Schlüssel in Datei exportieren
    .accesskey = e
openpgp-key-man-send-keys =
    .label = Öffentliche Schlüssel per E-Mail senden
    .accesskey = S
openpgp-key-man-backup-secret-keys =
    .label = Sicherheitskopie für geheime(n) Schlüssel erstellen
    .accesskey = g

openpgp-key-man-discover-cmd =
    .label = Schlüssel online finden
    .accesskey = o
openpgp-key-man-discover-prompt = Geben Sie eine E-Mail-Adresse oder Schlüssel-ID ein, um OpenPGP-Schlüssel auf Schlüsselservern oder mit dem WKD-Protokoll zu finden.
openpgp-key-man-discover-progress = Suche wird durchgeführt…

openpgp-key-copy-key =
    .label = Öffentlichen Schlüssel kopieren
    .accesskey = k

openpgp-key-export-key =
    .label = Öffentlichen Schlüssel exportieren
    .accesskey = e

openpgp-key-backup-key =
    .label = Sicherheitskopie für geheimen Schlüssel erstellen
    .accesskey = g

openpgp-key-send-key =
    .label = Öffentlichen Schlüssel per E-Mail senden
    .accesskey = S

openpgp-key-man-copy-to-clipbrd =
    .label = Öffentliche(n) Schlüssel in Zwischenablage kopieren
    .accesskey = b

openpgp-key-man-copy-key-ids =
    .label = { $count ->
               [one] Schlüssel-ID in Zwischenablage kopieren
               *[other] Schlüssel-IDs in Zwischenablage kopieren
             }
    .accesskey = k

openpgp-key-man-copy-fprs =
    .label = { $count ->
               [one] Fingerabdruck in Zwischenablage kopieren
               *[other] Fingerabdrücke in Zwischenablage kopieren
             }
    .accesskey = F

openpgp-key-man-copy-to-clipboard =
    .label = { $count ->
               [one] Öffentlichen Schlüssel in Zwischenablage kopieren
               *[other] Öffentliche Schlüssel in Zwischenablage kopieren
             }
    .accesskey = p

openpgp-key-man-ctx-expor-to-file-label =
    .label = Schlüssel in Datei exportieren
openpgp-key-man-ctx-copy-to-clipbrd-label =
    .label = Öffentliche Schlüssel in Zwischenablage kopieren

openpgp-key-man-ctx-copy =
    .label = Kopieren
    .accesskey = K

openpgp-key-man-ctx-copy-fprs =
    .label = { $count ->
               [one] Fingerabdruck
               *[other] Fingerabdrücke
             }
    .accesskey = F

openpgp-key-man-ctx-copy-key-ids =
    .label = { $count ->
               [one] Schlüssel-ID
               *[other] Schlüssel-IDs
             }
    .accesskey = D

openpgp-key-man-ctx-copy-public-keys =
    .label = { $count ->
               [one] Öffentlicher Schlüssel
               *[other] Öffentliche Schlüssel
             }
    .accesskey = n

openpgp-key-man-close =
    .label = Schließen
openpgp-key-man-reload =
    .label = Schlüsselzwischenspeicher neu laden
    .accesskey = n
openpgp-key-man-change-expiry =
    .label = Ablaufdatum ändern
    .accesskey = A
openpgp-key-man-del-key =
    .label = Schlüssel löschen
    .accesskey = c
openpgp-delete-key =
    .label = Schlüssel löschen
    .accesskey = c
openpgp-key-man-revoke-key =
    .label = Schlüssel widerrufen
    .accesskey = w
openpgp-key-man-key-props =
    .label = Schlüsseleigenschaften
    .accesskey = e
openpgp-key-man-key-more =
    .label = Mehr
    .accesskey = M
openpgp-key-man-view-photo =
    .label = Fotokennung
    .accesskey = F
openpgp-key-man-ctx-view-photo-label =
    .label = Fotokennung anzeigen
openpgp-key-man-show-invalid-keys =
    .label = Ungültige Schlüssel anzeigen
    .accesskey = U
openpgp-key-man-show-others-keys =
    .label = Schlüssel anderer Personen anzeigen
    .accesskey = P
openpgp-key-man-user-id-label =
    .label = Name
openpgp-key-man-fingerprint-label =
    .label = Fingerabdruck
openpgp-key-man-select-all =
    .label = Alle Schlüssel auswählen
    .accesskey = A
openpgp-key-man-empty-tree-tooltip =
    .label = Suchbegriffe in das Eingabefeld oberhalb eingeben
openpgp-key-man-nothing-found-tooltip =
    .label = Kein Schlüssel stimmt mit dem Suchbegriff überein
openpgp-key-man-please-wait-tooltip =
    .label = Bitte warten, Schlüssel werden geladen…

openpgp-key-man-filter-label =
    .placeholder = Nach Schlüsseln suchen

openpgp-key-man-select-all-key =
    .key = A
openpgp-key-man-key-details-key =
    .key = I

openpgp-key-details-title =
    .title = Schlüsseleigenschaften
openpgp-key-details-signatures-tab =
    .label = Zertifizierungen
openpgp-key-details-structure-tab =
    .label = Struktur
openpgp-key-details-uid-certified-col =
    .label = Benutzerkennung / Zertifiziert von
openpgp-key-details-user-id2-label = Vorgeblicher Schlüsselbesitzer
openpgp-key-details-id-label =
    .label = ID
openpgp-key-details-key-type-label = Typ
openpgp-key-details-key-part-label =
    .label = Schlüsselteil
openpgp-key-details-algorithm-label =
    .label = Algorithmus
openpgp-key-details-size-label =
    .label = Länge
openpgp-key-details-created-label =
    .label = Erzeugt am
openpgp-key-details-created-header = Erzeugt am
openpgp-key-details-expiry-label =
    .label = Läuft ab am
openpgp-key-details-expiry-header = Läuft ab am
openpgp-key-details-usage-label =
    .label = Fingerabdruck
openpgp-key-details-fingerprint-label = Fingerabdruck
openpgp-key-details-sel-action =
  .label = Aktion wählen…
  .accesskey = w
openpgp-key-details-also-known-label = Vorgebliche alternative Identitäten des Schlüsselbesitzers:
openpgp-card-details-close-window-label =
    .buttonlabelaccept = Schließen
openpgp-acceptance-label =
    .label = Ihre Akzeptanz
openpgp-acceptance-rejected-label =
    .label = Nein, diesen Schlüssel zurückweisen.
openpgp-acceptance-undecided-label =
    .label = Nicht jetzt, vielleicht später
openpgp-acceptance-unverified-label =
    .label = Ja, aber ich habe nicht überprüft, dass es sich um den korrekten Schlüssel handelt.
openpgp-acceptance-verified-label =
    .label = Ja, ich selbst habe überprüft, dass der Schlüssel über den korrekten Fingerabdruck verfügt.
key-accept-personal =
    Sie verfügen sowohl über den öffentlichen als auch über den geheimen Teil dieses Schlüssels und können ihn daher als persönlichen Schlüssel verwenden.
    Falls Sie diesen Schlüssel von einer anderen Person erhalten haben, dürfen Sie diesen nicht als persönlichen Schlüssel verwenden.
key-personal-warning = Haben Sie den Schlüssel selbst erzeugt und gibt der Schlüssel Sie als Besitzer aus?
openpgp-personal-no-label =
    .label = Nein, nicht als meinen persönlichen Schlüssel verwenden.
openpgp-personal-yes-label =
    .label = Ja, als meinen persönlichen Schlüssel verwenden.

openpgp-copy-cmd-label =
    .label = Kopieren

## e2e encryption settings

#   $count (Number) - the number of configured keys associated with the current identity
#   $identity (String) - the email address of the currently selected identity
openpgp-description = { $count ->
    [0]     Thunderbird verfügt über keinen persönlichen OpenPGP-Schlüssel für <b>{ $identity }</b>.
    [one]   Thunderbird verfügt über { $count } persönlichen OpenPGP-Schlüssel für <b>{ $identity }</b>.
   *[other] Thunderbird verfügt über { $count } persönliche OpenPGP-Schlüssel für <b>{ $identity }</b>.
}

#   $count (Number) - the number of configured keys associated with the current identity
#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status = { $count ->
    [0]     Wählen Sie einen gültigen Schlüssel aus, um das OpenPGP-Protokoll zu aktivieren.
   *[other] Derzeit ist die Verwendung der Schlüssel-ID <b>{ $key }</b> festgelegt.
}

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-have-key = Derzeit ist die Verwendung der Schlüssel-ID <b>{ $key }</b> festgelegt.

#   $key (String) - the currently selected OpenPGP key
openpgp-selection-status-error = Derzeit ist die Verwendung der Schlüssel-ID <b>{ $key }</b> festgelegt, aber der Schlüssel ist abgelaufen.

openpgp-add-key-button =
    .label = Schlüssel hinzufügen…
    .accesskey = h

e2e-learn-more = Weitere Informationen

openpgp-keygen-success = OpenPGP-Schlüssel erfolgreich erstellt

openpgp-keygen-import-success = OpenPGP-Schlüssel erfolgreich importiert

openpgp-keygen-external-success = Externe GnuPG-Schlüssel-ID gespeichert

## OpenPGP Key selection area

openpgp-radio-none =
    .label = Keiner

openpgp-radio-none-desc = OpenPGP für diese Identität nicht verwenden

openpgp-radio-key-not-usable = Dieser Schlüssel kann nicht als persönlicher Schlüssel verwendet werden, weil der geheime Schlüssel fehlt.
openpgp-radio-key-not-accepted = Sie müssen den Schlüssel bestätigen, um ihn als persönlichen Schlüssel zu verwenden.
openpgp-radio-key-not-found = Dieser Schlüssel wurde nicht gefunden. Falls er verwendet werden soll, muss er in { -brand-short-name } importiert werden.

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expires = Läuft ab: { $date }

openpgp-key-expires-image =
    .tooltiptext = Schlüssel läuft in weniger als 6 Monaten ab

#   $key (String) - the expiration date of the OpenPGP key
openpgp-radio-key-expired = Abgelaufen am: { $date }

openpgp-key-expired-image =
    .tooltiptext = Schlüssel abgelaufen

openpgp-key-expires-within-6-months-icon =
    .title = Schlüssel läuft in weniger als 6 Monaten ab

openpgp-key-has-expired-icon =
    .title = Schlüssel abgelaufen

openpgp-key-expand-section =
  .tooltiptext = Weitere Informationen

openpgp-key-revoke-title = Schlüssel widerrufen

openpgp-key-edit-title = OpenPGP-Schlüssel ändern

openpgp-key-edit-date-title = Ablaufdatum ändern

openpgp-manager-description = Mit der OpenPGP-Schlüsselverwaltung können Sie die Schlüssel Ihrer Kontakte und andere oben nicht aufgeführte Schlüssel anzeigen und verwalten.

openpgp-manager-button =
    .label = OpenPGP-Schlüssel verwalten
    .accesskey = v

openpgp-key-remove-external =
    .label = Externe Schlüssel-ID entfernen
    .accesskey = E

key-external-label = Externer GnuPG-Schlüssel

# Strings in keyDetailsDlg.xhtml
key-type-public = öffentlicher Schlüssel
key-type-primary = primärer Schlüssel
key-type-subkey = Unterschlüssel
key-type-pair = Schlüsselpaar (geheimer Schlüssel und öffentlicher Schlüssel)
key-expiry-never = nie
key-usage-encrypt = Verschlüsseln
key-usage-sign = Unterschreiben
key-usage-certify = Beglaubigen
key-usage-authentication = Authentifizieren
key-does-not-expire = Der Schlüssel läuft nicht ab.
key-expired-date = Der Schlüssel lief am { $keyExpiry } ab.
key-expired-simple = Der Schlüssel ist abgelaufen.
key-revoked-simple = Der Schlüssel wurde widerrufen.
key-do-you-accept = Akzeptieren Sie diesen Schlüssel für das Verifizieren von digitalen Unterschriften und das Verschlüsseln von Nachrichten?
key-accept-warning = Akzeptieren Sie nur vertrauenswürdige Schlüssel. Verwenden Sie einen anderen Kommunikationskanal als E-Mail, um den Fingerabdruck des Schlüssels Ihres Kontakts zu verifizieren.

# Strings enigmailMsgComposeOverlay.js
cannot-use-own-key-because = Die Nachricht konnte nicht gesendet werden, da es ein Problem mit Ihrem persönlichen Schlüssel gibt. { $problem }
cannot-encrypt-because-missing = Die Nachricht kann nicht mit Ende-zu-Ende-Verschlüsselung gesendet werden, weil es Probleme mit den Schlüsseln folgender Empfänger gibt: { $problem }
window-locked = Das Verfassen-Fenster ist gesperrt, der Sende-Vorgang wurde abgebrochen.

# Strings in mimeDecrypt.jsm
mime-decrypt-encrypted-part-attachment-label = Verschlüsselter Teil der Nachricht
mime-decrypt-encrypted-part-concealed-data = Dies ist ein verschlüsselter Teil der Nachricht. Sie müssen ihn in einem separaten Fenster öffnen, indem Sie auf den Anhang klicken.

# Strings in keyserver.jsm
keyserver-error-aborted = Abgebrochen
keyserver-error-unknown = Ein unbekannter Fehler trat auf.
keyserver-error-server-error = Der Schlüsselserver meldete einen Fehler.
keyserver-error-import-error = Beim Import des heruntergeladenen Schlüssels trat ein Fehler auf.
keyserver-error-unavailable = Der Schlüsselserver ist nicht verfügbar.
keyserver-error-security-error = Der Schlüsselserver unterstützt keinen verschlüsselten Zugriff.
keyserver-error-certificate-error = Das Zertifikat des Schlüsselservers ist ungültig.
keyserver-error-unsupported = Der Schlüsselserver wird nicht unterstützt.

# Strings in mimeWkdHandler.jsm
wkd-message-body-req =
    Ihr E-Mail-Anbieter hat Ihre Anfrage zum Hochladen Ihres öffentlichen Schlüssels in das OpenPGP-Web-Key-Verzeichnis verarbeitet.
    Bitte überprüfen Sie, dass Ihr öffentlicher Schlüssel veröffentlicht wurde.
wkd-message-body-process =
    Dies ist eine E-Mail im Zusammenhang mit der automatischen Verarbeitung, um Ihren öffentlichen Schlüssel in das OpenPGP-Web-Key-Verzeichnis hochzuladen.
    Sie müssen an dieser Stelle keine manuelle Handlung durchführen.

# Strings in persistentCrypto.jsm
converter-decrypt-body-failed =
    Die Nachricht mit dem Betreff
    { $subject }
    konnte nicht entschlüsselt werden. Wollen Sie es mit einem anderen Passwort erneut versuchen oder die Nachricht überspringen?

# Strings in gpg.jsm
unknown-signing-alg = Unbekannter Signatur-Algorithmus (ID: { $id })
unknown-hash-alg = Unbekannter kryptographischer Hash (ID: { $id })

# Strings in keyUsability.jsm
expiry-key-expires-soon =
    Ihr Schlüssel { $desc } läuft in weniger als { $days } Tagen ab.
    Es wird empfohlen, dass Sie ein neues Schlüsselpaar erzeugen und die entsprechenden E-Mail-Konten so einstellen, dass das neue Schlüsselpaar verwendet wird.
expiry-keys-expire-soon =
    In weniger als { $days } Tagen laufen die folgenden Schlüssel ab: { $desc }
    Es wird empfohlen, dass Sie neue Schlüsselpaare erzeugen und die entsprechenden E-Mail-Konten so einstellen, dass die neuen Schlüsselpaare verwendet werden.
expiry-key-missing-owner-trust =
    Ihrem geheimen Schlüssel { $desc } wird nicht vertraut.
    Es wird empfohlen, in den Schlüsseleigenschaften die Einstellung "Sie vertrauen Zertifizierungen" auf "absolut" setzen.
expiry-keys-missing-owner-trust =
    Ihren folgenden geheimen Schlüsseln wird nicht vertraut.
    { $desc }.
    Es wird empfohlen, in den Schlüsseleigenschaften die Einstellung "Sie vertrauen Zertifizierungen" auf "absolut" setzen.
expiry-open-key-manager = Verwaltung von OpenPGP-Schlüsseln öffnen
expiry-open-key-properties = Schlüsseleigenschaften öffnen

# Strings filters.jsm
filter-folder-required = Sie müssen einen Zielordner wählen.
filter-decrypt-move-warn-experimental =
    Warnung: Die Filteraktion "Dauerhaft entschlüsseln" kann zu zerstörten Nachrichten führen.
    Es wird eindringlich empfohlen, den Filter "Entschlüsselte Kopie erstellen" zu verwenden, die Einstellung zu testen und erst bei Erfolg die Einstellung "Dauerhaft entschlüsseln" zu verwenden.
filter-term-pgpencrypted-label = Mit OpenPGP verschlüsselt
filter-key-required = Sie müssen einen Empfängerschlüssel auswählen.
filter-key-not-found = Kein Schlüssel für Verschlüsselung von '{ $desc }' gefunden.
filter-warn-key-not-secret =
    Warnung: Die Filteraktion "Mit Schlüssel verschlüsseln" ersetzt die Empfänger.
    Falls Sie nicht über den geheimen Schlüssel für '{ $desc }' verfügen, werden Sie die E-Mails nicht mehr lesen können.

# Strings filtersWrapper.jsm
filter-decrypt-move-label = Dauerhaft entschlüsseln (OpenPGP)
filter-decrypt-copy-label = Entschlüsselte Kopie erstellen (OpenPGP)
filter-encrypt-label = Mit Schlüssel verschlüsseln (OpenPGP)

# Strings in enigmailKeyImportInfo.js
import-info-title =
    .title = Schlüssel erfolgreich importiert
import-info-bits = Bit
import-info-created = Erstellt am
import-info-fpr = Fingerabdruck
import-info-details = Details anzeigen und Schlüsselakzeptanz verwalten
import-info-no-keys = Keine Schlüssel importiert

# Strings in enigmailKeyManager.js
import-from-clip = Sollen ein oder mehrere Schlüssel aus der Zwischenablage importiert werden?
import-from-url = Öffentlichen Schlüssel von Adresse herunterladen:
copy-to-clipbrd-failed = Ausgewählte(r) Schlüssel konnte(n) nicht in Zwischenablage kopiert werden.
copy-to-clipbrd-ok = Schlüssel in Zwischenablage kopiert
delete-secret-key =
    WARNUNG: Sie sind dabei, einen geheimen Schlüssel zu löschen!

    Falls Sie Ihren geheimen Schlüssel löschen, können Sie in Zukunft weder mit diesem Schlüssel verschlüsselte Nachrichten entschlüsseln noch den Schlüssel widerrufen.

    Soll sowohl der geheime UND der öffentliche Schlüssel
    '{ $userId }'
    gelöscht werden?
delete-mix =
    WARNUNG: Sie sind dabei, geheime Schlüssel zu löschen!
    Falls Sie Ihre geheimen Schlüssel löschen, können Sie in Zukunft weder mit diesen Schlüsseln verschlüsselte Nachrichten entschlüsseln noch die Schlüssel widerrufen.
    Sollen sowohl die geheimen UND die öffentlichen Schlüssel gelöscht werden?
delete-pub-key =
    Soll der öffentliche Schlüssel
    '{ $userId }'
    gelöscht werden?
delete-selected-pub-key = Sollen die öffentlichen Schlüssel gelöscht werden?
refresh-all-question = Es ist kein Schlüssel ausgewählt. Sollen alle Schlüssel neu geladen werden?
key-man-button-export-sec-key = &Geheime Schlüssel exportieren
key-man-button-export-pub-key = Nur öff&entliche Schlüssel exportieren
key-man-button-refresh-all = Alle Schlüssel &neu laden
key-man-loading-keys = Schlüssel werden geladen, bitte warten…
ascii-armor-file = ASCII-Armored-Dateien (*.asc)
no-key-selected = Es muss mindestens ein Schlüssel ausgewählt werden, um die gewählte Aktion ausführen zu können.
export-to-file = Öffentlichen Schlüssel in Datei exportieren
export-keypair-to-file = Geheimen und öffentlichen Schlüssel in Datei exportieren
export-secret-key = Soll der geheime Schlüssel in die gespeicherte OpenPGP-Datei eingefügt werden?
save-keys-ok = Schlüssel erfolgreich gespeichert
save-keys-failed = Beim Speichern der Schlüssel trat ein Fehler auf
default-pub-key-filename = exportierte-oeffentliche-schluessel
default-pub-sec-key-filename = sicherheitskopie-geheime-schluessel
refresh-key-warn = Warnung: Abhängig von der Anzahl der Schlüssel und der Verbindungsgeschwindigkeit kann das neu Laden aller Schlüssel einige Zeit in Anspruch nehmen.
preview-failed = Datei mit öffentlichem Schlüssel konnte nicht gelesen werden.
general-error = Fehler: { $reason }
dlg-button-delete = &Löschen

## Account settings export output

openpgp-export-public-success = <b>Öffentlicher Schlüssel erfolgreich exportiert</b>
openpgp-export-public-fail = <b>Ausgewählter öffentlicher Schlüssel konnte nicht exportiert werden</b>

openpgp-export-secret-success = <b>Geheimer Schlüssel erfolgreich exportiert</b>
openpgp-export-secret-fail = <b>Ausgewählter öffentlicher Schlüssel konnte nicht exportiert werden</b>

# Strings in keyObj.jsm
key-ring-pub-key-revoked = Der Schlüssel { $userId } (Schlüssel-ID { $keyId }) wurde widerrufen.
key-ring-pub-key-expired = Der Schlüssel { $userId } (Schlüssel-ID { $keyId }) ist abgelaufen.
key-ring-key-disabled = Der Schlüssel { $userId } (Schlüssel-ID { $keyId }) ist deaktiviert und kann daher nicht verwendet werden.
key-ring-key-invalid = Der Schlüssel { $userId } (Schlüssel-ID { $keyId }) ist nicht gültig. Bitte ziehen Sie seine korrekte Verifizierung in Betracht.
key-ring-key-not-trusted=Dem Schlüssel { $userId } (Schlüssel-ID { $keyId }) wird nicht ausreichend vertraut. Bitte setzen Sie die Vertrauensstufe für den Schlüssel auf "absolut", um ihn für digitale Unterschriften zu verwenden.
key-ring-no-secret-key = Sie haben nicht den geheimen Schlüssel für { $userId } (Schlüssel-ID { $keyId }) in Ihrem Schlüsselbund und können den Schlüssel daher nicht für eine digitale Unterschrift einsetzen.
key-ring-pub-key-not-for-signing = Der Schlüssel { $userId } (Schlüssel-ID { $keyId }) kann nicht für digitale Unterschriften verwendet werden.
key-ring-pub-key-not-for-encryption = Der Schlüssel { $userId } (Schlüssel-ID { $keyId }) kann nicht für Verschlüsselung verwendet werden.
key-ring-sign-sub-keys-revoked = Alle Unterschlüssel für digitale Unterschriften in { $userId } (Schlüssel-ID { $keyId }) wurden widerrufen.
key-ring-sign-sub-keys-expired = Alle Unterschlüssel für digitale Unterschriften in { $userId } (Schlüssel-ID { $keyId }) sind abgelaufen.
key-ring-sign-sub-keys-unusable = Alle Unterschlüssel für digitale Unterschriften in { $userId } (Schlüssel-ID { $keyId }) wurden widerrufen, sind abgelaufen oder wegen anderer Gründe nicht einsetzbar.
key-ring-enc-sub-keys-revoked = Alle Unterschlüssel für Verschlüsselung in { $userId } (Schlüssel-ID { $keyId }) wurden widerrufen.
key-ring-enc-sub-keys-expired = Alle Unterschlüssel für Verschlüsselung in { $userId } (Schlüssel-ID { $keyId }) sind abgelaufen.
key-ring-enc-sub-keys-unusable = Alle Unterschlüssel für Verschlüsselung in { $userId } (Schlüssel-ID { $keyId }) wurden widerrufen, sind abgelaufen oder wegen anderer Gründe nicht einsetzbar.

# Strings in gnupg-keylist.jsm
keyring-photo = Foto
user-att-photo = Benutzerattribut (JPEG-Attribut)

# Strings in key.jsm
already-revoked = Dieser Schlüssel wurde bereits widerrufen.

#   $identity (String) - the id and associated user identity of the key being revoked
revoke-key-question =
    Sie sind dabei, folgenden Schlüssel zu widerrufen:
    '{ $identity }'
    Sie werden mit diesem Schlüssel nicht mehr unterscheiben können, und sobald der Widerruf verteilt ist, werden andere nicht mehr mit diesem Schlüssel verschlüsseln können. Sie können mit dem Schlüssel aber weiterhin alte Nachrichten entschlüsseln.
    Wollen Sie fortfahren?

#   $keyId (String) - the id of the key being revoked
revoke-key-not-present =
    Sie verfügen über keinen Schlüssel (0x{ $keyId }), der zu diesem Widerrufszertifikat passt.
    Wenn Sie Ihren Schlüssel verloren haben, müssen Sie ihn (z.B. von einem Schlüsselserver) importieren, bevor Sie das Widerrufszertifikat anwenden können.

#   $keyId (String) - the id of the key being revoked
revoke-key-already-revoked = Der Schlüssel 0x{ $keyId } wurde bereits widerrufen.

key-man-button-revoke-key = Schlüssel &widerrufen

openpgp-key-revoke-success = Schlüssel erfolgreich widerrufen

after-revoke-info =
    Der Schlüssel wurde widerrufen.
    Teilen Sie den Schlüssel erneut per E-Mail oder durch Hochladen auf Schlüsselserver, damit andere Personen erfahren, dass Sie den Schlüssel widerrufen haben.
    Sobald die Software der anderen Personen die Information über den Widerruf Ihres Schlüssels erhält, wird sie diesen nicht mehr verwenden.
    Falls Sie einen neuen Schlüssel für dieselbe E-Mail-Adresse verwenden und diesen an Ihre E-Mails anhängen, ist die Information über den Widerruf Ihes alten Zertifikats automatisch enthalten.

# Strings in keyRing.jsm & decryption.jsm
key-man-button-import = I&mportieren

delete-key-title = OpenPGP-Schlüssel löschen

delete-external-key-title = Externen GnuPG-Schlüssel entfernen

delete-external-key-description = Soll diese externe GnuPG-Schlüssel-ID widerrufen werden?

key-in-use-title = OpenPGP-Schlüssel wird derzeit verwendet

delete-key-in-use-description = Fortfahren nicht möglich! Der zum Löschen ausgewählte Schlüssel wird derzeit von dieser Identität verwendet. Wählen Sie einen anderen oder keinen Schlüssel und versuchen Sie es erneut.

revoke-key-in-use-description = Fortfahren nicht möglich! Der für den Widerruf ausgewählte Schlüssel wird derzeit von dieser Identität verwendet. Wählen Sie einen anderen oder keinen Schlüssel und versuchen Sie es erneut.

# Strings used in errorHandling.jsm
key-error-key-spec-not-found = Die E-Mail-Adresse '{ $keySpec }' passt zu keinem der Schlüssel in Ihrem Schlüsselbund.
key-error-key-id-not-found = Die konfigurierte Schlüssel-ID '{ $keySpec }' wurde nicht in Ihrem Schlüsselbund gefunden.
key-error-not-accepted-as-personal = Sie haben nicht bestätigt, dass der Schlüssel mit der ID '{ $keySpec }' Ihr persönlicher Schlüssel ist.

# Strings used in enigmailKeyManager.js & windows.jsm
need-online = Die gewählte Funktion ist nicht im Offline-Modus verfügbar. Bitte gehen Sie online und versuchen Sie es erneut.

# Strings used in keyRing.jsm & keyLookupHelper.jsm
no-key-found = Leider konnte kein passender Schlüssel zu den angegebenen Suchkriterien gefunden werden.

# Strings used in keyRing.jsm & GnuPGCryptoAPI.jsm
fail-key-extract = Fehler - Schlüsselextraktion fehlgeschlagen

# Strings used in keyRing.jsm
fail-cancel = Fehler - Schlüsselempfang durch Benutzer abgebrochen
not-first-block = Fehler - Erster OpenPGP-Block ist kein öffentlicher Schlüsselblock
import-key-confirm = In der Nachricht enthaltene(n) öffentliche(n) Schlüssel importieren?
fail-key-import = Fehler - Schlüssel konnte nicht importiert werden
file-write-failed = Fehler beim Schreiben der Datei { $output }
no-pgp-block = Fehler - Keinen gültigen armored-OpenPGP Datenblock gefunden
confirm-permissive-import = Fehler beim Import. Der zu importierende Schlüssel könnte beschädigt sein oder unbekannte Attribute verwenden. Sollen die korrekten Teile des Schlüssels importiert werden? Dies kann zum Import unvollständiger oder unbrauchbarer Schlüssel führen.

# Strings used in trust.jsm
key-valid-unknown = unbekannt
key-valid-invalid = ungültig
key-valid-disabled = deaktiviert
key-valid-revoked = widerrufen
key-valid-expired = abgelaufen
key-trust-untrusted = nicht vertraut
key-trust-marginal = marginal
key-trust-full = vertraut
key-trust-ultimate = absolut
key-trust-group = (Gruppe)

# Strings used in commonWorkflows.js
import-key-file = OpenPGP-Schlüsseldatei importieren
import-rev-file = OpenPGP-Widerrufsdatei importieren
gnupg-file = GnuPG-Dateien
import-keys-failed=Fehler beim Import der Schlüssel
passphrase-prompt = Bitte geben Sie das Passwort für den folgenden Schlüssel ein: { $key }
file-to-big-to-import = Die Datei ist zu groß. Bitte importieren Sie nicht viele Schlüssel auf einmal.

# Strings used in enigmailKeygen.js
save-revoke-cert-as = Widerrufszertifikat erzeugen und speichern
revoke-cert-ok = Das Widerrufszertifikat wurde erfolgreich erzeugt. Mit ihm können Sie Ihren öffentlichen Schlüssel widerrufen, z.B. falls Sie den geheimen Schlüssel verlieren.
revoke-cert-failed = Das Widerrufszertifikat konnte nicht erzeugt werden.
gen-going = Schlüsselerzeugung wird durchgeführt.
keygen-missing-user-name = Für das ausgewählte Konto bzw. die ausgewählte Identität ist kein Name festgelegt. Bitte geben Sie in den Konten-Einstellungen einen Wert in das Feld "Ihr Name" ein.
expiry-too-short = Der Schlüssel muss mindestens einen Tag gültig sein.
expiry-too-long = Es kann kein Schlüssel mit mehr als 100 Jahren Gültigkeit erzeugt werden.
key-confirm = Geheimen und öffentlichen Schlüssel für "{ $id }" erzeugen?
key-man-button-generate-key = Schlüssel &erzeugen
key-abort = Schlüsselerzeugung abbrechen?
key-man-button-generate-key-abort = Schlüsselerzeugung a&bbrechen
key-man-button-generate-key-continue = Schlüsselerzeugung f&ortsetzen

# Strings used in enigmailMessengerOverlay.js
failed-decrypt = Fehler bei der Entschlüsselung
fix-broken-exchange-msg-failed = Nachricht konnte nicht repariert werden.
attachment-no-match-from-signature = Konnte keine Verbindung von Datei mit digitaler Unterschrift "{ $attachment }" mit einem Anhang finden
attachment-no-match-to-signature = Konnte keine Verbindung von Anhang "{ $attachment }" mit Datei mit digitaler Unterschrift finden
signature-verified-ok = Die digitale Unterschrift für den Anhang { $attachment } wurde erfolgreich bestätigt.
signature-verify-failed = Die digitale Unterschrift für den Anhang { $attachment } konnte nicht bestätigt werden.
decrypt-ok-no-sig =
    Warnung
    Entschlüsselung verlief erfolgreich, aber die digitale Unterschrift konnte nicht erfolgreich bestätigt werden.
msg-ovl-button-cont-anyway = Trotzdem f&ortfahren
enig-content-note = *Anhänge dieser Nachricht wurden weder digital unterschrieben noch verschlüsselt.*

# Strings used in enigmailMsgComposeOverlay.js
msg-compose-button-send = Nachricht &senden
msg-compose-details-button-label = Details…
msg-compose-details-button-access-key = D
send-aborted = Senden wurde abgebrochen.
key-not-trusted = Nicht genügend Vertrauen in Schlüssel "{ $key }"
key-not-found = Schlüssel "{ $key }" nicht gefunden.
key-revoked = Schlüssel "{ $key }" wurde widerrufen.
key-expired = Schlüssel "{ $key }" ist abgelaufen.
msg-compose-internal-error = Es trat ein interner Fehler auf.
keys-to-export = Einzufügende OpenPGP-Schlüssel auswählen
msg-compose-partially-encrypted-inlinePGP =
    Sie antworten auf eine Nachricht, welche sowohl verschlüsselte als auch unverschlüsselte Teile enthält. Falls der Absender einige Teile nicht entschlüsseln konnte, so erfährt der Absender durch Sie gegebenenfalls unbeabsichtigt den Inhalt dieser verschlüsselten Nachrichtenteile.
    Entfernen Sie den gesamten zitierten Text in dieser Antwort an den Absender, um den Inhalt der verschlüsselten Nachrichtenteile weiterhin geheim zu halten.
msg-compose-cannot-save-draft = Beim Speichern des Entwurfs trat ein Fehler auf.
msg-compose-partially-encrypted-short = Weitergabe bislang verschlüsselter Nachrichteninformationen - teilweise verschlüsselte E-Mail.
quoted-printable-warn =
    Die Kodierung "quoted-printable" ist für zu sendende Nachrichten aktiv. Dies kann zu fehlerhafter Entschlüsselung oder Bestätigung Ihrer Unterschrift führen.
    Soll die Kodierung "quoted-printable" für zu sendende Nachrichten jetzt deaktiviert werden?
minimal-line-wrapping =
    Sie haben die Zeilenbreite auf { $width } Zeichen festgelegt. Für korrektes Verschlüsseln und Unterschreiben muss die Zeilenbreite mindestens 68 Zeichen weit sein.
    Soll die Zeilenbreite jetzt auf 68 Zeichen geändert werden?
sending-hidden-rcpt = Empfänger in Blindkopie (BCC) werden beim Senden einer verschlüsselten Nachricht nicht unterstützt. Entfernen Sie die Empfänger in Blindkopie oder verschieben Sie diese in Kopie (CC), um diese Nachricht verschlüsselt zu senden.
sending-news =
    Senden verschlüsselter Nachricht abgebrochen.
    Die Nachricht kann nicht verschlüsselt werden, da einige Empfänger Newsgruppen sind. Bitte senden Sie die Nachricht erneut, aber ohne Verschlüsselung.
send-to-news-warning =
    Warnung: Sie sind dabei, eine verschlüsselte Nachricht an eine Newsgruppe zu senden.
    Davon wird abgeraten, da es nur sinnvoll ist, falls alle Mitglieder der Newsgruppe die Nachricht entschlüsseln können, z.B. wenn die Nachricht mit den Schlüsseln aller Gruppenmitglieder verschlüsselt ist. Senden Sie diese Nachricht nur, wenn Sie wirklich wissen, was Sie tun.
    Fortfahren?
save-attachment-header = Entschlüsselten Anhang speichern
no-temp-dir =
    Kein temporäres Verzeichnis für Schreibvorgänge erkannt.
    Bitte setzen Sie die TEMP-Umgebungsvariable.
possibly-pgp-mime = Eventuell mit PGP/MIME verschlüsselte oder unterschriebene Nachricht; verwenden Sie die Funktion 'Entschlüsseln/Verifizieren' zum Verifizieren
cannot-send-sig-because-no-own-key = Die Nachricht kann nicht digital unterschrieben werden, da Sie noch keine Ende-zu-Ende-Verschlüsselung für <{ $key }> eingerichtet haben.
cannot-send-enc-because-no-own-key = Die Nachricht kann nicht verschlüsselt gesendet werden, da Sie noch keine Ende-zu-Ende-Verschlüsselung für <{ $key }> eingerichtet haben.

# Strings used in decryption.jsm
do-import-multiple =
    Sollen die folgenden Schlüssel importiert werden?
    { $key }
do-import-one = Soll der folgende Schlüssel importiert werden? { $name } ({ $id })
cant-import = Beim Importieren eines öffentlichen Schlüssels trat ein Fehler auf.
unverified-reply = Der eingerückte Teil der Nachricht (die Antwort) wurde wahrscheinlich verändert.
key-in-message-body = Im Nachrichteninhalt wurde ein Schlüssel erkannt. Klicken Sie aus "Schlüssel importieren", um den Schlüssel zu importieren.
sig-mismatch = Fehler - digitale Unterschrift stimmt nicht überein
invalid-email = Fehler - ungültige E-Mail-Adresse(n)
attachment-pgp-key =
    Bei dem zu öffnenden Anhang "{ $name }" scheint es sich um eine OpenPGP-Schlüsseldatei zu handeln.
    Wählen Sie "Importieren" für den Import der enthaltenen Schlüssel oder "Anzeigen", um die Datei in einem Browser-Fenster zu öffnen.
dlg-button-view = &Anzeigen

# Strings used in enigmailMsgHdrViewOverlay.js
decrypted-msg-with-format-error = Entschlüsselte Nachricht (beschädigtes PGP-E-Mail-Format wiederhergestellt, welches vermutlich durch einen alten Exchange-Server verursacht wurde, weshalb der Inhalt eventuell nicht vollständig lesbar ist)

# Strings used in encryption.jsm
not-required = Fehler - keine Verschlüsselung benötigt

# Strings used in windows.jsm
no-photo-available = Kein Foto verfügbar
error-photo-path-not-readable = Dateipfad zum Foto "{ $photo }" kann nicht gelesen werden
debug-log-title = OpenPGP-Debug-Protokoll

# Strings used in dialog.jsm
repeat-prefix = Dieser Alarm wird { $count }
repeat-suffix-singular = Mal wiederholt.
repeat-suffix-plural = Mal wiederholt.
no-repeat = Dieser Alarm wird in Zukunft nicht mehr angezeigt.
dlg-keep-setting = Antwort merken und in Zukunft nicht mehr nachfragen
dlg-button-ok = &OK
dlg-button-close = S&chließen
dlg-button-cancel = A&bbrechen
dlg-no-prompt = Dieses Dialogfenster nicht mehr anzeigen
enig-prompt = OpenPGP-Eingabeaufforderung
enig-confirm = OpenPGP-Bestätigung
enig-alert = OpenPGP-Alarm
enig-info = OpenPGP-Information

# Strings used in persistentCrypto.jsm
dlg-button-retry = &Wiederholen
dlg-button-skip = Ü&berspringen

# Strings used in enigmailCommon.js
enig-error = OpenPGP - Fehler
enig-alert-title =
    .title = OpenPGP - Alarm
