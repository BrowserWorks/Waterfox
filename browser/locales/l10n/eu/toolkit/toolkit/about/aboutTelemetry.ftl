# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Ping datu-iturria:
about-telemetry-show-current-data = Uneko datuak
about-telemetry-show-archived-ping-data = Artxibatutako ping datuak
about-telemetry-show-subsession-data = Erakutsi azpi-saioaren datuak
about-telemetry-choose-ping = Aukeratu ping-a:
about-telemetry-archive-ping-type = Ping mota
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Gaur
about-telemetry-option-group-yesterday = Atzo
about-telemetry-option-group-older = Zaharragoa
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetry datuak
about-telemetry-current-store = Uneko denda:
about-telemetry-more-information = Informazio gehiagoren bila?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefoxen datuen dokumentazioa</a>k gure datu-tresnekin nola lan egin erakusten du.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox Telemetry bezeroaren dokumentazioa</a>k kontzeptuen definizioak, API dokumentazioa eta datu-erreferentziak ditu.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetry panelen</a> bidez Mozillak Telemetry bitartez jasotako datuak irudika ditzakezu.
about-telemetry-telemetry-probe-dictionary = Telemetry zerbitzuak bildutako zunden xehetasun eta deskribapenak hornitzen ditu <a data-l10n-name="probe-dictionary-link">hiztegi-zundak</a>.
about-telemetry-show-in-Firefox-json-viewer = Ireki JSON ikustailean
about-telemetry-home-section = Hasiera
about-telemetry-general-data-section =   Datu orokorrak
about-telemetry-environment-data-section = Ingurunearen datuak
about-telemetry-session-info-section = Saioaren informazioa
about-telemetry-scalar-section = Eskalarrak
about-telemetry-keyed-scalar-section = Eskalar gakodunak
about-telemetry-histograms-section = Histogramak
about-telemetry-keyed-histogram-section =   Legendadun histogramak
about-telemetry-events-section = Gertaerak
about-telemetry-simple-measurements-section = Neurketa sinpleak
about-telemetry-slow-sql-section = SQL instrukzio motelak
about-telemetry-addon-details-section = Gehigarriaren xehetasunak
about-telemetry-captured-stacks-section = Kapturatutako pilak
about-telemetry-late-writes-section = Idazketa berantiarrak
about-telemetry-raw-payload-section = Eskaera-karga gordina
about-telemetry-raw = JSON gordina
about-telemetry-full-sql-warning = OHARRA: SQL motelaren arazketa gaituta dago. SQL kate osoak bistara litezke azpian baina ez dira Telemetry-ra bidaliko.
about-telemetry-fetch-stack-symbols = Eskuratu pilen funtzio-deiak
about-telemetry-hide-stack-symbols = Erakutsi pilaren datu gordinak
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] argitalpen-datuak
       *[prerelease] aurreargitalpen-datuak
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] gaituta
       *[disabled] desgaituta
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] lagin { $sampleCount }, bataz bestekoa = { $prettyAverage }, batura = { $sum }
       *[other] { $sampleCount } lagin, bataz bestekoa = { $prettyAverage }, batura = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Telemetry-k bildutako errendimenduaren, hardwarearen, erabilpenaren eta pertsonalizazioen inguruko datuak erakusten ditu orri honek. Informazio hau { $telemetryServerOwner }(r)a bidaltzen da { -brand-full-name } hobetzen laguntzeko.
about-telemetry-settings-explanation = Telemetry { about-telemetry-data-type } biltzen ari da eta igotzea <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> dago.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Informazio guztia "<a data-l10n-name="ping-link">ping</a>"etan bilduta bidaltzen da. { $name }, { $timestamp } ping-a ari zara ikusten.
about-telemetry-data-details-current = Informazio zati bakoitza "<a data-l10n-name="ping-link">ping</a>" izeneko multzoetan bidaltzen da. Uneko datuei begira zaude.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Bilatu { $selectedTitle } atalean
about-telemetry-filter-all-placeholder =
    .placeholder = Bilatu atal guztietan
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = "{ $searchTerms }" bilaketaren emaitzak
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Barkatu! { $sectionName } atalean ez dago "{ $currentSearchText }" bilaketarako emaitzarik
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Sentitzen dugu! Ataletan ez dago "{ $searchTerms }" bilaketarako emaitzarik.
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Sentitzen dugu! Une honetan ez dago daturik erabilgarri "{ $sectionName }" atalean
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = uneko datuak
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = denak
# button label to copy the histogram
about-telemetry-histogram-copy = Kopiatu
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Hari nagusiko SQL instrukzio motelak
about-telemetry-slow-sql-other = Hari laguntzaileetako SQL instrukzio motelak
about-telemetry-slow-sql-hits = Asmatutakoak
about-telemetry-slow-sql-average = B.b.ko denbora (ms)
about-telemetry-slow-sql-statement = Instrukzioa
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Gehigarriaren IDa
about-telemetry-addon-table-details = Xehetasunak
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } hornitzailea
about-telemetry-keys-header = Propietatea
about-telemetry-names-header = Izena
about-telemetry-values-header = Balioa
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (kaptura-kopurua: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = #{ $lateWriteCount } idazketa berantiarra
about-telemetry-stack-title = Pila:
about-telemetry-memory-map-title = Memoria-mapa:
about-telemetry-error-fetching-symbols = Errorea gertatu da sinboloak eskuratzean. Egiaztatu Internet konexioa daukazula eta saiatu berriro.
about-telemetry-time-stamp-header = denbora-marka
about-telemetry-category-header = kategoria
about-telemetry-method-header = metodoa
about-telemetry-object-header = objektua
about-telemetry-extra-header = estra
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = jatorria
about-telemetry-origin-count = kopurua
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a>k bidali aurretik kodetu egiten ditu datuak, { $telemetryServerOwner } zerbitzariak kontaketa burutu ahal izateko baina { -brand-product-name } jakin batek kontaketa horretan parte hartu duen jakiteko modurik gabe. (<a data-l10n-name="prio-blog-link">argibide gehiago</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } prozesua
