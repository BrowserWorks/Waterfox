# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Įtraukimo klaida
opensearch-error-duplicate-desc = Programai „{ -brand-short-name }“ nepavyko įdiegti ieškyklės iš tinklavietės { $location-url }, nes jau yra įdiegta taip pavadinta ieškyklė.
opensearch-error-format-title = Netinkamas formatas
opensearch-error-format-desc = „{ -brand-short-name }“ nepavyko įdiegti ieškyklės iš: { $location-url }
opensearch-error-download-title = Atsiuntimo klaida
opensearch-error-download-desc = Programai „{ -brand-short-name }“ nepavyko atsiųsti ieškyklės iš tinklavietės { $location-url }

##

searchbar-submit =
    .tooltiptext = Išsiųsti paiešką
# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Ieškoti
searchbar-icon =
    .tooltiptext = Paieška

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Jūsų numatytoji ieškyklė buvo pakeista.</strong> „{ $oldEngine }“ daugiau nebesiūloma kaip numatytoji „{ -brand-short-name }“ ieškyklė. Jūsų numatytąja ieškykle tapo „{ $newEngine }“. Norėdami pakeisti numatytąją naršyklę, eikite į nustatymus. <label data-l10n-name="remove-search-engine-article">Sužinoti daugiau</label>
remove-search-engine-button = Gerai
