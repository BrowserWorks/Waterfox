# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Credential panel
##
## Identity providers are websites you use to log in to another website, for
## example: Google when you Log in with Google.
##
## Variables:
##  $host (String): the hostname of the site that is being displayed.
##  $provider (String): the hostname of another website you are using to log in to the site being displayed

identity-credential-header-providers = 使用登入服務帳號登入
identity-credential-header-accounts = 使用 { $provider } 帳號登入
identity-credential-urlbar-anchor =
    .tooltiptext = 開啟登入面板
identity-credential-cancel-button =
    .label = 取消
    .accesskey = n
identity-credential-accept-button =
    .label = 繼續
    .accesskey = C
identity-credential-sign-in-button =
    .label = 登入
    .accesskey = S
identity-credential-policy-title = 使用 { $provider } 作為登入服務
identity-credential-policy-description = 使用 { $provider } 帳號登入 { $host }，需同意該服務的<label data-l10n-name="privacy-url">隱私權保護政策</label>與<label data-l10n-name="tos-url">服務條款</label>。
