# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Stránku se nepodařilo načíst
certerror-page-title = Varování: možné bezpečnostní riziko
certerror-sts-page-title = Nepřipojeno: Možný bezpečnostní problém
neterror-blocked-by-policy-page-title = Zablokovaná stránka
neterror-captive-portal-page-title = Přihlásit se do sítě
neterror-dns-not-found-title = Server nenalezen
neterror-malformed-uri-page-title = Neplatná URL adresa

## Error page actions

neterror-advanced-button = Rozšířené…
neterror-copy-to-clipboard-button = Zkopírovat text do schránky
neterror-learn-more-link = Zjistit více…
neterror-open-portal-login-page-button = Otevřít přihlašovací stránku k síti
neterror-override-exception-button = Beru na vědomí a chci pokračovat
neterror-pref-reset-button = Obnovit výchozí nastavení
neterror-return-to-previous-page-button = Zpátky
neterror-return-to-previous-page-recommended-button = Zpátky (doporučeno)
neterror-try-again-button = Zkusit znovu
neterror-add-exception-button = Na tomto webu vždy pokračovat
neterror-settings-button = Změnit nastavení DNS
neterror-view-certificate-link = Zobrazit certifikát
neterror-trr-continue-this-time = Tentokrát pokračovat
neterror-disable-native-feedback-warning = Vždy pokračovat

##

neterror-pref-reset = Zdá se, že příčinou může být vaše nastavení zabezpečení. Chcete obnovit výchozí nastavení?
neterror-error-reporting-automatic =
    { -vendor-short-name.case-status ->
        [with-cases] Hlásit chyby jako je tato a pomoci tak { -vendor-short-name(case: "dat") } identifikovat a blokovat škodlivé stránky
       *[no-cases] Hlásit chyby jako je tato a pomoci tak organizaci { -vendor-short-name } identifikovat a blokovat škodlivé stránky
    }

## Specific error messages

neterror-generic-error = { -brand-short-name } nemůže tuto stránku načíst.
neterror-load-error-try-again = Server je dočasně nedostupný. Zkuste to prosím znovu za chvíli.
neterror-load-error-connection = Pokud se vám nezobrazují ani ostatní stránky, zkontrolujte síťové připojení svého počítače.
neterror-load-error-firewall = Pokud je váš počítač chráněn firewallem nebo proxy serverem, zkontrolujte, že má { -brand-short-name } přístup na internet.
neterror-captive-portal = Pro přístup k internetu se musíte nejdříve přihlásit k této síti.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Chtěli jste navštívit <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Pokud jste adresu zadali správně:</strong>
neterror-dns-not-found-hint-try-again = Zkuste to znovu
neterror-dns-not-found-hint-check-network = Zkontrolujte připojení k síti
neterror-dns-not-found-hint-firewall = Zkontrolujte, zda má { -brand-short-name } povolený přístup na web (může být omezen firewallem).

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } nemůže ochránit vaše požadavky pro tento server pomocí důvěryhodného překladače DNS z těchto důvodů:
neterror-dns-not-found-trr-third-party-warning2 = Můžete pokračovat s použitím svého výchozího překladače DNS. Třetí strany pak ale mohou zjistit, jaké webové stránky navštěvujete.
neterror-dns-not-found-trr-only-could-not-connect =
    { -brand-short-name.case-status ->
        [with-cases] { -brand-short-name(case: "dat") } se nepodařilo připojit k DNS překladači { $trrDomain }.
       *[no-cases] Aplikaci { -brand-short-name } se nepodařilo připojit k DNS překladači { $trrDomain }.
    }
