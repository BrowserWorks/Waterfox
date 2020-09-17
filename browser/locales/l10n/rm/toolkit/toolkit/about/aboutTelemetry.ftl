# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Funtauna da datas da ping:
about-telemetry-show-current-data = Datas actualas
about-telemetry-show-archived-ping-data = Datas da ping archivadas
about-telemetry-show-subsession-data = Mussar datas da sesidas subordinadas
about-telemetry-choose-ping = Tscherner il ping:
about-telemetry-archive-ping-type = Tip da ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Oz
about-telemetry-option-group-yesterday = Ier
about-telemetry-option-group-older = Pli vegl
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Datas da telemetria
about-telemetry-current-store = Arcun actual:
about-telemetry-more-information = Tschertgas ti ulteriuras infurmaziuns?
about-telemetry-firefox-data-doc = La <a data-l10n-name="data-doc-link">Documentaziun datas da Firefox</a> cuntegna manuals davart la lavur cun noss utensils da datas.
about-telemetry-telemetry-client-doc = La <a data-l10n-name="client-doc-link">documentaziun client da telemetria da Firefox</a> includa definiziuns per concepts, documentaziuns dad API e referenzas a datas.
about-telemetry-telemetry-dashboard = Las <a data-l10n-name="dashboard-link">panelas da telemetria</a> ta permettan da visualisar las datas che Mozilla retschaiva via telemetria.
about-telemetry-telemetry-probe-dictionary = Il <a data-l10n-name="probe-dictionary-link">dicziunari da provas</a> cuntegna detagls e descripziuns per las provas rimnadas via telemetria.
about-telemetry-show-in-Firefox-json-viewer = Avrir en il visualisader da JSON
about-telemetry-home-section = Pagina da partenza
about-telemetry-general-data-section = Datas generalas
about-telemetry-environment-data-section = Datas dal conturn
about-telemetry-session-info-section = Infurmaziuns davart la sessiun
about-telemetry-scalar-section = Scalars
about-telemetry-keyed-scalar-section = Scalars cun clav
about-telemetry-histograms-section = Istograms
about-telemetry-keyed-histogram-section = Istograms cun clav
about-telemetry-events-section = Eveniments
about-telemetry-simple-measurements-section = Mesiraziuns simplas
about-telemetry-slow-sql-section = Statements da SQL plauns
about-telemetry-addon-details-section = Detagls dal supplement
about-telemetry-captured-stacks-section = Stacks Registrads
about-telemetry-late-writes-section = Inscripziuns retardadas
about-telemetry-raw-payload-section = Cuntegn betg elavurà
about-telemetry-raw = JSON brut
about-telemetry-full-sql-warning = REMARTGA: Il debugging da SQL plaun è activà. Eventualmain vegnan entirs strings da SQL mussads sutvart. Quels na vegnan dentant betg tramess a Telemetry.
about-telemetry-fetch-stack-symbols = Retschaiver ils nums da funcziuns per ils stacks
about-telemetry-hide-stack-symbols = Mussar las datas bruttas dal stack
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] datas da la versiun stabla
       *[prerelease] datas da la preversiun
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] activada
       *[disabled] deactivada
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } prova statistica, media = { $prettyAverage }, summa = { $sum }
       *[other] { $sampleCount } provas statisticas, media = { $prettyAverage }, summa = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Questa pagina mussa datas davart la prestaziun, la hardware, l'utilisaziun ed la persunalisaziun rimnadas da la telemetria. Questa infurmaziun vegn tramessa a { $telemetryServerOwner } per meglierar { -brand-full-name }.
about-telemetry-settings-explanation = La telemetria rimna las { about-telemetry-data-type } e la transmissiun è <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Mintga infurmaziun vegn tramessa pachetada en «<a data-l10n-name="ping-link">pings</a>». Ti vesas il ping { $name }, { $timestamp }.
about-telemetry-data-details-current = Mintga infurmaziun vegn tramessa pachetada en «<a data-l10n-name="ping-link">pings</a>». Ti vesas las datas actualas.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Tschertgar en { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Tschertgar en tuttas secziuns
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Resultats per «{ $searchTerms }»
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Perstgisa! I na dat nagins resultats en { $sectionName } per «{ $currentSearchText }»
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Perstgisa! Nagins resultats per «{ $searchTerms }» en tut las secziuns.
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Perstgisa! Naginas datas n'èn disponiblas en «{ $sectionName }»
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = datas actualas
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = tut
# button label to copy the histogram
about-telemetry-histogram-copy = Copiar
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Statements da SQL plauns en il thread principal
about-telemetry-slow-sql-other = Statements da SQL plauns en threads che assistan
about-telemetry-slow-sql-hits = Frequenza
about-telemetry-slow-sql-average = Temp en media (ms)
about-telemetry-slow-sql-statement = Statement
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID dal supplement
about-telemetry-addon-table-details = Detagls
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Purschider { $addonProvider }
about-telemetry-keys-header = Caracteristica
about-telemetry-names-header = Num
about-telemetry-values-header = Valur
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (dumber da captures: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Inscripziun retardada #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Diagram da la memoria:
about-telemetry-error-fetching-symbols = Ina errur è capitada cun retschaiver ils simbols. Controllescha che ti es connectà cun l'internet ed emprova anc ina giada.
about-telemetry-time-stamp-header = temp
about-telemetry-category-header = categoria
about-telemetry-method-header = metoda
about-telemetry-object-header = object
about-telemetry-extra-header = extra
about-telemetry-origin-section = Telemetria da origin
about-telemetry-origin-origin = origin
about-telemetry-origin-count = dumber
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">La telemetria da origin da Firefox</a> codescha las datas avant da las trametter per che { $telemetryServerOwner } possia calcular summas senza savair sche ina instanza specifica da { -brand-product-name } haja contribuì u betg contribuì a questa summa. (<a data-l10n-name="prio-blog-link">Ulteriuras infurmaziuns</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Process «{ $process }»
