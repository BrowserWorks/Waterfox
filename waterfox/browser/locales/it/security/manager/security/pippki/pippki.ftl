# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Indicatore qualità password

## Change Password dialog

change-device-password-window =
    .title = Cambio password
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispositivo di sicurezza: { $tokenName }
change-password-old = Password attuale:
change-password-new = Nuova password:
change-password-reenter = Nuova password (conferma):
pippki-failed-pw-change = Impossibile cambiare la password.
pippki-incorrect-pw = Non è stata inserita correttamente la password attuale. Ritentare.
pippki-pw-change-ok = La password è stata cambiata correttamente.
pippki-pw-empty-warning = Le password salvate e le chiavi private non verranno protette.
pippki-pw-erased-ok = La password è stata eliminata. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Attenzione: si è deciso di non utilizzare una password. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Si è in modalità FIPS. FIPS richiede che la password principale sia impostata.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Rimozione password principale
    .style = min-width: 40em
reset-password-button-label =
    .label = Reimposta
reset-primary-password-text = La rimozione della password principale comporterà la perdita di tutte le password di posta e dei siti web, dei dati dei moduli, dei certificati personali e delle chiavi private memorizzate. Rimuovere la password principale?
pippki-reset-password-confirmation-title = Rimozione password principale
pippki-reset-password-confirmation-message = La password è stata eliminata.

## Downloading cert dialog

download-cert-window2 =
    .title = Download certificato
    .style = min-width: 46em
download-cert-message = È stato richiesto di dare fiducia a una nuova autorità di certificazione (CA).
download-cert-trust-ssl =
    .label = Dai fiducia a questa CA per l’identificazione di siti web.
download-cert-trust-email =
    .label = Dai fiducia a questa CA per l’identificazione di utenti di posta.
download-cert-message-desc = Prima di dare fiducia a questa CA per un qualsiasi scopo, è consigliabile esaminare il suo certificato, le politiche e procedure da essa adottate (se disponibili).
download-cert-view-cert =
    .label = Visualizza
download-cert-view-text = Esamina certificato CA

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Richiesta identificazione utente
client-auth-send-no-certificate =
  .label = Non inviare un certificato
client-auth-site-description = Questo sito richiede di identificarti tramite un certificato:
client-auth-site-identification = “{ $hostname }” richiede di identificarti tramite un certificato:
client-auth-choose-cert = Scegliere un certificato da presentare come identificativo:
client-auth-cert-details = Dettagli del certificato selezionato:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Rilasciato a: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Numero seriale: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Valido dal { $notBefore } al { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Ambiti di utilizzo della chiave: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = Indirizzi email: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Rilasciato da: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Archiviato in: { $storedOn }
client-auth-cert-remember-box =
    .label = Ricorda questa scelta

## Set password (p12) dialog

set-password-window =
    .title = Scelta della password per il backup del certificato
set-password-message = Questa password serve a proteggere la copia di backup del certificato che si sta per creare. È necessario impostare una password per procedere con l’operazione.
set-password-backup-pw =
    .value = Password per il backup del certificato:
set-password-repeat-backup-pw =
    .value = Password per il backup del certificato (conferma):
set-password-reminder = Importante: se si dovesse scordare la password della copia di backup, non sarà possibile recuperarne successivamente il contenuto. Si consiglia di conservare la password in un luogo sicuro.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Effettuare l’autenticazione utilizzando il token “{ $tokenName }”. La modalità precisa dipende dal token, ad esempio potrebbe essere necessario utilizzare un lettore di impronte digitali o inserire un codice con un tastierino numerico.

