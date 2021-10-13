# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Fiók beállítása

## Header

account-setup-title = Meglévő e-mail fiók beállítása
account-setup-description =
    A jelenlegi e-mail-címe használatához ki kell töltenie a hitelesítő adatait.<br/>
    A { -brand-product-name } automatikusan megkeresi a működő és ajánlott kiszolgálóbeállításokat.
account-setup-secondary-description = A { -brand-product-name } automatikusan megkeresi a kiszolgáló működő és ajánlott beállításait.
account-setup-success-title = Fiók sikeresen létrehozva
account-setup-success-description = Most már használhatja ezt a fiókot a { -brand-short-name }del.
account-setup-success-secondary-description = A kapcsolódó szolgáltatások összekapcsolásával, és a fiók speciális beállításainak konfigurálásával javíthatja a felhasználói élményt.

## Form fields

account-setup-name-label = A teljes neve
    .accesskey = n
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Gipsz Jakab
account-setup-name-info-icon =
    .title = Így fog megjelenni a neve
account-setup-name-warning-icon =
    .title = { account-setup-name-warning }
account-setup-email-label = E-mail cím
    .accesskey = E
account-setup-email-input =
    .placeholder = gipsz.jakab@example.com
account-setup-email-info-icon =
    .title = A meglévő e-mail címe
account-setup-email-warning-icon =
    .title = { account-setup-email-warning }
account-setup-password-label = Jelszó
    .accesskey = J
    .title = Nem kötelező, csak a felhasználónév ellenőrzéséhez használatos
account-provisioner-button = Új e-mail-cím kérése
    .accesskey = j
account-setup-password-toggle =
    .title = Jelszó megjelenítése/elrejtése
account-setup-password-toggle-show =
    .title = Jelszó megjelenítése
account-setup-password-toggle-hide =
    .title = Jelszó elrejtése
account-setup-remember-password = Jelszó megjegyzése
    .accesskey = m
account-setup-exchange-label = Az Ön bejelentkezése
    .accesskey = b
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = TARTOMÁNY\felhasználónév
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Tartományi bejelentkezés

## Action buttons

account-setup-button-cancel = Mégse
    .accesskey = M
account-setup-button-manual-config = Kézi beállítás
    .accesskey = K
account-setup-button-stop = Leállítás
    .accesskey = L
account-setup-button-retest = Újratesztelés
    .accesskey = t
account-setup-button-continue = Folytatás
    .accesskey = F
account-setup-button-done = Kész
    .accesskey = K

## Notifications

account-setup-looking-up-settings = Konfiguráció keresése…
account-setup-looking-up-settings-guess = Konfiguráció keresése: Gyakori kiszolgálónevek kipróbálása…
account-setup-looking-up-settings-half-manual = Konfiguráció keresése: Kiszolgáló vizsgálata…
account-setup-looking-up-disk = Konfiguráció keresése: { -brand-short-name } telepítés…
account-setup-looking-up-isp = Konfiguráció keresése: E-mail-szolgáltató…
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Konfiguráció keresése: Waterfox ISP adatbázis…
account-setup-looking-up-mx = Konfiguráció keresése: Bejövő e-mail domain…
account-setup-looking-up-exchange = Konfiguráció keresése: Exchange kiszolgáló…
account-setup-checking-password = Jelszó ellenőrzése…
account-setup-installing-addon = Kiegészítő letöltése és telepítése…
account-setup-success-half-manual = Az adott kiszolgáló vizsgálata a következő beállításokat találta:
account-setup-success-guess = A beállításokat a gyakori kiszolgálónevek keresése találta.
account-setup-success-guess-offline = Kapcsolat nélküli üzemmódban van. Néhány beállítást kitaláltunk, de meg kell adnia a helyes beállításokat.
account-setup-success-password = Jelszó rendben
account-setup-success-addon = A kiegészítő telepítése sikeresen megtörtént
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = A konfiguráció megtalálható a Waterfox ISP adatbázisában.
account-setup-success-settings-disk = A konfiguráció megtalálható a { -brand-short-name } telepítésben.
account-setup-success-settings-isp = A konfiguráció megtalálható az e-mail-szolgáltatónál.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = A Microsoft Exchange kiszolgáló konfigurációja megtalálva.

## Illustrations

account-setup-step1-image =
    .title = Kezdeti beállítás
account-setup-step2-image =
    .title = Betöltés…
account-setup-step3-image =
    .title = Konfiguráció megtalálva
account-setup-step4-image =
    .title = Kapcsolódási hiba
account-setup-step5-image =
    .title = Fiók létrehozva
