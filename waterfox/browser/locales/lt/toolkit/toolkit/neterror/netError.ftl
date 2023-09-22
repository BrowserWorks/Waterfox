# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Nepavyko įkelti tinklalapio
certerror-page-title = Dėmesio: galima saugumo rizika
certerror-sts-page-title = Neprisijungta: galima saugumo problema
neterror-blocked-by-policy-page-title = Uždraustas puslapis
neterror-captive-portal-page-title = Prisijungti prie tinklo
neterror-dns-not-found-title = Serveris nerastas
neterror-malformed-uri-page-title = Neteisingas URL

## Error page actions

neterror-advanced-button = Papildomai…
neterror-copy-to-clipboard-button = Kopijuoti tekstą į iškarpinę
neterror-learn-more-link = Sužinoti daugiau…
neterror-open-portal-login-page-button = Atverti prisijungimo tinklalapį
neterror-override-exception-button = Priimti riziką ir tęsti
neterror-pref-reset-button = Atstatyti numatytąsias nuostatas
neterror-return-to-previous-page-button = Eiti atgal
neterror-return-to-previous-page-recommended-button = Grįžti (rekomenduojama)
neterror-try-again-button = Bandyti dar kartą
neterror-view-certificate-link = Rodyti liudijimą

##

neterror-pref-reset = Panašu, kad taip galėjo nutikti dėl jūsų tinklo saugumo nuostatų. Ar norite atstatyti numatytąsias reikšmes?
neterror-error-reporting-automatic = Pranešdami apie tokias klaidas kaip ši, padėsite „{ -vendor-short-name }i“ nustatyti ir užblokuoti kenksmingas svetaines

## Specific error messages

neterror-generic-error = „{ -brand-short-name }“ nepavyko įkelti šio tinklalapio dėl nežinomos priežasties.

neterror-load-error-try-again = Ši svetainė laikinai nepasiekiama arba yra per daug apkrauta. Šiek tiek palaukite ir bandykite prisijungti iš naujo.
neterror-load-error-connection = Jei nepavyksta įkelti ir kitų tinklalapių, patikrinkite kompiuterio ryšį su tinklu.
neterror-load-error-firewall = Jei jūsų kompiuteris ar tinklas apsaugotas užkarda arba jungiasi per įgaliotąjį serverį, tai įsitikinkite, kad „{ -brand-short-name }“ leidžiama pasiekti saityną.

neterror-captive-portal = Turite prisijungti prie šio tinklo, kad galėtumėte naudotis internetu.

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

##

neterror-file-not-found-filename = Patikrinkite, ar failo varde nėra rinkimo klaidų, pvz., didžiosios raidės pakeistos mažosiomis.
neterror-file-not-found-moved = Patikrinkite, ar failas nebuvo perkeltas, pervardytas ar pašalintas.

neterror-access-denied = Jis galėjo būti pašalintas, perkeltas arba priėjimą riboja failo leidimai.

neterror-unknown-protocol = Gali būti, kad šiam adresui atverti reikia įdiegti papildomą programinę įrangą.

neterror-redirect-loop = Ši klaida galėjo įvykti dėl to, kad naršyklė nepriima svetainės slapukų.

neterror-unknown-socket-type-psm-installed = Įsitikinkite, kad į jūsų sistemą yra įdiegta asmeninio saugumo tvarkytuvė.
neterror-unknown-socket-type-server-config = Ši klaida galėjo įvykti dėl nestandartinės serverio konfigūracijos.

neterror-not-cached-intro = Prašomo dokumento „{ -brand-short-name }“ podėlyje nėra.
neterror-not-cached-sensitive = Saugumo sumetimais „{ -brand-short-name }“ jautrių dokumentų automatiškai iš naujo neatsiunčia.
neterror-not-cached-try-again = Jeigu norite dokumentą iš svetainės atsiųsti iš naujo, spustelėkite „Bandyti dar kartą“.

neterror-net-offline = Spustelėkite „Bandyti dar kartą“, kad būtų prisijungta prie tinklo ir pabandyta įkelti tinklalapį iš naujo.

neterror-proxy-resolve-failure-settings = Patikrinkite, ar naršyklėje nurodytos teisingos įgaliotojo serverio nuostatos.
neterror-proxy-resolve-failure-connection = Patikrinkite, ar yra ryšys tarp jūsų kompiuterio ir tinklo.
neterror-proxy-resolve-failure-firewall = Jei jūsų kompiuteris ar tinklas apsaugotas užkarda arba jungiamasi per įgaliotąjį serverį, tai įsitikinkite, kad naršyklei „{ -brand-short-name }“ leidžiama pasiekti saityną.

neterror-proxy-connect-failure-settings = Patikrinkite, ar naršyklėje nurodytos teisingos įgaliotojo serverio nuostatos.
neterror-proxy-connect-failure-contact-admin = Jei norite sužinoti, ar įgaliotasis serveris veikia korektiškai, kreipkitės į sistemos administratorių.

neterror-content-encoding-error = Prašome pranešti svetainės savininkams apie šią problemą.

neterror-unsafe-content-type = Prašome pranešti svetainės savininkams apie šią problemą.

