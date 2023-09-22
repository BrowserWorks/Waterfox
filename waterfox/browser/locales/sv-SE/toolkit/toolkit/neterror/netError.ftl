# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Fel vid sidhämtning
certerror-page-title = Varning: Möjlig säkerhetsrisk framöver
certerror-sts-page-title = Kunde inte ansluta: Potentiellt säkerhetsproblem
neterror-blocked-by-policy-page-title = Blockerad sida
neterror-captive-portal-page-title = Logga in till nätverk
neterror-dns-not-found-title = Servern hittades inte
neterror-malformed-uri-page-title = Ogiltig URL

## Error page actions

neterror-advanced-button = Avancerat…
neterror-copy-to-clipboard-button = Kopiera text till urklipp
neterror-learn-more-link = Läs mer…
neterror-open-portal-login-page-button = Öppna inloggningssida för nätverk
neterror-override-exception-button = Acceptera risken och fortsätt
neterror-pref-reset-button = Återställ standardinställningar
neterror-return-to-previous-page-button = Gå tillbaka
neterror-return-to-previous-page-recommended-button = Gå tillbaka (rekommenderas)
neterror-try-again-button = Försök igen
neterror-add-exception-button = Fortsätt alltid för den här webbplatsen
neterror-settings-button = Ändra DNS-inställningar
neterror-view-certificate-link = Visa certifikat
neterror-trr-continue-this-time = Fortsätt den här gången
neterror-disable-native-feedback-warning = Fortsätt alltid

##

neterror-pref-reset = Det ser ut som nätverkets säkerhetsinställningar kan orsaka detta. Vill du att standardinställningarna ska återställas?
neterror-error-reporting-automatic = Rapportera fel som detta för att hjälpa { -vendor-short-name } identifiera och blockera skadliga webbplatser

## Specific error messages

neterror-generic-error = { -brand-short-name } kan av någon anledning inte visa sidan.
neterror-load-error-try-again = Webbplatsen kan tillfälligt vara nere eller upptagen. Försök igen om en stund.
neterror-load-error-connection = Om du inte kan öppna sidor, kontrollera datorns nätverksanslutning.
neterror-load-error-firewall = Om datorn eller nätverket skyddas av en brandvägg eller proxy, kontrollera att { -brand-short-name } har tillstånd att ansluta till webben.
neterror-captive-portal = Du måste logga in på nätverket innan du kan ansluta till Internet.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Menade du att gå till <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Om du har angett rätt adress kan du:</strong>
neterror-dns-not-found-hint-try-again = Försök igen senare
neterror-dns-not-found-hint-check-network = Kontrollera din nätverksanslutning
neterror-dns-not-found-hint-firewall = Kontrollera att { -brand-short-name } har behörighet att komma åt webben (du kan vara ansluten men bakom en brandvägg)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } kan inte skydda din begäran om den här webbplatsens adress genom vår betrodda DNS-resolver. Här är varför:
neterror-dns-not-found-trr-third-party-warning2 = Du kan fortsätta med din standard DNS-resolver. Men en tredje part kanske kan se vilka webbplatser du besöker.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } kunde inte ansluta till { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = Anslutningen till { $trrDomain } tog längre tid än förväntat.
neterror-dns-not-found-trr-offline = Du är inte ansluten till internet.
neterror-dns-not-found-trr-unknown-host2 = Den här webbplatsen hittades inte av { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Det uppstod ett problem med { $trrDomain }.
neterror-dns-not-found-bad-trr-url = Ogiltig URL.
neterror-dns-not-found-trr-unknown-problem = Oväntat problem.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } kan inte skydda din begäran om den här webbplatsens adress genom vår betrodda DNS-lösare. Här är varför:
neterror-dns-not-found-native-fallback-heuristic = DNS över HTTPS har inaktiverats i ditt nätverk.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } kunde inte ansluta till { $trrDomain }.

##

