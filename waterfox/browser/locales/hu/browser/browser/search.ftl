# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Telepítési hiba
opensearch-error-duplicate-desc = A { -brand-short-name } nem tudja telepíteni a keresőszolgáltatást „{ $location-url }” helyről, mert ilyen nevű keresőszolgáltatás már van.

opensearch-error-format-title = Érvénytelen formátum
opensearch-error-format-desc = { -brand-short-name } nem tudta telepíteni a keresőszolgáltatást innen: { $location-url }

opensearch-error-download-title = Letöltési hiba
opensearch-error-download-desc = A { -brand-short-name } nem tudta letölteni a keresőbővítményt innen: { $location-url }

##

searchbar-submit =
    .tooltiptext = Keresés indítása

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Keresés

searchbar-icon =
    .tooltiptext = Keresés

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Az alapértelmezett keresőszolgáltatás megváltozott.</strong> A(z) { $oldEngine } már nem érhető el alapértelmezett keresőszolgáltatásként a { -brand-short-name }ban. Most már a(z) { $newEngine } az alapértelmezett keresőszolgáltatás. Hogy másik keresőszolgáltatást válasszon, ugorjon a beállításokhoz. <label data-l10n-name="remove-search-engine-article">További tudnivalók</label>
remove-search-engine-button = OK