neterror-dns-not-found-trr-only-timeout = Připojení k DNS překladači { $trrDomain } trvalo déle, než se očekávalo.
neterror-dns-not-found-trr-offline = Nejste připojeni k internetu.
neterror-dns-not-found-trr-unknown-host2 = Tento server nebyl překladačem { $trrDomain } nalezen.
neterror-dns-not-found-trr-server-problem = Vyskytl se problém s DNS překladačem { $trrDomain }.
neterror-dns-not-found-bad-trr-url = Neplatná URL adresa.
neterror-dns-not-found-trr-unknown-problem = Neočekávaný problém.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } nemůže ochránit vaše požadavky pro tento server pomocí důvěryhodného překladače DNS z těchto důvodů:
neterror-dns-not-found-native-fallback-heuristic = DNS over HTTPS je ve vaší síti zakázáno.
neterror-dns-not-found-native-fallback-not-confirmed2 =
    { -brand-short-name.case-status ->
        [with-cases] { -brand-short-name(case: "dat") } se nepodařilo připojit k DNS překladači { $trrDomain }.
       *[no-cases] Aplikaci { -brand-short-name } se nepodařilo připojit k DNS překladači { $trrDomain }.
    }

##

neterror-file-not-found-filename = Zkontrolujte, že je název souboru napsán správně, a to včetně velikosti písmen.
neterror-file-not-found-moved = Zkontrolujte, že soubor nebyl přesunut, přejmenován nebo smazán.
neterror-access-denied = Možná byl smazán, přesunut nebo jeho oprávnění zabraňují přístupu.
neterror-unknown-protocol = Pro otevření této adresy budete patrně potřebovat nainstalovat další software.
neterror-redirect-loop = Tento problém může být způsoben zakázáním nebo odmítnutím cookies.
neterror-unknown-socket-type-psm-installed = Zkontrolujte, že je ve vašem systému nainstalován Personal Security Manager.
neterror-unknown-socket-type-server-config = Tato chyba může být také způsobena nestandardní konfigurací serveru.
neterror-not-cached-intro =
    { -brand-short-name.case-status ->
        [with-cases] Požadovaný dokument už není dostupný v mezipaměti { -brand-short-name(case: "gen") }.
       *[no-cases] Požadovaný dokument už není dostupný v mezipaměti aplikace { -brand-short-name }.
    }
