# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = Източник на данните в пакета:
about-telemetry-show-archived-ping-data = Архивни данни
about-telemetry-show-subsession-data = Показване на подробни данни
about-telemetry-choose-ping = Избиране на пакет:
about-telemetry-archive-ping-type = Вид на пакета
about-telemetry-archive-ping-header = Пакет
about-telemetry-option-group-today = Днес
about-telemetry-option-group-yesterday = Вчера
about-telemetry-option-group-older = По-стари
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Данни за Телеметрията
about-telemetry-more-information = Търсите повече информация?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Документацията за данни от Firefox</a> съдържа напътствия как да боравите с нашите инструменти за данни.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Документацията за клиент на Телеметрията на FIrefox</a> съдържа дефинициите за концепции, документация за ППИ и наръчници за данни.
about-telemetry-telemetry-dashboard = На <a data-l10n-name="dashboard-link">Таблата на Телеметрията</a> се изобразяват данните, които Mozilla получава от Телеметрията.
about-telemetry-show-in-Firefox-json-viewer = Отваряне за преглед на JSON
about-telemetry-home-section = Начало
about-telemetry-general-data-section = Основни данни
about-telemetry-environment-data-section = Данни за обкръжението
about-telemetry-session-info-section = Системна информация
about-telemetry-scalar-section = Скалари
about-telemetry-keyed-scalar-section = Keyed скалари
about-telemetry-histograms-section = Хистограми
about-telemetry-keyed-histogram-section = Небалансирани хистограми
about-telemetry-events-section = Събития
about-telemetry-simple-measurements-section = Прости измервания
about-telemetry-slow-sql-section = Бавни SQL-заявки
about-telemetry-addon-details-section = Подробности за добавки
about-telemetry-captured-stacks-section = Прихванати стекове
about-telemetry-late-writes-section = Късни записи
about-telemetry-raw-payload-section = Полезен товар в суров вид
about-telemetry-raw = Необработен JSON
about-telemetry-full-sql-warning = ВАЖНО: Записването на бавните SQL заявки е разрешено. Пълните заявки може и да бъдат показани, но те НЕ СЕ изпращат по телеметрията.
about-telemetry-fetch-stack-symbols = Вземане имената на функциите от стековете
about-telemetry-hide-stack-symbols = Сурови данни на стека
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] данни за стабилно издание
       *[prerelease] данни за изпитателно издание
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] включено
       *[disabled] изключено
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = Тази страница показва информация за производителността, хардуера, използването и настройките, събрани от Телеметрия. Информацията се изпраща до { $telemetryServerOwner } с цел подобряване на { -brand-full-name }.
about-telemetry-settings-explanation = Телеметрията събира { about-telemetry-data-type } като изпращането им е <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = Всяко парче информация бива изпращано под формата на „<a data-l10n-name="ping-link">пакети</a>“. В момента разглеждате пакет { $name }, { $timestamp }.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = Търсене в { $selectedTitle }
about-telemetry-filter-all-placeholder =
    .placeholder = Търсене във всички секции
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = Резултати за „{ $searchTerms }“
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = Съжаляваме! В { $sectionName } няма резултати за „{ $currentSearchText }“
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = Съжаляваме! В нито една секция няма резултати за „{ $searchTerms }“
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = Съжаляваме! В секция „{ $sectionName }“ няма данни
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = всички
# button label to copy the histogram
about-telemetry-histogram-copy = Копиране
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = Бавни заявки на SQL в основната нишка
about-telemetry-slow-sql-other = Бавни заявки на SQL в помощните нишки
about-telemetry-slow-sql-hits = Попадения
about-telemetry-slow-sql-average = Средно време (ms)
about-telemetry-slow-sql-statement = Заявка
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = Идентификатор на добавка
about-telemetry-addon-table-details = Подробности
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } доставчик
about-telemetry-keys-header = Свойство
about-telemetry-names-header = Наименование
about-telemetry-values-header = Стойност
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (брой прихващания: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = Късен запис № { $lateWriteCount }
about-telemetry-stack-title = Стек:
about-telemetry-memory-map-title = Карта на паметта:
about-telemetry-error-fetching-symbols = Грешка при извличане на символите. Проверете дали сте свързани към Интернет и опитайте отново.
about-telemetry-time-stamp-header = времеви маркер
about-telemetry-category-header = категория
about-telemetry-method-header = метод
about-telemetry-object-header = обект
about-telemetry-extra-header = допълнително
