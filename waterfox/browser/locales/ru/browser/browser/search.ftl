# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Ошибка установки
opensearch-error-duplicate-desc = { -brand-short-name } не смог установить поисковый плагин с «{ $location-url }», так как поисковая система с таким именем уже существует.

opensearch-error-format-title = Некорректный формат
opensearch-error-format-desc = { -brand-short-name } не смог установить поисковую систему из: { $location-url }

opensearch-error-download-title = Ошибка загрузки
opensearch-error-download-desc = { -brand-short-name } не смог загрузить поисковый плагин с: { $location-url }

##

searchbar-submit =
    .tooltiptext = Произвести поиск

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Поиск

searchbar-icon =
    .tooltiptext = Поиск

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Ваша поисковая система по умолчанию была изменена.</strong> { $oldEngine } более не используется как поисковая система по умолчанию в { -brand-short-name }. Теперь ваша поисковая система по умолчанию — { $newEngine }. Чтобы изменить её, перейдите в настройки. <label data-l10n-name="remove-search-engine-article">Подробнее</label>
remove-search-engine-button = OK
