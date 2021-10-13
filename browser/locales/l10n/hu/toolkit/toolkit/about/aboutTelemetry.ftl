# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Adatforrás pingelése:
about-telemetry-show-current-data = Jelenlegi adatok
about-telemetry-show-archived-ping-data = Archivált ping adatok
about-telemetry-show-subsession-data = Almunkamenet adatainak megjelenítése
about-telemetry-choose-ping = Válasszon pinget:
about-telemetry-archive-ping-type = Ping típusa
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Ma
about-telemetry-option-group-yesterday = Tegnap
about-telemetry-option-group-older = Régebbi
about-telemetry-previous-ping = <<
about-telemetry-next-ping = <i>
about-telemetry-page-title = Telemetriai adatok
about-telemetry-current-store = Jelenlegi bolt:
about-telemetry-more-information = Több információt keres?
about-telemetry-firefox-data-doc = A <a data-l10n-name="data-doc-link">Waterfox adatok dokumentáció</a> útmutatókat tartalmaz arról, hogyan dolgozzon az adateszközeinkkel.
about-telemetry-telemetry-client-doc = A <a data-l10n-name="client-doc-link">Waterfox telemetria ügyfél dokumentáció</a> fogalomdefiníciókat, API dokumentációkat és adathivatkozásokat tartalmaz.
about-telemetry-telemetry-dashboard = A <a data-l10n-name="dashboard-link">Telemetria vezérlőpultokkal</a> vizualizálhatóak a Waterfox által kapott telemetria adatok.
about-telemetry-telemetry-probe-dictionary = A <a data-l10n-name="probe-dictionary-link">Szonda szótár</a> részleteket és leírást ad a telemetria által gyűjtött szondákról.
about-telemetry-show-in-Waterfox-json-viewer = Megnyitás a JSON megjelenítővel
about-telemetry-home-section = Kezdőlap
about-telemetry-general-data-section = Általános adatok
about-telemetry-environment-data-section = Környezeti adatok
about-telemetry-session-info-section = Munkamenet-információk
about-telemetry-scalar-section = Skalárok
about-telemetry-keyed-scalar-section = Kulcsos skalárok
about-telemetry-histograms-section = Hisztogramok
about-telemetry-keyed-histogram-section = Hisztogramok kulccsal
about-telemetry-events-section = Események
about-telemetry-simple-measurements-section = Egyszerű mérési eszközök
about-telemetry-slow-sql-section = Lassú SQL utasítások
about-telemetry-addon-details-section = Kiegészítő részletei
about-telemetry-captured-stacks-section = Rögzített vermek
about-telemetry-late-writes-section = Késői írások
about-telemetry-raw-payload-section = Nyers teher
about-telemetry-raw = Nyers JSON
about-telemetry-full-sql-warning = MEGJEGYZÉS: A lassú SQL hibakeresés be van kapcsolva. Alább megjelenhetnek teljes SQL karakterláncok, de ezek nem kerülnek elküldésre a telemetriának.
about-telemetry-fetch-stack-symbols = Függvénynevek lekérése a vermekhez
about-telemetry-hide-stack-symbols = Nyers veremadatok megjelenítése
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] kiadási adatokat
       *[prerelease] kiadás előtti adatokat
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] engedélyezett
       *[disabled] tiltott
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } minta, átlag = { $prettyAverage }, összeg = { $sum }
       *[other] { $sampleCount } minta, átlag = { $prettyAverage }, összeg = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = Ez az oldal megjeleníti a telemetria által gyűjtött teljesítmény-, hardver-, és funkcióhasználati adatokat és testreszabásokat. Ezek az információk a { $telemetryServerOwner }nak a { -brand-full-name } tökéletesítése érdekében kerülnek elküldésre.
about-telemetry-settings-explanation = A telemetria { about-telemetry-data-type } gyűjt, és a feltöltés <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Minden információcsomag „<a data-l10n-name="ping-link">ping</a>” csomagként kerül elküldésre. Jelenleg a következő ping látható: { $name }, { $timestamp }.
about-telemetry-data-details-current = Az információk „<a data-l10n-name="ping-link">pingekbe</a>” csomagolva kerülnek elküldésre. Ön a jelenlegi adatokat látja.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Keresés itt: { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Keresés az összes szakaszban
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Találatok erre: „{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Elnézést, nincs találat itt: { $sectionName }, erre: „{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Elnézést, egyik szakaszban nincs találat erre: „{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Elnézést, jelenleg nincs elérhető adat itt: „{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = jelenlegi adatok
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = összes
# button label to copy the histogram
about-telemetry-histogram-copy = Másolás
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Lassú SQL utasítások a főszálon
about-telemetry-slow-sql-other = Lassú SQL utasítások a segédszálakon
about-telemetry-slow-sql-hits = Találatok
about-telemetry-slow-sql-average = Átl. idő (ms)
about-telemetry-slow-sql-statement = Megállapítások
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Kiegészítő-azonosító
about-telemetry-addon-table-details = Részletek
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } szolgáltató
about-telemetry-keys-header = Tulajdonság
about-telemetry-names-header = Név
about-telemetry-values-header = Érték
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (rögzítések száma: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = { $lateWriteCount }. utolsó írás
about-telemetry-stack-title = Verem:
about-telemetry-memory-map-title = Memóriatérkép:
about-telemetry-error-fetching-symbols = Hiba történt a szimbólumok lekérése közben. Ellenőrizze, hogy csatlakozik-e az internetre, és próbálja újra.
about-telemetry-time-stamp-header = időbélyeg
about-telemetry-category-header = kategória
about-telemetry-method-header = metódus
about-telemetry-object-header = objektum
about-telemetry-extra-header = extra
about-telemetry-origin-section = Eredettel kapcsolatos telemetria
about-telemetry-origin-origin = eredet
about-telemetry-origin-count = darabszám
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = A <a data-l10n-name="origin-doc-link">Waterfox eredettel kapcsolatos telemetria</a> kódolja az adatokat az elküldés előtt, így a { $telemetryServerOwner } csak összeszámolhat dolgokat, de nem tudja, hogy pontosan mely { -brand-product-name } járult hozzá ahhoz a számhoz. (<a data-l10n-name="prio-blog-link">további információk</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } folyamat
