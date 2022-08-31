# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Errore di installazione
opensearch-error-duplicate-desc = Non è stato possibile installare il plugin di ricerca da “{ $location-url }” poiché ne esiste già uno con lo stesso nome.

opensearch-error-format-title = Formato non valido
opensearch-error-format-desc = Non è stato possibile installare il motore di ricerca da: { $location-url }

opensearch-error-download-title = Errore download
opensearch-error-download-desc = Non è stato possibile scaricare il plugin di ricerca da: { $location-url }

##

searchbar-submit =
    .tooltiptext = Avvia ricerca

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Cerca

searchbar-icon =
    .tooltiptext = Cerca

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Il motore di ricerca predefinito è stato cambiato.</strong> { $oldEngine } non è più disponibile tra i motori di ricerca predefiniti di { -brand-short-name } e { $newEngine } è ora impostato come motore di ricerca predefinito. È possibile modificare il motore di ricerca predefinito nelle impostazioni. <label data-l10n-name="remove-search-engine-article">Ulteriori informazioni</label>
remove-search-engine-button = OK
