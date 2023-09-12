# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = Kesalahan Pemasangan
opensearch-error-duplicate-desc = { -brand-short-name } tidak dapat memasang plugin pencarian dari "{ $location-url }" karena mesin pencari dengan nama yang sama telah ada sebelumnya.

opensearch-error-format-title = Format Tidak Valid
opensearch-error-format-desc = { -brand-short-name } tidak dapat memasang mesin pencari dari: { $location-url }

opensearch-error-download-title = Kesalahan Unduhan
opensearch-error-download-desc = { -brand-short-name } tidak dapat mengunduh plugin pencarian dari: { $location-url }

##

searchbar-submit =
    .tooltiptext = Kirim penelusuran

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = Cari

searchbar-icon =
    .tooltiptext = Cari

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>Mesin pencari baku Anda telah diubah.</strong> { $oldEngine } tidak lagi tersedia sebagai mesin pencari baku di { -brand-short-name }. Kini, { $newEngine } menjadi mesin pencari baku Anda. Untuk mengubah ke mesin pencari baku lainnya, buka pengaturan. <label data-l10n-name="remove-search-engine-article">Pelajari lebih lanjut</label>
remove-search-engine-button = Oke
