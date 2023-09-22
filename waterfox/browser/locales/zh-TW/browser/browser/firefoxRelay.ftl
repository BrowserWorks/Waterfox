# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name } 無法產生新的轉寄信箱。HTTP 錯誤代碼：{ $status }。
firefox-relay-get-reusable-masks-failed = { -relay-brand-name } 無法找到可重複使用的轉寄信箱。HTTP 錯誤代碼：{ $status }。

##

firefox-relay-must-login-to-fxa = 必須登入 { -fxaccount-brand-name } 才可以使用 { -relay-brand-name }。
firefox-relay-must-login-to-account = 登入帳號即可使用您的 { -relay-brand-name } 轉寄信箱。
firefox-relay-get-unlimited-masks =
    .label = 管理轉寄信箱
    .accesskey = M
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = 保護您的電子郵件信箱：
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = 使用 { -relay-brand-name } 轉寄信箱
firefox-relay-use-mask-title = 使用 { -relay-brand-name } 轉寄信箱
firefox-relay-opt-in-confirmation-enable-button =
    .label = 使用轉寄信箱
    .accesskey = U
firefox-relay-opt-in-confirmation-disable =
    .label = 不要再顯示此訊息
    .accesskey = D
firefox-relay-opt-in-confirmation-postpone =
    .label = 現在不要
    .accesskey = N
