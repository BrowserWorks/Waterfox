# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Chyba instalace
opensearch-error-duplicate-desc =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } nemohl
        [feminine] { -brand-short-name } nemohla
        [neuter] { -brand-short-name } nemohlo
       *[other] Aplikace { -brand-short-name } nemohla
    } nainstalovat vyhledávač z „{ $location-url }“, protože už existuje jiný se stejným názvem.

opensearch-error-format-title = Neplatný formát
opensearch-error-format-desc =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } nemohl
        [feminine] { -brand-short-name } nemohla
        [neuter] { -brand-short-name } nemohlo
       *[other] Aplikace { -brand-short-name } nemohla
    } nainstalovat vyhledávač z „{ $location-url }“

opensearch-error-download-title = Chyba stahování
opensearch-error-download-desc =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } nemohl
        [feminine] { -brand-short-name } nemohla
        [neuter] { -brand-short-name } nemohlo
       *[other] Aplikace { -brand-short-name } nemohla
    } stáhnout vyhledávač z „{ $location-url }“

##

searchbar-submit =
    .tooltiptext = Potvrdí hledání

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Vyhledat

searchbar-icon =
    .tooltiptext = Vyhledat

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message =
    { -brand-short-name.gender ->
        [masculine] <strong>Váš výchozí vyhledávač byl změněn.</strong> Vyhledávač { $oldEngine } už není ve { -brand-short-name(case: "loc") } dostupný jako výchozí vyhledávač. Váš nový výchozí vyhledávač je teď { $newEngine }. Výchozí vyhledávač můžete změnit v nastavení. <label data-l10n-name="remove-search-engine-article">Zjistit více</label>
        [feminine] <strong>Váš výchozí vyhledávač byl změněn.</strong> Vyhledávač { $oldEngine } už není v { -brand-short-name(case: "loc") } dostupný jako výchozí vyhledávač. Váš nový výchozí vyhledávač je teď { $newEngine }. Výchozí vyhledávač můžete změnit v nastavení. <label data-l10n-name="remove-search-engine-article">Zjistit více</label>
        [neuter] <strong>Váš výchozí vyhledávač byl změněn.</strong> Vyhledávač { $oldEngine } už není v { -brand-short-name(case: "loc") } dostupný jako výchozí vyhledávač. Váš nový výchozí vyhledávač je teď { $newEngine }. Výchozí vyhledávač můžete změnit v nastavení. <label data-l10n-name="remove-search-engine-article">Zjistit více</label>
       *[other] <strong>Váš výchozí vyhledávač byl změněn.</strong> Vyhledávač { $oldEngine } už není v aplikaci { -brand-short-name } dostupný jako výchozí vyhledávač. Váš nový výchozí vyhledávač je teď { $newEngine }. Výchozí vyhledávač můžete změnit v nastavení. <label data-l10n-name="remove-search-engine-article">Zjistit více</label>
    }
remove-search-engine-button = OK
