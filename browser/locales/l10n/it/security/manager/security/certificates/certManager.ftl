# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Gestione certificati

certmgr-tab-mine =
    .label = Certificati personali

certmgr-tab-remembered =
    .label = Decisioni di autenticazione

certmgr-tab-people =
    .label = Persone

certmgr-tab-servers =
    .label = Server

certmgr-tab-ca =
    .label = Autorità

certmgr-mine = Sono presenti certificati rilasciati dalle seguenti organizzazioni che attestano la propria identità
certmgr-remembered = Questi certificati sono utilizzati per attestare la propria identità su siti web
certmgr-people = Sono presenti certificati su file che identificano le seguenti persone
certmgr-servers = Sono presenti certificati su file che identificano i seguenti server
certmgr-server = Queste voci rappresentano eccezioni per errori nei certificati server
certmgr-ca = Sono presenti certificati su file che identificano le seguenti autorità di certificazione

certmgr-detail-general-tab-title =
    .label = Generale
    .accesskey = G

certmgr-detail-pretty-print-tab-title =
    .label = Dettagli
    .accesskey = D

certmgr-pending-label =
    .value = Verifica del certificato in corso…

certmgr-subject-label = Rilasciato a

certmgr-issuer-label = Rilasciato da

certmgr-period-of-validity = Periodo di validità

certmgr-fingerprints = Impronte digitali

certmgr-cert-detail =
    .title = Dettagli certificato
    .buttonlabelaccept = Chiudi
    .buttonaccesskeyaccept = C

certmgr-cert-detail-commonname = Nome comune (CN)

certmgr-cert-detail-org = Organizzazione (O)

certmgr-cert-detail-orgunit = Unità organizzativa (OU)

certmgr-cert-detail-serial-number = Numero seriale

certmgr-cert-detail-sha-256-fingerprint = Impronta digitale SHA-256

certmgr-cert-detail-sha-1-fingerprint = Impronta digitale SHA1

certmgr-edit-ca-cert =
    .title = Modifica impostazioni fiducia certificato CA
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Modifica impostazioni attendibilità:

certmgr-edit-cert-trust-ssl =
    .label = Questo certificato può identificare siti web.

certmgr-edit-cert-trust-email =
    .label = Questo certificato può identificare utenti di posta.

certmgr-delete-cert =
    .title = Eliminazione certificato
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Host

certmgr-cert-name =
    .label = Nome certificato

certmgr-cert-server =
    .label = Server

certmgr-override-lifetime =
    .label = Durata

certmgr-token-name =
    .label = Dispositivo di sicurezza

certmgr-begins-on = Inizia il

certmgr-begins-label =
    .label = Inizia il

certmgr-expires-on = Termina il

certmgr-expires-label =
    .label = Termina il

certmgr-email =
    .label = Indirizzo email

certmgr-serial =
    .label = Numero seriale

certmgr-view =
    .label = Visualizza…
    .accesskey = V

certmgr-edit =
    .label = Modifica attendibilità…
    .accesskey = M

certmgr-export =
    .label = Esporta
    .accesskey = o

certmgr-delete =
    .label = Elimina…
    .accesskey = E

certmgr-delete-builtin =
    .label = Elimina o considera inattendibile…
    .accesskey = E

certmgr-backup =
    .label = Salva…
    .accesskey = S

certmgr-backup-all =
    .label = Salva tutto…
    .accesskey = t

certmgr-restore =
    .label = Importa…
    .accesskey = r

certmgr-details =
    .value = Campi certificato
    .accesskey = f

certmgr-fields =
    .value = Valore campo
    .accesskey = V

certmgr-hierarchy =
    .value = Gerarchia certificato
    .accesskey = t

certmgr-add-exception =
    .label = Aggiungi eccezione…
    .accesskey = z

exception-mgr =
    .title = Aggiungi eccezione di sicurezza

exception-mgr-extra-button =
    .label = Conferma eccezione di sicurezza
    .accesskey = C

exception-mgr-supplemental-warning = Banche, negozi e altri siti pubblici affidabili non chiederanno di fare questa operazione.

exception-mgr-cert-location-url =
    .value = Indirizzo:

exception-mgr-cert-location-download =
    .label = Acquisisci certificato
    .accesskey = q

exception-mgr-cert-status-view-cert =
    .label = Visualizza…
    .accesskey = V

exception-mgr-permanent =
    .label = Salva eccezione in modo permanente
    .accesskey = S

pk11-bad-password = La password inserita non era corretta.
pkcs12-decode-err = Impossibile decodificare il file. Potrebbe non essere nel formato PKCS #12, essere stato danneggiato, o la password inserita non era corretta.
pkcs12-unknown-err-restore = Ripristino del file PKCS #12 non riuscito per motivi sconosciuti.
pkcs12-unknown-err-backup = Copia di backup del file PKCS #12 non riuscita per motivi sconosciuti.
pkcs12-unknown-err = Operazione PKCS #12 non riuscita per motivi sconosciuti.
pkcs12-info-no-smartcard-backup = Non è possibile salvare una copia locale da dispositivi di sicurezza hardware quali, ad esempio, le smart card.
pkcs12-dup-data = Il certificato e la chiave privata sono già presenti nel dispositivo di sicurezza.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nome del file da archiviare
file-browse-pkcs12-spec = File PKCS12
choose-p12-restore-file-dialog = File certificato da importare

## Import certificate(s) file dialog

