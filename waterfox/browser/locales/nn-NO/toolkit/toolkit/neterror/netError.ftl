# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Problem med lasting av sida
certerror-page-title = Åtvaring: Potensiell sikkerheitsrisiko framom her
certerror-sts-page-title = Kopla ikkje til: Potensielt tryggingsproblem
neterror-blocked-by-policy-page-title = Blokkert side
neterror-captive-portal-page-title = Logg inn på nettverket
neterror-dns-not-found-title = Fann ikkje serveren
neterror-malformed-uri-page-title = Ugyldig nettadresse

## Error page actions

neterror-advanced-button = Avansert…
neterror-copy-to-clipboard-button = Kopier tekst til utklippstavla
neterror-learn-more-link = Les meir…
neterror-open-portal-login-page-button = Opne innloggingsside for nettverk
neterror-override-exception-button = Godta risikoen og fortset
neterror-pref-reset-button = Bruk standardinnstillingar
neterror-return-to-previous-page-button = Gå tilbake
neterror-return-to-previous-page-recommended-button = Gå tilbake (Tilrådd)
neterror-try-again-button = Prøv på nytt
neterror-add-exception-button = Fortset alltid for denne sida
neterror-settings-button = Endre DNS-instillingar
neterror-view-certificate-link = Vis sertifikat
neterror-trr-continue-this-time = Hald fram denne gongen
neterror-disable-native-feedback-warning = Hald alltid fram

##

neterror-pref-reset = Det ser ut til at sikkerheitsinnstillingane i nettverket kan vere årsak til dette. Vil du stille tilbake til standard innstillingar?
neterror-error-reporting-automatic = Rapporter feil som dette for å hjelpe { -vendor-short-name } med å identifisere og blokkere skadelege nettstadar

## Specific error messages

neterror-generic-error = { -brand-short-name } klarte ikkje å laste denne sida av ukjend årsak.
neterror-load-error-try-again = Nettstaden kan vere mellombels utilgjengeleg eller oppteken. Prøv på nytt om ei lita stund.
neterror-load-error-connection = Dersom ingen sider vert lasta, kontroller at nettverkstilkoplinga til datamaskina er i orden.
neterror-load-error-firewall = Dersom datamaskina er verna av ein brannmur eller mellomtenar, kontroller at { -brand-short-name } har løyve til å bruke nettet.
neterror-captive-portal = Du må logge inn på nettverket før du kan kople til Internett.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Meinte du å gå til <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Om du har skrive inn rett adresse, kan du:</strong>
neterror-dns-not-found-hint-try-again = Prøv på nytt seinare
neterror-dns-not-found-hint-check-network = Kontrollere nettverkstilkoplinga di
neterror-dns-not-found-hint-firewall = Kontrollere at { -brand-short-name } har løyve til å kople til nettet (du kan vere tilkopla, men bak ein brannvegg)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } kan ikkje beskytte førespurnaden din om adressa til denne nettstaden, gjennom den pålitelege DNS-løysaren vår. Årsak:
neterror-dns-not-found-trr-third-party-warning2 = Du kan halde fram med standard DNS-resolver. Ein tredjepart vil likevel kunne sjå kva for nettstadar du besøkjer.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } klarte ikkje å kople til { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = Tilkoblinga til { $trrDomain } tok lengre tid enn forventa.
neterror-dns-not-found-trr-offline = Du er ikkje kopla til internett.
neterror-dns-not-found-trr-unknown-host2 = Denne nettstaden vart ikkje funnen av { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Det er eit problem med { $trrDomain }.
neterror-dns-not-found-bad-trr-url = Ugyldig nettadresse.
neterror-dns-not-found-trr-unknown-problem = Uventa problem.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } kan ikkje beskytte førespurnaden din om adressa til denne nettstaden, gjennom den pålitelege DNS-løysaren vår. Årsak:
neterror-dns-not-found-native-fallback-heuristic = DNS-over-HTTPS er deaktivert på nettverket ditt.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } klarte ikkje å kople til { $trrDomain }.

##

