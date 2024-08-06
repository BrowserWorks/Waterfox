# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Błąd instalacji
opensearch-error-duplicate-desc = { -brand-short-name } nie mógł zainstalować wtyczki dla wyszukiwarki z „{ $location-url }”, ponieważ wtyczka o tej nazwie już istnieje.

opensearch-error-format-title = Nieprawidłowy format
opensearch-error-format-desc = { -brand-short-name } nie mógł zainstalować wyszukiwarki z adresu { $location-url }

opensearch-error-download-title = Błąd pobierania
opensearch-error-download-desc = { -brand-short-name } nie mógł pobrać wtyczki dla wyszukiwarki z adresu { $location-url }

##

searchbar-submit =
    .tooltiptext = Szukaj

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Szukaj

searchbar-icon =
    .tooltiptext = Szukaj

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Domyślna wyszukiwarka została zmieniona.</strong> Wyszukiwarka { $oldEngine } nie jest już dostępna jako domyślna wyszukiwarka w przeglądarce { -brand-short-name }. { $newEngine } jest teraz domyślną wyszukiwarką. W ustawieniach można zmienić ją na inną. <label data-l10n-name="remove-search-engine-article">Więcej informacji</label>
remove-search-engine-button = OK
