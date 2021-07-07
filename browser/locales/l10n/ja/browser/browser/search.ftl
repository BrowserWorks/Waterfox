# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = インストールエラー
opensearch-error-duplicate-desc = 同じ名前の検索エンジンがすでに存在するため、{ -brand-short-name } は “{ $location-url }” から検索エンジンをインストールできませんでした。
opensearch-error-format-title = 不正なフォーマット
opensearch-error-format-desc = 検索エンジンを次の場所からインストールできませんでした: { $location-url }
opensearch-error-download-title = ダウンロード失敗
opensearch-error-download-desc = { -brand-short-name } は次の場所から検索エンジンをダウンロードできませんでした: { $location-url }

##

searchbar-submit =
    .tooltiptext = 検索を実行します
# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = 検索
searchbar-icon =
    .tooltiptext = 検索します
