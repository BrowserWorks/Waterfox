# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Tækjastjóri
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Öryggiseiningar og tæki

devmgr-header-details =
    .label = Nánar

devmgr-header-value =
    .label = Gildi

devmgr-button-login =
    .label = Skrá inn
    .accesskey = n

devmgr-button-logout =
    .label = Stimpla út
    .accesskey = S

devmgr-button-changepw =
    .label = Breyta lykilorði
    .accesskey = B

devmgr-button-load =
    .label = Hlaða inn
    .accesskey = l

devmgr-button-unload =
    .label = Taka út
    .accesskey = a

devmgr-button-enable-fips =
    .label = Virkja FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Gera FIPS óvirkt
    .accesskey = F

## Strings used for load device

load-device =
    .title = Hlaða inn PKCS#11 rekil

load-device-info = Sláðu inn upplýsingar um eininguna sem þú vilt bæta við.

load-device-modname =
    .value = Eininganafn
    .accesskey = M

load-device-modname-default =
    .value = Ný PKCS#11 eining

load-device-filename =
    .value = Skráarnafn einingar
    .accesskey = f

load-device-browse =
    .label = Velja…
    .accesskey = V

## Token Manager

devinfo-status =
    .label = Staða

devinfo-status-disabled =
    .label = Óvirkt

devinfo-status-not-present =
    .label = Ekki til staðar

devinfo-status-uninitialized =
    .label = Ekki frumstillt

devinfo-status-not-logged-in =
    .label = Ekki innskráður

devinfo-status-logged-in =
    .label = Innskráður

devinfo-status-ready =
    .label = Tilbúin

devinfo-desc =
    .label = Lýsing

devinfo-man-id =
    .label = Framleiðandi

devinfo-hwversion =
    .label = Útgáfa vélbúnaðar
devinfo-fwversion =
    .label = Útgáfa fastbúnaðar

devinfo-modname =
    .label = Eining

devinfo-modpath =
    .label = Slóð

login-failed = Gat ekki skráð inn

devinfo-label =
    .label = Merki

devinfo-serialnum =
    .label = Raðnúmer

fips-nonempty-password-required = FIPS hamur þarfnast þess að aðallykilorð sé skilgreint fyrir hvert öryggistæki. Settu upp lykilorðið áður en þú reynir að virkja FIPS ham.

unable-to-toggle-fips = Get ekki breytt FIPS ham fyrir öryggistæki. Mælt er með að þú hættir og endurræsir þetta forrit.
load-pk11-module-file-picker-title = Veldu PKCS#11 rekil til að hlaða inn

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Nafn einingar má ekki vera tómt.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ er frátekið og er ekki hægt að nota sem nafn á einingu.

add-module-failure = Get ekki sett upp einingu
del-module-warning = Ertu viss um að þú viljir eyða þessari öryggiseiningu?
del-module-error = Get ekki eytt öryggiseiningu
