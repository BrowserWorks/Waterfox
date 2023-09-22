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

identity-credential-header-providers = ลงชื่อเข้าด้วยผู้ให้บริการเข้าสู่ระบบ
identity-credential-header-accounts = ลงชื่อเข้าด้วย { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = เปิดแผงเข้าสู่ระบบ
identity-credential-cancel-button =
    .label = ยกเลิก
    .accesskey = ย
identity-credential-accept-button =
    .label = ดำเนินการต่อ
    .accesskey = ด
identity-credential-sign-in-button =
    .label = ลงชื่อเข้า
    .accesskey = ล
identity-credential-policy-title = ใช้ { $provider } เป็นผู้ให้บริการเข้าสู่ระบบ
identity-credential-policy-description = การเข้าสู่ระบบ { $host } ด้วยบัญชี { $provider } จะอยู่ภายใต้<label data-l10n-name="privacy-url">นโยบายส่วนบุคคล</label>และ<label data-l10n-name="tos-url">ข้อกำหนดในการให้บริการ</label>
