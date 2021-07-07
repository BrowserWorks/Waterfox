# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Import Logins Autocomplete

# Variables:
#   $browser (String) - Browser name to import logins from.
#   $host (String) - Host name of the current site.
autocomplete-import-logins =
    <div data-l10n-name="line1">从 { $browser } 导入您的登录信息</div>
    <div data-l10n-name="line2">用于 { $host } 和其他网站</div>
autocomplete-import-logins-info =
    .tooltiptext = 详细了解

## Variables:
##   $host (String) - Host name of the current site.

autocomplete-import-logins-chrome = <div data-l10n-name="line1">从 Google Chrome 导入您<div data-l10n-name="line2">在 { $host } 和其他网站的登录信息</div>
autocomplete-import-logins-chromium = <div data-l10n-name="line1">从 Chromium 导入您<div data-l10n-name="line2">在 { $host } 和其他网站的登录信息</div>
autocomplete-import-logins-chromium-edge = <div data-l10n-name="line1">从 Microsoft Edge 导入您<div data-l10n-name="line2">在 { $host } 和其他网站的登录信息</div>

##

autocomplete-import-learn-more = 详细了解
