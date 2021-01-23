# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Järjestelmään sopeuttaminen

system-integration-dialog =
    .buttonlabelaccept = Aseta oletukseksi
    .buttonlabelcancel = Ohita järjestelmään sopeuttaminen
    .buttonlabelcancel2 = Peruuta

default-client-intro = Käytä { -brand-short-name }iä oletusohjelmana:

unset-default-tooltip = { -brand-short-name }istä ei ole mahdollista asettaa toista ohjelmaa järjestelmän oletukseksi. Aseta toinen ohjelma oletukseksi sen omalla ”Aseta oletukseksi” -asetuksella.

checkbox-email-label =
    .label = Sähköpostille
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Keskusteluryhmille
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Syötteille
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windowsin haku
       *[other] { "" }
    }

system-search-integration-label =
    .label = Salli käyttöjärjestelmän { system-search-engine-name } -hakutoiminnon etsiä viesteistä
    .accesskey = S

check-on-startup-label =
    .label = Tee tämä tarkistus aina, kun { -brand-short-name } käynnistetään
    .accesskey = T
