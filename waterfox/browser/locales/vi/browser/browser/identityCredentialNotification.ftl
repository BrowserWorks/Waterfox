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

identity-credential-header-providers = Đăng nhập với nhà cung cấp đăng nhập
identity-credential-header-accounts = Đăng nhập với { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Mở bảng đăng nhập
identity-credential-cancel-button =
    .label = Hủy bỏ
    .accesskey = n
identity-credential-accept-button =
    .label = Tiếp tục
    .accesskey = C
identity-credential-sign-in-button =
    .label = Đăng nhập
    .accesskey = S
identity-credential-policy-title = Sử dụng { $provider } làm nhà cung cấp đăng nhập
identity-credential-policy-description = Đăng nhập vào { $host } bằng tài khoản { $provider } cần tuân theo <label data-l10n-name="privacy-url">chính sách riêng tư</label> và <label data-l10n-name="tos-url">điều khoản dịch vụ</label>.
