# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Please keep the emphasis around the hostname and scheme (ie the
# `<strong>` HTML tags). Please also keep the hostname as close to the start
# of the sentence as your language's grammar allows.
#
# Variables:
#  $host - the hostname that is initiating the request
#  $scheme - the type of link that's being opened.
handler-dialog-host = <strong>{ $host }</strong> muốn mở liên kết <strong>{ $scheme }</strong>.

## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.

permission-dialog-description = Cho phép trang web này mở liên kết { $scheme }?
permission-dialog-description-file = Cho phép tập tin này mở liên kết { $scheme }?
permission-dialog-description-host = Cho phép { $host } mở liên kết { $scheme }?
permission-dialog-description-app = Cho phép trang web này mở liên kết { $scheme } bằng { $appName }?
permission-dialog-description-host-app = Cho phép { $host } mở liên kết { $scheme } bằng { $appName }?
permission-dialog-description-file-app = Cho phép tập tin này mở liên kết { $scheme } bằng { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

permission-dialog-remember = Luôn cho phép <strong>{ $host }</strong> mở các liên kết <strong>{ $scheme }</strong>
permission-dialog-remember-file = Luôn cho phép tập tin này mở các liên kết <strong>{ $scheme }</strong>

##

permission-dialog-btn-open-link =
    .label = Mở liên kết
    .accessKey = O
permission-dialog-btn-choose-app =
    .label = Chọn ứng dụng
    .accessKey = A
permission-dialog-unset-description = Bạn sẽ cần phải chọn một ứng dụng.
permission-dialog-set-change-app-link = Chọn một ứng dụng khác.

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.

chooser-window =
    .title = Chọn ứng dụng
    .style = min-width: 26em; min-height: 26em;
chooser-dialog =
    .buttonlabelaccept = Mở liên kết
    .buttonaccesskeyaccept = O
chooser-dialog-description = Chọn một ứng dụng để mở liên kết { $scheme }.
# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = Luôn sử dụng ứng dụng này để mở các liên kết <strong>{ $scheme }</strong>
chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] Lựa chọn này có thể thay đổi trong Tùy chọn { -brand-short-name }.
       *[other] Lựa chọn này có thể thay đổi trong Tùy chỉnh { -brand-short-name }.
    }
choose-other-app-description = Chọn ứng dụng khác
choose-app-btn =
    .label = Chọn…
    .accessKey = C
choose-other-app-window-title = Ứng dụng khác…
# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = Vô hiệu hóa trong cửa sổ riêng tư