neterror-not-cached-sensitive = Z bezpečnostních důvodů { -brand-short-name } automaticky nestahuje důvěrné dokumenty.
neterror-not-cached-try-again = Pro opětovné stažení dokumentu z webového serveru klepněte na tlačítko „Zkusit znovu“.
neterror-net-offline = Pro přechod do režimu online a opětovné načtení stránky klepněte na tlačítko „Zkusit znovu“.
neterror-proxy-resolve-failure-settings = Zkontrolujte nastavení proxy serveru.
neterror-proxy-resolve-failure-connection = Zkontrolujte síťové připojení svého počítače.
neterror-proxy-resolve-failure-firewall = Pokud je váš počítač chráněn firewallem nebo proxy serverem, zkontrolujte, že má { -brand-short-name } přístup na internet.
neterror-proxy-connect-failure-settings = Zkontrolujte nastavení proxy serveru.
neterror-proxy-connect-failure-contact-admin = Kontaktujte správce vaší sítě, jestli je proxy server v provozu.
neterror-content-encoding-error = Kontaktujte prosím vlastníky webového serveru a informujte je o tomto problému.
neterror-unsafe-content-type = Kontaktujte prosím vlastníky webového serveru a informujte je o tomto problému.
neterror-nss-failure-not-verified = Požadovanou stránku nelze zobrazit, protože nelze ověřit autenticitu přijatých dat.
neterror-nss-failure-contact-website = Kontaktujte prosím vlastníky webového serveru a informujte je o tomto problému.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zjistil možné ohrožení bezpečnosti a stránku na serveru <b>{ $hostname }</b> nenačetl. Pokud se přesto rozhodnete stránku navštívit, útočníci se mohou pokusit zcizit vaše údaje jako např. hesla, e-mailové adresy nebo údaje o platební kartě.
        [feminine] { -brand-short-name } zjistila možné ohrožení bezpečnosti a stránku na serveru <b>{ $hostname }</b> nenačetla. Pokud se přesto rozhodnete stránku navštívit, útočníci se mohou pokusit zcizit vaše údaje jako např. hesla, e-mailové adresy nebo údaje o platební kartě.
        [neuter] { -brand-short-name } zjistilo možné ohrožení bezpečnosti a stránku na serveru <b>{ $hostname }</b> nenačetlo. Pokud se přesto rozhodnete stránku navštívit, útočníci se mohou pokusit zcizit vaše údaje jako např. hesla, e-mailové adresy nebo údaje o platební kartě.
       *[other] Aplikace { -brand-short-name } zjistila možné ohrožení bezpečnosti a stránku na serveru <b>{ $hostname }</b> nenačetla. Pokud se přesto rozhodnete stránku navštívit, útočníci se mohou pokusit zcizit vaše údaje jako např. hesla, e-mailové adresy nebo údaje o platební kartě.
    }
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zjistil možné ohrožení bezpečnosti a stránku na serveru <b>{ $hostname }</b> nenačetl, protože tato stránka vyžaduje zabezpečené spojení.
        [feminine] { -brand-short-name } zjistila možné ohrožení bezpečnosti a stránku na serveru <b>{ $hostname }</b> nenačetla, protože tato stránka vyžaduje zabezpečené spojení.
        [neuter] { -brand-short-name } zjistilo možné ohrožení bezpečnosti a stránku na serveru <b>{ $hostname }</b> nenačetlo, protože tato stránka vyžaduje zabezpečené spojení.
       *[other] Aplikace { -brand-short-name } zjistila možné ohrožení bezpečnosti a stránku na serveru <b>{ $hostname }</b> nenačetla, protože tato stránka vyžaduje zabezpečené spojení.
    }
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zjistil problém a stránku na serveru <b>{ $hostname }</b> nenačetl. Server je buď špatně nastaven a nebo hodiny ve vašem počítači nejdou správně.
        [feminine] { -brand-short-name } zjistila problém a stránku na serveru <b>{ $hostname }</b> nenačetla. Server je buď špatně nastaven a nebo hodiny ve vašem počítači nejdou správně.
        [neuter] { -brand-short-name } zjistilo problém a stránku na serveru <b>{ $hostname }</b> nenačetlo. Server je buď špatně nastaven a nebo hodiny ve vašem počítači nejdou správně.
       *[other] Aplikace { -brand-short-name } zjistila problém a stránku na serveru <b>{ $hostname }</b> nenačetla. Server je buď špatně nastaven a nebo hodiny ve vašem počítači nejdou správně.
    }
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> je pravděpodobně bezpečný server, ale nelze s ním navázat zabezpečené spojení. Tento problém způsobuje <b>{ $mitm }</b>, což je buď program ve vašem počítači, nebo ve vaší síti.
neterror-corrupted-content-intro = Požadovanou stránku nelze zobrazit, protože při přenosu dat došlo k chybě.
neterror-corrupted-content-contact-website = Kontaktujte prosím vlastníky webového serveru a informujte je o tomto problému.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Podrobné informace: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> používá technologii, která je zastaralá a zranitelná vůči útokům. Útočník může snadno získat informace, které považujete za zabezpečené. Správce serveru musí server opravit, než budete moci stránku navštívit.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Kód chyby: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error =
    { -brand-short-name.case-status ->
        [with-cases] Datum ve vašem počítači je nesprávně nastaveno na { DATETIME($now, dateStyle: "medium") }, což brání { -brand-short-name(case: "dat") } v navázání zabezpečeného spojení. Abyste mohli stránku na serveru <b>{ $hostname }</b> navštívit, nastavte v systémových hodinách správné datum, čas a časové pásmo a znovu načtěte tuto stránku.
       *[no-cases] Datum ve vašem počítači je nesprávně nastaveno na { DATETIME($now, dateStyle: "medium") }, což brání aplikaci { -brand-short-name } v navázání zabezpečeného spojení. Abyste mohli stránku na serveru <b>{ $hostname }</b> navštívit, nastavte v systémových hodinách správné datum, čas a časové pásmo a znovu načtěte tuto stránku.
    }
