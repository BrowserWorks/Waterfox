# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Zertifikatverwaltung

certmgr-tab-mine =
    .label = Ihre Zertifikate

certmgr-tab-remembered =
    .label = Authentifizierungs-Entscheidungen

certmgr-tab-people =
    .label = Personen

certmgr-tab-servers =
    .label = Server

certmgr-tab-ca =
    .label = Zertifizierungsstellen

certmgr-mine = Sie haben Zertifikate dieser Organisationen, die Sie identifizieren:
certmgr-remembered = Folgende Zertifikate werden verwendet, um Sie gegenüber Websites zu identifizieren:
certmgr-people = Sie haben Zertifikate gespeichert, die diese Personen identifizieren:
certmgr-server = Diese Einträge identifizieren Ausnahmeregeln für Fehler von Serverzertifikaten
certmgr-ca = Sie haben Zertifikate gespeichert, die diese Zertifizierungsstellen identifizieren:

certmgr-edit-ca-cert =
    .title = CA-Zertifikat-Vertrauenseinstellungen bearbeiten
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Vertrauenseinstellungen bearbeiten

certmgr-edit-cert-trust-ssl =
    .label = Dieses Zertifikat kann Websites identifizieren.

certmgr-edit-cert-trust-email =
    .label = Dieses Zertifikat kann Mail-Benutzer identifizieren.

certmgr-delete-cert =
    .title = Zertifikat löschen
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Host

certmgr-cert-name =
    .label = Zertifikatsname

certmgr-cert-server =
    .label = Server

certmgr-override-lifetime =
    .label = Lebenszeit

certmgr-token-name =
    .label = Kryptographie-Modul

certmgr-begins-label =
    .label = Beginnt mit

certmgr-expires-label =
    .label = Gültig bis

certmgr-email =
    .label = E-Mail-Adresse

certmgr-serial =
    .label = Seriennummer

certmgr-view =
    .label = Ansehen…
    .accesskey = A

certmgr-edit =
    .label = Vertrauen bearbeiten…
    .accesskey = b

certmgr-export =
    .label = Exportieren…
    .accesskey = x

certmgr-delete =
    .label = Löschen…
    .accesskey = L

certmgr-delete-builtin =
    .label = Löschen oder Vertrauen entziehen…
    .accesskey = n

certmgr-backup =
    .label = Sichern…
    .accesskey = S

certmgr-backup-all =
    .label = Alle sichern…
    .accesskey = A

certmgr-restore =
    .label = Importieren…
    .accesskey = I

certmgr-add-exception =
    .label = Ausnahme hinzufügen…
    .accesskey = u

exception-mgr =
    .title = Sicherheits-Ausnahmeregel hinzufügen

exception-mgr-extra-button =
    .label = Sicherheits-Ausnahmeregel bestätigen
    .accesskey = S

exception-mgr-supplemental-warning = Seriöse Banken, Geschäfte und andere öffentliche Seiten werden Sie nicht bitten, Derartiges zu tun.

exception-mgr-cert-location-url =
    .value = Adresse:

exception-mgr-cert-location-download =
    .label = Zertifikat herunterladen
    .accesskey = Z

exception-mgr-cert-status-view-cert =
    .label = Ansehen…
    .accesskey = A

exception-mgr-permanent =
    .label = Diese Ausnahme dauerhaft speichern
    .accesskey = n

pk11-bad-password = Das eingegebene Passwort war falsch.
pkcs12-decode-err = Die Datei konnte nicht dekodiert werden. Entweder ist sie nicht im PKCS#12-Format, wurde fehlerhaft übertragen, oder das Passwort, das Sie eingegeben haben, war falsch.
pkcs12-unknown-err-restore = Das Wiederherstellen der PKCS#12-Datei ist aus unbekannten Gründen fehlgeschlagen.
pkcs12-unknown-err-backup = Das Erstellen der PKCS#12-Backupdatei ist aus unbekannten Gründen fehlgeschlagen.
pkcs12-unknown-err = Die PKCS#12-Operation ist aus unbekannten Gründen fehlgeschlagen.
pkcs12-info-no-smartcard-backup = Es ist nicht möglich, Zertifikate von einem Hardware-Kryptographie-Modul wie einer Smart Card zu sichern.
pkcs12-dup-data = Zertifikat und Privater Schlüssel sind bereits auf dem Kryptographie-Modul vorhanden.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Dateiname für Backup
file-browse-pkcs12-spec = PKCS12-Dateien
choose-p12-restore-file-dialog = Zu importierende Zertifikat-Datei

## Import certificate(s) file dialog

