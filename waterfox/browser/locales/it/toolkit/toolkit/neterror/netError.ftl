# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Errore caricamento pagina
certerror-page-title = Attenzione: potenziale rischio per la sicurezza
certerror-sts-page-title = Connessione interrotta: potenziale rischio per la sicurezza
neterror-blocked-by-policy-page-title = Pagina bloccata
neterror-captive-portal-page-title = Accedi alla rete
neterror-dns-not-found-title = Impossibile contattare il server
neterror-malformed-uri-page-title = Indirizzo non valido

## Error page actions

neterror-advanced-button = Avanzate…
neterror-copy-to-clipboard-button = Copia il testo negli appunti
neterror-learn-more-link = Ulteriori informazioni…
neterror-open-portal-login-page-button = Apri la pagina di accesso alla rete
neterror-override-exception-button = Accetta il rischio e continua
neterror-pref-reset-button = Ripristina impostazioni predefinite
neterror-return-to-previous-page-button = Torna indietro
neterror-return-to-previous-page-recommended-button = Torna indietro (consigliato)
neterror-try-again-button = Riprova
neterror-add-exception-button = Continua sempre per questo sito
neterror-settings-button = Modifica impostazioni DNS
neterror-view-certificate-link = Visualizza certificato
neterror-trr-continue-this-time = Continua questa volta
neterror-disable-native-feedback-warning = Continua sempre

##

neterror-pref-reset = Sembra che il problema sia causato dalle impostazioni di sicurezza della rete. Ripristinare le impostazioni predefinite?
neterror-error-reporting-automatic = Segnala errori come questo per aiutare { -vendor-short-name } a identificare e bloccare siti dannosi

## Specific error messages

neterror-generic-error = Per qualche motivo { -brand-short-name } non è in grado di caricare questa pagina.

neterror-load-error-try-again = Il sito potrebbe essere non disponibile o sovraccarico. Riprovare fra qualche istante.
neterror-load-error-connection = Se non è possibile caricare alcuna pagina, controllare la connessione di rete del computer.
neterror-load-error-firewall = Se il computer o la rete sono protetti da un firewall o un proxy, assicurarsi che { -brand-short-name } abbia i permessi per accedere al Web.

neterror-captive-portal = È necessario accedere alla rete per navigare in Internet.

# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Forse volevi aprire <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Se hai inserito l’indirizzo corretto, puoi:</strong>
neterror-dns-not-found-hint-try-again = Riprovare più tardi
neterror-dns-not-found-hint-check-network = Verificare la connessione alla rete
neterror-dns-not-found-hint-firewall = Controllare che { -brand-short-name } abbia il permesso di accedere a Internet (la connessione potrebbe essere protetta da un firewall)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } non può proteggere la richiesta relativa all’indirizzo di questo sito utilizzando il servizio di risoluzione dei nomi (DNS) che riteniamo attendibile. Motivo:
neterror-dns-not-found-trr-third-party-warning2 = È possibile continuare con il servizio di risoluzione dei nomi (DNS) predefinito. Tuttavia, un soggetto di terze parti potrebbe essere in grado di identificare quali siti visiti.

neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } non è riuscito a connettersi a { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = La connessione a { $trrDomain } ha richiesto più tempo del previsto.
neterror-dns-not-found-trr-offline = Nessuna connessione a Internet.
neterror-dns-not-found-trr-unknown-host2 = Il sito web non è stato trovato da { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Si è verificato un problema con { $trrDomain }.
neterror-dns-not-found-bad-trr-url = URL non valido.
neterror-dns-not-found-trr-unknown-problem = Problema inatteso.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } non può proteggere la richiesta relativa all’indirizzo di questo sito utilizzando il servizio di risoluzione dei nomi (DNS) che riteniamo attendibile. Motivo:
neterror-dns-not-found-native-fallback-heuristic = DNS su HTTPS è stato disattivato sulla tua rete.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } non è riuscito a connettersi a { $trrDomain }.

##

neterror-file-not-found-filename = Verificare che il nome del file non contenga maiuscole o errori di battitura.
neterror-file-not-found-moved = Verificare se il file è stato spostato, rinominato o rimosso.

neterror-access-denied = Il file potrebbe essere stato rimosso o spostato, oppure non si possiedono le autorizzazioni necessarie per aprirlo.

neterror-unknown-protocol = È necessario installare del software aggiuntivo per aprire questo indirizzo.

neterror-redirect-loop = Questo problema spesso è causato dal blocco o dal rifiuto dei cookie.

neterror-unknown-socket-type-psm-installed = Verificare che nel sistema sia installato il Personal Security Manager.
neterror-unknown-socket-type-server-config = Potrebbe trattarsi di una configurazione non standard del server.

neterror-not-cached-intro = Il documento richiesto non è più disponibile nella cache di { -brand-short-name }.
neterror-not-cached-sensitive = Per ragioni di sicurezza { -brand-short-name } non effettua automaticamente una nuova richiesta per documenti sensibili.
neterror-not-cached-try-again = Fare clic su Riprova per richiedere nuovamente il documento al sito web.

neterror-net-offline = Selezionare “Riprova” per passare alla modalità in linea e ricaricare la pagina.

neterror-proxy-resolve-failure-settings = Verificare la correttezza delle impostazioni del proxy.
neterror-proxy-resolve-failure-connection = Verificare se il computer ha una connessione di rete funzionante.
neterror-proxy-resolve-failure-firewall = Se il computer o la rete sono protetti da un firewall o un proxy, assicurarsi che { -brand-short-name } abbia i permessi per accedere al Web.