file-browse-certificate-spec = File certificato
import-ca-certs-prompt = Selezionare il file contenente i certificati della CA da importare
import-email-cert-prompt = Selezionare il file contenente il certificato del destinatario di posta da importare

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Il certificato “{ $certName }” rappresenta un’autorità di certificazione.

## For Deleting Certificates

delete-user-cert-title =
    .title = Eliminazione certificato personale
delete-user-cert-confirm = Eliminare questi certificati?
delete-user-cert-impact = Se si elimina uno dei propri certificati, non sarà più possibile identificarsi tramite questo certificato.


delete-ssl-cert-title =
    .title = Elimina eccezioni certificato server
delete-ssl-cert-confirm = Eliminare queste eccezioni?
delete-ssl-cert-impact = Eliminando un’eccezione per un server si ripristinano i controlli predefiniti di sicurezza  e per questo sito verrà richiesto un certificato valido.

delete-ssl-override-title =
    .title = Elimina eccezione certificato server
delete-ssl-override-confirm = Eliminare l’eccezione per questo server?
delete-ssl-override-impact = Eliminando un’eccezione per un server si ripristinano i controlli predefiniti di sicurezza  e per questo sito verrà richiesto un certificato valido.

delete-ca-cert-title =
    .title = Elimina o considera inattendibili certificati CA
delete-ca-cert-confirm = È stata richiesta l’eliminazione di questi certificati appartenenti ad autorità di certificazione (CA). I certificati predefiniti verranno considerati non più attendibili, ottenendo lo stesso risultato di una rimozione completa. Proseguire con l’operazione?
delete-ca-cert-impact = Se si elimina o considera non attendibile il certificato di un’autorità di certificazione (CA), qualsiasi certificato emesso da questa CA verrà considerato inattendibile.


delete-email-cert-title =
    .title = Eliminazione certificati email
delete-email-cert-confirm = Eliminare i certificati email di queste persone?
delete-email-cert-impact = Eliminando il certificato email di una persona, non sarà più possibile inviare email crittate a questa persona.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certificato con numero seriale: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Visualizzazione certificato: “{ $certName }”

not-present =
    .value = <non incluso nel certificato>

# Cert verification
cert-verified = Questo certificato è stato verificato per i seguenti utilizzi:

# Add usage
verify-ssl-client =
    .value = Certificato client SSL

verify-ssl-server =
    .value = Certificato server SSL

verify-ssl-ca =
    .value = Autorità di certificazione SSL

verify-email-signer =
    .value = Certificato firmatario email

verify-email-recip =
    .value = Certificato email destinatario

# Cert verification
cert-not-verified-cert-revoked = Non è possibile verificare questo certificato in quanto revocato.
cert-not-verified-cert-expired = Non è possibile verificare questo certificato in quanto scaduto.
cert-not-verified-cert-not-trusted = Non è possibile verificare questo certificato in quanto non ha ricevuto fiducia da terzi.
cert-not-verified-issuer-not-trusted = Non è possibile verificare questo certificato in quanto non si è dato fiducia a chi lo ha rilasciato.
cert-not-verified-issuer-unknown = Non è possibile verificare questo certificato in quanto non è individuabile chi lo ha rilasciato.
cert-not-verified-ca-invalid = Non è possibile verificare questo certificato in quanto la CA del certificato non è valida.
cert-not-verified_algorithm-disabled = Impossibile verificare questo certificato in quanto è stato firmato con un algoritmo di firma disattivato perché non sicuro.
cert-not-verified-unknown = Non è possibile verificare questo certificato per motivi sconosciuti.

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Non inviare alcun certificato client

# Used when no cert is stored for an override
no-cert-stored-for-override = (non salvato)

## Used to show whether an override is temporary or permanent

permanent-override = Permanente
temporary-override = Temporaneo

## Add Security Exception dialog

add-exception-branded-warning = Si sta per modificare il modo in cui { -brand-short-name } identifica questo sito.
add-exception-invalid-header = Il sito ha cercato di identificarsi fornendo informazioni non valide.
add-exception-domain-mismatch-short = Sito errato
add-exception-domain-mismatch-long = Il certificato appartiene a un altro sito, potrebbe trattarsi di un tentativo di sostituirsi al sito originale.
add-exception-expired-short = Informazioni obsolete
add-exception-expired-long = Il certificato non è più valido. È possibile che sia stato rubato o perso, e potrebbe essere utilizzato nel tentativo di sostituirsi al sito originale.
add-exception-unverified-or-bad-signature-short = Identità sconosciuta
add-exception-unverified-or-bad-signature-long = Il certificato non è affidabile in quanto non è possibile verificare che sia stato emesso da un’autorità riconosciuta utilizzando una firma sicura.
add-exception-valid-short = Certificato valido
add-exception-valid-long = Questo sito ha fornito un certificato valido e verificato. Non è necessario aggiungere un’eccezione.
add-exception-checking-short = Controllo informazioni
add-exception-checking-long = Tentativo di identificazione del sito…
add-exception-no-cert-short = Nessuna informazione disponibile
add-exception-no-cert-long = Impossibile ottenere lo stato dell’identificazione per questo sito.

## Certificate export "Save as" and error dialogs

save-cert-as = Salva certificato su file
cert-format-base64 = Certificato X.509 (PEM)
cert-format-base64-chain = Catena di certificati X.509 (PEM)
cert-format-der = Certificato X.509 (DER)
cert-format-pkcs7 = Certificato X.509 (PKCS#7)
cert-format-pkcs7-chain = Catena di certificati X.509 (PKCS#7)
write-file-failure = Errore nel file
