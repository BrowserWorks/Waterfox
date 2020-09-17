# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Пинг деректерінің көзі:
about-telemetry-show-current-data = Ағымдағы деректер
about-telemetry-show-archived-ping-data = Архивтелген пинг деректері
about-telemetry-show-subsession-data = Ішкі сессия деректерін көрсету
about-telemetry-choose-ping = Пингті таңдау:
about-telemetry-archive-ping-type = Пинг түрі
about-telemetry-archive-ping-header = Пинг
about-telemetry-option-group-today = Бүгін
about-telemetry-option-group-yesterday = Кеше
about-telemetry-option-group-older = Ескілеу
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Телеметрия мәліметтері
about-telemetry-current-store = Ағымдағы қойма:
about-telemetry-more-information = Көбірек ақпарат керек пе?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox деректер құжаттамасында</a> біздің деректер құралдарымен қалай жұмыс жасау керектігі туралы нұсқаулықтар бар.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox телеметрия клиентінің құжаттамасында</a> концепттер үшін анықтамалар, API құжаттамасы және деректерге сілтемелер бар.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Телеметрия панелінде</a> Mozilla телеметрия арқылы алған деректерді графикалық түрде қарауға болады.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Зондтар сөздігі</a> Телеметрия жинаған зондтар ақпаратын және сипаттамасын сақтайды.
about-telemetry-show-in-Firefox-json-viewer = JSON көрсетушісінде ашу
about-telemetry-home-section = Үй
about-telemetry-general-data-section =   Жалпы деректер
about-telemetry-environment-data-section = Қоршам деректері
about-telemetry-session-info-section = Сессия ақпараты
about-telemetry-scalar-section = Скалярлы шамалар
about-telemetry-keyed-scalar-section = Кілт бойынша скалярлы шамалар
about-telemetry-histograms-section = Гистограммалар
about-telemetry-keyed-histogram-section =   Пернелер гистограммалары
about-telemetry-events-section = Оқиғалар
about-telemetry-simple-measurements-section = Қарапайым өлшемдер
about-telemetry-slow-sql-section = Баяу SQL сұраныстары
about-telemetry-addon-details-section = Қосымша ақпараты
about-telemetry-captured-stacks-section = Түсірілген стектер
about-telemetry-late-writes-section = Кеш жазулар
about-telemetry-raw-payload-section = Шикі жүктеме
about-telemetry-raw = Шикі JSON
about-telemetry-full-sql-warning = Ескерту: Баяу SQL кодын жөндеу режимі іске қосулы тұр. Толық SQL жолдары төмен көрсетілуі мүмкін, бірақ олар телеметрияға жіберілмейді.
about-telemetry-fetch-stack-symbols = Стектер үшін функциялар аттарын алу
about-telemetry-hide-stack-symbols = Шикі стек деректерін көрсету
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] шығарылым деректерін
       *[prerelease] шығарылымға дейінгі деректерді
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] іске қосылған
       *[disabled] сөндірілген
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
       *[other] { $sampleCount } үлгі, орташасы = { $prettyAverage }, сомасы = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Бұл парақта телеметриямен жиналған өнімділік, құрылғылар, қолданылу мен баптаулар туралы ақпаратты көрсетеді. Бұл ақпарат { $telemetryServerOwner } адресіне, { -brand-full-name } жақсартуға көмектесу үшін жіберіледі.
about-telemetry-settings-explanation = Телеметрия { about-telemetry-data-type } жинайды, деректерді жүктеу <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Ақпараттың әр бөлігі "<a data-l10n-name="ping-link">пингтер</a>" ішіне салынып жіберіледі. Сіз { $name }, { $timestamp } пингіне қарап отырсыз.
about-telemetry-data-details-current = Ақпараттың әр бөлігі "<a data-l10n-name="ping-link">пингтер</a>" ішіне салынып жіберіледі. Сіз ағымдағы деректерге қарап отырсыз.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } ішінен табу
about-telemetry-filter-all-placeholder =
    .placeholder = Барлық санаттардан табу
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = "{ $searchTerms }" нәтижелері
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Кешіріңіз! { $sectionName } ішінде “{ $currentSearchText }” үшін нәтижелер табылмады
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Кешіріңіз! Бірде-бір санатта "{ $searchTerms }" үшін нәтижелер табылмады
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Кешіріңіз! Ағымдағы уақытта "{ $sectionName }" ішінде деректер жоқ
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = ағымдағы деректер
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = барлығы
# button label to copy the histogram
about-telemetry-histogram-copy = Көшіріп алу
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Басты үрдістегі баяу SQL сұраныстары
about-telemetry-slow-sql-other = Көмекші үрдістердегі баяу SQL сұраныстары
about-telemetry-slow-sql-hits = Сәйкестіктер
about-telemetry-slow-sql-average = Орташа уақыты (мс)
about-telemetry-slow-sql-statement = Сұраныс
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Қосымша ID-і
about-telemetry-addon-table-details = Ақпараты
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } ұсынушысы
about-telemetry-keys-header = Қасиеті
about-telemetry-names-header = Аты
about-telemetry-values-header = Мәні
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (ұстаулар саны: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Кеш жазу #{ $lateWriteCount }
about-telemetry-stack-title = Стек:
about-telemetry-memory-map-title = Жады бөліну схемасы:
about-telemetry-error-fetching-symbols = Таңбаларды алғанда қате кетті. Интернетке қосылғаныңызды тексеріп, тағы қайталап көріңіз.
about-telemetry-time-stamp-header = уақыт шамасы
about-telemetry-category-header = санат
about-telemetry-method-header = тәсіл
about-telemetry-object-header = объект
about-telemetry-extra-header = қосымша
about-telemetry-origin-section = Қайнар көздер телеметриясы
about-telemetry-origin-origin = қайнар көзі
about-telemetry-origin-count = саны
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox қайнар көзі телеметриясы</a> жіберуге дейін деректерді шифрлейді, осылайша { $telemetryServerOwner } нәрселерді санай алады, бірақ, берілген { -brand-product-name } оған үлесін қосқан ба, соны біле алмайды. (<a data-l10n-name="prio-blog-link">көбірек білу</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } процес