neterror-proxy-connect-failure-settings = Verificare la correttezza delle impostazioni del proxy.
neterror-proxy-connect-failure-contact-admin = Contattare l’amministratore di rete per verificare se il server proxy è funzionante.

neterror-content-encoding-error = Contattare il proprietario del sito web per informarlo del problema.

neterror-unsafe-content-type = Contattare il proprietario del sito web per informarlo del problema.

neterror-nss-failure-not-verified = La pagina che si sta cercando di visualizzare non può essere mostrata in quanto non è possibile verificare l’autenticità dei dati ricevuti.
neterror-nss-failure-contact-website = Contattare il responsabile del sito web per informarlo del problema.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } ha rilevato una potenziale minaccia per la sicurezza e interrotto la connessione con <b>{ $hostname }</b>. Visitando questo sito, malintenzionati potrebbero cercare di rubare informazioni personali come password, email o dati delle carte di credito.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } ha rilevato una potenziale minaccia per la sicurezza e interrotto la connessione con <b>{ $hostname }</b>, in quanto è possibile collegarsi a questo sito solo in modo sicuro.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } ha rilevato un problema e interrotto la connessione con <b>{ $hostname }</b>. Il sito non è configurato correttamente oppure l’orologio del computer è impostato sull’ora sbagliata.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> è probabilmente un sito affidabile, ma non è stato possibile stabilire una connessione sicura. Questo problema è causato da <b>{ $mitm }</b>, un software installato sul computer o sulla rete.

neterror-corrupted-content-intro = La pagina richiesta non può essere visualizzata a causa di un errore rilevato durante la trasmissione dei dati.
neterror-corrupted-content-contact-website = Contattare il proprietario del sito web e segnalare il problema.

# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Informazioni avanzate: SSL_ERROR_UNSUPPORTED_VERSION

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> utilizza una tecnologia di sicurezza obsoleta e vulnerabile. Un tentativo di attacco potrebbe facilmente compromettere informazioni considerate sicure. L’amministratore del sito web deve aggiornare la configurazione del server prima di poterlo visitare.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Codice di errore: NS_ERROR_NET_INADEQUATE_SECURITY

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = L’ora riportata dall’orologio del computer è { DATETIME($now, dateStyle: "medium") }, questo impedisce a { -brand-short-name } di connettersi in modo sicuro. Per visitare <b>{ $hostname }</b> aggiornare l’orologio del computer nelle impostazioni del sistema, impostando data, ora e fuso orario correnti, poi riprovare a caricare <b>{ $hostname }</b>.

neterror-network-protocol-error-intro = La pagina che si sta cercando di visualizzare non può essere mostrata poiché si è verificato un errore nel protocollo di rete.
neterror-network-protocol-error-contact-website = Contattare il proprietario del sito web per informarlo del problema.

certerror-expired-cert-second-para = È probabile che il certificato del sito web sia scaduto. Questo impedisce a { -brand-short-name } di connettersi in modo sicuro. Visitando questo sito, malintenzionati potrebbero cercare di rubare informazioni personali come password, email o dati delle carte di credito.
certerror-expired-cert-sts-second-para = È probabile che il certificato del sito web sia scaduto. Questo impedisce a { -brand-short-name } di connettersi in modo sicuro.

certerror-what-can-you-do-about-it-title = Che cosa posso fare per risolvere?

certerror-unknown-issuer-what-can-you-do-about-it-website = L’errore è probabilmente causato dal sito web e non può essere risolto.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Se si stanno utilizzando una rete aziendale o un software antivirus, contattare i team di supporto per ottenere assistenza. È inoltre possibile segnalare il problema al gestore del sito web.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = L’ora riportata dall’orologio del computer è { DATETIME($now, dateStyle: "medium") }. Assicurarsi che data, ora e fuso orario siano impostati correttamente nelle impostazioni di sistema, poi riprovare a caricare <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Se l’orologio del computer è già impostato correttamente, si tratta probabilmente di un’errata configurazione del sito web e il problema non può essere risolto. È possibile segnalare il problema al gestore del sito web.

certerror-bad-cert-domain-what-can-you-do-about-it = L’errore è probabilmente causato dal sito web e non può essere risolto. È possibile segnalare il problema al gestore del sito web.

certerror-mitm-what-can-you-do-about-it-antivirus = Se l’antivirus include una funzione per la scansione di connessioni crittate (spesso chiamato “web scanning” o ”https scanning”), provare a disattivarla. Se questa operazione non dovesse risolvere il problema, provare a disinstallare e reinstallare il software antivirus.
certerror-mitm-what-can-you-do-about-it-corporate = Se il computer è connesso a una rete aziendale, contattare il supporto tecnico.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Se non si conosce <b>{ $mitm }</b>, potrebbe trattarsi di un attacco ed è consigliato interrompere la connessione a questo sito.

# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Se non si conosce <b>{ $mitm }</b>, potrebbe trattarsi di un attacco e non è possibile accedere a questo sito.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> utilizza un criterio di sicurezza chiamato HTTP Strict Transport Security (HSTS). Questo significa che { -brand-short-name } può connettersi solo in modo sicuro e non è possibile aggiungere un’eccezione per visitare questo sito.

