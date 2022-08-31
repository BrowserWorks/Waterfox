# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Installations-Fehler
opensearch-error-duplicate-desc = { -brand-short-name } konnte die Suchmaschine von "{ $location-url }" nicht herunterladen, da bereits eine Suchmaschine mit demselben Namen existiert.

opensearch-error-format-title = Ungültiges Format
opensearch-error-format-desc = { -brand-short-name } konnte die Suchmaschine unter { $location-url } nicht installieren.

opensearch-error-download-title = Download-Fehler
opensearch-error-download-desc = { -brand-short-name } konnte die Suchmaschine nicht herunterladen von: { $location-url }

##

searchbar-submit =
    .tooltiptext = Suche absenden

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Suchen

searchbar-icon =
    .tooltiptext = Suchen

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Ihre Standardsuchmaschine wurde geändert.</strong> { $oldEngine } ist in { -brand-short-name } nicht mehr als Standardsuchmaschine verfügbar. { $newEngine } ist jetzt Ihre Standardsuchmaschine. Die Standardsuchmaschine kann in den Einstellungen geändert werden. <label data-l10n-name="remove-search-engine-article">Weitere Informationen</label>
remove-search-engine-button = OK