neterror-nss-failure-not-verified = Tinklalapis, kurį bandote atverti, negali būti parodytas, nes nepavyko patikrinti gautų duomenų autentiškumo.
neterror-nss-failure-contact-website = Prašom pranešti apie šią problemą svetainės savininkams.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = „{ -brand-short-name }“ aptiko galimą saugumo grėsmę ir neįkėlė <b>{ $hostname }</b>. Jei apsilankysite šioje svetainėje, piktavaliai gali bandyti pavogti jūsų slaptažodžius, el. laiškus, bankininkystės duomenis.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = „{ -brand-short-name }“ aptiko galimą saugumo grėsmę ir neįkėlė <b>{ $hostname }</b>, nes ši svetainė reikalauja saugaus ryšio.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = „{ -brand-short-name }“ aptiko problemą ir neįkėlė <b>{ $hostname }</b>. Ši svetainė gali būti netinkamai sukonfigūruota, arba jūsų kompiuterio laikrodis yra netinkamai nustatytas.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> greičiausiai yra saugi svetainė, tačiau nepavyko užmegzti saugaus ryšio. Šią problemą sukėlė „<b>{ $mitm }</b>“, jūsų kompiuteryje arba tinkle esanti programinė įranga.

neterror-corrupted-content-intro = Tinklalapio, kurį bandote atverti, parodyti negalima, nes perduodant duomenis įvyko klaida.
neterror-corrupted-content-contact-website = Siūlome susisiekti su svetainės savininkais ar valdytojais ir pranešti jiems apie šią problemą.

# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Papildoma informacija: SSL_ERROR_UNSUPPORTED_VERSION

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> naudoja saugumo technologiją, kuri yra pasenusi ir pažeidžiama. Piktavalis lengvai galėtų pamatyti informaciją, kuri jums atrodė saugi. Kol svetainės administratorius jos nesutvarkys, negalėsite į šią svetainę užeiti.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Klaidos kodas: NS_ERROR_NET_INADEQUATE_SECURITY

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Jūsų kompiuteris sako, kad yra dabar yra { DATETIME($now, dateStyle: "medium") }, kas neleidžia „{ -brand-short-name }“ užmegzti saugaus ryšio. Norėdami aplankyti <b>{ $hostname }</b>, atnaujinkite savo kompiuterio laikrodį, kad rodytų teisingą esamą datą, laiką ir laiko juostą, ir įkelkite <b>{ $hostname }</b> iš naujo.

neterror-network-protocol-error-intro = Tinklalapis, kurį bandote atverti, negali būti įkeltas dėl tinklo protokole aptiktos klaidos.
neterror-network-protocol-error-contact-website = Susisiekite su svetainės prižiūrėtojais ir praneškite apie šią problemą.

certerror-expired-cert-second-para = Tikėtina, kad svetainės liudijimas baigė galioti, todėl „{ -brand-short-name }“ negali užmegzti saugaus ryšio. Jei apsilankysite šioje svetainėje, piktavaliai gali bandyti pavogti jūsų slaptažodžius, el. laiškus, bankininkystės duomenis.
certerror-expired-cert-sts-second-para = Tikėtina, kad svetainės liudijimas baigė galioti, todėl „{ -brand-short-name }“ negali užmegzti saugaus ryšio.

certerror-what-can-you-do-about-it-title = Ką dėl to galima padaryti?

certerror-unknown-issuer-what-can-you-do-about-it-website = Problema greičiausiai yra su svetaine, ir jūs nieko negalite padaryti.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Jei esate įmonės vidiniame tinkle, arba naudojatės antivirusine programa, galite paprašyti pagalbos iš aptarnavimo skyriaus. Galite pranešti apie problemą ir svetainės prižiūrėtojui.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = Jūsų kompiuterio laikrodis rodo { DATETIME($now, dateStyle: "medium") }. Įsitikinkite, kad jūsų kompiuterio data, laikas ir laiko juosta yra tinkamai nustatyti, ir įkelkite <b>{ $hostname }</b> iš naujo.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Jeigu jūsų kompiuterio laikas jau yra geras, ši svetainė gali būti netinkamai sukonfigūruota, tad patys nieko negalite padaryti. Galite apie šią problemą pranešti svetainės prižiūrėtojui.

certerror-bad-cert-domain-what-can-you-do-about-it = Problema greičiausiai yra su svetaine, ir jūs nieko negalite padaryti. Galite pranešti apie problemą svetainės prižiūrėtojui.

certerror-mitm-what-can-you-do-about-it-antivirus = Jeigu jūsų antivirusinė programa turi funkciją, kuri tikrina užšifruotus susijungimus (dažnai vadinama „saityno skenavimu“ arba „https skenavimu“), galite ją išjungti. Jei tai nepadės, galite pašalinti antivirusinę programą ir įdiegti ją iš naujo.
certerror-mitm-what-can-you-do-about-it-corporate = Jeigu esate įmonės tinkle, galite susisiekti su savo IT skyriumi.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Jeigu neatpažįstate „<b>{ $mitm }</b>“, tai gali būti apgaulė ir neturėtumėte bandyti atverti šios svetainės.

# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Jeigu neatpažįstate „<b>{ $mitm }</b>“, tai gali būti apgaulė ir negalite nieko padaryti, kad atvertumėte šią svetainę.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> turi saugumo nuostatą, kuri vadinasi „HTTP Strict Transport Security“ (HSTS), ir reiškia, kad „{ -brand-short-name }“ gali jungtis tik saugiu ryšiu. Jūs negalite sukurti išimties, kad aplankytumėte šią svetainę.
