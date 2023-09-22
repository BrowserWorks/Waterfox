# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name }가 새 마스크를 생성할 수 없습니다. HTTP 오류 코드: { $status }.
firefox-relay-get-reusable-masks-failed = { -relay-brand-name }가 재사용 가능한 마스크를 찾을 수 없습니다. HTTP 오류 코드: { $status }.

##

firefox-relay-must-login-to-fxa = { -relay-brand-name }를 사용하려면 { -fxaccount-brand-name }에 로그인해야 합니다.
firefox-relay-must-login-to-account = { -relay-brand-name } 이메일 마스크를 사용하려면 계정에 로그인하세요.
firefox-relay-get-unlimited-masks =
    .label = 마스크 관리
    .accesskey = M
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = 이메일 주소 보호:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = { -relay-brand-name } 이메일 마스크 사용
firefox-relay-use-mask-title = { -relay-brand-name } 이메일 마스크 사용
firefox-relay-opt-in-confirmation-enable-button =
    .label = 이메일 마스크 사용
    .accesskey = U
firefox-relay-opt-in-confirmation-disable =
    .label = 다시 표시 안 함
    .accesskey = D
firefox-relay-opt-in-confirmation-postpone =
    .label = 나중에
    .accesskey = N
