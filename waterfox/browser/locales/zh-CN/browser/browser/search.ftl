# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = 安装错误
opensearch-error-duplicate-desc = { -brand-short-name } 无法安装来自 “{ $location-url }”的搜索插件，因为同名的引擎已经存在。

opensearch-error-format-title = 无效格式
opensearch-error-format-desc = { -brand-short-name } 未能从下列位置安装搜索引擎：{ $location-url }

opensearch-error-download-title = 下载错误
opensearch-error-download-desc = { -brand-short-name } 无法下载插件，目标地址为： { $location-url }

##

searchbar-submit =
    .tooltiptext = 提交搜索

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = 搜索

searchbar-icon =
    .tooltiptext = 搜索

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>您的默认搜索引擎有变动。</strong>{ $oldEngine } 不再作为 { -brand-short-name } 的默认搜索引擎，现已替换为 { $newEngine }。若要使用其他搜索引擎，请前往“设置”页面。<label data-l10n-name="remove-search-engine-article">详细了解</label>
remove-search-engine-button = 确定
