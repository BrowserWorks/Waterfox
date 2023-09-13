# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Installationsfel
opensearch-error-duplicate-desc = { -brand-short-name } kunde inte installera sökmodulen från “{ $location-url }” eftersom det redan finns en sökmotor med samma namn.

opensearch-error-format-title = Ogiltigt format
opensearch-error-format-desc = { -brand-short-name } kunde inte installera sökmotorn från: { $location-url }

opensearch-error-download-title = Hämtningsfel
opensearch-error-download-desc = { -brand-short-name } kunde inte hämta sökmodulen från: { $location-url }

##

searchbar-submit =
    .tooltiptext = Skicka sökning

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Sök

searchbar-icon =
    .tooltiptext = Sök

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Din standardsökmotor har ändrats.</strong> { $oldEngine } är inte längre tillgänglig som standardsökmotor i { -brand-short-name }. { $newEngine } är nu din standardsökmotor. För att byta till en annan standardsökmotor, gå till inställningar. <label data-l10n-name="remove-search-engine-article">Läs mer</label>
remove-search-engine-button = Ok
