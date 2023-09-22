# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>此頁面中的部分內容發生錯誤。</strong>您同意的話，可將此問題回報給 { -brand-product-name }，讓我們更快修正。

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = 此頁面中的部分內容發生錯誤。您同意的話，可將此問題回報給 { -brand-product-name }，讓我們更快修正。
crashed-subframe-learnmore-link =
    .value = 了解更多
crashed-subframe-submit =
    .label = 送出報告
    .accesskey = S

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message = 您有 { $reportCount } 筆未送出的錯誤回報
pending-crash-reports-view-all =
    .label = 檢視
pending-crash-reports-send =
    .label = 傳送
pending-crash-reports-always-send =
    .label = 總是傳送
