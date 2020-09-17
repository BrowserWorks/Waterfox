# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = Hallitse evästeitä ja sivustotietoja

site-data-settings-description = Seuraavat sivustot tallentavat evästeitä ja tietoja tietokoneellesi. { -brand-short-name } säilyttää pysyvää tallennustilaa käyttävien sivustojen tiedot, kunnes poistat ne, ja poistaa muiden sivustojen tietoja sitä mukaa, kun tilaa tarvitsee vapauttaa.

site-data-search-textbox =
    .placeholder = Etsi sivustoja
    .accesskey = E

site-data-column-host =
    .label = Sivusto
site-data-column-cookies =
    .label = Evästeet
site-data-column-storage =
    .label = Tallennustila
site-data-column-last-used =
    .label = Viimeksi käytetty

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (paikallinen tiedosto)

site-data-remove-selected =
    .label = Poista valitut
    .accesskey = v

site-data-button-cancel =
    .label = Peruuta
    .accesskey = P

site-data-button-save =
    .label = Tallenna muutokset
    .accesskey = m

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (pysyvästi)

site-data-remove-all =
    .label = Poista kaikki
    .accesskey = s

site-data-remove-shown =
    .label = Poista kaikki näkyvät
    .accesskey = n

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = Poista

site-data-removing-header = Evästeiden ja sivustotietojen poisto

site-data-removing-desc = Sivustotietojen poistaminen voi kirjata sinut ulos sivustoilta. Haluatko varmasti tehdä muutokset?

site-data-removing-table = Seuraavien sivustojen evästeet ja tiedot poistetaan
