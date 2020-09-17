# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Sorgente ping dæti:
about-telemetry-show-archived-ping-data = Ping dæti archiviæ
about-telemetry-show-subsession-data = Fanni vedde dæti sottasescion
about-telemetry-choose-ping = Çerni ping:
about-telemetry-archive-ping-type = Tipo de Ping
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Ancheu
about-telemetry-option-group-yesterday = Vei
about-telemetry-option-group-older = Ciù vegio
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Dæti telemetria
about-telemetry-more-information = Ti veu âtre informaçioin?
about-telemetry-firefox-data-doc = A <a data-l10n-name="data-doc-link">Documentaçion Dæti de Firefox</a> a contegne guidde in sce comme travagiâ co-i nòstri strumenti dati.
about-telemetry-telemetry-client-doc = A <a data-l10n-name="client-doc-link">Documentaçion da Telemetria Dæti de Firefox</a> a contegne documenti definiçioin, API e referense di dati.
about-telemetry-telemetry-dashboard = A <a data-l10n-name="dashboard-link">Lavagna da telemetria</a> a permette de vedde i dati che Mozilla a riçeive via Telemetria.
about-telemetry-show-in-Firefox-json-viewer = Arvi into vizoalizatô JSON
about-telemetry-home-section = Pagina prinçipâ
about-telemetry-general-data-section = Dæti generali
about-telemetry-environment-data-section = Dæti anbiente
about-telemetry-session-info-section = Informaçion in sciâ sescion
about-telemetry-scalar-section = Scalari
about-telemetry-keyed-scalar-section = Scalari tastea
about-telemetry-histograms-section = Istogrammi
about-telemetry-keyed-histogram-section = Istogrammi con ciave
about-telemetry-events-section = Eventi
about-telemetry-simple-measurements-section = Mizuaçioin senplici
about-telemetry-slow-sql-section = Istruçioin SQL lente
about-telemetry-addon-details-section = Detalli conp. azonto
about-telemetry-captured-stacks-section = Stack caturou
about-telemetry-late-writes-section = Scritue ritardæ
about-telemetry-raw-payload-section = Carego sgreuzzo
about-telemetry-raw = JSON sgreuzzo
about-telemetry-full-sql-warning = ATENÇION: o contròllo de istruçioin SQL lente o l'é ativo. Porieiva ese mostrou de stringhe SQL conplete ma queste informaçioin no saian trasmisse da-a telemetria.
about-telemetry-fetch-stack-symbols = Repiggia i nommi de fonçioin pe stack
about-telemetry-hide-stack-symbols = Fanni vedde stack dæti sgreuzzi
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] dæta publicaçion
       *[prerelease] data pre-release
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] abilitou
       *[disabled] dizabilitou
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = In sta pagina gh'é di dæti in sce prestaçioin e l'uzo de carateristiche arecogeite co-a telemetria. Ste informaçioin vegnan mandæ a { $telemetryServerOwner } in mòddo anònimo pe megiorâ { -brand-full-name }.
about-telemetry-settings-explanation = A telemetria a piggia { about-telemetry-data-type } e agiorna <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Tutte e informaçioin en spedie drento “<a data-l10n-name="ping-link">ping</a>”. Ti veddi o ping a { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Treuva in { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Treuva in tutte e seçioin
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Exiti pe “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Me spiaxe! No emmo trovou ninte in { $sectionName } pe “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Me spiaxe! No emmo trovou ninte inte seçioin pe “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Me spiaxe! No gh'emmo data in “{ $sectionName }”
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = tutto
# button label to copy the histogram
about-telemetry-histogram-copy = Còpia
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Istruçioin SQL lente into thread prinçipâ
about-telemetry-slow-sql-other = Istruçioin SQL lente into thread de sopòrto
about-telemetry-slow-sql-hits = Num.
about-telemetry-slow-sql-average = Tenpo medio (ms)
about-telemetry-slow-sql-statement = Istruçion
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID conponente azonto
about-telemetry-addon-table-details = Detalli
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Fornio da { $addonProvider }
about-telemetry-keys-header = Propietæ
about-telemetry-names-header = Nomme
about-telemetry-values-header = Valô
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (conta de catue: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Scritua ritardâ #{ $lateWriteCount }
about-telemetry-stack-title = Stack:
about-telemetry-memory-map-title = Mappa memöia:
about-telemetry-error-fetching-symbols = S'é verificòu 'n erô into repiggio di scinboli. Verifica a conescion a l'Internet e preuva torna.
about-telemetry-time-stamp-header = timestamp
about-telemetry-category-header = categoria
about-telemetry-method-header = metodo
about-telemetry-object-header = ògetto
about-telemetry-extra-header = extra