account-setup-privacy-footnote2 = A hitelesítő adatok csak helyben lesznek tárolva a számítógépen.
account-setup-selection-help = Nem tudja, mit válasszon?
account-setup-selection-error = Segítségre van szüksége?
account-setup-success-help = Nem biztos a következő lépésekben?
account-setup-documentation-help = Telepítési dokumentáció
account-setup-forum-help = Támogatói fórum
account-setup-privacy-help = Adatvédelmi irányelvek
account-setup-getting-started = Első lépések

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Elérhető konfiguráció
       *[other] Elérhető konfigurációk
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Mappák és e-mailek szinkronban tartása a kiszolgálón
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Mappák és e-mailek tárolása az Ön számítógépén
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = Microsoft Exchange vagy Office 365 felhőszolgáltatások használata
account-setup-incoming-title = Bejövő
account-setup-outgoing-title = Kimenő
account-setup-username-title = Felhasználónév
account-setup-exchange-title = Kiszolgáló
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Nincs titkosítás
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Meglévő SMTP-kiszolgáló használata
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Bejövő: { $incoming }, Kimenő: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Hitelesítés sikertelen. A megadott hitelesítő adatok hibásak vagy külön felhasználónév szükséges a bejelentkezéshez. Ez a felhasználónév általában a Windows tartományi bejelentkezése a tartomány nevével vagy anélkül (például gipszjakab vagy AD\\gipszjakab).
account-setup-credentials-wrong = Hitelesítés sikertelen. Ellenőrizze a felhasználónevet és a jelszót.
account-setup-find-settings-failed = A { -brand-short-name } nem találta meg az e-mail-fiókja beállításait
account-setup-exchange-config-unverifiable = A konfigurációt nem lehetett megerősíteni. Ha a felhasználóneve és a jelszava helyes, akkor valószínű, hogy a kiszolgáló adminisztrátora letiltotta a fiókjának kiválasztott konfigurációját. Próbáljon meg másik protokollt választani.
account-setup-provisioner-error = Hiba történt az új fiókja beállításakor a { -brand-short-name }ban. Próbálja kézzel beállítani a fiókját a hitelesítő adataival.

## Manual configuration area

account-setup-manual-config-title = Kiszolgáló beállításai
account-setup-incoming-server-legend = Bejövő kiszolgáló
account-setup-protocol-label = Protokoll:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Gépnév:
account-setup-port-label = Port:
    .title = Az automatikus észleléshez állítsa 0-ra a portszámot
account-setup-auto-description = A { -brand-short-name } megpróbálja automatikusan észlelni az üresen hagyott mezőket.
account-setup-ssl-label = Kapcsolat biztonsága:
account-setup-outgoing-server-legend = Kimenő kiszolgáló

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Automatikus felismerés
ssl-no-authentication-option = Nincs hitelesítés
ssl-cleartext-password-option = Normál jelszó
ssl-encrypted-password-option = Titkosított jelszó

## Incoming/Outgoing SSL options

ssl-noencryption-option = Egyik sem
account-setup-auth-label = Hitelesítési módszer:
account-setup-username-label = Felhasználónév:
account-setup-advanced-setup-button = Speciális beállítások
    .accesskey = S

## Warning insecure server dialog

account-setup-insecure-title = Vigyázat!
account-setup-insecure-incoming-title = Bejövő beállítások:
account-setup-insecure-outgoing-title = Kimenő beállítások:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = A(z) <b>{ $server }</b> nem használ titkosítást.
account-setup-warning-cleartext-details = A nem biztonságos levelezőkiszolgálók nem használnak titkosított kapcsolatokat a jelszavak és a privát információk védelme érdekében. Ha ilyen kiszolgálóhoz kapcsolódik, a jelszava és privát információi kiderülhetnek.
account-setup-insecure-server-checkbox = Megértettem a kockázatokat
    .accesskey = k
account-setup-insecure-description = A { -brand-short-name } megengedi a levelezést ezzel a konfigurációval. Ennek ellenére kérjük, forduljon a rendszergazdájához vagy az e-mail szolgáltatójához, és hívja fel a figyelmét ezekre a helytelen kapcsolatokra. További részletekért lásd a <a data-l10n-name="thunderbird-faq-link">Thunderbird GYIK</a> dokumentumot.
insecure-dialog-cancel-button = Beállítások módosítása
    .accesskey = B
insecure-dialog-confirm-button = Megerősítés
    .accesskey = M

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = A { -brand-short-name } megtalálta a fiókinformációit ehhez: { $domain }. Folytatja és elküldi a hitelesítő adatait?
exchange-dialog-confirm-button = Bejelentkezés
exchange-dialog-cancel-button = Mégse

