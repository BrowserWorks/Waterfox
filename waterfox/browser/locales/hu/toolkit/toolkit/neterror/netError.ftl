# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Probléma az oldal betöltése közben
certerror-page-title = Figyelmeztetés: Lehetséges biztonsági kockázat következik
certerror-sts-page-title = Nem kapcsolódott: lehetséges biztonsági probléma
neterror-blocked-by-policy-page-title = Blokkolt oldal
neterror-captive-portal-page-title = Bejelentkezés a hálózatba
neterror-dns-not-found-title = A kiszolgáló nem található
neterror-malformed-uri-page-title = Érvénytelen URL

## Error page actions

neterror-advanced-button = Speciális…
neterror-copy-to-clipboard-button = Szöveg másolása a vágólapra
neterror-learn-more-link = További tudnivalók…
neterror-open-portal-login-page-button = Hálózati bejelentkezés oldal megnyitása
neterror-override-exception-button = Kockázat elfogadása és továbblépés
neterror-pref-reset-button = Alapértelmezett beállítások visszaállítása
neterror-return-to-previous-page-button = Ugrás vissza
neterror-return-to-previous-page-recommended-button = Visszalépés (ajánlott)
neterror-try-again-button = Próbálja újra
neterror-add-exception-button = Folytatás mindig ezen az oldalon
neterror-settings-button = DNS beállítások módosítása
neterror-view-certificate-link = Tanúsítvány megtekintése
neterror-trr-continue-this-time = Most folytassa
neterror-disable-native-feedback-warning = Folytatás mindig

##

neterror-pref-reset = Úgy tűnik, ezt a hálózat biztonsági beállításai okozhatják. Szeretné helyreállítani az alapbeállításokat?
neterror-error-reporting-automatic = Az ilyen hibák jelentése segít a { -vendor-short-name(ending: "accented") }nak a rosszindulatú oldalak azonosításában és blokkolásában

## Specific error messages

