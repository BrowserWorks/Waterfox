# This Source Code Form is subject to the terms of the Mozilla Public
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
certmgr-servers = Sie haben Zertifikate gespeichert, die diese Server identifizieren:
certmgr-server = Diese Einträge identifizieren Ausnahmeregeln für Fehler von Serverzertifikaten
certmgr-ca = Sie haben Zertifikate gespeichert, die diese Zertifizierungsstellen identifizieren:
certmgr-detail-general-tab-title =
    .label = Allgemein
    .accesskey = A
certmgr-detail-pretty-print-tab-title =
    .label = Details
    .accesskey = D
certmgr-pending-label =
    .value = Das Zertifikat wird derzeit verifiziert…
certmgr-subject-label = Ausgestellt für
certmgr-issuer-label = Ausgestellt von
certmgr-period-of-validity = Gültigkeitsdauer
certmgr-fingerprints = Fingerabdrücke
certmgr-cert-detail =
    .title = Zertifikats-Detail
    .buttonlabelaccept = Schließen
    .buttonaccesskeyaccept = c
certmgr-cert-detail-commonname = Allgemeiner Name (CN)
certmgr-cert-detail-org = Organisation (O)
certmgr-cert-detail-orgunit = Organisationseinheit (OU)
certmgr-cert-detail-serial-number = Seriennummer
certmgr-cert-detail-sha-256-fingerprint = SHA-256-Fingerabdruck
certmgr-cert-detail-sha-1-fingerprint = SHA1-Fingerabdruck
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
certmgr-begins-on = Beginnt mit
certmgr-begins-label =
    .label = Beginnt mit
certmgr-expires-on = Gültig bis
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
certmgr-details =
    .value = Zertifikats-Layout
    .accesskey = Z
certmgr-fields =
    .value = Feld-Wert
    .accesskey = F
certmgr-hierarchy =
    .value = Zertifikatshierarchie
    .accesskey = h
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
delete-ssl-cert-title =
    .title = Server-Zertifikat-Ausnahmeregeln löschen
delete-ssl-cert-confirm = Sollen diese Server-Ausnahmeregeln wirklich gelöscht werden?
delete-ssl-cert-impact = Wenn Sie eine Server-Ausnahmeregel löschen, werden die normalen Sicherheitsüberprüfungen für diesen Server wiederhergestellt und er muss ein gültiges Zertifikat vorweisen.
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

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Zertifikat-Ansicht: "{ $certName }"
not-present =
    .value = <kein Teil des Zertifikats>
# Cert verification
cert-verified = Dieses Zertifikat wurde für die folgenden Verwendungen verifiziert:
# Add usage
verify-ssl-client =
    .value = SSL-Client-Zertifikat
verify-ssl-server =
    .value = SSL-Server-Zertifikat
verify-ssl-ca =
    .value = SSL-Zertifizierungsstelle
verify-email-signer =
    .value = E-Mail-Unterzeichner-Zertifikat
verify-email-recip =
    .value = E-Mail-Empfänger-Zertifikat
# Cert verification
cert-not-verified-cert-revoked = Dieses Zertifikat konnte nicht verifiziert werden, da es widerrufen wurde.
cert-not-verified-cert-expired = Dieses Zertifikat konnte nicht verifiziert werden, da es abgelaufen ist.
cert-not-verified-cert-not-trusted = Dieses Zertifikat konnte nicht verifiziert werden, da ihm nicht vertraut wird.
cert-not-verified-issuer-not-trusted = Dieses Zertifikat konnte nicht verifiziert werden, da dem Aussteller nicht vertraut wird.
cert-not-verified-issuer-unknown = Dieses Zertifikat konnte nicht verifiziert werden, da der Aussteller unbekannt ist.
cert-not-verified-ca-invalid = Dieses Zertifikat konnte nicht verifiziert werden, da das CA-Zertifikat ungültig ist.
cert-not-verified_algorithm-disabled = Das Zertifikat konnte nicht verifiziert werden, weil es mit einem Signatur-Algorithmus signiert wurde, der deaktiviert wurde, weil er nicht sicher ist.
cert-not-verified-unknown = Dieses Zertifikat konnte aus unbekannten Gründen nicht verifiziert werden.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Kein Client-Zertifikat senden
# Used when no cert is stored for an override
no-cert-stored-for-override = (Nicht gespeichert)

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