file-browse-certificate-spec = Zertifikat-Dateien
import-ca-certs-prompt = Wählen Sie die Datei mit dem oder den zu importierenden CA-Zertifikat(en)
import-email-cert-prompt = Wählen Sie die Datei mit dem zu importierenden E-Mail-Zertifikat

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Das Zertifikat "{ $certName }" repräsentiert eine Zertifizierungsstelle.

## For Deleting Certificates

delete-user-cert-title =
    .title = Ihre Zertifikate löschen
delete-user-cert-confirm = Sollen diese Zertifikate wirklich gelöscht werden?
delete-user-cert-impact = Wenn Sie eines Ihrer eigenen Zertifikate löschen, können Sie es nicht mehr verwenden, um sich zu identifizieren.


delete-ssl-override-title =
    .title = Ausnahmeregel für Serverzertifikat löschen
delete-ssl-override-confirm = Soll diese Ausnahmeregel für Server wirklich gelöscht werden?
delete-ssl-override-impact = Wenn Sie eine Ausnahmeregel für Server löschen, werden die normalen Sicherheitsüberprüfungen für diesen Server wiederhergestellt und er muss ein gültiges Zertifikat vorweisen.

delete-ca-cert-title =
    .title = CA-Zertifikate löschen oder Vertrauen entziehen
delete-ca-cert-confirm = Sie haben um ein Löschen dieser CA-Zertifikate angefragt. Für eingebaute Zertifikate wird alles Vertrauen entzogen, was den gleichen Effekt hat. Sollen diese CA-Zertifikate wirklich gelöscht oder ihr Vertrauen entzogen werden?
delete-ca-cert-impact = Wenn Sie ein Zertifizierungsstellen(CA)-Zertifikat löschen oder sein Vertrauen entziehen, vertraut die Anwendung keinen Zertifikaten mehr, die von dieser CA ausgestellt wurden.


delete-email-cert-title =
    .title = E-Mail-Zertifikate löschen
delete-email-cert-confirm = Sollen die E-Mail-Zertifikate dieser Personen wirklich gelöscht werden?
delete-email-cert-impact = Wenn Sie das E-Mail-Zertifikat einer Person löschen, können Sie keine verschlüsselten E-Mails mehr an diese Person senden.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Zertifikat mit Seriennummer: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Kein Client-Zertifikat senden

# Used when no cert is stored for an override
no-cert-stored-for-override = (Nicht gespeichert)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (Nicht verfügbar)

## Used to show whether an override is temporary or permanent

permanent-override = Dauerhaft
temporary-override = Vorübergehend

## Add Security Exception dialog

add-exception-branded-warning = Hiermit übergehen Sie die Identifikation dieser Website durch { -brand-short-name }.
add-exception-invalid-header = Diese Website versucht sich mit ungültigen Informationen zu identifizieren.
add-exception-domain-mismatch-short = Falsche Website
add-exception-domain-mismatch-long = Das Zertifikat gehört zu einer anderen Website, was heißen könnte, dass jemand versucht, sich als diese Website auszugeben.
add-exception-expired-short = Veraltete Informationen
add-exception-expired-long = Das Zertifikat ist derzeit nicht gültig. Es könnte gestohlen oder verloren worden sein, und könnte von jemand verwendet werden, um sich als diese Website auszugeben.
add-exception-unverified-or-bad-signature-short = Unbekannte Identität
add-exception-unverified-or-bad-signature-long = Dem Zertifikat wird nicht vertraut, weil nicht verifiziert wurde, dass es von einer vertrauenswürdigen Autorität unter Verwendung einer sicheren Signatur herausgegeben wurde.
add-exception-valid-short = Gültiges Zertifikat
add-exception-valid-long = Diese Website gibt gültige, überprüfte Informationen an.  Es gibt keinen Grund, eine Ausnahmeregel hinzuzufügen.
add-exception-checking-short = Überprüfe Informationen
add-exception-checking-long = Identifikation der Website wird versucht…
add-exception-no-cert-short = Keine Informationen verfügbar
add-exception-no-cert-long = Der Identifikationsstatus für diese Website konnte nicht bezogen werden.

## Certificate export "Save as" and error dialogs

save-cert-as = Zertifikate in Datei speichern
cert-format-base64 = X.509-Zertifikat (PEM)
cert-format-base64-chain = X.509-Zertifikat inklusive Ausstellern (PEM)
cert-format-der = X.509-Zertifikat (DER)
cert-format-pkcs7 = X.509-Zertifikat (PKCS#7)
cert-format-pkcs7-chain = X.509-Zertifikat inklusive Ausstellern (PKCS#7)
write-file-failure = Dateifehler