neterror-generic-error = A { -brand-short-name } nem tudja betölteni az oldalt valamilyen okból.
neterror-load-error-try-again = A webhely ideiglenesen nem érhető el vagy túlterhelt. Próbálja újra pár perc múlva.
neterror-load-error-connection = Ha semmilyen oldalt nem tud letölteni, ellenőrizze a számítógépe hálózati kapcsolatát.
neterror-load-error-firewall = Ha a számítógépet vagy a hálózatot tűzfal vagy proxy védi, ellenőrizze, hogy a { -brand-short-name } számára engedélyezett-e a webhozzáférés.
neterror-captive-portal = Az internet elérése előtt be kell jelentkezni a hálózatra.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = Erre gondolt: <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Ha a megfelelő címet adta meg, a következőket teheti:</strong>
neterror-dns-not-found-hint-try-again = Próbálja meg újra később
neterror-dns-not-found-hint-check-network = Ellenőrizze a hálózati kapcsolatot
neterror-dns-not-found-hint-firewall = Ellenőrizze, hogy a { -brand-short-name } jogosult-e az internet elérésére (lehet, hogy csatlakozik, de tűzfal mögött van)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = A { -brand-short-name } nem tudja megvédeni a webhely címére vonatkozó kérését a megbízható DNS-feloldónkon keresztül. Ennek ez az oka:
neterror-dns-not-found-trr-third-party-warning2 = Folytathatja az alapértelmezett DNS-feloldóval. Előfordulhat azonban, hogy egy harmadik fél láthatja, hogy milyen webhelyeket keres fel.
neterror-dns-not-found-trr-only-could-not-connect = A { -brand-short-name } nem tudott csatlakozni a következő domainhoz: { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = A következőhöz kapcsolódás a vártnál tovább tartott: { $trrDomain }.
neterror-dns-not-found-trr-offline = Nem csatlakozik az internethez.
neterror-dns-not-found-trr-unknown-host2 = Ezt a webhelyet nem találta meg a(z) { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Probléma lépett fel a következő domainen: { $trrDomain }.
neterror-dns-not-found-bad-trr-url = Érvénytelen webcím.
neterror-dns-not-found-trr-unknown-problem = Váratlan probléma.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = A { -brand-short-name } nem tudja megvédeni a webhely címére vonatkozó kérését a megbízható DNS-feloldónkon keresztül. Ennek ez az oka:
neterror-dns-not-found-native-fallback-heuristic = A HTTP-n keresztüli DNS le van tiltva a hálózatán.
neterror-dns-not-found-native-fallback-not-confirmed2 = A { -brand-short-name } nem tudott csatlakozni a következő domainhoz: { $trrDomain }.

##

neterror-file-not-found-filename = Ellenőrizze a fájlnevet, hogy jól írta-e.
neterror-file-not-found-moved = Ellenőrizze, hogy a fájlt áthelyezték-e, átnevezték-e vagy eltávolították-e.
neterror-access-denied = Lehet hogy törölve lett, át lett helyezve, vagy a fájljogosultságok megakadályozzák a hozzáférést.
neterror-unknown-protocol = Lehet, hogy egyéb szoftvert kell telepítenie a cím megnyitásához.
neterror-redirect-loop = Ez a probléma néha a letiltott vagy visszautasított sütik miatt jelentkezik.
neterror-unknown-socket-type-psm-installed = Ellenőrizze, hogy a rendszerre telepítve van-e a Personal Security Manager modul.
neterror-unknown-socket-type-server-config = A hibát okozhatja a kiszolgáló nem szabványos beállítása is.
neterror-not-cached-intro = A kért dokumentum nem érhető el a { -brand-short-name } gyorsítótárában.
neterror-not-cached-sensitive = Biztonsági okokból a { -brand-short-name } nem kéri le automatikusan az érzékeny adatokat tartalmazó dokumentumokat.
neterror-not-cached-try-again = Kattintson a „Próbálja újra” gombra, hogy újra lekérje a dokumentumot a webhelyről.
neterror-net-offline = Nyomja meg a „Próbálja újra” gombot az online módhoz és az oldal újratöltéséhez.
neterror-proxy-resolve-failure-settings = Ellenőrizze a proxybeállításokat, hogy helyesek-e.
neterror-proxy-resolve-failure-connection = Ellenőrizze, hogy a számítógép hálózati kapcsolata működik-e.
neterror-proxy-resolve-failure-firewall = Ha a számítógépet vagy a hálózatot tűzfal vagy proxy védi, ellenőrizze, hogy a { -brand-short-name } számára engedélyezett-e a webhozzáférés.
neterror-proxy-connect-failure-settings = Ellenőrizze a proxybeállításokat, hogy helyesek-e.
neterror-proxy-connect-failure-contact-admin = Kérdezze meg a hálózati rendszergazdától, hogy a proxykiszolgáló működik-e.
neterror-content-encoding-error = Értesítse a webhely tulajdonosait erről a problémáról.
neterror-unsafe-content-type = Értesítse a webhely tulajdonosait erről a problémáról.
neterror-nss-failure-not-verified = A megtekinteni kívánt oldal nem jeleníthető meg, mert a kapott adatok hitelessége nem ellenőrizhető.
neterror-nss-failure-contact-website = Lépjen kapcsolatba a webhely üzemeltetőjével, és értesítse a problémáról.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = A { -brand-short-name } egy lehetséges biztonsági kockázatot észlelt, és nem lépett tovább a(z) <b>{ $hostname }</b> oldalra. Ha felkeresi ezt az oldalt, akkor támadók megpróbálhatják ellopni a jelszavait, e-mailjeit vagy bankkártyaadatait.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = A { -brand-short-name } egy lehetséges biztonsági kockázatot észlelt, és nem lépett tovább a(z) <b>{ $hostname }</b> oldalra, mert ez a webhely biztonságos kapcsolatot igényel.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = A { -brand-short-name } egy problémát észlelt, és nem lépett tovább a(z) <b>{ $hostname }</b> oldalra. Lehet, hogy a webhely van rosszul beállítva vagy hibás az Ön számítógépének órabeállítása.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = A(z) <b>{ $hostname }</b> valószínűleg egy biztonságos oldal, de nem hozható létre biztonságos kapcsolat. A problémát <b>{ $mitm }</b> okozza, amely valószínűleg egy a számítógépén vagy a hálózatán lévő szoftver.
neterror-corrupted-content-intro = A megtekinteni kívánt oldal nem jeleníthető meg, mert az adatátvitel közben hiba történt.
neterror-corrupted-content-contact-website = Lépjen kapcsolatba a webhely üzemeltetőjével, és értesítse a problémáról.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Speciális információ: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> olyan biztonsági technológiát használ, amely elavult, és sérülékeny a támadásokkal szemben. Egy támadó könnyen felfedhet olyan információkat, amelyeket biztonságosnak gondol. A weboldal rendszergazdájának ki kell javítania a kiszolgálót, mielőtt meglátogathatja az oldalt.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Hibakód: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = A számítógépe szerint a pontos idő { DATETIME($now, dateStyle: "medium") }, és ez megakadályozza, hogy a { -brand-short-name } biztonságosan kapcsolódjon. A(z) <b>{ $hostname }</b> felkereséséhez frissítse a rendszerbeállításokban a számítógép óráját a jelenlegi dátumra, időre és időzónára, és frissítse a(z) <b>{ $hostname }</b> oldalt.
neterror-network-protocol-error-intro = A megtekinteni kívánt oldal nem jeleníthető meg, mert hiba észlelhető a hálózati protokollban.
neterror-network-protocol-error-contact-website = Lépjen kapcsolatba a webhely tulajdonosaival, hogy tájékoztassa őket a problémáról.
certerror-expired-cert-second-para = A webhely tanúsítványa valószínűleg lejárt, ami megakadályozza a { -brand-short-name } biztonságos csatlakozását. Ha meglátogatja ezt a webhelyet, támadók megpróbálhatnak ellopni olyan információkat, mint jelszavak, e-mailek vagy hitelkártyaadatok.
certerror-expired-cert-sts-second-para = A webhely tanúsítványa valószínűleg lejárt, ami megakadályozza a { -brand-short-name } biztonságos csatlakozását.
certerror-what-can-you-do-about-it-title = Mit tehet?
certerror-unknown-issuer-what-can-you-do-about-it-website = A probléma valószínűleg a weboldallal van, és semmit sem tehet a megoldása érdekében.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Ha vállalati hálózaton van, vagy antivírus szoftvert használ, akkor segítségért felkeresheti a terméktámogatási csoportot. A weboldal rendszergazdáját is értesítheti a problémáról.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = A számítógép órája erre van állítva: { DATETIME($now, dateStyle: "medium") }. Győződjön meg róla, hogy a helyes dátum, idő és időzóna van beállítva a rendszerbeállításokban, majd töltse újra a(z) <b>{ $hostname }</b> oldalt.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Ha már a helyes időre van állítva az óra, akkor valószínűleg a webhely van rosszul beállítva, és semmit sem tehet a probléma megoldása érdekében. Értesítheti a webhely rendszergazdáját a problémáról.
certerror-bad-cert-domain-what-can-you-do-about-it = A probléma valószínűleg a weboldallal van, és semmit sem tehet a megoldása érdekében. Értesítheti a weboldal rendszergazdáját a problémáról.
certerror-mitm-what-can-you-do-about-it-antivirus = Ha a víruskereső szoftvere olyan funkciót tartalmaz, amely titkosított kapcsolatokat ellenőriz (gyakran „webes szkennelés” vagy „https szkennelés” néven szerepel), akkor letilthatja ezt a funkciót. Ha ez nem működik, akkor eltávolíthatja és újratelepítheti a víruskereső szoftvert.
certerror-mitm-what-can-you-do-about-it-corporate = Ha vállalati hálózaton tartózkodik, akkor forduljon az IT részlegéhez.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Ha nem tudja mi az a <b>{ $mitm }</b>, akkor ez egy támadás lehet, és nem szabad továbblépnie a webhelyre.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Ha nem tudja mi az a <b>{ $mitm }</b>, akkor ez egy támadás lehet, és semmit sem tehet, hogy hozzáférjen a webhelyhez.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = A(z) <b>{ $hostname }</b> oldal a HTTP Strict Transport Security (HSTS) nevű biztonsági házirendet használja, amely azt jelenti, hogy a { -brand-short-name } csak biztonságosan kapcsolódhat hozzá. Nem adhat hozzá kivételt, hogy felkeresse ezt az oldalt.
