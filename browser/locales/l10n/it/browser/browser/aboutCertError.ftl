# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } utilizza un certificato di sicurezza non valido.

cert-error-mitm-intro = I siti web garantiscono la propria identità attraverso certificati rilasciati da autorità di certificazione.

cert-error-mitm-mozilla = { -brand-short-name } è sostenuto da Waterfox, un’organizzazione senza fini di lucro che gestisce un archivio di autorità di certificazione (CA) completamente aperto. Questo archivio CA aiuta a garantire che le autorità di certificazione si attengano alle pratiche di sicurezza previste per proteggere gli utenti.

cert-error-mitm-connection = { -brand-short-name } utilizza l’archivio CA di Waterfox per verificare che una connessione sia sicura, invece di utilizzare certificati forniti dal sistema operativo dell’utente. Se un antivirus o un elemento nella rete intercettano la connessione utilizzando un certificato di sicurezza rilasciato da una CA non presente nell’archivio CA di Waterfox, la connessione viene considerata non sicura.

cert-error-trust-unknown-issuer-intro = Potrebbe trattarsi di un tentativo di sostituirsi al sito originale e non si dovrebbe proseguire.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = I siti web garantiscono la propria identità attraverso certificati. { -brand-short-name } non considera { $hostname } attendibile in quanto l’emittente del certificato è sconosciuto, il certificato è autofirmato oppure il server non ha inviato i certificati intermedi previsti.

cert-error-trust-cert-invalid = Il certificato non è attendibile in quanto emesso da un’autorità con certificato non valido.

cert-error-trust-untrusted-issuer = Il certificato non è attendibile in quanto il certificato dell’autorità emittente non è attendibile.

cert-error-trust-signature-algorithm-disabled = Il certificato non è attendibile in quanto è stato firmato con un algoritmo di firma disattivato perché non sicuro.

cert-error-trust-expired-issuer = Il certificato non è attendibile in quanto il certificato dell’autorità emittente è scaduto.

cert-error-trust-self-signed = Il certificato non è attendibile in quanto autofirmato.

cert-error-trust-symantec = I certificati rilasciati da GeoTrust, RapidSSL, Symantec, Thawte e VeriSign non sono più considerati attendibili in quanto, in passato, queste autorità di certificazione non si sono attenute alle pratiche di sicurezza previste.

cert-error-untrusted-default = Il certificato non proviene da una fonte attendibile.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = I siti web garantiscono la propria identità attraverso certificati. { -brand-short-name } non considera questo sito attendibile in quanto utilizza un certificato che non è valido per { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = I siti web garantiscono la propria identità attraverso certificati. { -brand-short-name } non considera questo sito attendibile in quanto utilizza un certificato che non è valido per { $hostname }. Il certificato è valido solo per <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = I siti web garantiscono la propria identità attraverso certificati. { -brand-short-name } non considera questo sito attendibile in quanto utilizza un certificato che non è valido per { $hostname }. Il certificato è valido solo per { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = I siti web garantiscono la propria identità attraverso certificati. { -brand-short-name } non considera questo sito attendibile in quanto utilizza un certificato che non è valido per { $hostname }. Il certificato è valido solo per i seguenti nomi: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = I siti web garantiscono la propria identità attraverso certificati con un determinato periodo di validità. Il certificato per { $hostname } è scaduto il { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = I siti web garantiscono la propria identità attraverso certificati con un determinato periodo di validità. Il certificato per { $hostname } sarà valido a partire dal { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Codice di errore: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = I siti web garantiscono la propria identità attraverso certificati di sicurezza rilasciati da autorità di certificazione. La maggior parte dei browser non considera più attendibili i certificati rilasciati da GeoTrust, RapidSSL, Symantec, Thawte e VeriSign. { $hostname } utilizza un certificato rilasciato da una di queste autorità, pertanto non è possibile garantire l’autenticità del sito web.

cert-error-symantec-distrust-admin = È possibile segnalare il problema al gestore del sito web.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Catena di certificati:

open-in-new-window-for-csp-or-xfo-error = Apri sito in una nuova finestra

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Per proteggere la tua sicurezza, { $hostname } non consente a { -brand-short-name } di visualizzare la pagina quando è inclusa all’interno di un altro sito. Per visualizzare questa pagina è necessario aprirla in una nuova finestra.

## Messages used for certificate error titles

connectionFailure-title = Connessione non riuscita
deniedPortAccess-title = Questo indirizzo è bloccato
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Uhm… non riusciamo a trovare questo sito.
fileNotFound-title = File non trovato
fileAccessDenied-title = Accesso negato al file
generic-title = Oops.
captivePortal-title = Accedi alla rete
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Uhm… l’indirizzo non sembra corretto.
netInterrupt-title = La connessione è stata interrotta
notCached-title = Documento scaduto
netOffline-title = Non in linea
contentEncodingError-title = Errore di codifica del contenuto
unsafeContentType-title = Tipo di file non sicuro
netReset-title = La connessione è stata annullata
netTimeout-title = Tempo per la connessione esaurito
unknownProtocolFound-title = Indirizzo non interpretabile
proxyConnectFailure-title = Connessione rifiutata dal server proxy
proxyResolveFailure-title = Impossibile stabilire una connessione con il server proxy
redirectLoop-title = Questa pagina non reindirizza in modo corretto
unknownSocketType-title = Risposta imprevista del server
nssFailure2-title = Connessione sicura non riuscita
csp-xfo-error-title = Impossibile aprire questa pagina in { -brand-short-name }
corruptedContentError-title = Errore contenuto danneggiato
remoteXUL-title = XUL remoto
sslv3Used-title = Impossibile stabilire una connessione sicura
inadequateSecurityError-title = Connessione non sicura
blockedByPolicy-title = Pagina bloccata
clockSkewError-title = L’orologio del computer è errato
networkProtocolError-title = Errore protocollo di rete
nssBadCert-title = Attenzione: potenziale rischio per la sicurezza
nssBadCert-sts-title = Connessione interrotta: potenziale rischio per la sicurezza
certerror-mitm-title = Un software impedisce a { -brand-short-name } di connettersi in modo sicuro a questo sito
