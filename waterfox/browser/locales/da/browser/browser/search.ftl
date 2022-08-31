# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Installation mislykkedes
opensearch-error-duplicate-desc = { -brand-short-name } kunne ikke installere søgetjenesten fra "{ $location-url }" da en søgetjeneste med samme navn allerede er installeret.

opensearch-error-format-title = Ugyldigt format
opensearch-error-format-desc = { -brand-short-name } kunne ikke installere søgetjenesten fra: { $location-url }

opensearch-error-download-title = Hentningsfejl
opensearch-error-download-desc = { -brand-short-name } kunne ikke hente søgetjenesten fra: { $location-url }

##

searchbar-submit =
    .tooltiptext = Søg

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Søg

searchbar-icon =
    .tooltiptext = Søg

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Din standard-søgetjeneste er blevet ændret.</strong> { -brand-short-name } understøtter ikke længere { $oldEngine }. { $newEngine } er nu din standard-søgetjeneste. Gå til Indstillinger for at skifte til en anden standard-søgetjeneste. <label data-l10n-name="remove-search-engine-article">Læs mere</label>
remove-search-engine-button = OK
