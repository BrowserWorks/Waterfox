# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name } が新しいマスクを生成できませんでした。HTTP エラーコード: { $status }
firefox-relay-get-reusable-masks-failed = { -relay-brand-name } が再利用可能なマスクを見つけられませんでした。HTTP エラーコード: { $status }

##

firefox-relay-must-login-to-fxa = { -relay-brand-name } を利用するには { -fxaccount-brand-name } にログインする必要があります。
firefox-relay-get-unlimited-masks =
    .label = マスクを管理
    .accesskey = M
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = メールアドレスを保護しましょう:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = { -relay-brand-name } メールマスクを使用する
firefox-relay-use-mask-title = { -relay-brand-name } メールマスクを使用する
firefox-relay-opt-in-confirmation-enable-button =
    .label = メールマスクを使用
    .accesskey = U
firefox-relay-opt-in-confirmation-disable =
    .label = 今後は表示しない
    .accesskey = D
firefox-relay-opt-in-confirmation-postpone =
    .label = 後で
    .accesskey = N
