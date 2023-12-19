# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.


## Permission Dialog
## Variables:
##  $host - the hostname that is initiating the request
##  $scheme - the type of link that's being opened.
##  $appName - Name of the application that will be opened.
##  $extension - Name of extension that initiated the request

## Permission Dialog
## Variables:
##  $host (string) - The hostname that is initiating the request
##  $scheme (string) - The type of link that's being opened.
##  $appName (string) - Name of the application that will be opened.
##  $extension (string) - Name of extension that initiated the request

permission-dialog-description = Cho phép trang web này mở liên kết { $scheme }?

permission-dialog-description-file = Cho phép tập tin này mở liên kết { $scheme }?

permission-dialog-description-host = Cho phép { $host } mở liên kết { $scheme }?

permission-dialog-description-extension = Cho phép tiện ích mở rộng { $extension } mở liên kết { $scheme }?

permission-dialog-description-app = Cho phép trang web này mở liên kết { $scheme } bằng { $appName }?

permission-dialog-description-host-app = Cho phép { $host } mở liên kết { $scheme } bằng { $appName }?

permission-dialog-description-file-app = Cho phép tập tin này mở liên kết { $scheme } bằng { $appName }?

permission-dialog-description-extension-app = Cho phép tiện ích mở rộng { $extension } mở liên kết { $scheme } với { $appName }?

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.
## Variables:
##  $host (string) - The hostname that is initiating the request
##  $scheme (string) - The type of link that's being opened.

permission-dialog-remember = Luôn cho phép <strong>{ $host }</strong> mở các liên kết <strong>{ $scheme }</strong>

permission-dialog-remember-file = Luôn cho phép tập tin này mở các liên kết <strong>{ $scheme }</strong>

permission-dialog-remember-extension = Luôn cho phép tiện ích mở rộng này mở các liên kết <strong>{ $scheme }</strong>

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

## Chooser dialog
## Variables:
##  $scheme (string) - The type of link that's being opened.

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
