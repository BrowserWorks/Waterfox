# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = Új e-mail-cím kérése egy szolgáltatótól
provisioner-searching-icon =
    .alt = Keresés…
account-provisioner-title = Új e-mail-cím létrehozása
account-provisioner-description = Használja megbízható partnereinket, hogy új privát és biztonságos e-mail-címet szerezzen.
account-provisioner-start-help = A keresési kifejezések el lesznek küldve a { -vendor-short-name } (<a data-l10n-name="mozilla-privacy-link">Adatvédelmi nyilatkozat</a>) és a harmadik felű e-mail-szolgáltatók, tehát a <strong>mailfence.com</strong> (<a data-l10n-name="mailfence-privacy-link">Adatvédelmi nyilatkozat</a>, <a data-l10n-name="mailfence-tou-link">Szolgáltatási feltételek</a>) és a <strong>gandi.net</strong> (<a data-l10n-name="gandi-privacy-link">Adatvédelmi nyilatkozat</a>, <a data-l10n-name="gandi-tou-link">Szolgáltatási feltételek</a>) számára, hogy szabad e-mail-címeket találjanak.
account-provisioner-mail-account-title = Új e-mail-cím vásárlása
account-provisioner-mail-account-description = A Thunderbird partnerségre lépett a <a data-l10n-name="mailfence-home-link">Mailfence-szel</a>, hogy új privát és biztonságos e-mailt kínáljon. Úgy gondoljuk, hogy mindenkinek biztonságos e-mail-címmel kellene rendelkeznie.
account-provisioner-domain-title = Vásároljon saját e-mail-címet és domain nevet
account-provisioner-domain-description = A Thunderbird partnerségre lépett a <a data-l10n-name="gandi-home-link">Gandival</a>, hogy egyéni domaint kínáljon. Így bármilyen címet használhat azon a domain neven.

## Forms

account-provisioner-mail-input =
    .placeholder = Az Ön neve, beceneve vagy más keresési kifejezések
account-provisioner-domain-input =
    .placeholder = Az Ön neve, beceneve vagy más keresési kifejezések
account-provisioner-search-button = Keresés
account-provisioner-button-cancel = Mégse
account-provisioner-button-existing = Meglévő e-mail-fiók használata
account-provisioner-button-back = Ugrás vissza

## Notifications

account-provisioner-fetching-provisioners = Szolgáltatók lekérése…
account-provisioner-connection-issues = Nem sikerült kapcsolódni a feliratkozási kiszolgálókhoz. Ellenőrizze a kapcsolatát.
account-provisioner-searching-email = Elérhető e-mail-fiókok keresése…
account-provisioner-searching-domain = Elérhető domainek keresése…
account-provisioner-searching-error = Nem található javasolható cím. Próbálja megváltoztatni a keresési kifejezéseket.

## Illustrations

account-provisioner-step1-image =
    .title = Válassza ki, melyik fiókot szeretné létrehozni

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
        [one] Egy elérhető e-mail-cím található a következőhöz:
       *[other] { $count } elérhető e-mail-cím található a következőhöz:
    }
account-provisioner-mail-results-caption = Kereshet becenevekre vagy bármi másra is, hogy további e-mail-címeket találjon.
account-provisioner-domain-results-caption = Kereshet becenevekre vagy bármi másra is, hogy további domaineket találjon.
account-provisioner-free-account = Ingyenes
account-provision-price-per-year = { $price } évente
account-provisioner-all-results-button = Összes találat megjelenítése
