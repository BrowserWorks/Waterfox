# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name } không thể tạo mặt nạ mới. Mã lỗi HTTP: { $status }.
firefox-relay-get-reusable-masks-failed = { -relay-brand-name } không thể tìm thấy mặt nạ có thể sử dụng. Mã lỗi HTTP: { $status }.

##

firefox-relay-must-login-to-fxa = Bạn phải đăng nhập vào { -fxaccount-brand-name } để sử dụng { -relay-brand-name }.
firefox-relay-must-login-to-account = Đăng nhập vào tài khoản của bạn để sử dụng mặt nạ email { -relay-brand-name } của bạn.
firefox-relay-get-unlimited-masks =
    .label = Muản lý mặt nạ
    .accesskey = M
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = Bảo vệ địa chỉ email của bạn:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = Sử dụng mặt nạ email { -relay-brand-name }
firefox-relay-use-mask-title = Sử dụng mặt nạ email { -relay-brand-name }
firefox-relay-opt-in-confirmation-enable-button =
    .label = Sử dụng mặt nạ email
    .accesskey = U
firefox-relay-opt-in-confirmation-disable =
    .label = Đừng hỏi lại tôi điều này
    .accesskey = D
firefox-relay-opt-in-confirmation-postpone =
    .label = Không phải bây giờ
    .accesskey = N