neterror-network-protocol-error-intro = Požadovanou stránku nelze zobrazit, protože došlo k chybě v síťovém protokolu.
neterror-network-protocol-error-contact-website = Kontaktujte prosím vlastníky webového serveru a informujte je o tomto problému.
certerror-expired-cert-second-para =
    { -brand-short-name.case-status ->
        [with-cases] Pravděpodobně stránce vypršela platnost certifikátu, což brání { -brand-short-name(case: "dat") } v navázání zabezpečeného spojení. Pokud se přesto rozhodnete stránku navštívit, útočníci se mohou pokusit získat vaše údaje jako např. hesla, e-mailové adresy nebo údaje o platební kartě.
       *[no-cases] Pravděpodobně stránce vypršela platnost certifikátu, což brání aplikaci { -brand-short-name } v navázání zabezpečeného spojení. Pokud se přesto rozhodnete stránku navštívit, útočníci se mohou pokusit získat vaše údaje jako např. hesla, e-mailové adresy nebo údaje o platební kartě.
    }
certerror-expired-cert-sts-second-para =
    { -brand-short-name.case-status ->
        [with-cases] Pravděpodobně stránce vypršela platnost certifikátu, což brání { -brand-short-name(case: "dat") } v navázání zabezpečeného spojení.
       *[no-cases] Pravděpodobně stránce vypršela platnost certifikátu, což brání aplikaci { -brand-short-name } v navázání zabezpečeného spojení.
    }
certerror-what-can-you-do-about-it-title = Co s tím můžete dělat?
certerror-unknown-issuer-what-can-you-do-about-it-website = Příčina tohoto problému je pravděpodobně na straně serveru a vy ji bohužel nemůžete odstranit.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Pokud jste připojení do firemní sítě nebo používáte antivirový program, můžete se obrátit na oddělení technické podpory. Také můžete o problému informovat správce webu.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Datum ve vašem počítači je nastaveno na { DATETIME($now, dateStyle: "medium") }. Zkontrolujte prosím v systémovém nastavení, že máte nastavené správné datum, čas a časové pásmo, a pak stránku <b>{ $hostname }</b> načtěte znovu.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Pokud máte vše nastavené správně, je pravděpodobně problém na straně serveru a tak ho bohužel nemůžete vyřešit. Můžete o tom pouze informovat správce webu.
certerror-bad-cert-domain-what-can-you-do-about-it = Příčina tohoto problému je pravděpodobně na straně serveru a vy ji bohužel nemůžete odstranit. Můžete o tomto problému informovat správce webu.
certerror-mitm-what-can-you-do-about-it-antivirus = Pokud váš antivirový program obsahuje funkci, která kontroluje šifrovaná spojení (často nazýváno jako „skenování webu“ nebo „skenování https“), můžete tuto funkci vypnout. Pokud to nepomůže, můžete zkusit antivirový program odstranit nebo přeinstalovat.
certerror-mitm-what-can-you-do-about-it-corporate = Pokud se připojujete z firemní sítě, můžete se obrátit na vaše IT oddělení.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Pokud <b>{ $mitm }</b> neznáte, může jít i o útok a neměli byste pokračovat v pokusech o připojení k tomuto serveru.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Pokud <b>{ $mitm }</b> neznáte, může jít i o útok a bohužel pro bezpečné připojení k tomuto serveru nemůžete udělat nic.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = Server <b>{ $hostname }</b> má nastaveno bezpečnostní pravidlo HTTP Strict Transport Security (HSTS), které vynucuje používání pouze zabezpečeného spojení. Pro připojení k této stránce nelze udělit výjimku.