neterror-file-not-found-filename = Kontrollera om det finns stavfel eller andra typografiska fel i filnamnet.
neterror-file-not-found-moved = Kontrollera om filen flyttats, fått ett annat namn eller tagits bort.
neterror-access-denied = Den kan ha tagits bort, flyttats eller så kan filrättigheter hindra tillgång.
neterror-unknown-protocol = Du kan behöva installera andra program för att öppna den här sidan.
neterror-redirect-loop = Det här problemet kan ibland uppstå om du inaktiverat eller nekat att ta emot kakor.
neterror-unknown-socket-type-psm-installed = Kontrollera att Personal Security Manager finns installerat på datorn.
neterror-unknown-socket-type-server-config = Det här kan ibland bero på en ovanlig konfiguration på servern.
neterror-not-cached-intro = Det efterfrågade dokumentet finns inte längre i { -brand-short-name } cache.
neterror-not-cached-sensitive = Av säkerhetsskäl försöker inte { -brand-short-name } automatiskt att hämta om känsliga dokument.
neterror-not-cached-try-again = Klicka på Försök igen för att åter hämta dokumentet från webbplatsen.
neterror-net-offline = Klicka på “Försök igen” för att byta till uppkopplat läge och ladda om sidan.
neterror-proxy-resolve-failure-settings = Kontrollera att proxyinställningarna är riktiga.
neterror-proxy-resolve-failure-connection = Kontrollera att datorn har en fungerande nätverksanslutning.
neterror-proxy-resolve-failure-firewall = Om datorn eller nätverket skyddas av en brandvägg eller proxy, kontrollera att { -brand-short-name } har tillstånd att ansluta till webben.
neterror-proxy-connect-failure-settings = Kontrollera att proxyinställningarna är riktiga.
neterror-proxy-connect-failure-contact-admin = Kontakta nätverksadministratören för att säkerställa att proxyservern fungerar.
neterror-content-encoding-error = Kontakta webbplatsens ägare och informera dem om detta problem.
neterror-unsafe-content-type = Kontakta webbplatsens ägare för att informera dem om detta problem.
neterror-nss-failure-not-verified = Sidan du försöker se kan inte visas eftersom autenticiteten för mottagen data inte kan verifieras.
neterror-nss-failure-contact-website = Kontakta webbplatsens ägare och informera dem om detta problem.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } upptäckte ett potentiellt säkerhetshot och fortsatte inte till <b>{ $hostname }</b>. Om du besöker den här webbplatsen kan angripare försöka stjäla information som lösenord, e-post eller kreditkortsuppgifter.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } upptäckte ett potentiellt säkerhetshot och fortsatte inte <b>{ $hostname }</b> eftersom den här webbplatsen kräver en säker anslutning.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } upptäckte ett problem och fortsatte inte till <b>{ $hostname }</b>. Webbplatsen är antingen felkonfigurerad eller din klocka är inställd på fel tid.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> är troligtvis en säker webbplats, men en säker anslutning kunde inte etableras. Problemet orsakas av <b>{ $mitm }</b>, vilket är antingen programvara på din dator eller ditt nätverk.
neterror-corrupted-content-intro = Sidan du försöker se kan inte visas på grund av att ett fel i dataöverföringen upptäcktes.
neterror-corrupted-content-contact-website = Kontakta ägarna till webbplatsen för att informera dem om detta problem.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Avancerad info: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> använder säkerhetsteknologi som är föråldrad och sårbar för angrepp. En angripare kan lätt avslöja information som du trott ska vara säker. Webbplatsens administratör måste laga servern innan du kan besöka webbplatsen.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Felkod: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Din dator tycker att det är { DATETIME($now, dateStyle: "medium") }, vilket hindrar { -brand-short-name } från att ansluta säkert. För att besöka <b>{ $hostname }</b>, uppdatera datorns klocka i dina systeminställningar till aktuellt datum, tid och tidszon och uppdatera sedan <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = Sidan du försöker visa kan inte visas eftersom ett fel i nätverksprotokollet upptäcktes.
neterror-network-protocol-error-contact-website = Vänligen kontakta webbplatsens ägare för att informera dem om detta problem.
certerror-expired-cert-second-para = Det är troligt att webbplatsens certifikat har upphört, vilket förhindrar { -brand-short-name } från att ansluta säkert. Om du besöker den här webbplatsen kan angripare försöka stjäla information som lösenord, e-post eller kreditkortsuppgifter.
certerror-expired-cert-sts-second-para = Det är troligt att webbplatsens certifikat har upphört, vilket förhindrar { -brand-short-name } från att ansluta säkert.
certerror-what-can-you-do-about-it-title = Vad kan du göra åt det?
certerror-unknown-issuer-what-can-you-do-about-it-website = Problemet beror sannolikt på webbplatsen och det finns inget du kan göra för att lösa det.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Om du är på ett företagsnätverk eller använder antivirusprogram kan du fråga supporten efter hjälp. Du kan också meddela webbplatsens administratör om problemet.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Datorklockan är inställd på { DATETIME($now, dateStyle: "medium") }. Kontrollera att datorn är inställd på rätt datum, tid och tidszon i systeminställningarna och uppdatera sedan <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Om klockan redan är inställd på rätt tid, är webbplatsen sannolikt felkonfigurerad, och det finns inget du kan göra för att lösa problemet. Du kan meddela webbplatsens administratör om problemet.
certerror-bad-cert-domain-what-can-you-do-about-it = Problemet beror sannolikt på webbplatsen och det finns inget du kan göra för att lösa det. Du kan meddela webbplatsens administratör om problemet.
certerror-mitm-what-can-you-do-about-it-antivirus = Om ditt antivirusprogram innehåller en funktion som skannar krypterade anslutningar (ofta kallad "webbskanning" eller "https-skanning") kan du inaktivera den här funktionen. Om det inte fungerar kan du ta bort och installera om antivirusprogrammet.
certerror-mitm-what-can-you-do-about-it-corporate = Om du är på ett företagsnätverk kan du kontakta din IT-avdelning.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Om du inte känner till <b>{ $mitm }</b>, kan det här vara en attack och du borde inte fortsätta till webbplatsen.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Om du inte känner till <b>{ $mitm }</b>, kan det här vara en attack och det finns inget du kan göra för att komma åt webbplatsen.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> har en säkerhetspolicy som heter HTTP Strict Transport Security (HSTS), vilket innebär att { -brand-short-name } kan endast anslutas säkert till den. Du kan inte lägga till ett undantag för att besöka denna webbplats.
