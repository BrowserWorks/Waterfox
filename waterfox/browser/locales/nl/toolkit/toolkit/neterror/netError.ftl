# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Probleem bij het laden van de pagina
certerror-page-title = Waarschuwing: mogelijk beveiligingsrisico
certerror-sts-page-title = Geen verbinding gemaakt: mogelijk beveiligingsprobleem
neterror-blocked-by-policy-page-title = Geblokkeerde pagina
neterror-captive-portal-page-title = Aanmelden bij netwerk
neterror-dns-not-found-title = Server niet gevonden
neterror-malformed-uri-page-title = Ongeldige URL

## Error page actions

neterror-advanced-button = Geavanceerd…
neterror-copy-to-clipboard-button = Tekst naar klembord kopiëren
neterror-learn-more-link = Meer info…
neterror-open-portal-login-page-button = Aanmeldingspagina voor netwerk openen
neterror-override-exception-button = Het risico aanvaarden en doorgaan
neterror-pref-reset-button = Standaardinstellingen herstellen
neterror-return-to-previous-page-button = Terug
neterror-return-to-previous-page-recommended-button = Teruggaan (Aanbevolen)
neterror-try-again-button = Opnieuw proberen
neterror-add-exception-button = Altijd doorgaan voor deze website
neterror-settings-button = DNS-instellingen wijzigen
neterror-view-certificate-link = Certificaat bekijken
neterror-trr-continue-this-time = Deze keer doorgaan
neterror-disable-native-feedback-warning = Altijd doorgaan

##

neterror-pref-reset = Het lijkt erop dat dit door uw netwerkbeveiligingsinstellingen wordt veroorzaakt. Wilt u de standaardinstellingen herstellen?
neterror-error-reporting-automatic = Fouten als deze rapporteren om { -vendor-short-name } te helpen kwaadwillende websites te herkennen en te blokkeren

## Specific error messages

neterror-generic-error = { -brand-short-name } kan deze pagina om de een of andere reden niet laden.
neterror-load-error-try-again = Misschien is de website tijdelijk niet beschikbaar of overbelast. Probeer het over enkele ogenblikken opnieuw.
neterror-load-error-connection = Als u geen enkele pagina kunt laden, controleer dan de netwerkverbinding van uw computer.
neterror-load-error-firewall = Als uw computer of netwerk wordt beveiligd door een firewall of proxy, zorg er dan voor dat { -brand-short-name } toegang heeft tot het web.
neterror-captive-portal = U moet zich aanmelden bij dit netwerk voordat u toegang hebt tot het internet.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Wilde u naar <a data-l10n-name="website">{ $hostAndPath }</a> gaan?
neterror-dns-not-found-hint-header = <strong>Als u het juiste adres hebt ingevoerd, kunt u:</strong>
neterror-dns-not-found-hint-try-again = Het later opnieuw proberen
neterror-dns-not-found-hint-check-network = Uw netwerkverbinding controleren
neterror-dns-not-found-hint-firewall = Controleren of { -brand-short-name } toestemming heeft om toegang te krijgen tot internet (u bent mogelijk verbonden maar bevindt zich achter een firewall)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } kan uw aanvraag om het adres van deze website niet beschermen via onze vertrouwde DNS-resolver. Dit is de reden:
neterror-dns-not-found-trr-third-party-warning2 = U kunt doorgaan met uw standaard DNS-resolver. Een derde partij kan echter mogelijk zien welke websites u bezoekt.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } kon geen verbinding maken met { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = De verbinding met { $trrDomain } duurde langer dan verwacht.
neterror-dns-not-found-trr-offline = U bent niet verbonden met het internet.
neterror-dns-not-found-trr-unknown-host2 = Deze website is niet gevonden door { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Er is een probleem met { $trrDomain }.
neterror-dns-not-found-bad-trr-url = Ongeldige URL.
neterror-dns-not-found-trr-unknown-problem = Onverwacht probleem.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } kan uw aanvraag om het adres van deze website niet beschermen via onze vertrouwde DNS-resolver. Dit is de reden:
neterror-dns-not-found-native-fallback-heuristic = DNS over HTTPS is uitgeschakeld op uw netwerk.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } kon geen verbinding maken met { $trrDomain }.

