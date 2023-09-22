# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


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

permission-dialog-description = อนุญาตให้ไซต์นี้เปิดลิงก์ { $scheme } หรือไม่

permission-dialog-description-file = อนุญาตให้ไฟล์นี้เปิดลิงก์ { $scheme } หรือไม่

permission-dialog-description-host = อนุญาตให้ { $host } เปิดลิงก์ { $scheme } หรือไม่

permission-dialog-description-extension = อนุญาตให้ส่วนขยาย { $extension } เปิดลิงก์ { $scheme } หรือไม่

permission-dialog-description-app = อนุญาตให้ไซต์นี้เปิดลิงก์ { $scheme } ด้วย { $appName } หรือไม่

permission-dialog-description-host-app = อนุญาตให้ { $host } เปิดลิงก์ { $scheme } ด้วย { $appName } หรือไม่

permission-dialog-description-file-app = อนุญาตให้ไฟล์นี้เปิดลิงก์ { $scheme } ด้วย { $appName } หรือไม่

permission-dialog-description-extension-app = อนุญาตให้ส่วนขยาย { $extension } เปิดลิงก์ { $scheme } ด้วย { $appName } หรือไม่

## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.


## Please keep the emphasis around the hostname and scheme (ie the
## `<strong>` HTML tags). Please also keep the hostname as close to the start
## of the sentence as your language's grammar allows.
## Variables:
##  $host (string) - The hostname that is initiating the request
##  $scheme (string) - The type of link that's being opened.

permission-dialog-remember = อนุญาตให้ <strong>{ $host }</strong> เปิดลิงก์ <strong>{ $scheme }</strong> เสมอ

permission-dialog-remember-file = อนุญาตให้ไฟล์นี้เปิดลิงก์ <strong>{ $scheme }</strong> เสมอ

permission-dialog-remember-extension = อนุญาตให้ส่วนขยายนี้เปิดลิงก์ <strong>{ $scheme }</strong> เสมอ

##

permission-dialog-btn-open-link =
    .label = เปิดลิงก์
    .accessKey = O

permission-dialog-btn-choose-app =
    .label = เลือกแอปพลิเคชัน
    .accessKey = A

permission-dialog-unset-description = คุณจะต้องเลือกแอปพลิเคชัน

permission-dialog-set-change-app-link = เลือกแอปพลิเคชันอื่น

## Chooser dialog
## Variables:
##  $scheme - the type of link that's being opened.


## Chooser dialog
## Variables:
##  $scheme (string) - The type of link that's being opened.

chooser-window =
    .title = เลือกแอปพลิเคชัน
    .style = min-width: 26em; min-height: 26em;

chooser-dialog =
    .buttonlabelaccept = เปิดลิงก์
    .buttonaccesskeyaccept = O

chooser-dialog-description = เลือกแอปพลิเคชันเพื่อเปิดลิงก์ { $scheme }

# Please keep the emphasis around the scheme (ie the `<strong>` HTML tags).
chooser-dialog-remember = ใช้แอปพลิเคชันนี้เพื่อเปิดลิงก์ <strong>{ $scheme }</strong> เสมอ

chooser-dialog-remember-extra =
    { PLATFORM() ->
        [windows] คุณสามารถเปลี่ยนการตั้งค่านี้ได้ในตัวเลือกของ { -brand-short-name }
       *[other] คุณสามารถเปลี่ยนการตั้งค่านี้ได้ในค่ากำหนดของ { -brand-short-name }
    }

choose-other-app-description = เลือกแอปพลิเคชันอื่น
choose-app-btn =
    .label = เลือก…
    .accessKey = ล
choose-other-app-window-title = แอปพลิเคชันอื่น…

# Displayed under the name of a protocol handler in the Launch Application dialog.
choose-dialog-privatebrowsing-disabled = ถูกปิดใช้งานในหน้าต่างส่วนตัว
