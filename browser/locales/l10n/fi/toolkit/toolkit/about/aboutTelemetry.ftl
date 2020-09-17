# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping-datan lähde:
about-telemetry-show-current-data = Nykyinen data
about-telemetry-show-archived-ping-data = Arkistoitu ping-data
about-telemetry-show-subsession-data = Näytä ali-istuntodata
about-telemetry-choose-ping = Valitse ping:
about-telemetry-archive-ping-type = Pingin tyyppi
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Tänään
about-telemetry-option-group-yesterday = Eilen
about-telemetry-option-group-older = Vanhemmat
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Kaukomittaustiedot
about-telemetry-current-store = Nykyinen säilö:
about-telemetry-more-information = Etsitkö lisätietoa?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox Data Documentation</a> sisältää englanniksi oppaita datatyökalujen käytöstä.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetry client documentation</a> sisältää englanniksi käsitteiden määritelmät, API-dokumentaation ja dataviittaukset.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Kaukomittaustietojen yhteenvetojen</a> avulla voi visualisoida dataa, jota Mozilla vastaanottaa kaukomittauksen avulla.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Anturihakemisto</a> sisältää kaukomitattavien anturien tiedot ja kuvaukset.
about-telemetry-show-in-Firefox-json-viewer = Avaa JSON-katselimessa
about-telemetry-home-section = Etusivu
about-telemetry-general-data-section = Yleistiedot
about-telemetry-environment-data-section = Ympäristön tiedot
about-telemetry-session-info-section = Istunnon tiedot
about-telemetry-scalar-section = Skaalariarvot
about-telemetry-keyed-scalar-section = Avaimelliset skalaariarvot
about-telemetry-histograms-section = Histogrammit
about-telemetry-keyed-histogram-section = Histogrammit merkinnöistä
about-telemetry-events-section = Tapahtumat
about-telemetry-simple-measurements-section = Yksinkertaiset mittaukset
about-telemetry-slow-sql-section = Hitaat SQL-lauseet
about-telemetry-addon-details-section = Lisäosien tiedot
about-telemetry-captured-stacks-section = Kaapatut pinot
about-telemetry-late-writes-section = Myöhästyneet kirjoitukset
about-telemetry-raw-payload-section = Raakatiedot
about-telemetry-raw = Muotoilematon JSON
about-telemetry-full-sql-warning = Huom.: Hitaan SQL:n virheenetsintä on käytössä. Täydelliset SQL-lausekkeet saattavat näkyä alla, mutta niitä ei lähetetä mittaustietona.
about-telemetry-fetch-stack-symbols = Nouda funktioiden nimet pinoihin
about-telemetry-hide-stack-symbols = Näytä muotoilematon pinodata
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] release-tietoja
       *[prerelease] pre-release-tietoja
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] käytössä
       *[disabled] pois käytöstä
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } näyte, keskiarvo = { $prettyAverage }, summa = { $sum }
       *[other] { $sampleCount } näytettä, keskiarvo = { $prettyAverage }, summa = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Tällä sivulla näet Kaukomittaus-toiminnallisuuden keräämät tiedot suorituskyvystä, laitteistosta, ominaisuuksien käytöstä ja muokkauksista. Sivulla näkyvät tiedot lähetetään { $telemetryServerOwner }lle auttamaan { -brand-full-name }in kehityksessä.
about-telemetry-settings-explanation = Kaukomittaus kerää { about-telemetry-data-type } ja tietojen lähetys on <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Kukin informaation palanen lähetetään koottuna ”<a data-l10n-name="ping-link">pingeihin</a>”. Katselet juuri { $name }, { $timestamp }-pingiä.
about-telemetry-data-details-current = Kukin informaation palanen lähetetään koottuna ”<a data-l10n-name="ping-link">pingeihin</a>”. Katselet juuri nykyistä dataa.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Etsi: { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Etsi kaikista osioista
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Tulokset haulle ”{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Ei hakutuloksia osiosta { $sectionName } haulle ”{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Ei hakutuloksia mistään osiosta haulle ”{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Osiossa ”{ $sectionName }” ei ole tällä hetkellä dataa
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = nykyinen data
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = kaikki
# button label to copy the histogram
about-telemetry-histogram-copy = Kopioi
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Hitaat SQL-lauseet pääsäikeessä
about-telemetry-slow-sql-other = Hitaat SQL-lauseet apusäikeissä
about-telemetry-slow-sql-hits = Osumat
about-telemetry-slow-sql-average = Keskimääräinen aika (ms)
about-telemetry-slow-sql-statement = Lause
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Lisäosan tunnus
about-telemetry-addon-table-details = Tiedot
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider }-toimittaja
about-telemetry-keys-header = Ominaisuus
about-telemetry-names-header = Nimi
about-telemetry-values-header = Arvo
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (kaappausmäärä: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Myöhästynyt kirjoitus #{ $lateWriteCount }
about-telemetry-stack-title = Pino:
about-telemetry-memory-map-title = Muistikartta:
about-telemetry-error-fetching-symbols = Tapahtui virhe haettaessa symboleita. Tarkista, että Internet-yhteys on kunnossa ja yritä uudestaan.
about-telemetry-time-stamp-header = aikaleima
about-telemetry-category-header = luokka
about-telemetry-method-header = metodi
about-telemetry-object-header = objekti
about-telemetry-extra-header = lisätietoa
about-telemetry-origin-section = Origin-kaukomittaus
about-telemetry-origin-origin = origin
about-telemetry-origin-count = lukumäärä
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefoxin origin-kaukomittaus</a> koodaa datan ennen lähettämistä niin, että { $telemetryServerOwner } voi laskea tietueita mutta ei tiedä vaikuttiko tietty { -brand-product-name } lukumäärään vai ei. (<a data-l10n-name="prio-blog-link">lue lisää</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process }-prosessi
