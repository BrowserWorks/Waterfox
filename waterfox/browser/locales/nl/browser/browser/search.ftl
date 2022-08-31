# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Installatiefout
opensearch-error-duplicate-desc = { -brand-short-name } kon de zoekplug-in niet installeren vanaf ‘{ $location-url }’, omdat er al een zoekmachine bestaat met dezelfde naam.

opensearch-error-format-title = Ongeldige indeling
opensearch-error-format-desc = { -brand-short-name } kon de zoekmachine niet installeren vanaf { $location-url }

opensearch-error-download-title = Downloadfout
opensearch-error-download-desc = { -brand-short-name } kon de zoekplug-in niet downloaden vanaf: { $location-url }

##

searchbar-submit =
    .tooltiptext = Zoekopdracht verzenden

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Zoeken

searchbar-icon =
    .tooltiptext = Zoeken

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Uw standaardzoekmachine is gewijzigd.</strong> { $oldEngine } is niet meer als standaardzoekmachine beschikbaar in { -brand-short-name }. { $newEngine } is nu uw standaardzoekmachine. Ga naar uw instellingen om over te schakelen naar een andere standaardzoekmachine. <label data-l10n-name="remove-search-engine-article">Meer info</label>
remove-search-engine-button = OK
