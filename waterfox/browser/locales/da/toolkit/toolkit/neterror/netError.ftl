# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Problem med indlæsning af side
certerror-page-title = Advarsel: Mulig sikkerhedsrisiko
certerror-sts-page-title = Oprettede ikke forbindelse: Muligt sikkerhedsproblem
neterror-blocked-by-policy-page-title = Blokeret side
neterror-captive-portal-page-title = Login til netværk
neterror-dns-not-found-title = Serveren blev ikke fundet
neterror-malformed-uri-page-title = Ugyldig URL

## Error page actions

neterror-advanced-button = Avanceret…
neterror-copy-to-clipboard-button = Kopiér tekst til udklipsholder
neterror-learn-more-link = Læs mere…
neterror-open-portal-login-page-button = Åbn netværkets login-side
neterror-override-exception-button = Accepter risikoen og fortsæt
neterror-pref-reset-button = Gendan indstillinger til standard
neterror-return-to-previous-page-button = Gå tilbage
neterror-return-to-previous-page-recommended-button = Gå tilbage (anbefalet)
neterror-try-again-button = Prøv igen
neterror-add-exception-button = Fortsæt altid for dette websted
neterror-settings-button = Skift DNS-indstillinger
neterror-view-certificate-link = Vis certifikat
neterror-trr-continue-this-time = Fortsætte denne gang
neterror-disable-native-feedback-warning = Fortsæt altid

##

neterror-pref-reset = Det ser ud til, at dine indstillinger for netværkssikkerhed forårsager dette. Vil du gendanne til standard-indstillinger?
neterror-error-reporting-automatic = Indberet automatisk fejl som denne for at hjælpe { -vendor-short-name } med at identificere og blokere ondsindede websteder.

## Specific error messages

neterror-generic-error = { -brand-short-name } kan ikke indlæse denne side af en eller anden grund.
neterror-load-error-try-again = Siden kan være midlertidigt utilgængelig eller travlt optaget. Prøv igen om et øjeblik.
neterror-load-error-connection = Hvis du er ude af stand til at indlæse nogen sider overhovedet, undersøg da din computers netværksforbindelse.
neterror-load-error-firewall = Hvis din computer eller dit netværk er beskyttet af en firewall eller proxy, sørg da for at { -brand-short-name } har tilladelse til at tilgå nettet.
neterror-captive-portal = Dette netværk kræver, at du skal logge ind for at bruge internettet.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Ville du besøge <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Hvis du har indtasten adressen korrekt:</strong>
neterror-dns-not-found-hint-try-again = Prøv igen senere
neterror-dns-not-found-hint-check-network = Kontroller din internetforbindelse
neterror-dns-not-found-hint-firewall = Kontroller, om { -brand-short-name } har adgang til internettet (forbindelsen kan fx befinde sig bag en firewall)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } kan ikke beskytte din anmodning om dette websteds adresse gennem vores betroede DNS-resolver. Her er forklaringen:
neterror-dns-not-found-trr-third-party-warning2 = Du kan fortsætte med din standard DNS-resolver. Det kan dog betyde, at en tredjepart kan se, hvilke websteder du besøger.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } kunne ikke oprette forbindelse til { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = Oprettelse af forbindelse til { $trrDomain } tog længere tid end ventet.
neterror-dns-not-found-trr-offline = Du er ikke forbundet til internettet.
neterror-dns-not-found-trr-unknown-host2 = Webstedet blev ikke fundet af { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Der opstod et problem med { $trrDomain }.
neterror-dns-not-found-bad-trr-url = Ugyldig URL.
neterror-dns-not-found-trr-unknown-problem = Uventet problem.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } kan ikke beskytte din anmodning om dette websteds adresse gennem vores betroede DNS-resolver. Her er forklaringen:
neterror-dns-not-found-native-fallback-heuristic = DNS over HTTPS er blevet deaktiveret på dit netværk.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } kunne ikke oprette forbindelse til { $trrDomain }.

##

