# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Крыніца дадзеных пінга:
about-telemetry-show-current-data = Бягучыя дадзеныя
about-telemetry-show-archived-ping-data = Дадзеныя архіўнага пінга
about-telemetry-show-subsession-data = Адлюстроўваць дадзеныя падсесіі
about-telemetry-choose-ping = Выберыце пінг:
about-telemetry-archive-ping-type = Тып пінгу
about-telemetry-archive-ping-header = Пінг
about-telemetry-option-group-today = Сёння
about-telemetry-option-group-yesterday = Учора
about-telemetry-option-group-older = Раней
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Дадзеныя тэлеметрыі
about-telemetry-current-store = Цяперашняе сховішча:
about-telemetry-more-information = Шукаеце больш інфармацыі?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Дакументацыя дадзеных Firefox</a> змяшчае кіраўніцтва па працы з нашымі інструментамі збору дадзеных.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Дакументацыя кліента тэлеметрыі Firefox</a> змяшчае вызначэнні канцэпцый, дакументацыю па API і даведку па дадзеных.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Панэлі Тэлеметрыі</a> дазваляюць вам візуалізаваць дадзеныя, атрыманыя Mozilla праз тэлеметрыю.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> утрымлівае падрабязнасці і апісанні зондаў, сабраныя тэлеметрыяй.
about-telemetry-show-in-Firefox-json-viewer = Адкрыць у праглядальніку JSON
about-telemetry-home-section = Хатняя старонка
about-telemetry-general-data-section = Агульныя дадзеныя
about-telemetry-environment-data-section = Дадзеныя асяроддзя
about-telemetry-session-info-section = Інфармацыя сесіі
about-telemetry-scalar-section = Скаляры
about-telemetry-keyed-scalar-section = Ключавыя скаляры
about-telemetry-histograms-section = Гістаграмы
about-telemetry-keyed-histogram-section = Ключавыя гістаграмы
about-telemetry-events-section = Падзеі
about-telemetry-simple-measurements-section = Простыя вымярэнні
about-telemetry-slow-sql-section = Паказ чыннікаў SQL
about-telemetry-addon-details-section = Падрабязнасці дадатка
about-telemetry-captured-stacks-section = Захопленыя стэкі
about-telemetry-late-writes-section = Апошнія запісы
about-telemetry-raw-payload-section = Неапрацаваная нагрузка
about-telemetry-raw = Неапрацаваны JSON
about-telemetry-full-sql-warning = УВАГА: дазволена марудная наладка SQL. Поўныя радкі SQL могуць адлюстроўвацца ніжэй, але яны не будуць падавацца тэлеметрыі.
about-telemetry-fetch-stack-symbols = Атрымаць імёны функцый для стэкаў
about-telemetry-hide-stack-symbols = Паказаць сырыя дадзеныя стэка
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] дадзеныя аб выпуску
       *[prerelease] дадзеныя аб папярэднім выпуску
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] уключана
       *[disabled] адключана
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } замер, сярэдняе = { $prettyAverage }, сума = { $sum }
        [few] { $sampleCount } замеры, сярэдняе = { $prettyAverage }, сума = { $sum }
       *[many] { $sampleCount } замераў, сярэдняе = { $prettyAverage }, сума = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Гэтая старонка паказвае звесткі пра працавыніковасць, начынне, выкарыстанне і ўладкаванні, назбіраныя тэлеметрыяй. Гэтыя звесткі дасылаюцца { $telemetryServerOwner } дзеля ўдасканалення { -brand-full-name }.
about-telemetry-settings-explanation = Тэлеметрыя збірае { about-telemetry-data-type } і зацягванне <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Кожная частка інфармацыі адпраўляецца ў камплекце “<a data-l10n-name="ping-link">пінгі</a>”. Вы праглядаеце пінг { $name }, { $timestamp }.
about-telemetry-data-details-current = Кожны фрагмент інфармацыі дасылаецца ў камплекце з "<a data-l10n-name="ping-link">пінгамі</a>". Вы глядзіце на бягучыя дадзеныя.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Знайсці ў { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Знайсці ва ўсіх раздзелах
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Вынікі для “{ $searchTerms }”
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Выбачайце! У { $sectionName } няма вынікаў для “{ $currentSearchText }”
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Выбачайце! Ні ў адным раздзеле няма вынікаў для “{ $searchTerms }”
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Выбачайце! Зараз няма ніякіх звестак у “{ $sectionName }”
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = бягучыя дадзеныя
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = усе
# button label to copy the histogram
about-telemetry-histogram-copy = Капіяваць
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Паказ чыннікаў SQL у галоўнай нізцы
about-telemetry-slow-sql-other = Паказ чыннікаў SQL у дапаможных нізках
about-telemetry-slow-sql-hits = Штуршкі
about-telemetry-slow-sql-average = Сяр. час (мс)
about-telemetry-slow-sql-statement = Чыннік
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Вызначальнік ададатка
about-telemetry-addon-table-details = Падрабязнасці
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = Дастаўшчык { $addonProvider }
about-telemetry-keys-header = Уласцівасць
about-telemetry-names-header = Імя
about-telemetry-values-header = Значэнне
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (колькасць захопленых: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Апошні запіс #{ $lateWriteCount }
about-telemetry-stack-title = Стос:
about-telemetry-memory-map-title = Мапа памяці:
about-telemetry-error-fetching-symbols = Памылка даставання сімвалаў. Праверце, што вы злучаны з Інтэрнэтам і паспрабуйце зноў.
about-telemetry-time-stamp-header = часовая пазнака
about-telemetry-category-header = катэгорыя
about-telemetry-method-header = метад
about-telemetry-object-header = аб'ект
about-telemetry-extra-header = дадаткова
about-telemetry-origin-section = Тэлеметрыя крыніц
about-telemetry-origin-origin = крыніца
about-telemetry-origin-count = колькасць
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Тэлеметрыя крыніц Firefox</a> кадуе звесткі перад перадачай, таму { $telemetryServerOwner } можа палічыць рэчы, не ведаючы, ці зрабіў пэўны { -brand-product-name } унёсак у гэту лічбу. (<a data-l10n-name="prio-blog-link">даведацца больш</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = Працэс { $process }