## Dismiss account creation dialog

exit-dialog-title = Nincs e-mail-fiók beállítva
exit-dialog-description = Biztos, hogy megszakítja a telepítési folyamatot? A { -brand-short-name } továbbra is használható lesz e-mail-fiók nélkül, de számos funkció nem lesz elérhető.
account-setup-no-account-checkbox = A { -brand-short-name } használata e-mail-fiók nélkül
    .accesskey = h
exit-dialog-cancel-button = Beállítás folytatása
    .accesskey = f
exit-dialog-confirm-button = Kilépés a beállításból
    .accesskey = K

## Alert dialogs

account-setup-creation-error-title = Hiba a fiók létrehozásakor
account-setup-error-server-exists = Már van bejövő kiszolgáló.
account-setup-confirm-advanced-title = Speciális beállítások megerősítése
account-setup-confirm-advanced-description = Ez a párbeszédpanel bezáródik, és létrejön egy fiók a jelenlegi beállításokkal, még akkor is, ha a konfiguráció hibás. Folytatja?

## Addon installation section

account-setup-addon-install-title = Telepítés
account-setup-addon-install-intro = Egy harmadik féltől származó kiegészítővel hozzáférhet az e-mail fiókjához ezen a kiszolgálón:
account-setup-addon-no-protocol = Ez az e-mail-kiszolgáló sajnos nem támogatja a nyílt protokollokat. { account-setup-addon-install-intro }

## Success view

account-setup-settings-button = Fiókbeállítások
account-setup-encryption-button = Végpontok közötti titkosítás
account-setup-signature-button = Aláírás hozzáadása
account-setup-dictionaries-button = Szótárak letöltése
account-setup-address-book-carddav-button = Kapcsolódás egy CardDAV címjegyzékhez
account-setup-address-book-ldap-button = Kapcsolódás egy LDAP címjegyzékhez
account-setup-calendar-button = Kapcsolódás egy távoli naptárhoz
account-setup-linked-services-title = Kapcsolt szolgáltatások összekapcsolása
account-setup-linked-services-description = A { -brand-short-name } egyéb, az e-mail-fiókjához kapcsolódó szolgáltatások észlelt.
account-setup-no-linked-description = Állítson be más szolgáltatásokat, hogy a legtöbbet hozza ki a { -brand-short-name } élményéből.
# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] A { -brand-short-name } egy, az e-mail-fiókjához kapcsolódó címjegyzéket talált.
       *[other] A { -brand-short-name } { $count }, az e-mail-fiókjához kapcsolódó címjegyzéket talált.
    }
# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] A { -brand-short-name } egy, az e-mail-fiókjához kapcsolódó naptárat talált.
       *[other] A { -brand-short-name } { $count }, az e-mail-fiókjához kapcsolódó naptárat talált.
    }
account-setup-button-finish = Befejezés
    .accesskey = B
account-setup-looking-up-address-books = Címjegyzékek keresése…
account-setup-looking-up-calendars = Naptárak keresése…
account-setup-address-books-button = Címjegyzékek
account-setup-calendars-button = Naptárak
account-setup-connect-link = Kapcsolódás
account-setup-existing-address-book = Kapcsolódva
    .title = Már kapcsolódik a címjegyzékhez
account-setup-existing-calendar = Kapcsolódva
    .title = Már kapcsolódik a naptárhoz
account-setup-connect-all-calendars = Kapcsolódás az összes naptárhoz
account-setup-connect-all-address-books = Kapcsolódás az összes címjegyzékhez

## Calendar synchronization dialog

calendar-dialog-title = Kapcsolódás egy naptárhoz
calendar-dialog-cancel-button = Mégse
    .accesskey = M
calendar-dialog-confirm-button = Kapcsolódás
    .accesskey = K
account-setup-calendar-name-label = Név
account-setup-calendar-name-input =
    .placeholder = Saját naptár
account-setup-calendar-color-label = Szín
account-setup-calendar-refresh-label = Frissítés
account-setup-calendar-refresh-manual = Kézzel
account-setup-calendar-refresh-interval =
    { $count ->
        [one] Percenként
       *[other] { $minutes } percenként
    }
account-setup-calendar-read-only = Csak olvasható
    .accesskey = o
account-setup-calendar-show-reminders = Emlékeztetők megjelenítése
    .accesskey = E
account-setup-calendar-offline-support = Offline támogatás
    .accesskey = O
