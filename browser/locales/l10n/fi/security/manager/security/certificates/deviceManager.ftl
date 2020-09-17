# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Turvalaitteiden hallinta
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Turvallisuusmoduulit ja -laitteet

devmgr-header-details =
    .label = Yksityiskohdat

devmgr-header-value =
    .label = Arvo

devmgr-button-login =
    .label = Kirjaudu sisään
    .accesskey = K

devmgr-button-logout =
    .label = Kirjaudu ulos
    .accesskey = i

devmgr-button-changepw =
    .label = Vaihda salasanaa
    .accesskey = a

devmgr-button-load =
    .label = Lataa
    .accesskey = L

devmgr-button-unload =
    .label = Poista
    .accesskey = P

devmgr-button-enable-fips =
    .label = Ota FIPS käyttöön
    .accesskey = F

devmgr-button-disable-fips =
    .label = Poista FIPS käytöstä
    .accesskey = F

## Strings used for load device

load-device =
    .title = Lataa PKCS#11-laiteajuri

load-device-info = Kirjoita tiedot lisättävälle moduulille.

load-device-modname =
    .value = Moduulin nimi
    .accesskey = M

load-device-modname-default =
    .value = Uusi PKCS#11-moduuli

load-device-filename =
    .value = Moduulin tiedostonimi
    .accesskey = d

load-device-browse =
    .label = Selaa…
    .accesskey = S

## Token Manager

devinfo-status =
    .label = Tila

devinfo-status-disabled =
    .label = Ei käytössä

devinfo-status-not-present =
    .label = Ei paikalla

devinfo-status-uninitialized =
    .label = Alustamaton

devinfo-status-not-logged-in =
    .label = Ei kirjauduttu

devinfo-status-logged-in =
    .label = Kirjauduttu sisään

devinfo-status-ready =
    .label = Valmis

devinfo-desc =
    .label = Kuvaus

devinfo-man-id =
    .label = Valmistaja

devinfo-hwversion =
    .label = HW-versio
devinfo-fwversion =
    .label = FW-versio

devinfo-modname =
    .label = Moduuli

devinfo-modpath =
    .label = Polku

login-failed = Sisäänkirjautuminen epäonnistui

devinfo-label =
    .label = Lomakkeen nimi

devinfo-serialnum =
    .label = Sarjanumero

fips-nonempty-password-required = FIPS-tila vaatii, että jokaiselle turvalaitteelle on asetettu pääsalasana. Aseta salasana ennen kuin yrität ottaa FIPS-tilaa käyttöön.

fips-nonempty-primary-password-required = FIPS-tila vaatii, että jokaiselle turvalaitteelle on asetettu pääsalasana. Aseta salasana ennen kuin yrität ottaa FIPS-tilaa käyttöön.
unable-to-toggle-fips = FIPS-tilan vaihto turvalaitteelle ei onnistu. On suositeltavaa sulkea ja käynnistää tämä ohjelma uudelleen.
load-pk11-module-file-picker-title = Valitse ladattava PKCS#11-laiteajuri

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Moduulin nimi ei voi olla tyhjä.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ”Root Certs” on varattu nimi eikä sitä voi käyttää moduulin nimenä.

add-module-failure = Moduulin lisääminen ei onnistunut
del-module-warning = Poistetaanko tämä turvallisuusmoduuli?
del-module-error = Moduulin poistaminen ei onnistu