neterror-file-not-found-filename = Undersøg filnavnet for store bogstaver eller andre tastefejl.
neterror-file-not-found-moved = Undersøg om filen er blevet flyttet, omdøbt eller slettet
neterror-access-denied = Den kan være blevet slettet, flyttet, eller tilladelserne for filen kan forhindre adgang.
neterror-unknown-protocol = Du er måske nødt til at installere andet software for at åbne denne adresse.
neterror-redirect-loop = Dette problem kan nogle gange skyldes, at cookies er slået fra, eller modtagelse af cookies er blevet nægtet.
neterror-unknown-socket-type-psm-installed = Undersøg om dit system har Personal Security Manager installeret.
neterror-unknown-socket-type-server-config = Dette kan skyldes en ikke-standardopsætning af serveren.
neterror-not-cached-intro = Den forespurgte side er ikke tilgængelig i { -brand-short-name }' cache.
neterror-not-cached-sensitive = Af sikkerhedshensyn henter { -brand-short-name } ikke automatisk følsomme sider igen.
neterror-not-cached-try-again = Klik for at prøve at hente siden igen fra webstedet.
neterror-net-offline = Klik på “Prøv igen” for at skifte til online-tilstand og genindlæse siden.
neterror-proxy-resolve-failure-settings = Kontrollér proxy-indstillingerne, og vær sikker på, at de er korrekte.
neterror-proxy-resolve-failure-connection = Kontrollér om din computer har en fungerende netværksforbindelse.
neterror-proxy-resolve-failure-firewall = Hvis din computer eller dit netværk er beskyttet af en firewall eller proxy, så kontrollér, om { -brand-short-name }  har tilladelse til at tilgå nettet i firewallen eller proxyens indstillinger.
neterror-proxy-connect-failure-settings = Kontrollér proxy-indstillingerne, og vær sikker på, at de er korrekte.
neterror-proxy-connect-failure-contact-admin = Kontakt din netværks-administrator for at sikre dig, at proxyserveren fungerer.
neterror-content-encoding-error = Kontakt ejerne af webstedet omkring dette problem.
neterror-unsafe-content-type = Kontakt ejerne af webstedet omkring dette problem.
neterror-nss-failure-not-verified = Siden kunne ikke vises, da autenticiteten af de modtagne data ikke kunne bekræftes.
neterror-nss-failure-contact-website = Kontakt ejerne af webstedet omkring dette problem.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } har opdaget en mulig sikkerhedstrussel og fortsatte ikke til <b>{ $hostname }</b>. Hvis du besøger webstedet, kan angribere forsøge at stjæle informationer, som fx dine adgangskoder, mails eller oplysninger om dine betalingskort.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } har opdaget en mulig sikkerhedstrussel og fortsatte ikke til <b>{ $hostname }</b>, fordi webstedet kræver en sikker forbindelse.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } har opdaget et problem og fortsatte ikke til <b>{ $hostname }</b>. Webstedet er enten opsat forkert, eller også er uret i din computer indstillet forkert.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> er højst sandsynligt et sikkert websted, men der kan ikke oprettes en sikker forbindelse til det. Problemet skyldes programmet <b>{ $mitm }</b>, der enten er på din computer eller på dit netværk.
neterror-corrupted-content-intro = Siden, du forsøger at se, kan ikke vises, da der er fundet en fejl i overførslen af data.
neterror-corrupted-content-contact-website = Kontakt ejerne af webstedet omkring dette problem.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Avanceret info: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> bruger forældet sikkerheds-teknologi, der er sårbar overfor angreb. En angriber kan derfor nemt få adgang til information, som du troede var sikker. Webstedets administrator er nødt til at løse problemerne på serveren, før du kan besøge webstedet.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Fejlkode: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Din computer tror, at { DATETIME($now, dateStyle: "medium") } er den korrekte dato og tid, hvilket forhindrer { -brand-short-name } i at oprette en sikker forbindelse. For at besøge <b>{ $hostname }</b> skal du gå til dine systemindstillinger og opdatere din computers ur til den korrekte dato, tidszone og det korrekte klokkeslæt. Opdater derefter <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = Siden kan ikke vises, da der er fundet en fejl i netværksprotokollen.
neterror-network-protocol-error-contact-website = Kontakt ejerne af webstedet omkring dette problem.
certerror-expired-cert-second-para = Webstedets certifikat er sandsynligvis forældet, hvilket forhindrer { -brand-short-name } i at oprette en sikker forbindelse. Hvis du besøger webstedet, kan angribere forsøge at stjæle informationer, som fx dine adgangskoder, mails eller oplysninger om dine betalingskort.
certerror-expired-cert-sts-second-para = Webstedets certifikat er sandsynligvis forældet, hvilket forhindrer { -brand-short-name } i at oprette en sikker forbindelse.
certerror-what-can-you-do-about-it-title = Hvad kan du gøre?
certerror-unknown-issuer-what-can-you-do-about-it-website = Problemet skyldes sandsynligvis en opsætning på webstedet, og du kan i så fald ikke selv gøre noget for at løse det.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Hvis du befinder dig på et virksomhedsnetværk eller anvender antivirus, kan du kontakte supporten for at få hjælp. Du kan også prøve at give besked til webstedets ejer om problemet.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Uret i din computer er indstillet til { DATETIME($now, dateStyle: "medium") }. Åbn din computers systemindstillinger og undersøg, om dato, tidspunkt og tidszone er indstillet rigtigt. Genindlæs derefter <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Hvis din computer allerede er indstillet til det korrekte tidspunkt, er webstedet sandsynligvis opsat forkert, og det kan du ikke selv gøre noget ved. Du kan prøve at kontakte webstedets administrator for at gøre opmærksom på problemet.
certerror-bad-cert-domain-what-can-you-do-about-it = Problemet skyldes højst sandsynligt webstedet, og du kan ikke selv løse problemet. Du kan prøve at kontakte webstedets administrator for at gøre opmærksom på problemet.
certerror-mitm-what-can-you-do-about-it-antivirus = Hvis dit antivirus-program har en funktion, der skanner krypterede forbindelser (funktionen kaldes ofte “web scanning” eller “https scanning”), så kan du deaktivere funktionen. Hvis dét ikke virker, så kan du prøve at fjerne og geninstallere antivirus-programmet.
certerror-mitm-what-can-you-do-about-it-corporate = Hvis du befinder dig på et virksomhedsnetværk, så kan du kontakte IT-supporten for at få hjælp.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Hvis du ikke kender <b>{ $mitm }</b>, så kan dette være et angreb og du bør ikke fortsætte til webstedet.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Hvis du ikke kender<b>{ $mitm }</b>, så kan dette være et angreb, og du kan ikke gøre noget for at få adgang til webstedet.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> bruger en sikkerhedspolitik kaldet HTTP Strict Transport Security (HSTS), hvilket betyder at { -brand-short-name } kun kan oprette en sikker forbindelse til webstedet. Du kan ikke tilføje en undtagelse for at besøge webstedet.