neterror-file-not-found-filename = Kontroller filnamnet etter skilnadar i store/små bokstavar eller andre skrivefeil.
neterror-file-not-found-moved = Kontroller om fila er flytta, har endra namn eller er sletta.
neterror-access-denied = Den kan ha vorte fjerna, flytta, eller filrettar hindrar tilgang.
neterror-unknown-protocol = Du må kanskje installere anna programvare for å opne denne adressa.
neterror-redirect-loop = Dette problemet kan av og til kome av at infokapslar har vorte slått av eller ved å ikkje godta infokapslar.
neterror-unknown-socket-type-psm-installed = Kontroller at systemet ditt har Personal Security Manager installert.
neterror-unknown-socket-type-server-config = Dette problemet kan kome av eit uvanleg oppsett på tenaren.
neterror-not-cached-intro = Det førespurde dokumentet er ikkje tilgjengeleg i { -brand-short-name } sitt snøgglager.
neterror-not-cached-sensitive = Av tryggingsomsyn tillét ikkje { -brand-short-name } å automatisk hente sensitive dokument på nytt.
neterror-not-cached-try-again = Trykk Prøv på nytt for å hente dokumentet på nytt frå nettstaden.
neterror-net-offline = Trykk «Prøv på nytt» for å byte til tilkopla modus og laste sida på nytt.
neterror-proxy-resolve-failure-settings = Kontroller at proxyinnstillingane er rette.
neterror-proxy-resolve-failure-connection = Kontroller at datamaskina har ei fungerande nettverkstilkopling.
neterror-proxy-resolve-failure-firewall = Dersom datamaskina di eller nettverket er verna av ein brannmur eller proxy, kontroller at { -brand-short-name } har løyve til å kople til Internett.
neterror-proxy-connect-failure-settings = Kontroller at proxy-innstillingane er korrekte.
neterror-proxy-connect-failure-contact-admin = Kontakt nettverksansvarleg for å forsikre deg om at proxyserveren fungerer.
neterror-content-encoding-error = Kontakt eigarane av nettstaden og informer dei om problemet.
neterror-unsafe-content-type = Kontakt eigaren av nettsida og informer dei om dette problemet.
neterror-nss-failure-not-verified = Sida du prøver å opne kan ikkje visast fordi det ikkje kan stadfestast at overførte data er autentiske.
neterror-nss-failure-contact-website = Kontakt nettstadeigarane og informer om problemet.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } oppdaga ein potensiell sikkerheitstrussel og fortsette ikkje til <b>{ $hostname }</b>. Viss du besøkjer denne nettstaden, kan angriparane prøve å stele informasjon som passord, e-post eller kredittkortdetaljar.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } oppdaga ein potensiell sikkerheitstrussel og held ikkje fram til <b>{ $hostname }</b> fordi denne nettstaden krev ei sikker tilkopling.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } oppdaga eit problem og held ikkje fram til <b>{ $hostname }</b>. Nettstaden er anten feilkonfigurert eller klokka på datamaskina er stilt inn på feil tid.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> er sannsynlegvis ein sikker nettstad, men ei sikker tilkopling kunne ikkje etablerast. Problemet er forårsaka av <b>{ $mitm }</b> som anten er eit program på datamaskina di eller på nettverket ditt.
neterror-corrupted-content-intro = Sida du prøver å vise kan ikkje opnast fordi ein feil i dataoverføringa vart oppdaga.
neterror-corrupted-content-contact-website = Kontakt eigarane av nettstaden og informer dei om dette problemet.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Avansert info: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> brukar tryggingsteknologi som er forelda og sårbar for åtak. Ein angripar kan lett avsløre informasjon som du trudde skulle vere sikker. Administrator på nettstaden må fikse tenaren før du kan besøkje nettsida.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Feilkode: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Datamaskina di trur det er { DATETIME($now, dateStyle: "medium") }, som hindrar { -brand-short-name } frå å kople til trygt. For å besøkje <b>{ $hostname }</b>, oppdater klokka til datamaskina i systeminnstillingane til gjeldande dato, klokkeslett og tidssone, og oppdater deretter <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = Sida du forsøker å vise kan ikkje opnast fordi ein feil i nettverksprotokollen vart oppdaga.
neterror-network-protocol-error-contact-website = Kontakt nettstadseigarane og informer dei om dette problemet.
certerror-expired-cert-second-para = Sannsynlegvis har sertifikatet til nettsida gått ut, noko som hindrar { -brand-short-name } frå å kople til trygt. Dersom du besøkjer denne nettsida, kan angriparar prøve å stele informasjon som passord, e-post eller kredittkortdetaljar.
certerror-expired-cert-sts-second-para = Sannsynlegvis har sertifikatet til nettsida gått ut, noko som hindrar { -brand-short-name } frå å opprette eit trygt samband.
certerror-what-can-you-do-about-it-title = Kva kan du gjere med det?
certerror-unknown-issuer-what-can-you-do-about-it-website = Problemet er mest sannsynleg med nettstaden, og det er ingenting du kan gjere for å løyse det.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Viss du er på eit bedriftsnettverk eller brukar antivirusprogramvare, kan du kontakte brukarstøtta for hjelp. Du kan også varsle administrator for nettstaden om problemet.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Klokka på datamaskina er sett til { DATETIME($now, dateStyle: "medium") }. Kontroller at datamaskina er sett til rett dato, klokkeslett og tidssone i systeminnstillingane, og last deretter <b>{ $hostname }</b> på nytt.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Viss klokka di allereie er sett til rett tidspunkt, er nettstaden sannsynlegvis feilkonfigurert, og det er ingenting du kan gjere for å løyse problemet. Du kan varsle administrator for nettstaden om problemet.
certerror-bad-cert-domain-what-can-you-do-about-it = Problemet er mest sannsynleg med nettstaden, og det er ingenting du kan gjere for å løyse det. Du kan varsle administrator for nettstaden om problemet.
certerror-mitm-what-can-you-do-about-it-antivirus = Viss antivirusprogrammet ditt inneheld ein funksjon som skannar krypterte tilkoplingar (ofte kalla «webscanning» eller «https-skanning»), kan du deaktivere denne funksjonen. Viss det ikkje verkar, kan du fjerne og installere antivirusprogrammet på nytt.
certerror-mitm-what-can-you-do-about-it-corporate = Om du er i eit bedriftsnettverk, kan du kontakte IT-avdelinga di.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Viss du ikkje kjenner til <b>{ $mitm }</b>, kan dette vere eit angrep, og du bør ikkje fortsette til nettstaden.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Viss du ikkje kjenner til <b>{ $mitm }</b>, kan dette vere eit angrep, og det er ingenting du kan gjere for å få tilgang til nettstaden.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> har ein tryggingspolicy kalla HTTP Strict Transport Security (HSTS), som betyr at { -brand-short-name } berre kan kople til han trygt. Du kan ikkje leggje til eit unntak for å besøkje denne nettstaden.