##

neterror-file-not-found-filename = Controleer de bestandsnaam op grote/kleine letters of andere typefouten.
neterror-file-not-found-moved = Controleer of het bestand is verplaatst, hernoemd of verwijderd.
neterror-access-denied = Het kan zijn verwijderd, verplaatst, of bestandsmachtigingen kunnen toegang tegengaan.
neterror-unknown-protocol = Misschien moet u andere software installeren om dit adres te openen.
neterror-redirect-loop = Dit probleem kan soms worden veroorzaakt door het uitschakelen of weigeren van cookies.
neterror-unknown-socket-type-psm-installed = Zorg ervoor dat de persoonlijke beveiligingsbeheerder op uw systeem is geïnstalleerd.
neterror-unknown-socket-type-server-config = Dit kan het gevolg zijn van een niet-standaard configuratie van de server.
neterror-not-cached-intro = Het opgevraagde document is niet beschikbaar in de buffer van { -brand-short-name }.
neterror-not-cached-sensitive = Als beveiligingsmaatregel vraagt { -brand-short-name } gevoelige documenten niet automatisch opnieuw op.
neterror-not-cached-try-again = Klik op Opnieuw proberen om het document opnieuw van de website op te vragen.
neterror-net-offline = Klik op ‘Opnieuw proberen’ om naar de onlinemodus over te schakelen en de pagina opnieuw te laden.
neterror-proxy-resolve-failure-settings = Controleer of uw proxyinstellingen juist zijn.
neterror-proxy-resolve-failure-connection = Controleer of uw computer een werkende netwerkverbinding heeft.
neterror-proxy-resolve-failure-firewall = Als uw computer of netwerk wordt beveiligd door een firewall of proxy, zorg er dan voor dat { -brand-short-name } toegang heeft tot het web.
neterror-proxy-connect-failure-settings = Controleer of uw proxyinstellingen juist zijn.
neterror-proxy-connect-failure-contact-admin = Neem contact op met uw netwerkbeheerder om te controleren of de proxyserver werkt.
neterror-content-encoding-error = Neem contact op met de website-eigenaars om ze over dit probleem te informeren.
neterror-unsafe-content-type = Neem contact op met de website-eigenaars om ze over dit probleem te informeren.
neterror-nss-failure-not-verified = De pagina die u wilt bekijken kan niet worden weergegeven, omdat de echtheid van de ontvangen gegevens niet kon worden geverifieerd.
neterror-nss-failure-contact-website = Neem contact op met de website-eigenaars om ze over dit probleem te informeren.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } heeft een mogelijk beveiligingsrisico gedetecteerd en is niet doorgegaan naar <b>{ $hostname }</b>. Als u deze website bezoekt, zouden aanvallers gegevens kunnen proberen te stelen, zoals uw wachtwoorden, e-mailadressen of creditcardgegevens.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } heeft een mogelijk beveiligingsrisico gedetecteerd en is niet doorgegaan naar <b>{ $hostname }</b>, omdat deze website een beveiligde verbinding vereist.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } heeft een probleem gedetecteerd en is niet doorgegaan naar <b>{ $hostname }</b>. Of de website is onjuist geconfigureerd, of uw computerklok is op de verkeerde tijd ingesteld.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> is zeer waarschijnlijk een veilige website, maar er kon geen beveiligde verbinding tot stand worden gebracht. Dit probleem wordt veroorzaakt door <b>{ $mitm }</b>, dat software op uw computer of op uw netwerk betreft.
neterror-corrupted-content-intro = De pagina die u wilt bekijken kan niet worden weergegeven, omdat er een fout in de gegevensoverdracht is gedetecteerd.
neterror-corrupted-content-contact-website = Neem contact op met de website-eigenaars om ze over dit probleem te informeren.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Geavanceerde info: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> gebruikt verouderde beveiligingstechnologie die kwetsbaar is voor aanvallen. Een aanvaller kan eenvoudig gegevens onthullen waarvan u dacht dat deze veilig waren. De websitebeheerder dient eerst de server in orde te maken voordat u de website kunt bezoeken.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Foutcode: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Uw computer denkt dat het { DATETIME($now, dateStyle: "medium") } is, waardoor { -brand-short-name } geen beveiligde verbinding met <b>{ $hostname }</b> kan maken. Werk uw computerklok bij naar de huidige datum, tijd en tijdzone in uw systeeminstellingen, en vernieuw daarna de pagina om <b>{ $hostname }</b> te bezoeken.
neterror-network-protocol-error-intro = De pagina die u wilt bekijken kan niet worden weergegeven, omdat er een fout in het netwerkprotocol is gedetecteerd.
neterror-network-protocol-error-contact-website = Neem contact op met de website-eigenaars om ze over dit probleem te informeren.
certerror-expired-cert-second-para = Waarschijnlijk is het certificaat van de website verlopen, waardoor { -brand-short-name } geen beveiligde verbinding kan maken. Als u deze website bezoekt, zouden aanvallers gegevens kunnen proberen te stelen, zoals uw wachtwoorden, e-mailadressen of creditcardgegevens.
certerror-expired-cert-sts-second-para = Waarschijnlijk is het certificaat van de website verlopen, waardoor { -brand-short-name } geen beveiligde verbinding kan maken.
certerror-what-can-you-do-about-it-title = Wat kunt u hieraan doen?
certerror-unknown-issuer-what-can-you-do-about-it-website = Het probleem ligt zeer waarschijnlijk bij de website, en u kunt niets doen om dit te verhelpen.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Als u zich op een zakelijk netwerk bevindt of antivirussoftware gebruikt, kunt u contact opnemen met de ondersteuningsafdelingen voor assistentie. U kunt ook de beheerder van de website over het probleem informeren.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Uw computerklok is ingesteld op { DATETIME($now, dateStyle: "medium") }. Zorg ervoor dat uw computer op de juiste datum, tijd en tijdzone is ingesteld in uw systeeminstellingen, en vernieuw daarna <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Als uw klok al op de juiste tijd is ingesteld, is de website waarschijnlijk onjuist geconfigureerd, en kunt u niets doen om het probleem te verhelpen. U kunt wel de beheerder van de website over het probleem informeren.
certerror-bad-cert-domain-what-can-you-do-about-it = Het probleem ligt zeer waarschijnlijk bij de website, en u kunt niets doen om dit te verhelpen. U kunt wel de beheerder van de website over het probleem informeren.
certerror-mitm-what-can-you-do-about-it-antivirus = Als uw antivirussoftware een functie bevat die versleutelde verbindingen scant (vaak ‘webscanning’ of ‘https-scanning’ genoemd), kunt u die functie uitschakelen. Als dat niet werkt, kunt u de antivirussoftware verwijderen en opnieuw installeren.
certerror-mitm-what-can-you-do-about-it-corporate = Als u zich op een zakelijk netwerk bevindt, kunt u contact opnemen met uw IT-afdeling.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Als u niet bekend bent met <b>{ $mitm }</b>, kan dit een aanval zijn en kunt u de website beter niet bezoeken.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Als u niet bekend bent met <b>{ $mitm }</b>, kan dit een aanval zijn, en is er niets wat u kunt doen om de website te bezoeken.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> heeft een beveiligingsbeleid met de naam HTTP Strict Transport Security (HSTS), wat betekent dat { -brand-short-name } alleen een beveiligde verbinding ermee kan maken. U kunt geen uitzondering toevoegen om deze website te bezoeken.
