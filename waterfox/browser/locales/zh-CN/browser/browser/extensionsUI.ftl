# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = 详细了解
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = “{ $addonName }”想将您的默认搜索引擎从“{ $currentEngine }”更改为“{ $newEngine }”。您同意吗？
webext-default-search-yes =
    .label = 是
    .accesskey = Y
webext-default-search-no =
    .label = 否
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = “{ $addonName }”已添加。

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = 要在受限网站上运行“{ $addonName }”吗？
webext-quarantine-confirmation-line-1 = 为了保护您的数据，此扩展未被允许在此网站上运行。
webext-quarantine-confirmation-line-2 = 如果您信任此扩展读取并更改您在受 { -vendor-short-name } 限制的网站上的数据，可以允许它在此网站上运行。
webext-quarantine-confirmation-allow =
    .label = 允许
    .accesskey = A
webext-quarantine-confirmation-deny =
    .label = 不允许
    .accesskey = D
