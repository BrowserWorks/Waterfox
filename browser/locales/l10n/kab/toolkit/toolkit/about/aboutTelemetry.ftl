# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Aɣbalu n isefka n Ping:
about-telemetry-show-current-data = Isefka imiranen
about-telemetry-show-archived-ping-data = Isefka n Ping ittwaɣebṛen
about-telemetry-show-subsession-data = Sken isefka n adtiɣimit
about-telemetry-choose-ping = Fren ping:
about-telemetry-archive-ping-type = Tawsit n untu
about-telemetry-archive-ping-header = Ping
about-telemetry-option-group-today = Ass-a
about-telemetry-option-group-yesterday = Iḍelli
about-telemetry-option-group-older = Iqbuṛen
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Isefka n tilisɣelt
about-telemetry-current-store = Tahanut tamirant:
about-telemetry-more-information = Tettnadiḍ ugar n telγut?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Tisemlit n isefka Firefox</a> tegber imniren γef amek ad nseqdec s ifecka n isefka.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Tisemlit n umsaγ tilisγelt</a>tegber tabadutin yef tiktiwin, API tisemlit akked isefka ittwamlen.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Tafelwit n tilisγelt</a> ad k-tsireg akken ad twaliḍ isefka ittwaznen i Mozilla s ttawil n tilispyelt.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Amawal n usenqed</a> ittmuddu-d talqayt akked uglam i isenqaden id-telqeḍ tilisɣelt.
about-telemetry-show-in-Firefox-json-viewer = Ldi deg umeskan JSON
about-telemetry-home-section = Agejdan
about-telemetry-general-data-section = Isefka imatuten
about-telemetry-environment-data-section = Isefka n twennaṭ
about-telemetry-session-info-section = Talɣut n tɣimit
about-telemetry-scalar-section = Afesnan
about-telemetry-keyed-scalar-section = Afesnan tasarutt
about-telemetry-histograms-section = Imazrudlifen
about-telemetry-keyed-histogram-section = Imazrudlifen s wawalen n tsura
about-telemetry-events-section = Tidyanin
about-telemetry-simple-measurements-section = Iktazalen iḥerfiyen
about-telemetry-slow-sql-section = Tuţriwin SQL tiẓayanin
about-telemetry-addon-details-section = Aglam leqqayen n izegrar
about-telemetry-captured-stacks-section = Tinebdanin ittwaṭfen
about-telemetry-late-writes-section = Tira tineggura
about-telemetry-raw-payload-section = Taɛekkemt tarewwayt
about-telemetry-raw = Izirig JSON
about-telemetry-full-sql-warning = Tazmilt: Aseɣti n tuttriwin SQL ẓẓayen yermed. Tuttriwin SQL yemden zemrent ad d-waseknent daw-a, acukan ur zmirent ara ad ttwaznent s tilisɣelt.
about-telemetry-fetch-stack-symbols = Awi-d ismawen n twuriwin i tnebdanin
about-telemetry-hide-stack-symbols = Sken-d isefka n ukufi
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] ifecka n lqem ad yefγen
       *[prerelease] ifecka n lqem send ad d-yeffeγ
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] irmed
       *[disabled] yensa
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } n umedya, alemmas = { $prettyAverage }, amatu = { $sum }
       *[other] { $sampleCount } n yimedyaten, alemmas= { $prettyAverage }, amatu= { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Asebter-agi iskan-d talɣut n tmellit, arrum, aseqdec d waggan id d-lqeḍ tilisɣelt. Talɣut-agi tettwazen i { $telemetryServerOwner } i wusnerni n { -brand-full-name }.
about-telemetry-settings-explanation = Tilisγelt tettalqqaḍ { about-telemetry-data-type } sakin tuzna d <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Yal aḥric seg iḥricen n telɣut ad ittwazen γer <a data-l10n-name="ping-link">ipingen</a>. Aql-ak tettwaliḍ aping { $name }, { $timestamp }.
about-telemetry-data-details-current = Yal aḥric seg iḥricen n telγut ad ittwazen γer “<a data-l10n-name="ping-link">ipingen</a>“. Aql-ak tettwaliḍ ɣer yisefka imiranen.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Af di { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Af deg akk tgezmiwin
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Igemmaḍ i “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Nesḥasef! Ulac igemmaḍ deg { $sectionName } i “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Nesḥasef! Ulac igemmaḍ ula d yiwet n tgezmit i “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Nesḥasef! Ulac akka tura isefka i “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = Isefka imiranen
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = akk
# button label to copy the histogram
about-telemetry-histogram-copy = Nɣel
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Tuttriwin SQL ẓẓayen deg ukala afessas agejdan (main thread)
about-telemetry-slow-sql-other = Tuttriwin SQL ẓẓayen deg ukala afessas imaragen (helper threads)
about-telemetry-slow-sql-hits = Amsiḍan
about-telemetry-slow-sql-average = Akud alemmas (ms)
about-telemetry-slow-sql-statement = Tuţra
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Asulay n uzegrir
about-telemetry-addon-table-details = Aglam leqqayen
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Amaẓrag { $addonProvider }
about-telemetry-keys-header = Taɣaṛa
about-telemetry-names-header = Isem
about-telemetry-values-header = Azal
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (amḍan n tuṭṭfiwin: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Tira n #{ $lateWriteCount } tgellel
about-telemetry-stack-title = Tanebdant:
about-telemetry-memory-map-title = Takarda n tkatut:
about-telemetry-error-fetching-symbols = Teḍra-d tuccḍa deg aggway n izamulen. Senqed ma yella teqqneḍ ɣer Internet u ɛṛeḍ tikelt nniḍen.
about-telemetry-time-stamp-header = Azemzakud
about-telemetry-category-header = Taggayt
about-telemetry-method-header = tarrayt
about-telemetry-object-header = Taɣawsa
about-telemetry-extra-header = asemmadan
about-telemetry-origin-section = Tilisɣelt taɣbalut
about-telemetry-origin-origin = aɣbalu
about-telemetry-origin-count = Amḍan
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> yestengal isefka send ad ttwaznen akken { $telemetryServerOwner } ad yizmir ad isiḍen tiɣawsiwin, maca ur ittizmir ara ad iẓer ma yella { -brand-product-name } ittekka neɣ ala deg usiden-a. (<a data-l10n-name="prio-blog-link">Issin ugar</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Akala { $process }
