# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Извор података пинга:
about-telemetry-show-current-data = Тренутни подаци
about-telemetry-show-archived-ping-data = Архивирани подаци пинга
about-telemetry-show-subsession-data = Прикажи податке сесије
about-telemetry-choose-ping = Изабери пинг:
about-telemetry-archive-ping-type = Врста пинга
about-telemetry-archive-ping-header = Пинг
about-telemetry-option-group-today = Данас
about-telemetry-option-group-yesterday = Јуче
about-telemetry-option-group-older = Старије
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Подаци телеметрије
about-telemetry-current-store = Тренутна продавница:
about-telemetry-more-information = Тражите више података?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox документација података</a> садржи водиче о томе како радити са нашим алатима за податке.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox документација телеметрије клијента</a> укључује дефиниције концепта, API документацију и референце података.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Командна табла телеметрије</a> вам дозвољава да визуелно прикажете податке које Mozilla прима путем телеметрије.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Речник узорака пружа детаље и описе за узорке прикупљене телеметријом.</a>
about-telemetry-show-in-Firefox-json-viewer = Отвори у JSON приказивачу
about-telemetry-home-section = Почетна
about-telemetry-general-data-section = Општи подаци
about-telemetry-environment-data-section = Подаци о окружењу
about-telemetry-session-info-section = Информације о сесији
about-telemetry-scalar-section = Скалари
about-telemetry-keyed-scalar-section = Кључни скалари
about-telemetry-histograms-section = Хистограми
about-telemetry-keyed-histogram-section = Кључни хистограми
about-telemetry-events-section = Догађаји
about-telemetry-simple-measurements-section = Једноставна мерења
about-telemetry-slow-sql-section = Прикажи SQL упите
about-telemetry-addon-details-section = Детаљи о додатку
about-telemetry-captured-stacks-section = Ухваћени стекови
about-telemetry-late-writes-section = Касна писања
about-telemetry-raw-payload-section = Raw Payload
about-telemetry-raw = Необрађен JSON
about-telemetry-full-sql-warning = Напона: Споро SQL решавање је укључено. SQL стрингови ће можда бити приказани испод али не могу бити послати телеметрији.
about-telemetry-fetch-stack-symbols = Имена Fetch функција за стекове
about-telemetry-hide-stack-symbols = Прикажи стек податке
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] подаци пуштања
       *[prerelease] подаци пре пуштања
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] омогућено
       *[disabled] онемогућено
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } узорак, просек = { $prettyAverage }, збир = { $sum }
        [few] { $sampleCount } узорка, просек = { $prettyAverage }, збир = { $sum }
       *[other] { $sampleCount } узорака, просек = { $prettyAverage }, збир = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Ова страница ће приказати информације о перфомансама, хардверу, потрошњи и прилагођењу које је прикупила телеметрија. Ове информације ће бити послате { $telemetryServerOwner }-и да би се побољшао { -brand-full-name }.
about-telemetry-settings-explanation = Телеметрија сакупља { about-telemetry-data-type } и отпремање је <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Сваки део информације је послат у комплету у “<a data-l10n-name="ping-link">пингове</a>”. Ви гледате у { $name }, { $timestamp } пинг.
about-telemetry-data-details-current = Сваки делић података се шаље у пакетима под називом"<a data-l10n-name="ping-link">пинг</a>“. Ви гледате тренутне податке.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Нађите у { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Пронађи све одељке
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Резултати за “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Жао нам је! Нема резултата у { $sectionName } за “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Жао нам је! Нема резултата претраге ни у једном одељку “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Жао нам је! Тренутно нема доступних података у “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = тренутни подаци
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = све
# button label to copy the histogram
about-telemetry-histogram-copy = Копирај
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Прикажи SQL исказе на главној нити
about-telemetry-slow-sql-other = Прикажи SQL исказе на помоћним нитима
about-telemetry-slow-sql-hits = Погоци
about-telemetry-slow-sql-average = Просечно време (ms)
about-telemetry-slow-sql-statement = Упити
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ID додатка
about-telemetry-addon-table-details = Детаљи
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } провајдер
about-telemetry-keys-header = Својство
about-telemetry-names-header = Име
about-telemetry-values-header = Вредност
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (број хватања: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Касно писање #{ $lateWriteCount }
about-telemetry-stack-title = Стек:
about-telemetry-memory-map-title = Меморијска мапа:
about-telemetry-error-fetching-symbols = Грешка се десила приликом приказивања симбола. Проверите да ли сте повезани на интернет и покушајте поново.
about-telemetry-time-stamp-header = временска ознака
about-telemetry-category-header = категорија
about-telemetry-method-header = метода
about-telemetry-object-header = објекат
about-telemetry-extra-header = додатно
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = извор
about-telemetry-origin-count = број
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Firefox Origin Telemetry</a> кодира податке пре слања тако да { $telemetryServerOwner } може пребројати ствари, али не може знати да ли неки { -brand-product-name } доприноси том броју. (<a data-l10n-name="prio-blog-link">сазнајте више</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } процес
